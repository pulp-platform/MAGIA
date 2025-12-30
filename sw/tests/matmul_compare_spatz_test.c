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
 *  Matrix Multiplication Comparison Test: RedMule vs Spatz
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "magia_spatz_utils.h"
#include "redmule_mm_utils.h"
#include "event_unit_utils.h"
#include "matmul_compare_spatz_test_task_bin.h"

// Golden model test data headers
#include "x_input.h"
#include "w_input.h"
#include "y_input.h"
#include "z_output.h"

// Matrix dimensions (from golden model headers)
#define M_SIZE (96)
#define N_SIZE (64)
#define K_SIZE (64)

// Memory layout in L1
#define X_BASE (L1_BASE + 0x00012048)
#define W_BASE (L1_BASE + 0x00016048)
#define Y_BASE (L1_BASE + 0x0001A048)
#define Z_BASE (L2_BASE + 0x00042000)

// Aliases for consistency with comparison test
#define A_BASE X_BASE
#define B_BASE W_BASE
#define C_REDMULE_BASE Y_BASE
#define C_SPATZ_BASE   (L1_BASE + 0x00023000)
#define C_SCALAR_BASE  Z_BASE

// Spatz parameter area in shared L1
#define MATMUL_PARAM_BASE (L1_BASE + 0x00010000)

#define VERBOSE (0)
#define DIFF_TH (0x0011)

// Use 16-bit float for RedMule compatibility
typedef uint16_t fp16_t;

int main(void) {
    // Enable CV32E40P cycle counter
    cv32e40p_ccount_enable();
    
    printf("\n");
    printf("========================================\n");
    printf("MATMUL Performance Comparison Test\n");
    printf("========================================\n");

    // Initialize input matrices from golden model headers
    printf("Initializing matrices from golden model...\n");
    
    // X (matrix A)
    for (int i = 0; i < M_SIZE*N_SIZE; i++)
        mmio16(X_BASE + 2*i) = x_inp[i];
    
    // W (matrix B)
    for (int i = 0; i < N_SIZE*K_SIZE; i++)
        mmio16(W_BASE + 2*i) = w_inp[i];
    
    // Y (RedMule output) - initialize to ZERO (no accumulation, same as Spatz)
    for (int i = 0; i < M_SIZE*K_SIZE; i++)
        mmio16(Y_BASE + 2*i) = 0;
    
    printf("Matrices initialized.\n\n");
    
    // =====================================================
    // Test 1: RedMule HWPE Accelerator
    // =====================================================
    printf("----------------------------------------\n");
    printf("Test 1: RedMule HWPE Accelerator\n");
    printf("----------------------------------------\n");
    
    // Initialize and configure RedMulE
    hwpe_cg_enable();
    hwpe_soft_clear();
    
    // Acquire RedMule job
    int offload_id_tmp;
    while ((offload_id_tmp = hwpe_acquire_job()) < 0);
    
    // Configure RedMulE with matrices
    redmule_cfg((unsigned int)A_BASE, (unsigned int)B_BASE, (unsigned int)C_REDMULE_BASE, 
                M_SIZE, N_SIZE, K_SIZE, (uint8_t)gemm_ops, (uint8_t)Float16);
    
    printf("Starting RedMulE computation...\n");
    
    uint32_t redmule_start = cv32e40p_get_cycles();
    
    // Trigger job
    hwpe_trigger_job();
    
    // Wait for HWPE completion using the polling method
    hwpe_wait_for_completion();
    
    uint32_t redmule_cycles = cv32e40p_get_cycles() - redmule_start;

    printf("RedMule cycles: %u\n", redmule_cycles);
    printf("RedMule completed.\n\n");
    
    // =====================================================
    // Test 2: Spatz Vector Processor
    // =====================================================
    printf("----------------------------------------\n");
    printf("Test 2: Spatz Vector Processor\n");
    printf("----------------------------------------\n");
    
    // Initialize Event Unit and Spatz
    eu_init();
    eu_enable_events(EU_SPATZ_DONE_MASK);
    
    printf("Initializing Spatz...\n");
    spatz_init(SPATZ_BINARY_START);
    
    // Write parameters to shared L1 memory for Spatz task
    volatile uint32_t *params = (volatile uint32_t *)MATMUL_PARAM_BASE;
    params[0] = A_BASE;           // a_addr
    params[1] = B_BASE;           // b_addr  
    params[2] = C_SPATZ_BASE;     // c_addr
    params[3] = M_SIZE;           // m_size
    params[4] = N_SIZE;           // n_size
    params[5] = K_SIZE;           // k_size
    
    printf("Initializing Spatz output matrix to zero...\n");
    for (uint32_t i = 0; i < M_SIZE * K_SIZE; i++) {
        mmio16(C_SPATZ_BASE + 2*i) = 0;
    }
    
    printf("Starting Spatz computation...\n");
    
    uint32_t spatz_start = cv32e40p_get_cycles();
    
    spatz_run_task(MATMUL16_TASK);
    spatz_pass_params(MATMUL_PARAM_BASE);    
    eu_wait_spatz_polling(EU_SPATZ_DONE_MASK);
    
    uint32_t spatz_cycles = cv32e40p_get_cycles() - spatz_start;
    
    printf("Spatz cycles: %u\n\n", spatz_cycles);

    // =====================================================
    // Result Verification
    // =====================================================
    printf("========================================\n");
    printf("Result Verification\n");
    printf("========================================\n");
    
    unsigned int mismatch_errors = 0;
    uint16_t redmule_val, spatz_val, diff;

    // Verify that RedMule and Spatz produce IDENTICAL results
    printf("Comparing RedMule vs Spatz results...\n");
    for(int i = 0; i < M_SIZE*K_SIZE; i++){
      redmule_val = mmio16(C_REDMULE_BASE + 2*i);
      spatz_val = mmio16(C_SPATZ_BASE + 2*i);
      diff = (redmule_val > spatz_val) ? (redmule_val - spatz_val) : (spatz_val - redmule_val);
      if(diff > DIFF_TH){
        mismatch_errors++;
        if(mismatch_errors <= 10) // Print first 10 errors only
          printf("  ERROR: RedMule[%d](=0x%04x) != Spatz[%d](=0x%04x), diff=0x%04x\n", 
                 i, redmule_val, i, spatz_val, diff);
      }
    }
    
    printf("\n");
    if (mismatch_errors == 0) {
      printf("SUCCESS: RedMule and Spatz produce IDENTICAL results!\n");
      printf("All %d elements match (diff <= %d)\n", M_SIZE*K_SIZE, DIFF_TH);
    } else {
      printf("FAILURE: RedMule and Spatz differ in %d elements\n", mismatch_errors);
    }
    
    printf("\n");
    printf("Performance Summary:\n");
    printf("RedMule cycles: %u\n", redmule_cycles);
    printf("Spatz cycles:   %u\n", spatz_cycles);

  return mismatch_errors;

}
