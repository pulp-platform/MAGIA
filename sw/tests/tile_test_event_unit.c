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
 *         Based on tile_test.c by Victor Isachi
 * 
 * MAGIA Tile Test - Event Unit WFE API Version
 * Uses event_unit_utils.h for Event Unit control and WFE/polling
 * 
 */

#include "magia_tile_utils.h"
#include "redmule_mm_utils.h"
#include "idma_mm_utils.h"
#include "event_unit_utils.h"

#include "x_input.h"
#include "w_input.h"
#include "y_input.h"
#include "z_output.h"

#define X_BASE (L1_BASE + 0x00012048)
#define W_BASE (L1_BASE + 0x00016048)
#define Y_BASE (L1_BASE + 0x0001A048)
#define Z_BASE (L2_BASE + 0x00042000)
#define V_BASE (L2_BASE + 0x00046000)
#define T_BASE (L2_BASE + 0x0004A000)

#define M_SIZE (96)
#define N_SIZE (64)
#define K_SIZE (64)

#define VERBOSE (0)

#define USE_WFE (0)

#define WAIT_CYCLES (10)

#define DIFF_TH (0x0011)

#define CONCURRENT

void idma_mv_in(unsigned int x_dim, unsigned int y_dim, uint16_t src_data[], uint32_t dst_address){
  uint32_t dst_addr;
  uint32_t src_addr;
  uint32_t len;

  // Initialize Event Unit once
  static int eu_initialized = 0;
  if (!eu_initialized) {
    eu_init();
    eu_initialized = 1;
  }

  for (int i = 0; i < x_dim*y_dim; i++)
    mmio16(T_BASE + 2*i) = src_data[i];

  dst_addr = (uint32_t)dst_address;
  src_addr = (uint32_t)T_BASE;
  len      = (uint32_t)(x_dim*y_dim*2); // 2 Bytes per element
#if VERBOSE > 10
  printf("dst_addr: 0x%8x\n", dst_addr);
  printf("src_addr: 0x%8x\n", src_addr);
  printf("len: %0d\n", len);
#endif

  uint32_t transfer_id = idma_L2ToL1(src_addr, dst_addr, len);

  // Clear Event Unit and ensure A2O mask is enabled
  eu_clear_events(0xFFFFFFFF);
  eu_enable_events(EU_IDMA_A2O_DONE_MASK);

  if (USE_WFE) {
    eu_idma_wait_a2o_completion(EU_WAIT_MODE_WFE);
  } else {
    eu_idma_wait_a2o_completion(EU_WAIT_MODE_POLLING);
  }

#if VERBOSE > 100
  for (int i = 0; i < x_dim*y_dim; i++)
    printf("DST[%8x]: 0x%4x\n", dst_address + 2*i, mmio16(dst_address + 2*i));
#endif

#if VERBOSE > 10
  unsigned int num_errors;
  num_errors = 0;
  for (int i = 0; i < x_dim*y_dim; i++) {
    if (mmio16(dst_address + 2*i) != src_data[i]) {
      num_errors++;
      printf("DST[%8x]: 0x%4x != SRC[%0d]: 0x%4x\n", dst_address + 2*i, mmio16(dst_address + 2*i), i, src_data[i]);
    }
  }
  printf("Detected %0d error(s) in the transfer...\n", num_errors);
#endif
}

void idma_mv_out(unsigned int x_dim, unsigned int y_dim, uint32_t src_address, uint32_t dst_address){
  uint32_t dst_addr;
  uint32_t src_addr;
  uint32_t len;

  dst_addr = (uint32_t)dst_address;
  src_addr = (uint32_t)src_address;
  len      = (uint32_t)(x_dim*y_dim*2); // 2 Bytes per element
#if VERBOSE > 10
  printf("dst_addr: 0x%8x\n", dst_addr);
  printf("src_addr: 0x%8x\n", src_addr);
  printf("len: %0d\n", len);
#endif

  uint32_t transfer_id = idma_L1ToL2(src_addr, dst_addr, len);

  // Clear Event Unit and ensure O2A mask is enabled
  eu_clear_events(0xFFFFFFFF);
  eu_enable_events(EU_IDMA_O2A_DONE_MASK);

  if (USE_WFE) {
    eu_idma_wait_o2a_completion(EU_WAIT_MODE_WFE);
  } else {
    eu_idma_wait_o2a_completion(EU_WAIT_MODE_POLLING);
  }

#if VERBOSE > 100
  for (int i = 0; i < x_dim*y_dim; i++)
    printf("DST[%8x]: 0x%4x\n", dst_address + 2*i, mmio16(dst_address + 2*i));
#endif

#if VERBOSE > 10
  unsigned int num_errors;
  num_errors = 0;
  for (int i = 0; i < x_dim*y_dim; i++) {
    if (mmio16(dst_address + 2*i) != mmio16(src_address + 2*i)) {
      num_errors++;
      printf("DST[%8x]: 0x%4x != SRC[%8x]: 0x%4x\n", dst_address + 2*i, mmio16(dst_address + 2*i), src_address + 2*i, mmio16(src_address + 2*i));
    }
  }
  printf("Detected %0d error(s) in the transfer...\n", num_errors);
#endif
}

int main(void) {
  // X
  printf("Initializing X through iDMA...\n");
  idma_mv_in(M_SIZE, N_SIZE, x_inp, X_BASE);

  // W
  printf("Initializing W through iDMA...\n");
  idma_mv_in(N_SIZE, K_SIZE, w_inp, W_BASE);

  // Y
  printf("Initializing Y through iDMA...\n");
  idma_mv_in(M_SIZE, K_SIZE, y_inp, Y_BASE);

  // Z - golden (reference)
  printf("Initializing Z - golden...\n");
  for (int i = 0; i < M_SIZE*K_SIZE; i++)
    mmio16(Z_BASE + 2*i) = z_oup[i];
#if VERBOSE > 100
  for (int i = 0; i < M_SIZE*K_SIZE; i++)
    printf("Z[%8x]: 0x%4x\n", Z_BASE + 2*i, mmio16(Z_BASE + 2*i));
#endif

#if VERBOSE > 10
  printf("K_SIZE: %4x\n", K_SIZE);
  printf("M_SIZE: %4x\n", M_SIZE);
  printf("N_SIZE: %4x\n", N_SIZE);  
#endif

  // Initialize and configure RedMulE using MM approach
  hwpe_cg_enable();
  hwpe_soft_clear();

  int offload_id_tmp;
  while ((offload_id_tmp = hwpe_acquire_job()) < 0)
    ;

  redmule_cfg((unsigned int)X_BASE, (unsigned int)W_BASE, (unsigned int)Y_BASE, 
              M_SIZE, N_SIZE, K_SIZE, (uint8_t)gemm_ops, (uint8_t)Float16);

  // Initialize Event Unit for RedMulE
  eu_redmule_init(USE_WFE);

  printf("Testing matrix multiplication with RedMulE...\n");
  hwpe_trigger_job();

  // Wait for HWPE completion using Event Unit
  if (USE_WFE) {
    eu_redmule_wait_completion(EU_WAIT_MODE_WFE);
  } else {
    eu_redmule_wait_completion(EU_WAIT_MODE_POLLING);
  }

  printf("Moving results through iDMA...\n");
  idma_mv_out(M_SIZE, K_SIZE, Y_BASE, V_BASE);

  printf("Verifying results...\n");
  
  unsigned int num_errors = 0;

  uint16_t computed, expected, diff;
  for(int i = 0; i < M_SIZE*K_SIZE; i++){
    computed = mmio16(V_BASE + 2*i);
    expected = mmio16(Z_BASE + 2*i);
    diff = (computed > expected) ? (computed - expected) : (expected - computed);
    if(diff > DIFF_TH){
      num_errors++;
      printf("**ERROR**: V[%8x](=0x%4x) != Z[%8x](=0x%4x)\n", V_BASE + 2*i, computed, Z_BASE + 2*i, expected);
    }
  }
  printf("Finished test with %0d errors\n", num_errors);

  uint32_t exit_code;
  if(num_errors)
    exit_code = FAIL_EXIT_CODE;
  else
    exit_code = PASS_EXIT_CODE;

  mmio16(TEST_END_ADDR) = exit_code;

  return 0;
}