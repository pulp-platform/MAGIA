/*
 * Copyright (C) 2023-2024 ETH Zurich and University of Bologna
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
 * Authors: Victor Isachi <victor.isachi@unibo.it>
 * 
 * MAGIA Tile Utils
 */

#ifndef MAGIA_TILE_UTILS_H
#define MAGIA_TILE_UTILS_H

#include <stdint.h>
#include "tinyprintf.h"

#define NUM_L1_BANKS (32)
#define WORDS_BANK   (8192)
#define BITS_WORD    (32)
#define BITS_BYTE    (8)

#define REDMULE_BASE    (0x00000100)
#define REDMULE_END     (0x000001FF)
#define IDMA_BASE       (0x00000200)
#define IDMA_END        (0x000005FF)
#define FSYNC_BASE      (0x00000600)
#define FSYNC_END       (0x000006FF)
#define EVENT_UNIT_BASE (0x00000700)
#define EVENT_UNIT_END  (0x000016FF)
#define RESERVED_START  (0x00001700)   
#define RESERVED_END    (0x0000FFFF)   
#define STACK_START     (0x00010000)
#define STACK_END       (0x0001FFFF)
#define L1_BASE         (0x00020000)
#define L1_SIZE         (0x000E0000)
#define L1_TILE_OFFSET  (0x00100000)
#define L2_BASE         (0xCC000000)
#define TEST_END_ADDR   (0xCCFF0000)

#define DEFAULT_EXIT_CODE (0xDEFC)
#define PASS_EXIT_CODE    (0xAAAA)
#define FAIL_EXIT_CODE    (0xFFFF)

// Individual IRQ indices unnecessary - Event Unit provides unified interrupt management
// Use Event Unit API (event_unit_utils.h) for event handling
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

static inline void irq_en(volatile uint32_t index_oh){
    asm volatile("addi t0, %0, 0\n\t"
                 "csrrs zero, mie, t0"
                 ::"r"(index_oh));
}

static inline uint32_t irq_st(){
    uint32_t irq_status;
    asm volatile("csrr %0, mip"
                 :"=r"(irq_status):);
    return irq_status;
}

static inline void wait_nop(uint32_t nops){
    for (int i = 0; i < nops; i++) asm volatile("addi x0, x0, 0" ::);
}

static inline void sentinel_instr_id(){
    asm volatile("addi x0, x0, 0x404" ::);
}

static inline void sentinel_instr_ex(){
    asm volatile("addi x0, x0, 0x505" ::);
}

static inline void sentinel_start(){
    asm volatile("addi x0, x0, 0x5AA" ::);
}

static inline void sentinel_end(){
    asm volatile("addi x0, x0, 0x5FF" ::);
}

static inline void ccount_en(){
#ifdef CV32E40X
    asm volatile("csrrci zero, 0x320, 0x1" ::);
#else
    uint32_t pcmr = 1;
    asm volatile("csrw 0x7e1, %0" ::"r"(pcmr));
#endif
}

static inline void ccount_dis(){
#ifdef CV32E40X
    asm volatile("csrrsi zero, 0x320, 0x1" ::);
#else
    uint32_t pcmr = 0;
    asm volatile("csrw 0x7e1, %0" ::"r"(pcmr));
#endif
}

static inline uint32_t get_cyclel(){
    uint32_t cyclel;
#ifdef CV32E40X
    asm volatile("csrr %0, cycle"
                 :"=r"(cyclel):);
#else
    asm volatile("csrr %0, 0x780"
                 :"=r"(cyclel):);
#endif
    return cyclel;
}

static inline uint32_t get_cycleh(){
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

static inline uint32_t get_timel(){
    uint32_t timel;
#ifdef CV32E40X
    asm volatile("csrr %0, time"
                 :"=r"(timel):);
#else
    asm volatile("csrr %0, 0x781"
                 :"=r"(timel):);
#endif
    return timel;
}

static inline uint32_t get_timeh(){
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

// Additional Flex-V CSR access functions based on CSR table
static inline uint32_t get_mstatus(){
    uint32_t mstatus;
    asm volatile("csrr %0, 0x300" :"=r"(mstatus):); // MSTATUS (0x300)
    return mstatus;
}

static inline void set_mstatus(uint32_t value){
    asm volatile("csrw 0x300, %0" ::"r"(value)); // MSTATUS (0x300)
}

static inline uint32_t get_mtvec(){
    uint32_t mtvec;
    asm volatile("csrr %0, 0x305" :"=r"(mtvec):); // MTVEC (0x305)
    return mtvec;
}

static inline void set_mtvec(uint32_t value){
    asm volatile("csrw 0x305, %0" ::"r"(value)); // MTVEC (0x305)
}

static inline uint32_t get_mepc(){
    uint32_t mepc;
    asm volatile("csrr %0, 0x341" :"=r"(mepc):); // MEPC (0x341)
    return mepc;
}

static inline void set_mepc(uint32_t value){
    asm volatile("csrw 0x341, %0" ::"r"(value)); // MEPC (0x341)
}

static inline uint32_t get_mcause(){
    uint32_t mcause;
    asm volatile("csrr %0, 0x342" :"=r"(mcause):); // MCAUSE (0x342)
    return mcause;
}

static inline uint32_t get_privlv(){
    uint32_t privlv;
    asm volatile("csrr %0, 0xc10" :"=r"(privlv):); // PRIVLV (0xC10)
    return privlv;
}

static inline uint32_t get_uhartid(){
    uint32_t uhartid;
    asm volatile("csrr %0, 0x014" :"=r"(uhartid):); // UHARTID (0x014)
    return uhartid;
}

// Flex-V performance counter control
static inline void perf_counter_enable(){
    uint32_t pcer = 3; // Enable cycles (bit 0) and instruction count (bit 1)
    uint32_t pcmr = 1; // Enable global performance counter
    asm volatile("csrw 0x7e0, %0" ::"r"(pcer)); // PCER_MACHINE (0x7E0)
    asm volatile("csrw 0x7e1, %0" ::"r"(pcmr)); // PCMR_MACHINE (0x7E1)
}

static inline void perf_counter_disable(){
    uint32_t pcmr = 0; // Disable global performance counter
    asm volatile("csrw 0x7e1, %0" ::"r"(pcmr)); // PCMR_MACHINE (0x7E1)
}

#endif /*MAGIA_TILE_UTILS_H*/
