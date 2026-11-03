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

/* Data cache registers (data_cc_cfg_regs), only with MAGIA_DCACHE */
#define DCACHE_CTRL_BASE (0x00000080)
#define DCACHE_CTRL_END  (0x000000BF)
#define REDMULE_BASE    (0x00000100)
#define REDMULE_END     (0x000001FF)
#define IDMA_BASE       (0x00000200)
#define IDMA_END        (0x000005FF)
#define FSYNC_BASE      (0x00000600)
#define FSYNC_END       (0x000006FF)
#define EVENT_UNIT_BASE (0x00000700)
#define EVENT_UNIT_END  (0x000016FF)
#define SPATZ_CTRL_BASE (0x00001700)
#define SPATZ_CTRL_END  (0x0000173F)
/* PULP Cluster Control registers (tile_csr + 0x40), bare-metal dispatch model */
#define PULP_CTRL_BASE        (0x00001740)
#define PULP_FETCH_EN         (PULP_CTRL_BASE + 0x00)  /* R/W boot enable, sticky in the cores; every write resets READY */
#define PULP_BINARY           (PULP_CTRL_BASE + 0x04)  /* R/W boot address of all cluster cores */
#define PULP_DONE             (PULP_CTRL_BASE + 0x08)  /* W   core 0 signals completion, pulsing EU bit 12 on the CV32 */
#define PULP_TASKBIN          (PULP_CTRL_BASE + 0x0C)  /* R/W task function address, read by core 0 */
#define PULP_DATA             (PULP_CTRL_BASE + 0x10)  /* R/W task argument (a0) */
#define PULP_START            (PULP_CTRL_BASE + 0x14)  /* R/W CV32 rings core 0 (EU bit 13), core 0 writes 0 to ACK */
#define PULP_READY            (PULP_CTRL_BASE + 0x18)  /* R 1 once all cores booted, W each core posts 1 once armed */
#define PULP_RETURN           (PULP_CTRL_BASE + 0x1C)  /* R/W task exit code, written by core 0 before PULP_DONE */
#define PULP_RETURN_CRASHED_BIT (0x80000000u)  /* Set when core 0 trapped instead of returning */
#define PULP_CTRL_END         (0x000017BF)
#define PULP_CORE_COUNT       (8)
#define PULP_HARTID_BASE      (32)
// HCI arbiter control register (tile_csr + 0xC0)
#define HCI_ARB_CTRL_BASE     (0x000017C0)
#define HCI_ARB_CTRL          (HCI_ARB_CTRL_BASE + 0x00)
#define HCI_ARB_CTRL_END      (0x000017FF)
#define HCI_ARB_CTRL_DEFAULT  (0x00000000u)  /* Denominator 0: default ratio of magia_hci_interconnect */
#define HCI_ARB_INVERT_PRIO   (1u << 0)
#define HCI_ARB_PRIO_NUM(n)   (((n) & 0xFFu) << 8)
#define HCI_ARB_PRIO_DEN(n)   (((n) & 0xFFu) << 16)
#define COLL_CTRL_BASE  (0x00001800)
#define COLL_CTRL_END   (0x000018FF)
#define CLUSTER_EU_DIRECT_BASE (0x00001900)
#define CLUSTER_EU_DIRECT_END  (0x000028FF)
#define CLUSTER_EU_BASE       (0x00002900)
#define CLUSTER_EU_END        (0x000038FF)
#define RESERVED_START  (0x00003900)
#define RESERVED_END    (0x0000FFFF)
#define STACK_START     (0x00010000)
#define STACK_END       (0x0001FFFF)
#define L1_BASE         (0x00020000)
#ifndef L1_SIZE
/* TCDM minus the 128 KiB below L1_BASE (peripherals, reserved, stacks). Overridable so that the tests can be
 * built for a smaller TCDM: with 32 banks the size follows the words per bank. */
#define L1_SIZE         (0x000E0000)
#endif
#define L1_TILE_OFFSET  (0x00100000)

/* The L1 is global (hw/tile/magia_isle.sv: tile_l1_start_addr = L1_ADDR_START + mhartid*L1_TILE_OFFSET).
 * L1_BASE on its own is the L1 of tile 0: from any other tile the access leaves on the NoC and lands there.
 * The same memory therefore has two addresses, and which one to use depends on who issues the access:
 *   - the core goes through its demux, which routes locally only its own window: it needs L1_GLOBAL;
 *   - the iDMA port is wired to the TCDM of its own tile: it needs L1_LOCAL.
 * On a single tile the two coincide, which is why a test can look correct and still break on a mesh.
 * A cluster core reads its cluster index in mhartid, not the tile index: in a pulp_task use the addresses
 * the control core puts in the parameter block, or L1_TILE_VIEW(cluster_tile_id(), off). */
#define L1_LOCAL(off)         (L1_BASE + (off))                             /* iDMA view */
#define L1_TILE_VIEW(t, off)  (L1_BASE + (t) * L1_TILE_OFFSET + (off))      /* core view of tile t */
#define L1_GLOBAL(off)        L1_TILE_VIEW(magia_tile_id(), (off))          /* core view, this tile */

/* Index of this tile, from the control core. See L1_GLOBAL for what a cluster core reads instead. */
static inline uint32_t magia_tile_id(void) {
  uint32_t id;
  asm volatile("csrr %0, mhartid" : "=r"(id));
  return id;
}
/* Data cache store: top of L1, reserved while the cache is on (MAGIA_DCACHE). Same geometry as magia_pkg
 * (make dc_ways=... dc_sets=...): 4 ways x 64 sets x 128 B = 32 KiB by default */
#ifndef MAGIA_DCACHE_WAYS
#define MAGIA_DCACHE_WAYS (4)
#endif
#ifndef MAGIA_DCACHE_SETS
#define MAGIA_DCACHE_SETS (64)
#endif
#define L1_DCACHE_LINE  (128)
#define L1_DCACHE_SIZE  (MAGIA_DCACHE_WAYS * MAGIA_DCACHE_SETS * L1_DCACHE_LINE)
#define L1_DCACHE_BASE  (L1_BASE + L1_SIZE - L1_DCACHE_SIZE)
#ifdef MAGIA_DCACHE
#define L1_SPM_SIZE     (L1_SIZE - L1_DCACHE_SIZE)
#else
#define L1_SPM_SIZE     (L1_SIZE)
#endif
#define L2_BASE         (0xCC000000)
#define TEST_END_ADDR   (0xCCFF0000)

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
