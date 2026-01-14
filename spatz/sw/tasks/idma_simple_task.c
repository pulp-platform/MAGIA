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
 * iDMA Task for MAGIA Tile - Demonstrates iDMA Transfers with Event Unit controlled by Spatz_cc
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "event_unit_utils.h"
#include "idma_mm_utils.h"

#define L1_DMA_SRC  ((volatile uint32_t *)(L1_BASE + 0x1000))
#define L1_DMA_DST  ((volatile uint32_t *)(L1_BASE + 0x2000))
#define L2_DMA_BUF  ((volatile uint32_t *)(L2_BASE + 0x1000))
#define DMA_SIZE    64  // 64 bytes = 16 words

int idma_simple_task(void) {
    printf("[SNITCH] \n========================================\n");
    printf("[SNITCH] IDMA TASK: DMA Transfers + Event Unit\n");
    printf("[SNITCH] ========================================\n");
    int errors = 0;
    
    // Enable iDMA events (keep EU_SPATZ_DONE enabled for CV32)
    printf("[SNITCH] Enabling iDMA events...\n");
    eu_enable_events(EU_IDMA_ALL_DONE_MASK);
    
    // 1. Test iDMA transfer L1→L2
    printf("[SNITCH] Testing iDMA L1 to L2 transfer...\n");
    
    // Initialize source data in L1
    for (int i = 0; i < (DMA_SIZE/4); i++) {
        L1_DMA_SRC[i] = 0xA0000000 + i;
    }
    
    // Launch DMA transfer (L1→L2)
    int tid = idma_L1ToL2((uint32_t)L1_DMA_SRC, (uint32_t)L2_DMA_BUF, DMA_SIZE);
    
    // Wait for O2A completion with polling (10ms timeout)
    uint32_t events = eu_idma_wait_o2a_completion(EU_WAIT_MODE_POLLING);
    
    if (events & EU_IDMA_O2A_DONE_MASK) {
        printf("[SNITCH] DMA L1 to L2 complete (O2A event detected)\n");
    } else {
        printf("[SNITCH] DMA L1 to L2 TIMEOUT\n");
        errors++;
    }
    
    // 2. Test iDMA transfer L2→L1
    printf("[SNITCH] Testing iDMA L2 to L1 transfer...\n");
    
    // Clear destination
    for (int i = 0; i < (DMA_SIZE/4); i++) {
        L1_DMA_DST[i] = 0;
    }
    
    tid = idma_L2ToL1((uint32_t)L2_DMA_BUF, (uint32_t)L1_DMA_DST, DMA_SIZE);
    
    // Wait for A2O completion with polling (10ms timeout)
    events = eu_idma_wait_a2o_completion(EU_WAIT_MODE_POLLING);
    
    if (events & EU_IDMA_A2O_DONE_MASK) {
        printf("[SNITCH] DMA L2 to L1 complete (A2O event detected)\n");
    } else {
        printf("[SNITCH] DMA L2 to L1 TIMEOUT\n");
        errors++;
    }
    
    // Verify transferred data (using mmio32)
    printf("[SNITCH] Verifying transferred data...\n");
    for (int i = 0; i < (DMA_SIZE/4); i++) {
        uint32_t expected = 0xA0000000 + i;
        uint32_t computed = mmio32((uint32_t)L1_DMA_DST + 4*i);
        if (computed != expected) {
            printf("[SNITCH] [%d] FAIL: computed=0x%08x, expected=0x%08x\n", 
                   i, computed, expected);
            errors++;
        }
    }
    if (errors == 0) printf("[SNITCH] Data verification: OK\n");
    return 0;
}
