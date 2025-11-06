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
 * Authors: Luca Balboni <luca.balboni10@studio.unibo.it>
 * 
 * MAGIA iDMA Memory-Mapped I/O Utils - Simplified Version
 * Simplified version without channel ID exposure (always uses stream 0)
 */

#ifndef IDMA_MM_UTILS_SIMPLE_H
#define IDMA_MM_UTILS_SIMPLE_H

#include <stdint.h>
#include "magia_tile_utils.h"

#define IDMA_MM_DIRECTION_OFFSET (0x200)
#define IDMA_MM_BASE_AXI2OBI (IDMA_BASE)
#define IDMA_MM_BASE_OBI2AXI (IDMA_BASE + IDMA_MM_DIRECTION_OFFSET)

#define IDMA_CONF_OFFSET          (0x00)
#define IDMA_STATUS_OFFSET        (0x04)  
#define IDMA_NEXT_ID_OFFSET       (0x44)  
#define IDMA_DONE_ID_OFFSET       (0x84)  
#define IDMA_DST_ADDR_LOW_OFFSET  (0xD0)
#define IDMA_SRC_ADDR_LOW_OFFSET  (0xD8)
#define IDMA_LENGTH_LOW_OFFSET    (0xE0)
#define IDMA_DST_STRIDE_2_LOW_OFFSET (0xE8)
#define IDMA_SRC_STRIDE_2_LOW_OFFSET (0xF0)
#define IDMA_REPS_2_LOW_OFFSET    (0xF8)
#define IDMA_DST_STRIDE_3_LOW_OFFSET (0x100)
#define IDMA_SRC_STRIDE_3_LOW_OFFSET (0x108)
#define IDMA_REPS_3_LOW_OFFSET    (0x110)

#define IDMA_CONF_ADDR(is_l1_to_l2)          ((is_l1_to_l2) ? (IDMA_MM_BASE_OBI2AXI + IDMA_CONF_OFFSET) : (IDMA_MM_BASE_AXI2OBI + IDMA_CONF_OFFSET))
#define IDMA_STATUS_ADDR(is_l1_to_l2)        ((is_l1_to_l2) ? (IDMA_MM_BASE_OBI2AXI + IDMA_STATUS_OFFSET) : (IDMA_MM_BASE_AXI2OBI + IDMA_STATUS_OFFSET))
#define IDMA_NEXT_ID_ADDR(is_l1_to_l2)       ((is_l1_to_l2) ? (IDMA_MM_BASE_OBI2AXI + IDMA_NEXT_ID_OFFSET) : (IDMA_MM_BASE_AXI2OBI + IDMA_NEXT_ID_OFFSET))
#define IDMA_DONE_ID_ADDR(is_l1_to_l2)       ((is_l1_to_l2) ? (IDMA_MM_BASE_OBI2AXI + IDMA_DONE_ID_OFFSET) : (IDMA_MM_BASE_AXI2OBI + IDMA_DONE_ID_OFFSET))
#define IDMA_DST_ADDR_LOW_ADDR(is_l1_to_l2)  ((is_l1_to_l2) ? (IDMA_MM_BASE_OBI2AXI + IDMA_DST_ADDR_LOW_OFFSET) : (IDMA_MM_BASE_AXI2OBI + IDMA_DST_ADDR_LOW_OFFSET))
#define IDMA_SRC_ADDR_LOW_ADDR(is_l1_to_l2)  ((is_l1_to_l2) ? (IDMA_MM_BASE_OBI2AXI + IDMA_SRC_ADDR_LOW_OFFSET) : (IDMA_MM_BASE_AXI2OBI + IDMA_SRC_ADDR_LOW_OFFSET))
#define IDMA_LENGTH_LOW_ADDR(is_l1_to_l2)    ((is_l1_to_l2) ? (IDMA_MM_BASE_OBI2AXI + IDMA_LENGTH_LOW_OFFSET) : (IDMA_MM_BASE_AXI2OBI + IDMA_LENGTH_LOW_OFFSET))
#define IDMA_DST_STRIDE_2_LOW_ADDR(is_l1_to_l2) ((is_l1_to_l2) ? (IDMA_MM_BASE_OBI2AXI + IDMA_DST_STRIDE_2_LOW_OFFSET) : (IDMA_MM_BASE_AXI2OBI + IDMA_DST_STRIDE_2_LOW_OFFSET))
#define IDMA_SRC_STRIDE_2_LOW_ADDR(is_l1_to_l2) ((is_l1_to_l2) ? (IDMA_MM_BASE_OBI2AXI + IDMA_SRC_STRIDE_2_LOW_OFFSET) : (IDMA_MM_BASE_AXI2OBI + IDMA_SRC_STRIDE_2_LOW_OFFSET))
#define IDMA_REPS_2_LOW_ADDR(is_l1_to_l2)    ((is_l1_to_l2) ? (IDMA_MM_BASE_OBI2AXI + IDMA_REPS_2_LOW_OFFSET) : (IDMA_MM_BASE_AXI2OBI + IDMA_REPS_2_LOW_OFFSET))
#define IDMA_DST_STRIDE_3_LOW_ADDR(is_l1_to_l2) ((is_l1_to_l2) ? (IDMA_MM_BASE_OBI2AXI + IDMA_DST_STRIDE_3_LOW_OFFSET) : (IDMA_MM_BASE_AXI2OBI + IDMA_DST_STRIDE_3_LOW_OFFSET))
#define IDMA_SRC_STRIDE_3_LOW_ADDR(is_l1_to_l2) ((is_l1_to_l2) ? (IDMA_MM_BASE_OBI2AXI + IDMA_SRC_STRIDE_3_LOW_OFFSET) : (IDMA_MM_BASE_AXI2OBI + IDMA_SRC_STRIDE_3_LOW_OFFSET))
#define IDMA_REPS_3_LOW_ADDR(is_l1_to_l2)    ((is_l1_to_l2) ? (IDMA_MM_BASE_OBI2AXI + IDMA_REPS_3_LOW_OFFSET) : (IDMA_MM_BASE_AXI2OBI + IDMA_REPS_3_LOW_OFFSET))

#define IDMA_CONF_DECOUPLE_AW_BIT    (0)
#define IDMA_CONF_DECOUPLE_RW_BIT    (1)
#define IDMA_CONF_SRC_REDUCE_LEN_BIT (2)
#define IDMA_CONF_DST_REDUCE_LEN_BIT (3)
#define IDMA_CONF_SRC_MAX_LLEN_SHIFT (4)
#define IDMA_CONF_DST_MAX_LLEN_SHIFT (7)
#define IDMA_CONF_ENABLE_ND_SHIFT    (10)

#define IDMA_STATUS_BUSY_MASK        (0x3FF)

// ============================================================================
// Low-Level Configuration and Control
// ============================================================================

static inline void idma_mm_conf_in(){
  uint32_t conf_val = (3 << IDMA_CONF_ENABLE_ND_SHIFT);
  mmio32(IDMA_CONF_ADDR(0)) = conf_val;
}

static inline void idma_mm_conf_out(){
  uint32_t conf_val = (3 << IDMA_CONF_ENABLE_ND_SHIFT);
  mmio32(IDMA_CONF_ADDR(1)) = conf_val;
}

static inline uint32_t idma_mm_is_busy_in() {
  uint32_t status = mmio32(IDMA_STATUS_ADDR(0));
  return (status & IDMA_STATUS_BUSY_MASK) ? 1 : 0;
}

static inline uint32_t idma_mm_is_busy_out() {
  uint32_t status = mmio32(IDMA_STATUS_ADDR(1));
  return (status & IDMA_STATUS_BUSY_MASK) ? 1 : 0;
}

static inline uint32_t idma_mm_start_in() {
  return mmio32(IDMA_NEXT_ID_ADDR(0));
}

static inline uint32_t idma_mm_start_out() {
  return mmio32(IDMA_NEXT_ID_ADDR(1));
}

static inline uint32_t idma_mm_get_done_id_in() {
  return mmio32(IDMA_DONE_ID_ADDR(0));
}

static inline uint32_t idma_mm_get_done_id_out() {
  return mmio32(IDMA_DONE_ID_ADDR(1));
}

// ============================================================================
// Low-Level Transfer Parameter Setters
// ============================================================================

static inline void idma_mm_set_addr_len_in(uint32_t dst_addr, uint32_t src_addr, uint32_t length) {
  mmio32(IDMA_DST_ADDR_LOW_ADDR(0)) = dst_addr;
  mmio32(IDMA_SRC_ADDR_LOW_ADDR(0)) = src_addr;
  mmio32(IDMA_LENGTH_LOW_ADDR(0)) = length;
}

static inline void idma_mm_set_addr_len_out(uint32_t dst_addr, uint32_t src_addr, uint32_t length) {
  mmio32(IDMA_DST_ADDR_LOW_ADDR(1)) = dst_addr;
  mmio32(IDMA_SRC_ADDR_LOW_ADDR(1)) = src_addr;
  mmio32(IDMA_LENGTH_LOW_ADDR(1)) = length;
}

static inline void idma_mm_set_std2_rep2_in(uint32_t dst_stride_2, uint32_t src_stride_2, uint32_t reps_2) {
  mmio32(IDMA_DST_STRIDE_2_LOW_ADDR(0)) = dst_stride_2;
  mmio32(IDMA_SRC_STRIDE_2_LOW_ADDR(0)) = src_stride_2;
  mmio32(IDMA_REPS_2_LOW_ADDR(0)) = reps_2;
}

static inline void idma_mm_set_std2_rep2_out(uint32_t dst_stride_2, uint32_t src_stride_2, uint32_t reps_2) {
  mmio32(IDMA_DST_STRIDE_2_LOW_ADDR(1)) = dst_stride_2;
  mmio32(IDMA_SRC_STRIDE_2_LOW_ADDR(1)) = src_stride_2;
  mmio32(IDMA_REPS_2_LOW_ADDR(1)) = reps_2;
}

static inline void idma_mm_set_std3_rep3_in(uint32_t dst_stride_3, uint32_t src_stride_3, uint32_t reps_3) {
  mmio32(IDMA_DST_STRIDE_3_LOW_ADDR(0)) = dst_stride_3;
  mmio32(IDMA_SRC_STRIDE_3_LOW_ADDR(0)) = src_stride_3;
  mmio32(IDMA_REPS_3_LOW_ADDR(0)) = reps_3;
}

static inline void idma_mm_set_std3_rep3_out(uint32_t dst_stride_3, uint32_t src_stride_3, uint32_t reps_3) {
  mmio32(IDMA_DST_STRIDE_3_LOW_ADDR(1)) = dst_stride_3;
  mmio32(IDMA_SRC_STRIDE_3_LOW_ADDR(1)) = src_stride_3;
  mmio32(IDMA_REPS_3_LOW_ADDR(1)) = reps_3;
}

// ============================================================================
// 1D Transfers
// ============================================================================

static inline void idma_L2ToL1(unsigned int src, unsigned int dst, unsigned short size) {
  idma_mm_conf_in();
  idma_mm_set_addr_len_in(dst, src, size);
  idma_mm_set_std2_rep2_in(0, 0, 1);
  idma_mm_set_std3_rep3_in(0, 0, 1);
  (void)idma_mm_start_in();
}

static inline void idma_L1ToL2(unsigned int src, unsigned int dst, unsigned short size) {
  idma_mm_conf_out();
  idma_mm_set_addr_len_out(dst, src, size);
  idma_mm_set_std2_rep2_out(0, 0, 1);
  idma_mm_set_std3_rep3_out(0, 0, 1);
  (void)idma_mm_start_out();
}

static inline void idma_L1ToL1(unsigned int src, unsigned int dst, unsigned short size) {
  idma_mm_conf_in();
  idma_mm_set_addr_len_in(dst, src, size);
  idma_mm_set_std2_rep2_in(0, 0, 1);
  idma_mm_set_std3_rep3_in(0, 0, 1);
  (void)idma_mm_start_in();
}

// ============================================================================
// 2D Transfers
// ============================================================================

static inline void idma_L2ToL1_2d(unsigned int src, unsigned int dst, unsigned short size,
                                  unsigned int src_stride, unsigned int dst_stride, unsigned int num_reps) {
  idma_mm_conf_in();
  idma_mm_set_addr_len_in(dst, src, size);
  idma_mm_set_std2_rep2_in(dst_stride, src_stride, num_reps);
  idma_mm_set_std3_rep3_in(0, 0, 1);
  (void)idma_mm_start_in();
}

static inline void idma_L1ToL2_2d(unsigned int src, unsigned int dst, unsigned short size,
                                  unsigned int src_stride, unsigned int dst_stride, unsigned int num_reps) {
  idma_mm_conf_out();
  idma_mm_set_addr_len_out(dst, src, size);
  idma_mm_set_std2_rep2_out(dst_stride, src_stride, num_reps);
  idma_mm_set_std3_rep3_out(0, 0, 1);
  (void)idma_mm_start_out();
}

static inline void idma_L1ToL1_2d(unsigned int src, unsigned int dst, unsigned short size,
                                  unsigned int src_stride, unsigned int dst_stride, unsigned int num_reps) {
  idma_mm_conf_in();
  idma_mm_set_addr_len_in(dst, src, size);
  idma_mm_set_std2_rep2_in(dst_stride, src_stride, num_reps);
  idma_mm_set_std3_rep3_in(0, 0, 1);
  (void)idma_mm_start_in();
}

// ============================================================================
// 3D Transfers
// ============================================================================

static inline void idma_L2ToL1_3d(unsigned int src, unsigned int dst, unsigned short size,
                                  unsigned int src_stride_2, unsigned int dst_stride_2, unsigned int num_reps_2,
                                  unsigned int src_stride_3, unsigned int dst_stride_3, unsigned int num_reps_3) {
  idma_mm_conf_in();
  idma_mm_set_addr_len_in(dst, src, size);
  idma_mm_set_std2_rep2_in(dst_stride_2, src_stride_2, num_reps_2);
  idma_mm_set_std3_rep3_in(dst_stride_3, src_stride_3, num_reps_3);
  (void)idma_mm_start_in();
}

static inline void idma_L1ToL2_3d(unsigned int src, unsigned int dst, unsigned short size,
                                  unsigned int src_stride_2, unsigned int dst_stride_2, unsigned int num_reps_2,
                                  unsigned int src_stride_3, unsigned int dst_stride_3, unsigned int num_reps_3) {
  idma_mm_conf_out();
  idma_mm_set_addr_len_out(dst, src, size);
  idma_mm_set_std2_rep2_out(dst_stride_2, src_stride_2, num_reps_2);
  idma_mm_set_std3_rep3_out(dst_stride_3, src_stride_3, num_reps_3);
  (void)idma_mm_start_out();
}

static inline void idma_L1ToL1_3d(unsigned int src, unsigned int dst, unsigned short size,
                                  unsigned int src_stride_2, unsigned int dst_stride_2, unsigned int num_reps_2,
                                  unsigned int src_stride_3, unsigned int dst_stride_3, unsigned int num_reps_3) {
  idma_mm_conf_in();
  idma_mm_set_addr_len_in(dst, src, size);
  idma_mm_set_std2_rep2_in(dst_stride_2, src_stride_2, num_reps_2);
  idma_mm_set_std3_rep3_in(dst_stride_3, src_stride_3, num_reps_3);
  (void)idma_mm_start_in();
}

// ============================================================================
// Wait and Check Functions
// ============================================================================

static inline void idma_wait_in() {
  while(idma_mm_is_busy_in()) {
    wait_nop(1);
  }
}

static inline void idma_wait_out() {
  while(idma_mm_is_busy_out()) {
    wait_nop(1);
  }
}

static inline void idma_barrier() {
  while(dma_status()) {
    wait_nop(1);
  }
}

static inline unsigned int idma_is_busy_in() {
  return idma_mm_is_busy_in();
}

static inline unsigned int idma_is_busy_out() {
  return idma_mm_is_busy_out();
}

static inline unsigned int dma_status() {
  return idma_mm_is_busy_in() || idma_mm_is_busy_out();
}

#endif /*IDMA_MM_UTILS_SIMPLE_H*/
