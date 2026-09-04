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
 * matrix_swap_rows — main core (CV32) binary. See vector_add/main.c for
 * the full rationale. In-place row swap on an MxN matrix; PLAY's data.h
 * ships the row indices as `rowA`/`rowB`.
 */

#include "magia_tile_utils.h"
#include "cluster_utils.h"

#define TARGET_IS_PULP_OPEN 1
#include "../../../../../../PLAY/test/matrix_swap_rows/test_data/data.h"

#include "matrix_swap_rows_pulp_task_bin.h"

#define TOLL 0.004f

#define Z_BASE      (L1_BASE + 0x00000000)   /* mat copy/result : DIM_M*DIM_N*4 B */
#define Z_SRC_BASE  (L1_BASE + 0x00004000)   /* pristine mat    : DIM_M*DIM_N*4 B */
#define PARAMS_BASE (L1_BASE + 0x00008000)

typedef struct {
    uint32_t mat;
    uint32_t mat_src;
    uint32_t row_a;
    uint32_t row_b;
    uint32_t dim_M;
    uint32_t dim_N;
} matrix_swap_rows_params_t;

static inline uint32_t get_hartid(void) {
    uint32_t hartid;
    asm volatile("csrr %0, mhartid" : "=r"(hartid));
    return hartid;
}

static inline float fabs_f32(float x) {
    return (x < 0.0f) ? -x : x;
}

int main(void) {
    uint32_t hartid = get_hartid();

    printf("[Main core %u] Hello World!\n", (unsigned)hartid);

    /* Z_SRC keeps a pristine copy; the cluster task restores Z from it on
     * every HOTTING+REPEAT iteration, mirroring PLAY's initialize_matrices()
     * inside START_LOOP_STATS()..END_LOOP_STATS()
     * (test/matrix_swap_rows/pulp-open/main.c). Z is seeded here too so a
     * stats=0 build (single pass, no re-init loop) still runs. */
    volatile float *Z     = (volatile float *)Z_BASE;
    volatile float *Z_SRC = (volatile float *)Z_SRC_BASE;
    for (int i = 0; i < DIM_M * DIM_N; i++) Z_SRC[i] = mat[i];
    for (int i = 0; i < DIM_M * DIM_N; i++) Z[i]     = mat[i];

    volatile matrix_swap_rows_params_t *params =
        (volatile matrix_swap_rows_params_t *)PARAMS_BASE;
    params->mat     = Z_BASE;
    params->mat_src = Z_SRC_BASE;
    params->row_a   = (uint32_t)rowA;
    params->row_b   = (uint32_t)rowB;
    params->dim_M   = DIM_M;
    params->dim_N   = DIM_N;

    cluster_boot(PULP_BINARY_START);
    cluster_arm_done_event();
    cluster_dispatch_task_with_params(MATRIX_SWAP_ROWS_TASK, PARAMS_BASE);
    cluster_wait_done_eu();

    uint32_t errors = 0;
    for (int i = 0; i < DIM_M * DIM_N; i++) {
        if (fabs_f32(Z[i] - expected[i]) > TOLL)
            errors++;
    }

    if (errors == 0) {
        printf("[Main core %u] matrix_swap_rows PASS (%d elements)\n",
               (unsigned)hartid, DIM_M * DIM_N);
    } else {
        printf("[Main core %u] matrix_swap_rows FAIL (%u/%d mismatches)\n",
               (unsigned)hartid, (unsigned)errors, DIM_M * DIM_N);
    }

    return (int)errors;
}
