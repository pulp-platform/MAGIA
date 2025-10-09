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
 * Authors: Luca Balboni <luca.balboni@unibo.it>
 *          Based on fsync_isa_utils.h by Victor Isachi
 * 
 * MAGIA FractalSync Memory-Mapped Utils
 */

#ifndef FSYNC_MM_UTILS_H
#define FSYNC_MM_UTILS_H

#include "magia_tile_utils.h"

/* Memory-mapped FractalSync register offsets */
#define FSYNC_MM_AGGR_REG_OFFSET    (0x00)
#define FSYNC_MM_ID_REG_OFFSET      (0x04)
#define FSYNC_MM_CONTROL_REG_OFFSET (0x08)
#define FSYNC_MM_STATUS_REG_OFFSET  (0x0C)

/* Status register bits */
#define FSYNC_MM_STATUS_BUSY_MASK   (1 << 2)

/* Memory-mapped sync function */
static inline void fsync_mm(volatile uint32_t id, volatile uint32_t aggregate){
  volatile uint32_t *fsync_base = (volatile uint32_t *)(FSYNC_BASE);
  
  fsync_base[FSYNC_MM_AGGR_REG_OFFSET/4] = aggregate;
  fsync_base[FSYNC_MM_ID_REG_OFFSET/4] = id;
  fsync_base[FSYNC_MM_CONTROL_REG_OFFSET/4] = 1;
  
#ifdef STALLING
  // Polling mode - wait for completion
  volatile uint32_t status;
  do {
    status = fsync_base[FSYNC_MM_STATUS_REG_OFFSET/4];
  } while (status & FSYNC_MM_STATUS_BUSY_MASK);
#endif
  // In non-stalling mode, the function returns immediately
  // and the caller should do wfi to wait for interrupt
}

#endif /*FSYNC_MM_UTILS_H*/