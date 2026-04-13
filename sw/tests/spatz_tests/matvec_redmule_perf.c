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
 * Matrix-Vector Multiplication Performance Test: RedMule
 * Silent profiling - writes results to L2 memory for CSV export by VIP
 * 
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "redmule_mm_utils.h"
#include "event_unit_utils.h"

// Default matrix/vector dimensions (can be overridden at compile time)
#ifndef M_SIZE
#define M_SIZE 64
#endif

#ifndef N_SIZE
#define N_SIZE 32
#endif

typedef uint16_t fp16_t;

// FP16 encoding: 1.0 = 0x3C00
static const fp16_t mat_value = 0x3C00;

// Memory layout in L1
#define MAT_BASE        (L1_BASE + 0x00010000)
#define VEC_X_BASE      (L1_BASE + 0x00020000)
#define DST_BASE        (L1_BASE + 0x00030000)

int main(void) {
    ccount_en();

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

    // Initialize RedMulE and Event Unit
    eu_init();
    eu_enable_events(EU_REDMULE_DONE_MASK);
    hwpe_cg_enable();
    hwpe_soft_clear();

    // =====================================================
    // Warm-up run with M=16, N=96 to heat cache/pipeline
    // Same dimensions as Spatz warm-up for fair comparison
    // =====================================================
    
    while (hwpe_acquire_job() < 0);
    
    redmule_cfg((unsigned int)MAT_BASE, (unsigned int)VEC_X_BASE, (unsigned int)DST_BASE,
                16, 96, 1, (uint8_t)gemm_ops, (uint8_t)Float16, (uint8_t)Float16);
    
    hwpe_trigger_job();
    eu_redmule_wait_completion(EU_WAIT_MODE_POLLING);
    hwpe_soft_clear();

    // Clear result vector after warm-up
    for (uint32_t i = 0; i < M_SIZE; i++) {
        mmio16(DST_BASE + 2*i) = 0x0000;
    }

    // =====================================================
    // Actual measurement: M×N matvec
    // =====================================================
    
    while (hwpe_acquire_job() < 0);
    
    redmule_cfg((unsigned int)MAT_BASE, (unsigned int)VEC_X_BASE, (unsigned int)DST_BASE,
                M_SIZE, N_SIZE, 1, (uint8_t)gemm_ops, (uint8_t)Float16, (uint8_t)Float16);
    
    uint32_t start_cycles = get_cycle();
    
    hwpe_trigger_job();
    eu_redmule_wait_completion(EU_WAIT_MODE_POLLING);
    
    uint32_t cycles = get_cycle() - start_cycles;

    // =====================================================
    // Store results in L2 for CSV generation by VIP
    // =====================================================
    
    printf("RedMule cycles: %u\n", cycles);
    printf("Spatz cycles: 0\n");

    // Cleanup
    hwpe_cg_disable();

    return 0;
}
