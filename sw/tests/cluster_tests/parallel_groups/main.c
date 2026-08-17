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
 * parallel_groups — main core (CV32) binary.
 *
 * Dispatches ONE task (parallel_groups_task) to the cluster, which
 * internally splits into two disjoint, concurrently-running teams: cores
 * 0-3 compute OUT_A = X + Y, cores 4-7 compute OUT_B = X - Y, at the same
 * time. See pulp_task/parallel_groups_task.c for the full mechanism.
 *
 * This is a *static* proof that the dispatch is structured to allow real
 * concurrency (group B is pushed and starts running before group A's own
 * work even begins). Confirming it actually overlaps in time -- not just
 * that it's *allowed* to -- needs a real simulation run: compare
 * trace_core_00000020..23 (group A) against trace_core_00000024..27
 * (group B) and check their cycle ranges overlap, rather than one finishing
 * before the other starts.
 */

#include "magia_tile_utils.h"
#include "cluster_utils.h"

#include "parallel_groups_pulp_task_bin.h"

#define N            64
#define X_BASE       (L1_BASE + 0x00000000)
#define Y_BASE       (L1_BASE + 0x00001000)
#define OUT_A_BASE   (L1_BASE + 0x00002000)
#define OUT_B_BASE   (L1_BASE + 0x00003000)

static inline uint32_t get_hartid(void) {
    uint32_t hartid;
    asm volatile("csrr %0, mhartid" : "=r"(hartid));
    return hartid;
}

int main(void) {
    uint32_t hartid = get_hartid();

    printf("[Main core %u] Hello World!\n", (unsigned)hartid);

    volatile int32_t *X = (volatile int32_t *)X_BASE;
    volatile int32_t *Y = (volatile int32_t *)Y_BASE;
    for (int i = 0; i < N; i++) {
        X[i] = i + 1;
        Y[i] = 100;
    }

    cluster_boot(PULP_BINARY_START);
    cluster_arm_done_event();

    printf("[Main core %u] Dispatching parallel_groups_task "
           "(cores 0-3: X+Y, cores 4-7: X-Y, concurrently)...\n",
           (unsigned)hartid);
    cluster_dispatch_task(PARALLEL_GROUPS_TASK);
    cluster_wait_done_eu();

    volatile int32_t *OA = (volatile int32_t *)OUT_A_BASE;
    volatile int32_t *OB = (volatile int32_t *)OUT_B_BASE;
    uint32_t errors = 0;

    for (int i = 0; i < N; i++) {
        int32_t exp_a = X[i] + Y[i];
        int32_t exp_b = X[i] - Y[i];
        if (OA[i] != exp_a) errors++;
        if (OB[i] != exp_b) errors++;
    }

    if (errors == 0) {
        printf("[Main core %u] parallel_groups PASS (%d elements x 2 groups)\n",
               (unsigned)hartid, N);
    } else {
        printf("[Main core %u] parallel_groups FAIL (%u mismatches)\n",
               (unsigned)hartid, (unsigned)errors);
    }

    return (int)errors;
}
