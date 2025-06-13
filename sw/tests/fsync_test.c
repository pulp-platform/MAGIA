/*
 * Copyright (C) 2023-2024 ETH Zurich and University of Bologna
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
 * Authors: Victor Isachi <victor.isachi@unibo.it>
 * 
 * MAGIA FractalSync Synchronization Test
 */

#include "magia_tile_utils.h"
#include "magia_utils.h"
#include "fsync_isa_utils.h"
#include "cache_fill.h"

#define VERBOSE (0)

#define NUM_LEVELS (6)
#define STALLING

#define CACHE_HEAT_CYCLES (3)

/// Only measure via 1 method (cycles xor time) otherwise the 2 methods interfere with each other
/// Note SW performance measures add overhead
// #define PERF_MEASURE
// #define P_CYCLES
// #define P_TIME

int main(void) {
  uint32_t levels[NUM_HARTS];

#ifdef PERF_MEASURE
#ifdef P_CYCLES
  uint32_t start_cycle[NUM_HARTS];
  uint32_t end_cycle[NUM_HARTS];
  ccount_en();
#endif
#ifdef P_TIME
  uint32_t start_time[NUM_HARTS];
  uint32_t end_time[NUM_HARTS];
#endif
#endif

  for (int i = NUM_LEVELS-1; i < NUM_LEVELS; i++){
    // h_pprintf("Fractal Sync at level "); pprintf(ds(i+1)); n_pprintf("...");
    printf("Fractal Sync at level %0d...\n", i+1);

#ifndef STALLING
    irq_en(1<<IRQ_FSYNC_DONE);
#endif
    
    levels[get_hartid()] = 1 << i; 
#if VERBOSE > 10
    // h_pprintf("levels: 0x"); n_pprintf(hs(levels[get_hartid()]));
    printf("levels: 0x%0x\n", levels[get_hartid()]);
#endif

#ifdef PERF_MEASURE
#ifdef P_CYCLES
    start_cycle[get_hartid()] = get_cycle();
#endif
#ifdef P_TIME
    start_time[get_hartid()]  = get_time();
#endif
#endif

    // Filling up the cache
    fill_icache();

    // Execute synchronization multiple times to pre-heat the cache
    for (int i = 0; i < CACHE_HEAT_CYCLES; i++) {
      fsync(levels[get_hartid()]);
#ifndef STALLING
      asm volatile("wfi" ::: "memory");
      // h_pprintf("Detected IRQ...\n");
      printf("Detected IRQ...\n");
#endif
      sentinel_instr_id();   // Indicate occurred synchronization
    }

#ifdef PERF_MEASURE
#ifdef P_CYCLES
    end_cycle[get_hartid()] = get_cycle();
#endif
#ifdef P_TIME
    end_time[get_hartid()]  = get_time();
#endif
#endif

    // h_pprintf("Synchronized...\n");
    printf("Synchronized...\n");

#ifdef PERF_MEASURE
#ifdef P_CYCLES
    if (start_cycle[get_hartid()] && end_cycle[get_hartid()]){
      // h_pprintf("PERFORMANCE COUNTER: "); pprintf(ds(end_cycle[get_hartid()] - start_cycle[get_hartid()])); pprintf("cycles (");
      // pprintf(ds(start_cycle[get_hartid()])); pprintf(" - "); pprintf(ds(end_cycle[get_hartid()])); n_pprintf(")cycle");
      printf("PERFORMANCE COUNTER: %0dcycles (%0d - %0d)cycles\n", end_cycle[get_hartid()] - start_cycle[get_hartid()], start_cycle[get_hartid()], end_cycle[get_hartid()]);
    }
    else
      // h_pprintf("PERFORMANCE COUNTER: ERROR cycle counter overlow...\n");
      printf("PERFORMANCE COUNTER: ERROR cycle counter overlow...\n");
#endif
#ifdef P_TIME
    if (start_time[get_hartid()] && end_time[get_hartid()]){
      // h_pprintf("PERFORMANCE COUNTER: "); pprintf(ds(end_time[get_hartid()] - start_time[get_hartid()])); pprintf("ns (");
      // pprintf(ds(start_time[get_hartid()])); pprintf(" - "); pprintf(ds(end_time[get_hartid()])); n_pprintf(")ns");
      printf("PERFORMANCE COUNTER: %0dns (%0d - %0d)ns\n", end_time[get_hartid()] - start_time[get_hartid()], start_time[get_hartid()], end_time[get_hartid()]);
    }
    else
      // h_pprintf("PERFORMANCE COUNTER: ERROR time counter overlow...\n");
      printf("PERFORMANCE COUNTER: ERROR time counter overlow...\n");
#endif
#endif
  }

#ifdef PERF_MEASURE
#ifdef P_CYCLES
  ccount_dis();
#endif
#endif

  // h_pprintf("Fractal Sync test finished...\n");
  printf("Fractal Sync test finished...\n");

  mmio16(TEST_END_ADDR + get_hartid()*2) = DEFAULT_EXIT_CODE - get_hartid();

  return 0;
}
