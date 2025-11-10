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
 *         Based on mesh_test.c by Victor Isachi
 * 
 * MAGIA Mesh Test - Pure Event Unit API Version (FIXED)
 * Uses ONLY event_unit_utils for WFE/polling 
 * 
 * Configuration:
 * - Set USE_WFE to 1 for WFE (Wait-For-Event) mode
 * - Set USE_WFE to 0 for Event Unit polling mode
 * 
 * FIXED VERSION: Uses local variables instead of global arrays
 * to avoid triggering hardware bug in core_data_demux_eu_direct
 */

#include "magia_tile_utils.h"
#include "magia_utils.h"
#include "redmule_mm_utils.h"
#include "idma_mm_utils.h"
#include "event_unit_utils.h"

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

#define MHARTID_OFFSET (0x00010000)

#define M_SIZE (96)
#define N_SIZE (64)
#define K_SIZE (64)

#define VERBOSE (0)

#define WAIT_CYCLES (10)

#define DIFF_TH (0x0011)

#define USE_WFE (0)

void idma_mv_in_pure_eu(unsigned int x_dim, unsigned int y_dim, uint16_t src_data[], uint32_t dst_address) {
  uint32_t dst_addr;
  uint32_t src_addr;
  uint32_t len;

  // Initialize Event Unit once
  static int eu_initialized = 0;
  if (!eu_initialized) {
    eu_init();
    eu_initialized = 1;
  }

  for (int i = 0; i < x_dim*y_dim; i++)
    mmio16(T_BASE + get_hartid()*MHARTID_OFFSET + 2*i) = src_data[i];

  dst_addr = (uint32_t)dst_address;
  src_addr = (uint32_t)(T_BASE + get_hartid()*MHARTID_OFFSET);
  len      = (uint32_t)(x_dim*y_dim*2);
#if VERBOSE > 10
  printf("dst_addr: 0x%0x\n", dst_addr);
  printf("src_addr: 0x%0x\n", src_addr);
  printf("len:        %0d\n", len);
#endif

  idma_L2ToL1(src_addr, dst_addr, len);

  eu_clear_events(0xFFFFFFFF);
  eu_enable_events(EU_IDMA_A2O_DONE_MASK);

  eu_wait_mode_t wait_mode = USE_WFE ? EU_WAIT_MODE_WFE : EU_WAIT_MODE_POLLING;
  eu_idma_wait_direction_completion(0, wait_mode);

#if VERBOSE > 100
  for (int i = 0; i < x_dim*y_dim; i++){
    uint32_t addr = dst_addr + 2*i;
    volatile uint16_t *ptr = (volatile uint16_t *)addr;
    uint16_t val = *ptr;
    printf("DST[0x%0x]: 0x%0x\n", addr, val);
  }
#endif

#if VERBOSE > 10
  unsigned int num_errors;
  num_errors = 0;
  for (int i = 0; i < x_dim*y_dim; i++) {
    uint32_t addr = dst_addr + 2*i;
    volatile uint16_t *ptr = (volatile uint16_t *)addr;
    uint16_t dst_val = *ptr;
    uint16_t src_val = src_data[i];
    if (dst_val != src_val) {
      num_errors++;
      printf("DST[0x%0x]: 0x%0x != SRC[%0d]: 0x%0x\n", addr, dst_val, i, src_val);
    }
  }
  printf("Detected %0d error(s) in the transfer...\n", num_errors);
#endif
}

void idma_mv_out_pure_eu(unsigned int x_dim, unsigned int y_dim, uint32_t src_address, uint32_t dst_address) {
  uint32_t dst_addr;
  uint32_t src_addr;
  uint32_t len;

  dst_addr = (uint32_t)dst_address;
  src_addr = (uint32_t)src_address;
  len      = (uint32_t)(x_dim*y_dim*2);
#if VERBOSE > 10
  printf("dst_addr: 0x%0x\n", dst_addr);
  printf("src_addr: 0x%0x\n", src_addr);
  printf("len:        %0d\n", len);
#endif

  idma_L1ToL2(src_addr, dst_addr, len);

  eu_clear_events(0xFFFFFFFF);
  eu_enable_events(EU_IDMA_O2A_DONE_MASK);

  eu_wait_mode_t wait_mode = USE_WFE ? EU_WAIT_MODE_WFE : EU_WAIT_MODE_POLLING;
  eu_idma_wait_direction_completion(1, wait_mode);

#if VERBOSE > 100
  for (int i = 0; i < x_dim*y_dim; i++){
    uint32_t addr = dst_addr + 2*i;
    volatile uint16_t *ptr = (volatile uint16_t *)addr;
    uint16_t val = *ptr;
    printf("DST[0x%0x]: 0x%0x\n", addr, val);
  }
#endif

#if VERBOSE > 10
  unsigned int num_errors;
  num_errors = 0;
  for (int i = 0; i < x_dim*y_dim; i++) {
    uint32_t dst_addr_i = dst_addr + 2*i;
    uint32_t src_addr_i = src_addr + 2*i;
    volatile uint16_t *dst_ptr = (volatile uint16_t *)dst_addr_i;
    volatile uint16_t *src_ptr = (volatile uint16_t *)src_addr_i;
    uint16_t dst_val = *dst_ptr;
    uint16_t src_val = *src_ptr;
    if (dst_val != src_val) {
      num_errors++;
      printf("DST[0x%0x]: 0x%0x != SRC[0x%0x]: 0x%0x\n", dst_addr_i, dst_val, src_addr_i, src_val);
    }
  }
  printf("Detected %0d error(s) in the transfer...\n", num_errors);
#endif
}

int main(void) {
  // X
  printf("Initializing X through iDMA...\n");
  idma_mv_in_pure_eu(M_SIZE, N_SIZE, x_inp, (X_BASE + get_hartid()*L1_TILE_OFFSET));

  // W
  printf("Initializing W through iDMA...\n");
  idma_mv_in_pure_eu(N_SIZE, K_SIZE, w_inp, (W_BASE + get_hartid()*L1_TILE_OFFSET));

  // Y
  printf("Initializing Y through iDMA...\n");
  idma_mv_in_pure_eu(M_SIZE, K_SIZE, y_inp, (Y_BASE + get_hartid()*L1_TILE_OFFSET));

#if VERBOSE > 10
  printf("K_SIZE: 0x%0x\n", K_SIZE);
  printf("M_SIZE: 0x%0x\n", M_SIZE);
  printf("N_SIZE: 0x%0x\n", N_SIZE);
#endif

  printf("Testing matrix multiplication with RedMulE...\n");

  hwpe_cg_enable();
  hwpe_soft_clear();

  int offload_id_tmp;
  while ((offload_id_tmp = hwpe_acquire_job()) < 0)
    ;

  redmule_cfg((unsigned int)(X_BASE + get_hartid()*L1_TILE_OFFSET), 
              (unsigned int)(W_BASE + get_hartid()*L1_TILE_OFFSET), 
              (unsigned int)(Y_BASE + get_hartid()*L1_TILE_OFFSET), 
              M_SIZE, N_SIZE, K_SIZE, (uint8_t)gemm_ops, (uint8_t)Float16);

  hwpe_trigger_job();

  eu_clear_events(0xFFFFFFFF);
  eu_enable_events(EU_REDMULE_DONE_MASK);

  eu_wait_mode_t wait_mode = USE_WFE ? EU_WAIT_MODE_WFE : EU_WAIT_MODE_POLLING;
  eu_redmule_wait_completion(wait_mode);

  printf("Moving results through iDMA...\n");
  idma_mv_out_pure_eu(M_SIZE, K_SIZE, Y_BASE + get_hartid()*L1_TILE_OFFSET, V_BASE + get_hartid()*MHARTID_OFFSET);

  printf("Verifying results...\n");
  
  // ✅ FIX: Use purely local variables instead of global arrays
  unsigned int num_errors = 0;

  for(int i = 0; i < M_SIZE*K_SIZE; i++){
    uint32_t addr = V_BASE + get_hartid()*MHARTID_OFFSET + 2*i;
    volatile uint16_t *ptr = (volatile uint16_t *)addr;
    
    // ✅ FIX: Local variables - compiler keeps them in registers
    uint16_t comp_val = *ptr;
    uint16_t exp_val = z_oup[i];
    uint16_t diff_val = (comp_val > exp_val) ? (comp_val - exp_val) : (exp_val - comp_val);
    
    if(diff_val > DIFF_TH){
      num_errors++;
      printf("**ERROR**: V[0x%0x](=0x%0x) != Z[%0d](=0x%0x) diff=0x%0x\n", 
             addr, comp_val, i, exp_val, diff_val);
    }
  }
  
  printf("Finished test with %0d error(s)\n", num_errors);


  return num_errors;
}
