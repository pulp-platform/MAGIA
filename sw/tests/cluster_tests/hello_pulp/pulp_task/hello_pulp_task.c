/*
 * Copyright (C) 2026 Fondazione Chips-IT
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * SPDX-License-Identifier: Apache-2.0
 *
 * Authors: Niccolò Giuliani, Fondazione Chips-IT
 */

/*
 * hello_pulp — PULP cluster-core task.
 *
 * Linked at 0x0 (PIC, ORIGIN=0) and embedded as .pulp_binary inside the
 * CV32 ELF (single-binary flow). The PULP cores boot here via crt0 and
 * stay in their dispatcher loop until the CV32 dispatches this function
 * with cluster_dispatch_task(HELLO_PULP_TASK, mask).
 *
 * The task is entered as `void hello_pulp_task(void *data)`; `data` is
 * whatever pointer the CV32 wrote to PULP_DATA (NULL here). When it
 * returns, the trap handler writes 1 to PULP_DONE and re-enters WFI.
 */

#include "magia_tile_utils.h"

static inline uint32_t get_hartid(void) {
    uint32_t hartid;
    asm volatile("csrr %0, mhartid"
                 :"=r"(hartid):);
    #ifndef RI5CY
        return hartid;
    #else
        // RI5CY mhartid CSR: { 21'b0, cluster_id_i[5:0], 1'b0, core_id_i[3:0] }
        //   cluster_id_i = mhartid_tile + 1  (which tile/cluster, 1-indexed; 0 = standalone main core)
        //   core_id_i    = i                 (which core within the cluster, 0-indexed)
        uint32_t cluster_id = (hartid >> 5) & 0x3F;  // = tile_hartid + 1 (same for all cores in a tile)
        uint32_t core_id    = hartid & 0xF;           // = i (unique per core within tile)
        //printf ("%d\n",PULP_HARTID_BASE + (cluster_id - 1) * PULP_CORE_COUNT + core_id);
        if (cluster_id == 0)
            return core_id;  // standalone main tile core
        return PULP_HARTID_BASE + (cluster_id - 1) * PULP_CORE_COUNT + core_id;
    #endif
}

void hello_pulp_task(void *data) {
    (void)data;

    uint32_t hartid   = get_hartid();
    uint32_t pulp_gid = hartid - PULP_HARTID_BASE;
    uint32_t local_id = pulp_gid % PULP_CORE_COUNT;
    uint32_t tile_id  = pulp_gid / PULP_CORE_COUNT;

    /* Only core 0 of each tile prints, to avoid interleaving on the
       shared per-tile UART peripheral at 0xFFFF0004. */
    if (local_id == 0)
        printf("[Tile %u PULP-%u mhartid %u] Hello World!\n",
               tile_id, local_id, hartid);
}
