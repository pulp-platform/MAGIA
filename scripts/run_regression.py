#!/usr/bin/env python3
# Copyright (C) 2026 ETH Zurich, University of Bologna and Fondazione Chips-IT
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-License-Identifier: Apache-2.0
#
# Author: Luca Balboni <luca.balboni@chips.it>
#
# Run the MAGIA tests of sw/tests/tests.yml over several build configurations, one after the other.
#
# Usage: scripts/run_regression.py --sim SIM --core CORE --fsync on|off --test TEST [options]
#   --sim/--core/--fsync take a value, a comma list or `all`; --test takes `all`, `mesh`, `tile`,
#   a folder of sw/tests/ (`general` is sw/tests/ itself) or folder/test. See --help for the rest.
#
# Each configuration builds in its own worktree under .regression/, and its HW is rebuilt only when
# its sources change (--rebuild forces it). Tests run only where their sims/cores/requires allow;
# --list prints the plan and the tests left out. Results, with one log per build and per test, go
# to .regression/results/<date_time>/.
#
# Environment: riscv64-unknown-elf-gcc and bender on PATH (or BENDER), SPATZ_LLVM_PATH for Spatz,
# and optionally MAGIA_QUESTA_SETUP / MAGIA_VERILATOR_SETUP to load the simulators.
#
# Examples:
#   scripts/run_regression.py --sim questa --core CV32E40P --fsync on --test mm_tests/fsync_test_mm
#   scripts/run_regression.py --sim verilator --core CV32E40P --fsync on --test collective_tests
#   scripts/run_regression.py --sim all --core all --fsync all --test all

import argparse
import collections
import concurrent.futures
import datetime
import hashlib
import os
import re
import shutil
import signal
import subprocess
import sys
import threading
import time

import yaml

# Tuning: software builds and simulations running at the same time in each build, and per-test timeouts
PARALLEL_SIMS  = 4
TIMEOUT_MESH_S = 3600
TIMEOUT_TILE_S = 1800
MONITOR_PERIOD_S = 60  # Dashboard period when stdout is not a terminal (a terminal refreshes every 2 s); 0 disables it

# Simulator setup, run before every command of that simulator; empty means the tools are already on PATH
QUESTA_SETUP    = os.environ.get('MAGIA_QUESTA_SETUP', '')
VERILATOR_SETUP = os.environ.get('MAGIA_VERILATOR_SETUP', '')
QUESTA_ENV      = f"{QUESTA_SETUP} && " if QUESTA_SETUP else ''
VERILATOR_ENV   = f"{VERILATOR_SETUP} && " if VERILATOR_SETUP else ''

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DEFAULT_YML = ['sw/tests/tests.yml']
TESTBENCHES = ('mesh', 'tile')
SIMS = ('questa', 'verilator')
CORES = ('CV32E40P', 'CV32E40X')
FSYNC = ('on', 'off')

print_lock = threading.Lock()
git_lock = threading.Lock()  # git worktree add/remove cannot run concurrently

TTY = sys.stdout.isatty()  # A terminal gets the dashboard redrawn in place


class Console:
    """Where log lines go: printed before the run, into the dashboard during a live run, always to a file."""

    def __init__(self):
        self.live = False                         # True while the terminal dashboard owns the screen
        self.events = collections.deque(maxlen=6)
        self.logfh = None


console = Console()


def log(msg):
    line = f"[{time.strftime('%H:%M:%S')}] {msg}"
    with print_lock:
        console.events.append(line)
        if console.logfh:
            console.logfh.write(line + '\n')
            console.logfh.flush()
        if not console.live:
            print(line, flush=True)


def hms(sec):
    sec = int(sec)
    return f"{sec // 3600:d}:{sec % 3600 // 60:02d}:{sec % 60:02d}"


# Error lines of a failed log, most telling first: tool errors, then test results, then make
ERROR_RES = [re.compile(r'%Error|\*\* (Error|Fatal)|\$fatal|Fatal error|\berror:|undefined reference|'
                        r'Segmentation fault|Traceback|[Cc]ommand not found|No such file or directory|cannot open'),
             re.compile(r'TILE\[.*\] ERRORS|EXIT CODE: *0*[1-9a-fA-F]|Assertion'),
             re.compile(r'make(\[\d+\])?: \*\*\*')]


def first_error(logfile):
    """The most telling error line of a log, or its last non-empty line, cut to one readable line."""
    try:
        with open(logfile, errors='replace') as fh:
            lines = [ln.strip() for ln in fh if ln.strip() and not ln.startswith(('$ ', '===== '))]
    except OSError:
        return f"no log ({logfile})"
    hit = next((ln for rx in ERROR_RES for ln in lines if rx.search(ln)), None)
    line = hit or (lines[-1] if lines else 'empty log')
    line = re.sub(r'\s+', ' ', line.replace(ROOT, '.'))
    return line if len(line) <= 140 else line[:137] + '...'


class Progress:
    """Live state of every build: phase, results and running tests."""

    def __init__(self):
        self.lock = threading.Lock()
        self.jobs = {}  # job -> state, in execution order

    def add(self, job, label, total):
        with self.lock:
            self.jobs[job] = {'label': label, 'phase': 'queued', 'since': None, 'start': None, 'end': None,
                              'total': total, 'results': {}, 'logs': {}, 'reasons': {}, 'running': {},
                              'build_error': None}

    def phase(self, job, phase):
        with self.lock:
            j = self.jobs[job]
            now = time.time()
            j['phase'], j['since'] = phase, now
            j['start'] = j['start'] or now
            if phase == 'done':
                j['end'] = now

    def start(self, job, test):
        with self.lock:
            self.jobs[job]['running'][test] = time.time()

    def done(self, job, test, status, logfile=None, reason=None):
        with self.lock:
            j = self.jobs[job]
            j['running'].pop(test, None)
            j['results'][test] = status
            j['logs'][test] = logfile
            j['reasons'][test] = reason

    def build_failed(self, job, logfile, reason, status='HW_BUILD_FAIL'):
        """The build failed, so none of its tests ran: reported once for the whole build."""
        with self.lock:
            self.jobs[job]['build_error'] = (logfile, reason, status)

    def report(self, t0, out_dir, final=False):
        """The dashboard: one row per build, then failures, running tests and recent events."""
        now = time.time()
        width = 92
        rule = '─' * width
        title = 'MAGIA regression · finished' if final else 'MAGIA regression · running'
        lines = [f"{title}   {time.strftime('%H:%M:%S')}   elapsed {hms(now - t0)}",
                 f"results: {out_dir}", rule,
                 f"{'#':>2}  {'build':42s} {'phase':10s} {'pass':>5s} {'fail':>5s} {'run':>4s} "
                 f"{'todo':>5s}  {'time':>8s}", rule]
        fails, running = [], []
        tot = npass = nfail = nrun = 0
        with self.lock:
            for n, (job, j) in enumerate(self.jobs.items(), 1):
                p = sum(v == 'PASS' for v in j['results'].values())
                f = len(j['results']) - p
                r = len(j['running'])
                todo = j['total'] - len(j['results']) - r
                tot, npass, nfail, nrun = tot + j['total'], npass + p, nfail + f, nrun + r
                if j['start'] is None:
                    t = '-'
                else:
                    t = hms((j['end'] or now) - j['start'])
                lines.append(f"{n:2d}  {j['label']:42s} {j['phase']:10s} {p:5d} {f:5d} {r:4d} {todo:5d}  {t:>8s}")
                if j['build_error']:
                    lf, why, st = j['build_error']
                    fails.append((n, f"build ({j['total']} tests not run)", st, lf, why))
                else:
                    for test, st in j['results'].items():
                        if st != 'PASS':
                            fails.append((n, test, st, j['logs'].get(test), j['reasons'].get(test)))
                for test, st in j['running'].items():
                    running.append((now - st, n, test))
        lines.append(rule)
        lines.append(f"total {tot}   pass {npass}   fail {nfail}   running {nrun}   todo {tot - npass - nfail - nrun}")
        if fails:
            lines += ['', f"failures"]
            for n, test, st, lf, why in fails:
                lines.append(f"  #{n:<2d} {test:38s} {st}")
                if why:
                    lines.append(f"      {why}")
                if lf:
                    lines.append(f"      log: {lf}")
        if running and not final:
            lines += ['', f"running (longest first)"]
            for el, n, test in sorted(running, reverse=True)[:8]:
                lines.append(f"  #{n:<2d} {test:38s} {hms(el)}")
            if len(running) > 8:
                lines.append(f"  ... and {len(running) - 8} more")
        if console.events and not final:
            lines += ['', f"recent"] + [f"  {e}" for e in console.events]
        return '\n'.join(lines)


progress = Progress()


class Screen:
    """Redraws a block of text in place: moves up over the previous block and erases it, so the
    terminal scrollback never fills with old copies."""

    def __init__(self):
        self.height = 0  # Lines drawn by the previous update

    def draw(self, text, fit=True):
        """`fit` clips to the terminal so the next update can move back over every line."""
        size = shutil.get_terminal_size()
        lines = text.split('\n')
        if fit:
            lines = [line[:size.columns - 1] for line in lines][:size.lines - 1]
        up = f"\033[{self.height}F" if self.height else ''
        sys.stdout.write(up + '\033[J' + '\n'.join(lines) + '\n')
        sys.stdout.flush()
        self.height = len(lines)


screen = Screen()


def monitor(period, t0, out_dir, stop):
    """Redraws the dashboard in place on a terminal, prints it every `period` s otherwise."""
    step = 2 if TTY else period
    while not stop.wait(step):
        rep = progress.report(t0, out_dir)
        with print_lock:
            if TTY:
                screen.draw(rep)
            elif period > 0:
                print(rep, flush=True)
        with open(os.path.join(out_dir, 'status.txt'), 'w') as fh:
            fh.write(rep + '\n')


def sh(cmd, cwd, logfile=None, timeout=None, env=None, title=None):
    """Run a shell command; kill its whole process group on timeout. Returns rc, or None on timeout.
    With a title the output is appended to the log under a header naming the step and the command."""
    out = open(logfile, 'a' if title else 'w') if logfile else subprocess.DEVNULL
    if title:
        out.write(f"\n===== {title}  [{time.strftime('%H:%M:%S')}]\n$ {cmd}\n\n")
        out.flush()
    try:
        p = subprocess.Popen(cmd, cwd=cwd, shell=True, stdout=out, stderr=subprocess.STDOUT,
                             start_new_session=True, env=env)
        try:
            return p.wait(timeout=timeout)
        except subprocess.TimeoutExpired:
            os.killpg(p.pid, signal.SIGKILL)
            p.wait()
            return None
    finally:
        if logfile:
            out.close()


def unsupported(sim, core, fsync):
    """Why a configuration cannot be built, or None if it can."""
    if sim == 'verilator' and core != 'CV32E40P':
        return 'the Verilator flow only supports CV32E40P'
    return None


class Config:
    """A build configuration: simulator, control core and FractalSync on/off."""

    def __init__(self, sim, core, fsync):
        self.sim = sim
        self.core = core
        self.fsync = fsync == 'on'
        self.defines = {core} | ({'MAGIA_FSYNC'} if self.fsync else set())
        self.name = f"{self.sim}_{core}_{'fsync' if self.fsync else 'nofsync'}"

    def make_args(self, mesh_dv, fast):
        return f"core={self.core} fsync={int(self.fsync)} mesh_dv={mesh_dv} fast_sim={int(fast)}"

    def reject(self, test):
        """Why the test does not run in this configuration, or None if it does."""
        if self.sim not in test['sims']:
            return f"runs only on {'/'.join(test['sims'])}"
        if self.core not in test['cores']:
            return f"runs only on {'/'.join(test['cores'])}"
        missing = set(test['requires']) - self.defines
        if missing:
            return f"requires {' '.join(sorted(missing))}"
        return None


def parse_choice(opt, value, choices):
    """Comma list or `all` of an option; returns (values, from_all)."""
    if value == 'all':
        return list(choices), True
    values = value.split(',')
    bad = [v for v in values if v not in choices]
    if bad:
        sys.exit(f"{opt}: unknown value(s) {' '.join(bad)} (use {', '.join(choices)} or all)")
    return values, False


def load_tests(yml_files):
    """Tests of the yml lists; each top-level key must be the sw/tests/ folder of its tests."""
    tests = []
    for f in yml_files:
        with open(os.path.join(ROOT, f)) as fh:
            for folder, entries in yaml.safe_load(fh).items():
                for name, t in entries.items():
                    if t.get('testbench') not in TESTBENCHES:
                        sys.exit(f"{f}:{name}: testbench must be one of {', '.join(TESTBENCHES)}")
                    if test_folder(name) != folder:
                        sys.exit(f"{f}:{name}: listed under {folder} but lives in {test_folder(name)}")
                    sims = t.get('sims') or []
                    if not sims or not set(sims) <= set(SIMS):
                        sys.exit(f"{f}:{name}: sims must list some of {', '.join(SIMS)}")
                    if 'verilator' in sims and t['testbench'] != 'mesh':
                        sys.exit(f"{f}:{name}: the Verilator flow only builds the mesh")
                    tests.append({'name': name, 'testbench': t['testbench'], 'sims': sims,
                                  'mesh_dv': int(t['testbench'] == 'mesh'),
                                  'cores': t.get('cores', list(CORES)),
                                  'requires': t.get('requires') or [],
                                  'fast_sim': t.get('fast_sim', True),
                                  'timeout': t.get('timeout'),
                                  'path': f"{folder}/{os.path.basename(name)}"})
    return tests


def test_folder(name):
    """Folder of a test under sw/tests/, or 'general' for tests that live in sw/tests/ itself."""
    base = os.path.join(ROOT, 'sw', 'tests')
    if '/' in name:
        rel = os.path.dirname(name)
    else:
        rel = ''
        for dirpath, dirnames, filenames in os.walk(base):
            if name + '.c' in filenames or name in dirnames:
                rel = os.path.relpath(dirpath, base)
                break
    rel = '' if rel == '.' else rel
    return rel.split(os.sep)[0] if rel else 'general'


# Paths that never change the HW build: test software, docs and this script
NON_HW_RE = re.compile(r'^(sw/|spatz/sw/|doc/|\.github/|\.regression|scripts/run_regression\.py$|'
                       r'.*\.md$|\.gitlab-ci\.yml$)')


def hw_fingerprint(*extra):
    """Hash of every file of the working tree that feeds the HW build, plus build arguments and setup."""
    files = subprocess.run(['git', 'ls-files', '-co', '--exclude-standard', '-z'], cwd=ROOT, check=True,
                           stdout=subprocess.PIPE).stdout.decode().split('\0')
    h = hashlib.sha256('\0'.join(extra).encode())
    for f in sorted(filter(None, files)):
        path = os.path.join(ROOT, f)
        if NON_HW_RE.match(f) or not os.path.isfile(path):
            continue
        h.update(f.encode() + b'\0')
        with open(path, 'rb') as fh:
            h.update(fh.read())
    return h.hexdigest()


def copy_changes(wt):
    """Applies the uncommitted changes and untracked files of the working tree to a worktree at HEAD."""
    diff = subprocess.run(['git', 'diff', 'HEAD', '--binary'], cwd=ROOT, check=True,
                          stdout=subprocess.PIPE).stdout
    if diff:
        subprocess.run(['git', 'apply', '--whitespace=nowarn'], cwd=wt, input=diff, check=True)
    untracked = subprocess.run(['git', 'ls-files', '--others', '--exclude-standard', '-z'], cwd=ROOT,
                               check=True, stdout=subprocess.PIPE).stdout.decode().split('\0')
    for f in filter(None, untracked):
        if f.startswith('.regression'):
            continue
        os.makedirs(os.path.dirname(os.path.join(wt, f)) or wt, exist_ok=True)
        shutil.copy2(os.path.join(ROOT, f), os.path.join(wt, f))


def make_worktree(wt):
    """New worktree at HEAD with the working-tree changes."""
    with git_lock:
        if os.path.exists(wt):
            subprocess.run(['git', 'worktree', 'remove', '--force', wt], cwd=ROOT, check=False,
                           stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            shutil.rmtree(wt, ignore_errors=True)
        subprocess.run(['git', 'worktree', 'prune'], cwd=ROOT, check=True)
        subprocess.run(['git', 'worktree', 'add', '--detach', wt, 'HEAD'], cwd=ROOT, check=True,
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    copy_changes(wt)


def sync_worktree(wt):
    """Brings an existing worktree to HEAD plus the working-tree changes; build outputs are untracked
    files, so the reset leaves them in place."""
    head = subprocess.run(['git', 'rev-parse', 'HEAD'], cwd=ROOT, check=True,
                          stdout=subprocess.PIPE).stdout.decode().strip()
    with git_lock:
        subprocess.run(['git', 'reset', '-q', '--hard', head], cwd=wt, check=True)
    copy_changes(wt)


def share_bender(wt, work_dir):
    """Points the worktree's .bender at one dependency checkout shared by every build, instead of a
    full clone per worktree (builds run one at a time, so they never touch it concurrently)."""
    shared = os.path.join(work_dir, 'bender_deps')
    os.makedirs(shared, exist_ok=True)
    link = os.path.join(wt, '.bender')
    if os.path.islink(link):
        return
    if os.path.exists(link):
        shutil.rmtree(link)
    os.symlink(shared, link)


def job_name(cfg, mesh_dv, fast):
    return f"{cfg.name}_{'mesh' if mesh_dv else 'tile'}{'' if fast else '_nofast'}"


def job_label(cfg, mesh_dv, fast):
    return (f"{cfg.sim:9s} {cfg.core:8s} {'fsync' if cfg.fsync else 'nofsync':7s} "
            f"{'mesh' if mesh_dv else 'tile'}{'' if fast else ' nofast'}")


def select_tests(tests, selectors):
    """Tests matching any selector: `all`, a testbench (mesh, tile), a folder or folder/test."""
    if 'all' in selectors:
        return tests
    folders = sorted({t['path'].split('/')[0] for t in tests})
    sel = []
    for s in selectors:
        hit = [t for t in tests if t['testbench'] == s or t['path'] == s or t['path'].startswith(s + '/')]
        if not hit:
            sys.exit(f"--test {s}: no such testbench, folder or test (testbenches: {' '.join(TESTBENCHES)}; "
                     f"folders: {' '.join(folders)}; --test all --list prints every test)")
        sel += [t for t in hit if t not in sel]
    return sel


def print_plan(jobs, skipped, verbose):
    """Builds in execution order, then the tests left out of each configuration and why."""
    print(f"\nPlan: {len(jobs)} build(s), {sum(len(sel) for *_, sel in jobs)} test run(s), "
          f"one build at a time")
    print(f"{'#':>2}  {'build':42s} {'tests':>5s}")
    for n, (cfg, mesh_dv, fast, sel) in enumerate(jobs, 1):
        print(f"{n:2d}  {job_label(cfg, mesh_dv, fast):42s} {len(sel):5d}")
        if verbose:
            print(f"      {' '.join(t['path'] for t in sel)}")
    if skipped:
        print(f"\nNot run")
        for cfg, why, names in skipped:
            cfg_label = f"{cfg.sim} {cfg.core} {'fsync' if cfg.fsync else 'nofsync'}"
            print(f"  {cfg_label:32s} {len(names):3d} test(s): {why}")
            if verbose:
                print(f"      {' '.join(names)}")
    if not verbose:
        print(f"(--list shows the test paths)")


def run_job(cfg, mesh_dv, fast, tests, args, out_dir):
    """Build one configuration and run its tests. Returns {test name: status}."""
    job = job_name(cfg, mesh_dv, fast)
    wt = os.path.join(args.work_dir, job)
    jlog = os.path.join(out_dir, job)
    os.makedirs(jlog, exist_ok=True)
    margs = f"{cfg.make_args(mesh_dv, fast)} BENDER={args.bender}"
    env = VERILATOR_ENV if cfg.sim == 'verilator' else QUESTA_ENV
    results = {}

    # The HW is rebuilt only when a file feeding it, the build arguments or the tool setup changed
    stamp = os.path.join(args.work_dir, f"{job}.hw_stamp")
    fingerprint = hw_fingerprint(margs, env, QUESTA_ENV)
    if os.path.exists(os.path.join(wt, '.git')):
        progress.phase(job, 'sync')
        log(f"{job}: updating worktree")
        sync_worktree(wt)
    else:
        progress.phase(job, 'worktree')
        log(f"{job}: creating worktree")
        make_worktree(wt)
    built = open(stamp).read().strip() if os.path.exists(stamp) else None

    hlog = f"{jlog}/hw_build.log"
    if built == fingerprint and not args.rebuild:
        log(f"{job}: HW unchanged since the last build, reusing it")
        with open(hlog, 'w') as fh:
            fh.write(f"HW unchanged since the last successful build, reusing the one in {wt}\n")
    else:
        why = 'forced by --rebuild' if args.rebuild else 'first build' if built is None else 'HW sources changed'
        progress.phase(job, 'hw build')
        log(f"{job}: building HW ({why})")
        if os.path.exists(stamp):
            os.remove(stamp)
        with open(hlog, 'w') as fh:
            fh.write(f"HW build of {job} ({why}) in {wt}\n")
        share_bender(wt, args.work_dir)
        ok = sh(f"{args.bender} checkout", wt, hlog, title='bender checkout') == 0
        # vsim-scripts also generates the iDMA RTL, which the Verilator flow needs too
        ok = ok and sh(f"{QUESTA_ENV}make vsim-scripts {margs}", wt, hlog, title='compile scripts') == 0
        if ok and cfg.sim == 'verilator':
            ok = sh(f"{env}make verilate {margs}", wt, hlog, title='Verilator model') == 0
        elif ok:
            ok = sh(f"{env}make build-hw {margs}", wt, hlog, title='Questa build') == 0
        if ok:
            with open(stamp, 'w') as fh:
                fh.write(fingerprint + '\n')
        else:
            why = first_error(hlog)
            log(f"{job}: HW build FAILED: {why}")
            progress.build_failed(job, hlog, why)
            for t in tests:
                progress.done(job, t['path'], 'HW_BUILD_FAIL', hlog, why)
            progress.phase(job, 'done')
            return {t['path']: 'HW_BUILD_FAIL' for t in tests}

    # One log per test, SW build then simulation; tests run in parallel, so they never share a file
    tdir = os.path.join(jlog, 'tests')
    os.makedirs(tdir, exist_ok=True)

    def test_log(t):
        return os.path.join(tdir, t['path'].replace('/', '__') + '.log')

    # `make clean` only touches this test's artifacts, so software builds can run in parallel too
    def build_one(t):
        open(test_log(t), 'w').close()
        return t, sh(f"make clean all {margs} test={t['name']}", wt, test_log(t), title='SW build') == 0

    progress.phase(job, 'sw build')
    runnable = []
    with concurrent.futures.ThreadPoolExecutor(max_workers=args.procs) as pool:
        for t, ok in pool.map(build_one, tests):
            if ok:
                runnable.append(t)
            else:
                results[t['path']] = 'SW_BUILD_FAIL'
                why = first_error(test_log(t))
                log(f"{job}: {t['path']} SW build FAILED: {why}")
                progress.done(job, t['path'], 'SW_BUILD_FAIL', test_log(t), why)
    progress.phase(job, 'running')
    log(f"{job}: {len(runnable)}/{len(tests)} tests built, running {args.procs} at a time")

    timeout = args.timeout_mesh if mesh_dv else args.timeout_tile

    def run_one(t):
        logfile = test_log(t)
        start = time.time()
        progress.start(job, t['path'])
        target = 'verilate-run' if cfg.sim == 'verilator' else 'run'
        rc = sh(f"{env}make {target} {margs} test={t['name']}", wt, logfile, timeout=t['timeout'] or timeout,
                title='simulation')
        with open(logfile, errors='replace') as fh:
            m = re.findall(r'EXIT CODE:\s*([0-9a-fA-Fx]+)', fh.read())
        limit = t['timeout'] or timeout
        why = None
        if rc is None:
            st = 'TIMEOUT'
            why = f"no EXIT CODE within {limit} s, last line: {first_error(logfile)}"
        elif m and int(m[-1], 16) == 0:
            st = 'PASS'
        else:
            st = f"FAIL(exit={m[-1] if m else 'none'})"
            why = first_error(logfile)
        log(f"{job}: {t['path']} {st} ({time.time() - start:.0f}s)" + (f": {why}" if why else ''))
        progress.done(job, t['path'], st, logfile, why)
        return t['path'], st

    with concurrent.futures.ThreadPoolExecutor(max_workers=args.procs) as pool:
        for name, st in pool.map(run_one, runnable):
            results[name] = st
    progress.phase(job, 'done')
    return results


def check_tools(bender, sims):
    """Stops before any build if a tool the selected simulators need is missing."""
    missing = []
    if not shutil.which('riscv64-unknown-elf-gcc'):
        missing.append('riscv64-unknown-elf-gcc on PATH')
    if not shutil.which(bender):
        missing.append(f"bender ({bender}): put it on PATH, set BENDER or pass --bender")
    if 'questa' in sims and sh(f"{QUESTA_ENV}command -v vsim", ROOT) != 0:
        missing.append('vsim: put Questa on PATH or set MAGIA_QUESTA_SETUP')
    if 'verilator' in sims and sh(f"{VERILATOR_ENV}command -v verilator", ROOT) != 0:
        missing.append('verilator: put it on PATH or set MAGIA_VERILATOR_SETUP')
    if missing:
        sys.exit('missing tools:\n  ' + '\n  '.join(missing))


def main():
    ap = argparse.ArgumentParser(description='Run the MAGIA regression over several build configurations.')
    ap.add_argument('yml', nargs='*', default=DEFAULT_YML, help='test lists (default: sw/tests/tests.yml)')
    ap.add_argument('--sim', required=True, help=f"{', '.join(SIMS)} or all (comma list)")
    ap.add_argument('--core', required=True, help=f"{', '.join(CORES)} or all (comma list)")
    ap.add_argument('--fsync', required=True, help=f"{', '.join(FSYNC)} or all (comma list)")
    ap.add_argument('--test', action='append', required=True,
                    help="all, mesh, tile, a folder of sw/tests/ ('general' = sw/tests/ itself) or "
                         "folder/test; repeatable, comma separated")
    ap.add_argument('-p', '--procs', type=int, default=PARALLEL_SIMS, help='simulations in parallel per build')
    ap.add_argument('--timeout-mesh', type=int, default=TIMEOUT_MESH_S, help='seconds per mesh test')
    ap.add_argument('--timeout-tile', type=int, default=TIMEOUT_TILE_S, help='seconds per tile test')
    ap.add_argument('--work-dir', default=os.path.join(ROOT, '.regression'), help='worktrees and results')
    ap.add_argument('--bender', default=os.environ.get('BENDER', 'bender'), help='bender binary (default: $BENDER or bender)')
    ap.add_argument('--rebuild', action='store_true', help='rebuild the HW even if its sources did not change')
    ap.add_argument('--list', action='store_true', help='print the selected tests and exit')
    ap.add_argument('--monitor', type=int, default=MONITOR_PERIOD_S,
                    help='seconds between dashboards when not on a terminal, 0 disables')
    args = ap.parse_args()
    args.work_dir = os.path.abspath(args.work_dir)

    sims, all_sims = parse_choice('--sim', args.sim, SIMS)
    cores, all_cores = parse_choice('--core', args.core, CORES)
    fsyncs, _ = parse_choice('--fsync', args.fsync, FSYNC)
    configs = []
    for sim in sims:
        for core in cores:
            for fsync in fsyncs:
                why = unsupported(sim, core, fsync)
                if why and not (all_sims or all_cores):
                    sys.exit(f"configuration {sim} {core} fsync={fsync} is not supported: {why}")
                if why:
                    print(f"skipping {sim} {core} fsync={fsync}: {why}")
                else:
                    configs.append(Config(sim, core, fsync))

    tests = load_tests(args.yml)
    tests = select_tests(tests, [v.strip('/') for arg in args.test for v in arg.split(',')])

    # fast_sim only changes the Questa build, Verilator runs every test in one build
    jobs = []
    skipped = []  # (config, reason, test names)
    for cfg in configs:
        by_reason = {}
        for t in tests:
            why = cfg.reject(t)
            if why:
                by_reason.setdefault(why, []).append(t['path'])
        skipped += [(cfg, why, names) for why, names in by_reason.items()]  # names are sw/tests/ paths
        for mesh_dv in (1, 0):
            for fast in (True, False):
                sel = [t for t in tests if t['mesh_dv'] == mesh_dv and cfg.reject(t) is None and
                       (cfg.sim == 'verilator' or t['fast_sim'] == fast)]
                if cfg.sim == 'verilator' and not fast:
                    sel = []
                if sel:
                    jobs.append((cfg, mesh_dv, fast, sel))
    print_plan(jobs, skipped, args.list)
    if not jobs:
        sys.exit("none of the selected tests runs in the selected configurations")
    if args.list:
        return
    check_tools(args.bender, {cfg.sim for cfg, *_ in jobs})

    stamp = datetime.datetime.now().strftime('%Y%m%d_%H%M%S')
    out_dir = os.path.join(args.work_dir, 'results', stamp)
    os.makedirs(out_dir, exist_ok=True)
    console.logfh = open(os.path.join(out_dir, 'events.log'), 'w')
    for cfg, mesh_dv, fast, sel in jobs:
        progress.add(job_name(cfg, mesh_dv, fast), job_label(cfg, mesh_dv, fast), len(sel))
    print(f"\nresults in {out_dir}\n", flush=True)

    t0 = time.time()
    stop = threading.Event()
    console.live = TTY
    if TTY or args.monitor > 0:
        threading.Thread(target=monitor, args=(args.monitor, t0, out_dir, stop), daemon=True).start()

    # One build at a time: builds and simulations of different configurations never overlap
    results = {}
    for cfg, mesh_dv, fast, sel in jobs:
        job = job_name(cfg, mesh_dv, fast)
        try:
            results[job] = run_job(cfg, mesh_dv, fast, sel, args, out_dir)
        except Exception as e:  # noqa: BLE001
            log(f"{job}: {e}")
            results[job] = {t['path']: 'ERROR' for t in sel}
            progress.build_failed(job, None, f"script error: {e}", 'ERROR')
            for t in sel:
                progress.done(job, t['path'], 'ERROR', None, str(e))
            progress.phase(job, 'done')

    stop.set()
    console.live = False
    final = progress.report(t0, out_dir, final=True)
    with open(os.path.join(out_dir, 'status.txt'), 'w') as fh:
        fh.write(final + '\n')

    lines = ['| build | test | result |', '|---|---|---|']
    npass = ntot = 0
    for job in results:
        for name, st in sorted(results[job].items()):
            lines.append(f"| {job} | {name} | {st} |")
            ntot += 1
            npass += st == 'PASS'
    lines.append(f"\n{npass}/{ntot} passed")
    with open(os.path.join(out_dir, 'summary.md'), 'w') as fh:
        fh.write('\n'.join(lines) + '\n')
    with print_lock:
        if TTY:
            screen.draw(final, fit=False)
        else:
            print('\n' + final, flush=True)
        print(f"\n{npass}/{ntot} passed   (summary.md, status.txt and events.log in {out_dir})")
    sys.exit(0 if npass == ntot else 1)


if __name__ == '__main__':
    main()
