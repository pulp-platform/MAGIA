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
 * Authors: Luca Balboni <luca.balboni@chips.it>
 * 
 *  hetero_mesh_test - PULP cluster-core task.
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "cluster_utils.h"

#define CHUNK          8u                    
#define RESULT_BASE    (L2_BASE + 0x00080000)
#define RESULT_STRIDE  (0x00000100)           

static void hetero_cluster_fork_entry(void *data) {
    (void)data;

    uint32_t tile_id  = cluster_tile_id();
    uint32_t local_id = cluster_core_id();

    /* Expected = CHUNK*local_id + (0+1+...+CHUNK-1). */
    uint32_t acc = 0;
    for (uint32_t i = 0; i < CHUNK; i++)
        acc += local_id + i;

    mmio32(RESULT_BASE + tile_id * RESULT_STRIDE + 4 * local_id) = acc;
}

void hetero_cluster_task(void *data) {
    pi_cl_team_fork(PULP_CORE_COUNT, hetero_cluster_fork_entry, data);
}
