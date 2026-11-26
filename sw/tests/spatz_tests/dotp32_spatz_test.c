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
 * Authors: Luca Colombo
 * 
 * Spatz DOTP Test - Dot Product
 * a[N] = all 1.0, b[N] = all 1.0
 * Expected: result = N (in FP16)
 */

#include "magia_tile_utils.h"
#include "magia_spatz_utils.h"
#include "event_unit_utils.h"
#include "dotp32_spatz_test_task_bin.h"

#define N_SIZE 64

#define A_BASE      (L1_BASE + 0x00010000)
#define B_BASE      (L1_BASE + 0x00010400)
#define RES_BASE    (L1_BASE + 0x00010800)
#define PARAM_BASE  (L1_BASE + 0x00011000)
#define DBG_BASE    (L1_BASE + 0x12000)


// FP32 values handled as raw bit patterns: no soft-float/double promotion needed
#define FP32_ONE_BITS  0x3F800000u  // 1.0f
#define FP32_N_BITS    0x42800000u  // 64.0f (N_SIZE)
#define DIFF_TH_ULP    1u           // max allowed error in ULPs

typedef struct {
    uint32_t a_addr;
    uint32_t b_addr;  
    uint32_t result_addr;
    uint32_t n_elements;
} dotp_params_t;

int main(void) {
    // Initialize vectors A and B to 1.0
    for (int i = 0; i < N_SIZE; i++) {
        mmio32(A_BASE + 4*i) = FP32_ONE_BITS;
        mmio32(B_BASE + 4*i) = FP32_ONE_BITS;
    }
    mmio32(RES_BASE) = 0;
    mmio32(DBG_BASE) = 0;
    
    // Initialize Event Unit and Spatz
    eu_init();
    eu_enable_events(EU_SPATZ_DONE_MASK);
    spatz_init(SPATZ_BINARY_START);
    
    printf("Setup parameteres \n");
    // Set parameters
    volatile dotp_params_t *params = (volatile dotp_params_t *)PARAM_BASE;
    params->a_addr = A_BASE;
    params->b_addr = B_BASE;
    params->result_addr = RES_BASE;
    params->n_elements = N_SIZE;

    printf("SPATZ_BINARY_START = 0x%08x\n",
       (unsigned int)SPATZ_BINARY_START);

    printf("DOTP32_TASK        = 0x%08x\n",
       (unsigned int)DOTP32_TASK);
    
    // Run task
    printf("Pass parameteres \n");
    spatz_pass_params(PARAM_BASE);
    printf("Start task\n");
    spatz_run_task(DOTP32_TASK);
    eu_wait_spatz_wfe(EU_SPATZ_DONE_MASK);
    
    // Verify: result should be N_SIZE (64.0)
    uint32_t result = mmio32(RES_BASE);
    uint32_t diff = (result > FP32_N_BITS) ? (result - FP32_N_BITS) : (FP32_N_BITS - result);
    unsigned int errors = (diff > DIFF_TH_ULP) ? 1 : 0;
    
    if(errors == 0)
        printf("DOTP test PASSED\n");
    else
        printf("DOTP test FAILED: result=0x%04x, expected=0x%04x\n", result, FP32_N_BITS);
    
    return errors;
}
