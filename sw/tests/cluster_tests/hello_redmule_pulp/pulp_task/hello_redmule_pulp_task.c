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
 * hello_redmule_pulp - PULP cluster-core task.
 *
 * Linked as a position-independent embedded PULP binary. The CV32 boots the
 * cluster into crt0's dispatcher loop, then dispatches this task by writing
 * PULP_NB_CORES_TO_WAIT, PULP_TASKBIN and PULP_START.
 *
 * Concurrency model:
 *
 *   - All 8 cluster cores try to ACQUIRE the RedMulE HWPE in parallel.
 *     RedMulE's REDMULE_ACQUIRE register returns >=0 to exactly ONE
 *     core at a time (HWPE-internal arbitration). The losers see -1
 *     and spin.
 *
 *   - The winner programs RedMulE (mcfg + base addresses), triggers the job,
 *     then polls RedMulE STATUS via MMIO. Cluster cores intentionally do not
 *     use the Event Unit direct link.
 *
 *   - When the winner sees STATUS clear, the HWPE auto-clears and the next
 *     acquire winner runs. Repeat 8 times.
 *
 *   - Each cluster core writes a small marker in L2 with its hartid so
 *     we can confirm in the trace that all 8 actually ran the kernel.
 *
 * crt0 writes 1 to PULP_DONE when the task returns; after all selected cores
 * report done, the tile CSR emits EU bit 12 and wakes the CV32 main core.
 *
 * NOTE: every cluster core runs the SAME matmul on the SAME shared X/W
 * inputs, but each writes its result into its OWN PRIVATE Y slot
 * (Y_BASE + local_id*Y_STRIDE). No two cores ever touch the same word,
 * so the result is deterministic regardless of timing. The CV32 main
 * pre-loads every Y slot with the y_inp bias before dispatch and, after
 * PULP_DONE, verifies every slot == Z.
 */

#include "magia_tile_utils.h"
#include "redmule_mm_utils.h"
#include "magia_utils.h"

/* NOTE: we deliberately DO NOT include x_input.h / w_input.h /
   y_input.h here. Those headers define large `const uint16_t` arrays
   that would land in this PULP binary's .rodata/.data. Because the
   binary is linked with ORIGIN=0 and embedded into the CV32 ELF at
   runtime, GCC materializes the symbol addresses as their link-time
   absolute values (e.g. y_inp -> 0x6f4), which at runtime falls
   inside the tile's MMIO region (0x700+ = Event Unit) and hangs the
   core on a fake sleep register. All operand buffers are pre-loaded
   by the CV32 main into L1 SPM and we reach them through absolute
   addresses (X_BASE, W_BASE, Y_BASE). */

/* Same reduced size as main.c — must stay in sync. */
#define M_SIZE   (1)
#define N_SIZE   (64)
#define K_SIZE   (64)

#define X_BASE   (L1_BASE + 0x00012048)   /* shared, read-only */
#define W_BASE   (L1_BASE + 0x00016048)   /* shared, read-only */
/* PER-CORE output Y: each cluster core writes its OWN private slot at
   Y_BASE + local_id*Y_STRIDE, so two cores never touch the same word ->
   no cross-core race on the result buffer (deterministic). The CV32 main
   pre-loads every slot with the y_inp bias before dispatch, so the cores
   do NOT reload the bias themselves. MUST match Y_BASE/Y_STRIDE in main.c. */
#define Y_BASE   (L1_BASE + 0x0001A048)
#define Y_STRIDE (0x00001000)

/* Per-core marker area in L2: 4B per cluster core, 8 cluster cores per
   tile, 16 tiles -> 8*16 = 128 entries. Used only to prove every core
   reached the kernel. */
#define MARKER_BASE  (L2_BASE + 0x00050000)


/* Enable the FPU on this hart: set mstatus.FS to INITIAL (01). Without
   this any FPU instruction faults. RedMulE's hwpe-mac-engine itself
   does not need this (it's a separate HWPE), but the cluster core
   may execute float register copies in libgcc helpers / printf, and
   future tests may issue FP instructions directly. */
static inline void enable_fpu(void) {
    asm volatile (
        "li t0, 0x2000\n"
        "csrs mstatus, t0\n"
        ::: "t0"
    );
}

void hello_redmule_pulp_task(void *data) {
    (void)data;
    enable_fpu();

    uint32_t hartid   = get_hartid();
    uint32_t pulp_gid = hartid - PULP_HARTID_BASE;     /* 0..127 */
    uint32_t local_id = pulp_gid % PULP_CORE_COUNT;    /* 0..7 within tile */
    uint32_t tile_id  = pulp_gid / PULP_CORE_COUNT;    /* 0..15 across mesh */

    /* Drop a marker so the test trace can confirm we got here. */
    mmio32(MARKER_BASE + 4 * pulp_gid) = 0xC1057ED0u + local_id;

    /* Only core 0 of each tile prints, to avoid interleaving on the
       per-tile UART peripheral at 0xFFFF0004. */
    if (local_id == 0) {
        printf("[Tile %u PULP-%u mhartid %u] entering RedMulE contention\n",
            tile_id, local_id, hartid);
    }
    /* HWPE acquire: ONE core at a time wins. Losers spin here.
       NOTE: do NOT call hwpe_soft_clear inside this critical section,
       it would release the HWPE and let another core grab it mid-job.
       The CV32 main has already done cg_enable + soft_clear before
       releasing the cluster, so the HWPE is in a clean state. */
    int job_id;
    while ((job_id = hwpe_acquire_job()) < 0)
        ;

    /* Wait for the HWPE to be fully idle before (re)configuring it: the
       previous winner may still have write-back beats in flight (STATUS
       nonzero) even after it released the ACQUIRE lock. With per-core Y
       slots those beats land in the PREVIOUS core's slot, not ours, so
       they can't corrupt our result -- but we still wait so we never
       reprogram the HWPE mid-write-back. */
    while (hwpe_get_status() != 0);
    asm volatile("fence" ::: "memory");

    /* This core's PRIVATE output slot. The CV32 main has already pre-loaded
       it with the y_inp bias, so we just point RedMulE at it -- no reload. */
    uint32_t my_y = Y_BASE + local_id * Y_STRIDE;

    redmule_cfg((unsigned)X_BASE, (unsigned)W_BASE, (unsigned)my_y,
                M_SIZE, N_SIZE, K_SIZE,
                (uint8_t)gemm_ops, (uint8_t)Float16, (uint8_t)Float16);

    hwpe_trigger_job();

      while (hwpe_get_status() != 0)
         ;
    asm volatile("fence" ::: "memory");

    hwpe_cg_disable();

    if (local_id == 0) {
      printf("[Tile %u PULP-%u mhartid %u] RedMulE done, exiting\n",
               tile_id, local_id, hartid);
    }
    /* trap_handler writes 1 to PULP_DONE on return. */
}
