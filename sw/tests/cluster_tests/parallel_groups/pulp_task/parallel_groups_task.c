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
 * Authors: Luca Balboni <luca.balboni@chips.it>
 *
 * parallel_groups - PULP cluster task: cores 0-3 compute X + Y while cores 4-7 compute X - Y
 */

#include "magia_tile_utils.h"
#include "cluster_utils.h"

#define N            64
#define X_BASE       (L1_BASE + 0x00000000)  /* X[64] : 256 B */
#define Y_BASE       (L1_BASE + 0x00001000)  /* Y[64] : 256 B */
#define OUT_A_BASE   (L1_BASE + 0x00002000)  /* OUT_A[64] = X + Y */
#define OUT_B_BASE   (L1_BASE + 0x00003000)  /* OUT_B[64] = X - Y */

#define GROUP_A_MASK   0x0F   /* cores 0-3 */
#define GROUP_A_SIZE   4
#define GROUP_B_MASK   0xF0   /* cores 4-7 */
#define GROUP_B_SIZE   4
#define GROUP_B_BASE_ID    4  /* lowest core id in group B */
#define GROUP_B_LEADER_ID  4  /* who reports completion */
#define GROUP_B_BARRIER_ID 1  /* barrier 0 is group A's (pi_cl_team_fork) */
#define GROUP_B_DONE_SW_EVT 0 /* SW event id used to notify core 0 */
#define CORE0_MASK     0x01

static void group_a_entry(void *arg) {
    (void)arg;
    uint32_t local_id = pi_core_id();                             /* 0..3 */
    uint32_t off  = cluster_chunk_offset(N, GROUP_A_SIZE, local_id);
    uint32_t size = cluster_chunk_size(N, GROUP_A_SIZE, local_id);

    volatile int32_t *X   = (volatile int32_t *)X_BASE;
    volatile int32_t *Y   = (volatile int32_t *)Y_BASE;
    volatile int32_t *OUT = (volatile int32_t *)OUT_A_BASE;

    for (uint32_t i = 0; i < size; i++) {
        OUT[off + i] = X[off + i] + Y[off + i];
    }
}

static void group_b_entry(void *arg) {
    (void)arg;
    uint32_t local_id = pi_core_id() - GROUP_B_BASE_ID;            /* 0..3 */
    uint32_t off  = cluster_chunk_offset(N, GROUP_B_SIZE, local_id);
    uint32_t size = cluster_chunk_size(N, GROUP_B_SIZE, local_id);

    volatile int32_t *X   = (volatile int32_t *)X_BASE;
    volatile int32_t *Y   = (volatile int32_t *)Y_BASE;
    volatile int32_t *OUT = (volatile int32_t *)OUT_B_BASE;

    for (uint32_t i = 0; i < size; i++) {
        OUT[off + i] = X[off + i] - Y[off + i];
    }

    /* Barrier private to cores 4-7, distinct from group A's barrier 0 */
    pi_cl_team_barrier_id(GROUP_B_BARRIER_ID);

    if (pi_core_id() == GROUP_B_LEADER_ID) {
        pi_cl_sw_event_trigger(GROUP_B_DONE_SW_EVT, CORE0_MASK);
    }
}

void parallel_groups_task(void *data) {
    (void)data;

    /* Push group B first: core 0 is not a member, so cores 4-7 start right away */
    pi_cl_team_barrier_setup(GROUP_B_BARRIER_ID, GROUP_B_MASK);
    pi_cl_team_push_other(GROUP_B_MASK, group_b_entry, (void *)0);

    /* Group A on cores 0-3 with barrier 0, while group B is still running */
    pi_cl_team_fork(GROUP_A_SIZE, group_a_entry, (void *)0);

    /* Two barriers share one completion bit per core, so group B reports to core 0 with a SW event */
    pi_cl_sw_event_wait(GROUP_B_DONE_SW_EVT);
}
