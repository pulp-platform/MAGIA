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
 * matrix_mul — main core (CV32) binary. See vector_add/main.c for the full
 * rationale. dst[MxP] = src_a[MxN] * src_b[NxP].
 */

#include "magia_tile_utils.h"
#include "cluster_utils.h"

#define TARGET_IS_PULP_OPEN 1
#include "../../../../../../PLAY/test/matrix_mul/test_data/data.h"

#include "matrix_mul_pulp_task_bin.h"

#define TOLL 0.004f

/* DIM_M=64 DIM_N=32 DIM_P=64: A = 64*32*4 = 0x2000, B = 32*64*4 = 0x2000,
 * Z = DIM_M*DIM_P*4 = 64*64*4 = 0x4000. The old PARAMS_BASE at +0x9000 left Z
 * only 0x3000 of room, so dst[] writes clobbered the params struct; the
 * HOTTING/REPEAT loop then re-read garbage src_a/src_b/dst pointers on the 2nd
 * iteration and walked off into uninitialised L2. Give Z a full 0x5000 slot. */
#define A_BASE      (L1_BASE + 0x00000000)   /* mat_a copy : DIM_M*DIM_N*4 = 0x2000 B */
#define B_BASE      (L1_BASE + 0x00003000)   /* mat_b copy : DIM_N*DIM_P*4 = 0x2000 B */
#define Z_BASE      (L1_BASE + 0x00006000)   /* result     : DIM_M*DIM_P*4 = 0x4000 B */
#define PARAMS_BASE (L1_BASE + 0x0000B000)

typedef struct {
    uint32_t src_a;
    uint32_t src_b;
    uint32_t dst;
    uint32_t dim_M;
    uint32_t dim_N;
    uint32_t dim_P;
} matrix_mul_params_t;

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

    volatile float *A = (volatile float *)A_BASE;
    volatile float *B = (volatile float *)B_BASE;
    for (int i = 0; i < DIM_M * DIM_N; i++) A[i] = mat_a[i];
    for (int i = 0; i < DIM_N * DIM_P; i++) B[i] = mat_b[i];

    /* PLAY parity: initialize_matrices() zeroes result before the timed loop
     * (the CLUSTER kernel's remainder path does dst[...] += ...). */
    for (int i = 0; i < DIM_M * DIM_P; i++) ((volatile float *)Z_BASE)[i] = 0.0f;

    volatile matrix_mul_params_t *params =
        (volatile matrix_mul_params_t *)PARAMS_BASE;
    params->src_a = A_BASE;
    params->src_b = B_BASE;
    params->dst   = Z_BASE;
    params->dim_M = DIM_M;
    params->dim_N = DIM_N;
    params->dim_P = DIM_P;

    cluster_boot(PULP_BINARY_START);
    cluster_arm_done_event();
    cluster_dispatch_task_with_params(MATRIX_MUL_TASK, PARAMS_BASE);
    cluster_wait_done_eu();

    volatile float *Z = (volatile float *)Z_BASE;
    uint32_t errors = 0;
    for (int i = 0; i < DIM_M * DIM_P; i++) {
        if (fabs_f32(Z[i] - expected[i]) > TOLL)
            errors++;
    }

    if (errors == 0) {
        printf("[Main core %u] matrix_mul PASS (%d elements)\n",
               (unsigned)hartid, DIM_M * DIM_P);
    } else {
        printf("[Main core %u] matrix_mul FAIL (%u/%d mismatches)\n",
               (unsigned)hartid, (unsigned)errors, DIM_M * DIM_P);
    }

    return (int)errors;
}
