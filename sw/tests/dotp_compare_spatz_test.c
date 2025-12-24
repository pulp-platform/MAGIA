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
 * Dot Product Comparison Test: RedMule vs Spatz
 * 
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "magia_spatz_utils.h"
#include "redmule_mm_utils.h"
#include "event_unit_utils.h"
#include "dotp_compare_spatz_test_task_bin.h"

// Test data with golden reference
// Pattern: A[i] = 1.0, B[i] = 2.0 for all i
// Expected result: 2048 * 1.0 * 2.0 = 4096.0
#define DOTP_SIZE 2048  
#define DIFF_TH (0x0011)
typedef uint16_t fp16_t;

// FP16 encoding: 1.0 = 0x3C00, 2.0 = 0x4000, 4096.0 = 0x6C00
static const fp16_t dotp_a_value = 0x3C00;  // 1.0 in FP16
static const fp16_t dotp_b_value = 0x4000;  // 2.0 in FP16
static const fp16_t dotp_golden = 0x6C00;   // 4096.0 in FP16

// Memory layout in L1
#define A_VEC_BASE      (L1_BASE + 0x00010000)
#define B_VEC_BASE      (L1_BASE + 0x00012000)
#define B_VEC_TRANSP    (L1_BASE + 0x00014000)  // B transposed for RedMule
#define RESULT_REDMULE  (L1_BASE + 0x00016000)
#define RESULT_CV32     (L1_BASE + 0x00016010)
#define RESULT_SPATZ    (L1_BASE + 0x00016020)

// Spatz parameter area in shared L1
#define DOTP_PARAM_BASE (L1_BASE + 0x00015000)

int main(void) {
    // Enable CV32E40P cycle counter
    cv32e40p_ccount_enable();
    
    printf("\n");
    printf("========================================\n");
    printf("Dot Product Performance Comparison\n");
    printf("========================================\n");
    printf("Vector size: %d elements\n", DOTP_SIZE);
    printf("Data type: FP16\n");
    printf("Test pattern: A[i] = 1.0, B[i] = 2.0\n");

    // Initialize vectors with test pattern
    printf("Initializing vectors...\n");
    
    for (uint32_t i = 0; i < DOTP_SIZE; i++) {
        mmio16(A_VEC_BASE + 2*i) = dotp_a_value;
        mmio16(B_VEC_BASE + 2*i) = dotp_b_value;
        mmio16(B_VEC_TRANSP + 2*i) = dotp_b_value;
    }
    printf("Vectors initialized.\n\n");
    
    // =====================================================
    // Test 1: RedMule HWPE (using 1×N GEMM)
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
    
    // Configure RedMulE: C[1×1] = A[1×N] × B[N×1]
    // M=1, N=DOTP_SIZE, K=1 produces dot product
    redmule_cfg((unsigned int)A_VEC_BASE, (unsigned int)B_VEC_TRANSP, (unsigned int)RESULT_REDMULE, 
                1, DOTP_SIZE, 1, (uint8_t)gemm_ops, (uint8_t)Float16);
    
    printf("Starting RedMulE dot product ...\n");
    
    uint32_t redmule_start = cv32e40p_get_cycles();
    
    // Trigger job
    hwpe_trigger_job();
    
    // Wait for HWPE completion
    hwpe_wait_for_completion();
    
    uint32_t redmule_cycles = cv32e40p_get_cycles() - redmule_start;
    
    // Disable RedMulE
    hwpe_cg_disable();
    
    fp16_t result_redmule = mmio16(RESULT_REDMULE);

    printf("RedMule cycles: %u\n", redmule_cycles);
    printf("RedMule result: 0x%04x\n", result_redmule);
    
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
    volatile uint32_t *params = (volatile uint32_t *)DOTP_PARAM_BASE;
    params[0] = A_VEC_BASE;       // a_addr
    params[1] = B_VEC_BASE;       // b_addr
    params[2] = RESULT_SPATZ;     // result_addr
    params[3] = DOTP_SIZE;        // n_elements
    
    printf("Starting Spatz dot product...\n");
    
    uint32_t spatz_start = cv32e40p_get_cycles();
    
    spatz_run_task(DOTP_TASK);
    
    eu_wait_spatz_polling(EU_SPATZ_DONE_MASK);
    
    uint32_t spatz_cycles = cv32e40p_get_cycles() - spatz_start;
    
    fp16_t result_spatz = mmio16(RESULT_SPATZ);

    printf("Spatz cycles: %u\n", spatz_cycles);
    printf("Spatz result: 0x%04x\n\n", result_spatz);

    // =====================================================
    // Result Verification
    // =====================================================
    printf("========================================\n");
    printf("Result Verification\n");
    printf("========================================\n");
    
    unsigned int redmule_errors = 0;
    unsigned int spatz_errors = 0;
    uint16_t computed, expected, diff;
    
    // Check RedMule result
    printf("Checking RedMule result...\n");
    computed = result_redmule;
    expected = dotp_golden;
    diff = (computed > expected) ? (computed - expected) : (expected - computed);
    if(diff > DIFF_TH){
        redmule_errors++;
        printf("ERROR: RedMule result (=0x%04x) != Golden (=0x%04x), diff=0x%04x\n", computed, expected, diff);
    }
    
    
    // Check Spatz result
    printf("Checking Spatz result...\n");
    // Convert Spatz FP32 result to FP16 for comparison
    computed = result_spatz;
    expected = dotp_golden;
    diff = (computed > expected) ? (computed - expected) : (expected - computed);
    if(diff > DIFF_TH){
        spatz_errors++;
        printf("ERROR: Spatz result (=0x%04x) != Golden (=0x%04x), diff=0x%04x\n", computed, expected, diff);
    }
    
    printf("\n");
    printf("RedMule errors: %u\n", redmule_errors);
    printf("Spatz errors:   %u\n", spatz_errors);
    
    unsigned int total_errors = redmule_errors + spatz_errors;
    printf("\nFinished test with %u total errors\n", total_errors);

    return total_errors;
}
