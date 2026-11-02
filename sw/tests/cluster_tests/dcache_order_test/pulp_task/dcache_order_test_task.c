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
 * dcache_order_test - PULP cluster task.
 *   Cores 0 .. ncache-1: read-modify-write of their own word (word = core id, so bank = core id in the data store)
 *   in every line of the buffer, `depth` lines per set, each core starting at another line: hits and misses on the
 *   same lines from different cores, dirty victims evicted while other cores hit them. Each core also reads the
 *   word of the next core: a word only grows, so a smaller value than the last one seen is a stale read.
 *   The other cores: SPM reads on the banks of those words until the cache cores are done, so the hits of the
 *   cache wait for the bank and stay longer in flight.
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "cluster_utils.h"

// GCC 14 crashes ("could not split insn", doloop_begin_i) on the cv32e40p hardware loop of the big loops
#pragma GCC optimize("no-branch-count-reg")

#define LINE_WORDS (32)
#define SET_WORDS  (64 * LINE_WORDS)   /* 8 KiB: lines at this distance share the set */
#define MAX_LINES  (64)

typedef struct {
    uint32_t buf;                      /* L2 buffer, aligned to 8 KiB */
    uint32_t spm;                      /* SPM area of the hammer cores */
    uint32_t nsets;
    uint32_t depth;
    uint32_t reps;
    uint32_t ncache;                   /* cores on the cache, the others hammer the SPM */
    uint32_t done[PULP_CORE_COUNT];
    uint32_t errors[PULP_CORE_COUNT];
    uint32_t cycles[PULP_CORE_COUNT];
    uint32_t progress[PULP_CORE_COUNT];  /* accesses done, read by the main core if the task hangs */
} dcache_order_params_t;

static inline uint32_t read_mcycle(void) {
    uint32_t cycles;
    asm volatile("csrr %0, mcycle" : "=r"(cycles));
    return cycles;
}

static void dcache_order_fork_entry(void *arg) {
    volatile dcache_order_params_t *p = (volatile dcache_order_params_t *)arg;
    volatile uint32_t *buf = (volatile uint32_t *)p->buf;
    volatile uint32_t *spm = (volatile uint32_t *)p->spm;
    uint32_t id     = pi_core_id();
    uint32_t nsets  = p->nsets;
    uint32_t depth  = p->depth;
    uint32_t reps   = p->reps;
    uint32_t ncache = p->ncache;
    uint32_t nlines = nsets * depth;
    uint32_t errors = 0;
    volatile uint32_t last[MAX_LINES];  // volatile: no memset call (no libc)

    for (uint32_t l = 0; l < MAX_LINES; l++)
        last[l] = 0;
    asm volatile("csrw mcountinhibit, zero");
    pi_cl_team_barrier();
    uint32_t start = read_mcycle();

    if (id < ncache) {
        uint32_t next = (id + 1) % ncache;
        for (uint32_t r = 0; r < reps; r++) {
            for (uint32_t i = 0; i < nlines; i++) {
                uint32_t l    = (i + 3 * id) % nlines;
                uint32_t set  = l / depth;
                uint32_t k    = l % depth;
                volatile uint32_t *line = buf + k * SET_WORDS + set * LINE_WORDS;
                uint32_t v = line[id];
                line[id] = v + 1;
                uint32_t n = line[next];
                if ((n < last[l]) || (n > reps))
                    errors++;
                last[l] = n;
                p->progress[id] = r * nlines + i + 1;
            }
        }
        p->done[id] = 1;
    } else {
        uint32_t sink = 0;
        uint32_t j    = id;
        uint32_t busy = 1;
        while (busy) {
            for (uint32_t b = 0; b < ncache; b++)
                sink += spm[((j + b) % 64) * LINE_WORDS + b];
            j++;
            busy = 0;
            for (uint32_t c = 0; c < ncache; c++)
                if (!p->done[c])
                    busy = 1;
        }
        p->done[id] = sink;
    }

    p->cycles[id] = read_mcycle() - start;
    p->errors[id] = errors;
    pi_cl_team_barrier();
}

int dcache_order_test_task(void *data) {
    pi_cl_team_fork(PULP_CORE_COUNT, dcache_order_fork_entry, data);
    return 0;
}
