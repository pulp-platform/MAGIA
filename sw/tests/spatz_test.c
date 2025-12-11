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
 * Spatz Test - CV32 launches Spatz and waits with WFE
 * 
 */

#include "magia_tile_utils.h"
#include "magia_spatz_utils.h"
#include "event_unit_utils.h"

// Include Spatz test_binary_spatz program header
#include "../../spatz/sw/headers/test_binary_spatz.h"

int main(void) {
    printf("Spatz Test: Launch by CV32\n");
    
    // Initialize Event Unit
    eu_spatz_init();
    
    // Get Spatz program entry point (inlined in instrram after CV32 code)
    uint32_t spatz_entry_point = TEST_BINARY_SPATZ_BINARY_START;
    
    printf("Spatz binary at 0x%08X\n", spatz_entry_point);
    
    // Launch Spatz
    spatz_run(spatz_entry_point);
    
    // Wait for Spatz completion (WFE)
    eu_spatz_wait_completion(EU_WAIT_MODE_WFE);

    // Disable Spatz clock (clock gating)
    spatz_clk_dis();
    
    printf("Spatz Test: End\n");
    
    return 0;
}
