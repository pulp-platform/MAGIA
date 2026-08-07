#!/usr/bin/env python3
"""Verify the configured reusable tile specializations in a hierarchy plan.

Parses the authoritative `VM_HIER_LIBS` manifest in the generated
`V<top>_hier.mk` (one `<dir>/lib<mangledName>.a` entry per specialization
Verilator actually built), not raw text occurrences of the module name,
which can appear many times in unrelated prerequisites/commands.
"""

import argparse
from pathlib import Path
import re


def parse_hier_libs(text):
    match = re.search(r"^VM_HIER_LIBS\s*:=\s*\\\n((?:.*\\\n)*)", text, re.MULTILINE)
    if not match:
        return []
    names = []
    for line in match.group(1).splitlines():
        m = re.search(r"lib([A-Za-z0-9_]+)\.a", line)
        if m:
            names.append(m.group(1))
    return names


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("hier_makefile", type=Path)
    parser.add_argument("--module", default="magia_tile_hier")
    parser.add_argument("--expected-count", type=int, default=1)
    args = parser.parse_args()

    if args.expected_count < 1:
        raise SystemExit("--expected-count must be a positive integer")

    if not args.hier_makefile.is_file():
        raise SystemExit(f"hierarchy makefile not found: {args.hier_makefile}")

    text = args.hier_makefile.read_text()
    lib_names = parse_hier_libs(text)
    if not lib_names:
        raise SystemExit(
            f"no VM_HIER_LIBS entries found in {args.hier_makefile}; "
            "hierarchical Verilation did not build any hier_block library "
            "(the control file's hier_block directive may not have taken effect)"
        )

    module_names = sorted({n for n in lib_names if n.startswith(args.module)})
    if not module_names:
        raise SystemExit(
            f"no specialization of '{args.module}' found; built libraries: "
            + ", ".join(sorted(set(lib_names)))
        )
    if len(module_names) != args.expected_count:
        raise SystemExit(
            f"expected {args.expected_count} specialization(s) of "
            f"'{args.module}', found {len(module_names)}: "
            + ", ".join(module_names)
        )

    other_names = sorted({n for n in lib_names if not n.startswith(args.module)})
    if other_names:
        raise SystemExit(
            "unexpected additional hier_block librar"
            + ("y" if len(other_names) == 1 else "ies")
            + " besides '"
            + args.module
            + "': "
            + ", ".join(other_names)
        )

    if not re.search(r"^hier_build:\s*\$\(VM_HIER_LIBS\)", text, re.MULTILINE):
        raise SystemExit("hier_build does not depend on VM_HIER_LIBS")

    print("hierarchy check passed: " + ", ".join(module_names))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
