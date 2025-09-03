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
 * MAGIA Extended FractalSync Synchronization Test
 */

#include "magia_tile_utils.h"
#include "magia_utils.h"
#include "fsync_isa_utils.h"
#include "fsync_api.h"
#include "cache_fill.h"

#define VERBOSE (0)

#define STALLING

int main(void) {
  uint32_t aggregates[NUM_HARTS];
  uint32_t ids[NUM_HARTS];

#ifndef STALLING
  irq_en(1<<IRQ_FSYNC_DONE);
#endif

#if NUM_HARTS == 16
  /// Custom 4x4 synch.
  switch (get_hartid()){
    case 0:  aggregates[get_hartid()] = 0b1111; ids[get_hartid()] = 7; break;
    case 1:  aggregates[get_hartid()] = 0b1111; ids[get_hartid()] = 7; break;
    case 2:  aggregates[get_hartid()] = 0b1111; ids[get_hartid()] = 7; break;
    case 3:  aggregates[get_hartid()] = 0b1111; ids[get_hartid()] = 7; break;
    case 4:  aggregates[get_hartid()] = 0b1111; ids[get_hartid()] = 7; break;
    case 5:  aggregates[get_hartid()] = 0b1111; ids[get_hartid()] = 7; break;
    case 6:  aggregates[get_hartid()] = 0b1111; ids[get_hartid()] = 7; break;
    case 7:  aggregates[get_hartid()] = 0b1111; ids[get_hartid()] = 7; break;
    case 8:  aggregates[get_hartid()] = 0b1111; ids[get_hartid()] = 7; break;
    case 9:  aggregates[get_hartid()] = 0b1111; ids[get_hartid()] = 7; break;
    case 10: aggregates[get_hartid()] = 0b1111; ids[get_hartid()] = 7; break;
    case 11: aggregates[get_hartid()] = 0b1111; ids[get_hartid()] = 7; break;
    case 12: aggregates[get_hartid()] = 0b1111; ids[get_hartid()] = 7; break;
    case 13: aggregates[get_hartid()] = 0b1111; ids[get_hartid()] = 7; break;
    case 14: aggregates[get_hartid()] = 0b1111; ids[get_hartid()] = 7; break;
    case 15: aggregates[get_hartid()] = 0b1111; ids[get_hartid()] = 7; break;
  }

  // h_pprintf("FractalSync aggregate: 0b"); pprintf(bs(aggregates[get_hartid()])); pprintf(", id: "); pprintf(ds(ids[get_hartid()])); n_pprintf("...");
  printf("FractalSync aggregate: 0x%0x, id: %0d...\n", aggregates[get_hartid()], ids[get_hartid()]);

  fsync(ids[get_hartid()], aggregates[get_hartid()]);

#ifndef STALLING
  asm volatile("wfi" ::: "memory");
  // h_pprintf("Detected IRQ...\n");
  printf("Detected IRQ...\n");
#endif

  sentinel_instr_id();
#endif

  printf("[FractalSync] Horizontal neighbor test starting\n");
  fsync_hnbr();

#ifndef STALLING
  asm volatile("wfi" ::: "memory");
  // h_pprintf("Detected IRQ...\n");
  printf("Detected IRQ...\n");
#endif

  sentinel_instr_id();
  printf("[FractalSync] Horizontal neighbor test ending\n");

  printf("[FractalSync] Horizontal ring neighbor test starting\n");
  fsync_hring();

#ifndef STALLING
  asm volatile("wfi" ::: "memory");
  // h_pprintf("Detected IRQ...\n");
  printf("Detected IRQ...\n");
#endif

  sentinel_instr_id();
  printf("[FractalSync] Horizontal ring neighbor test ending\n");

  printf("[FractalSync] Vertical neighbor test starting\n");
  fsync_vnbr();

#ifndef STALLING
  asm volatile("wfi" ::: "memory");
  // h_pprintf("Detected IRQ...\n");
  printf("Detected IRQ...\n");
#endif

  sentinel_instr_id();
  printf("[FractalSync] Vertical neighbor test ending\n");

  printf("[FractalSync] Vertical ring neighbor test starting\n");
  fsync_vring();

#ifndef STALLING
  asm volatile("wfi" ::: "memory");
  // h_pprintf("Detected IRQ...\n");
  printf("Detected IRQ...\n");
#endif

  sentinel_instr_id();
  printf("[FractalSync] Vertical ring neighbor test ending\n");

  printf("[FractalSync] Row test starting\n");
  fsync_rows();

#ifndef STALLING
  asm volatile("wfi" ::: "memory");
  // h_pprintf("Detected IRQ...\n");
  printf("Detected IRQ...\n");
#endif

  sentinel_instr_id();
  printf("[FractalSync] Row test ending\n");

  printf("[FractalSync] Column test starting\n");
  fsync_cols();

#ifndef STALLING
  asm volatile("wfi" ::: "memory");
  // h_pprintf("Detected IRQ...\n");
  printf("Detected IRQ...\n");
#endif

  sentinel_instr_id();
  printf("[FractalSync] Column test ending\n");

  printf("[FractalSync] Global test starting\n");
  fsync_global();

#ifndef STALLING
  asm volatile("wfi" ::: "memory");
  // h_pprintf("Detected IRQ...\n");
  printf("Detected IRQ...\n");
#endif

  sentinel_instr_id();
  printf("[FractalSync] Global test ending\n");

  // h_pprintf("FractalSync test finished...\n");
  printf("FractalSync test finished...\n");

  return 0;
}