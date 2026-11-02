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
 * Data cache test: the control core reads and writes global arrays in .data/.bss (L2 dataram, cacheable).
 * Phases: cold and warm reads, write and read back, byte/halfword accesses, an array twice the cache
 * (dirty evictions and refills), flush and read back from L2. Cycles from mcycle. Runs with and without
 * the cache (make dcache=0|1): the results must be the same, only the cycles change.
 */

// GCC 14 crashes ("could not split insn", doloop_begin_i) on the cv32e40p hardware loop of the big loops
#pragma GCC optimize("no-branch-count-reg")

#include "magia_tile_utils.h"
#include "magia_dcache_utils.h"

#define SMALL_WORDS (1024)       /* 4 KiB: fits in the cache */
#define BIG_WORDS   (16 * 1024)  /* 64 KiB: twice the cache */

volatile uint32_t small_array[SMALL_WORDS] = {[0 ... SMALL_WORDS-1] = 7};
volatile uint32_t big_array[BIG_WORDS];
volatile uint8_t  byte_array[256];
volatile uint16_t half_array[256];

static inline uint32_t read_mcycle(void) {
  uint32_t cycles;
  asm volatile("csrr %0, mcycle" : "=r"(cycles));
  return cycles;
}

static uint32_t check(const char *what, uint32_t got, uint32_t expected) {
  if (got != expected) {
    printf("[FAIL] %s: got 0x%x, expected 0x%x\n", what, (unsigned)got, (unsigned)expected);
    return 1;
  }
  return 0;
}

int main(void) {
  uint32_t errors = 0;
  uint32_t sum, start, cycles;
  dcache_perf_t perf;

  // mcycle is inhibited at reset
  asm volatile("csrw mcountinhibit, zero");
  dcache_perf_start();

  // 1. Cold and warm reads
  for (int pass = 0; pass < 2; pass++) {
    start = read_mcycle();
    sum   = 0;
    for (int i = 0; i < SMALL_WORDS; i++)
      sum += small_array[i];
    cycles = read_mcycle() - start;
    printf("read %s: %d cycles\n", pass ? "warm" : "cold", cycles);
    errors += check("small_array sum", sum, 7 * SMALL_WORDS);
  }

  // 2. Write and read back
  start = read_mcycle();
  for (int i = 0; i < SMALL_WORDS; i++)
    small_array[i] = 3 * i;
  sum = 0;
  for (int i = 0; i < SMALL_WORDS; i++)
    sum += small_array[i];
  cycles = read_mcycle() - start;
  printf("write + read: %d cycles\n", cycles);
  errors += check("small_array written sum", sum, 3 * (SMALL_WORDS * (SMALL_WORDS - 1) / 2));

  // 3. Byte and halfword lanes
  for (int i = 0; i < 256; i++) {
    byte_array[i] = (uint8_t)(i ^ 0x5A);
    half_array[i] = (uint16_t)(i * 257);
  }
  for (int i = 0; i < 256; i++) {
    errors += check("byte_array", byte_array[i], (uint8_t)(i ^ 0x5A));
    errors += check("half_array", half_array[i], (uint16_t)(i * 257));
  }

  // 4. Twice the cache: write misses, dirty evictions, refills of written lines
  start = read_mcycle();
  for (int i = 0; i < BIG_WORDS; i++)
    big_array[i] = i + 1;
  sum = 0;
  for (int i = 0; i < BIG_WORDS; i++)
    sum += big_array[i];
  cycles = read_mcycle() - start;
  printf("big write + read: %d cycles\n", cycles);
  errors += check("big_array sum", sum, BIG_WORDS * (BIG_WORDS + 1) / 2);

  // 5. Flush: the data must come back from L2
  dcache_flush();
  sum = 0;
  for (int i = 0; i < SMALL_WORDS; i++)
    sum += small_array[i];
  errors += check("small_array after flush", sum, 3 * (SMALL_WORDS * (SMALL_WORDS - 1) / 2));
  errors += check("byte_array[17] after flush", byte_array[17], (uint8_t)(17 ^ 0x5A));
  errors += check("half_array[200] after flush", half_array[200], (uint16_t)(200 * 257));

  dcache_perf_stop();
  dcache_perf_read(&perf);
  dcache_perf_print(&perf);

  printf("dcache_sum_test: %d errors\n", errors);
  return errors;
}
