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
 * Authors: Carlotta Chiarini
 * 
 * MAGIA Column multicast test over the narrow channel.
 */

#include "magia_utils.h"
#include "magia_coll_utils.h"

#define MEM_OFFSET (0x1000)
#define END_OF_TEST_OFFSET (0x0)
#define END_PATTERN (0xCCAA)
#define BROADCAST_WORD (0x12345678)

#define SOURCE_HART_ID 3

int main() {
  
  set_collective_mask(gen_collective_mask(ROW));
  set_collective_op(MULTICAST);
    
  if(get_hartid() == SOURCE_HART_ID) {
    
    printf("Source of the broadcast\n");

    *(volatile int*) (COLLECTIVE_ADDR_OFFSET + get_hartid()*L1_TILE_OFFSET + L1_BASE + MEM_OFFSET) = (int) BROADCAST_WORD;
    *(volatile int*) (COLLECTIVE_ADDR_OFFSET + get_hartid()*L1_TILE_OFFSET + L1_BASE + END_OF_TEST_OFFSET) = (int) END_PATTERN;
    
  } else {
      if(GET_Y_ID(get_hartid()) == GET_Y_ID(SOURCE_HART_ID)){
        printf("Destination of the multicast\n");

        while(*(volatile int*) (L1_BASE + get_hartid()*L1_TILE_OFFSET + END_OF_TEST_OFFSET) != (int) END_PATTERN) {};

        if(*(volatile int*) (L1_BASE + get_hartid()*L1_TILE_OFFSET + MEM_OFFSET) == BROADCAST_WORD)
            printf("TEST PASSED\n");
        else
            printf("ERROR: Expected 0x%x; Actual: 0x%x\n", BROADCAST_WORD, *(volatile int *)(L1_BASE + get_hartid()*L1_TILE_OFFSET + MEM_OFFSET));
      }
    }   

  return 0;
}
