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
 * Vector Sum Performance Test - RedMule Only
 * Computes Z = X + Y using RedMule GEMM accumulation: Z = I×Y + X
 * where I is N×N identity matrix
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "redmule_mm_utils.h"
#include "event_unit_utils.h"

#ifndef N_SIZE
#define N_SIZE 512
#endif

#define DIFF_TH (0x0020)
typedef uint16_t fp16_t;

// FP16 encoding: 1.0 = 0x3C00, 2.0 = 0x4000, 3.0 = 0x4200
static const fp16_t x_value = 0x3C00;      // 1.0
static const fp16_t y_value = 0x4000;      // 2.0
static const fp16_t expected_sum = 0x4200; // 3.0

// Memory layout in L1
#define X_VEC_BASE      (L1_BASE + 0x00010000)
#define Y_VEC_BASE      (L1_BASE + 0x00011000)
#define ID_MAT_BASE     (L1_BASE + 0x00012000)
#define Z_REDMULE       (L1_BASE + 0x00092000)

int main(void) {
    ccount_en();
    
    uint32_t N = N_SIZE;
    
    // Initialize vectors X and Y
    for (uint32_t i = 0; i < N; i++) {
        mmio16(X_VEC_BASE + 2*i) = x_value;
        mmio16(Y_VEC_BASE + 2*i) = y_value;
    }
    
    // Build identity matrix I[N×N]
    for (uint32_t i = 0; i < N; i++) {
        for (uint32_t j = 0; j < N; j++) {
            if (i == j) {
                mmio16(ID_MAT_BASE + 2*(i * N + j)) = x_value; // 1.0 on diagonal
            } else {
                mmio16(ID_MAT_BASE + 2*(i * N + j)) = 0x0000; // 0.0 elsewhere
            }
        }
    }
    
    // Pre-load Z with X for GEMM accumulation
    for (uint32_t i = 0; i < N; i++) {
        mmio16(Z_REDMULE + 2*i) = mmio16(X_VEC_BASE + 2*i);
    }
    
    // Initialize RedMule
    hwpe_cg_enable();
    hwpe_soft_clear();
    
    // Initialize Event Unit
    eu_init();
    eu_enable_events(EU_REDMULE_DONE_MASK);
    
    // --- Warm-up run ---
    uint32_t N_warmup = 16;
    
    // Build warm-up identity matrix
    for (uint32_t i = 0; i < N_warmup; i++) {
        for (uint32_t j = 0; j < N_warmup; j++) {
            if (i == j) {
                mmio16(ID_MAT_BASE + 2*(i * N_warmup + j)) = x_value;
            } else {
                mmio16(ID_MAT_BASE + 2*(i * N_warmup + j)) = 0x0000;
            }
        }
    }
    
    for (uint32_t i = 0; i < N_warmup; i++) {
        mmio16(Z_REDMULE + 2*i) = mmio16(X_VEC_BASE + 2*i);
    }
    
    int offload_id_warmup;
    while ((offload_id_warmup = hwpe_acquire_job()) < 0);
    
    redmule_cfg((unsigned int)ID_MAT_BASE, (unsigned int)Y_VEC_BASE, (unsigned int)Z_REDMULE,
                N_warmup, N_warmup, 1, (uint8_t)gemm_ops, (uint8_t)Float16, (uint8_t)Float16);
    hwpe_trigger_job();
    eu_redmule_wait_completion(EU_WAIT_MODE_POLLING);
    
    hwpe_soft_clear();
    eu_clear_events(EU_REDMULE_DONE_MASK);
    
    // Rebuild identity matrix for actual test
    for (uint32_t i = 0; i < N; i++) {
        for (uint32_t j = 0; j < N; j++) {
            if (i == j) {
                mmio16(ID_MAT_BASE + 2*(i * N + j)) = x_value;
            } else {
                mmio16(ID_MAT_BASE + 2*(i * N + j)) = 0x0000;
            }
        }
    }
    
    // Reload Z with X
    for (uint32_t i = 0; i < N; i++) {
        mmio16(Z_REDMULE + 2*i) = mmio16(X_VEC_BASE + 2*i);
    }
    
    // --- Actual measurement ---
    int offload_id;
    while ((offload_id = hwpe_acquire_job()) < 0);
    
    redmule_cfg((unsigned int)ID_MAT_BASE, (unsigned int)Y_VEC_BASE, (unsigned int)Z_REDMULE,
                N, N, 1, (uint8_t)gemm_ops, (uint8_t)Float16, (uint8_t)Float16);
    
    uint32_t start_cycles = get_cycle();
    hwpe_trigger_job();
    eu_redmule_wait_completion(EU_WAIT_MODE_POLLING);
    uint32_t cycles = get_cycle() - start_cycles;

    printf("RedMule cycles: %u\n", cycles);
    printf("Spatz cycles: 0\n");
    
    hwpe_cg_disable();
    
    return 0;
}
