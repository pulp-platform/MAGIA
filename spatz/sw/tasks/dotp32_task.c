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
 * FP32 Dot Product using RISC-V Vector Extension
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "magia_spatz_utils.h"
#include "spatz_workers.h"

// DATA register address for reading parameter pointer
#define DATA_ADDR (SPATZ_DATA)
#define DBG_BASE  (L1_BASE + 0x00012000)

// Parameter structure in shared L1 memory
typedef struct {
    uint32_t a_addr;        // Vector A address
    uint32_t b_addr;        // Vector B address  
    uint32_t result_addr;   // Result address (scalar)
    uint32_t n_elements;    // Number of elements
} dotp_params_t;

// Main entry point
int dotp32_task(void) {

    uint32_t params_ptr = mmio32(DATA_ADDR);

    volatile dotp_params_t *params =
        (volatile dotp_params_t *)params_ptr;

    float *A = (float *)params->a_addr;
    float *B = (float *)params->b_addr;
    float *result = (float *)params->result_addr;
    uint32_t N = params->n_elements;

    // TODO: back to `*result = fdotp_v32b(A, B, N);` once spatz_vpu returns VFU scalar results
    fdotp_v32b_st(A, B, N, result);

    return 0;
}
