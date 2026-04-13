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
 * Matrix Multiplication Power Test: RedMule
 * VCD dump profiling - silent execution, no CSV output
 * 
 */

#include <stdint.h>
#include <stdio.h>
#include "magia_tile_utils.h"
#include "redmule_mm_utils.h"
#include "event_unit_utils.h"
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

    // Initialize RedMulE and Event Unit
    eu_init();
    eu_enable_events(EU_REDMULE_DONE_MASK);
    hwpe_cg_enable();
    hwpe_soft_clear();

    // =====================================================
    // Warm-up run with M=16, K=16, N=96 to heat cache/pipeline
    // Same dimensions as Spatz warm-up for fair comparison
    // =====================================================
    
    while (hwpe_acquire_job() < 0);
    
    redmule_cfg((unsigned int)A_MAT_BASE, (unsigned int)B_MAT_BASE, (unsigned int)C_MAT_BASE,
                16, 96, 16, (uint8_t)gemm_ops, (uint8_t)Float16);
    
    hwpe_trigger_job();
    eu_redmule_wait_completion(EU_WAIT_MODE_POLLING);
    hwpe_soft_clear();

    // Clear result matrix after warm-up
    for (uint32_t i = 0; i < M_SIZE * K_SIZE; i++) {
        mmio16(C_MAT_BASE + 2*i) = 0x0000;
    }

    // =====================================================
    // VCD dump: M×N×K matmul
    // =====================================================
    
    while (hwpe_acquire_job() < 0);
    
    redmule_cfg((unsigned int)A_MAT_BASE, (unsigned int)B_MAT_BASE, (unsigned int)C_MAT_BASE,
                M_SIZE, N_SIZE, K_SIZE, (uint8_t)0x00, (uint8_t)Float16);
    
    VCD_DUMP_START_SIMPLE();
    
    hwpe_trigger_job();
    eu_redmule_wait_completion(EU_WAIT_MODE_WFE);
    
    VCD_DUMP_STOP_SIMPLE();

    // Cleanup
    hwpe_cg_disable();

    return 0;
}
