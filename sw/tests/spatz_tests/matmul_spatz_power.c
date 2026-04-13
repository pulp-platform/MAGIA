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
 * Matrix Multiplication Power Test: Spatz
 * VCD dump profiling - silent execution, no CSV output
 * 
 */

#include <stdint.h>
#include <stdio.h>
#include "magia_tile_utils.h"
#include "magia_spatz_utils.h"

#include "event_unit_utils.h"
#include "matmul_spatz_power_task_bin.h"
#include "vcd_dump.h"

// Default matrix dimensions (can be overridden at compile time)
#ifndef M_SIZE
#define M_SIZE 16
#endif

#ifndef N_SIZE
#define N_SIZE 96
#endif

#ifndef K_SIZE
#define K_SIZE 16
#endif

typedef uint16_t fp16_t;

// FP16 encoding: 1.0 = 0x3C00
static const fp16_t mat_value = 0x3C00;

// Memory layout in L1
#define A_MAT_BASE      (L1_BASE + 0x00010000)
#define B_MAT_BASE      (L1_BASE + 0x00012000)
#define C_MAT_BASE      (L1_BASE + 0x00030000)
#define PARAM_BASE      (L1_BASE + 0x00050000)

// Parameter structure for Spatz matmul task
typedef struct {
    uint32_t a_addr;
    uint32_t b_addr;
    uint32_t c_addr;
    uint32_t m_size;
    uint32_t n_size;
    uint32_t k_size;
} matmul_params_t;

int main(void) {
    cv32e40p_ccount_enable();

    // Initialize matrices: A[M×N], B[N×K], C[M×K]
    // A = 1.0
    for (uint32_t i = 0; i < M_SIZE * N_SIZE; i++) {
        mmio16(A_MAT_BASE + 2*i) = mat_value;
    }
    // B = 1.0
    for (uint32_t i = 0; i < N_SIZE * K_SIZE; i++) {
        mmio16(B_MAT_BASE + 2*i) = mat_value;
    }
    // C = 0.0
    for (uint32_t i = 0; i < M_SIZE * K_SIZE; i++) {
        mmio16(C_MAT_BASE + 2*i) = 0x0000;
    }

    // Initialize Event Unit and Spatz
    eu_init();
    eu_enable_events(EU_SPATZ_DONE_MASK);
    spatz_init(SPATZ_BINARY_START);

    volatile matmul_params_t *params = (volatile matmul_params_t *)PARAM_BASE;

    // =====================================================
    // Warm-up Spatz with M=16, K=16, N=96 to heat cache
    // =====================================================
    
    params->a_addr = A_MAT_BASE;
    params->b_addr = B_MAT_BASE;
    params->c_addr = C_MAT_BASE;
    params->m_size = 16;
    params->n_size = 96;
    params->k_size = 16;
    
    spatz_pass_params(PARAM_BASE);
    spatz_run_task(MATMUL16_TASK);
    eu_wait_spatz_polling(EU_SPATZ_DONE_MASK);
    eu_clear_events(EU_SPATZ_DONE_MASK);

    // Clear result matrix after warm-up
    for (uint32_t i = 0; i < M_SIZE * K_SIZE; i++) {
        mmio16(C_MAT_BASE + 2*i) = 0x0000;
    }

    // =====================================================
    // VCD dump: M×N×K matmul
    // =====================================================
    
    params->a_addr = A_MAT_BASE;
    params->b_addr = B_MAT_BASE;
    params->c_addr = C_MAT_BASE;
    params->m_size = M_SIZE;
    params->n_size = N_SIZE;
    params->k_size = K_SIZE;

    spatz_pass_params(PARAM_BASE);
    
    VCD_DUMP_START_SIMPLE();
    
    spatz_run_task(MATMUL16_TASK);
    eu_wait_spatz_wfe(EU_SPATZ_DONE_MASK);
    
    VCD_DUMP_STOP_SIMPLE();

    return 0;
}
