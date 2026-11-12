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
 * Author: Luca Balboni, Fondazione Chips-IT
 *
 * Snitch runtime subset used by the spatz_vpu riscvTests, on the MAGIA Spatz core
 */
#ifndef SNRT_H
#define SNRT_H

#include <stdint.h>
#include <stddef.h>
#include "magia_tile_utils.h"

// Bump allocator in the private L1 scratch, which the VLSU reaches; never freed
static inline void *snrt_l1alloc(size_t size) {
    static uint32_t next;  // 0 until the first call: the binary has no loader to initialize it
    if (next == 0) next = SCRATCH_BASE;
    void *ptr = (void *)next;
    next = (next + size + 7) & ~7u;  // Keep e64 accesses aligned
    return ptr;
}

static inline uint32_t snrt_cluster_core_idx(void) { return 0; }
static inline void snrt_cluster_hw_barrier(void) { }

#define snrt_min(a, b) ((a) < (b) ? (a) : (b))

#endif
