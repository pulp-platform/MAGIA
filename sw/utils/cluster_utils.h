/*
 * Copyright (C) 2023-2026 ETH Zurich, University of Bologna and Fondazione Chips-IT
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
 * PULP Cluster Utilities for MAGIA — aligned with magia-sdk
 * (lz/magia_v3/pulp_on_magia).
 *
 * Two usage perspectives:
 *
 *   CV32 (main core) — orchestrator:
 *     cluster_start(binary, mask)  one-shot kick: writes BINARY, NB_CORES_TO_WAIT
 *                                  (popcount of mask) and CLK_EN (mask)
 *     cluster_wait_polling()       spin on PULP_DONE (blocking)
 *     cluster_is_done()            non-blocking status read
 *     cluster_init_eu()            arm Event Unit for cluster-done WFE
 *     cluster_wait_eu()            WFE on cluster_done (EU bit 22), then
 *                                  clears the CSR (read-to-clear)
 *     cluster_stop()               de-assert PULP clock-enable mask
 *
 *   PULP cluster core — worker:
 *     cluster_core_id()            local index within the cluster (0..N-1)
 *     cluster_tile_id()            tile index of this core
 *     cluster_chunk_offset/size()  data partition helpers
 *
 * Hardware (obi_slave_ctrl_cluster.sv) memory map @ PULP_CTRL_BASE = 0x1740:
 *   +0x00 PULP_CLK_EN           one-hot bitmask (bit N => core N)
 *   +0x04 PULP_BINARY           entry point address for all cores
 *   +0x08 PULP_NB_CORES_TO_WAIT number of harts the CSR waits for
 *   +0x0C PULP_DONE             sticky done flag (R: read-to-clear,
 *                                                 W: each hart signals exit)
 *   EU bit 22 = cluster_done from obi_slave_ctrl_cluster.
 */

#ifndef CLUSTER_UTILS_H
#define CLUSTER_UTILS_H

#include <stdint.h>
#include "magia_tile_utils.h"
#include "magia_pulp_utils.h"
#include "event_unit_utils.h"

// =============================================================================
// CV32 (main core) — orchestrator API
// =============================================================================

/**
 * @brief Bring up the PULP cluster cores selected by @p core_mask.
 *
 *   1) Write the binary entry point to PULP_BINARY.
 *   2) Write popcount(core_mask) to PULP_NB_CORES_TO_WAIT.
 *   3) Write @p core_mask to PULP_CLK_EN, releasing the selected cores.
 *
 * @param binary_start  Entry point address (typically PULP_BINARY_START).
 * @param core_mask     One-hot bitmask of PULP cores to enable.
 */
static inline void cluster_start(uint32_t binary_start, uint32_t core_mask) {
    pulp_init(binary_start, core_mask);
}

/** De-assert the PULP clock-enable mask. */
static inline void cluster_stop(void) {
    pulp_clk_dis();
}

/**
 * @brief Busy-poll until the cluster CSR signals done.
 *
 * The read clears the register (read-to-clear) so this must be called
 * exactly once per cluster run. Prefer cluster_wait_eu() for energy.
 */
static inline void cluster_wait_polling(void) {
    while (!(mmio32(PULP_DONE) & 1))
        ;
}

/** Non-blocking status check (clears the register if it was set). */
static inline uint32_t cluster_is_done(void) {
    return mmio32(PULP_DONE) & 1;
}

/**
 * @brief Arm the Event Unit for cluster-done WFE.
 *
 * Clears the EU event buffer and enables EU bit 22.
 * Call before cluster_start() to avoid missing the event.
 */
static inline void cluster_init_eu(void) {
    eu_clear_events(0xFFFFFFFF);
    eu_enable_events(EU_CLUSTER_DONE_MASK);
}

/**
 * @brief Sleep until the cluster CSR signals done, then clear it.
 *
 *   cluster_init_eu();
 *   cluster_start(PULP_BINARY_START, 0xFF);
 *   cluster_wait_eu();
 */
static inline void cluster_wait_eu(void) {
    do {
        eu_wait_events_wfe(EU_CLUSTER_DONE_MASK);
    } while (!(mmio32(PULP_DONE) & 1));
}

// =============================================================================
// Cluster core (worker) — identity helpers
// =============================================================================

static inline uint32_t cluster_core_id(void) {
    uint32_t hartid;
    asm volatile("csrr %0, mhartid" : "=r"(hartid));
    return (hartid - PULP_HARTID_BASE) % PULP_CORE_COUNT;
}

static inline uint32_t cluster_tile_id(void) {
    uint32_t hartid;
    asm volatile("csrr %0, mhartid" : "=r"(hartid));
    return (hartid - PULP_HARTID_BASE) / PULP_CORE_COUNT;
}

// =============================================================================
// Cluster core (worker) — data partitioning helpers
// =============================================================================

static inline uint32_t cluster_chunk_offset(uint32_t total, uint32_t n_cores,
                                            uint32_t core_id) {
    return (total / n_cores) * core_id;
}

static inline uint32_t cluster_chunk_size(uint32_t total, uint32_t n_cores,
                                          uint32_t core_id) {
    uint32_t base = total / n_cores;
    return (core_id == n_cores - 1) ? (total - base * core_id) : base;
}

#endif /* CLUSTER_UTILS_H */
