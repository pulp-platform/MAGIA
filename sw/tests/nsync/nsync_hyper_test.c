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
 * MAGIA Hyper NoC Synchronization Test
 */

#include "magia_tile_utils.h"
#include "magia_utils.h"
#include "cache_fill.h"

#define VERBOSE (0)

#define SYNC_NODE_Y_ID ((MESH_Y_TILES-1)/2)
#define SYNC_NODE_X_ID ((MESH_X_TILES-1)/2)
#define SYNC_NODE_ID   (GET_ID(SYNC_NODE_Y_ID, SYNC_NODE_X_ID))
#define SYNC_MAX_BIT   (31-__builtin_clz(NUM_HARTS/2))

#define CACHE_HEAT_CYCLES (3)

int main(void) {
  volatile uint32_t sync_count[NUM_HARTS];
  volatile uint32_t sync_bit[NUM_HARTS];
  volatile uint32_t sync_ohbit[NUM_HARTS];
  volatile uint32_t sync_mask[NUM_HARTS];
  volatile uint32_t sync_sign[NUM_HARTS];
  
  printf("Starting NoC Synch test...\n");

  printf("Running hyper algorithm...\n");

  // Filling up the cache
  fill_icache();
  
  // Execute synchronization multiple times to pre-heat the cache
  for (int i = 0; i < CACHE_HEAT_CYCLES; i++) {
    // Instruction immediately preceding synchronization: indicates start of the synchronization region
    sentinel_start();
    
    sync_bit[get_hartid()]   = 0;
    sync_ohbit[get_hartid()] = 1;
    sync_mask[get_hartid()]  = 0;
    sync_sign[get_hartid()]  = 0;

    // Ascend tree
    while ((sync_bit[get_hartid()] < SYNC_MAX_BIT) && ((get_hartid() & sync_mask[get_hartid()]) == sync_sign[get_hartid()])) {
      // Ignore column quadrant bit
      if (sync_bit[get_hartid()] == SYNC_MAX_BIT/2) {
#if VERBOSE > 10
        printf("[ASCEND PHASE] SKIP: sync_bit - %0d, sync_ohbit - 0x%0x, sync_mask - 0x%0x, sync_sign - 0x%0x\n",
          sync_bit[get_hartid()], sync_ohbit[get_hartid()], sync_mask[get_hartid()], sync_sign[get_hartid()]);
#endif
        sync_bit[get_hartid()]   += 1;
        sync_ohbit[get_hartid()] <<= 1;
        continue;
      }

      if ((GET_Y_ID(get_hartid()) <= SYNC_NODE_Y_ID) && (GET_X_ID(get_hartid()) <= SYNC_NODE_X_ID)) { // First quadrant

        if (get_hartid() & sync_ohbit[get_hartid()]) {  // DST
#if VERBOSE > 10
          printf("[ASCEND PHASE] Q1 DST: sync_bit - %0d, sync_ohbit - 0x%0x, sync_mask - 0x%0x, sync_sign - 0x%0x\n",
            sync_bit[get_hartid()], sync_ohbit[get_hartid()], sync_mask[get_hartid()], sync_sign[get_hartid()]);
#endif
          // Wait for SRC to request synchronization
          do {
            sync_count[get_hartid()] = mmio32(SYNC_BASE + 4*sync_bit[get_hartid()] + get_hartid()*L1_TILE_OFFSET);
#if VERBOSE > 100
            printf("current sync_count: %0d\n", sync_count[get_hartid()]);
#endif
          } while (sync_count[get_hartid()] < 1);
          // Reset barrier counter
          mmio32(SYNC_BASE + 4*sync_bit[get_hartid()] + get_hartid()*L1_TILE_OFFSET) = 0;
        } else {  // SRC
#if VERBOSE > 10
          printf("[ASCEND PHASE] Q1 SRC: sync_bit - %0d, sync_ohbit - 0x%0x, sync_mask - 0x%0x, sync_sign - 0x%0x\n",
            sync_bit[get_hartid()], sync_ohbit[get_hartid()], sync_mask[get_hartid()], sync_sign[get_hartid()]);
#endif
          // Send synchronization request to DST: No need for AMOs (single source write)
          mmio32(SYNC_BASE + 4*sync_bit[get_hartid()] + (get_hartid() ^ sync_ohbit[get_hartid()])*L1_TILE_OFFSET) = 1;
          // amo_increment(SYNC_BASE + 4*sync_bit[get_hartid()] + (get_hartid() ^ sync_ohbit[get_hartid()])*L1_TILE_OFFSET, 1);
        }
        sync_sign[get_hartid()] = sync_sign[get_hartid()] | (1 << sync_bit[get_hartid()]);

      } else if ((GET_Y_ID(get_hartid()) <= SYNC_NODE_Y_ID) && (GET_X_ID(get_hartid()) > SYNC_NODE_X_ID)) {  // Second quadrant

        if ((!(get_hartid() & sync_ohbit[get_hartid()]) && (sync_bit[get_hartid()] < (SYNC_MAX_BIT/2))) || 
            ((get_hartid() & sync_ohbit[get_hartid()]) && (sync_bit[get_hartid()] >= (SYNC_MAX_BIT/2)))) {  // DST
#if VERBOSE > 10
          printf("[ASCEND PHASE] Q2 DST: sync_bit - %0d, sync_ohbit - 0x%0x, sync_mask - 0x%0x, sync_sign - 0x%0x\n",
            sync_bit[get_hartid()], sync_ohbit[get_hartid()], sync_mask[get_hartid()], sync_sign[get_hartid()]);
#endif
          // Wait for SRC to request synchronization
          do {
            sync_count[get_hartid()] = mmio32(SYNC_BASE + 4*sync_bit[get_hartid()] + get_hartid()*L1_TILE_OFFSET);
#if VERBOSE > 100
            printf("current sync_count: %0d\n", sync_count[get_hartid()]);
#endif
          } while (sync_count[get_hartid()] < 1);
          // Reset barrier counter
          mmio32(SYNC_BASE + 4*sync_bit[get_hartid()] + get_hartid()*L1_TILE_OFFSET) = 0;
        } else {  // SRC
#if VERBOSE > 10
          printf("[ASCEND PHASE] Q2 SRC: sync_bit - %0d, sync_ohbit - 0x%0x, sync_mask - 0x%0x, sync_sign - 0x%0x\n",
            sync_bit[get_hartid()], sync_ohbit[get_hartid()], sync_mask[get_hartid()], sync_sign[get_hartid()]);
#endif
          // Send synchronization request to DST: No need for AMOs (single source write)
          mmio32(SYNC_BASE + 4*sync_bit[get_hartid()] + (get_hartid() ^ sync_ohbit[get_hartid()])*L1_TILE_OFFSET) = 1;
          // amo_increment(SYNC_BASE + 4*sync_bit[get_hartid()] + (get_hartid() ^ sync_ohbit[get_hartid()])*L1_TILE_OFFSET, 1);
        }
        if (sync_bit[get_hartid()] >= (SYNC_MAX_BIT/2))
          sync_sign[get_hartid()] = sync_sign[get_hartid()] | (1 << sync_bit[get_hartid()]);

      } else if ((GET_Y_ID(get_hartid()) > SYNC_NODE_Y_ID) && (GET_X_ID(get_hartid()) <= SYNC_NODE_X_ID)) {  // Third quadrant

        if (((get_hartid() & sync_ohbit[get_hartid()]) && (sync_bit[get_hartid()] < (SYNC_MAX_BIT/2))) || 
            (!(get_hartid() & sync_ohbit[get_hartid()]) && (sync_bit[get_hartid()] >= (SYNC_MAX_BIT/2)))) {  // DST
#if VERBOSE > 10
          printf("[ASCEND PHASE] Q3 DST: sync_bit - %0d, sync_ohbit - 0x%0x, sync_mask - 0x%0x, sync_sign - 0x%0x\n",
            sync_bit[get_hartid()], sync_ohbit[get_hartid()], sync_mask[get_hartid()], sync_sign[get_hartid()]);
#endif
          // Wait for SRC to request synchronization
          do {
            sync_count[get_hartid()] = mmio32(SYNC_BASE + 4*sync_bit[get_hartid()] + get_hartid()*L1_TILE_OFFSET);
#if VERBOSE > 100
            printf("current sync_count: %0d\n", sync_count[get_hartid()]);
#endif
          } while (sync_count[get_hartid()] < 1);
          // Reset barrier counter
          mmio32(SYNC_BASE + 4*sync_bit[get_hartid()] + get_hartid()*L1_TILE_OFFSET) = 0;
        } else {  // SRC
#if VERBOSE > 10
          printf("[ASCEND PHASE] Q3 SRC: sync_bit - %0d, sync_ohbit - 0x%0x, sync_mask - 0x%0x, sync_sign - 0x%0x\n",
            sync_bit[get_hartid()], sync_ohbit[get_hartid()], sync_mask[get_hartid()], sync_sign[get_hartid()]);
#endif
          // Send synchronization request to DST: No need for AMOs (single source write)
          mmio32(SYNC_BASE + 4*sync_bit[get_hartid()] + (get_hartid() ^ sync_ohbit[get_hartid()])*L1_TILE_OFFSET) = 1;
          // amo_increment(SYNC_BASE + 4*sync_bit[get_hartid()] + (get_hartid() ^ sync_ohbit[get_hartid()])*L1_TILE_OFFSET, 1);
        }
        if (sync_bit[get_hartid()] < (SYNC_MAX_BIT/2))
          sync_sign[get_hartid()] = sync_sign[get_hartid()] | (1 << sync_bit[get_hartid()]);

      } else if ((GET_Y_ID(get_hartid()) > SYNC_NODE_Y_ID) && (GET_X_ID(get_hartid()) > SYNC_NODE_X_ID)) {  // Forth quadrant

        if (!(get_hartid() & sync_ohbit[get_hartid()])) {  // DST
#if VERBOSE > 10
          printf("[ASCEND PHASE] Q4 DST: sync_bit - %0d, sync_ohbit - 0x%0x, sync_mask - 0x%0x, sync_sign - 0x%0x\n",
            sync_bit[get_hartid()], sync_ohbit[get_hartid()], sync_mask[get_hartid()], sync_sign[get_hartid()]);
#endif
          // Wait for SRC to request synchronization
          do {
            sync_count[get_hartid()] = mmio32(SYNC_BASE + 4*sync_bit[get_hartid()] + get_hartid()*L1_TILE_OFFSET);
#if VERBOSE > 100
            printf("current sync_count: %0d\n", sync_count[get_hartid()]);
#endif
          } while (sync_count[get_hartid()] < 1);
          // Reset barrier counter
          mmio32(SYNC_BASE + 4*sync_bit[get_hartid()] + get_hartid()*L1_TILE_OFFSET) = 0;
        } else {  // SRC
#if VERBOSE > 10
          printf("[ASCEND PHASE] Q4 SRC: sync_bit - %0d, sync_ohbit - 0x%0x, sync_mask - 0x%0x, sync_sign - 0x%0x\n",
            sync_bit[get_hartid()], sync_ohbit[get_hartid()], sync_mask[get_hartid()], sync_sign[get_hartid()]);
#endif
          // Send synchronization request to DST: No need for AMOs (single source write)
          mmio32(SYNC_BASE + 4*sync_bit[get_hartid()] + (get_hartid() ^ sync_ohbit[get_hartid()])*L1_TILE_OFFSET) = 1;
          // amo_increment(SYNC_BASE + 4*sync_bit[get_hartid()] + (get_hartid() ^ sync_ohbit[get_hartid()])*L1_TILE_OFFSET, 1);
        }
        // Default sign is already correct
      }
      sync_mask[get_hartid()]  = sync_mask[get_hartid()] | (1 << sync_bit[get_hartid()]);
      sync_bit[get_hartid()]   += 1;
      sync_ohbit[get_hartid()] <<= 1;
    }
#if VERBOSE > 10
    printf("[ASCEND PHASE] END: sync_bit - %0d, sync_ohbit - 0x%0x, sync_mask - 0x%0x, sync_sign - 0x%0x\n",
      sync_bit[get_hartid()], sync_ohbit[get_hartid()], sync_mask[get_hartid()], sync_sign[get_hartid()]);
#endif
    
    // Synchronize root tree
    if ((GET_Y_ID(get_hartid()) == SYNC_NODE_Y_ID+1) && (GET_X_ID(get_hartid()) == SYNC_NODE_X_ID+1)) { // Forth quadrant root
#if VERBOSE > 10
      printf("[ROOT PHASE] Q4: sync_bit - %0d, sync_ohbit - 0x%0x, sync_mask - 0x%0x, sync_sign - 0x%0x\n",
        sync_bit[get_hartid()], sync_ohbit[get_hartid()], sync_mask[get_hartid()], sync_sign[get_hartid()]);
#endif
      // Send synchronization request to DST: No need for AMOs (single source write)
      mmio32(SYNC_BASE + 4*sync_bit[get_hartid()] + GET_ID(SYNC_NODE_Y_ID+1, SYNC_NODE_X_ID)*L1_TILE_OFFSET) = 1;
      // amo_increment(SYNC_BASE + 4*sync_bit[get_hartid()] + GET_ID(SYNC_NODE_Y_ID+1, SYNC_NODE_X_ID)*L1_TILE_OFFSET, 1);

      // Wait for DST synchronization response
      do {
        sync_count[get_hartid()] = mmio32(SYNC_BASE + 4*sync_bit[get_hartid()] + get_hartid()*L1_TILE_OFFSET);
#if VERBOSE > 100
        printf("current sync_count: %0d\n", sync_count[get_hartid()]);
#endif
      } while (sync_count[get_hartid()] < 1);
      // Reset barrier counter
      mmio32(SYNC_BASE + 4*sync_bit[get_hartid()] + get_hartid()*L1_TILE_OFFSET) = 0;

    } else if ((GET_Y_ID(get_hartid()) == SYNC_NODE_Y_ID) && (GET_X_ID(get_hartid()) == SYNC_NODE_X_ID+1)) {  // Second quadrant root
#if VERBOSE > 10
      printf("[ROOT PHASE] Q2: sync_bit - %0d, sync_ohbit - 0x%0x, sync_mask - 0x%0x, sync_sign - 0x%0x\n",
        sync_bit[get_hartid()], sync_ohbit[get_hartid()], sync_mask[get_hartid()], sync_sign[get_hartid()]);
#endif
      // Send synchronization request to DST: No need for AMOs (single source write)
      mmio32(SYNC_BASE + 4*sync_bit[get_hartid()] + GET_ID(SYNC_NODE_Y_ID, SYNC_NODE_X_ID)*L1_TILE_OFFSET) = 1;
      // amo_increment(SYNC_BASE + 4*sync_bit[get_hartid()] + GET_ID(SYNC_NODE_Y_ID, SYNC_NODE_X_ID)*L1_TILE_OFFSET, 1);

      // Wait for DST synchronization response
      do {
        sync_count[get_hartid()] = mmio32(SYNC_BASE + 4*sync_bit[get_hartid()] + get_hartid()*L1_TILE_OFFSET);
#if VERBOSE > 100
        printf("current sync_count: %0d\n", sync_count[get_hartid()]);
#endif
      } while (sync_count[get_hartid()] < 1);
      // Reset barrier counter
      mmio32(SYNC_BASE + 4*sync_bit[get_hartid()] + get_hartid()*L1_TILE_OFFSET) = 0;

    } else if ((GET_Y_ID(get_hartid()) == SYNC_NODE_Y_ID+1) && (GET_X_ID(get_hartid()) == SYNC_NODE_X_ID)) {  // Third quadrant root
#if VERBOSE > 10
      printf("[ROOT PHASE] Q3: sync_bit - %0d, sync_ohbit - 0x%0x, sync_mask - 0x%0x, sync_sign - 0x%0x\n",
        sync_bit[get_hartid()], sync_ohbit[get_hartid()], sync_mask[get_hartid()], sync_sign[get_hartid()]);
#endif
      // Wait for SRC to request synchronization
      do {
        sync_count[get_hartid()] = mmio32(SYNC_BASE + 4*sync_bit[get_hartid()] + get_hartid()*L1_TILE_OFFSET);
#if VERBOSE > 100
        printf("current sync_count: %0d\n", sync_count[get_hartid()]);
#endif
      } while (sync_count[get_hartid()] < 1);
      // Reset barrier counter
      mmio32(SYNC_BASE + 4*sync_bit[get_hartid()] + get_hartid()*L1_TILE_OFFSET) = 0;

      // Send synchronization request to DST: No need for AMOs (single source write)
      mmio32(SYNC_BASE + 4*(sync_bit[get_hartid()]+1) + GET_ID(SYNC_NODE_Y_ID, SYNC_NODE_X_ID)*L1_TILE_OFFSET) = 1;
      // amo_increment(SYNC_BASE + 4*(sync_bit[get_hartid()]+1) + GET_ID(SYNC_NODE_Y_ID, SYNC_NODE_X_ID)*L1_TILE_OFFSET, 1);

      // Wait for DST synchronization response
      do {
        sync_count[get_hartid()] = mmio32(SYNC_BASE + 4*(sync_bit[get_hartid()]+1) + get_hartid()*L1_TILE_OFFSET);
#if VERBOSE > 100
        printf("current sync_count: %0d\n", sync_count[get_hartid()]);
#endif
      } while (sync_count[get_hartid()] < 1);
      // Reset barrier counter
      mmio32(SYNC_BASE + 4*(sync_bit[get_hartid()]+1) + get_hartid()*L1_TILE_OFFSET) = 0;

      // Send synchronization response to SRC: No need for AMOs (single source write)
      mmio32(SYNC_BASE + 4*sync_bit[get_hartid()] + GET_ID(SYNC_NODE_Y_ID+1, SYNC_NODE_X_ID+1)*L1_TILE_OFFSET) = 1;
      // amo_increment(SYNC_BASE + 4*sync_bit[get_hartid()] + GET_ID(SYNC_NODE_Y_ID+1, SYNC_NODE_X_ID+1)*L1_TILE_OFFSET, 1);

    } else if ((GET_Y_ID(get_hartid()) == SYNC_NODE_Y_ID) && (GET_X_ID(get_hartid()) == SYNC_NODE_X_ID)) {  // First quadrant root
#if VERBOSE > 10
      printf("[ROOT PHASE] Q1: sync_bit - %0d, sync_ohbit - 0x%0x, sync_mask - 0x%0x, sync_sign - 0x%0x\n",
        sync_bit[get_hartid()], sync_ohbit[get_hartid()], sync_mask[get_hartid()], sync_sign[get_hartid()]);
#endif
      // Wait for SRC to request synchronization
      do {
        sync_count[get_hartid()] = mmio32(SYNC_BASE + 4*sync_bit[get_hartid()] + get_hartid()*L1_TILE_OFFSET);
#if VERBOSE > 100
        printf("current sync_count: %0d\n", sync_count[get_hartid()]);
#endif
      } while (sync_count[get_hartid()] < 1);
      // Reset barrier counter
      mmio32(SYNC_BASE + 4*sync_bit[get_hartid()] + get_hartid()*L1_TILE_OFFSET) = 0;

      // Wait for SRC to request synchronization
      do {
        sync_count[get_hartid()] = mmio32(SYNC_BASE + 4*(sync_bit[get_hartid()]+1) + get_hartid()*L1_TILE_OFFSET);
#if VERBOSE > 100
        printf("current sync_count: %0d\n", sync_count[get_hartid()]);
#endif
      } while (sync_count[get_hartid()] < 1);
      // Reset barrier counter
      mmio32(SYNC_BASE + 4*(sync_bit[get_hartid()]+1) + get_hartid()*L1_TILE_OFFSET) = 0;

      // Send synchronization response to SRC: No need for AMOs (single source write)
      mmio32(SYNC_BASE + 4*(sync_bit[get_hartid()]+1) + GET_ID(SYNC_NODE_Y_ID+1, SYNC_NODE_X_ID)*L1_TILE_OFFSET) = 1;
      // amo_increment(SYNC_BASE + 4*(sync_bit[get_hartid()]+1) + GET_ID(SYNC_NODE_Y_ID+1, SYNC_NODE_X_ID)*L1_TILE_OFFSET, 1);

      // Send synchronization response to SRC: No need for AMOs (single source write)
      mmio32(SYNC_BASE + 4*sync_bit[get_hartid()] + GET_ID(SYNC_NODE_Y_ID, SYNC_NODE_X_ID+1)*L1_TILE_OFFSET) = 1;
      // amo_increment(SYNC_BASE + 4*sync_bit[get_hartid()] + GET_ID(SYNC_NODE_Y_ID, SYNC_NODE_X_ID+1)*L1_TILE_OFFSET, 1);
    }
#if VERBOSE > 10
      printf("[ROOT PHASE] END: sync_bit - %0d, sync_ohbit - 0x%0x, sync_mask - 0x%0x, sync_sign - 0x%0x\n",
        sync_bit[get_hartid()], sync_ohbit[get_hartid()], sync_mask[get_hartid()], sync_sign[get_hartid()]);
#endif

    // Descend tree
    sync_bit[get_hartid()]   -= 1;
    sync_ohbit[get_hartid()] >>= 1;
    sync_mask[get_hartid()]  = sync_mask[get_hartid()] & ~(1 << sync_bit[get_hartid()]);
    sync_sign[get_hartid()]  = sync_sign[get_hartid()] & ~(1 << sync_bit[get_hartid()]);
    while ((sync_bit[get_hartid()] < SYNC_MAX_BIT) && ((get_hartid() & sync_mask[get_hartid()]) == sync_sign[get_hartid()])) {
      // Ignore column quadrant bit
      if (sync_bit[get_hartid()] == SYNC_MAX_BIT/2) {
#if VERBOSE > 10
        printf("[DESCEND PHASE] SKIP: sync_bit - %0d, sync_ohbit - 0x%0x, sync_mask - 0x%0x, sync_sign - 0x%0x\n",
          sync_bit[get_hartid()], sync_ohbit[get_hartid()], sync_mask[get_hartid()], sync_sign[get_hartid()]);
#endif
        sync_bit[get_hartid()]   -= 1;
        sync_ohbit[get_hartid()] >>= 1;
        sync_mask[get_hartid()]  = sync_mask[get_hartid()] & ~(1 << sync_bit[get_hartid()]);
        sync_sign[get_hartid()]  = sync_sign[get_hartid()] & ~(1 << sync_bit[get_hartid()]);
        continue;
      }

      if ((GET_Y_ID(get_hartid()) <= SYNC_NODE_Y_ID) && (GET_X_ID(get_hartid()) <= SYNC_NODE_X_ID)) { // First quadrant

        if (get_hartid() & sync_ohbit[get_hartid()]) {  // SRC
#if VERBOSE > 10
          printf("[DESCEND PHASE] Q1 SRC: sync_bit - %0d, sync_ohbit - 0x%0x, sync_mask - 0x%0x, sync_sign - 0x%0x\n",
            sync_bit[get_hartid()], sync_ohbit[get_hartid()], sync_mask[get_hartid()], sync_sign[get_hartid()]);
#endif
          // Send synchronization response to SRC: No need for AMOs (single source write)
          mmio32(SYNC_BASE + 4*sync_bit[get_hartid()] + (get_hartid() ^ sync_ohbit[get_hartid()])*L1_TILE_OFFSET) = 1;
          // amo_increment(SYNC_BASE + 4*sync_bit[get_hartid()] + (get_hartid() ^ sync_ohbit[get_hartid()])*L1_TILE_OFFSET, 1);
        } else {  // DST
#if VERBOSE > 10
          printf("[DESCEND PHASE] Q1 DST: sync_bit - %0d, sync_ohbit - 0x%0x, sync_mask - 0x%0x, sync_sign - 0x%0x\n",
            sync_bit[get_hartid()], sync_ohbit[get_hartid()], sync_mask[get_hartid()], sync_sign[get_hartid()]);
#endif
          // Wait for DST synchronization response
          do {
            sync_count[get_hartid()] = mmio32(SYNC_BASE + 4*sync_bit[get_hartid()] + get_hartid()*L1_TILE_OFFSET);
#if VERBOSE > 100
            printf("current sync_count: %0d\n", sync_count[get_hartid()]);
#endif
          } while (sync_count[get_hartid()] < 1);
          // Reset barrier counter
          mmio32(SYNC_BASE + 4*sync_bit[get_hartid()] + get_hartid()*L1_TILE_OFFSET) = 0;
        }

      } else if ((GET_Y_ID(get_hartid()) <= SYNC_NODE_Y_ID) && (GET_X_ID(get_hartid()) > SYNC_NODE_X_ID)) {  // Second quadrant

        if ((!(get_hartid() & sync_ohbit[get_hartid()]) && (sync_bit[get_hartid()] < (SYNC_MAX_BIT/2))) || 
            ((get_hartid() & sync_ohbit[get_hartid()]) && (sync_bit[get_hartid()] >= (SYNC_MAX_BIT/2)))) {  // SRC
#if VERBOSE > 10
          printf("[DESCEND PHASE] Q2 SRC: sync_bit - %0d, sync_ohbit - 0x%0x, sync_mask - 0x%0x, sync_sign - 0x%0x\n",
            sync_bit[get_hartid()], sync_ohbit[get_hartid()], sync_mask[get_hartid()], sync_sign[get_hartid()]);
#endif
          // Send synchronization response to SRC: No need for AMOs (single source write)
          mmio32(SYNC_BASE + 4*sync_bit[get_hartid()] + (get_hartid() ^ sync_ohbit[get_hartid()])*L1_TILE_OFFSET) = 1;
          // amo_increment(SYNC_BASE + 4*sync_bit[get_hartid()] + (get_hartid() ^ sync_ohbit[get_hartid()])*L1_TILE_OFFSET, 1);
        } else {  // DST
#if VERBOSE > 10
          printf("[DESCEND PHASE] Q2 DST: sync_bit - %0d, sync_ohbit - 0x%0x, sync_mask - 0x%0x, sync_sign - 0x%0x\n",
            sync_bit[get_hartid()], sync_ohbit[get_hartid()], sync_mask[get_hartid()], sync_sign[get_hartid()]);
#endif
          // Wait for DST synchronization response
          do {
            sync_count[get_hartid()] = mmio32(SYNC_BASE + 4*sync_bit[get_hartid()] + get_hartid()*L1_TILE_OFFSET);
#if VERBOSE > 100
            printf("current sync_count: %0d\n", sync_count[get_hartid()]);
#endif
          } while (sync_count[get_hartid()] < 1);
          // Reset barrier counter
          mmio32(SYNC_BASE + 4*sync_bit[get_hartid()] + get_hartid()*L1_TILE_OFFSET) = 0;
        }

      } else if ((GET_Y_ID(get_hartid()) > SYNC_NODE_Y_ID) && (GET_X_ID(get_hartid()) <= SYNC_NODE_X_ID)) {  // Third quadrant

        if (((get_hartid() & sync_ohbit[get_hartid()]) && (sync_bit[get_hartid()] < (SYNC_MAX_BIT/2))) || 
            (!(get_hartid() & sync_ohbit[get_hartid()]) && (sync_bit[get_hartid()] >= (SYNC_MAX_BIT/2)))) {  // SRC
#if VERBOSE > 10
          printf("[DESCEND PHASE] Q3 SRC: sync_bit - %0d, sync_ohbit - 0x%0x, sync_mask - 0x%0x, sync_sign - 0x%0x\n",
            sync_bit[get_hartid()], sync_ohbit[get_hartid()], sync_mask[get_hartid()], sync_sign[get_hartid()]);
#endif
          // Send synchronization response to SRC: No need for AMOs (single source write)
          mmio32(SYNC_BASE + 4*sync_bit[get_hartid()] + (get_hartid() ^ sync_ohbit[get_hartid()])*L1_TILE_OFFSET) = 1;
          // amo_increment(SYNC_BASE + 4*sync_bit[get_hartid()] + (get_hartid() ^ sync_ohbit[get_hartid()])*L1_TILE_OFFSET, 1);
        } else {  // DST
#if VERBOSE > 10
          printf("[DESCEND PHASE] Q3 DST: sync_bit - %0d, sync_ohbit - 0x%0x, sync_mask - 0x%0x, sync_sign - 0x%0x\n",
            sync_bit[get_hartid()], sync_ohbit[get_hartid()], sync_mask[get_hartid()], sync_sign[get_hartid()]);
#endif
          // Wait for DST synchronization response
          do {
            sync_count[get_hartid()] = mmio32(SYNC_BASE + 4*sync_bit[get_hartid()] + get_hartid()*L1_TILE_OFFSET);
#if VERBOSE > 100
            printf("current sync_count: %0d\n", sync_count[get_hartid()]);
#endif
          } while (sync_count[get_hartid()] < 1);
          // Reset barrier counter
          mmio32(SYNC_BASE + 4*sync_bit[get_hartid()] + get_hartid()*L1_TILE_OFFSET) = 0;
        }

      } else if ((GET_Y_ID(get_hartid()) > SYNC_NODE_Y_ID) && (GET_X_ID(get_hartid()) > SYNC_NODE_X_ID)) {  // Forth quadrant

        if (!(get_hartid() & sync_ohbit[get_hartid()])) {  // SRC
#if VERBOSE > 10
          printf("[DESCEND PHASE] Q4 SRC: sync_bit - %0d, sync_ohbit - 0x%0x, sync_mask - 0x%0x, sync_sign - 0x%0x\n",
            sync_bit[get_hartid()], sync_ohbit[get_hartid()], sync_mask[get_hartid()], sync_sign[get_hartid()]);
#endif
          // Send synchronization response to SRC: No need for AMOs (single source write)
          mmio32(SYNC_BASE + 4*sync_bit[get_hartid()] + (get_hartid() ^ sync_ohbit[get_hartid()])*L1_TILE_OFFSET) = 1;
          // amo_increment(SYNC_BASE + 4*sync_bit[get_hartid()] + (get_hartid() ^ sync_ohbit[get_hartid()])*L1_TILE_OFFSET, 1);
        } else {  // DST
#if VERBOSE > 10
          printf("[DESCEND PHASE] Q4 DST: sync_bit - %0d, sync_ohbit - 0x%0x, sync_mask - 0x%0x, sync_sign - 0x%0x\n",
            sync_bit[get_hartid()], sync_ohbit[get_hartid()], sync_mask[get_hartid()], sync_sign[get_hartid()]);
#endif
          // Wait for DST synchronization response
          do {
            sync_count[get_hartid()] = mmio32(SYNC_BASE + 4*sync_bit[get_hartid()] + get_hartid()*L1_TILE_OFFSET);
#if VERBOSE > 100
            printf("current sync_count: %0d\n", sync_count[get_hartid()]);
#endif
          } while (sync_count[get_hartid()] < 1);
          // Reset barrier counter
          mmio32(SYNC_BASE + 4*sync_bit[get_hartid()] + get_hartid()*L1_TILE_OFFSET) = 0;
        }
      }
      sync_bit[get_hartid()]   -= 1;
      sync_ohbit[get_hartid()] >>= 1;
      sync_mask[get_hartid()]  = sync_mask[get_hartid()] & ~(1 << sync_bit[get_hartid()]);
      sync_sign[get_hartid()]  = sync_sign[get_hartid()] & ~(1 << sync_bit[get_hartid()]);
    }
#if VERBOSE > 10
    printf("[DESCEND PHASE] END: sync_bit - %0d, sync_ohbit - 0x%0x, sync_mask - 0x%0x, sync_sign - 0x%0x\n",
      sync_bit[get_hartid()], sync_ohbit[get_hartid()], sync_mask[get_hartid()], sync_sign[get_hartid()]);
#endif

    // Instruction immediately following synchronization: indicates end of the synchronization region
    sentinel_end();
  }

  printf("NoC Synch test finished...\n");

  mmio16(TEST_END_ADDR + get_hartid()*2) = DEFAULT_EXIT_CODE - get_hartid();

  return 0;
}
