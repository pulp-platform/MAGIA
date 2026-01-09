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
 * Double Spatz Test - CV32 launches Spatz task twice consecutively
 * 
 */

#include "magia_tile_utils.h"
#include "magia_spatz_utils.h"
#include "event_unit_utils.h"
#include "simple_double_spatz_test_task_bin.h"

int main(void) {

    int errors = 0;

    printf("[CV32] Double Spatz Test:\n");

    // ==========================================
    // Initialization of Event Unit and Spatz
    // ==========================================
    
    // Initialize Event Unit
    eu_init();
    eu_enable_events(EU_SPATZ_DONE_MASK);  // Enable Spatz DONE event

    // Enable clk and initialize Spatz (bootrom jumps to _start, does full init)
    printf("\n[CV32] Initializing Spatz...\n");
    spatz_init(SPATZ_BINARY_START);
    
    // ==========================================
    // Test 1: First Spatz Task Run
    // ==========================================
    printf("\n[CV32] Launching SPATZ Task (Run 1)\n");
    spatz_run_task(HELLO_WORLD_SIMPLE_TASK);

    eu_wait_spatz_wfe(EU_SPATZ_DONE_MASK);
    
    if(spatz_get_exit_code() != 0) {
        printf("[CV32] SPATZ TASK RUN 1 ENDED with exit code: 0x%03x\n", spatz_get_exit_code());
        errors++;
    } else {
        printf("[CV32] SPATZ TASK RUN 1 ENDED successfully\n");
    }

    // Disable Spatz clock between tasks
    printf("\n[CV32] Disabling Spatz clock...\n");
    spatz_clk_dis();

    // Re-enable Spatz clock
    printf("[CV32] Re-enabling Spatz clock...\n");
    spatz_clk_en();

    // ==========================================
    // Test 2: Second Spatz Task Run
    // ==========================================
    printf("\n[CV32] Launching SPATZ Task (Run 2)\n");
    spatz_run_task(IDMA_SIMPLE_TASK);

    eu_wait_spatz_wfe(EU_SPATZ_DONE_MASK);
    
    if(spatz_get_exit_code() != 0) {
        printf("[CV32] SPATZ TASK RUN 2 ENDED with exit code: 0x%03x\n", spatz_get_exit_code());
        errors++;
    } else {
        printf("[CV32] SPATZ TASK RUN 2 ENDED successfully\n");
    }

    // ==========================================
    // Summary
    // ==========================================
    if(errors == 0) {
        printf("\n[CV32] ========================================\n");
        printf("[CV32] ALL TESTS PASSED (2 runs completed)\n");
        printf("[CV32] ========================================\n");
    } else {
        printf("\n[CV32] TESTS FAILED with %d errors\n", errors);
    }

    // Disable Spatz clock
    spatz_clk_dis();
    
    // Return error status for CV32
    return errors;
}
