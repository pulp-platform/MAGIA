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
 * Matrix-Vector Multiplication Power Test: Spatz Transposed
 * VCD dump profiling - silent execution, no CSV output
 * Uses mat^T × vec_x (row-wise sequential access)
 * 
 */

#include <stdint.h>
#include <stdio.h>
#include "magia_tile_utils.h"
#include "magia_spatz_utils.h"
#include "event_unit_utils.h"
#include "matvec_spatz_power_task_bin.h"
#include "vcd_dump.h"

// Default matrix dimensions (can be overridden at compile time)
#ifndef M_SIZE
#define M_SIZE 16
#endif

#ifndef N_SIZE
#define N_SIZE 96
#endif

typedef uint16_t fp16_t;

// FP16 encoding: 1.0 = 0x3C00
static const fp16_t mat_value = 0x3C00;

// Memory layout in L1
#define MAT_BASE        (L1_BASE + 0x00010000)
#define VEC_X_BASE      (L1_BASE + 0x00020000)
#define DST_BASE        (L1_BASE + 0x00030000)
#define PARAM_BASE      (L1_BASE + 0x00050000)

// Parameter structure for Spatz matvec task
typedef struct {
    uint32_t mat_addr;
    uint32_t vec_x_addr;
    uint32_t vec_y_addr;
    uint32_t dst_addr;
    fp16_t alpha;
    fp16_t beta;
    uint32_t m_size;
    uint32_t n_size;
} matvec_params_t;

int main(void) {
    cv32e40p_ccount_enable();

    // Initialize Spatz first
    spatz_init(SPATZ_BINARY_START);

    // Initialize matrix: mat[M×N] = 1.0
    for (uint32_t i = 0; i < M_SIZE * N_SIZE; i++) {
        mmio16(MAT_BASE + 2*i) = mat_value;
    }
    // Initialize vector: vec_x[N] = 1.0
    for (uint32_t i = 0; i < N_SIZE; i++) {
        mmio16(VEC_X_BASE + 2*i) = mat_value;
    }
    // Initialize result: dst[M] = 0.0
    for (uint32_t i = 0; i < M_SIZE; i++) {
        mmio16(DST_BASE + 2*i) = 0x0000;
    }

    // Initialize Event Unit
    eu_init();
    eu_enable_events(EU_SPATZ_DONE_MASK);

    volatile matvec_params_t *params = (volatile matvec_params_t *)PARAM_BASE;

    // =====================================================
    // Warm-up Spatz with M=16, N=96 to heat cache
    // =====================================================
    
    params->mat_addr = MAT_BASE;
    params->vec_x_addr = VEC_X_BASE;
    params->vec_y_addr = 0;
    params->dst_addr = DST_BASE;
    params->m_size = 16;
    params->n_size = 96;

    spatz_pass_params(PARAM_BASE);
    spatz_run_task(MATVECTRANS16_TASK);
    eu_wait_spatz_polling(EU_SPATZ_DONE_MASK);
    eu_clear_events(EU_SPATZ_DONE_MASK);

    // Clear result vector after warm-up
    for (uint32_t i = 0; i < M_SIZE; i++) {
        mmio16(DST_BASE + 2*i) = 0x0000;
    }

    // =====================================================
    // VCD dump: M×N matvec
    // =====================================================
    
    params->mat_addr = MAT_BASE;
    params->vec_x_addr = VEC_X_BASE;
    params->vec_y_addr = 0;
    params->dst_addr = DST_BASE;
    params->alpha = 0x3C00;  // 1.0
    params->beta = 0x0000;   // 0.0
    params->m_size = M_SIZE;
    params->n_size = N_SIZE;

    spatz_pass_params(PARAM_BASE);
    
    VCD_DUMP_START_SIMPLE();
    
    spatz_run_task(MATVECTRANS16_TASK);
    eu_wait_spatz_wfe(EU_SPATZ_DONE_MASK);
    
    VCD_DUMP_STOP_SIMPLE();

    return 0;
}
