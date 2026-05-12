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
 * fpu_cluster_test - main core (CV32) binary.
 *
 * Releases the 8 PULP cluster cores and waits for them to complete.
 * Each cluster core runs a small set of single-precision FPU operations
 * (fadd.s, fmul.s, fsub.s) and writes a pass/fail word to L2.
 * The CV32 main then reads back those words and reports the result.
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "cluster_utils.h"

/* Result slot: 4 bytes per cluster core.
 * Cluster cores write 0xFEEDxxxx where xx = error count. */
#define FPU_RESULT_BASE  (L2_BASE + 0x00060000)
#define FPU_RESULT_MAGIC (0xFEED0000u)
#define FPU_RESULT_MASK  (0xFFFF0000u)

static inline uint32_t get_mhartid(void) {
    uint32_t hartid;
    asm volatile("csrr %0, mhartid" : "=r"(hartid));
    return hartid;
}

int main(void) {
    int print_summary = (get_mhartid() == 0);

    /* Arm EU before kicking the cluster to avoid missing the event. */
    cluster_init_eu();

    /* Release the PULP cluster cores. */
    if (print_summary)
        printf("[fpu_cluster_test] running %d PULP cores\n", PULP_CORE_COUNT);
    cluster_start();

    /* Sleep (cv.elw) until all cluster cores have exited. */
    cluster_wait_eu();

    /* Read back per-core results from L2 and report. */
    unsigned int total_errors = 0;
    unsigned int passed_cores = 0;
    for (int core_idx = 0; core_idx < PULP_CORE_COUNT; core_idx++) {
        uint32_t word = mmio32(FPU_RESULT_BASE + 4 * core_idx);
        if ((word & FPU_RESULT_MASK) != FPU_RESULT_MAGIC) {
            if (print_summary)
                printf("[fpu_cluster_test] core %d MISSING slot=0x%08x\n", core_idx, word);
            total_errors++;
        } else {
            unsigned int errs = word & 0xFFFFu;
            if (errs == 0) {
                passed_cores++;
            } else {
                if (print_summary)
                    printf("[fpu_cluster_test] core %d FAIL %u mismatches\n", core_idx, errs);
                total_errors += errs;
            }
        }
    }

    if (print_summary) {
        if (total_errors == 0)
            printf("[fpu_cluster_test] PASS: %u/%d cores, 3 ops/core\n",
                   passed_cores, PULP_CORE_COUNT);
        else
            printf("[fpu_cluster_test] FAIL: %u errors, %u/%d cores passed\n",
                   total_errors, passed_cores, PULP_CORE_COUNT);
    }

    return (int)total_errors;
}
