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
 *
 * Authors: Luca Balboni <luca.balboni@chips.it>
 *
 * vector_add - main core: bare-metal port of PLAY's vector_add, checks the cluster sums bit-exactly
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "cluster_utils.h"
#include "vector_add_pulp_task_bin.h"

#define LEN          (2048)

#define SRC_A_BASE   (L1_BASE + 0x00000000)   /* LEN*4 = 8 KB */
#define SRC_B_BASE   (L1_BASE + 0x00002000)   /* LEN*4 = 8 KB */
#define DST_BASE     (L1_BASE + 0x00004000)   /* LEN*4 = 8 KB */
#define PARAMS_BASE  (L1_BASE + 0x00006000)   /* vector_add_params_t */

typedef struct {
    uint32_t src_a;
    uint32_t src_b;
    uint32_t dst;
    uint32_t len;
} vector_add_params_t;

static inline uint32_t get_hartid(void) {
    uint32_t hartid;
    asm volatile("csrr %0, mhartid" : "=r"(hartid));
    return hartid;
}

/* Multiples of 0.25 well inside the float32 exact range: every sum is exact */
static inline float src_a_val(int i) { return (float)i * 0.5f; }
static inline float src_b_val(int i) { return (float)(LEN - i) * 0.25f; }

int main(void) {
    uint32_t hartid = get_hartid();

    volatile float *src_a = (volatile float *)SRC_A_BASE;
    volatile float *src_b = (volatile float *)SRC_B_BASE;
    volatile float *dst   = (volatile float *)DST_BASE;
    for (int i = 0; i < LEN; i++) {
        src_a[i] = src_a_val(i);
        src_b[i] = src_b_val(i);
        dst[i]   = -1.0f;
    }

    volatile vector_add_params_t *params = (volatile vector_add_params_t *)PARAMS_BASE;
    params->src_a = SRC_A_BASE;
    params->src_b = SRC_B_BASE;
    params->dst   = DST_BASE;
    params->len   = LEN;

    printf("[vector_add] %d elements on %d PULP cores\n", LEN, PULP_CORE_COUNT);
    cluster_boot(PULP_BINARY_START);

    /* Arm EU before dispatching the task to avoid missing DONE. */
    cluster_arm_done_event();

    cluster_dispatch_task_with_params(VECTOR_ADD_TASK, PARAMS_BASE);

    /* Sleep (cv.elw) until core 0 signals the fork has completed. */
    cluster_wait_done_eu();

    if (cluster_task_crashed()) {
        printf("[vector_add] FAIL: cluster task trapped (mcause=0x%08x)\n",
               cluster_get_mcause());
        return 1;
    }

    uint32_t errors = 0;
    for (int i = 0; i < LEN; i++) {
        float exp = src_a_val(i) + src_b_val(i);
        if (dst[i] != exp) {
            if (errors < 8)
                printf("[vector_add] dst[%d] mismatch\n", i);
            errors++;
        }
    }

    if (errors == 0)
        printf("[Main core %u] vector_add PASS (%d elements)\n", (unsigned)hartid, LEN);
    else
        printf("[Main core %u] vector_add FAIL (%u/%d mismatches)\n",
               (unsigned)hartid, (unsigned)errors, LEN);

    return (int)errors;
}
