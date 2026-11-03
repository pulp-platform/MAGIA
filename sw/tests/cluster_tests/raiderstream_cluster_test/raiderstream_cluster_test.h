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
 * What the control core hands to the team of raiderstream_cluster_test.
 * The kernels, the roles and what the iDMA may stage are in sw/tests/raiderstream_kernels.h, shared with
 * the single core test: the team derives its staging plan from there, it is not sent one.
 */

#ifndef RAIDERSTREAM_CLUSTER_TEST_H
#define RAIDERSTREAM_CLUSTER_TEST_H

#include <stdint.h>
#include "../../raiderstream_kernels.h"

#ifndef RSC_WORDS
#define RSC_WORDS (4 * 1024)                  /* words per array, as STREAM_WORDS of the 1 core test */
#endif

enum {
    RSC_VAR_DIRECT = 0,                       /* straight to the L2, the cache off */
    RSC_VAR_IDMA   = 1,                       /* tiles staged in the L1 SPM by cluster core 0 */
    RSC_VAR_CACHE  = 2                        /* straight to the L2 through the cache */
};

typedef struct {
    uint32_t group;                           /* G_SEQ .. G_SG */
    uint32_t op;                              /* OP_COPY .. OP_TRIAD */
    uint32_t variant;
    uint32_t n_words;                         /* words per array; the task uses this, never the define */
    uint32_t role[R_NUM];                     /* L2 address of each array, by role */
    uint32_t spm;                             /* base of the tile buffers, core view */
    uint32_t spm_loc;                         /* the same memory, iDMA view */
    uint32_t tile_words;                      /* words of one tile for the whole team */
    uint32_t cycles[8];
} rsc_params_t;

#endif /* RAIDERSTREAM_CLUSTER_TEST_H */
