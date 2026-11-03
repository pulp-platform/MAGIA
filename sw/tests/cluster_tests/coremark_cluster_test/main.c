/*
 * Copyright (C) 2026 Fondazione Chips-IT
 * SPDX-License-Identifier: Apache-2.0
 *
 * Authors: Niccolò Giuliani <niccolo.giuliani@chips.it>
 *
 * coremark_cluster_test - CoreMark on the 8 PULP cores as eight independent contexts, one per core, each on
 * its own 2 KiB of data. CoreMark is single threaded by construction, so eight instances is the only honest
 * way to load eight cores with it; the number reported is therefore cycles per context, not a CoreMark score
 * (an official score also needs a run of at least 10 s, which a simulation does not do).
 * The data of the contexts lives in the L2 (COREMARK_MEM=1 through the cache, 2 with the cache off) or in the
 * L1 SPM (COREMARK_MEM=0), exactly as in sw/tests/coremark/coremark_test.c for one core.
 * The control core initializes the contexts with the unchanged EEMBC routines, dispatches the team and checks
 * the CRCs of every context against the known ones of the 2K profile.
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "magia_dcache_utils.h"
#include "cluster_utils.h"
#include "coremark_cluster_test.h"
#include "coremark_cluster_test_pulp_task_bin.h"

#pragma GCC optimize("no-branch-count-reg")

#include "../../coremark/coremark.h"
#include "../../coremark/core_portme.c"
#include "../../coremark/core_list_join.c"
#include "../../coremark/core_matrix.c"
#pragma GCC push_options
#pragma GCC optimize("no-tree-loop-optimize")
#include "../../coremark/core_state.c"
#pragma GCC pop_options
#include "../../coremark/core_util.c"

#ifndef ARENA_STRIDE
#define ARENA_STRIDE (0x00040000)
#endif
#ifndef BUDGET_KIB
#define BUDGET_KIB   (32)                     /* the eight contexts are 16 KiB in all: they fit a way budget */
#endif

#define CTX          (PULP_CORE_COUNT)
#define ARENA        (0xCC200000u + magia_tile_id() * ARENA_STRIDE)

#define PARAMS_OFF   (0)
#define STATE_OFF    (0x400)
#define RESULTS_OFF  (0x800)                  /* core_results[8] */
#define SPM_DATA_OFF (0x4000)                 /* the contexts when COREMARK_MEM = 0 */
#define PARAMS       L1_GLOBAL(PARAMS_OFF)
#define STATE        L1_GLOBAL(STATE_OFF)
#define RESULTS      L1_GLOBAL(RESULTS_OFF)
#define SPM_DATA     L1_GLOBAL(SPM_DATA_OFF)

#define errors       (*(volatile uint32_t *)(STATE + 0))

/* The known CRCs of EEMBC core_main.c for this profile: seeds 0, 0, 0x66 and 666 bytes per algorithm give
 * seedcrc 0xe9f5, which is entry 3 of list_known_crc, matrix_known_crc and state_known_crc. They are the
 * same values the single core run of sw/tests/coremark prints. */
#define KNOWN_LIST   (0xe714)
#define KNOWN_MATRIX (0x1fd7)
#define KNOWN_STATE  (0x8e3a)
#define KNOWN_FINAL  (0xe714)

/* bench_utils.h is deliberately not included here: core_portme.c of the EEMBC port already defines its own
 * read_mcycle, and two definitions of it in one translation unit do not compile. The task side does use the
 * shared header. */
static inline uint32_t read_mcycle_m(void) {
    uint32_t cycles;
    asm volatile("csrr %0, mcycle" : "=r"(cycles));
    return cycles;
}

static void check(const char *what, uint32_t ctx, uint32_t got, uint32_t expected) {
    if (got != expected) {
        printf("[FAIL] context %d %s: got 0x%x, expected 0x%x\n", (int)ctx, what, (unsigned)got,
               (unsigned)expected);
        errors = errors + 1;
    }
}

static uint32_t max_cycles(volatile coremark_cluster_params_t *p) {
    uint32_t max = 0;
    for (int c = 0; c < PULP_CORE_COUNT; c++)
        if (p->cycles[c] > max)
            max = p->cycles[c];
    return max;
}

/* One context per core: its memblock, the three workloads initialized on it */
static void init_contexts(void) {
    core_results *res = (core_results *)RESULTS;
    ee_u32 base = (COREMARK_MEM == 0) ? SPM_DATA : ARENA;
    ee_u32 size;

    for (uint32_t i = 0; i < CTX; i++) {
        res[i].memblock[0] = (void *)(base + i * TOTAL_DATA_SIZE);
        res[i].size        = TOTAL_DATA_SIZE;
        res[i].seed1       = 0;
        res[i].seed2       = 0;
        res[i].seed3       = 0x66;
        res[i].iterations  = ITERATIONS;
        res[i].execs       = ALL_ALGORITHMS_MASK;
        res[i].err         = 0;
    }
    size = TOTAL_DATA_SIZE / 3;               /* three algorithms, as EEMBC core_main does */
    for (uint32_t i = 0; i < CTX; i++) {
        res[i].size        = size;
        res[i].memblock[1] = (char *)res[i].memblock[0];
        res[i].memblock[2] = (char *)res[i].memblock[0] + size;
        res[i].memblock[3] = (char *)res[i].memblock[0] + 2 * size;
        res[i].list = core_list_init(size, res[i].memblock[1], res[i].seed1);
        core_init_matrix(size, res[i].memblock[2],
                         (ee_s32)res[i].seed1 | (((ee_s32)res[i].seed2) << 16), &(res[i].mat));
        core_init_state(size, res[i].seed1, res[i].memblock[3]);
    }
}

int main(void) {
    volatile coremark_cluster_params_t *p = (volatile coremark_cluster_params_t *)PARAMS;
    core_results *res = (core_results *)RESULTS;
    uint32_t spm_base, spm_size, way_bytes, ways, t;
    dcache_perf_t perf;

    asm volatile("csrw mcountinhibit, zero");
    errors = 0;

    printf("coremark_cluster: %d contexts, mem=%d (%s), %d iterations, dcache %d ways x %d sets\n",
           CTX, COREMARK_MEM, MEM_LOCATION, ITERATIONS, (int)dcache_num_ways(), MAGIA_DCACHE_SETS);
    if (!dcache_geometry_ok()) {
        printf("[FAIL] geometry\n");
        return 1;
    }

    cluster_boot(PULP_BINARY_START);
    dcache_enable(1);
    dcache_set_prefetch(0);
    init_contexts();
    dcache_flush();

    p->results = RESULTS;
    way_bytes  = L1_DCACHE_SIZE / dcache_num_ways();
    ways       = (BUDGET_KIB * 1024) / way_bytes;
    if (COREMARK_MEM == 2) {
        dcache_enable(0);
    } else if (COREMARK_MEM == 1 && ways && ways <= dcache_num_ways()) {
        dcache_set_ways(ways, &spm_base, &spm_size);
        dcache_set_prefetch(COREMARK_PF);
    }
    dcache_perf_start();
    cluster_arm_done_event();
    t = read_mcycle_m();
    cluster_dispatch_task_with_params(COREMARK_CLUSTER_TEST_TASK, (uint32_t)p);
    cluster_wait_done_eu();
    t = read_mcycle_m() - t;
    dcache_perf_stop();
    dcache_perf_read(&perf);
    dcache_enable(1);
    dcache_set_prefetch(0);
    dcache_set_ways(dcache_num_ways(), &spm_base, &spm_size);

    if (cluster_task_crashed()) {
        printf("[FAIL] cluster task trapped (mcause=0x%08x)\n", (unsigned)cluster_get_mcause());
        return 1;
    }
    dcache_flush();
    for (uint32_t i = 0; i < CTX; i++) {
        check("crclist", i, res[i].crclist, KNOWN_LIST);
        check("crcmatrix", i, res[i].crcmatrix, KNOWN_MATRIX);
        check("crcstate", i, res[i].crcstate, KNOWN_STATE);
        check("crc", i, res[i].crc, KNOWN_FINAL);
    }
    printf("COREMARK_CLUSTER contexts=%d mem=%d pf=%d iterations=%d budget=%d cycles=%u per_context=%u "
           "hit_r=%d miss_r=%d hit_w=%d miss_w=%d refill=%d wb=%d\n",
           CTX, COREMARK_MEM, COREMARK_PF, ITERATIONS, (COREMARK_MEM == 1) ? BUDGET_KIB : 0,
           (unsigned)t, (unsigned)max_cycles(p), (int)perf.hit_r, (int)perf.miss_r, (int)perf.hit_w,
           (int)perf.miss_w, (int)perf.refill, (int)perf.writeback);
    printf("coremark_cluster_test: %d errors\n", (int)errors);
    return errors;
}
