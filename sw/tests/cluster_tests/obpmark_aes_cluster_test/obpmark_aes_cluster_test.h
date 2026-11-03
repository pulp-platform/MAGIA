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
 * Shared between the control core and the cluster task of obpmark_aes_cluster_test.
 */

#ifndef OBPMARK_AES_CLUSTER_TEST_H
#define OBPMARK_AES_CLUSTER_TEST_H

#include <stdint.h>

#ifndef AES_KEY_BITS
#define AES_KEY_BITS (256)
#endif
#ifndef AES_BLOCKS
#define AES_BLOCKS   (2048)                   /* 16-byte blocks: 32 KiB of plaintext */
#endif

enum {
    AES_VAR_L2   = 0,                         /* plaintext and ciphertext in L2, cache off or on */
    AES_VAR_IDMA = 1                          /* tiles in and out of the L1 SPM, staged by cluster core 0 */
};

typedef struct {
    uint32_t variant;
    uint32_t pt;                              /* L2 plaintext */
    uint32_t ct;                              /* L2 ciphertext */
    uint32_t blocks;                          /* total 16-byte blocks */
    uint32_t hot;                             /* sbox, rcon, expanded key, base counter: core view */
    uint32_t spm;                             /* iDMA tiles, core view */
    uint32_t spm_loc;                         /* same memory, iDMA view */
    uint32_t tile_blocks;                     /* blocks of one tile for the whole team (iDMA variant) */
    uint32_t kat_errors;                      /* FIPS-197 known answer, filled by core 0 */
    uint32_t cycles[8];
} aes_params_t;

/* Layout of the hot area, all read only once core 0 has built it */
#define AES_HOT_SBOX   (0)                    /* 256 B */
#define AES_HOT_RCON   (256)                  /* 11 B */
#define AES_HOT_EKEY   (512)                  /* NB * (NR + 1) words */
#define AES_HOT_IV     (1024)                 /* 16 B base counter */
#define AES_HOT_KEY    (1056)                 /* NK * 4 B */
#define AES_HOT_BYTES  (4096)

#endif /* OBPMARK_AES_CLUSTER_TEST_H */
