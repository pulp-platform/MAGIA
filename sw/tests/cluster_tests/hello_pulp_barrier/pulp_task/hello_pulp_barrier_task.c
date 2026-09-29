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
 * hello_pulp_barrier - PULP cluster task: core 0 forks a barrier-only entry onto all cores
 */

#include "magia_tile_utils.h"
#include "cluster_utils.h"

static inline uint32_t get_hartid(void) {
    uint32_t hartid;
    asm volatile("csrr %0, mhartid"
                 :"=r"(hartid):);
    return hartid;
}

/* Runs on every core: just the barrier rendez-vous */
static void barrier_entry(void *arg) {
    (void)arg;
    pi_cl_team_barrier();
}

void hello_pulp_barrier_task(void *data) {
    (void)data;

    uint32_t hartid   = get_hartid();
    uint32_t local_id = pi_core_id();       /* pulp-sdk-compatible, cluster_utils.h */
    uint32_t tile_id  = cluster_tile_id();  /* MAGIA multi-tile extension, no pulp-sdk equivalent */

    printf("[Tile %u PULP-%u mhartid %u] Hello World!\n",
           tile_id, local_id, hartid);

    printf("[Tile %u PULP-%u mhartid %u] Starting cluster-wide Barrier (%d cores)\n",
           tile_id, local_id, hartid, PULP_CORE_COUNT);

    /* pi_cl_team_fork() programs the barrier masks: it returns once every core has reached the barrier */
    pi_cl_team_fork(PULP_CORE_COUNT, barrier_entry, NULL);

    printf("[Tile %u PULP-%u mhartid %u] Barrier Complete\n",
           tile_id, local_id, hartid);
}
