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
 * FP16 Matrix Multiplication using RISC-V Vector Extension
 * Computes C = A × B where C is M×K, A is M×N, B is N×K
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "spatz_workers.h"

// Parameters passed via L1 shared memory
#define MATMUL_PARAM_BASE  (L1_BASE + 0x00010000)

// Parameter structure in shared L1 memory
typedef struct {
    uint32_t a_addr;        // Matrix A address
    uint32_t b_addr;        // Matrix B address  
    uint32_t c_addr;        // Matrix C address (result)
    uint32_t m_size;        // Number of rows in A and C
    uint32_t n_size;        // Number of columns in A, rows in B
    uint32_t k_size;        // Number of columns in B and C
} matmul_params_t;

// Main entry point
int matmul16_task(void) {
    
    // Read parameters from shared L1 memory
    volatile matmul_params_t *params = (volatile matmul_params_t *)MATMUL_PARAM_BASE;
    
    float16_t *A = (float16_t *)params->a_addr;
    float16_t *B = (float16_t *)params->b_addr;
    float16_t *C = (float16_t *)params->c_addr;
    uint32_t M = params->m_size;
    uint32_t N = params->n_size;
    uint32_t K = params->k_size;
    
    // Compute matrix multiplication using Spatz benchmark kernel
    // C[M×K] = A[M×N] × B[N×K]
    fmatmul_v16b(C, A, B, M, N, K);
    
    return 0;
}
