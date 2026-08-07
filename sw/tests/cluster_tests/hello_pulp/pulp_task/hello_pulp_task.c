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
 * hello_pulp — PULP cluster-core task.
 *
 * Linked at 0x0 (PIC, ORIGIN=0) and embedded as .pulp_binary inside the
 * CV32 ELF (single-binary flow). Core 0 boots into pulp_crt0.S's
 * dispatcher_loop and jumps here when the CV32 calls
 * cluster_dispatch_task(HELLO_PULP_TASK). Cores 1-7 stay parked on the
 * Event Unit dispatch FIFO (pulp_crt0.S's worker_wait): this task runs on
 * core 0 only, since it never forks work onto them (e.g. via
 * pi_cl_team_fork()) -- the local_id==0 check below is therefore always
 * true here, kept only so the print still makes sense if this task is
 * ever extended to fork.
 *
 * The task is entered as `void hello_pulp_task(void *data)`; `data` is
 * whatever pointer the CV32 wrote to PULP_DATA (NULL here). When it
 * returns, pulp_crt0.S's dispatcher_loop writes 1 to PULP_DONE and goes
 * back to sleep (cv.elw), not a trap/WFI.
 */

#include "magia_tile_utils.h"

static inline uint32_t get_hartid(void) {
    uint32_t hartid;
    asm volatile("csrr %0, mhartid"
                 :"=r"(hartid):);
    return hartid;
}

void hello_pulp_task(void *data) {
    (void)data;

    uint32_t hartid   = get_hartid();
    uint32_t pulp_gid = hartid - PULP_HARTID_BASE;
    uint32_t local_id = pulp_gid % PULP_CORE_COUNT;
    uint32_t tile_id  = pulp_gid / PULP_CORE_COUNT;

    /* Only core 0 of each tile prints, to avoid interleaving on the
       shared per-tile UART peripheral at 0xFFFF0004. */
    if (local_id == 0)
        printf("[Tile %u PULP-%u mhartid %u] Hello World!\n",
               tile_id, local_id, hartid);
}
