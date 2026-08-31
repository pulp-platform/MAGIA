#!/usr/bin/env python3
#
# Copyright (C) 2026 Fondazione Chips-IT
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
# MAGIA benchmark runner for the PLAY kernel ports
# (sw/tests/cluster_tests/benchmarks/tests/). Mirrors the structure of
# PLAY's own test-runner.py (parallel jobs, per-test CSV, a final markdown
# report), adapted for MAGIA's build:
#
#   - MAGIA's simulation step shares ONE compiled Questa library across
#     every test (sim/work, sim/modelsim.ini -- symlinked into each test
#     dir, not copied). Running `vsim` concurrently against that shared
#     library corrupts it (seen directly in this repo's own history:
#     "mtilibWrite INTERNAL ERROR", "vsim-3816 incompatible release").
#     So only the SW compile step (`make ... all`, each test's own
#     build/ dir, no shared mutable state) is run in parallel; the
#     `vsim run` step is serialized behind a lock, one at a time.
#   - `module load` is required for vsim/riscv64-unknown-elf-gcc in a
#     fresh shell here, unlike PLAY's own environment.
#   - PULP_CORE_COUNT is fixed at 8 (sw/utils/magia_tile_utils.h), no
#     1-core baseline to run.
#
# Usage:
#   python3 scripts/magia_bench_runner.py
#   python3 scripts/magia_bench_runner.py -j 4
#   python3 scripts/magia_bench_runner.py --tests vector_add vector_mul
#   python3 scripts/magia_bench_runner.py --timeout 300 --questa-module questa/2025.3

import argparse
import csv
import os
import re
import signal
import subprocess
import sys
import threading
from concurrent.futures import ThreadPoolExecutor, as_completed
from types import SimpleNamespace

# Full PLAY kernel roster (PLAY/source/*), in the order the ported tests
# should run/report in. Not all of these are ported yet -- discover_kernels()
# filters this down to whichever ones actually have a
# benchmarks/tests/<name>/pulp_task/<name>_task.c, so the runner just skips
# (with a warning) the rest rather than failing.
TEST_DIRS = [
    'vector_add',
    'vector_axpy',
    'vector_dot',
    'vector_memcpy',
    'vector_min',
    'vector_mul',
    'vector_offset',
    'vector_scale',
    'vector_set_all',
    'vector_sub',
]

print_lock = threading.Lock()
vsim_lock = threading.Lock()  # serializes the shared sim/work simulation step

STATS_HEADER = "Printing statistics:"
STATS_LINE_RE = re.compile(r"\[(\d+)\]\s+([\w\s]+):\s+([\d.]+)")
RESULT_RE = re.compile(r"\[Main core \d+\]\s+(\w+)\s+(PASS|FAIL)")
NUM_CORES = 8

DEFAULT_TIMEOUT_S = 300  # per make step (compile, then run), not combined


def parse_args():
    parser = argparse.ArgumentParser(
        description="Build+run MAGIA's PLAY kernel ports and save per-kernel stats CSVs "
                    "plus a markdown report, PLAY-test-runner style."
    )
    parser.add_argument(
        "--tests", nargs="*", default=None,
        help="Kernel names to run (must have sw/tests/cluster_tests/benchmarks/tests/<name>/). "
             "Default: auto-discover every ported PLAY kernel."
    )
    parser.add_argument(
        "-j", "--jobs", type=int, default=1,
        help="Number of tests to build (compile) in parallel. The `vsim run` step is always "
             "serialized (shared sim/work), regardless of this value. Default: 1 (fully sequential)."
    )
    parser.add_argument(
        "--stats", type=int, default=1, choices=[0, 1],
        help="Value for the Makefile's stats= flag (default: 1, i.e. enabled)."
    )
    parser.add_argument(
        "--timeout", type=int, default=DEFAULT_TIMEOUT_S,
        help=f"Per-step (compile, then run) wall-clock timeout in seconds (default: {DEFAULT_TIMEOUT_S})."
    )
    parser.add_argument(
        "--questa-module", default="questa/2025.3",
        help="Environment-modules name to load for vsim/vopt/vlib (default: questa/2025.3)."
    )
    parser.add_argument(
        "--gcc-module", default="corev-gcc/14.1.0-v0.3",
        help="Environment-modules name to load for riscv64-unknown-elf-gcc (default: corev-gcc/14.1.0-v0.3)."
    )
    parser.add_argument(
        "--skip-module-load", action="store_true",
        help="Don't try `module load` at all; assume vsim/riscv64-unknown-elf-gcc are already on PATH."
    )
    parser.add_argument(
        "--results-dir", default=None,
        help="Where to write the per-kernel CSVs and the markdown report "
             "(default: sw/tests/cluster_tests/benchmarks/results)."
    )
    return parser.parse_args()


def set_paths(args):
    paths = SimpleNamespace()
    paths.script_dir = os.path.dirname(os.path.abspath(__file__))
    paths.repo_root = os.path.abspath(os.path.join(paths.script_dir, ".."))
    paths.benchmarks_dir = os.path.join(paths.repo_root, "sw", "tests", "cluster_tests", "benchmarks")
    paths.tests_dir = os.path.join(paths.benchmarks_dir, "tests")
    paths.results_dir = args.results_dir or os.path.join(paths.benchmarks_dir, "results")
    os.makedirs(paths.results_dir, exist_ok=True)
    return paths


def discover_kernels(paths):
    """Filters TEST_DIRS (the full PLAY roster) down to whichever ones are
    actually ported: a benchmarks/tests/<name>/ dir whose pulp_task/
    contains a <name>_task.c. Kernels listed in TEST_DIRS but not yet
    ported are skipped with a warning instead of failing the run."""
    kernels = []
    skipped = []
    for name in TEST_DIRS:
        task_file = os.path.join(paths.tests_dir, name, "pulp_task", f"{name}_task.c")
        if os.path.isfile(task_file):
            kernels.append(name)
        else:
            skipped.append(name)
    if skipped:
        print(f"Not yet ported, skipping: {', '.join(skipped)}")
    return kernels


def module_prefix(args):
    if args.skip_module_load:
        return ""
    return f"module load {args.questa_module} {args.gcc_module} && "


def run_make_step(args, paths, kernel_name, make_target):
    """Runs one `make test=<kernel> stats=<N> <target>` step from the repo
    root; returns (ok, output).

    Started in its own process group (start_new_session=True) so a timeout
    can kill the *whole* descendant tree (bash -> make -> vsim/vish/vsimk),
    not just the direct bash child -- plain subprocess.run(timeout=...) only
    kills the immediate child, leaving a hung vsim running indefinitely
    (seen directly: vector_dot's known deadlock survived a 300s timeout
    because only `bash` got killed, vsim kept spinning for hours)."""
    command = f"{module_prefix(args)}make test={kernel_name} stats={args.stats} {make_target}"
    proc = subprocess.Popen(
        ["bash", "-lc", command],
        cwd=paths.repo_root,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        universal_newlines=True,
        start_new_session=True,
    )
    try:
        stdout, _ = proc.communicate(timeout=args.timeout)
        return proc.returncode == 0, stdout
    except subprocess.TimeoutExpired:
        try:
            os.killpg(os.getpgid(proc.pid), signal.SIGKILL)
        except ProcessLookupError:
            pass
        stdout, _ = proc.communicate()
        return False, (stdout or "") + f"\n[TIMEOUT after {args.timeout}s running `{make_target}` -- process group killed]\n"


def run_test_case(args, paths, kernel_name):
    """Compile (parallel-safe) then simulate (serialized) one kernel;
    returns (status, output) where status is one of 'PASS', 'FAIL',
    'TIMEOUT', 'ERROR'."""
    header = f"\n--- Running {kernel_name} ---\n"

    ok, compile_out = run_make_step(args, paths, kernel_name, "all")
    if not ok:
        with print_lock:
            print(header, end="")
            print(compile_out, end="")
            print(f"Result: {kernel_name} -> ERROR (compile)")
        return "ERROR", compile_out

    # Only one `vsim run` at a time: sim/work is a single shared library
    # symlinked into every test dir, not copied per-test -- concurrent
    # vsim invocations against it corrupt the compiled design (seen
    # directly in this repo's history: "mtilibWrite INTERNAL ERROR",
    # "vsim-3816 ... incompatible release of vsim"). Compiling in
    # parallel is safe (each test's own build/ dir); simulating is not.
    with vsim_lock:
        ok, run_out = run_make_step(args, paths, kernel_name, "run")

    output = compile_out + run_out

    with print_lock:
        print(header, end="")
        print(run_out, end="")

    if not ok:
        status = "TIMEOUT" if "[TIMEOUT" in run_out else "ERROR"
        with print_lock:
            print(f"Result: {kernel_name} -> {status}")
        return status, output

    result_match = RESULT_RE.search(output)
    if result_match:
        status = result_match.group(2)  # PASS or FAIL
    elif "Errors: 0" in output and STATS_HEADER in output:
        status = "PASS"
    else:
        status = "ERROR"

    with print_lock:
        print(f"Result: {kernel_name} -> {status}")
    return status, output


def parse_and_save_stats(paths, kernel_name, output):
    if STATS_HEADER not in output:
        print(f"Warning: no '{STATS_HEADER}' block found for {kernel_name}; not writing a CSV.")
        return None

    stats_block = output[output.find(STATS_HEADER):]
    per_core_data = {}

    for line in stats_block.splitlines():
        match = STATS_LINE_RE.search(line)
        if not match:
            continue
        core_id = int(match.group(1))
        key = match.group(2).strip().replace(" ", "_")
        value = match.group(3)
        per_core_data.setdefault(core_id, {})[key] = value

    if not per_core_data:
        print(f"Warning: '{STATS_HEADER}' found but no per-core lines parsed for {kernel_name}.")
        return None

    fieldnames = ["id"] + list(next(iter(per_core_data.values())).keys())
    csv_path = os.path.join(paths.results_dir, f"{kernel_name}_MAGIA_CL_{NUM_CORES}.csv")

    with open(csv_path, "w", newline="") as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames, lineterminator="\n")
        writer.writeheader()
        for core_id in sorted(per_core_data):
            row = {"id": core_id, **per_core_data[core_id]}
            writer.writerow({f: row.get(f, "") for f in fieldnames})

    print(f"Statistics saved to {csv_path}")
    return csv_path


def generate_markdown_report(paths, statuses):
    print("\n--- Generating Markdown Report ---")

    test_data = {}
    for filename in sorted(os.listdir(paths.results_dir)):
        if not filename.endswith(".csv"):
            continue
        suffix = f"_MAGIA_CL_{NUM_CORES}.csv"
        if not filename.endswith(suffix):
            continue
        test_name = filename[: -len(suffix)]
        with open(os.path.join(paths.results_dir, filename), newline="") as csvfile:
            reader = csv.DictReader(csvfile)
            test_data[test_name] = {"headers": reader.fieldnames, "rows": list(reader)}

    lines = []
    for test_name in sorted(test_data.keys()):
        headers = test_data[test_name]["headers"]
        rows = test_data[test_name]["rows"]
        if not rows:
            continue

        status = statuses.get(test_name, "")
        lines.append(f"## {test_name.replace('_', ' ').upper()} ({status})")
        lines.append("")

        display_headers = ["Core"] + [h.replace("_", " ") for h in headers if h != "id"]
        lines.append("| " + " | ".join(display_headers) + " |")
        lines.append("|-" + "|-".join("" for _ in display_headers) + "|")

        for row in rows:
            values = [row.get("id", "")]
            values += [row.get(h, "") for h in headers if h != "id"]
            lines.append("| " + " | ".join(values) + " |")

        lines.append("")

    report_path = os.path.join(paths.results_dir, "benchmarks.md")
    with open(report_path, "w") as f:
        f.write("\n".join(lines))
    print(f"Markdown report saved to {report_path}")


def main():
    args = parse_args()
    paths = set_paths(args)

    kernels = args.tests if args.tests else discover_kernels(paths)
    if not kernels:
        print("No kernels found to run. Use --tests to specify them explicitly.")
        sys.exit(1)

    print(f"Kernels to run ({len(kernels)}): {', '.join(kernels)}")
    if args.jobs > 1:
        print(f"Compiling up to {args.jobs} at a time; `vsim run` is always serialized (shared sim/work).")

    statuses = {}

    def do_one(kernel_name):
        status, output = run_test_case(args, paths, kernel_name)
        statuses[kernel_name] = status
        if status == "PASS":
            parse_and_save_stats(paths, kernel_name, output)

    if args.jobs > 1:
        with ThreadPoolExecutor(max_workers=args.jobs) as executor:
            futures = {executor.submit(do_one, k): k for k in kernels}
            for future in as_completed(futures):
                k = futures[future]
                try:
                    future.result()
                except Exception as e:
                    with print_lock:
                        print(f"Test {k} raised an exception: {e}")
                    statuses[k] = "ERROR"
    else:
        for kernel_name in kernels:
            do_one(kernel_name)

    generate_markdown_report(paths, statuses)

    failed = [k for k in kernels if statuses.get(k) != "PASS"]
    print(f"\nDone: {len(kernels) - len(failed)}/{len(kernels)} passed.")
    if failed:
        print(f"Not PASS: {', '.join(failed)}")


if __name__ == "__main__":
    main()
