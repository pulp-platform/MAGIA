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
 * vector_add — main core (CV32) binary.
 *
 * Runs PLAY's (https://github.com/FondazioneChipsIT/PLAY) vector_add kernel
 * on the MAGIA PULP cluster, using PLAY's own golden test vectors
 * (PLAY/test/vector_add/test_data/data.h: vec_a, vec_b, expected, all
 * LEN=2048 floats) instead of MAGIA test harness data.
 *
 * PLAY's own test harness (test/vector_add/pulp-open/main.c) isn't reused
 * here: it depends on PMSIS device-open ceremony (pi_cluster_open() etc.)
 * that assumes a pulpOS-hosted fabric controller, which MAGIA's bare-metal
 * ctrl core doesn't run. This orchestrator replaces that ceremony with
 * MAGIA's own cluster_boot/cluster_dispatch_task_with_params/
 * cluster_wait_done_eu flow (same as every other MAGIA cluster test), and
 * hands the cluster side PLAY's algorithm completely unmodified (see
 * pulp_task/vector_add_task.c).
 *
 * Flow:
 *   1) Copy vec_a/vec_b (PLAY's golden inputs) into tile-local L1.
 *   2) Boot the PULP cluster and dispatch vector_add_task to core 0, along
 *      with a small params struct (src/dst addresses + length).
 *   3) Sleep in WFE until PULP_DONE.
 *   4) Compare the L1 result against PLAY's own `expected[]`, using PLAY's
 *      own tolerance (TOLL = 0.004f, see PLAY/test/common/utils.c
 *      vector_compare()).
 */

#include "magia_tile_utils.h"
#include "cluster_utils.h"

#define TARGET_IS_PULP_OPEN 1
#include "../../../../../../PLAY/test/vector_add/test_data/data.h"

#include "vector_add_pulp_task_bin.h"

#define TOLL 0.004f

#define X_BASE      (L1_BASE + 0x00000000)   /* vec_a copy : LEN*4 = 8192 B */
#define Y_BASE      (L1_BASE + 0x00003000)   /* vec_b copy : LEN*4 = 8192 B */
#define Z_BASE      (L1_BASE + 0x00006000)   /* result     : LEN*4 = 8192 B */
#define PARAMS_BASE (L1_BASE + 0x00009000)   /* vector_add_params_t : 16 B  */

typedef struct {
    uint32_t src_a;
    uint32_t src_b;
    uint32_t dst;
    uint32_t len;
} vector_add_params_t;

static inline uint32_t get_hartid(void) {
    uint32_t hartid;
    asm volatile("csrr %0, mhartid" : "=r"(hartid));
    return hartid;
}

static inline float fabs_f32(float x) {
    return (x < 0.0f) ? -x : x;
}

int main(void) {
    uint32_t hartid = get_hartid();

    printf("[Main core %u] Hello World!\n", (unsigned)hartid);

    /* Copy PLAY's golden inputs into cluster-visible L1. */
    volatile float *X = (volatile float *)X_BASE;
    volatile float *Y = (volatile float *)Y_BASE;
    for (int i = 0; i < LEN; i++) {
        X[i] = vec_a[i];
        Y[i] = vec_b[i];
    }

    volatile vector_add_params_t *params =
        (volatile vector_add_params_t *)PARAMS_BASE;
    params->src_a = X_BASE;
    params->src_b = Y_BASE;
    params->dst   = Z_BASE;
    params->len   = LEN;

    /* Boot the PULP cluster cores into their dispatcher loop. */
    cluster_boot(PULP_BINARY_START);

    /* Arm EU before dispatching the task to avoid missing DONE. */
    cluster_arm_done_event();

    /* Dispatch vector_add_task to core 0; it forks PLAY's vector_add()
     * across all 8 cores via pi_cl_team_fork(). */
    cluster_dispatch_task_with_params(VECTOR_ADD_TASK, PARAMS_BASE);

    /* Sleep (cv.elw) until core 0 has signalled task completion -- i.e. the
     * fork, PLAY's vector_add() on every core and its closing
     * pi_cl_team_barrier() have all completed. */
    cluster_wait_done_eu();

    /* Compare against PLAY's own golden output, PLAY's own tolerance. */
    volatile float *Z = (volatile float *)Z_BASE;
    uint32_t errors = 0;
    for (int i = 0; i < LEN; i++) {
        if (fabs_f32(Z[i] - expected[i]) > TOLL)
            errors++;
    }

    if (errors == 0) {
        printf("[Main core %u] vector_add PASS (%d elements)\n",
               (unsigned)hartid, LEN);
    } else {
        printf("[Main core %u] vector_add FAIL (%u/%d mismatches)\n",
               (unsigned)hartid, (unsigned)errors, LEN);
    }

    return (int)errors;
}
