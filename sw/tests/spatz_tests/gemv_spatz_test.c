/*
 * Copyright (C) 2026 ETH Zurich, University of Bologna and Fondazione Chips-IT
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
 * Spatz GEMV Test - Matrix-Vector Multiplication (Optimized Column-Major)
 * 
 * OPERATION: dst = mat × vec_x (with alpha=1.0, beta=0.0)
 * 
 * TEST SETUP:
 * - Matrix: 16×8, all elements = 1.0 (FP16), COLUMN-MAJOR storage
 * - Vector: 8×1, all elements = 1.0 (FP16)
 * - Expected: dst[i] = 8.0 (FP16: 0x4800) for all i ∈ [0, 15]
 * 
 * STORAGE FORMAT (Column-Major for optimal performance):
 * - mat[i + j*M] = element at row i, column j
 * - Enables fast contiguous loads in gemv_v16b_m4() kernel
 * - ~20-30% faster than row-major strided loads
 */

#include "magia_tile_utils.h"
#include "magia_spatz_utils.h"
#include "event_unit_utils.h"
#include "gemv_spatz_test_task_bin.h"

#define M_SIZE 16
#define N_SIZE 8

#define MAT_BASE    (L1_BASE + 0x00010000)
#define VECX_BASE   (L1_BASE + 0x00011000)
#define VECY_BASE   (L1_BASE + 0x00011400)
#define DST_BASE    (L1_BASE + 0x00011800)
#define PARAM_BASE  (L1_BASE + 0x00012000)

typedef uint16_t fp16_t;
static const fp16_t fp16_one = 0x3C00;   // 1.0
static const fp16_t fp16_n = 0x4800;     // 8.0 (N_SIZE)
#define DIFF_TH 0x0011

typedef struct __attribute__((packed)) {
    uint32_t mat_addr;
    uint32_t vec_x_addr;
    uint32_t vec_y_addr;
    uint32_t dst_addr;
    uint16_t alpha;
    uint16_t beta;
    uint32_t m_size;
    uint32_t n_size;
} matvec_params_t;

int main(void) {

    for (int j = 0; j < N_SIZE; j++)
        for (int i = 0; i < M_SIZE; i++)
            mmio16(MAT_BASE + 2*(i + j*M_SIZE)) = fp16_one;

    for (int i = 0; i < N_SIZE; i++)
        mmio16(VECX_BASE + 2*i) = fp16_one;
        
    for (int i = 0; i < M_SIZE; i++)
        mmio16(DST_BASE + 2*i) = 0;
    
    // Initialize Event Unit and Spatz
    eu_init();
    eu_enable_events(EU_SPATZ_DONE_MASK);
    spatz_init(SPATZ_BINARY_START);
    
    // Set parameters: alpha=1.0, beta=0.0
    volatile matvec_params_t *params = (volatile matvec_params_t *)PARAM_BASE;
    params->mat_addr = MAT_BASE;
    params->vec_x_addr = VECX_BASE;
    params->vec_y_addr = VECY_BASE;
    params->dst_addr = DST_BASE;
    params->alpha = fp16_one;
    params->beta = 0x0000;  // 0.0
    params->m_size = M_SIZE;
    params->n_size = N_SIZE;
    
    spatz_pass_params(PARAM_BASE);
    spatz_run_task(MATVEC16_TASK);
    eu_wait_spatz_wfe(EU_SPATZ_DONE_MASK);
    

    for(int i = 0; i < 8; i++)
        printf("0x%04x ", mmio16(DST_BASE + 2*i));
    printf("\n");
    
    // Verify: each dst[i] should be N_SIZE (8.0)
    unsigned int errors = 0;
    for(int i = 0; i < M_SIZE; i++){
        fp16_t result = mmio16(DST_BASE + 2*i);
        uint16_t diff = (result > fp16_n) ? (result - fp16_n) : (fp16_n - result);
        if(diff > DIFF_TH) {
            errors++;
            if(errors <= 10)
                printf("ERROR: dst[%d]=0x%04x, expected=0x%04x (diff=0x%04x)\n", i, result, fp16_n, diff);
        }
    }
    
    if(errors == 0)
        printf("GEMV test PASSED\n");
    else
        printf("GEMV test FAILED: %u errors\n", errors);
    
    return errors;
}
