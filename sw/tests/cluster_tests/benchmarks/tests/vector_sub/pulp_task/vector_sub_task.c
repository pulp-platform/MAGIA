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
 * vector_sub — PLAY task wrapper for the MAGIA PULP cluster.
 * Same pattern as vector_add_task.c: PLAY's vector_sub.c and
 * arch/vector_sub_pulp_open.c are pulled in verbatim; only the
 * pi_cl_team_fork() call (which PLAY's own harness normally provides) and
 * the MAGIA dispatch entry point are added here.
 */

#include "magia_tile_utils.h"
#include "cluster_utils.h"
#include "stats.h"

#include "../../../../../../../PLAY/source/vector_sub/vector_sub.c"
#include "../../../../../../../PLAY/source/vector_sub/arch/vector_sub_pulp_open.c"

typedef struct {
    uint32_t src_a;
    uint32_t src_b;
    uint32_t dst;
    uint32_t len;
} vector_sub_params_t;

static void vector_sub_fork_entry(void *arg) {
    vector_sub_params_t *p = (vector_sub_params_t *)arg;

    INIT_STATS();
    START_LOOP_STATS();
    START_STATS();
    vector_sub((const float *)p->src_a, (const float *)p->src_b,
               (float *)p->dst, (int)p->len);
    STOP_STATS();
    END_LOOP_STATS();
}

int vector_sub_task(void *data) {
    vector_sub_params_t *params = (vector_sub_params_t *)data;
    pi_cl_team_fork(PULP_CORE_COUNT, vector_sub_fork_entry, params);
    return 0;
}
