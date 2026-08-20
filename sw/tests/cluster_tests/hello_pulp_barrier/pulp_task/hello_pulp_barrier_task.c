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
 * hello_pulp_barrier — PULP cluster-core task.
 *
 * CV32 dispatches to core 0 only, MAGIA's usual single-task mailbox
 * (pulp_crt0.S's dispatcher_loop); core 0 then forks a cluster-wide
 * rendez-vous onto all PULP_CORE_COUNT cores, exactly like vector_add_task.c
 * does for real work -- except here the forked entry does nothing but the
 * barrier itself: no partitioning, no per-core computation, just "get to
 * the barrier and wait" on every core.
 *
 * pi_cl_team_barrier() is a bare "block until trigger_mask == target_mask"
 * rendez-vous on Event Unit barrier 0 (see hw_barrier_unit.sv) -- it does
 * NOT program those masks itself. Both reset to 0, and barrier_matched is
 * gated by `trigger_mask_DP != '0`, so calling it before anyone has written
 * a non-zero mask blocks forever. pi_cl_team_fork() is what writes
 * trigger_mask = target_mask = the team's core mask before running the
 * entry function on every member core -- here PULP_CORE_COUNT cores, so
 * the barrier below is only satisfied once all 8 have arrived.
 */

#include "magia_tile_utils.h"
#include "pmsis.h"

static inline uint32_t get_hartid(void) {
    uint32_t hartid;
    asm volatile("csrr %0, mhartid"
                 :"=r"(hartid):);
    return hartid;
}

/* Runs on all PULP_CORE_COUNT cores (core 0 directly via pi_cl_team_fork(),
   cores 1-7 woken by its dispatch push, see pulp_crt0.S's worker_wait). No
   real work -- just the barrier rendez-vous. */
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

    /* Forks barrier_entry onto all PULP_CORE_COUNT cores: pi_cl_team_fork()
       writes trigger/target mask = full core mask, runs barrier_entry() on
       every core, then rendez-vouses itself -- only returns here once every
       core has hit its own pi_cl_team_barrier() above. */
    pi_cl_team_fork(PULP_CORE_COUNT, barrier_entry, NULL);

    printf("[Tile %u PULP-%u mhartid %u] Barrier Complete\n",
           tile_id, local_id, hartid);
}
