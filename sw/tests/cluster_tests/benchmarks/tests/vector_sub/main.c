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
 * vector_sub — main core (CV32) binary. See vector_add/main.c for the full
 * rationale; same orchestration, PLAY's own golden vectors/tolerance.
 */

#include "magia_tile_utils.h"
#include "cluster_utils.h"

#define TARGET_IS_PULP_OPEN 1
#include "../../../../../../PLAY/test/vector_sub/test_data/data.h"

#include "vector_sub_pulp_task_bin.h"

#define TOLL 0.004f

#define X_BASE      (L1_BASE + 0x00000000)   /* vec_a copy : LEN*4 = 8192 B */
#define Y_BASE      (L1_BASE + 0x00003000)   /* vec_b copy : LEN*4 = 8192 B */
#define Z_BASE      (L1_BASE + 0x00006000)   /* result     : LEN*4 = 8192 B */
#define PARAMS_BASE (L1_BASE + 0x00009000)   /* vector_sub_params_t : 16 B  */

typedef struct {
    uint32_t src_a;
    uint32_t src_b;
    uint32_t dst;
    uint32_t len;
} vector_sub_params_t;

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
    volatile float *Y = (volatile float *)Y_BASE;
    for (int i = 0; i < LEN; i++) {
        X[i] = vec_a[i];
        Y[i] = vec_b[i];
    }

    volatile vector_sub_params_t *params =
        (volatile vector_sub_params_t *)PARAMS_BASE;
    params->src_a = X_BASE;
    params->src_b = Y_BASE;
    params->dst   = Z_BASE;
    params->len   = LEN;

    cluster_boot(PULP_BINARY_START);
    cluster_arm_done_event();
    cluster_dispatch_task_with_params(VECTOR_SUB_TASK, PARAMS_BASE);
    cluster_wait_done_eu();

    volatile float *Z = (volatile float *)Z_BASE;
    uint32_t errors = 0;
    for (int i = 0; i < LEN; i++) {
        if (fabs_f32(Z[i] - expected[i]) > TOLL)
            errors++;
    }

    if (errors == 0) {
        printf("[Main core %u] vector_sub PASS (%d elements)\n",
               (unsigned)hartid, LEN);
    } else {
        printf("[Main core %u] vector_sub FAIL (%u/%d mismatches)\n",
               (unsigned)hartid, (unsigned)errors, LEN);
    }

    return (int)errors;
}
