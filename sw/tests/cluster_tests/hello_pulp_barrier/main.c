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
 * hello_pulp_barrier — main core (CV32) binary.
 *
 * Same single-mailbox dispatch as hello_pulp: the CV32 boots the cluster
 * and dispatches ONE task to core 0. See hello_pulp_barrier_task.c for the
 * point of this test -- pi_cl_team_barrier() called on a properly
 * configured 1-core team, as opposed to hello_pulp_task.c's bare call
 * (which hangs, see that file's history).
 */

#include "magia_tile_utils.h"
#include "cluster_utils.h"
#include "hello_pulp_barrier_pulp_task_bin.h"

static inline uint32_t get_hartid(void) {
    uint32_t hartid;
    asm volatile("csrr %0, mhartid"
                 :"=r"(hartid):);
    return hartid;
}

int main(void) {
    uint32_t hartid = get_hartid();

    printf("[Main core %u] Hello World!\n", hartid);

    /* Boot the PULP cluster cores into their dispatcher loop. */
    cluster_boot(PULP_BINARY_START);

    /* Arm EU before dispatching the task to avoid missing DONE. */
    cluster_arm_done_event();

    /* Dispatch the task to core 0 (the usual single-mailbox model). */
    cluster_dispatch_task(HELLO_PULP_BARRIER_TASK);

    /* Sleep (cv.elw) until core 0 has signalled task completion. */
    cluster_wait_done_eu();

    return 0;
}
