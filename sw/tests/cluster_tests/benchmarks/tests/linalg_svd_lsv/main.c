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
 * linalg_svd_lsv — main core (CV32) binary. See vector_add/main.c for the
 * full rationale. mat_V[NxN]/vec_S[N] (PLAY's `V[]`/`S[]`) are INPUTS here
 * (already-computed right singular vectors/values), not golden outputs;
 * only dst[MxN] is compared, against `expected[]`.
 */

#include "magia_tile_utils.h"
#include "cluster_utils.h"

#define TARGET_IS_PULP_OPEN 1
#include "../../../../../../PLAY/test/linalg_svd_lsv/test_data/data.h"

#include "linalg_svd_lsv_pulp_task_bin.h"

#define TOLL 0.004f

#define SRC_BASE    (L1_BASE + 0x00000000)   /* mat copy : DIM_M*DIM_N*4 B */
#define V_BASE      (L1_BASE + 0x00004000)   /* mat_V in : DIM_N*DIM_N*4 B */
#define S_BASE      (L1_BASE + 0x00008000)   /* vec_S in : DIM_N*4 B       */
#define DST_BASE    (L1_BASE + 0x00008400)   /* dst      : DIM_M*DIM_N*4 B */
#define PARAMS_BASE (L1_BASE + 0x0000C400)

typedef struct {
    uint32_t src;
    uint32_t mat_V;
    uint32_t vec_S;
    uint32_t dst;
    uint32_t dim_M;
    uint32_t dim_N;
} linalg_svd_lsv_params_t;

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

    volatile float *src_L1 = (volatile float *)SRC_BASE;
    volatile float *v_L1   = (volatile float *)V_BASE;
    volatile float *s_L1   = (volatile float *)S_BASE;
    for (int i = 0; i < DIM_M * DIM_N; i++) src_L1[i] = mat[i];
    for (int i = 0; i < DIM_N * DIM_N; i++) v_L1[i]   = V[i];
    for (int i = 0; i < DIM_N; i++)         s_L1[i]   = S[i];

    /* PLAY parity: initialize_data() zeroes result before the timed loop. */
    for (int i = 0; i < DIM_M * DIM_N; i++) ((volatile float *)DST_BASE)[i] = 0.0f;

    volatile linalg_svd_lsv_params_t *params =
        (volatile linalg_svd_lsv_params_t *)PARAMS_BASE;
    params->src   = SRC_BASE;
    params->mat_V = V_BASE;
    params->vec_S = S_BASE;
    params->dst   = DST_BASE;
    params->dim_M = DIM_M;
    params->dim_N = DIM_N;

    cluster_boot(PULP_BINARY_START);
    cluster_arm_done_event();
    cluster_dispatch_task_with_params(LINALG_SVD_LSV_TASK, PARAMS_BASE);
    cluster_wait_done_eu();

    volatile float *dst_L1 = (volatile float *)DST_BASE;
    uint32_t errors = 0;
    for (int i = 0; i < DIM_M * DIM_N; i++) {
        if (fabs_f32(fabs_f32(dst_L1[i]) - fabs_f32(expected[i])) > TOLL)
            errors++;
    }

    if (errors == 0) {
        printf("[Main core %u] linalg_svd_lsv PASS (%d elements)\n",
               (unsigned)hartid, DIM_M * DIM_N);
    } else {
        printf("[Main core %u] linalg_svd_lsv FAIL (%u/%d mismatches)\n",
               (unsigned)hartid, (unsigned)errors, DIM_M * DIM_N);
    }

    return (int)errors;
}
