#!/usr/bin/env bash
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
# Authors: Niccolò Giuliani, Fondazione Chips-IT

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
