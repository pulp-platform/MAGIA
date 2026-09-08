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
 * MAGIA Cholesky Test Using PULP Cluster - Cluster Task
 */

#include "magia_tile_utils.h"
#include "magia_utils.h"
#include "cluster_utils.h"

#define DBG_PRINT

#define POTRF_LOWER_CL_KERNEL                 (0)
#define TRSM_RIGHT_LOWER_TRANS_ROWS_CL_KERNEL (1)
#define GEMM_NT_UPDATE_CL_KERNEL              (2)
#define SYRK_LOWER_UPDATE_CL_KERNEL           (3)

static inline float rv_sqrtf(float f){
    float res;
    asm volatile("fsqrt.s %0, %1\n\t" : "=f"(res) : "f"(f));
    return res;
}

static void potrf_lower(uint32_t a_addr, unsigned int m_size, uint32_t l1_buff_addr){
    uint32_t core_id = cluster_core_id();

    volatile float* a_mat = (float*)a_addr;
    volatile float* buff  = (float*)l1_buff_addr;

    for(int j = 0; j < m_size; j++){
        // Each core computes the partial sum of diagonal element
        float local_sum = 0.0f;
        for(int p = core_id; p < j; p += NUM_CORES){
            local_sum += a_mat[j*m_size + p] * a_mat[j*m_size + p];
        }
        buff[core_id] = local_sum;
        pi_cl_team_barrier();

        // Core 0 reduces the partial sums and performs the squre root
        // to obtain the final result
        if(core_id == 0){
            float d = a_mat[j*m_size + j];
            for(int i = 0; i < NUM_CORES; i++){
                d -= buff[i];
            }
            a_mat[j*m_size + j] = rv_sqrtf(d);
        }
        pi_cl_team_barrier();

        // Each core computes elements below the diagonal independently
        for(int i = j + 1 + core_id; i < m_size; i += NUM_CORES){
            float s = a_mat[i*m_size + j];
            for(int p = 0; p < j; p++){
                s -= a_mat[i*m_size + p] * a_mat[j*m_size + p];
            }
            a_mat[i*m_size + j] = s / a_mat[j*m_size + j];
        }
        pi_cl_team_barrier();
    }
}

static void trsm_right_lower_trans_rows(uint32_t a_addr, uint32_t l_addr, unsigned int m_size, unsigned int row_begin, unsigned int row_end){
    uint32_t core_id = cluster_core_id();

    volatile float* a_mat = (float*)a_addr;
    volatile float* l_mat = (float*)l_addr;

    for(int r = row_begin + core_id; r < row_end; r += NUM_CORES){
        for(int c = 0; c < m_size; c++){
            float s = a_mat[r*m_size + c];
            for(int p = 0; p < c; p++){
                s -= a_mat[r*m_size + p] * l_mat[c*m_size + p]; 
            }
            a_mat[r*m_size + c] = s / l_mat[c*m_size + c];
        }
    }
    pi_cl_team_barrier();
}

static void gemm_nt_update_rows(uint32_t c_addr, uint32_t l_addr, uint32_t r_addr, unsigned int m_size, unsigned int row_begin, unsigned int row_end){
    uint32_t core_id = cluster_core_id();

    volatile float* c_mat = (float*)c_addr;
    volatile float* l_mat = (float*)l_addr;
    volatile float* r_mat = (float*)r_addr;

    for(int i = row_begin + core_id; i < row_end; i += NUM_CORES){
        for(int j = 0; j < m_size; j++){
            float local_sum = 0.0f;
            for(int p = 0; p < m_size; p++){
                local_sum += l_mat[i*m_size + p] * r_mat[j*m_size + p];
            }
            c_mat[i*m_size + j] -= local_sum;
        }
    }
    pi_cl_team_barrier();
}

static void syrk_lower_update(uint32_t a_addr, uint32_t l_addr, unsigned int m_size){
    uint32_t core_id = cluster_core_id();

    volatile float* a_mat = (float*)a_addr;
    volatile float* l_mat = (float*)l_addr;

    for(int i = core_id; i < m_size; i += NUM_CORES){
        for(int j = 0; j <= i; j++){
            float local_sum = 0.0f;
            for(int p = 0; p < m_size; p++){
                local_sum += l_mat[i*m_size + p] * l_mat[j*m_size + p];
            }
            a_mat[i*m_size + j] -= local_sum;
        }
    }
    pi_cl_team_barrier();
}

static void forked_task(void *data){
    enable_fpu();

    uint32_t tile_id = cluster_tile_id();
    uint32_t core_id = cluster_core_id();

    uint32_t params_addr = (uint32_t)data;

    uint32_t kernel = mmio32(params_addr);

    if(kernel == POTRF_LOWER_CL_KERNEL){
        uint32_t a_addr       = mmio32(params_addr + 4);
        uint32_t m_size       = mmio32(params_addr + 8);
        uint32_t l1_buff_addr = mmio32(params_addr + 12);
        
#ifdef DBG_PRINT
        if(core_id == 0){
            printf("[DBG] Detected forked cluster kernel potrf_lower(0x%08x, %0u, 0x%08x)\n", a_addr, m_size, l1_buff_addr);
        }
#endif /*DBG_PRINT*/

        potrf_lower(a_addr, m_size, l1_buff_addr);
    }else if(kernel == TRSM_RIGHT_LOWER_TRANS_ROWS_CL_KERNEL){
        uint32_t a_addr    = mmio32(params_addr + 4);
        uint32_t l_addr    = mmio32(params_addr + 8);
        uint32_t m_size    = mmio32(params_addr + 12);
        uint32_t row_begin = mmio32(params_addr + 16);
        uint32_t row_end   = mmio32(params_addr + 20);
        
#ifdef DBG_PRINT
        if(core_id == 0){
            printf("[DBG] Detected forked cluster kernel trsm_right_lower_trans_rows(0x%08x, 0x%08x, %0u, %0u, %0u)\n", a_addr, l_addr, m_size, row_begin, row_end);
        }
#endif /*DBG_PRINT*/

        trsm_right_lower_trans_rows(a_addr, l_addr, m_size, row_begin, row_end);
    }else if(kernel == GEMM_NT_UPDATE_CL_KERNEL){
        uint32_t c_addr    = mmio32(params_addr + 4);
        uint32_t l_addr    = mmio32(params_addr + 8);
        uint32_t r_addr    = mmio32(params_addr + 12);
        uint32_t m_size    = mmio32(params_addr + 16);
        uint32_t row_begin = mmio32(params_addr + 20);
        uint32_t row_end   = mmio32(params_addr + 24);
        
#ifdef DBG_PRINT
        if(core_id == 0){
            printf("[DBG] Detected forked cluster kernel gemm_nt_update_rows(0x%08x, 0x%08x, 0x%08x, %0u, %0u, %0u)\n", c_addr, l_addr, r_addr, m_size, row_begin, row_end);
        }
#endif /*DBG_PRINT*/

        gemm_nt_update_rows(c_addr, l_addr, r_addr, m_size, row_begin, row_end);
    }else if(kernel == SYRK_LOWER_UPDATE_CL_KERNEL){
        uint32_t a_addr    = mmio32(params_addr + 4);
        uint32_t l_addr    = mmio32(params_addr + 8);
        uint32_t m_size    = mmio32(params_addr + 12);
        
#ifdef DBG_PRINT
        if(core_id == 0){
            printf("[DBG] Detected forked cluster kernel syrk_lower_update(0x%08x, 0x%08x, %0u)\n", a_addr, l_addr, m_size);
        }
#endif /*DBG_PRINT*/

        syrk_lower_update(a_addr, l_addr, m_size);
    }else{
        if(core_id == 0) printf("[ERROR] Unrecognized cluster kernel\n");    
    }
}

void cholesky_pulp_task(void *data){
    pi_cl_team_fork(NUM_CORES, forked_task, data);
}
