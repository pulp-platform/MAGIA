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
 * dcache_mshr_test - main core: the 8 PULP cores miss in the data cache at the same time, on a 128 KiB array
 * (4x the cache), with the patterns of dcache_mshr_test.h: dense writes (init), dense reads, one word per line,
 * stride of one way (every access on the same set), stride of one way plus one line, random words.
 * Every pattern starts from a clean cache (flush). The main core checks the sum of each core, in core order.
 * The random and dense patterns run again with the next-line prefetch.
 * Same results with and without the cache (make dcache=0|1), only the cycles change.
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "magia_dcache_utils.h"
#include "cluster_utils.h"
#include "dcache_mshr_test.h"
#include "dcache_mshr_test_pulp_task_bin.h"

// GCC 14 crashes ("could not split insn", doloop_begin_i) on the cv32e40p hardware loop of the big loops
#pragma GCC optimize("no-branch-count-reg")

// Modes that run (make EXTRA_CFLAGS=-DMSHR_RUN_MASK=0x9): bit m = mode m without prefetch (0..5), bits 6, 7, 8 =
// dense, sparse, random with prefetch. Default: all of them
#ifndef MSHR_RUN_MASK
#define MSHR_RUN_MASK (0x1FF)
#endif

#define BIG_BASE    (0xCC200000)               /* 128 KiB in the cacheable L2 region, way aligned */
#define PARAMS_BASE (L1_BASE + 0x00008000)     /* dcache_mshr_params_t */

static const char *mode_name[MSHR_NUM_MODES] = {"init", "dense", "sparse", "stride_way", "stride_line", "random"};

static volatile uint32_t partial[PULP_CORE_COUNT];

// The main core sleeps while it waits (its mcycle stops): the cluster cores measure their own cycles
static void run_task(void) {
    cluster_arm_done_event();
    cluster_dispatch_task_with_params(DCACHE_MSHR_TEST_TASK, PARAMS_BASE);
    cluster_wait_done_eu();
}

static uint32_t max_cycles(volatile dcache_mshr_params_t *params) {
    uint32_t max = 0;
    for (int c = 0; c < PULP_CORE_COUNT; c++)
        if (params->cycles[c] > max)
            max = params->cycles[c];
    return max;
}

// Sum of mshr_value(i) for i in [first, first + n), modulo 2^32
static uint32_t dense_sum(uint32_t first, uint32_t n) {
    uint32_t tri = (n % 2 == 0) ? (n / 2) * (n - 1) : n * ((n - 1) / 2);
    return 0x9E3779B1u * (n * first + tri) + 7u * n;
}

static uint32_t expected_sum(uint32_t mode, uint32_t c) {
    uint32_t offset = cluster_chunk_offset(MSHR_BIG_WORDS, PULP_CORE_COUNT, c);
    uint32_t size   = cluster_chunk_size(MSHR_BIG_WORDS, PULP_CORE_COUNT, c);
    uint32_t sum    = 0;
    uint32_t lcg    = mshr_lcg_seed(c);

    if (mode == MSHR_MODE_INIT)
        return 0;
    if (mode == MSHR_MODE_DENSE)
        return dense_sum(offset, size);
    if (mode == MSHR_MODE_SPARSE) {
        for (uint32_t r = 0; r < MSHR_SPARSE_REPS; r++)
            for (uint32_t i = offset + r; i < offset + size; i += MSHR_LINE_WORDS)
                sum += mshr_value(i);
    } else if (mode == MSHR_MODE_STRIDE_WAY || mode == MSHR_MODE_STRIDE_LINE) {
        for (uint32_t j = 0; j < MSHR_STRIDE_ACC; j++)
            sum += mshr_value(mshr_stride_index(mode, c, j));
    } else {
        for (uint32_t j = 0; j < MSHR_RANDOM_ACC; j++)
            sum += mshr_value(mshr_lcg_next(&lcg));
    }
    return sum;
}

static uint32_t run_mode(uint32_t mode, uint32_t prefetch) {
    volatile dcache_mshr_params_t *params = (volatile dcache_mshr_params_t *)PARAMS_BASE;
    dcache_perf_t perf;
    uint32_t errors = 0;

    for (int c = 0; c < PULP_CORE_COUNT; c++)
        partial[c] = 0xDEADBEEF;
    params->mode    = mode;
    params->big     = BIG_BASE;
    params->partial = (uint32_t)partial;

    // Clean and empty cache: every pattern starts cold, the partial sums reach L2
    dcache_flush();
    dcache_set_prefetch(prefetch);
    dcache_perf_start();
    run_task();
    dcache_perf_stop();
    dcache_set_prefetch(0);
    dcache_perf_read(&perf);
    printf("mode %s%s: slowest core %d cycles\n", mode_name[mode], prefetch ? "+pf" : "", (int)max_cycles(params));
    dcache_perf_print(&perf);

    if (cluster_task_crashed()) {
        printf("[FAIL] cluster task trapped (mcause=0x%08x)\n", (unsigned)cluster_get_mcause());
        return 1;
    }
    // In core order: the result of core c must be the one of core c
    for (int c = 0; c < PULP_CORE_COUNT; c++) {
        uint32_t expected = expected_sum(mode, c);
        if (partial[c] != expected) {
            printf("[FAIL] mode %s core %d: 0x%x, expected 0x%x\n", mode_name[mode], c, (unsigned)partial[c],
                   (unsigned)expected);
            errors++;
        }
    }
    return errors;
}

int main(void) {
    uint32_t errors = 0;

    cluster_boot(PULP_BINARY_START);

    for (uint32_t mode = 0; mode < MSHR_NUM_MODES; mode++)
        if (MSHR_RUN_MASK & (1u << mode))
            errors += run_mode(mode, 0);
    if (MSHR_RUN_MASK & (1u << 6))
        errors += run_mode(MSHR_MODE_DENSE, 1);
    if (MSHR_RUN_MASK & (1u << 7))
        errors += run_mode(MSHR_MODE_SPARSE, 1);
    if (MSHR_RUN_MASK & (1u << 8))
        errors += run_mode(MSHR_MODE_RANDOM, 1);

    printf("dcache_mshr_test: %d errors\n", (int)errors);
    return errors;
}
