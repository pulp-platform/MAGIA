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
 * dcache_order_test - main core: order rules between the narrow hit port and the miss engine of the data cache.
 * Several PULP cores read and write the same lines, more lines per set than ways, so dirty lines are evicted
 * while other cores hit them (see pulp_task/). Every configuration checks the values twice: through the cache,
 * then from L2 after a flush with the cache off. The monitor of the testbench prints, for every configuration,
 * how often the order rules held the miss engine (miss_hold) or a refill (refill_wait).
 * Same results with and without the cache (make dcache=0|1), only the cycles change.
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "magia_dcache_utils.h"
#include "cluster_utils.h"
#include "dcache_order_test_pulp_task_bin.h"

// GCC 14 crashes ("could not split insn", doloop_begin_i) on the cv32e40p hardware loop of the big loops
#pragma GCC optimize("no-branch-count-reg")

#define LINE_WORDS  (32)
#define SET_WORDS   (64 * LINE_WORDS)        /* 8 KiB: lines at this distance share the set */
#define MAX_DEPTH   (8)
#define MAX_LINES   (64)
#define HANG_CYCLES (1000000)  /* polled with mcycle, enabled at the start of main */

#define SPM_BASE    (L1_BASE + 0x00000000)
#define PARAMS_BASE (L1_BASE + 0x00008000)   /* dcache_order_params_t */

typedef struct {
    uint32_t buf;
    uint32_t spm;
    uint32_t nsets;
    uint32_t depth;
    uint32_t reps;
    uint32_t ncache;
    uint32_t done[PULP_CORE_COUNT];
    uint32_t errors[PULP_CORE_COUNT];
    uint32_t cycles[PULP_CORE_COUNT];
    uint32_t progress[PULP_CORE_COUNT];  /* accesses done, read by the main core if the task hangs */
} dcache_order_params_t;

typedef struct {
    uint32_t nsets;
    uint32_t depth;
    uint32_t reps;
    uint32_t ncache;
    uint32_t prefetch;
} order_cfg_t;

/* 64 KiB = 2x the cache: MAX_DEPTH lines for each of the 64 sets */
volatile uint32_t order_buf[MAX_DEPTH * SET_WORDS] __attribute__((aligned(8192)));

static const order_cfg_t cfgs[] = {
    {4, 8,  8, 2, 0},   /* 2 cores on the cache, 6 on the SPM banks of their words */
    {4, 8,  8, 3, 0},   /* 3 cores on the cache */
    {4, 8,  8, 6, 0},   /* 4 sets x 8 lines, 6 cores on the cache, 2 on the SPM banks of their words */
    {1, 8, 16, 6, 0},   /* all on one set */
    {8, 5,  8, 6, 0},   /* 5 lines per set: one more than the ways */
    {4, 8,  8, 8, 0},   /* 8 cores on the cache, no SPM traffic */
    {4, 8,  8, 6, 1},   /* as the first one, with the next-line prefetch */
};

static inline uint32_t read_mcycle(void) {
    uint32_t cycles;
    asm volatile("csrr %0, mcycle" : "=r"(cycles));
    return cycles;
}

static volatile uint32_t *line_addr(uint32_t set, uint32_t k) {
    return order_buf + k * SET_WORDS + set * LINE_WORDS;
}

static uint32_t check(const order_cfg_t *c, const char *where) {
    uint32_t errors = 0;
    for (uint32_t set = 0; set < c->nsets; set++) {
        for (uint32_t k = 0; k < c->depth; k++) {
            volatile uint32_t *line = line_addr(set, k);
            for (uint32_t w = 0; w < LINE_WORDS; w++) {
                uint32_t expected = (w < c->ncache) ? c->reps : 0;
                if (line[w] != expected) {
                    if (errors < 8)
                        printf("[FAIL] %s: set %d line %d word %d = %d, expected %d\n", where, set, k, w,
                               line[w], expected);
                    errors++;
                }
            }
        }
    }
    return errors;
}

int main(void) {
    uint32_t errors = 0;
    dcache_perf_t perf;
    volatile dcache_order_params_t *params = (volatile dcache_order_params_t *)PARAMS_BASE;
    volatile uint32_t *spm = (volatile uint32_t *)SPM_BASE;

    asm volatile("csrw mcountinhibit, zero");  // mcycle for the hang limit
    cluster_boot(PULP_BINARY_START);
    for (int i = 0; i < MAX_LINES * LINE_WORDS; i++)
        spm[i] = i;

    for (uint32_t n = 0; n < sizeof(cfgs) / sizeof(cfgs[0]); n++) {
        const order_cfg_t *c = &cfgs[n];
        uint32_t task_errors = 0, max_cycles = 0;

        for (uint32_t set = 0; set < c->nsets; set++)
            for (uint32_t k = 0; k < c->depth; k++)
                for (uint32_t w = 0; w < LINE_WORDS; w++)
                    line_addr(set, k)[w] = 0;
        params->buf    = (uint32_t)order_buf;
        params->spm    = SPM_BASE;
        params->nsets  = c->nsets;
        params->depth  = c->depth;
        params->reps   = c->reps;
        params->ncache = c->ncache;
        for (int i = 0; i < PULP_CORE_COUNT; i++) {
            params->progress[i] = 0;
            params->done[i]   = 0;
            params->errors[i] = 0;
        }

        dcache_set_prefetch(c->prefetch);
        dcache_perf_start();
        cluster_arm_done_event();
        cluster_dispatch_task_with_params(DCACHE_ORDER_TEST_TASK, PARAMS_BASE);
        // Poll with a limit instead of sleeping: a hang prints how far every core got
        uint32_t t0 = read_mcycle();
        while (!cluster_done_pending()) {
            if (read_mcycle() - t0 > HANG_CYCLES) {
                printf("[FAIL] cfg %d: cluster not done after %d cycles\n", n, HANG_CYCLES);
                for (int i = 0; i < PULP_CORE_COUNT; i++)
                    printf("  core %d: progress %d done %d\n", i, params->progress[i], params->done[i]);
                return 1;
            }
        }
        cluster_wait_done_eu();
        dcache_perf_stop();
        dcache_perf_read(&perf);
        dcache_set_prefetch(0);

        if (cluster_task_crashed()) {
            printf("[FAIL] cluster task trapped (mcause=0x%08x)\n", cluster_get_mcause());
            return 1;
        }
        for (int i = 0; i < PULP_CORE_COUNT; i++) {
            task_errors += params->errors[i];
            if (params->cycles[i] > max_cycles)
                max_cycles = params->cycles[i];
        }
        printf("order cfg %d (sets %d, depth %d, reps %d, cache cores %d, prefetch %d): slowest core %d cycles, "
               "%d stale reads\n", n, c->nsets, c->depth, c->reps, c->ncache, c->prefetch, max_cycles, task_errors);
        dcache_perf_print(&perf);
        errors += task_errors;

        // Through the cache, then from L2 with the cache off (the flush wrote every dirty line back)
        errors += check(c, "cache");
        dcache_enable(0);
        errors += check(c, "L2");
        dcache_enable(1);
    }

    printf("dcache_order_test: %d errors\n", errors);
    return errors;
}
