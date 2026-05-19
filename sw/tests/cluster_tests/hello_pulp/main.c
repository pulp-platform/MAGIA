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
 *   2) Arm the Event Unit for cluster-done WFE (EU bit 22).
 *   3) Kick the PULP cluster cores via cluster_start().
 *   4) Sleep in WFE until all cluster cores have reported (cluster_wait_eu()).
 *   5) Print the "done" message.
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

    /* Arm EU before kicking the cluster to avoid missing the event. */
    cluster_init_eu();

    /* Release the PULP cluster cores of this tile. */
    cluster_start(PULP_BINARY_START, 0xFFu);

    /* Sleep (cv.elw) until every cluster core of this tile has signalled
     * exit; cluster_wait_eu() also clears PULP_DONE (read-to-clear). */
    cluster_wait_eu();

    printf("[Main core %u] All %d cluster cores done!\n",
           hartid, PULP_CORE_COUNT);

    return 0;
}
