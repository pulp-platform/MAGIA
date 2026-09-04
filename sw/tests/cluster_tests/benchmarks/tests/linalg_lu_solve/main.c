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
 * linalg_lu_solve — main core (CV32) binary. See vector_add/main.c for the
 * full rationale. Square system (dim_N == dim_M, PLAY's data.h defines
 * only DIM_M); PLAY names the LU matrix/rhs/permutation `LU`/`b`/`p`.
 */

#include "magia_tile_utils.h"
#include "cluster_utils.h"

#define TARGET_IS_PULP_OPEN 1
#include "../../../../../../PLAY/test/linalg_lu_solve/test_data/data.h"

#include "linalg_lu_solve_pulp_task_bin.h"

#define TOLL 0.004f

#define MAT_BASE    (L1_BASE + 0x00000000)   /* LU copy   : DIM_M*DIM_M*4 B */
#define VEC_BASE    (L1_BASE + 0x00004000)   /* b copy    : DIM_M*4 B       */
#define PERM_BASE   (L1_BASE + 0x00004400)   /* p copy    : DIM_M*4 B       */
#define Z_BASE      (L1_BASE + 0x00004800)   /* result    : DIM_M*4 B       */
#define PARAMS_BASE (L1_BASE + 0x00004C00)

typedef struct {
    uint32_t mat;
    uint32_t vec;
    uint32_t perm;
    uint32_t result;
    uint32_t dim_M;
    uint32_t dim_N;
} linalg_lu_solve_params_t;

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

    volatile float *MAT  = (volatile float *)MAT_BASE;
    volatile float *VEC  = (volatile float *)VEC_BASE;
    volatile int   *PERM = (volatile int *)PERM_BASE;
    for (int i = 0; i < DIM_M * DIM_M; i++) MAT[i]  = LU[i];
    for (int i = 0; i < DIM_M; i++)         VEC[i]  = b[i];
    for (int i = 0; i < DIM_M; i++)         PERM[i] = p[i];

    /* PLAY parity: initialize_data() zeroes result before the timed loop. */
    for (int i = 0; i < DIM_M; i++) ((volatile float *)Z_BASE)[i] = 0.0f;

    volatile linalg_lu_solve_params_t *params =
        (volatile linalg_lu_solve_params_t *)PARAMS_BASE;
    params->mat    = MAT_BASE;
    params->vec    = VEC_BASE;
    params->perm   = PERM_BASE;
    params->result = Z_BASE;
    params->dim_M  = DIM_M;
    params->dim_N  = DIM_M;

    cluster_boot(PULP_BINARY_START);
    cluster_arm_done_event();
    cluster_dispatch_task_with_params(LINALG_LU_SOLVE_TASK, PARAMS_BASE);
    cluster_wait_done_eu();

    volatile float *Z = (volatile float *)Z_BASE;
    uint32_t errors = 0;
    for (int i = 0; i < DIM_M; i++) {
        if (fabs_f32(Z[i] - expected[i]) > TOLL)
            errors++;
    }

    if (errors == 0) {
        printf("[Main core %u] linalg_lu_solve PASS (%d elements)\n",
               (unsigned)hartid, DIM_M);
    } else {
        printf("[Main core %u] linalg_lu_solve FAIL (%u/%d mismatches)\n",
               (unsigned)hartid, (unsigned)errors, DIM_M);
    }

    return (int)errors;
}
