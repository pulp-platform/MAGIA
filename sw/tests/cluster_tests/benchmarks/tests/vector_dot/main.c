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
 * vector_dot — main core (CV32) binary. See vector_add/main.c.
 * Scalar-output reduction: compares a single float against PLAY's
 * `expected` scalar.
 */

#include "magia_tile_utils.h"
#include "cluster_utils.h"

#define TARGET_IS_PULP_OPEN 1
#include "../../../../../../PLAY/test/vector_dot/test_data/data.h"

#include "vector_dot_pulp_task_bin.h"

#define TOLL 0.004f

#define X_BASE      (L1_BASE + 0x00000000)   /* vec_a copy : LEN*4 = 8192 B */
#define Y_BASE      (L1_BASE + 0x00003000)   /* vec_b copy : LEN*4 = 8192 B */
#define Z_BASE      (L1_BASE + 0x00006000)   /* result     : 4 B            */
#define PARAMS_BASE (L1_BASE + 0x00009000)

typedef struct {
    uint32_t src_a;
    uint32_t src_b;
    uint32_t dst;
    uint32_t len;
} vector_dot_params_t;

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

    volatile vector_dot_params_t *params =
        (volatile vector_dot_params_t *)PARAMS_BASE;
    params->src_a = X_BASE;
    params->src_b = Y_BASE;
    params->dst   = Z_BASE;
    params->len   = LEN;

    cluster_boot(PULP_BINARY_START);
    cluster_arm_done_event();
    cluster_dispatch_task_with_params(VECTOR_DOT_TASK, PARAMS_BASE);
    cluster_wait_done_eu();

    volatile float *Z = (volatile float *)Z_BASE;
    uint32_t errors = (fabs_f32(*Z - expected) > TOLL) ? 1 : 0;

    if (errors == 0) {
        printf("[Main core %u] vector_dot PASS (1 scalar)\n", (unsigned)hartid);
    } else {
        printf("[Main core %u] vector_dot FAIL (scalar mismatch)\n",
               (unsigned)hartid);
    }

    return (int)errors;
}
