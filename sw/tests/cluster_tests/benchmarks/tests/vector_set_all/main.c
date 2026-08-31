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
 * vector_set_all — main core (CV32) binary. See vector_add/main.c.
 * No source vector to copy in: vector_set_all() writes `value` into a fresh
 * L1 buffer; PLAY's golden `vec[]` holds the expected all-`value` array.
 */

#include "magia_tile_utils.h"
#include "cluster_utils.h"

#define TARGET_IS_PULP_OPEN 1
#include "../../../../../../PLAY/test/vector_set_all/test_data/data.h"

#include "vector_set_all_pulp_task_bin.h"

#define TOLL 0.004f

#define Z_BASE      (L1_BASE + 0x00000000)   /* result : LEN*4 = 8192 B */
#define PARAMS_BASE (L1_BASE + 0x00003000)

typedef struct {
    uint32_t vec;
    float    val;
    uint32_t len;
} vector_set_all_params_t;

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

    volatile vector_set_all_params_t *params =
        (volatile vector_set_all_params_t *)PARAMS_BASE;
    params->vec = Z_BASE;
    params->val = value;
    params->len = LEN;

    cluster_boot(PULP_BINARY_START);
    cluster_arm_done_event();
    cluster_dispatch_task_with_params(VECTOR_SET_ALL_TASK, PARAMS_BASE);
    cluster_wait_done_eu();

    volatile float *Z = (volatile float *)Z_BASE;
    uint32_t errors = 0;
    for (int i = 0; i < LEN; i++) {
        if (fabs_f32(Z[i] - vec[i]) > TOLL)
            errors++;
    }

    if (errors == 0) {
        printf("[Main core %u] vector_set_all PASS (%d elements)\n",
               (unsigned)hartid, LEN);
    } else {
        printf("[Main core %u] vector_set_all FAIL (%u/%d mismatches)\n",
               (unsigned)hartid, (unsigned)errors, LEN);
    }

    return (int)errors;
}
