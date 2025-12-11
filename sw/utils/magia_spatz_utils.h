#ifndef MAGIA_SPATZ_UTILS_H
#define MAGIA_SPATZ_UTILS_H

#include <stdint.h>
#include "magia_tile_utils.h"

#define SPATZ_CLK_EN        (SPATZ_CTRL_BASE + 0x00)
#define SPATZ_FUNC_PTR      (SPATZ_CTRL_BASE + 0x04)
#define SPATZ_START         (SPATZ_CTRL_BASE + 0x08)
#define SPATZ_DONE          (SPATZ_CTRL_BASE + 0x0C)
#define SPATZ_BOOT_ADDR     (0x00001800)

#define mmio32(x) (*(volatile uint32_t *)(x))

static inline void spatz_clk_en(void) {
    mmio32(SPATZ_CLK_EN) = 1;
}

static inline void spatz_clk_dis(void) {
    mmio32(SPATZ_CLK_EN) = 0;
}

static inline void spatz_set_func(uint32_t addr) {
    mmio32(SPATZ_FUNC_PTR) = addr;
}

static inline void spatz_trigger_en_irq(void) {
    mmio32(SPATZ_START) = 1;
}

static inline void spatz_trigger_dis_irq(void) {
    mmio32(SPATZ_START) = 0;
}

static inline void spatz_done(void) {
    mmio32(SPATZ_DONE) = 1;
}

static inline void spatz_run(uint32_t addr) {
    spatz_clk_en();
    spatz_set_func(addr);
    spatz_trigger_en_irq();
}

#endif
