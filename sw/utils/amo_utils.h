/*
 * Copyright (C) 2023-2025 ETH Zurich and University of Bologna
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
 * MAGIA Atomic Memory Operations Utils
 */

#ifndef AMO_UTILS_H
#define AMO_UTILS_H

#include "magia_tile_utils.h"

/**
 * Atomically increase the value stored in addr by an immediate value
 */
int amo_add_immediate(uint32_t addr, uint32_t immediate){
    asm volatile("addi t0, %0, 0" ::"r"(addr));
    asm volatile("mv t1, %0" ::"r"(immediate));
    asm volatile("amoadd.w t2, t1, (t0)" ::);
    return 0;
}

/**
 * Atomically increase the value in addr by amnt
 */
static inline void amo_increment(volatile uint32_t addr, volatile uint32_t amnt){
    asm volatile("amoadd.w x0, %1, (%0)" ::"r"(addr), "r"(amnt):"memory");
}

/**
 * Binary semaphore at sem_addr wait
 */
static inline void bsem_wait(volatile uint32_t *sem_addr){
    asm volatile("1:\n\t"
                 "lr.w.aq t0, (%0)\n\t"
                 "beqz t0, 1b\n\t"
                 "sc.w t0, zero, (%0)\n\t"
                 "bnez t0, 1b\n\t"
                 :
                 :"r"(sem_addr)
                 :"t0", "memory");
}

/**
 * Binary semaphore at sem_addr signal
 */
static inline void bsem_signal(volatile uint32_t *sem_addr){
    asm volatile("li t1, 1\n\t"
                 "amoswap.w.rl t0, t1, 0(%0)\n\t"
                 :
                 :"r"(sem_addr)
                 :"t1", "t0", "memory");
}

/**
 * Counting semaphore at sem_addr wait
 */
static inline void csem_wait(volatile uint32_t *sem_addr){
    asm volatile("li t2, 1\n\t"
                 "li t1, -1\n\t"
                 "1:\n\t"
                 "lw t0, 0(%0)\n\t"
                 "blt t0, t2, 1b\n\t"
                 "amoadd.w.aq t0, t1, 0(%0)\n\t"
                 :
                 :"r"(sem_addr)
                 :"t2", "t1", "t0", "memory");
}

/**
 * Counting semaphore at sem_addr signal
 */
static inline void csem_signal(volatile uint32_t *sem_addr){
    asm volatile("li t1, 1\n\t"
                 "amoadd.w.rl t0, t1, 0(%0)\n\t"
                 :
                 :"r"(sem_addr)
                 :"t1", "t0", "memory");
}

#endif //AMO_UTILS_H