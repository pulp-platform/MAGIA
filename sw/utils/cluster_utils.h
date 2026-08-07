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
 * Bare-metal PULP Cluster Utilities for MAGIA.
 *
 * Two usage perspectives:
 *
 *   CV32 (main core) — orchestrator:
 *     cluster_boot(binary)         boot all PULP cores into the dispatcher
 *                                  loop (= pulp_init); polls PULP_READY.
 *     cluster_arm_done_event()     clear/enable the CV32 EU done event
 *     cluster_dispatch_task()      write TASKBIN, ring the START doorbell;
 *                                  returns once core 0 has ACK'd
 *     cluster_wait_done_polling()  spin on the CV32 EU done event
 *     cluster_done_pending()       non-blocking EU done-event check
 *     cluster_wait_done_eu()       WFE on PULP_DONE (EU bit 12)
 *     cluster_stop()               de-assert PULP CLK_EN
 *
 *   PULP cluster core — worker:
 *     cluster_core_id()            local index within the cluster (0..N-1)
 *     cluster_tile_id()            tile index of this core
 *     cluster_chunk_offset/size()  data partition helpers
 *
 *   PULP cluster core — team fork/barrier (pulp-sdk-API-compatible):
 *     pi_core_id()                 alias of cluster_core_id(), pulp-sdk name
 *     pi_cl_team_fork(n, fn, arg)  fan fn(arg) out to n cores + rendez-vous
 *     pi_cl_team_barrier()         stand-alone rendez-vous on barrier 0
 *
 * Hardware (obi_slave_ctrl_cluster.sv) memory map @ PULP_CTRL_BASE = 0x1740:
 *   see magia_tile_utils.h. EU bit 12 = PULP_DONE (one write by the dispatcher
 *   core).
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

static inline void cluster_boot(uint32_t binary_start) {
    pulp_init(binary_start);
}

static inline void cluster_dispatch_task(uint32_t task_addr) {
    pulp_run_task(task_addr);
}

static inline void cluster_dispatch_task_with_params(uint32_t task_addr,
                                                     uint32_t params_ptr) {
    pulp_run_task_with_params(task_addr, params_ptr);
}

static inline void cluster_stop(void) {
    pulp_clk_dis();
}

static inline void cluster_resume(void) {
    pulp_clk_en();
}

static inline void cluster_wait_done_polling(void) {
    (void)eu_cluster_done_wait(EU_WAIT_MODE_POLLING);
}

static inline uint32_t cluster_done_pending(void) {
    return eu_check_events(EU_CLUSTER_DONE_MASK) != 0;
}

static inline void cluster_arm_done_event(void) {
    eu_cluster_done_init();
}

static inline void cluster_wait_done_eu(void) {
    (void)eu_cluster_done_wait(EU_WAIT_MODE_WFE);
}

static inline int32_t cluster_get_return_value(void) {
    return (int32_t)mmio32(PULP_RETURN);
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

// =============================================================================
// Cluster core — team fork/barrier
// Native, bare-metal reimplementation of the pulp-sdk primitives PLAY's
// =============================================================================

#define CLUSTER_EU_DISPATCH_OFFSET    (0x80)
#define CLUSTER_EU_DISPATCH_FIFO      (CLUSTER_EU_DIRECT_BASE + CLUSTER_EU_DISPATCH_OFFSET + 0x00)
#define CLUSTER_EU_DISPATCH_TEAM_CFG  (CLUSTER_EU_DIRECT_BASE + CLUSTER_EU_DISPATCH_OFFSET + 0x04)

#define CLUSTER_EU_BARRIER_OFFSET     (0x200)
#define CLUSTER_EU_BARRIER_SIZE       (0x20)
#define CLUSTER_EU_BARRIER0_ADDR      (CLUSTER_EU_DIRECT_BASE + CLUSTER_EU_BARRIER_OFFSET)
#define CLUSTER_EU_BARR_TRIGGER_MASK  (0x00)
#define CLUSTER_EU_BARR_TARGET_MASK   (0x0C)
#define CLUSTER_EU_BARR_WAIT_CLEAR    (0x1C)

#define CLUSTER_EU_MUTEX_OFFSET       (0xC0)
#define CLUSTER_EU_MUTEX0_ADDR        (CLUSTER_EU_DIRECT_BASE + CLUSTER_EU_MUTEX_OFFSET)


#define CLUSTER_EU_SW_EVT_TRIG_OFFSET (0x100)
#define CLUSTER_EU_SW_EVT_TRIG(id)    (CLUSTER_EU_DIRECT_BASE + CLUSTER_EU_SW_EVT_TRIG_OFFSET + ((id) << 2))

#define CLUSTER_EU_SW_EVT_BIT(id) (4u + (id))

static inline void pi_cl_sw_event_trigger(unsigned int id, uint32_t core_mask) {
    mmio32(CLUSTER_EU_SW_EVT_TRIG(id)) = core_mask;
}

static inline void pi_cl_sw_event_wait(unsigned int id) {
    uint32_t bit = 1u << CLUSTER_EU_SW_EVT_BIT(id);
    mmio32(CLUSTER_EU_DIRECT_BASE + 0x08) = bit;                 /* EU_CORE_MASK_OR */
    (void)evt_read32(CLUSTER_EU_DIRECT_BASE, 0x3C);               /* EU_EVENT_WAIT_CLR */
}


static inline uint32_t pi_core_id(void) {
    return cluster_core_id();
}

static inline void pi_cl_team_critical_enter(void) {
    (void)evt_read32(CLUSTER_EU_MUTEX0_ADDR, 0);
}

static inline void pi_cl_team_critical_exit(void) {
    mmio32(CLUSTER_EU_MUTEX0_ADDR) = 0;
}

static inline void pi_cl_team_barrier_id(unsigned int barrier_id) {
    uint32_t addr = CLUSTER_EU_DIRECT_BASE + CLUSTER_EU_BARRIER_OFFSET
                   + barrier_id * CLUSTER_EU_BARRIER_SIZE;
    (void)evt_read32(addr, CLUSTER_EU_BARR_WAIT_CLEAR);
}


static inline void pi_cl_team_barrier(void) {
    (void)evt_read32(CLUSTER_EU_BARRIER0_ADDR, CLUSTER_EU_BARR_WAIT_CLEAR);
}

static inline void pi_cl_team_fork(int nb_cores, void (*entry)(void *), void *arg) {
    uint32_t core_mask = (nb_cores >= 32) ? 0xFFFFFFFFu : ((1u << nb_cores) - 1u);

    if (nb_cores) {
        mmio32(CLUSTER_EU_DISPATCH_TEAM_CFG) = core_mask;
        mmio32(CLUSTER_EU_BARRIER0_ADDR + CLUSTER_EU_BARR_TRIGGER_MASK) = core_mask;
        mmio32(CLUSTER_EU_BARRIER0_ADDR + CLUSTER_EU_BARR_TARGET_MASK)  = core_mask;
    }

    mmio32(CLUSTER_EU_DISPATCH_FIFO) = (uint32_t)entry;
    mmio32(CLUSTER_EU_DISPATCH_FIFO) = (uint32_t)arg;

    /* The calling core is itself a member of the team. */
    entry(arg);

    pi_cl_team_barrier();
}

/* Lower-level primitive for running MULTIPLE independent teams on disjoint core subsets at once */ 
//NOT IN THE PULP-SDK API

static inline void pi_cl_team_push_other(uint32_t core_mask, void (*entry)(void *), void *arg) {
    mmio32(CLUSTER_EU_DISPATCH_TEAM_CFG) = core_mask;
    mmio32(CLUSTER_EU_DISPATCH_FIFO) = ((uint32_t)entry) | 1u;  /* bit 0 set: other entry, no auto barrier */
    mmio32(CLUSTER_EU_DISPATCH_FIFO) = (uint32_t)arg;
}


static inline void pi_cl_team_barrier_setup(unsigned int barrier_id, uint32_t core_mask) {
    uint32_t addr = CLUSTER_EU_DIRECT_BASE + CLUSTER_EU_BARRIER_OFFSET
                   + barrier_id * CLUSTER_EU_BARRIER_SIZE;
    mmio32(addr + CLUSTER_EU_BARR_TRIGGER_MASK) = core_mask;
    mmio32(addr + CLUSTER_EU_BARR_TARGET_MASK)  = core_mask;
}

#endif /* CLUSTER_UTILS_H */
