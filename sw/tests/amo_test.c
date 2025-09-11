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
 * MAGIA AMO Test
 */

#include "magia_tile_utils.h"
#include "magia_utils.h"

#define VERBOSE (0)

#define NUM_ITER     (1000)
#define INITIAL_VAL  (0)
#define AMO_TILES    (NUM_HARTS)
#define EXPECTED_VAL (INITIAL_VAL + NUM_ITER*AMO_TILES)

int main(void) {
  uint32_t hartid = get_hartid();

  printf("Starting AMO test...\n");

  for (int i = 0; i < NUM_ITER; i++){
    wait_nop(get_hartid());
    for (int i = 0; i < AMO_TILES; i++){
      asm volatile("addi t0, %0, 0" ::"r"((uint32_t)(SYNC_BASE + ((hartid+i)%NUM_HARTS)*L1_TILE_OFFSET)));
      asm volatile("li t1, 1" ::);
      asm volatile("amoadd.w t2, t1, (t0)" ::);
    }
  }

  printf("Waiting for counter to reach expected value...\n");
  while (mmio32(SYNC_BASE + hartid*L1_TILE_OFFSET) != EXPECTED_VAL){
#if VERBOSE > 10
  printf("Read Synch Value: %0d - Expected: %0d\n", mmio32(SYNC_BASE + hartid*L1_TILE_OFFSET), EXPECTED_VAL);
#endif
  }

  printf("Test PASSED: counter reached\n");

  return 0;
}

