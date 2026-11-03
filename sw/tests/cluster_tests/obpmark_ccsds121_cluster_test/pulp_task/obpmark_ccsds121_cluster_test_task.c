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
 * Cluster task of obpmark_ccsds121_cluster_test: the 8 PULP cores compress CCSDS 121.0 reference intervals,
 * one interval per core per round. The encoder is the one of sw/tests/obpmark_ccsds121_test.c (OBPMark 2.1,
 * CPU port); the only change parallelism forces is that its state (the preprocessed interval, the second
 * extension candidates, the zero block bookkeeping and the unit delay predictor) moves from file globals to
 * a per core context, because in the cluster a global is one copy shared by the team.
 * Each core starts its interval with the predictor loaded from the last sample of the previous interval, so
 * the stream of an interval is the same as in the serial test; the streams of the cores are kept apart,
 * one region each, because the length of an interval is known only after compressing it.
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "cluster_utils.h"
#include "idma_mm_utils.h"
#include "bench_utils.h"
#include "../obpmark_ccsds121_cluster_test.h"

// GCC 14 crashes ("could not split insn", doloop_begin_i) on the cv32e40p hardware loop of the big loops
#pragma GCC optimize("no-branch-count-reg")
#pragma GCC optimize("align-loops=4")
#define KERNEL __attribute__((noinline, aligned(4)))

/* Compression identifiers of the CCSDS 121 standard, as in the OBPMark port */
#define ZERO_BLOCK_ID          (0)
#define FUNDAMENTAL_SEQ_ID     (1)
#define SAMPLE_SPLITTING_ID    (1)
#define SECOND_EXTENSION_ID    (31)
#define NO_COMPRESSION_ID      (32)

/* What used to be the file globals of the single core encoder: one per core */
typedef struct {
    volatile uint32_t *pre;
    volatile uint32_t *cand_a;
    volatile uint32_t *zeros_of;
    uint32_t           delayed;
} ccsds_ctx_t;

// write exactly the same stream whatever the tiling.

typedef struct {
    volatile uint32_t *out;
    uint32_t words;
    uint32_t acc;
    uint32_t nbits;
    uint32_t total;
} bitw_t;

static void bw_init(bitw_t *b, volatile uint32_t *out) {
    b->out = out;
    b->words = 0;
    b->acc = 0;
    b->nbits = 0;
    b->total = 0;
}

static void bw_put(bitw_t *b, uint32_t value, uint32_t n) {
    for (uint32_t i = 0; i < n; i++) {
        uint32_t bit = (value >> (n - 1 - i)) & 1u;
        b->acc = (b->acc << 1) | bit;
        b->nbits++;
        b->total++;
        if (b->nbits == 32) {
            b->out[b->words++] = b->acc;
            b->acc = 0;
            b->nbits = 0;
        }
    }
}

/* n zeros then a one: the unary part of fundamental sequence and sample splitting */
static void bw_unary(bitw_t *b, uint32_t n) {
    for (uint32_t i = 0; i < n; i++)
        bw_put(b, 0, 1);
    bw_put(b, 1, 1);
}

static void bw_flush(bitw_t *b) {
    if (b->nbits > 0) {
        b->out[b->words++] = b->acc << (32 - b->nbits);
        b->acc = 0;
        b->nbits = 0;
    }
}

/////////////////////////////////////////////////
// Preprocessor (OBPMark processing.c)        //
/////////////////////////////////////////////////

static inline uint32_t unit_delay_predictor(ccsds_ctx_t *cx, uint32_t sample) {
    uint32_t cached = cx->delayed;
    cx->delayed = sample;
    return cached;
}

/* theta + |e|, with the two special cases of the standard */
static uint32_t predictor_error_mapper(int32_t predicted, int32_t error) {
    const int32_t x_min = 0;
    const int32_t x_max = (int32_t)((1u << CCSDS_N_BITS) - 1u);
    int32_t lo = predicted - x_min;
    int32_t hi = x_max - predicted;
    int32_t theta = (lo < hi) ? lo : hi;
    int32_t abs_e = (error < 0) ? -error : error;

    if (0 <= error && error <= theta)
        return (uint32_t)(2 * error);
    if (-theta <= error && error < 0)
        return (uint32_t)(2 * abs_e - 1);
    return (uint32_t)(theta + abs_e);
}

KERNEL static uint32_t preprocess_interval(ccsds_ctx_t *cx, volatile uint32_t *src) {
    uint32_t all_zero_runs = 0;
    uint32_t consecutive = 0;

    for (uint32_t blk = 0; blk < CCSDS_R_BLOCKS; blk++) {
        uint32_t all_zero = 1;
        for (uint32_t i = 0; i < CCSDS_J_BLOCK; i++) {
            uint32_t idx = blk * CCSDS_J_BLOCK + i;
            int32_t  x = (int32_t)src[idx];
            int32_t  predicted = (int32_t)unit_delay_predictor(cx, (uint32_t)x);
            uint32_t mapped = predictor_error_mapper(predicted, x - predicted);
            cx->pre[idx] = mapped;
            if (mapped != 0)
                all_zero = 0;
        }
        if (all_zero) {
            cx->zeros_of[blk] = consecutive;
            consecutive++;
            all_zero_runs++;
        } else {
            cx->zeros_of[blk] = 0xFFFFFFFFu;       /* not a zero block */
            consecutive = 0;
        }
    }
    return all_zero_runs;
}

///////////////////////////////////////////////////
// Adaptive entropy encoder (OBPMark processing) //
///////////////////////////////////////////////////

static uint32_t size_second_extension(volatile uint32_t *halved) {
    uint32_t size = 0;
    for (uint32_t i = 0; i < CCSDS_J_BLOCK / 2; i++)
        size += halved[i] + 1;
    return size;
}

static uint32_t size_fundamental_sequence(volatile uint32_t *s) {
    uint32_t size = 0;
    for (uint32_t i = 0; i < CCSDS_J_BLOCK; i++)
        size += s[i] + 1;
    return size;
}

static uint32_t size_sample_splitting(volatile uint32_t *s, uint32_t k) {
    uint32_t size = 0;
    for (uint32_t i = 0; i < CCSDS_J_BLOCK; i++)
        size += k + (s[i] >> k) + 1;
    return size;
}

/* The identifier field is as wide as the sample size says (OBPMark NoCompression) */
static uint32_t id_width(void) {
    if (CCSDS_N_BITS < 3)
        return 1;
    if (CCSDS_N_BITS < 5)
        return 2;
    if (CCSDS_N_BITS <= 8)
        return 3;
    if (CCSDS_N_BITS <= 16)
        return 4;
    return 5;
}

/* One block: try every option, write the smallest. Returns nothing, the writer advances. */
KERNEL static void encode_block(ccsds_ctx_t *cx, bitw_t *bw, volatile uint32_t *s, uint32_t zeros) {
    const uint32_t uncompressed = CCSDS_N_BITS * CCSDS_J_BLOCK;
    uint32_t best_size = uncompressed;
    uint32_t best_id = NO_COMPRESSION_ID;
    uint32_t best_k = 0;

    if (zeros != 0xFFFFFFFFu) {
        // A run of all-zero blocks: the zero block option, nothing else is tried
        bw_put(bw, ZERO_BLOCK_ID, id_width());
        bw_unary(bw, zeros);
        return;
    }

    // Second extension: pairs of samples folded into one value
    for (uint32_t i = 0; i < CCSDS_J_BLOCK / 2; i++) {
        uint32_t a = s[2 * i], b = s[2 * i + 1];
        cx->cand_a[i] = ((a + b) * (a + b + 1)) / 2 + b;
    }
    uint32_t se = size_second_extension(cx->cand_a);
    if (se < best_size) {
        best_size = se;
        best_id = SECOND_EXTENSION_ID;
    }

    // Fundamental sequence is sample splitting with k = 0
    uint32_t fs = size_fundamental_sequence(s);
    if (fs < best_size) {
        best_size = fs;
        best_id = FUNDAMENTAL_SEQ_ID;
        best_k = 0;
    }
    for (uint32_t k = 1; k < CCSDS_N_BITS - 2; k++) {
        uint32_t ss = size_sample_splitting(s, k);
        if (ss < best_size) {
            best_size = ss;
            best_id = SAMPLE_SPLITTING_ID + k;
            best_k = k;
        }
    }

    bw_put(bw, best_id, id_width());
    if (best_id == NO_COMPRESSION_ID) {
        for (uint32_t i = 0; i < CCSDS_J_BLOCK; i++)
            bw_put(bw, s[i], CCSDS_N_BITS);
    } else if (best_id == SECOND_EXTENSION_ID) {
        for (uint32_t i = 0; i < CCSDS_J_BLOCK / 2; i++)
            bw_unary(bw, cx->cand_a[i]);
    } else if (best_k == 0) {
        for (uint32_t i = 0; i < CCSDS_J_BLOCK; i++)
            bw_unary(bw, s[i]);
    } else {
        for (uint32_t i = 0; i < CCSDS_J_BLOCK; i++)
            bw_unary(bw, s[i] >> best_k);
        for (uint32_t i = 0; i < CCSDS_J_BLOCK; i++)
            bw_put(bw, s[i] & ((1u << best_k) - 1u), best_k);
    }
}

/* One reference interval: preprocess, then every block. The writer is flushed at the end, so the stream does
 * not depend on how the samples got here. Returns the words written. */
KERNEL static uint32_t compress_interval(ccsds_ctx_t *cx, volatile uint32_t *src, volatile uint32_t *dst, uint32_t *bits) {
    bitw_t bw;
    bw_init(&bw, dst);
    preprocess_interval(cx, src);
    for (uint32_t blk = 0; blk < CCSDS_R_BLOCKS; blk++)
        encode_block(cx, &bw, cx->pre + blk * CCSDS_J_BLOCK, cx->zeros_of[blk]);
    bw_flush(&bw);
    *bits = bw.total;
    return bw.words;
}

//////////////
// Variants //
//////////////

/* GCC 14 and the corev GCC stop with an internal error (maybe_postinc, expr.cc) at -O2 on the CV32
 * post-increment stores of this loop: it is kept apart so that only it loses the loop optimizer. */
#pragma GCC push_options
#pragma GCC optimize("no-tree-loop-optimize")
static void zero_words(uint32_t *v, uint32_t n) {
    for (uint32_t i = 0; i < n; i++)
        v[i] = 0;
}
#pragma GCC pop_options

/* The context of this core: its slot of the scratch, predictor cleared */
static void ctx_init(ccsds_ctx_t *cx, volatile ccsds_params_t *p, uint32_t id) {
    uint32_t base = p->scratch + id * CCSDS_SCRATCH_SZ;

    cx->pre      = (volatile uint32_t *)(base + CCSDS_PRE_OFF);
    cx->cand_a   = (volatile uint32_t *)(base + CCSDS_CAND_OFF);
    cx->zeros_of = (volatile uint32_t *)(base + CCSDS_ZEROS_OFF);
    cx->delayed  = 0;
}

/* L2 variants: core `id` compresses the intervals id, id + 8, id + 16 ... straight from and to the L2 */
static void ccsds_l2(volatile ccsds_params_t *p, uint32_t id) {
    volatile uint32_t *in  = (volatile uint32_t *)p->in;
    volatile uint32_t *out = (volatile uint32_t *)(p->out + id * p->out_stride * 4);
    ccsds_ctx_t cx;
    uint32_t words = 0, bits = 0, b;

    ctx_init(&cx, p, id);
    for (uint32_t t = id; t < INTERVALS; t += PULP_CORE_COUNT) {
        /* The predictor carries the last sample of the previous interval, as in the serial stream */
        cx.delayed = (t == 0) ? 0 : in[t * INTERVAL_WORDS - 1];
        words += compress_interval(&cx, in + t * INTERVAL_WORDS, out + words, &b);
        bits  += b;
    }
    p->words[id] = words;
    p->bits[id]  = bits;
}

/* iDMA variant: one round is one interval per core. Core 0 brings the round in (double buffered) and, once
 * the team has compressed it, sends each core's stream out: the length of an interval is known only then,
 * so the output side is one transfer per core and is not double buffered. */
static void ccsds_idma(volatile ccsds_params_t *p, uint32_t id) {
    uint32_t tile_words = p->tile_intervals * INTERVAL_WORDS;
    uint32_t tile_bytes = tile_words * 4;
    uint32_t out_slot   = (INTERVAL_WORDS + 32) * 4;   /* worst case: no compression plus the id fields */
    uint32_t rounds     = INTERVALS / p->tile_intervals;
    volatile uint32_t *in = (volatile uint32_t *)p->in;
    uint32_t in_id[2] = {0, 0}, out_id = 0;
    uint32_t acc[PULP_CORE_COUNT];            /* words already written by each core, kept by core 0 */
    ccsds_ctx_t cx;
    uint32_t words = 0, bits = 0, b;

    zero_words(acc, PULP_CORE_COUNT);
    ctx_init(&cx, p, id);
    if (id == 0)
        in_id[0] = idma_L2ToL1(p->in, p->spm_loc, tile_bytes);
    for (uint32_t t = 0; t < rounds; t++) {
        int d = t & 1, n = d ^ 1;
        uint32_t first = t * p->tile_intervals + id;   /* the interval of this core in this round */
        volatile uint32_t *src = (volatile uint32_t *)(p->spm + d * tile_bytes + id * INTERVAL_WORDS * 4);
        volatile uint32_t *dst = (volatile uint32_t *)(p->spm + 2 * tile_bytes + id * out_slot);

        if (id == 0) {
            idma_wait_in(in_id[d]);
            if (t + 1 < rounds)
                in_id[n] = idma_L2ToL1(p->in + (t + 1) * tile_bytes, p->spm_loc + n * tile_bytes, tile_bytes);
        }
        pi_cl_team_barrier();
        cx.delayed = (first == 0) ? 0 : in[first * INTERVAL_WORDS - 1];
        uint32_t w = compress_interval(&cx, src, dst, &b);
        p->words[id] = w;
        pi_cl_team_barrier();
        if (id == 0) {
            /* One transfer per core: the streams have different lengths and different destinations */
            for (uint32_t g = 0; g < PULP_CORE_COUNT; g++) {
                out_id = idma_L1ToL2(p->spm_loc + 2 * tile_bytes + g * out_slot,
                                     p->out + (g * p->out_stride + acc[g]) * 4, p->words[g] * 4);
                acc[g] += p->words[g];
            }
            idma_wait_out(out_id);
        }
        words += w;
        bits  += b;
        pi_cl_team_barrier();
    }
    p->words[id] = words;
    p->bits[id]  = bits;
}

static void ccsds_fork_entry(void *arg) {
    volatile ccsds_params_t *p = (volatile ccsds_params_t *)arg;
    uint32_t id = pi_core_id();

    asm volatile("csrw mcountinhibit, zero");
    pi_cl_team_barrier();
    uint32_t start = read_mcycle();

    if (p->variant == CCSDS_VAR_IDMA)
        ccsds_idma(p, id);
    else
        ccsds_l2(p, id);

    p->cycles[id] = read_mcycle() - start;
    pi_cl_team_barrier();
}

int obpmark_ccsds121_cluster_test_task(void *data) {
    pi_cl_team_fork(PULP_CORE_COUNT, ccsds_fork_entry, data);
    return 0;
}
