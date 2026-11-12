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
 * Authors: Luca Balboni <luca.balboni10@studio.unibo.it>
 *
 * Spatz control from the CV32: boot the CV32E40PX+Spatz core once, then dispatch tasks like to a one-core cluster
 */
#ifndef MAGIA_SPATZ_UTILS_H
#define MAGIA_SPATZ_UTILS_H

#include <stdint.h>
#include "magia_tile_utils.h"

// Same register map as PULP_CTRL (obi_slave_ctrl_cluster)
#define SPATZ_FETCH_EN (SPATZ_CTRL_BASE + 0x00)  // R/W boot enable, sticky in the core; every write resets READY
#define SPATZ_BINARY   (SPATZ_CTRL_BASE + 0x04)  // R/W boot address
#define SPATZ_DONE     (SPATZ_CTRL_BASE + 0x08)  // W   Spatz signals completion, raising EU_SPATZ_DONE on the CV32
#define SPATZ_TASKBIN  (SPATZ_CTRL_BASE + 0x0C)  // R/W task function address
#define SPATZ_DATA     (SPATZ_CTRL_BASE + 0x10)  // R/W task argument (a0)
#define SPATZ_START    (SPATZ_CTRL_BASE + 0x14)  // R/W CV32 rings Spatz (its MEI), Spatz writes 0 to ACK
#define SPATZ_READY    (SPATZ_CTRL_BASE + 0x18)  // R 1 once Spatz booted, W Spatz posts 1 once armed
#define SPATZ_RETURN   (SPATZ_CTRL_BASE + 0x1C)  // R/W task exit code, written by Spatz before DONE
#define SPATZ_RETURN_CRASHED_BIT (0x80000000u)  // Set when Spatz trapped instead of returning; low bits are mcause

#define mmio32(x) (*(volatile uint32_t *)(x))

static inline void spatz_set_func(uint32_t addr) {
    mmio32(SPATZ_TASKBIN) = addr;
}

static inline void spatz_pass_params(uint32_t params_ptr) {
    mmio32(SPATZ_DATA) = params_ptr;
}

static inline uint32_t spatz_get_exit_code(void) {
    return mmio32(SPATZ_RETURN);
}

// Boot once after reset: FETCH_EN is sticky in the core, so a second boot does nothing
static inline void spatz_init(uint32_t binary_start) {
    mmio32(SPATZ_BINARY) = binary_start;
    mmio32(SPATZ_FETCH_EN) = 1;
    while ((mmio32(SPATZ_READY) & 1u) == 0u) { }
}

// Returns once Spatz has taken the task; completion comes as EU_SPATZ_DONE
static inline void spatz_run_task(uint32_t spatz_task_addr) {
    spatz_set_func(spatz_task_addr);
    mmio32(SPATZ_START) = 1;
    while (mmio32(SPATZ_START) != 0u) { }
}

static inline void spatz_run_task_with_params(uint32_t spatz_task_addr, uint32_t params_ptr) {
    spatz_pass_params(params_ptr);
    spatz_run_task(spatz_task_addr);
}

#endif
