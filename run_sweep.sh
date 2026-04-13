#!/usr/bin/env bash
# run_sweep.sh
# Usage: ./run_sweep.sh [config_file] [mesh_dv]
#
# Reads a sweep config file and runs run_test_perf.sh for each entry.
# Default config: sweep_config.conf
# Default mesh_dv: 0
#
# Config format:
#   [test_name]      -> test to run (must match a .c under sw/tests/)
#   M=X N=Y K=Z     -> one run with those dimensions
#   # comment        -> ignored
#   blank line       -> ignored

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

CONFIG="${1:-sweep_config.conf}"
MESH_DV="${2:-0}"

if [[ ! -f "$CONFIG" ]]; then
    echo "ERROR: config file '$CONFIG' not found" >&2
    exit 1
fi

echo "=== Sweep config: $CONFIG ==="
echo "=== mesh_dv:      $MESH_DV ==="
echo ""

CURRENT_TEST=""
RUN_COUNT=0
FAIL_COUNT=0
PASS_COUNT=0
declare -a FAILED_RUNS=()

while IFS= read -r line || [[ -n "$line" ]]; do
    # Strip leading/trailing whitespace
    line="${line#"${line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"

    # Skip blank lines and comments
    [[ -z "$line" || "$line" == \#* ]] && continue

    # Section header: [test_name]
    if [[ "$line" =~ ^\[(.+)\]$ ]]; then
        CURRENT_TEST="${BASH_REMATCH[1]}"
        echo "--- Test: $CURRENT_TEST ---"
        continue
    fi

    # Dimension line: M=X N=Y K=Z (any combination)
    if [[ -n "$CURRENT_TEST" ]]; then
        # Parse each token as a dimension arg
        DIMS=()
        for token in $line; do
            [[ "$token" =~ ^[MNK]=[0-9]+$ ]] && DIMS+=("$token")
        done

        if [[ ${#DIMS[@]} -eq 0 ]]; then
            echo "WARNING: unrecognised line: '$line' (skipping)" >&2
            continue
        fi

        RUN_COUNT=$((RUN_COUNT + 1))
        DIM_STR="${DIMS[*]}"
        echo "[Run $RUN_COUNT] $CURRENT_TEST  $DIM_STR"

        if bash "$SCRIPT_DIR/run_test_perf.sh" "$CURRENT_TEST" "$MESH_DV" "${DIMS[@]}"; then
            PASS_COUNT=$((PASS_COUNT + 1))
        else
            FAIL_COUNT=$((FAIL_COUNT + 1))
            FAILED_RUNS+=("$CURRENT_TEST  $DIM_STR")
            echo "WARNING: run failed, continuing sweep..." >&2
        fi
        echo ""
    else
        echo "WARNING: dimension line before any [test] header: '$line' (skipping)" >&2
    fi
done < "$CONFIG"

echo "=============================================="
echo "  Sweep complete: $PASS_COUNT passed, $FAIL_COUNT failed out of $RUN_COUNT runs"
if [[ ${#FAILED_RUNS[@]} -gt 0 ]]; then
    echo "  Failed runs:"
    for r in "${FAILED_RUNS[@]}"; do
        echo "    - $r"
    done
fi
echo "=============================================="
