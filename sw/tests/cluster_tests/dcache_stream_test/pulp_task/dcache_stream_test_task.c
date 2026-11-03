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
 * Cluster task of dcache_stream_test: the 8 PULP cores run one kernel on the L2 arrays, either straight to the
 * L2 (with or without the cache) or on tiles that core 0 stages in the L1 SPM with the iDMA, double buffered.
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "cluster_utils.h"
#include "idma_mm_utils.h"
#include "../dcache_stream_test.h"

// GCC 14 crashes ("could not split insn", doloop_begin_i) on the cv32e40p hardware loop of the big loops
#pragma GCC optimize("no-branch-count-reg")

static inline uint32_t read_mcycle(void) {
    uint32_t cycles;
    asm volatile("csrr %0, mcycle" : "=r"(cycles));
    return cycles;
}

static inline void wait_in(uint32_t id) {
    while ((int32_t)(idma_mm_get_done_id_dir(0, 0) - id) < 0);
}

static inline void wait_out(uint32_t id) {
    while ((int32_t)(idma_mm_get_done_id_dir(1, 0) - id) < 0);
}

/* Buffer of stream s, half d: the streams of a kernel follow each other, two halves each */
static inline uint32_t stream_buf(volatile dcache_stream_params_t *p, uint32_t s, int d) {
    return p->spm + (2 * s + d) * p->tile_words * 4;
}

/* L2 variants (direct and cache): every core on its own chunk of the arrays */
static uint32_t stream_l2(volatile dcache_stream_params_t *p, uint32_t id) {
    volatile uint32_t *a   = (volatile uint32_t *)p->a;
    volatile uint32_t *b   = (volatile uint32_t *)p->b;
    volatile uint32_t *c   = (volatile uint32_t *)p->c;
    volatile uint32_t *idx = (volatile uint32_t *)p->idx;
    uint32_t off  = cluster_chunk_offset(p->n_words, PULP_CORE_COUNT, id);
    uint32_t size = cluster_chunk_size(p->n_words, PULP_CORE_COUNT, id);
    uint32_t sum  = 0;

    if (p->kernel == STREAM_K_TRIAD) {
        for (uint32_t j = off; j < off + size; j++)
            a[j] = b[j] + STREAM_SCALAR * c[j];
    } else if (p->kernel == STREAM_K_GATHER) {
        for (uint32_t j = off; j < off + size; j++)
            sum += a[idx[j]];
    } else {
        for (uint32_t j = off; j < off + size; j++)
            c[idx[j]] = a[j];
    }
    return sum;
}

/* Called by stream_idma on core 0: the input streams of tile t into the half d, returns the last transfer */
static uint32_t stream_stage_in(volatile dcache_stream_params_t *p, int t, int d) {
    uint32_t bytes = p->tile_words * 4;
    uint32_t off   = t * bytes;
    uint32_t id    = 0;

    if (p->kernel == STREAM_K_TRIAD) {
        id = idma_L2ToL1(p->b + off, stream_buf(p, 0, d), bytes);
        id = idma_L2ToL1(p->c + off, stream_buf(p, 1, d), bytes);
    } else if (p->kernel == STREAM_K_GATHER) {
        id = idma_L2ToL1(p->idx + off, stream_buf(p, 0, d), bytes);
    } else {
        id = idma_L2ToL1(p->a + off, stream_buf(p, 0, d), bytes);
        id = idma_L2ToL1(p->idx + off, stream_buf(p, 1, d), bytes);
    }
    return id;
}

/* Called by stream_idma on core 0: the result tile of triad back to the L2 */
static uint32_t stream_stage_out(volatile dcache_stream_params_t *p, int t, int d) {
    uint32_t bytes = p->tile_words * 4;
    return idma_L1ToL2(stream_buf(p, 2, d), p->a + t * bytes, bytes);
}

/* Called by stream_idma: the share of core `id` of the tile in half d. The irregular array stays in the L2:
 * the iDMA can stage the indices and the sequential operands, not the gather or the scatter itself. */
static uint32_t stream_tile(volatile dcache_stream_params_t *p, int t, int d, uint32_t id) {
    uint32_t per   = p->tile_words / PULP_CORE_COUNT;
    uint32_t first = id * per;
    uint32_t sum   = 0;

    if (p->kernel == STREAM_K_TRIAD) {
        volatile uint32_t *b_buf = (volatile uint32_t *)stream_buf(p, 0, d);
        volatile uint32_t *c_buf = (volatile uint32_t *)stream_buf(p, 1, d);
        volatile uint32_t *a_buf = (volatile uint32_t *)stream_buf(p, 2, d);
        for (uint32_t k = first; k < first + per; k++)
            a_buf[k] = b_buf[k] + STREAM_SCALAR * c_buf[k];
    } else if (p->kernel == STREAM_K_GATHER) {
        volatile uint32_t *i_buf = (volatile uint32_t *)stream_buf(p, 0, d);
        volatile uint32_t *a     = (volatile uint32_t *)p->a;
        for (uint32_t k = first; k < first + per; k++)
            sum += a[i_buf[k]];
    } else {
        volatile uint32_t *a_buf = (volatile uint32_t *)stream_buf(p, 0, d);
        volatile uint32_t *i_buf = (volatile uint32_t *)stream_buf(p, 1, d);
        volatile uint32_t *c     = (volatile uint32_t *)p->c;
        for (uint32_t k = first; k < first + per; k++)
            c[i_buf[k]] = a_buf[k];
    }
    return sum;
}

/* iDMA variant: core 0 keeps the next tile coming while the team works on the current one */
static uint32_t stream_idma(volatile dcache_stream_params_t *p, uint32_t id) {
    int      tiles    = p->n_words / p->tile_words;
    int      writes   = (p->kernel == STREAM_K_TRIAD);
    uint32_t in_id[2] = {0, 0}, out_id[2] = {0, 0};
    uint32_t sum      = 0;

    if (id == 0)
        in_id[0] = stream_stage_in(p, 0, 0);
    for (int t = 0; t < tiles; t++) {
        int d = t & 1, n = d ^ 1;
        if (id == 0) {
            wait_in(in_id[d]);
            if (t + 1 < tiles) {
                // The half n still holds the result tile of t - 1 until the iDMA has taken it
                if (writes && t >= 1)
                    wait_out(out_id[n]);
                in_id[n] = stream_stage_in(p, t + 1, n);
            }
        }
        pi_cl_team_barrier();
        sum += stream_tile(p, t, d, id);
        pi_cl_team_barrier();
        if (id == 0 && writes)
            out_id[d] = stream_stage_out(p, t, d);
    }
    if (id == 0 && writes)
        wait_out(out_id[(tiles - 1) & 1]);
    return sum;
}

static void dcache_stream_fork_entry(void *arg) {
    volatile dcache_stream_params_t *p = (volatile dcache_stream_params_t *)arg;
    volatile uint32_t *partial = (volatile uint32_t *)p->partial;
    uint32_t id  = pi_core_id();
    uint32_t sum = 0;

    asm volatile("csrw mcountinhibit, zero");
    pi_cl_team_barrier();
    uint32_t start = read_mcycle();

    if (p->variant == STREAM_VAR_IDMA)
        sum = stream_idma(p, id);
    else
        sum = stream_l2(p, id);

    p->cycles[id] = read_mcycle() - start;
    partial[id]   = sum;
    pi_cl_team_barrier();
}

int dcache_stream_test_task(void *data) {
    pi_cl_team_fork(PULP_CORE_COUNT, dcache_stream_fork_entry, data);
    return 0;
}
