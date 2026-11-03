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
 * dcache_blocks_cluster_test - the break-even test of sw/tests/dcache_blocks_test.c on the 8 PULP cores.
 * Same kernel (sum of blocks of BLOCK words taken in random order, so that BLOCK sweeps from pure gather to
 * pure sequential) and same three variants, but the work is split across the team. The difference that
 * matters: there is one iDMA for the whole tile while the cache serves all eight cores, so in the iDMA
 * variant core 0 has to issue one descriptor per core per round and the others wait for it.
 * The staging area needs 2 halves x 8 cores x BLOCK words: a block larger than budget/64 words does not fit,
 * and is skipped with a line of its own.
 * Needs the cache (make dcache=1).
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "magia_dcache_utils.h"
#include "idma_mm_utils.h"
#include "bench_utils.h"
#include "cluster_utils.h"
#include "dcache_blocks_cluster_test.h"
#include "dcache_blocks_cluster_test_pulp_task_bin.h"

// GCC 14 crashes ("could not split insn", doloop_begin_i) on the cv32e40p hardware loop of the big loops
#pragma GCC optimize("no-branch-count-reg")

#ifndef N_WORDS
#define N_WORDS      (8 * 1024)               /* 32 KiB of data in the L2 */
#endif
#ifndef REUSE
#define REUSE        (1)
#endif
#ifndef BUDGET_KIB
#define BUDGET_KIB   (16)
#endif
#ifndef BLOCK_LIST
#define BLOCK_LIST   1, 2, 4, 8, 16, 32, 64, 128, 256, 512
#endif
#ifndef RUN_DIRECT
#define RUN_DIRECT   (1)
#endif
#ifndef ARENA_STRIDE
#define ARENA_STRIDE (0x00040000)
#endif

/* L2 arena, one per tile (see dcache_blocks_test.c: the program image is shared by the whole mesh) */
#define ARENA        (0xCC200000u + magia_tile_id() * ARENA_STRIDE)
#define SRC_ADDR     (ARENA)
#define IDX_ADDR     (ARENA + N_WORDS * 4 + 128)
#define ARENA_END    (IDX_ADDR + N_WORDS * 4)

/* L1: no mutable globals, the state of the control core lives in its own L1 */
#define PARAMS_OFF   (0)
#define STATE_OFF    (0x800)
#define BUF_OFF      (0x1000)
#define PARAMS       L1_GLOBAL(PARAMS_OFF)
#define STATE        L1_GLOBAL(STATE_OFF)
#define BUF          L1_GLOBAL(BUF_OFF)
#define BUF_LOC      L1_LOCAL(BUF_OFF)

#define errors       (*(volatile uint32_t *)(STATE + 0))
#define lcg_state    (*(volatile uint32_t *)(STATE + 4))

extern char _bss_end;

static const uint32_t block_list[] = {BLOCK_LIST};

static void check(const char *what, uint32_t block, uint32_t got, uint32_t expected) {
    if (got != expected) {
        printf("[FAIL] tile %d %s block=%d: got 0x%x, expected 0x%x\n", (int)magia_tile_id(), what, (int)block,
               (unsigned)got, (unsigned)expected);
        errors = errors + 1;
    }
}

static uint32_t lcg_next(void) {
    lcg_state = lcg_state * 1664525u + 1013904223u;
    return lcg_state;
}

/* A random permutation of the blocks (not of the words: overlapping blocks would break the checksum).
 * Written to the L2 by the core: the preparation is not timed and nothing is staged from the L1. */
static void make_block_permutation(uint32_t n_blocks, uint32_t block) {
    volatile uint32_t *idx = (volatile uint32_t *)IDX_ADDR;

    for (uint32_t i = 0; i < n_blocks; i++)
        idx[i] = i * block;
    for (uint32_t i = n_blocks - 1; i > 0; i--) {
        uint32_t j = lcg_next() % (i + 1);
        uint32_t tmp = idx[i];
        idx[i] = idx[j];
        idx[j] = tmp;
    }
    dcache_flush();
}

static uint32_t golden_sum(void) {
    uint32_t n = N_WORDS;
    uint32_t tri = (n % 2 == 0) ? (n / 2) * (n - 1) : n * ((n - 1) / 2);
    return tri * REUSE;
}

static void print_res(const char *variant, uint32_t block, uint32_t cycles, const dcache_perf_t *perf) {
    printf("RES tile=%d variant=%s block=%d reuse=%d cycles=%d hit_r=%d miss_r=%d refill=%d\n",
           (int)magia_tile_id(), variant, (int)block, REUSE, (int)cycles, (int)perf->hit_r, (int)perf->miss_r,
           (int)perf->refill);
}

static uint32_t max_cycles(volatile dbc_params_t *p) {
    uint32_t max = 0;
    for (int c = 0; c < PULP_CORE_COUNT; c++)
        if (p->cycles[c] > max)
            max = p->cycles[c];
    return max;
}

static uint32_t total_sum(volatile dbc_params_t *p) {
    uint32_t s = 0;
    for (int c = 0; c < PULP_CORE_COUNT; c++)
        s += p->partial[c];
    return s;
}

static void run_team(volatile dbc_params_t *p) {
    cluster_arm_done_event();
    cluster_dispatch_task_with_params(DCACHE_BLOCKS_CLUSTER_TEST_TASK, (uint32_t)p);
    cluster_wait_done_eu();
}

static void run_block(uint32_t block) {
    volatile dbc_params_t *p = (volatile dbc_params_t *)PARAMS;
    uint32_t n_blocks = N_WORDS / block;
    dcache_perf_t none = {0};
    dcache_perf_t perf;
    uint32_t spm_base, spm_size, t;

    if (n_blocks % PULP_CORE_COUNT != 0) {
        printf("block=%d: %d blocks do not divide among %d cores, skipped\n", (int)block, (int)n_blocks,
               PULP_CORE_COUNT);
        return;
    }
    make_block_permutation(n_blocks, block);
    p->src      = SRC_ADDR;
    p->idx      = IDX_ADDR;
    p->n_blocks = n_blocks;
    p->block    = block;
    p->reuse    = REUSE;
    p->buf      = BUF;
    p->buf_loc  = BUF_LOC;

    if (RUN_DIRECT) {
        p->variant = DBC_VAR_L2;
        dcache_flush();
        dcache_enable(0);
        t = read_mcycle(); run_team(p); t = read_mcycle() - t;
        dcache_enable(1);
        check("direct", block, total_sum(p), golden_sum());
        print_res("direct", block, max_cycles(p), &none);
    }

    /* The staging area is 2 halves x one block per core: a bigger block does not fit the budget */
    if (2 * PULP_CORE_COUNT * block * 4 <= BUDGET_KIB * 1024) {
        p->variant = DBC_VAR_IDMA;
        dcache_flush();
        dcache_enable(0);                     /* the iDMA brings everything to the SPM: the cache is out */
        t = read_mcycle(); run_team(p); t = read_mcycle() - t;
        dcache_enable(1);
        check("idma", block, total_sum(p), golden_sum());
        print_res("idma", block, max_cycles(p), &none);
    } else {
        printf("idma block=%d: 2 x %d x %d B of buffers do not fit %d KiB, skipped\n", (int)block,
               PULP_CORE_COUNT, (int)(block * 4), BUDGET_KIB);
    }

    for (uint32_t pf = 0; pf < 2; pf++) {
        uint32_t way_bytes = L1_DCACHE_SIZE / dcache_num_ways();
        uint32_t ways = (BUDGET_KIB * 1024) / way_bytes;

        if (ways == 0 || ways > dcache_num_ways())
            continue;
        p->variant = DBC_VAR_L2;
        dcache_set_ways(ways, &spm_base, &spm_size);
        dcache_set_prefetch(pf);
        dcache_flush();
        dcache_perf_start();
        t = read_mcycle(); run_team(p); t = read_mcycle() - t;
        dcache_perf_stop();
        dcache_perf_read(&perf);
        check(pf ? "cache_pf1" : "cache_pf0", block, total_sum(p), golden_sum());
        print_res(pf ? "cache_pf1" : "cache_pf0", block, max_cycles(p), &perf);
        dcache_set_prefetch(0);
        dcache_set_ways(dcache_num_ways(), &spm_base, &spm_size);
    }
}

int main(void) {
    volatile uint32_t *src = (volatile uint32_t *)SRC_ADDR;

    asm volatile("csrw mcountinhibit, zero");
    errors    = 0;
    lcg_state = 0x2026u + magia_tile_id();

    if (magia_tile_id() == 0)
        printf("dcache_blocks_cluster: %d cores, %d words, reuse %d, budget %d KiB, dcache %d ways x %d sets\n",
               PULP_CORE_COUNT, N_WORDS, REUSE, BUDGET_KIB, (int)dcache_num_ways(), MAGIA_DCACHE_SETS);
    if (!dcache_geometry_ok() || (uint32_t)&_bss_end > ARENA || ARENA_END > 0xCCF00000) {
        printf("[FAIL] tile %d: geometry or arena\n", (int)magia_tile_id());
        return 1;
    }

    cluster_boot(PULP_BINARY_START);
    for (uint32_t i = 0; i < N_WORDS; i++)
        src[i] = i;
    dcache_flush();

    for (uint32_t i = 0; i < sizeof(block_list) / sizeof(block_list[0]); i++)
        run_block(block_list[i]);

    printf("dcache_blocks_cluster_test: tile %d, %d errors\n", (int)magia_tile_id(), (int)errors);
    return errors;
}
