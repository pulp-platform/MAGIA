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
 * Authors: Luca Balboni <luca.balboni10@studio.unibo,it>
 *
 * FP16 Dot Product using RISC-V Vector Extension
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "spatz_workers.h"

// Parameters passed via L1 shared memory
#define DOTP_PARAM_BASE  (L1_BASE + 0x00015000)

// Parameter structure in shared L1 memory
typedef struct {
    uint32_t a_addr;        // Vector A address
    uint32_t b_addr;        // Vector B address  
    uint32_t result_addr;   // Result address (scalar)
    uint32_t n_elements;    // Number of elements
} dotp_params_t;

// Main entry point
int dotp_task(void) {
    
    // Read parameters from shared L1 memory
    volatile dotp_params_t *params = (volatile dotp_params_t *)DOTP_PARAM_BASE;
    
    float16_t *A = (float16_t *)params->a_addr;
    float16_t *B = (float16_t *)params->b_addr;
    float *result = (float *)params->result_addr;
    uint32_t N = params->n_elements;
    
    // Compute dot product using Spatz benchmark kernel
    float16_t result_fp16 = fdotp_v16b(A, B, N);
    
    *result = result_fp16;
    
    return 0;
}
