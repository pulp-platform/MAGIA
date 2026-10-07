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
 * hello_spatz_pulp — PULP cluster-core task.
 *
 * Core 0 forks hello_spatz_pulp_fork_entry onto all 8 cores with pi_cl_team_fork().
 * Each core sums its slice of Z (Spatz output, 3.0 FP16 = 0x4200) as raw uint16 into its L2 slot.
 * Core 0 then returns the grand total through PULP_RETURN.
 *
 * Memory layout (shared with main.c):
 *   Z_BASE      = L1_BASE + 0x00002000   (256 FP16 elements, Spatz output)
 *   RESULT_BASE = L2_BASE + 0x00060000   (8 x uint32, one per cluster core)
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "cluster_utils.h"

#define VLEN        256
#define Z_BASE      (L1_BASE + 0x00002000)
#define RESULT_BASE (L2_BASE + 0x00060000)

static void hello_spatz_pulp_fork_entry(void *data) {
    (void)data;

    uint32_t local_id = cluster_core_id();
    uint32_t chunk    = VLEN / PULP_CORE_COUNT;   /* 32 elements per core */
    uint32_t start    = local_id * chunk;

    /* Sum raw FP16 bit-patterns in this core's slice of Z. */
    uint32_t partial_sum = 0;
    for (uint32_t i = start; i < start + chunk; i++)
        partial_sum += mmio16(Z_BASE + 2 * i);

    /* Write result to per-core L2 slot. */
    mmio32(RESULT_BASE + 4 * local_id) = partial_sum;

    if (local_id == 0)
        printf("[PULP core 0] partial_sum=0x%08x\n", partial_sum);
}

int hello_spatz_pulp_task(void *data) {
    pi_cl_team_fork(PULP_CORE_COUNT, hello_spatz_pulp_fork_entry, data);

    /* The fork's barrier guarantees every core has written its partial */
    uint32_t grand_total = 0;
    for (int i = 0; i < PULP_CORE_COUNT; i++) {
        grand_total += mmio32(RESULT_BASE + 4 * i);
    }
    return (int)grand_total;
}
