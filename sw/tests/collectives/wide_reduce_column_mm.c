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
 * Authors: Luca Balboni <luca.balboni10@studio.unibo.it>
 *         Based on idma_test.c by Victor Isachi
 * 
 * MAGIA Broadcast test over iDMA using Memory-Mapped Control
 */
#include "magia_utils.h"
#include "magia_tile_utils.h"
#include "idma_mm_utils.h"
#include "magia_coll_utils.h"

#include "x_input.h"

#define X_BASE (L1_BASE + 0x00012000)
#define Y_BASE (L1_BASE + 0x00016048)
#define Z_BASE (L2_BASE + 0x00001000)

#define REDUCE_OFFSET 0x1000

#define TRANSFER_SIZE (16)

#define VERBOSE (11)

#define END_OF_TEST_OFFSET (0x0)
#define END_PATTERN (0xCCAA)

#define DESTINATION_HART_ID 0

#define MHARTID_OFFSET (0x0001000)

int main(void) {

  uint32_t dst_addr;
  uint32_t src_addr;
  uint32_t reduce_addr;
  uint32_t len;
  uint32_t mask;
  uint32_t collective_op;
  uint32_t unreduced_data = 100;
  uint32_t reduced_data;

  
  if(GET_X_ID(get_hartid()) == GET_X_ID(DESTINATION_HART_ID)) {

    printf("Writing data in L2 memory...\n");

    mmio32(Z_BASE + get_hartid()*MHARTID_OFFSET) = unreduced_data;

    dst_addr    = (uint32_t)(X_BASE + get_hartid()*L1_TILE_OFFSET);
    src_addr    = (uint32_t)(Z_BASE + get_hartid()*MHARTID_OFFSET);
    len         = (uint32_t)(TRANSFER_SIZE);
    reduce_addr = (uint32_t)(X_BASE + DESTINATION_HART_ID*L1_TILE_OFFSET + REDUCE_OFFSET);

    #if VERBOSE > 10
      printf("dst_addr: 0x%8x (X_BASE)\n", dst_addr);
      printf("src_addr: 0x%8x (Z_BASE)\n", src_addr);
      printf("len: %0d\n", len);
    #endif
    
    printf("iDMA moving data from L2 to L1...\n");
    uint32_t transfer_id_0 = idma_L2ToL1(src_addr, dst_addr, len);
    dma_wait(transfer_id_0);
  }


  // ******** INT SUM TEST ******** //
  if(GET_X_ID(get_hartid()) == GET_X_ID(DESTINATION_HART_ID)) {
    printf("Summing...\n");
    uint32_t transfer_id_1 = collective(dst_addr, reduce_addr, len, gen_collective_mask(COLUMN), INT_ADD);
    dma_wait(transfer_id_1);
  }
  if(get_hartid() == DESTINATION_HART_ID){
    reduced_data = unreduced_data * MESH_X_TILES;
    while(*(volatile int*) (X_BASE + DESTINATION_HART_ID*L1_TILE_OFFSET + REDUCE_OFFSET) != reduced_data) {};
    printf("SUM TEST PASSED\n");
  }


  // ******** MUL SUM TEST ******** //
  if(GET_X_ID(get_hartid()) == GET_X_ID(DESTINATION_HART_ID)) {
    printf("Multiplying...\n");
    uint32_t transfer_id_1 = collective(dst_addr, reduce_addr, len, gen_collective_mask(COLUMN), INT_MUL);
    dma_wait(transfer_id_1);
  }
  if(get_hartid() == DESTINATION_HART_ID){
    reduced_data = unreduced_data;
    
    for(int i = 0; i < (MESH_X_TILES-1); i++)
      reduced_data = reduced_data*unreduced_data;

    while(*(volatile int*) (X_BASE + DESTINATION_HART_ID*L1_TILE_OFFSET + REDUCE_OFFSET) != (int)reduced_data) {};
    printf("MUL TEST PASSED\n");
  }

  return 0;
}