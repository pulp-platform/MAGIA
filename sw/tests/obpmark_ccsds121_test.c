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
 * OBPMark 2.1 CCSDS 121.0 data compression (ESA/BSC, github.com/OBPMark/OBPMark,
 * src/2.1-data_compression/src/ports/cpu) on the control core. The algorithm is the one of the CPU port:
 * unit delay predictor and predictor error mapper, then for every block of J samples the adaptive entropy
 * encoder tries no compression, second extension, fundamental sequence and sample splitting for every k, and
 * keeps the smallest; a run of all-zero blocks becomes a zero block.
 *
 * Adapted for bare metal, with the memory behaviour kept as it is:
 *   - the candidates are not malloc'ed and freed one by one; two fixed buffers are ping-ponged, which is how
 *     many are alive at a time in the original (MIN frees the loser straight away);
 *   - pow(2, n_bits) is a shift;
 *   - the output is the real bit stream (identifier plus the coded samples), written by a bit writer; every
 *     interval starts on a word boundary, so that the three variants produce exactly the same stream.
 *
 * It is the low-compute-per-byte counterpart of obpmark_aes_test: here the transport should matter.
 * Input samples and compressed output live in L2, the scratch of the encoder in the SPM, and the three
 * variants move only the first two:
 *   direct : samples and output in L2, cache off
 *   idma   : tiles of samples in and of output out, double buffered, the encoder works in the SPM
 *   cache  : samples and output in L2 through the cache (budget in ways, prefetch off and on)
 * Checks: the three variants must produce the same bit count and the same checksum, and a zero input must
 * collapse to zero blocks. Needs the cache (make dcache=1).
 */

#include "magia_tile_utils.h"
#include "magia_dcache_utils.h"
#include "idma_mm_utils.h"

// GCC 14 crashes ("could not split insn", doloop_begin_i) on the cv32e40p hardware loop of the big loops
#pragma GCC optimize("no-branch-count-reg")
#pragma GCC optimize("align-loops=4")
#define KERNEL __attribute__((noinline, aligned(4)))

////////////////
// Parameters //
////////////////

#ifndef CCSDS_N_BITS
#define CCSDS_N_BITS   (16)                   /* bits per sample (OBPMark -n) */
#endif
#ifndef CCSDS_J_BLOCK
#define CCSDS_J_BLOCK  (16)                   /* samples per block (OBPMark -j) */
#endif
#ifndef CCSDS_R_BLOCKS
#define CCSDS_R_BLOCKS (64)                   /* blocks per reference interval (OBPMark -r) */
#endif
#ifndef CCSDS_SAMPLES
#define CCSDS_SAMPLES  (8 * 1024)             /* total samples: 32 KiB in L2 */
#endif
#ifndef BUDGETS_KIB
#define BUDGETS_KIB    16, 32
#endif
#ifndef RUN_DIRECT
#define RUN_DIRECT     (1)
#endif
#ifndef RUN_IDMA
#define RUN_IDMA       (1)
#endif
#ifndef CACHE_PF
#define CACHE_PF       (3)
#endif

#define INTERVAL_WORDS (CCSDS_J_BLOCK * CCSDS_R_BLOCKS)   /* samples of one reference interval */
#define INTERVALS      (CCSDS_SAMPLES / INTERVAL_WORDS)
#define DMA_CHUNK      (32 * 1024)

/* Compression identifiers of the CCSDS 121 standard, as in the OBPMark port */
#define ZERO_BLOCK_ID          (0)
#define FUNDAMENTAL_SEQ_ID     (1)
#define SAMPLE_SPLITTING_ID    (1)
#define SECOND_EXTENSION_ID    (31)
#define NO_COMPRESSION_ID      (32)

/////////////////////
// Memory and data //
/////////////////////

/* Samples and compressed stream in the L2 arena (cacheable region) */
#define ARENA        (0xCC100000)
#define IN_ADDR      (ARENA)
#define IN_BYTES     (CCSDS_SAMPLES * 4)
#define OUT_ADDR     (ARENA + IN_BYTES + 128)
#define OUT_BYTES    (CCSDS_SAMPLES * 4)      /* the stream never grows past the input here */
#define ARENA_END    (OUT_ADDR + OUT_BYTES)

/* Scratch of the encoder, in the SPM in every variant: preprocessed interval, two candidate buffers,
 * the zero-block bookkeeping. Small and hot, like the tables of the AES benchmark. */
#define SCRATCH      (L1_BASE + L1_SPM_SIZE - 64 * 1024)
#define SPM          (L1_BASE)                /* iDMA buffers */

static volatile uint32_t *const pre      = (volatile uint32_t *)(SCRATCH);
static volatile uint32_t *const cand_a   = (volatile uint32_t *)(SCRATCH + 0x8000);
static volatile uint32_t *const cand_b   = (volatile uint32_t *)(SCRATCH + 0x8400);
static volatile uint32_t *const zeros_of = (volatile uint32_t *)(SCRATCH + 0x8800);

static const uint32_t budgets_kib[] = {BUDGETS_KIB};
static uint32_t errors = 0;

static inline uint32_t read_mcycle(void) {
    uint32_t cycles;
    asm volatile("csrr %0, mcycle" : "=r"(cycles));
    return cycles;
}

static void check(const char *what, uint32_t got, uint32_t expected) {
    if (got != expected) {
        printf("[FAIL] %s: got 0x%x, expected 0x%x\n", what, (unsigned)got, (unsigned)expected);
        errors++;
    }
}

//////////
// iDMA //
//////////

static inline void wait_in(uint32_t id) {
    while ((int32_t)(idma_mm_get_done_id_dir(0, 0) - id) < 0);
}

static inline void wait_out(uint32_t id) {
    while ((int32_t)(idma_mm_get_done_id_dir(1, 0) - id) < 0);
}

static uint32_t dma_in(uint32_t l2, uint32_t l1, uint32_t bytes) {
    uint32_t id = 0;
    for (uint32_t off = 0; off < bytes; off += DMA_CHUNK) {
        uint32_t len = (bytes - off < DMA_CHUNK) ? bytes - off : DMA_CHUNK;
        id = idma_L2ToL1(l2 + off, l1 + off, len);
    }
    return id;
}

static uint32_t dma_out(uint32_t l1, uint32_t l2, uint32_t bytes) {
    uint32_t id = 0;
    for (uint32_t off = 0; off < bytes; off += DMA_CHUNK) {
        uint32_t len = (bytes - off < DMA_CHUNK) ? bytes - off : DMA_CHUNK;
        id = idma_L1ToL2(l1 + off, l2 + off, len);
    }
    return id;
}

//////////////////
// Bit writer   //
//////////////////
// The compressed stream, word by word. Every interval is flushed to a word boundary, so the three variants
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

static uint32_t delayed_stack;

static inline uint32_t unit_delay_predictor(uint32_t sample) {
    uint32_t cached = delayed_stack;
    delayed_stack = sample;
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

KERNEL static uint32_t preprocess_interval(volatile uint32_t *src) {
    uint32_t all_zero_runs = 0;
    uint32_t consecutive = 0;

    for (uint32_t blk = 0; blk < CCSDS_R_BLOCKS; blk++) {
        uint32_t all_zero = 1;
        for (uint32_t i = 0; i < CCSDS_J_BLOCK; i++) {
            uint32_t idx = blk * CCSDS_J_BLOCK + i;
            int32_t  x = (int32_t)src[idx];
            int32_t  predicted = (int32_t)unit_delay_predictor((uint32_t)x);
            uint32_t mapped = predictor_error_mapper(predicted, x - predicted);
            pre[idx] = mapped;
            if (mapped != 0)
                all_zero = 0;
        }
        if (all_zero) {
            zeros_of[blk] = consecutive;
            consecutive++;
            all_zero_runs++;
        } else {
            zeros_of[blk] = 0xFFFFFFFFu;       /* not a zero block */
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
KERNEL static void encode_block(bitw_t *bw, volatile uint32_t *s, uint32_t zeros) {
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
        cand_a[i] = ((a + b) * (a + b + 1)) / 2 + b;
    }
    uint32_t se = size_second_extension(cand_a);
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
            bw_unary(bw, cand_a[i]);
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
KERNEL static uint32_t compress_interval(volatile uint32_t *src, volatile uint32_t *dst, uint32_t *bits) {
    bitw_t bw;
    bw_init(&bw, dst);
    preprocess_interval(src);
    for (uint32_t blk = 0; blk < CCSDS_R_BLOCKS; blk++)
        encode_block(&bw, pre + blk * CCSDS_J_BLOCK, zeros_of[blk]);
    bw_flush(&bw);
    *bits = bw.total;
    return bw.words;
}

//////////
// Runs //
//////////

static uint32_t golden_bits, golden_sum, golden_words;

static uint32_t out_checksum(uint32_t words) {
    uint32_t s = 0;
    volatile uint32_t *o = (volatile uint32_t *)OUT_ADDR;
    dcache_flush();
    for (uint32_t i = 0; i < words; i++)
        s = s * 31u + o[i];
    return s;
}

static void print_res(const char *variant, uint32_t budget, uint32_t cycles, const dcache_perf_t *perf) {
    printf("RES variant=%s budget=%d kernel=ccsds121 cycles=%d hit_r=%d miss_r=%d hit_w=%d miss_w=%d "
           "refill=%d wb=%d\n", variant, (int)(budget / 1024), (int)cycles, (int)perf->hit_r,
           (int)perf->miss_r, (int)perf->hit_w, (int)perf->miss_w, (int)perf->refill, (int)perf->writeback);
}

/* The whole stream, interval by interval, straight from and to the L2 */
static uint32_t compress_l2(uint32_t *bits_out) {
    volatile uint32_t *in = (volatile uint32_t *)IN_ADDR;
    volatile uint32_t *out = (volatile uint32_t *)OUT_ADDR;
    uint32_t words = 0, bits = 0, b;

    delayed_stack = 0;
    for (uint32_t t = 0; t < INTERVALS; t++) {
        words += compress_interval(in + t * INTERVAL_WORDS, out + words, &b);
        bits += b;
    }
    *bits_out = bits;
    return words;
}

/* Same loop, but the samples arrive in the SPM and the stream leaves from the SPM, double buffered.
 * The tile is a whole number of reference intervals, so the stream is the same as above. */
static uint32_t compress_idma(uint32_t budget, uint32_t *bits_out) {
    uint32_t tile_intervals = budget / (4 * INTERVAL_WORDS * 4);
    if (tile_intervals == 0)
        tile_intervals = 1;
    while (INTERVALS % tile_intervals != 0)
        tile_intervals--;
    uint32_t tile_words = tile_intervals * INTERVAL_WORDS;
    uint32_t tile_bytes = tile_words * 4;
    int      tiles = INTERVALS / tile_intervals;
    uint32_t in_buf[2] = {SPM, SPM + tile_bytes};
    uint32_t out_buf[2] = {SPM + 2 * tile_bytes, SPM + 3 * tile_bytes};
    uint32_t in_id[2] = {0, 0}, out_id[2] = {0, 0}, out_len[2] = {0, 0};
    uint32_t words = 0, bits = 0, b;

    delayed_stack = 0;
    in_id[0] = dma_in(IN_ADDR, in_buf[0], tile_bytes);
    for (int t = 0; t < tiles; t++) {
        int d = t & 1, n = d ^ 1;
        if (t + 1 < tiles) {
            if (t >= 1)
                wait_out(out_id[n]);
            in_id[n] = dma_in(IN_ADDR + (t + 1) * tile_bytes, in_buf[n], tile_bytes);
        }
        wait_in(in_id[d]);
        uint32_t tw = 0;
        for (uint32_t k = 0; k < tile_intervals; k++) {
            tw += compress_interval((volatile uint32_t *)(in_buf[d] + k * INTERVAL_WORDS * 4),
                                    (volatile uint32_t *)(out_buf[d] + tw * 4), &b);
            bits += b;
        }
        out_len[d] = tw;
        out_id[d] = dma_out(out_buf[d], OUT_ADDR + words * 4, tw * 4);
        words += tw;
    }
    wait_out(out_id[(tiles - 1) & 1]);
    *bits_out = bits;
    return words;
}

static void run_direct(void) {
    dcache_perf_t none = {0};
    uint32_t bits, words, start, t;

    dcache_flush();
    dcache_enable(0);
    start = read_mcycle();
    words = compress_l2(&bits);
    t = read_mcycle() - start;
    dcache_enable(1);
    check("direct bits", bits, golden_bits);
    check("direct words", words, golden_words);
    check("direct checksum", out_checksum(words), golden_sum);
    print_res("direct", 0, t, &none);
}

static void run_idma(uint32_t budget) {
    dcache_perf_t none = {0};
    uint32_t bits, words, start, t;

    dcache_flush();
    dcache_enable(0);
    start = read_mcycle();
    words = compress_idma(budget, &bits);
    t = read_mcycle() - start;
    dcache_enable(1);
    check("idma bits", bits, golden_bits);
    check("idma words", words, golden_words);
    check("idma checksum", out_checksum(words), golden_sum);
    print_res("idma", budget, t, &none);
}

static void run_cache(uint32_t budget, uint32_t prefetch) {
    const char   *variant = prefetch ? "cache_pf1" : "cache_pf0";
    uint32_t      way_bytes = L1_DCACHE_SIZE / dcache_num_ways();
    uint32_t      ways = budget / way_bytes;
    uint32_t      spm_base, spm_size, bits, words, start, t1, tf;
    dcache_perf_t perf;

    if (ways == 0 || ways > dcache_num_ways() || ways * way_bytes != budget) {
        printf("cache %d KiB: not a number of ways, skipped\n", (int)(budget / 1024));
        return;
    }
    dcache_set_ways(ways, &spm_base, &spm_size);
    dcache_set_prefetch(prefetch);
    dcache_flush();
    dcache_perf_start();
    start = read_mcycle();
    words = compress_l2(&bits);
    t1 = read_mcycle() - start;
    dcache_perf_stop();
    dcache_perf_read(&perf);
    start = read_mcycle();
    dcache_flush();
    tf = read_mcycle() - start;
    check("cache bits", bits, golden_bits);
    check("cache words", words, golden_words);
    check("cache checksum", out_checksum(words), golden_sum);
    print_res(variant, budget, t1 + tf, &perf);
    dcache_set_prefetch(0);
    dcache_set_ways(dcache_num_ways(), &spm_base, &spm_size);
}

int main(void) {
    volatile uint32_t *in = (volatile uint32_t *)IN_ADDR;
    uint32_t x = 0x2026u;

    asm volatile("csrw mcountinhibit, zero");
    printf("obpmark ccsds121: %d samples, %d bits, J=%d, R=%d (%d intervalli), dcache %d ways x %d sets "
           "(%d KiB), geometry %s\n", CCSDS_SAMPLES, CCSDS_N_BITS, CCSDS_J_BLOCK, CCSDS_R_BLOCKS, INTERVALS,
           (int)dcache_num_ways(), MAGIA_DCACHE_SETS, L1_DCACHE_SIZE / 1024,
           dcache_geometry_ok() ? "ok" : "MISMATCH");
    if (!dcache_geometry_ok() || ARENA_END > 0xCCF00000 || CCSDS_SAMPLES % INTERVAL_WORDS != 0) {
        printf("[FAIL] geometry, arena or interval\n");
        return 1;
    }

    /* A signal a compressor can work on: a slow ramp with noise, so that the predictor leaves small residuals
     * and the encoder really chooses between the options, plus a flat stretch that becomes zero blocks. */
    for (uint32_t i = 0; i < CCSDS_SAMPLES; i++) {
        x = x * 1664525u + 1013904223u;
        uint32_t ramp = (i * 3) & 0xFFFFu;
        uint32_t noise = (x >> 24) & 0x1Fu;
        uint32_t flat = (i / INTERVAL_WORDS) % 4 == 3;     /* one interval in four is constant */
        in[i] = flat ? 0x1000u : ((ramp + noise) & 0xFFFFu);
    }
    dcache_flush();

    /* Reference run (not timed) */
    golden_words = compress_l2(&golden_bits);
    golden_sum = out_checksum(golden_words);
    printf("stream di riferimento: %d bit, %d parole (%d%% dell'ingresso)\n", (int)golden_bits,
           (int)golden_words, (int)(100 * golden_words / CCSDS_SAMPLES));

    if (RUN_DIRECT)
        run_direct();
    for (uint32_t i = 0; i < sizeof(budgets_kib) / sizeof(budgets_kib[0]); i++) {
        uint32_t budget = budgets_kib[i] * 1024;
        if (RUN_IDMA)
            run_idma(budget);
        if (CACHE_PF & 1)
            run_cache(budget, 0);
        if (CACHE_PF & 2)
            run_cache(budget, 1);
    }

    printf("obpmark_ccsds121_test: %d errors\n", (int)errors);
    return errors;
}
