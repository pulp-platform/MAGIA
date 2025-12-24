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
 * Authors: Luca Balboni <luca.balboni10@studio.unibo,it>
 *
 * 32-bit Interconnect Access Test Task for Spatz_cc
 */

#include <stdint.h>
#include "magia_tile_utils.h"

// Memory in L1
#define TEST_MEM32_BASE (L1_BASE + 0x00003000)
#define test_mem32 ((volatile uint32_t *)TEST_MEM32_BASE)

int interconnect32_check_task(void) {
    
    printf("[SNITCH] Testing 32-bit accesses\n");
    printf("[SNITCH] Using L1 memory at 0x%08x\n", TEST_MEM32_BASE);
    
    // =============================================
    // Test 1: Sequential 32-bit stores and loads
    // =============================================
    printf("[SNITCH] Sequential 32-bit store/load\n");
    
    for (int i = 0; i < 16; i++) {
        test_mem32[i] = 0x10000000 + i;
    }
    
    for (int i = 0; i < 16; i++) {
        if (test_mem32[i] != (uint32_t)(0x10000000 + i)) {
            printf("[SNITCH] ERROR: 32-bit store/load failed at [%d]\n", i);
        }
    }
    
    // =============================================
    // Test 2: Strided 32-bit access pattern
    // =============================================
    printf("[SNITCH] Strided 32-bit access\n");
    
    test_mem32[0] = 0xAAAAAAAA;
    test_mem32[2] = 0xBBBBBBBB;
    test_mem32[4] = 0xCCCCCCCC;
    test_mem32[6] = 0xDDDDDDDD;
    
    if (test_mem32[0] != 0xAAAAAAAA || test_mem32[4] != 0xCCCCCCCC) {
        printf("[SNITCH] ERROR: Strided access failed\n");
    }
    
    // =============================================
    // Test 3: Reverse order stores
    // =============================================
    printf("[SNITCH] Reverse order stores\n");
    
    for (int i = 7; i >= 0; i--) {
        test_mem32[i] = 0x30000000 + (7 - i);
    }
    
    if (test_mem32[0] != 0x30000007 || test_mem32[7] != 0x30000000) {
        printf("[SNITCH] ERROR: Reverse order failed\n");
    }
    
    // =============================================
    // Test 4: Alternating read/write pattern
    // =============================================
    printf("[SNITCH] Alternating read/write\n");
    
    uint32_t accumulator = 0;
    for (int i = 0; i < 8; i++) {
        test_mem32[i] = 0x40000000 + i;
        accumulator += test_mem32[i];
    }
    
    if (accumulator != 0x0000001C + (8 * 0x40000000)) {
        printf("[SNITCH] ERROR: Alternating pattern failed\n");
    }
    
    // =============================================
    // Test 7: Vector load/store 32-bit (vle32.v/vse32.v)
    // =============================================
    printf("[SNITCH] Vector load/store e32\n");
    
    // Initialize pattern for vector operations
    for (int i = 0; i < 16; i++) {
        test_mem32[i] = 0x70000000 + (i * 0x11);
    }
    
    // Configure vector: vtype = e32, m1, ta, ma (vl=8)
    asm volatile(
        "li t0, 8\n"
        "vsetvli zero, t0, e32, m1, ta, ma\n"
        ::: "t0"
    );
    
    // Vector load from test_mem32[0:7] into v1
    asm volatile(
        "vle32.v v1, (%0)\n"
        :: "r"(&test_mem32[0])
        : "memory"
    );
    
    // Vector store from v1 to test_mem32[16:23]
    asm volatile(
        "vse32.v v1, (%0)\n"
        :: "r"(&test_mem32[16])
        : "memory"
    );
    
    // Verify vector store
    for (int i = 0; i < 8; i++) {
        if (test_mem32[16 + i] != test_mem32[i]) {
            printf("[SNITCH] ERROR: Vector store failed at [%d], got 0x%08x expected 0x%08x\n",
                   i, test_mem32[16 + i], test_mem32[i]);
        }
    }
    
    return 0;
}
