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
 * crt0 for PULP cluster cores (mhartid 32..159).
 * This ELF lives at instrram 0xC0000000 and is fetched ONLY by PULP
 * cores (CV32 main fetches its own ELF at 0xCC000000).
 *
 * Hartid layout matches gvsoc magia_v3 and magia-sdk targets/pulp:
 *   PULP_HARTID_BASE = 2 * NUM_CLUSTERS = 32
 *   TOTAL_PULP_HARTS = NUM_CLUSTERS * PULP_CORE_COUNT
 */

#define PULP_HARTID_BASE   32
#define PULP_CORE_COUNT    8
#define NUM_CLUSTERS       16
#define TOTAL_PULP_HARTS   (NUM_CLUSTERS * PULP_CORE_COUNT)

  .section .text
  .global _start
_start:
  # PULP cluster cores land here after fetch_en is raised. The reset
  # vector is shared with the main core, but the main core has its own
  # instruction memory image and never reaches this ELF.
  # Halt any hart that does not belong to the PULP range.
  csrr    a0, mhartid
  li      t0, PULP_HARTID_BASE
  bltu    a0, t0, _halt_unused_hart            # main cores (should not happen here)
  sub     a1, a0, t0                           # a1 = global PULP id
  li      t0, TOTAL_PULP_HARTS
  bgeu    a1, t0, _halt_unused_hart            # out of range
  li      t0, PULP_CORE_COUNT
  remu    a1, a1, t0                           # a1 = local PULP id (0..7)

  # Enable CV32E40P mstatus.MIE
  li      t0, 0x1
  csrrs   zero, mstatus, t0
  # Enable CV32E40P SW interrupt (mie[3])
  li      t0, 0x8
  csrrs   zero, mie, t0

  # BSS clear — harmless if multiple PULP harts race since all write 0.
  la      t0, _bss_start
  la      t1, _bss_end
1:
  beq     t0, t1, 2f
  sw      zero, 0(t0)
  addi    t0, t0, 4
  j       1b
2:

  # Stack init: per-core slice in SPM region.
  #   sp = stack - local_id * _stack_slice_size
  la      x2, stack
  slli    t0, a1, 11                           # * 2048 (= 0x800, must match link.ld)
  sub     x2, x2, t0

  # Call main(0, 0).
  addi    a0, x0, 0
  addi    a1, x0, 0
  la      t2, main
  jalr    x1, t2
  mv      s0, a0

  # main returned -> exit.
  mv      a0, s0
  la      t2, exit
  jalr    x1, t2

  .global _init
  .global _fini
_init:
_fini:
  ret

# Park unused harts (main cores running this binary, or out-of-range).
_halt_unused_hart:
  wfi
  j       _halt_unused_hart

# PULP exit: write 1 to CLUSTER_DONE (tile CSR @ 0x00001744).
# TILE_CSR_START=0x1700, cluster offset=0x40, CLUSTER_DONE offset=0x04 → 0x1744.
exit:
  li      a1, 0x00001744
  li      a0, 1
  sw      a0, 0(a1)
1:
  wfi
  j       1b

.section .vectors, "ax"
.option norvc;

  .org 0x80
  jal x0, _start
