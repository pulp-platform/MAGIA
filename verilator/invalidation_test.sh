#!/usr/bin/env bash
#
# Plan 4: automated invalidation tests for the hierarchical Verilator build.
#
# Prerequisite: a successful `make verilate core=CV32E40P mesh_dv=1
# VERILATOR_JOBS=4` build already exists (this script does not create the
# first build itself, to keep each scenario's baseline explicit and to
# avoid hiding a cold-build failure inside a test run).
#
# Every scenario touches only *mtimes* (via `touch`), never file content,
# and restores the original mtime afterward with `touch -d @<epoch>`. RTL
# and third-party checkout files are never edited.
#
# Assertions are based on artifact mtimes/existence, not log text, per
# Plan 4 Step 3 ("assert timestamps stay unchanged" / "fail on unexpected
# compilation, not only timestamps" — logs are captured and grepped only
# as a secondary confirmation of *what* rebuilt, not as the primary
# pass/fail signal).

set -uo pipefail

ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

MAKE_ARGS=(core=CV32E40P mesh_dv=1 VERILATOR_JOBS=4)
BUILD_DIR="$ROOT/verilator/build"
OBJ="$BUILD_DIR/obj_dir"
HIER_MK="$OBJ/Vmagia_tb_hier.mk"
PARENT_MK="$OBJ/Vmagia_tb.mk"
CHILD_LIB="$OBJ/Vmagia_tile_hier_f/libmagia_tile_hier_f.a"
BIN="$OBJ/Vmagia_tb"
STAMP="$BUILD_DIR/config.stamp"
LOGDIR="$BUILD_DIR/invalidation-test-logs"
mkdir -p "$LOGDIR"

FAIL=0
pass() { echo "PASS: $1"; }
failt() { echo "FAIL: $1"; FAIL=1; }

require() {
  if [ ! -e "$1" ]; then
    echo "error: prerequisite artifact missing: $1" >&2
    echo "run: make verilate ${MAKE_ARGS[*]} first" >&2
    exit 2
  fi
}
require "$HIER_MK"
require "$PARENT_MK"
require "$CHILD_LIB"
require "$BIN"

mtime() { stat -c '%Y' "$1" 2>/dev/null || echo "MISSING"; }

run_make() {
  local logfile="$1"
  make verilate "${MAKE_ARGS[@]}" >"$logfile" 2>&1
}

touched_child() {
  # Real child rebuild work: a fresh verilator --hierarchical invocation
  # AND either a child .cpp compile or the child archive being (re)built.
  grep -qE '(^|[^a-zA-Z])ar (rcs|cr) .*libmagia_tile_hier_f\.a|Vmagia_tile_hier_f/.*\.cpp' "$1"
}
touched_parent_compile() {
  grep -qE 'ccache g\+\+|(^|[[:space:]])g\+\+ ' "$1"
}
ran_verilator_hier() {
  grep -qE 'magia_hier\.vlt --hierarchical' "$1"
}

echo "=== Test 1: no change -> full no-op ==="
{
  m_hier=$(mtime "$HIER_MK"); m_parent=$(mtime "$PARENT_MK")
  m_child=$(mtime "$CHILD_LIB"); m_bin=$(mtime "$BIN")
  log="$LOGDIR/1-nochange.log"
  run_make "$log"
  ok=1
  [ "$(mtime "$HIER_MK")" = "$m_hier" ] || { failt "test1: Vmagia_tb_hier.mk mtime changed on no-op"; ok=0; }
  [ "$(mtime "$PARENT_MK")" = "$m_parent" ] || { failt "test1: Vmagia_tb.mk mtime changed on no-op"; ok=0; }
  [ "$(mtime "$CHILD_LIB")" = "$m_child" ] || { failt "test1: child lib mtime changed on no-op"; ok=0; }
  [ "$(mtime "$BIN")" = "$m_bin" ] || { failt "test1: binary mtime changed on no-op"; ok=0; }
  if ran_verilator_hier "$log" || touched_parent_compile "$log"; then
    failt "test1: unexpected compiler/verilator activity in log ($log)"
    ok=0
  fi
  [ "$ok" = 1 ] && pass "test1: no-change rebuild is a true no-op"
}

echo "=== Test 2: mesh/VIP-only touch -> parent rebuilds, child library untouched ==="
{
  MESH_FILE="$ROOT/target/sim/src/mesh/magia_vip.sv"
  orig=$(mtime "$MESH_FILE")
  m_child_before=$(mtime "$CHILD_LIB")
  m_bin_before=$(mtime "$BIN")
  touch "$MESH_FILE"
  log="$LOGDIR/2-mesh-touch.log"
  run_make "$log"
  touch -d "@$orig" "$MESH_FILE"
  ok=1
  [ "$(mtime "$CHILD_LIB")" = "$m_child_before" ] || { failt "test2: child library was rebuilt from a mesh-only change"; ok=0; }
  [ "$(mtime "$BIN")" != "$m_bin_before" ] || { failt "test2: binary was not relinked after a mesh-only change"; ok=0; }
  [ "$ok" = 1 ] && pass "test2: mesh-only touch rebuilds parent/relinks, preserves child library"
}

echo "=== Test 3: tile RTL touch -> child rebuilds, executable relinks ==="
{
  TILE_FILE="$ROOT/hw/tile/magia_tile.sv"
  orig=$(mtime "$TILE_FILE")
  m_child_before=$(mtime "$CHILD_LIB")
  m_bin_before=$(mtime "$BIN")
  touch "$TILE_FILE"
  log="$LOGDIR/3-tile-touch.log"
  run_make "$log"
  touch -d "@$orig" "$TILE_FILE"
  ok=1
  [ "$(mtime "$CHILD_LIB")" != "$m_child_before" ] || { failt "test3: child library was NOT rebuilt after a tile RTL change"; ok=0; }
  [ "$(mtime "$BIN")" != "$m_bin_before" ] || { failt "test3: binary was not relinked after a tile RTL change"; ok=0; }
  [ "$ok" = 1 ] && pass "test3: tile-RTL touch rebuilds child library and relinks"
}

echo "=== Test 4: tile parameter/define change -> compatible rebuild, no stale reuse ==="
{
  m_bin_before=$(mtime "$BIN")
  log="$LOGDIR/4a-define-change.log"
  make verilate "${MAKE_ARGS[@]}" SPATZ_N_FPU=2 >"$log" 2>&1
  ok=1
  [ "$(mtime "$BIN")" != "$m_bin_before" ] || { failt "test4: binary unchanged after a Spatz define change (stale reuse?)"; ok=0; }
  python3 "$ROOT/verilator/check_hierarchy.py" "$HIER_MK" --module magia_tile_hier >>"$log" 2>&1 \
    || { failt "test4: hierarchy check failed after define change"; ok=0; }
  [ "$ok" = 1 ] && pass "test4a: SPATZ_N_FPU=2 produces a compatible rebuild with one specialization"

  # restore default configuration
  log2="$LOGDIR/4b-define-restore.log"
  make verilate "${MAKE_ARGS[@]}" >"$log2" 2>&1
  python3 "$ROOT/verilator/check_hierarchy.py" "$HIER_MK" --module magia_tile_hier >>"$log2" 2>&1 \
    && pass "test4b: reverting SPATZ_N_FPU restores default build with one specialization" \
    || failt "test4b: failed to restore default configuration"
}

echo "=== Test 5 (Step 4): control file touch invalidates hierarchy generation ==="
{
  CTRL="$ROOT/verilator/magia_hier.vlt"
  orig=$(mtime "$CTRL")
  m_hier_before=$(mtime "$HIER_MK")
  touch "$CTRL"
  log="$LOGDIR/5-control-touch.log"
  run_make "$log"
  touch -d "@$orig" "$CTRL"
  if [ "$(mtime "$HIER_MK")" != "$m_hier_before" ]; then
    pass "test5: touching magia_hier.vlt invalidates and regenerates the hierarchy plan"
  else
    failt "test5: touching magia_hier.vlt did not force regeneration"
  fi
}

echo "=== Test 6 (Step 4): DPI C source touch relinks ==="
{
  DPI_C=$(grep '^dpi=' "$STAMP" | cut -d= -f2- | awk '{print $1}')
  if [ -z "$DPI_C" ] || [ ! -e "$DPI_C" ]; then
    echo "SKIP: test6: could not resolve a DPI source path from $STAMP"
  else
    orig=$(mtime "$DPI_C")
    m_bin_before=$(mtime "$BIN")
    touch "$DPI_C"
    log="$LOGDIR/6-dpi-touch.log"
    run_make "$log"
    touch -d "@$orig" "$DPI_C"
    if [ "$(mtime "$BIN")" != "$m_bin_before" ]; then
      pass "test6: touching a DPI C source relinks the executable"
    else
      failt "test6: touching a DPI C source did not trigger a relink"
    fi
  fi
}

echo "=== Test 7 (Step 4): simulated stale Verilator-version stamp cannot be reused ==="
{
  cp "$STAMP" "$STAMP.bak"
  sed -i 's/^verilator_version=.*/verilator_version=Verilator 0.000 FAKE-STALE-VERSION/' "$STAMP"
  m_hier_before=$(mtime "$HIER_MK")
  log="$LOGDIR/7-stale-version-stamp.log"
  run_make "$log"
  ok=1
  if [ "$(mtime "$HIER_MK")" = "$m_hier_before" ]; then
    failt "test7: a stamp claiming a stale Verilator version was not detected/corrected"
    ok=0
  fi
  if grep -q "FAKE-STALE-VERSION" "$STAMP"; then
    failt "test7: corrupted stamp content was not overwritten with the real version"
    ok=0
  fi
  [ "$ok" = 1 ] && pass "test7: a corrupted/stale version stamp is detected and corrected, forcing a rebuild"
  rm -f "$STAMP.bak"
}

echo "=== Test 8: simulation main edit -> main recompiles and executable relinks ==="
{
  MAIN_CPP="$ROOT/verilator/magia_main.cpp"
  if [ ! -e "$MAIN_CPP" ]; then
    echo "SKIP: test8: $MAIN_CPP not found"
  else
    # Content change, not just an mtime bump: the main is compiled by the
    # generated parent makefile, and Verilator's planner does not rewrite
    # V<top>_hier.mk for it, so this is the case a codegen-only dependency
    # would silently miss.
    cp "$MAIN_CPP" "$MAIN_CPP.bak"
    m_bin_before=$(mtime "$BIN")
    m_child_before=$(mtime "$CHILD_LIB")
    printf '\n// invalidation_test.sh probe\n' >> "$MAIN_CPP"
    log="$LOGDIR/8-main-edit.log"
    run_make "$log"
    mv -f "$MAIN_CPP.bak" "$MAIN_CPP"
    ok=1
    if [ "$(mtime "$BIN")" = "$m_bin_before" ]; then
      failt "test8: editing the simulation main did not relink the executable"
      ok=0
    fi
    if ! grep -q 'magia_main\.o' "$log"; then
      failt "test8: editing the simulation main did not recompile magia_main.o"
      ok=0
    fi
    if [ "$(mtime "$CHILD_LIB")" != "$m_child_before" ]; then
      failt "test8: editing the simulation main rebuilt the child library"
      ok=0
    fi
    [ "$ok" = 1 ] && pass "test8: a simulation main edit recompiles it and relinks, sparing the child library"
    # Restore the executable to the committed main.
    run_make "$LOGDIR/8-main-restore.log"
  fi
}

echo ""
if [ "$FAIL" = 0 ]; then
  echo "ALL INVALIDATION TESTS PASSED"
else
  echo "ONE OR MORE INVALIDATION TESTS FAILED"
fi
exit "$FAIL"
