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
 * Author: Luca Balboni, Fondazione Chips-IT
 *
 * HCI arbiter control registers: register file checks and QoS checks under L1 contention
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "magia_stats.h"
#include "redmule_mm_utils.h"
#include "idma_mm_utils.h"

// Wide-vs-narrow arbiter, then the wide tree nodes up to RedMulE
#define N_ARB (1 + HCI_ARB_TREE_REDMULE + 1)

#define GEMM_DIM     (32)
#define MAT_BYTES    (GEMM_DIM * GEMM_DIM * 2)  // FP16
#define X_BUF        (L1_BASE + 0x00020000)
#define W_BUF        (X_BUF + MAT_BYTES)
#define Y_BUF        (W_BUF + MAT_BYTES)
#define CORE_BUF     (Y_BUF + MAT_BYTES)
#define BURST_WORDS  (32)  // One load per L1 bank
#define CORE_BURSTS  (6)  // Core alone lasts about as long as RedMulE alone
#define DMA_BYTES    (0x4000)
#define DMA_L1_DST   (L1_BASE + 0x00030000)
#define DMA_L2_SRC   (L2_BASE + 0x00042000)  // Clear of instrram and of the dataram header

// Agents racing for the L1 banks
enum { AG_CORE, AG_REDMULE, AG_DMA, AG_NUM };
#define AG(a) (1u << (a))

static const char *const ag_name[AG_NUM] = {"core", "redmule", "dma"};

static uint32_t arb_addr(int a) {
  return a == 0 ? HCI_ARB_CTRL : HCI_ARB_CTRL_TREE(a - 1);
}

// Distinct per arbiter, so a write landing on the wrong register shows up
static uint32_t arb_value(int a) {
  return HCI_ARB_PRIO_DEN(4 + a) | HCI_ARB_PRIO_NUM(1 + a);
}

static void expect_reg(int a, uint32_t expected, uint32_t *errors) {
  uint32_t got = mmio32(arb_addr(a));
  if (got != expected) {
    printf("  ARB_CTRL[%d]: got 0x%08x expected 0x%08x\n", a, (unsigned int)got,
           (unsigned int)expected);
    (*errors)++;
  }
}

static void check_registers(uint32_t *errors) {
  for (int a = 0; a < N_ARB; a++)
    expect_reg(a, HCI_ARB_CTRL_DEFAULT, errors);
  for (int a = 0; a < N_ARB; a++)
    mmio32(arb_addr(a)) = arb_value(a);
  for (int a = 0; a < N_ARB; a++)
    expect_reg(a, arb_value(a), errors);
  for (int a = 0; a < N_ARB; a++)
    mmio32(arb_addr(a)) = HCI_ARB_CTRL_DEFAULT;
}

// Back-to-back loads: the densest narrow traffic one core issues
static void core_burst(void) {
  volatile uint32_t *p = (volatile uint32_t *)CORE_BUF;
#pragma GCC unroll 32
  for (int i = 0; i < BURST_WORDS; i++)
    (void)p[i];
}

static void redmule_prepare(void) {
  hwpe_cg_enable();
  hwpe_soft_clear();
  while (hwpe_acquire_job() < 0)
    ;
  redmule_cfg(X_BUF, W_BUF, Y_BUF, GEMM_DIM, GEMM_DIM, GEMM_DIM, gemm_ops, Float16, Float16);
}

static void dma_prepare(void) {
  idma_mm_conf_default_dir(IDMA_DIR_L2_TO_L1);
  idma_mm_set_addr_len_dir(IDMA_DIR_L2_TO_L1, DMA_L1_DST, DMA_L2_SRC, DMA_BYTES);
  idma_mm_set_2d_params_dir(IDMA_DIR_L2_TO_L1, 0, 0, 1);
  idma_mm_set_3d_params_dir(IDMA_DIR_L2_TO_L1, 0, 0, 1);
}

// Starts the agents of mask together; cycles[a] is when agent a finished, within a core burst
static void race(uint32_t mask, uint32_t cycles[AG_NUM]) {
  uint32_t bursts = 0, dma_id = 0, running = mask;

  if (mask & AG(AG_REDMULE))
    redmule_prepare();
  if (mask & AG(AG_DMA))
    dma_prepare();

  uint32_t t0 = perf_csr_cycle();
  if (mask & AG(AG_REDMULE))
    hwpe_trigger_job();
  if (mask & AG(AG_DMA))
    dma_id = idma_mm_start_transfer_dir(IDMA_DIR_L2_TO_L1, 0);

  while (running) {
    uint32_t done = 0;
    if (running & AG(AG_CORE)) {
      core_burst();
      if (++bursts == CORE_BURSTS)
        done |= AG(AG_CORE);
    }
    if ((running & AG(AG_REDMULE)) && hwpe_get_status() == 0)
      done |= AG(AG_REDMULE);
    if ((running & AG(AG_DMA)) && idma_mm_get_done_id_dir(IDMA_DIR_L2_TO_L1, 0) == dma_id)
      done |= AG(AG_DMA);

    uint32_t now = perf_csr_cycle() - t0;
    for (int a = 0; a < AG_NUM; a++)
      if (done & AG(a))
        cycles[a] = now;
    running &= ~done;
  }

  if (mask & AG(AG_REDMULE))
    hwpe_cg_disable();
}

// Races high against low on the arbiter at addr: each must finish sooner when it has priority
static void qos_check(uint32_t addr, int high, int low, uint32_t *errors) {
  uint32_t high_first[AG_NUM], low_first[AG_NUM];

  mmio32(addr) = HCI_ARB_PRIO_DEN(2);  // Numerator 0: high always wins
  race(AG(high) | AG(low), high_first);
  mmio32(addr) = HCI_ARB_INVERT_PRIO | HCI_ARB_PRIO_DEN(2);  // Inverted: low always wins
  race(AG(high) | AG(low), low_first);
  mmio32(addr) = HCI_ARB_CTRL_DEFAULT;

  printf("%s first: %s %u, %s %u cycles\n", ag_name[high], ag_name[high],
         (unsigned int)high_first[high], ag_name[low], (unsigned int)high_first[low]);
  printf("%s first: %s %u, %s %u cycles\n", ag_name[low], ag_name[high],
         (unsigned int)low_first[high], ag_name[low], (unsigned int)low_first[low]);

  if (high_first[high] >= low_first[high] || low_first[low] >= high_first[low]) {
    printf("  ARB 0x%x does not steer %s vs %s\n", (unsigned int)addr, ag_name[high], ag_name[low]);
    (*errors)++;
  }
}

int main(void) {
  uint32_t errors = 0;

  check_registers(&errors);

  // FP16 zeros: RedMulE timing does not depend on the values and nothing overflows
  for (uint32_t i = 0; i < 3 * MAT_BYTES / 4 + BURST_WORDS; i++)
    mmio32(X_BUF + 4 * i) = 0;

  ccount_en();

  // Warms the instruction cache, else the first measured race pays its misses
  uint32_t warmup[AG_NUM];
  race(AG(AG_CORE) | AG(AG_REDMULE) | AG(AG_DMA), warmup);

  qos_check(HCI_ARB_CTRL, AG_REDMULE, AG_CORE, &errors);
  qos_check(HCI_ARB_CTRL_TREE(HCI_ARB_TREE_REDMULE), AG_DMA, AG_REDMULE, &errors);

  printf(errors ? "Test FAILED\n" : "Test PASSED\n");
  return errors;
}
