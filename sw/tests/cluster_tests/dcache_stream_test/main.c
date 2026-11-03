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
 * dcache_stream_test - the 8 PULP cores on three RaiderSTREAM kernels over L2 arrays (triad, gather, scatter),
 * with the three transports of raiderstream_test: L2 direct (cache off), iDMA tiles in the L1 SPM (double
 * buffered by cluster core 0) and the data cache with a budget of ways. It is the multi-core counterpart of
 * raiderstream_test: here several cores miss together, so the MSHRs and the wide port of the cache are the
 * thing under test. The control core prepares the arrays, runs each case and checks the results.
 * Needs the cache (make dcache=1).
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "magia_dcache_utils.h"
#include "idma_mm_utils.h"
#include "cluster_utils.h"
#include "dcache_stream_test.h"
#include "dcache_stream_test_pulp_task_bin.h"

// GCC 14 crashes ("could not split insn", doloop_begin_i) on the cv32e40p hardware loop of the big loops
#pragma GCC optimize("no-branch-count-reg")

#ifndef BUDGETS_KIB
#define BUDGETS_KIB  16, 32
#endif
#ifndef CACHE_PF
#define CACHE_PF     (3)                       /* bit 0: prefetch off, bit 1: prefetch on */
#endif

/* L2 arena: the four arrays, 128 B apart so that a[j], b[j] and c[j] do not share a set */
#define ARENA       (0xCC100000)
#define ARR_BYTES   (STREAM_N_WORDS * 4 + 128)
#define A_ADDR      (ARENA)
#define B_ADDR      (A_ADDR + ARR_BYTES)
#define C_ADDR      (B_ADDR + ARR_BYTES)
#define IDX_ADDR    (C_ADDR + ARR_BYTES)
#define ARENA_END   (IDX_ADDR + STREAM_N_WORDS * 4)

#define PARAMS_BASE (L1_BASE)                  /* small, and below everything else */
#define SPM         (L1_BASE + 0x00001000)     /* iDMA buffers, and the permutation scratch before the runs */

#define a_arr   ((volatile uint32_t *)A_ADDR)
#define c_arr   ((volatile uint32_t *)C_ADDR)
#define idx_arr ((volatile uint32_t *)IDX_ADDR)

static const uint32_t budgets_kib[] = {BUDGETS_KIB};
static const char *kernel_name[STREAM_NUM_KERNELS] = {"triad", "gather", "scatter"};
static volatile uint32_t partial[PULP_CORE_COUNT];
static uint32_t errors = 0;

static void check(const char *what, uint32_t got, uint32_t expected) {
    if (got != expected) {
        printf("[FAIL] %s: got 0x%x, expected 0x%x\n", what, (unsigned)got, (unsigned)expected);
        errors++;
    }
}

static inline void wait_out(uint32_t id) {
    while ((int32_t)(idma_mm_get_done_id_dir(1, 0) - id) < 0);
}

// The main core sleeps while it waits (its mcycle stops): the cluster cores measure their own cycles
static void run_task(void) {
    volatile dcache_stream_params_t *params = (volatile dcache_stream_params_t *)PARAMS_BASE;
    cluster_arm_done_event();
    cluster_dispatch_task_with_params(DCACHE_STREAM_TEST_TASK, PARAMS_BASE);
    cluster_wait_done_eu();
    (void)params;
}

static uint32_t max_cycles(volatile dcache_stream_params_t *params) {
    uint32_t max = 0;
    for (int c = 0; c < PULP_CORE_COUNT; c++)
        if (params->cycles[c] > max)
            max = params->cycles[c];
    return max;
}

/* The arrays the kernels write, back to their initial values (through the cache, not timed) */
static void init_arrays(void) {
    dcache_set_prefetch(0);
    for (uint32_t i = 0; i < STREAM_N_WORDS; i++) {
        a_arr[i] = i;
        c_arr[i] = i + STREAM_OC;
    }
    dcache_flush();
}

/* Words of one tile for the whole team: a power of two, the streams double buffered inside the budget */
static uint32_t tile_words_for(uint32_t kernel, uint32_t budget) {
    uint32_t streams = stream_nb_streams(kernel);
    uint32_t tw = PULP_CORE_COUNT;
    while (2 * tw * streams * 2 * 4 <= budget && 2 * tw <= STREAM_N_WORDS)
        tw = 2 * tw;
    return tw;
}

static void print_res(const char *variant, uint32_t budget, uint32_t kernel, uint32_t cycles,
                      const dcache_perf_t *perf) {
    printf("RES variant=%s budget=%d kernel=%s cycles=%d hit_r=%d miss_r=%d hit_w=%d miss_w=%d refill=%d wb=%d\n",
           variant, (int)(budget / 1024), kernel_name[kernel], (int)cycles, (int)perf->hit_r, (int)perf->miss_r,
           (int)perf->hit_w, (int)perf->miss_w, (int)perf->refill, (int)perf->writeback);
}

static void check_results(uint32_t kernel, const char *what) {
    uint32_t sum = 0;

    dcache_flush();
    if (kernel == STREAM_K_TRIAD) {
        for (uint32_t j = 0; j < STREAM_N_WORDS; j += 251)
            check(what, a_arr[j], (j + STREAM_OB) + STREAM_SCALAR * (j + STREAM_OC));
        check(what, a_arr[STREAM_N_WORDS - 1],
              (STREAM_N_WORDS - 1 + STREAM_OB) + STREAM_SCALAR * (STREAM_N_WORDS - 1 + STREAM_OC));
    } else if (kernel == STREAM_K_GATHER) {
        // The chunks of the 8 cores cover every j, and idx is a permutation: the total is the sum of a
        for (int c = 0; c < PULP_CORE_COUNT; c++)
            sum += partial[c];
        check(what, sum, stream_sum(STREAM_N_WORDS, 0));
    } else {
        // c is a permutation of a: same sum, and the sampled words are in their place
        for (uint32_t j = 0; j < STREAM_N_WORDS; j++)
            sum += c_arr[j];
        check(what, sum, stream_sum(STREAM_N_WORDS, 0));
        for (uint32_t j = 0; j < STREAM_N_WORDS; j += 251)
            check(what, c_arr[idx_arr[j]], j);
    }
}

/* One case: the cache set up for the variant, the task, the check and the result line */
static void run_case(uint32_t kernel, uint32_t variant, uint32_t budget, uint32_t prefetch) {
    volatile dcache_stream_params_t *params = (volatile dcache_stream_params_t *)PARAMS_BASE;
    const char   *variant_name;
    uint32_t      way_bytes = L1_DCACHE_SIZE / dcache_num_ways();
    uint32_t      ways = budget / way_bytes;
    uint32_t      spm_base, spm_size;
    dcache_perf_t perf;

    if (variant == STREAM_VAR_CACHE) {
        variant_name = prefetch ? "cache_pf1" : "cache_pf0";
        if (ways == 0 || ways > dcache_num_ways() || ways * way_bytes != budget) {
            printf("cache %d KiB: not a number of ways, skipped\n", (int)(budget / 1024));
            return;
        }
    } else {
        variant_name = (variant == STREAM_VAR_DIRECT) ? "direct" : "idma";
    }

    for (int c = 0; c < PULP_CORE_COUNT; c++)
        partial[c] = 0xDEADBEEF;
    init_arrays();
    params->kernel     = kernel;
    params->n_words    = STREAM_N_WORDS;
    params->variant    = variant;
    params->a          = A_ADDR;
    params->b          = B_ADDR;
    params->c          = C_ADDR;
    params->idx        = IDX_ADDR;
    params->spm        = SPM;
    params->tile_words = tile_words_for(kernel, budget);
    params->partial    = (uint32_t)partial;

    // direct and iDMA run with the cache off: in both the cores reach the L2 without it
    if (variant == STREAM_VAR_CACHE) {
        dcache_set_ways(ways, &spm_base, &spm_size);
        dcache_set_prefetch(prefetch);
    } else {
        dcache_enable(0);
    }
    dcache_perf_start();
    run_task();
    dcache_perf_stop();
    dcache_perf_read(&perf);
    if (variant == STREAM_VAR_CACHE) {
        dcache_set_prefetch(0);
        dcache_set_ways(dcache_num_ways(), &spm_base, &spm_size);
    } else {
        dcache_enable(1);
    }

    if (cluster_task_crashed()) {
        printf("[FAIL] cluster task trapped (mcause=0x%08x)\n", (unsigned)cluster_get_mcause());
        errors++;
        return;
    }
    print_res(variant_name, (variant == STREAM_VAR_DIRECT) ? 0 : budget, kernel, max_cycles(params), &perf);
    check_results(kernel, variant_name);
}

/* A random permutation of 0 .. N-1 (Fisher-Yates, as RaiderSTREAM), built in the SPM and sent to the L2 */
static void make_permutation(void) {
    volatile uint32_t *scratch = (volatile uint32_t *)SPM;
    uint32_t lcg = 0x2026u;

    for (uint32_t i = 0; i < STREAM_N_WORDS; i++)
        scratch[i] = i;
    for (uint32_t i = STREAM_N_WORDS - 1; i > 0; i--) {
        lcg = lcg * 1664525u + 1013904223u;
        uint32_t j = lcg % (i + 1);
        uint32_t tmp = scratch[i];
        scratch[i] = scratch[j];
        scratch[j] = tmp;
    }
    // The length of one iDMA transfer is 16 bits: a big permutation goes out in chunks
    uint32_t id = 0;
    for (uint32_t off = 0; off < STREAM_N_WORDS * 4; off += 32768) {
        uint32_t len = (STREAM_N_WORDS * 4 - off < 32768) ? STREAM_N_WORDS * 4 - off : 32768;
        id = idma_L1ToL2(SPM + off, IDX_ADDR + off, len);
    }
    wait_out(id);
}

int main(void) {
    volatile uint32_t *b_arr = (volatile uint32_t *)B_ADDR;

    asm volatile("csrw mcountinhibit, zero");
    printf("dcache_stream: %d cores, %d words per array, dcache %d ways x %d sets (%d KiB), geometry %s\n",
           PULP_CORE_COUNT, STREAM_N_WORDS, (int)dcache_num_ways(), MAGIA_DCACHE_SETS, L1_DCACHE_SIZE / 1024,
           dcache_geometry_ok() ? "ok" : "MISMATCH");
    if (!dcache_geometry_ok() || ARENA_END > 0xCCF00000) {
        printf("[FAIL] geometry or arena\n");
        return 1;
    }

    cluster_boot(PULP_BINARY_START);
    make_permutation();
    for (uint32_t i = 0; i < STREAM_N_WORDS; i++)
        b_arr[i] = i + STREAM_OB;
    dcache_flush();

    for (uint32_t k = 0; k < STREAM_NUM_KERNELS; k++) {
        run_case(k, STREAM_VAR_DIRECT, 0, 0);
        for (uint32_t i = 0; i < sizeof(budgets_kib) / sizeof(budgets_kib[0]); i++) {
            uint32_t budget = budgets_kib[i] * 1024;
            run_case(k, STREAM_VAR_IDMA, budget, 0);
            if (CACHE_PF & 1)
                run_case(k, STREAM_VAR_CACHE, budget, 0);
            if (CACHE_PF & 2)
                run_case(k, STREAM_VAR_CACHE, budget, 1);
        }
    }

    printf("dcache_stream_test: %d errors\n", (int)errors);
    return errors;
}
