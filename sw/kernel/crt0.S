/*
 * Copyright (C) 2018-2019 ETH Zurich and University of Bologna
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
 * Authors: Germain Haugou, ETH (germain.haugou@iis.ee.ethz.ch)
 *          Francesco Conti, ETHZ & UNIBO
 *
 * Unified crt0 for MAGIA tile.
 *
 * Hartid layout (mirrors gvsoc magia_v3 and magia-sdk targets/pulp):
 *   - mhartid <  PULP_HARTID_BASE   : CV32 "main" core per tile
 *   - mhartid >= PULP_HARTID_BASE   : PULP cluster cores
 *
 * With NUM_CLUSTERS = 16 and PULP_CORE_COUNT = 8:
 *   PULP_HARTID_BASE = 2 * NUM_CLUSTERS = 32
 *
 * Stack layout (driven by the linker script):
 *   `stack` = top of the stack region
 *   slot 0 (top)    -> CV32 main core
 *   slot local_id+1 -> PULP core local_id (0..PULP_CORE_COUNT-1)
 *   sp = stack - slot_idx * STACK_SLICE_SIZE
 */

#define PULP_HARTID_BASE   32
#define PULP_CORE_COUNT    8
#define STACK_SLICE_SIZE   0x800        /* must match _stack_slice_size in link.ld */

  .section .text
  .global _start
_start:
  # All harts enter here. Compute the stack slot index in a1.
  csrr    a0, mhartid

  li      t0, PULP_HARTID_BASE
  bltu    a0, t0, _main_core_entry

  # --------------------------------------------------------------------
  # PULP cluster core path (mhartid >= PULP_HARTID_BASE)
  # local_id = (mhartid - PULP_HARTID_BASE) % PULP_CORE_COUNT
  # slot     = local_id + 1  (slot 0 is reserved for the main core)
  # --------------------------------------------------------------------
  sub     a1, a0, t0
  li      t0, PULP_CORE_COUNT
  remu    a1, a1, t0                  # a1 = local_id (0..PULP_CORE_COUNT-1)
  addi    a1, a1, 1                   # slot index
  j       _common_init

_main_core_entry:
  li      a1, 0                       # main core uses slot 0 (top)

_common_init:
  # Enable CV32E40P mstatus.MIE
  li      t0, 0x1
  csrrs   zero, mstatus, t0
  # Enable CV32E40P SW interrupt (mie[3])
  li      t0, 0x8
  csrrs   zero, mie, t0

  # BSS clear: executed only by the CV32 main core to avoid a
  # multi-writer race between CV32 and PULP cluster cores.
  csrr    t2, mhartid
  li      t3, PULP_HARTID_BASE
  bgeu    t2, t3, 2f
  la      t0, _bss_start
  la      t1, _bss_end
1:
  beq     t0, t1, 2f
  sw      zero, 0(t0)
  addi    t0, t0, 4
  j       1b
2:

  # Stack init: sp = stack - slot_idx * STACK_SLICE_SIZE
  la      x2, stack
  li      t0, STACK_SLICE_SIZE
  mul     t0, a1, t0
  sub     x2, x2, t0

  # Zero argc/argv and jump to main(argc=0, argv=0).
  addi    a0, x0, 0
  addi    a1, x0, 0
  la      t2, main
  jalr    x1, t2
  mv      s0, a0

  # If main returns, call exit.
  mv      a0, s0
  la      t2, exit
  jalr    x1, t2

  .global _init
  .global _fini
_init:
_fini:
  # Nothing to do (init_array/fini_array are used).
  ret

# --------------------------------------------------------------------
# Exit: every hart ends up here when main() returns.
#
# PULP cluster cores write 1 to PULP_DONE (tile CSR @ 0x00001744);
# the tile CSR counts reports and raises its done flag/IRQ after
# PULP_CORE_COUNT writes.
# The CV32 main core signals the testbench via the legacy exit-code
# write at 0xCCFF0000 + mhartid*2.
# --------------------------------------------------------------------
exit:
  csrr    t2, mhartid
  li      t3, PULP_HARTID_BASE
  bgeu    t2, t3, _pulp_exit

  # ---- CV32 main core exit (testbench handshake) ----
  csrr    a0, mhartid
  andi    s0, s0, 0x7ff
  li      a1, 0xCCff0000
  li      a2, 0x800
  xor     s0, s0, a2
  add     a1, a1, a0
  add     a1, a1, a0
  sh      s0, 0(a1)
  wfi

_pulp_exit:
  # ---- PULP cluster core exit: write 1 to PULP_DONE (0x00001744) ----
  li      a1, 0x00001744
  li      a0, 1
  sw      a0, 0(a1)
_pulp_park:
  wfi
  j       _pulp_park

.section .vectors, "ax"
.option norvc;

  .org 0x80
  jal x0, _start
