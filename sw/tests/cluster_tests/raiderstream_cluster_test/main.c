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
 * raiderstream_cluster_test - the 16 kernels of sw/tests/raiderstream_kernels.h on the 8 PULP cores instead
 * of the control core, with the same three transports and the same RES lines as sw/tests/raiderstream_test.c,
 * so the two compare kernel by kernel. It replaces cluster_tests/dcache_stream_test, which ran three of
 * these kernels rewritten by hand.
 *
 * The control core prepares the arrays, sets up the cache for each case, dispatches the team and checks.
 * Needs the cache (make dcache=1).
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "magia_dcache_utils.h"
#include "cluster_utils.h"
#include "bench_utils.h"
#include "raiderstream_cluster_test.h"
#include "raiderstream_cluster_test_pulp_task_bin.h"

////////////////
// Parameters //
////////////////

#ifndef BUDGETS_KIB
#define BUDGETS_KIB  16, 32
#endif
#ifndef RUN_DIRECT
#define RUN_DIRECT   (1)
#endif
#ifndef RUN_IDMA
#define RUN_IDMA     (1)
#endif
#ifndef CACHE_PF
#define CACHE_PF     (3)                      /* bit 0: prefetch off, bit 1: prefetch on */
#endif
#ifndef GROUPS
#define GROUPS       (0xF)                    /* bit g: run group g */
#endif
#ifndef STREAM_OFFSET
#define STREAM_OFFSET (128)                   /* keeps a[j], b[j] and c[j] out of the same set */
#endif
#ifndef ARENA_STRIDE
#define ARENA_STRIDE (0x00080000)
#endif

#define N (RSC_WORDS)

/////////////////////
// Memory and data //
/////////////////////

/* L2 arena, one per tile: on a mesh the tiles must not share the arrays (no coherence between tiles, and
 * the program image is one copy for all of them). */
#define ARR_BYTES    (N * 4 + STREAM_OFFSET)
#define A_OFF        (0)
#define B_OFF        (A_OFF + ARR_BYTES)
#define C_OFF        (B_OFF + ARR_BYTES)
#define I1_OFF       (C_OFF + ARR_BYTES)
#define I2_OFF       (I1_OFF + ARR_BYTES)
#define I3_OFF       (I2_OFF + ARR_BYTES)
#define ARENA_BYTES  (I3_OFF + N * 4)
#define ARENA        (0xCC200000u + magia_tile_id() * ARENA_STRIDE)

/* L1: the core uses the global view, the iDMA the local one (see L1_LOCAL / L1_GLOBAL) */
#define PARAMS_OFF   (0)
#define STATE_OFF    (0x800)
#define SPM_OFF      (0x1000)                 /* tile buffers, and the permutation scratch before the runs */
#define PAT_WORDS    (8 * 1024 + 8 * (N / 8192))
#define PAT_OFF      (L1_SPM_SIZE - PAT_WORDS * 4)   /* the fill pattern, out of the budgets */

#define PARAMS       L1_GLOBAL(PARAMS_OFF)
#define STATE        L1_GLOBAL(STATE_OFF)
#define SPM          L1_GLOBAL(SPM_OFF)
#define SPM_LOC      L1_LOCAL(SPM_OFF)
#define PAT          L1_GLOBAL(PAT_OFF)
#define PAT_LOC      L1_LOCAL(PAT_OFF)

/* No mutable globals: .bss is one copy for the whole mesh */
#define errors       (*(volatile uint32_t *)(STATE + 0))
#define lcg_state    (*(volatile uint32_t *)(STATE + 4))

extern char _bss_end;

static const uint32_t budgets_kib[] = {BUDGETS_KIB};

static void role_addrs(uint32_t *out) {
    static const uint32_t off[R_NUM] = {A_OFF, B_OFF, C_OFF, I1_OFF, I2_OFF, I3_OFF};
    uint32_t arena = ARENA;                   /* reads mhartid: once, never in a loop */
    for (int r = 0; r < R_NUM; r++)
        out[r] = arena + off[r];
}

static inline uint32_t val(uint32_t i) {
    return (i & 8191) + 8 * (i >> 13);
}

static void check(const char *variant, const char *what, uint32_t got, uint32_t expected) {
    if (got != expected) {
        printf("[FAIL] %s %s: got 0x%x, expected 0x%x\n", variant, what, (unsigned)got, (unsigned)expected);
        errors = errors + 1;
    }
}

/* The arrays are written by the iDMA from a pattern in the SPM, never by the core: a store from the core
 * would go through the cache and leave the data dirty there instead of in the L2. */
static void fill(uint32_t l2, uint32_t words) {
    uint32_t id = 0;
    for (uint32_t c = 0; c * 8192 < words; c++) {
        uint32_t n = (words - c * 8192 < 8192) ? words - c * 8192 : 8192;
        id = idma_L1ToL2(PAT_LOC + 8 * c * 4, l2 + c * 8192 * 4, n * 4);
    }
    idma_wait_out(id);
}

static uint32_t golden_sum(uint32_t words) {
    uint32_t s = 0;
    for (uint32_t c = 0; c * 8192 < words; c++) {
        uint32_t n = (words - c * 8192 < 8192) ? words - c * 8192 : 8192;
        s += n * (n - 1) / 2 + n * 8 * c;
    }
    return s;
}

/* A random permutation of 0 .. N-1 (Fisher-Yates, as RaiderSTREAM), built in the SPM and sent to the L2 */
static void make_permutation(uint32_t l2) {
    volatile uint32_t *scratch = (volatile uint32_t *)SPM;

    for (uint32_t i = 0; i < N; i++)
        scratch[i] = i;
    for (uint32_t i = N - 1; i > 0; i--) {
        lcg_state = lcg_state * 1664525u + 1013904223u;
        uint32_t j = lcg_state % (i + 1);
        uint32_t tmp = scratch[i];
        scratch[i] = scratch[j];
        scratch[j] = tmp;
    }
    idma_wait_out(idma_out(SPM_LOC, l2, N * 4));
}

//////////
// Runs //
//////////

static void print_res(const char *variant, uint32_t budget, const char *kernel, uint32_t cycles,
                      const dcache_perf_t *perf) {
    printf("RES variant=%s budget=%d kernel=%s cycles=%d hit_r=%d miss_r=%d hit_w=%d miss_w=%d refill=%d wb=%d\n",
           variant, (int)(budget / 1024), kernel, (int)cycles, (int)perf->hit_r, (int)perf->miss_r,
           (int)perf->hit_w, (int)perf->miss_w, (int)perf->refill, (int)perf->writeback);
}

static void run_team(volatile rsc_params_t *p) {
    cluster_arm_done_event();
    cluster_dispatch_task_with_params(RAIDERSTREAM_CLUSTER_TEST_TASK, (uint32_t)p);
    cluster_wait_done_eu();
}

/* Before a group: write back what the cache holds, a again from the pattern (copy and scale overwrite b
 * and c completely, so only a needs resetting) */
static void init_group(void) {
    uint32_t addr[R_NUM];

    role_addrs(addr);
    dcache_flush();
    fill(addr[R_A], N);
}

/* After a group, the three sums. The four operations in order give sum(a) = 15 S, sum(b) = 3 S,
 * sum(c) = 4 S whatever the group, because an index array is a permutation and only moves values around. */
static void check_group(const char *variant, uint32_t g) {
    uint32_t addr[R_NUM], s = golden_sum(N);

    role_addrs(addr);
    dcache_flush();                           /* or we would read the L2 while the results are still dirty */
    volatile uint32_t *a = (volatile uint32_t *)addr[R_A];
    volatile uint32_t *b = (volatile uint32_t *)addr[R_B];
    volatile uint32_t *c = (volatile uint32_t *)addr[R_C];
    check(variant, "sum(a)", sum_of(a, N), 15 * s);
    check(variant, "sum(b)", sum_of(b, N), 3 * s);
    check(variant, "sum(c)", sum_of(c, N), 4 * s);
    if (g == G_SEQ) {
        /* A sum does not notice two swapped elements: where the positions are predictable, check them */
        for (uint32_t i = 0; i < N; i += 61) {
            check(variant, "seq a[i]", a[i], 15 * val(i));
            check(variant, "seq b[i]", b[i], 3 * val(i));
            check(variant, "seq c[i]", c[i], 4 * val(i));
        }
    }
}

/* One group of four operations on one variant. Returns without a line when the case cannot run. */
static void run_group(uint32_t g, uint32_t variant, uint32_t budget, uint32_t prefetch) {
    volatile rsc_params_t *p = (volatile rsc_params_t *)PARAMS;
    const char   *name = (variant == RSC_VAR_DIRECT) ? "direct"
                       : (variant == RSC_VAR_IDMA)   ? "idma"
                       : prefetch ? "cache_pf1" : "cache_pf0";
    uint32_t      way_bytes = L1_DCACHE_SIZE / dcache_num_ways();
    uint32_t      ways = budget / way_bytes;
    uint32_t      spm_base, spm_size, addr[R_NUM];
    dcache_perf_t perf, none = {0};

    if (variant == RSC_VAR_IDMA && g == G_SG)
        return;                               /* irregular at both ends: nothing to stage */
    if (variant == RSC_VAR_CACHE && (ways == 0 || ways > dcache_num_ways() || ways * way_bytes != budget)) {
        printf("cache %d KiB: not a whole number of ways, skipped\n", (int)(budget / 1024));
        return;
    }

    role_addrs(addr);
    p->variant = variant;
    p->n_words = N;
    p->spm     = SPM;
    p->spm_loc = SPM_LOC;
    for (int r = 0; r < R_NUM; r++)
        p->role[r] = addr[r];

    init_group();
    for (uint32_t op = 0; op < OP_NUM; op++) {
        rs_plan_t pl;
        uint32_t  t;

        p->group = g;
        p->op    = op;
        /* The tile is a whole number of words per core, so that the team can split it */
        p->tile_words = N;
        if (variant == RSC_VAR_IDMA) {
            rs_plan(g, op, &pl);
            p->tile_words = rs_tile_words(pl.n_streams, budget, N, PULP_CORE_COUNT);
            if (p->tile_words % PULP_CORE_COUNT != 0 || N % p->tile_words != 0) {
                printf("idma %s: tile of %d words does not divide, skipped\n",
                       rs_rows[g][op].name, (int)p->tile_words);
                continue;
            }
        }

        /* direct and iDMA run with the cache off: in both the cores reach the L2 without it. In the iDMA
         * variant of gather and scatter the irregular array stays in L2 and is touched directly, so leaving
         * the cache on would make this a cache-assisted variant. */
        if (variant == RSC_VAR_CACHE) {
            dcache_set_ways(ways, &spm_base, &spm_size);
            dcache_set_prefetch(prefetch);
            dcache_perf_start();
            t = read_mcycle(); run_team(p); t = read_mcycle() - t;
            dcache_perf_stop();
            dcache_perf_read(&perf);
            dcache_set_prefetch(0);
            dcache_set_ways(dcache_num_ways(), &spm_base, &spm_size);
            print_res(name, budget, rs_rows[g][op].name, max_of(p->cycles, PULP_CORE_COUNT), &perf);
        } else {
            dcache_enable(0);
            t = read_mcycle(); run_team(p); t = read_mcycle() - t;
            dcache_enable(1);
            print_res(name, (variant == RSC_VAR_DIRECT) ? 0 : budget, rs_rows[g][op].name,
                      max_of(p->cycles, PULP_CORE_COUNT), &none);
        }
        if (cluster_task_crashed()) {
            printf("[FAIL] cluster task trapped (mcause=0x%08x)\n", (unsigned)cluster_get_mcause());
            errors = errors + 1;
            return;
        }
    }
    if (variant == RSC_VAR_CACHE) {
        uint32_t t = read_mcycle();
        dcache_flush();
        print_res(name, budget, "flush", read_mcycle() - t, &none);
    }
    check_group(name, g);
}

int main(void) {
    asm volatile("csrw mcountinhibit, zero");
    errors    = 0;
    lcg_state = 0x2026u;

    printf("raiderstream_cluster: %d cores, %d words per array, dcache %d ways x %d sets (%d KiB), geometry %s\n",
           PULP_CORE_COUNT, N, (int)dcache_num_ways(), MAGIA_DCACHE_SETS, L1_DCACHE_SIZE / 1024,
           dcache_geometry_ok() ? "ok" : "MISMATCH");
    if (!dcache_geometry_ok() || (uint32_t)&_bss_end > ARENA || ARENA + ARENA_BYTES > 0xCCF00000 ||
        N % (32 * PULP_CORE_COUNT) != 0 || STREAM_OFFSET % 128 != 0) {
        printf("[FAIL] geometry, arena or alignment\n");
        return 1;
    }

    cluster_boot(PULP_BINARY_START);

    uint32_t pat = PAT, addr[R_NUM];           /* L1_GLOBAL reads mhartid: not inside the loop */
    for (uint32_t j = 0; j < PAT_WORDS; j++)
        mmio32(pat + j * 4) = j;
    role_addrs(addr);
    make_permutation(addr[R_I1]);
    make_permutation(addr[R_I2]);
    make_permutation(addr[R_I3]);
    dcache_flush();                            /* the first measurement must start from a cold cache */

    for (uint32_t g = 0; g < G_NUM; g++) {
        if (!(GROUPS & (1u << g)))
            continue;
        if (RUN_DIRECT)
            run_group(g, RSC_VAR_DIRECT, 0, 0);
        for (uint32_t i = 0; i < sizeof(budgets_kib) / sizeof(budgets_kib[0]); i++) {
            uint32_t budget = budgets_kib[i] * 1024;
            if (RUN_IDMA)
                run_group(g, RSC_VAR_IDMA, budget, 0);
            if (CACHE_PF & 1)
                run_group(g, RSC_VAR_CACHE, budget, 0);
            if (CACHE_PF & 2)
                run_group(g, RSC_VAR_CACHE, budget, 1);
        }
    }

    printf("raiderstream_cluster_test: %d errors\n", (int)errors);
    return errors;
}
