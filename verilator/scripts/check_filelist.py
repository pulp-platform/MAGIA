#!/usr/bin/env python3
"""Fail early when the normalized Verilator input list is inconsistent."""

import argparse
from collections import Counter
from pathlib import Path


UNSUPPORTED = {
    "pad_functional.sv",
    "apb_test.sv",
    "dmi_test.sv",
    "reqrsp_test.sv",
    "tcdm_test.sv",
    "snitch_icache_l0_tb.sv",
}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("filelist", type=Path)
    parser.add_argument("--top", required=True)
    parser.add_argument("--dpi", action="append", default=[])
    args = parser.parse_args()

    lines = [line.strip() for line in args.filelist.read_text().splitlines()]
    sources = [line for line in lines if line and not line.startswith(("+", "-"))]
    errors = []

    duplicates = [path for path, count in Counter(sources).items() if count > 1]
    if duplicates:
        errors.append("duplicate source paths: " + ", ".join(duplicates))
    bad = [path for path in sources if Path(path).name in UNSUPPORTED]
    if bad:
        errors.append("unsupported verification sources: " + ", ".join(bad))
    if not any(Path(path).name == f"{args.top}.sv" for path in sources):
        errors.append(f"top source {args.top}.sv is missing")
    missing_files = [path for path in sources if not Path(path).is_file()]
    if missing_files:
        errors.append("missing source files: " + ", ".join(missing_files))
    for dpi in args.dpi:
        resolved = str(Path(dpi).resolve())
        if resolved not in sources:
            errors.append(f"DPI source is missing from file list: {resolved}")

    if errors:
        raise SystemExit("file-list check failed:\n  " + "\n  ".join(errors))
    print(f"file-list check passed: {len(sources)} unique sources, top={args.top}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
