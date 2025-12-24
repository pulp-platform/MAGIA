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
 * Spatz Vector Utilities - Based on Spatz Benchmarks
 * Provides optimized vector kernels for various operations
 */


#ifndef _SPATZ_UTILS_H_
#define _SPATZ_UTILS_H_

#include <stdint.h>

// FP16 type alias
typedef uint16_t fp16_t;
typedef _Float16 float16_t;

// =============================================================================
// Dot Product Kernels (from spatzBenchmarks/dp-fdotp)
// =============================================================================

// 64-bit dot-product: a * b
static inline double fdotp_v64b(const double *a, const double *b, unsigned int avl) {
  const unsigned int orig_avl = avl;
  unsigned int vl;
  double red;

  // Clean the accumulator
  asm volatile("vsetvli %0, %1, e64, m8, ta, ma" : "=r"(vl) : "r"(avl));
  asm volatile("vmv.s.x v0, zero");

  // Stripmine and accumulate a partial reduced vector
  do {
    // Set the vl
    asm volatile("vsetvli %0, %1, e64, m8, ta, ma" : "=r"(vl) : "r"(avl));

    // Load chunk a and b
    asm volatile("vle64.v v8,  (%0)" ::"r"(a));
    asm volatile("vle64.v v16, (%0)" ::"r"(b));

    // Multiply and accumulate
    if (avl == orig_avl) {
      asm volatile("vfmul.vv v24, v8, v16");
    } else {
      asm volatile("vfmacc.vv v24, v8, v16");
    }

    // Bump pointers
    a += vl;
    b += vl;
    avl -= vl;
  } while (avl > 0);

  // Reduce and return
  asm volatile("vsetvli zero, %0, e64, m8, ta, ma" ::"r"(orig_avl));
  asm volatile("vfredusum.vs v0, v24, v0");
  asm volatile("vfmv.f.s %0, v0" : "=f"(red));

  return red;
}

// 32-bit dot-product: a * b
static inline float fdotp_v32b(const float *a, const float *b, unsigned int avl) {
  const unsigned int orig_avl = avl;
  unsigned int vl;
  float red;

  asm volatile("vsetvli %0, %1, e32, m8, ta, ma" : "=r"(vl) : "r"(avl));
  asm volatile("vmv.s.x v0, zero");

  // Stripmine and accumulate a partial reduced vector
  do {
    // Set the vl
    asm volatile("vsetvli %0, %1, e32, m8, ta, ma" : "=r"(vl) : "r"(avl));

    // Load chunk a and b
    asm volatile("vle32.v v8,  (%0)" ::"r"(a));
    asm volatile("vle32.v v16, (%0)" ::"r"(b));

    // Multiply and accumulate
    if (avl == orig_avl) {
      asm volatile("vfmul.vv v24, v8, v16");
    } else {
      asm volatile("vfmacc.vv v24, v8, v16");
    }

    // Bump pointers
    a += vl;
    b += vl;
    avl -= vl;
  } while (avl > 0);

  // Reduce and return
  asm volatile("vsetvli zero, %0, e32, m8, ta, ma" ::"r"(orig_avl));
  asm volatile("vfredusum.vs v0, v24, v0");
  asm volatile("vfmv.f.s %0, v0" : "=f"(red));
  return red;
}

// 16-bit dot-product: a * b
static inline float16_t fdotp_v16b(const float16_t *a, const float16_t *b, unsigned int avl) {
  const unsigned int orig_avl = avl;
  unsigned int vl;
  float16_t red;

  asm volatile("vsetvli %0, %1, e16, m8, ta, ma" : "=r"(vl) : "r"(avl));
  asm volatile("vmv.s.x v0, zero");

  // Stripmine and accumulate a partial reduced vector
  do {
    // Set the vl
    asm volatile("vsetvli %0, %1, e16, m8, ta, ma" : "=r"(vl) : "r"(avl));

    // Load chunk a and b
    asm volatile("vle16.v v8,  (%0)" ::"r"(a));
    asm volatile("vle16.v v16, (%0)" ::"r"(b));

    // Multiply and accumulate
    if (avl == orig_avl) {
      asm volatile("vfmul.vv v24, v8, v16");
    } else {
      asm volatile("vfmacc.vv v24, v8, v16");
    }

    // Bump pointers
    a += vl;
    b += vl;
    avl -= vl;
  } while (avl > 0);

  // Reduce and return
  asm volatile("vsetvli zero, %0, e16, m8, ta, ma" ::"r"(orig_avl));
  asm volatile("vfredusum.vs v0, v24, v0");
  asm volatile("vfmv.f.s %0, v0" : "=f"(red));
  return red;
}

// =============================================================================
// AXPY Kernels (from spatzBenchmarks/dp-faxpy): y = a * x + y
// =============================================================================

// 64-bit AXPY: y = a * x + y
static inline void faxpy_v64b(const double a, const double *x, const double *y, unsigned int avl) {
  unsigned int vl;

  // Stripmine and accumulate a partial vector
  do {
    // Set the vl
    asm volatile("vsetvli %0, %1, e64, m8, ta, ma" : "=r"(vl) : "r"(avl));

    // Load vectors
    asm volatile("vle64.v v0, (%0)" ::"r"(x));
    asm volatile("vle64.v v8, (%0)" ::"r"(y));

    // Multiply-accumulate
    asm volatile("vfmacc.vf v8, %0, v0" ::"f"(a));

    // Store results
    asm volatile("vse64.v v8, (%0)" ::"r"(y));

    // Bump pointers
    x += vl;
    y += vl;
    avl -= vl;
  } while (avl > 0);
}

// 32-bit AXPY: y = a * x + y
static inline void faxpy_v32b(const float a, const float *x, const float *y, unsigned int avl) {
  unsigned int vl;

  // Stripmine and accumulate a partial vector
  do {
    // Set the vl
    asm volatile("vsetvli %0, %1, e32, m8, ta, ma" : "=r"(vl) : "r"(avl));

    // Load vectors
    asm volatile("vle32.v v0, (%0)" ::"r"(x));
    asm volatile("vle32.v v8, (%0)" ::"r"(y));

    // Multiply-accumulate
    asm volatile("vfmacc.vf v8, %0, v0" ::"f"(a));

    // Store results
    asm volatile("vse32.v v8, (%0)" ::"r"(y));

    // Bump pointers
    x += vl;
    y += vl;
    avl -= vl;
  } while (avl > 0);
}

// 16-bit AXPY: y = a * x + y
static inline void faxpy_v16b(const float16_t a, const float16_t *x, const float16_t *y, unsigned int avl) {
  unsigned int vl;

  // Stripmine and accumulate a partial vector
  do {
    // Set the vl
    asm volatile("vsetvli %0, %1, e16, m8, ta, ma" : "=r"(vl) : "r"(avl));

    // Load vectors
    asm volatile("vle16.v v0, (%0)" ::"r"(x));
    asm volatile("vle16.v v8, (%0)" ::"r"(y));

    // Multiply-accumulate
    asm volatile("vfmacc.vf v8, %0, v0" ::"f"(a));

    // Store results
    asm volatile("vse16.v v8, (%0)" ::"r"(y));

    // Bump pointers
    x += vl;
    y += vl;
    avl -= vl;
  } while (avl > 0);
}

// =============================================================================
// Matrix Multiplication Kernels (from spatzBenchmarks/dp-fmatmul)
// =============================================================================

#ifndef MIN
#define MIN(a, b) ((a) < (b) ? (a) : (b))
#endif

// Forward declarations
static inline void fmatmul_v64b_2xVL(double *c, const double *a, const double *b,
                                      const unsigned int m_start, const unsigned int m_end,
                                      const unsigned int N, const unsigned int P,
                                      const unsigned int p_start, const unsigned int p_end);
static inline void fmatmul_v64b_4xVL(double *c, const double *a, const double *b,
                                      const unsigned int m_start, const unsigned int m_end,
                                      const unsigned int N, const unsigned int P,
                                      const unsigned int p_start, const unsigned int p_end);
static inline void fmatmul_v64b_8xVL(double *c, const double *a, const double *b,
                                      const unsigned int m_start, const unsigned int m_end,
                                      const unsigned int N, const unsigned int P,
                                      const unsigned int p_start, const unsigned int p_end);

// Matrix multiplication wrapper - automatically selects optimal variant
// Computes C = A × B where C is MxP, A is MxN, B is NxP
static inline void fmatmul_v64b(double *c, const double *a, const double *b,
                                const unsigned int M, const unsigned int N,
                                const unsigned int P) {
  if (M <= 4) {
    fmatmul_v64b_2xVL(c, a, b, 0, M, N, P, 0, P);
  } else if (M <= 8) {
    fmatmul_v64b_4xVL(c, a, b, 0, M, N, P, 0, P);
  } else {
    fmatmul_v64b_8xVL(c, a, b, 0, M, N, P, 0, P);
  }
}

// 2xVL variant - optimized for small matrices (M <= 4)
static inline void fmatmul_v64b_2xVL(double *c, const double *a, const double *b,
                                      const unsigned int m_start, const unsigned int m_end,
                                      const unsigned int N, const unsigned int P,
                                      const unsigned int p_start, const unsigned int p_end) {
  unsigned int p = p_start;
  while (p < p_end) {
    // Calculate the vl
    size_t gvl;
    asm volatile("vsetvli %[gvl], %[vl], e64, m8, ta, ma"
                 : [gvl] "=r"(gvl)
                 : [vl] "r"(p_end - p));

    const double *b_ = b + p;
    double *c_ = c + p;

    for (unsigned int m = m_start; m < m_end; m += 2) {
      const double *a_ = a + m * N;
      const double *a__ = a_;

      asm volatile("vle64.v v16, (%0);" ::"r"(b_));
      const double *b__ = b_ + P;

      double *c__ = c_ + m * P;

      double t0, t1;

      t0 = *a__;
      a__ += N;
      t1 = *a__;

      unsigned int n = 0;

      while (n < N) {
        a__ = a_ + ++n;

        asm volatile("vle64.v v24, (%0);" ::"r"(b__));
        b__ += P;

        if (n == 1) {
          asm volatile("vfmul.vf v0, v16, %0" ::"f"(t0));
          t0 = *a__;
          a__ += N;
          asm volatile("vfmul.vf v8, v16, %0" ::"f"(t1));
          t1 = *a__;
        } else {
          asm volatile("vfmacc.vf v0, %0, v16" ::"f"(t0));
          t0 = *a__;
          a__ += N;
          asm volatile("vfmacc.vf v8, %0, v16" ::"f"(t1));
          t1 = *a__;
        }

        a__ = a_ + ++n;

        if (n == N)
          break;

        asm volatile("vle64.v v16, (%0);" ::"r"(b__));
        b__ += P;

        asm volatile("vfmacc.vf v0, %0, v24" ::"f"(t0));
        t0 = *a__;
        a__ += N;
        asm volatile("vfmacc.vf v8, %0, v24" ::"f"(t1));
        t1 = *a__;
      }

      asm volatile("vfmacc.vf v0, %0, v24" ::"f"(t0));
      asm volatile("vse64.v v0, (%0);" ::"r"(c__));
      c__ += P;
      asm volatile("vfmacc.vf v8, %0, v24" ::"f"(t1));
      asm volatile("vse64.v v8, (%0);" ::"r"(c__));
    }

    p += gvl;
  }
}

// 4xVL variant - optimized for medium matrices (M <= 8)
static inline void fmatmul_v64b_4xVL(double *c, const double *a, const double *b,
                                      const unsigned int m_start, const unsigned int m_end,
                                      const unsigned int N, const unsigned int P,
                                      const unsigned int p_start, const unsigned int p_end) {
  unsigned int p = p_start;
  while (p < p_end) {
    // Calculate the vl
    size_t gvl;
    asm volatile("vsetvli %[gvl], %[vl], e64, m4, ta, ma"
                 : [gvl] "=r"(gvl)
                 : [vl] "r"(p_end - p));

    const double *b_ = b + p;
    double *c_ = c + p;

    for (unsigned int m = m_start; m < m_end; m += 4) {
      const double *a_ = a + m * N;
      const double *a__ = a_;

      asm volatile("vle64.v v16, (%0);" ::"r"(b_));
      const double *b__ = b_ + P;

      double *c__ = c_ + m * P;

      double t0, t1, t2, t3;

      t0 = *a__;
      a__ += N;
      t1 = *a__;
      a__ += N;
      t2 = *a__;
      a__ += N;
      t3 = *a__;

      unsigned int n = 0;

      while (n < N) {
        asm volatile("vle64.v v20, (%0);" ::"r"(b__));
        b__ += P;

        a__ = a_ + ++n;

        if (n == 1) {
          asm volatile("vfmul.vf v0, v16, %0" ::"f"(t0));
          t0 = *a__;
          a__ += N;
          asm volatile("vfmul.vf v4, v16, %0" ::"f"(t1));
          t1 = *a__;
          a__ += N;
          asm volatile("vfmul.vf v8, v16, %0" ::"f"(t2));
          t2 = *a__;
          a__ += N;
          asm volatile("vfmul.vf v12, v16, %0" ::"f"(t3));
          t3 = *a__;
        } else {
          asm volatile("vfmacc.vf v0, %0, v16" ::"f"(t0));
          t0 = *a__;
          a__ += N;
          asm volatile("vfmacc.vf v4, %0, v16" ::"f"(t1));
          t1 = *a__;
          a__ += N;
          asm volatile("vfmacc.vf v8, %0, v16" ::"f"(t2));
          t2 = *a__;
          a__ += N;
          asm volatile("vfmacc.vf v12, %0, v16" ::"f"(t3));
          t3 = *a__;
        }

        a__ = a_ + ++n;

        if (n == N)
          break;

        asm volatile("vle64.v v16, (%0);" ::"r"(b__));
        b__ += P;

        asm volatile("vfmacc.vf v0, %0, v20" ::"f"(t0));
        t0 = *a__;
        a__ += N;
        asm volatile("vfmacc.vf v4, %0, v20" ::"f"(t1));
        t1 = *a__;
        a__ += N;
        asm volatile("vfmacc.vf v8, %0, v20" ::"f"(t2));
        t2 = *a__;
        a__ += N;
        asm volatile("vfmacc.vf v12, %0, v20" ::"f"(t3));
        t3 = *a__;
      }

      asm volatile("vfmacc.vf v0, %0, v20" ::"f"(t0));
      asm volatile("vse64.v v0, (%0);" ::"r"(c__));
      c__ += P;
      asm volatile("vfmacc.vf v4, %0, v20" ::"f"(t1));
      asm volatile("vse64.v v4, (%0);" ::"r"(c__));
      c__ += P;
      asm volatile("vfmacc.vf v8, %0, v20" ::"f"(t2));
      asm volatile("vse64.v v8, (%0);" ::"r"(c__));
      c__ += P;
      asm volatile("vfmacc.vf v12, %0, v20" ::"f"(t3));
      asm volatile("vse64.v v12, (%0);" ::"r"(c__));
    }

    p += gvl;
  }
}

// 8xVL variant - optimized for larger matrices (M > 8)
static inline void fmatmul_v64b_8xVL(double *c, const double *a, const double *b,
                                      const unsigned int m_start, const unsigned int m_end,
                                      const unsigned int N, const unsigned int P,
                                      const unsigned int p_start, const unsigned int p_end) {
  unsigned int p = p_start;
  while (p < p_end) {
    // Calculate the vl
    size_t gvl;
    asm volatile("vsetvli %[gvl], %[vl], e64, m2, ta, ma"
                 : [gvl] "=r"(gvl)
                 : [vl] "r"(p_end - p));

    const double *b_ = b + p;
    double *c_ = c + p;

    for (unsigned int m = m_start; m < m_end; m += 8) {
      const double *a_ = a + m * N;
      const double *a__ = a_;

      asm volatile("vle64.v v18, (%0);" ::"r"(b_));
      const double *b__ = b_ + P;

      double *c__ = c_ + m * P;

      double t0, t1, t2, t3, t4, t5, t6, t7;

      t0 = *a__;
      a__ += N;
      t1 = *a__;
      a__ += N;
      t2 = *a__;
      a__ += N;
      t3 = *a__;
      a__ += N;
      t4 = *a__;
      a__ += N;
      t5 = *a__;
      a__ += N;
      t6 = *a__;
      a__ += N;
      t7 = *a__;

      unsigned int n = 0;

      while (n < N) {
        a__ = a_ + ++n;

        asm volatile("vle64.v v20, (%0);" ::"r"(b__));
        b__ += P;

        if (n == 1) {
          asm volatile("vfmul.vf v0, v18, %0" ::"f"(t0));
          t0 = *a__;
          a__ += N;
          asm volatile("vfmul.vf v2, v18, %0" ::"f"(t1));
          t1 = *a__;
          a__ += N;
          asm volatile("vfmul.vf v4, v18, %0" ::"f"(t2));
          t2 = *a__;
          a__ += N;
          asm volatile("vfmul.vf v6, v18, %0" ::"f"(t3));
          t3 = *a__;
          a__ += N;
          asm volatile("vfmul.vf v8, v18, %0" ::"f"(t4));
          t4 = *a__;
          a__ += N;
          asm volatile("vfmul.vf v10, v18, %0" ::"f"(t5));
          t5 = *a__;
          a__ += N;
          asm volatile("vfmul.vf v12, v18, %0" ::"f"(t6));
          t6 = *a__;
          a__ += N;
          asm volatile("vfmul.vf v14, v18, %0" ::"f"(t7));
          t7 = *a__;
        } else {
          asm volatile("vfmacc.vf v0, %0, v18" ::"f"(t0));
          t0 = *a__;
          a__ += N;
          asm volatile("vfmacc.vf v2, %0, v18" ::"f"(t1));
          t1 = *a__;
          a__ += N;
          asm volatile("vfmacc.vf v4, %0, v18" ::"f"(t2));
          t2 = *a__;
          a__ += N;
          asm volatile("vfmacc.vf v6, %0, v18" ::"f"(t3));
          t3 = *a__;
          a__ += N;
          asm volatile("vfmacc.vf v8, %0, v18" ::"f"(t4));
          t4 = *a__;
          a__ += N;
          asm volatile("vfmacc.vf v10, %0, v18" ::"f"(t5));
          t5 = *a__;
          a__ += N;
          asm volatile("vfmacc.vf v12, %0, v18" ::"f"(t6));
          t6 = *a__;
          a__ += N;
          asm volatile("vfmacc.vf v14, %0, v18" ::"f"(t7));
          t7 = *a__;
        }

        a__ = a_ + ++n;

        if (n == N)
          break;

        asm volatile("vle64.v v18, (%0);" ::"r"(b__));
        b__ += P;

        asm volatile("vfmacc.vf v0, %0, v20" ::"f"(t0));
        t0 = *a__;
        a__ += N;
        asm volatile("vfmacc.vf v2, %0, v20" ::"f"(t1));
        t1 = *a__;
        a__ += N;
        asm volatile("vfmacc.vf v4, %0, v20" ::"f"(t2));
        t2 = *a__;
        a__ += N;
        asm volatile("vfmacc.vf v6, %0, v20" ::"f"(t3));
        t3 = *a__;
        a__ += N;
        asm volatile("vfmacc.vf v8, %0, v20" ::"f"(t4));
        t4 = *a__;
        a__ += N;
        asm volatile("vfmacc.vf v10, %0, v20" ::"f"(t5));
        t5 = *a__;
        a__ += N;
        asm volatile("vfmacc.vf v12, %0, v20" ::"f"(t6));
        t6 = *a__;
        a__ += N;
        asm volatile("vfmacc.vf v14, %0, v20" ::"f"(t7));
        t7 = *a__;
      }

      asm volatile("vfmacc.vf v0, %0, v20" ::"f"(t0));
      asm volatile("vse64.v v0, (%0);" ::"r"(c__));
      c__ += P;
      asm volatile("vfmacc.vf v2, %0, v20" ::"f"(t1));
      asm volatile("vse64.v v2, (%0);" ::"r"(c__));
      c__ += P;
      asm volatile("vfmacc.vf v4, %0, v20" ::"f"(t2));
      asm volatile("vse64.v v4, (%0);" ::"r"(c__));
      c__ += P;
      asm volatile("vfmacc.vf v6, %0, v20" ::"f"(t3));
      asm volatile("vse64.v v6, (%0);" ::"r"(c__));
      c__ += P;
      asm volatile("vfmacc.vf v8, %0, v20" ::"f"(t4));
      asm volatile("vse64.v v8, (%0);" ::"r"(c__));
      c__ += P;
      asm volatile("vfmacc.vf v10, %0, v20" ::"f"(t5));
      asm volatile("vse64.v v10, (%0);" ::"r"(c__));
      c__ += P;
      asm volatile("vfmacc.vf v12, %0, v20" ::"f"(t6));
      asm volatile("vse64.v v12, (%0);" ::"r"(c__));
      c__ += P;
      asm volatile("vfmacc.vf v14, %0, v20" ::"f"(t7));
      asm volatile("vse64.v v14, (%0);" ::"r"(c__));
    }

    p += gvl;
  }
}

// =============================================================================
// FP32 Matrix Multiplication Kernels (from spatzBenchmarks/sp-fmatmul)
// =============================================================================

// Forward declarations for FP32 matmul
static inline void fmatmul_v32b_2xVL(float *c, const float *a, const float *b,
                                      const unsigned int m_start, const unsigned int m_end,
                                      const unsigned int N, const unsigned int P,
                                      const unsigned int p_start, const unsigned int p_end);
static inline void fmatmul_v32b_4xVL(float *c, const float *a, const float *b,
                                      const unsigned int m_start, const unsigned int m_end,
                                      const unsigned int N, const unsigned int P,
                                      const unsigned int p_start, const unsigned int p_end);
static inline void fmatmul_v32b_8xVL(float *c, const float *a, const float *b,
                                      const unsigned int m_start, const unsigned int m_end,
                                      const unsigned int N, const unsigned int P,
                                      const unsigned int p_start, const unsigned int p_end);

// FP32 matrix multiplication wrapper - automatically selects optimal variant
// Computes C = A × B where C is MxP, A is MxN, B is NxP
static inline void fmatmul_v32b(float *c, const float *a, const float *b,
                                const unsigned int M, const unsigned int N,
                                const unsigned int P) {
  if (M <= 4) {
    fmatmul_v32b_2xVL(c, a, b, 0, M, N, P, 0, P);
  } else if (M <= 8) {
    fmatmul_v32b_4xVL(c, a, b, 0, M, N, P, 0, P);
  } else {
    fmatmul_v32b_8xVL(c, a, b, 0, M, N, P, 0, P);
  }
}

// 2xVL variant - optimized for small matrices (M <= 4)
static inline void fmatmul_v32b_2xVL(float *c, const float *a, const float *b,
                                      const unsigned int m_start, const unsigned int m_end,
                                      const unsigned int N, const unsigned int P,
                                      const unsigned int p_start, const unsigned int p_end) {
  unsigned int p = p_start;
  while (p < p_end) {
    // Calculate the vl
    size_t gvl;
    asm volatile("vsetvli %[gvl], %[vl], e32, m8, ta, ma"
                 : [gvl] "=r"(gvl)
                 : [vl] "r"(p_end - p));

    const float *b_ = b + p;
    float *c_ = c + p;

    for (unsigned int m = m_start; m < m_end; m += 2) {
      const float *a_ = a + m * N;
      const float *a__ = a_;

      asm volatile("vle32.v v16, (%0);" ::"r"(b_));
      const float *b__ = b_ + P;

      float *c__ = c_ + m * P;

      float t0, t1;

      t0 = *a__;
      a__ += N;
      t1 = *a__;

      unsigned int n = 0;

      while (n < N) {
        a__ = a_ + ++n;

        asm volatile("vle32.v v24, (%0);" ::"r"(b__));
        b__ += P;

        if (n == 1) {
          asm volatile("vfmul.vf v0, v16, %0" ::"f"(t0));
          t0 = *a__;
          a__ += N;
          asm volatile("vfmul.vf v8, v16, %0" ::"f"(t1));
          t1 = *a__;
        } else {
          asm volatile("vfmacc.vf v0, %0, v16" ::"f"(t0));
          t0 = *a__;
          a__ += N;
          asm volatile("vfmacc.vf v8, %0, v16" ::"f"(t1));
          t1 = *a__;
        }

        a__ = a_ + ++n;

        if (n == N)
          break;

        asm volatile("vle32.v v16, (%0);" ::"r"(b__));
        b__ += P;

        asm volatile("vfmacc.vf v0, %0, v24" ::"f"(t0));
        t0 = *a__;
        a__ += N;
        asm volatile("vfmacc.vf v8, %0, v24" ::"f"(t1));
        t1 = *a__;
      }

      asm volatile("vfmacc.vf v0, %0, v24" ::"f"(t0));
      asm volatile("vse32.v v0, (%0);" ::"r"(c__));
      c__ += P;
      asm volatile("vfmacc.vf v8, %0, v24" ::"f"(t1));
      asm volatile("vse32.v v8, (%0);" ::"r"(c__));
    }

    p += gvl;
  }
}

// 4xVL variant - optimized for medium matrices (M <= 8)
static inline void fmatmul_v32b_4xVL(float *c, const float *a, const float *b,
                                      const unsigned int m_start, const unsigned int m_end,
                                      const unsigned int N, const unsigned int P,
                                      const unsigned int p_start, const unsigned int p_end) {
  unsigned int p = p_start;
  while (p < p_end) {
    // Calculate the vl
    size_t gvl;
    asm volatile("vsetvli %[gvl], %[vl], e32, m4, ta, ma"
                 : [gvl] "=r"(gvl)
                 : [vl] "r"(p_end - p));

    const float *b_ = b + p;
    float *c_ = c + p;

    for (unsigned int m = m_start; m < m_end; m += 4) {
      const float *a_ = a + m * N;
      const float *a__ = a_;

      asm volatile("vle32.v v16, (%0);" ::"r"(b_));
      const float *b__ = b_ + P;

      float *c__ = c_ + m * P;

      float t0, t1, t2, t3;

      t0 = *a__;
      a__ += N;
      t1 = *a__;
      a__ += N;
      t2 = *a__;
      a__ += N;
      t3 = *a__;

      unsigned int n = 0;

      while (n < N) {
        asm volatile("vle32.v v20, (%0);" ::"r"(b__));
        b__ += P;

        a__ = a_ + ++n;

        if (n == 1) {
          asm volatile("vfmul.vf v0, v16, %0" ::"f"(t0));
          t0 = *a__;
          a__ += N;
          asm volatile("vfmul.vf v4, v16, %0" ::"f"(t1));
          t1 = *a__;
          a__ += N;
          asm volatile("vfmul.vf v8, v16, %0" ::"f"(t2));
          t2 = *a__;
          a__ += N;
          asm volatile("vfmul.vf v12, v16, %0" ::"f"(t3));
          t3 = *a__;
        } else {
          asm volatile("vfmacc.vf v0, %0, v16" ::"f"(t0));
          t0 = *a__;
          a__ += N;
          asm volatile("vfmacc.vf v4, %0, v16" ::"f"(t1));
          t1 = *a__;
          a__ += N;
          asm volatile("vfmacc.vf v8, %0, v16" ::"f"(t2));
          t2 = *a__;
          a__ += N;
          asm volatile("vfmacc.vf v12, %0, v16" ::"f"(t3));
          t3 = *a__;
        }

        a__ = a_ + ++n;

        if (n == N)
          break;

        asm volatile("vle32.v v16, (%0);" ::"r"(b__));
        b__ += P;

        asm volatile("vfmacc.vf v0, %0, v20" ::"f"(t0));
        t0 = *a__;
        a__ += N;
        asm volatile("vfmacc.vf v4, %0, v20" ::"f"(t1));
        t1 = *a__;
        a__ += N;
        asm volatile("vfmacc.vf v8, %0, v20" ::"f"(t2));
        t2 = *a__;
        a__ += N;
        asm volatile("vfmacc.vf v12, %0, v20" ::"f"(t3));
        t3 = *a__;
      }

      asm volatile("vfmacc.vf v0, %0, v20" ::"f"(t0));
      asm volatile("vse32.v v0, (%0);" ::"r"(c__));
      c__ += P;
      asm volatile("vfmacc.vf v4, %0, v20" ::"f"(t1));
      asm volatile("vse32.v v4, (%0);" ::"r"(c__));
      c__ += P;
      asm volatile("vfmacc.vf v8, %0, v20" ::"f"(t2));
      asm volatile("vse32.v v8, (%0);" ::"r"(c__));
      c__ += P;
      asm volatile("vfmacc.vf v12, %0, v20" ::"f"(t3));
      asm volatile("vse32.v v12, (%0);" ::"r"(c__));
    }

    p += gvl;
  }
}

// 8xVL variant - optimized for larger matrices (M > 8)
static inline void fmatmul_v32b_8xVL(float *c, const float *a, const float *b,
                                      const unsigned int m_start, const unsigned int m_end,
                                      const unsigned int N, const unsigned int P,
                                      const unsigned int p_start, const unsigned int p_end) {
  unsigned int p = p_start;
  while (p < p_end) {
    // Calculate the vl
    size_t gvl;
    asm volatile("vsetvli %[gvl], %[vl], e32, m2, ta, ma"
                 : [gvl] "=r"(gvl)
                 : [vl] "r"(p_end - p));

    const float *b_ = b + p;
    float *c_ = c + p;

    for (unsigned int m = m_start; m < m_end; m += 8) {
      const float *a_ = a + m * N;
      const float *a__ = a_;

      asm volatile("vle32.v v18, (%0);" ::"r"(b_));
      const float *b__ = b_ + P;

      float *c__ = c_ + m * P;

      float t0, t1, t2, t3, t4, t5, t6, t7;

      t0 = *a__;
      a__ += N;
      t1 = *a__;
      a__ += N;
      t2 = *a__;
      a__ += N;
      t3 = *a__;
      a__ += N;
      t4 = *a__;
      a__ += N;
      t5 = *a__;
      a__ += N;
      t6 = *a__;
      a__ += N;
      t7 = *a__;

      unsigned int n = 0;

      while (n < N) {
        a__ = a_ + ++n;

        asm volatile("vle32.v v20, (%0);" ::"r"(b__));
        b__ += P;

        if (n == 1) {
          asm volatile("vfmul.vf v0, v18, %0" ::"f"(t0));
          t0 = *a__;
          a__ += N;
          asm volatile("vfmul.vf v2, v18, %0" ::"f"(t1));
          t1 = *a__;
          a__ += N;
          asm volatile("vfmul.vf v4, v18, %0" ::"f"(t2));
          t2 = *a__;
          a__ += N;
          asm volatile("vfmul.vf v6, v18, %0" ::"f"(t3));
          t3 = *a__;
          a__ += N;
          asm volatile("vfmul.vf v8, v18, %0" ::"f"(t4));
          t4 = *a__;
          a__ += N;
          asm volatile("vfmul.vf v10, v18, %0" ::"f"(t5));
          t5 = *a__;
          a__ += N;
          asm volatile("vfmul.vf v12, v18, %0" ::"f"(t6));
          t6 = *a__;
          a__ += N;
          asm volatile("vfmul.vf v14, v18, %0" ::"f"(t7));
          t7 = *a__;
        } else {
          asm volatile("vfmacc.vf v0, %0, v18" ::"f"(t0));
          t0 = *a__;
          a__ += N;
          asm volatile("vfmacc.vf v2, %0, v18" ::"f"(t1));
          t1 = *a__;
          a__ += N;
          asm volatile("vfmacc.vf v4, %0, v18" ::"f"(t2));
          t2 = *a__;
          a__ += N;
          asm volatile("vfmacc.vf v6, %0, v18" ::"f"(t3));
          t3 = *a__;
          a__ += N;
          asm volatile("vfmacc.vf v8, %0, v18" ::"f"(t4));
          t4 = *a__;
          a__ += N;
          asm volatile("vfmacc.vf v10, %0, v18" ::"f"(t5));
          t5 = *a__;
          a__ += N;
          asm volatile("vfmacc.vf v12, %0, v18" ::"f"(t6));
          t6 = *a__;
          a__ += N;
          asm volatile("vfmacc.vf v14, %0, v18" ::"f"(t7));
          t7 = *a__;
        }

        a__ = a_ + ++n;

        if (n == N)
          break;

        asm volatile("vle32.v v18, (%0);" ::"r"(b__));
        b__ += P;

        asm volatile("vfmacc.vf v0, %0, v20" ::"f"(t0));
        t0 = *a__;
        a__ += N;
        asm volatile("vfmacc.vf v2, %0, v20" ::"f"(t1));
        t1 = *a__;
        a__ += N;
        asm volatile("vfmacc.vf v4, %0, v20" ::"f"(t2));
        t2 = *a__;
        a__ += N;
        asm volatile("vfmacc.vf v6, %0, v20" ::"f"(t3));
        t3 = *a__;
        a__ += N;
        asm volatile("vfmacc.vf v8, %0, v20" ::"f"(t4));
        t4 = *a__;
        a__ += N;
        asm volatile("vfmacc.vf v10, %0, v20" ::"f"(t5));
        t5 = *a__;
        a__ += N;
        asm volatile("vfmacc.vf v12, %0, v20" ::"f"(t6));
        t6 = *a__;
        a__ += N;
        asm volatile("vfmacc.vf v14, %0, v20" ::"f"(t7));
        t7 = *a__;
      }

      asm volatile("vfmacc.vf v0, %0, v20" ::"f"(t0));
      asm volatile("vse32.v v0, (%0);" ::"r"(c__));
      c__ += P;
      asm volatile("vfmacc.vf v2, %0, v20" ::"f"(t1));
      asm volatile("vse32.v v2, (%0);" ::"r"(c__));
      c__ += P;
      asm volatile("vfmacc.vf v4, %0, v20" ::"f"(t2));
      asm volatile("vse32.v v4, (%0);" ::"r"(c__));
      c__ += P;
      asm volatile("vfmacc.vf v6, %0, v20" ::"f"(t3));
      asm volatile("vse32.v v6, (%0);" ::"r"(c__));
      c__ += P;
      asm volatile("vfmacc.vf v8, %0, v20" ::"f"(t4));
      asm volatile("vse32.v v8, (%0);" ::"r"(c__));
      c__ += P;
      asm volatile("vfmacc.vf v10, %0, v20" ::"f"(t5));
      asm volatile("vse32.v v10, (%0);" ::"r"(c__));
      c__ += P;
      asm volatile("vfmacc.vf v12, %0, v20" ::"f"(t6));
      asm volatile("vse32.v v12, (%0);" ::"r"(c__));
      c__ += P;
      asm volatile("vfmacc.vf v14, %0, v20" ::"f"(t7));
      asm volatile("vse32.v v14, (%0);" ::"r"(c__));
    }

    p += gvl;
  }
}

// =============================================================================
// FP16 Matrix Multiplication Kernels (from spatzBenchmarks/hp-fmatmul)
// =============================================================================

// Forward declarations for FP16 matmul
static inline void fmatmul_v16b_2xVL(float16_t *c, const float16_t *a, const float16_t *b,
                                      const unsigned int m_start, const unsigned int m_end,
                                      const unsigned int N, const unsigned int P,
                                      const unsigned int p_start, const unsigned int p_end);
static inline void fmatmul_v16b_4xVL(float16_t *c, const float16_t *a, const float16_t *b,
                                      const unsigned int m_start, const unsigned int m_end,
                                      const unsigned int N, const unsigned int P,
                                      const unsigned int p_start, const unsigned int p_end);
static inline void fmatmul_v16b_8xVL(float16_t *c, const float16_t *a, const float16_t *b,
                                      const unsigned int m_start, const unsigned int m_end,
                                      const unsigned int N, const unsigned int P,
                                      const unsigned int p_start, const unsigned int p_end);

// FP16 matrix multiplication wrapper - automatically selects optimal variant
// Computes C = A × B where C is MxP, A is MxN, B is NxP
static inline void fmatmul_v16b(float16_t *c, const float16_t *a, const float16_t *b,
                                const unsigned int M, const unsigned int N,
                                const unsigned int P) {
  if (M <= 4) {
    fmatmul_v16b_2xVL(c, a, b, 0, M, N, P, 0, P);
  } else if (M <= 8) {
    fmatmul_v16b_4xVL(c, a, b, 0, M, N, P, 0, P);
  } else {
    fmatmul_v16b_8xVL(c, a, b, 0, M, N, P, 0, P);
  }
}

// 2xVL variant - optimized for small matrices (M <= 4)
// NOTE: Uses e32 (FP32 accumulation) for better precision
static inline void fmatmul_v16b_2xVL(float16_t *c, const float16_t *a, const float16_t *b,
                                      const unsigned int m_start, const unsigned int m_end,
                                      const unsigned int N, const unsigned int P,
                                      const unsigned int p_start, const unsigned int p_end) {
  unsigned int p = p_start;
  while (p < p_end) {
    // Calculate the vl (using e32 for FP32 accumulation)
    size_t gvl;
    asm volatile("vsetvli %[gvl], %[vl], e32, m8, ta, ma"
                 : [gvl] "=r"(gvl)
                 : [vl] "r"(p_end - p));

    const float16_t *b_ = b + p;
    float16_t *c_ = c + p;

    for (unsigned int m = m_start; m < m_end; m += 2) {
      const float16_t *a_ = a + m * N;
      const float16_t *a__ = a_;

      asm volatile("vle32.v v16, (%0);" ::"r"(b_));
      const float16_t *b__ = b_ + P;

      float16_t *c__ = c_ + m * P;

      float t0, t1;

      asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t0) : [a] "r"(a__));
      a__ += N;
      asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t1) : [a] "r"(a__));

      unsigned int n = 0;

      while (n < N) {
        a__ = a_ + ++n;

        asm volatile("vle32.v v24, (%0);" ::"r"(b__));
        b__ += P;

        if (n == 1) {
          asm volatile("vfmul.vf v0, v16, %0" ::"f"(t0));
          asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t0) : [a] "r"(a__));
          a__ += N;
          asm volatile("vfmul.vf v8, v16, %0" ::"f"(t1));
          asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t1) : [a] "r"(a__));
        } else {
          asm volatile("vfmacc.vf v0, %0, v16" ::"f"(t0));
          asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t0) : [a] "r"(a__));
          a__ += N;
          asm volatile("vfmacc.vf v8, %0, v16" ::"f"(t1));
          asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t1) : [a] "r"(a__));
        }

        a__ = a_ + ++n;

        if (n == N)
          break;

        asm volatile("vle32.v v16, (%0);" ::"r"(b__));
        b__ += P;

        asm volatile("vfmacc.vf v0, %0, v24" ::"f"(t0));
        asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t0) : [a] "r"(a__));
        a__ += N;
        asm volatile("vfmacc.vf v8, %0, v24" ::"f"(t1));
        asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t1) : [a] "r"(a__));
      }

      asm volatile("vfmacc.vf v0, %0, v24" ::"f"(t0));
      asm volatile("vse32.v v0, (%0);" ::"r"(c__));
      c__ += P;
      asm volatile("vfmacc.vf v8, %0, v24" ::"f"(t1));
      asm volatile("vse32.v v8, (%0);" ::"r"(c__));
    }

    p += gvl;
  }
}

// 4xVL variant - optimized for medium matrices (M <= 8)
static inline void fmatmul_v16b_4xVL(float16_t *c, const float16_t *a, const float16_t *b,
                                      const unsigned int m_start, const unsigned int m_end,
                                      const unsigned int N, const unsigned int P,
                                      const unsigned int p_start, const unsigned int p_end) {
  unsigned int p = p_start;
  while (p < p_end) {
    // Calculate the vl (using e32 for FP32 accumulation)
    size_t gvl;
    asm volatile("vsetvli %[gvl], %[vl], e32, m4, ta, ma"
                 : [gvl] "=r"(gvl)
                 : [vl] "r"(p_end - p));

    const float16_t *b_ = b + p;
    float16_t *c_ = c + p;

    for (unsigned int m = m_start; m < m_end; m += 4) {
      const float16_t *a_ = a + m * N;
      const float16_t *a__ = a_;

      asm volatile("vle32.v v16, (%0);" ::"r"(b_));
      const float16_t *b__ = b_ + P;

      float16_t *c__ = c_ + m * P;

      float t0, t1, t2, t3;

      asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t0) : [a] "r"(a__));
      a__ += N;
      asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t1) : [a] "r"(a__));
      a__ += N;
      asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t2) : [a] "r"(a__));
      a__ += N;
      asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t3) : [a] "r"(a__));

      unsigned int n = 0;

      while (n < N) {
        asm volatile("vle32.v v20, (%0);" ::"r"(b__));
        b__ += P;

        a__ = a_ + ++n;

        if (n == 1) {
          asm volatile("vfmul.vf v0, v16, %0" ::"f"(t0));
          asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t0) : [a] "r"(a__));
          a__ += N;
          asm volatile("vfmul.vf v4, v16, %0" ::"f"(t1));
          asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t1) : [a] "r"(a__));
          a__ += N;
          asm volatile("vfmul.vf v8, v16, %0" ::"f"(t2));
          asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t2) : [a] "r"(a__));
          a__ += N;
          asm volatile("vfmul.vf v12, v16, %0" ::"f"(t3));
          asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t3) : [a] "r"(a__));
        } else {
          asm volatile("vfmacc.vf v0, %0, v16" ::"f"(t0));
          asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t0) : [a] "r"(a__));
          a__ += N;
          asm volatile("vfmacc.vf v4, %0, v16" ::"f"(t1));
          asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t1) : [a] "r"(a__));
          a__ += N;
          asm volatile("vfmacc.vf v8, %0, v16" ::"f"(t2));
          asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t2) : [a] "r"(a__));
          a__ += N;
          asm volatile("vfmacc.vf v12, %0, v16" ::"f"(t3));
          asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t3) : [a] "r"(a__));
        }

        a__ = a_ + ++n;

        if (n == N)
          break;

        asm volatile("vle32.v v16, (%0);" ::"r"(b__));
        b__ += P;

        asm volatile("vfmacc.vf v0, %0, v20" ::"f"(t0));
        asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t0) : [a] "r"(a__));
        a__ += N;
        asm volatile("vfmacc.vf v4, %0, v20" ::"f"(t1));
        asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t1) : [a] "r"(a__));
        a__ += N;
        asm volatile("vfmacc.vf v8, %0, v20" ::"f"(t2));
        asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t2) : [a] "r"(a__));
        a__ += N;
        asm volatile("vfmacc.vf v12, %0, v20" ::"f"(t3));
        asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t3) : [a] "r"(a__));
      }

      asm volatile("vfmacc.vf v0, %0, v20" ::"f"(t0));
      asm volatile("vse32.v v0, (%0);" ::"r"(c__));
      c__ += P;
      asm volatile("vfmacc.vf v4, %0, v20" ::"f"(t1));
      asm volatile("vse32.v v4, (%0);" ::"r"(c__));
      c__ += P;
      asm volatile("vfmacc.vf v8, %0, v20" ::"f"(t2));
      asm volatile("vse32.v v8, (%0);" ::"r"(c__));
      c__ += P;
      asm volatile("vfmacc.vf v12, %0, v20" ::"f"(t3));
      asm volatile("vse32.v v12, (%0);" ::"r"(c__));
    }

    p += gvl;
  }
}

// 8xVL variant - optimized for larger matrices (M > 8)
static inline void fmatmul_v16b_8xVL(float16_t *c, const float16_t *a, const float16_t *b,
                                      const unsigned int m_start, const unsigned int m_end,
                                      const unsigned int N, const unsigned int P,
                                      const unsigned int p_start, const unsigned int p_end) {
  unsigned int p = p_start;
  while (p < p_end) {
    // Calculate the vl (using e16 for this variant)
    size_t gvl;
    asm volatile("vsetvli %[gvl], %[vl], e16, m2, ta, ma"
                 : [gvl] "=r"(gvl)
                 : [vl] "r"(p_end - p));

    const float16_t *b_ = b + p;
    float16_t *c_ = c + p;

    for (unsigned int m = m_start; m < m_end; m += 8) {
      const float16_t *a_ = a + m * N;
      const float16_t *a__ = a_;

      asm volatile("vle16.v v18, (%0);" ::"r"(b_));
      const float16_t *b__ = b_ + P;

      float16_t *c__ = c_ + m * P;

      float t0, t1, t2, t3, t4, t5, t6, t7;

      asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t0) : [a] "r"(a__));
      a__ += N;
      asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t1) : [a] "r"(a__));
      a__ += N;
      asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t2) : [a] "r"(a__));
      a__ += N;
      asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t3) : [a] "r"(a__));
      a__ += N;
      asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t4) : [a] "r"(a__));
      a__ += N;
      asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t5) : [a] "r"(a__));
      a__ += N;
      asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t6) : [a] "r"(a__));
      a__ += N;
      asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t7) : [a] "r"(a__));

      unsigned int n = 0;

      while (n < N) {
        a__ = a_ + ++n;

        asm volatile("vle16.v v20, (%0);" ::"r"(b__));
        b__ += P;

        if (n == 1) {
          asm volatile("vfmul.vf v0, v18, %0" ::"f"(t0));
          asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t0) : [a] "r"(a__));
          a__ += N;
          asm volatile("vfmul.vf v2, v18, %0" ::"f"(t1));
          asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t1) : [a] "r"(a__));
          a__ += N;
          asm volatile("vfmul.vf v4, v18, %0" ::"f"(t2));
          asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t2) : [a] "r"(a__));
          a__ += N;
          asm volatile("vfmul.vf v6, v18, %0" ::"f"(t3));
          asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t3) : [a] "r"(a__));
          a__ += N;
          asm volatile("vfmul.vf v8, v18, %0" ::"f"(t4));
          asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t4) : [a] "r"(a__));
          a__ += N;
          asm volatile("vfmul.vf v10, v18, %0" ::"f"(t5));
          asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t5) : [a] "r"(a__));
          a__ += N;
          asm volatile("vfmul.vf v12, v18, %0" ::"f"(t6));
          asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t6) : [a] "r"(a__));
          a__ += N;
          asm volatile("vfmul.vf v14, v18, %0" ::"f"(t7));
          asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t7) : [a] "r"(a__));
        } else {
          asm volatile("vfmacc.vf v0, %0, v18" ::"f"(t0));
          asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t0) : [a] "r"(a__));
          a__ += N;
          asm volatile("vfmacc.vf v2, %0, v18" ::"f"(t1));
          asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t1) : [a] "r"(a__));
          a__ += N;
          asm volatile("vfmacc.vf v4, %0, v18" ::"f"(t2));
          asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t2) : [a] "r"(a__));
          a__ += N;
          asm volatile("vfmacc.vf v6, %0, v18" ::"f"(t3));
          asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t3) : [a] "r"(a__));
          a__ += N;
          asm volatile("vfmacc.vf v8, %0, v18" ::"f"(t4));
          asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t4) : [a] "r"(a__));
          a__ += N;
          asm volatile("vfmacc.vf v10, %0, v18" ::"f"(t5));
          asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t5) : [a] "r"(a__));
          a__ += N;
          asm volatile("vfmacc.vf v12, %0, v18" ::"f"(t6));
          asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t6) : [a] "r"(a__));
          a__ += N;
          asm volatile("vfmacc.vf v14, %0, v18" ::"f"(t7));
          asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t7) : [a] "r"(a__));
        }

        a__ = a_ + ++n;

        if (n == N)
          break;

        asm volatile("vle16.v v18, (%0);" ::"r"(b__));
        b__ += P;

        asm volatile("vfmacc.vf v0, %0, v20" ::"f"(t0));
        asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t0) : [a] "r"(a__));
        a__ += N;
        asm volatile("vfmacc.vf v2, %0, v20" ::"f"(t1));
        asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t1) : [a] "r"(a__));
        a__ += N;
        asm volatile("vfmacc.vf v4, %0, v20" ::"f"(t2));
        asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t2) : [a] "r"(a__));
        a__ += N;
        asm volatile("vfmacc.vf v6, %0, v20" ::"f"(t3));
        asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t3) : [a] "r"(a__));
        a__ += N;
        asm volatile("vfmacc.vf v8, %0, v20" ::"f"(t4));
        asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t4) : [a] "r"(a__));
        a__ += N;
        asm volatile("vfmacc.vf v10, %0, v20" ::"f"(t5));
        asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t5) : [a] "r"(a__));
        a__ += N;
        asm volatile("vfmacc.vf v12, %0, v20" ::"f"(t6));
        asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t6) : [a] "r"(a__));
        a__ += N;
        asm volatile("vfmacc.vf v14, %0, v20" ::"f"(t7));
        asm volatile("flh %[t], 0(%[a])" : [t] "=f"(t7) : [a] "r"(a__));
      }

      asm volatile("vfmacc.vf v0, %0, v20" ::"f"(t0));
      asm volatile("vse16.v v0, (%0);" ::"r"(c__));
      c__ += P;
      asm volatile("vfmacc.vf v2, %0, v20" ::"f"(t1));
      asm volatile("vse16.v v2, (%0);" ::"r"(c__));
      c__ += P;
      asm volatile("vfmacc.vf v4, %0, v20" ::"f"(t2));
      asm volatile("vse16.v v4, (%0);" ::"r"(c__));
      c__ += P;
      asm volatile("vfmacc.vf v6, %0, v20" ::"f"(t3));
      asm volatile("vse16.v v6, (%0);" ::"r"(c__));
      c__ += P;
      asm volatile("vfmacc.vf v8, %0, v20" ::"f"(t4));
      asm volatile("vse16.v v8, (%0);" ::"r"(c__));
      c__ += P;
      asm volatile("vfmacc.vf v10, %0, v20" ::"f"(t5));
      asm volatile("vse16.v v10, (%0);" ::"r"(c__));
      c__ += P;
      asm volatile("vfmacc.vf v12, %0, v20" ::"f"(t6));
      asm volatile("vse16.v v12, (%0);" ::"r"(c__));
      c__ += P;
      asm volatile("vfmacc.vf v14, %0, v20" ::"f"(t7));
      asm volatile("vse16.v v14, (%0);" ::"r"(c__));
    }

    p += gvl;
  }
}

#endif // _SPATZ_UTILS_H_
