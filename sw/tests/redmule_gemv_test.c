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
 * MAGIA RedMulE GeMV Test
 */

#include "magia_tile_utils.h"
#include "magia_utils.h"
#include "redmule_isa_utils.h"
#include "idma_isa_utils.h"

#include "x_input_gemv.h"
#include "w_input_gemv.h"
#include "y_input_gemv.h"
#include "z_output_gemv.h"

#define X_BASE (L1_BASE + 0x00012048)
#define W_BASE (L1_BASE + 0x00016048)
#define Y_BASE (L1_BASE + 0x0001A048)
#define Z_BASE (L1_BASE + 0x0001E048)

#define M_SIZE (1)
#define N_SIZE (64)
#define K_SIZE (64)

#define DIFF_TH (0x0011)

int main(void) {
  uint32_t hartid = get_hartid();
  uint32_t num_errors = 0;

  if (hartid == 0) {
    irq_en(1<<IRQ_A2O_DONE);
    irq_en((1<<IRQ_REDMULE_EVT_0) | (1<<IRQ_REDMULE_EVT_1));
    idma_conf_in();

    // Move X in
    printf("Moving X in...\n");
    idma_set_addr_len_in(X_BASE, x_inp, M_SIZE*N_SIZE*2);
    idma_set_std2_rep2_in(0, 0, 1);
    idma_set_std3_rep3_in(0, 0, 1);
    idma_start_in();
    asm volatile("wfi" ::: "memory");
    printf("Moved X in...\n");
    
    // Move W in
    printf("Moving W in...\n");
    idma_set_addr_len_in(W_BASE, w_inp, N_SIZE*K_SIZE*2);
    idma_set_std2_rep2_in(0, 0, 1);
    idma_set_std3_rep3_in(0, 0, 1);
    idma_start_in();
    asm volatile("wfi" ::: "memory");
    printf("Moved W in...\n");

    // Move Y in
    printf("Moving Y in...\n");
    idma_set_addr_len_in(Y_BASE, y_inp, M_SIZE*K_SIZE*2);
    idma_set_std2_rep2_in(0, 0, 1);
    idma_set_std3_rep3_in(0, 0, 1);
    idma_start_in();
    asm volatile("wfi" ::: "memory");
    printf("Moved Y in...\n");

    // Move Z (golden) in
    printf("Moving Z (golden) in...\n");
    idma_set_addr_len_in(Z_BASE, z_oup, M_SIZE*K_SIZE*2);
    idma_set_std2_rep2_in(0, 0, 1);
    idma_set_std3_rep3_in(0, 0, 1);
    idma_start_in();
    asm volatile("wfi" ::: "memory");
    printf("Moved Z (golden) in...\n");

    printf("Testing matrix-vector multiplication with RedMulE...\n");
    printf("Workload C = AxB sizes: A %0dx%0d vector, B %0dx%0d matrix and C %0dx%0d matrix\n", M_SIZE, N_SIZE, N_SIZE, K_SIZE, M_SIZE, K_SIZE);

    redmule_mcnfig(K_SIZE, M_SIZE, N_SIZE);

    redmule_marith(Y_BASE, W_BASE, X_BASE);
    asm volatile("wfi" ::: "memory");
    printf("GeMV finished...\n");

    printf("Verifying results...\n");
    uint16_t computed, expected, diff;
    for(int i = 0; i < M_SIZE*K_SIZE; i++){
      computed = mmio16(Y_BASE + 2*i);
      expected = mmio16(Z_BASE + 2*i);
      diff = (computed > expected) ? (computed - expected) : (expected - computed);
      if(diff > DIFF_TH){
        num_errors++;
        printf("**ERROR**: Y[%8x](=0x%4x) != Z[%8x](=0x%4x)\n", Y_BASE + 2*i, computed, Z_BASE + 2*i, expected);
      }
    }
    printf("Finished test with %0d errors\n", num_errors);
  }

  return num_errors;
}
