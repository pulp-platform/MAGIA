/*
 * Copyright (C) 2026 ETH Zurich, University of Bologna and Fondazione Chips-IT
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
 * Author: Luca Balboni, Fondazione Chips-IT
 *
 * magia-sdk idma.h on the MAGIA memory-mapped iDMA utils
 */
#ifndef SDK_SHIM_IDMA_H
#define SDK_SHIM_IDMA_H

#include "idma_mm_utils.h"

static inline int idma_init(void) { return 0; }

// dir 0: AXI (L2) to OBI (L1), 1: OBI to AXI
static inline int idma_memcpy_1d(uint8_t dir, uint32_t axi_addr, uint32_t obi_addr, uint32_t len) {
    return dir ? idma_L1ToL2(obi_addr, axi_addr, len) : idma_L2ToL1(axi_addr, obi_addr, len);
}

#endif
