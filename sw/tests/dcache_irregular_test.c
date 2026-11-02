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
 * Irregular kernel on the control core: LOOKUPS lookups at pseudo-random indices (xorshift) in a TABLE_WORDS table
 * in L2. 7 lookups out of 8 fall in a hot window of the table, the others anywhere. The index of each lookup is
 * known only when the lookup is made, so the software cannot plan the transfers. The ways:
 *   direct    : loads from L2 (cache off)
 *   cache     : the same loop, through the data cache (next-line prefetch off and on)
 *   idma_all  : the whole table copied to the SPM first, then loads from the SPM (only if the table fits)
 *   idma_word : one iDMA transfer per lookup (software gather, the only way without SPM for the table)
 *   idma_hot  : the software knows the hot window: HOT_BUDGET bytes of it copied to the SPM, the other lookups
 *               from L2 (cache off). The best an SPM of the same L1 budget as the cache can do
 * With WARM = 1 the cache runs LOOKUPS lookups (cold) and then LOOKUPS more (warm, the sequence goes on); the other
 * ways run the warm sequence. Hot windows, sizes and ways are defines (a scaled run is a wrapper that defines them
 * and includes this file). The table lives in an L2 arena above .bss and is written by the iDMA from a pattern.
 * Every run starts with the table only in L2.
 */

#include "magia_tile_utils.h"
#include "magia_dcache_utils.h"
#include "idma_mm_utils.h"

// GCC 14 crashes ("could not split insn", doloop_begin_i) on the cv32e40p hardware loop of the big loops
#pragma GCC optimize("no-branch-count-reg")

////////////////
// Parameters //
////////////////

#ifndef TABLE_WORDS
#define TABLE_WORDS   (32 * 1024)             /* 128 KiB, a power of two */
#endif
#ifndef LOOKUPS
#define LOOKUPS       (4096)
#endif
#ifndef REF_LOOKUPS
#define REF_LOOKUPS   (LOOKUPS)               /* direct and idma_word: no state, cost per lookup */
#endif
#ifndef HOT_KIB
#define HOT_KIB       8, 64                   /* hot windows, KiB, powers of two */
#endif
#ifndef HOT_BUDGET
#define HOT_BUDGET    (L1_DCACHE_SIZE)        /* idma_hot: SPM bytes, the L1 budget of the cache */
#endif
#ifndef WARM
#define WARM          (0)
#endif
#ifndef RUN_DIRECT
#define RUN_DIRECT    (1)
#endif
#ifndef RUN_IDMA_ALL
#define RUN_IDMA_ALL  (1)
#endif
#ifndef RUN_IDMA_WORD
#define RUN_IDMA_WORD (1)
#endif
#ifndef RUN_IDMA_HOT
#define RUN_IDMA_HOT  (1)
#endif
#ifndef CACHE_PF
#define CACHE_PF      (3)                     /* bit 0: cache with prefetch off, bit 1: with prefetch on */
#endif

#define DMA_CHUNK     (32 * 1024)             /* one iDMA transfer: the length is 16 bits */
#define SEED          (0x12345678)

/////////////////////
// Memory and data //
/////////////////////

#define ARENA         (0xCC100000)            /* L2, above .data/.bss, inside the cacheable region at reset */
#define table         ((volatile uint32_t *)ARENA)

/* Pattern for the iDMA fill: PAT[j] = j, 64 KiB at the top of the SPM (below the cache store) */
#define PAT_WORDS     (16 * 1024)
#define PAT           (L1_BASE + L1_SPM_SIZE - PAT_WORDS * 4)
#define SPM_TABLE     (L1_BASE)               /* idma_all: copy of the table; idma_hot: copy of the window */
#define SPM_WORD      (PAT - 32)              /* idma_word: landing slot of one lookup */

extern char _bss_end;

static const uint32_t hot_kib[] = {HOT_KIB};
static uint32_t errors = 0;

static inline uint32_t read_mcycle(void) {
  uint32_t cycles;
  asm volatile("csrr %0, mcycle" : "=r"(cycles));
  return cycles;
}

/* table[i]: chunk c of 8 K words is PAT[8 c ...] */
static inline uint32_t val(uint32_t i) {
  return (i & 8191) + 8 * (i >> 13);
}

/* Index of the next lookup: 7 out of 8 in the hot window [0, hot_words), the others anywhere */
static inline uint32_t next_index(uint32_t *state, uint32_t hot_words) {
  uint32_t s = *state;
  s ^= s << 13;
  s ^= s >> 17;
  s ^= s << 5;
  *state = s;
  if ((s & 7) != 0)
    return (s >> 3) & (hot_words - 1);
  return (s >> 3) & (TABLE_WORDS - 1);
}

static void check(const char *what, uint32_t got, uint32_t expected) {
  if (got != expected) {
    printf("[FAIL] %s: got 0x%x, expected 0x%x\n", what, (unsigned)got, (unsigned)expected);
    errors++;
  }
}

/* The done id of each direction grows in order: wait until it reaches id */
static inline void wait_in(uint32_t id) {
  while ((int32_t)(idma_mm_get_done_id_dir(0, 0) - id) < 0);
}

static inline void wait_out(uint32_t id) {
  while ((int32_t)(idma_mm_get_done_id_dir(1, 0) - id) < 0);
}

static uint32_t dma_in(uint32_t l2, uint32_t l1, uint32_t bytes) {
  uint32_t id = 0;
  for (uint32_t off = 0; off < bytes; off += DMA_CHUNK) {
    uint32_t len = (bytes - off < DMA_CHUNK) ? bytes - off : DMA_CHUNK;
    id = idma_L2ToL1(l2 + off, l1 + off, len);
  }
  return id;
}

///////////
// Loops //
///////////

/* Golden: the same sequence, values from the pattern formula, no memory access */
static uint32_t lookup_golden(uint32_t *state, int n, uint32_t hot_words) {
  uint32_t sum = 0;
  for (int k = 0; k < n; k++)
    sum += val(next_index(state, hot_words));
  return sum;
}

/* direct, cache and idma_all: plain C */
static uint32_t lookup_mem(volatile uint32_t *t, uint32_t *state, int n, uint32_t hot_words) {
  uint32_t sum = 0;
  for (int k = 0; k < n; k++)
    sum += t[next_index(state, hot_words)];
  return sum;
}

/* idma_word: every lookup is a transfer to the SPM and a wait */
static uint32_t lookup_idma_word(uint32_t *state, int n, uint32_t hot_words) {
  uint32_t sum = 0;
  for (int k = 0; k < n; k++) {
    uint32_t idx = next_index(state, hot_words);
    wait_in(idma_L2ToL1((uint32_t)&table[idx], SPM_WORD, 4));
    sum += mmio32(SPM_WORD);
  }
  return sum;
}

/* idma_hot: the first spm_words of the window from the SPM, the rest from L2 */
static uint32_t lookup_hot(uint32_t *state, int n, uint32_t hot_words, uint32_t spm_words) {
  volatile uint32_t *spm = (volatile uint32_t *)SPM_TABLE;
  uint32_t           sum = 0;
  for (int k = 0; k < n; k++) {
    uint32_t idx = next_index(state, hot_words);
    if (idx < spm_words)
      sum += spm[idx];
    else
      sum += table[idx];
  }
  return sum;
}

//////////
// Runs //
//////////

static void print_res(const char *variant, uint32_t hot_words, const char *phase, int n, uint32_t cycles,
                      uint32_t extra, const dcache_perf_t *perf) {
  printf("RES variant=%s hot=%d phase=%s lookups=%d cycles=%d extra=%d hit_r=%d miss_r=%d refill=%d\n", variant,
         (int)(hot_words / 256), phase, n, (int)cycles, (int)extra, (int)perf->hit_r, (int)perf->miss_r,
         (int)perf->refill);
}

static void run_cache(uint32_t hot_words, uint32_t prefetch, uint32_t golden_a, uint32_t golden_b) {
  const char   *variant = prefetch ? "cache_pf1" : "cache_pf0";
  uint32_t      state = SEED, start, t, sum;
  dcache_perf_t perf;

  dcache_flush();
  dcache_set_prefetch(prefetch);
  dcache_perf_start();
  start = read_mcycle();
  sum   = lookup_mem(table, &state, LOOKUPS, hot_words);
  t     = read_mcycle() - start;
  dcache_perf_stop();
  dcache_perf_read(&perf);
  check(variant, sum, golden_a);
  print_res(variant, hot_words, "cold", LOOKUPS, t, 0, &perf);
  if (WARM) {
    dcache_perf_start();
    start = read_mcycle();
    sum   = lookup_mem(table, &state, LOOKUPS, hot_words);
    t     = read_mcycle() - start;
    dcache_perf_stop();
    dcache_perf_read(&perf);
    check(variant, sum, golden_b);
    print_res(variant, hot_words, "warm", LOOKUPS, t, 0, &perf);
  }
  dcache_set_prefetch(0);
}

static void run(uint32_t hot_words) {
  const char   *phase = WARM ? "warm" : "cold";
  dcache_perf_t none = {0};
  uint32_t      state, state_b, golden_a, golden_b, golden_ref, start, t, copy, sum;

  // Golden of the cold sequence (A), of the warm one (B, it goes on from A) and of the REF_LOOKUPS references
  state    = SEED;
  golden_a = lookup_golden(&state, LOOKUPS, hot_words);
  state_b  = WARM ? state : SEED;
  golden_b = WARM ? lookup_golden(&state, LOOKUPS, hot_words) : golden_a;
  state    = state_b;
  golden_ref = lookup_golden(&state, REF_LOOKUPS, hot_words);

  if (RUN_DIRECT) {
    dcache_enable(0);
    state = state_b;
    start = read_mcycle();
    sum   = lookup_mem(table, &state, REF_LOOKUPS, hot_words);
    t     = read_mcycle() - start;
    dcache_enable(1);
    check("direct", sum, golden_ref);
    print_res("direct", hot_words, phase, REF_LOOKUPS, t, 0, &none);
  }

  if (CACHE_PF & 1)
    run_cache(hot_words, 0, golden_a, golden_b);
  if (CACHE_PF & 2)
    run_cache(hot_words, 1, golden_a, golden_b);

  if (RUN_IDMA_ALL && TABLE_WORDS * 4 <= SPM_WORD - SPM_TABLE) {
    dcache_flush();
    state = state_b;
    start = read_mcycle();
    wait_in(dma_in(ARENA, SPM_TABLE, TABLE_WORDS * 4));
    copy  = read_mcycle() - start;
    sum   = lookup_mem((volatile uint32_t *)SPM_TABLE, &state, LOOKUPS, hot_words);
    t     = read_mcycle() - start;
    check("idma_all", sum, golden_b);
    print_res("idma_all", hot_words, phase, LOOKUPS, t, copy, &none);
  }

  if (RUN_IDMA_WORD) {
    state = state_b;
    start = read_mcycle();
    sum   = lookup_idma_word(&state, REF_LOOKUPS, hot_words);
    t     = read_mcycle() - start;
    check("idma_word", sum, golden_ref);
    print_res("idma_word", hot_words, phase, REF_LOOKUPS, t, 0, &none);
  }

  if (RUN_IDMA_HOT) {
    uint32_t spm_bytes = (hot_words * 4 < HOT_BUDGET) ? hot_words * 4 : HOT_BUDGET;
    dcache_enable(0);
    state = state_b;
    start = read_mcycle();
    wait_in(dma_in(ARENA, SPM_TABLE, spm_bytes));
    copy  = read_mcycle() - start;
    sum   = lookup_hot(&state, LOOKUPS, hot_words, spm_bytes / 4);
    t     = read_mcycle() - start;
    dcache_enable(1);
    check("idma_hot", sum, golden_b);
    print_res("idma_hot", hot_words, phase, LOOKUPS, t, copy, &none);
  }
}

int main(void) {
  uint32_t id = 0;

  asm volatile("csrw mcountinhibit, zero");

  printf("dcache %d KiB, geometry %s; table %d KiB, %d lookups, warm %d, idma_hot budget %d KiB\n",
         L1_DCACHE_SIZE / 1024, dcache_geometry_ok() ? "ok" : "MISMATCH", TABLE_WORDS / 256, LOOKUPS, WARM,
         HOT_BUDGET / 1024);
  if (!dcache_geometry_ok() || (uint32_t)&_bss_end > ARENA || ARENA + TABLE_WORDS * 4 > 0xCCF00000 ||
      HOT_BUDGET > SPM_WORD - SPM_TABLE) {
    printf("[FAIL] geometry, arena or budget\n");
    return 1;
  }

  // Pattern in the SPM, then the table in L2 by the iDMA
  for (uint32_t j = 0; j < PAT_WORDS; j++)
    mmio32(PAT + j * 4) = j;
  dcache_flush();
  for (uint32_t c = 0; c * 8192 < TABLE_WORDS; c++)
    id = idma_L1ToL2(PAT + 8 * c * 4, ARENA + c * 8192 * 4, 8192 * 4);
  wait_out(id);

  for (uint32_t i = 0; i < sizeof(hot_kib) / sizeof(hot_kib[0]); i++)
    run(hot_kib[i] * 256);

  printf("dcache_irregular_test: %d errors\n", (int)errors);
  return errors;
}
