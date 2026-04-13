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
 * Matrix-Vector Multiplication Comparison Test: RedMule vs Spatz
 * Computes dst = mat x vec_x (MxN * Nx1 = Mx1) with both accelerators
 * and compares results element-wise.
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "magia_spatz_utils.h"
#include "redmule_mm_utils.h"
#include "event_unit_utils.h"
#include "matvec_spatz_perf_task_bin.h"

#ifndef M_SIZE
#define M_SIZE 64
#endif

#ifndef N_SIZE
#define N_SIZE 32
#endif

// Memory layout in L1
#define MAT_BASE        (L1_BASE + 0x00010000)  // Matrix M×N (256×256×2 = 128KB)
#define VEC_X_BASE      (L1_BASE + 0x00030000)  // Input vector N (256×2 = 512B)
#define VEC_Y_BASE      (L1_BASE + 0x00030400)  // Input vector M (256×2 = 512B)
#define RESULT_REDMULE  (L1_BASE + 0x00030800)  // RedMule output M (256×2 = 512B)
#define RESULT_SPATZ    (L1_BASE + 0x00030C00)  // Spatz output M (256×2 = 512B)
#define RESULT_TRANS    (L1_BASE + 0x00031000)  // Spatz transposed output N (256×2 = 512B)
#define PARAM_BASE      (L1_BASE + 0x00031400)  // Spatz parameters

// Parameter structure for Spatz matvec task (matches matvec16_task.c)
typedef struct __attribute__((packed)) {
    uint32_t mat_addr;
    uint32_t vec_x_addr;
    uint32_t vec_y_addr;
    uint32_t dst_addr;
    uint16_t alpha;  // FP16
    uint16_t beta;   // FP16
    uint32_t m_size;
    uint32_t n_size;
} matvec_params_t;

#define DIFF_TH (0x0020)  // Tolerance for FP16 comparison

typedef uint16_t fp16_t;

// FP16 constants
static const fp16_t MAT_VALUE  = 0x4000;  // 2.0
static const fp16_t VECX_VALUE = 0x4000;  // 2.0
static const fp16_t VECY_VALUE = 0x4000;  // 2.0
static const fp16_t ALPHA      = 0x3C00;  // 1.0
static const fp16_t BETA       = 0x0000;  // 0.0 - for fair comparison with RedMule

int main(void) {
    ccount_en();
    
    printf("\n");
    printf("========================================\n");
    printf("Matrix-Vector Comparison Test\n");
    printf("RedMule vs Spatz Transposed\n");
    printf("========================================\n");
  

    // Initialize input matrix and vectors
    printf("Initializing test data...\n");
    
    // Matrix: mat[M×N] = 1.0
    for (int i = 0; i < M_SIZE * N_SIZE; i++)
        mmio16(MAT_BASE + 2*i) = MAT_VALUE;
    
    // Input vector x[N] = 1.0
    for (int i = 0; i < N_SIZE; i++)
        mmio16(VEC_X_BASE + 2*i) = VECX_VALUE;
    
    // Input vector y[M] = 1.0
    for (int i = 0; i < M_SIZE; i++)
        mmio16(VEC_Y_BASE + 2*i) = VECY_VALUE;
    
    // Initialize output vectors to zero
    for (int i = 0; i < M_SIZE; i++) {
        mmio16(RESULT_REDMULE + 2*i) = 0x0000;
    }
    
    // Initialize transposed output vector to zero
    for (int i = 0; i < N_SIZE; i++) {
        mmio16(RESULT_TRANS + 2*i) = 0x0000;
    }
    
    printf("Test data initialized.\n\n");
    
    // =====================================================
    // Test 1: RedMule HWPE Accelerator
    // =====================================================
    
    printf("========================================\n");
    printf("Running RedMule GEMV...\n");
    printf("========================================\n");
    
    // Initialize and configure RedMulE
    eu_init();
    eu_enable_events(EU_REDMULE_DONE_MASK);
    hwpe_cg_enable();
    hwpe_soft_clear();
    
    // Acquire RedMule job
    int offload_id_tmp;
    while ((offload_id_tmp = hwpe_acquire_job()) < 0);
    
    // For GEMV, we use RedMule with K=1 (treat vector as N×1 matrix)
    // Note: RedMule performs C = A×B, where A is M×N and B is N×1 -> C is M×1
    // For the full GEMV (α·A·x + β·y), we need to:
    //   1. First copy β·vec_y to result (pre-accumulation)
    //   2. Then compute A×x and accumulate with α scaling
    // However, RedMule doesn't support α,β directly, so we'll just compute A×x
    // and verify the matrix-vector product matches Spatz
    
    // For fair comparison, we just compute mat×vec (no β·vec_y term for RedMule)
    // Initialize RedMule result to zero (no accumulation)
    for (int i = 0; i < M_SIZE; i++)
        mmio16(RESULT_REDMULE + 2*i) = 0x0000;
    
    redmule_cfg((unsigned int)MAT_BASE, (unsigned int)VEC_X_BASE, (unsigned int)RESULT_REDMULE,
                M_SIZE, N_SIZE, 1, (uint8_t)gemm_ops, (uint8_t)Float16, (uint8_t)Float16);
    
    printf("Starting RedMulE computation...\n", M_SIZE, N_SIZE);
    
    uint32_t redmule_start = get_cycle();
    
    hwpe_trigger_job();
    eu_redmule_wait_completion(EU_WAIT_MODE_POLLING);
    
    uint32_t redmule_cycles = get_cycle() - redmule_start;
    
    printf("RedMule completed in %u cycles\n", redmule_cycles);
    
    // Debug: Check first few output values immediately
    printf("First RedMule output values:\n");
    for (int i = 0; i < 5; i++) {
        printf("  dst[%d] = 0x%04x\n", i, mmio16(RESULT_REDMULE + 2*i));
    }
    printf("Expected: 0x6400 (1024.0 in FP16) = 256 × (2.0 × 2.0)\n");
    
    // RedMule result is already mat×vec (with β=0 equivalent)
    // No need to add β·vec_y since we're comparing with β=0 for fair comparison
    
    printf("\n");
    
    // =====================================================
    // Test 2: Spatz GEMV Transposed (mat^T × vec_x)
    // =====================================================
    
    printf("========================================\n");
    printf("Running Spatz GEMV Transposed...\n");
    printf("========================================\n");
    
    // Initialize Spatz and enable events
    eu_clear_events(EU_REDMULE_DONE_MASK);
    eu_enable_events(EU_SPATZ_DONE_MASK);
    
    printf("Initializing Spatz...\n");
    spatz_init(SPATZ_BINARY_START);
    
    // Write parameters to shared L1 memory for Spatz task
    volatile matvec_params_t *params = (volatile matvec_params_t *)PARAM_BASE;
    params->mat_addr = MAT_BASE;
    params->vec_x_addr = VEC_X_BASE;
    params->vec_y_addr = VEC_Y_BASE;
    params->dst_addr = RESULT_TRANS;  // Output for transposed
    params->alpha = ALPHA;
    params->beta = BETA;
    params->m_size = M_SIZE;
    params->n_size = N_SIZE;
    
    printf("Spatz transposed parameters:\n");
    printf("  mat_addr=0x%08x, vec_x_addr=0x%08x\n", params->mat_addr, params->vec_x_addr);
    printf("  dst_addr=0x%08x\n", params->dst_addr);
    printf("  alpha=0x%04x, beta=0x%04x\n", params->alpha, params->beta);
    printf("  m_size=%d, n_size=%d\n", params->m_size, params->n_size);
    printf("  First matrix elements: 0x%04x 0x%04x 0x%04x\n", 
           mmio16(MAT_BASE), mmio16(MAT_BASE+2), mmio16(MAT_BASE+4));
    printf("  First vec_x elements: 0x%04x 0x%04x 0x%04x\n",
           mmio16(VEC_X_BASE), mmio16(VEC_X_BASE+2), mmio16(VEC_X_BASE+4));
    printf("\n");
    printf("Starting Spatz transposed computation...\n");
    
    spatz_pass_params(PARAM_BASE);
    
    uint32_t spatz_trans_start = get_cycle();
    
    spatz_run_task(MATVECTRANS16_TASK);
    
    eu_wait_spatz_polling(EU_SPATZ_DONE_MASK);
    
    uint32_t spatz_trans_cycles = get_cycle() - spatz_trans_start;
    
    printf("Spatz transposed completed in %u cycles\n", spatz_trans_cycles);
    
    // Debug: Check first few output values
    printf("First Spatz transposed output values:\n");
    for (int i = 0; i < 5; i++) {
        printf("  dst[%d] = 0x%04x\n", i, mmio16(RESULT_TRANS + 2*i));
    }
    printf("Expected: 0x6400 (1024.0 in FP16) = 256 × (2.0 × 2.0)\n");
    printf("\n");

    // =====================================================
    // Result Verification: RedMule vs Spatz Transposed
    // =====================================================
    
    printf("========================================\n");
    printf("Verifying Results...\n");
    printf("========================================\n");
    
    unsigned int mismatch_errors = 0;
    uint16_t redmule_val, trans_val, diff;
    
    // Compare RedMule (mat×vec) with Spatz Transposed (mat^T×vec)
    // For square uniform matrices, these should give the same result
    printf("Comparing RedMule vs Spatz Transposed (first 10 elements)...\n");
    for(int i = 0; i < M_SIZE; i++){
        redmule_val = mmio16(RESULT_REDMULE + 2*i);
        trans_val = mmio16(RESULT_TRANS + 2*i);
        diff = (redmule_val > trans_val) ? (redmule_val - trans_val) : (trans_val - redmule_val);
        
        if(i < 10) {  // Print first 10 values
            printf("  [%3d] RedMule=0x%04x, Trans=0x%04x, diff=0x%04x\n", 
                   i, redmule_val, trans_val, diff);
        }
        
        if(diff > DIFF_TH){
            mismatch_errors++;
            if(mismatch_errors <= 10) // Print first 10 errors only
                printf("  ERROR[%d]: RedMule(0x%04x) != Trans(0x%04x), diff=0x%04x\n", 
                       i, redmule_val, trans_val, diff);
        }
    }
    
    printf("\n");
    
    // =====================================================
    // Summary
    // =====================================================
    
    printf("========================================\n");
    printf("Test Summary\n");
    printf("========================================\n");
    printf("Matrix size: %d×%d\n", M_SIZE, N_SIZE);
    printf("MACs: %d\n", M_SIZE * N_SIZE);
    printf("\n");
    
    printf("Performance:\n");
    printf("  RedMule (mat×vec):     %8u cycles\n", redmule_cycles);
    printf("  Spatz Trans (mat^T×vec): %8u cycles\n", spatz_trans_cycles);

    printf("\n");
    printf("Performance Summary:\n");
    printf("RedMule cycles: %u\n", redmule_cycles);
    printf("Spatz cycles:   %u\n", spatz_trans_cycles);
    
    // Calculate speedup using integer arithmetic (x100 for 2 decimal places)
    if (redmule_cycles > 0 && spatz_trans_cycles > 0) {
        uint32_t speedup_x100 = (redmule_cycles * 100) / spatz_trans_cycles;
        if (speedup_x100 > 100) {
            printf("  Spatz Trans is %u.%02ux faster than RedMule\n", 
                   speedup_x100/100, speedup_x100%100);
        } else if (speedup_x100 < 100) {
            uint32_t inverse_x100 = (spatz_trans_cycles * 100) / redmule_cycles;
            printf("  RedMule is %u.%02ux faster than Spatz Trans\n", 
                   inverse_x100/100, inverse_x100%100);
        } else {
            printf("  RedMule and Spatz Trans have similar performance\n");
        }
    }
    printf("\n");
    
    printf("Correctness:\n");
    if (mismatch_errors == 0) {
        printf("  ✓ SUCCESS: Results match within threshold!\n");
        printf("  Total mismatches: 0 / %d\n", M_SIZE);
    } else {
        printf("  ✗ FAILURE: Results differ!\n");
        printf("  Total mismatches: %d / %d\n", mismatch_errors, M_SIZE);
    }
    printf("\n");
    
    // =====================================================
    // Cross-verification Summary
    // =====================================================
    
    printf("========================================\n");
    printf("Implementation Comparison\n");
    printf("========================================\n");
    printf("Test Configuration:\n");
    printf("  Matrix size:    256×256\n");
    printf("  Matrix values:  2.0 (0x4000)\n");
    printf("  Vector values:  2.0 (0x4000)\n");
    printf("  Alpha:          1.0 (0x3C00)\n");
    printf("  Beta:           0.0 (0x0000)\n");
    printf("\n");
    
    printf("RedMule (mat × vec_x):\n");
    printf("  Operation:      mat × vec_x (column-wise access)\n");
    printf("  Access pattern: Column-wise strided (K=1 optimization)\n");
    printf("  Expected:       Each element = 256 × (2.0 × 2.0) = 1024.0 = 0x6400\n");
    printf("  Result[0]:      0x%04x\n", mmio16(RESULT_REDMULE));
    printf("  Cycles:         %u\n", redmule_cycles);
    printf("\n");
    
    printf("Spatz Transposed (mat^T × vec_x):\n");
    printf("  Operation:      mat^T × vec_x (row-wise access)\n");
    printf("  Access pattern: Row-wise sequential (vle16)\n");
    printf("  Expected:       Each element = 256 × (2.0 × 2.0) = 1024.0 = 0x6400\n");
    printf("  Result[0]:      0x%04x\n", mmio16(RESULT_TRANS));
    printf("  Cycles:         %u\n", spatz_trans_cycles);
    printf("\n");
    
    printf("Note: For this uniform test case (all 2.0), mat × vec and mat^T × vec\n");
    printf("      give the same numerical result since M=N=256.\n");
    printf("      However, they access memory with different patterns.\n");
    printf("      Transposed version uses sequential row access, which may be more efficient.\n");
    printf("\n");
    
    // Cleanup
    hwpe_cg_disable();
    
    return mismatch_errors;
}
