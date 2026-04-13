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
 * Dot Product Comparison Test: RedMule vs Spatz
 * Computes A·B (1×N · N×1 = scalar) with both accelerators and compares results.
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "magia_spatz_utils.h"
#include "redmule_mm_utils.h"
#include "event_unit_utils.h"
#include "dotp_spatz_perf_task_bin.h"

#ifndef N_SIZE
#define N_SIZE 512
#endif

#if N_SIZE < 16
#error "N_SIZE must be at least 16 (RedMule constraint)"
#endif

#define DIFF_TH (0x0011)

typedef uint16_t fp16_t;

#define FP16_ONE  0x3C00  // 1.0

// Memory layout in L1
// A and B are shared between RedMule and Spatz (same data, same layout)
#define A_VEC_BASE      (L1_BASE + 0x00010000)  // A[N]  (1×N for RedMule, vec for Spatz)
#define B_VEC_BASE      (L1_BASE + 0x00012000)  // B[N]  (N×1 for RedMule, vec for Spatz)
#define RESULT_REDMULE  (L1_BASE + 0x00014000)  // scalar result from RedMule
#define RESULT_SPATZ    (L1_BASE + 0x00015000)  // scalar result from Spatz
#define PARAM_BASE      (L1_BASE + 0x000A0000)  // Spatz parameter area

// Parameter structure for Spatz dotp task
typedef struct {
    uint32_t a_addr;
    uint32_t b_addr;
    uint32_t result_addr;
    uint32_t n_size;
} dotp_params_t;

int main(void) {
    ccount_en();

    // Initialize A = B = 1.0 (expected result: N_SIZE * 1.0 * 1.0 = N_SIZE)
    for (uint32_t i = 0; i < N_SIZE; i++) {
        mmio16(A_VEC_BASE + 2*i) = FP16_ONE;
        mmio16(B_VEC_BASE + 2*i) = FP16_ONE;
    }
    // Clear result slots
    mmio16(RESULT_REDMULE) = 0x0000;
    mmio16(RESULT_SPATZ)   = 0x0000;

    // =====================================================
    // Test 1: RedMule HWPE Accelerator
    // =====================================================

    eu_init();
    eu_enable_events(EU_REDMULE_DONE_MASK);
    hwpe_cg_enable();
    hwpe_soft_clear();

    // Warm-up run (N=16)
    while (hwpe_acquire_job() < 0);
    redmule_cfg((unsigned int)A_VEC_BASE, (unsigned int)B_VEC_BASE, (unsigned int)RESULT_REDMULE,
                1, 16, 1, (uint8_t)gemm_ops, (uint8_t)Float16, (uint8_t)Float16);
    hwpe_trigger_job();
    eu_redmule_wait_completion(EU_WAIT_MODE_POLLING);
    hwpe_soft_clear();

    // Clear result before actual run
    mmio16(RESULT_REDMULE) = 0x0000;

    // Actual measurement
    while (hwpe_acquire_job() < 0);
    redmule_cfg((unsigned int)A_VEC_BASE, (unsigned int)B_VEC_BASE, (unsigned int)RESULT_REDMULE,
                1, N_SIZE, 1, (uint8_t)gemm_ops, (uint8_t)Float16, (uint8_t)Float16);

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

    eu_enable_events(EU_SPATZ_DONE_MASK);
    spatz_init(SPATZ_BINARY_START);

    volatile dotp_params_t *params = (volatile dotp_params_t *)PARAM_BASE;

    // Warm-up run (N=16)
    params->a_addr      = A_VEC_BASE;
    params->b_addr      = B_VEC_BASE;
    params->result_addr = RESULT_SPATZ;
    params->n_size      = 16;
    spatz_pass_params(PARAM_BASE);
    spatz_run_task(DOTP_TASK);
    eu_wait_spatz_polling(EU_SPATZ_DONE_MASK);
    eu_clear_events(EU_SPATZ_DONE_MASK);

    // Clear result before actual run
    mmio16(RESULT_SPATZ) = 0x0000;

    // Actual measurement
    params->a_addr      = A_VEC_BASE;
    params->b_addr      = B_VEC_BASE;
    params->result_addr = RESULT_SPATZ;
    params->n_size      = N_SIZE;

    uint32_t spatz_start = get_cycle();
    spatz_pass_params(PARAM_BASE);
    spatz_run_task(DOTP_TASK);
    eu_wait_spatz_polling(EU_SPATZ_DONE_MASK);
    uint32_t spatz_cycles = get_cycle() - spatz_start;

    printf("Spatz cycles: %u\n\n", spatz_cycles);

    eu_clear_events(EU_SPATZ_DONE_MASK);

    // =====================================================
    // Result Verification
    // =====================================================

    unsigned int mismatch_errors = 0;
    fp16_t redmule_val = mmio16(RESULT_REDMULE);
    fp16_t spatz_val   = mmio16(RESULT_SPATZ);
    uint16_t diff = (redmule_val > spatz_val) ? (redmule_val - spatz_val)
                                              : (spatz_val   - redmule_val);

    printf("Comparing RedMule vs Spatz result...\n");
    if (diff > DIFF_TH) {
        mismatch_errors++;
        printf("  ERROR: RedMule result(=0x%04x) != Spatz result(=0x%04x), diff=0x%04x\n",
               redmule_val, spatz_val, diff);
    }

    printf("\n");
    if (mismatch_errors == 0) {
        printf("SUCCESS: RedMule and Spatz produce IDENTICAL results!\n");
    } else {
        printf("FAILURE: RedMule and Spatz differ\n");
    }

    printf("\n");
    printf("Performance Summary:\n");
    printf("RedMule cycles: %u\n", redmule_cycles);
    printf("Spatz cycles:   %u\n", spatz_cycles);

    return mismatch_errors;
}
