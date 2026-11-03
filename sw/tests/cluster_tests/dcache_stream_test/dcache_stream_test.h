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
 * Shared between the control core and the cluster task of dcache_stream_test.
 */

#ifndef DCACHE_STREAM_TEST_H
#define DCACHE_STREAM_TEST_H

#include <stdint.h>

#ifndef STREAM_N_WORDS
#define STREAM_N_WORDS (8 * 1024)              /* 32 KiB per array: a, b, c are 96 KiB, 3x the cache */
#endif
#define STREAM_SCALAR  (3u)
#define STREAM_OB      (0x1000u)               /* b[i] = i + STREAM_OB */
#define STREAM_OC      (0x2000u)               /* c[i] = i + STREAM_OC */

enum {
    STREAM_K_TRIAD     = 0,                    /* a[j] = b[j] + 3 c[j]: two reads and one write, sequential */
    STREAM_K_GATHER    = 1,                    /* sum of a[idx[j]]: irregular reads */
    STREAM_K_SCATTER   = 2,                    /* c[idx[j]] = a[j]: irregular writes */
    STREAM_NUM_KERNELS = 3
};

enum {
    STREAM_VAR_DIRECT = 0,                     /* straight to the L2, the cache off */
    STREAM_VAR_IDMA   = 1,                     /* tiles staged in the L1 SPM by cluster core 0, double buffered */
    STREAM_VAR_CACHE  = 2                      /* straight to the L2 through the cache */
};

/* Streams staged by the iDMA variant: triad b, c and a out; gather the indices; scatter a and the indices */
static inline uint32_t stream_nb_streams(uint32_t kernel) {
    if (kernel == STREAM_K_TRIAD)
        return 3;
    if (kernel == STREAM_K_GATHER)
        return 1;
    return 2;
}

typedef struct {
    uint32_t kernel;
    uint32_t variant;
    uint32_t n_words;                          /* words per array: the task uses this, not the define, so that
                                                * a build that redefines STREAM_N_WORDS on one side only cannot
                                                * send the cores past the arrays */
    uint32_t a, b, c, idx;                     /* L2 addresses of the arrays */
    uint32_t spm;                              /* base of the iDMA buffers in the L1 SPM */
    uint32_t tile_words;                       /* words of one tile, the whole team (iDMA variant) */
    uint32_t partial;                          /* uint32_t[PULP_CORE_COUNT] */
    uint32_t cycles[8];
} dcache_stream_params_t;

/* Sum of i + o for i in [0, n), modulo 2^32 */
static inline uint32_t stream_sum(uint32_t n, uint32_t o) {
    uint32_t tri = (n % 2 == 0) ? (n / 2) * (n - 1) : n * ((n - 1) / 2);
    return tri + n * o;
}

#endif /* DCACHE_STREAM_TEST_H */
