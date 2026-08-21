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
 * Authors: Carlotta Chiarini, Fondazione Chips-IT
 * 
 * MAGIA Broadcast test over the FlooNoC narrow channel
 * 1) The source tile (SOURCE_HART_ID) broadcast a single 32-bit word over the narrow channel.
 * 2) The test passes if all the destination tiles successfully receive the 32-bit word.
 */

#include "magia_utils.h"
#include "magia_coll_utils.h"

#define MEM_OFFSET (0x1000)
#define BROADCAST_WORD (0x12345678)

#define SOURCE_HART_ID 3

int main() {
  
  /*
  * Hardware configuration:
  * 1) Collective Operation opcode -> MULTICAST
  * 2) Nodes taking part to the transactions -> ALL
  */
  set_collective_mask(gen_collective_mask(ALL));
  set_collective_op(MULTICAST);
    
  if(get_hartid() == SOURCE_HART_ID) {
    
    printf("Source of the broadcast\n");

    /*
    * The source tile broadcast a single 32-bit word.
    * COLLECTIVE_ADDR_OFFSET tells the hardware that this 32-bit word should be treated as part of a collective operation.
    */ 
    mmio32(COLLECTIVE_ADDR_OFFSET + L1_BASE + get_hartid()*L1_TILE_OFFSET + MEM_OFFSET) = BROADCAST_WORD;
    
  } else {

    printf("Destination of the broadcast\n");

    /*
    * The destination tile waits the reception of the broadcast word.
    */
    while(mmio32(L1_BASE + get_hartid()*L1_TILE_OFFSET + MEM_OFFSET) != BROADCAST_WORD) {};

    printf("TEST PASSED\n");
  }

  return 0;
}
