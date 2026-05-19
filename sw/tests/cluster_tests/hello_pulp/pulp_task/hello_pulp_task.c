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
 * hello_pulp — PULP cluster-core binary.
 *
 * This ELF is linked at 0xC0000000 and executed by the PULP cluster
 * cores of each tile (mhartid 32..159).
 *
 * On return, crt0 writes 1 to CLUSTER_DONE (tile CSR 0x1744) and
 * parks the core.
 */

#include "magia_tile_utils.h"

static inline uint32_t get_mhartid(void) {
    uint32_t id;
    asm volatile("csrr %0, mhartid" : "=r"(id));
    return id;
}

int main(void) {
    uint32_t hartid   = get_mhartid();
    uint32_t pulp_gid = hartid - PULP_HARTID_BASE;
    uint32_t local_id = pulp_gid % PULP_CORE_COUNT;
    uint32_t tile_id  = pulp_gid / PULP_CORE_COUNT;

    /* Only core 0 of each tile prints, to avoid interleaving on the
       shared per-tile UART peripheral at 0xFFFF0004. */
    if (local_id == 0)
        printf("[Tile %u PULP-%u mhartid %u] Hello World!\n",
               tile_id, local_id, hartid);

    return 0;
}
