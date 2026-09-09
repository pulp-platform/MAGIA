// Copyright 2026 ETH Zurich, University of Bologna and Fondazione Chips-IT.
// SPDX-License-Identifier: Apache-2.0
#include "event_unit_utils.h"
#include "timer_utils.h"

static uint32_t core_cycles(void)
{
    uint32_t value;
    __asm__ volatile ("csrr %0, mcycle" : "=r"(value) :: "memory");
    return value;
}

int main(void)
{
    const uintptr_t timer = MAGIA_TIMER_BASE;
    const uint32_t low = magia_timer_event_mask(MAGIA_TIMER_LOW);
    const uint32_t high = magia_timer_event_mask(MAGIA_TIMER_HIGH);
    int errors = 0;
    eu_init();
    magia_timer_init(timer, MAGIA_TIMER_LOW);
    magia_timer_init(timer, MAGIA_TIMER_HIGH);
    errors += magia_timer_read(timer, MAGIA_TIMER_LOW) != 0;
    errors += magia_timer_read(timer, MAGIA_TIMER_HIGH) != 0;

    // Shared LOW timer measures elapsed tile cycles, including a HIGH timeout
    // while the control core is blocked in cv.elw.
    __asm__ volatile ("csrci mcountinhibit, 1" ::: "memory");
    magia_timer_start(timer, MAGIA_TIMER_LOW);
    uint32_t start = core_cycles();
    magia_timer_wait_cycles(4096, MAGIA_TIMER_HIGH);
    uint32_t active = core_cycles() - start;
    magia_timer_stop(timer, MAGIA_TIMER_LOW);
    uint32_t elapsed = magia_timer_read(timer, MAGIA_TIMER_LOW);
    errors += elapsed < 4096;
#if defined(CV32E40P)
    errors += active + 1024 >= elapsed; // cv.elw must gate the core, not the timer
#endif
    wait_nop(32);
    errors += elapsed != magia_timer_read(timer, MAGIA_TIMER_LOW);
    errors += (eu_get_events() & high) != 0;
    printf("Timer elapsed=%u, mcycle=%u\n", (unsigned)elapsed, (unsigned)active);

    // Exercise LOW event delivery, automatic one-shot stop and mask restore.
    eu_enable_events(1u << 6);
    eu_enable_irq(1u << 7); // Unrelated IRQ mask must survive the wait
    // The control core uses the EU direct-link SW trigger window (+0x100).
    magia_timer_reg_write(EU_BASE + 0x100u, 1);
    errors += (eu_get_events() & (1u << 6)) == 0;
    magia_timer_wait_cycles(256, MAGIA_TIMER_LOW);
    errors += mmio32(EU_CORE_MASK) != (1u << 6);
    errors += mmio32(EU_CORE_IRQ_MASK) != (1u << 7);
    errors += (eu_get_events() & (1u << 6)) == 0;
    eu_clear_events(1u << 6);
    magia_timer_wait_cycles(0, MAGIA_TIMER_LOW);
    errors += (eu_get_events() & low) != 0;

    // Periodic HIGH keeps running and delivers multiple observable events.
    eu_enable_events(high);
    magia_timer_arm(timer, MAGIA_TIMER_HIGH, 128, 1);
    for (int i = 0; i < 3; ++i)
        errors += eu_wait_events_polling(high, 10000) != high;
    magia_timer_cancel(timer, MAGIA_TIMER_HIGH);
    eu_clear_events(high);
    magia_timer_reset(timer, MAGIA_TIMER_LOW);
    errors += magia_timer_read(timer, MAGIA_TIMER_LOW) != 0;
    printf("Tile timer test: %s (%d errors)\n", errors ? "FAIL" : "PASS", errors);
    return errors;
}
