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
 * linalg_svd_jacobi — PLAY task wrapper for the MAGIA PULP cluster.
 *
 * linalg_svd_jacobi(mat, mat_V, vec_S, dim_M) (source/linalg_svd_jacobi/
 * arch/linalg_svd_jacobi_pulp_open.c) is pulled in unmodified, same as
 * every other kernel here (see vector_add_task.c). Unlike the others,
 * PLAY's own test harness (test/linalg_svd_jacobi/pulp-open/main.c) does
 * one extra step this kernel needs for a stable golden comparison: Jacobi
 * SVD produces singular values/vectors in no particular order, so
 * sort_results_descending() (defined there, NOT part of PLAY's kernel
 * source) sorts them by |S| descending before comparing against the
 * (order-fixed) expected/V/S golden data. That helper is reproduced here
 * verbatim (it's ~20 lines of test-harness bookkeeping, not algorithm),
 * gated to core 0 with a barrier on each side like PLAY's is_master_core()
 * + barrier() calls, since it must run after every core's contribution to
 * linalg_svd_jacobi() (itself internally parallel) has landed.
 */

#include "magia_tile_utils.h"
#include "cluster_utils.h"
#include "stats.h"

/* `static` is neutralised around the PLAY includes so this kernel's PI_L1
 * scalars (ONE_f, ZERO_f, TWO_f, MAX_ITER, EPSILON) get external linkage and
 * are addressed through the GOT, which pulp_crt0.S fixes up. Left `static`
 * they are addressed PC-relative, which resolves outside L1 and reads 0 --
 * MAX_ITER == 0 then hangs every core in pmsis_exit(). See
 * sw/utils/play_l1_linkage.h for the full story. */
#include "play_l1_linkage.h"

#define static
#define inline
#include "../../../../../../../PLAY/source/linalg_svd_jacobi/linalg_svd_jacobi.c"
#include "../../../../../../../PLAY/source/linalg_svd_jacobi/arch/linalg_svd_jacobi_pulp_open.c"
#undef inline
#undef static

typedef struct {
    uint32_t mat;
    uint32_t mat_V;
    uint32_t vec_S;
    uint32_t mat_src;
    uint32_t dim_M;
} linalg_svd_jacobi_params_t;

/* Verbatim port of PLAY's test/linalg_svd_jacobi/pulp-open/main.c
 * sort_results_descending() -- test-harness bookkeeping, not part of
 * PLAY's kernel source, so not pulled in via the #include above. */
static void sort_results_descending(float *result, float *mat_V, float *vec_S,
                                     const int dim_M) {
    float tmp;
    int max_idx;

    for (int i = 0; i < (dim_M - 1); i++) {
        max_idx = i;
        for (int j = (i + 1); j < dim_M; j++) {
            if ((vec_S[j] < 0 ? -vec_S[j] : vec_S[j]) >
                (vec_S[max_idx] < 0 ? -vec_S[max_idx] : vec_S[max_idx])) {
                max_idx = j;
            }
        }

        if (max_idx != i) {
            tmp = vec_S[i];
            vec_S[i] = vec_S[max_idx];
            vec_S[max_idx] = tmp;

            tmp = result[i * dim_M + i];
            result[i * dim_M + i] = result[max_idx * dim_M + max_idx];
            result[max_idx * dim_M + max_idx] = tmp;

            for (int k = 0; k < dim_M; k++) {
                tmp = mat_V[k * dim_M + i];
                mat_V[k * dim_M + i] = mat_V[k * dim_M + max_idx];
                mat_V[k * dim_M + max_idx] = tmp;
            }
        }
    }
}

static void linalg_svd_jacobi_fork_entry(void *arg) {
    linalg_svd_jacobi_params_t *p = (linalg_svd_jacobi_params_t *)arg;

    const int    M       = (int)p->dim_M;
    float       *mat     = (float *)p->mat;
    float       *mat_V   = (float *)p->mat_V;
    float       *vec_S   = (float *)p->vec_S;
    const float *mat_src = (const float *)p->mat_src;

    INIT_STATS();
    START_LOOP_STATS();
    /* PLAY parity: linalg_svd_jacobi() overwrites mat in place and
     * accumulates into mat_V/vec_S, so restore all three every
     * HOTTING+REPEAT iteration -- exactly PLAY's `initialize_data();
     * barrier();` inside START_LOOP_STATS()..END_LOOP_STATS()
     * (test/linalg_svd_jacobi/pulp-open/main.c). */
    if (pi_core_id() == 0) {
        /* volatile casts on the zeroing stores keep -O3 from lowering them
         * to memset(), which the -nostdlib PULP task binary can't link. */
        for (int i = 0; i < M * M; i++) mat[i] = mat_src[i];
        for (int i = 0; i < M * M; i++) ((volatile float *)mat_V)[i] = 0.0f;
        for (int i = 0; i < M; i++)     ((volatile float *)vec_S)[i] = 0.0f;
    }
    pi_cl_team_barrier();
    START_STATS();
    linalg_svd_jacobi(mat, mat_V, vec_S, M);
    STOP_STATS();
    END_LOOP_STATS();

    pi_cl_team_barrier();
    if (pi_core_id() == 0) {
        sort_results_descending(mat, mat_V, vec_S, M);
    }
    pi_cl_team_barrier();
}

int linalg_svd_jacobi_task(void *data) {
    linalg_svd_jacobi_params_t *params = (linalg_svd_jacobi_params_t *)data;
    pi_cl_team_fork(PULP_CORE_COUNT, linalg_svd_jacobi_fork_entry, params);
    return 0;
}
