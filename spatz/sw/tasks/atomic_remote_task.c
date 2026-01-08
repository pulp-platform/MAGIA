/*
 * Copyright (C) 2024 ETH Zurich and University of Bologna
 * SPDX-License-Identifier: Apache-2.0
 *
 * Atomic Remote Task for Spatz
 * Each hart performs atomic operations on: self + 2 remote tiles
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "magia_spatz_utils.h"
#include "spatz_workers.h"

#define EXCHANGE_REG_ADDR (SPATZ_EXCHANGE_REG)
#define NUM_ITER       2
#define NUM_TARGETS    3  // Self + 2 remote tiles

typedef struct {
    uint32_t hartid;
    uint32_t counter_addr;
    uint32_t sync_base;
} atomic_params_t;

int atomic_remote_task(void) {
  // Read parameter structure pointer from EXCHANGE_REG
  uint32_t params_ptr = mmio32(EXCHANGE_REG_ADDR);
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
