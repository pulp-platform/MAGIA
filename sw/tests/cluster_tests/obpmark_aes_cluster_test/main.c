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
 * obpmark_aes_cluster_test - OBPMark 3.1 AES in counter mode on the 8 PULP cores, the 8 core counterpart of
 * sw/tests/obpmark_aes_test.c, with the same three transports and the same RES lines. AES is compute bound,
 * so this is the case where going to eight cores should show what the cache costs when the kernel is not
 * waiting for memory.
 * The control core builds the tables and the plaintext, dispatches the team and checks. The checks are the
 * FIPS-197 known answer (run by cluster core 0 on the expanded key) and the ciphertext checksum, which must
 * be the same for every transport.
 * Needs the cache (make dcache=1).
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "magia_dcache_utils.h"
#include "idma_mm_utils.h"
#include "bench_utils.h"
#include "cluster_utils.h"
#include "obpmark_aes_cluster_test.h"
#include "obpmark_aes_cluster_test_pulp_task_bin.h"

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

#define NK           (AES_KEY_BITS / 32)
#define DATA_BYTES   (AES_BLOCKS * 16)

#define ARENA        (0xCC200000u + magia_tile_id() * ARENA_STRIDE)
#define PT_ADDR      (ARENA)
#define CT_ADDR      (ARENA + DATA_BYTES + 128)
#define ARENA_END    (CT_ADDR + DATA_BYTES)

#define PARAMS_OFF   (0)
#define STATE_OFF    (0x800)
#define SPM_OFF      (0x1000)                 /* iDMA tiles */
#define HOT_OFF      (L1_SPM_SIZE - AES_HOT_BYTES)   /* tables and expanded key, out of the budgets */
#define PARAMS       L1_GLOBAL(PARAMS_OFF)
#define STATE        L1_GLOBAL(STATE_OFF)
#define SPM          L1_GLOBAL(SPM_OFF)
#define SPM_LOC      L1_LOCAL(SPM_OFF)
#define HOT          L1_GLOBAL(HOT_OFF)

#define errors       (*(volatile uint32_t *)(STATE + 0))
#define golden       (*(volatile uint32_t *)(STATE + 4))
#define have_golden  (*(volatile uint32_t *)(STATE + 8))

extern char _bss_end;

static const uint32_t budgets_kib[] = {BUDGETS_KIB};

/* The AES S-box (FIPS-197), copied to the SPM at init */
static const uint8_t sbox_rom[256] = {
  0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5, 0x30, 0x01, 0x67, 0x2b, 0xfe, 0xd7, 0xab, 0x76,
  0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59, 0x47, 0xf0, 0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0,
  0xb7, 0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc, 0x34, 0xa5, 0xe5, 0xf1, 0x71, 0xd8, 0x31, 0x15,
  0x04, 0xc7, 0x23, 0xc3, 0x18, 0x96, 0x05, 0x9a, 0x07, 0x12, 0x80, 0xe2, 0xeb, 0x27, 0xb2, 0x75,
  0x09, 0x83, 0x2c, 0x1a, 0x1b, 0x6e, 0x5a, 0xa0, 0x52, 0x3b, 0xd6, 0xb3, 0x29, 0xe3, 0x2f, 0x84,
  0x53, 0xd1, 0x00, 0xed, 0x20, 0xfc, 0xb1, 0x5b, 0x6a, 0xcb, 0xbe, 0x39, 0x4a, 0x4c, 0x58, 0xcf,
  0xd0, 0xef, 0xaa, 0xfb, 0x43, 0x4d, 0x33, 0x85, 0x45, 0xf9, 0x02, 0x7f, 0x50, 0x3c, 0x9f, 0xa8,
  0x51, 0xa3, 0x40, 0x8f, 0x92, 0x9d, 0x38, 0xf5, 0xbc, 0xb6, 0xda, 0x21, 0x10, 0xff, 0xf3, 0xd2,
  0xcd, 0x0c, 0x13, 0xec, 0x5f, 0x97, 0x44, 0x17, 0xc4, 0xa7, 0x7e, 0x3d, 0x64, 0x5d, 0x19, 0x73,
  0x60, 0x81, 0x4f, 0xdc, 0x22, 0x2a, 0x90, 0x88, 0x46, 0xee, 0xb8, 0x14, 0xde, 0x5e, 0x0b, 0xdb,
  0xe0, 0x32, 0x3a, 0x0a, 0x49, 0x06, 0x24, 0x5c, 0xc2, 0xd3, 0xac, 0x62, 0x91, 0x95, 0xe4, 0x79,
  0xe7, 0xc8, 0x37, 0x6d, 0x8d, 0xd5, 0x4e, 0xa9, 0x6c, 0x56, 0xf4, 0xea, 0x65, 0x7a, 0xae, 0x08,
  0xba, 0x78, 0x25, 0x2e, 0x1c, 0xa6, 0xb4, 0xc6, 0xe8, 0xdd, 0x74, 0x1f, 0x4b, 0xbd, 0x8b, 0x8a,
  0x70, 0x3e, 0xb5, 0x66, 0x48, 0x03, 0xf6, 0x0e, 0x61, 0x35, 0x57, 0xb9, 0x86, 0xc1, 0x1d, 0x9e,
  0xe1, 0xf8, 0x98, 0x11, 0x69, 0xd9, 0x8e, 0x94, 0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf,
  0x8c, 0xa1, 0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68, 0x41, 0x99, 0x2d, 0x0f, 0xb0, 0x54, 0xbb, 0x16
};

static const uint8_t rcon_rom[11] = {0x8d, 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36};

static void check(const char *what, uint32_t got, uint32_t expected) {
    if (got != expected) {
        printf("[FAIL] %s: got 0x%x, expected 0x%x\n", what, (unsigned)got, (unsigned)expected);
        errors = errors + 1;
    }
}

/* The tables, the key and the base counter in the SPM: small and hot, as any bare metal port would do */
static void init_hot(void) {
    volatile uint8_t *sbox = (volatile uint8_t *)(HOT + AES_HOT_SBOX);
    volatile uint8_t *rcon = (volatile uint8_t *)(HOT + AES_HOT_RCON);
    volatile uint8_t *key  = (volatile uint8_t *)(HOT + AES_HOT_KEY);
    volatile uint8_t *iv   = (volatile uint8_t *)(HOT + AES_HOT_IV);

    for (int i = 0; i < 256; i++)
        sbox[i] = sbox_rom[i];
    for (int i = 0; i < 11; i++)
        rcon[i] = rcon_rom[i];
    for (int i = 0; i < NK * 4; i++)
        key[i] = (uint8_t)i;                  /* FIPS-197 key of the known answer tests */
    for (int i = 0; i < 16; i++)
        iv[i] = (uint8_t)(0xA0 + i);          /* same base for every variant: same ciphertext */
}

static uint32_t ct_checksum(void) {
    volatile uint32_t *ct = (volatile uint32_t *)CT_ADDR;
    uint32_t s = 0;

    dcache_flush();
    for (uint32_t j = 0; j < DATA_BYTES / 4; j++)
        s += ct[j];
    return s;
}

/* A struct assignment here turns into a call to memset or memcpy, which the bare metal build does not have */
static void perf_zero(dcache_perf_t *p) {
    p->hit_r = 0; p->hit_w = 0; p->miss_r = 0; p->miss_w = 0;
    p->refill = 0; p->writeback = 0; p->stall = 0; p->tcdm_stall = 0;
}

static uint32_t max_cycles(volatile aes_params_t *p) {
    uint32_t max = 0;
    for (int c = 0; c < PULP_CORE_COUNT; c++)
        if (p->cycles[c] > max)
            max = p->cycles[c];
    return max;
}

static void print_res(const char *variant, uint32_t budget, uint32_t cycles, const dcache_perf_t *perf) {
    printf("RES variant=%s budget=%d kernel=aes%d cycles=%d hit_r=%d miss_r=%d hit_w=%d miss_w=%d refill=%d "
           "wb=%d\n", variant, (int)(budget / 1024), AES_KEY_BITS, (int)cycles, (int)perf->hit_r,
           (int)perf->miss_r, (int)perf->hit_w, (int)perf->miss_w, (int)perf->refill, (int)perf->writeback);
}

static void run_team(volatile aes_params_t *p) {
    cluster_arm_done_event();
    cluster_dispatch_task_with_params(OBPMARK_AES_CLUSTER_TEST_TASK, (uint32_t)p);
    cluster_wait_done_eu();
}

/* One case: the cache set up for the variant, the team, the checks and the result line */
static void run_case(uint32_t variant, uint32_t budget, uint32_t prefetch) {
    volatile aes_params_t *p = (volatile aes_params_t *)PARAMS;
    const char   *name;
    uint32_t      way_bytes = L1_DCACHE_SIZE / dcache_num_ways();
    uint32_t      ways = budget / way_bytes;
    uint32_t      spm_base, spm_size, t, sum;
    dcache_perf_t perf;

    if (variant == AES_VAR_IDMA) {
        name = "idma";
        /* Four halves of the budget: pt0 pt1 ct0 ct1 */
        p->tile_blocks = (budget / 4) / 16;
        if (p->tile_blocks % PULP_CORE_COUNT != 0 || AES_BLOCKS % p->tile_blocks != 0) {
            printf("idma %d KiB: the tile does not divide, skipped\n", (int)(budget / 1024));
            return;
        }
    } else if (variant == AES_VAR_L2 && budget) {
        name = prefetch ? "cache_pf1" : "cache_pf0";
        if (ways == 0 || ways > dcache_num_ways() || ways * way_bytes != budget) {
            printf("cache %d KiB: not a number of ways, skipped\n", (int)(budget / 1024));
            return;
        }
    } else {
        name = "direct";
    }

    p->variant     = variant;
    p->pt          = PT_ADDR;
    p->ct          = CT_ADDR;
    p->blocks      = AES_BLOCKS;
    p->hot         = HOT;
    p->spm         = SPM;
    p->spm_loc     = SPM_LOC;
    p->kat_errors  = 0;

    dcache_flush();
    if (budget && variant == AES_VAR_L2) {
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
    if (p->kat_errors)
        check("FIPS-197 known answer", 1, 0);
    sum = ct_checksum();
    if (!have_golden) {
        golden      = sum;
        have_golden = 1;
    } else {
        check("ciphertext checksum", sum, golden);
    }
    print_res(name, (variant == AES_VAR_L2 && !budget) ? 0 : budget, max_cycles(p), &perf);
}

int main(void) {
    volatile uint32_t *pt = (volatile uint32_t *)PT_ADDR;
    uint32_t x = 0x2026u;

    asm volatile("csrw mcountinhibit, zero");
    errors      = 0;
    have_golden = 0;

    if (magia_tile_id() == 0)
        printf("obpmark_aes_cluster: %d cores, aes-%d ctr, %d blocks (%d KiB), dcache %d ways x %d sets\n",
               PULP_CORE_COUNT, AES_KEY_BITS, AES_BLOCKS, DATA_BYTES / 1024, (int)dcache_num_ways(),
               MAGIA_DCACHE_SETS);
    if (!dcache_geometry_ok() || (uint32_t)&_bss_end > ARENA || ARENA_END > 0xCCF00000) {
        printf("[FAIL] tile %d: geometry or arena\n", (int)magia_tile_id());
        return 1;
    }

    cluster_boot(PULP_BINARY_START);
    init_hot();
    for (uint32_t i = 0; i < DATA_BYTES / 4; i++) {
        x = x * 1664525u + 1013904223u;
        pt[i] = x;
    }
    dcache_flush();

    if (RUN_DIRECT)
        run_case(AES_VAR_L2, 0, 0);
    for (uint32_t i = 0; i < sizeof(budgets_kib) / sizeof(budgets_kib[0]); i++) {
        uint32_t budget = budgets_kib[i] * 1024;
        if (RUN_IDMA)
            run_case(AES_VAR_IDMA, budget, 0);
        if (CACHE_PF & 1)
            run_case(AES_VAR_L2, budget, 0);
        if (CACHE_PF & 2)
            run_case(AES_VAR_L2, budget, 1);
    }

    printf("obpmark_aes_cluster_test: %d errors\n", (int)errors);
    return errors;
}
