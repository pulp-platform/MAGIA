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
 * 
 * MAGIA Event Unit Tile Stress Test - Event Unit WFE API Version
 * Uses event_unit_utils.h for Event Unit control and WFE/polling
 * Tests concurrent RedMulE and IDMA operations with out-of-order completions
 * 
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "redmule_mm_utils.h"
#include "idma_mm_utils.h"
#include "event_unit_utils.h"

#include "x_input.h"
#include "w_input.h"
#include "y_input.h"
#include "z_output.h"

#define X_BASE_1 (L1_BASE + 0x00012048)
#define W_BASE_1 (L1_BASE + 0x00016048)
#define Y_BASE_1 (L1_BASE + 0x0001A048)
#define X_BASE_2 (L1_BASE + 0x0001E048)
#define W_BASE_2 (L1_BASE + 0x00022048)
#define Y_BASE_2 (L1_BASE + 0x00026048)

#define Z_BASE_1 (L2_BASE + 0x00001000)
#define Z_BASE_2 (L2_BASE + 0x00005000)
#define Z_BASE_4 (L2_BASE + 0x0000D000)

#define DMA_BUFFER_1 (L1_BASE + 0x00036048)
#define DMA_BUFFER_2 (L1_BASE + 0x0003A048)

#define M_SIZE (96)
#define N_SIZE (64)
#define K_SIZE (64)

#define VERBOSE (1)

#define USE_WFE (1)

#define WAIT_CYCLES (10)

#define DIFF_TH (0x0011)

#define DMA_CHUNK_SIZE (M_SIZE * N_SIZE * 2)

int main(void) {
  uint32_t dst_addr;
  uint32_t src_addr;
  uint32_t len;
  
  uint32_t redmule_completed = 0;
  uint32_t idma_a2o_completed = 0;
  uint32_t idma_o2a_completed = 0;
  
  // Initialize Event Unit once
  eu_init();

  // Setup test data
  printf("Setting up test data...\n");
  
  // X matrix for RedMulE
  for (int i = 0; i < M_SIZE*N_SIZE; i++)
    mmio16(X_BASE_1 + 2*i) = x_inp[i];

  // W matrix for RedMulE  
  for (int i = 0; i < N_SIZE*K_SIZE; i++)
    mmio16(W_BASE_1 + 2*i) = w_inp[i];

  // Y matrix (accumulator) for RedMulE
  for (int i = 0; i < M_SIZE*K_SIZE; i++)
    mmio16(Y_BASE_1 + 2*i) = y_inp[i];

  // Z - golden (reference) for RedMulE
  for (int i = 0; i < M_SIZE*K_SIZE; i++)
    mmio16(Z_BASE_1 + 2*i) = z_oup[i];

  // Initialize IDMA test data
  for (int i = 0; i < DMA_CHUNK_SIZE/2; i++) {
    uint16_t test_pattern = (uint16_t)(0x1000 + (i & 0xFFF));
    mmio16(Z_BASE_4 + 2*i) = test_pattern;
  }

#if VERBOSE > 10
  printf("Test data setup complete\n");
#endif

  printf("Testing concurrent RedMulE and IDMA operations...\n");
  
  // Initialize Event Unit BEFORE launching operations
  eu_multi_init(1, 1, 1, 0, USE_WFE); // Enable RedMulE, IDMA A2O, IDMA O2A, disable FSync
  
  // Launch RedMulE operation
  printf("Launching RedMulE operation...\n");
  hwpe_cg_enable();
  hwpe_soft_clear();

  int offload_id_tmp;
  while ((offload_id_tmp = hwpe_acquire_job()) < 0)
    ;

  redmule_cfg((unsigned int)X_BASE_1, (unsigned int)W_BASE_1, (unsigned int)Y_BASE_1, 
              M_SIZE, N_SIZE, K_SIZE, (uint8_t)gemm_ops, (uint8_t)Float16);

  // Launch IDMA operations
  printf("Launching IDMA operations...\n");
  
  // First IDMA transfer: L2 to L1
  dst_addr = (uint32_t)DMA_BUFFER_1;
  src_addr = (uint32_t)Z_BASE_4;
  len      = (uint32_t)DMA_CHUNK_SIZE;

  uint32_t transfer_id_1 = idma_L2ToL1(src_addr, dst_addr, len);

 
  // Second IDMA transfer: L1 to L2
  dst_addr = (uint32_t)Z_BASE_2;
  src_addr = (uint32_t)DMA_BUFFER_1;
  len      = (uint32_t)DMA_CHUNK_SIZE;
 
  uint32_t transfer_id_2 = idma_L1ToL2(src_addr, dst_addr, len);
  printf("iDMA transfer 2 (L1->L2) started, ID: %d\n", transfer_id_2);

  // Trigger RedMulE after IDMA to create concurrency
  hwpe_trigger_job();

  // Wait for ALL accelerators using eu_multi_wait_all - elegante!
  printf("Waiting for ALL accelerators completion (RedMulE + IDMA A2O + IDMA O2A)...\n");
  
  eu_wait_mode_t wait_mode = USE_WFE ? EU_WAIT_MODE_WFE : EU_WAIT_MODE_POLLING;
  uint32_t all_events = eu_multi_wait_all(1, 1, 1, 0, wait_mode);
  
  // eu_multi_wait_all returns only when ALL events are present (or 0 on timeout)
  if (all_events) {
    redmule_completed = 1;
    idma_a2o_completed = 1;
    idma_o2a_completed = 1;
  }
  // If all_events == 0, it means timeout occurred

  // Check for timeout
  if (!(redmule_completed && idma_a2o_completed && idma_o2a_completed)) {
    mmio16(TEST_END_ADDR) = FAIL_EXIT_CODE;
    return 1;
  }

  // Disable RedMulE
  hwpe_cg_disable();
  
  unsigned int num_errors = 0;

  // Verify RedMulE results
  uint16_t computed, expected, diff;
  for(int i = 0; i < M_SIZE*K_SIZE; i++){
    computed = mmio16(Y_BASE_1 + 2*i);
    expected = mmio16(Z_BASE_1 + 2*i);
    diff = (computed > expected) ? (computed - expected) : (expected - computed);
    if(diff > DIFF_TH){
      num_errors++;
    }
  }

  // Verify IDMA results (basic integrity check)
  uint32_t idma_errors = 0;
  for(int i = 0; i < 100; i++) { // Check first 100 elements
    uint16_t source_data = mmio16(Z_BASE_4 + 2*i);
    uint16_t copied_data = mmio16(DMA_BUFFER_1 + 2*i);
    if(source_data != copied_data) {
      idma_errors++;
    }
  }
  
  num_errors += idma_errors;

  // Event Unit integrity check
  if (!(redmule_completed && idma_a2o_completed && idma_o2a_completed)) {
    num_errors++;
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