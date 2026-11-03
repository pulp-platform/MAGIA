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
 * RaiderSTREAM on the control core: the 16 kernels of sw/tests/raiderstream_kernels.h, each run through the
 * three transports under comparison.
 *
 *   direct : the arrays stay in the L2 and the cache is off. The no-cache baseline
 *   idma   : what the iDMA can stage is staged in the L1 scratchpad, double buffered, within the budget;
 *            what is reached through an index stays in the L2 (the cache is off there too: an iDMA cannot
 *            gather, and leaving the cache on would make this variant secretly cache assisted)
 *   cache  : the same code as `direct`, but the region is cacheable and the cache gets a budget of ways
 *            equal to the iDMA buffers (WAY_EN). Prefetch off and on
 *
 * `direct` and `cache` run the very same loop: only the configuration around it changes.
 * The eight-core counterpart is cluster_tests/raiderstream_cluster_test/, built on the same kernels, with
 * the same variants and the same RES lines, so the two compare kernel by kernel.
 *
 * Checks: the index arrays are permutations, so a group of four operations always leaves
 * sum(a) = 15 S, sum(b) = 3 S, sum(c) = 4 S with S the sum of the initial a. One check covers 16 kernels.
 *
 * Needs the cache (make dcache=1). Sizes and variants are defines, overridable with EXTRA_CFLAGS.
 */

#include "magia_tile_utils.h"
#include "magia_dcache_utils.h"
#include "bench_utils.h"
#include "raiderstream_kernels.h"

// GCC 14 crashes ("could not split insn", doloop_begin_i) on the cv32e40p hardware loop of the big loops
#pragma GCC optimize("no-branch-count-reg")
#pragma GCC optimize("align-loops=4")

////////////////
// Parameters //
////////////////

#ifndef STREAM_WORDS
#define STREAM_WORDS (4 * 1024)               /* words of a, b, c and of each index array */
#endif
#ifndef BUDGETS_KIB
#define BUDGETS_KIB  16, 32                   /* L1 budgets (iDMA buffers, cache ways), KiB */
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
#define GROUPS       (0xF)                    /* bit g: run group g (G_SEQ, G_GATHER, G_SCATTER, G_SG) */
#endif
/* STREAM_OFFSET is the OFFSET of STREAM: without it the arrays are a multiple of the way size apart and
 * a[j], b[j], c[j] fight for the same set. SetXorHash makes it unnecessary (see CACHE_VS_SCRATCHPAD.md). */
#ifndef STREAM_OFFSET
#define STREAM_OFFSET (128)
#endif
#ifndef ARENA_STRIDE
#define ARENA_STRIDE (0x00080000)             /* L2 arena per tile: the six arrays fit with room to spare */
#endif

#define N (STREAM_WORDS)

/////////////////////
// Memory and data //
/////////////////////

/* L2 arena, one per tile. On a mesh the tiles must not share the arrays: there is no coherence between
 * tiles, and the program image is one copy for all of them. */
#define ARR_BYTES    (N * 4 + STREAM_OFFSET)
#define A_OFF        (0)
#define B_OFF        (A_OFF + ARR_BYTES)
#define C_OFF        (B_OFF + ARR_BYTES)
#define I1_OFF       (C_OFF + ARR_BYTES)
#define I2_OFF       (I1_OFF + ARR_BYTES)
#define I3_OFF       (I2_OFF + ARR_BYTES)
#define ARENA_BYTES  (I3_OFF + N * 4)
#define ARENA        (0xCC200000u + magia_tile_id() * ARENA_STRIDE)

/* L1. The core reads and writes through the global view, the iDMA through the local one: same memory, two
 * addresses (see L1_LOCAL / L1_GLOBAL in magia_tile_utils.h). */
#define STATE_OFF    (0x800)                  /* the state of this core: see below */
#define SPM_OFF      (0x1000)                 /* iDMA buffers, and the permutation scratch before the runs */
#define PAT_WORDS    (8 * 1024 + 8 * (N / 8192))
#define PAT_OFF      (L1_SPM_SIZE - PAT_WORDS * 4)   /* the fill pattern, top of the SPM, out of the budgets */

#define STATE        L1_GLOBAL(STATE_OFF)
#define SPM          L1_GLOBAL(SPM_OFF)
#define SPM_LOC      L1_LOCAL(SPM_OFF)
#define PAT          L1_GLOBAL(PAT_OFF)
#define PAT_LOC      L1_LOCAL(PAT_OFF)

/* No mutable globals: .data and .bss live in the L2 and the program image is one copy for the whole mesh,
 * so a global would be shared by every tile. */
#define errors       (*(volatile uint32_t *)(STATE + 0))
#define lcg_state    (*(volatile uint32_t *)(STATE + 4))

extern char _bss_end;

static const uint32_t budgets_kib[] = {BUDGETS_KIB};

/* ARENA reads mhartid, so this must never be called inside a timed loop: ask for the six addresses once,
 * before the measurement, with role_addrs(). */
static inline uint32_t role_addr(uint32_t r) {
  static const uint32_t off[R_NUM] = {A_OFF, B_OFF, C_OFF, I1_OFF, I2_OFF, I3_OFF};
  return ARENA + off[r];
}

static void role_addrs(uint32_t *out) {
  uint32_t arena = ARENA;
  static const uint32_t off[R_NUM] = {A_OFF, B_OFF, C_OFF, I1_OFF, I2_OFF, I3_OFF};
  for (int r = 0; r < R_NUM; r++)
    out[r] = arena + off[r];
}

/* a[i] = val(i, 0). With N <= 8192 this is just a[i] = i; the rest of the formula is what keeps the values
 * going up when fill() has to copy the pattern in several pieces (see fill). */
static inline uint32_t val(uint32_t i, uint32_t o) {
  return (i & 8191) + 8 * (i >> 13) + o;
}

static void check(const char *variant, const char *what, uint32_t got, uint32_t expected) {
  if (got != expected) {
    printf("[FAIL] %s %s: got 0x%x, expected 0x%x\n", variant, what, (unsigned)got, (unsigned)expected);
    errors = errors + 1;
  }
}

/////////////////////////
// Data, written by DMA //
/////////////////////////

/* The arrays are written by the iDMA from a pattern in the SPM, never by the core: a store from the core
 * would go through the cache, leave the data dirty there instead of in the L2, and count on the performance
 * counters. The pattern is copied in pieces of 8192 words; piece c starts at PAT[8 c] so that the values
 * keep going up across pieces, which is what val() describes. */
static void fill(uint32_t l2, uint32_t words, uint32_t o) {
  uint32_t id = 0;
  for (uint32_t c = 0; c * 8192 < words; c++) {
    uint32_t n = (words - c * 8192 < 8192) ? words - c * 8192 : 8192;
    id = idma_L1ToL2(PAT_LOC + (o + 8 * c) * 4, l2 + c * 8192 * 4, n * 4);
  }
  idma_wait_out(id);
}

static uint32_t golden_sum(uint32_t words, uint32_t o) {
  uint32_t s = 0;
  for (uint32_t c = 0; c * 8192 < words; c++) {
    uint32_t n = (words - c * 8192 < 8192) ? words - c * 8192 : 8192;
    s += n * (n - 1) / 2 + n * (8 * c + o);
  }
  return s;
}

/* A random permutation of 0 .. N-1 (Fisher-Yates, as RaiderSTREAM initRandomIdxArray), built in the SPM and
 * sent to the L2 by the iDMA. A permutation and not random indices: with repetitions two j would write the
 * same cell and the sums below would not hold. */
static void make_permutation(uint32_t l2) {
  volatile uint32_t *scratch = (volatile uint32_t *)SPM;   /* read once, outside the loops below */

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

////////////////////////////
// The three transports   //
////////////////////////////

RS_KERNEL static uint32_t sum_arr(volatile uint32_t *p, uint32_t n) {
  uint32_t s = 0;
  for (uint32_t j = 0; j < n; j++)
    s += p[j];
  return s;
}

static void print_res(const char *variant, uint32_t budget, const char *kernel, uint32_t cycles,
                      const dcache_perf_t *perf) {
  printf("RES variant=%s budget=%d kernel=%s cycles=%d hit_r=%d miss_r=%d hit_w=%d miss_w=%d refill=%d wb=%d\n",
         variant, (int)(budget / 1024), kernel, (int)cycles, (int)perf->hit_r, (int)perf->miss_r,
         (int)perf->hit_w, (int)perf->miss_w, (int)perf->refill, (int)perf->writeback);
}

/* Before a group: write back what the cache holds, a again from the pattern. b and c need no reset, copy
 * and scale overwrite them completely. */
static void init_group(void) {
  dcache_flush();
  fill(role_addr(R_A), N, 0);
}

/* After a group, the three sums. The four operations in order give, whatever the group, sum(a) = 15 S,
 * sum(b) = 3 S, sum(c) = 4 S: copy puts S in c, scale 3S in b, add 4S in c, triad 15S in a. An index array
 * is a permutation, so it only moves the values around and the sums are the same for all four groups. */
static void check_group(const char *variant, uint32_t g) {
  volatile uint32_t *a = (volatile uint32_t *)role_addr(R_A);
  volatile uint32_t *b = (volatile uint32_t *)role_addr(R_B);
  volatile uint32_t *c = (volatile uint32_t *)role_addr(R_C);
  uint32_t s = golden_sum(N, 0);

  dcache_flush();                             /* without this we would read the L2 while the results are
                                               * still dirty in the cache */
  check(variant, "sum(a)", sum_arr(a, N), 15 * s);
  check(variant, "sum(b)", sum_arr(b, N), 3 * s);
  check(variant, "sum(c)", sum_arr(c, N), 4 * s);
  if (g == G_SEQ) {
    /* A sum does not notice two swapped elements. Where the positions are predictable, check them too. */
    for (uint32_t i = 0; i < N; i += 61) {
      check(variant, "seq a[i]", a[i], 15 * val(i, 0));
      check(variant, "seq b[i]", b[i], 3 * val(i, 0));
      check(variant, "seq c[i]", c[i], 4 * val(i, 0));
    }
  }
}

/* The kernel on the whole L2 arrays. `direct` and `cache` both call this one. */
static void run_whole_arrays(uint32_t g, uint32_t op) {
  volatile uint32_t *p[R_NUM];
  uint32_t addr[R_NUM];

  role_addrs(addr);
  for (int r = 0; r < R_NUM; r++)
    p[r] = (volatile uint32_t *)addr[r];
  rs_kernel(g, op, p, 0, N);
}

/* The iDMA variant: the streams the plan allows, in tiles, double buffered. While the core works on half b
 * the iDMA fills half nx; the irregular arrays are reached where they are, in the L2. */
static void run_tiled(uint32_t g, uint32_t op, uint32_t budget) {
  rs_plan_t pl;
  uint32_t  addr[R_NUM];
  uint32_t  spm = SPM;                        /* SPM is L1_GLOBAL, so it reads mhartid: read it once */
  uint32_t  in_id[2] = {0, 0}, out_id[2] = {0, 0};

  if (!rs_plan(g, op, &pl))
    return;
  role_addrs(addr);
  uint32_t tile_words = rs_tile_words(pl.n_streams, budget, N, 1);
  uint32_t tile_bytes = tile_words * 4;
  uint32_t tiles      = N / tile_words;

  /* The buffers sit one after the other from the start of the SPM, two halves each. The offset is the same
   * for both views of the L1: the core adds SPM, the iDMA adds SPM_LOC. */
  #define BUF_OFF(s, d) (((2 * (s)) + (d)) * tile_bytes)

  /* Where each role lives, once per half, before the measurement: a staged role points into its buffer and
   * is indexed from 0, an irregular one keeps its L2 address. Doing this per tile costs a couple of percent
   * on the short kernels, which is the order of the effects we are measuring. */
  volatile uint32_t *p[2][R_NUM];
  for (int d = 0; d < 2; d++)
    for (int r = 0; r < R_NUM; r++)
      p[d][r] = (volatile uint32_t *)((pl.role_buf[r] >= 0) ? spm + BUF_OFF(pl.role_buf[r], d) : addr[r]);

  for (uint32_t s = 0; s < pl.n_in; s++)
    in_id[0] = idma_in(addr[pl.in_role[s]], SPM_LOC + BUF_OFF(s, 0), tile_bytes);
  for (uint32_t t = 0; t < tiles; t++) {
    int b = t & 1, nx = b ^ 1;

    if (t + 1 < tiles) {
      /* Half nx still holds the result tile of t-1 until the iDMA has taken it away */
      if (pl.out_role >= 0 && t >= 1)
        idma_wait_out(out_id[nx]);
      for (uint32_t s = 0; s < pl.n_in; s++)
        in_id[nx] = idma_in(addr[pl.in_role[s]] + (t + 1) * tile_bytes,
                            SPM_LOC + BUF_OFF(s, nx), tile_bytes);
    }
    idma_wait_in(in_id[b]);
    rs_kernel(g, op, p[b], 0, tile_words);

    if (pl.out_role >= 0)
      out_id[b] = idma_out(SPM_LOC + BUF_OFF(pl.n_in, b),
                           addr[pl.out_role] + t * tile_bytes, tile_bytes);
  }
  if (pl.out_role >= 0)
    idma_wait_out(out_id[(tiles - 1) & 1]);
  #undef BUF_OFF
}

//////////
// Runs //
//////////

/* One group of four operations with the cache off: the arrays are reached straight in the L2 */
static void run_direct(uint32_t g) {
  dcache_perf_t none = {0};

  init_group();
  for (uint32_t op = 0; op < OP_NUM; op++) {
    uint32_t t;
    dcache_enable(0);
    t = read_mcycle(); run_whole_arrays(g, op); t = read_mcycle() - t;
    dcache_enable(1);                         /* back on: check_group needs to flush */
    print_res("direct", 0, rs_rows[g][op].name, t, &none);
  }
  check_group("direct", g);
}

/* One group with the iDMA. On the irregular groups the cache is switched off, otherwise the array reached
 * through an index would be served by it and this would not be an iDMA variant any more. */
static void run_idma(uint32_t g, uint32_t budget) {
  dcache_perf_t none = {0};

  if (g == G_SG)
    return;                                   /* irregular at both ends: nothing to stage */
  init_group();
  for (uint32_t op = 0; op < OP_NUM; op++) {
    uint32_t t;
    if (g != G_SEQ)
      dcache_enable(0);
    t = read_mcycle(); run_tiled(g, op, budget); t = read_mcycle() - t;
    if (g != G_SEQ)
      dcache_enable(1);
    print_res("idma", budget, rs_rows[g][op].name, t, &none);
  }
  check_group("idma", g);
}

/* One group through the cache, with the budget given as a number of ways. The final flush gets a RES line of
 * its own: getting the results to the L2 is a cost of this variant, and hiding it inside triad would be
 * flattering. */
static void run_cache(uint32_t g, uint32_t budget, uint32_t prefetch) {
  const char   *variant = prefetch ? "cache_pf1" : "cache_pf0";
  uint32_t      way_bytes = L1_DCACHE_SIZE / dcache_num_ways();
  uint32_t      ways = budget / way_bytes;
  uint32_t      spm_base, spm_size, t;
  dcache_perf_t perf, none = {0};

  if (ways == 0 || ways > dcache_num_ways() || ways * way_bytes != budget) {
    printf("cache %d KiB: not a whole number of ways, skipped\n", (int)(budget / 1024));
    return;
  }
  dcache_set_ways(ways, &spm_base, &spm_size);
  dcache_set_prefetch(prefetch);

  init_group();
  for (uint32_t op = 0; op < OP_NUM; op++) {
    dcache_perf_start();
    t = read_mcycle(); run_whole_arrays(g, op); t = read_mcycle() - t;
    dcache_perf_stop();
    dcache_perf_read(&perf);
    print_res(variant, budget, rs_rows[g][op].name, t, &perf);
  }
  t = read_mcycle(); dcache_flush(); t = read_mcycle() - t;
  print_res(variant, budget, "flush", t, &none);
  check_group(variant, g);

  dcache_set_prefetch(0);
  dcache_set_ways(dcache_num_ways(), &spm_base, &spm_size);
}

int main(void) {
  asm volatile("csrw mcountinhibit, zero");    /* without this mcycle does not run */
  errors    = 0;
  lcg_state = 0x2026u;

  printf("raiderstream: %d words per array, dcache %d ways x %d sets (%d KiB), geometry %s\n",
         N, (int)dcache_num_ways(), MAGIA_DCACHE_SETS, L1_DCACHE_SIZE / 1024,
         dcache_geometry_ok() ? "ok" : "MISMATCH");
  if (!dcache_geometry_ok()                    /* the ELF was built for another geometry */
      || (uint32_t)&_bss_end > ARENA           /* the program data reaches into the arena */
      || ARENA + ARENA_BYTES > 0xCCF00000      /* the arena reaches past the cacheable region */
      || N % 32 != 0                           /* not a whole number of cache lines */
      || STREAM_OFFSET % 128 != 0) {           /* the offset between arrays is not a whole line */
    printf("[FAIL] geometry, arena or alignment\n");
    return 1;
  }

  /* The pattern and the index arrays, written by the iDMA so that nothing of this touches the cache */
  uint32_t pat = PAT;                          /* L1_GLOBAL reads mhartid: not inside the loop */
  for (uint32_t j = 0; j < PAT_WORDS; j++)
    mmio32(pat + j * 4) = j;
  make_permutation(role_addr(R_I1));
  make_permutation(role_addr(R_I2));
  make_permutation(role_addr(R_I3));
  dcache_flush();                              /* the first measurement must start from a cold cache */

  for (uint32_t g = 0; g < G_NUM; g++) {
    if (!(GROUPS & (1u << g)))
      continue;
    if (RUN_DIRECT)
      run_direct(g);
    for (uint32_t i = 0; i < sizeof(budgets_kib) / sizeof(budgets_kib[0]); i++) {
      uint32_t budget = budgets_kib[i] * 1024;
      if (RUN_IDMA)
        run_idma(g, budget);
      if (CACHE_PF & 1)
        run_cache(g, budget, 0);
      if (CACHE_PF & 2)
        run_cache(g, budget, 1);
    }
  }

  printf("raiderstream_test: %d errors\n", (int)errors);
  return errors;
}
