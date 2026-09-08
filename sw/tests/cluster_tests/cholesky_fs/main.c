/*
 * Copyright (C) 2026 Copyright ETH Zurich, University of Bologna,
 * and Fondazione Chips-IT
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
 * MAGIA Cholesky Test Using PULP Cluster
 */

#include <stdint.h>
#include <string.h>

// #define SIZE_64x64
#define SIZE_128x128
// #define SIZE_256x256
// #define SIZE_512x512
// #define SIZE_1024x1024

#if defined(SIZE_64x64)
#include "test_data/spd_mat_64x64.h"
#elif defined(SIZE_128x128)
#include "test_data/spd_mat_128x128.h"
#elif defined(SIZE_256x256)
#include "test_data/spd_mat_256x256.h"
#elif defined(SIZE_512x512)
#include "test_data/spd_mat_512x512.h"
#elif defined(SIZE_1024x1024)
#include "test_data/spd_mat_1024x1024.h"
#endif

#include "magia_tile_utils.h"
#include "magia_utils.h"
#include "cluster_utils.h"
#include "idma_mm_utils.h"
#include "fsync_mm_api.h"
#include "cholesky_pulp_task_bin.h"

#define DBG_PRINT

#define DMA_IN  (0)
#define DMA_OUT (1)

// float is 4 bytes
#define F_SIZE (4)

// uint32_t is 4 bytes
#define U_SIZE (4)

// Maximum number of parameters that can be passed to the cluster
#define MAX_PARAM (8)

#define POTRF_LOWER_CL_KERNEL                 (0)
#define TRSM_RIGHT_LOWER_TRANS_ROWS_CL_KERNEL (1)
#define GEMM_NT_UPDATE_CL_KERNEL              (2)
#define SYRK_LOWER_UPDATE_CL_KERNEL           (3)

void cluster_wakeup(){
   cluster_boot(PULP_BINARY_START);
}

void cluster_task(uint32_t params_addr){
   cluster_resume();
   cluster_arm_done_event();
   cluster_dispatch_task_with_params(CHOLESKY_PULP_TASK, params_addr);
   cluster_wait_done_eu();
   cluster_stop();
}

int main(void) {
   uint32_t hartid = get_hartid();
   uint32_t hartid_row = GET_Y_ID(hartid);
   uint32_t hartid_col = GET_X_ID(hartid);

   // Block size, address, and split and leftover each tile will work with
   uint32_t block_1d_size = M_SIZE / MESH_Y_TILES;
   uint32_t block_2d_size = block_1d_size * block_1d_size;

   uint32_t block_row_offset = hartid_row * block_1d_size * (M_SIZE * F_SIZE);
   uint32_t block_col_offset = hartid_col * block_1d_size * F_SIZE;
   uint32_t a_block_src_addr = (uint32_t)(&a_float) + block_row_offset + block_col_offset;
   uint32_t l_block_dst_addr = (uint32_t)(&l_float) + block_row_offset + block_col_offset;

   uint32_t split    = (block_1d_size + 1) / 2;
   uint32_t leftover = block_1d_size - split;

   // Setup tile L1 memory map
   uint32_t params_addr = L1_BASE + hartid*L1_TILE_OFFSET;
   uint32_t params_size = MAX_PARAM * U_SIZE;
   
   uint32_t a_l1_addr = params_addr + params_size;
   uint32_t a_l1_size = block_2d_size * F_SIZE;
   uint32_t t_l1_addr = a_l1_addr + a_l1_size;
   uint32_t t_l1_size = a_l1_size;
   uint32_t r_l1_addr = t_l1_addr + t_l1_size;
   uint32_t r_l1_size = a_l1_size;
   uint32_t c_l1_addr = r_l1_addr + r_l1_size;
   uint32_t c_l1_size = a_l1_size;
 
#ifdef DBG_PRINT
   printf("[DBG] Tile %0u (%0u, %0u) parameters:\n"
          "      Block size: %0ux%0u (%0u) - Input matrix size %0ux%0u\n"
          "      A block L2 address: 0x%08x\n"
          "      L block L2 address: 0x%08x\n"
          "      Split: %0u, leftover: %0u\n"
          "      Params addr: 0x%08x, size: %0u B\n"
          "      A L1 addr: 0x%08x, size: %0u B\n"
          "      T L1 addr: 0x%08x, size: %0u B\n"
          "      R L1 addr: 0x%08x, size: %0u B\n"
          "      C L1 addr: 0x%08x, size: %0u B\n",
           hartid, hartid_row, hartid_col,
           block_1d_size, block_1d_size, block_2d_size, M_SIZE, M_SIZE,
           a_block_src_addr,
           l_block_dst_addr,
           split, leftover,
           params_addr, params_size,
           a_l1_addr, a_l1_size,
           t_l1_addr, t_l1_size,
           r_l1_addr, r_l1_size,
           c_l1_addr, c_l1_size);
#endif /*DBG_PRINT*/

   // Setup tile EU, iDMA, FractalSync and cluster
   eu_init();
   eu_idma_init();
   eu_fsync_init();
   eu_pulp_init();
   cluster_wakeup();

   // Move block of the input matrix into tile
   idma_mm_conf_default_dir(DMA_IN);
   idma_mm_set_addr_len_dir(DMA_IN, a_l1_addr, a_block_src_addr, block_1d_size*F_SIZE);
   idma_mm_set_2d_params_dir(DMA_IN, block_1d_size*F_SIZE, M_SIZE*F_SIZE, block_1d_size);
   idma_mm_set_3d_params_dir(DMA_IN, 0, 0, 1);
   (void)idma_mm_start_transfer_dir(DMA_IN, 0);
   eu_wait_events_wfe(EU_IDMA_A2O_DONE_MASK);

#ifdef DBG_PRINT
   printf("[DBG] Block moved in L1:\n");
   for(int i = 0; i < block_1d_size; i++){
      printf("      ");
      for(int j = 0; j < block_1d_size; j++){
         uint32_t idx = i*block_1d_size + j;
         uint32_t a = mmio32(a_l1_addr + idx*U_SIZE);
         printf("0x%08x ", a);
      }
      printf("\n");
   }
#endif /*DBG_PRINT*/

   // Perform global barrier 
   fsync_mm_global();
   eu_wait_events_wfe(EU_FSYNC_DONE_MASK);

   // Enter main Cholesky loop
   for(int k = 0; k < MESH_Y_TILES; k++){
      // Factor diagonal block A[k, k]
      if(hartid_row == k && hartid_col == k){
         mmio32(params_addr)      = POTRF_LOWER_CL_KERNEL;
         mmio32(params_addr + 4)  = a_l1_addr;
         mmio32(params_addr + 8)  = block_1d_size;
         mmio32(params_addr + 12) = c_l1_addr + c_l1_size;

#ifdef DBG_PRINT
         printf("[DBG] Cholesky loop iteration %0u: Starting POTRF_LOWER_CL_KERNEL with parameter stack: 0x%08x, 0x%08x, 0x%08x\n",
            k, a_l1_addr, block_1d_size, c_l1_addr + c_l1_size);
#endif /*DBG_PRINT*/

         cluster_task(params_addr);
         // eu_wait_events_wfe(EU_CLUSTER_DONE_MASK); -> already implemented by cluster_task()
      }

#ifdef DBG_PRINT
      printf("[DBG] Cholesky loop iteration %0u: Finished POTRF_LOWER_CL_KERNEL\n", k);
#endif /*DBG_PRINT*/

      fsync_mm_global();
      eu_wait_events_wfe(EU_FSYNC_DONE_MASK);

      // Last iteration: no other operation is necessary
      if(k == (MESH_Y_TILES-1)) continue;

      // Broadcast L[k, k] to row k and column k
      if(hartid_row == k){
         if(hartid_col > k){
            uint32_t l1_offset = (hartid - GET_ID(k, k)) * L1_TILE_OFFSET;
            idma_mm_conf_default_dir(DMA_IN);
            idma_mm_set_addr_len_dir(DMA_IN, r_l1_addr, a_l1_addr-l1_offset, block_2d_size*F_SIZE);
            idma_mm_set_2d_params_dir(DMA_IN, 0, 0, 1);
            idma_mm_set_3d_params_dir(DMA_IN, 0, 0, 1);
            (void)idma_mm_start_transfer_dir(DMA_IN, 0);
            eu_wait_events_wfe(EU_IDMA_A2O_DONE_MASK);

#ifdef DBG_PRINT
            printf("[DBG] Cholesky loop iteration %0u: L[k, k] row broadcast from 0x%08x to 0x%08x finished\n", k, a_l1_addr-l1_offset, r_l1_addr);
#endif /*DBG_PRINT*/
         }
         fsync_mm_rows();
         eu_wait_events_wfe(EU_FSYNC_DONE_MASK);
      }
      if(hartid_col == k){
         if(hartid_row > k){
            uint32_t l1_offset = (hartid - GET_ID(k, k)) * L1_TILE_OFFSET;
            idma_mm_conf_default_dir(DMA_IN);
            idma_mm_set_addr_len_dir(DMA_IN, c_l1_addr, a_l1_addr-l1_offset, block_2d_size*F_SIZE);
            idma_mm_set_2d_params_dir(DMA_IN, 0, 0, 1);
            idma_mm_set_3d_params_dir(DMA_IN, 0, 0, 1);
            (void)idma_mm_start_transfer_dir(DMA_IN, 0);
            eu_wait_events_wfe(EU_IDMA_A2O_DONE_MASK);

#ifdef DBG_PRINT
            printf("[DBG] Cholesky loop iteration %0u: L[k, k] column broadcast from 0x%08x to 0x%08x finished\n", k, a_l1_addr-l1_offset, c_l1_addr);
#endif /*DBG_PRINT*/
         }
         fsync_mm_cols();
         eu_wait_events_wfe(EU_FSYNC_DONE_MASK);
      }

#ifdef DBG_PRINT
      printf("[DBG] Cholesky loop iteration %0u: L[k, k] row and column broadcast finished\n", k);
#endif /*DBG_PRINT*/

      // Compute TRSM
      if(hartid_col == k && hartid_row > k){
         // Tiles in the same column already have the necessary A submatrix
         mmio32(params_addr)      = TRSM_RIGHT_LOWER_TRANS_ROWS_CL_KERNEL;
         mmio32(params_addr + 4)  = a_l1_addr;
         mmio32(params_addr + 8)  = c_l1_addr;
         mmio32(params_addr + 12) = block_1d_size;
         mmio32(params_addr + 16) = 0;
         mmio32(params_addr + 20) = split;

#ifdef DBG_PRINT
         printf("[DBG] Cholesky loop iteration %0u: Starting TRSM_RIGHT_LOWER_TRANS_ROWS_CL_KERNEL with parameter stack: 0x%08x, 0x%08x, 0x%08x, 0x%08x, 0x%08x\n",
            k, a_l1_addr, c_l1_addr, block_1d_size, 0, split);
#endif /*DBG_PRINT*/

         cluster_task(params_addr);
      }else if(hartid_row == k && hartid_col > k){
         // Tiles in the same row need to retrieve the A submatrix from tiles with transposed indices
         uint32_t l1_offset     = (GET_ID(hartid_col, hartid_row) - hartid) * L1_TILE_OFFSET;
         uint32_t a_l1_offset   = l1_offset + split * block_1d_size * F_SIZE;
         uint32_t leftover_size = leftover * block_1d_size;

         idma_mm_conf_default_dir(DMA_IN);
         idma_mm_set_addr_len_dir(DMA_IN, t_l1_addr, a_l1_addr+a_l1_offset, leftover_size*F_SIZE);
         idma_mm_set_2d_params_dir(DMA_IN, 0, 0, 1);
         idma_mm_set_3d_params_dir(DMA_IN, 0, 0, 1);
         (void)idma_mm_start_transfer_dir(DMA_IN, 0);
         eu_wait_events_wfe(EU_IDMA_A2O_DONE_MASK);

         mmio32(params_addr)      = TRSM_RIGHT_LOWER_TRANS_ROWS_CL_KERNEL;
         mmio32(params_addr + 4)  = t_l1_addr;
         mmio32(params_addr + 8)  = r_l1_addr;
         mmio32(params_addr + 12) = block_1d_size;
         mmio32(params_addr + 16) = 0;
         mmio32(params_addr + 20) = leftover;

#ifdef DBG_PRINT
         printf("[DBG] Cholesky loop iteration %0u: Starting TRSM_RIGHT_LOWER_TRANS_ROWS_CL_KERNEL with parameter stack: 0x%08x, 0x%08x, 0x%08x, 0x%08x, 0x%08x\n",
            k, t_l1_addr, r_l1_addr, block_1d_size, 0, leftover);
#endif /*DBG_PRINT*/

         cluster_task(params_addr);

         idma_mm_conf_default_dir(DMA_OUT);
         idma_mm_set_addr_len_dir(DMA_OUT, a_l1_addr+a_l1_offset, t_l1_addr, leftover_size*F_SIZE);
         idma_mm_set_2d_params_dir(DMA_OUT, 0, 0, 1);
         idma_mm_set_3d_params_dir(DMA_OUT, 0, 0, 1);
         (void)idma_mm_start_transfer_dir(DMA_OUT, 0);
         eu_wait_events_wfe(EU_IDMA_O2A_DONE_MASK);
      }

#ifdef DBG_PRINT
      printf("[DBG] Cholesky loop iteration %0u: Finished TRSM_RIGHT_LOWER_TRANS_ROWS_CL_KERNEL\n", k);
#endif /*DBG_PRINT*/

      fsync_mm_global();
      eu_wait_events_wfe(EU_FSYNC_DONE_MASK);

      // Propagate L[i, k] across row i
      if(hartid_row > k){
         if(hartid_col > k){
            uint32_t l1_offset = (hartid - GET_ID(hartid_row, k)) * L1_TILE_OFFSET;
            idma_mm_conf_default_dir(DMA_IN);
            idma_mm_set_addr_len_dir(DMA_IN, r_l1_addr, a_l1_addr-l1_offset, block_2d_size*F_SIZE);
            idma_mm_set_2d_params_dir(DMA_IN, 0, 0, 1);
            idma_mm_set_3d_params_dir(DMA_IN, 0, 0, 1);
            (void)idma_mm_start_transfer_dir(DMA_IN, 0);
            eu_wait_events_wfe(EU_IDMA_A2O_DONE_MASK);

#ifdef DBG_PRINT
            printf("[DBG] Cholesky loop iteration %0u: L[i, k] propagation across row from 0x%08x to 0x%08x finished\n", k, a_l1_addr-l1_offset, r_l1_addr);
#endif /*DBG_PRINT*/
         }
         fsync_mm_rows();
         eu_wait_events_wfe(EU_FSYNC_DONE_MASK);
      }

      // Propagate L[j, k] across column j
      if(hartid_col > k){
         fsync_mm_cols();
         eu_wait_events_wfe(EU_FSYNC_DONE_MASK);
         if(hartid_row > k){
            uint32_t l1_offset = (hartid_row > hartid_col)?
                                 (hartid - GET_ID(hartid_col, hartid_col)) * L1_TILE_OFFSET:
                                 (GET_ID(hartid_col, hartid_col) - hartid) * L1_TILE_OFFSET;
            uint32_t r_l1_addr_offset = (hartid_row > hartid_col)?
                                         r_l1_addr-l1_offset:
                                         r_l1_addr+l1_offset;
            idma_mm_conf_default_dir(DMA_IN);
            idma_mm_set_addr_len_dir(DMA_IN, c_l1_addr, r_l1_addr_offset, block_2d_size*F_SIZE);
            idma_mm_set_2d_params_dir(DMA_IN, 0, 0, 1);
            idma_mm_set_3d_params_dir(DMA_IN, 0, 0, 1);
            (void)idma_mm_start_transfer_dir(DMA_IN, 0);
            eu_wait_events_wfe(EU_IDMA_A2O_DONE_MASK);

#ifdef DBG_PRINT
            printf("[DBG] Cholesky loop iteration %0u: L[j, k] propagation across column from 0x%08x to 0x%08x finished\n", k, r_l1_addr_offset, c_l1_addr);
#endif /*DBG_PRINT*/
         }
      }

#ifdef DBG_PRINT
      printf("[DBG] Cholesky loop iteration %0u: L[i, k] row and L[j, k] column propagation finished\n", k);
#endif /*DBG_PRINT*/

      // Trailing update: compute lower-triangular SYRK on diagonal tiles,
      // compute GEMM to update A[i, j] on non-diagonal tiles
      if(hartid_row > k && hartid_col > k){
         if(hartid_row == hartid_col){
            mmio32(params_addr)      = SYRK_LOWER_UPDATE_CL_KERNEL;
            mmio32(params_addr + 4)  = a_l1_addr;
            mmio32(params_addr + 8)  = r_l1_addr;
            mmio32(params_addr + 12) = block_1d_size;

#ifdef DBG_PRINT
            printf("[DBG] Cholesky loop iteration %0u: Starting SYRK_LOWER_UPDATE_CL_KERNEL with parameter stack: 0x%08x, 0x%08x, 0x%08x\n",
               k, a_l1_addr, r_l1_addr, block_1d_size);
#endif /*DBG_PRINT*/
            
            cluster_task(params_addr);
         }else if(hartid_row > hartid_col){
            // Tiles in the lower triangle already have the necessary A submatrix
            mmio32(params_addr)      = GEMM_NT_UPDATE_CL_KERNEL;
            mmio32(params_addr + 4)  = a_l1_addr;
            mmio32(params_addr + 8)  = r_l1_addr;
            mmio32(params_addr + 12) = c_l1_addr;
            mmio32(params_addr + 16) = block_1d_size;
            mmio32(params_addr + 20) = 0;
            mmio32(params_addr + 24) = split;

#ifdef DBG_PRINT
            printf("[DBG] Cholesky loop iteration %0u: Starting GEMM_NT_UPDATE_CL_KERNEL with parameter stack: 0x%08x, 0x%08x, 0x%08x, 0x%08x, 0x%08x, 0x%08x\n",
               k, a_l1_addr, r_l1_addr, c_l1_addr, block_1d_size, 0, split);
#endif /*DBG_PRINT*/

            cluster_task(params_addr);
         }else{
            // Tiles in the upper triangle need to retrieve the A submatrix from tiles with transposed indices
            uint32_t l1_offset     = (GET_ID(hartid_col, hartid_row) - hartid) * L1_TILE_OFFSET;
            uint32_t a_l1_offset   = l1_offset + split * block_1d_size * F_SIZE;
            uint32_t leftover_size = leftover * block_1d_size;

            idma_mm_conf_default_dir(DMA_IN);
            idma_mm_set_addr_len_dir(DMA_IN, t_l1_addr, a_l1_addr+a_l1_offset, leftover_size*F_SIZE);
            idma_mm_set_2d_params_dir(DMA_IN, 0, 0, 1);
            idma_mm_set_3d_params_dir(DMA_IN, 0, 0, 1);
            (void)idma_mm_start_transfer_dir(DMA_IN, 0);
            eu_wait_events_wfe(EU_IDMA_A2O_DONE_MASK);

            mmio32(params_addr)      = GEMM_NT_UPDATE_CL_KERNEL;
            mmio32(params_addr + 4)  = t_l1_addr;
            mmio32(params_addr + 8)  = c_l1_addr + split * block_1d_size * F_SIZE;
            mmio32(params_addr + 12) = r_l1_addr;
            mmio32(params_addr + 16) = block_1d_size;
            mmio32(params_addr + 20) = 0;
            mmio32(params_addr + 24) = leftover;

#ifdef DBG_PRINT
            printf("[DBG] Cholesky loop iteration %0u: Starting GEMM_NT_UPDATE_CL_KERNEL with parameter stack: 0x%08x, 0x%08x, 0x%08x, 0x%08x, 0x%08x, 0x%08x\n",
               k, t_l1_addr, c_l1_addr + split * block_1d_size * F_SIZE, r_l1_addr, block_1d_size, 0, leftover);
#endif /*DBG_PRINT*/

            cluster_task(params_addr);

            idma_mm_conf_default_dir(DMA_OUT);
            idma_mm_set_addr_len_dir(DMA_OUT, a_l1_addr+a_l1_offset, t_l1_addr, leftover_size*F_SIZE);
            idma_mm_set_2d_params_dir(DMA_OUT, 0, 0, 1);
            idma_mm_set_3d_params_dir(DMA_OUT, 0, 0, 1);
            (void)idma_mm_start_transfer_dir(DMA_OUT, 0);
            eu_wait_events_wfe(EU_IDMA_O2A_DONE_MASK);
         }
      }

#ifdef DBG_PRINT
      printf("[DBG] Cholesky loop iteration %0u: Finished SYRK_LOWER_UPDATE_CL_KERNEL/GEMM_NT_UPDATE_CL_KERNEL\n", k);
#endif /*DBG_PRINT*/

      fsync_mm_global();
      eu_wait_events_wfe(EU_FSYNC_DONE_MASK);
   }

   // Move block of the output matrix back to L2
   idma_mm_conf_default_dir(DMA_OUT);
   idma_mm_set_addr_len_dir(DMA_OUT, l_block_dst_addr, a_l1_addr, block_1d_size*F_SIZE);
   idma_mm_set_2d_params_dir(DMA_OUT, M_SIZE*F_SIZE, block_1d_size*F_SIZE, block_1d_size);
   idma_mm_set_3d_params_dir(DMA_OUT, 0, 0, 1);
   (void)idma_mm_start_transfer_dir(DMA_OUT, 0);
   eu_wait_events_wfe(EU_IDMA_O2A_DONE_MASK);

   fsync_mm_global();
   eu_wait_events_wfe(EU_FSYNC_DONE_MASK);

#ifdef DBG_PRINT
   if(hartid == 0){
      printf("[DBG] Output matrix (L) in L2:\n");
      for(int i = 0; i < M_SIZE; i++){
         printf("      ");
         for(int j = 0; j < M_SIZE; j++){
            uint32_t idx = i*M_SIZE + j;
            float    l_f = l_float[idx];
            uint32_t l_h;
            memcpy(&l_h, &l_f, 4);
            printf("0x%08x ", l_h);
         }
         printf("\n");
      }
   }
#endif /*DBG_PRINT*/

   return 0;
}
