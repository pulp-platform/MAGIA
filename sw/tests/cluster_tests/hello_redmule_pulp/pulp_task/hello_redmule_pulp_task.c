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
 * hello_redmule_pulp — PULP cluster task (PIC, ORIGIN=0).
 * All 8 cores serialize on hwpe_acquire_job(); the winner programs RedMulE
 * and polls STATUS. Each core writes into its own Y slot (Y_BASE + id*Y_STRIDE)
 * so there is no shared-buffer race. crt0 writes PULP_DONE on return.
 */

#include "magia_tile_utils.h"
#include "redmule_mm_utils.h"
#include "magia_utils.h"

/* Do NOT include x_input.h/w_input.h/y_input.h: with ORIGIN=0 their symbol
   addresses alias tile MMIO at runtime. Use X_BASE/W_BASE/Y_BASE instead. */

/* Same reduced size as main.c — must stay in sync. */
#define M_SIZE   (1)
#define N_SIZE   (64)
#define K_SIZE   (64)

#define X_BASE   (L1_BASE + 0x00012048)   /* shared, read-only */
#define W_BASE   (L1_BASE + 0x00016048)   /* shared, read-only */
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

    int job_id;
    while ((job_id = hwpe_acquire_job()) < 0)
        ;

    // Wait for the HWPE to be fully idle before (re)configuring it

    while (hwpe_get_status() != 0);
    asm volatile("fence" ::: "memory");

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
