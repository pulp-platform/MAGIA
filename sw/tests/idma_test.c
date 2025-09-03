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
 * MAGIA iDMA Test
 */

#include "magia_tile_utils.h"
#include "idma_isa_utils.h"

#include "x_input.h"

#define X_BASE (L1_BASE + 0x00012048)
#define Y_BASE (L1_BASE + 0x00016048)
#define Z_BASE (L2_BASE + 0x00001000)
#define W_BASE (L2_BASE + 0x00005000)

#define M_SIZE (96)
#define N_SIZE (64)

#define VERBOSE (0)

#define IRQ_EN

#define WAIT_CYCLES (10)

#define CONCURRENT

int main(void) {
  uint32_t dst_addr;
  uint32_t src_addr;
  uint32_t len;

  uint32_t dst_std_2;
  uint32_t src_std_2;
  uint32_t reps_2;

  uint32_t dst_std_3;
  uint32_t src_std_3;
  uint32_t reps_3;

  // Z - golden (reference)
  for (int i = 0; i < M_SIZE*N_SIZE; i++)
    mmio16(Z_BASE + 2*i) = x_inp[i];
#if VERBOSE > 100
  for (int i = 0; i < M_SIZE*N_SIZE; i++)
    printf("Z[%8x]: 0x%4x\n", Z_BASE + 2*i, mmio16(Z_BASE + 2*i));
#endif

#ifdef IRQ_EN
  // Enable IRQs
  uint32_t index = (1<<IRQ_A2O_DONE) | (1<<IRQ_O2A_DONE);
  irq_en(index);
#endif

  idma_conf_in();

  dst_addr = (uint32_t)X_BASE;
  src_addr = (uint32_t)Z_BASE;
  len      = (uint32_t)(M_SIZE*N_SIZE*2); // 2 Bytes per element
#if VERBOSE > 10
  printf("dst_addr: 0x%8x (X_BASE)\n", dst_addr);
  printf("src_addr: 0x%8x (Z_BASE)\n", src_addr);
  printf("len: %0d\n", len);
#endif
  idma_set_addr_len_in(dst_addr, src_addr, len);

  dst_std_2 = 0;
  src_std_2 = 0;
  reps_2    = 1;
#if VERBOSE > 10
  printf("dst_std_2: 0x%8x\n", dst_std_2);
  printf("src_std_2: 0x%8x\n", src_std_2);
  printf("reps_2: 0x%8x\n", reps_2);
#endif
  idma_set_std2_rep2_in(dst_std_2, src_std_2, reps_2);

  dst_std_3 = 0;
  src_std_3 = 0;
  reps_3    = 1;
#if VERBOSE > 10
  printf("dst_std_3: 0x%8x\n", dst_std_3);
  printf("src_std_3: 0x%8x\n", src_std_3);
  printf("reps_3: 0x%8x\n", reps_3);
#endif
  idma_set_std3_rep3_in(dst_std_3, src_std_3, reps_3);

  idma_start_in();
  printf("iDMA moving data from L2 to L1...\n");
#ifdef IRQ_EN
  asm volatile("wfi" ::: "memory");
  printf("Detected IRQ...\n");
#else
  wait_print(WAIT_CYCLES);
#endif

  idma_conf_out();

  dst_addr = (uint32_t)W_BASE;
  src_addr = (uint32_t)X_BASE;
  len      = (uint32_t)(M_SIZE*N_SIZE*2); // 2 Bytes per element
#if VERBOSE > 10
  printf("dst_addr: 0x%8x (W_BASE)\n", dst_addr);
  printf("src_addr: 0x%8x (X_BASE)\n", src_addr);
  printf("len: %0d\n", len);
#endif
  idma_set_addr_len_out(dst_addr, src_addr, len);

  dst_std_2 = 0;
  src_std_2 = 0;
  reps_2    = 1;
#if VERBOSE > 10
  printf("dst_std_2: 0x%8x\n", dst_std_2);
  printf("src_std_2: 0x%8x\n", src_std_2);
  printf("reps_2: 0x%8x\n", reps_2);
#endif
  idma_set_std2_rep2_out(dst_std_2, src_std_2, reps_2);

  dst_std_3 = 0;
  src_std_3 = 0;
  reps_3    = 1;
#if VERBOSE > 10
  printf("dst_std_3: 0x%8x\n", dst_std_3);
  printf("src_std_3: 0x%8x\n", src_std_3);
  printf("reps_3: 0x%8x\n", reps_3);
#endif
  idma_set_std3_rep3_out(dst_std_3, src_std_3, reps_3);

#ifdef CONCURRENT
  idma_conf_in();

  dst_addr = (uint32_t)Y_BASE;
  src_addr = (uint32_t)Z_BASE;
  len      = (uint32_t)(M_SIZE*N_SIZE*2); // 2 Bytes per element
#if VERBOSE > 10
  printf("dst_addr: 0x%8x (Y_BASE)\n", dst_addr);
  printf("src_addr: 0x%8x (Z_BASE)\n", src_addr);
  printf("len: %0d\n", len);
#endif
  idma_set_addr_len_in(dst_addr, src_addr, len);

  dst_std_2 = 0;
  src_std_2 = 0;
  reps_2    = 1;
#if VERBOSE > 10
  printf("dst_std_2: 0x%8x\n", dst_std_2);
  printf("src_std_2: 0x%8x\n", src_std_2);
  printf("reps_2: 0x%8x\n", reps_2);
#endif
  idma_set_std2_rep2_in(dst_std_2, src_std_2, reps_2);

  dst_std_3 = 0;
  src_std_3 = 0;
  reps_3    = 1;
#if VERBOSE > 10
  printf("dst_std_3: 0x%8x\n", dst_std_3);
  printf("src_std_3: 0x%8x\n", src_std_3);
  printf("reps_3: 0x%8x\n", reps_3);
#endif
  idma_set_std3_rep3_in(dst_std_3, src_std_3, reps_3);

  idma_start_out();

  idma_start_in();

  printf("iDMA moving concurrently data from L1 to L2 and from L2 to L1...\n");
#ifdef IRQ_EN
  asm volatile("wfi" ::: "memory");
  printf("Detected IRQ...\n");
#else
  wait_print(2*WAIT_CYCLES);
#endif
#else
  idma_start_out();

  printf("iDMA moving data from L1 to L2...\n");
#ifdef IRQ_EN
  asm volatile("wfi" ::: "memory");
  printf("Detected IRQ...\n");
#else
  wait_print(WAIT_CYCLES);
#endif
#endif

  printf("Verifying results...\n");
  
  unsigned int num_errors = 0;

  uint16_t detected_l1, detected_l2, expected;
  for(int i = 0; i < M_SIZE*N_SIZE; i++){
    detected_l2 = mmio16(W_BASE + 2*i);
#ifdef CONCURRENT
    detected_l1 = mmio16(Y_BASE + 2*i);
#else
    detected_l1 = mmio16(X_BASE + 2*i);
#endif
    expected = mmio16(Z_BASE + 2*i);
    if((detected_l2 != expected) || (detected_l1 != expected)){
      num_errors++;
      printf("**ERROR**: DETECTED L2[%0d](=0x%4x) || DETECTED L1[%0d](=0x%4x) != EXPECTED[%0d](=0x%4x)\n", i, detected_l2, i, detected_l1, i, expected);
    }
  }
  printf("Finished test with %0d errors\n", num_errors);

  return num_errors;
}
