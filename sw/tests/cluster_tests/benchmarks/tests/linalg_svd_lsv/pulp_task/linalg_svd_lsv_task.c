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
 * linalg_svd_lsv — PLAY task wrapper for the MAGIA PULP cluster. Same
 * shape as vector_add_task.c; linalg_svd_lsv(src, mat_V, vec_S, dst,
 * dim_M, dim_N) computes the left singular vectors dst[MxN] of src[MxN]
 * given its already-computed right singular vectors/values mat_V[NxN]/
 * vec_S[N] (e.g. from linalg_svd_jacobi) -- unlike linalg_svd_jacobi/
 * linalg_svd, mat_V/vec_S are INPUTS here, not outputs.
 */

#include "magia_tile_utils.h"
#include "cluster_utils.h"
#include "stats.h"

/* `static` is neutralised around the PLAY includes so this kernel's PI_L1
 * scalars (ONE_f, EPSILON) get external linkage and are addressed through the
 * GOT, which pulp_crt0.S fixes up. Left `static` they are addressed
 * PC-relative, which resolves outside L1 and reads 0 -- see
 * sw/utils/play_l1_linkage.h for the full story. */
#include "play_l1_linkage.h"

#define static
#define inline
#include "../../../../../../../PLAY/source/linalg_svd_lsv/linalg_svd_lsv.c"
#include "../../../../../../../PLAY/source/linalg_svd_lsv/arch/linalg_svd_lsv_pulp_open.c"
#undef inline
#undef static

typedef struct {
    uint32_t src;
    uint32_t mat_V;
    uint32_t vec_S;
    uint32_t dst;
    uint32_t dim_M;
    uint32_t dim_N;
} linalg_svd_lsv_params_t;

static void linalg_svd_lsv_fork_entry(void *arg) {
    linalg_svd_lsv_params_t *p = (linalg_svd_lsv_params_t *)arg;

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
    linalg_svd_lsv((const float *)p->src, (float *)p->mat_V,
                    (float *)p->vec_S, (float *)p->dst, (int)p->dim_M,
                    (int)p->dim_N);
    STOP_STATS();
    END_LOOP_STATS();
    pi_cl_team_barrier();
}

int linalg_svd_lsv_task(void *data) {
    linalg_svd_lsv_params_t *params = (linalg_svd_lsv_params_t *)data;
    pi_cl_team_fork(PULP_CORE_COUNT, linalg_svd_lsv_fork_entry, params);
    return 0;
}
