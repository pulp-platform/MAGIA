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
 * Cluster task of raiderstream_cluster_test: the 8 PULP cores run one of the 16 kernels of
 * sw/tests/raiderstream_kernels.h, either straight to the L2 (cache on or off) or on tiles that core 0
 * stages in the L1 SPM, double buffered.
 *
 * Every kernel writes through j or through idx[j], and the index arrays are permutations, so giving each
 * core a contiguous range of j is enough to keep the cores out of each other's way. There is nothing to
 * reduce at the end, which is why no core returns a partial result.
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "cluster_utils.h"
#include "bench_utils.h"
#include "../raiderstream_cluster_test.h"

/* L2 variants: every core on its own contiguous chunk of the arrays */
static void run_whole_arrays(volatile rsc_params_t *p, uint32_t id) {
    volatile uint32_t *ptr[R_NUM];
    uint32_t lo = cluster_chunk_offset(p->n_words, PULP_CORE_COUNT, id);
    uint32_t hi = lo + cluster_chunk_size(p->n_words, PULP_CORE_COUNT, id);

    for (int r = 0; r < R_NUM; r++)
        ptr[r] = (volatile uint32_t *)p->role[r];
    rs_kernel(p->group, p->op, ptr, lo, hi);
}

/* Buffers one after the other from the start of the SPM, two halves each. The offset is the same in both
 * views of the L1: the core adds spm, the iDMA adds spm_loc. */
#define BUF_OFF(s, d, tile_bytes) (((2 * (s)) + (d)) * (tile_bytes))

/* Where each role lives, per half. A staged role points into its buffer and is indexed from 0, an irregular
 * one keeps its L2 address. Worked out BEFORE the clock starts: deciding what the iDMA may stage is
 * inspection, not transfer, and on the short kernels it is worth a few percent, which is the size of the
 * effects being measured. */
static void bind_roles(volatile rsc_params_t *p, const rs_plan_t *pl, volatile uint32_t *ptr[2][R_NUM]) {
    uint32_t tile_bytes = p->tile_words * 4;

    for (int d = 0; d < 2; d++)
        for (int r = 0; r < R_NUM; r++)
            ptr[d][r] = (volatile uint32_t *)((pl->role_buf[r] >= 0)
                                              ? p->spm + BUF_OFF(pl->role_buf[r], d, tile_bytes)
                                              : p->role[r]);
}

/* iDMA variant: core 0 keeps the next tile coming while the team works on the current one, and every core
 * takes its share inside the tile. One iDMA for the whole tile is the point of the comparison: the staging
 * is serialized on core 0 while the cache would serve all eight at once. */
static void run_tiled(volatile rsc_params_t *p, uint32_t id, const rs_plan_t *pl,
                      volatile uint32_t *ptr[2][R_NUM]) {
    uint32_t tile_bytes = p->tile_words * 4;
    uint32_t tiles      = p->n_words / p->tile_words;
    uint32_t per        = p->tile_words / PULP_CORE_COUNT;
    uint32_t lo         = id * per;
    uint32_t in_id[2] = {0, 0}, out_id[2] = {0, 0};

    if (id == 0)
        for (uint32_t s = 0; s < pl->n_in; s++)
            in_id[0] = idma_in(p->role[pl->in_role[s]], p->spm_loc + BUF_OFF(s, 0, tile_bytes),
                               tile_bytes);
    for (uint32_t t = 0; t < tiles; t++) {
        int d = t & 1, n = d ^ 1;

        if (id == 0) {
            idma_wait_in(in_id[d]);
            if (t + 1 < tiles) {
                /* Half n still holds the result tile of t-1 until the iDMA has taken it away */
                if (pl->out_role >= 0 && t >= 1)
                    idma_wait_out(out_id[n]);
                for (uint32_t s = 0; s < pl->n_in; s++)
                    in_id[n] = idma_in(p->role[pl->in_role[s]] + (t + 1) * tile_bytes,
                                       p->spm_loc + BUF_OFF(s, n, tile_bytes), tile_bytes);
            }
        }
        pi_cl_team_barrier();
        rs_kernel(p->group, p->op, ptr[d], lo, lo + per);
        pi_cl_team_barrier();
        if (id == 0 && pl->out_role >= 0)
            out_id[d] = idma_out(p->spm_loc + BUF_OFF(pl->n_in, d, tile_bytes),
                                 p->role[pl->out_role] + t * tile_bytes, tile_bytes);
    }
    if (id == 0 && pl->out_role >= 0)
        idma_wait_out(out_id[(tiles - 1) & 1]);
}

static void rsc_fork_entry(void *arg) {
    volatile rsc_params_t *p = (volatile rsc_params_t *)arg;
    uint32_t  id = pi_core_id();
    rs_plan_t pl;
    volatile uint32_t *ptr[2][R_NUM];
    int tiled = 0;

    asm volatile("csrw mcountinhibit, zero");
    /* Everything that is inspection and not work, before the clock starts */
    if (p->variant == RSC_VAR_IDMA && rs_plan(p->group, p->op, &pl)) {
        bind_roles(p, &pl, ptr);
        tiled = 1;
    }
    pi_cl_team_barrier();
    uint32_t start = read_mcycle();

    if (tiled)
        run_tiled(p, id, &pl, ptr);
    else if (p->variant != RSC_VAR_IDMA)
        run_whole_arrays(p, id);

    p->cycles[id] = read_mcycle() - start;
    pi_cl_team_barrier();
}

int raiderstream_cluster_test_task(void *data) {
    pi_cl_team_fork(PULP_CORE_COUNT, rsc_fork_entry, data);
    return 0;
}
