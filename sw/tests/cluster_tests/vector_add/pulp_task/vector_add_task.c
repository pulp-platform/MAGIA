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
 * vector_add — PLAY task wrapper for the MAGIA PULP cluster.
 *
 * PLAY (https://github.com/FondazioneChipsIT/PLAY) ships vector_add's
 * algorithm as two files: source/vector_add/vector_add.c (the public
 * vector_add() -> vector_add_impl() shim) and source/vector_add/arch/
 * vector_add_pulp_open.c (the PULP-cluster backend: #if CLUSTER selects
 * vector_add_pulp_open_cluster(), which partitions the vector by
 * pi_core_id() and closes with pi_cl_team_barrier() -- pulp-sdk/PMSIS
 * calls, backed here by cluster_utils.h's native reimplementation, no
 * pulp-sdk submodule involved).
 *
 * Neither file is modified; they're pulled in verbatim below (PLAY has no
 * standalone build for just the kernel sources, so this is a 2-file unity
 * build rather than a Makefile-level source list). What PLAY does NOT ship
 * is the fork itself: in PLAY's own test harness, main.c's cluster_entry()
 * calls pi_cl_team_fork(NUM_CORES, run_test, NULL) to fan run_test() (which
 * calls vector_add()) out to the team. We're not using PLAY's own harness
 * (it depends on PMSIS device-open ceremony MAGIA's bare-metal ctrl core
 * doesn't have), so that one fork call is reproduced here instead.
 *
 * Dispatched to cluster core 0 only, MAGIA's usual single-task mailbox
 * (pulp_crt0.S's dispatcher_loop); it forks the real work onto all 8 cores.
 */

#include "magia_tile_utils.h"
#include "cluster_utils.h"

#include "../../../../../PLAY/source/vector_add/vector_add.c"
#include "../../../../../PLAY/source/vector_add/arch/vector_add_pulp_open.c"

typedef struct {
    uint32_t src_a;
    uint32_t src_b;
    uint32_t dst;
    uint32_t len;
} vector_add_params_t;

static void vector_add_fork_entry(void *arg) {
    vector_add_params_t *p = (vector_add_params_t *)arg;
    vector_add((const float *)p->src_a, (const float *)p->src_b,
               (float *)p->dst, (int)p->len);
}

int vector_add_task(void *data) {
    vector_add_params_t *params = (vector_add_params_t *)data;
    pi_cl_team_fork(PULP_CORE_COUNT, vector_add_fork_entry, params);
    /* PLAY's vector_add() has no error/exit code of its own; the golden
     * comparison against PLAY's expected[] happens on the CV32 side
     * (main.c) where the data already lives, so 0 here just confirms the
     * fork+algorithm ran to completion without crashing. */
    return 0;
}
