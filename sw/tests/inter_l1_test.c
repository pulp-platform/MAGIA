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
 * Authors: Alessandro Nadalini <alessandro.nadalini3@unibo.it>
 * 
 * MAGIA Inter-Tile L1 Test
 */

#include "magia_utils.h"

#define MEM_OFFSET (0x1000)

#define SETTLE_CYCLE (MESH_X_TILES*500)

int main() {
  uint32_t error[NUM_HARTS];
  uint32_t total_errors = 0;

  // Initialize error array
  for(int i = 0; i < NUM_HARTS; i++) {
    error[i] = 0;
  }

  // Write the tiles ID to different L1 memory locations in other tiles
  for(int i = 0; i < NUM_HARTS; i++) {
    if(get_mhartid() != i) {
      *(volatile int*) (L1_BASE + i*L1_TILE_OFFSET + MEM_OFFSET + get_mhartid()*4) = (int) get_mhartid();
    }
  }

  // Read back the values
  for (int i = 0; i < NUM_HARTS; i++) {
    if(get_mhartid() != i) {
      if (*(volatile int *) (L1_BASE + i*L1_TILE_OFFSET + MEM_OFFSET + get_mhartid()*4) != get_mhartid()) {
        // h_pprintf("Read wrong value, expected "); pprintf(ds(get_hartid())); pprintln;
        printf("Read wrong value, expected %0d\n", get_mhartid());
        error[get_mhartid()]++;
      }
    }
  }

  wait_nop(SETTLE_CYCLE);

  if (get_mhartid() == 0) {
    for (int i = 0; i < NUM_HARTS; i++)
      if (error[i]) total_errors++;
    if (total_errors) { /*h_pprintf("TEST FAILED!!"); pprintln;*/ printf("TEST FAILED!!"); }
    else              { /*h_pprintf("TEST PASSED!!"); pprintln;*/ printf("TEST PASSED!!"); }
  } else wait_nop(SETTLE_CYCLE);         

  return total_errors;
}
