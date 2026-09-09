// Copyright 2026 ETH Zurich, University of Bologna and Fondazione Chips-IT.
// SPDX-License-Identifier: Apache-2.0
#ifndef MAGIA_TIMER_UTILS_H
#define MAGIA_TIMER_UTILS_H
#include <stdint.h>

// One tile-local PULP timer, shared by all cores. LOW/HIGH are two halves
// of that peripheral, not per-core counters. Only one owner may configure
// a half. sys_clk continues during core sleep, but stops with the whole tile.
#define MAGIA_TIMER_BASE ((uintptr_t)0x3800u)
#define MAGIA_TIMER_EU_BASE ((uintptr_t)0x700u)
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
// Independent 32-bit mode. Periodic compare-and-clear has period ticks+1.
// No reference clock or external start-event source is connected in MAGIA.
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
// Control core only: timer events are not wired to the private cluster EU.
// Own this half and its event bit; preserve other events and restore masks.
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
