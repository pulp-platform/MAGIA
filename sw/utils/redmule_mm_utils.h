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
 * Authors: 
 * 
 * RedMulE MM Utilities
 * 
 * This header contains MM-related definitions and functions for RedMulE control
 * using MMIO-based register access.
 */

#ifndef REDMULE_MM_UTILS_H
#define REDMULE_MM_UTILS_H

#include <stdint.h>
#include "magia_tile_utils.h"

/* OBI2HWPE Protocol Stamps */
#define REDMULE_ADDR_BASE REDMULE_BASE

#define HWPE_WRITE(value, offset) *(volatile int *)(REDMULE_ADDR_BASE + offset) = value
#define HWPE_READ(offset) *(volatile int *)(REDMULE_ADDR_BASE + offset)

/* Register offsets (RedMulE hwpe-ctrl) */
#define REDMULE_REG_OFFS     0x00
#define REDMULE_TRIGGER      0x00
#define REDMULE_ACQUIRE      0x04
#define REDMULE_EVT_ENABLE   0x08
#define REDMULE_STATUS       0x0C
#define REDMULE_RUNNING_JOB  0x10
#define REDMULE_SOFT_CLEAR   0x14

/* RedMulE configuration registers */
#define REDMULE_REG_X_PTR    0x40
#define REDMULE_REG_W_PTR    0x44
#define REDMULE_REG_Z_PTR    0x48
#define REDMULE_MCFG0_PTR    0x4C
#define REDMULE_MCFG1_PTR    0x50
#define REDMULE_ARITH_PTR    0x54

/* Operations and formats */
#define gemm_ops    0x1
#define Float16     0x1
#define Float16Alt  0x2
#define Float8      0x3
#define Float8Alt   0x4

/* HWPE Register Access Functions */
static inline void redmule_x_add_set(unsigned int value) {
  HWPE_WRITE(value, REDMULE_REG_OFFS + REDMULE_REG_X_PTR);
}

static inline void redmule_w_add_set(unsigned int value) {
  HWPE_WRITE(value, REDMULE_REG_OFFS + REDMULE_REG_W_PTR);
}

static inline void redmule_z_add_set(unsigned int value) {
  HWPE_WRITE(value, REDMULE_REG_OFFS + REDMULE_REG_Z_PTR);
}

static inline void redmule_mcfg_set(uint32_t mcfg0, uint32_t mcfg1) {
  HWPE_WRITE(mcfg0, REDMULE_REG_OFFS + REDMULE_MCFG0_PTR);
  HWPE_WRITE(mcfg1, REDMULE_REG_OFFS + REDMULE_MCFG1_PTR);
}

static inline void redmule_arith_set(uint32_t arith) {
  HWPE_WRITE(arith, REDMULE_REG_OFFS + REDMULE_ARITH_PTR);
}

static inline void hwpe_trigger_job() { 
  HWPE_WRITE(0, REDMULE_TRIGGER); 
}

static inline int hwpe_acquire_job() { 
  int result = HWPE_READ(REDMULE_ACQUIRE);
  return result;
}

static inline unsigned int hwpe_get_status() { 
  unsigned int result = HWPE_READ(REDMULE_STATUS);
  return result;
}

static inline void hwpe_soft_clear() {
  HWPE_WRITE(0, REDMULE_SOFT_CLEAR);
}

static inline void hwpe_cg_enable() { 
  return; 
}

static inline void hwpe_cg_disable() { 
  return; 
}

static inline void hwpe_wait_for_completion() {
#ifdef IRQ_EN
  asm volatile ("wfi" : : : "memory");  // Wait For Interrupt
#else
  // Polling-based completion detection
  unsigned int status;
  unsigned int poll_count = 0;
  unsigned int max_polls = 100000;
  
  do {
    status = hwpe_get_status();
    poll_count++;
    
    // Small pause to not overload system
    if (poll_count % 50 == 0) {
      wait_nop(10);
    }
    
    // Exit conditions: idle status (0) or timeout
    if (status == 0 || poll_count >= max_polls) {
      break;
    }
    
  } while (1);
#endif
}

/* RedMulE Configuration Function */
static inline void redmule_cfg(unsigned int x, unsigned int w, unsigned int z, uint16_t m_size, uint16_t n_size,
                 uint16_t k_size, uint8_t gemm_op, uint8_t gemm_fmt) {

  uint32_t mcfg_reg0 = (k_size << 16) | (m_size << 0);
  uint32_t mcfg_reg1 = n_size << 0;
  uint32_t arith_reg = (gemm_op << 10) | (gemm_fmt << 7);

  redmule_x_add_set((unsigned int)x);
  redmule_w_add_set((unsigned int)w);
  redmule_z_add_set((unsigned int)z);
  redmule_mcfg_set((unsigned int)mcfg_reg0, (unsigned int)mcfg_reg1);
  redmule_arith_set((unsigned int)arith_reg);
}

#endif /* REDMULE_MM_UTILS_H */