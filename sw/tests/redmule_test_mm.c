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
 * Authors: 
 * 
 * RedMulE Matrix Multiplication Test with MMIO HWPE Control Functions
 * 
 * This test uses MMIO functions for HWPE control and simplified IRQ management
 * copied from redmule_test.c for better reliability.
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "redmule_mm_utils.h"

#include "x_input.h"
#include "w_input.h"
#include "y_input.h"
#include "z_output.h"

#define X_BASE (L1_BASE + 0x00012048)
#define W_BASE (L1_BASE + 0x00016048)
#define Y_BASE (L1_BASE + 0x0001A048)
#define Z_BASE (L2_BASE + 0x00042000)

#define M_SIZE (96)
#define N_SIZE (64)
#define K_SIZE (64)

#define VERBOSE (0)

#define IRQ_EN

#define WAIT_CYCLES (10)

#define DIFF_TH (0x0011)

int main(void) {
  // X
  for (int i = 0; i < M_SIZE*N_SIZE; i++)
    mmio16(X_BASE + 2*i) = x_inp[i];
#if VERBOSE > 10
  for (int i = 0; i < M_SIZE*N_SIZE; i++)
    printf("X[%8x]: 0x%4x\n", X_BASE + 2*i, mmio16(X_BASE + 2*i));
#endif

  // W
  for (int i = 0; i < N_SIZE*K_SIZE; i++)
    mmio16(W_BASE + 2*i) = w_inp[i];
#if VERBOSE > 10
  for (int i = 0; i < N_SIZE*K_SIZE; i++)
    printf("W[%8x]: 0x%4x\n", W_BASE + 2*i, mmio16(W_BASE + 2*i));
#endif

// Y
  for (int i = 0; i < M_SIZE*K_SIZE; i++)
    mmio16(Y_BASE + 2*i) = y_inp[i];
#if VERBOSE > 10
  for (int i = 0; i < M_SIZE*K_SIZE; i++)
    printf("Y[%8x]: 0x%4x\n", Y_BASE + 2*i, mmio16(Y_BASE + 2*i));
#endif

  // Z - golden (reference)
  for (int i = 0; i < M_SIZE*K_SIZE; i++)
    mmio16(Z_BASE + 2*i) = z_oup[i];
#if VERBOSE > 10
  for (int i = 0; i < M_SIZE*K_SIZE; i++)
    printf("Z[%8x]: 0x%4x\n", Z_BASE + 2*i, mmio16(Z_BASE + 2*i));
#endif

#if VERBOSE > 10
  printf("K_SIZE: %4x\n", K_SIZE);
  printf("M_SIZE: %4x\n", M_SIZE);
  printf("N_SIZE: %4x\n", N_SIZE);  
#endif

  // Initialize and configure RedMulE
  hwpe_cg_enable();
  hwpe_soft_clear();

  int offload_id_tmp;
  while ((offload_id_tmp = hwpe_acquire_job()) < 0)
    ;

  redmule_cfg((unsigned int)X_BASE, (unsigned int)W_BASE, (unsigned int)Y_BASE, 
              M_SIZE, N_SIZE, K_SIZE, (uint8_t)gemm_ops, (uint8_t)Float16);

#ifdef IRQ_EN
  // Enable IRQs
  uint32_t irq_mask = (1 << IRQ_REDMULE_EVT_0) | (1 << IRQ_REDMULE_EVT_1);
  irq_en(irq_mask);
#endif

  // Wait for end of computation
  printf("Testing matrix multiplication with RedMulE...\n");
  hwpe_trigger_job();
  
  // Wait for HWPE completion
  hwpe_wait_for_completion();
  
#ifdef IRQ_EN
  printf("Detected IRQ...\n");
#endif
  printf("Verifying results...\n");

  // Disable RedMulE
  hwpe_cg_disable();
  
  unsigned int num_errors = 0;

  uint16_t computed, expected, diff;
  for(int i = 0; i < M_SIZE*K_SIZE; i++){
    computed = mmio16(Y_BASE + 2*i);
    expected = mmio16(Z_BASE + 2*i);
    diff = (computed > expected) ? (computed - expected) : (expected - computed);
    if(diff > DIFF_TH){
      num_errors++;
      printf("**ERROR**: Y[%8x](=0x%4x) != Z[%8x](=0x%4x)\n", Y_BASE + 2*i, computed, Z_BASE + 2*i, expected);
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
