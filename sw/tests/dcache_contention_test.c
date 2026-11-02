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
 * Contention between the data cache and the iDMA on the shared AXI towards L2. The iDMA copies DMA_BYTES from L2
 * to the SPM (DMA_XFERS transfers queued at once) while the control core works on L2 data through the cache:
 *   stream : sum of STREAM_WORDS words (sequential, the prefetch guesses every line)
 *   random : RANDOM_LOOKUPS loads at pseudo-random indices of a 128 KiB table (4x the cache: most loads miss, and
 *            every prefetch is useless, the bad case of the prefetch)
 * Each kernel runs alone and with the iDMA in the background, with the prefetch off and on. The iDMA runs alone too
 * (the core only polls it). The core polls the iDMA every few loads (STREAM_CHUNK, RANDOM_CHUNK), so the iDMA time has a resolution of one
 * chunk; the polling costs the same with and without the iDMA. Every run starts with an empty cache. All the data
 * is one 128 KiB array in .data (loaded with the program, no time spent writing it; the loader takes at most
 * 192 KiB of data): the iDMA copies it twice, the stream reads its first half, the random lookups all of it.
 * Needs the cache.
 */

#include "magia_tile_utils.h"
#include "magia_dcache_utils.h"
#include "idma_mm_utils.h"

// GCC 14 crashes ("could not split insn", doloop_begin_i) on the cv32e40p hardware loop of the big loops
#pragma GCC optimize("no-branch-count-reg")
#pragma GCC optimize("align-loops=4")
#define KERNEL __attribute__((noinline, aligned(4)))

#define DMA_XFERS      (8)
#define DMA_XFER_BYTES (32 * 1024)
#define DMA_BYTES      (DMA_XFERS * DMA_XFER_BYTES)  /* 256 KiB */
#define DMA_WORDS      (DMA_BYTES / 4)
#define TABLE_WORDS    (32 * 1024)                   /* 128 KiB */
#define TABLE_BYTES    (TABLE_WORDS * 4)
#define STREAM_WORDS   (16 * 1024)                   /* 64 KiB */
#define STREAM_CHUNK   (16)                          /* loads between two polls of the iDMA */
#define RANDOM_CHUNK   (2)

#ifndef RANDOM_LOOKUPS
#define RANDOM_LOOKUPS (2048)
#endif

#define SPM_DST        (L1_BASE)

#define TABLE_VALUE    (5u)

volatile uint32_t table[TABLE_WORDS] = {[0 ... TABLE_WORDS - 1] = TABLE_VALUE};

static uint32_t errors = 0;

static inline uint32_t read_mcycle(void) {
  uint32_t cycles;
  asm volatile("csrr %0, mcycle" : "=r"(cycles));
  return cycles;
}

static void check(const char *what, uint32_t got, uint32_t expected) {
  if (got != expected) {
    printf("[FAIL] %s: got 0x%x, expected 0x%x\n", what, (unsigned)got, (unsigned)expected);
    errors++;
  }
}

/* State of the background copy, polled by the kernels */
typedef struct {
  uint32_t active;   /* a copy is running */
  uint32_t last_id;  /* id of its last transfer */
  uint32_t start;    /* mcycle before queuing it */
  uint32_t issued;   /* mcycle after queuing it */
  uint32_t done;     /* mcycle when the core saw it done, 0 before */
} bg_dma_t;

static bg_dma_t bg;

static void bg_start(void) {
  bg.active = 1;
  bg.done   = 0;
  bg.start  = read_mcycle();
  for (int t = 0; t < DMA_XFERS; t++)
    bg.last_id = idma_L2ToL1((uint32_t)table + (t * DMA_XFER_BYTES) % TABLE_BYTES, SPM_DST + t * DMA_XFER_BYTES,
                             DMA_XFER_BYTES);
  bg.issued = read_mcycle();
}

/* Called every few loads, also without a copy (same cost) */
static inline void bg_poll(void) {
  if (idma_tx_cplt(bg.last_id) && bg.active && bg.done == 0)
    bg.done = read_mcycle();
}

static void bg_finish(void) {
  while (bg.done == 0)
    bg_poll();
  bg.active = 0;
}

/////////////
// Kernels //
/////////////

KERNEL static uint32_t stream_sum(volatile uint32_t *a, int n) {
  uint32_t s = 0;
  for (int i = 0; i < n; i += STREAM_CHUNK) {
    for (int j = 0; j < STREAM_CHUNK; j++)
      s += a[i + j];
    bg_poll();
  }
  return s;
}

KERNEL static uint32_t random_sum(volatile uint32_t *t, int n) {
  uint32_t state = 0x12345678, s = 0;
  for (int k = 0; k < n; k += RANDOM_CHUNK) {
    for (int j = 0; j < RANDOM_CHUNK; j++) {
      state ^= state << 13;
      state ^= state >> 17;
      state ^= state << 5;
      s += t[state & (TABLE_WORDS - 1)];
    }
    bg_poll();
  }
  return s;
}

//////////
// Runs //
//////////

static void check_dma(const char *what) {
  for (int i = 0; i < DMA_WORDS; i += 1021)
    check(what, mmio32(SPM_DST + 4 * i), TABLE_VALUE);
  check(what, mmio32(SPM_DST + DMA_BYTES - 4), TABLE_VALUE);
}

static void clear_dst(void) {
  for (int i = 0; i < DMA_WORDS; i += 1021)
    mmio32(SPM_DST + 4 * i) = 0;
  mmio32(SPM_DST + DMA_BYTES - 4) = 0;
}

/* The iDMA alone: the core only polls */
static void run_dma_alone(void) {
  uint32_t t_dma;

  clear_dst();
  dcache_flush();
  bg_start();
  bg_finish();
  t_dma = bg.done - bg.start;
  check_dma("dma alone");
  printf("contention dma alone: dma %d, issue %d cycles\n", (int)t_dma, (int)(bg.issued - bg.start));
}

/* kernel: 0 stream, 1 random */
static void run_kernel(uint32_t kernel, uint32_t prefetch, uint32_t with_dma) {
  uint32_t      start, t_core, t_dma, t_issue, s;
  dcache_perf_t perf;

  clear_dst();
  dcache_flush();
  dcache_set_prefetch(prefetch);
  dcache_perf_start();
  start = read_mcycle();
  if (with_dma)
    bg_start();
  if (kernel == 0)
    s = stream_sum(table, STREAM_WORDS);
  else
    s = random_sum(table, RANDOM_LOOKUPS);
  t_core = read_mcycle() - start;
  dcache_perf_stop();
  dcache_perf_read(&perf);
  t_dma   = 0;
  t_issue = 0;
  if (with_dma) {
    t_issue = bg.issued - bg.start;
    if (bg.done == 0)
      printf("[WARN] the iDMA outlasted the kernel: its time is not measured under contention\n");
    bg_finish();
    t_dma = bg.done - bg.start;
    check_dma(kernel == 0 ? "dma with stream" : "dma with random");
  }
  dcache_set_prefetch(0);
  if (kernel == 0)
    check("stream sum", s, STREAM_WORDS * TABLE_VALUE);
  else
    check("random sum", s, RANDOM_LOOKUPS * TABLE_VALUE);

  // core time without the queuing of the copy
  printf("contention %s pf%d dma%d: core %d, dma %d, issue %d cycles, hit_r=%u miss_r=%u refill=%u\n",
         kernel == 0 ? "stream" : "random", (int)prefetch, (int)with_dma, (int)(t_core - t_issue), (int)t_dma,
         (int)t_issue,
         (unsigned)perf.hit_r, (unsigned)perf.miss_r, (unsigned)perf.refill);
}

int main(void) {
  asm volatile("csrw mcountinhibit, zero");

  bg.active  = 0;
  bg.last_id = 0;

  run_dma_alone();
  for (uint32_t kernel = 0; kernel < 2; kernel++)
    for (uint32_t prefetch = 0; prefetch < 2; prefetch++)
      for (uint32_t with_dma = 0; with_dma < 2; with_dma++)
        run_kernel(kernel, prefetch, with_dma);
  run_dma_alone();

  printf("dcache_contention_test: %d errors\n", (int)errors);
  return errors;
}
