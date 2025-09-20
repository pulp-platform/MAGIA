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
 * MAGIA Naive NoC Synchronization Test
 */

#include "magia_tile_utils.h"
#include "magia_utils.h"
#include "cache_fill.h"

#define VERBOSE (0)

#define SYNC_NODE_Y_ID ((MESH_Y_TILES-1)/2)
#define SYNC_NODE_X_ID ((MESH_X_TILES-1)/2)
#define SYNC_NODE_ID   (GET_ID(SYNC_NODE_Y_ID, SYNC_NODE_X_ID))

#define CACHE_HEAT_CYCLES (3)

int main(void) {
  uint32_t tile_hartid = get_hartid();

  printf("Starting NoC Synch test...\n");

  printf("Running naive algorithm...\n");

  // Filling up the cache
  fill_icache();
  
  // Execute synchronization multiple times to pre-heat the cache
  for (int i = 0; i < CACHE_HEAT_CYCLES; i++) {
    // Instruction immediately preceding synchronization: indicates start of the synchronization region
    stnl_snc_s();

    if (tile_hartid == SYNC_NODE_ID) { // DST
      // Wait for all SRCs to request synchronization
      while (mmio32(SYNC_BASE + tile_hartid*L1_TILE_OFFSET) < NUM_HARTS-1);

      // Reset barrier counter
      mmio32(SYNC_BASE + tile_hartid*L1_TILE_OFFSET) = 0;

      // Send synchronization response to all SRCs
      for (int i = 0; i < SYNC_NODE_ID; i++) amo_increment(SYNC_BASE + i*L1_TILE_OFFSET, 1);
      for (int i = SYNC_NODE_ID+1; i < NUM_HARTS; i++) amo_increment(SYNC_BASE + i*L1_TILE_OFFSET, 1);
    } else {  // SRC
      // Send synchronization request to DST
      amo_increment(SYNC_BASE + SYNC_NODE_ID*L1_TILE_OFFSET, 1);

      // Wait for DST synchronization response
      while (mmio32(SYNC_BASE + tile_hartid*L1_TILE_OFFSET) < 1);

      // Reset barrier counter
      mmio32(SYNC_BASE + tile_hartid*L1_TILE_OFFSET) = 0;
    }

    // Instruction immediately following synchronization: indicates end of the synchronization region
    stnl_snc_f();
  }

  printf("NoC Synch test finished...\n");

  mmio16(TEST_END_ADDR + tile_hartid*2) = DEFAULT_EXIT_CODE - tile_hartid;

  return 0;
}
