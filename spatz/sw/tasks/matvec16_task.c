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
 * FP16 Matrix-Vector Multiplication (GEMV)
 * Based on PLAY library: https://github.com/FondazioneChipsIT/PLAY
 * source/linalg_gemv/arch/linalg_gemv_spatz.c
 * 
 * Computes: dst = α·mat·vec_x + β·vec_y
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

/* Helper functions adapted from PLAY library */

static inline int vector_set_all_spatz(float16_t *vec, const float16_t val, const int len)
{
    const float16_t *v;
    size_t avl;
    size_t vl;

    avl = len;
    v = vec;

    asm volatile ("vsetvli %0, %1, e16, m8, ta, ma" : "=r"(vl) : "r"(avl));
    asm volatile ("vfmv.v.f v0, %0" :: "f"(val));

    for (; avl > 0; avl -= vl) {
        asm volatile ("vsetvli %0, %1, e16, m8, ta, ma" : "=r"(vl) : "r"(avl));
        asm volatile ("vse16.v v0, (%0)" :: "r"(v));
        v += vl;
    }

    return 0;
}

static inline int vector_memcpy_spatz(const float16_t *src, float16_t *dst, const int len)
{
    size_t avl;
    size_t vl;
    const float16_t *p_src;
    float16_t *p_dst;

    avl = len;
    p_src = src;
    p_dst = dst;

    for (; avl > 0; avl -= vl) {
        asm volatile ("vsetvli %0, %1, e16, m8, ta, ma" : "=r"(vl) : "r"(avl));
        asm volatile ("vle16.v v0, (%0)" :: "r"(p_src));
        asm volatile ("vse16.v v0, (%0)" :: "r"(p_dst));
        p_src += vl;
        p_dst += vl;
    }

    return 0;
}

static inline int vector_scale_spatz(const float16_t *src, const float16_t val, float16_t *dst, const int len)
{
    size_t avl;
    size_t vl;
    const float16_t *p_src;
    float16_t *p_dst;

    avl = len;
    p_src = src;
    p_dst = dst;

    for (; avl > 0; avl -= vl) {
        asm volatile ("vsetvli %0, %1, e16, m8, ta, ma" : "=r"(vl) : "r"(avl));
        asm volatile ("vle16.v v0, (%0)" :: "r"(p_src));
        asm volatile ("vfmul.vf v8, v0, %0" :: "f"(val));
        asm volatile ("vse16.v v8, (%0)" :: "r"(p_dst));
        p_src += vl;
        p_dst += vl;
    }

    return 0;
}

/* Main GEMV function - direct translation from PLAY linalg_gemv_spatz.c */

static int linalg_gemv_spatz_serial(
    const float16_t *mat, 
    const float16_t *vec_x, 
    const float16_t *vec_y,
    const float16_t alpha, 
    const float16_t beta, 
    float16_t *dst, 
    const int dim_M, 
    const int dim_N)
{
    float16_t ZERO_f = 0.0f;
    float16_t ONE_f = 1.0f;

    const float16_t *col_m;
    float16_t *p_dst;
    float16_t elem_x;

    size_t stride;
    size_t avl;
    size_t vl;

    // CRITICAL FIX: Use bit pattern comparison for FP16
    // Direct float comparison (alpha == ZERO_f) fails because it compares FP16 vs FP32
    uint16_t alpha_bits = *(uint16_t *)&alpha;
    uint16_t beta_bits = *(uint16_t *)&beta;
    uint16_t zero_bits = 0x0000;
    uint16_t one_bits = 0x3C00;

    if (alpha_bits == zero_bits) {
        if (beta_bits == zero_bits)
            vector_set_all_spatz(dst, ZERO_f, dim_M);
        else if (beta_bits == one_bits)
            vector_memcpy_spatz(vec_y, dst, dim_M);
        else
            vector_scale_spatz(vec_y, beta, dst, dim_M);
        return 0;
    }

    if (beta_bits == zero_bits)
        vector_set_all_spatz(dst, ZERO_f, dim_M);
    else if (beta_bits == one_bits)
        vector_memcpy_spatz(vec_y, dst, dim_M);
    else
        vector_scale_spatz(vec_y, beta, dst, dim_M);

    avl = dim_M;
    p_dst = dst;
    stride = dim_N * sizeof(float16_t);

    for (; avl > 0; avl -= vl) {
        asm volatile ("vsetvli %0, %1, e16, m8, ta, ma" : "=r"(vl) : "r"(avl));
        asm volatile ("vfmv.v.f v0, %0" :: "f"(ZERO_f));
        asm volatile ("vle16.v v24, (%0)" :: "r"(p_dst));

        for (int n = 0; n < dim_N; n++) {
            col_m = mat + n;
            elem_x = vec_x[n];
            asm volatile ("vlse16.v v8, (%0), %1" :: "r"(col_m), "r"(stride));
            asm volatile ("vfmacc.vf v0, %0, v8" :: "f"(elem_x));
        }

        asm volatile ("vfmul.vf v0, v0, %0" :: "f"(alpha));
        asm volatile ("vfadd.vv v0, v24, v0");
        asm volatile ("vse16.v v0, (%0)" :: "r"(p_dst));

        p_dst += vl;
    }

    return 0;
}

/* Task entry point */

int matvec16_task(void) {
    
    uint32_t params_ptr = mmio32(DATA_ADDR);
    volatile matvec_params_t *params = (volatile matvec_params_t *)params_ptr;
    
    float16_t *mat = (float16_t *)params->mat_addr;
    float16_t *vec_x = (float16_t *)params->vec_x_addr;
    float16_t *vec_y = (float16_t *)params->vec_y_addr;
    float16_t *dst = (float16_t *)params->dst_addr;
    uint32_t M = params->m_size;
    uint32_t N = params->n_size;
    
    // Bitcast uint16_t to float16_t
    union { uint16_t u; float16_t f; } alpha_u, beta_u;
    alpha_u.u = params->alpha;
    beta_u.u = params->beta;
    
    linalg_gemv_spatz_serial(mat, vec_x, vec_y, alpha_u.f, beta_u.f, dst, M, N);
    
    return 0;
}
