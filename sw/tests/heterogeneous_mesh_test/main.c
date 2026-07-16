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
 */

/*
 * heterogeneous_mesh_test - main core (CV32) binary.
 *
 * Basic regression test: every tile runs one smoke check per accelerator it
 * carries (see TILE_CFGS) and prints a single OK/FAIL line.
 *
 *   RedMulE  one 1x64x64 FP16 GEMM on iDMA-loaded data, checked vs z_output.h
 *   Spatz    Z = X + Y over 16 FP16 elements, checked by the CV32
 *   Cluster  each PULP core sums its own slice into a per-tile L2 slot
 *
 * Catches "a tile flavour stopped working", nothing more.
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "magia_utils.h"          /* get_hartid() -> flat tile index */
#include "cluster_utils.h"
#include "redmule_mm_utils.h"
#include "idma_mm_utils.h"
#include "event_unit_utils.h"
#include "magia_spatz_utils.h"

#include "heterogeneous_mesh_test_pulp_task_bin.h" /* PULP_BINARY_START, HETEROGENEOUS_CLUSTER_TASK */
#include "heterogeneous_mesh_test_task_bin.h"      /* SPATZ_BINARY_START, VECSUM16_TASK */

/* RedMulE stimulus (shared read-only rodata in L2). */
#include "x_input.h"
#include "w_input.h"
#include "y_input.h"
#include "z_output.h"

/* Tile contents: 1:1 copy of HETERO_TILE_CFGS in hw/mesh/magia_pkg.sv. */
#define RM (1u << 0)  /* EnRedMule */
#define SP (1u << 1)  /* EnSpatzCC */
#define CL (1u << 2)  /* EnCluster */

static const uint8_t TILE_CFGS[16] = {
    RM|SP|CL, RM|SP|CL, RM|SP|CL, RM|SP|CL,  /*  0.. 3  MagiaTileDefaultCfg */
    RM,       RM,       RM,       RM,        /*  4.. 7  MagiaTileRedMuleCfg */
    SP,       SP,       SP,       SP,        /*  8..11  MagiaTileSpatzCfg   */
    CL,       CL,       CL,       CL,        /* 12..15  MagiaTileClusterCfg */
};

/* L1_BASE is the GLOBAL address of tile 0's L1. Every tile must add its own
   L1_TILE_OFFSET slice, or its accesses leave the tile and land in tile 0's L1
   over the NoC -- which still "passes" whenever all tiles write equal values. */
static inline uint32_t l1(uint32_t off) {
    return L1_BASE + get_hartid() * L1_TILE_OFFSET + off;
}

/* Spatz vecsum16: Z = X + Y over one 256-bit FP16 register. */
#define SP_VLEN      16
#define SP_X         l1(0x00000000)
#define SP_Y         l1(0x00001000)
#define SP_Z         l1(0x00002000)
#define SP_PARAMS    l1(0x00003000)
#define FP16_ONE     (0x3C00u)   /* 1.0 */
#define FP16_TWO     (0x4000u)   /* 2.0 */
#define FP16_THREE   (0x4200u)   /* 3.0 */

/* RedMulE GEMM (goldens come from z_output.h). */
#define RM_X         l1(0x00012048)
#define RM_W         l1(0x00016048)
#define RM_Y         l1(0x0001A048)
#define RM_M_SIZE    (1)
#define RM_N_SIZE    (64)
#define RM_K_SIZE    (64)
#define RM_DIFF_TH   (0x0011)

/* PULP cluster per-core result (must match heterogeneous_cluster_task.c). */
#define CL_RESULT_BASE   (L2_BASE + 0x00080000)
#define CL_RESULT_STRIDE (0x00000100)
#define CL_CHUNK         8u

typedef struct {
    uint32_t x_addr;
    uint32_t y_addr;
    uint32_t z_addr;
    uint32_t n_size;
} vecsum_params_t;

/* iDMA L2->L1: issue, WFE on A2O_DONE, re-poll until idle. */
static void idma_load_l2_to_l1(uint32_t l2_src, uint32_t l1_dst, uint32_t size_bytes) {
    eu_clear_events(0xFFFFFFFF);
    eu_enable_events(EU_IDMA_A2O_DONE_MASK);
    (void)idma_L2ToL1(l2_src, l1_dst, (unsigned short)size_bytes);
    do {
        eu_idma_wait_a2o_completion(EU_WAIT_MODE_WFE);
    } while (idma_mm_is_busy_dir(/*is_l1_to_l2=*/0, /*stream_id=*/0));
}

/* RedMulE: iDMA-load X/W/Y into this tile's L1, run one GEMM, check vs golden. */
static unsigned int run_redmule(void) {
    idma_load_l2_to_l1((uint32_t)x_inp, RM_X, RM_M_SIZE * RM_N_SIZE * 2);
    idma_load_l2_to_l1((uint32_t)w_inp, RM_W, RM_N_SIZE * RM_K_SIZE * 2);
    idma_load_l2_to_l1((uint32_t)y_inp, RM_Y, RM_M_SIZE * RM_K_SIZE * 2);

    hwpe_cg_enable();
    hwpe_soft_clear();
    while (hwpe_acquire_job() < 0)
        ;

    redmule_cfg(RM_X, RM_W, RM_Y, RM_M_SIZE, RM_N_SIZE, RM_K_SIZE,
                (uint8_t)gemm_ops, (uint8_t)Float16, (uint8_t)Float16);

    eu_redmule_init();
    hwpe_trigger_job();
    do {
        eu_redmule_wait_completion(EU_WAIT_MODE_WFE);
    } while (hwpe_get_status() != 0);
    asm volatile("fence" ::: "memory");
    hwpe_cg_disable();

    unsigned int errors = 0;
    for (int i = 0; i < RM_M_SIZE * RM_K_SIZE; i++) {
        uint16_t computed = mmio16(RM_Y + 2 * i);
        uint16_t expected = z_oup[i];
        uint16_t diff = (computed > expected) ? (computed - expected) : (expected - computed);
        if (diff > RM_DIFF_TH) errors++;
    }
    return errors;
}

/* Spatz: Z = X + Y over FP16 vectors via vecsum16, checked on the CV32 side. */
static unsigned int run_spatz(void) {
    volatile uint16_t *x = (volatile uint16_t *)SP_X;
    volatile uint16_t *y = (volatile uint16_t *)SP_Y;
    volatile uint16_t *z = (volatile uint16_t *)SP_Z;

    /* z is pre-cleared so a Spatz that never wrote cannot pass on stale data. */
    for (int i = 0; i < SP_VLEN; i++) { x[i] = FP16_ONE; y[i] = FP16_TWO; z[i] = 0; }

    volatile vecsum_params_t *p = (volatile vecsum_params_t *)SP_PARAMS;
    p->x_addr = SP_X; p->y_addr = SP_Y; p->z_addr = SP_Z; p->n_size = SP_VLEN;

    eu_init();
    eu_enable_events(EU_SPATZ_DONE_MASK);
    spatz_init(SPATZ_BINARY_START);
    spatz_run_task_with_params(VECSUM16_TASK, SP_PARAMS);
    eu_wait_spatz_wfe(EU_SPATZ_DONE_MASK);

    unsigned int errors = 0;
    if (spatz_get_exit_code() != 0) errors++;
    for (int i = 0; i < SP_VLEN; i++)
        if (z[i] != FP16_THREE) { errors++; break; }

    spatz_clk_dis();
    return errors;
}

/* PULP cluster: boot, dispatch the task to this tile's cores, verify. */
static unsigned int run_cluster(void) {
    eu_init();
    cluster_boot(PULP_BINARY_START);
    cluster_arm_done_event();
    cluster_dispatch_task(HETEROGENEOUS_CLUSTER_TASK, (1u << PULP_CORE_COUNT) - 1u);
    cluster_wait_done_eu();

    /* Each core knows its own tile, so it wrote to this tile's L2 slot. */
    uint32_t result_base = CL_RESULT_BASE + get_hartid() * CL_RESULT_STRIDE;
    unsigned int errors = 0;
    for (uint32_t c = 0; c < PULP_CORE_COUNT; c++) {
        uint32_t got      = mmio32(result_base + 4 * c);
        uint32_t expected = CL_CHUNK * c + (CL_CHUNK * (CL_CHUNK - 1u)) / 2u;
        if (got != expected) errors++;
    }
    return errors;
}

int main(void) {
    uint32_t idx = get_hartid();   /* ctrl core: mhartid == flat tile index */
    uint8_t  cfg = TILE_CFGS[idx];
    unsigned int errors = 0;

    if (cfg & RM) errors += run_redmule();
    if (cfg & SP) errors += run_spatz();
    if (cfg & CL) errors += run_cluster();

    printf("[Tile %u] %s\n", (unsigned)idx, errors ? "FAIL" : "OK");
    return (int)errors;
}
