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

#define SYNC_SETTLE (MESH_X_TILES*500)

#define NUM_ITER     (1000)
#define INITIAL_VAL  (1234)
#define AMO_TILES    (NUM_HARTS)
#define EXPECTED_VAL (INITIAL_VAL + NUM_ITER*AMO_TILES)

int main(void) {
  uint32_t current_count[NUM_HARTS];
  // h_pprintf("Starting AMO test...\n");
  printf("Starting AMO test...\n");
  mmio32(SYNC_BASE + get_hartid()*L1_TILE_OFFSET) = INITIAL_VAL;
  wait_nop(SYNC_SETTLE);
  for (int i = 0; i < NUM_ITER; i++){
    wait_nop(get_hartid());
    for (int i = 0; i < AMO_TILES; i++){
      asm volatile("addi t0, %0, 0" ::"r"((uint32_t)(SYNC_BASE + ((get_hartid()+i)%NUM_HARTS)*L1_TILE_OFFSET)));
      asm volatile("li t1, 1" ::);
      asm volatile("amoadd.w t2, t1, (t0)" ::);
    }
    current_count[get_hartid()] = mmio32(SYNC_BASE + get_hartid()*L1_TILE_OFFSET);
#if VERBOSE > 100
  // h_pprintf("current_count: "); pprintf(ds(current_count[get_hartid()])); pprintln;
  printf("current_count: %0d\n", current_count[get_hartid()]);
#endif
  }

  wait_nop(SYNC_SETTLE);

  // h_pprintf("Verifying results...\n");
  printf("Verifying results...\n");
  uint32_t exit_code[NUM_HARTS];
  if(mmio32(SYNC_BASE + get_hartid()*L1_TILE_OFFSET) != EXPECTED_VAL){
    exit_code[get_hartid()] = FAIL_EXIT_CODE;
    // h_pprintf("Test FAILED\n");
    printf("Test FAILED\n");
  }else{
    exit_code[get_hartid()] = PASS_EXIT_CODE;
    // h_pprintf("Test PASSED\n");
    printf("Test PASSED\n");
  }

#if VERBOSE > 10
  // h_pprintf("Final Synch Value: "); pprintf(ds(mmio32(SYNC_BASE + get_hartid()*L1_TILE_OFFSET))); 
  //   pprintf(" - Expected: ");       pprintf(ds(EXPECTED_VAL)); pprintln;
  printf("Final Synch Value: %0d - Expected: %0d\n", mmio32(SYNC_BASE + get_hartid()*L1_TILE_OFFSET), EXPECTED_VAL);
#endif
  
  mmio16(TEST_END_ADDR + get_hartid()*2) = exit_code[get_hartid()] - get_hartid();

  return 0;
}
