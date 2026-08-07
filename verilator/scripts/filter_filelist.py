#!/usr/bin/env python3
"""Normalize Bender's Verilator list and remove known-incompatible DV files."""

import argparse
from pathlib import Path
import sys


EXCLUDED = {
    "pad_functional.sv",
    "apb_test.sv",
    "dmi_test.sv",
    "reqrsp_test.sv",
    "tcdm_test.sv",
    # Not reachable from magia_tb/magia_tile_tb (standalone snitch_icache
    # verification), but unlike the flat build, Verilator's hierarchical
    # child-block parsing does not lazily skip it and hits an unsupported
    # `##[min:max]` cycle-delay-range assertion (Plan 3, Step 6).
    "snitch_icache_l0_tb.sv",
}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()

    seen_sources = set()
    result = []
    for raw in sys.stdin:
        line = raw.rstrip()
        stripped = line.strip()
        if not stripped:
            continue
        if Path(stripped).name in EXCLUDED:
            continue
        if not stripped.startswith(("+", "-")):
            normalized = str(Path(stripped).resolve())
            if normalized in seen_sources:
                continue
            seen_sources.add(normalized)
            line = normalized
        result.append(line)

    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text("\n".join(result) + "\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
