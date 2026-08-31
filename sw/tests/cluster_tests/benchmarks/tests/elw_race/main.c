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
 * elw_race — main core (CV32) binary.
 *
 * Minimal, deterministic reproduction of the cv.elw hang found while
 * porting vector_dot. See pulp_task/elw_race_task.c for why this runs
 * PLAY's real vector_dot kernel (not a hand-approximated version) and
 * sw/tests/cluster_tests/benchmarks/PIC_CALL_OVERHEAD.md for the full
 * writeup. If this hangs, the race is confirmed; if it prints PASS, the
 * fix (or the timing on this build) avoids it.
 */

#include "magia_tile_utils.h"
#include "cluster_utils.h"

#include "elw_race_pulp_task_bin.h"

/* Small on purpose -- just enough to keep the same shape (cv.setup hw
 * loop of cv.lw+fmadd.s) that vector_dot's disassembly shows right
 * before the barrier's cv.sw+cv.elw. LEN=2048 (the real vector_dot test)
 * reproduces the hang too, just ~30x slower to simulate. Must divide
 * evenly by PULP_CORE_COUNT (8) to keep the same block/left=0 path. */
#define LEN 64

#define X_BASE      (L1_BASE + 0x00000000)   /* vec_a copy : LEN*4 = 256 B */
#define Y_BASE      (L1_BASE + 0x00000400)   /* vec_b copy : LEN*4 = 256 B */
#define Z_BASE      (L1_BASE + 0x00000800)   /* result     : 4 B           */
#define PARAMS_BASE (L1_BASE + 0x00000c00)

typedef struct {
    uint32_t src_a;
    uint32_t src_b;
    uint32_t dst;
    uint32_t len;
} elw_race_params_t;

#define TOLL 0.004f

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
    float expected = 0.0f;
    for (int i = 0; i < LEN; i++) {
        X[i] = 1.0f;
        Y[i] = (float)(i % 4) - 1.5f; /* -1.5, -0.5, 0.5, 1.5, repeat */
        expected += X[i] * Y[i];
    }

    volatile elw_race_params_t *params =
        (volatile elw_race_params_t *)PARAMS_BASE;
    params->src_a = X_BASE;
    params->src_b = Y_BASE;
    params->dst   = Z_BASE;
    params->len   = LEN;

    cluster_boot(PULP_BINARY_START);
    cluster_arm_done_event();
    cluster_dispatch_task_with_params(ELW_RACE_TASK, PARAMS_BASE);
    cluster_wait_done_eu();

    volatile float *Z = (volatile float *)Z_BASE;
    uint32_t errors = (fabs_f32(*Z - expected) > TOLL) ? 1 : 0;

    if (errors == 0) {
        printf("[Main core %u] elw_race PASS (1 scalar)\n", (unsigned)hartid);
    } else {
        printf("[Main core %u] elw_race FAIL (scalar mismatch)\n",
               (unsigned)hartid);
    }

    return (int)errors;
}
