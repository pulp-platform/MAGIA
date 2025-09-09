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

#define FP_TH (0.1f)

#define abs_diff(x, y) (((x) > (y)) ? ((x) - (y)) : ((y) - (x)))

inline uint32_t f_add(volatile uint32_t op_a, volatile uint32_t op_b){
  uint32_t result;
  asm volatile("fmv.s.x	ft0, %0" ::"r"(op_a));
  asm volatile("fmv.s.x	ft1, %0" ::"r"(op_b));
  asm volatile("fadd.s	ft0,ft0,ft1" ::);
  asm volatile("fmv.x.s	%0,ft0" :"=r"(result):);
  return result;
}

int main(void) {
  // uint32_t exit_code;
  
  // volatile float a, b, c;
  // a = A_VAL;
  // b = B_VAL;
  // c = a+b;

  // if (abs_diff(c, C_EXP) > FP_TH){
  //   exit_code = FAIL_EXIT_CODE;
  //   printf("Test FAILED\n");
  // }else{
  //   exit_code = PASS_EXIT_CODE;
  //   printf("Test PASSED\n");
  // }

  // mmio16(TEST_END_ADDR) = exit_code;

  uint32_t a, b, c;
  a = 0x414570A4; // Binary for 12.34f
  b = 0x42631EB8; // Binary for 56.78f
  c = f_add(a, b);
  printf("Float operation result: 0x%0x [expected: 0x428A3D71(69.12f)]\n", c);

  mmio16(TEST_END_ADDR) = DEFAULT_EXIT_CODE;

  return 0;
}
