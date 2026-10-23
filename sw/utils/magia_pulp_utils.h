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
 * Bare-metal PULP Cluster Utility Functions (CV32 control side): boot the cluster and dispatch tasks to core 0
 */
#ifndef MAGIA_PULP_UTILS_H
#define MAGIA_PULP_UTILS_H

#include <stdint.h>
#include "magia_tile_utils.h"

/* ---- Low-level register helpers ---------------------------------------- */

/* Start all cores once after reset: FETCH_EN is sticky in the cores and every write clears READY */
static inline void pulp_fetch_en(void) { mmio32(PULP_FETCH_EN) = 1; }

static inline void pulp_set_binary(uint32_t addr) {
    mmio32(PULP_BINARY) = addr;
}

static inline void pulp_set_func(uint32_t task_addr) {
    mmio32(PULP_TASKBIN) = task_addr;
}

static inline void pulp_pass_params(uint32_t params_ptr) {
    mmio32(PULP_DATA) = params_ptr;
}

/* ---- High-level dispatch API ------------------------------------------- */

/* Boot once after reset: set the entry point, broadcast FETCH_EN, wait for PULP_READY */
static inline void pulp_init(uint32_t binary_start) {
    pulp_set_binary(binary_start);
    pulp_fetch_en();
    while ((mmio32(PULP_READY) & 1u) == 0u) { }
}

/* Dispatch a task to core 0, returning once core 0 has ACK'd PULP_START */
static inline void pulp_run_task(uint32_t task_addr) {
    pulp_set_func(task_addr);
    mmio32(PULP_START) = 1;
    while (mmio32(PULP_START) != 0u) { }
}

/* Dispatch a task with a context pointer passed as first argument */
static inline void pulp_run_task_with_params(uint32_t task_addr,
                                             uint32_t params_ptr) {
    pulp_pass_params(params_ptr);
    pulp_run_task(task_addr);
}

#endif /* MAGIA_PULP_UTILS_H */
