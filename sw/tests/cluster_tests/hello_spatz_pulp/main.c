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
 * hello_spatz_pulp — main core (CV32) binary.
 *
 * Demonstrates the CV32 + Spatz + PULP cluster pipeline on one tile:
 *
 *   1) Fill FP16 input vectors X (= 1.0) and Y (= 2.0) in tile-local L1.
 *   2) Initialize Spatz + Event Unit; offload Z = X + Y (vecsum16) to Spatz.
 *   3) Sleep via WFE (EU bit 8 = spatz_done) until Spatz signals completion.
 *   4) Check Spatz exit code; disable Spatz clock.
 *   5) Reset EU, arm for cluster-done WFE (EU bit 22); release PULP cluster.
 *   6) Each cluster core sums its 1/8th of Z (raw uint16 bit-patterns) → L2.
 *   7) CV32 wakes from WFE, collects per-core partial sums, verifies total.
 *
 * Expected result:
 *   Z[i] = 3.0 FP16 = 0x4200 for all i.
 *   Per-core partial sum  = 32 × 0x4200 = 0x84000.
 *   Grand total (8 cores) = 256 × 0x4200 = 0x420000.
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "cluster_utils.h"
#include "magia_spatz_utils.h"
#include "event_unit_utils.h"

#include "hello_spatz_pulp_pulp_task_bin.h"
#include "hello_spatz_pulp_task_bin.h"   /* generated: SPATZ_BINARY_START, VECSUM16_TASK */

/* -------------------------------------------------------------------------
 * Memory layout (tile-local L1 + shared L2)
 * ------------------------------------------------------------------------- */
#define VLEN         256                      /* number of FP16 elements     */

#define X_BASE       (L1_BASE + 0x00000000)  /* X[256] : 512 B              */
#define Y_BASE       (L1_BASE + 0x00001000)  /* Y[256] : 512 B              */
#define Z_BASE       (L1_BASE + 0x00002000)  /* Z[256] : 512 B (Spatz out)  */
#define PARAMS_BASE  (L1_BASE + 0x00003000)  /* vecsum_params_t : 16 B      */

/* One uint32 slot per cluster core in L2. */
#define RESULT_BASE  (L2_BASE + 0x00060000)

/* -------------------------------------------------------------------------
 * FP16 constants
 * ------------------------------------------------------------------------- */
#define FP16_ONE     (0x3C00u)   /* 1.0  */
#define FP16_TWO     (0x4000u)   /* 2.0  */
#define FP16_THREE   (0x4200u)   /* 3.0 = 1.0 + 2.0 */

/* Per-core partial sum  = (VLEN / PULP_CORE_COUNT) elements × FP16_THREE  */
#define GOLDEN_PARTIAL  ((VLEN / PULP_CORE_COUNT) * FP16_THREE)  /* 0x84000  */
/* Grand total           = VLEN elements × FP16_THREE                       */
#define GOLDEN_TOTAL    (VLEN * FP16_THREE)                       /* 0x420000 */

/* -------------------------------------------------------------------------
 * Parameter struct for vecsum16_task (must match vecsum16_task.c).
 * ------------------------------------------------------------------------- */
typedef struct {
    uint32_t x_addr;
    uint32_t y_addr;
    uint32_t z_addr;
    uint32_t n_size;
} vecsum_params_t;

int main(void) {
    unsigned int errors = 0;

    /* ------------------------------------------------------------------
     * Step 1: populate X and Y in L1 with constant FP16 patterns.
     * ------------------------------------------------------------------ */
    volatile uint16_t *X = (volatile uint16_t *)X_BASE;
    volatile uint16_t *Y = (volatile uint16_t *)Y_BASE;
    for (int i = 0; i < VLEN; i++) {
        X[i] = FP16_ONE;
        Y[i] = FP16_TWO;
    }

    /* ------------------------------------------------------------------
     * Step 2: initialize Event Unit and Spatz.
     * ------------------------------------------------------------------ */
    eu_init();
    eu_enable_events(EU_SPATZ_DONE_MASK);

    printf("[CV32] Initializing Spatz...\n");
    spatz_init(SPATZ_BINARY_START);

    /* Write parameter struct for vecsum16_task into L1. */
    volatile vecsum_params_t *params = (volatile vecsum_params_t *)PARAMS_BASE;
    params->x_addr = X_BASE;
    params->y_addr = Y_BASE;
    params->z_addr = Z_BASE;
    params->n_size = VLEN;

    /* ------------------------------------------------------------------
     * Step 3: trigger Spatz and wait for completion via WFE.
     *
     * spatz_run_task() sets TASKBIN, writes START=1, then polls START
     * until Spatz firmware clears it (task acknowledged).
     * eu_wait_spatz_wfe() then sleeps until the DONE event asserts.
     * ------------------------------------------------------------------ */
    printf("[CV32] Launching Spatz vecsum16 (N=%d)...\n", VLEN);
    spatz_pass_params(PARAMS_BASE);
    spatz_run_task(VECSUM16_TASK);
    eu_wait_spatz_wfe(EU_SPATZ_DONE_MASK);

    if (spatz_get_exit_code() != 0) {
        printf("[CV32] ERROR: Spatz returned exit code 0x%08x\n",
               spatz_get_exit_code());
        errors++;
    } else {
        printf("[CV32] Spatz vecsum16 done OK.\n");
    }

    spatz_clk_dis();

    /* ------------------------------------------------------------------
     * Step 4: release PULP cluster; wait for cluster-done via WFE.
     *
     * eu_init() fully resets the EU (clears buffer and mask), then
     * cluster_init_eu() arms EU bit 22 (EU_CLUSTER_DONE_MASK).
     * ------------------------------------------------------------------ */
    eu_init();
    cluster_init_eu();

    printf("[CV32] Releasing PULP cluster cores...\n");
    cluster_start(PULP_BINARY_START, 0xFFu);
    cluster_wait_eu();

    /* ------------------------------------------------------------------
     * Step 5: collect per-core partial sums from L2 and verify.
     * ------------------------------------------------------------------ */
    printf("[CV32] Verifying results...\n");
    uint32_t grand_total = 0;
    for (int i = 0; i < PULP_CORE_COUNT; i++) {
        uint32_t partial = mmio32(RESULT_BASE + 4 * i);
        grand_total += partial;
        if (partial != GOLDEN_PARTIAL) {
            printf("  core %d partial=0x%08x expected=0x%08x FAIL\n",
                   i, partial, (unsigned)GOLDEN_PARTIAL);
            errors++;
        } else {
            printf("  core %d partial=0x%08x PASS\n", i, partial);
        }
    }

    if (grand_total == GOLDEN_TOTAL) {
        printf("[CV32] Grand total=0x%08x PASS\n", grand_total);
    } else {
        printf("[CV32] Grand total=0x%08x expected=0x%08x FAIL\n",
               grand_total, (unsigned)GOLDEN_TOTAL);
        errors++;
    }

    return (int)errors;
}
