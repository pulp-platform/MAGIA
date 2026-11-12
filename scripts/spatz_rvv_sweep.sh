#!/usr/bin/env bash
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
# SPDX-License-Identifier: Apache-2.0
#
# Author: Luca Balboni, Fondazione Chips-IT
#
# Instruction sweep of Spatz: runs the riscvTests of spatz_vpu (or the magia-sdk Spatz tests) on the standalone tile with Verilator.
#
# Usage: scripts/spatz_rvv_sweep.sh [-k rvv|sdk] [-j jobs] [-t timeout_s] [-o out_dir] [test ...]
#   Without tests it runs every riscvTest that spatz_vpu's CMakeLists registers, or with -k sdk
#   every test in magia-sdk/tests/spatz_on_magia (git submodule update --init magia-sdk).
#   Needs the tile model (make verilate mesh_dv=0), bender, riscv64-unknown-elf-gcc and the Spatz LLVM.
#   Results: <out_dir>/<test>/transcript and <out_dir>/summary.txt.
set -euo pipefail

ROOT=$(cd "$(dirname "$0")/.." && pwd)
JOBS=8
TIMEOUT_S=1800
KIND=rvv
OUT=

while getopts "k:j:t:o:" opt; do
  case "$opt" in
    k) KIND=$OPTARG ;;
    j) JOBS=$OPTARG ;;
    t) TIMEOUT_S=$OPTARG ;;
    o) OUT=$OPTARG ;;
    *) sed -n 17,22p "$0" >&2; exit 1 ;;
  esac
done
shift $((OPTIND - 1))

case "$KIND" in
  rvv) TEST=rvv_riscv_test; TEST_VAR=RVV_TEST ;;
  sdk) TEST=sdk_spatz_test; TEST_VAR=SDK_TEST ;;
  *) echo "error: -k is rvv or sdk" >&2; exit 1 ;;
esac
OUT=${OUT:-"$ROOT/sw/tests/spatz_tests/$TEST/sweep"}

cd "$ROOT"
BENDER=${BENDER:-bender}
RVV_TESTS_DIR=$($BENDER path spatz_vpu)/sw/riscvTests
SIM_BIN=${SIM_BIN:-"$ROOT/verilator/build-tile/obj_dir/Vmagia_tile_tb"}  # Override for another build dir
[[ -x "$SIM_BIN" ]] || { echo "error: no tile model at $SIM_BIN, run make verilate mesh_dv=0" >&2; exit 1; }

if [[ $# -gt 0 ]]; then
  TESTS=("$@")
elif [[ $KIND == sdk ]]; then
  mapfile -t TESTS < <(ls magia-sdk/tests/spatz_on_magia/*/main.c | xargs -n1 dirname | xargs -n1 basename)
else
  # fl_narrow: scalar FP8 loads of Spatz' smallfloat extension, which the CV32E40PX does not have
  mapfile -t TESTS < <(grep -oP 'add_snitch_test\(\s*\K[a-z0-9_]+' "$RVV_TESTS_DIR/CMakeLists.txt" | grep -vx fl_narrow)
fi

mkdir -p "$OUT"
rm -f "$OUT/summary.txt.tmp"
BUILT=()

# The Spatz headers and the build dir are shared by every test, so the builds go one at a time
for t in "${TESTS[@]}"; do
  if make -s clean all test="$TEST" "$TEST_VAR=$t" mesh_dv=0 > "$OUT/$t.build.log" 2>&1; then
    rm -rf "${OUT:?}/$t"
    mkdir -p "$OUT/$t"
    cp -r "$ROOT/sw/tests/spatz_tests/$TEST/build" "$OUT/$t/build"
    BUILT+=("$t")
  else
    echo "$t BUILD_FAIL" >> "$OUT/summary.txt.tmp"
  fi
done

run_one() {
  local t=$1
  cd "$OUT/$t"
  timeout -s INT "$TIMEOUT_S" "$SIM_BIN" \
    +INST_HEX=build/stim_instr.txt +DATA_HEX=build/stim_data.txt \
    +INST_ENTRY=0xC0000000 +DATA_ENTRY=0xC0008800 +BOOT_ADDR=0xC0000080 \
    +itb_file=build/verif.itb > transcript 2>&1 || true
  local verdict
  if bash "$ROOT/scripts/sim_ret_errors_verilator.sh" transcript > /dev/null; then
    verdict=PASS
  elif grep -qE "Spatz trapped|Spatz task FAILED with error: -" transcript; then
    verdict=TRAP
  elif grep -q "SIMULATION FINISHED" transcript; then
    verdict=FAIL
  else
    verdict=HANG
  fi
  echo "$t $verdict"
}
export -f run_one
export OUT ROOT SIM_BIN TIMEOUT_S

printf '%s\n' "${BUILT[@]}" | xargs -P "$JOBS" -I{} bash -c 'run_one {}' >> "$OUT/summary.txt.tmp"
sort "$OUT/summary.txt.tmp" > "$OUT/summary.txt"
rm -f "$OUT/summary.txt.tmp"

awk '{n[$2]++} END {for (v in n) printf "%s %d\n", v, n[v]}' "$OUT/summary.txt" | sort
echo "Details: $OUT/summary.txt"
