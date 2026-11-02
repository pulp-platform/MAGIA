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
 * dcache_amo_test - AMOs next to the data cache (CV32E40X only: the CV32E40P toolchain has no atomics).
 * AMOs never go to the cache: the demux sends them to the xbar, like any access out of the cacheable region.
 *   1. amoadd on L1 (SPM): reference.
 *   2. amoadd on an L2 word of the cacheable region, flushed first, so not in the cache: it must work, and a load
 *      through the cache must see its result.  Checked.
 *   3. amoadd on an L2 word dirty in the cache: the AMO reads the old L2 value, the core keeps reading its dirty copy,
 *      and the flush writes that copy over the AMO result. Printed, not checked: this is the documented limit
 *      (the software must not use AMOs on lines that can be in the cache).
 * With dcache=0 the steps 1-2 run the same, and step 3 shows the behaviour without a cache.
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "magia_dcache_utils.h"

#define SPM_WORD (L1_BASE + 0x00000100)

volatile uint32_t amo_word_clean;
volatile uint32_t amo_word_dirty;

static inline uint32_t amoadd(volatile uint32_t *addr, uint32_t value) {
    uint32_t old;
    asm volatile("amoadd.w %0, %2, (%1)" : "=r"(old) : "r"(addr), "r"(value) : "memory");
    return old;
}

int main(void) {
    uint32_t errors = 0;
    uint32_t old, now, l2;
    volatile uint32_t *spm = (volatile uint32_t *)SPM_WORD;

    // 1. L1
    *spm = 10;
    old  = amoadd(spm, 3);
    now  = *spm;
    printf("amo L1: old %d now %d (expected 10, 13)\n", old, now);
    if ((old != 10) || (now != 13))
        errors++;

    // 2. L2, line not in the cache
    amo_word_clean = 100;
    dcache_flush();
    printf("amo L2 clean: issuing\n");
    old = amoadd(&amo_word_clean, 5);
    now = amo_word_clean;
    printf("amo L2 clean: old %d now %d (expected 100, 105)\n", old, now);
    if ((old != 100) || (now != 105))
        errors++;

    // 3. L2, line dirty in the cache
    amo_word_dirty = 100;
    dcache_flush();
    amo_word_dirty = 200;
    old = amoadd(&amo_word_dirty, 7);
    now = amo_word_dirty;
    dcache_enable(0);
    l2 = amo_word_dirty;
    dcache_enable(1);
    printf("amo L2 dirty: amo old %d, core reads %d, L2 after flush %d (coherent: 200, 207, 207)\n", old, now, l2);

    printf("dcache_amo_test: %d errors\n", errors);
    return errors;
}
