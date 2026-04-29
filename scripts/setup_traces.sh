#!/usr/bin/env bash
# setup_traces.sh — pre-simulation: create the per-tile trace directory tree.
#
# Makes the empty tree visible from the start of simulation:
#
#   <sim_dir>/traces/tile_N/main/       ← will receive CV32 main-core trace
#   <sim_dir>/traces/tile_N/cluster/    ← will receive PULP cores traces
#
# The actual trace files are moved in by sort_traces.sh after vsim exits
# (the cv32e40p tracer writes them to <sim_dir>/trace_core_<hartid>.log).
#
# Usage: setup_traces.sh <sim_dir> [num_clusters]

SIM_DIR=${1:-.}
NUM_CLUSTERS=${2:-16}

echo "[setup-traces] Creating ${NUM_CLUSTERS} tile dirs under ${SIM_DIR}/traces/"

for t in $(seq 0 $(( NUM_CLUSTERS - 1 ))); do
    mkdir -p "${SIM_DIR}/traces/tile_${t}/main" "${SIM_DIR}/traces/tile_${t}/cluster"
done

echo "[setup-traces] Done. Traces will be moved into place after simulation exits."
