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
 * RaiderSTREAM (github.com/michael-beebe/RaiderSTREAM) on the control core: the STREAM kernels (copy, scale,
 * add, triad) in the sequential, gather, scatter and scatter-gather variants, on uint32 instead of double (no
 * FPU) with the STREAM scalar 3. The index arrays are random permutations (Fisher-Yates, as RaiderSTREAM).
 * Three ways to run each group of four kernels, as dcache_vs_idma_test:
 *   direct : data in L2, cache off (the no-cache baseline)
 *   idma   : the sequential streams staged in the L1 SPM by the iDMA, double buffered; gather and scatter keep
 *            their irregular array in L2 (cache off): the iDMA cannot gather, this is the best it can do
 *   cache  : data in L2 through the cache, same L1 budget as the iDMA buffers (WAY_EN), prefetch on and off
 * The scatter-gather group has no iDMA version: every access is irregular.
 * Checks: a permutation preserves the sum of an array, so after each group sum(a) = 15 S, sum(b) = 3 S,
 * sum(c) = 4 S with S the sum of the initial a; the sequential group is also checked element by element.
 * Needs the cache (make dcache=1). Sizes and variants are defines, overridable with EXTRA_CFLAGS.
 */

#include "magia_tile_utils.h"
#include "magia_dcache_utils.h"
#include "idma_mm_utils.h"

// GCC 14 crashes ("could not split insn", doloop_begin_i) on the cv32e40p hardware loop of the big loops
#pragma GCC optimize("no-branch-count-reg")
// Aligned, not inlined: every variant runs the same aligned loop
#pragma GCC optimize("align-loops=4")
#define KERNEL __attribute__((noinline, aligned(4)))

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
#define CACHE_PF     (3)                      /* bit 0: cache with prefetch off, bit 1: with prefetch on */
#endif

#define G_SEQ        (1 << 0)
#define G_GATHER     (1 << 1)
#define G_SCATTER    (1 << 2)
#define G_SG         (1 << 3)
#ifndef GROUPS
#define GROUPS       (G_SEQ | G_GATHER | G_SCATTER | G_SG)
#endif

#define N            (STREAM_WORDS)
#define SCALAR       (3u)
#define DMA_CHUNK    (32 * 1024)              /* one iDMA transfer: the length is 16 bits */

/////////////////////
// Memory and data //
/////////////////////

/* L2 arena above .data/.bss (inside the cacheable region at reset). STREAM_OFFSET is the OFFSET of STREAM:
 * without it the arrays are a multiple of the way size apart and a[j], b[j], c[j] fight for the same set. */
#ifndef STREAM_OFFSET
#define STREAM_OFFSET (128)
#endif
#define ARENA        (0xCC100000)
#define ALIGN_UP(a)  (((a) + 0xFFF) & ~0xFFF)
#define ARR_BYTES    (N * 4 + STREAM_OFFSET)
#define A_ADDR       (ARENA)
#define B_ADDR       (A_ADDR + ARR_BYTES)
#define C_ADDR       (B_ADDR + ARR_BYTES)
#define IDX1_ADDR    (C_ADDR + ARR_BYTES)
#define IDX2_ADDR    (IDX1_ADDR + ARR_BYTES)
#define IDX3_ADDR    (IDX2_ADDR + ARR_BYTES)
#define ARENA_END    ALIGN_UP(IDX3_ADDR + N * 4)

#define a_arr        ((volatile uint32_t *)A_ADDR)
#define b_arr        ((volatile uint32_t *)B_ADDR)
#define c_arr        ((volatile uint32_t *)C_ADDR)
#define idx1_arr     ((volatile uint32_t *)IDX1_ADDR)
#define idx2_arr     ((volatile uint32_t *)IDX2_ADDR)
#define idx3_arr     ((volatile uint32_t *)IDX3_ADDR)

/* Pattern for the iDMA fill of a: PAT[j] = j, at the top of the SPM (below the cache store), out of the
 * budgets. Chunk c of a fill starts at PAT[8 c] and reads 8192 words: the margin covers the last chunk. */
#define PAT_WORDS    (8 * 1024 + 8 * (N / 8192))
#define PAT          (L1_BASE + L1_SPM_SIZE - PAT_WORDS * 4)
#define SPM          (L1_BASE)                /* iDMA buffers and the index scratch, from the start of the L1 */

#define O_A          (0)                      /* fill offset of a (see val) */

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

static void check2(const char *variant, const char *what, uint32_t got, uint32_t expected) {
  if (got != expected) {
    printf("[FAIL] %s %s: got 0x%x, expected 0x%x\n", variant, what, (unsigned)got, (unsigned)expected);
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
// RaiderSTREAM RS_OMP_IMPL.c, one loop each; src and dst can be L2 arrays or L1 tiles.

KERNEL static void seq_copy(volatile uint32_t *av, volatile uint32_t *cv, int n) {
  for (int j = 0; j < n; j++)
    cv[j] = av[j];
}

KERNEL static void seq_scale(volatile uint32_t *cv, volatile uint32_t *bv, int n) {
  for (int j = 0; j < n; j++)
    bv[j] = SCALAR * cv[j];
}

KERNEL static void seq_add(volatile uint32_t *av, volatile uint32_t *bv, volatile uint32_t *cv, int n) {
  for (int j = 0; j < n; j++)
    cv[j] = av[j] + bv[j];
}

KERNEL static void seq_triad(volatile uint32_t *bv, volatile uint32_t *cv, volatile uint32_t *av, int n) {
  for (int j = 0; j < n; j++)
    av[j] = bv[j] + SCALAR * cv[j];
}

KERNEL static void gather_copy(volatile uint32_t *av, volatile uint32_t *i1, volatile uint32_t *cv, int n) {
  for (int j = 0; j < n; j++)
    cv[j] = av[i1[j]];
}

KERNEL static void gather_scale(volatile uint32_t *cv, volatile uint32_t *i1, volatile uint32_t *bv, int n) {
  for (int j = 0; j < n; j++)
    bv[j] = SCALAR * cv[i1[j]];
}

KERNEL static void gather_add(volatile uint32_t *av, volatile uint32_t *bv, volatile uint32_t *i1,
                              volatile uint32_t *i2, volatile uint32_t *cv, int n) {
  for (int j = 0; j < n; j++)
    cv[j] = av[i1[j]] + bv[i2[j]];
}

KERNEL static void gather_triad(volatile uint32_t *bv, volatile uint32_t *cv, volatile uint32_t *i1,
                                volatile uint32_t *i2, volatile uint32_t *av, int n) {
  for (int j = 0; j < n; j++)
    av[j] = bv[i1[j]] + SCALAR * cv[i2[j]];
}

KERNEL static void scatter_copy(volatile uint32_t *av, volatile uint32_t *i1, volatile uint32_t *cv, int n) {
  for (int j = 0; j < n; j++)
    cv[i1[j]] = av[j];
}

KERNEL static void scatter_scale(volatile uint32_t *cv, volatile uint32_t *i1, volatile uint32_t *bv, int n) {
  for (int j = 0; j < n; j++)
    bv[i1[j]] = SCALAR * cv[j];
}

KERNEL static void scatter_add(volatile uint32_t *av, volatile uint32_t *bv, volatile uint32_t *i1,
                               volatile uint32_t *cv, int n) {
  for (int j = 0; j < n; j++)
    cv[i1[j]] = av[j] + bv[j];
}

KERNEL static void scatter_triad(volatile uint32_t *bv, volatile uint32_t *cv, volatile uint32_t *i1,
                                 volatile uint32_t *av, int n) {
  for (int j = 0; j < n; j++)
    av[i1[j]] = bv[j] + SCALAR * cv[j];
}

KERNEL static void sg_copy(volatile uint32_t *av, volatile uint32_t *i1, volatile uint32_t *i2,
                           volatile uint32_t *cv, int n) {
  for (int j = 0; j < n; j++)
    cv[i1[j]] = av[i2[j]];
}

KERNEL static void sg_scale(volatile uint32_t *cv, volatile uint32_t *i1, volatile uint32_t *i2,
                            volatile uint32_t *bv, int n) {
  for (int j = 0; j < n; j++)
    bv[i2[j]] = SCALAR * cv[i1[j]];
}

KERNEL static void sg_add(volatile uint32_t *av, volatile uint32_t *bv, volatile uint32_t *i1,
                          volatile uint32_t *i2, volatile uint32_t *i3, volatile uint32_t *cv, int n) {
  for (int j = 0; j < n; j++)
    cv[i1[j]] = av[i2[j]] + bv[i3[j]];
}

KERNEL static void sg_triad(volatile uint32_t *bv, volatile uint32_t *cv, volatile uint32_t *i1,
                            volatile uint32_t *i2, volatile uint32_t *i3, volatile uint32_t *av, int n) {
  for (int j = 0; j < n; j++)
    av[i1[j]] = bv[i2[j]] + SCALAR * cv[i3[j]];
}

KERNEL static uint32_t sum_arr(volatile uint32_t *p, int n) {
  uint32_t s = 0;
  for (int j = 0; j < n; j++)
    s += p[j];
  return s;
}

//////////////////////////////////////////
// Kernel table: one row per kernel run //
//////////////////////////////////////////
// in0/in1 are the sequential operands, out the sequential result (0 = none, the kernel scatters to L2),
// irr0/irr1 the arrays indexed by idx (they stay in L2 in the idma variant), ni the index arrays used.

enum { OP_COPY, OP_SCALE, OP_ADD, OP_TRIAD };

typedef struct {
  const char *name;
  uint32_t    in0, in1;   /* sequential inputs (L2 address, 0 = none) */
  uint32_t    out;        /* sequential output (0 = the kernel writes through idx) */
  uint32_t    irr0, irr1; /* irregular arrays (always L2, 0 = none) */
  uint32_t    ni;         /* index arrays used (staged in the idma variant) */
} krow_t;

static const krow_t seq_rows[4] = {
  {"seq_copy",   A_ADDR, 0,      C_ADDR, 0,      0,      0},
  {"seq_scale",  C_ADDR, 0,      B_ADDR, 0,      0,      0},
  {"seq_add",    A_ADDR, B_ADDR, C_ADDR, 0,      0,      0},
  {"seq_triad",  B_ADDR, C_ADDR, A_ADDR, 0,      0,      0},
};

static const krow_t gather_rows[4] = {
  {"gather_copy",  0, 0, C_ADDR, A_ADDR, 0,      1},
  {"gather_scale", 0, 0, B_ADDR, C_ADDR, 0,      1},
  {"gather_add",   0, 0, C_ADDR, A_ADDR, B_ADDR, 2},
  {"gather_triad", 0, 0, A_ADDR, B_ADDR, C_ADDR, 2},
};

static const krow_t scatter_rows[4] = {
  {"scatter_copy",  A_ADDR, 0,      0, C_ADDR, 0, 1},
  {"scatter_scale", C_ADDR, 0,      0, B_ADDR, 0, 1},
  {"scatter_add",   A_ADDR, B_ADDR, 0, C_ADDR, 0, 1},
  {"scatter_triad", B_ADDR, C_ADDR, 0, A_ADDR, 0, 1},
};

static const krow_t sg_rows[4] = {
  {"sg_copy",  0, 0, 0, A_ADDR, C_ADDR, 2},
  {"sg_scale", 0, 0, 0, C_ADDR, B_ADDR, 2},
  {"sg_add",   0, 0, 0, A_ADDR, B_ADDR, 3},   /* and C_ADDR through idx1 */
  {"sg_triad", 0, 0, 0, B_ADDR, C_ADDR, 3},   /* and A_ADDR through idx1 */
};

/* The kernel of group g (G_*) and op on the full L2 arrays */
static void run_l2(uint32_t g, int op) {
  if (g == G_SEQ) {
    if (op == OP_COPY)  seq_copy(a_arr, c_arr, N);
    if (op == OP_SCALE) seq_scale(c_arr, b_arr, N);
    if (op == OP_ADD)   seq_add(a_arr, b_arr, c_arr, N);
    if (op == OP_TRIAD) seq_triad(b_arr, c_arr, a_arr, N);
  } else if (g == G_GATHER) {
    if (op == OP_COPY)  gather_copy(a_arr, idx1_arr, c_arr, N);
    if (op == OP_SCALE) gather_scale(c_arr, idx1_arr, b_arr, N);
    if (op == OP_ADD)   gather_add(a_arr, b_arr, idx1_arr, idx2_arr, c_arr, N);
    if (op == OP_TRIAD) gather_triad(b_arr, c_arr, idx1_arr, idx2_arr, a_arr, N);
  } else if (g == G_SCATTER) {
    if (op == OP_COPY)  scatter_copy(a_arr, idx1_arr, c_arr, N);
    if (op == OP_SCALE) scatter_scale(c_arr, idx1_arr, b_arr, N);
    if (op == OP_ADD)   scatter_add(a_arr, b_arr, idx1_arr, c_arr, N);
    if (op == OP_TRIAD) scatter_triad(b_arr, c_arr, idx1_arr, a_arr, N);
  } else {
    if (op == OP_COPY)  sg_copy(a_arr, idx1_arr, idx2_arr, c_arr, N);
    if (op == OP_SCALE) sg_scale(c_arr, idx1_arr, idx2_arr, b_arr, N);
    if (op == OP_ADD)   sg_add(a_arr, b_arr, idx1_arr, idx2_arr, idx3_arr, c_arr, N);
    if (op == OP_TRIAD) sg_triad(b_arr, c_arr, idx1_arr, idx2_arr, idx3_arr, a_arr, N);
  }
}

////////////////////////////////////
// iDMA versions, double buffered //
////////////////////////////////////

/* One kernel of the row, tiled: the sequential streams (in0, in1, idx used, out) live in L1 tiles,
 * the irregular arrays stay in L2. Buffers: ns streams x 2 tiles within the budget. */
static void run_idma_row(uint32_t g, int op, const krow_t *r, uint32_t budget) {
  uint32_t ins[4];
  uint32_t nin = 0;
  if (r->in0) { ins[nin] = r->in0; nin++; }
  if (r->in1) { ins[nin] = r->in1; nin++; }
  if (r->ni >= 1) { ins[nin] = IDX1_ADDR; nin++; }
  if (r->ni >= 2) { ins[nin] = IDX2_ADDR; nin++; }
  if (r->ni >= 3) { ins[nin] = IDX3_ADDR; nin++; }
  uint32_t ns = nin + (r->out ? 1 : 0);

  /* The largest power-of-two tile so that ns streams x 2 tiles fit in the budget */
  uint32_t tile_words = 1;
  while (2 * tile_words * ns * 2 * 4 <= budget && 2 * tile_words <= N)
    tile_words *= 2;
  uint32_t tile_bytes = tile_words * 4;
  int      tiles      = N / tile_words;
  uint32_t buf[4 + 1][2];
  for (uint32_t s = 0; s < ns; s++) {
    buf[s][0] = SPM + (2 * s) * tile_bytes;
    buf[s][1] = SPM + (2 * s + 1) * tile_bytes;
  }
  uint32_t in_id[2] = {0, 0}, out_id[2] = {0, 0};

  for (uint32_t s = 0; s < nin; s++)
    in_id[0] = dma_in(ins[s], buf[s][0], tile_bytes);
  for (int t = 0; t < tiles; t++) {
    int b = t & 1, nx = b ^ 1;
    if (t + 1 < tiles) {
      if (r->out && t >= 1)
        wait_out(out_id[nx]);
      for (uint32_t s = 0; s < nin; s++)
        in_id[nx] = dma_in(ins[s] + (t + 1) * tile_bytes, buf[s][nx], tile_bytes);
    }
    wait_in(in_id[b]);

    /* The staged tiles in kernel-argument order; the irregular arrays as full L2 arrays */
    volatile uint32_t *s0 = (volatile uint32_t *)buf[0][b];
    volatile uint32_t *s1 = (volatile uint32_t *)buf[1][b];
    volatile uint32_t *s2 = (volatile uint32_t *)buf[2][b];
    volatile uint32_t *ob = (volatile uint32_t *)buf[ns - 1][b];
    int n = tile_words;
    if (g == G_SEQ) {
      if (op == OP_COPY)  seq_copy(s0, ob, n);
      if (op == OP_SCALE) seq_scale(s0, ob, n);
      if (op == OP_ADD)   seq_add(s0, s1, ob, n);
      if (op == OP_TRIAD) seq_triad(s0, s1, ob, n);
    } else if (g == G_GATHER) {
      /* idx tiles staged, the gathered array in L2, the result tile in L1 */
      if (op == OP_COPY)  gather_copy((volatile uint32_t *)r->irr0, s0, ob, n);
      if (op == OP_SCALE) gather_scale((volatile uint32_t *)r->irr0, s0, ob, n);
      if (op == OP_ADD)   gather_add((volatile uint32_t *)r->irr0, (volatile uint32_t *)r->irr1, s0, s1, ob, n);
      if (op == OP_TRIAD) gather_triad((volatile uint32_t *)r->irr0, (volatile uint32_t *)r->irr1, s0, s1, ob, n);
    } else {
      /* sequential operands and idx staged, the scattered array in L2 */
      if (op == OP_COPY)  scatter_copy(s0, s1, (volatile uint32_t *)r->irr0, n);
      if (op == OP_SCALE) scatter_scale(s0, s1, (volatile uint32_t *)r->irr0, n);
      if (op == OP_ADD)   scatter_add(s0, s1, s2, (volatile uint32_t *)r->irr0, n);
      if (op == OP_TRIAD) scatter_triad(s0, s1, s2, (volatile uint32_t *)r->irr0, n);
    }
    if (r->out)
      out_id[b] = dma_out(buf[ns - 1][b], r->out + t * tile_bytes, tile_bytes);
  }
  if (r->out)
    wait_out(out_id[(tiles - 1) & 1]);
}

//////////
// Runs //
//////////

static const krow_t *group_rows(uint32_t g) {
  if (g == G_SEQ)     return seq_rows;
  if (g == G_GATHER)  return gather_rows;
  if (g == G_SCATTER) return scatter_rows;
  return sg_rows;
}

static const char *group_name(uint32_t g) {
  if (g == G_SEQ)     return "seq";
  if (g == G_GATHER)  return "gather";
  if (g == G_SCATTER) return "scatter";
  return "sg";
}

static void print_res(const char *variant, uint32_t budget, const char *kernel, uint32_t cycles,
                      const dcache_perf_t *perf) {
  printf("RES variant=%s budget=%d kernel=%s cycles=%d hit_r=%d miss_r=%d hit_w=%d miss_w=%d refill=%d wb=%d\n",
         variant, (int)(budget / 1024), kernel, (int)cycles, (int)perf->hit_r, (int)perf->miss_r,
         (int)perf->hit_w, (int)perf->miss_w, (int)perf->refill, (int)perf->writeback);
}

/* Before a group: write back what the cache holds, a again from the pattern (b and c are fully overwritten) */
static void init_group(void) {
  dcache_flush();
  fill(A_ADDR, N, O_A);
}

/* After a group: the three sums; a permutation preserves them, so they hold for every group */
static void check_group(const char *what, uint32_t g) {
  uint32_t s = golden_sum(N, O_A);
  dcache_flush();
  check2(what, "sum(a)", sum_arr(a_arr, N), 15 * s);
  check2(what, "sum(b)", sum_arr(b_arr, N), 3 * s);
  check2(what, "sum(c)", sum_arr(c_arr, N), 4 * s);
  if (g == G_SEQ) {
    for (uint32_t i = 0; i < N; i += 61) {
      check("seq a[i]", a_arr[i], 15 * val(i, O_A));
      check("seq b[i]", b_arr[i], 3 * val(i, O_A));
      check("seq c[i]", c_arr[i], 4 * val(i, O_A));
    }
  }
}

/* direct: cache off during the kernels */
static void run_direct(uint32_t g) {
  dcache_perf_t none = {0};
  const krow_t *rows = group_rows(g);
  uint32_t      start, t;

  init_group();
  for (int op = 0; op < 4; op++) {
    dcache_enable(0);
    start = read_mcycle(); run_l2(g, op); t = read_mcycle() - start;
    dcache_enable(1);
    print_res("direct", 0, rows[op].name, t, &none);
  }
  check_group("direct", g);
}

/* idma: sequential streams staged in the budget; gather and scatter touch L2 with the cache off */
static void run_idma(uint32_t g, uint32_t budget) {
  dcache_perf_t none = {0};
  const krow_t *rows = group_rows(g);
  uint32_t      start, t;

  if (g == G_SG)
    return;                                   /* every access irregular: nothing to stage */
  init_group();
  for (int op = 0; op < 4; op++) {
    if (g != G_SEQ)
      dcache_enable(0);
    start = read_mcycle(); run_idma_row(g, op, &rows[op], budget); t = read_mcycle() - start;
    if (g != G_SEQ)
      dcache_enable(1);
    print_res("idma", budget, rows[op].name, t, &none);
  }
  check_group("idma", g);
}

/* cache with the budget in ways; the final flush is its own RES line (the cost of getting results to L2) */
static void run_cache(uint32_t g, uint32_t budget, uint32_t prefetch) {
  const char   *variant = prefetch ? "cache_pf1" : "cache_pf0";
  const krow_t *rows = group_rows(g);
  uint32_t      way_bytes = L1_DCACHE_SIZE / dcache_num_ways();
  uint32_t      ways = budget / way_bytes;
  uint32_t      spm_base, spm_size, start, t;
  dcache_perf_t perf;

  if (ways == 0 || ways > dcache_num_ways() || ways * way_bytes != budget) {
    printf("cache %d KiB: not a number of ways, skipped\n", (int)(budget / 1024));
    return;
  }
  dcache_set_ways(ways, &spm_base, &spm_size);
  dcache_set_prefetch(prefetch);

  init_group();
  for (int op = 0; op < 4; op++) {
    dcache_perf_start();
    start = read_mcycle(); run_l2(g, op); t = read_mcycle() - start;
    dcache_perf_stop();
    dcache_perf_read(&perf);
    print_res(variant, budget, rows[op].name, t, &perf);
  }
  dcache_perf_t none = {0};
  start = read_mcycle(); dcache_flush(); t = read_mcycle() - start;
  print_res(variant, budget, "flush", t, &none);
  check_group(variant, g);

  dcache_set_prefetch(0);
  dcache_set_ways(dcache_num_ways(), &spm_base, &spm_size);
}

/////////////////////
// Index arrays    //
/////////////////////

/* A random permutation of 0 .. N-1 (Fisher-Yates, as RaiderSTREAM initRandomIdxArray), built in the SPM
 * and written to L2 by the iDMA */
static uint32_t lcg_state = 0x2026u;

static uint32_t lcg_next(void) {
  lcg_state = lcg_state * 1664525u + 1013904223u;
  return lcg_state;
}

static void make_permutation(uint32_t l2) {
  volatile uint32_t *scratch = (volatile uint32_t *)SPM;
  for (uint32_t i = 0; i < N; i++)
    scratch[i] = i;
  for (uint32_t i = N - 1; i > 0; i--) {
    uint32_t j = lcg_next() % (i + 1);
    uint32_t tmp = scratch[i];
    scratch[i] = scratch[j];
    scratch[j] = tmp;
  }
  wait_out(dma_out(SPM, l2, N * 4));
}

int main(void) {
  asm volatile("csrw mcountinhibit, zero");

  printf("raiderstream: %d words per array, dcache %d ways x %d sets (%d KiB), geometry %s\n",
         N, (int)dcache_num_ways(), MAGIA_DCACHE_SETS, L1_DCACHE_SIZE / 1024,
         dcache_geometry_ok() ? "ok" : "MISMATCH");
  if (!dcache_geometry_ok() || (uint32_t)&_bss_end > ARENA || ARENA_END > 0xCCF00000 ||
      N % 32 != 0 || STREAM_OFFSET % 128 != 0) {
    printf("[FAIL] geometry, arena or alignment\n");
    return 1;
  }

  // Pattern in the SPM, the index permutations, then every group on every variant
  for (uint32_t j = 0; j < PAT_WORDS; j++)
    mmio32(PAT + j * 4) = j;
  make_permutation(IDX1_ADDR);
  make_permutation(IDX2_ADDR);
  make_permutation(IDX3_ADDR);
  dcache_flush();

  for (uint32_t g = G_SEQ; g <= G_SG; g <<= 1) {
    if (!(GROUPS & g))
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
