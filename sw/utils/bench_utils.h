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
 * The few things every cache-vs-iDMA benchmark needs, in one place: reading the cycle counter, waiting for
 * an iDMA transfer, and issuing one that is longer than an iDMA descriptor can express. Before this header
 * each test carried its own copy; they were identical, and the copies are the reason a reader had to check
 * every test to be sure.
 */

#ifndef BENCH_UTILS_H
#define BENCH_UTILS_H

#include <stdint.h>
#include "magia_tile_utils.h"
#include "idma_mm_utils.h"

/* The cycle counter. It only runs if mcountinhibit has been cleared: every benchmark does it as its first
 * instruction, with `asm volatile("csrw mcountinhibit, zero")`. */
static inline uint32_t read_mcycle(void) {
    uint32_t cycles;
    asm volatile("csrr %0, mcycle" : "=r"(cycles));
    return cycles;
}

/* The iDMA numbers its transfers per direction, and the done id only grows: waiting for id means waiting
 * until the counter has reached it. The signed difference handles the wrap of the 32-bit counter. */
static inline void idma_wait_in(uint32_t id) {
    while ((int32_t)(idma_mm_get_done_id_dir(0, 0) - id) < 0);
}

static inline void idma_wait_out(uint32_t id) {
    while ((int32_t)(idma_mm_get_done_id_dir(1, 0) - id) < 0);
}

/* The length of one iDMA transfer is 16 bits: anything from 64 KiB up truncates, silently, and the first
 * sign is a checksum that fails three hundred lines later. These two split a long transfer and return the
 * id of the last piece, which is the one to wait for.
 *
 * `l1_loc` is the LOCAL L1 address, L1_LOCAL(off): the iDMA port is wired to the TCDM of its own tile and
 * does not know about the global window the core uses. See L1_LOCAL / L1_GLOBAL in magia_tile_utils.h; on a
 * single tile the two coincide, which is how a test can look right and still break on a mesh. */
#define IDMA_MAX_LEN (32 * 1024)

static inline uint32_t idma_in(uint32_t l2, uint32_t l1_loc, uint32_t bytes) {
    uint32_t id = 0;
    if (bytes <= IDMA_MAX_LEN)
        return idma_L2ToL1(l2, l1_loc, bytes);   /* the usual case: no loop in the timed path */
    for (uint32_t off = 0; off < bytes; off += IDMA_MAX_LEN) {
        uint32_t len = (bytes - off < IDMA_MAX_LEN) ? bytes - off : IDMA_MAX_LEN;
        id = idma_L2ToL1(l2 + off, l1_loc + off, len);
    }
    return id;
}

static inline uint32_t idma_out(uint32_t l1_loc, uint32_t l2, uint32_t bytes) {
    uint32_t id = 0;
    if (bytes <= IDMA_MAX_LEN)
        return idma_L1ToL2(l1_loc, l2, bytes);
    for (uint32_t off = 0; off < bytes; off += IDMA_MAX_LEN) {
        uint32_t len = (bytes - off < IDMA_MAX_LEN) ? bytes - off : IDMA_MAX_LEN;
        id = idma_L1ToL2(l1_loc + off, l2 + off, len);
    }
    return id;
}

/* The slowest core is the one that decides how long the team took */
static uint32_t max_of(const volatile uint32_t *v, uint32_t n) {
    uint32_t max = 0;
    for (uint32_t i = 0; i < n; i++)
        if (v[i] > max)
            max = v[i];
    return max;
}

static uint32_t sum_of(const volatile uint32_t *v, uint32_t n) {
    uint32_t s = 0;
    for (uint32_t i = 0; i < n; i++)
        s += v[i];
    return s;
}

#endif /* BENCH_UTILS_H */
