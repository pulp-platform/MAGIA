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
 * linalg_svd_jacobi — main core (CV32) binary. See vector_add/main.c for
 * the full rationale. Three golden comparisons (result matrix, V, S), each
 * against PLAY's own |a|-|b| tolerance (matrix_compare_abs/
 * vector_compare_abs in PLAY/test/common/utils.c) since Jacobi SVD signs
 * are not fixed by the algorithm -- see pulp_task/linalg_svd_jacobi_task.c
 * for the matching sort step.
 *
 * PLAY's data.h names the golden outputs `V[]`/`S[]` (same names as this
 * kernel's own output parameters) and the golden result matrix
 * `expected[]`; the L1 destination pointers below are named *_L1 to avoid
 * colliding with those globals.
 */

#include "magia_tile_utils.h"
#include "cluster_utils.h"

#define TARGET_IS_PULP_OPEN 1
#include "../../../../../../PLAY/test/linalg_svd_jacobi/test_data/data.h"

#include "linalg_svd_jacobi_pulp_task_bin.h"

#define TOLL 0.004f

#define MAT_BASE     (L1_BASE + 0x00000000)   /* mat copy/result : DIM_M*DIM_M*4 B */
#define V_BASE       (L1_BASE + 0x00004000)   /* mat_V           : DIM_M*DIM_M*4 B */
#define S_BASE       (L1_BASE + 0x00008000)   /* vec_S           : DIM_M*4 B       */
#define PARAMS_BASE  (L1_BASE + 0x00009000)
#define MAT_SRC_BASE (L1_BASE + 0x0000A000)   /* pristine mat    : DIM_M*DIM_M*4 B */

typedef struct {
    uint32_t mat;
    uint32_t mat_V;
    uint32_t vec_S;
    uint32_t mat_src;
    uint32_t dim_M;
} linalg_svd_jacobi_params_t;

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

    /* MAT_SRC keeps a pristine copy; the cluster task restores mat/mat_V/
     * vec_S from it (and zero) on every HOTTING+REPEAT iteration, mirroring
     * PLAY's initialize_data() inside START_LOOP_STATS()..END_LOOP_STATS()
     * (test/linalg_svd_jacobi/pulp-open/main.c). The working buffers are
     * seeded here too so a stats=0 build (single pass) still runs. */
    volatile float *mat_L1 = (volatile float *)MAT_BASE;
    volatile float *v_L1   = (volatile float *)V_BASE;
    volatile float *s_L1   = (volatile float *)S_BASE;
    volatile float *src_L1 = (volatile float *)MAT_SRC_BASE;
    for (int i = 0; i < DIM_M * DIM_M; i++) src_L1[i] = mat[i];
    for (int i = 0; i < DIM_M * DIM_M; i++) mat_L1[i] = mat[i];
    for (int i = 0; i < DIM_M * DIM_M; i++) v_L1[i]   = 0.0f;
    for (int i = 0; i < DIM_M; i++)         s_L1[i]   = 0.0f;

    volatile linalg_svd_jacobi_params_t *params =
        (volatile linalg_svd_jacobi_params_t *)PARAMS_BASE;
    params->mat     = MAT_BASE;
    params->mat_V   = V_BASE;
    params->vec_S   = S_BASE;
    params->mat_src = MAT_SRC_BASE;
    params->dim_M   = DIM_M;

    cluster_boot(PULP_BINARY_START);
    cluster_arm_done_event();
    cluster_dispatch_task_with_params(LINALG_SVD_JACOBI_TASK, PARAMS_BASE);
    cluster_wait_done_eu();

    uint32_t errors = 0;
    for (int i = 0; i < DIM_M * DIM_M; i++) {
        if (fabs_f32(fabs_f32(mat_L1[i]) - fabs_f32(expected[i])) > TOLL)
            errors++;
    }
    for (int i = 0; i < DIM_M * DIM_M; i++) {
        if (fabs_f32(fabs_f32(v_L1[i]) - fabs_f32(V[i])) > TOLL)
            errors++;
    }
    for (int i = 0; i < DIM_M; i++) {
        if (fabs_f32(fabs_f32(s_L1[i]) - fabs_f32(S[i])) > TOLL)
            errors++;
    }

    if (errors == 0) {
        printf("[Main core %u] linalg_svd_jacobi PASS (dim %d)\n",
               (unsigned)hartid, DIM_M);
    } else {
        printf("[Main core %u] linalg_svd_jacobi FAIL (%u mismatches)\n",
               (unsigned)hartid, (unsigned)errors);
    }

    return (int)errors;
}
