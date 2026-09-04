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
 * linalg_gemv_trans — PLAY task wrapper for the MAGIA PULP cluster. Same
 * shape as vector_add_task.c; linalg_gemv_trans(mat, vec_x, vec_y, alpha,
 * beta, dst, dim_M, dim_N) computes
 * dst[N] = alpha*mat[MxN]^T*vec_x[M] + beta*vec_y[N].
 */

#include "magia_tile_utils.h"
#include "cluster_utils.h"
#include "stats.h"

/* linalg_gemv_trans's alpha==0 fast path calls vector_set_all/
 * vector_memcpy/vector_scale -- same reasoning as linalg_gemv_task.c. */
#include "../../../../../../../PLAY/source/vector_memcpy/vector_memcpy.c"
#include "../../../../../../../PLAY/source/vector_memcpy/arch/vector_memcpy_pulp_open.c"
#include "../../../../../../../PLAY/source/vector_scale/vector_scale.c"
#include "../../../../../../../PLAY/source/vector_scale/arch/vector_scale_pulp_open.c"
#include "../../../../../../../PLAY/source/vector_set_all/vector_set_all.c"
#include "../../../../../../../PLAY/source/vector_set_all/arch/vector_set_all_pulp_open.c"

#include "../../../../../../../PLAY/source/linalg_gemv_trans/linalg_gemv_trans.c"
#include "../../../../../../../PLAY/source/linalg_gemv_trans/arch/linalg_gemv_trans_pulp_open.c"

typedef struct {
    uint32_t mat;
    uint32_t vec_x;
    uint32_t vec_y;
    float    alpha;
    float    beta;
    uint32_t dst;
    uint32_t dim_M;
    uint32_t dim_N;
} linalg_gemv_trans_params_t;

static void linalg_gemv_trans_fork_entry(void *arg) {
    linalg_gemv_trans_params_t *p = (linalg_gemv_trans_params_t *)arg;

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
    linalg_gemv_trans((const float *)p->mat, (const float *)p->vec_x,
                       (const float *)p->vec_y, p->alpha, p->beta,
                       (float *)p->dst, (int)p->dim_M, (int)p->dim_N);
    STOP_STATS();
    END_LOOP_STATS();
    pi_cl_team_barrier();
}

int linalg_gemv_trans_task(void *data) {
    linalg_gemv_trans_params_t *params = (linalg_gemv_trans_params_t *)data;
    pi_cl_team_fork(PULP_CORE_COUNT, linalg_gemv_trans_fork_entry, params);
    return 0;
}
