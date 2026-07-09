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
 * MAGIA Broscast test over iDMA using Memory-Mapped Control
 */
#include "magia_utils.h"
#include "magia_tile_utils.h"
#include "idma_mm_utils.h"
#include "magia_coll_utils.h"

#include "x_input.h"

#define X_BASE (L1_BASE + 0x00012048)
#define Y_BASE (L1_BASE + 0x00016048)
#define Z_BASE (L2_BASE + 0x00001000)

#define M_SIZE (16)
#define N_SIZE (16)

#define VERBOSE (0)

#define END_OF_TEST_OFFSET (0x0)
#define END_PATTERN (0xCCAA)

#define SOURCE_HART_ID 3

int main(void) {

  uint32_t dst_addr;
  uint32_t src_addr;
  uint32_t broad_addr;
  uint32_t len;
  uint32_t mask;
  uint32_t collective_op;

  if(get_hartid() == SOURCE_HART_ID) {

  // ******** WRITING DATA TO L2 MEMORY ******** //
    printf("Before writing data to memory...\n");
    for (int i = 0; i < M_SIZE*N_SIZE; i++)
      mmio16(Z_BASE + 2*i) = x_inp[i];

    dst_addr   = (uint32_t)(X_BASE + get_hartid()*L1_TILE_OFFSET);
    src_addr   = (uint32_t)(Z_BASE);
    len        = (uint32_t)(M_SIZE*N_SIZE*2); // 2 Bytes per element
    broad_addr = (uint32_t)(X_BASE + get_hartid()*L1_TILE_OFFSET);

  // ******** MOVING DATA FROM L2 TO L1 TILE 0 MEMORY ******** //
  #if VERBOSE > 10
    printf("dst_addr: 0x%8x (X_BASE)\n", dst_addr);
    printf("src_addr: 0x%8x (Z_BASE)\n", src_addr);
    printf("len: %0d\n", len);
  #endif

    uint32_t transfer_id_0 = idma_L2ToL1(src_addr, dst_addr, len);
    printf("iDMA moving data from L2 to L1...\n");

    // Use polling to wait for completion
    dma_wait(transfer_id_0);


    // **************** BROADCASTING ************** //
    uint32_t transfer_id_1 = broadcast(dst_addr, broad_addr, len, gen_collective_mask(ROW), MULTICAST);
    printf("Multicast over the row...\n");

    // Use polling to wait for completion
    dma_wait(transfer_id_1);

    // Inform all the cores about the newly arrived data
    printf("Sending end of test signal...\n");
    set_collective_mask(gen_collective_mask(ROW));
    set_collective_op(MULTICAST);
    *(volatile int*) (COLLECTIVE_ADDR_OFFSET + get_hartid()*L1_TILE_OFFSET + L1_BASE + END_OF_TEST_OFFSET) = (int) END_PATTERN;


  } else {
    if(GET_Y_ID(get_hartid()) == GET_Y_ID(SOURCE_HART_ID)){
      
      printf("Destination of the multicast...\n");
      // Polling on the end_of_test address offset
      while(*(volatile int*) (L1_BASE + get_hartid()*L1_TILE_OFFSET + END_OF_TEST_OFFSET) != (int) END_PATTERN) {};

      uint16_t detected_l1, detected_l2, expected;
      unsigned int num_errors = 0;
      for(int i = 0; i < M_SIZE*N_SIZE; i++){
        detected_l1 = mmio16(X_BASE + get_hartid()*L1_TILE_OFFSET + 2*i);
        expected = mmio16(Z_BASE + 2*i);
        if(detected_l1 != expected){
          num_errors++;
          printf("**ERROR**: DETECTED L1[%0d](=0x%4x) != EXPECTED[%0d](=0x%4x)\n", i, detected_l1, i, expected);
        }
      }
      printf("Finished test with %0d errors\n", num_errors);
    }
  }
  return 0;
}