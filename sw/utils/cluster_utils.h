/*
 * Copyright (C) 2023-2025 ETH Zurich and University of Bologna
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
 * PULP Cluster Utilities for MAGIA
 *
 * Two usage perspectives:
 *
 *   CV32 (main core) — orchestrator:
 *     cluster_start()              kick all N cluster cores
 *     cluster_wait_polling()       spin on PULP_DONE (blocking)
 *     cluster_is_done()            non-blocking status read
 *     cluster_init_eu()            arm Event Unit for cluster-done WFE
 *     cluster_wait_eu()            WFE on cluster_done (via EU bit 22),
 *                                  then clears the CSR
 *
 *   CV32E40P cluster core — worker:
 *     cluster_core_id()            local index within the cluster (0..N-1)
 *     cluster_tile_id()            tile index of this core
 *     cluster_chunk_offset()       data partition offset for this core
 *     cluster_chunk_size()         data partition size  for this core
 *
 * Hardware background:
 *   - PULP_FETCH_EN  (PULP_CTRL_BASE + 0x00): W:1 releases all cluster cores
 *   - PULP_DONE      (PULP_CTRL_BASE + 0x04): R:1 = all cores done (read-to-clear)
 *                                             W:1 = each cluster core signals exit (from crt0)
 *   - EU bit 22 = cluster_done from obi_slave_ctrl_cluster, fed via other_events_i
 *     (see magia_tile.sv: assign other_events_shared = {..., cluster_done, 22'b0})
 */

#ifndef CLUSTER_UTILS_H
#define CLUSTER_UTILS_H

#include <stdint.h>
#include "magia_tile_utils.h"
#include "event_unit_utils.h"

// =============================================================================
// CV32 (main core) — orchestrator API
// =============================================================================

/**
 * @brief Release all PULP cluster cores of this tile.
 *
 * Writes 1 to PULP_FETCH_EN. The cluster cores start fetching from
 * PULP_BOOT_ADDR (0xC0000080) after this call.
 * Must be called after any cluster-side setup (iDMA pre-loads, HWPE init…)
 * is complete.
 */
static inline void cluster_start(void) {
    mmio32(PULP_FETCH_EN) = 1;
}

/**
 * @brief Busy-poll until all cluster cores have signalled done.
 *
 * Reads PULP_DONE until bit 0 is set. The read itself clears the register
 * (read-to-clear), so this must be called exactly once per cluster run.
 * Prefer cluster_wait_eu() for energy efficiency.
 */
static inline void cluster_wait_polling(void) {
    while (!(mmio32(PULP_DONE) & 1))
        ;
}

/**
 * @brief Non-blocking check: returns non-zero if all cluster cores are done.
 *
 * NOTE: this read is NOT destructive only when the result is 0.
 * If it returns non-zero the PULP_DONE register has been cleared;
 * a subsequent cluster_wait_polling() / cluster_wait_eu() call would
 * hang indefinitely.  Use this only for status checks before the wait.
 */
static inline uint32_t cluster_is_done(void) {
    return mmio32(PULP_DONE) & 1;
}

/**
 * @brief Arm the Event Unit for cluster-done WFE.
 *
 * Clears the full EU event buffer and enables EU bit 22 (EU_CLUSTER_DONE_MASK).
 * Call this before cluster_start() to avoid missing the event.
 */
static inline void cluster_init_eu(void) {
    eu_clear_events(0xFFFFFFFF);
    eu_enable_events(EU_CLUSTER_DONE_MASK);
}

/**
 * @brief Sleep (cv.elw / p.elw) until all cluster cores are done, then clear.
 *
 * Uses the Event Unit WFE mechanism (EU bit 22 = cluster_done).
 * After waking, reads PULP_DONE to de-assert the RTL cluster_done signal
 * (read-to-clear); if the signal is still low (spurious wake) the function
 * re-arms and sleeps again.
 *
 * Typical usage:
 *   cluster_init_eu();
 *   cluster_start();
 *   cluster_wait_eu();
 */
static inline void cluster_wait_eu(void) {
    do {
        eu_wait_events_wfe(EU_CLUSTER_DONE_MASK);
    } while (!(mmio32(PULP_DONE) & 1));
    /* PULP_DONE read above already cleared the CSR (read-to-clear). */
}

// =============================================================================
// Cluster core (worker) — identity helpers
// =============================================================================

/**
 * @brief Local core index within the cluster: 0 .. PULP_CORE_COUNT-1.
 */
static inline uint32_t cluster_core_id(void) {
    uint32_t hartid;
    asm volatile("csrr %0, mhartid" : "=r"(hartid));
    return (hartid - PULP_HARTID_BASE) % PULP_CORE_COUNT;
}

/**
 * @brief Tile index of this cluster core: 0 .. NUM_CLUSTERS-1.
 */
static inline uint32_t cluster_tile_id(void) {
    uint32_t hartid;
    asm volatile("csrr %0, mhartid" : "=r"(hartid));
    return (hartid - PULP_HARTID_BASE) / PULP_CORE_COUNT;
}

// =============================================================================
// Cluster core (worker) — data partitioning helpers
// =============================================================================

/**
 * @brief Starting element index for this core given a 1-D array of `total`
 *        elements split evenly among `n_cores` cores.
 */
static inline uint32_t cluster_chunk_offset(uint32_t total, uint32_t n_cores,
                                             uint32_t core_id) {
    return (total / n_cores) * core_id;
}

/**
 * @brief Number of elements assigned to this core.
 *        The last core absorbs any remainder (total % n_cores).
 */
static inline uint32_t cluster_chunk_size(uint32_t total, uint32_t n_cores,
                                           uint32_t core_id) {
    uint32_t base = total / n_cores;
    return (core_id == n_cores - 1) ? (total - base * core_id) : base;
}

#endif /* CLUSTER_UTILS_H */
