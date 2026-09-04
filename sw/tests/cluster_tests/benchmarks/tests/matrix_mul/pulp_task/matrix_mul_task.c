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
 * matrix_mul — PLAY task wrapper for the MAGIA PULP cluster. Same shape as
 * vector_add_task.c; matrix_mul(src_a, src_b, dst, dim_M, dim_N, dim_P)
 * computes dst[MxP] = src_a[MxN] * src_b[NxP].
 */

#include "magia_tile_utils.h"
#include "cluster_utils.h"
#include "stats.h"

#include "../../../../../../../PLAY/source/matrix_mul/matrix_mul.c"
#include "../../../../../../../PLAY/source/matrix_mul/arch/matrix_mul_pulp_open.c"

typedef struct {
    uint32_t src_a;
    uint32_t src_b;
    uint32_t dst;
    uint32_t dim_M;
    uint32_t dim_N;
    uint32_t dim_P;
} matrix_mul_params_t;

static void matrix_mul_fork_entry(void *arg) {
    matrix_mul_params_t *p = (matrix_mul_params_t *)arg;

    /* Align all cores before the timed region, matching PLAY's own
     * test harness (test/common/utils.c barrier(), called before
     * INIT_STATS()/after END_LOOP_STATS() in every PLAY pulp-open
     * run_test()) -- without it, cores can enter their own
     * START_STATS() at different real times (fork/dispatch skew),
     * making the stats not directly comparable to PLAY's own
     * numbers. */
    pi_cl_team_barrier();

    INIT_STATS();
    START_LOOP_STATS();
    START_STATS();
    matrix_mul((const float *)p->src_a, (const float *)p->src_b,
               (float *)p->dst, (int)p->dim_M, (int)p->dim_N, (int)p->dim_P);
    STOP_STATS();
    END_LOOP_STATS();
    pi_cl_team_barrier();
}

int matrix_mul_task(void *data) {
    matrix_mul_params_t *params = (matrix_mul_params_t *)data;
    pi_cl_team_fork(PULP_CORE_COUNT, matrix_mul_fork_entry, params);
    return 0;
}
