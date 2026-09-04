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
# collect_bench_csvs.py -- collapses one platform's per-kernel PLAY benchmark
# CSVs into two combined CSVs with a schema that is IDENTICAL on both
# platforms, so the MAGIA run and the pulp_cluster standalone run can be
# dropped into Excel side by side and compared with a plain VLOOKUP/join on
# (test, core) or (test).
#
# The same script ships in both repos, with the default --results-dir and
# --suffix pointing at that repo's own layout:
#
#   MAGIA-eventunit        scripts/collect_bench_csvs.py
#       sw/tests/cluster_tests/benchmarks/results/<kernel>_MAGIA_CL_8.csv
#   pulp_cluster-ohw-cv32  regression_tests/play_bench/collect_bench_csvs.py
#       PLAY/test/runners/pulp-open/benchmarks/rtl/results/<kernel>_CL_8.csv
#
# Both per-kernel CSVs already share the PLAY stats column set written by
# stats.h's print_stats() (id,cycles,instr_execd,ld_stall,jr_stall,imiss,ld,
# st,jump,branch,btaken,rvc), so the merge is a straight concatenation with
# the kernel name recovered from the filename and the platform tag prepended.
#
# Outputs (next to the per-kernel CSVs unless -o is given):
#   <platform>_all_cores.csv    one row per (test, core)  -- the raw data
#   <platform>_per_test.csv     one row per test          -- what you actually
#                               chart: cycles min/mean/max across the 8 cores,
#                               plus the per-core mean of every other counter.
#
# `cycles` is reported as the MAX across cores as well as the mean because the
# kernel's wall-clock cost is the slowest core; PLAY's own reports quote core 0.
#
# Usage:
#   python3 collect_bench_csvs.py
#   python3 collect_bench_csvs.py --cores 1            # the CL_1 baselines
#   python3 collect_bench_csvs.py --results-dir DIR --suffix _MAGIA_CL_8.csv
#   python3 collect_bench_csvs.py --platform MAGIA -o /tmp/magia.csv

import argparse
import csv
import os

def mean(vals):
    """statistics.fmean() is 3.8+; the toolchain hosts still ship 3.6."""
    return sum(vals) / float(len(vals))

import sys

# Filled in per repo -- see the header comment.
DEFAULT_PLATFORM = "MAGIA"
DEFAULT_RESULTS_DIR = "sw/tests/cluster_tests/benchmarks/results"     # relative to the repo root
DEFAULT_SUFFIX_FMT = "_MAGIA_CL_{cores}.csv"       # e.g. "_MAGIA_CL_{cores}.csv"
DEFAULT_ROOT_UP = ("..",)          # scripts/ -> repo root

ID_COL = "id"


def repo_root():
    return os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)),
                                        *DEFAULT_ROOT_UP))


def parse_args():
    p = argparse.ArgumentParser(
        description="Collect per-kernel PLAY benchmark CSVs into one combined CSV "
                    "plus a per-test summary, with a schema shared across platforms."
    )
    p.add_argument("--platform", default=DEFAULT_PLATFORM,
                   help=f"Platform tag written into every row (default: {DEFAULT_PLATFORM}).")
    p.add_argument("--cores", type=int, default=8,
                   help="Core count of the run to collect (default: 8). Selects the "
                        "_CL_<cores>.csv files and is written into every row.")
    p.add_argument("--results-dir", default=None,
                   help=f"Directory holding the per-kernel CSVs "
                        f"(default: <repo>/{DEFAULT_RESULTS_DIR}).")
    p.add_argument("--suffix", default=None,
                   help=f"Filename suffix identifying a per-kernel CSV "
                        f"(default: {DEFAULT_SUFFIX_FMT.format(cores='<cores>')}).")
    p.add_argument("-o", "--output", default=None,
                   help="Path of the per-core CSV (default: "
                        "<results-dir>/<platform>_all_cores_CL_<cores>.csv). "
                        "The per-test summary is written alongside it.")
    return p.parse_args()


def load(path):
    """Returns (fieldnames, rows) for one per-kernel CSV, or (None, None)."""
    with open(path, newline="") as fh:
        reader = csv.DictReader(fh)
        if not reader.fieldnames or ID_COL not in reader.fieldnames:
            return None, None
        return list(reader.fieldnames), list(reader)


def main():
    args = parse_args()

    results_dir = args.results_dir or os.path.join(repo_root(), DEFAULT_RESULTS_DIR)
    suffix = args.suffix or DEFAULT_SUFFIX_FMT.format(cores=args.cores)
    if not os.path.isdir(results_dir):
        sys.exit(f"error: results dir not found: {results_dir}")

    names = sorted(f for f in os.listdir(results_dir)
                   if f.endswith(suffix) and not f.startswith(args.platform))
    if not names:
        sys.exit(f"error: no *{suffix} found in {results_dir}")

    schema = None
    per_core = []           # list of dicts, canonical schema
    per_test = []
    skipped = []

    for name in names:
        test = name[:-len(suffix)]
        fields, rows = load(os.path.join(results_dir, name))
        if fields is None:
            skipped.append((test, "no 'id' column"))
            continue
        if "test" in fields:
            # An already-merged file (it carries its own 'test' column) that
            # happens to match the suffix -- e.g. all_benchmarks_MAGIA_CL_8.csv
            # or a previous run of this script. Not an input.
            continue
        counters = [c for c in fields if c != ID_COL]
        if schema is None:
            schema = counters
        elif counters != schema:
            # Merging mismatched column sets would silently misalign the two
            # platforms' columns, which is the one thing this script exists to
            # prevent. Report and drop instead.
            skipped.append((test, f"columns {counters} != {schema}"))
            continue

        for row in rows:
            out = {"platform": args.platform, "test": test,
                   "cores": args.cores, "core": row[ID_COL]}
            out.update({c: row.get(c, "") for c in counters})
            per_core.append(out)

        def col(c):
            vals = []
            for row in rows:
                try:
                    vals.append(float(row[c]))
                except (KeyError, TypeError, ValueError):
                    pass
            return vals

        cyc = col("cycles") if "cycles" in counters else []
        summary = {"platform": args.platform, "test": test, "cores": args.cores,
                   "n_cores_reported": len(rows)}
        summary["cycles_max"]  = f"{max(cyc):.0f}" if cyc else ""
        summary["cycles_mean"] = f"{mean(cyc):.1f}" if cyc else ""
        summary["cycles_min"]  = f"{min(cyc):.0f}" if cyc else ""
        summary["cycles_core0"] = rows[0].get("cycles", "") if rows else ""
        for c in counters:
            vals = col(c)
            summary[f"{c}_mean"] = f"{mean(vals):.1f}" if vals else ""
        per_test.append(summary)

    if not per_core:
        sys.exit("error: nothing collected")

    out_cores = args.output or os.path.join(
        results_dir, f"{args.platform}_all_cores_CL_{args.cores}.csv")
    base, ext = os.path.splitext(out_cores)
    out_tests = f"{base}_per_test{ext or '.csv'}"

    core_fields = ["platform", "test", "cores", "core"] + schema
    with open(out_cores, "w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=core_fields)
        w.writeheader()
        w.writerows(per_core)

    test_fields = (["platform", "test", "cores", "n_cores_reported",
                    "cycles_max", "cycles_mean", "cycles_min", "cycles_core0"]
                   + [f"{c}_mean" for c in schema])
    with open(out_tests, "w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=test_fields)
        w.writeheader()
        w.writerows(per_test)

    print(f"{args.platform}: {len(per_test)} kernels, {len(per_core)} core rows")
    print(f"  per-core : {out_cores}")
    print(f"  per-test : {out_tests}")
    if skipped:
        print("  skipped:")
        for test, why in skipped:
            print(f"    {test}: {why}")


if __name__ == "__main__":
    main()
