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
 * linalg_lu_decomp — main core (CV32) binary. See vector_add/main.c for
 * the full rationale. In-place LU decomposition of an MxN matrix plus a
 * length-M row-pivot permutation; two golden comparisons (mat, perm).
 */

#include "magia_tile_utils.h"
#include "cluster_utils.h"

#define TARGET_IS_PULP_OPEN 1
#include "../../../../../../PLAY/test/linalg_lu_decomp/test_data/data.h"

#include "linalg_lu_decomp_pulp_task_bin.h"

#define TOLL 0.004f

#define MAT_BASE     (L1_BASE + 0x00000000)   /* mat copy/result : DIM_M*DIM_N*4 B */
#define PERM_BASE    (L1_BASE + 0x00004000)   /* perm            : DIM_M*4 B       */
#define MAT_SRC_BASE (L1_BASE + 0x00005000)   /* pristine mat    : DIM_M*DIM_N*4 B */
#define PARAMS_BASE  (L1_BASE + 0x00007000)

typedef struct {
    uint32_t mat;
    uint32_t perm;
    uint32_t mat_src;
    uint32_t dim_M;
    uint32_t dim_N;
} linalg_lu_decomp_params_t;

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

    /* MAT_SRC keeps a pristine copy of the input; the cluster task restores
     * MAT/PERM from it on every HOTTING+REPEAT iteration, mirroring PLAY's
     * initialize_data() inside START_LOOP_STATS()..END_LOOP_STATS()
     * (test/linalg_lu_decomp/pulp-open/main.c). MAT/PERM are seeded here too
     * so a stats=0 build (single pass, no re-init loop) still runs. */
    volatile float *MAT     = (volatile float *)MAT_BASE;
    volatile int   *PERM    = (volatile int *)PERM_BASE;
    volatile float *MAT_SRC = (volatile float *)MAT_SRC_BASE;
    for (int i = 0; i < DIM_M * DIM_N; i++) MAT_SRC[i] = mat[i];
    for (int i = 0; i < DIM_M * DIM_N; i++) MAT[i]     = mat[i];
    for (int i = 0; i < DIM_M; i++)         PERM[i]    = i;

    volatile linalg_lu_decomp_params_t *params =
        (volatile linalg_lu_decomp_params_t *)PARAMS_BASE;
    params->mat     = MAT_BASE;
    params->perm    = PERM_BASE;
    params->mat_src = MAT_SRC_BASE;
    params->dim_M   = DIM_M;
    params->dim_N   = DIM_N;

    cluster_boot(PULP_BINARY_START);
    cluster_arm_done_event();
    cluster_dispatch_task_with_params(LINALG_LU_DECOMP_TASK, PARAMS_BASE);
    cluster_wait_done_eu();

    uint32_t errors = 0;
    for (int i = 0; i < DIM_M * DIM_N; i++) {
        if (fabs_f32(MAT[i] - expected_mat[i]) > TOLL)
            errors++;
    }
    /* PLAY parity: test/linalg_lu_decomp/pulp-open/main.c checks the pivot
     * permutation with vector_compare((float *)perm, (float *)expected_perm,
     * DIM_M) -- it reinterprets the int arrays as float, so every index in
     * 0..DIM_M-1 becomes a subnormal ~1e-44 and the |diff| is always well
     * below TOLL. That comparison is degenerate (always true): PLAY only
     * really validates the factorised matrix. Mirror it exactly so the
     * MAGIA verdict matches PLAY's rather than being stricter. */
    const volatile float *perm_f = (const volatile float *)PERM;
    const float *eperm_f = (const float *)expected_perm;
    for (int i = 0; i < DIM_M; i++) {
        if (fabs_f32(perm_f[i] - eperm_f[i]) > TOLL)
            errors++;
    }

    if (errors == 0) {
        printf("[Main core %u] linalg_lu_decomp PASS (%d elements)\n",
               (unsigned)hartid, DIM_M * DIM_N);
    } else {
        printf("[Main core %u] linalg_lu_decomp FAIL (%u mismatches)\n",
               (unsigned)hartid, (unsigned)errors);
    }

    return (int)errors;
}
