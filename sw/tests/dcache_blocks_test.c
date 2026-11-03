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
 * Where the iDMA and the cache cross. The kernel sums blocks of BLOCK consecutive words, taken in random
 * order:
 *
 *     for (j = 0; j < n_blocks; j++)
 *         for (k = 0; k < BLOCK; k++)
 *             sum += src[idx[j] + k];
 *
 * BLOCK = 1 is a pure gather (one word per index), BLOCK = N is a pure sequential read: one parameter covers
 * the whole range between the two cases we already know go one way and the other. The iDMA pays a descriptor
 * per block plus the transfer, so its cost per word falls as BLOCK grows; the cache pays one miss per line
 * and then hits, so its cost per word is nearly flat from 32 words up (a line is 128 B). The two curves
 * cross, and this test looks for where.
 *
 * REUSE repeats the pass. With high reuse the iDMA wins on latency (the scratchpad against the 3 cycles of a
 * hit), not on bandwidth, so the crossing moves. The useful result is the frontier on the (BLOCK, REUSE)
 * plane.
 *
 * The test is written to run on a mesh as well, which means it has **no mutable state in .data or .bss**:
 * in MAGIA those are a single copy shared by every tile. Counters and results live in the L1, which is local
 * to the tile, and the L2 arena is moved by hart id.
 *
 *   make all test=dcache_blocks_test dcache=1 core=CV32E40P fsync=1 \
 *        EXTRA_CFLAGS="-DN_WORDS=8192 -DREUSE=1 -DBUDGET_KIB=16"
 */

#include "magia_tile_utils.h"
#include "magia_dcache_utils.h"
#include "idma_mm_utils.h"
#include "bench_utils.h"

// GCC 14 crashes ("could not split insn", doloop_begin_i) on the cv32e40p hardware loop of the big loops
#pragma GCC optimize("no-branch-count-reg")
#pragma GCC optimize("align-loops=4")
#define KERNEL __attribute__((noinline, aligned(4)))

////////////////
// Parameters //
////////////////

#ifndef N_WORDS
#define N_WORDS      (8 * 1024)               /* 32 KiB of data in the L2 */
#endif
#ifndef REUSE
#define REUSE        (1)                      /* how many times the whole block list is walked again */
#endif
#ifndef BUDGET_KIB
#define BUDGET_KIB   (16)                     /* L1 budget given to the cache (ways switched on) */
#endif
#ifndef BLOCK_LIST
#define BLOCK_LIST   1, 2, 4, 8, 16, 32, 64, 128, 256, 512
#endif
#ifndef RUN_DIRECT
#define RUN_DIRECT   (1)
#endif
#ifndef ARENA_STRIDE
#define ARENA_STRIDE (0x00040000)             /* 256 KiB per tile: src and idx fit with room to spare */
#endif

#define MAX_BLOCK    (512)

static inline uint32_t tile_id(void) {
    uint32_t id;
    asm volatile("csrr %0, mhartid" : "=r"(id));
    return id;
}

//////////////////////////////////////////////////
// Memory: no mutable state in .data or .bss     //
//////////////////////////////////////////////////

/* L2, una fetta per tile */
/* 0xCC20_0000 and not 0xCC10_0000: tile 0 would get the lowest arena, and on a mesh the program data
 * (one copy for every tile) reaches up into it. */
#define ARENA        (0xCC200000u + tile_id() * ARENA_STRIDE)
#define SRC_ADDR     (ARENA)
#define IDX_ADDR     (ARENA + N_WORDS * 4 + 128)
#define ARENA_END    (IDX_ADDR + N_WORDS * 4)

/* L1: the core's map is GLOBAL (magia_isle.sv: tile_l1_start_addr = L1_ADDR_START + mhartid*L1_TILE_OFFSET).
 * L1_BASE on its own is the L1 of tile 0: from any other tile it leaves on the NoC and lands there. */
#define TILE_L1      (L1_BASE + tile_id() * L1_TILE_OFFSET) /* the core's view: the L1 of THIS tile */
#define STATE        (TILE_L1)                              /* counters and results */
#define DMA_BUF      (TILE_L1 + 0x1000)                     /* two buffers of MAX_BLOCK words, core view */
/* The OBI port of the iDMA is wired to the TCDM of its own tile: it wants the local address, with no tile offset */
#define DMA_BUF_LOC  (L1_BASE + 0x1000)

#define errors       (*(volatile uint32_t *)(STATE + 0))
#define lcg_state    (*(volatile uint32_t *)(STATE + 4))

extern char _bss_end;

static const uint32_t block_list[] = {BLOCK_LIST};          /* const: condividerla fra le tile va bene */

static void check(const char *what, uint32_t block, uint32_t got, uint32_t expected) {
    if (got != expected) {
        printf("[FAIL] tile %d %s block=%d: got 0x%x, expected 0x%x\n", (int)tile_id(), what, (int)block,
               (unsigned)got, (unsigned)expected);
        errors = errors + 1;
    }
}

//////////
// iDMA //
//////////

/////////////
// Kernels //
/////////////

/* Sum of n_blocks blocks of `block` words, taken where idx says. This is the version that reaches the L2:
 * direct and cache both use it, unchanged, so the only difference between them is the cache setup. */
KERNEL static uint32_t sum_blocks_l2(volatile uint32_t *src, volatile uint32_t *idx, uint32_t n_blocks,
                                     uint32_t block) {
    uint32_t sum = 0;
    for (uint32_t j = 0; j < n_blocks; j++) {
        uint32_t s = idx[j];
        for (uint32_t k = 0; k < block; k++)
            sum += src[s + k];
    }
    return sum;
}

/* The sum of a block already staged in the scratchpad */
KERNEL static uint32_t sum_buf(volatile uint32_t *buf, uint32_t block) {
    uint32_t sum = 0;
    for (uint32_t k = 0; k < block; k++)
        sum += buf[k];
    return sum;
}

/* iDMA version: one descriptor per block, double buffered. The addresses of the blocks are known only by
 * reading the index list, so one descriptor per block is the best a DMA can do here. */
static uint32_t sum_blocks_idma(uint32_t src, volatile uint32_t *idx, uint32_t n_blocks, uint32_t block) {
    uint32_t bytes = block * 4;
    uint32_t buf[2] = {DMA_BUF, DMA_BUF + MAX_BLOCK * 4};
    uint32_t dst[2] = {DMA_BUF_LOC, DMA_BUF_LOC + MAX_BLOCK * 4};
    uint32_t id[2] = {0, 0};
    uint32_t sum = 0;

    id[0] = idma_L2ToL1(src + idx[0] * 4, dst[0], bytes);
    for (uint32_t j = 0; j < n_blocks; j++) {
        uint32_t d = j & 1, n = d ^ 1;
        if (j + 1 < n_blocks)
            id[n] = idma_L2ToL1(src + idx[j + 1] * 4, dst[n], bytes);
        idma_wait_in(id[d]);
        sum += sum_buf((volatile uint32_t *)buf[d], block);
    }
    return sum;
}

/////////////////
// Preparation  //
/////////////////

static uint32_t lcg_next(void) {
    lcg_state = lcg_state * 1664525u + 1013904223u;
    return lcg_state;
}

/* A random permutation of the blocks, not of the words: overlapping blocks would break the checksum. The
 * core writes it straight to the L2. The preparation is not timed, and this way there is no staging from
 * the L1 that could go wrong, which on a mesh is where the errors came from. */
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
    dcache_flush();                 /* the list must be in the L2 for the runs with the cache off too */
}

/* The cost of one iDMA descriptor on its own: it is the constant that decides where the crossing falls */
static void measure_descriptor_cost(void) {
    const uint32_t n = 256;
    uint32_t start = read_mcycle();
    uint32_t id = 0;
    for (uint32_t i = 0; i < n; i++)
        id = idma_L2ToL1(SRC_ADDR, DMA_BUF_LOC, 4);
    idma_wait_in(id);
    uint32_t t = read_mcycle() - start;
    printf("RES tile=%d what=descriptor n=%d cycles=%d per_descriptor=%d\n", (int)tile_id(), (int)n, (int)t,
           (int)(t / n));
}

//////////
// Runs //
//////////

static uint32_t golden_sum(void) {
    /* src[i] = i, and a permutation of the blocks covers them all: the sum does not depend on block */
    uint32_t n = N_WORDS;
    uint32_t tri = (n % 2 == 0) ? (n / 2) * (n - 1) : n * ((n - 1) / 2);
    return tri * REUSE;
}

static void print_res(const char *variant, uint32_t block, uint32_t cycles, const dcache_perf_t *perf) {
    printf("RES tile=%d variant=%s block=%d reuse=%d cycles=%d hit_r=%d miss_r=%d refill=%d\n",
           (int)tile_id(), variant, (int)block, REUSE, (int)cycles, (int)perf->hit_r, (int)perf->miss_r,
           (int)perf->refill);
}

static void run_block(uint32_t block) {
    volatile uint32_t *src = (volatile uint32_t *)SRC_ADDR;
    volatile uint32_t *idx = (volatile uint32_t *)IDX_ADDR;
    uint32_t n_blocks = N_WORDS / block;
    dcache_perf_t none = {0};
    dcache_perf_t perf;
    uint32_t spm_base, spm_size, start, t, sum;

    make_block_permutation(n_blocks, block);

    if (RUN_DIRECT) {
        dcache_flush();
        dcache_enable(0);
        start = read_mcycle();
        sum = 0;
        for (uint32_t r = 0; r < REUSE; r++)
            sum += sum_blocks_l2(src, idx, n_blocks, block);
        t = read_mcycle() - start;
        dcache_enable(1);
        check("direct", block, sum, golden_sum());
        print_res("direct", block, t, &none);
    }

    dcache_flush();
    dcache_enable(0);                         /* the iDMA brings everything to the scratchpad: the cache is out of it */
    start = read_mcycle();
    sum = 0;
    for (uint32_t r = 0; r < REUSE; r++)
        sum += sum_blocks_idma(SRC_ADDR, idx, n_blocks, block);
    t = read_mcycle() - start;
    dcache_enable(1);
    check("idma", block, sum, golden_sum());
    print_res("idma", block, t, &none);

    for (uint32_t pf = 0; pf < 2; pf++) {
        uint32_t way_bytes = L1_DCACHE_SIZE / dcache_num_ways();
        uint32_t ways = (BUDGET_KIB * 1024) / way_bytes;
        if (ways == 0 || ways > dcache_num_ways())
            continue;
        dcache_set_ways(ways, &spm_base, &spm_size);
        dcache_set_prefetch(pf);
        dcache_flush();
        dcache_perf_start();
        start = read_mcycle();
        sum = 0;
        for (uint32_t r = 0; r < REUSE; r++)
            sum += sum_blocks_l2(src, idx, n_blocks, block);
        t = read_mcycle() - start;
        dcache_perf_stop();
        dcache_perf_read(&perf);
        check(pf ? "cache_pf1" : "cache_pf0", block, sum, golden_sum());
        print_res(pf ? "cache_pf1" : "cache_pf0", block, t, &perf);
        dcache_set_prefetch(0);
        dcache_set_ways(dcache_num_ways(), &spm_base, &spm_size);
    }
}

int main(void) {
    volatile uint32_t *src = (volatile uint32_t *)SRC_ADDR;

    asm volatile("csrw mcountinhibit, zero");
    errors = 0;
    lcg_state = 0x2026u + tile_id();

    if (tile_id() == 0)
        printf("dcache_blocks: %d words, reuse %d, budget %d KiB, dcache %d ways x %d sets (%d KiB)\n",
               N_WORDS, REUSE, BUDGET_KIB, (int)dcache_num_ways(), MAGIA_DCACHE_SETS, L1_DCACHE_SIZE / 1024);
    if (!dcache_geometry_ok() || (uint32_t)&_bss_end > ARENA || ARENA_END > 0xCCF00000) {
        printf("[FAIL] tile %d: geometry or arena\n", (int)tile_id());
        return 1;
    }

    for (uint32_t i = 0; i < N_WORDS; i++)
        src[i] = i;
    dcache_flush();

    measure_descriptor_cost();
    for (uint32_t i = 0; i < sizeof(block_list) / sizeof(block_list[0]); i++)
        run_block(block_list[i]);

    printf("dcache_blocks_test: tile %d, %d errors\n", (int)tile_id(), (int)errors);
    return errors;
}
