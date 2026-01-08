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
 * 64-bit Interconnect Access Test Task for Spatz_cc 
 * !!! This task requires Spatz with RVD extension enabled !!!
 */

#include <stdint.h>
#include "magia_tile_utils.h"

// Memory in L1
#define TEST_MEM64_BASE (L1_BASE + 0x00004000)
#define test_mem64 ((volatile uint64_t *)TEST_MEM64_BASE)
#define test_mem32 ((volatile uint32_t *)TEST_MEM64_BASE)

int interconnect64_simple_task(void) {
    
    printf("[SNITCH] Testing 64 bit accesses\n");
    printf("[SNITCH] Using L1 memory at 0x%08x\n", TEST_MEM64_BASE);
    
    // =============================================
    // Test 1: 64-bit aligned stores and loads
    // =============================================
    printf("[SNITCH] 64-bit aligned store/load\n");
    
    test_mem64[0] = 0x123456789ABCDEF0ULL;
    test_mem64[1] = 0xFEDCBA9876543210ULL;
    test_mem64[2] = 0xAAAAAAAABBBBBBBBULL;
    test_mem64[3] = 0xCCCCCCCCDDDDDDDDULL;
    
    if (test_mem64[0] != 0x123456789ABCDEF0ULL) {
        printf("[SNITCH] ERROR: 64-bit store/load failed at [0]\n");
    }
    if (test_mem64[1] != 0xFEDCBA9876543210ULL) {
        printf("[SNITCH] ERROR: 64-bit store/load failed at [1]\n");
    }
    
    // =============================================
    // Test 2: 32-bit stores to 64-bit memory
    // =============================================
    printf("[SNITCH] 32-bit stores to 64-bit region\n");
    
    test_mem32[0] = 0x11111111;
    test_mem32[1] = 0x22222222;
    test_mem32[2] = 0x33333333;
    test_mem32[3] = 0x44444444;
    
    if (test_mem64[0] != 0x2222222211111111ULL) {
        printf("[SNITCH] ERROR: 32-bit stores failed, got 0x%08x%08x\n", 
               (uint32_t)(test_mem64[0] >> 32), (uint32_t)test_mem64[0]);
    }
    
    // =============================================
    // Test 3: Mixed 32/64 access patterns
    // =============================================
    printf("[SNITCH] Mixed 32/64-bit access pattern\n");
    
    test_mem64[4] = 0xDEADBEEFCAFEBABEULL;
    uint32_t low_word = test_mem32[8];
    uint32_t high_word = test_mem32[9];
    
    if (low_word != 0xCAFEBABE || high_word != 0xDEADBEEF) {
        printf("[SNITCH] ERROR: Mixed access failed, low=0x%08x high=0x%08x\n", 
               low_word, high_word);
    }
    
    // =============================================
    // Test 4: Sequential 64-bit loads (stress reqrsp64toobi32)
    // =============================================
    printf("[SNITCH] Sequential 64-bit loads\n");
    
    for (int i = 0; i < 8; i++) {
        test_mem64[i] = (uint64_t)i * 0x0101010101010101ULL;
    }
    
    uint64_t sum = 0;
    for (int i = 0; i < 8; i++) {
        sum += test_mem64[i];
    }
    
    uint64_t expected_sum = 0x1C1C1C1C1C1C1C1CULL;
    if (sum != expected_sum) {
        printf("[SNITCH] ERROR: Sequential load sum mismatch\n");
    }
    
    // =============================================
    // Test 5: Alternating 32/64 stores (stress tcdm64todualtcdm32)
    // =============================================
    printf("[SNITCH] Alternating 32/64-bit stores\n");
    
    test_mem64[0] = 0x0000000000000000ULL;
    test_mem32[0] = 0xAAAAAAAA;  // Writes to low word of test_mem64[0]
    test_mem64[1] = 0x5555555555555555ULL;
    test_mem32[2] = 0xBBBBBBBB;  // Writes to low word of test_mem64[1]
    
    if (test_mem64[0] != 0x00000000AAAAAAAAULL) {
        printf("[SNITCH] ERROR: Alternating store failed at [0], got 0x%08x%08x\n", 
               (uint32_t)(test_mem64[0] >> 32), (uint32_t)test_mem64[0]);
    }
    if (test_mem64[1] != 0x55555555BBBBBBBBULL) {
        printf("[SNITCH] ERROR: Alternating store failed at [1], got 0x%08x%08x\n",
               (uint32_t)(test_mem64[1] >> 32), (uint32_t)test_mem64[1]);
    }
    
    // =============================================
    // Test 6: Unaligned 32-bit accesses
    // =============================================
    printf("[SNITCH] Unaligned 32-bit accesses\n");
    
    test_mem32[1] = 0x12345678;
    test_mem32[3] = 0x9ABCDEF0;
    test_mem32[5] = 0xFEDCBA98;
    
    if (test_mem32[1] != 0x12345678) {
        printf("[SNITCH] ERROR: Unaligned access failed\n");
    }
    
    // =============================================
    // Test 7: Vector load/store 64-bit (vle64.v/vse64.v)
    // =============================================
    printf("[SNITCH] Vector load/store e64\n");
    
    // Initialize pattern for vector operations
    for (int i = 0; i < 8; i++) {
        test_mem64[i] = 0x7000000000000000ULL + ((uint64_t)i * 0x1111111111111111ULL);
    }
    
    // Configure vector: vtype = e64, m1, ta, ma (vl=4)
    asm volatile(
        "li t0, 4\n"
        "vsetvli zero, t0, e64, m1, ta, ma\n"
        ::: "t0"
    );
    
    // Vector load from test_mem64[0:3] into v2
    asm volatile(
        "vle64.v v2, (%0)\n"
        :: "r"(&test_mem64[0])
        : "memory"
    );
    
    // Vector store from v2 to test_mem64[8:11]
    asm volatile(
        "vse64.v v2, (%0)\n"
        :: "r"(&test_mem64[8])
        : "memory"
    );
    
    // Verify vector store
    for (int i = 0; i < 4; i++) {
        if (test_mem64[8 + i] != test_mem64[i]) {
            printf("[SNITCH] ERROR: Vector store failed at [%d], got 0x%08x%08x expected 0x%08x%08x\n",
                   i, (uint32_t)(test_mem64[8 + i] >> 32), (uint32_t)test_mem64[8 + i],
                   (uint32_t)(test_mem64[i] >> 32), (uint32_t)test_mem64[i]);
        }
    }
    
    return 0;
}
