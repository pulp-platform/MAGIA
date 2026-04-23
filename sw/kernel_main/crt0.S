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
 * crt0 for the CV32 main core (one per tile, mhartid 0..NUM_TILES-1).
 * This ELF is placed in L2 instrram at 0xCC000000 and is NOT fetched
 * by PULP cluster cores (they fetch their own ELF at 0xC0000000).
 */

  .section .text
  .global _start
_start:
  csrr    a0, mhartid
  # Main cores only: compute (tile_y, tile_x) just in case the test
  # needs them in a0/a1. Safe even for hart 0.
  andi    a1, a0, 0x1f
  srli    a0, a0, 5

  # Enable CV32E40P mstatus.MIE
  li      t0, 0x1
  csrrs   zero, mstatus, t0
  # Enable CV32E40P SW interrupt (mie[3])
  li      t0, 0x8
  csrrs   zero, mie, t0

  # Clear the BSS segment.
  la      t0, _bss_start
  la      t1, _bss_end
1:
  beq     t0, t1, 2f
  sw      zero, 0(t0)
  addi    t0, t0, 4
  j       1b
2:

  # Stack init: full region is private to the main core.
  la      x2, stack

  # main(0, 0)
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
  ret

# --------------------------------------------------------------------
# Exit: testbench handshake.
# Write halfword (s0 ^ 0x800) & 0x7ff to 0xCCff0000 + mhartid*2.
# --------------------------------------------------------------------
exit:
  csrr    a0, mhartid
  andi    s0, s0, 0x7ff
  li      a1, 0xCCff0000
  li      a2, 0x800
  xor     s0, s0, a2
  add     a1, a1, a0
  add     a1, a1, a0
  sh      s0, 0(a1)
  wfi

.section .vectors, "ax"
.option norvc;

  .org 0x80
  jal x0, _start
