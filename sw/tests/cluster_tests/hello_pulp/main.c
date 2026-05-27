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
 * hello_pulp — main core (CV32) binary.
 *
 * This ELF is linked at 0xCC000000 and executed by the CV32 main core
 * of each tile (mhartid 0..NUM_CLUSTERS-1).
 *
 * Flow:
 *   1) Print a "hello" banner.
 *   2) Boot the PULP cluster cores into their dispatcher loop
 *      (cluster_boot -> pulp_init: programs PULP_BINARY, broadcasts
 *      CLK_EN, polls PULP_READY).
 *   3) Arm the CV32 Event Unit for PULP_DONE (EU bit 12).
 *   4) Dispatch the hello task to all 8 PULP cores by programming
 *      NB_CORES_TO_WAIT, TASKBIN and START.
 *   5) Sleep in WFE until the DONE quorum reaches the Event Unit.
 *   6) Print the "done" message.
 */

#include "magia_tile_utils.h"
#include "cluster_utils.h"
#include "hello_pulp_pulp_task_bin.h"

static inline uint32_t get_mhartid(void) {
    uint32_t id;
    asm volatile("csrr %0, mhartid" : "=r"(id));
    return id;
}

int main(void) {
    uint32_t hartid = get_mhartid();

    printf("[Main core %u] Hello World!\n", hartid);

    /* Boot the PULP cluster cores into their dispatcher loop. */
    cluster_boot(PULP_BINARY_START);

    /* Arm EU before dispatching the task to avoid missing DONE. */
    cluster_arm_done_event();

    /* Dispatch the hello task to all 8 cluster cores of this tile. */
    cluster_dispatch_task(HELLO_PULP_TASK, 0xFFu);

    /* Sleep (cv.elw) until every cluster core of this tile has signalled
     * task completion. */
    cluster_wait_done_eu();

    printf("[Main core %u] All %d cluster cores done!\n",
           hartid, PULP_CORE_COUNT);

    return 0;
}
