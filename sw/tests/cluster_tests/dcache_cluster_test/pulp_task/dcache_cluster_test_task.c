/*
 * Copyright (C) 2026 ETH Zurich, University of Bologna and Fondazione Chips-IT
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
 * Authors: Niccolò Giuliani <niccolo.giuliani@chips.it>
 *
 * dcache_cluster_test - PULP cluster task: every core sums its chunk of src and records its own cycles.
 *   mode 1: src and dst in .data (cache), dst[i] = 3 * src[i]
 *   mode 2: src in L1 (SPM), summed reps times
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "cluster_utils.h"

// GCC 14 crashes ("could not split insn", doloop_begin_i) on the cv32e40p hardware loop of the big loops
#pragma GCC optimize("no-branch-count-reg")

typedef struct {
    uint32_t mode;
    uint32_t src;
    uint32_t dst;
    uint32_t partial;
    uint32_t len;
    uint32_t reps;
    uint32_t cycles[PULP_CORE_COUNT];
} dcache_cluster_params_t;

static inline uint32_t read_mcycle(void) {
    uint32_t cycles;
    asm volatile("csrr %0, mcycle" : "=r"(cycles));
    return cycles;
}

static void dcache_cluster_fork_entry(void *arg) {
    volatile dcache_cluster_params_t *p = (volatile dcache_cluster_params_t *)arg;
    volatile uint32_t *src     = (volatile uint32_t *)p->src;
    volatile uint32_t *dst     = (volatile uint32_t *)p->dst;
    volatile uint32_t *partial = (volatile uint32_t *)p->partial;
    uint32_t id     = pi_core_id();
    uint32_t offset = cluster_chunk_offset(p->len, PULP_CORE_COUNT, id);
    uint32_t size   = cluster_chunk_size(p->len, PULP_CORE_COUNT, id);
    uint32_t mode   = p->mode;
    uint32_t reps   = p->reps;
    uint32_t sum    = 0;

    asm volatile("csrw mcountinhibit, zero");
    pi_cl_team_barrier();
    uint32_t start = read_mcycle();

    for (uint32_t r = 0; r < reps; r++) {
        for (uint32_t i = offset; i < offset + size; i++) {
            uint32_t v = src[i];
            sum += v;
            if (mode == 1)
                dst[i] = 3 * v;
        }
    }

    p->cycles[id] = read_mcycle() - start;
    partial[id]   = sum;
    pi_cl_team_barrier();
}

int dcache_cluster_test_task(void *data) {
    pi_cl_team_fork(PULP_CORE_COUNT, dcache_cluster_fork_entry, data);
    return 0;
}
