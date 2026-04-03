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
 * Authors: Luca Balboni <luca.balboni10@studio.unibo.it>
 *
 * Atomic Remote Task for Spatz
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "magia_spatz_utils.h"
#include "spatz_workers.h"

#define DATA_ADDR (SPATZ_DATA)
#define NUM_ITER       2
#define NUM_TARGETS    3  // Self + 2 remote tiles

typedef struct {
    uint32_t hartid;
    uint32_t counter_addr;
    uint32_t sync_base;
} atomic_params_t;

int atomic_remote_task(void) {
  // Read parameter structure pointer from DATA register
  uint32_t params_ptr = mmio32(DATA_ADDR);
  volatile atomic_params_t *params = (volatile atomic_params_t *)params_ptr;
  
  uint32_t hartid = params->hartid;
  uint32_t my_addr = params->counter_addr;
  uint32_t sync_base = params->sync_base;
  
  // Each hart increments: self, (self+1)%16, (self+2)%16
  for (int iter = 0; iter < NUM_ITER; iter++) {
    for (int i = 0; i < NUM_TARGETS; i++) {
      uint32_t target = (hartid + i) % 16;
      uint32_t addr = sync_base + target * L1_TILE_OFFSET;
      
      asm volatile(
        "addi t0, %0, 0     \n"
        "li   t1, 1         \n"
        "amoadd.w t2, t1, (t0) \n"
        :
        : "r"(addr)
        : "t0", "t1", "t2", "memory"
      );
    }
  }
  
  while (mmio32(my_addr) != (NUM_ITER * NUM_TARGETS));
  
  return 0;
}
