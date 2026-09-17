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
 * Authors: Luca Balboni, Fondazione Chips-IT
 */

/*
 * vector_add - PULP cluster-core binary.
 *
 * vector_add_cluster() is PLAY's vector_add_pulp_open_cluster()
 * (source/vector_add/arch/vector_add_pulp_open.c) copied as is: each core
 * takes a contiguous block, adds it two elements per iteration, then joins
 * the team barrier. The PMSIS calls it needs (pi_core_id,
 * pi_cl_team_barrier, pi_cl_team_fork) come from cluster_utils.h.
 *
 * Only core 0 is dispatched; vector_add_task forks the kernel onto all
 * PULP_CORE_COUNT cores.
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "cluster_utils.h"

#define NUM_CORES PULP_CORE_COUNT

typedef struct {
    uint32_t src_a;
    uint32_t src_b;
    uint32_t dst;
    uint32_t len;
} vector_add_params_t;

static int vector_add_cluster(const float *src_a, const float *src_b, float *dst, const int len)
{
    int rem_ops;
    int tot_ops;
    int block;
    int start;
    int left;
    int end;
    int op;
    int id;
    int i;

    id = pi_core_id();
    block = len / NUM_CORES;
    left = len % NUM_CORES;
    start = id * block + (id < left ? id : left);
    end = start + block + (id < left ? 1 : 0);
    tot_ops = (end - start) / 2;
    rem_ops = tot_ops % 2;
    i = start;
    op = 0;

    do {
        int idx1, idx2;
        float a1, a2;
        float b1, b2;

        idx1 = i;
        idx2 = i + 1;
        a1 = src_a[idx1];
        b1 = src_b[idx1];
        a2 = src_a[idx2];
        b2 = src_b[idx2];

        dst[idx1] = a1 + b1;
        dst[idx2] = a2 + b2;

        i += 2;
        op++;
    } while (op < tot_ops);

    if (rem_ops)
        dst[end - 1] = src_a[end - 1] + src_b[end - 1];

#if NUM_CORES > 1
    pi_cl_team_barrier();
#endif

    return 0;
}

static void vector_add_fork_entry(void *arg) {
    vector_add_params_t *p = (vector_add_params_t *)arg;
    vector_add_cluster((const float *)p->src_a, (const float *)p->src_b,
                       (float *)p->dst, (int)p->len);
}

int vector_add_task(void *data) {
    pi_cl_team_fork(PULP_CORE_COUNT, vector_add_fork_entry, data);
    return 0;
}
