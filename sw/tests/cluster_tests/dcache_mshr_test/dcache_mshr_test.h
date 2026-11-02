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
 * dcache_mshr_test - shared by the main core and the PULP task: access patterns and the value of each word, so
 * that the main core computes the expected sums without reading the array.
 */

#ifndef DCACHE_MSHR_TEST_H
#define DCACHE_MSHR_TEST_H

#include <stdint.h>

#define MSHR_BIG_WORDS    (32 * 1024)          /* 128 KiB: 4x the cache */
#define MSHR_LINE_WORDS   (32)                 /* 128 B line */
#define MSHR_WAY_WORDS    (2048)               /* 8 KiB: one way, the set index repeats */
#define MSHR_STRIDE_LINES (16)                 /* lines on one set in the 128 KiB array */
#define MSHR_STRIDE_ACC   (128)                /* accesses per core, strided modes */
#define MSHR_RANDOM_ACC   (256)                /* accesses per core, random mode */
#define MSHR_SPARSE_REPS  (2)                  /* passes of the one-word-per-line stream */

enum {
    MSHR_MODE_INIT        = 0,                 /* dense writes, own chunk */
    MSHR_MODE_DENSE       = 1,                 /* dense reads, own chunk */
    MSHR_MODE_SPARSE      = 2,                 /* one word per line, own chunk */
    MSHR_MODE_STRIDE_WAY  = 3,                 /* stride = one way: every access on the same set */
    MSHR_MODE_STRIDE_LINE = 4,                 /* stride = one way + one line: same lines count, 16 sets */
    MSHR_MODE_RANDOM      = 5,                 /* random words of the whole array */
    MSHR_NUM_MODES        = 6
};

typedef struct {
    uint32_t mode;
    uint32_t big;
    uint32_t partial;                          /* uint32_t[PULP_CORE_COUNT] */
    uint32_t cycles[8];
} dcache_mshr_params_t;

static inline uint32_t mshr_value(uint32_t i) {
    return i * 0x9E3779B1u + 7u;
}

/* Word index of access j of core c in a strided mode */
static inline uint32_t mshr_stride_index(uint32_t mode, uint32_t c, uint32_t j) {
    uint32_t line = (c + j) % MSHR_STRIDE_LINES;
    uint32_t word = (j / MSHR_STRIDE_LINES) % MSHR_LINE_WORDS;
    uint32_t step = (mode == MSHR_MODE_STRIDE_WAY) ? MSHR_WAY_WORDS : (MSHR_WAY_WORDS + MSHR_LINE_WORDS);
    return line * step + word;
}

/* Random mode: one LCG per core */
static inline uint32_t mshr_lcg_seed(uint32_t c) {
    return 12345u + 7919u * c;
}

static inline uint32_t mshr_lcg_next(uint32_t *state) {
    *state = *state * 1664525u + 1013904223u;
    return (*state >> 8) % MSHR_BIG_WORDS;
}

#endif
