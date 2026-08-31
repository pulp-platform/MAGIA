/*
 * Copyright (C) 2026 Fondazione Chips-IT
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
 * elw_race — minimal, deterministic reproduction of the cv.elw hang found
 * while porting vector_dot. See PIC_CALL_OVERHEAD.md for the root cause.
 *
 * Three hand-written variants (plain C, raw-asm same-pattern, raw-asm
 * forced same-address contention) all failed to reproduce the hang under
 * the original (buggy) DEPTH=2 LSU, even though they all put a store
 * immediately before a cv.elw. That means the detail that matters isn't
 * just "store then elw with nothing between" -- it's the exact TCDM
 * traffic PLAY's vector_dot_pulp_open_cluster() generates right before
 * the barrier (a cv.setup hardware loop of cv.lw's feeding fmadd.s,
 * confirmed byte-for-byte in vector_dot's own disassembly at
 * cc0014e0-cc001536), which leaves a load response in flight when the
 * final cv.sw (local_dot[id] = ...) issues.
 *
 * So instead of hand-approximating that shape, this test #includes the
 * exact same PLAY source vector_dot_task.c uses (vector_dot.c +
 * arch/vector_dot_pulp_open.c) with the same compiler flags (same
 * Makefile), which guarantees byte-identical codegen for the critical
 * region. The only difference from the real vector_dot test is a much
 * smaller LEN, to keep sim time short.
 */

#include "magia_tile_utils.h"
#include "cluster_utils.h"

#include "../../../../../../../PLAY/source/vector_dot/vector_dot.c"
#include "../../../../../../../PLAY/source/vector_dot/arch/vector_dot_pulp_open.c"

typedef struct {
    uint32_t src_a;
    uint32_t src_b;
    uint32_t dst;
    uint32_t len;
} elw_race_params_t;

static void elw_race_fork_entry(void *arg) {
    elw_race_params_t *p = (elw_race_params_t *)arg;
    vector_dot((const float *)p->src_a, (const float *)p->src_b,
               (float *)p->dst, (int)p->len);
}

int elw_race_task(void *data) {
    elw_race_params_t *params = (elw_race_params_t *)data;
    pi_cl_team_fork(PULP_CORE_COUNT, elw_race_fork_entry, params);
    return 0;
}
