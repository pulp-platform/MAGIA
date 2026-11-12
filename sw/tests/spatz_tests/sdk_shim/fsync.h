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
 * magia-sdk fsync.h on the MAGIA memory-mapped Fractal Sync utils
 */
#ifndef SDK_SHIM_FSYNC_H
#define SDK_SHIM_FSYNC_H

// The fsync ISA instruction shares its opcode with the CV32E40PX Xcv extension
#include "fsync_mm_api.h"

#define MAX_SYNC_LVL (31 - __builtin_clz(NUM_HARTS))

static inline void fsync_init(void) {}

// shortcut: every level syncs the whole mesh, map the levels when a test needs a smaller group
static inline int fsync_sync_level(uint32_t level, uint8_t dir) {
    fsync_mm_global();
    return 0;
}

#endif
