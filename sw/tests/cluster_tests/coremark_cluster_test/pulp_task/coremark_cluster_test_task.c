/*
 * Copyright (C) 2026 Fondazione Chips-IT
 * SPDX-License-Identifier: Apache-2.0
 *
 * Authors: Niccolò Giuliani <niccolo.giuliani@chips.it>
 *
 * Cluster task of coremark_cluster_test: each of the 8 PULP cores runs one CoreMark context on its own data.
 * The timed body is iterate() of EEMBC core_main.c, copied verbatim, and the three workloads come from the
 * unchanged EEMBC sources; the control core does the initialization and checks the CRCs.
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "cluster_utils.h"
#include "bench_utils.h"
#include "../coremark_cluster_test.h"

#pragma GCC optimize("no-branch-count-reg")

/* The EEMBC workloads. core_portme.c is NOT included: it drives the cache registers, which belong to the
 * control core; the cluster side only needs ee_printf for the error paths. */
#include "../../../coremark/coremark.h"

int ee_printf(const char *fmt, ...) {
    (void)fmt;
    return 0;
}

#include "../../../coremark/core_list_join.c"
#include "../../../coremark/core_matrix.c"
#pragma GCC push_options
#pragma GCC optimize("no-tree-loop-optimize")
#include "../../../coremark/core_state.c"
#pragma GCC pop_options
#include "../../../coremark/core_util.c"

/* EEMBC core_main.c iterate(), verbatim */
void *iterate(void *pres) {
    ee_u32        i;
    ee_u16        crc;
    core_results *res        = (core_results *)pres;
    ee_u32        iterations = res->iterations;
    res->crc                 = 0;
    res->crclist             = 0;
    res->crcmatrix           = 0;
    res->crcstate            = 0;

    for (i = 0; i < iterations; i++) {
        crc      = core_bench_list(res, 1);
        res->crc = crcu16(crc, res->crc);
        crc      = core_bench_list(res, -1);
        res->crc = crcu16(crc, res->crc);
        if (i == 0)
            res->crclist = res->crc;
    }
    return NULL;
}

static void coremark_fork_entry(void *arg) {
    volatile coremark_cluster_params_t *p = (volatile coremark_cluster_params_t *)arg;
    uint32_t id  = pi_core_id();
    core_results *res = (core_results *)(p->results + id * sizeof(core_results));

    asm volatile("csrw mcountinhibit, zero");
    pi_cl_team_barrier();
    uint32_t start = read_mcycle();
    iterate(res);
    p->cycles[id] = read_mcycle() - start;
    pi_cl_team_barrier();
}

int coremark_cluster_test_task(void *data) {
    pi_cl_team_fork(PULP_CORE_COUNT, coremark_fork_entry, data);
    return 0;
}
