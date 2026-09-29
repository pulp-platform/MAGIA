/*
 * Copyright (C) 2026 Fondazione Chips-IT
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
 * Authors: Luca Balboni <luca.balboni@chips.it>
 * 
 *  Test for the heterogeneous mesh
 */


#include <stdint.h>
#include "magia_tile_utils.h"
#include "magia_utils.h"
#include "cluster_utils.h"
#include "redmule_mm_utils.h"
#include "idma_mm_utils.h"
#include "event_unit_utils.h"
#include "magia_spatz_utils.h"

#include "hetero_mesh_test_pulp_task_bin.h"
#include "hetero_mesh_test_task_bin.h"

#include "x_input.h"
#include "w_input.h"
#include "y_input.h"
#include "z_output.h"

/* L1_BASE is tile 0's L1 in the global map, add our own slice */
static inline uint32_t l1(uint32_t off) {
    return L1_BASE + get_hartid() * L1_TILE_OFFSET + off;
}

#define SP_VLEN       16
#define SP_X          l1(0x00000000)
#define SP_Y          l1(0x00001000)
#define SP_Z          l1(0x00002000)
#define SP_PARAMS     l1(0x00003000)

#define RM_X          l1(0x00012048)
#define RM_W          l1(0x00016048)
#define RM_Y          l1(0x0001A048)   /* Z overwrites Y */
#define RM_M_SIZE     (1)
#define RM_N_SIZE     (64)
#define RM_K_SIZE     (64)
#define RM_DIFF_TH    (0x0011)

/* one uint32 per core, one block per tile: see pulp_task/ */
#define CL_RESULT_BASE   (L2_BASE + 0x00080000)
#define CL_RESULT_STRIDE (0x00000100)
#define CL_CHUNK         8u
#define CL_GOLDEN(c)     ((CL_CHUNK) * (c) + ((CL_CHUNK) * ((CL_CHUNK) - 1u)) / 2u)

#define FP16_ONE      (0x3C00u)
#define FP16_TWO      (0x4000u)
#define FP16_THREE    (0x4200u)

typedef struct {
    uint32_t x_addr;
    uint32_t y_addr;
    uint32_t z_addr;
    uint32_t n_size;
} vecsum_params_t;

static void idma_load(uint32_t l2_src, uint32_t l1_dst, uint32_t size) {
    eu_clear_events(0xFFFFFFFF);
    eu_enable_events(EU_IDMA_A2O_DONE_MASK);
    (void)idma_L2ToL1(l2_src, l1_dst, (unsigned short)size);
    do {
        eu_idma_wait_a2o_completion(EU_WAIT_MODE_WFE);
    } while (idma_mm_is_busy_dir(0, 0));
}

/* 1x64x64 FP16 GEMM on iDMA-loaded data */
static unsigned int run_redmule(void) {
    unsigned int errors = 0;

    idma_load((uint32_t)x_inp, RM_X, RM_M_SIZE * RM_N_SIZE * 2);
    idma_load((uint32_t)w_inp, RM_W, RM_N_SIZE * RM_K_SIZE * 2);
    idma_load((uint32_t)y_inp, RM_Y, RM_M_SIZE * RM_K_SIZE * 2);

    hwpe_cg_enable();
    hwpe_soft_clear();
    while (hwpe_acquire_job() < 0)
        ;

    redmule_cfg(RM_X, RM_W, RM_Y, RM_M_SIZE, RM_N_SIZE, RM_K_SIZE,
                (uint8_t)gemm_ops, (uint8_t)Float16, (uint8_t)Float16);

    eu_redmule_init();
    hwpe_trigger_job();
    eu_redmule_wait_completion(EU_WAIT_MODE_WFE);
    hwpe_cg_disable();

    for (int i = 0; i < RM_M_SIZE * RM_K_SIZE; i++) {
        uint16_t got = mmio16(RM_Y + 2 * i);
        uint16_t exp = z_oup[i];
        uint16_t diff = (got > exp) ? (got - exp) : (exp - got);
        if (diff > RM_DIFF_TH) errors++;
    }
    return errors;
}

/* Z = X + Y, 16 FP16 elements */
static unsigned int run_spatz(void) {
    volatile uint16_t *x = (volatile uint16_t *)SP_X;
    volatile uint16_t *y = (volatile uint16_t *)SP_Y;
    volatile uint16_t *z = (volatile uint16_t *)SP_Z;
    unsigned int errors = 0;

    for (int i = 0; i < SP_VLEN; i++) {
        x[i] = FP16_ONE;
        y[i] = FP16_TWO;
        z[i] = 0;
    }

    volatile vecsum_params_t *params = (volatile vecsum_params_t *)SP_PARAMS;
    params->x_addr = SP_X;
    params->y_addr = SP_Y;
    params->z_addr = SP_Z;
    params->n_size = SP_VLEN;

    eu_init();
    eu_enable_events(EU_SPATZ_DONE_MASK);
    spatz_init(SPATZ_BINARY_START);
    spatz_run_task_with_params(VECSUM16_TASK, SP_PARAMS);
    eu_wait_spatz_wfe(EU_SPATZ_DONE_MASK);

    if (spatz_get_exit_code() != 0) errors++;
    for (int i = 0; i < SP_VLEN; i++) {
        if (z[i] != FP16_THREE) {
            errors++;
            break;
        }
    }

    spatz_clk_dis();
    return errors;
}

/* every PULP core sums its own slice into L2 */
static unsigned int run_cluster(void) {
    unsigned int errors = 0;

    eu_init();
    cluster_boot(PULP_BINARY_START);
    eu_cluster_done_init();
    cluster_dispatch_task(HETERO_CLUSTER_TASK, (1u << PULP_CORE_COUNT) - 1u);
    eu_cluster_done_wait(EU_WAIT_MODE_WFE);

    uint32_t base = CL_RESULT_BASE + get_hartid() * CL_RESULT_STRIDE;
    for (uint32_t c = 0; c < PULP_CORE_COUNT; c++) {
        if (mmio32(base + 4 * c) != CL_GOLDEN(c)) errors++;
    }
    return errors;
}

int main(void) {
    uint32_t tile = get_hartid();
    unsigned int errors = 0;

    switch (tile / 4) {
    case 0:
        errors += run_redmule();
        errors += run_spatz();
        errors += run_cluster();
        break;
    case 1:
        errors += run_redmule();
        break;
    case 2:
        errors += run_spatz();
        break;
    default:
        errors += run_cluster();
        break;
    }

    printf("[Tile %u] %s (%u)\n", (unsigned)tile, errors ? "FAIL" : "OK", errors);
    return (int)errors;
}
