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
 * obpmark_ccsds121_cluster_test - OBPMark 2.1 CCSDS 121.0 compression on the 8 PULP cores, the 8 core
 * counterpart of sw/tests/obpmark_ccsds121_test.c. Little compute per byte and a blocked, data dependent
 * output: the opposite end from AES among the application kernels.
 * The control core builds the samples, dispatches the team and checks that the three transports produce the
 * same stream (same bits, same words, same checksum per core).
 * Needs the cache (make dcache=1).
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "magia_dcache_utils.h"
#include "idma_mm_utils.h"
#include "bench_utils.h"
#include "cluster_utils.h"
#include "obpmark_ccsds121_cluster_test.h"
#include "obpmark_ccsds121_cluster_test_pulp_task_bin.h"

// GCC 14 crashes ("could not split insn", doloop_begin_i) on the cv32e40p hardware loop of the big loops
#pragma GCC optimize("no-branch-count-reg")

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
#define CACHE_PF     (3)
#endif
#ifndef ARENA_STRIDE
#define ARENA_STRIDE (0x00040000)
#endif

#define IN_BYTES     (CCSDS_SAMPLES * 4)
#define OUT_STRIDE   (INTERVALS / PULP_CORE_COUNT * INTERVAL_WORDS)   /* words reserved per core */
#define OUT_BYTES    (OUT_STRIDE * PULP_CORE_COUNT * 4)

#define ARENA        (0xCC200000u + magia_tile_id() * ARENA_STRIDE)
#define IN_ADDR      (ARENA)
#define OUT_ADDR     (ARENA + IN_BYTES + 128)
#define ARENA_END    (OUT_ADDR + OUT_BYTES)

#define PARAMS_OFF   (0)
#define STATE_OFF    (0x800)
#define SPM_OFF      (0x1000)                 /* iDMA tiles */
#define SCRATCH_OFF  (L1_SPM_SIZE - PULP_CORE_COUNT * CCSDS_SCRATCH_SZ)  /* out of the budgets */
#define PARAMS       L1_GLOBAL(PARAMS_OFF)
#define STATE        L1_GLOBAL(STATE_OFF)
#define SPM          L1_GLOBAL(SPM_OFF)
#define SPM_LOC      L1_LOCAL(SPM_OFF)
#define SCRATCH      L1_GLOBAL(SCRATCH_OFF)

#define errors       (*(volatile uint32_t *)(STATE + 0))
#define have_golden  (*(volatile uint32_t *)(STATE + 4))
#define golden_sum   (*(volatile uint32_t *)(STATE + 8))
#define golden_bits  (*(volatile uint32_t *)(STATE + 12))
#define golden_words (*(volatile uint32_t *)(STATE + 16))

extern char _bss_end;

static const uint32_t budgets_kib[] = {BUDGETS_KIB};

static void check(const char *what, uint32_t got, uint32_t expected) {
    if (got != expected) {
        printf("[FAIL] %s: got 0x%x, expected 0x%x\n", what, (unsigned)got, (unsigned)expected);
        errors = errors + 1;
    }
}

static void perf_zero(dcache_perf_t *p) {
    p->hit_r = 0; p->hit_w = 0; p->miss_r = 0; p->miss_w = 0;
    p->refill = 0; p->writeback = 0; p->stall = 0; p->tcdm_stall = 0;
}

/* The streams of the cores, in their regions: one checksum for all of them */
static uint32_t out_checksum(volatile ccsds_params_t *p) {
    volatile uint32_t *o = (volatile uint32_t *)OUT_ADDR;
    uint32_t s = 0;

    dcache_flush();
    for (uint32_t c = 0; c < PULP_CORE_COUNT; c++)
        for (uint32_t i = 0; i < p->words[c]; i++)
            s = s * 31u + o[c * OUT_STRIDE + i];
    return s;
}

static uint32_t total_of(volatile uint32_t *v) {
    uint32_t s = 0;
    for (int c = 0; c < PULP_CORE_COUNT; c++)
        s += v[c];
    return s;
}

static uint32_t max_cycles(volatile ccsds_params_t *p) {
    uint32_t max = 0;
    for (int c = 0; c < PULP_CORE_COUNT; c++)
        if (p->cycles[c] > max)
            max = p->cycles[c];
    return max;
}

static void print_res(const char *variant, uint32_t budget, uint32_t cycles, const dcache_perf_t *perf) {
    printf("RES variant=%s budget=%d kernel=ccsds121 cycles=%d hit_r=%d miss_r=%d hit_w=%d miss_w=%d "
           "refill=%d wb=%d\n", variant, (int)(budget / 1024), (int)cycles, (int)perf->hit_r,
           (int)perf->miss_r, (int)perf->hit_w, (int)perf->miss_w, (int)perf->refill, (int)perf->writeback);
}

static void run_team(volatile ccsds_params_t *p) {
    cluster_arm_done_event();
    cluster_dispatch_task_with_params(OBPMARK_CCSDS121_CLUSTER_TEST_TASK, (uint32_t)p);
    cluster_wait_done_eu();
}

static void run_case(uint32_t variant, uint32_t budget, uint32_t prefetch) {
    volatile ccsds_params_t *p = (volatile ccsds_params_t *)PARAMS;
    const char   *name;
    uint32_t      way_bytes = L1_DCACHE_SIZE / dcache_num_ways();
    uint32_t      ways = budget / way_bytes;
    uint32_t      spm_base, spm_size, t;
    dcache_perf_t perf;

    p->tile_intervals = PULP_CORE_COUNT;      /* one interval per core per round */
    if (variant == CCSDS_VAR_IDMA) {
        /* in, double buffered, plus one output slot per core: the length of an interval is known only
         * after compressing it, so the output side cannot be double buffered */
        uint32_t need = 2 * p->tile_intervals * INTERVAL_WORDS * 4
                      + PULP_CORE_COUNT * (INTERVAL_WORDS + 32) * 4;
        name = "idma";
        if (need > budget) {
            printf("idma %d KiB: the team needs %d B of staging (8 intervals in flight), skipped\n",
                   (int)(budget / 1024), (int)need);
            return;
        }
        if (INTERVALS % p->tile_intervals != 0) {
            printf("idma: %d intervals do not divide among %d cores, skipped\n", INTERVALS, PULP_CORE_COUNT);
            return;
        }
    } else if (budget) {
        name = prefetch ? "cache_pf1" : "cache_pf0";
        if (ways == 0 || ways > dcache_num_ways() || ways * way_bytes != budget) {
            printf("cache %d KiB: not a number of ways, skipped\n", (int)(budget / 1024));
            return;
        }
    } else {
        name = "direct";
    }

    p->variant    = variant;
    p->in         = IN_ADDR;
    p->out        = OUT_ADDR;
    p->out_stride = OUT_STRIDE;
    p->scratch    = SCRATCH;
    p->spm        = SPM;
    p->spm_loc    = SPM_LOC;

    dcache_flush();
    if (budget && variant == CCSDS_VAR_L2) {
        dcache_set_ways(ways, &spm_base, &spm_size);
        dcache_set_prefetch(prefetch);
        dcache_perf_start();
        t = read_mcycle(); run_team(p); t = read_mcycle() - t;
        dcache_perf_stop();
        dcache_perf_read(&perf);
        dcache_set_prefetch(0);
        dcache_set_ways(dcache_num_ways(), &spm_base, &spm_size);
    } else {
        dcache_enable(0);
        t = read_mcycle(); run_team(p); t = read_mcycle() - t;
        dcache_enable(1);
        perf_zero(&perf);
    }

    if (cluster_task_crashed()) {
        printf("[FAIL] cluster task trapped (mcause=0x%08x)\n", (unsigned)cluster_get_mcause());
        errors = errors + 1;
        return;
    }
    uint32_t bits = total_of(p->bits), words = total_of(p->words), sum = out_checksum(p);
    if (!have_golden) {
        golden_bits  = bits;
        golden_words = words;
        golden_sum   = sum;
        have_golden  = 1;
        printf("ccsds: %d bits, %d words, ratio %d/1000\n", (int)bits, (int)words,
               (int)((uint64_t)bits * 1000 / (CCSDS_SAMPLES * CCSDS_N_BITS)));
    } else {
        check("bits", bits, golden_bits);
        check("words", words, golden_words);
        check("stream checksum", sum, golden_sum);
    }
    print_res(name, (variant == CCSDS_VAR_L2 && !budget) ? 0 : budget, max_cycles(p), &perf);
}

int main(void) {
    volatile uint32_t *in = (volatile uint32_t *)IN_ADDR;
    uint32_t x = 0x2026u;

    asm volatile("csrw mcountinhibit, zero");
    errors      = 0;
    have_golden = 0;

    if (magia_tile_id() == 0)
        printf("obpmark_ccsds121_cluster: %d cores, n=%d j=%d r=%d, %d samples, %d intervals, dcache %d x %d\n",
               PULP_CORE_COUNT, CCSDS_N_BITS, CCSDS_J_BLOCK, CCSDS_R_BLOCKS, CCSDS_SAMPLES, INTERVALS,
               (int)dcache_num_ways(), MAGIA_DCACHE_SETS);
    if (!dcache_geometry_ok() || (uint32_t)&_bss_end > ARENA || ARENA_END > 0xCCF00000 ||
        INTERVALS % PULP_CORE_COUNT != 0) {
        printf("[FAIL] tile %d: geometry, arena or intervals\n", (int)magia_tile_id());
        return 1;
    }

    cluster_boot(PULP_BINARY_START);
    /* Samples with some structure: a slow ramp with noise, so that the encoder picks different options */
    for (uint32_t i = 0; i < CCSDS_SAMPLES; i++) {
        x = x * 1664525u + 1013904223u;
        in[i] = ((i >> 3) + (x >> 28)) & ((1u << CCSDS_N_BITS) - 1u);
    }
    dcache_flush();

    if (RUN_DIRECT)
        run_case(CCSDS_VAR_L2, 0, 0);
    for (uint32_t i = 0; i < sizeof(budgets_kib) / sizeof(budgets_kib[0]); i++) {
        uint32_t budget = budgets_kib[i] * 1024;
        if (RUN_IDMA)
            run_case(CCSDS_VAR_IDMA, budget, 0);
        if (CACHE_PF & 1)
            run_case(CCSDS_VAR_L2, budget, 0);
        if (CACHE_PF & 2)
            run_case(CCSDS_VAR_L2, budget, 1);
    }

    printf("obpmark_ccsds121_cluster_test: %d errors\n", (int)errors);
    return errors;
}
