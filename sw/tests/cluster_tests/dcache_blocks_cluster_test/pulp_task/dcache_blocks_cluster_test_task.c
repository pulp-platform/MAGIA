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
 * Cluster task of dcache_blocks_cluster_test: the 8 PULP cores sum blocks of `block` words taken in random
 * order. In the L2 variant each core walks its own share of the list; in the iDMA variant there is one iDMA
 * for the whole tile, so cluster core 0 issues one descriptor per core per round and the team waits on it.
 * That serialization is the point of the test: it is what moves the break-even away from one cache line.
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "cluster_utils.h"
#include "idma_mm_utils.h"
#include "bench_utils.h"
#include "../dcache_blocks_cluster_test.h"

// GCC 14 crashes ("could not split insn", doloop_begin_i) on the cv32e40p hardware loop of the big loops
#pragma GCC optimize("no-branch-count-reg")
#pragma GCC optimize("align-loops=4")
#define KERNEL __attribute__((noinline, aligned(4)))

/* Blocks [lo, hi) of the list, straight from the L2. Same loop for direct and cache: the only difference
 * between the two is how the cache is configured around it. */
KERNEL static uint32_t sum_blocks_l2(volatile uint32_t *src, volatile uint32_t *idx, uint32_t lo, uint32_t hi,
                                     uint32_t block) {
    uint32_t sum = 0;
    for (uint32_t j = lo; j < hi; j++) {
        uint32_t s = idx[j];
        for (uint32_t k = 0; k < block; k++)
            sum += src[s + k];
    }
    return sum;
}

/* One block already staged in the SPM */
KERNEL static uint32_t sum_buf(volatile uint32_t *buf, uint32_t block) {
    uint32_t sum = 0;
    for (uint32_t k = 0; k < block; k++)
        sum += buf[k];
    return sum;
}

static uint32_t dbc_l2(volatile dbc_params_t *p, uint32_t id) {
    volatile uint32_t *src = (volatile uint32_t *)p->src;
    volatile uint32_t *idx = (volatile uint32_t *)p->idx;
    uint32_t lo  = cluster_chunk_offset(p->n_blocks, PULP_CORE_COUNT, id);
    uint32_t hi  = lo + cluster_chunk_size(p->n_blocks, PULP_CORE_COUNT, id);
    uint32_t sum = 0;

    for (uint32_t r = 0; r < p->reuse; r++)
        sum += sum_blocks_l2(src, idx, lo, hi, p->block);
    return sum;
}

/* Slot of core g in half d, core view and iDMA view */
static inline uint32_t dbc_slot(volatile dbc_params_t *p, int d, uint32_t g) {
    return p->buf + ((d * PULP_CORE_COUNT) + g) * p->block * 4;
}

static inline uint32_t dbc_slot_loc(volatile dbc_params_t *p, int d, uint32_t g) {
    return p->buf_loc + ((d * PULP_CORE_COUNT) + g) * p->block * 4;
}

/* One descriptor per core per round, issued by core 0 only: the tile has one iDMA */
static uint32_t dbc_stage(volatile dbc_params_t *p, uint32_t round, int d) {
    volatile uint32_t *idx = (volatile uint32_t *)p->idx;
    uint32_t bytes = p->block * 4;
    uint32_t id    = 0;

    for (uint32_t g = 0; g < PULP_CORE_COUNT; g++)
        id = idma_L2ToL1(p->src + idx[round * PULP_CORE_COUNT + g] * 4, dbc_slot_loc(p, d, g), bytes);
    return id;
}

static uint32_t dbc_idma(volatile dbc_params_t *p, uint32_t id) {
    uint32_t rounds   = p->n_blocks / PULP_CORE_COUNT;
    uint32_t in_id[2] = {0, 0};
    uint32_t sum      = 0;

    for (uint32_t r = 0; r < p->reuse; r++) {
        if (id == 0)
            in_id[0] = dbc_stage(p, 0, 0);
        for (uint32_t t = 0; t < rounds; t++) {
            int d = t & 1, n = d ^ 1;
            if (id == 0) {
                idma_wait_in(in_id[d]);
                if (t + 1 < rounds)
                    in_id[n] = dbc_stage(p, t + 1, n);
            }
            pi_cl_team_barrier();
            sum += sum_buf((volatile uint32_t *)dbc_slot(p, d, id), p->block);
            pi_cl_team_barrier();
        }
    }
    return sum;
}

static void dbc_fork_entry(void *arg) {
    volatile dbc_params_t *p = (volatile dbc_params_t *)arg;
    uint32_t id = pi_core_id();
    uint32_t sum;

    asm volatile("csrw mcountinhibit, zero");
    pi_cl_team_barrier();
    uint32_t start = read_mcycle();

    if (p->variant == DBC_VAR_IDMA)
        sum = dbc_idma(p, id);
    else
        sum = dbc_l2(p, id);

    p->cycles[id]  = read_mcycle() - start;
    p->partial[id] = sum;
    pi_cl_team_barrier();
}

int dcache_blocks_cluster_test_task(void *data) {
    pi_cl_team_fork(PULP_CORE_COUNT, dbc_fork_entry, data);
    return 0;
}
