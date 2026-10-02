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
 * Authors: Luca Balboni <luca.balboni@chips.it>
 *
 * Tile timer driver: one PULP timer shared by all cores, each LOW/HIGH half configured by a single owner
 */

#ifndef MAGIA_TIMER_UTILS_H
#define MAGIA_TIMER_UTILS_H
#include <stdint.h>
#include "magia_tile_utils.h"

#define MAGIA_TIMER_BASE ((uintptr_t)TIMER_BASE)
#define MAGIA_TIMER_EU_BASE ((uintptr_t)EVENT_UNIT_BASE)
#define MAGIA_TIMER_CFG 0x00u
#define MAGIA_TIMER_VALUE 0x08u
#define MAGIA_TIMER_COMPARE 0x10u
#define MAGIA_TIMER_START 0x18u
#define MAGIA_TIMER_RESET 0x20u
#define MAGIA_TIMER_ENABLE (1u << 0)
#define MAGIA_TIMER_IRQ (1u << 2)
#define MAGIA_TIMER_CMP_CLEAR (1u << 4)
#define MAGIA_TIMER_ONE_SHOT (1u << 5)
typedef enum { MAGIA_TIMER_LOW = 0, MAGIA_TIMER_HIGH = 1 } magia_timer_half_t;

static inline uint32_t magia_timer_reg_read(uintptr_t addr) {
    __asm__ volatile ("" : "+r"(addr) :: "memory");
    return *(volatile uint32_t *)addr;
}
static inline void magia_timer_reg_write(uintptr_t addr, uint32_t value) {
    __asm__ volatile ("" : "+r"(addr) :: "memory");
    *(volatile uint32_t *)addr = value;
    __asm__ volatile ("" ::: "memory");
}
static inline uintptr_t magia_timer_reg(uintptr_t base, magia_timer_half_t half,
                                       uint32_t offset) {
    return base + offset + 4u * (unsigned)half;
}
static inline void magia_timer_cancel(uintptr_t base, magia_timer_half_t half) {
    magia_timer_reg_write(magia_timer_reg(base, half, MAGIA_TIMER_CFG), 0);
}
static inline void magia_timer_reset(uintptr_t base, magia_timer_half_t half) {
    magia_timer_reg_write(magia_timer_reg(base, half, MAGIA_TIMER_RESET), 1);
}
static inline void magia_timer_init(uintptr_t base, magia_timer_half_t half) {
    magia_timer_cancel(base, half);
    magia_timer_reset(base, half);
}
static inline void magia_timer_start(uintptr_t base, magia_timer_half_t half) {
    magia_timer_reg_write(magia_timer_reg(base, half, MAGIA_TIMER_START), 1);
}
static inline void magia_timer_stop(uintptr_t base, magia_timer_half_t half) {
    uintptr_t cfg = magia_timer_reg(base, half, MAGIA_TIMER_CFG);
    magia_timer_reg_write(cfg, magia_timer_reg_read(cfg) & ~MAGIA_TIMER_ENABLE);
}
static inline uint32_t magia_timer_read(uintptr_t base, magia_timer_half_t half) {
    return magia_timer_reg_read(magia_timer_reg(base, half, MAGIA_TIMER_VALUE));
}
// Independent 32-bit mode; a periodic compare-and-clear has period ticks+1
static inline void magia_timer_arm(uintptr_t base, magia_timer_half_t half,
                                   uint32_t ticks, int periodic) {
    magia_timer_init(base, half);
    magia_timer_reg_write(magia_timer_reg(base, half, MAGIA_TIMER_COMPARE), ticks ? ticks : 1u);
    magia_timer_reg_write(magia_timer_reg(base, half, MAGIA_TIMER_CFG),
        MAGIA_TIMER_ENABLE | MAGIA_TIMER_IRQ | MAGIA_TIMER_CMP_CLEAR |
        (periodic ? 0u : MAGIA_TIMER_ONE_SHOT));
}
static inline uint32_t magia_timer_event_mask(magia_timer_half_t half) {
    return 1u << (4u + (unsigned)half);
}
// Control core only: sleep until this half fires, then restore the EU masks
static inline void magia_timer_wait_cycles(uint32_t ticks, magia_timer_half_t half) {
    if (!ticks) return;
    uintptr_t eu = MAGIA_TIMER_EU_BASE;
    uint32_t bit = magia_timer_event_mask(half);
    uint32_t mask = magia_timer_reg_read(eu);
    uint32_t irq_mask = magia_timer_reg_read(eu + 0x0cu);
    magia_timer_cancel(MAGIA_TIMER_BASE, half);
    magia_timer_reg_write(eu + 0x10u, bit);
    magia_timer_reg_write(eu + 0x28u, bit);
    magia_timer_reg_write(eu, bit);
    magia_timer_arm(MAGIA_TIMER_BASE, half, ticks, 0);
    while (!(magia_timer_reg_read(eu + 0x1cu) & bit)) {
#if defined(CV32E40P) || defined(__cv32e40p__)
        uint32_t events;
        __asm__ volatile ("cv.elw %0, 0(%1)" : "=r"(events)
                          : "r"(eu + 0x38u) : "memory");
#endif
    }
    magia_timer_cancel(MAGIA_TIMER_BASE, half);
    magia_timer_reg_write(eu + 0x28u, bit);
    magia_timer_reg_write(eu, mask);
    magia_timer_reg_write(eu + 0x0cu, irq_mask);
}
#endif
