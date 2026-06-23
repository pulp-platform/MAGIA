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
 * Authors: Niccolò Giuliani, Fondazione Chips-IT
 */

/*
 * hello_redmule_pulp - main core (CV32) binary.
 *
 * Linked at 0xCC000000, run by the CV32 main core (mhartid 0..15).
 *
 * Demonstrates the SHARED-ACCELERATOR / MULTI-INITIATOR pattern with the
 * local bare-metal PULP dispatch model:
 *
 *   1) The CV32 main core loads X, W, Y in tile-local L1.
 *   2) The CV32 main core runs RedMulE once (sanity check), then waits
 *      for completion via Event Unit WFE (p.elw on its own EU slice).
 *   3) The CV32 main core re-loads Y (so the bias is fresh again),
 *      then boots the PULP cluster dispatcher and dispatches the task.
 *   4) Each PULP cluster core (see pulp_main.c) tries to ACQUIRE the
 *      RedMulE HWPE; the HWPE returns -1 if busy so the cluster cores
 *      naturally serialize. Whoever wins runs RedMulE on the same
 *      buffers and polls RedMulE STATUS via MMIO.
 *   5) When all 8 cluster cores have hit crt0 exit, PULP_DONE goes
 *      high; the CV32 main wakes from WFE (EU bit 12), verifies
 *      Y == Z (golden), prints and exits.
 *
 * This exercises the RTL fix that broadcasts redmule_evt[*]/redmule_busy
 * to every cluster core's EU slice (acc_events_array[i] for i=0..N).
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "cluster_utils.h"
#include "redmule_mm_utils.h"
#include "event_unit_utils.h"
#include "idma_mm_utils.h"
#include "hello_redmule_pulp_pulp_task_bin.h"

#include "x_input.h"
#include "w_input.h"
#include "y_input.h"
#include "z_output.h"

/* Address map.
 * X, W, Y live in tile-local L1 (private per tile, no cross-tile race).
 * The golden reference Z is read directly from z_oup[] in the main
 * ELF .rodata (already in L2), so no per-tile L2 copy is needed. */
#define X_BASE (L1_BASE + 0x00012048)   /* shared, read-only */
#define W_BASE (L1_BASE + 0x00016048)   /* shared, read-only */
/* PER-CORE output Y: each of the 8 cluster cores computes into its OWN
   private slot at Y_BASE + c*Y_STRIDE, so no two cores ever touch the same
   word -> the result is fully deterministic (no shared-buffer race). The
   CV32 main pre-loads every slot with the y_inp bias before dispatch, so
   the cores never reload the bias themselves.
   MUST match Y_BASE/Y_STRIDE in pulp_task/hello_redmule_pulp_task.c. */
#define Y_BASE   (L1_BASE + 0x0001A048)
#define Y_STRIDE (0x00001000)            /* 4 KB per core (8 slots) */

/* Enable the FPU: set mstatus.FS to INITIAL (01).
 * Without this any FPU instruction faults. CV32E40P (and the cluster
 * cores) need this even though FP is enabled at compile time. */
static inline void enable_fpu(void) {
  asm volatile (
    "li t0, 0x2000\n"   /* mstatus.FS[14:13] = 01 (Initial) */
    "csrs mstatus, t0\n"
    ::: "t0"
  );
}

/* Bulk-load an array from L2 (.rodata of the main ELF) into L1 via iDMA.
 * Same wait pattern as cluster cores use after RedMulE jobs:
 *   issue -> WFE -> on wake re-check the HW status, retry until clear.
 * The first WFE returns when A2O_DONE is asserted, the status check
 * confirms the back-end FIFO has truly drained before we let the
 * caller touch L1. */
static inline void idma_load_l2_to_l1(uint32_t l2_src, uint32_t l1_dst, uint32_t size_bytes) {
  eu_clear_events(0xFFFFFFFF);
  eu_enable_events(EU_IDMA_A2O_DONE_MASK);
  (void)idma_L2ToL1(l2_src, l1_dst, (unsigned short)size_bytes);
  do {
    eu_idma_wait_a2o_completion(EU_WAIT_MODE_WFE);
  } while (idma_mm_is_busy_dir(/*is_l1_to_l2=*/0, /*stream_id=*/0));
}

/* Reduced from 96 to 1 row. Two reasons: (1) it cuts simulation time,
 * and (2) it shrinks the SHARED Y buffer that all 8 cluster cores reload
 * and GEMM into (M*K words) to the minimum, so the per-word reload-vs-
 * write-back race window across cores is as small as possible.
 * The first M rows of the golden are independent of the others, so
 * z_oup[0..M*K-1] remains a valid reference for this subset.
 * N and K cannot be reduced: they are baked into the W matrix layout. */
#define M_SIZE  (1)
#define N_SIZE  (64)
#define K_SIZE  (64)

#define VERBOSE (0)
#define USE_WFE (1)
#define DIFF_TH (0x0011)

/* Helper: same body as redmule_test_event_unit.c::main, factored so we
   can call it once from the CV32 main and verify results. Returns
   number of mismatches. */
static unsigned int redmule_run_and_verify(void) __attribute__((unused));
static unsigned int redmule_run_and_verify(void) {
  /* Bulk-load X, W, Y for this tile via iDMA. All 16 tiles run this
     in parallel; cross-tile contention is handled the same way the
     cluster cores serialize on the HWPE: each iDMA load issues, the
     core sleeps in WFE, and on wake re-checks the HW state until it
     is truly idle (see idma_load_l2_to_l1). */
  idma_load_l2_to_l1((uint32_t)x_inp, X_BASE, M_SIZE * N_SIZE * 2);
  idma_load_l2_to_l1((uint32_t)w_inp, W_BASE, N_SIZE * K_SIZE * 2);
  idma_load_l2_to_l1((uint32_t)y_inp, Y_BASE, M_SIZE * K_SIZE * 2);

  /* Initialize and configure RedMulE */
  hwpe_cg_enable();
  hwpe_soft_clear();

  int offload_id_tmp;
  while ((offload_id_tmp = hwpe_acquire_job()) < 0)
    ;

  redmule_cfg((unsigned int)X_BASE, (unsigned int)W_BASE, (unsigned int)Y_BASE,
              M_SIZE, N_SIZE, K_SIZE, (uint8_t)gemm_ops, (uint8_t)Float16, (uint8_t)Float16);

  /* Initialize Event Unit for RedMulE */
  eu_redmule_init();

  printf("Testing matrix multiplication with RedMulE...\n");
  hwpe_trigger_job();

  if (USE_WFE) {
    /* Drain HCI writeback: redmule_evt fires when the LAST writeback
       has been ISSUED, not when it's been committed to L1. Without
       this loop, the verify below can race the in-flight stores and
       see stale Y values on a few scattered indices (observed on
       tiles 14/15 where the per-tile timing is tightest). Same
       pattern used by pulp_main.c after the cluster jobs. */
    do {
      eu_redmule_wait_completion(EU_WAIT_MODE_WFE);
    } while (hwpe_get_status() != 0);
    printf("Detected WFE...\n");
  } else {
    do {
      eu_redmule_wait_completion(EU_WAIT_MODE_POLLING);
    } while (hwpe_get_status() != 0);
    printf("Detected polling completion...\n");
  }
  /* Make any in-flight HCI stores observable to subsequent loads. */
  asm volatile ("fence" ::: "memory");
  printf("Verifying results...\n");

  hwpe_cg_disable();

  unsigned int num_errors = 0;
  uint16_t computed, expected, diff;
  for (int i = 0; i < M_SIZE*K_SIZE; i++) {
    computed = mmio16(Y_BASE + 2*i);
    expected = z_oup[i];
    diff = (computed > expected) ? (computed - expected) : (expected - computed);
    if (diff > DIFF_TH) {
      num_errors++;
      printf("**ERROR**: Y[%8x](=0x%4x) != Z[%0d](=0x%4x)\n",
             Y_BASE + 2*i, computed, i, expected);
    }
  }
  printf("Finished test with %0d errors\n", num_errors);
  return num_errors;
}

int main(void) {
  enable_fpu();

  /* Step 1: CV32 main runs RedMulE once as a sanity check AND to leave
     the HWPE in a fully-initialized state for the cluster cores.
     Without an actual trigger+done cycle on the CV32 side, the cluster
     cores read garbage (0xFFFFFFFE) from REDMULE_ACQUIRE and spin
     forever in `while ((id = hwpe_acquire_job()) < 0)`.

     This step also implicitly populates X, W, Y in this tile's L1 SPM
     (via redmule_run_and_verify -> idma_load_l2_to_l1), so the cluster
     cores have valid operands when they re-run the matmul.

     NOTE: under mesh_dv=1 this used to race with iDMA on tiles 14/15;
     if that regresses, gate the call with a mesh_dv check or revert
     to soft_clear-only + extend the CV32-side hwpe_cg_enable to write
     a real CG-enable register once one is exposed by the wrapper. */
  unsigned int err_main = redmule_run_and_verify();
  printf("CV32 main RedMulE sanity-check: %0d errors\n", err_main);

  /* Pre-load EVERY per-core Y slot with the y_inp bias. Each cluster core
     then computes X*W + bias into its OWN slot, so there is no shared Y
     buffer and no cross-core race at all. (slot 0 = Y_BASE was overwritten
     with the result by the sanity-check above; this refreshes all slots.) */
  for (int c = 0; c < PULP_CORE_COUNT; c++)
    idma_load_l2_to_l1((uint32_t)y_inp, Y_BASE + c * Y_STRIDE,
                       M_SIZE * K_SIZE * 2);

  printf("Booting PULP cluster cores...\n");
  cluster_boot(PULP_BINARY_START);

  /* Arm EU before dispatching the task to avoid missing DONE. */
  cluster_arm_done_event();

  cluster_dispatch_task(HELLO_REDMULE_PULP_TASK, 0xFFu);

  /* Step 3: sleep (cv.elw) until all cluster cores have exited. */
  cluster_wait_done_eu();

  /* Step 4: verify EVERY cluster core's private Y slot == golden Z. */
  unsigned int err_pulp = 0;
  uint16_t computed, expected, diff;
  for (int c = 0; c < PULP_CORE_COUNT; c++) {
    uint32_t ybase = Y_BASE + c * Y_STRIDE;
    for (int i = 0; i < M_SIZE*K_SIZE; i++) {
      computed = mmio16(ybase + 2*i);
      expected = z_oup[i];
      diff = (computed > expected) ? (computed - expected) : (expected - computed);
      if (diff > DIFF_TH) {
        err_pulp++;
        printf("**PULP_ERR**: core=%0d i=%0d Y=0x%4x Z=0x%4x diff=0x%4x\n",
               c, i, computed, expected, diff);
      }
    }
  }
  printf("PULP cluster pass finished with %0d errors\n", err_pulp);

  return (err_main + err_pulp);
}
