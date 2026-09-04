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
 * linalg_svd — PLAY task wrapper for the MAGIA PULP cluster. Same shape as
 * vector_add_task.c; linalg_svd(src, dst, mat_V, vec_S, dim_M, dim_N)
 * computes the SVD of an MxN matrix (dst[MxN], mat_V[NxN], vec_S[N]) by
 * composing matrix_mul_trans_A + linalg_svd_jacobi + linalg_svd_lsv
 * internally, scratch-allocating via pmsis_l1_malloc() (see
 * sw/utils/pmsis.h). Mirrors PLAY's test/linalg_svd/pulp-open/main.c
 * run_test() exactly: data re-init inside the HOTTING+REPEAT loop (the
 * inner Jacobi is iterative), then sort_results_descending() outside the
 * timed region before the golden comparison.
 */

#include "magia_tile_utils.h"
#include "cluster_utils.h"
#include "stats.h"

/* linalg_svd's own arch file calls matrix_mul_trans_A(), linalg_svd_jacobi()
 * and linalg_svd_lsv() -- in PLAY's own build these come from a prebuilt
 * PLAY library every test links against; this unity build has no such
 * library, so their sources are pulled in directly too. linalg_svd_jacobi
 * and linalg_svd_lsv each declare their own file-scope `static ONE_f`/
 * `EPSILON` (same names, same values, harmless in their own real
 * translation units) -- textually concatenating both into this one file
 * makes that a hard redefinition error, so each is renamed uniquely for
 * the duration of its own #include.
 *
 * `static` is neutralised across all of them for a second, independent
 * reason: it would give the PI_L1 scalars internal linkage, which makes GCC
 * address them PC-relative instead of through the GOT -- resolving outside L1
 * and reading 0. That is what used to hang this kernel (MAX_ITER == 0 ->
 * pmsis_exit()). See sw/utils/play_l1_linkage.h. The renames above stay
 * necessary: without them the now-external ONE_f/EPSILON would collide at
 * link time instead of at compile time. */
#include "play_l1_linkage.h"

#define static
#define inline
#include "../../../../../../../PLAY/source/matrix_mul_trans_A/matrix_mul_trans_A.c"
#include "../../../../../../../PLAY/source/matrix_mul_trans_A/arch/matrix_mul_trans_A_pulp_open.c"

#define ONE_f ONE_f_svd_jacobi
#define EPSILON EPSILON_svd_jacobi
#include "../../../../../../../PLAY/source/linalg_svd_jacobi/linalg_svd_jacobi.c"
#include "../../../../../../../PLAY/source/linalg_svd_jacobi/arch/linalg_svd_jacobi_pulp_open.c"
#undef ONE_f
#undef EPSILON

#define ONE_f ONE_f_svd_lsv
#define EPSILON EPSILON_svd_lsv
#include "../../../../../../../PLAY/source/linalg_svd_lsv/linalg_svd_lsv.c"
#include "../../../../../../../PLAY/source/linalg_svd_lsv/arch/linalg_svd_lsv_pulp_open.c"
#undef ONE_f
#undef EPSILON

#include "../../../../../../../PLAY/source/linalg_svd/linalg_svd.c"
#include "../../../../../../../PLAY/source/linalg_svd/arch/linalg_svd_pulp_open.c"
#undef inline
#undef static

typedef struct {
    uint32_t src;
    uint32_t dst;
    uint32_t mat_V;
    uint32_t vec_S;
    uint32_t dim_M;
    uint32_t dim_N;
} linalg_svd_params_t;

/* Verbatim port of PLAY's test/linalg_svd/pulp-open/main.c
 * sort_results_descending() -- test-harness bookkeeping, not part of PLAY's
 * kernel source. PLAY's run_test() runs it (master core only, barrier on
 * each side) after END_LOOP_STATS() and before check_result(); Jacobi SVD
 * emits singular values/vectors in no fixed order, so both sides sort by
 * |S| descending before comparing against the order-fixed golden data. */
static void sort_results_descending(float *result, float *mat_V, float *vec_S,
                                     const int dim_M, const int dim_N) {
    float tmp;
    int max_idx;

    for (int idx = 0; idx < (dim_N - 1); idx++) {
        max_idx = idx;
        for (int n = (idx + 1); n < dim_N; n++) {
            if ((vec_S[n] < 0 ? -vec_S[n] : vec_S[n]) >
                (vec_S[max_idx] < 0 ? -vec_S[max_idx] : vec_S[max_idx]))
                max_idx = n;
        }

        if (max_idx != idx) {
            tmp = vec_S[max_idx];
            vec_S[max_idx] = vec_S[idx];
            vec_S[idx] = tmp;

            for (int m = 0; m < dim_M; m++) {
                tmp = result[m * dim_N + max_idx];
                result[m * dim_N + max_idx] = result[m * dim_N + idx];
                result[m * dim_N + idx] = tmp;
            }

            for (int n = 0; n < dim_N; n++) {
                tmp = mat_V[n * dim_N + max_idx];
                mat_V[n * dim_N + max_idx] = mat_V[n * dim_N + idx];
                mat_V[n * dim_N + idx] = tmp;
            }
        }
    }
}

static void linalg_svd_fork_entry(void *arg) {
    linalg_svd_params_t *p = (linalg_svd_params_t *)arg;

    const int  M     = (int)p->dim_M;
    const int  N     = (int)p->dim_N;
    float     *dst   = (float *)p->dst;
    float     *mat_V = (float *)p->mat_V;
    float     *vec_S = (float *)p->vec_S;

    INIT_STATS();
    START_LOOP_STATS();
    /* PLAY parity: linalg_svd() only reads src (const) but fills
     * dst/mat_V/vec_S and internally runs iterative Jacobi sweeps, so reset
     * the three output buffers every HOTTING+REPEAT iteration -- exactly
     * PLAY's `initialize_data(); barrier();` inside START_LOOP_STATS()..
     * END_LOOP_STATS() (test/linalg_svd/pulp-open/main.c). src is kept
     * pristine by main.c and never written here, so no re-copy needed. */
    if (pi_core_id() == 0) {
        /* volatile casts keep -O3 from lowering these to memset(), which the
         * -nostdlib PULP task binary can't link. */
        for (int i = 0; i < M * N; i++) ((volatile float *)dst)[i]   = 0.0f;
        for (int i = 0; i < N * N; i++) ((volatile float *)mat_V)[i] = 0.0f;
        for (int i = 0; i < N; i++)     ((volatile float *)vec_S)[i] = 0.0f;
    }
    pi_cl_team_barrier();
    START_STATS();
    linalg_svd((const float *)p->src, dst, mat_V, vec_S, M, N);
    STOP_STATS();
    END_LOOP_STATS();

    pi_cl_team_barrier();
    if (pi_core_id() == 0) {
        sort_results_descending(dst, mat_V, vec_S, M, N);
    }
    pi_cl_team_barrier();
}

int linalg_svd_task(void *data) {
    linalg_svd_params_t *params = (linalg_svd_params_t *)data;
    pi_cl_team_fork(PULP_CORE_COUNT, linalg_svd_fork_entry, params);
    return 0;
}
