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
 */

/*
 * heterogeneous_mesh_test - PULP cluster-core task.
 *
 * Each core sums its own tiny slice and writes it to a per-tile L2 slot, so
 * every cluster tile stays in a disjoint region with no cross-tile race.
 * On return the trap handler sets PULP_DONE.
 *
 * The address map MUST match main.c.
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "cluster_utils.h"

#define CHUNK          8u                     /* elements summed per core    */
#define RESULT_BASE    (L2_BASE + 0x00080000)
#define RESULT_STRIDE  (0x00000100)           /* 256 B per tile (>= 8 slots) */

void heterogeneous_cluster_task(void *data) {
    (void)data;

    uint32_t tile_id  = cluster_tile_id();
    uint32_t local_id = cluster_core_id();

    /* Expected = CHUNK*local_id + (0+1+...+CHUNK-1). */
    uint32_t acc = 0;
    for (uint32_t i = 0; i < CHUNK; i++)
        acc += local_id + i;

    mmio32(RESULT_BASE + tile_id * RESULT_STRIDE + 4 * local_id) = acc;
}
