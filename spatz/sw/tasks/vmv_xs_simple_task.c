/*
 * Copyright (C) 2023-2024 ETH Zurich and University of Bologna
 *
 * Simple test task for vmv.x.s instruction with e32
 */

#include <stdint.h>
#include "magia_tile_utils.h"

int vmv_xs_simple_task(void) {
    
    int32_t result_e32;
    uint32_t vl_result;
    
    // Set vtype to e32, m1
    asm volatile("vsetvli %0, %1, e32, m1, ta, ma" : "=r"(vl_result) : "r"(1));
    
    // Load value into vector register
    asm volatile("li t0, 5678");
    asm volatile("vmv.s.x v0, t0");
    
    // Move from vector to scalar
    asm volatile("vmv.x.s %0, v0" : "=r"(result_e32));
    
    // Check result
    if (result_e32 == 5678) {
        printf("PASS: result=%d\n", result_e32);
    } else {
        printf("FAIL: result=%d (expected 5678)\n", result_e32);
    }
    
    return 0;
}
