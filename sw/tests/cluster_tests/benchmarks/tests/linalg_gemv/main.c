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
 * linalg_gemv — main core (CV32) binary. See vector_add/main.c for the
 * full rationale. dst[M] = alpha*matA[MxN]*vecX[N] + beta*vecY[M]; PLAY's
 * data.h names the scalars `a`/`b`.
 */

#include "magia_tile_utils.h"
#include "cluster_utils.h"

#define TARGET_IS_PULP_OPEN 1
#include "../../../../../../PLAY/test/linalg_gemv/test_data/data.h"

#include "linalg_gemv_pulp_task_bin.h"

#define TOLL 0.004f

#define MAT_BASE    (L1_BASE + 0x00000000)   /* matA copy : DIM_M*DIM_N*4 B */
#define X_BASE      (L1_BASE + 0x00003000)   /* vecX copy : DIM_N*4 B       */
#define Y_BASE      (L1_BASE + 0x00003400)   /* vecY copy : DIM_M*4 B       */
#define Z_BASE      (L1_BASE + 0x00003800)   /* result    : DIM_M*4 B       */
#define PARAMS_BASE (L1_BASE + 0x00003C00)

typedef struct {
    uint32_t mat;
    uint32_t vec_x;
    uint32_t vec_y;
    float    alpha;
    float    beta;
    uint32_t dst;
    uint32_t dim_M;
    uint32_t dim_N;
} linalg_gemv_params_t;

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

    volatile float *MAT = (volatile float *)MAT_BASE;
    volatile float *X   = (volatile float *)X_BASE;
    volatile float *Y   = (volatile float *)Y_BASE;
    for (int i = 0; i < DIM_M * DIM_N; i++) MAT[i] = matA[i];
    for (int i = 0; i < DIM_N; i++)         X[i]   = vecX[i];
    for (int i = 0; i < DIM_M; i++)         Y[i]   = vecY[i];

    /* PLAY parity: initialize_data() zeroes result before the timed loop. */
    for (int i = 0; i < DIM_M; i++) ((volatile float *)Z_BASE)[i] = 0.0f;

    volatile linalg_gemv_params_t *params =
        (volatile linalg_gemv_params_t *)PARAMS_BASE;
    params->mat   = MAT_BASE;
    params->vec_x = X_BASE;
    params->vec_y = Y_BASE;
    params->alpha = a;
    params->beta  = b;
    params->dst   = Z_BASE;
    params->dim_M = DIM_M;
    params->dim_N = DIM_N;

    cluster_boot(PULP_BINARY_START);
    cluster_arm_done_event();
    cluster_dispatch_task_with_params(LINALG_GEMV_TASK, PARAMS_BASE);
    cluster_wait_done_eu();

    volatile float *Z = (volatile float *)Z_BASE;
    uint32_t errors = 0;
    for (int i = 0; i < DIM_M; i++) {
        if (fabs_f32(Z[i] - expected[i]) > TOLL)
            errors++;
    }

    if (errors == 0) {
        printf("[Main core %u] linalg_gemv PASS (%d elements)\n",
               (unsigned)hartid, DIM_M);
    } else {
        printf("[Main core %u] linalg_gemv FAIL (%u/%d mismatches)\n",
               (unsigned)hartid, (unsigned)errors, DIM_M);
    }

    return (int)errors;
}
