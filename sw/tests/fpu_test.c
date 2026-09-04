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
 * Authors: Victor Isachi <victor.isachi@unibo.it>
 * 
 * MAGIA Tile FPU Test
 */

#include "magia_tile_utils.h"

#define A_VAL (12.34f)
#define B_VAL (56.78f)
#define C_EXP (69.12f)
#define F_EXP 0x428A3D70

#ifdef CV32E40P
#define FP_TH (1e-45f)
#else
#define FP_TH (0.1f)
#endif


#define abs_diff(x, y) (((x) > (y)) ? ((x) - (y)) : ((y) - (x)))

static inline uint32_t f32_bits(float f){
  uint32_t *p = (volatile uint32_t *)&f;
  return *p;
}

inline uint32_t f_add(volatile uint32_t op_a, volatile uint32_t op_b){
  uint32_t result;
  asm volatile("fmv.s.x	ft0, %0" ::"r"(op_a));
  asm volatile("fmv.s.x	ft1, %0" ::"r"(op_b));
  asm volatile("fadd.s	ft0,ft0,ft1" ::);
  asm volatile("fmv.x.s	%0,ft0" :"=r"(result):);
  return result;
}

inline uint32_t f_sub(volatile uint32_t op_a, volatile uint32_t op_b){
  uint32_t result;
  asm volatile("fmv.s.x	ft2, %0" ::"r"(op_a));
  asm volatile("fmv.s.x	ft3, %0" ::"r"(op_b));
  asm volatile("fsub.s	ft2,ft2,ft3" ::);
  asm volatile("fmv.x.s	%0,ft2" :"=r"(result):);
  return result;
}

inline uint32_t f_lt(volatile uint32_t op_a, volatile uint32_t op_b){
  volatile uint32_t result;
  asm volatile("fmv.s.x	ft4, %0" ::"r"(op_a));
  asm volatile("fmv.s.x	ft5, %0" ::"r"(op_b));
  asm volatile("flt.s	%0,ft4,ft5" :"=r"(result):);
  return result;
}

int main(void) {
  uint32_t error = 0;

#ifndef CV32E40X
  volatile float a, b, c;
  a = A_VAL;
  b = B_VAL;
  c = a+b;

  if (abs_diff(c, C_EXP) > FP_TH){
     printf("Test FAILED\n");
     error++;
   }else{
     printf("Test PASSED\n");
   }
#else
  volatile uint32_t a, b, c;
  a = f32_bits(A_VAL);
  b = f32_bits(B_VAL);
  c = f_add(a, b);

  uint32_t diff = f_sub(c, f32_bits(C_EXP));
  if (f_lt(diff, 0))
   diff = f_sub(0, diff);

   if (f_lt(diff, f32_bits(FP_TH))){
     printf("Test PASSED\n");
   }else{
     printf("Test FAILED\n");
     error++;
   }
#endif

  return error;
}
