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

#include "x_input.h"

//#define X_BASE (L1_BASE + 0x00012048)
#define X_BASE (L1_BASE + 0x00112048)
#define Y_BASE (L1_BASE + 0x00016048)
#define Z_BASE (L2_BASE + 0x00001000)
#define W_BASE (L2_BASE + 0x00005000)

#define M_SIZE (16)
#define N_SIZE (16)

#define VERBOSE (0)

#define WAIT_CYCLES (10)

#define CONCURRENT

#define MEM_OFFSET (0x1000)
#define MHARTID_OFFSET (0x00100000)

int main(void) {

  uint32_t dst_addr;
  uint32_t src_addr;
  uint32_t broad_addr;
  uint32_t len;
  uint32_t mask;
  uint32_t collective_op;

  if(get_hartid() == 0) {

  // ******** WRITING DATA TO L2 MEMORY ******** //
    printf("Before writing data to memory...\n");
    for (int i = 0; i < M_SIZE*N_SIZE; i++)
      mmio16(Z_BASE + 2*i) = x_inp[i];

    dst_addr   = (uint32_t)(X_BASE);
    src_addr   = (uint32_t)Z_BASE;
    len        = (uint32_t)(M_SIZE*N_SIZE*2); // 2 Bytes per element
    broad_addr = (uint32_t)(X_BASE);

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
    if(NUM_HARTS==4)
      mask = 0x00300000;
    else if(NUM_HARTS==16)
      mask = 0x00F00000;
    else if(NUM_HARTS==64)
      mask = 0x00F00000;
    else if(NUM_HARTS==256)
      mask = 0x00F00000;
    else
      mask = 0x00F00000;

    collective_op = 0x1; // 0x0 Unicast; 0x1 Multicast
    uint32_t transfer_id_1 = broadcast(dst_addr, broad_addr, len, mask, collective_op);
    printf("Broadcasting...\n");

    // Use polling to wait for completion
    dma_wait(transfer_id_1);

    printf("End of test...\n");

  }
  return 0;
}