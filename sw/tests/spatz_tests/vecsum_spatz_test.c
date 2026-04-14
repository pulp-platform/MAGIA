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
 * Spatz VECSUM Test - Vector Addition
 * x[N] = all 1.0, y[N] = all 1.0
 * Expected: z[N] = all 2.0 (in FP16)
 */

#include "magia_tile_utils.h"
#include "magia_spatz_utils.h"
#include "event_unit_utils.h"
#include "vecsum_spatz_test_task_bin.h"

#define N_SIZE 64

#define X_BASE      (L1_BASE + 0x00010000)
#define Y_BASE      (L1_BASE + 0x00010400)
#define Z_BASE      (L1_BASE + 0x00010800)
#define PARAM_BASE  (L1_BASE + 0x00011000)

typedef uint16_t fp16_t;
static const fp16_t fp16_one = 0x3C00;   // 1.0
static const fp16_t fp16_two = 0x4000;   // 2.0
#define DIFF_TH 0x0011

typedef struct {
    uint32_t x_addr;
    uint32_t y_addr;
    uint32_t z_addr;
    uint32_t n_size;
} vecsum_params_t;

int main(void) {
    // Initialize vectors X and Y to 1.0
    for (int i = 0; i < N_SIZE; i++) {
        mmio16(X_BASE + 2*i) = fp16_one;
        mmio16(Y_BASE + 2*i) = fp16_one;
        mmio16(Z_BASE + 2*i) = 0;
    }
    
    // Initialize Event Unit and Spatz
    eu_init();
    eu_enable_events(EU_SPATZ_DONE_MASK);
    spatz_init(SPATZ_BINARY_START);
    
    // Set parameters
    volatile vecsum_params_t *params = (volatile vecsum_params_t *)PARAM_BASE;
    params->x_addr = X_BASE;
    params->y_addr = Y_BASE;
    params->z_addr = Z_BASE;
    params->n_size = N_SIZE;
    
    // Run task
    spatz_pass_params(PARAM_BASE);
    spatz_run_task(VECSUM16_TASK);
    eu_wait_spatz_wfe(EU_SPATZ_DONE_MASK);
    
    // Verify: each z[i] should be 2.0
    unsigned int errors = 0;
    for(int i = 0; i < N_SIZE; i++){
        fp16_t result = mmio16(Z_BASE + 2*i);
        uint16_t diff = (result > fp16_two) ? (result - fp16_two) : (fp16_two - result);
        if(diff > DIFF_TH) {
            errors++;
            if(errors <= 3)
                printf("ERROR: z[%d]=0x%04x, expected=0x%04x\n", i, result, fp16_two);
        }
    }
    
    if(errors == 0)
        printf("VECSUM test PASSED\n");
    else
        printf("VECSUM test FAILED: %u errors\n", errors);
    
    return errors;
}
