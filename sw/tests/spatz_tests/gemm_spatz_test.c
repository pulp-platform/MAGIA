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
 * Spatz GEMM Test - Matrix Multiplication
 * A[64×64] = all 1.0, B[64×64] = all 1.0
 * Expected: C[64×64] = all 64.0 (in FP16)
 */

#include "magia_tile_utils.h"
#include "magia_spatz_utils.h"
#include "event_unit_utils.h"
#include "gemm_spatz_test_task_bin.h"

#define M_SIZE 64
#define N_SIZE 64
#define K_SIZE 64

#define A_BASE      (L1_BASE + 0x00010000)
#define B_BASE      (L1_BASE + 0x00020000)
#define C_BASE      (L1_BASE + 0x00030000)
#define PARAM_BASE  (L1_BASE + 0x00040000)

typedef uint16_t fp16_t;
static const fp16_t fp16_one = 0x3C00;   // 1.0
static const fp16_t fp16_n = 0x5400;     // 64.0 (N_SIZE)
#define DIFF_TH 0x0011

typedef struct {
    uint32_t a_addr;
    uint32_t b_addr;  
    uint32_t c_addr;
    uint32_t m_size;
    uint32_t n_size;
    uint32_t k_size;
} matmul_params_t;

int main(void) {
    // Initialize matrices A and B to 1.0
    for (int i = 0; i < M_SIZE*N_SIZE; i++)
        mmio16(A_BASE + 2*i) = fp16_one;
    for (int i = 0; i < N_SIZE*K_SIZE; i++)
        mmio16(B_BASE + 2*i) = fp16_one;
    for (int i = 0; i < M_SIZE*K_SIZE; i++)
        mmio16(C_BASE + 2*i) = 0;
    
    // Initialize Event Unit and Spatz
    eu_init();
    eu_enable_events(EU_SPATZ_DONE_MASK);
    spatz_init(SPATZ_BINARY_START);
    
    // Set parameters
    volatile matmul_params_t *params = (volatile matmul_params_t *)PARAM_BASE;
    params->a_addr = A_BASE;
    params->b_addr = B_BASE;
    params->c_addr = C_BASE;
    params->m_size = M_SIZE;
    params->n_size = N_SIZE;
    params->k_size = K_SIZE;
    
    // Run task
    spatz_pass_params(PARAM_BASE);
    spatz_run_task(MATMUL16_TASK);
    eu_wait_spatz_wfe(EU_SPATZ_DONE_MASK);
    
    // Verify: each C[i] should be N_SIZE (64.0)
    unsigned int errors = 0;
    for(int i = 0; i < M_SIZE*K_SIZE; i++){
        fp16_t result = mmio16(C_BASE + 2*i);
        uint16_t diff = (result > fp16_n) ? (result - fp16_n) : (fp16_n - result);
        if(diff > DIFF_TH) {
            errors++;
            if(errors <= 3)
                printf("ERROR: C[%d]=0x%04x, expected=0x%04x\n", i, result, fp16_n);
        }
    }
    
    if(errors == 0)
        printf("GEMM test PASSED\n");
    else
        printf("GEMM test FAILED: %u errors\n", errors);
    
    return errors;
}
