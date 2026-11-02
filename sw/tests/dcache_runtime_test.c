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
 * Data cache runtime configuration: cacheable region (CACHED_START/END), CACHE_EN, and ways given back to the
 * SPM (WAY_EN). Without the cache (make dcache=0) only the data checks run.
 */

#include "magia_tile_utils.h"
#include "magia_dcache_utils.h"

// GCC 14 crashes ("could not split insn", doloop_begin_i) on the cv32e40p hardware loop of the big loops
#pragma GCC optimize("no-branch-count-reg")

#define WORDS     (1024)          /* 4 KiB */
#define BIG_WORDS (8 * 1024)      /* 32 KiB: twice what 2 ways hold */

volatile uint32_t array_a[WORDS];
volatile uint32_t array_b[WORDS];
volatile uint32_t big_array[BIG_WORDS];

static uint32_t errors = 0;

static void check(const char *what, uint32_t got, uint32_t expected) {
  if (got != expected) {
    printf("[FAIL] %s: got 0x%x, expected 0x%x\n", what, (unsigned)got, (unsigned)expected);
    errors++;
  }
}

static uint32_t sum(volatile uint32_t *array, int words) {
  uint32_t s = 0;
  for (int i = 0; i < words; i++)
    s += array[i];
  return s;
}

/* Hits and misses since the last dcache_perf_start() */
static uint32_t cache_accesses(void) {
  dcache_perf_t perf;
  dcache_perf_read(&perf);
  return perf.hit_r + perf.hit_w + perf.miss_r + perf.miss_w;
}

int main(void) {
  for (int i = 0; i < WORDS; i++) {
    array_a[i] = i;
    array_b[i] = 2 * i;
  }

  // 1. Region: array_a outside, array_b inside
#ifdef MAGIA_DCACHE
  uint32_t start = mmio32(DCACHE_CACHED_START);
  uint32_t end   = mmio32(DCACHE_CACHED_END);
  dcache_set_region((uint32_t)array_b, (uint32_t)(array_b + WORDS));
  dcache_perf_start();
  check("array_a, uncached", sum(array_a, WORDS), WORDS * (WORDS - 1) / 2);
  check("cache accesses for array_a", cache_accesses(), 0);
  dcache_perf_start();
  check("array_b, cached", sum(array_b, WORDS), WORDS * (WORDS - 1));
  check("cache accesses for array_b", cache_accesses(), WORDS);
  dcache_set_region(start, end);
#endif

  // 2. CACHE_EN = 0: nothing goes to the cache
  dcache_enable(0);
  dcache_perf_start();
  check("array_a, cache off", sum(array_a, WORDS), WORDS * (WORDS - 1) / 2);
  check("cache accesses with the cache off", cache_accesses(), 0);
  dcache_enable(1);

  // 3. Two ways back to the SPM: the cache works on the other two and never touches the freed slice
  uint32_t spm_base, spm_size;
  dcache_set_ways(2, &spm_base, &spm_size);
  volatile uint32_t *spm = (volatile uint32_t *)spm_base;
  for (uint32_t i = 0; i < spm_size / 4; i++)
    spm[i] = 0xA5000000 | i;
  for (int i = 0; i < BIG_WORDS; i++)
    big_array[i] = 3 * i;
  check("big_array with 2 ways", sum(big_array, BIG_WORDS), 3 * (BIG_WORDS * (BIG_WORDS - 1) / 2));
  for (uint32_t i = 0; i < spm_size / 4; i++) {
    if (spm[i] != (0xA5000000 | i)) {
      check("freed SPM", spm[i], 0xA5000000 | i);
      break;
    }
  }
  dcache_set_ways(4, &spm_base, &spm_size);
  check("big_array with 4 ways", sum(big_array, BIG_WORDS), 3 * (BIG_WORDS * (BIG_WORDS - 1) / 2));
  check("array_b at the end", sum(array_b, WORDS), WORDS * (WORDS - 1));

  printf("dcache_runtime_test: %d errors\n", (int)errors);
  return errors;
}
