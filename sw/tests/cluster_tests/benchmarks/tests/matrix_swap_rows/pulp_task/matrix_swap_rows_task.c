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
 * matrix_swap_rows — PLAY task wrapper for the MAGIA PULP cluster. Same
 * shape as vector_add_task.c; matrix_swap_rows(mat, row_a, row_b, dim_N)
 * swaps two rows of an MxN matrix in place.
 */

#include "magia_tile_utils.h"
#include "cluster_utils.h"
#include "stats.h"

#include "../../../../../../../PLAY/source/matrix_swap_rows/matrix_swap_rows.c"
#include "../../../../../../../PLAY/source/matrix_swap_rows/arch/matrix_swap_rows_pulp_open.c"

typedef struct {
    uint32_t mat;
    uint32_t mat_src;
    uint32_t row_a;
    uint32_t row_b;
    uint32_t dim_M;
    uint32_t dim_N;
} matrix_swap_rows_params_t;

static void matrix_swap_rows_fork_entry(void *arg) {
    matrix_swap_rows_params_t *p = (matrix_swap_rows_params_t *)arg;

    float       *mat     = (float *)p->mat;
    const float *mat_src = (const float *)p->mat_src;
    const int    total   = (int)p->dim_M * (int)p->dim_N;

    /* PLAY parity: run_test() for this in-place kernel has NO barrier
     * before INIT_STATS() (test/matrix_swap_rows/pulp-open/main.c) -- the
     * per-iteration barrier after the re-init below is what aligns the
     * team ahead of START_STATS(). */
    INIT_STATS();
    START_LOOP_STATS();
    /* PLAY parity: matrix_swap_rows() swaps in place, so restore the working
     * buffer every HOTTING+REPEAT iteration -- exactly PLAY's
     * `initialize_matrices(); barrier();` inside START_LOOP_STATS()..
     * END_LOOP_STATS() (test/matrix_swap_rows/pulp-open/main.c). */
    if (pi_core_id() == 0) {
        for (int i = 0; i < total; i++) mat[i] = mat_src[i];
    }
    pi_cl_team_barrier();
    START_STATS();
    matrix_swap_rows(mat, (int)p->row_a, (int)p->row_b, (int)p->dim_N);
    STOP_STATS();
    END_LOOP_STATS();
    pi_cl_team_barrier();
}

int matrix_swap_rows_task(void *data) {
    matrix_swap_rows_params_t *params = (matrix_swap_rows_params_t *)data;
    pi_cl_team_fork(PULP_CORE_COUNT, matrix_swap_rows_fork_entry, params);
    return 0;
}
