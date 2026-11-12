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
 * magia-sdk tile.h on the MAGIA utils, for the CV32 and the Spatz side of sdk_spatz_test
 */
#ifndef SDK_SHIM_TILE_H
#define SDK_SHIM_TILE_H

#include <stdint.h>
#include <stddef.h>
#include "magia_tile_utils.h"
#include "magia_utils.h"
#include "magia_spatz_utils.h"

typedef _Float16 float16;
#define mmio_fp16(x) (*(volatile float16 *)(x))
// No libc is linked: the tests copy only small fixed sizes, which the compiler inlines
#define memcpy __builtin_memcpy

// The CV32E40PX Spatz has no clock enable: it sleeps in WFI between tasks
static inline void spatz_clk_dis(void) {}

#endif
