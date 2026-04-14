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
 * Spatz DOTP Test - Dot Product
 * a[N] = all 1.0, b[N] = all 1.0
 * Expected: result = N (in FP16)
 */

#include "magia_tile_utils.h"
#include "magia_spatz_utils.h"
#include "event_unit_utils.h"
#include "dotp_spatz_test_task_bin.h"

#define N_SIZE 64

#define A_BASE      (L1_BASE + 0x00010000)
#define B_BASE      (L1_BASE + 0x00010400)
#define RES_BASE    (L1_BASE + 0x00010800)
#define PARAM_BASE  (L1_BASE + 0x00011000)

typedef uint16_t fp16_t;
static const fp16_t fp16_one = 0x3C00;   // 1.0
static const fp16_t fp16_n = 0x5400;     // 64.0 (N_SIZE)
#define DIFF_TH 0x0011

typedef struct {
    uint32_t a_addr;
    uint32_t b_addr;  
    uint32_t result_addr;
    uint32_t n_elements;
} dotp_params_t;

int main(void) {
    // Initialize vectors A and B to 1.0
    for (int i = 0; i < N_SIZE; i++) {
        mmio16(A_BASE + 2*i) = fp16_one;
        mmio16(B_BASE + 2*i) = fp16_one;
    }
    mmio16(RES_BASE) = 0;
    
    // Initialize Event Unit and Spatz
    eu_init();
    eu_enable_events(EU_SPATZ_DONE_MASK);
    spatz_init(SPATZ_BINARY_START);
    
    // Set parameters
    volatile dotp_params_t *params = (volatile dotp_params_t *)PARAM_BASE;
    params->a_addr = A_BASE;
    params->b_addr = B_BASE;
    params->result_addr = RES_BASE;
    params->n_elements = N_SIZE;
    
    // Run task
    spatz_pass_params(PARAM_BASE);
    spatz_run_task(DOTP_TASK);
    eu_wait_spatz_wfe(EU_SPATZ_DONE_MASK);
    
    // Verify: result should be N_SIZE (64.0)
    fp16_t result = mmio16(RES_BASE);
    uint16_t diff = (result > fp16_n) ? (result - fp16_n) : (fp16_n - result);
    unsigned int errors = (diff > DIFF_TH) ? 1 : 0;
    
    if(errors == 0)
        printf("DOTP test PASSED\n");
    else
        printf("DOTP test FAILED: result=0x%04x, expected=0x%04x\n", result, fp16_n);
    
    return errors;
}
