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
 * Authors: Niccolò Giuliani <niccolo.giuliani@chips.it>
 *
 * CoreMark (EEMBC, github.com/eembc/coremark at 9d07b05, the files unchanged: coremark.md5) on the MAGIA control
 * core. The test is built from one source file: this one includes the port and the EEMBC files.
 *
 *   make all test=coremark_test dcache=1 EXTRA_CFLAGS="-DCOREMARK_MEM=1 -DITERATIONS=1"
 *
 * COREMARK_MEM: 0 data in the L1 SPM, 1 in the L2 through the data cache, 2 in the L2 with the cache off
 * (core_portme.h). The exit code is 0 when the CRCs of the run are the known ones. The "at least 10 secs" line
 * of CoreMark always appears (a simulation runs for milliseconds): the numbers are cycles, not a reported score.
 */

#pragma GCC optimize("no-branch-count-reg")

#include "core_portme.c"
#include "core_list_join.c"
#include "core_main.c"
#include "core_matrix.c"
/* GCC 14 and the corev GCC stop with an internal error (maybe_postinc, expr.cc) on core_state.c at -O2 with the
 * CV32 post-increment loads: the loop optimizer is off for this file only. */
#pragma GCC push_options
#pragma GCC optimize("no-tree-loop-optimize")
#include "core_state.c"
#pragma GCC pop_options
#include "core_util.c"
