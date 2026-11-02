/*
 * Copyright (C) 2026 ETH Zurich, University of Bologna and Fondazione Chips-IT
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
 * Authors: Niccolò Giuliani <niccolo.giuliani@chips.it>
 *
 * dcache_cluster_test - main core: the data cache with several managers, and its effect on the SPM.
 *   Phase 1: the PULP cores read and write arrays in .data (through the cache), the main core checks them.
 *   Phase 2: the PULP cores sum an array in L1 (SPM) while the main core keeps reading .data (cache hits):
 *            the cluster cycles show how much the cache traffic slows down the SPM.
 * Same results with and without the cache (make dcache=0|1), only the cycles change.
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "magia_dcache_utils.h"
#include "cluster_utils.h"
#include "dcache_cluster_test_pulp_task_bin.h"

// GCC 14 crashes ("could not split insn", doloop_begin_i) on the cv32e40p hardware loop of the big loops
#pragma GCC optimize("no-branch-count-reg")

#define CACHED_WORDS (4096)                    /* 16 KiB: fits in the cache */
#define SPM_WORDS    (8192)                    /* 32 KiB in L1 */
#define SPM_REPS     (4)

#define SPM_BASE     (L1_BASE + 0x00000000)
#define PARAMS_BASE  (L1_BASE + 0x00008000)    /* dcache_cluster_params_t */

typedef struct {
    uint32_t mode;                             /* 1: cached arrays, 2: SPM array */
    uint32_t src;
    uint32_t dst;
    uint32_t partial;
    uint32_t len;
    uint32_t reps;
    uint32_t cycles[PULP_CORE_COUNT];
} dcache_cluster_params_t;

volatile uint32_t cached_src[CACHED_WORDS];
volatile uint32_t cached_dst[CACHED_WORDS];
volatile uint32_t cached_partial[PULP_CORE_COUNT];

// The main core sleeps while it waits (its mcycle stops): the cluster cores measure their own cycles
static void run_task(void) {
    cluster_arm_done_event();
    cluster_dispatch_task_with_params(DCACHE_CLUSTER_TEST_TASK, PARAMS_BASE);
    cluster_wait_done_eu();
}

static uint32_t max_cycles(volatile dcache_cluster_params_t *params) {
    uint32_t max = 0;
    for (int c = 0; c < PULP_CORE_COUNT; c++)
        if (params->cycles[c] > max)
            max = params->cycles[c];
    return max;
}

int main(void) {
    uint32_t errors = 0;
    uint32_t total, sum;
    dcache_perf_t perf;
    volatile dcache_cluster_params_t *params = (volatile dcache_cluster_params_t *)PARAMS_BASE;
    volatile uint32_t *spm = (volatile uint32_t *)SPM_BASE;

    cluster_boot(PULP_BINARY_START);

    // 1. Several managers on the cache: the arrays are dirty in the cache when the cluster starts
    for (int i = 0; i < CACHED_WORDS; i++)
        cached_src[i] = 5 * i + 1;
    params->mode    = 1;
    params->src     = (uint32_t)cached_src;
    params->dst     = (uint32_t)cached_dst;
    params->partial = (uint32_t)cached_partial;
    params->len     = CACHED_WORDS;
    params->reps    = 1;

    dcache_perf_start();
    run_task();
    dcache_perf_stop();
    dcache_perf_read(&perf);
    printf("phase 1 (cluster on .data): slowest core %d cycles\n", max_cycles(params));
    dcache_perf_print(&perf);

    if (cluster_task_crashed()) {
        printf("[FAIL] cluster task trapped (mcause=0x%08x)\n", cluster_get_mcause());
        return 1;
    }
    total = 0;
    for (int c = 0; c < PULP_CORE_COUNT; c++)
        total += cached_partial[c];
    if (total != 5 * (CACHED_WORDS * (CACHED_WORDS - 1) / 2) + CACHED_WORDS) {
        printf("[FAIL] partial sums: 0x%x\n", (unsigned)total);
        errors++;
    }
    for (int i = 0; i < CACHED_WORDS; i++) {
        if (cached_dst[i] != 3 * cached_src[i]) {
            if (errors < 8)
                printf("[FAIL] cached_dst[%d] = 0x%x\n", i, (unsigned)cached_dst[i]);
            errors++;
        }
    }

    // 2. The cluster on the SPM, the main core on the cache at the same time
    for (int i = 0; i < SPM_WORDS; i++)
        spm[i] = i;
    params->mode = 2;
    params->src  = SPM_BASE;
    params->len  = SPM_WORDS;
    params->reps = SPM_REPS;

    run_task();
    printf("phase 2 (cluster on SPM, main core idle): slowest core %d cycles\n", max_cycles(params));

    dcache_perf_start();
    cluster_arm_done_event();
    cluster_dispatch_task_with_params(DCACHE_CLUSTER_TEST_TASK, PARAMS_BASE);
    sum = 0;
    while (!cluster_done_pending())
        for (int i = 0; i < 256; i++)
            sum += cached_src[i];
    cluster_wait_done_eu();
    dcache_perf_stop();
    dcache_perf_read(&perf);
    printf("phase 2 (cluster on SPM, main core on .data): slowest core %d cycles\n", max_cycles(params));
    dcache_perf_print(&perf);

    total = 0;
    for (int c = 0; c < PULP_CORE_COUNT; c++)
        total += cached_partial[c];
    if (total != SPM_REPS * (SPM_WORDS * (SPM_WORDS - 1) / 2)) {
        printf("[FAIL] SPM partial sums: 0x%x\n", (unsigned)total);
        errors++;
    }

    printf("dcache_cluster_test: %d errors (sink 0x%x)\n", errors, (unsigned)sum);
    return errors;
}
