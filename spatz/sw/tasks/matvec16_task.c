/*
 * Copyright (C) 2026 ETH Zurich, University of Bologna and Fondazione Chips-IT
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
 *
 * FP16 Matrix-Vector Multiplication (GEMV) - Optimized Spatz Implementation
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "magia_spatz_utils.h"
#include "spatz_workers.h"

#define DATA_ADDR (SPATZ_DATA)

typedef struct __attribute__((packed)) {
    uint32_t mat_addr;
    uint32_t vec_x_addr;
    uint32_t vec_y_addr;
    uint32_t dst_addr;
    uint16_t alpha;
    uint16_t beta;
    uint32_t m_size;
    uint32_t n_size;
} matvec_params_t;

/* Task entry point */

int matvec16_task(void) {
    
    uint32_t params_ptr = mmio32(DATA_ADDR);
    volatile matvec_params_t *params = (volatile matvec_params_t *)params_ptr;
    
    float16_t *mat = (float16_t *)params->mat_addr;
    float16_t *vec_x = (float16_t *)params->vec_x_addr;
    float16_t *dst = (float16_t *)params->dst_addr;
    uint32_t M = params->m_size;
    uint32_t N = params->n_size;
    gemv_v16b_m4((__fp16 *)mat, (__fp16 *)vec_x, (__fp16 *)dst, M, M, N);
    
    return 0;
}
