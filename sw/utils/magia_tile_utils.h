#ifndef MAGIA_TILE_UTILS_H
#define MAGIA_TILE_UTILS_H

#include "tinyprintf.h"

#define NUM_L1_BANKS (32)
#define WORDS_BANK   (8192)
#define BITS_WORD    (32)
#define BITS_BYTE    (8)

#define RESERVED_START (0x00000000)
#define RESERVED_END   (0x0000FFFF)
#define STACK_START    (0x00010000)
#define STACK_END      (0x0001FFFF)
#define L1_BASE        (0x00020000)
#define L1_SIZE        (0x000E0000)
#define L1_TILE_OFFSET (0x00100000)
#define L2_BASE        (0xCC000000)
#define TEST_END_ADDR  (0xCC030000)

#define DEFAULT_EXIT_CODE (0xDEFC)
#define PASS_EXIT_CODE    (0xAAAA)
#define FAIL_EXIT_CODE    (0xFFFF)

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

inline void irq_en(volatile uint32_t index_oh){
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

inline void wait_nop(uint32_t nops){
    for (int i = 0; i < nops; i++) asm volatile("addi x0, x0, 0" ::);
}

inline void sentinel_instr_id(){
    asm volatile("addi x0, x0, 0x404" ::);
}

inline void sentinel_instr_ex(){
    asm volatile("addi x0, x0, 0x505" ::);
}

inline void ccount_en(){
    asm volatile("csrrci zero, 0x320, 0x1" ::);
}

inline void ccount_dis(){
    asm volatile("csrrsi zero, 0x320, 0x1" ::);
}

inline uint32_t get_cyclel(){
    uint32_t cyclel;
    asm volatile("csrr %0, cycle"
                 :"=r"(cyclel):);
    return cyclel;
}

inline uint32_t get_cycleh(){
    uint32_t cycleh;
    asm volatile("csrr %0, cycleh"
                 :"=r"(cycleh):);
    return cycleh;
}

uint32_t get_cycle(){
    uint32_t cyclel = get_cyclel();
    uint32_t cycleh = get_cycleh();
    if (cycleh) return 0;
    return cyclel;
}

inline uint32_t get_timel(){
    uint32_t timel;
    asm volatile("csrr %0, time"
                 :"=r"(timel):);
    return timel;
}

inline uint32_t get_timeh(){
    uint32_t timeh;
    asm volatile("csrr %0, timeh"
                 :"=r"(timeh):);
    return timeh;
}

uint32_t get_time(){
    uint32_t timel = get_timel();
    uint32_t timeh = get_timeh();
    if (timeh) return 0;
    return timel;
}

#endif /*MAGIA_TILE_UTILS_H*/