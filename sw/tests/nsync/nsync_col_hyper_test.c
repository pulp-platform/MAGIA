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
 * MAGIA NoC Column Hyper Synchronization Test
 */

#include "magia_tile_utils.h"
#include "magia_utils.h"
#include "cache_fill.h"

#define VERBOSE (0)

#define SYNC_NODE_Y_ID ((MESH_Y_TILES-1)/2)
#define SYNC_START_BIT (31-__builtin_clz(MESH_X_TILES))
#define SYNC_MAX_BIT   (30-__builtin_clz(NUM_HARTS))

#define CACHE_HEAT_CYCLES (3)

int main(void) {
  uint32_t tile_hartid = get_hartid();
  uint32_t tile_yid    = GET_Y_ID(tile_hartid);

  printf("Starting NoC Synch test...\n");

  printf("Running column hyper algorithm...\n");

  // Filling up the cache
  fill_icache();
  
  // Execute synchronization multiple times to pre-heat the cache
  for (int i = 0; i < CACHE_HEAT_CYCLES; i++) {
    uint32_t sync_bit   = SYNC_START_BIT;
    uint32_t sync_ohbit = 1 << SYNC_START_BIT;
    uint32_t sync_mask  = 0;
    uint32_t sync_sign  = 0;
    
    // Instruction immediately preceding synchronization: indicates start of the synchronization region
    sentinel_start();
    
    // Ascend tree
    while ((sync_bit < SYNC_MAX_BIT) && ((tile_hartid & sync_mask) == sync_sign)){

      if (tile_yid <= SYNC_NODE_Y_ID) { // Top half

        if (tile_hartid & sync_ohbit) { // DST
#if VERBOSE > 10
          printf("[ASCEND PHASE] Top DST: sync_bit - %0d, sync_ohbit - 0x%0x, sync_mask - 0x%0x, sync_sign - 0x%0x\n",
            sync_bit, sync_ohbit, sync_mask, sync_sign);
#endif
          // Wait for SRC to request synchronization
          while (mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) < 1);

          // Reset barrier counter
          mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) = 0;
        } else {  // SRC
#if VERBOSE > 10
          printf("[ASCEND PHASE] Top SRC: sync_bit - %0d, sync_ohbit - 0x%0x, sync_mask - 0x%0x, sync_sign - 0x%0x\n",
            sync_bit, sync_ohbit, sync_mask, sync_sign);
#endif
          // Send synchronization request to DST: No need for AMOs (single source write)
          mmio32(SYNC_BASE + 4*sync_bit + (tile_hartid ^ sync_ohbit)*L1_TILE_OFFSET) = 1;
          // amo_increment(SYNC_BASE + 4*sync_bit + (tile_hartid ^ sync_ohbit)*L1_TILE_OFFSET, 1);
        }
        sync_sign = sync_sign | (1 << sync_bit);

      } else {  // Bottom half

        if (!(tile_hartid & sync_ohbit)) {  // DST
#if VERBOSE > 10
          printf("[ASCEND PHASE] Bottom DST: sync_bit - %0d, sync_ohbit - 0x%0x, sync_mask - 0x%0x, sync_sign - 0x%0x\n",
            sync_bit, sync_ohbit, sync_mask, sync_sign);
#endif
          // Wait for SRC to request synchronization
          while (mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) < 1);

          // Reset barrier counter
          mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) = 0;
        } else {  // SRC
#if VERBOSE > 10
          printf("[ASCEND PHASE] Bottom SRC: sync_bit - %0d, sync_ohbit - 0x%0x, sync_mask - 0x%0x, sync_sign - 0x%0x\n",
            sync_bit, sync_ohbit, sync_mask, sync_sign);
#endif
          // Send synchronization request to DST: No need for AMOs (single source write)
          mmio32(SYNC_BASE + 4*sync_bit + (tile_hartid ^ sync_ohbit)*L1_TILE_OFFSET) = 1;
          // amo_increment(SYNC_BASE + 4*sync_bit + (tile_hartid ^ sync_ohbit)*L1_TILE_OFFSET, 1);
        }
        // Default sign is already correct
      }
      sync_mask  = sync_mask | (1 << sync_bit);
      sync_bit   += 1;
      sync_ohbit <<= 1;
    }
#if VERBOSE > 10
    printf("[ASCEND PHASE] END: sync_bit - %0d, sync_ohbit - 0x%0x, sync_mask - 0x%0x, sync_sign - 0x%0x\n",
      sync_bit, sync_ohbit, sync_mask, sync_sign);
#endif

    // Synchronize root nodes
    if ((tile_hartid & sync_mask) == sync_sign) { // Root nodes
      if (!(tile_hartid & sync_ohbit)) {  // DST
#if VERBOSE > 10
        printf("[ROOT PHASE] DST: sync_bit - %0d, sync_ohbit - 0x%0x, sync_mask - 0x%0x, sync_sign - 0x%0x\n",
          sync_bit, sync_ohbit, sync_mask, sync_sign);
#endif
        // Wait for SRC to request synchronization
        while (mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) < 1);

        // Reset barrier counter
        mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) = 0;

        // Send synchronization response to SRC: No need for AMOs (single source write)
        mmio32(SYNC_BASE + 4*sync_bit + (tile_hartid+MESH_X_TILES)*L1_TILE_OFFSET) = 1;
        // amo_increment(SYNC_BASE + 4*sync_bit + (tile_hartid+MESH_X_TILES)*L1_TILE_OFFSET, 1);
      } else {  // SRC
#if VERBOSE > 10
        printf("[ROOT PHASE] SRC: sync_bit - %0d, sync_ohbit - 0x%0x, sync_mask - 0x%0x, sync_sign - 0x%0x\n",
          sync_bit, sync_ohbit, sync_mask, sync_sign);
#endif
        // Send synchronization request to DST: No need for AMOs (single source write)
        mmio32(SYNC_BASE + 4*sync_bit + (tile_hartid-MESH_X_TILES)*L1_TILE_OFFSET) = 1;
        // amo_increment(SYNC_BASE + 4*sync_bit + (tile_hartid-MESH_X_TILES)*L1_TILE_OFFSET, 1);

        // Wait for DST synchronization response
        while (mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) < 1);

        // Reset barrier counter
        mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) = 0;
      }
    }
#if VERBOSE > 10
    printf("[ROOT PHASE] END: sync_bit - %0d, sync_ohbit - 0x%0x, sync_mask - 0x%0x, sync_sign - 0x%0x\n",
      sync_bit, sync_ohbit, sync_mask, sync_sign);
#endif

    // Descend tree
    sync_bit   -= 1;
    sync_ohbit >>= 1;
    sync_mask  = sync_mask & ~(1 << sync_bit);
    sync_sign  = sync_sign & ~(1 << sync_bit);
    while ((sync_bit < SYNC_MAX_BIT) && ((tile_hartid & sync_mask) == sync_sign)) {

      if (tile_yid <= SYNC_NODE_Y_ID) { // Top half

        if (tile_hartid & sync_ohbit) {  // SRC
#if VERBOSE > 10
          printf("[DESCEND PHASE] Top SRC: sync_bit - %0d, sync_ohbit - 0x%0x, sync_mask - 0x%0x, sync_sign - 0x%0x\n",
            sync_bit, sync_ohbit, sync_mask, sync_sign);
#endif
          // Send synchronization response to SRC: No need for AMOs (single source write)
          mmio32(SYNC_BASE + 4*sync_bit + (tile_hartid ^ sync_ohbit)*L1_TILE_OFFSET) = 1;
          // amo_increment(SYNC_BASE + 4*sync_bit + (tile_hartid ^ sync_ohbit)*L1_TILE_OFFSET, 1);
        } else {  // DST
#if VERBOSE > 10
          printf("[DESCEND PHASE] Top DST: sync_bit - %0d, sync_ohbit - 0x%0x, sync_mask - 0x%0x, sync_sign - 0x%0x\n",
            sync_bit, sync_ohbit, sync_mask, sync_sign);
#endif
          // Wait for DST synchronization response
          while (mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) < 1);

          // Reset barrier counter
          mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) = 0;
        }

      } else {  // Bottom half

        if (!(tile_hartid & sync_ohbit)) {  // SRC
#if VERBOSE > 10
          printf("[DESCEND PHASE] Bottom SRC: sync_bit - %0d, sync_ohbit - 0x%0x, sync_mask - 0x%0x, sync_sign - 0x%0x\n",
            sync_bit, sync_ohbit, sync_mask, sync_sign);
#endif
          // Send synchronization response to SRC: No need for AMOs (single source write)
          mmio32(SYNC_BASE + 4*sync_bit + (tile_hartid ^ sync_ohbit)*L1_TILE_OFFSET) = 1;
          // amo_increment(SYNC_BASE + 4*sync_bit + (tile_hartid ^ sync_ohbit)*L1_TILE_OFFSET, 1);
        } else {  // DST
#if VERBOSE > 10
          printf("[DESCEND PHASE] Bottom DST: sync_bit - %0d, sync_ohbit - 0x%0x, sync_mask - 0x%0x, sync_sign - 0x%0x\n",
            sync_bit, sync_ohbit, sync_mask, sync_sign);
#endif
          // Wait for DST synchronization response
          while (mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) < 1);
          
          // Reset barrier counter
          mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) = 0;
        }

      }
      sync_bit   -= 1;
      sync_ohbit >>= 1;
      sync_mask  = sync_mask & ~(1 << sync_bit);
      sync_sign  = sync_sign & ~(1 << sync_bit);
    }
#if VERBOSE > 10
    printf("[DESCEND PHASE] END: sync_bit - %0d, sync_ohbit - 0x%0x, sync_mask - 0x%0x, sync_sign - 0x%0x\n",
      sync_bit, sync_ohbit, sync_mask, sync_sign);
#endif

    // Instruction immediately following synchronization: indicates end of the synchronization region
    sentinel_end();
  }

  printf("NoC Synch test finished...\n");

  mmio16(TEST_END_ADDR + tile_hartid*2) = DEFAULT_EXIT_CODE - tile_hartid;

  return 0;
}
