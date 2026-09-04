/*
 * Copyright (C) 2026 ETH Zurich, University of Bologna and Fondazione Chips-IT
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
 *
 * HCI Arbitration RedMulE Benchmark: control-core orchestrator
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "magia_stats.h"
#include "cluster_utils.h"
#include "redmule_mm_utils.h"
#include "hci_arb_redmule_bench_pulp_task_bin.h"

#include "x_input.h"
#include "w_input.h"

#define M_SIZE (16)
#define N_SIZE (16)
#define K_SIZE (16)

#define X_BASE (L1_BASE + 0x00012048)
#define W_BASE (L1_BASE + 0x00016048)
#define Y_BASE (L1_BASE + 0x0001A048)

#define HCI_ARB_NARROW75_NUM (1)
#define HCI_ARB_NARROW75_DEN (4)
#define HCI_ARB_WIDE75_NUM   (3)
#define HCI_ARB_WIDE75_DEN   (4)

static uint32_t run_redmule_once(void) {
    for (int i = 0; i < M_SIZE*K_SIZE; i++)
        mmio16(Y_BASE + 2*i) = 0;

    hwpe_cg_enable();
    hwpe_soft_clear();

    int offload_id_tmp;
    while ((offload_id_tmp = hwpe_acquire_job()) < 0)
        ;

    redmule_cfg((unsigned int)X_BASE, (unsigned int)W_BASE, (unsigned int)Y_BASE,
                M_SIZE, N_SIZE, K_SIZE, (uint8_t)gemm_ops, (uint8_t)Float16, (uint8_t)Float16);

    uint32_t start = perf_csr_cycle();
    hwpe_trigger_job();
    hwpe_wait_for_completion();
    uint32_t cycles = perf_csr_cycle() - start;

    hwpe_cg_disable();

    return cycles;
}

static uint32_t bench_arb(uint32_t arb_ctrl_value) {
    mmio32(HCI_ARB_CTRL) = arb_ctrl_value;

    cluster_arm_done_event();
    cluster_dispatch_task(HCI_ARB_REDMULE_BENCH_TASK);

    uint32_t redmule_cycles = run_redmule_once();

    cluster_wait_done_eu();

    return redmule_cycles;
}

int main(void) {
    for (int i = 0; i < M_SIZE*N_SIZE; i++)
        mmio16(X_BASE + 2*i) = x_inp[i];
    for (int i = 0; i < N_SIZE*K_SIZE; i++)
        mmio16(W_BASE + 2*i) = w_inp[i];

    ccount_en();

    cluster_boot(PULP_BINARY_START);

    uint32_t cycles_narrow75 = bench_arb(HCI_ARB_PRIO_NUM(HCI_ARB_NARROW75_NUM) | HCI_ARB_PRIO_DEN(HCI_ARB_NARROW75_DEN));
    uint32_t cycles_wide75   = bench_arb(HCI_ARB_PRIO_NUM(HCI_ARB_WIDE75_NUM)   | HCI_ARB_PRIO_DEN(HCI_ARB_WIDE75_DEN));

    printf("RedMulE cycles, narrow 75%% / wide 25%% HCI arbitration: %u\n", (unsigned)cycles_narrow75);
    printf("RedMulE cycles, narrow 25%% / wide 75%% HCI arbitration: %u\n", (unsigned)cycles_wide75);

    return 0;
}
