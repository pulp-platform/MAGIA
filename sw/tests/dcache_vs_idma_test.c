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
 * Fair comparison on the control core: iDMA + SPM vs data cache, same L1 budget, same compute loops.
 * Rules: every run starts with the data only in L2 and ends with the results in L2 (the cache pays its final
 * flush); the iDMA version is double buffered and its buffers fit in the budget; the cache gets the same budget
 * with WAY_EN. L2 direct (cache off) is the reference.
 *   saxpy  : y = 3x + y, two VEC_WORDS arrays (streaming, no reuse)
 *   sum    : sum of a SUM_WORDS array (read only)
 *   matvec : y = A x, A ROWS x COLS words (read once), x COLS words (read ROWS times)
 *   reuse  : sum of a REUSE_WORDS array, REUSE_PASSES times (temporal reuse; off with REUSE_WORDS = 0)
 * Every size, the budgets, the kernels and the variants are defines (see below), so a scaled run is a wrapper that
 * defines them and includes this file. The arrays live in an L2 arena above .bss and are written by the iDMA
 * from a pattern in the SPM (a core loop or a .bss clear would cost more than the kernels). Needs the cache
 * (make dcache=1).
 */

#include "magia_tile_utils.h"
#include "magia_dcache_utils.h"
#include "idma_mm_utils.h"

// GCC 14 crashes ("could not split insn", doloop_begin_i) on the cv32e40p hardware loop of the big loops
#pragma GCC optimize("no-branch-count-reg")
// A loop starting with a 32-bit instruction at a 2-byte boundary costs one more cycle per iteration: the kernels are
// not inlined and aligned, so every version runs the same aligned loop
#pragma GCC optimize("align-loops=4")
#define KERNEL __attribute__((noinline, aligned(4)))

////////////////
// Parameters //
////////////////

#ifndef VEC_WORDS
#define VEC_WORDS    (8 * 1024)               /* saxpy: words per array */
#endif
#ifndef SUM_WORDS
#define SUM_WORDS    (16 * 1024)              /* sum */
#endif
#ifndef ROWS
#define ROWS         (64)                     /* matvec: A is ROWS x COLS */
#endif
#ifndef COLS
#define COLS         (256)
#endif
#ifndef REUSE_WORDS
#define REUSE_WORDS  (0)                      /* reuse: words of the array, 0 = off */
#endif
#ifndef REUSE_PASSES
#define REUSE_PASSES (4)
#endif
#ifndef BUDGETS_KIB
#define BUDGETS_KIB  16, 32                   /* L1 budgets, KiB */
#endif
#ifndef RUN_DIRECT
#define RUN_DIRECT   (1)                      /* L2 direct, cache off */
#endif
#ifndef DIRECT_DIV
#define DIRECT_DIV   (1)                      /* direct runs on 1/DIRECT_DIV of every array (no state: linear) */
#endif
#ifndef RUN_IDMA
#define RUN_IDMA     (1)
#endif
#ifndef CACHE_PF
#define CACHE_PF     (3)                      /* bit 0: cache with prefetch off, bit 1: with prefetch on */
#endif

#define K_SAXPY      (1 << 0)
#define K_SUM        (1 << 1)
#define K_MATVEC     (1 << 2)
#define K_REUSE      (1 << 3)
#ifndef KERNELS
#define KERNELS      (K_SAXPY | K_SUM | K_MATVEC | (REUSE_WORDS ? K_REUSE : 0))
#endif

#define ROW_BYTES    (COLS * 4)
#define DMA_CHUNK    (32 * 1024)              /* one iDMA transfer: the length is 16 bits */

/////////////////////
// Memory and data //
/////////////////////

static inline uint32_t tile_id(void) {
  uint32_t id;
  asm volatile("csrr %0, mhartid" : "=r"(id));
  return id;
}

/* L2 arena above .data/.bss (inside the cacheable region at reset). On a mesh every tile takes its own
 * slice, so the tiles do not write on each other: the point of a mesh run is the contention on the L2 and
 * on the NoC, not a data race. */
#ifndef ARENA_STRIDE
#define ARENA_STRIDE (0x00020000)             /* 128 KiB per tile */
#endif
/* Computed from the hart id every time it is used, on purpose: a static would live in .bss, which on a mesh
 * is one shared L2 location for every tile, so the tiles would all end up on the same arena. */
#define ARENA        (0xCC100000u + tile_id() * ARENA_STRIDE)
#define ALIGN_UP(a)  (((a) + 0xFFF) & ~0xFFF)
#define X_ADDR       (ARENA)
#define Y_ADDR       ALIGN_UP(X_ADDR + VEC_WORDS * 4)
#define BIG_ADDR     ALIGN_UP(Y_ADDR + VEC_WORDS * 4)
#define MAT_ADDR     ALIGN_UP(BIG_ADDR + SUM_WORDS * 4)
#define VEC_ADDR     ALIGN_UP(MAT_ADDR + ROWS * COLS * 4)
#define RES_ADDR     ALIGN_UP(VEC_ADDR + COLS * 4)
#define REUSE_ADDR   ALIGN_UP(RES_ADDR + ROWS * 4)
#define ARENA_END    ALIGN_UP(REUSE_ADDR + REUSE_WORDS * 4)

#define x            ((volatile uint32_t *)X_ADDR)
#define y            ((volatile uint32_t *)Y_ADDR)
#define big          ((volatile uint32_t *)BIG_ADDR)
#define mat          ((volatile uint32_t *)MAT_ADDR)
#define vec          ((volatile uint32_t *)VEC_ADDR)
#define res          ((volatile uint32_t *)RES_ADDR)
#define reuse_arr    ((volatile uint32_t *)REUSE_ADDR)

/* Pattern for the iDMA fills: PAT[j] = j, 64 KiB at the top of the SPM (below the cache store), out of the budgets */
#define PAT_WORDS    (16 * 1024)
#define PAT          (L1_BASE + L1_SPM_SIZE - PAT_WORDS * 4)
#define SPM          (L1_BASE)                /* iDMA buffers, from the start of the L1 */

/* Value of word i of an array filled with offset o: chunk c of 8 K words is PAT[o + 8 c ...] */
#define O_X          (0)
#define O_Y          (1024)
#define O_BIG        (2048)
#define O_MAT        (3072)
#define O_VEC        (4096)
#define O_RES        (5120)
#define O_REUSE      (6144)

extern char _bss_end;

static const uint32_t budgets_kib[] = {BUDGETS_KIB};
static uint32_t errors = 0;

static inline uint32_t read_mcycle(void) {
  uint32_t cycles;
  asm volatile("csrr %0, mcycle" : "=r"(cycles));
  return cycles;
}

static inline uint32_t val(uint32_t i, uint32_t o) {
  return (i & 8191) + 8 * (i >> 13) + o;
}

static void check(const char *what, uint32_t got, uint32_t expected) {
  if (got != expected) {
    printf("[FAIL] %s: got 0x%x, expected 0x%x\n", what, (unsigned)got, (unsigned)expected);
    errors++;
  }
}

//////////
// iDMA //
//////////

/* The done id of each direction grows in order: wait until it reaches id */
static inline void wait_in(uint32_t id) {
  while ((int32_t)(idma_mm_get_done_id_dir(0, 0) - id) < 0);
}

static inline void wait_out(uint32_t id) {
  while ((int32_t)(idma_mm_get_done_id_dir(1, 0) - id) < 0);
}

/* L2 -> L1 and L1 -> L2 of any length, in transfers of at most DMA_CHUNK bytes; returns the last id */
static uint32_t dma_in(uint32_t l2, uint32_t l1, uint32_t bytes) {
  uint32_t id = 0;
  for (uint32_t off = 0; off < bytes; off += DMA_CHUNK) {
    uint32_t len = (bytes - off < DMA_CHUNK) ? bytes - off : DMA_CHUNK;
    id = idma_L2ToL1(l2 + off, l1 + off, len);
  }
  return id;
}

static uint32_t dma_out(uint32_t l1, uint32_t l2, uint32_t bytes) {
  uint32_t id = 0;
  for (uint32_t off = 0; off < bytes; off += DMA_CHUNK) {
    uint32_t len = (bytes - off < DMA_CHUNK) ? bytes - off : DMA_CHUNK;
    id = idma_L1ToL2(l1 + off, l2 + off, len);
  }
  return id;
}

/* Array of words in L2 with the values val(i, o), written by the iDMA from the pattern */
static void fill(uint32_t l2, uint32_t words, uint32_t o) {
  uint32_t id = 0;
  for (uint32_t c = 0; c * 8192 < words; c++) {
    uint32_t n = (words - c * 8192 < 8192) ? words - c * 8192 : 8192;
    id = idma_L1ToL2(PAT + (o + 8 * c) * 4, l2 + c * 8192 * 4, n * 4);
  }
  wait_out(id);
}

static uint32_t golden_sum(uint32_t words, uint32_t o) {
  uint32_t s = 0;
  for (uint32_t c = 0; c * 8192 < words; c++) {
    uint32_t n = (words - c * 8192 < 8192) ? words - c * 8192 : 8192;
    s += n * (n - 1) / 2 + n * (8 * c + o);
  }
  return s;
}

/////////////
// Kernels //
/////////////

KERNEL static void saxpy(volatile uint32_t *xs, volatile uint32_t *ys, int n) {
  for (int i = 0; i < n; i++)
    ys[i] = 3 * xs[i] + ys[i];
}

KERNEL static uint32_t sum(volatile uint32_t *a, int n) {
  uint32_t s = 0;
  for (int i = 0; i < n; i++)
    s += a[i];
  return s;
}

KERNEL static void matvec(volatile uint32_t *a, volatile uint32_t *v, volatile uint32_t *r, int rows) {
  for (int i = 0; i < rows; i++) {
    uint32_t acc = 0;
    for (int j = 0; j < COLS; j++)
      acc += a[i * COLS + j] * v[j];
    r[i] = acc;
  }
}

static uint32_t sum_passes(volatile uint32_t *a, int n) {
  uint32_t s = 0;
  for (int p = 0; p < REUSE_PASSES; p++)
    s += sum(a, n);
  return s;
}

////////////////////////////////////
// iDMA versions, double buffered //
////////////////////////////////////

/* Buffers: x0 x1 y0 y1, each budget / 4 */
static void saxpy_idma(uint32_t budget) {
  uint32_t tile_bytes = (budget / 4 < VEC_WORDS * 4) ? budget / 4 : VEC_WORDS * 4;
  uint32_t tile_words = tile_bytes / 4;
  int      tiles      = VEC_WORDS / tile_words;
  uint32_t in_id[2]   = {0, 0}, out_id[2] = {0, 0};

  dma_in(X_ADDR, SPM, tile_bytes);
  in_id[0] = dma_in(Y_ADDR, SPM + 2 * tile_bytes, tile_bytes);
  for (int t = 0; t < tiles; t++) {
    int b = t & 1, n = b ^ 1;
    if (t + 1 < tiles) {
      if (t >= 1)
        wait_out(out_id[n]);
      dma_in(X_ADDR + (t + 1) * tile_bytes, SPM + n * tile_bytes, tile_bytes);
      in_id[n] = dma_in(Y_ADDR + (t + 1) * tile_bytes, SPM + (2 + n) * tile_bytes, tile_bytes);
    }
    wait_in(in_id[b]);
    saxpy((volatile uint32_t *)(SPM + b * tile_bytes), (volatile uint32_t *)(SPM + (2 + b) * tile_bytes), tile_words);
    out_id[b] = dma_out(SPM + (2 + b) * tile_bytes, Y_ADDR + t * tile_bytes, tile_bytes);
  }
  wait_out(out_id[(tiles - 1) & 1]);
}

/* Buffers: a0 a1, each budget / 2 */
static uint32_t sum_idma(uint32_t budget, uint32_t l2, uint32_t words) {
  uint32_t tile_bytes = (budget / 2 < words * 4) ? budget / 2 : words * 4;
  uint32_t tile_words = tile_bytes / 4;
  int      tiles      = words / tile_words;
  uint32_t id[2]      = {0, 0}, s = 0;

  id[0] = dma_in(l2, SPM, tile_bytes);
  for (int t = 0; t < tiles; t++) {
    int b = t & 1, n = b ^ 1;
    if (t + 1 < tiles)
      id[n] = dma_in(l2 + (t + 1) * tile_bytes, SPM + n * tile_bytes, tile_bytes);
    wait_in(id[b]);
    s += sum((volatile uint32_t *)(SPM + b * tile_bytes), tile_words);
  }
  return s;
}

/* Buffers: x (ROW_BYTES), y (ROWS words), two tiles of rows of A in the rest of the budget */
static void matvec_idma(uint32_t budget) {
  uint32_t vec_buf   = SPM;
  uint32_t res_buf   = SPM + ROW_BYTES;
  uint32_t a_buf     = res_buf + ROWS * 4;
  uint32_t max_rows  = (budget - ROW_BYTES - ROWS * 4) / 2 / ROW_BYTES;
  uint32_t tile_rows = 1;
  // a power of two, so that the tiles cover the ROWS rows exactly
  while (2 * tile_rows <= max_rows && 2 * tile_rows <= ROWS)
    tile_rows *= 2;
  uint32_t tile_bytes = tile_rows * ROW_BYTES;
  int      tiles     = ROWS / tile_rows;
  uint32_t id[2]     = {0, 0};

  id[0] = dma_in(VEC_ADDR, vec_buf, ROW_BYTES);
  id[0] = dma_in(MAT_ADDR, a_buf, tile_bytes);
  for (int t = 0; t < tiles; t++) {
    int b = t & 1, n = b ^ 1;
    if (t + 1 < tiles)
      id[n] = dma_in(MAT_ADDR + (t + 1) * tile_bytes, a_buf + n * tile_bytes, tile_bytes);
    wait_in(id[b]);
    matvec((volatile uint32_t *)(a_buf + b * tile_bytes), (volatile uint32_t *)vec_buf,
           (volatile uint32_t *)(res_buf + t * tile_rows * 4), tile_rows);
  }
  wait_out(dma_out(res_buf, RES_ADDR, ROWS * 4));
}

/* The array fits in the budget: one copy, then every pass from the SPM. Otherwise every pass streams it again. */
static uint32_t reuse_idma(uint32_t budget) {
  uint32_t s = 0;
  if (REUSE_WORDS * 4 <= budget) {
    wait_in(dma_in(REUSE_ADDR, SPM, REUSE_WORDS * 4));
    s = sum_passes((volatile uint32_t *)SPM, REUSE_WORDS);
  } else {
    for (int p = 0; p < REUSE_PASSES; p++)
      s += sum_idma(budget, REUSE_ADDR, REUSE_WORDS);
  }
  return s;
}

//////////
// Runs //
//////////

/* Every run starts with its data only in L2: write back and drop what the cache holds, then the iDMA fills */
static void init_saxpy(void) {
  dcache_flush();
  fill(X_ADDR, VEC_WORDS, O_X);
  fill(Y_ADDR, VEC_WORDS, O_Y);
}

static void init_matvec(void) {
  dcache_flush();
  fill(RES_ADDR, ROWS, O_RES);
}

static void check_saxpy(const char *what, uint32_t n) {
  dcache_flush();
  for (uint32_t i = 0; i < n; i += 61)
    check(what, y[i], 3 * val(i, O_X) + val(i, O_Y));
  check(what, y[n - 1], 3 * val(n - 1, O_X) + val(n - 1, O_Y));
}

static void check_matvec(const char *what, uint32_t rows) {
  dcache_flush();
  for (uint32_t i = 0; i < rows; i++) {
    uint32_t acc = 0;
    for (uint32_t j = 0; j < COLS; j++)
      acc += val(i * COLS + j, O_MAT) * val(j, O_VEC);
    check(what, res[i], acc);
  }
}

static void print_res(const char *variant, uint32_t budget, const char *kernel, uint32_t cycles, uint32_t flush,
                      const dcache_perf_t *perf) {
  printf("RES tile=%d variant=%s budget=%d kernel=%s cycles=%d flush=%d hit_r=%d miss_r=%d hit_w=%d miss_w=%d refill=%d "
         "wb=%d\n", (int)tile_id(), variant, (int)(budget / 1024), kernel, (int)cycles, (int)flush, (int)perf->hit_r,
         (int)perf->miss_r, (int)perf->hit_w, (int)perf->miss_w, (int)perf->refill, (int)perf->writeback);
}

/* direct: cache off, on 1/DIRECT_DIV of every array */
static void run_direct(void) {
  dcache_perf_t none = {0};
  uint32_t      start, t, s;

  if (KERNELS & K_SAXPY) {
    init_saxpy();
    dcache_enable(0);
    start = read_mcycle(); saxpy(x, y, VEC_WORDS / DIRECT_DIV); t = read_mcycle() - start;
    dcache_enable(1);
    check_saxpy("direct saxpy", VEC_WORDS / DIRECT_DIV);
    print_res("direct", 0, "saxpy", t, 0, &none);
  }
  if (KERNELS & K_SUM) {
    dcache_enable(0);
    start = read_mcycle(); s = sum(big, SUM_WORDS / DIRECT_DIV); t = read_mcycle() - start;
    dcache_enable(1);
    check("direct sum", s, golden_sum(SUM_WORDS / DIRECT_DIV, O_BIG));
    print_res("direct", 0, "sum", t, 0, &none);
  }
  if (KERNELS & K_MATVEC) {
    init_matvec();
    dcache_enable(0);
    start = read_mcycle(); matvec(mat, vec, res, ROWS / DIRECT_DIV); t = read_mcycle() - start;
    dcache_enable(1);
    check_matvec("direct matvec", ROWS / DIRECT_DIV);
    print_res("direct", 0, "matvec", t, 0, &none);
  }
  if (KERNELS & K_REUSE) {
    dcache_enable(0);
    start = read_mcycle(); s = sum_passes(reuse_arr, REUSE_WORDS / DIRECT_DIV); t = read_mcycle() - start;
    dcache_enable(1);
    check("direct reuse", s, REUSE_PASSES * golden_sum(REUSE_WORDS / DIRECT_DIV, O_REUSE));
    print_res("direct", 0, "reuse", t, 0, &none);
  }
  printf("direct runs on 1/%d of the data\n", DIRECT_DIV);
}

/* iDMA + SPM, buffers within the budget (the cache keeps its ways, it is not used) */
static void run_idma(uint32_t budget) {
  dcache_perf_t none = {0};
  uint32_t      start, t, s;

  if (KERNELS & K_SAXPY) {
    init_saxpy();
    start = read_mcycle(); saxpy_idma(budget); t = read_mcycle() - start;
    check_saxpy("idma saxpy", VEC_WORDS);
    print_res("idma", budget, "saxpy", t, 0, &none);
  }
  if (KERNELS & K_SUM) {
    start = read_mcycle(); s = sum_idma(budget, BIG_ADDR, SUM_WORDS); t = read_mcycle() - start;
    check("idma sum", s, golden_sum(SUM_WORDS, O_BIG));
    print_res("idma", budget, "sum", t, 0, &none);
  }
  if (KERNELS & K_MATVEC) {
    init_matvec();
    start = read_mcycle(); matvec_idma(budget); t = read_mcycle() - start;
    check_matvec("idma matvec", ROWS);
    print_res("idma", budget, "matvec", t, 0, &none);
  }
  if (KERNELS & K_REUSE) {
    start = read_mcycle(); s = reuse_idma(budget); t = read_mcycle() - start;
    check("idma reuse", s, REUSE_PASSES * golden_sum(REUSE_WORDS, O_REUSE));
    print_res("idma", budget, "reuse", t, 0, &none);
  }
}

/* Cache with the same budget: budget / way size ways, results written back by the final flush (timed) */
static void run_cache(uint32_t budget, uint32_t prefetch) {
  const char   *variant = prefetch ? "cache_pf1" : "cache_pf0";
  uint32_t      way_bytes = L1_DCACHE_SIZE / dcache_num_ways();
  uint32_t      ways = budget / way_bytes;
  uint32_t      spm_base, spm_size, start, t, f, s;
  dcache_perf_t perf;

  if (ways == 0 || ways > dcache_num_ways() || ways * way_bytes != budget) {
    printf("cache %d KiB: not a number of ways, skipped\n", (int)(budget / 1024));
    return;
  }
  dcache_set_ways(ways, &spm_base, &spm_size);
  dcache_set_prefetch(prefetch);

  if (KERNELS & K_SAXPY) {
    init_saxpy();
    dcache_perf_start();
    start = read_mcycle(); saxpy(x, y, VEC_WORDS); t = read_mcycle() - start;
    dcache_perf_stop();
    dcache_perf_read(&perf);
    start = read_mcycle(); dcache_flush(); f = read_mcycle() - start;
    check_saxpy("cache saxpy", VEC_WORDS);
    print_res(variant, budget, "saxpy", t, f, &perf);
  }
  if (KERNELS & K_SUM) {
    dcache_flush();
    dcache_perf_start();
    start = read_mcycle(); s = sum(big, SUM_WORDS); t = read_mcycle() - start;
    dcache_perf_stop();
    dcache_perf_read(&perf);
    check("cache sum", s, golden_sum(SUM_WORDS, O_BIG));
    print_res(variant, budget, "sum", t, 0, &perf);
  }
  if (KERNELS & K_MATVEC) {
    init_matvec();
    dcache_perf_start();
    start = read_mcycle(); matvec(mat, vec, res, ROWS); t = read_mcycle() - start;
    dcache_perf_stop();
    dcache_perf_read(&perf);
    start = read_mcycle(); dcache_flush(); f = read_mcycle() - start;
    check_matvec("cache matvec", ROWS);
    print_res(variant, budget, "matvec", t, f, &perf);
  }
  if (KERNELS & K_REUSE) {
    dcache_flush();
    dcache_perf_start();
    start = read_mcycle(); s = sum_passes(reuse_arr, REUSE_WORDS); t = read_mcycle() - start;
    dcache_perf_stop();
    dcache_perf_read(&perf);
    check("cache reuse", s, REUSE_PASSES * golden_sum(REUSE_WORDS, O_REUSE));
    print_res(variant, budget, "reuse", t, 0, &perf);
  }

  dcache_set_prefetch(0);
  dcache_set_ways(dcache_num_ways(), &spm_base, &spm_size);
}

int main(void) {
  asm volatile("csrw mcountinhibit, zero");

  printf("dcache %d ways x %d sets (%d KiB), geometry %s; saxpy %d, sum %d, matvec %dx%d, reuse %dx%d words\n",
         (int)dcache_num_ways(), MAGIA_DCACHE_SETS, L1_DCACHE_SIZE / 1024, dcache_geometry_ok() ? "ok" : "MISMATCH",
         VEC_WORDS, SUM_WORDS, ROWS, COLS, REUSE_WORDS, REUSE_PASSES);
  if (!dcache_geometry_ok() || (uint32_t)&_bss_end > ARENA || ARENA_END > 0xCCF00000) {
    printf("[FAIL] geometry or arena\n");
    return 1;
  }
  for (uint32_t i = 0; i < sizeof(budgets_kib) / sizeof(budgets_kib[0]); i++) {
    if (budgets_kib[i] * 1024 > PAT - SPM) {
      printf("[FAIL] budget %d KiB does not fit below the pattern\n", (int)budgets_kib[i]);
      return 1;
    }
  }

  // Pattern in the SPM, then the read-only arrays (the others are filled before each run)
  for (uint32_t j = 0; j < PAT_WORDS; j++)
    mmio32(PAT + j * 4) = j;
  dcache_flush();
  fill(BIG_ADDR, SUM_WORDS, O_BIG);
  fill(MAT_ADDR, ROWS * COLS, O_MAT);
  fill(VEC_ADDR, COLS, O_VEC);
  fill(REUSE_ADDR, REUSE_WORDS, O_REUSE);

  if (RUN_DIRECT)
    run_direct();
  for (uint32_t i = 0; i < sizeof(budgets_kib) / sizeof(budgets_kib[0]); i++) {
    uint32_t budget = budgets_kib[i] * 1024;
    if (RUN_IDMA)
      run_idma(budget);
    if (CACHE_PF & 1)
      run_cache(budget, 0);
    if (CACHE_PF & 2)
      run_cache(budget, 1);
  }

  printf("dcache_vs_idma_test: %d errors\n", (int)errors);
  return errors;
}
