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
 * Vector Sum Performance Test - Spatz Only
 * Direct vector addition: Z = X + Y (O(N) operations)
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "magia_spatz_utils.h"
#include "event_unit_utils.h"
#include "vecsum_spatz_perf_task_bin.h"

#ifndef N_SIZE
#define N_SIZE 512
#endif

#define DIFF_TH (0x0020)
typedef uint16_t fp16_t;

static const fp16_t x_value = 0x3C00;      // 1.0
static const fp16_t y_value = 0x4000;      // 2.0
static const fp16_t expected_sum = 0x4200; // 3.0

#define X_VEC_BASE      (L1_BASE + 0x00010000)
#define Y_VEC_BASE      (L1_BASE + 0x00011000)
#define Z_SPATZ         (L1_BASE + 0x00093000)

// Parameter structure for Spatz vecsum task
typedef struct {
    uint32_t x_addr;
    uint32_t y_addr;
    uint32_t z_addr;
    uint32_t n_size;
} vecsum_params_t;

int main(void) {
    ccount_en();
    
    uint32_t N = N_SIZE;
    
    // Initialize vectors
    for (uint32_t i = 0; i < N; i++) {
        mmio16(X_VEC_BASE + 2*i) = x_value;
        mmio16(Y_VEC_BASE + 2*i) = y_value;
        mmio16(Z_SPATZ + 2*i) = 0x0000;
    }
    
    // Initialize Event Unit and Spatz
    eu_init();
    eu_enable_events(EU_SPATZ_DONE_MASK);
    spatz_init(SPATZ_BINARY_START);
    
    // --- Warm-up run ---
    uint32_t N_warmup = 16;
    
    uint32_t param_base_warmup = L1_BASE + 0x000A0000;
    volatile vecsum_params_t *params_warmup = (volatile vecsum_params_t *)param_base_warmup;
    params_warmup->x_addr = X_VEC_BASE;
    params_warmup->y_addr = Y_VEC_BASE;
    params_warmup->z_addr = Z_SPATZ;
    params_warmup->n_size = N_warmup;
    
    // CRITICAL: Pass parameters BEFORE running task
    spatz_pass_params(param_base_warmup);
    spatz_run_task(VECSUM16_TASK);
    eu_wait_spatz_polling(EU_SPATZ_DONE_MASK);
    eu_clear_events(EU_SPATZ_DONE_MASK);
    
    // Reset output for actual test
    for (uint32_t i = 0; i < N; i++) {
        mmio16(Z_SPATZ + 2*i) = 0x0000;
    }
    
    // --- Actual measurement ---
    uint32_t param_base = L1_BASE + 0x000A1000;
    volatile vecsum_params_t *params = (volatile vecsum_params_t *)param_base;
    params->x_addr = X_VEC_BASE;
    params->y_addr = Y_VEC_BASE;
    params->z_addr = Z_SPATZ;
    params->n_size = N;
    
    uint32_t start_cycles = get_cycle();
    
    // CRITICAL: Pass parameters BEFORE running task
    spatz_pass_params(param_base);
    spatz_run_task(VECSUM16_TASK);
    eu_wait_spatz_polling(EU_SPATZ_DONE_MASK);
    
    uint32_t cycles = get_cycle() - start_cycles;

    printf("RedMule cycles: 0\n");
    printf("Spatz cycles: %u\n", cycles);
    
    return 0;
}
