/*
 * Copyright (C) 2024 ETH Zurich and University of Bologna
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
 * MAGIA Event Unit - Generic utilities for all accelerators
 * Supports RedMulE, FSync, iDMA and custom events
 */

#ifndef EVENT_UNIT_UTILS_H
#define EVENT_UNIT_UTILS_H

#include <stdint.h>
#include "magia_tile_utils.h"

//=============================================================================
// Event Unit Register Map - Base addresses and offsets
//=============================================================================

#define EU_BASE                      EVENT_UNIT_BASE           // 0x800

// Core Event Unit registers - Main control and status
#define EU_CORE_MASK                 (EU_BASE + 0x00)          // R/W: Event mask (enables event lines)
#define EU_CORE_MASK_AND             (EU_BASE + 0x04)          // W: Clear bits in mask
#define EU_CORE_MASK_OR              (EU_BASE + 0x08)          // W: Set bits in mask
#define EU_CORE_IRQ_MASK             (EU_BASE + 0x0C)          // R/W: IRQ event mask
#define EU_CORE_IRQ_MASK_AND         (EU_BASE + 0x10)          // W: Clear IRQ mask bits
#define EU_CORE_IRQ_MASK_OR          (EU_BASE + 0x14)          // W: Set IRQ mask bits
#define EU_CORE_STATUS               (EU_BASE + 0x18)          // R: Core clock status
#define EU_CORE_BUFFER               (EU_BASE + 0x1C)          // R: Event buffer
#define EU_CORE_BUFFER_MASKED        (EU_BASE + 0x20)          // R: Buffer with mask applied
#define EU_CORE_BUFFER_IRQ_MASKED    (EU_BASE + 0x24)          // R: Buffer with IRQ mask
#define EU_CORE_BUFFER_CLEAR         (EU_BASE + 0x28)          // W: Clear received events
#define EU_CORE_SW_EVENTS_MASK       (EU_BASE + 0x2C)          // R/W: SW event target mask
#define EU_CORE_SW_EVENTS_MASK_AND   (EU_BASE + 0x30)          // W: Clear SW target bits
#define EU_CORE_SW_EVENTS_MASK_OR    (EU_BASE + 0x34)          // W: Set SW target bits

// Core Event Unit wait registers - Sleep functionality
#define EU_CORE_EVENT_WAIT           (EU_BASE + 0x38)          // R: Sleep until event
#define EU_CORE_EVENT_WAIT_CLEAR     (EU_BASE + 0x3C)          // R: Sleep + clear buffer

// Hardware barrier registers (0x20 * barr_id offset)
#define HW_BARR_TRIGGER_MASK         (EU_BASE + 0x400)         // R/W: Barrier trigger mask
#define HW_BARR_STATUS               (EU_BASE + 0x404)         // R: Barrier status
#define HW_BARR_TARGET_MASK          (EU_BASE + 0x40C)         // R/W: Barrier target mask
#define HW_BARR_TRIGGER              (EU_BASE + 0x410)         // W: Manual barrier trigger
#define HW_BARR_TRIGGER_SELF         (EU_BASE + 0x414)         // R: Automatic trigger
#define HW_BARR_TRIGGER_WAIT         (EU_BASE + 0x418)         // R: Trigger + sleep
#define HW_BARR_TRIGGER_WAIT_CLEAR   (EU_BASE + 0x41C)         // R: Trigger + sleep + clear

// Software event trigger registers (0x04 * sw_event_id offset)
#define EU_CORE_TRIGG_SW_EVENT       (EU_BASE + 0x600)         // W: Generate SW event
#define EU_CORE_TRIGG_SW_EVENT_WAIT  (EU_BASE + 0x640)         // R: Generate event + sleep
#define EU_CORE_TRIGG_SW_EVENT_WAIT_CLEAR (EU_BASE + 0x680)    // R: Generate event + sleep + clear

// SoC event FIFO register
#define EU_CORE_CURRENT_EVENT        (EU_BASE + 0x700)         // R: SoC event FIFO

// Hardware mutex registers (0x04 * mutex_id offset)
#define EU_CORE_HW_MUTEX             (EU_BASE + 0x0C0)         // R/W: HW mutex management

//=============================================================================
// Event Bit Mapping - Based on cluster_event_map.sv
//=============================================================================

// DMA Events [3:2] - dma_events_i mapping
#define EU_DMA_EVT_0_BIT             2                         // DMA event 0 (completion)
#define EU_DMA_EVT_1_BIT             3                         // DMA event 1 (error/status)
#define EU_DMA_EVT_MASK              0x0000000C                // bits 3:2

// Timer Events [5:4] - timer_events_i mapping  
#define EU_TIMER_EVT_0_BIT           4                         // Timer event 0
#define EU_TIMER_EVT_1_BIT           5                         // Timer event 1
#define EU_TIMER_EVT_MASK            0x00000030                // bits 5:4

// Accelerator Events [11:8] - acc_events_i mapping
#define EU_ACC_EVT_0_BIT             8                         // Accelerator event 0 (always zero)
#define EU_ACC_EVT_1_BIT             9                         // Accelerator event 1 (busy)
#define EU_ACC_EVT_2_BIT             10                        // Accelerator event 2 (completion)
#define EU_ACC_EVT_3_BIT             11                        // Accelerator event 3 (additional)
#define EU_ACC_EVT_MASK              0x00000F00                // bits 11:8

// RedMulE specific event mapping (within accelerator events)
#define EU_REDMULE_BUSY_BIT          EU_ACC_EVT_1_BIT          // bit 9 - RedMulE busy
#define EU_REDMULE_DONE_BIT          EU_ACC_EVT_2_BIT          // bit 10 - RedMulE completion
#define EU_REDMULE_EVT1_BIT          EU_ACC_EVT_3_BIT          // bit 11 - RedMulE additional event
#define EU_REDMULE_DONE_MASK         (1 << EU_REDMULE_DONE_BIT) // 0x400
#define EU_REDMULE_BUSY_MASK         (1 << EU_REDMULE_BUSY_BIT) // 0x200
#define EU_REDMULE_EVT1_MASK         (1 << EU_REDMULE_EVT1_BIT) // 0x800
#define EU_REDMULE_ALL_MASK          (EU_ACC_EVT_MASK)         // 0xF00

// iDMA specific event mapping (within DMA events)
// Based on magia_tile.sv: assign dma_events_array[0] = {idma_o2a_done, idma_a2o_done};
#define EU_IDMA_A2O_DONE_BIT         EU_DMA_EVT_0_BIT          // bit 2 - iDMA AXI2OBI (L2->L1) completion
#define EU_IDMA_O2A_DONE_BIT         EU_DMA_EVT_1_BIT          // bit 3 - iDMA OBI2AXI (L1->L2) completion
#define EU_IDMA_A2O_DONE_MASK        (1 << EU_IDMA_A2O_DONE_BIT) // 0x04 - L2->L1 done
#define EU_IDMA_O2A_DONE_MASK        (1 << EU_IDMA_O2A_DONE_BIT) // 0x08 - L1->L2 done
#define EU_IDMA_ALL_DONE_MASK        (EU_IDMA_A2O_DONE_MASK | EU_IDMA_O2A_DONE_MASK) // 0x0C
#define EU_IDMA_ALL_MASK             (EU_DMA_EVT_MASK)         // 0x0C

// Legacy compatibility (uses A2O done by default)
#define EU_IDMA_DONE_BIT             EU_IDMA_A2O_DONE_BIT      // bit 2 - Default to A2O done
#define EU_IDMA_ERROR_BIT            EU_IDMA_O2A_DONE_BIT      // bit 3 - Legacy "error" was O2A done
#define EU_IDMA_DONE_MASK            EU_IDMA_A2O_DONE_MASK     // 0x04 - Legacy compatibility
#define EU_IDMA_ERROR_MASK           EU_IDMA_O2A_DONE_MASK     // 0x08 - Legacy compatibility

// iDMA extended status via cluster events [31:26]
#define EU_IDMA_A2O_ERROR_BIT        26                        // iDMA AXI2OBI error
#define EU_IDMA_O2A_ERROR_BIT        27                        // iDMA OBI2AXI error  
#define EU_IDMA_A2O_START_BIT        28                        // iDMA AXI2OBI start
#define EU_IDMA_O2A_START_BIT        29                        // iDMA OBI2AXI start
#define EU_IDMA_A2O_BUSY_BIT         30                        // iDMA AXI2OBI busy
#define EU_IDMA_O2A_BUSY_BIT         31                        // iDMA OBI2AXI busy
#define EU_IDMA_A2O_ERROR_MASK       (1 << EU_IDMA_A2O_ERROR_BIT) // 0x04000000
#define EU_IDMA_O2A_ERROR_MASK       (1 << EU_IDMA_O2A_ERROR_BIT) // 0x08000000
#define EU_IDMA_A2O_START_MASK       (1 << EU_IDMA_A2O_START_BIT) // 0x10000000
#define EU_IDMA_O2A_START_MASK       (1 << EU_IDMA_O2A_START_BIT) // 0x20000000
#define EU_IDMA_A2O_BUSY_MASK        (1 << EU_IDMA_A2O_BUSY_BIT)  // 0x40000000
#define EU_IDMA_O2A_BUSY_MASK        (1 << EU_IDMA_O2A_BUSY_BIT)  // 0x80000000
#define EU_IDMA_STATUS_MASK          0xFC000000                // All iDMA status bits [31:26]

// FSync specific event mapping (via cluster_events_i[25:24])
// Based on magia_tile.sv: fsync_error, fsync_done at bits [25:24]
#define EU_FSYNC_DONE_BIT            24                        // FSync completion event
#define EU_FSYNC_ERROR_BIT           25                        // FSync error event
#define EU_FSYNC_DONE_MASK           (1 << EU_FSYNC_DONE_BIT)  // 0x01000000
#define EU_FSYNC_ERROR_MASK          (1 << EU_FSYNC_ERROR_BIT) // 0x02000000
#define EU_FSYNC_ALL_MASK            (EU_FSYNC_DONE_MASK | EU_FSYNC_ERROR_MASK) // 0x03000000

// Legacy compatibility - use DONE by default
#define EU_FSYNC_EVT_BIT             EU_FSYNC_DONE_BIT         // bit 24 - Legacy compatibility
#define EU_FSYNC_EVT_MASK            EU_FSYNC_DONE_MASK        // 0x01000000 - Legacy compatibility

// Synchronization and barrier events [1:0]
#define EU_SYNC_EVT_BIT              0                         // Synchronization/barrier event
#define EU_DISPATCH_EVT_BIT          1                         // Dispatch event
#define EU_SYNC_EVT_MASK             0x00000001                // bit 0
#define EU_DISPATCH_EVT_MASK         0x00000002                // bit 1

//=============================================================================
// Event Type Definitions
//=============================================================================

typedef enum {
    EU_EVENT_TYPE_DMA = 0,        // iDMA events
    EU_EVENT_TYPE_TIMER,          // Timer events
    EU_EVENT_TYPE_ACCELERATOR,    // Accelerator events (RedMulE, etc.)
    EU_EVENT_TYPE_FSYNC,          // FSync events
    EU_EVENT_TYPE_SOFTWARE,       // Software events
    EU_EVENT_TYPE_BARRIER,        // Barrier events
    EU_EVENT_TYPE_CUSTOM          // Custom cluster events
} eu_event_type_t;

typedef enum {
    EU_WAIT_MODE_POLLING = 0,     // Busy wait polling
    EU_WAIT_MODE_WFE,             // Wait For Event (RISC-V)
    EU_WAIT_MODE_IRQ              // Interrupt-based waiting
} eu_wait_mode_t;

//=============================================================================
// Basic Event Unit Control Functions
//=============================================================================

/**
 * @brief Initialize Event Unit with default configuration
 */
static inline void eu_init(void) {
    // Clear all pending events
    mmio32(EU_CORE_BUFFER_CLEAR) = 0xFFFFFFFF;
    
    // Reset masks to default (disabled)
    mmio32(EU_CORE_MASK) = 0x00000000;
    mmio32(EU_CORE_IRQ_MASK) = 0x00000000;
}

/**
 * @brief Enable specific event types in Event Unit mask
 * @param event_mask Bitmask of events to enable
 */
static inline void eu_enable_events(uint32_t event_mask) {
    mmio32(EU_CORE_MASK_OR) = event_mask;
}

/**
 * @brief Disable specific event types in Event Unit mask
 * @param event_mask Bitmask of events to disable
 */
static inline void eu_disable_events(uint32_t event_mask) {
    mmio32(EU_CORE_MASK_AND) = event_mask;
}

/**
 * @brief Enable IRQ for specific event types
 * @param irq_mask Bitmask of events that should trigger IRQ
 */
static inline void eu_enable_irq(uint32_t irq_mask) {
    mmio32(EU_CORE_IRQ_MASK_OR) = irq_mask;
}

/**
 * @brief Disable IRQ for specific event types
 * @param irq_mask Bitmask of events that should not trigger IRQ
 */
static inline void eu_disable_irq(uint32_t irq_mask) {
    mmio32(EU_CORE_IRQ_MASK_AND) = irq_mask;
}

/**
 * @brief Clear specific events from the buffer
 * @param event_mask Bitmask of events to clear
 */
static inline void eu_clear_events(uint32_t event_mask) {
    mmio32(EU_CORE_BUFFER_CLEAR) = event_mask;
}

/**
 * @brief Get current event buffer (all events)
 * @return 32-bit event buffer value
 */
static inline uint32_t eu_get_events(void) {
    return mmio32(EU_CORE_BUFFER);
}

/**
 * @brief Get current event buffer with mask applied
 * @return 32-bit masked event buffer value
 */
static inline uint32_t eu_get_events_masked(void) {
    return mmio32(EU_CORE_BUFFER_MASKED);
}

/**
 * @brief Get current event buffer with IRQ mask applied
 * @return 32-bit IRQ-masked event buffer value
 */
static inline uint32_t eu_get_events_irq_masked(void) {
    return mmio32(EU_CORE_BUFFER_IRQ_MASKED);
}

/**
 * @brief Check if specific events are present
 * @param event_mask Bitmask of events to check
 * @return Non-zero if any of the specified events are present
 */
static inline uint32_t eu_check_events(uint32_t event_mask) {
    return mmio32(EU_CORE_BUFFER_MASKED) & event_mask;
}

//=============================================================================
// Wait Functions - Different waiting strategies
//=============================================================================

/**
 * @brief Wait for events using polling mode
 * @param event_mask Bitmask of events to wait for
 * @param timeout_cycles Maximum cycles to wait (0 = infinite)
 * @return Non-zero if events detected, 0 if timeout
 */
static inline uint32_t eu_wait_events_polling(uint32_t event_mask, uint32_t timeout_cycles) {
    uint32_t cycles = 0;
    uint32_t detected_events;
    
    do {
        detected_events = eu_check_events(event_mask);
        if (detected_events) {
            return detected_events;
        }
        
        wait_nop(10);
        cycles += 10;
        
    } while (timeout_cycles == 0 || cycles < timeout_cycles);
    
    return 0; // Timeout
}

/**
 * @brief Wait for events using RISC-V WFE instruction
 * @param event_mask Bitmask of events to wait for
 * @return Non-zero if events detected
 */
static inline uint32_t eu_wait_events_wfe(uint32_t event_mask) {
    uint32_t detected_events;
    
    // First check if events are already present
    detected_events = eu_check_events(event_mask);
    if (detected_events) {
        return detected_events;
    }
    
    // Enable IRQ for these events (required for WFE wake-up)
    eu_enable_irq(event_mask);
    
    // Execute WFE instruction (CV32E40X specific: 0x8C000073)
    __asm__ volatile (".word 0x8C000073" ::: "memory");
    
    // After wake-up, check for events
    detected_events = eu_check_events(event_mask);
    return detected_events;
}

/**
 * @brief Wait for events using Event Unit built-in wait
 * @param clear_after_wait If true, clear events after waiting
 * @return Current event buffer value
 */
static inline uint32_t eu_wait_events_builtin(uint32_t clear_after_wait) {
    if (clear_after_wait) {
        return mmio32(EU_CORE_EVENT_WAIT_CLEAR);
    } else {
        return mmio32(EU_CORE_EVENT_WAIT);
    }
}

/**
 * @brief Generic wait function with selectable mode
 * @param event_mask Bitmask of events to wait for
 * @param mode Wait mode (polling, WFE, etc.)
 * @param timeout_cycles Timeout in cycles (polling mode only, 0 = infinite)
 * @return Non-zero if events detected, 0 if timeout
 */
static inline uint32_t eu_wait_events(uint32_t event_mask, eu_wait_mode_t mode, uint32_t timeout_cycles) {
    switch (mode) {
        case EU_WAIT_MODE_POLLING:
            return eu_wait_events_polling(event_mask, timeout_cycles);
            
        case EU_WAIT_MODE_WFE:
            return eu_wait_events_wfe(event_mask);
            
        case EU_WAIT_MODE_IRQ:
            // For IRQ mode, just enable IRQ and use built-in wait
            eu_enable_irq(event_mask);
            return eu_wait_events_builtin(1); // Clear after wait
            
        default:
            return eu_wait_events_polling(event_mask, timeout_cycles);
    }
}

//=============================================================================
// RedMulE-specific Event Functions
//=============================================================================

/**
 * @brief Initialize Event Unit for RedMulE events
 * @param enable_irq If true, enable IRQ for RedMulE completion
 */
static inline void eu_redmule_init(uint32_t enable_irq) {
    // Clear any pending events
    eu_clear_events(0xFFFFFFFF);
    
    // Enable RedMulE events in mask
    eu_enable_events(EU_REDMULE_ALL_MASK);
    
    // Optionally enable IRQ for RedMulE completion
    if (enable_irq) {
        eu_enable_irq(EU_REDMULE_DONE_MASK);
    }
}

/**
 * @brief Wait for RedMulE completion using specified mode
 * @param mode Wait mode (polling, WFE, etc.)
 * @return Non-zero if RedMulE completed, 0 if timeout/error
 */
static inline uint32_t eu_redmule_wait_completion(eu_wait_mode_t mode) {
    return eu_wait_events(EU_REDMULE_DONE_MASK, mode, 1000000); // 1M cycle timeout
}

/**
 * @brief Check if RedMulE is currently busy
 * @return Non-zero if RedMulE is busy
 */
static inline uint32_t eu_redmule_is_busy(void) {
    return eu_check_events(EU_REDMULE_BUSY_MASK);
}

/**
 * @brief Check if RedMulE has completed
 * @return Non-zero if RedMulE completed
 */
static inline uint32_t eu_redmule_is_done(void) {
    return eu_check_events(EU_REDMULE_DONE_MASK);
}

//=============================================================================
// iDMA-specific Event Functions  
//=============================================================================

/**
 * @brief Initialize Event Unit for iDMA events
 * @param enable_irq If true, enable IRQ for iDMA completion
 */
static inline void eu_idma_init(uint32_t enable_irq) {
    // Clear any pending events
    eu_clear_events(0xFFFFFFFF);
    
    // Enable iDMA events in mask (both directions)
    eu_enable_events(EU_IDMA_ALL_MASK);
    
    // Optionally enable IRQ for iDMA completion (both directions)
    if (enable_irq) {
        eu_enable_irq(EU_IDMA_ALL_DONE_MASK);
    }
}

/**
 * @brief Wait for any iDMA completion using specified mode
 * @param mode Wait mode (polling, WFE, etc.)
 * @return Non-zero if any iDMA completed, 0 if timeout/error
 */
static inline uint32_t eu_idma_wait_completion(eu_wait_mode_t mode) {
    return eu_wait_events(EU_IDMA_ALL_DONE_MASK, mode, 1000000); // 1M cycle timeout
}

/**
 * @brief Wait for specific iDMA direction completion
 * @param direction 0 = L2->L1 (A2O), 1 = L1->L2 (O2A)
 * @param mode Wait mode (polling, WFE, etc.)
 * @return Non-zero if specified direction completed, 0 if timeout/error
 */
static inline uint32_t eu_idma_wait_direction_completion(uint32_t direction, eu_wait_mode_t mode) {
    uint32_t wait_mask = direction ? EU_IDMA_O2A_DONE_MASK : EU_IDMA_A2O_DONE_MASK;
    return eu_wait_events(wait_mask, mode, 1000000); // 1M cycle timeout
}

/**
 * @brief Wait for L2->L1 (AXI2OBI) completion specifically
 * @param mode Wait mode (polling, WFE, etc.)
 * @return Non-zero if L2->L1 completed, 0 if timeout/error
 */
static inline uint32_t eu_idma_wait_a2o_completion(eu_wait_mode_t mode) {
    return eu_wait_events(EU_IDMA_A2O_DONE_MASK, mode, 1000000);
}

/**
 * @brief Wait for L1->L2 (OBI2AXI) completion specifically  
 * @param mode Wait mode (polling, WFE, etc.)
 * @return Non-zero if L1->L2 completed, 0 if timeout/error
 */
static inline uint32_t eu_idma_wait_o2a_completion(eu_wait_mode_t mode) {
    return eu_wait_events(EU_IDMA_O2A_DONE_MASK, mode, 1000000);
}

/**
 * @brief Check if any iDMA transfer has completed
 * @return Non-zero if any iDMA completed
 */
static inline uint32_t eu_idma_is_done(void) {
    return eu_check_events(EU_IDMA_ALL_DONE_MASK);
}

/**
 * @brief Check if L2->L1 (AXI2OBI) transfer has completed
 * @return Non-zero if L2->L1 completed
 */
static inline uint32_t eu_idma_a2o_is_done(void) {
    return eu_check_events(EU_IDMA_A2O_DONE_MASK);
}

/**
 * @brief Check if L1->L2 (OBI2AXI) transfer has completed
 * @return Non-zero if L1->L2 completed
 */
static inline uint32_t eu_idma_o2a_is_done(void) {
    return eu_check_events(EU_IDMA_O2A_DONE_MASK);
}

/**
 * @brief Check if iDMA has error (using cluster events)
 * @return Non-zero if iDMA error occurred
 */
static inline uint32_t eu_idma_has_error(void) {
    uint32_t events = eu_get_events();
    return events & (EU_IDMA_A2O_ERROR_MASK | EU_IDMA_O2A_ERROR_MASK);
}

/**
 * @brief Check if L2->L1 (AXI2OBI) has error
 * @return Non-zero if L2->L1 error occurred
 */
static inline uint32_t eu_idma_a2o_has_error(void) {
    return eu_check_events(EU_IDMA_A2O_ERROR_MASK);
}

/**
 * @brief Check if L1->L2 (OBI2AXI) has error
 * @return Non-zero if L1->L2 error occurred
 */
static inline uint32_t eu_idma_o2a_has_error(void) {
    return eu_check_events(EU_IDMA_O2A_ERROR_MASK);
}

/**
 * @brief Check if any iDMA transfer is busy
 * @return Non-zero if any iDMA busy
 */
static inline uint32_t eu_idma_is_busy(void) {
    uint32_t events = eu_get_events();
    return events & (EU_IDMA_A2O_BUSY_MASK | EU_IDMA_O2A_BUSY_MASK);
}

/**
 * @brief Check if L2->L1 (AXI2OBI) transfer is busy
 * @return Non-zero if L2->L1 busy
 */
static inline uint32_t eu_idma_a2o_is_busy(void) {
    return eu_check_events(EU_IDMA_A2O_BUSY_MASK);
}

/**
 * @brief Check if L1->L2 (OBI2AXI) transfer is busy
 * @return Non-zero if L1->L2 busy
 */
static inline uint32_t eu_idma_o2a_is_busy(void) {
    return eu_check_events(EU_IDMA_O2A_BUSY_MASK);
}

//=============================================================================
// FSync-specific Event Functions
//=============================================================================

/**
 * @brief Initialize Event Unit for FSync events
 * @param enable_irq If true, enable IRQ for FSync completion
 */
static inline void eu_fsync_init(uint32_t enable_irq) {
    // Clear any pending events
    eu_clear_events(0xFFFFFFFF);
    
    // Enable FSync events in mask (bits 25:24)
    eu_enable_events(EU_FSYNC_ALL_MASK);
    
    // Optionally enable IRQ for FSync completion (bit 24)
    if (enable_irq) {
        eu_enable_irq(EU_FSYNC_DONE_MASK);
    }
}

/**
 * @brief Wait for FSync completion using specified mode
 * @param mode Wait mode (polling, WFE, etc.)
 * @return Non-zero if FSync completed, 0 if timeout/error
 */
static inline uint32_t eu_fsync_wait_completion(eu_wait_mode_t mode) {
    return eu_wait_events(EU_FSYNC_DONE_MASK, mode, 1000000); // 1M cycle timeout
}

/**
 * @brief Check if FSync has completed
 * @return Non-zero if FSync completed
 */
static inline uint32_t eu_fsync_is_done(void) {
    return eu_check_events(EU_FSYNC_DONE_MASK);
}

/**
 * @brief Check if FSync has error
 * @return Non-zero if FSync error occurred
 */
static inline uint32_t eu_fsync_has_error(void) {
    return eu_check_events(EU_FSYNC_ERROR_MASK);
}

//=============================================================================
// Multi-accelerator Event Functions
//=============================================================================

/**
 * @brief Initialize Event Unit for multiple accelerators
 * @param redmule_enable Enable RedMulE events
 * @param idma_a2o_enable Enable iDMA A2O (L2->L1) events
 * @param idma_o2a_enable Enable iDMA O2A (L1->L2) events
 * @param fsync_enable Enable FSync events
 * @param enable_irq Enable IRQ for completion events
 */
static inline void eu_multi_init(uint32_t redmule_enable, uint32_t idma_a2o_enable, 
                                 uint32_t idma_o2a_enable, uint32_t fsync_enable, 
                                 uint32_t enable_irq) {
    // Clear all pending events
    eu_clear_events(0xFFFFFFFF);
    
    uint32_t event_mask = 0;
    uint32_t irq_mask = 0;
    
    if (redmule_enable) {
        event_mask |= EU_REDMULE_ALL_MASK;
        if (enable_irq) irq_mask |= EU_REDMULE_DONE_MASK;
    }
    
    if (idma_a2o_enable) {
        event_mask |= EU_IDMA_A2O_DONE_MASK;
        if (enable_irq) irq_mask |= EU_IDMA_A2O_DONE_MASK;
    }
    
    if (idma_o2a_enable) {
        event_mask |= EU_IDMA_O2A_DONE_MASK;
        if (enable_irq) irq_mask |= EU_IDMA_O2A_DONE_MASK;
    }
    
    if (fsync_enable) {
        event_mask |= EU_FSYNC_ALL_MASK;
        if (enable_irq) irq_mask |= EU_FSYNC_DONE_MASK;
    }
    
    // Enable selected events
    if (event_mask) {
        eu_enable_events(event_mask);
    }
    
    // Enable selected IRQs
    if (irq_mask) {
        eu_enable_irq(irq_mask);
    }
}

/**
 * @brief Wait for any of the specified accelerator completions
 * @param wait_redmule Wait for RedMulE completion
 * @param wait_idma Wait for iDMA completion
 * @param wait_fsync Wait for FSync completion
 * @param mode Wait mode (polling, WFE, etc.)
 * @return Bitmask of completed accelerators
 */
/**
 * @brief Wait for ANY of the specified accelerator events to complete
 * @param wait_redmule Wait for RedMulE completion (1) or ignore (0)
 * @param wait_idma_a2o Wait for IDMA A2O (L2->L1) completion (1) or ignore (0)
 * @param wait_idma_o2a Wait for IDMA O2A (L1->L2) completion (1) or ignore (0)
 * @param wait_fsync Wait for FSync completion (1) or ignore (0)
 * @param mode Wait mode (WFE, polling, etc.)
 * @return Event mask when any event is detected
 */
static inline uint32_t eu_multi_wait_any(uint32_t wait_redmule, uint32_t wait_idma_a2o, 
                                         uint32_t wait_idma_o2a, uint32_t wait_fsync, 
                                         eu_wait_mode_t mode) {
    uint32_t wait_mask = 0;
    
    if (wait_redmule) wait_mask |= EU_REDMULE_DONE_MASK;
    if (wait_idma_a2o) wait_mask |= EU_IDMA_A2O_DONE_MASK;
    if (wait_idma_o2a) wait_mask |= EU_IDMA_O2A_DONE_MASK;
    if (wait_fsync) wait_mask |= EU_FSYNC_DONE_MASK;
    
    return eu_wait_events(wait_mask, mode, 1000000); // 1M cycle timeout
}

/**
 * @brief Wait for ALL specified accelerator events to complete
 * @param wait_redmule Wait for RedMulE completion (1) or ignore (0)
 * @param wait_idma_a2o Wait for IDMA A2O (L2->L1) completion (1) or ignore (0)
 * @param wait_idma_o2a Wait for IDMA O2A (L1->L2) completion (1) or ignore (0)
 * @param wait_fsync Wait for FSync completion (1) or ignore (0)
 * @param mode Wait mode (WFE, polling, etc.)
 * @return Event mask when ALL required events are present
 */
static inline uint32_t eu_multi_wait_all(uint32_t wait_redmule, uint32_t wait_idma_a2o, 
                                         uint32_t wait_idma_o2a, uint32_t wait_fsync, 
                                         eu_wait_mode_t mode) {
    uint32_t required_mask = 0;
    uint32_t wait_mask = 0;
    
    // Build required events mask
    if (wait_redmule) required_mask |= EU_REDMULE_DONE_MASK;
    if (wait_idma_a2o) required_mask |= EU_IDMA_A2O_DONE_MASK;
    if (wait_idma_o2a) required_mask |= EU_IDMA_O2A_DONE_MASK;
    if (wait_fsync) required_mask |= EU_FSYNC_DONE_MASK;
    
    // Build wait mask (same as required for initial wait)
    wait_mask = required_mask;
    
    if (mode == EU_WAIT_MODE_WFE) {
        // True WFE: sleep until interrupt, no timeout
        uint32_t accumulated_events = 0;
        
        while ((accumulated_events & required_mask) != required_mask) {
            // Calculate which events we still need
            uint32_t missing_events = required_mask & ~accumulated_events;
            
            // Wait only for missing events using pure WFE
            uint32_t detected_events = eu_wait_events(missing_events, EU_WAIT_MODE_WFE, 0);
            
            // Accumulate detected events (don't clear them yet)
            accumulated_events |= detected_events;
        }
        
        // All events present! Clear them and return
        eu_clear_events(accumulated_events);
        return accumulated_events;
    } else {
        // Polling mode with timeout protection
        uint32_t timeout_cycles = 1000000;
        uint32_t cycles = 0;
        
        while (cycles < timeout_cycles) {
            // Wait for any of the required events
            uint32_t detected_events = eu_wait_events(wait_mask, mode, 100); // Short timeout per iteration
            
            // Check if we have ALL required events
            if ((detected_events & required_mask) == required_mask) {
                return detected_events; // All events present!
            }
            
            // If partial events, clear them and continue waiting for remaining
            if (detected_events) {
                eu_clear_events(detected_events);
            }
            
            cycles += 100;
        }
        
        return 0; // Timeout - not all events received (polling mode only)
    }
}

//=============================================================================
// Clock Status Function
//=============================================================================

/**
 * @brief Check Event Unit clock status
 * @return Non-zero if Event Unit clock is enabled
 */
static inline uint32_t eu_clock_is_enabled(void) {
    return mmio32(EU_CORE_STATUS) & 0x1;
}

//=============================================================================
// Software Event Functions
//=============================================================================

/**
 * @brief Trigger a software event
 * @param sw_event_id Software event ID (0-7 typically)
 */
static inline void eu_trigger_sw_event(uint32_t sw_event_id) {
    if (sw_event_id < 8) {
        mmio32(EU_CORE_TRIGG_SW_EVENT + (sw_event_id * 4)) = 1;
    }
}

/**
 * @brief Trigger software event and wait for response
 * @param sw_event_id Software event ID
 * @return Event buffer value after wake-up
 */
static inline uint32_t eu_trigger_sw_event_wait(uint32_t sw_event_id) {
    if (sw_event_id < 8) {
        return mmio32(EU_CORE_TRIGG_SW_EVENT_WAIT + (sw_event_id * 4));
    }
    return 0;
}

#endif /*EVENT_UNIT_UTILS_H*/