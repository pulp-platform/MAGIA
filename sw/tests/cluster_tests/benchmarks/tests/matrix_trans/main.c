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
 * matrix_trans — main core (CV32) binary. See vector_add/main.c for the
 * full rationale. dst[NxM] = src[MxN]^T.
 */

#include "magia_tile_utils.h"
#include "cluster_utils.h"

#define TARGET_IS_PULP_OPEN 1
#include "../../../../../../PLAY/test/matrix_trans/test_data/data.h"

#include "matrix_trans_pulp_task_bin.h"

#define TOLL 0.004f

#define X_BASE      (L1_BASE + 0x00000000)   /* mat copy   : DIM_M*DIM_N*4 B */
#define Z_BASE      (L1_BASE + 0x00003000)   /* result     : DIM_N*DIM_M*4 B */
#define PARAMS_BASE (L1_BASE + 0x00006000)

typedef struct {
    uint32_t src;
    uint32_t dst;
    uint32_t dim_M;
    uint32_t dim_N;
} matrix_trans_params_t;

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

    volatile float *X = (volatile float *)X_BASE;
    for (int i = 0; i < DIM_M * DIM_N; i++) X[i] = mat[i];

    /* PLAY parity: initialize_matrices() zeroes result before the timed loop. */
    for (int i = 0; i < DIM_M * DIM_N; i++) ((volatile float *)Z_BASE)[i] = 0.0f;

    volatile matrix_trans_params_t *params =
        (volatile matrix_trans_params_t *)PARAMS_BASE;
    params->src   = X_BASE;
    params->dst   = Z_BASE;
    params->dim_M = DIM_M;
    params->dim_N = DIM_N;

    cluster_boot(PULP_BINARY_START);
    cluster_arm_done_event();
    cluster_dispatch_task_with_params(MATRIX_TRANS_TASK, PARAMS_BASE);
    cluster_wait_done_eu();

    volatile float *Z = (volatile float *)Z_BASE;
    uint32_t errors = 0;
    for (int i = 0; i < DIM_M * DIM_N; i++) {
        if (fabs_f32(Z[i] - expected[i]) > TOLL)
            errors++;
    }

    if (errors == 0) {
        printf("[Main core %u] matrix_trans PASS (%d elements)\n",
               (unsigned)hartid, DIM_M * DIM_N);
    } else {
        printf("[Main core %u] matrix_trans FAIL (%u/%d mismatches)\n",
               (unsigned)hartid, (unsigned)errors, DIM_M * DIM_N);
    }

    return (int)errors;
}
