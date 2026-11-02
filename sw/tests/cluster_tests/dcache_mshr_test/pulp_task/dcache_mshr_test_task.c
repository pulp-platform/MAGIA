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
 * dcache_mshr_test - PULP cluster task: every core runs one access pattern on the 128 KiB array, sums what it
 * reads and records its own cycles. See dcache_mshr_test.h for the patterns.
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "cluster_utils.h"
#include "../dcache_mshr_test.h"

// GCC 14 crashes ("could not split insn", doloop_begin_i) on the cv32e40p hardware loop of the big loops
#pragma GCC optimize("no-branch-count-reg")

static inline uint32_t read_mcycle(void) {
    uint32_t cycles;
    asm volatile("csrr %0, mcycle" : "=r"(cycles));
    return cycles;
}

static void dcache_mshr_fork_entry(void *arg) {
    volatile dcache_mshr_params_t *p = (volatile dcache_mshr_params_t *)arg;
    volatile uint32_t *big     = (volatile uint32_t *)p->big;
    volatile uint32_t *partial = (volatile uint32_t *)p->partial;
    uint32_t id     = pi_core_id();
    uint32_t mode   = p->mode;
    uint32_t offset = cluster_chunk_offset(MSHR_BIG_WORDS, PULP_CORE_COUNT, id);
    uint32_t size   = cluster_chunk_size(MSHR_BIG_WORDS, PULP_CORE_COUNT, id);
    uint32_t sum    = 0;
    uint32_t lcg    = mshr_lcg_seed(id);

    asm volatile("csrw mcountinhibit, zero");
    pi_cl_team_barrier();
    uint32_t start = read_mcycle();

    if (mode == MSHR_MODE_INIT) {
        for (uint32_t i = offset; i < offset + size; i++)
            big[i] = mshr_value(i);
    } else if (mode == MSHR_MODE_DENSE) {
        for (uint32_t i = offset; i < offset + size; i++)
            sum += big[i];
    } else if (mode == MSHR_MODE_SPARSE) {
        for (uint32_t r = 0; r < MSHR_SPARSE_REPS; r++)
            for (uint32_t i = offset + r; i < offset + size; i += MSHR_LINE_WORDS)
                sum += big[i];
    } else if (mode == MSHR_MODE_STRIDE_WAY || mode == MSHR_MODE_STRIDE_LINE) {
        for (uint32_t j = 0; j < MSHR_STRIDE_ACC; j++)
            sum += big[mshr_stride_index(mode, id, j)];
    } else {
        for (uint32_t j = 0; j < MSHR_RANDOM_ACC; j++)
            sum += big[mshr_lcg_next(&lcg)];
    }

    p->cycles[id] = read_mcycle() - start;
    partial[id]   = sum;
    pi_cl_team_barrier();
}

int dcache_mshr_test_task(void *data) {
    pi_cl_team_fork(PULP_CORE_COUNT, dcache_mshr_fork_entry, data);
    return 0;
}
