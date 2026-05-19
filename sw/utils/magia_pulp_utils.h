/*
 * Copyright (C) 2026 ETH Zurich and University of Bologna
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
 * PULP Cluster Utility Functions (CV32 control side).
 *
 * Aligned with magia-sdk (lz/magia_v3/pulp_on_magia):
 *   targets/magia_v3/include/utils/magia_pulp_utils.h
 *
 * ClusterRegs PULP offsets from PULP_CTRL_BASE (0x1740):
 *   0x00: PULP_CLK_EN           — one-hot bitmask; bit N enables PULP core N
 *   0x04: PULP_BINARY           — binary entry point address
 *   0x08: PULP_NB_CORES_TO_WAIT — number of PULP harts to wait for
 *   0x0C: PULP_DONE             — each PULP hart writes 1 here on completion
 */
#ifndef MAGIA_PULP_UTILS_H
#define MAGIA_PULP_UTILS_H

#include <stdint.h>
#include "magia_tile_utils.h"

/* Enable cores selected by one-hot mask (e.g. 0xFF to start all 8 cores). */
static inline void pulp_clk_en(uint32_t core_mask) {
    mmio32(PULP_CLK_EN) = core_mask;
}

static inline void pulp_clk_dis(void) {
    mmio32(PULP_CLK_EN) = 0;
}

static inline void pulp_set_binary(uint32_t addr) {
    mmio32(PULP_BINARY) = addr;
}

static inline void pulp_set_nb_cores_to_wait(uint32_t nb_cores) {
    mmio32(PULP_NB_CORES_TO_WAIT) = nb_cores;
}

static inline uint32_t _pulp_popcount(uint32_t x) {
    x = x - ((x >> 1) & 0x55555555u);
    x = (x & 0x33333333u) + ((x >> 2) & 0x33333333u);
    x = (x + (x >> 4)) & 0x0f0f0f0fu;
    return (x * 0x01010101u) >> 24;
}

/* Write entry point, set number of cores to wait for, then enable selected
 * cores. core_mask is a one-hot bitmask (bit N => core N).            */
static inline void pulp_init(uint32_t binary_start, uint32_t core_mask) {
    pulp_set_binary(binary_start);
    pulp_set_nb_cores_to_wait(_pulp_popcount(core_mask));
    pulp_clk_en(core_mask);
}

#endif /* MAGIA_PULP_UTILS_H */
