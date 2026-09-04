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
 * linalg_cholesky_decomp — PLAY task wrapper for the MAGIA PULP cluster.
 * Same shape as vector_add_task.c; linalg_cholesky_decomp(src, dst, dim)
 * computes the Cholesky decomposition of a dim x dim matrix.
 */

#include "magia_tile_utils.h"
#include "cluster_utils.h"
#include "stats.h"

#include "../../../../../../../PLAY/source/linalg_cholesky_decomp/linalg_cholesky_decomp.c"
#include "../../../../../../../PLAY/source/linalg_cholesky_decomp/arch/linalg_cholesky_decomp_pulp_open.c"

typedef struct {
    uint32_t src;
    uint32_t dst;
    uint32_t dim;
} linalg_cholesky_decomp_params_t;

static void linalg_cholesky_decomp_fork_entry(void *arg) {
    linalg_cholesky_decomp_params_t *p = (linalg_cholesky_decomp_params_t *)arg;

    /* Align all cores before the timed region, matching PLAY's own
     * test harness (test/common/utils.c barrier(), called before
     * INIT_STATS()/after END_LOOP_STATS() in every PLAY pulp-open
     * run_test()) -- without it, cores can enter their own
     * START_STATS() at different real times (fork/dispatch skew),
     * making the stats not directly comparable to PLAY's own
     * numbers. Confirmed NOT the cause of the stats=1 hang seen on this
     * kernel (removing it didn't help -- see PIC_CALL_OVERHEAD.md /
     * conversation history): the real cause is HOTTING+REPEAT calling
     * this in-place kernel 5x on the same buffer without re-init between
     * calls. */
    pi_cl_team_barrier();

    INIT_STATS();
    START_LOOP_STATS();
    START_STATS();
    linalg_cholesky_decomp((const float *)p->src, (float *)p->dst,
                            (int)p->dim);
    STOP_STATS();
    END_LOOP_STATS();
    pi_cl_team_barrier();
}

int linalg_cholesky_decomp_task(void *data) {
    linalg_cholesky_decomp_params_t *params =
        (linalg_cholesky_decomp_params_t *)data;
    pi_cl_team_fork(PULP_CORE_COUNT, linalg_cholesky_decomp_fork_entry, params);
    return 0;
}
