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
 * Vector Sum Comparison Test: RedMule vs Spatz
 * Computes Z = X + Y with both accelerators and compares results element-wise.
 * RedMule uses the identity matrix trick: Z = I×Y + X (GEMM accumulation).
 * Spatz uses direct vector addition.
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "magia_spatz_utils.h"
#include "redmule_mm_utils.h"
#include "event_unit_utils.h"
#include "vecsum_spatz_perf_task_bin.h"

#ifndef N_SIZE
#define N_SIZE 512
#endif

#define DIFF_TH (0x0020)

typedef uint16_t fp16_t;

static const fp16_t x_value      = 0x3C00;  // 1.0
static const fp16_t y_value      = 0x4000;  // 2.0
static const fp16_t expected_sum = 0x4200;  // 3.0 = 1.0 + 2.0

// Memory layout in L1
// X and Y are shared between RedMule and Spatz
#define X_VEC_BASE   (L1_BASE + 0x00010000)  // X[N]
#define Y_VEC_BASE   (L1_BASE + 0x00011000)  // Y[N]
#define ID_MAT_BASE  (L1_BASE + 0x00012000)  // I[N×N]  (used by RedMule only)
#define Z_REDMULE    (L1_BASE + 0x00092000)  // Z output from RedMule
#define Z_SPATZ      (L1_BASE + 0x00093000)  // Z output from Spatz
#define PARAM_BASE   (L1_BASE + 0x000A1000)  // Spatz parameter area

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

    // Initialize input vectors
    for (uint32_t i = 0; i < N; i++) {
        mmio16(X_VEC_BASE + 2*i) = x_value;
        mmio16(Y_VEC_BASE + 2*i) = y_value;
    }

    // =====================================================
    // Test 1: RedMule HWPE Accelerator
    // Z = I×Y + X  (identity matrix trick for vector addition)
    // =====================================================

    eu_init();
    eu_enable_events(EU_REDMULE_DONE_MASK);
    hwpe_cg_enable();
    hwpe_soft_clear();

    // Warm-up run (N_warmup=16): build small identity matrix and pre-load Z
    uint32_t N_warmup = 16;
    for (uint32_t i = 0; i < N_warmup; i++) {
        for (uint32_t j = 0; j < N_warmup; j++) {
            mmio16(ID_MAT_BASE + 2*(i * N_warmup + j)) = (i == j) ? x_value : 0x0000;
        }
    }
    for (uint32_t i = 0; i < N_warmup; i++) {
        mmio16(Z_REDMULE + 2*i) = mmio16(X_VEC_BASE + 2*i);
    }

    while (hwpe_acquire_job() < 0);
    redmule_cfg((unsigned int)ID_MAT_BASE, (unsigned int)Y_VEC_BASE, (unsigned int)Z_REDMULE,
                N_warmup, N_warmup, 1, (uint8_t)gemm_ops, (uint8_t)Float16, (uint8_t)Float16);
    hwpe_trigger_job();
    eu_redmule_wait_completion(EU_WAIT_MODE_POLLING);
    hwpe_soft_clear();
    eu_clear_events(EU_REDMULE_DONE_MASK);

    // Rebuild full NxN identity matrix and reload Z with X for actual run
    for (uint32_t i = 0; i < N; i++) {
        for (uint32_t j = 0; j < N; j++) {
            mmio16(ID_MAT_BASE + 2*(i * N + j)) = (i == j) ? x_value : 0x0000;
        }
    }
    for (uint32_t i = 0; i < N; i++) {
        mmio16(Z_REDMULE + 2*i) = mmio16(X_VEC_BASE + 2*i);
    }

    // Actual measurement
    while (hwpe_acquire_job() < 0);
    redmule_cfg((unsigned int)ID_MAT_BASE, (unsigned int)Y_VEC_BASE, (unsigned int)Z_REDMULE,
                N, N, 1, (uint8_t)gemm_ops, (uint8_t)Float16, (uint8_t)Float16);

    uint32_t redmule_start = get_cycle();
    hwpe_trigger_job();
    eu_redmule_wait_completion(EU_WAIT_MODE_POLLING);
    uint32_t redmule_cycles = get_cycle() - redmule_start;

    printf("RedMule cycles: %u\n", redmule_cycles);
    printf("RedMule completed.\n\n");

    hwpe_soft_clear();
    hwpe_cg_disable();

    // =====================================================
    // Test 2: Spatz Vector Processor
    // =====================================================

    // Clear Spatz output
    for (uint32_t i = 0; i < N; i++) {
        mmio16(Z_SPATZ + 2*i) = 0x0000;
    }

    eu_enable_events(EU_SPATZ_DONE_MASK);
    spatz_init(SPATZ_BINARY_START);

    volatile vecsum_params_t *params = (volatile vecsum_params_t *)PARAM_BASE;

    // Warm-up run (N=16)
    params->x_addr = X_VEC_BASE;
    params->y_addr = Y_VEC_BASE;
    params->z_addr = Z_SPATZ;
    params->n_size = 16;
    spatz_pass_params(PARAM_BASE);
    spatz_run_task(VECSUM16_TASK);
    eu_wait_spatz_polling(EU_SPATZ_DONE_MASK);
    eu_clear_events(EU_SPATZ_DONE_MASK);

    // Reset Spatz output before actual run
    for (uint32_t i = 0; i < N; i++) {
        mmio16(Z_SPATZ + 2*i) = 0x0000;
    }

    // Actual measurement
    params->x_addr = X_VEC_BASE;
    params->y_addr = Y_VEC_BASE;
    params->z_addr = Z_SPATZ;
    params->n_size = N;

    uint32_t spatz_start = get_cycle();
    spatz_pass_params(PARAM_BASE);
    spatz_run_task(VECSUM16_TASK);
    eu_wait_spatz_polling(EU_SPATZ_DONE_MASK);
    uint32_t spatz_cycles = get_cycle() - spatz_start;

    printf("Spatz cycles: %u\n\n", spatz_cycles);

    eu_clear_events(EU_SPATZ_DONE_MASK);

    // =====================================================
    // Result Verification
    // =====================================================

    unsigned int mismatch_errors = 0;
    uint16_t redmule_val, spatz_val, diff;

    printf("Comparing RedMule vs Spatz results...\n");
    for (uint32_t i = 0; i < N; i++) {
        redmule_val = mmio16(Z_REDMULE + 2*i);
        spatz_val   = mmio16(Z_SPATZ   + 2*i);
        diff = (redmule_val > spatz_val) ? (redmule_val - spatz_val)
                                        : (spatz_val   - redmule_val);
        if (diff > DIFF_TH) {
            mismatch_errors++;
            if (mismatch_errors <= 10)
                printf("  ERROR: RedMule[%u](=0x%04x) != Spatz[%u](=0x%04x), diff=0x%04x\n",
                       i, redmule_val, i, spatz_val, diff);
        }
    }

    printf("\n");
    if (mismatch_errors == 0) {
        printf("SUCCESS: RedMule and Spatz produce IDENTICAL results!\n");
    } else {
        printf("FAILURE: RedMule and Spatz differ in %u elements\n", mismatch_errors);
    }

    printf("\n");
    printf("Performance Summary:\n");
    printf("RedMule cycles: %u\n", redmule_cycles);
    printf("Spatz cycles:   %u\n", spatz_cycles);

    return mismatch_errors;
}
