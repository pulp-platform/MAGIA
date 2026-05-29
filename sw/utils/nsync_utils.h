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
 * MAGIA NoC/AMO-base Synchronization Utils
 */

#ifndef NSYNC_UTILS_H
#define NSYNC_UTILS_H

#include "magia_tile_utils.h"
#include "magia_utils.h"
#include "amo_utils.h"

#define SYNC_NODE_Y_ID      ((MESH_Y_TILES-1)/2)
#define SYNC_NODE_X_ID      ((MESH_X_TILES-1)/2)
#define SYNC_NODE_ID        (GET_ID(SYNC_NODE_Y_ID, SYNC_NODE_X_ID))
#define SYNC_GLOBAL_MAX_BIT (31-__builtin_clz(NUM_HARTS/2))
#define SYNC_ROW_START_BIT  (0)
#define SYNC_ROW_MAX_BIT    (30-__builtin_clz(MESH_X_TILES))
#define SYNC_COL_START_BIT  (31-__builtin_clz(MESH_X_TILES))
#define SYNC_COL_MAX_BIT    (30-__builtin_clz(NUM_HARTS))

void nsync_global(const uint32_t tile_hartid){

   uint32_t tile_xid = GET_X_ID(tile_hartid);
   uint32_t tile_yid = GET_Y_ID(tile_hartid);

#if NUM_HARTS <= 64
   // XY Algorithm

   uint32_t tile_1d_syncid = GET_ID(GET_Y_ID(tile_hartid), SYNC_NODE_X_ID);

   // Phase I - synchronize along X direction
   if (tile_xid != SYNC_NODE_X_ID){  // SRC
      // Send synchronization request to DST
      amo_increment(SYNC_BASE + tile_1d_syncid*L1_TILE_OFFSET, 1);

      // Wait for DST synchronization response
      while (mmio32(SYNC_BASE + tile_hartid*L1_TILE_OFFSET) < 1);

      // Reset barrier counter
      mmio32(SYNC_BASE + tile_hartid*L1_TILE_OFFSET) = 0;
   } else {  // DST
      // Wait for all SRCs to request synchronization
      while (mmio32(SYNC_BASE + tile_hartid*L1_TILE_OFFSET) < (MESH_X_TILES-1));

      // Phase II - synchronize along Y direction
      if (tile_hartid != SYNC_NODE_ID) { // SRC
         // Send synchronization request to DST
         amo_increment(SYNC_BASE + SYNC_NODE_ID*L1_TILE_OFFSET, 1);

         // Wait for DST synchronization response
         while (mmio32(SYNC_BASE + tile_hartid*L1_TILE_OFFSET) < MESH_X_TILES);

         // Reset barrier counter
         mmio32(SYNC_BASE + tile_hartid*L1_TILE_OFFSET) = 0;
      } else {  // DST
         // Wait for all SRCs to request synchronization
         while (mmio32(SYNC_BASE + tile_hartid*L1_TILE_OFFSET) < (MESH_X_TILES+MESH_Y_TILES-2));

         // Reset barrier counter
         mmio32(SYNC_BASE + tile_hartid*L1_TILE_OFFSET) = 0;
         
         // Send synchronization response to all SRCs
         for (int i = 0; i < SYNC_NODE_Y_ID; i++) amo_increment(SYNC_BASE + (GET_ID(i, SYNC_NODE_X_ID))*L1_TILE_OFFSET, 1);
         for (int i = SYNC_NODE_Y_ID+1; i < MESH_Y_TILES; i++) amo_increment(SYNC_BASE + (GET_ID(i, SYNC_NODE_X_ID))*L1_TILE_OFFSET, 1);
      }

      // Send synchronization response to all SRCs
      for (int i = 0; i < SYNC_NODE_X_ID; i++) amo_increment(SYNC_BASE + (GET_ID(tile_yid, i))*L1_TILE_OFFSET, 1);
      for (int i = SYNC_NODE_X_ID+1; i < MESH_X_TILES; i++) amo_increment(SYNC_BASE + (GET_ID(tile_yid, i))*L1_TILE_OFFSET, 1);
   }

#else
   // HyperSync Algorithm

   uint32_t q2_rootid = GET_ID(SYNC_NODE_Y_ID, SYNC_NODE_X_ID+1);
   uint32_t q3_rootid = GET_ID(SYNC_NODE_Y_ID+1, SYNC_NODE_X_ID);
   uint32_t q4_rootid = GET_ID(SYNC_NODE_Y_ID+1, SYNC_NODE_X_ID+1);

   uint32_t sync_bit   = 0;
   uint32_t sync_ohbit = 1;
   uint32_t sync_mask  = 0;
   uint32_t sync_sign  = 0;

   // Ascend tree
   while ((sync_bit < SYNC_GLOBAL_MAX_BIT) && ((tile_hartid & sync_mask) == sync_sign)) {
      // Ignore column quadrant bit
      if (sync_bit == SYNC_GLOBAL_MAX_BIT/2) {
         sync_bit   += 1;
         sync_ohbit <<= 1;
         continue;
      }

      if ((tile_yid <= SYNC_NODE_Y_ID) && (tile_xid <= SYNC_NODE_X_ID)) { // First quadrant

         if (tile_hartid & sync_ohbit) {  // DST
            // Wait for SRC to request synchronization
            while (mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) < 1);

            // Reset barrier counter
            mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) = 0;
         } else {  // SRC
            // Send synchronization request to DST: No need for AMOs (single source write)
            mmio32(SYNC_BASE + 4*sync_bit + (tile_hartid ^ sync_ohbit)*L1_TILE_OFFSET) = 1;
            // amo_increment(SYNC_BASE + 4*sync_bit + (tile_hartid ^ sync_ohbit)*L1_TILE_OFFSET, 1);
         }
         sync_sign = sync_sign | (1 << sync_bit);

      } else if ((tile_yid <= SYNC_NODE_Y_ID) && (tile_xid > SYNC_NODE_X_ID)) {  // Second quadrant

         if ((!(tile_hartid & sync_ohbit) && (sync_bit < (SYNC_GLOBAL_MAX_BIT/2))) || 
            ((tile_hartid & sync_ohbit) && (sync_bit >= (SYNC_GLOBAL_MAX_BIT/2)))) {  // DST
            // Wait for SRC to request synchronization
            while (mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) < 1);

            // Reset barrier counter
            mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) = 0;
         } else {  // SRC
            // Send synchronization request to DST: No need for AMOs (single source write)
            mmio32(SYNC_BASE + 4*sync_bit + (tile_hartid ^ sync_ohbit)*L1_TILE_OFFSET) = 1;
            // amo_increment(SYNC_BASE + 4*sync_bit + (tile_hartid ^ sync_ohbit)*L1_TILE_OFFSET, 1);
         }
         if (sync_bit >= (SYNC_GLOBAL_MAX_BIT/2))
            sync_sign = sync_sign | (1 << sync_bit);

      } else if ((tile_yid > SYNC_NODE_Y_ID) && (tile_xid <= SYNC_NODE_X_ID)) {  // Third quadrant

         if (((tile_hartid & sync_ohbit) && (sync_bit < (SYNC_GLOBAL_MAX_BIT/2))) || 
            (!(tile_hartid & sync_ohbit) && (sync_bit >= (SYNC_GLOBAL_MAX_BIT/2)))) {  // DST
            // Wait for SRC to request synchronization
            while (mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) < 1);

            // Reset barrier counter
            mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) = 0;
         } else {  // SRC
            // Send synchronization request to DST: No need for AMOs (single source write)
            mmio32(SYNC_BASE + 4*sync_bit + (tile_hartid ^ sync_ohbit)*L1_TILE_OFFSET) = 1;
            // amo_increment(SYNC_BASE + 4*sync_bit + (tile_hartid ^ sync_ohbit)*L1_TILE_OFFSET, 1);
         }
         if (sync_bit < (SYNC_GLOBAL_MAX_BIT/2))
            sync_sign = sync_sign | (1 << sync_bit);

      } else if ((tile_yid > SYNC_NODE_Y_ID) && (tile_xid > SYNC_NODE_X_ID)) {  // Forth quadrant

         if (!(tile_hartid & sync_ohbit)) {  // DST
            // Wait for SRC to request synchronization
            while (mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) < 1);

            // Reset barrier counter
            mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) = 0;
         } else {  // SRC
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
      
   // Synchronize root tree
   if ((tile_yid == SYNC_NODE_Y_ID+1) && (tile_xid == SYNC_NODE_X_ID+1)) { // Forth quadrant root
      // Send synchronization request to DST: No need for AMOs (single source write)
      mmio32(SYNC_BASE + 4*sync_bit + q3_rootid*L1_TILE_OFFSET) = 1;
      // amo_increment(SYNC_BASE + 4*sync_bit + q3_rootid*L1_TILE_OFFSET, 1);

      // Wait for DST synchronization response
      while (mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) < 1);
      
      // Reset barrier counter
      mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) = 0;

   } else if ((tile_yid == SYNC_NODE_Y_ID) && (tile_xid == SYNC_NODE_X_ID+1)) {  // Second quadrant root
      // Send synchronization request to DST: No need for AMOs (single source write)
      mmio32(SYNC_BASE + 4*sync_bit + SYNC_NODE_ID*L1_TILE_OFFSET) = 1;
      // amo_increment(SYNC_BASE + 4*sync_bit + SYNC_NODE_ID*L1_TILE_OFFSET, 1);

      // Wait for DST synchronization response
      while (mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) < 1);

      // Reset barrier counter
      mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) = 0;

   } else if ((tile_yid == SYNC_NODE_Y_ID+1) && (tile_xid == SYNC_NODE_X_ID)) {  // Third quadrant root
      // Wait for SRC to request synchronization
      while (mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) < 1);

      // Reset barrier counter
      mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) = 0;

      // Send synchronization request to DST: No need for AMOs (single source write)
      mmio32(SYNC_BASE + 4*(sync_bit+1) + SYNC_NODE_ID*L1_TILE_OFFSET) = 1;
      // amo_increment(SYNC_BASE + 4*(sync_bit+1) + SYNC_NODE_ID*L1_TILE_OFFSET, 1);

      // Wait for DST synchronization response
      while (mmio32(SYNC_BASE + 4*(sync_bit+1) + tile_hartid*L1_TILE_OFFSET) < 1);

      // Reset barrier counter
      mmio32(SYNC_BASE + 4*(sync_bit+1) + tile_hartid*L1_TILE_OFFSET) = 0;

      // Send synchronization response to SRC: No need for AMOs (single source write)
      mmio32(SYNC_BASE + 4*sync_bit + q4_rootid*L1_TILE_OFFSET) = 1;
      // amo_increment(SYNC_BASE + 4*sync_bit + q4_rootid*L1_TILE_OFFSET, 1);

   } else if ((tile_yid == SYNC_NODE_Y_ID) && (tile_xid == SYNC_NODE_X_ID)) {  // First quadrant root
      // Wait for SRC to request synchronization
      while (mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) < 1);

      // Reset barrier counter
      mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) = 0;

      // Wait for SRC to request synchronization
      while (mmio32(SYNC_BASE + 4*(sync_bit+1) + tile_hartid*L1_TILE_OFFSET) < 1);

      // Reset barrier counter
      mmio32(SYNC_BASE + 4*(sync_bit+1) + tile_hartid*L1_TILE_OFFSET) = 0;

      // Send synchronization response to SRC: No need for AMOs (single source write)
      mmio32(SYNC_BASE + 4*(sync_bit+1) + q3_rootid*L1_TILE_OFFSET) = 1;
      // amo_increment(SYNC_BASE + 4*(sync_bit+1) + q3_rootid*L1_TILE_OFFSET, 1);

      // Send synchronization response to SRC: No need for AMOs (single source write)
      mmio32(SYNC_BASE + 4*sync_bit + q2_rootid*L1_TILE_OFFSET) = 1;
      // amo_increment(SYNC_BASE + 4*sync_bit + q2_rootid*L1_TILE_OFFSET, 1);
   }

   // Descend tree
   sync_bit   -= 1;
   sync_ohbit >>= 1;
   sync_mask  = sync_mask & ~(1 << sync_bit);
   sync_sign  = sync_sign & ~(1 << sync_bit);
   while ((sync_bit < SYNC_GLOBAL_MAX_BIT) && ((tile_hartid & sync_mask) == sync_sign)) {
      // Ignore column quadrant bit
      if (sync_bit == SYNC_GLOBAL_MAX_BIT/2) {
         sync_bit   -= 1;
         sync_ohbit >>= 1;
         sync_mask  = sync_mask & ~(1 << sync_bit);
         sync_sign  = sync_sign & ~(1 << sync_bit);
         continue;
      }

      if ((tile_yid <= SYNC_NODE_Y_ID) && (tile_xid <= SYNC_NODE_X_ID)) { // First quadrant

         if (tile_hartid & sync_ohbit) {  // SRC
            // Send synchronization response to SRC: No need for AMOs (single source write)
            mmio32(SYNC_BASE + 4*sync_bit + (tile_hartid ^ sync_ohbit)*L1_TILE_OFFSET) = 1;
            // amo_increment(SYNC_BASE + 4*sync_bit + (tile_hartid ^ sync_ohbit)*L1_TILE_OFFSET, 1);
         } else {  // DST
            // Wait for DST synchronization response
            while (mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) < 1);

            // Reset barrier counter
            mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) = 0;
         }

      } else if ((tile_yid <= SYNC_NODE_Y_ID) && (tile_xid > SYNC_NODE_X_ID)) {  // Second quadrant

         if ((!(tile_hartid & sync_ohbit) && (sync_bit < (SYNC_GLOBAL_MAX_BIT/2))) || 
            ((tile_hartid & sync_ohbit) && (sync_bit >= (SYNC_GLOBAL_MAX_BIT/2)))) {  // SRC
            // Send synchronization response to SRC: No need for AMOs (single source write)
            mmio32(SYNC_BASE + 4*sync_bit + (tile_hartid ^ sync_ohbit)*L1_TILE_OFFSET) = 1;
            // amo_increment(SYNC_BASE + 4*sync_bit + (tile_hartid ^ sync_ohbit)*L1_TILE_OFFSET, 1);
         } else {  // DST
            // Wait for DST synchronization response
            while (mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) < 1);

            // Reset barrier counter
            mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) = 0;
         }

      } else if ((tile_yid > SYNC_NODE_Y_ID) && (tile_xid <= SYNC_NODE_X_ID)) {  // Third quadrant

         if (((tile_hartid & sync_ohbit) && (sync_bit < (SYNC_GLOBAL_MAX_BIT/2))) || 
            (!(tile_hartid & sync_ohbit) && (sync_bit >= (SYNC_GLOBAL_MAX_BIT/2)))) {  // SRC
            // Send synchronization response to SRC: No need for AMOs (single source write)
            mmio32(SYNC_BASE + 4*sync_bit + (tile_hartid ^ sync_ohbit)*L1_TILE_OFFSET) = 1;
            // amo_increment(SYNC_BASE + 4*sync_bit + (tile_hartid ^ sync_ohbit)*L1_TILE_OFFSET, 1);
         } else {  // DST
            // Wait for DST synchronization response
            while (mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) < 1);

            // Reset barrier counter
            mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) = 0;
         }

      } else if ((tile_yid > SYNC_NODE_Y_ID) && (tile_xid > SYNC_NODE_X_ID)) {  // Forth quadrant

         if (!(tile_hartid & sync_ohbit)) {  // SRC
            // Send synchronization response to SRC: No need for AMOs (single source write)
            mmio32(SYNC_BASE + 4*sync_bit + (tile_hartid ^ sync_ohbit)*L1_TILE_OFFSET) = 1;
            // amo_increment(SYNC_BASE + 4*sync_bit + (tile_hartid ^ sync_ohbit)*L1_TILE_OFFSET, 1);
         } else {  // DST
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

#endif

}

void nsync_row(const uint32_t tile_hartid){

   uint32_t tile_xid = GET_X_ID(tile_hartid);

   uint32_t sync_bit   = SYNC_ROW_START_BIT;
   uint32_t sync_ohbit = 1 << SYNC_ROW_START_BIT;
   uint32_t sync_mask  = 0;
   uint32_t sync_sign  = 0;

   // Ascend tree
   while ((sync_bit < SYNC_ROW_MAX_BIT) && ((tile_hartid & sync_mask) == sync_sign)){
      if (tile_xid <= SYNC_NODE_X_ID) { // Left half

         if (tile_hartid & sync_ohbit) { // DST
            // Wait for SRC to request synchronization
            while (mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) < 1);

            // Reset barrier counter
            mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) = 0;
         } else {  // SRC
            // Send synchronization request to DST: No need for AMOs (single source write)
            mmio32(SYNC_BASE + 4*sync_bit + (tile_hartid ^ sync_ohbit)*L1_TILE_OFFSET) = 1;
            // amo_increment(SYNC_BASE + 4*sync_bit + (tile_hartid ^ sync_ohbit)*L1_TILE_OFFSET, 1);
         }
         sync_sign = sync_sign | (1 << sync_bit);

      } else {  // Right half

         if (!(tile_hartid & sync_ohbit)) {  // DST
            // Wait for SRC to request synchronization
            while (mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) < 1);

            // Reset barrier counter
            mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) = 0;
         } else {  // SRC
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
    
   // Synchronize root nodes
   if ((tile_hartid & sync_mask) == sync_sign) { // Root nodes
      if (!(tile_hartid & sync_ohbit)) {  // DST
         // Wait for SRC to request synchronization
         while (mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) < 1);

         // Reset barrier counter
         mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) = 0;

         // Send synchronization response to SRC: No need for AMOs (single source write)
         mmio32(SYNC_BASE + 4*sync_bit + (tile_hartid+1)*L1_TILE_OFFSET) = 1;
         // amo_increment(SYNC_BASE + 4*sync_bit + (tile_hartid+1)*L1_TILE_OFFSET, 1);
      } else {  // SRC
         // Send synchronization request to DST: No need for AMOs (single source write)
         mmio32(SYNC_BASE + 4*sync_bit + (tile_hartid-1)*L1_TILE_OFFSET) = 1;
         // amo_increment(SYNC_BASE + 4*sync_bit + (tile_hartid-1)*L1_TILE_OFFSET, 1);

         // Wait for DST synchronization response
         while (mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) < 1);

         // Reset barrier counter
         mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) = 0;
      }
   }

   // Descend tree
   sync_bit   -= 1;
   sync_ohbit >>= 1;
   sync_mask  = sync_mask & ~(1 << sync_bit);
   sync_sign  = sync_sign & ~(1 << sync_bit);
   while ((sync_bit < SYNC_ROW_MAX_BIT) && ((tile_hartid & sync_mask) == sync_sign)) {
      if (tile_xid <= SYNC_NODE_X_ID) { // Left half

         if (tile_hartid & sync_ohbit) {  // SRC
            // Send synchronization response to SRC: No need for AMOs (single source write)
            mmio32(SYNC_BASE + 4*sync_bit + (tile_hartid ^ sync_ohbit)*L1_TILE_OFFSET) = 1;
            // amo_increment(SYNC_BASE + 4*sync_bit + (tile_hartid ^ sync_ohbit)*L1_TILE_OFFSET, 1);
         } else {  // DST
            // Wait for DST synchronization response
            while (mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) < 1);

            // Reset barrier counter
            mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) = 0;
         }

      } else {  // Right half

         if (!(tile_hartid & sync_ohbit)) {  // SRC
            // Send synchronization response to SRC: No need for AMOs (single source write)
            mmio32(SYNC_BASE + 4*sync_bit + (tile_hartid ^ sync_ohbit)*L1_TILE_OFFSET) = 1;
            // amo_increment(SYNC_BASE + 4*sync_bit + (tile_hartid ^ sync_ohbit)*L1_TILE_OFFSET, 1);
         } else {  // DST
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

}

void nsync_col(const uint32_t tile_hartid){

   uint32_t tile_yid = GET_Y_ID(tile_hartid);

#if NUM_HARTS <= 64
   // Naive Algorithm

   uint32_t tile_xid = GET_X_ID(tile_hartid);
    
   if (tile_yid == SYNC_NODE_Y_ID) { // DST
      // Wait for all SRCs to request synchronization
      while (mmio32(SYNC_BASE + tile_hartid*L1_TILE_OFFSET) < MESH_Y_TILES-1);

      // Reset barrier counter
      mmio32(SYNC_BASE + tile_hartid*L1_TILE_OFFSET) = 0;

      // Send synchronization response to all SRCs
      for (int i = 0; i < SYNC_NODE_Y_ID; i++) amo_increment(SYNC_BASE + (GET_ID(i, tile_xid))*L1_TILE_OFFSET, 1);
      for (int i = SYNC_NODE_Y_ID+1; i < MESH_Y_TILES; i++) amo_increment(SYNC_BASE + (GET_ID(i, tile_xid))*L1_TILE_OFFSET, 1);
   } else { // SRC
      // Send synchronization request to DST
      amo_increment(SYNC_BASE + (GET_ID(SYNC_NODE_Y_ID, tile_xid))*L1_TILE_OFFSET, 1);

      // Wait for DST synchronization response
      while (mmio32(SYNC_BASE + tile_hartid*L1_TILE_OFFSET) < 1);

      // Reset barrier counter
      mmio32(SYNC_BASE + tile_hartid*L1_TILE_OFFSET) = 0;
   }

#else
   // HyperSync Algorithm

   uint32_t sync_bit   = SYNC_COL_START_BIT;
   uint32_t sync_ohbit = 1 << SYNC_COL_START_BIT;
   uint32_t sync_mask  = 0;
   uint32_t sync_sign  = 0;
    
   // Ascend tree
   while ((sync_bit < SYNC_COL_MAX_BIT) && ((tile_hartid & sync_mask) == sync_sign)){
      if (tile_yid <= SYNC_NODE_Y_ID) { // Top half

         if (tile_hartid & sync_ohbit) { // DST
            // Wait for SRC to request synchronization
            while (mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) < 1);

            // Reset barrier counter
            mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) = 0;
         } else {  // SRC
            // Send synchronization request to DST: No need for AMOs (single source write)
            mmio32(SYNC_BASE + 4*sync_bit + (tile_hartid ^ sync_ohbit)*L1_TILE_OFFSET) = 1;
            // amo_increment(SYNC_BASE + 4*sync_bit + (tile_hartid ^ sync_ohbit)*L1_TILE_OFFSET, 1);
         }
         sync_sign = sync_sign | (1 << sync_bit);

      } else {  // Bottom half

         if (!(tile_hartid & sync_ohbit)) {  // DST
            // Wait for SRC to request synchronization
            while (mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) < 1);

            // Reset barrier counter
            mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) = 0;
         } else {  // SRC
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

   // Synchronize root nodes
   if ((tile_hartid & sync_mask) == sync_sign) { // Root nodes
      if (!(tile_hartid & sync_ohbit)) {  // DST
         // Wait for SRC to request synchronization
         while (mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) < 1);

         // Reset barrier counter
         mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) = 0;

         // Send synchronization response to SRC: No need for AMOs (single source write)
         mmio32(SYNC_BASE + 4*sync_bit + (tile_hartid+MESH_X_TILES)*L1_TILE_OFFSET) = 1;
         // amo_increment(SYNC_BASE + 4*sync_bit + (tile_hartid+MESH_X_TILES)*L1_TILE_OFFSET, 1);
      } else {  // SRC
         // Send synchronization request to DST: No need for AMOs (single source write)
         mmio32(SYNC_BASE + 4*sync_bit + (tile_hartid-MESH_X_TILES)*L1_TILE_OFFSET) = 1;
         // amo_increment(SYNC_BASE + 4*sync_bit + (tile_hartid-MESH_X_TILES)*L1_TILE_OFFSET, 1);

         // Wait for DST synchronization response
         while (mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) < 1);

         // Reset barrier counter
         mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) = 0;
      }
   }

   // Descend tree
   sync_bit   -= 1;
   sync_ohbit >>= 1;
   sync_mask  = sync_mask & ~(1 << sync_bit);
   sync_sign  = sync_sign & ~(1 << sync_bit);
   while ((sync_bit < SYNC_COL_MAX_BIT) && ((tile_hartid & sync_mask) == sync_sign)) {
      if (tile_yid <= SYNC_NODE_Y_ID) { // Top half

         if (tile_hartid & sync_ohbit) {  // SRC
            // Send synchronization response to SRC: No need for AMOs (single source write)
            mmio32(SYNC_BASE + 4*sync_bit + (tile_hartid ^ sync_ohbit)*L1_TILE_OFFSET) = 1;
            // amo_increment(SYNC_BASE + 4*sync_bit + (tile_hartid ^ sync_ohbit)*L1_TILE_OFFSET, 1);
         } else {  // DST
            // Wait for DST synchronization response
            while (mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) < 1);

            // Reset barrier counter
            mmio32(SYNC_BASE + 4*sync_bit + tile_hartid*L1_TILE_OFFSET) = 0;
         }

      } else {  // Bottom half

         if (!(tile_hartid & sync_ohbit)) {  // SRC
            // Send synchronization response to SRC: No need for AMOs (single source write)
            mmio32(SYNC_BASE + 4*sync_bit + (tile_hartid ^ sync_ohbit)*L1_TILE_OFFSET) = 1;
            // amo_increment(SYNC_BASE + 4*sync_bit + (tile_hartid ^ sync_ohbit)*L1_TILE_OFFSET, 1);
         } else {  // DST
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

#endif

}

#endif /*NSYNC_UTILS_H*/