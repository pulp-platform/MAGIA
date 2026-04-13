#!/usr/bin/env bash
# run_test_perf.sh
# Usage: ./run_test_perf.sh <test_name> [mesh_dv=0] [M=<val>] [N=<val>] [K=<val>]
#
# Runs build+sim for the given test, extracts RedMule and Spatz cycle counts
# from the QuestaSim transcript, and saves results in a CSV file under
#   sw/tests/<subdir>/<test_name>/performance/results.csv
#
# M, N, K override the matrix/vector dimensions at compile time.
# For 1-D tests (dotp/vecsum) only N is meaningful.
# Examples:
#   ./run_test_perf.sh matmul_spatz_perf
#   ./run_test_perf.sh matmul_spatz_perf 0 M=32 N=64 K=32
#   ./run_test_perf.sh dotp_spatz_perf   0 N=1024
#   ./run_test_perf.sh vecsum_redmule_perf 0 N=512

set -euo pipefail

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <test_name> [mesh_dv=0] [M=<val>] [N=<val>] [K=<val>]" >&2
    exit 1
fi

TEST_NAME="$1"
MESH_DV="${2:-0}"          # default: mesh_dv=0

# Parse optional M=, N=, K= arguments (any position from $3 onward)
M_VAL=""; N_VAL=""; K_VAL=""
for arg in "${@:3}"; do
    case "$arg" in
        M=*) M_VAL="${arg#M=}" ;;
        N=*) N_VAL="${arg#N=}" ;;
        K=*) K_VAL="${arg#K=}" ;;
        *)   echo "WARNING: unknown argument '$arg' ignored" >&2 ;;
    esac
done

# Build the FLAGS string to pass to make (appended to any existing FLAGS)
DIM_FLAGS=""
[[ -n "$M_VAL" ]] && DIM_FLAGS+="-DM_SIZE=${M_VAL} "
[[ -n "$N_VAL" ]] && DIM_FLAGS+="-DN_SIZE=${N_VAL} "
[[ -n "$K_VAL" ]] && DIM_FLAGS+="-DK_SIZE=${K_VAL} "

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# ---------------------------------------------------------------------------
# Locate the .c source file to determine the test subdirectory
# ---------------------------------------------------------------------------
TEST_DIR="sw/tests"
TEST_SRC="$(find "$TEST_DIR" -name "${TEST_NAME}.c" 2>/dev/null | head -1)"
if [[ -z "$TEST_SRC" ]]; then
    echo "ERROR: cannot find ${TEST_NAME}.c under ${TEST_DIR}" >&2
    exit 1
fi
TEST_SUBDIR="$(dirname "$TEST_SRC")"          # e.g. sw/tests/spatz_tests
TEST_BUILD_DIR="${TEST_SUBDIR}/${TEST_NAME}"  # e.g. sw/tests/spatz_tests/matmul_compare_spatz_test
TRANSCRIPT="${TEST_BUILD_DIR}/transcript"

echo "=== Test:        $TEST_NAME ==="
echo "=== Build dir:   $TEST_BUILD_DIR ==="
echo "=== mesh_dv:     $MESH_DV ==="
[[ -n "$DIM_FLAGS" ]] && echo "=== Dimensions:  $DIM_FLAGS ==="
echo ""

# ---------------------------------------------------------------------------
# Initialize Environment Modules (needed when running as a plain bash script)
# ---------------------------------------------------------------------------
MODULE_INIT=""
for _f in /usr/share/Modules/init/bash \
           /usr/local/Modules/init/bash \
           /etc/profile.d/modules.sh    \
           /opt/Modules/init/bash; do
    if [[ -f "$_f" ]]; then
        MODULE_INIT="$_f"
        break
    fi
done
if [[ -n "$MODULE_INIT" ]]; then
    # shellcheck disable=SC1090
    source "$MODULE_INIT"
elif command -v modulecmd &>/dev/null; then
    eval "$(modulecmd bash bash)"
else
    echo "WARNING: cannot initialize 'module' command; assuming it is already available" >&2
fi

# ---------------------------------------------------------------------------
# 1. Software build
# ---------------------------------------------------------------------------
echo "[1/2] Loading PULP GCC and compiling SW..."
module load pulp-gcc7/1.0.16
make clean all test="${TEST_NAME}" mesh_dv="${MESH_DV}" ${DIM_FLAGS:+FLAGS="${DIM_FLAGS}"}

# ---------------------------------------------------------------------------
# 2. Simulation run
# ---------------------------------------------------------------------------
echo "[2/2] Running simulation (gui=0)..."
make run test="${TEST_NAME}" mesh_dv="${MESH_DV}" gui=0

echo ""
echo "=== Simulation finished ==="

# ---------------------------------------------------------------------------
# 6. Parse transcript for cycle counts
# ---------------------------------------------------------------------------
if [[ ! -f "$TRANSCRIPT" ]]; then
    echo "ERROR: transcript not found at ${TRANSCRIPT}" >&2
    exit 1
fi

# QuestaSim prefixes printf output lines with "# " in the transcript.
# We match both prefixed and non-prefixed lines.
REDMULE_CYCLES="$(grep -oP '(?:# )?RedMule cycles:\s+\K[0-9]+' "$TRANSCRIPT" | tail -1 || true)"
SPATZ_CYCLES="$(grep -oP '(?:# )?Spatz cycles:\s+\K[0-9]+' "$TRANSCRIPT" | tail -1 || true)"

if [[ -z "$REDMULE_CYCLES" && -z "$SPATZ_CYCLES" ]]; then
    echo "WARNING: no cycle counts found in transcript. Check ${TRANSCRIPT}" >&2
fi

echo "RedMule cycles : ${REDMULE_CYCLES:-N/A}"
echo "Spatz   cycles : ${SPATZ_CYCLES:-N/A}"

# ---------------------------------------------------------------------------
# 7. Save results to CSV
# ---------------------------------------------------------------------------
# NOTE: CSV lives under results/ at the repo root so that
#       "make clean" (which removes the entire test build dir) never wipes it.
PERF_DIR="${SCRIPT_DIR}/results/${TEST_NAME}/performance"
mkdir -p "$PERF_DIR"
CSV_FILE="${PERF_DIR}/results.csv"

TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')"

# Write header if the file does not exist yet
if [[ ! -f "$CSV_FILE" ]]; then
    echo "timestamp,test,M,N,K,redmule_cycles,spatz_cycles" > "$CSV_FILE"
fi

echo "${TIMESTAMP},${TEST_NAME},${M_VAL:-},${N_VAL:-},${K_VAL:-},${REDMULE_CYCLES:-},${SPATZ_CYCLES:-}" >> "$CSV_FILE"

echo ""
echo "=== Performance results saved to: ${CSV_FILE} ==="
cat "$CSV_FILE"
