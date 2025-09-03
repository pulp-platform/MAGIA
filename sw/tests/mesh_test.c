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
 * MAGIA Mesh Test
 */

#include "magia_tile_utils.h"
#include "magia_utils.h"
#include "redmule_isa_utils.h"
#include "idma_isa_utils.h"

#include "x_input.h"
#include "w_input.h"
#include "y_input.h"
#include "z_output.h"

#define X_BASE (L1_BASE + 0x00012048)
#define W_BASE (L1_BASE + 0x00016048)
#define Y_BASE (L1_BASE + 0x0001A048)
#define Z_BASE (L2_BASE + 0x00042000) // Note: for a large number of tiles (e.g. 64x64 mesh) we might exceed memory range of L2
#define V_BASE (L2_BASE + 0x00046000) // Note: for a large number of tiles (e.g. 64x64 mesh) we might exceed memory range of L2
#define T_BASE (L2_BASE + 0x0004A000) // Note: for a large number of tiles (e.g. 64x64 mesh) we might exceed memory range of L2

#define MHARTID_OFFSET (0x00010000)

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
    mmio16(T_BASE + get_hartid()*MHARTID_OFFSET + 2*i) = src_data[i];

  idma_conf_in();

  dst_addr = (uint32_t)dst_address;
  src_addr = (uint32_t)(T_BASE + get_hartid()*MHARTID_OFFSET);
  len      = (uint32_t)(x_dim*y_dim*2); // 2 Bytes per element
#if VERBOSE > 10
  // h_pprintf("dst_addr: 0x"); n_pprintf(hs(dst_addr));
  // h_pprintf("src_addr: 0x"); n_pprintf(hs(src_addr));
  // h_pprintf("len:        "); n_pprintf(ds(len));
  printf("dst_addr: 0x%0x\n", dst_addr);
  printf("src_addr: 0x%0x\n", src_addr);
  printf("len:        %0d\n", len);
#endif
  idma_set_addr_len_in(dst_addr, src_addr, len);

  dst_std_2 = 0;
  src_std_2 = 0;
  reps_2    = 1;
#if VERBOSE > 100
  // h_pprintf("dst_std_2: 0x"); n_pprintf(hs(dst_std_2));
  // h_pprintf("src_std_2: 0x"); n_pprintf(hs(src_std_2));
  // h_pprintf("reps_2:    0x"); n_pprintf(hs(reps_2));
  printf("dst_std_2: 0x%0x\n", dst_std_2);
  printf("src_std_2: 0x%0x\n", src_std_2);
  printf("reps_2:    0x%0x\n", reps_2);
#endif
  idma_set_std2_rep2_in(dst_std_2, src_std_2, reps_2);

  dst_std_3 = 0;
  src_std_3 = 0;
  reps_3    = 1;
#if VERBOSE > 100
  // h_pprintf("dst_std_3: 0x"); n_pprintf(hs(dst_std_3));
  // h_pprintf("src_std_3: 0x"); n_pprintf(hs(src_std_3));
  // h_pprintf("reps_3:    0x"); n_pprintf(hs(reps_3));
  printf("dst_std_3: 0x%0x\n", dst_std_3);
  printf("src_std_3: 0x%0x\n", src_std_3);
  printf("reps_3:    0x%0x\n", reps_3);
#endif
  idma_set_std3_rep3_in(dst_std_3, src_std_3, reps_3);

  idma_start_in();

#ifdef IRQ_EN
  asm volatile("wfi" ::: "memory");
  // h_pprintf("Detected IRQ...\n");
  printf("Detected IRQ...\n");
#else
  wait_print(WAIT_CYCLES);
#endif

#if VERBOSE > 100
  for (int i = 0; i < x_dim*y_dim; i++){
    // h_pprintf("DST[0x"); pprintf(hs(dst_addr + 2*i)); pprintf("]: 0x"); n_pprintf(hs(mmio16(dst_addr + 2*i)));
    printf("DST[0x%0x]: 0x%0x\n", dst_addr + 2*i, mmio16(dst_addr + 2*i));
  }
#endif

#if VERBOSE > 10
  unsigned int num_errors;
  num_errors = 0;
  for (int i = 0; i < x_dim*y_dim; i++) {
    if (mmio16(dst_addr + 2*i) != src_data[i]) {
      num_errors++;
      // h_pprintf("DST[0x"); pprintf(hs(dst_addr + 2*i)); pprintf("]: 0x"); pprintf(hs(mmio16(dst_addr + 2*i))); 
      // pprintf(" != SRC["); pprintf(ds(i)); pprintf("]: 0x"); n_pprintf(ds(src_data[i]));
      printf("DST[0x%0x]: 0x%0x != SRC[%0d]: 0x%0x\n", dst_addr + 2*i, mmio16(dst_addr + 2*i), i, src_data[i]);
    }
  }
  // h_pprintf("Detected "); pprintf(ds(num_errors)); n_pprintf(" error(s) in the transfer...");
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
  // h_pprintf("dst_addr: 0x"); n_pprintf(hs(dst_addr));
  // h_pprintf("src_addr: 0x"); n_pprintf(hs(src_addr));
  // h_pprintf("len:        "); n_pprintf(ds(len));
  printf("dst_addr: 0x%0x\n", dst_addr);
  printf("src_addr: 0x%0x\n", src_addr);
  printf("len:        %0d\n", len);
#endif
  idma_set_addr_len_out(dst_addr, src_addr, len);

  dst_std_2 = 0;
  src_std_2 = 0;
  reps_2    = 1;
#if VERBOSE > 100
  // h_pprintf("dst_std_2: 0x"); n_pprintf(hs(dst_std_2));
  // h_pprintf("src_std_2: 0x"); n_pprintf(hs(src_std_2));
  // h_pprintf("reps_2:    0x"); n_pprintf(hs(reps_2));
  printf("dst_std_2: 0x%0x\n", dst_std_2);
  printf("src_std_2: 0x%0x\n", src_std_2);
  printf("reps_2:    0x%0x\n", reps_2);
#endif
  idma_set_std2_rep2_out(dst_std_2, src_std_2, reps_2);

  dst_std_3 = 0;
  src_std_3 = 0;
  reps_3    = 1;
#if VERBOSE > 100
  // h_pprintf("dst_std_3: 0x"); n_pprintf(hs(dst_std_3));
  // h_pprintf("src_std_3: 0x"); n_pprintf(hs(src_std_3));
  // h_pprintf("reps_3:    0x"); n_pprintf(hs(reps_3));
  printf("dst_std_3: 0x%0x\n", dst_std_3);
  printf("src_std_3: 0x%0x\n", src_std_3);
  printf("reps_3:    0x%0x\n", reps_3);
#endif
  idma_set_std3_rep3_out(dst_std_3, src_std_3, reps_3);

  idma_start_out();

#ifdef IRQ_EN
  asm volatile("wfi" ::: "memory");
  // h_pprintf("Detected IRQ...\n");
  printf("Detected IRQ...\n");
#else
  wait_print(WAIT_CYCLES);
#endif

#if VERBOSE > 100
  for (int i = 0; i < x_dim*y_dim; i++){
    // h_pprintf("DST[0x"); pprintf(hs(dst_addr + 2*i)); pprintf("]: 0x"); n_pprintf(hs(mmio16(dst_addr + 2*i)));
    printf("DST[0x%0x]: 0x%0x\n", dst_addr + 2*i, mmio16(dst_addr + 2*i));
  }
#endif

#if VERBOSE > 10
  unsigned int num_errors;
  num_errors = 0;
  for (int i = 0; i < x_dim*y_dim; i++) {
    if (mmio16(dst_addr + 2*i) != mmio16(src_addr + 2*i)) {
      num_errors++;
      // h_pprintf("DST[0x"); pprintf(hs(dst_addr + 2*i)); pprintf("]: 0x"); pprintf(hs(mmio16(dst_addr + 2*i)));
      // pprintf(" != SRC[0x"); pprintf(hs(src_addr + 2*i)); pprintf("]: 0x"); n_pprintf(hs(mmio16(src_addr + 2*i)));
      printf("DST[0x%0x]: 0x%0x != SRC[%0d]: 0x%0x\n", dst_addr + 2*i, mmio16(dst_addr + 2*i), i, mmio16(src_addr + 2*i));
    }
  }
  // h_pprintf("Detected "); pprintf(ds(num_errors)); n_pprintf(" error(s) in the transfer...");
  printf("Detected %0d error(s) in the transfer...\n", num_errors);
#endif
}

int main(void) {
  // X
  // h_pprintf("Initializing X through iDMA...\n");
  printf("Initializing X through iDMA...\n");
  idma_mv_in(M_SIZE, N_SIZE, x_inp, (X_BASE + get_hartid()*L1_TILE_OFFSET));

  // W
  // h_pprintf("Initializing W through iDMA...\n");
  printf("Initializing W through iDMA...\n");
  idma_mv_in(N_SIZE, K_SIZE, w_inp, (W_BASE + get_hartid()*L1_TILE_OFFSET));

  // Y
  // h_pprintf("Initializing Y through iDMA...\n");
  printf("Initializing Y through iDMA...\n");
  idma_mv_in(M_SIZE, K_SIZE, y_inp, (Y_BASE + get_hartid()*L1_TILE_OFFSET));

#if VERBOSE > 10
  // h_pprintf("K_SIZE: 0x");   n_pprintf(hs(K_SIZE));
  // h_pprintf("M_SIZE: 0x");   n_pprintf(hs(M_SIZE));
  // h_pprintf("N_SIZE: 0x");   n_pprintf(hs(N_SIZE));
  printf("K_SIZE: 0x%0x\n", K_SIZE);
  printf("M_SIZE: 0x%0x\n", M_SIZE);
  printf("N_SIZE: 0x%0x\n", N_SIZE);
#endif

  redmule_mcnfig(K_SIZE, M_SIZE, N_SIZE);

  redmule_marith(Y_BASE + get_hartid()*L1_TILE_OFFSET, W_BASE + get_hartid()*L1_TILE_OFFSET, X_BASE + get_hartid()*L1_TILE_OFFSET);

#ifdef IRQ_EN
  irq_en(1<<IRQ_REDMULE_EVT_0);
#endif

  // h_pprintf("Testing matrix multiplication with RedMulE...\n");
  printf("Testing matrix multiplication with RedMulE...\n");

#ifdef IRQ_EN
  // Wait for end of computation
  asm volatile("wfi" ::: "memory");
  // h_pprintf("Detected IRQ...\n");
  printf("Detected IRQ...\n");
#else
  wait_print(WAIT_CYCLES);
#endif

  // h_pprintf("Moving results through iDMA...\n");
  printf("Moving results through iDMA...\n");
  idma_mv_out(M_SIZE, K_SIZE, Y_BASE + get_hartid()*L1_TILE_OFFSET, V_BASE + get_hartid()*MHARTID_OFFSET);

  // h_pprintf("Verifying results...\n");
  printf("Verifying results...\n");
  
  unsigned int num_errors[NUM_HARTS];
  num_errors[get_hartid()] = 0;

  uint16_t computed[NUM_HARTS], expected[NUM_HARTS], diff[NUM_HARTS];
  for(int i = 0; i < M_SIZE*K_SIZE; i++){
    computed[get_hartid()] = mmio16(V_BASE + get_hartid()*MHARTID_OFFSET + 2*i);
    expected[get_hartid()] = z_oup[i];
    diff[get_hartid()] = (computed[get_hartid()] > expected[get_hartid()]) ? (computed[get_hartid()] - expected[get_hartid()]) : (expected[get_hartid()] - computed[get_hartid()]);
    if(diff[get_hartid()] > DIFF_TH){
      num_errors[get_hartid()]++;
      // h_pprintf("**ERROR**: V[0x"); pprintf(hs(V_BASE + get_hartid()*MHARTID_OFFSET + 2*i)); pprintf("](=0x"); pprintf(hs(computed[get_hartid()]));
      // pprintf(") != Z["); pprintf(ds(i)); pprintf("](=0x"); pprintf(hs(expected[get_hartid()])); n_pprintf(")");
      printf("**ERROR**: V[0x%0x](=0x%0x) != Z[%0d](=0x%0x)\n", V_BASE + get_hartid()*MHARTID_OFFSET + 2*i, computed[get_hartid()], i, expected[get_hartid()]);
    }
  }
  // h_pprintf("Finished test with "); pprintf(ds(num_errors[get_hartid()])); n_pprintf(" error(s)");
  printf("Finished test with %0d error(s)\n", num_errors[get_hartid()]);

  uint32_t exit_code[NUM_HARTS];
  if(num_errors[get_hartid()])
    exit_code[get_hartid()] = FAIL_EXIT_CODE;
  else
    exit_code[get_hartid()] = PASS_EXIT_CODE;

  mmio16(TEST_END_ADDR + get_hartid()*2) = exit_code[get_hartid()] - get_hartid();

  return 0;
}
