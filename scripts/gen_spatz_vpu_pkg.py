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
# Generate spatz_pkg.sv for the spatz_vpu dependency from a Spatz configuration of MAGIA.
#
# The Spatz parameters live only in hw/mesh/magia_pkg.sv, as spatz_cfg_t localparams
# (MagiaSpatzDefaultCfg, ...). The Makefile selects one with --cfg.
#
# spatz_vpu ships a spatz_pkg.sv pre-generated from its own hjson config (RVD=1, VLEN=512).
# This script renders spatz_vpu's own template (hw/src/spatz_pkg.sv.tpl) with the selected
# configuration, the same way spatz_vpu's util/apply_cfg.py does, and writes the result inside
# MAGIA. The Makefile then swaps it into the compile script in place of the spatz_vpu one, so
# nothing is changed in spatz_vpu. With --out-mk it also writes the SPATZ_* make variables of
# the same configuration, used by the Spatz SW build.

import argparse
import re
import sys
from pathlib import Path
from types import SimpleNamespace

from mako.template import Template


def parse_isa(isa):
    # Same result as spatz_vpu util/isa.py parse_isa_string (which needs Python >= 3.7)
    flags = SimpleNamespace(i=False, e=False, m=False, a=False, f=False, d=False)
    if not isa.startswith("rv32") or len(isa) < 5 or isa[4] not in "ie":
        raise ValueError("Illegal ISA string: " + isa)
    for ext in isa[4:]:
        if ext not in "iemafd":
            raise ValueError("Illegal ISA string: " + isa)
        setattr(flags, ext, True)
    return flags


# spatz_cfg_t fields that must be present in the selected configuration
REQUIRED_FIELDS = ("RVD", "RVF", "RVV", "NumIPU", "NumFPU", "NumPorts", "XDivSqrt", "XDMA", "VLEN")


def parse_sv_int(text):
    # SystemVerilog integer literal: 8, 1'b0, 32'h0002_0000, 'd4
    text = text.strip().replace("_", "")
    m = re.fullmatch(r"(?:\d*)'([sS]?)([bBoOdDhH])([0-9a-fA-F]+)", text)
    if m:
        return int(m.group(3), {"b": 2, "o": 8, "d": 10, "h": 16}[m.group(2).lower()])
    if re.fullmatch(r"\d+", text):
        return int(text)
    raise ValueError(text)


def read_spatz_cfg(pkg_path, name):
    # Read the localparam spatz_cfg_t <name> = '{ Field: value, ... }; of magia_pkg.sv
    text = Path(pkg_path).read_text()
    text = re.sub(r"/\*.*?\*/", "", text, flags=re.S)
    text = re.sub(r"//[^\n]*", "", text)
    m = re.search(r"localparam\s+spatz_cfg_t\s+" + re.escape(name) + r"\s*=\s*'\{(.*?)\}\s*;",
                  text, re.S)
    if not m:
        found = re.findall(r"localparam\s+spatz_cfg_t\s+(\w+)", text)
        sys.exit("gen_spatz_vpu_pkg: spatz_cfg_t {} not found in {} (available: {})".format(
            name, pkg_path, ", ".join(found) or "none"))
    cfg = {}
    for item in m.group(1).split(","):
        if not item.strip():
            continue
        field, sep, value = item.partition(":")
        if not sep:
            sys.exit("gen_spatz_vpu_pkg: {}: cannot parse '{}'".format(name, item.strip()))
        try:
            cfg[field.strip()] = parse_sv_int(value)
        except ValueError:
            sys.exit("gen_spatz_vpu_pkg: {}.{} = '{}' is not an integer literal".format(
                name, field.strip(), value.strip()))
    missing = [f for f in REQUIRED_FIELDS if f not in cfg]
    if missing:
        sys.exit("gen_spatz_vpu_pkg: {} lacks field(s) {}".format(name, ", ".join(missing)))
    return cfg


def write_if_changed(path, content):
    # Rewrite only on change, so an unchanged configuration does not trigger a rebuild
    out = Path(path)
    if out.is_file() and out.read_text() == content:
        return False
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(content)
    return True


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--magia-pkg", required=True, help="MAGIA magia_pkg.sv")
    parser.add_argument("--cfg", required=True,
                        help="spatz_cfg_t localparam of magia_pkg.sv (e.g. MagiaSpatzDefaultCfg)")
    parser.add_argument("--vpu-dir", help="spatz_vpu checkout (bender path spatz_vpu), needed by --out")
    parser.add_argument("--out", help="Output spatz_pkg.sv")
    parser.add_argument("--out-mk", help="Output makefile fragment with the SPATZ_* variables")
    parser.add_argument("--mk-prefix", default="SPATZ_",
                        help="Prefix of the variables written by --out-mk (default: SPATZ_)")
    parser.add_argument("--double-bw", type=int, choices=(0, 1), default=0, help="Double VLSU bandwidth")
    parser.add_argument("--scalar-fpu", type=int, choices=(0, 1), default=0,
                        help="SCALAR_FPU_SUPPORT (scalar FP executed by Spatz' FPU sequencer)")
    args = parser.parse_args()

    if not args.out and not args.out_mk:
        parser.error("nothing to do: give --out and/or --out-mk")
    if args.out and not args.vpu_dir:
        parser.error("--out requires --vpu-dir")

    c = read_spatz_cfg(args.magia_pkg, args.cfg)
    vlen, n_fpu, n_ipu, nports = c["VLEN"], c["NumFPU"], c["NumIPU"], c["NumPorts"]
    rvf, rvd = c["RVF"], c["RVD"]

    where = "{} in {}".format(args.cfg, args.magia_pkg)
    if rvd and not rvf:
        sys.exit("gen_spatz_vpu_pkg: {}: RVD=1 requires RVF=1".format(where))
    if n_fpu < 1 or n_ipu < 1:
        sys.exit("gen_spatz_vpu_pkg: {}: NumFPU and NumIPU must be at least 1".format(where))
    if nports % n_fpu:
        sys.exit("gen_spatz_vpu_pkg: {}: NumPorts must be a multiple of NumFPU "
                 "(NumVLSUInterfaces = NumPorts / NumFPU)".format(where))

    if args.out_mk:
        mk = "# Generated by MAGIA scripts/gen_spatz_vpu_pkg.py from {} -- do not edit.\n".format(where)
        for var, field in (("RVD", "RVD"), ("RVF", "RVF"), ("RVV", "RVV"), ("VLEN", "VLEN"),
                           ("N_IPU", "NumIPU"), ("N_FPU", "NumFPU"), ("XDIVSQRT", "XDivSqrt"),
                           ("XDMA", "XDMA")):
            mk += "{}{} := {}\n".format(args.mk_prefix, var, c[field])
        if write_if_changed(args.out_mk, mk):
            print("gen_spatz_vpu_pkg: wrote {} ({})".format(args.out_mk, args.cfg))

    if not args.out:
        return

    template_path = Path(args.vpu_dir) / "hw" / "src" / "spatz_pkg.sv.tpl"
    if not template_path.is_file():
        sys.exit("gen_spatz_vpu_pkg: template not found: {}".format(template_path))

    isa = "rv32ima" + ("f" if rvf else "") + ("d" if rvd else "")
    cfg = {
        "mempool": 0,
        "vlen": vlen,
        "n_fpu": n_fpu,
        "n_ipu": n_ipu,
        "spatz_fpu": True,
        "isa": isa,
        "spatz_nports": nports,
        "double_bw": bool(args.double_bw),
        "buf_fpu": 1,
        "divsqrt_is_shared": 1,  # spatz_vpu default (util/import_cfg.py)
        "cores": [{"isa_parsed": parse_isa(isa)}],
    }

    rendered = Template(template_path.read_text()).render(cfg=cfg)

    # spatz.sv uses SCALAR_FPU_SUPPORT, but the template lacks it (it was added by hand
    # to spatz_vpu's generated pkg): insert it after the FPU flag unless the template has it
    if "SCALAR_FPU_SUPPORT" not in rendered:
        anchor = "  localparam bit FPU            = N_FPU != 0;\n"
        if anchor not in rendered:
            sys.exit("gen_spatz_vpu_pkg: cannot place SCALAR_FPU_SUPPORT, template layout changed")
        rendered = rendered.replace(
            anchor, anchor + "  localparam bit SCALAR_FPU_SUPPORT = {};\n".format(args.scalar_fpu), 1)

    header = (
        "// Generated by MAGIA scripts/gen_spatz_vpu_pkg.py from {} -- do not edit.\n"
        "// cfg={} ({})\n"
        "// isa={} vlen={} n_fpu={} n_ipu={} nports={} double_bw={} scalar_fpu={}\n"
    ).format(template_path, args.cfg, args.magia_pkg, isa, vlen, n_fpu, n_ipu, nports,
             args.double_bw, args.scalar_fpu)

    if write_if_changed(args.out, header + rendered):
        print("gen_spatz_vpu_pkg: wrote {} ({}: {}, VLEN={}, N_FPU={})".format(
            args.out, args.cfg, isa, vlen, n_fpu))
    else:
        print("gen_spatz_vpu_pkg: {} up to date ({})".format(args.out, args.cfg))


if __name__ == "__main__":
    main()
