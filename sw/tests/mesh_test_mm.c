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
 * Authors:
 * 
 * MAGIA Mesh Test - Memory Mapped Version
 */

#include "magia_tile_utils.h"
#include "magia_utils.h"
#include "redmule_mm_utils.h"
#include "idma_mm_utils.h"

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

#ifdef IRQ_EN
  irq_en(1<<IRQ_A2O_DONE);
#endif

  for (int i = 0; i < x_dim*y_dim; i++)
    mmio16(T_BASE + get_hartid()*MHARTID_OFFSET + 2*i) = src_data[i];

  dst_addr = (uint32_t)dst_address;
  src_addr = (uint32_t)(T_BASE + get_hartid()*MHARTID_OFFSET);
  len      = (uint32_t)(x_dim*y_dim*2); // 2 Bytes per element
#if VERBOSE > 10
  printf("dst_addr: 0x%0x\n", dst_addr);
  printf("src_addr: 0x%0x\n", src_addr);
  printf("len:        %0d\n", len);
#endif

  uint32_t transfer_id = idma_L2ToL1(src_addr, dst_addr, len);

#ifdef IRQ_EN
  asm volatile("wfi" ::: "memory");
  printf("Detected IRQ...\n");
#else
  dma_wait(transfer_id);
#endif

#if VERBOSE > 100
  for (int i = 0; i < x_dim*y_dim; i++){
    printf("DST[0x%0x]: 0x%0x\n", dst_addr + 2*i, mmio16(dst_addr + 2*i));
  }
#endif

#if VERBOSE > 10
  unsigned int num_errors;
  num_errors = 0;
  for (int i = 0; i < x_dim*y_dim; i++) {
    if (mmio16(dst_addr + 2*i) != src_data[i]) {
      num_errors++;
      printf("DST[0x%0x]: 0x%0x != SRC[%0d]: 0x%0x\n", dst_addr + 2*i, mmio16(dst_addr + 2*i), i, src_data[i]);
    }
  }
  printf("Detected %0d error(s) in the transfer...\n", num_errors);
#endif
}

void idma_mv_out(unsigned int x_dim, unsigned int y_dim, uint32_t src_address, uint32_t dst_address){
  uint32_t dst_addr;
  uint32_t src_addr;
  uint32_t len;

#ifdef IRQ_EN
  irq_en(1<<IRQ_O2A_DONE);
#endif

  dst_addr = (uint32_t)dst_address;
  src_addr = (uint32_t)src_address;
  len      = (uint32_t)(x_dim*y_dim*2); // 2 Bytes per element
#if VERBOSE > 10
  printf("dst_addr: 0x%0x\n", dst_addr);
  printf("src_addr: 0x%0x\n", src_addr);
  printf("len:        %0d\n", len);
#endif

  uint32_t transfer_id = idma_L1ToL2(src_addr, dst_addr, len);

#ifdef IRQ_EN
  asm volatile("wfi" ::: "memory");
  printf("Detected IRQ...\n");
#else
  dma_wait(transfer_id);
#endif

#if VERBOSE > 100
  for (int i = 0; i < x_dim*y_dim; i++){
    printf("DST[0x%0x]: 0x%0x\n", dst_addr + 2*i, mmio16(dst_addr + 2*i));
  }
#endif

#if VERBOSE > 10
  unsigned int num_errors;
  num_errors = 0;
  for (int i = 0; i < x_dim*y_dim; i++) {
    if (mmio16(dst_addr + 2*i) != mmio16(src_addr + 2*i)) {
      num_errors++;
      printf("DST[0x%0x]: 0x%0x != SRC[%0d]: 0x%0x\n", dst_addr + 2*i, mmio16(dst_addr + 2*i), i, mmio16(src_addr + 2*i));
    }
  }
  printf("Detected %0d error(s) in the transfer...\n", num_errors);
#endif
}

int main(void) {
  // X
  printf("Initializing X through iDMA...\n");
  idma_mv_in(M_SIZE, N_SIZE, x_inp, (X_BASE + get_hartid()*L1_TILE_OFFSET));

  // W
  printf("Initializing W through iDMA...\n");
  idma_mv_in(N_SIZE, K_SIZE, w_inp, (W_BASE + get_hartid()*L1_TILE_OFFSET));

  // Y
  printf("Initializing Y through iDMA...\n");
  idma_mv_in(M_SIZE, K_SIZE, y_inp, (Y_BASE + get_hartid()*L1_TILE_OFFSET));

#if VERBOSE > 10
  printf("K_SIZE: 0x%0x\n", K_SIZE);
  printf("M_SIZE: 0x%0x\n", M_SIZE);
  printf("N_SIZE: 0x%0x\n", N_SIZE);
#endif

  printf("Testing matrix multiplication with RedMulE...\n");

  // Initialize and configure RedMulE using MM approach
  hwpe_cg_enable();
  hwpe_soft_clear();

  int offload_id_tmp;
  while ((offload_id_tmp = hwpe_acquire_job()) < 0)
    ;

  redmule_cfg((unsigned int)(X_BASE + get_hartid()*L1_TILE_OFFSET), 
              (unsigned int)(W_BASE + get_hartid()*L1_TILE_OFFSET), 
              (unsigned int)(Y_BASE + get_hartid()*L1_TILE_OFFSET), 
              M_SIZE, N_SIZE, K_SIZE, (uint8_t)gemm_ops, (uint8_t)Float16);

#ifdef IRQ_EN
  irq_en(1<<IRQ_REDMULE_EVT_0);
#endif

  hwpe_trigger_job();

  // Wait for HWPE completion
  hwpe_wait_for_completion();

#ifdef IRQ_EN
  printf("Detected IRQ...\n");
#endif

  printf("Moving results through iDMA...\n");
  idma_mv_out(M_SIZE, K_SIZE, Y_BASE + get_hartid()*L1_TILE_OFFSET, V_BASE + get_hartid()*MHARTID_OFFSET);

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
      printf("**ERROR**: V[0x%0x](=0x%0x) != Z[%0d](=0x%0x)\n", V_BASE + get_hartid()*MHARTID_OFFSET + 2*i, computed[get_hartid()], i, expected[get_hartid()]);
    }
  }
  printf("Finished test with %0d error(s)\n", num_errors[get_hartid()]);

  uint32_t exit_code[NUM_HARTS];
  if(num_errors[get_hartid()])
    exit_code[get_hartid()] = FAIL_EXIT_CODE;
  else
    exit_code[get_hartid()] = PASS_EXIT_CODE;

  mmio16(TEST_END_ADDR + get_hartid()*2) = exit_code[get_hartid()] - get_hartid();

  return 0;
}