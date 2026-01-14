/*
 * Copyright (C) 2023-2024 ETH Zurich and University of Bologna
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
 * Authors: Luca Balboni <luca.balboni10@studio.unibo.it>
 *
 * Performance Counter Utilities for Snitch
 */

#ifndef __PERF_COUNTERS_H__
#define __PERF_COUNTERS_H__

#include <stdint.h>

static inline uint32_t read_mcyclel(void) {
    uint32_t cyclel;
    asm volatile("csrr %0, mcycle" : "=r"(cyclel));
    return cyclel;
}

static inline uint32_t read_mcycleh(void) {
    uint32_t cycleh;
    asm volatile("csrr %0, mcycleh" : "=r"(cycleh));
    return cycleh;
}

static inline uint32_t read_mcycle(void) {
    return read_mcyclel();
}

#define PERF_START() read_mcycle()
#define PERF_END(start) (read_mcycle() - (start))

#endif // __PERF_COUNTERS_H__
