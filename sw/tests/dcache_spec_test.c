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
 * Hit latency of the data cache, short enough for a waveform (a few thousand cycles): one pass over a small
 * array that misses, then two passes that hit, with the cycles of each. With the way prediction
 * (make dc_waypred=1) the hit passes should cost one cycle less per access.
 */

#include "magia_tile_utils.h"
#include "magia_dcache_utils.h"

#define WORDS (64)               /* two lines of 128 B */

volatile uint32_t spec_array[WORDS] = {[0 ... WORDS-1] = 3};

static inline uint32_t read_mcycle(void) {
  uint32_t cycles;
  asm volatile("csrr %0, mcycle" : "=r"(cycles));
  return cycles;
}

// Dependent reads: every load waits for the one before, so the cycles are the hit latency
__attribute__((noinline)) static uint32_t pass(volatile uint32_t *a, int n) {
  uint32_t s = 0;
  for (int i = 0; i < n; i++)
    s += a[i];
  return s;
}

int main(void) {
  uint32_t errors = 0;
  uint32_t start, cold, warm1, warm2, s;

  asm volatile("csrw mcountinhibit, zero");
  dcache_flush();

  start = read_mcycle(); s = pass(spec_array, WORDS); cold = read_mcycle() - start;
  if (s != 3 * WORDS) errors++;
  start = read_mcycle(); s = pass(spec_array, WORDS); warm1 = read_mcycle() - start;
  if (s != 3 * WORDS) errors++;
  start = read_mcycle(); s = pass(spec_array, WORDS); warm2 = read_mcycle() - start;
  if (s != 3 * WORDS) errors++;

  printf("cold: %d cycles, warm1: %d cycles, warm2: %d cycles (%d words)\n",
         (int)cold, (int)warm1, (int)warm2, WORDS);
  printf("dcache_spec_test: %d errors\n", (int)errors);
  return errors;
}
