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
 * MAGIA Tile Test
 */

#include "magia_tile_utils.h"
#include "redmule_isa_utils.h"
#include "idma_isa_utils.h"

#include "x_input.h"
#include "w_input.h"
#include "y_input.h"
#include "z_output.h"

#define X_BASE (L1_BASE + 0x00012048)
#define W_BASE (L1_BASE + 0x00016048)
#define Y_BASE (L1_BASE + 0x0001A048)
#define Z_BASE (L2_BASE + 0x00042000)
#define V_BASE (L2_BASE + 0x00046000)
#define T_BASE (L2_BASE + 0x0004A000)

#define M_SIZE (96)
#define N_SIZE (64)
#define K_SIZE (64)

#define VERBOSE (0)

#define WAIT_CYCLES (10)

#define DIFF_TH (0x0011)

#define CONCURRENT

#define IRQ_EN

void idma_mv_in(unsigned int x_dim, unsigned int y_dim, uint16_t src_data[], uint32_t dst_address){
  uint32_t dst_addr;
  uint32_t src_addr;
  uint32_t len;

  uint32_t dst_std_2;
  uint32_t src_std_2;
  uint32_t reps_2;

  uint32_t dst_std_3;
  uint32_t src_std_3;
  uint32_t reps_3;

#ifdef IRQ_EN
  irq_en(1<<IRQ_A2O_DONE);
#endif

  for (int i = 0; i < x_dim*y_dim; i++)
    mmio16(T_BASE + 2*i) = src_data[i];

  idma_conf_in();

  dst_addr = (uint32_t)dst_address;
  src_addr = (uint32_t)T_BASE;
  len      = (uint32_t)(x_dim*y_dim*2); // 2 Bytes per element
#if VERBOSE > 10
  printf("dst_addr: 0x%8x\n", dst_addr);
  printf("src_addr: 0x%8x\n", src_addr);
  printf("len: %0d\n", len);
#endif
  idma_set_addr_len_in(dst_addr, src_addr, len);

  dst_std_2 = 0;
  src_std_2 = 0;
  reps_2    = 1;
#if VERBOSE > 100
  printf("dst_std_2: 0x%8x\n", dst_std_2);
  printf("src_std_2: 0x%8x\n", src_std_2);
  printf("reps_2: 0x%8x\n", reps_2);
#endif
  idma_set_std2_rep2_in(dst_std_2, src_std_2, reps_2);

  dst_std_3 = 0;
  src_std_3 = 0;
  reps_3    = 1;
#if VERBOSE > 100
  printf("dst_std_3: 0x%8x\n", dst_std_3);
  printf("src_std_3: 0x%8x\n", src_std_3);
  printf("reps_3: 0x%8x\n", reps_3);
#endif
  idma_set_std3_rep3_in(dst_std_3, src_std_3, reps_3);

  idma_start_in();

#ifdef IRQ_EN
  asm volatile("wfi" ::: "memory");
  printf("Detected IRQ...\n");
#else
  wait_print(WAIT_CYCLES);
#endif

#if VERBOSE > 100
  for (int i = 0; i < x_dim*y_dim; i++)
    printf("DST[%8x]: 0x%4x\n", dst_address + 2*i, mmio16(dst_address + 2*i));
#endif

#if VERBOSE > 10
  unsigned int num_errors;
  num_errors = 0;
  for (int i = 0; i < x_dim*y_dim; i++) {
    if (mmio16(dst_address + 2*i) != src_data[i]) {
      num_errors++;
      printf("DST[%8x]: 0x%4x != SRC[%0d]: 0x%4x\n", dst_address + 2*i, mmio16(dst_address + 2*i), i, src_data[i]);
    }
  }
  printf("Detected %0d error(s) in the transfer...\n", num_errors);
#endif
}

void idma_mv_out(unsigned int x_dim, unsigned int y_dim, uint32_t src_address, uint32_t dst_address){
  uint32_t dst_addr;
  uint32_t src_addr;
  uint32_t len;

  uint32_t dst_std_2;
  uint32_t src_std_2;
  uint32_t reps_2;

  uint32_t dst_std_3;
  uint32_t src_std_3;
  uint32_t reps_3;

#ifdef IRQ_EN
  irq_en(1<<IRQ_O2A_DONE);
#endif

  idma_conf_out();

  dst_addr = (uint32_t)dst_address;
  src_addr = (uint32_t)src_address;
  len      = (uint32_t)(x_dim*y_dim*2); // 2 Bytes per element
#if VERBOSE > 10
  printf("dst_addr: 0x%8x\n", dst_addr);
  printf("src_addr: 0x%8x\n", src_addr);
  printf("len: %0d\n", len);
#endif
  idma_set_addr_len_out(dst_addr, src_addr, len);

  dst_std_2 = 0;
  src_std_2 = 0;
  reps_2    = 1;
#if VERBOSE > 100
  printf("dst_std_2: 0x%8x\n", dst_std_2);
  printf("src_std_2: 0x%8x\n", src_std_2);
  printf("reps_2: 0x%8x\n", reps_2);
#endif
  idma_set_std2_rep2_out(dst_std_2, src_std_2, reps_2);

  dst_std_3 = 0;
  src_std_3 = 0;
  reps_3    = 1;
#if VERBOSE > 100
  printf("dst_std_3: 0x%8x\n", dst_std_3);
  printf("src_std_3: 0x%8x\n", src_std_3);
  printf("reps_3: 0x%8x\n", reps_3);
#endif
  idma_set_std3_rep3_out(dst_std_3, src_std_3, reps_3);

  idma_start_out();

#ifdef IRQ_EN
  asm volatile("wfi" ::: "memory");
  printf("Detected IRQ...\n");
#else
  wait_print(WAIT_CYCLES);
#endif

#if VERBOSE > 100
  for (int i = 0; i < x_dim*y_dim; i++)
    printf("DST[%8x]: 0x%4x\n", dst_address + 2*i, mmio16(dst_address + 2*i));
#endif

#if VERBOSE > 10
  unsigned int num_errors;
  num_errors = 0;
  for (int i = 0; i < x_dim*y_dim; i++) {
    if (mmio16(dst_address + 2*i) != mmio16(src_address + 2*i)) {
      num_errors++;
      printf("DST[%8x]: 0x%4x != SRC[%8x]: 0x%4x\n", dst_address + 2*i, mmio16(dst_address + 2*i), src_address + 2*i, mmio16(src_address + 2*i));
    }
  }
  printf("Detected %0d error(s) in the transfer...\n", num_errors);
#endif
}

int main(void) {
  // X
  printf("Initializing X through iDMA...\n");
  idma_mv_in(M_SIZE, N_SIZE, x_inp, X_BASE);

  // W
  printf("Initializing W through iDMA...\n");
  idma_mv_in(N_SIZE, K_SIZE, w_inp, W_BASE);

  // Y
  printf("Initializing Y through iDMA...\n");
  idma_mv_in(M_SIZE, K_SIZE, y_inp, Y_BASE);

  // Z - golden (reference)
  printf("Initializing Z - golden...\n");
  for (int i = 0; i < M_SIZE*K_SIZE; i++)
    mmio16(Z_BASE + 2*i) = z_oup[i];
#if VERBOSE > 100
  for (int i = 0; i < M_SIZE*K_SIZE; i++)
    printf("Z[%8x]: 0x%4x\n", Z_BASE + 2*i, mmio16(Z_BASE + 2*i));
#endif

#if VERBOSE > 10
  printf("K_SIZE: %4x\n", K_SIZE);
  printf("M_SIZE: %4x\n", M_SIZE);
  printf("N_SIZE: %4x\n", N_SIZE);  
#endif

  redmule_mcnfig(K_SIZE, M_SIZE, N_SIZE);

  redmule_marith(Y_BASE, W_BASE, X_BASE);

#ifdef IRQ_EN
  irq_en(1<<IRQ_REDMULE_EVT_0);
#endif

  printf("Testing matrix multiplication with RedMulE...\n");

#ifdef IRQ_EN
  // Wait for end of computation
  asm volatile("wfi" ::: "memory");
  printf("Detected IRQ...\n");
#else
  wait_print(WAIT_CYCLES);
#endif

  printf("Moving results through iDMA...\n");
  idma_mv_out(M_SIZE, K_SIZE, Y_BASE, V_BASE);

  printf("Verifying results...\n");
  
  unsigned int num_errors = 0;

  uint16_t computed, expected, diff;
  for(int i = 0; i < M_SIZE*K_SIZE; i++){
    computed = mmio16(V_BASE + 2*i);
    expected = mmio16(Z_BASE + 2*i);
    diff = (computed > expected) ? (computed - expected) : (expected - computed);
    if(diff > DIFF_TH){
      num_errors++;
      printf("**ERROR**: V[%8x](=0x%4x) != Z[%8x](=0x%4x)\n", V_BASE + 2*i, computed, Z_BASE + 2*i, expected);
    }
  }
  printf("Finished test with %0d errors\n", num_errors);

  return num_errors;
}
