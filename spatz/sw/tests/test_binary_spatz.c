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
 * Tests:
 * - L1 access via tcdm2hci_atomic (Snitch TCDM port)
 * - L2 access via reqrsp2obi (Snitch data port → OBI)
 * - L1 to L2 copy
 * - Vector operations via Spatz offload (RVD=0, ELEN=32, VLEN=256)
 */

#include "../../sw/utils/magia_tile_utils.h"
#include "../../sw/utils/magia_spatz_utils.h"

#define L1_END          (L1_BASE + L1_SIZE)
#define L2_DATARAM_BASE (0xCC010000)
#define L2_DATARAM_END  (0xCC03FFFF)

// Entry point
void _start(void) __attribute__((section(".text.start")));

void _start(void) {
    volatile uint32_t *ptr;
    int errors;
    
    printf("Spatz memory boundary test\n");
    
    // TEST 1: L1 start boundary (0x00020000)
    printf("TEST 1: L1 start\n");
    errors = 0;
    ptr = (volatile uint32_t*)L1_BASE;
    ptr[0] = 0x11111111;
    ptr[1] = 0x22222222;
    
    if (ptr[0] != 0x11111111) errors++;
    if (ptr[1] != 0x22222222) errors++;
    
    if (errors == 0) printf("  L1 start PASS\n");
    else printf("  L1 start FAIL\n");
    
    // TEST 2: L1 high address (near 0x000FFFFF end)
    printf("TEST 2: L1 high\n");
    errors = 0;
    ptr = (volatile uint32_t*)0x000FFF00;
    ptr[0] = 0x33333333;
    ptr[1] = 0x44444444;
    
    if (ptr[0] != 0x33333333) errors++;
    if (ptr[1] != 0x44444444) errors++;
    
    if (errors == 0) printf("  L1 high PASS\n");
    else printf("  L1 high FAIL\n");
    
    // TEST 3: L2 dataram start (0xCC010000)
    printf("TEST 3: L2 start\n");
    errors = 0;
    ptr = (volatile uint32_t*)L2_DATARAM_BASE;
    ptr[0] = 0xAAAAAAAA;
    ptr[1] = 0xBBBBBBBB;
    
    if (ptr[0] != 0xAAAAAAAA) errors++;
    if (ptr[1] != 0xBBBBBBBB) errors++;
    
    if (errors == 0) printf("  L2 start PASS\n");
    else printf("  L2 start FAIL\n");
    
    // TEST 4: L2 dataram high address (near 0xCC03FFFF end)
    printf("TEST 4: L2 high\n");
    errors = 0;
    ptr = (volatile uint32_t*)0xCC03FF00;
    ptr[0] = 0xCCCCCCCC;
    ptr[1] = 0xDDDDDDDD;
    
    if (ptr[0] != 0xCCCCCCCC) errors++;
    if (ptr[1] != 0xDDDDDDDD) errors++;
    
    if (errors == 0) printf("  L2 high PASS\n");
    else printf("  L2 high FAIL\n");
    
    // TEST 5: Vector operations in L1 middle region
    printf("TEST 5: Vector operations\n");
    
    volatile uint32_t *vec_src = (volatile uint32_t*)(L1_BASE + 0x10000);
    volatile uint32_t *vec_dst = (volatile uint32_t*)(L1_BASE + 0x20000);
    volatile uint16_t *vec_src_h = (volatile uint16_t*)(L1_BASE + 0x30000);
    volatile uint16_t *vec_dst_h = (volatile uint16_t*)(L1_BASE + 0x40000);
    
    int total_errors = 0;
    
    // TEST 4a: e32 with VL=8
    vec_src[0] = 0x11111111;
    vec_src[1] = 0x22222222;
    vec_src[2] = 0x33333333;
    vec_src[3] = 0x44444444;
    vec_src[4] = 0x55555555;
    vec_src[5] = 0x66666666;
    vec_src[6] = 0x77777777;
    vec_src[7] = 0x88888888;
    for (int i = 0; i < 8; i++) vec_dst[i] = 0;
    
    asm volatile (
        "vsetvli zero, %0, e32, m1, ta, ma\n"
        "vle32.v v1, (%1)\n"
        "vse32.v v1, (%2)\n"
        :
        : "r"(8), "r"(vec_src), "r"(vec_dst)
        : "memory"
    );
    
    if (vec_dst[0] != 0x11111111) total_errors++;
    if (vec_dst[1] != 0x22222222) total_errors++;
    if (vec_dst[2] != 0x33333333) total_errors++;
    if (vec_dst[3] != 0x44444444) total_errors++;
    if (vec_dst[4] != 0x55555555) total_errors++;
    if (vec_dst[5] != 0x66666666) total_errors++;
    if (vec_dst[6] != 0x77777777) total_errors++;
    if (vec_dst[7] != 0x88888888) total_errors++;
    
    // TEST 4b: e32 with VL=2
    vec_src[0] = 0xAAAAAAAA;
    vec_src[1] = 0xBBBBBBBB;
    for (int i = 0; i < 4; i++) vec_dst[i] = 0;
    
    asm volatile (
        "vsetvli zero, %0, e32, m1, ta, ma\n"
        "vle32.v v2, (%1)\n"
        "vse32.v v2, (%2)\n"
        :
        : "r"(2), "r"(vec_src), "r"(vec_dst)
        : "memory"
    );
    
    if (vec_dst[0] != 0xAAAAAAAA) total_errors++;
    if (vec_dst[1] != 0xBBBBBBBB) total_errors++;
    
    // TEST 4c: e16 with VL=4
    vec_src_h[0] = 0x0001;
    vec_src_h[1] = 0x0002;
    vec_src_h[2] = 0x0003;
    vec_src_h[3] = 0x0004;
    for (int i = 0; i < 4; i++) vec_dst_h[i] = 0;
    
    asm volatile (
        "vsetvli zero, %0, e16, m1, ta, ma\n"
        "vle16.v v3, (%1)\n"
        "vse16.v v3, (%2)\n"
        :
        : "r"(4), "r"(vec_src_h), "r"(vec_dst_h)
        : "memory"
    );
    
    if (vec_dst_h[0] != 0x0001) total_errors++;
    if (vec_dst_h[1] != 0x0002) total_errors++;
    if (vec_dst_h[2] != 0x0003) total_errors++;
    if (vec_dst_h[3] != 0x0004) total_errors++;
    
    if (total_errors == 0) printf("  Vector PASS\n");
    else printf("  Vector FAIL\n");
    
    // Results
    printf("Test complete\n");
    
    // Signal done
    spatz_done();
}
