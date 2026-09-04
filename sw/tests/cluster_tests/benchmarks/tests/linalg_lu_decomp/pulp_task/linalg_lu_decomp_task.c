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
 * linalg_lu_decomp — PLAY task wrapper for the MAGIA PULP cluster. Same
 * shape as vector_add_task.c; linalg_lu_decomp(mat, perm, dim_M, dim_N)
 * LU-decomposes an MxN matrix in place, with perm[M] the row-pivot
 * permutation.
 */

#include "magia_tile_utils.h"
#include "cluster_utils.h"
#include "stats.h"

/* `static` is neutralised around the PLAY includes so this kernel's PI_L1
 * scalar (ONE_f) gets external linkage and is addressed through the GOT,
 * which pulp_crt0.S fixes up. Left `static` it is addressed PC-relative,
 * which resolves outside L1 and reads 0 -- see sw/utils/play_l1_linkage.h. */
#include "play_l1_linkage.h"

#define static
#define inline
#include "../../../../../../../PLAY/source/linalg_lu_decomp/linalg_lu_decomp.c"
#include "../../../../../../../PLAY/source/linalg_lu_decomp/arch/linalg_lu_decomp_pulp_open.c"
#undef inline
#undef static

typedef struct {
    uint32_t mat;
    uint32_t perm;
    uint32_t mat_src;
    uint32_t dim_M;
    uint32_t dim_N;
} linalg_lu_decomp_params_t;

static void linalg_lu_decomp_fork_entry(void *arg) {
    linalg_lu_decomp_params_t *p = (linalg_lu_decomp_params_t *)arg;

    const int    M       = (int)p->dim_M;
    const int    N       = (int)p->dim_N;
    float       *mat     = (float *)p->mat;
    int         *perm    = (int *)p->perm;
    const float *mat_src = (const float *)p->mat_src;

    /* PLAY parity: run_test() for this in-place kernel has NO barrier
     * before INIT_STATS() (test/linalg_lu_decomp/pulp-open/main.c) -- the
     * per-iteration barrier after the re-init below is what aligns the
     * team ahead of START_STATS(). */
    INIT_STATS();
    START_LOOP_STATS();
    /* PLAY parity: linalg_lu_decomp() factorises mat/perm in place, so the
     * working buffers must be restored on every HOTTING+REPEAT iteration --
     * exactly PLAY's `initialize_data(); barrier();` inside
     * START_LOOP_STATS()..END_LOOP_STATS() (test/linalg_lu_decomp/
     * pulp-open/main.c). Master core only, like PLAY's is_master_core()
     * guard, then a team barrier before the timed region. PLAY zeroes perm
     * and lets the kernel's set_permutation_identity() fill it; the CLUSTER
     * build of that helper only writes 2 entries per core, so seed the
     * identity directly here instead. */
    if (pi_core_id() == 0) {
        for (int i = 0; i < M * N; i++) mat[i]  = mat_src[i];
        for (int i = 0; i < M;     i++) perm[i] = i;
    }
    pi_cl_team_barrier();
    START_STATS();
    linalg_lu_decomp(mat, perm, M, N);
    STOP_STATS();
    END_LOOP_STATS();
    pi_cl_team_barrier();
}

int linalg_lu_decomp_task(void *data) {
    linalg_lu_decomp_params_t *params = (linalg_lu_decomp_params_t *)data;
    pi_cl_team_fork(PULP_CORE_COUNT, linalg_lu_decomp_fork_entry, params);
    return 0;
}
