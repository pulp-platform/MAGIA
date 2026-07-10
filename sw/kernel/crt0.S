/*
 * Copyright (C) 2018-2026 ETH Zurich, University of Bologna and Fondazione Chips-IT
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
 * Unified crt0 for the CV32 main core (one per tile, mhartid 0..NUM_TILES-1).
 *
 * Aligned with the magia-sdk single-binary flow: PULP cluster cores no
 * longer share this code path — they fetch their own position-independent
 * binary embedded in section .pulp_binary at _pulp_binary_start (see
 * sw/kernel/link.ld and sw/kernel_pulp/pulp_crt0.S).
 *
 * exit() signals the testbench via the legacy write at
 *   0xCCff0000 + 2*mhartid  ← (s0 ^ 0x800) & 0x7ff
 */

  .section .text
  .global _start
_start:
  csrr    a0, mhartid
  # Compute (tile_y, tile_x) just in case the test needs them in a0/a1.
  andi    a1, a0, 0x1f
  srli    a0, a0, 5

  # Enable CV32E40P mstatus.MIE (bit 3 = 0x8, not bit 0)
  li      t0, 0x8
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

  # Stack init.
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
# Exit: testbench handshake (CV32 main cores only).
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
