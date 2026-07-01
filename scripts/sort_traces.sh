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
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-License-Identifier: Apache-2.0
#
# Authors: Niccolò Giuliani, Fondazione Chips-IT

# sort_traces.sh — distribute per-core trace files into per-tile subdirectories.
#
# Usage: sort_traces.sh <sim_dir> [num_clusters] [pulp_core_count]
#
# For a 4x4 MAGIA mesh:
#   - Main core of tile N  → mhartid = N          (0x00..0x0F)
#   - PULP core C of tile N → mhartid = 2*N_TILES + N*PULP_CORE_COUNT + C
#
# Result layout:
#   <sim_dir>/traces/tile_N/main/trace_core_XXXXXXXX.log
#   <sim_dir>/traces/tile_N/cluster/trace_core_XXXXXXXX.log

SIM_DIR=${1:-.}
NUM_CLUSTERS=${2:-16}
PULP_CORE_COUNT=${3:-8}

PULP_HARTID_BASE=$(( 2 * NUM_CLUSTERS ))

# Move or confirm a single trace file into its destination directory.
# Handles three cases robustly:
#   1. src is a dangling symlink            → remove it (file never written)
#   2. src is a symlink and already at dst  → remove the symlink (file already there)
#   3. src is a regular file                → mv it into dst/
place_trace() {
    local src="$1" dst_dir="$2" label="$3"
    local fname; fname=$(basename "${src}")
    local dst="${dst_dir}/${fname}"

    if [ -L "${src}" ]; then
        # Symlink left over from a previous run: remove it.
        # The real file is already inside traces/ (or was never written).
        rm -f "${src}"
        [ -f "${dst}" ] && echo "  ${label} → already in place (symlink cleaned)"
    elif [ -f "${src}" ]; then
        if [ "${src}" -ef "${dst}" ]; then
            # Same inode (hardlink edge-case): nothing to do.
            echo "  ${label} → already in place"
        else
            mv "${src}" "${dst_dir}/" && echo "  ${label} → $(basename "${dst_dir%/*}")/$(basename "${dst_dir}")/${fname}"
        fi
    fi
}

echo "[sort-traces] Sorting ${NUM_CLUSTERS} tiles x ${PULP_CORE_COUNT} PULP cores into ${SIM_DIR}/traces/"

for t in $(seq 0 $(( NUM_CLUSTERS - 1 ))); do
    MAIN_DIR="${SIM_DIR}/traces/tile_${t}/main"
    CLUSTER_DIR="${SIM_DIR}/traces/tile_${t}/cluster"
    mkdir -p "${MAIN_DIR}" "${CLUSTER_DIR}"

    # Main CV32 core (one per tile, mhartid = t)
    f=$(printf "%s/trace_core_%08x.log" "${SIM_DIR}" ${t})
    place_trace "${f}" "${MAIN_DIR}" "tile ${t} main"

    # PULP cluster cores (PULP_CORE_COUNT per tile)
    for c in $(seq 0 $(( PULP_CORE_COUNT - 1 ))); do
        h=$(( PULP_HARTID_BASE + t * PULP_CORE_COUNT + c ))
        f=$(printf "%s/trace_core_%08x.log" "${SIM_DIR}" ${h})
        place_trace "${f}" "${CLUSTER_DIR}" "tile ${t} core${c}"
    done
done

echo "[sort-traces] Done."
