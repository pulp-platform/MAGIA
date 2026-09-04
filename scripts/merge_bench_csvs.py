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
# Merges every per-kernel sw/tests/cluster_tests/benchmarks/results/
# <kernel>_MAGIA_CL_8.csv (written by scripts/magia_bench_runner.py) into
# one combined CSV, prefixing each row with the kernel name (parsed back
# out of the filename) so rows from different kernels stay identifiable
# once merged. All per-kernel CSVs share the same column set (core id +
# the HPM stats from sw/utils/stats.h); a kernel whose columns differ from
# the first file's is reported and skipped rather than silently
# corrupting the merge.
#
# Usage:
#   python3 scripts/merge_bench_csvs.py
#   python3 scripts/merge_bench_csvs.py --results-dir sw/tests/cluster_tests/benchmarks/results
#   python3 scripts/merge_bench_csvs.py -o /tmp/all_benchmarks.csv

import argparse
import csv
import os
import re
import sys

NUM_CORES = 8
SUFFIX = f"_MAGIA_CL_{NUM_CORES}.csv"


def parse_args():
    parser = argparse.ArgumentParser(
        description="Merge every <kernel>_MAGIA_CL_8.csv in --results-dir into one combined CSV."
    )
    script_dir = os.path.dirname(os.path.abspath(__file__))
    repo_root = os.path.abspath(os.path.join(script_dir, ".."))
    default_results_dir = os.path.join(
        repo_root, "sw", "tests", "cluster_tests", "benchmarks", "results"
    )
    parser.add_argument(
        "--results-dir", default=default_results_dir,
        help=f"Directory holding the per-kernel CSVs (default: {default_results_dir})."
    )
    parser.add_argument(
        "-o", "--output", default=None,
        help="Path of the merged CSV (default: <results-dir>/all_benchmarks_MAGIA_CL_8.csv)."
    )
    return parser.parse_args()


def main():
    args = parse_args()
    results_dir = args.results_dir
    output_path = args.output or os.path.join(results_dir, f"all_benchmarks_MAGIA_CL_{NUM_CORES}.csv")

    if not os.path.isdir(results_dir):
        print(f"Error: results dir not found: {results_dir}")
        sys.exit(1)

    csv_files = sorted(
        f for f in os.listdir(results_dir)
        if f.endswith(SUFFIX) and f != os.path.basename(output_path)
    )
    if not csv_files:
        print(f"No *{SUFFIX} files found in {results_dir}")
        sys.exit(1)

    fieldnames = None
    merged_rows = []
    skipped = []

    for filename in csv_files:
        kernel_name = filename[: -len(SUFFIX)]
        path = os.path.join(results_dir, filename)
        with open(path, newline="") as csvfile:
            reader = csv.DictReader(csvfile)
            rows = list(reader)
            if not rows:
                print(f"Warning: {filename} has no data rows, skipping.")
                continue
            if fieldnames is None:
                fieldnames = reader.fieldnames
            elif reader.fieldnames != fieldnames:
                print(f"Warning: {filename} has columns {reader.fieldnames}, "
                      f"expected {fieldnames}; skipping.")
                skipped.append(kernel_name)
                continue
            for row in rows:
                merged_rows.append({"test": kernel_name, **row})

    if not merged_rows:
        print("Nothing to merge.")
        sys.exit(1)

    out_fieldnames = ["test"] + list(fieldnames)
    with open(output_path, "w", newline="") as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=out_fieldnames, lineterminator="\n")
        writer.writeheader()
        writer.writerows(merged_rows)

    print(f"Merged {len(csv_files) - len(skipped)} kernel CSV(s), "
          f"{len(merged_rows)} rows, into {output_path}")
    if skipped:
        print(f"Skipped (column mismatch): {', '.join(skipped)}")


if __name__ == "__main__":
    main()
