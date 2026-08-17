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
 * parallel_groups — proof that the cluster can run two independent,
 * disjoint teams AT THE SAME TIME, not one after the other.
 *
 * Cores 0-3 ("group A") compute OUT_A = X + Y.
 * Cores 4-7 ("group B") compute OUT_B = X - Y.
 * Both groups start from the SAME dispatch (core 0's own task, below) and
 * both are genuinely in flight together -- core 0 pushes group B first
 * (pi_cl_team_push_other(), fire-and-forget, core 0 is not a member),
 * THEN does group A's own work itself (pi_cl_team_fork(), core 0 IS a
 * member) -- so while core 0 (and cores 1-3) are computing group A's
 * slice, cores 4-7 are already awake and computing group B's slice in
 * parallel. Nothing in this code forces group B to wait for group A or
 * vice versa before either one starts.
 *
 * Why not just call pi_cl_team_fork() twice with different masks: core 0
 * would end up a target of two barriers active at once, and
 * event_unit_top.sv ORs every barrier's completion into a single shared
 * bit per core -- core 0 couldn't tell group A's completion from group
 * B's. See pi_cl_team_push_other()/pi_cl_team_barrier_id() in
 * cluster_utils.h for the full reasoning (verified against the real
 * pulp-sdk driver: it never runs two barriers at once either, for exactly
 * this reason).
 *
 * Group B's own rendez-vous (making sure all 4 of its cores are done)
 * uses barrier 1, entirely private to cores 4-7 -- core 0 is never a
 * target of it, so there's no shared-bit ambiguity. Group B's lowest-id
 * core (4) then reports completion to core 0 with a targeted SW event
 * (pi_cl_sw_event_trigger()/pi_cl_sw_event_wait(), cluster_utils.h) --
 * its own distinct bit, separate from the barrier-completion bit that
 * group A already uses, so core 0 can tell the two apart and block
 * (clock-gated cv.elw) instead of busy-polling. This is the same kind of
 * targeted, one-core-tells-another notification real pulp-sdk itself uses
 * for cluster-to-FC completion (pos_cluster_push_fc_event()).
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

    /* Private rendez-vous among cores 4-7 only -- core 0 never touches
     * this barrier, so there's no ambiguity with group A's barrier 0. */
    pi_cl_team_barrier_id(GROUP_B_BARRIER_ID);

    if (pi_core_id() == GROUP_B_LEADER_ID) {
        pi_cl_sw_event_trigger(GROUP_B_DONE_SW_EVT, CORE0_MASK);
    }
}

void parallel_groups_task(void *data) {
    (void)data;

    /* Push group B first: fire-and-forget, core 0 is not a member, cores
     * 4-7 start computing immediately and independently. */
    pi_cl_team_barrier_setup(GROUP_B_BARRIER_ID, GROUP_B_MASK);
    pi_cl_team_push_other(GROUP_B_MASK, group_b_entry, (void *)0);

    /* Group A: core 0 IS a member, runs its own slice, then rendez-vous
     * on barrier 0 with cores 1-3 -- exactly the normal pi_cl_team_fork.
     * Cores 4-7 are running group_b_entry concurrently with all of this. */
    pi_cl_team_fork(GROUP_A_SIZE, group_a_entry, (void *)0);

    /* Group A is already done (the barrier above guaranteed it). Block
     * (clock-gated) until group B's leader signals its own SW event --
     * distinct bit from the barrier-completion one, so no ambiguity. */
    pi_cl_sw_event_wait(GROUP_B_DONE_SW_EVT);
}
