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
 * MAGIA NoC Vertical Neighbor Synchronization Test
 */

#include "magia_tile_utils.h"
#include "magia_utils.h"
#include "cache_fill.h"

#define VERBOSE (0)

#define CACHE_HEAT_CYCLES (3)

int main(void) {
  uint32_t tile_hartid = get_hartid();
  uint32_t tile_yid    = GET_Y_ID(tile_hartid);

  printf("Starting NoC Synch test...\n");

  printf("Running vertical neighbor algorithm...\n");

  // Filling up the cache
  fill_icache();
  
  // Execute synchronization multiple times to pre-heat the cache
  for (int i = 0; i < CACHE_HEAT_CYCLES; i++) {
    // Instruction immediately preceding synchronization: indicates start of the synchronization region
    sentinel_start();
    
    if (tile_yid % 2) { // SRC
      // Send synchronization request to DST
      amo_increment(SYNC_BASE + (tile_hartid-MESH_X_TILES)*L1_TILE_OFFSET, 1);

      // Wait for DST synchronization response
      while (mmio32(SYNC_BASE + tile_hartid*L1_TILE_OFFSET) < 1);

      // Reset barrier counter
      mmio32(SYNC_BASE + tile_hartid*L1_TILE_OFFSET) = 0;
    } else { // DST
      // Wait for all SRCs to request synchronization
      while (mmio32(SYNC_BASE + tile_hartid*L1_TILE_OFFSET) < 1);

      // Reset barrier counter
      mmio32(SYNC_BASE + tile_hartid*L1_TILE_OFFSET) = 0;

      // Send synchronization response to SRC
      amo_increment(SYNC_BASE + (tile_hartid+MESH_X_TILES)*L1_TILE_OFFSET, 1);
    }

    // Instruction immediately following synchronization: indicates end of the synchronization region
    sentinel_end();
  }

  printf("NoC Synch test finished...\n");

  return 0;
}
