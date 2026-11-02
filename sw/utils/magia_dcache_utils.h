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
 * Authors: Niccolò Giuliani <niccolo.giuliani@chips.it>
 *
 *  Data cache (data_cc) driver. Without MAGIA_DCACHE the tile has no cache: every function is a no-op
 *  and the counters read 0, so tests can call them unconditionally.
 */
#ifndef MAGIA_DCACHE_UTILS_H
#define MAGIA_DCACHE_UTILS_H

#include <stdint.h>
#include "magia_tile_utils.h"

/* Registers of data_cc_cfg_regs */
#define DCACHE_INFO             (DCACHE_CTRL_BASE + 0x00)  /* R  [7:0] ways, [15:8] log2(sets), [23:16] log2(line bytes), [31:24] version */
#define DCACHE_CTRL             (DCACHE_CTRL_BASE + 0x04)  /* W  bit0 FLUSH_ALL: write back and invalidate every line */
#define DCACHE_STATUS           (DCACHE_CTRL_BASE + 0x08)  /* R  bit0 BUSY: init or flush in progress */
#define DCACHE_PERF_CTRL        (DCACHE_CTRL_BASE + 0x0C)  /* RW bit0 enable, bit1 clear (write 1) */
#define DCACHE_PERF_HIT_R       (DCACHE_CTRL_BASE + 0x10)
#define DCACHE_PERF_HIT_W       (DCACHE_CTRL_BASE + 0x14)
#define DCACHE_PERF_MISS_R      (DCACHE_CTRL_BASE + 0x18)
#define DCACHE_PERF_MISS_W      (DCACHE_CTRL_BASE + 0x1C)
#define DCACHE_PERF_REFILL      (DCACHE_CTRL_BASE + 0x20)
#define DCACHE_PERF_WRITEBACK   (DCACHE_CTRL_BASE + 0x24)
#define DCACHE_PERF_STALL       (DCACHE_CTRL_BASE + 0x28)
#define DCACHE_PERF_TCDM_STALL  (DCACHE_CTRL_BASE + 0x2C)
#define DCACHE_CACHE_EN         (DCACHE_CTRL_BASE + 0x30)  /* RW bit0: cacheable accesses go to the cache (reset 1), bit1 PREFETCH_EN (reset 0) */
#define DCACHE_CACHED_START     (DCACHE_CTRL_BASE + 0x34)  /* RW first cacheable L2 address */
#define DCACHE_CACHED_END       (DCACHE_CTRL_BASE + 0x38)  /* RW end of the cacheable region, excluded */
#define DCACHE_WAY_EN           (DCACHE_CTRL_BASE + 0x3C)  /* RW one bit per way (reset all 1) */

#define DCACHE_CTRL_FLUSH_ALL   (1u << 0)
#define DCACHE_CACHE_EN_BIT     (1u << 0)
#define DCACHE_PREFETCH_EN_BIT  (1u << 1)
#define DCACHE_STATUS_BUSY      (1u << 0)
#define DCACHE_PERF_EN          (1u << 0)
#define DCACHE_PERF_CLEAR       (1u << 1)

typedef struct {
    uint32_t hit_r;
    uint32_t hit_w;
    uint32_t miss_r;
    uint32_t miss_w;
    uint32_t refill;
    uint32_t writeback;
    uint32_t stall;
    uint32_t tcdm_stall;
} dcache_perf_t;

#ifdef MAGIA_DCACHE

static inline void dcache_wait_idle(void) {
    while (mmio32(DCACHE_STATUS) & DCACHE_STATUS_BUSY);
}

/* Writes back the dirty lines to L2 and invalidates the cache. Call it before another master
 * (iDMA, other tiles) reads data written through the cache, and before reading data that another
 * master wrote to L2. Every access of this core issued before the call is already completed. */
static inline void dcache_flush(void) {
    asm volatile("fence" ::: "memory");
    mmio32(DCACHE_CTRL) = DCACHE_CTRL_FLUSH_ALL;
    dcache_wait_idle();
    asm volatile("fence" ::: "memory");
}

static inline void dcache_perf_start(void) {
    mmio32(DCACHE_PERF_CTRL) = DCACHE_PERF_CLEAR;
    mmio32(DCACHE_PERF_CTRL) = DCACHE_PERF_EN;
}

static inline uint32_t dcache_num_ways(void) {
    return mmio32(DCACHE_INFO) & 0xFF;
}

/* 1 if the hardware geometry (INFO) is the one of the software (MAGIA_DCACHE_WAYS/SETS, L1_DCACHE_*) */
static inline int dcache_geometry_ok(void) {
    uint32_t info = mmio32(DCACHE_INFO);
    return (info & 0xFF) == MAGIA_DCACHE_WAYS && (1u << ((info >> 8) & 0xFF)) == MAGIA_DCACHE_SETS;
}

/* The functions below flush first: no other master may use the cache while they run (barrier). */

static inline void dcache_enable(uint32_t enable) {
    uint32_t prefetch = mmio32(DCACHE_CACHE_EN) & DCACHE_PREFETCH_EN_BIT;
    dcache_flush();
    mmio32(DCACHE_CACHE_EN) = prefetch | (enable ? DCACHE_CACHE_EN_BIT : 0);
    asm volatile("fence" ::: "memory");
}

/* Next-line prefetch on or off. No flush needed: a prefetch only brings clean lines. */
static inline void dcache_set_prefetch(uint32_t enable) {
    uint32_t cache_en = mmio32(DCACHE_CACHE_EN) & DCACHE_CACHE_EN_BIT;
    mmio32(DCACHE_CACHE_EN) = cache_en | (enable ? DCACHE_PREFETCH_EN_BIT : 0);
}

/* L2 addresses in [start, end) go through the cache. Keep the code, Test End and the VIP prints out of it. */
static inline void dcache_set_region(uint32_t start, uint32_t end) {
    uint32_t enable = mmio32(DCACHE_CACHE_EN);
    dcache_flush();
    mmio32(DCACHE_CACHE_EN)     = enable & DCACHE_PREFETCH_EN_BIT;
    mmio32(DCACHE_CACHED_START) = start;
    mmio32(DCACHE_CACHED_END)   = end;
    mmio32(DCACHE_CACHE_EN)     = enable;
    asm volatile("fence" ::: "memory");
}

/* Keeps the first n ways of the cache; the L1 slice of the other ones becomes SPM (*spm_base, *spm_size).
 * Each way is a contiguous slice of L1_DCACHE_SIZE / ways bytes. With n = 0 the cache is off. */
static inline void dcache_set_ways(uint32_t n, uint32_t *spm_base, uint32_t *spm_size) {
    uint32_t way_bytes = L1_DCACHE_SIZE / dcache_num_ways();
    dcache_flush();
    mmio32(DCACHE_WAY_EN) = (1u << n) - 1;
    asm volatile("fence" ::: "memory");
    *spm_base = L1_DCACHE_BASE + n * way_bytes;
    *spm_size = L1_DCACHE_SIZE - n * way_bytes;
}

static inline void dcache_perf_stop(void) {
    mmio32(DCACHE_PERF_CTRL) = 0;
}

static inline void dcache_perf_read(dcache_perf_t *perf) {
    perf->hit_r      = mmio32(DCACHE_PERF_HIT_R);
    perf->hit_w      = mmio32(DCACHE_PERF_HIT_W);
    perf->miss_r     = mmio32(DCACHE_PERF_MISS_R);
    perf->miss_w     = mmio32(DCACHE_PERF_MISS_W);
    perf->refill     = mmio32(DCACHE_PERF_REFILL);
    perf->writeback  = mmio32(DCACHE_PERF_WRITEBACK);
    perf->stall      = mmio32(DCACHE_PERF_STALL);
    perf->tcdm_stall = mmio32(DCACHE_PERF_TCDM_STALL);
}

#else

static inline void dcache_wait_idle(void) {}
static inline uint32_t dcache_num_ways(void) { return 1; }  /* no cache: avoids a division by 0 in callers */
static inline void dcache_flush(void) {}
static inline void dcache_perf_start(void) {}
static inline void dcache_perf_stop(void) {}
static inline void dcache_enable(uint32_t enable) {}
static inline void dcache_set_prefetch(uint32_t enable) {}
static inline void dcache_set_region(uint32_t start, uint32_t end) {}
static inline int  dcache_geometry_ok(void) { return 1; }

/* No cache: the whole region is SPM already */
static inline void dcache_set_ways(uint32_t n, uint32_t *spm_base, uint32_t *spm_size) {
    *spm_base = L1_DCACHE_BASE;
    *spm_size = L1_DCACHE_SIZE;
}

static inline void dcache_perf_read(dcache_perf_t *perf) {
    *perf = (dcache_perf_t){0};
}

#endif

static inline void dcache_perf_print(const dcache_perf_t *perf) {
    printf("[DCACHE] hit_r=%u hit_w=%u miss_r=%u miss_w=%u refill=%u writeback=%u stall=%u tcdm_stall=%u\n",
           (unsigned)perf->hit_r, (unsigned)perf->hit_w, (unsigned)perf->miss_r, (unsigned)perf->miss_w,
           (unsigned)perf->refill, (unsigned)perf->writeback, (unsigned)perf->stall, (unsigned)perf->tcdm_stall);
}

#endif /* MAGIA_DCACHE_UTILS_H */
