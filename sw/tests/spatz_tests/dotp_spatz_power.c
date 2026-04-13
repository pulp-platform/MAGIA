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
 * Spatz Dot Product Power Profiling
 * 
 * VCD dump for power analysis using Spatz vector processor
 * VCD output: profiling/dotp_spatz_N<size>_power.vcd
 * 
 * Compile with: make clean all test=dotp_spatz_power N_SIZE=<value>
 * Example: make run test=dotp_spatz_power N_SIZE=512 mesh_dv=0 gui=0
 */

#include <stdint.h>
#include <stdio.h>
#include "magia_tile_utils.h"
#include "magia_spatz_utils.h"
#include "event_unit_utils.h"
#include "vcd_dump.h"
#include "dotp_spatz_power_task_bin.h"

// Allow N_SIZE to be overridden at compile time
#ifndef N_SIZE
#define N_SIZE 512
#endif

#if N_SIZE < 1
#error "N_SIZE must be at least 1"
#endif

typedef uint16_t fp16_t;

#define FP16_ONE   0x3C00  // 1.0

// Memory layout
#define A_VEC_BASE      (L1_BASE + 0x00010000)  // A[N]
#define B_VEC_BASE      (L1_BASE + 0x00012000)  // B[N]
#define RESULT_BASE     (L1_BASE + 0x00014000)  // Result scalar
#define PARAM_BASE      (L1_BASE + 0x000A0000)  // Parameters

// Parameter structure for Spatz dotp task
typedef struct {
    uint32_t a_addr;
    uint32_t b_addr;
    uint32_t result_addr;
    uint32_t n_size;
} dotp_params_t;

int main(void) {
    
    
    // Initialize A vector = 1.0
    for (uint32_t i = 0; i < N_SIZE; i++) {
        mmio16(A_VEC_BASE + 2*i) = FP16_ONE;
    }
    
    // Initialize B vector = 1.0
    for (uint32_t i = 0; i < N_SIZE; i++) {
        mmio16(B_VEC_BASE + 2*i) = FP16_ONE;
    }
    
    // Clear result
    mmio16(RESULT_BASE) = 0x0000;
    
    // Initialize Event Unit and Spatz
    eu_init();
    eu_enable_events(EU_SPATZ_DONE_MASK);
    spatz_init(SPATZ_BINARY_START);
    
    // Write parameters
    volatile dotp_params_t *params = (volatile dotp_params_t *)PARAM_BASE;
    params->a_addr = A_VEC_BASE;
    params->b_addr = B_VEC_BASE;
    params->result_addr = RESULT_BASE;
    params->n_size = N_SIZE;
    
    // Warm-up strategy: run small task first to heat cache/pipeline
    // Then run actual task with target N_SIZE
    // Small warm-up (N=16) always works, even when N_SIZE is large
    volatile dotp_params_t *warmup_params = (volatile dotp_params_t *)PARAM_BASE;
    warmup_params->a_addr = A_VEC_BASE;
    warmup_params->b_addr = B_VEC_BASE;
    warmup_params->result_addr = RESULT_BASE;
    warmup_params->n_size = 16;  // Small size for warm-up
    
    // Warm-up run with N=16
    spatz_pass_params(PARAM_BASE);
    spatz_run_task(DOTP_TASK);
    eu_wait_spatz_polling(EU_SPATZ_DONE_MASK);
    eu_clear_events(EU_SPATZ_DONE_MASK);
    
    // Reconfigure parameters for actual test with N_SIZE
    params->n_size = N_SIZE;

    spatz_pass_params(PARAM_BASE);
    
    // Start VCD dump, trigger computation, stop dump
    VCD_DUMP_START_SIMPLE();
    
    spatz_run_task(DOTP_TASK);
    eu_wait_spatz_wfe(EU_SPATZ_DONE_MASK);
    
    VCD_DUMP_STOP_SIMPLE();
    
    // Cleanup
    eu_clear_events(EU_SPATZ_DONE_MASK);
    
    return 0;
}
