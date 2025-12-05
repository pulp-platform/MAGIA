/*
 * Copyright (C) 2024 ETH Zurich and University of Bologna
 *
 * Licensed under the Solderpad Hardware License, Version 0.51 
 * (the "License"); you may not use this file except in compliance 
 * with the License. You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * SPDX-License-Identifier: SHL-0.51
/*
 * Spatz Boot ROM Linker Script for MAGIA Tile
 * 
 * Maps bootrom to 0x10000000 (outside L2 range to avoid AXI address decode overlap).
 * The bootrom is synthesized as a hardware module (spatz_bootrom.sv) mapped via AXI slave.
 * 
 * Boot sequence:
 *   1. Spatz resets with PC = 0x10000000 (SPATZ_BOOT_ADDR in magia_tile.sv)
 *   2. Bootrom initializes core (clear regs, setup interrupts)
 *   3. Bootrom waits for MEIP interrupt via WFI
 *   4. CV32 writes entry point to FUNC_PTR (0x1704)
 *   5. CV32 triggers START_TRIGGER (0x1700) → MEIP interrupt
 *   6. Bootrom reads FUNC_PTR and jumps to user program (typically 0xCC010000 in L2)
 */

SEARCH_DIR(.)
OUTPUT_ARCH(riscv)
ENTRY(_start)

MEMORY
{
    bootrom : ORIGIN = 0x10000000, LENGTH = 0x100  /* 256B at 0x10000000 (outside L2 range to avoid AXI overlap) */
}

SECTIONS
{
    .text.bootrom : {
        KEEP(*(.text.bootrom))
        *(.text)
        *(.text.*)
    } > bootrom

    .rodata : {
        *(.rodata)
        *(.rodata.*)
    } > bootrom

    /* Discard all other sections */
    /DISCARD/ : {
        *(.data)
        *(.data.*)
        *(.bss)
        *(.bss.*)
        *(.comment)
        *(.note.*)
    }
}
