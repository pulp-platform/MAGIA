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
 * Shared between the control core and the cluster task of dcache_blocks_cluster_test.
 */

#ifndef DCACHE_BLOCKS_CLUSTER_TEST_H
#define DCACHE_BLOCKS_CLUSTER_TEST_H

#include <stdint.h>

enum {
    DBC_VAR_L2   = 0,                         /* the cores read the L2 directly, cache off or on */
    DBC_VAR_IDMA = 1                          /* cluster core 0 stages one block per core, double buffered */
};

typedef struct {
    uint32_t variant;
    uint32_t src;                             /* L2 array */
    uint32_t idx;                             /* L2 list of block starts, a permutation of the blocks */
    uint32_t n_blocks;
    uint32_t block;                           /* words per block */
    uint32_t reuse;                           /* passes over the whole list */
    uint32_t buf;                             /* staging area, core view */
    uint32_t buf_loc;                         /* same memory, iDMA view */
    uint32_t partial[8];
    uint32_t cycles[8];
} dbc_params_t;

#endif /* DCACHE_BLOCKS_CLUSTER_TEST_H */
