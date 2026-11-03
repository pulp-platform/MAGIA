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
 * The 16 RaiderSTREAM kernels (github.com/michael-beebe/RaiderSTREAM, the loops of its OpenMP
 * implementation), on uint32 instead of double because there is no FPU, with the STREAM scalar 3.
 *
 * One definition, shared by the two tests that run them:
 *   sw/tests/raiderstream_test.c                              on the control core
 *   sw/tests/cluster_tests/raiderstream_cluster_test/         on the 8 cluster cores
 * They used to have a copy each, which is two places to keep in step and two places to read.
 *
 * Every kernel is a single loop over [lo, hi) and takes its six arrays through the same `p[]`, indexed by
 * role. That is what lets one call site serve both transports: in the L2 variants p[] holds the L2 arrays
 * and [lo, hi) is the share of this core, in the iDMA variant the staged streams point into the L1 buffers
 * and [lo, hi) is the share of this core inside the tile.
 */

#ifndef RAIDERSTREAM_KERNELS_H
#define RAIDERSTREAM_KERNELS_H

#include <stdint.h>

/* These two belong here and not in the including file: a #pragma after the #include would leave the kernels
 * compiled differently from the rest, and the difference is not small. Measured on 2026-11-03, by mistake:
 * with the hardware loop of the CV32 left on, the kernels run up to 36% faster, which silently invalidates
 * every number of a campaign. GCC 14 also goes into an internal error ("could not split insn",
 * doloop_begin_i) on the hardware loop of the long preparation loops, which is the other reason it is off.
 * align-loops is what makes every variant run the same loop at the same alignment. */
#pragma GCC optimize("no-branch-count-reg")
#pragma GCC optimize("align-loops=4")

#define RS_SCALAR (3u)

/* The six arrays, by role. RaiderSTREAM names them a, b, c and idx1..idx3. */
enum { R_A = 0, R_B = 1, R_C = 2, R_I1 = 3, R_I2 = 4, R_I3 = 5, R_NUM = 6 };

/* A kernel is a group (how it accesses) times an operation (what it computes) */
enum { G_SEQ = 0, G_GATHER = 1, G_SCATTER = 2, G_SG = 3, G_NUM = 4 };
enum { OP_COPY = 0, OP_SCALE = 1, OP_ADD = 2, OP_TRIAD = 3, OP_NUM = 4 };

/* Not inlined and aligned: every variant must run the same loop, laid out the same way, or a few percent of
 * difference could come from the compiler instead of from the cache. */
#define RS_KERNEL __attribute__((noinline, aligned(4)))

/* What a kernel needs from the transport, so that the iDMA variant knows what it may stage:
 *   in0, in1  the sequential inputs, -1 if none
 *   out       the array written sequentially, -1 if the kernel writes through idx (so it stays in L2)
 *   ni        how many index arrays it uses, I1 first
 * Whatever is not listed here is irregular and can only be reached where it already is. */
typedef struct {
    const char *name;
    int8_t      in0, in1;
    int8_t      out;
    uint8_t     ni;
} rs_row_t;

static const rs_row_t rs_rows[G_NUM][OP_NUM] = {
    {{"seq_copy",     R_A, -1,  R_C, 0}, {"seq_scale",     R_C, -1,  R_B, 0},
     {"seq_add",      R_A, R_B, R_C, 0}, {"seq_triad",     R_B, R_C, R_A, 0}},
    {{"gather_copy",  -1,  -1,  R_C, 1}, {"gather_scale",  -1,  -1,  R_B, 1},
     {"gather_add",   -1,  -1,  R_C, 2}, {"gather_triad",  -1,  -1,  R_A, 2}},
    {{"scatter_copy", R_A, -1,  -1,  1}, {"scatter_scale", R_C, -1,  -1,  1},
     {"scatter_add",  R_A, R_B, -1,  1}, {"scatter_triad", R_B, R_C, -1,  1}},
    {{"sg_copy",      -1,  -1,  -1,  2}, {"sg_scale",      -1,  -1,  -1,  2},
     {"sg_add",       -1,  -1,  -1,  3}, {"sg_triad",      -1,  -1,  -1,  3}},
};

static const char *const rs_group_name[G_NUM] = {"seq", "gather", "scatter", "sg"};

/////////////
// Kernels //
/////////////

RS_KERNEL static void rs_seq_copy(volatile uint32_t *av, volatile uint32_t *cv, uint32_t lo, uint32_t hi) {
    for (uint32_t j = lo; j < hi; j++)
        cv[j] = av[j];
}

RS_KERNEL static void rs_seq_scale(volatile uint32_t *cv, volatile uint32_t *bv, uint32_t lo, uint32_t hi) {
    for (uint32_t j = lo; j < hi; j++)
        bv[j] = RS_SCALAR * cv[j];
}

RS_KERNEL static void rs_seq_add(volatile uint32_t *av, volatile uint32_t *bv, volatile uint32_t *cv,
                                 uint32_t lo, uint32_t hi) {
    for (uint32_t j = lo; j < hi; j++)
        cv[j] = av[j] + bv[j];
}

RS_KERNEL static void rs_seq_triad(volatile uint32_t *bv, volatile uint32_t *cv, volatile uint32_t *av,
                                   uint32_t lo, uint32_t hi) {
    for (uint32_t j = lo; j < hi; j++)
        av[j] = bv[j] + RS_SCALAR * cv[j];
}

RS_KERNEL static void rs_gather_copy(volatile uint32_t *av, volatile uint32_t *i1, volatile uint32_t *cv,
                                     uint32_t lo, uint32_t hi) {
    for (uint32_t j = lo; j < hi; j++)
        cv[j] = av[i1[j]];
}

RS_KERNEL static void rs_gather_scale(volatile uint32_t *cv, volatile uint32_t *i1, volatile uint32_t *bv,
                                      uint32_t lo, uint32_t hi) {
    for (uint32_t j = lo; j < hi; j++)
        bv[j] = RS_SCALAR * cv[i1[j]];
}

RS_KERNEL static void rs_gather_add(volatile uint32_t *av, volatile uint32_t *bv, volatile uint32_t *i1,
                                    volatile uint32_t *i2, volatile uint32_t *cv, uint32_t lo, uint32_t hi) {
    for (uint32_t j = lo; j < hi; j++)
        cv[j] = av[i1[j]] + bv[i2[j]];
}

RS_KERNEL static void rs_gather_triad(volatile uint32_t *bv, volatile uint32_t *cv, volatile uint32_t *i1,
                                      volatile uint32_t *i2, volatile uint32_t *av, uint32_t lo, uint32_t hi) {
    for (uint32_t j = lo; j < hi; j++)
        av[j] = bv[i1[j]] + RS_SCALAR * cv[i2[j]];
}

RS_KERNEL static void rs_scatter_copy(volatile uint32_t *av, volatile uint32_t *i1, volatile uint32_t *cv,
                                      uint32_t lo, uint32_t hi) {
    for (uint32_t j = lo; j < hi; j++)
        cv[i1[j]] = av[j];
}

RS_KERNEL static void rs_scatter_scale(volatile uint32_t *cv, volatile uint32_t *i1, volatile uint32_t *bv,
                                       uint32_t lo, uint32_t hi) {
    for (uint32_t j = lo; j < hi; j++)
        bv[i1[j]] = RS_SCALAR * cv[j];
}

RS_KERNEL static void rs_scatter_add(volatile uint32_t *av, volatile uint32_t *bv, volatile uint32_t *i1,
                                     volatile uint32_t *cv, uint32_t lo, uint32_t hi) {
    for (uint32_t j = lo; j < hi; j++)
        cv[i1[j]] = av[j] + bv[j];
}

RS_KERNEL static void rs_scatter_triad(volatile uint32_t *bv, volatile uint32_t *cv, volatile uint32_t *i1,
                                       volatile uint32_t *av, uint32_t lo, uint32_t hi) {
    for (uint32_t j = lo; j < hi; j++)
        av[i1[j]] = bv[j] + RS_SCALAR * cv[j];
}

RS_KERNEL static void rs_sg_copy(volatile uint32_t *av, volatile uint32_t *i1, volatile uint32_t *i2,
                                 volatile uint32_t *cv, uint32_t lo, uint32_t hi) {
    for (uint32_t j = lo; j < hi; j++)
        cv[i1[j]] = av[i2[j]];
}

RS_KERNEL static void rs_sg_scale(volatile uint32_t *cv, volatile uint32_t *i1, volatile uint32_t *i2,
                                  volatile uint32_t *bv, uint32_t lo, uint32_t hi) {
    for (uint32_t j = lo; j < hi; j++)
        bv[i2[j]] = RS_SCALAR * cv[i1[j]];
}

RS_KERNEL static void rs_sg_add(volatile uint32_t *av, volatile uint32_t *bv, volatile uint32_t *i1,
                                volatile uint32_t *i2, volatile uint32_t *i3, volatile uint32_t *cv,
                                uint32_t lo, uint32_t hi) {
    for (uint32_t j = lo; j < hi; j++)
        cv[i1[j]] = av[i2[j]] + bv[i3[j]];
}

RS_KERNEL static void rs_sg_triad(volatile uint32_t *bv, volatile uint32_t *cv, volatile uint32_t *i1,
                                  volatile uint32_t *i2, volatile uint32_t *i3, volatile uint32_t *av,
                                  uint32_t lo, uint32_t hi) {
    for (uint32_t j = lo; j < hi; j++)
        av[i1[j]] = bv[i2[j]] + RS_SCALAR * cv[i3[j]];
}

/* The one call site: kernel (g, op) on [lo, hi), with the six arrays already bound by role */
static void rs_kernel(uint32_t g, uint32_t op, volatile uint32_t *const p[R_NUM], uint32_t lo, uint32_t hi) {
    volatile uint32_t *a  = p[R_A],  *b  = p[R_B],  *c  = p[R_C];
    volatile uint32_t *i1 = p[R_I1], *i2 = p[R_I2], *i3 = p[R_I3];

    if (g == G_SEQ) {
        if (op == OP_COPY)  rs_seq_copy(a, c, lo, hi);
        if (op == OP_SCALE) rs_seq_scale(c, b, lo, hi);
        if (op == OP_ADD)   rs_seq_add(a, b, c, lo, hi);
        if (op == OP_TRIAD) rs_seq_triad(b, c, a, lo, hi);
    } else if (g == G_GATHER) {
        if (op == OP_COPY)  rs_gather_copy(a, i1, c, lo, hi);
        if (op == OP_SCALE) rs_gather_scale(c, i1, b, lo, hi);
        if (op == OP_ADD)   rs_gather_add(a, b, i1, i2, c, lo, hi);
        if (op == OP_TRIAD) rs_gather_triad(b, c, i1, i2, a, lo, hi);
    } else if (g == G_SCATTER) {
        if (op == OP_COPY)  rs_scatter_copy(a, i1, c, lo, hi);
        if (op == OP_SCALE) rs_scatter_scale(c, i1, b, lo, hi);
        if (op == OP_ADD)   rs_scatter_add(a, b, i1, c, lo, hi);
        if (op == OP_TRIAD) rs_scatter_triad(b, c, i1, a, lo, hi);
    } else {
        if (op == OP_COPY)  rs_sg_copy(a, i1, i2, c, lo, hi);
        if (op == OP_SCALE) rs_sg_scale(c, i1, i2, b, lo, hi);
        if (op == OP_ADD)   rs_sg_add(a, b, i1, i2, i3, c, lo, hi);
        if (op == OP_TRIAD) rs_sg_triad(b, c, i1, i2, i3, a, lo, hi);
    }
}

/////////////////////////////////////////////
// What the iDMA variant is allowed to stage //
/////////////////////////////////////////////

#define RS_MAX_STREAMS (4)                    /* at most 3 staged inputs plus the result tile */

/* The plan of the iDMA variant for one kernel: which arrays go to L1 and in which buffer each one lands.
 * The buffers follow the inputs in order and the result tile is last, so buffer k holds in_role[k] and
 * buffer n_in holds out_role. A role not listed is irregular and stays in the L2. */
typedef struct {
    uint32_t n_in;
    int8_t   in_role[RS_MAX_STREAMS];
    int8_t   out_role;                        /* -1: the kernel writes through idx, straight to the L2 */
    uint32_t n_streams;                       /* buffers needed: n_in, plus one if out_role >= 0 */
    int8_t   role_buf[R_NUM];                 /* buffer of each role, -1 if it stays in the L2 */
} rs_plan_t;

/* Returns 0 if the kernel has no iDMA variant: scatter-gather is irregular at both ends, so there is no
 * sequential stream to put in a tile and the question does not arise. */
static int rs_plan(uint32_t g, uint32_t op, rs_plan_t *pl) {
    const rs_row_t *r = &rs_rows[g][op];

    for (int i = 0; i < R_NUM; i++)
        pl->role_buf[i] = -1;
    pl->n_in     = 0;
    pl->out_role = r->out;
    if (g == G_SG)
        return 0;

    if (r->in0 >= 0) { pl->in_role[pl->n_in] = r->in0; pl->n_in++; }
    if (r->in1 >= 0) { pl->in_role[pl->n_in] = r->in1; pl->n_in++; }
    for (uint8_t k = 0; k < r->ni; k++) { pl->in_role[pl->n_in] = (int8_t)(R_I1 + k); pl->n_in++; }
    for (uint32_t s = 0; s < pl->n_in; s++)
        pl->role_buf[pl->in_role[s]] = (int8_t)s;
    if (r->out >= 0)
        pl->role_buf[r->out] = (int8_t)pl->n_in;
    pl->n_streams = pl->n_in + (r->out >= 0 ? 1 : 0);
    return 1;
}

/* The largest power-of-two tile such that every stream is double buffered inside the budget. `least` is the
 * smallest tile that still makes sense: 1 on one core, the number of cores for a team. */
static uint32_t rs_tile_words(uint32_t n_streams, uint32_t budget, uint32_t n_words, uint32_t least) {
    uint32_t tw = least;
    while (2 * tw * n_streams * 2 * 4 <= budget && 2 * tw <= n_words)
        tw *= 2;
    return tw;
}

#endif /* RAIDERSTREAM_KERNELS_H */
