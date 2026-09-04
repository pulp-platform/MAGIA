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
 */

/*
 * play_l1_linkage.h -- pre-includes the headers the PLAY kernel sources pull
 * in, so a task wrapper can safely neutralise `static` around its PLAY
 * #includes.
 *
 * WHY THAT IS NEEDED
 * ------------------
 * Several PLAY arch files declare their PI_L1 scalars `static`:
 *
 *     static PI_L1 float ONE_f   = 1.0f;
 *     static PI_L1 int   MAX_ITER = 200;
 *
 * `static` gives them internal linkage. GCC then knows the symbol cannot be
 * interposed, so under -fPIC -mcmodel=medany it addresses it with a direct
 * PC-relative auipc+lw instead of going through the GOT:
 *
 *     auipc a5, 0x37
 *     addi  a5, a5, 816    # 38028 <MAX_ITER>
 *     lw    a4, 0(a5)
 *
 * That is correct for ordinary blob data, whose VMA is blob-relative. It is
 * WRONG for .l1data: pulp_program.ld gives that section an ABSOLUTE TCDM VMA
 * (0x00038000) and deliberately does not relocate it with the blob, because
 * the whole point is to land in the cluster L1. A PC-relative access instead
 * resolves to blob_base + 0x38000 (~0xCC038xxx), which is past the end of the
 * 32 KB instruction RAM (magia_tile_pkg::INSTRRAM_SIZE) and falls into
 * uninitialised L2 -- so the load silently returns 0.
 *
 * pulp_crt0.S already guards against a related hazard, but only for GOT
 * entries (it keeps the ones pointing into [__l1data_start, __l1data_end)
 * absolute instead of rebasing them). A PC-relative access never touches the
 * GOT, so the fixup never sees it.
 *
 * The failure is silent and total: the crt0 copies the correct initial image
 * to 0x38000, nothing ever reads it back, and every such scalar evaluates to
 * 0. Observed consequences before this fix:
 *
 *   - linalg_svd_lsv:    ONE_f == 0  =>  s_inv = ONE_f/s = 0  =>  the whole
 *                        result matrix came out zero (2004/2048 mismatches).
 *   - linalg_svd_jacobi: MAX_ITER == 0  =>  the sweep loop never ran, the
 *                        `if (iter >= MAX_ITER)` non-convergence branch fired
 *                        immediately, and pmsis_exit(-1) (a `while (1) {}`)
 *                        hung all 8 cores until the runner's 2 h timeout.
 *   - linalg_svd:        composes both, so it inherited the same hang.
 *
 * THE FIX
 * -------
 * Neutralising `static` for the duration of the PLAY #includes gives those
 * symbols external linkage, which forces GCC through the GOT and lets the
 * crt0 fixup keep them absolute. `inline` has to go with it: `static inline`
 * would otherwise degrade to a bare C99 inline definition, which emits no
 * external symbol and fails to link if GCC decides not to inline the call.
 *
 * Including this header first is what makes that safe. It pulls in the PLAY
 * and PMSIS headers while `static` still means `static`, so their own
 * internal helpers (pmsis_l1_malloc(), pmsis_exit(), ...) keep the linkage
 * they were written with; only the arch file's own declarations are affected.
 *
 * Usage in a task wrapper:
 *
 *     #include "play_l1_linkage.h"
 *
 *     #define static
 *     #define inline
 *     #include ".../PLAY/source/<kernel>/<kernel>.c"
 *     #include ".../PLAY/source/<kernel>/arch/<kernel>_pulp_open.c"
 *     #undef inline
 *     #undef static
 *
 * The Makefile's `check-l1data-linkage` step enforces the result: if any LOCAL
 * symbol is left in .l1data, the build fails rather than producing a binary
 * that reads zeros.
 */

#ifndef MAGIA_PLAY_L1_LINKAGE_H
#define MAGIA_PLAY_L1_LINKAGE_H

#include "internal/arch_interface.h"
#include "play.h"
#include "pmsis.h"

#endif /* MAGIA_PLAY_L1_LINKAGE_H */
