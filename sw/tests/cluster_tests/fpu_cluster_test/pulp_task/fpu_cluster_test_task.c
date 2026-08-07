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
 * Authors: Niccolò Giuliani, Fondazione Chips-IT
 */

/*
 * fpu_cluster_test - PULP cluster-core binary.
 *
 * Mirrors sw/tests/fpu_test.c but runs on all 8 cluster cores. Only core 0
 * is ever dispatched directly (pulp_crt0.S's single mailbox);
 * fpu_cluster_test_task forks the actual body onto all 8 cores with
 * pi_cl_team_fork() so cores 1-7 -- otherwise parked in worker_wait -- run
 * it too. Each core performs:
 *   fadd.s:  12.34 + 56.78  ~ 69.12  (tolerance 0.1)
 *   fsub.s:  56.78 - 12.34  ~ 44.44  (tolerance 0.1)
 *   fmul.s:  12.34 * 2.0    ~ 24.68  (tolerance 0.1)
 *
 * 12.34 and 56.78 are NOT exact in float32, so comparisons use the same
 * 0.1 tolerance as fpu_test.c rather than bit-exact equality.
 *
 * Each core writes a 32-bit word to L2: 0xFEED0000 | <error_count_16bit>.
 * After the fork's implicit barrier, core 0 sums all 8 error counts and
 * returns the total through PULP_RETURN; the CV32 main also reads the
 * per-core L2 words back for the detailed report.
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "cluster_utils.h"

/* L2 result area: 4 bytes per cluster core (local_id 0..7). */
#define FPU_RESULT_BASE  (L2_BASE + 0x00060000)
#define FPU_RESULT_MAGIC (0xFEED0000u)

#define A_VAL  (12.34f)
#define B_VAL  (56.78f)
#define ADD_EXP (69.12f)
#define SUB_EXP (44.44f)
#define MUL_EXP (24.68f)
#define FP_TH  (0.1f)

#define abs_diff(x, y) (((x) > (y)) ? ((x) - (y)) : ((y) - (x)))

/* Enable the FPU: set mstatus.FS to INITIAL (01). */
static inline void enable_fpu(void) {
    asm volatile (
        "li t0, 0x2000\n"
        "csrs mstatus, t0\n"
        ::: "t0"
    );
}

static void fpu_cluster_test_fork_entry(void *data) {
    (void)data;
    enable_fpu();

    uint32_t local_id = cluster_core_id();

    unsigned int errors = 0;

    volatile float a = A_VAL;
    volatile float b = B_VAL;

    /* fadd.s: a + b ~ 69.12 */
    float c_add = a + b;
    if (abs_diff(c_add, ADD_EXP) > FP_TH) errors++;

    /* fsub.s: b - a ~ 44.44 */
    float c_sub = b - a;
    if (abs_diff(c_sub, SUB_EXP) > FP_TH) errors++;

    /* fmul.s: a * 2.0 ~ 24.68 */
    volatile float two = 2.0f;
    float c_mul = a * two;
    if (abs_diff(c_mul, MUL_EXP) > FP_TH) errors++;

    if (errors != 0) {
        printf("[PULP FPU] core %u: %u errors (add=%s sub=%s mul=%s)\n",
               local_id, errors,
               (abs_diff(c_add, ADD_EXP) <= FP_TH) ? "OK" : "FAIL",
               (abs_diff(c_sub, SUB_EXP) <= FP_TH) ? "OK" : "FAIL",
               (abs_diff(c_mul, MUL_EXP) <= FP_TH) ? "OK" : "FAIL");
    }

    /* Write result to L2 slot for this core. */
    mmio32(FPU_RESULT_BASE + 4 * local_id) = FPU_RESULT_MAGIC | (errors & 0xFFFFu);
}

int fpu_cluster_test_task(void *data) {
    pi_cl_team_fork(PULP_CORE_COUNT, fpu_cluster_test_fork_entry, data);

    /* Safe to read every slot now -- the fork's barrier guarantees every
     * core's write already happened. */
    unsigned int total_errors = 0;
    for (int i = 0; i < PULP_CORE_COUNT; i++) {
        total_errors += mmio32(FPU_RESULT_BASE + 4 * i) & 0xFFFFu;
    }
    return (int)total_errors;
}
