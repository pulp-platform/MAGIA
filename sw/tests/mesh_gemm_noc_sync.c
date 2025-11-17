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
 * MAGIA MeshGeMM NoC Synchronization Test
 */

#include "magia_tile_utils.h"
#include "magia_utils.h"
#include "magia_sentinel_utils.h"
#include "cache_fill.h"

#define VERBOSE (0)

#define GEMM_WIDTH (MESH_X_TILES)
#define GEMM_MAX(x, y) (((int)(x) > (int)(y)) ? (x) : (y))
#define GEMM_MIN(x, y) (((int)(x) < (int)(y)) ? (x) : (y))
#define GEMM_GTH(x, y, t) (((int)(x) >= (int)(t)) ? (x) : (y))
#define GEMM_LTH(x, y, t) (((int)(x) <= (int)(t)) ? (x) : (y))
#define SYNC_SRC_H (SYNC_BASE + 0x0)
#define SYNC_DST_H (SYNC_BASE + 0x4)
#define SYNC_SRC_V (SYNC_BASE + 0x8)
#define SYNC_DST_V (SYNC_BASE + 0xC)

#define CACHE_HEAT_CYCLES (3)

// #define BARRIER
#define SEMAPHORE

static inline void h_pair_sync_wait(volatile uint32_t id){
    // Wait for horizontal data to be ready
    csem_wait(SYNC_SRC_H + id*L1_TILE_OFFSET);
    csem_wait(SYNC_DST_H + id*L1_TILE_OFFSET);
}

static inline void h_pair_sync_signal(volatile uint32_t src_id, volatile uint32_t dst_id){
    // Signal that horizontal data is ready
    csem_signal(SYNC_SRC_H + src_id*L1_TILE_OFFSET);
    csem_signal(SYNC_DST_H + dst_id*L1_TILE_OFFSET);
}

static inline void v_pair_sync_wait(volatile uint32_t id){
    // Wait for vertical data to be ready
    csem_wait(SYNC_SRC_V + id*L1_TILE_OFFSET);
    csem_wait(SYNC_DST_V + id*L1_TILE_OFFSET);
}

static inline void v_pair_sync_signal(volatile uint32_t src_id, volatile uint32_t dst_id){
    // Signal that vertical data is ready
    csem_signal(SYNC_SRC_V + src_id*L1_TILE_OFFSET);
    csem_signal(SYNC_DST_V + dst_id*L1_TILE_OFFSET);
}

int main(void) {
  uint32_t tile_hartid = get_hartid();
  uint32_t y_id = GET_Y_ID(tile_hartid);
  uint32_t x_id = GET_X_ID(tile_hartid);

  int32_t index = ((y_id+1)/2)*(y_id%2 ? -1 : 1) + ((x_id+1)/2)*(x_id%2 ? -1 : 1);
  index = index < 0 ? index+GEMM_WIDTH : index;
  index = index >= GEMM_WIDTH/2 ? GEMM_WIDTH-(2*index-GEMM_WIDTH+1) : 2*index;

  uint32_t mesh_dst_x_id = x_id%2 ? GEMM_MAX(x_id-2, 0) : GEMM_MIN(x_id+2, GEMM_WIDTH-1);
  uint32_t mesh_dst_y_id = y_id%2 ? GEMM_MAX(y_id-2, 0) : GEMM_MIN(y_id+2, GEMM_WIDTH-1);
  uint32_t mesh_src_x_id = x_id%2 ? GEMM_LTH(x_id+2, GEMM_WIDTH-2, GEMM_WIDTH-1) : GEMM_GTH(x_id-2, 1, 0);
  uint32_t mesh_src_y_id = y_id%2 ? GEMM_LTH(y_id+2, GEMM_WIDTH-2, GEMM_WIDTH-1) : GEMM_GTH(y_id-2, 1, 0);
  uint32_t horizontal_dst_id = GET_ID(y_id, mesh_dst_x_id);
  uint32_t vertical_dst_id = GET_ID(mesh_dst_y_id, x_id);
  uint32_t horizontal_src_id = GET_ID(y_id, mesh_src_x_id);
  uint32_t vertical_src_id = GET_ID(mesh_src_y_id, x_id);

  printf("Starting NoC Synch test...\n");

  printf("Running MeshGeMM algorithm...\n");

  // Filling up the cache
  fill_icache();
  
  // Execute synchronization multiple times to pre-heat the cache
  for (int i = 0; i < CACHE_HEAT_CYCLES; i++) {
    // Instruction immediately preceding synchronization: indicates start of the synchronization region
    stnl_snc_s();

#ifdef BARRIER
    if (tile_hartid == 15) { // DST
      // Wait for all SRCs to request synchronization
      while (mmio32(SYNC_BASE + tile_hartid*L1_TILE_OFFSET) < 4);

      // Reset barrier counter
      mmio32(SYNC_BASE + tile_hartid*L1_TILE_OFFSET) = 0;

      // Send synchronization response to all SRCs
      amo_increment(SYNC_BASE +  7*L1_TILE_OFFSET, 1);
      amo_increment(SYNC_BASE + 11*L1_TILE_OFFSET, 1);
      amo_increment(SYNC_BASE + 13*L1_TILE_OFFSET, 1);
      amo_increment(SYNC_BASE + 14*L1_TILE_OFFSET, 1);
    } else if ((tile_hartid == 7) || (tile_hartid == 11) || (tile_hartid == 13) || (tile_hartid == 14)) {  // SRCs
      // Send synchronization request to DST
      amo_increment(SYNC_BASE + 15*L1_TILE_OFFSET, 1);

      // Wait for DST synchronization response
      while (mmio32(SYNC_BASE + tile_hartid*L1_TILE_OFFSET) < 1);

      // Reset barrier counter
      mmio32(SYNC_BASE + tile_hartid*L1_TILE_OFFSET) = 0;
    }
#endif
#ifdef SEMAPHORE
    // Signal data ready to horizontal neighbors
    h_pair_sync_signal(horizontal_src_id, horizontal_dst_id);
    // Signal data ready to vertical neighbors
    v_pair_sync_signal(vertical_src_id, vertical_dst_id);
    // Wait for horizontal neighbors to be ready
    h_pair_sync_wait(tile_hartid);
    // Wait for vertical neighbors to be ready
    v_pair_sync_wait(tile_hartid);
#endif

    // Instruction immediately following synchronization: indicates end of the synchronization region
    stnl_snc_f();
  }

  printf("NoC Synch test finished...\n");

  return 0;
}
