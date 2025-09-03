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
 * MAGIA FractalSync Synchronization Test
 */

#include "magia_tile_utils.h"
#include "magia_utils.h"
#include "fsync_isa_utils.h"
#include "fsync_api.h"
#include "cache_fill.h"

#define VERBOSE (0)

#define CLIB_FS_TEST
// #define GLOBAL_FS_TEST
// #define ROW_FS_TEST
// #define COL_FS_TEST
// #define HNBR_FS_TEST
// #define VNBR_FS_TEST
// #define HRING_FS_TEST
// #define VRING_FS_TEST

#define NUM_LEVELS (31-__builtin_clz(NUM_HARTS))

#define STALLING

#define CACHE_HEAT_CYCLES (3)

int main(void) {
  uint32_t tile_hartid  = get_hartid();
  uint32_t tile_xhartid = GET_X_ID(tile_hartid);
  uint32_t tile_yhartid = GET_Y_ID(tile_hartid);

  printf("Starting Fractal Sync test...\n");

  // Filling up the cache
  fill_icache();

  // Execute synchronization multiple times to pre-heat the cache
  for (int i = 0; i < CACHE_HEAT_CYCLES; i++) {
#ifdef CLIB_FS_TEST
    // Climb FS tree test
    for (int i = 0; i < NUM_LEVELS; i++){
      printf("Fractal Sync at level %0d...\n", i+1);

#ifndef STALLING
      irq_en(1<<IRQ_FSYNC_DONE);
#endif
      
      uint32_t aggregates = (1 << (i+1))-1;
      uint32_t ids = 0;
#if VERBOSE > 10
      printf("aggregate: 0x%0x\n", aggregates);
      printf("id: 0x%0x\n", ids);
#endif

      // Instruction immediately preceding synchronization: indicates start of the synchronization region
      sentinel_start();

      fsync(ids, aggregates);
#ifndef STALLING
      asm volatile("wfi" ::: "memory");
      printf("Detected IRQ...\n");
#endif

      // Instruction immediately following synchronization: indicates end of the synchronization region
      sentinel_end();

      printf("Synchronized...\n");
    }
#endif

#ifdef GLOBAL_FS_TEST
#if VERBOSE > 1
    printf("Fractal Sync global synchrnonization test...\n");
#endif

#ifndef STALLING
    irq_en(1<<IRQ_FSYNC_DONE);
#endif

#if VERBOSE > 10
    printf("aggregate: 0x%0x\n", _FS_GLOBAL_AGGR);
    printf("id: 0x%0x\n", _FS_GLOBAL_ID);
#endif

    // Instruction immediately preceding synchronization: indicates start of the synchronization region
    sentinel_start();

    fsync_global();
#ifndef STALLING
    asm volatile("wfi" ::: "memory");
    printf("Detected IRQ...\n");
#endif

    // Instruction immediately following synchronization: indicates end of the synchronization region
    sentinel_end();

#if VERBOSE > 1
    printf("Synchronized...\n");
#endif
#endif

#ifdef HNBR_FS_TEST
#if VERBOSE > 1
    printf("Fractal Sync horizontal neighbor synchrnonization test...\n");
#endif

#ifndef STALLING
    irq_en(1<<IRQ_FSYNC_DONE);
#endif

#if VERBOSE > 10
    printf("aggregate: 0x%0x\n", _FS_HNBR_AGGR);
    printf("id: 0x%0x\n", _FS_HNBR_ID);
#endif

    // Instruction immediately preceding synchronization: indicates start of the synchronization region
    sentinel_start();

    fsync_hnbr();
#ifndef STALLING
    asm volatile("wfi" ::: "memory");
    printf("Detected IRQ...\n");
#endif

    // Instruction immediately following synchronization: indicates end of the synchronization region
    sentinel_end();

#if VERBOSE > 1
    printf("Synchronized...\n");
#endif
#endif

#ifdef VNBR_FS_TEST
#if VERBOSE > 1
    printf("Fractal Sync vertical neighbor synchrnonization test...\n");
#endif

#ifndef STALLING
    irq_en(1<<IRQ_FSYNC_DONE);
#endif

#if VERBOSE > 10
    printf("aggregate: 0x%0x\n", _FS_VNBR_AGGR);
    printf("id: 0x%0x\n", _FS_VNBR_ID);
#endif

    // Instruction immediately preceding synchronization: indicates start of the synchronization region
    sentinel_start();

    fsync_vnbr();
#ifndef STALLING
    asm volatile("wfi" ::: "memory");
    printf("Detected IRQ...\n");
#endif

    // Instruction immediately following synchronization: indicates end of the synchronization region
    sentinel_end();

#if VERBOSE > 1
    printf("Synchronized...\n");
#endif
#endif

#ifdef HRING_FS_TEST
#if VERBOSE > 1
    printf("Fractal Sync horizontal ring synchrnonization test...\n");
#endif

#ifndef STALLING
    irq_en(1<<IRQ_FSYNC_DONE);
#endif

#if VERBOSE > 10
    if ((tile_xhartid == 0) || (tile_xhartid == MESH_X_TILES-1)){
      uint32_t id = row_id_lookup(tile_yhartid);
      printf("aggregate: 0x%0x\n", _FS_RC_LVL);
      printf("id: 0x%0x\n", id);
    } else {
      printf("aggregate: 0x%0x\n", _FS_HRING_AGGR);
      printf("id: 0x%0x\n", _FS_HRING_ID);
    }
#endif

    // Instruction immediately preceding synchronization: indicates start of the synchronization region
    sentinel_start();

    fsync_hring();
#ifndef STALLING
    asm volatile("wfi" ::: "memory");
    printf("Detected IRQ...\n");
#endif

    // Instruction immediately following synchronization: indicates end of the synchronization region
    sentinel_end();

#if VERBOSE > 1
    printf("Synchronized...\n");
#endif
#endif

#ifdef VRING_FS_TEST
#if VERBOSE > 1
    printf("Fractal Sync vertical ring synchrnonization test...\n");
#endif

#ifndef STALLING
    irq_en(1<<IRQ_FSYNC_DONE);
#endif

#if VERBOSE > 10
    if ((tile_yhartid == 0) || (tile_yhartid == MESH_Y_TILES-1)){
      uint32_t id = col_id_lookup(tile_xhartid);
      printf("aggregate: 0x%0x\n", _FS_RC_LVL);
      printf("id: 0x%0x\n", id);
    } else {
      printf("aggregate: 0x%0x\n", _FS_VRING_AGGR);
      printf("id: 0x%0x\n", _FS_VRING_ID);
    }
#endif

    // Instruction immediately preceding synchronization: indicates start of the synchronization region
    sentinel_start();

    fsync_vring();
#ifndef STALLING
    asm volatile("wfi" ::: "memory");
    printf("Detected IRQ...\n");
#endif

    // Instruction immediately following synchronization: indicates end of the synchronization region
    sentinel_end();

#if VERBOSE > 1
    printf("Synchronized...\n");
#endif
#endif

#ifdef ROW_FS_TEST
#if VERBOSE > 1
    printf("Fractal Sync row synchrnonization test...\n");
#endif

#ifndef STALLING
    irq_en(1<<IRQ_FSYNC_DONE);
#endif

#if VERBOSE > 10
    uint32_t id = row_id_lookup(tile_yhartid);
    printf("aggregate: 0x%0x\n", _FS_RC_AGGR);
    printf("id: 0x%0x\n", id);
#endif

    // Instruction immediately preceding synchronization: indicates start of the synchronization region
    sentinel_start();

    fsync_rows();
#ifndef STALLING
    asm volatile("wfi" ::: "memory");
    printf("Detected IRQ...\n");
#endif

    // Instruction immediately following synchronization: indicates end of the synchronization region
    sentinel_end();

#if VERBOSE > 1
    printf("Synchronized...\n");
#endif
#endif

#ifdef COL_FS_TEST
#if VERBOSE > 1
    printf("Fractal Sync column synchrnonization test...\n");
#endif

#ifndef STALLING
    irq_en(1<<IRQ_FSYNC_DONE);
#endif

#if VERBOSE > 10
    uint32_t id = col_id_lookup(tile_xhartid);
    printf("aggregate: 0x%0x\n", _FS_RC_AGGR);
    printf("id: 0x%0x\n", id);
#endif

    // Instruction immediately preceding synchronization: indicates start of the synchronization region
    sentinel_start();

    fsync_cols();
#ifndef STALLING
    asm volatile("wfi" ::: "memory");
    printf("Detected IRQ...\n");
#endif

    // Instruction immediately following synchronization: indicates end of the synchronization region
    sentinel_end();

#if VERBOSE > 1
    printf("Synchronized...\n");
#endif
#endif
  }

  printf("Fractal Sync test finished...\n");

  mmio16(TEST_END_ADDR + tile_hartid*2) = DEFAULT_EXIT_CODE - tile_hartid;

  return 0;
}
