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
 * MAGIA Column synchronization test over the narrow channel
 * using the built-in FlooNoC collectives
 */

#include "magia_utils.h"
#include "magia_coll_utils.h"

#define MEM_OFFSET (0x1000)
#define DESTINATION_HART_ID 0
#define CACHE_HEAT_CYCLES (5)
#define SYNC_PATTERN 3

int main() {

  /*
  * Hardware configuration:
  * 1) Collective Operation opcode -> LSBAND
  * 2) Nodes taking part to the transactions -> COLUMN
  */
  set_collective_mask(gen_collective_mask(COLUMN));
  set_collective_op(LSBAND);

  /*
  * Only the nodes on the same column of the DESTINATION_HART_ID node are taking part to the sync.
  */
  if(GET_X_ID(get_hartid()) == GET_X_ID(DESTINATION_HART_ID)){
    printf("Synchronizing...\n");
    /* 
    * Execute synchronization multiple times to pre-heat the cache
    */
    for (int i = 0; i < CACHE_HEAT_CYCLES; i++) {
        // Data to be reduced (LsbAND)
        sentinel_start();
        mmio32(COLLECTIVE_ADDR_OFFSET + L1_BASE + DESTINATION_HART_ID*L1_TILE_OFFSET + MEM_OFFSET) = SYNC_PATTERN;
        magia_fence();
        sentinel_end();
    }
  }
  /*
  * If the current node is the DESTINATION_HART_ID node, it waits for the final reduced data.
  */
  if(get_hartid() == DESTINATION_HART_ID){
    while(mmio32(L1_BASE + get_hartid()*L1_TILE_OFFSET + MEM_OFFSET) != SYNC_PATTERN) {};
    printf("TEST PASSED\n");
  }

  return 0;
}
