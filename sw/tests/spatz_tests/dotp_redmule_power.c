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
 * RedMule Dot Product Power Profiling
 * 
 * VCD dump for power analysis using RedMule HWPE
 * VCD output: profiling/dotp_redmule_N<size>_power.vcd
 * 
 * Compile with: make clean all test=dotp_redmule_power N_SIZE=<value>
 * Example: make run test=dotp_redmule_power N_SIZE=512 mesh_dv=0 gui=0
 */

#include <stdint.h>
#include <stdio.h>
#include "magia_tile_utils.h"
#include "redmule_mm_utils.h"
#include "event_unit_utils.h"
#include "vcd_dump.h"

// Allow N_SIZE to be overridden at compile time
#ifndef N_SIZE
#define N_SIZE 512
#endif

#if N_SIZE < 16
#error "N_SIZE must be at least 16 (RedMule constraint)"
#endif

typedef uint16_t fp16_t;

#define FP16_ONE   0x3C00  // 1.0

// Memory layout
#define A_VEC_BASE      (L1_BASE + 0x00010000)  // A[N]
#define B_VEC_TRANSP    (L1_BASE + 0x00012000)  // B transposed [N×1]
#define RESULT_BASE     (L1_BASE + 0x00014000)  // Result scalar [1×1]

int main(void) {
    
    cv32e40p_ccount_enable();
    
    // Initialize A vector = 1.0
    for (uint32_t i = 0; i < N_SIZE; i++) {
        mmio16(A_VEC_BASE + 2*i) = FP16_ONE;
    }
    
    // Initialize B transposed [N×1] = 1.0
    for (uint32_t i = 0; i < N_SIZE; i++) {
        mmio16(B_VEC_TRANSP + 2*i) = FP16_ONE;
    }
    
    // Clear result
    mmio16(RESULT_BASE) = 0x0000;
    
    // Initialize RedMule and Event Unit
    eu_init();
    eu_enable_events(EU_REDMULE_DONE_MASK);
    hwpe_cg_enable();
    hwpe_soft_clear();
    
    // Warm-up run with N=16 to heat cache/pipeline
    while (hwpe_acquire_job() < 0);
    redmule_cfg((unsigned int)A_VEC_BASE, (unsigned int)B_VEC_TRANSP, (unsigned int)RESULT_BASE, 
                1, 16, 1, (uint8_t)0x00, (uint8_t)Float16);
    hwpe_trigger_job();
    eu_redmule_wait_completion(EU_WAIT_MODE_POLLING);
    hwpe_soft_clear();
    
    // Configure RedMule for actual test: result[1×1] = A[1×N] × B[N×1]
    while (hwpe_acquire_job() < 0);
    redmule_cfg((unsigned int)A_VEC_BASE, (unsigned int)B_VEC_TRANSP, (unsigned int)RESULT_BASE, 
                1, N_SIZE, 1, (uint8_t)0x00, (uint8_t)Float16);
    
    // Start VCD dump, trigger computation, stop dump
    VCD_DUMP_START_SIMPLE();
    
    hwpe_trigger_job();
    eu_redmule_wait_completion(EU_WAIT_MODE_WFE);
    
    VCD_DUMP_STOP_SIMPLE();
    
    // Cleanup
    hwpe_soft_clear();
    hwpe_cg_disable();
    
    return 0;
}
