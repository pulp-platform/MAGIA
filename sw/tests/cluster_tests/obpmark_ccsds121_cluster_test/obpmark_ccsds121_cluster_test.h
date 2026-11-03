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
 * Shared between the control core and the cluster task of obpmark_ccsds121_cluster_test.
 */

#ifndef OBPMARK_CCSDS121_CLUSTER_TEST_H
#define OBPMARK_CCSDS121_CLUSTER_TEST_H

#include <stdint.h>

#ifndef CCSDS_N_BITS
#define CCSDS_N_BITS   (16)
#endif
#ifndef CCSDS_J_BLOCK
#define CCSDS_J_BLOCK  (16)
#endif
/* 16 and not the 64 of the single core test: a team of 8 cores needs 8 reference intervals in flight in
 * the iDMA variant, so a smaller interval is what lets the staging fit an L1 budget at all. The single core
 * test is run with -DCCSDS_R_BLOCKS=16 as well, so the two are comparable. */
#ifndef CCSDS_R_BLOCKS
#define CCSDS_R_BLOCKS (16)
#endif
#ifndef CCSDS_SAMPLES
#define CCSDS_SAMPLES  (8 * 1024)
#endif

#define INTERVAL_WORDS (CCSDS_J_BLOCK * CCSDS_R_BLOCKS)
#define INTERVALS      (CCSDS_SAMPLES / INTERVAL_WORDS)

/* Scratch of one core: the preprocessed interval, the second extension candidates and the zero block
 * bookkeeping. One slot per core, so the cores never share it. */
#define CCSDS_PRE_OFF    (0)
#define CCSDS_CAND_OFF   (INTERVAL_WORDS * 4)
#define CCSDS_ZEROS_OFF  (CCSDS_CAND_OFF + 0x400)
#define CCSDS_SCRATCH_SZ (0x2000)

enum {
    CCSDS_VAR_L2   = 0,
    CCSDS_VAR_IDMA = 1
};

typedef struct {
    uint32_t variant;
    uint32_t in;                              /* L2 samples */
    uint32_t out;                             /* L2 compressed stream */
    uint32_t out_stride;                      /* words reserved per core in the output */
    uint32_t scratch;                         /* base of the per core scratch, core view */
    uint32_t spm;                             /* iDMA tiles, core view */
    uint32_t spm_loc;                         /* same memory, iDMA view */
    uint32_t tile_intervals;                  /* intervals of one tile for the whole team (iDMA variant) */
    uint32_t words[8];                        /* words written by each core */
    uint32_t bits[8];
    uint32_t cycles[8];
} ccsds_params_t;

#endif /* OBPMARK_CCSDS121_CLUSTER_TEST_H */
