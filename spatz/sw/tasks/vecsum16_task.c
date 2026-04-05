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
 * FP16 Vector-Vector Sum using RISC-V Vector Extension
 * Computes Z = X + Y where X, Y, Z are N×1 vectors
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "magia_spatz_utils.h"
#include "spatz_workers.h"

// DATA register address for reading parameter pointer
#define DATA_ADDR (SPATZ_DATA)

// Parameter structure in shared L1 memory
typedef struct {
    uint32_t x_addr;        // Vector X address [N×1]
    uint32_t y_addr;        // Vector Y address [N×1]
    uint32_t z_addr;        // Result Z address [N×1]
    uint32_t n_size;        // Vector length N
} vecsum_params_t;

// Main entry point
int vecsum16_task(void) {
    
    // Read parameter structure pointer from DATA register
    uint32_t params_ptr = mmio32(DATA_ADDR);
    volatile vecsum_params_t *params = (volatile vecsum_params_t *)params_ptr;
    
    const float16_t *X = (const float16_t *)params->x_addr;
    const float16_t *Y = (const float16_t *)params->y_addr;
    float16_t *Z = (float16_t *)params->z_addr;
    uint32_t N = params->n_size;
    
    // Vector addition: Z[N] = X[N] + Y[N]
    // Use stripmine loop for large vectors
    unsigned int avl = N;
    unsigned int vl;
    
    do {
        // Set vector length
        asm volatile("vsetvli %0, %1, e16, m8, ta, ma" : "=r"(vl) : "r"(avl));
        
        // Load X and Y vectors
        asm volatile("vle16.v v0, (%0)" ::"r"(X));
        asm volatile("vle16.v v8, (%0)" ::"r"(Y));
        
        // Vector floating-point add: v16 = v0 + v8
        asm volatile("vfadd.vv v16, v0, v8");
        
        // Store result
        asm volatile("vse16.v v16, (%0)" ::"r"(Z));
        
        // Bump pointers
        X += vl;
        Y += vl;
        Z += vl;
        avl -= vl;
    } while (avl > 0);
    
    return 0;
}
