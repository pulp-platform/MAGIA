#ifndef REDMULE_TILE_UTILS_H
#define REDMULE_TILE_UTILS_H

#include "tinyprintf.h"

#define NUM_L1_BANKS (32)
#define WORDS_BANK   (4096)
#define BITS_WORD    (32)

#define L1_BASE       (0x1C010000)
#define L1_SIZE       (0x10000000)
#define L2_BASE       (0x5C010000)
#define TEST_END_ADDR (0x5C030000)

#define DEFAULT_EXIT_CODE (0xAF)
#define PASS_EXIT_CODE    (0xA)
#define FAIL_EXIT_CODE    (0xF)

#define IRQ_REDMULE_EVT_0 (31)
#define IRQ_REDMULE_EVT_1 (30)
#define IRQ_A2O_ERROR     (29)
#define IRQ_O2A_ERROR     (28)
#define IRQ_A2O_DONE      (27)
#define IRQ_O2A_DONE      (26)
#define IRQ_A2O_START     (25)
#define IRQ_O2A_START     (24)
#define IRQ_A2O_BUSY      (23)
#define IRQ_O2A_BUSY      (22)
#define IRQ_REDMULE_BUSY  (21)
#define IRQ_FSYNC_DONE    (20)
#define IRQ_FSYNC_ERROR   (19)

#define mmio64(x) (*(volatile uint64_t *)(x))
#define mmio32(x) (*(volatile uint32_t *)(x))
#define mmio16(x) (*(volatile uint16_t *)(x))
#define mmio8(x)  (*(volatile uint8_t  *)(x))

#define addr64(x) (*(uint64_t *)(&x))
#define addr32(x) (*(uint32_t *)(&x))
#define addr16(x) (*(uint16_t *)(&x))
#define addr8(x)  (*(uint8_t  *)(&x))

void wait_print(unsigned int cycles){
    for(int i = 0; i <= cycles; i++){
        printf("Waiting: [");
        for(int j = 0; j < i; j++)
            printf("+");
        for(int j = 0; j < cycles - i; j++)
            printf("-");
        printf("]\n");
    }
}

inline void irq_en(uint32_t index_oh){
    asm volatile("addi t0, %0, 0\n\t"
                 "csrrs zero, mie, t0"
                 ::"r"(index_oh));
}

inline uint32_t irq_st(){
    uint32_t irq_status;
    asm volatile("csrr %0, mip"
                 :"=r"(irq_status):);
    return irq_status;
}

#endif /*REDMULE_TILE_UTILS_H*/