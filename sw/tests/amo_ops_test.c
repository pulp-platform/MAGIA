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
 * Every RV32A atomic on the private, local and remote L1, then LR/SC and AMO counters under contention
 */

#include "magia_tile_utils.h"
#include "magia_utils.h"

#define SLOT_BYTES   (0x10)                  // Guard, target, guard, LR/SC other word
#define SLOTS_BASE   (SYNC_BASE + 0x100)     // Tile 0 address, one slot per source hart
#define PRIV_SLOT    (SCRATCH_BASE + 0x10000)
#define LRSC_CNT     (SYNC_BASE + 0x800)     // Shared counters, in tile 0
#define AMO_CNT      (SYNC_BASE + 0x804)
#define CNT_READY    (SYNC_BASE + 0x808)
#define READY_MAGIC  (0xA70A1C5Eu)           // Unlikely in uninitialized L1
#define GUARD        (0x5A5A5A5Au)
#define NUM_ITER     (8)                     // Increments per hart and per counter
#define MAX_TRIES    (10000)                 // LR/SC attempts before declaring a livelock
#define MAX_POLLS    (20000)

#define DEFINE_AMO(op)                                                                   \
  static uint32_t do_##op(uint32_t addr, uint32_t val) {                                 \
    uint32_t old;                                                                        \
    asm volatile(#op ".w %0, %2, (%1)" : "=r"(old) : "r"(addr), "r"(val) : "memory");   \
    return old;                                                                          \
  }

DEFINE_AMO(amoswap)
DEFINE_AMO(amoadd)
DEFINE_AMO(amoxor)
DEFINE_AMO(amoand)
DEFINE_AMO(amoor)
DEFINE_AMO(amomin)
DEFINE_AMO(amomax)
DEFINE_AMO(amominu)
DEFINE_AMO(amomaxu)

typedef struct {
  const char *name;
  uint32_t  (*fn)(uint32_t addr, uint32_t val);
  uint32_t    init;
  uint32_t    operand;
  uint32_t    result;  // Memory after the AMO; the AMO returns init
} amo_vec_t;

static const amo_vec_t vecs[] = {
  {"amoswap.w", do_amoswap, 0x12345678, 0xCAFEBABE, 0xCAFEBABE},
  {"amoadd.w",  do_amoadd,  0x00000064, 0x00000017, 0x0000007B},
  {"amoadd.w",  do_amoadd,  0xFFFFFFFF, 0x00000002, 0x00000001},
  {"amoxor.w",  do_amoxor,  0xF0F0F0F0, 0xFF00FF00, 0x0FF00FF0},
  {"amoand.w",  do_amoand,  0xF0F0F0F0, 0xFF00FF00, 0xF000F000},
  {"amoor.w",   do_amoor,   0xF0F0F0F0, 0xFF00FF00, 0xFFF0FFF0},
  {"amomin.w",  do_amomin,  0xFFFFFFFB, 0x00000003, 0xFFFFFFFB},  // -5 vs 3
  {"amomin.w",  do_amomin,  0x00000007, 0xFFFFFFFE, 0xFFFFFFFE},  // 7 vs -2
  {"amomax.w",  do_amomax,  0xFFFFFFFB, 0x00000003, 0x00000003},
  {"amomax.w",  do_amomax,  0x7FFFFFFF, 0x80000000, 0x7FFFFFFF},
  {"amominu.w", do_amominu, 0xFFFFFFFB, 0x00000003, 0x00000003},
  {"amominu.w", do_amominu, 0x80000000, 0x7FFFFFFF, 0x7FFFFFFF},
  {"amomaxu.w", do_amomaxu, 0xFFFFFFFB, 0x00000003, 0xFFFFFFFB},
  {"amomaxu.w", do_amomaxu, 0x80000000, 0x7FFFFFFF, 0x80000000},
};

#define NUM_VECS (sizeof(vecs) / sizeof(vecs[0]))

static inline uint32_t lr_w(uint32_t addr) {
  uint32_t val;
  asm volatile("lr.w %0, (%1)" : "=r"(val) : "r"(addr) : "memory");
  return val;
}

// 0 on success, as sc.w
static inline uint32_t sc_w(uint32_t addr, uint32_t val) {
  uint32_t fail;
  asm volatile("sc.w %0, %2, (%1)" : "=&r"(fail) : "r"(addr), "r"(val) : "memory");
  return fail;
}

static int check(int ok, const char *where, const char *what, uint32_t got, uint32_t exp) {
  if (!ok)
    printf("%s %s: got 0x%08x expected 0x%08x\n", where, what, (unsigned int)got, (unsigned int)exp);
  return !ok;
}

static int test_amo_ops(uint32_t slot, const char *where) {
  uint32_t addr = slot + 0x4;
  int errors = 0;

  mmio32(slot)       = GUARD;
  mmio32(slot + 0x8) = GUARD;
  for (unsigned int i = 0; i < NUM_VECS; i++) {
    const amo_vec_t *v = &vecs[i];
    mmio32(addr) = v->init;
    uint32_t old = v->fn(addr, v->operand);
    uint32_t mem = mmio32(addr);
    errors += check(old == v->init,   where, v->name, old, v->init);
    errors += check(mem == v->result, where, v->name, mem, v->result);
  }
  errors += check(mmio32(slot) == GUARD,       where, "guard below", mmio32(slot), GUARD);
  errors += check(mmio32(slot + 0x8) == GUARD, where, "guard above", mmio32(slot + 0x8), GUARD);
  return errors;
}

static int test_lrsc(uint32_t slot, const char *where) {
  uint32_t addr  = slot + 0x4;
  uint32_t other = slot + 0xC;
  uint32_t fail  = 1;
  int errors = 0;
  int tries;

  mmio32(addr)  = 0x11111111;
  mmio32(other) = 0x22222222;

  // No reservation: SC must fail and leave memory alone
  fail = sc_w(addr, 0xDEADBEEF);
  errors += check(fail != 0, where, "sc.w without lr.w", fail, 1);
  errors += check(mmio32(addr) == 0x11111111, where, "memory after failed sc.w", mmio32(addr), 0x11111111);

  // A paired SC may fail spuriously, so retry; it must succeed and return what LR read
  for (tries = 0; tries < MAX_TRIES && fail != 0; tries++) {
    uint32_t val = lr_w(addr);
    errors += check(val == 0x11111111, where, "lr.w", val, 0x11111111);
    fail = sc_w(addr, 0x33333333);
  }
  errors += check(fail == 0, where, "lr.w/sc.w never succeeded", (uint32_t)tries, MAX_TRIES);
  errors += check(mmio32(addr) == 0x33333333, where, "memory after sc.w", mmio32(addr), 0x33333333);

  // The successful SC consumed the reservation
  fail = sc_w(addr, 0x44444444);
  errors += check(fail != 0, where, "second sc.w", fail, 1);
  errors += check(mmio32(addr) == 0x33333333, where, "memory after second sc.w", mmio32(addr), 0x33333333);

  // An SC outside the reserved word must fail
  (void)lr_w(addr);
  fail = sc_w(other, 0x55555555);
  errors += check(fail != 0, where, "sc.w to another word", fail, 1);
  errors += check(mmio32(other) == 0x22222222, where, "other word after sc.w", mmio32(other), 0x22222222);
  return errors;
}

static int lrsc_increment(uint32_t addr) {
  for (int tries = 0; tries < MAX_TRIES; tries++) {
    if (sc_w(addr, lr_w(addr) + 1) == 0)
      return 0;
  }
  return 1;
}

static int wait_for(uint32_t addr, uint32_t exp) {
  for (int polls = 0; polls < MAX_POLLS; polls++) {
    if (mmio32(addr) == exp)
      return 1;
  }
  return 0;
}

int main(void) {
  uint32_t hartid = get_hartid();
  uint32_t next   = (hartid + 1) % NUM_HARTS;
  uint32_t local  = SLOTS_BASE + hartid * L1_TILE_OFFSET + hartid * SLOT_BYTES;
  uint32_t remote = SLOTS_BASE + next   * L1_TILE_OFFSET + hartid * SLOT_BYTES;
  uint32_t total  = NUM_HARTS * NUM_ITER;
  int errors = 0;

  printf("Starting AMO operations test...\n");

  errors += test_amo_ops(PRIV_SLOT, "private L1");
  errors += test_amo_ops(local,     "local L1");
  errors += test_amo_ops(remote,    "remote L1");
  errors += test_lrsc(PRIV_SLOT, "private L1");
  errors += test_lrsc(local,     "local L1");
  errors += test_lrsc(remote,    "remote L1");

  // Contention: every hart increments both counters of tile 0
  if (hartid == 0) {
    mmio32(LRSC_CNT)  = 0;
    mmio32(AMO_CNT)   = 0;
    mmio32(CNT_READY) = READY_MAGIC;
  } else if (!wait_for(CNT_READY, READY_MAGIC)) {
    printf("counters never initialized\n");
    errors++;
  }
  for (int i = 0; i < NUM_ITER; i++) {
    errors += check(!lrsc_increment(LRSC_CNT), "contention", "lr.w/sc.w livelock", i, NUM_ITER);
    (void)do_amoadd(AMO_CNT, 1);
  }
  if (!wait_for(LRSC_CNT, total) || !wait_for(AMO_CNT, total)) {
    errors += check(mmio32(LRSC_CNT) == total, "contention", "lr.w/sc.w counter", mmio32(LRSC_CNT), total);
    errors += check(mmio32(AMO_CNT) == total,  "contention", "amoadd.w counter",  mmio32(AMO_CNT),  total);
  }

  if (errors)
    printf("Test FAILED: %d errors\n", errors);
  else
    printf("Test PASSED\n");

  return errors;
}
