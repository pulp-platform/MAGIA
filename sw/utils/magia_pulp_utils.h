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
 * Bare-metal PULP Cluster Utility Functions (CV32 control side).
 *
 * Dynamic dispatch model (CV32 -> PULP cluster):
 *   1. pulp_init(binary)   boot all cores into the PULP dispatcher loop; polls
 *                          PULP_READY until every core is armed.
 *   2. pulp_run_task(task) dispatch the task function: writes TASKBIN = task,
 *                          then PULP_START = 1, which rings a 1-cycle doorbell
 *                          on core 0's Event Unit slice (core 0 is the sole
 *                          bridge to the control core; it may then fork work
 *                          onto the other 7 cores itself, e.g. via
 *                          pi_cl_team_fork()). CV32 polls PULP_START until
 *                          core 0 ACKs it (write 0).
 *   3. cluster_wait_done_eu()/_polling() wait for PULP_DONE (written once, by
 *                          core 0, when the task returns).
 *
 *   pulp_run_task_with_params() also writes PULP_DATA so the task receives a
 *   context pointer as its first argument (a0).
 *
 * Register map: see magia_tile_utils.h (PULP_CTRL_BASE).
 */
#ifndef MAGIA_PULP_UTILS_H
#define MAGIA_PULP_UTILS_H

#include <stdint.h>
#include "magia_tile_utils.h"

/* ---- Low-level register helpers ---------------------------------------- */

static inline void pulp_clk_en(void)  { mmio32(PULP_CLK_EN) = 1; }
static inline void pulp_clk_dis(void) { mmio32(PULP_CLK_EN) = 0; }

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

/**
 * @brief Boot the PULP cluster: write the binary entry point, enable all
 *        cores (CLK_EN broadcast), then wait until every core has armed its
 *        dispatcher (PULP_READY == 1).
 */
static inline void pulp_init(uint32_t binary_start) {
    pulp_set_binary(binary_start);
    pulp_clk_en();
    while ((mmio32(PULP_READY) & 1u) == 0u) { }
}

/**
 * @brief Dispatch @p task_addr to core 0 (the cluster's sole dispatcher).
 *        Returns once the start has been ACK'd (write-0 to PULP_START), i.e.
 *        once core 0 has entered the task function. core 0 may fork work onto
 *        the other 7 cores itself from within the task (e.g. pi_cl_team_fork()).
 *        Use cluster_wait_done_eu()/cluster_wait_done_polling() for completion.
 */
static inline void pulp_run_task(uint32_t task_addr) {
    pulp_set_func(task_addr);
    mmio32(PULP_START) = 1;
    while (mmio32(PULP_START) != 0u) { }
}

/**
 * @brief Dispatch a task with a context pointer passed as first argument.
 */
static inline void pulp_run_task_with_params(uint32_t task_addr,
                                             uint32_t params_ptr) {
    pulp_pass_params(params_ptr);
    pulp_run_task(task_addr);
}

#endif /* MAGIA_PULP_UTILS_H */
