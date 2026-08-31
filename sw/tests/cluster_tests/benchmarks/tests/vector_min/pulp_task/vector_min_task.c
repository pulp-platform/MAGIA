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
 * vector_min — PLAY task wrapper for the MAGIA PULP cluster.
 * Reduction kernel: each core finds its local minimum into PI_L1 local_min[]
 * (PI_L1 expands to nothing under MAGIA's pmsis.h shim, so it's just a
 * plain global array here), core 0 reduces across cores after the barrier.
 * dst is a single float, not a vector.
 */

#include "magia_tile_utils.h"
#include "cluster_utils.h"
#include "stats.h"

#include "../../../../../../../PLAY/source/vector_min/vector_min.c"
#include "../../../../../../../PLAY/source/vector_min/arch/vector_min_pulp_open.c"

typedef struct {
    uint32_t src;
    uint32_t dst;
    uint32_t len;
} vector_min_params_t;

static void vector_min_fork_entry(void *arg) {
    vector_min_params_t *p = (vector_min_params_t *)arg;

    INIT_STATS();
    START_LOOP_STATS();
    START_STATS();
    vector_min((const float *)p->src, (float *)p->dst, (int)p->len);
    STOP_STATS();
    END_LOOP_STATS();
}

int vector_min_task(void *data) {
    vector_min_params_t *params = (vector_min_params_t *)data;
    pi_cl_team_fork(PULP_CORE_COUNT, vector_min_fork_entry, params);
    return 0;
}
