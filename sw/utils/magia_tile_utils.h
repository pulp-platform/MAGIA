/*
 * Copyright (C) 2023-2024 ETH Zurich and University of Bologna and Fondazione Chips-IT
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

/* Tile peripherals: private, the same in every tile, laid out as in magia_tile_pkg */
#define TILE_PERIPH_BASE (0xA0000000)
#define EVENT_UNIT_BASE (TILE_PERIPH_BASE + 0x0000)
#define EVENT_UNIT_END  (TILE_PERIPH_BASE + 0x0FFF)
#define IDMA_BASE       (TILE_PERIPH_BASE + 0x1000)
#define IDMA_END        (TILE_PERIPH_BASE + 0x13FF)
// HCI arbiter control register
#define HCI_ARB_CTRL_BASE     (TILE_PERIPH_BASE + 0x1400)
#define HCI_ARB_CTRL          (HCI_ARB_CTRL_BASE + 0x00)
#define HCI_ARB_CTRL_END      (TILE_PERIPH_BASE + 0x143F)
#define HCI_ARB_CTRL_DEFAULT  (0x00000000u)  /* Denominator 0: default ratio of magia_hci_interconnect */
#define HCI_ARB_INVERT_PRIO   (1u << 0)
#define HCI_ARB_PRIO_NUM(n)   (((n) & 0xFFu) << 8)
#define HCI_ARB_PRIO_DEN(n)   (((n) & 0xFFu) << 16)
/* Optional units: an absent one answers with an error */
#define REDMULE_BASE    (TILE_PERIPH_BASE + 0x2000)
#define REDMULE_END     (TILE_PERIPH_BASE + 0x20FF)
#define FSYNC_BASE      (TILE_PERIPH_BASE + 0x2100)
#define FSYNC_END       (TILE_PERIPH_BASE + 0x21FF)
#define SPATZ_CTRL_BASE (TILE_PERIPH_BASE + 0x2200)
#define SPATZ_CTRL_END  (TILE_PERIPH_BASE + 0x223F)
/* PULP Cluster Control registers, bare-metal dispatch model */
#define PULP_CTRL_BASE        (TILE_PERIPH_BASE + 0x2300)
#define PULP_FETCH_EN         (PULP_CTRL_BASE + 0x00)  /* R/W boot enable, sticky in the cores; every write resets READY */
#define PULP_BINARY           (PULP_CTRL_BASE + 0x04)  /* R/W boot address of all cluster cores */
#define PULP_DONE             (PULP_CTRL_BASE + 0x08)  /* W   core 0 signals completion, pulsing EU bit 12 on the CV32 */
#define PULP_TASKBIN          (PULP_CTRL_BASE + 0x0C)  /* R/W task function address, read by core 0 */
#define PULP_DATA             (PULP_CTRL_BASE + 0x10)  /* R/W task argument (a0) */
#define PULP_START            (PULP_CTRL_BASE + 0x14)  /* R/W CV32 rings core 0 (EU bit 13), core 0 writes 0 to ACK */
#define PULP_READY            (PULP_CTRL_BASE + 0x18)  /* R 1 once all cores booted, W each core posts 1 once armed */
#define PULP_RETURN           (PULP_CTRL_BASE + 0x1C)  /* R/W task exit code, written by core 0 before PULP_DONE */
#define PULP_RETURN_CRASHED_BIT (0x80000000u)  /* Set when core 0 trapped instead of returning */
#define PULP_CTRL_END         (TILE_PERIPH_BASE + 0x237F)
#define PULP_CORE_COUNT       (8)
#define PULP_HARTID_BASE      (32)
#define COLL_CTRL_BASE  (TILE_PERIPH_BASE + 0x2400)
#define COLL_CTRL_END   (TILE_PERIPH_BASE + 0x24FF)
#define CLUSTER_EU_DIRECT_BASE (TILE_PERIPH_BASE + 0x3000)
#define CLUSTER_EU_DIRECT_END  (TILE_PERIPH_BASE + 0x3FFF)
#define CLUSTER_EU_BASE       (TILE_PERIPH_BASE + 0x4000)
#define CLUSTER_EU_END        (TILE_PERIPH_BASE + 0x4FFF)
/* L1 of tile k: private part at L1_PRIV_BASE, global part at k * L1_TILE_OFFSET + L1_PRIV_SIZE */
#define L1_TILE_OFFSET  (0x00100000)
#define L1_PRIV_BASE    (0xA0100000)
#define L1_PRIV_SIZE    (0x00020000)  /* TileCfg.L1.PrivBytes */
/* SW layout of the private part: scratch, then the stacks of the linker scripts */
#define SCRATCH_BASE    (L1_PRIV_BASE + 0x00000)
#define SCRATCH_END     (L1_PRIV_BASE + 0x177FF)  /* Up to the stacks of sw/kernel/link.ld */
#define L1_BASE         (L1_PRIV_SIZE)  /* Global part of tile 0 */
/* Global bytes per tile */
#define L1_SIZE         (NUM_L1_BANKS * WORDS_BANK * (BITS_WORD / BITS_BYTE) - L1_PRIV_SIZE)
#define L2_BASE         (0xC0000000)
#define TEST_END_ADDR   (0xC0008000)  /* Must match sw/kernel/link.ld and the testbench VIPs */

#define DEFAULT_EXIT_CODE (0xDEFC)
#define PASS_EXIT_CODE    (0xAAAA)
#define FAIL_EXIT_CODE    (0xFFFF)

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

#endif /*MAGIA_TILE_UTILS_H*/
