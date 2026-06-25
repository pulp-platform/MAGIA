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
 * Linker script for PULP embedded binary in CV32 instrram (magia_v3).
 *
 * Aligned with magia-sdk targets/magia_v3/pulp/src/pulp_program.ld.
 *
 * Memory layout when embedded:
 *   0xCC000000:               CV32 .text
 *   0xCC000000 + CV32_size:   .spatz_binary (Spatz code, if present)
 *   0xCC000000 + offset:      _pulp_binary_start (.pulp_binary, this binary)
 *
 * Binary is position-independent (compiled with -fPIC -mcmodel=medany).
 * ORIGIN=0x0 means all section addresses are relative to load address.
 *
 * Local stack allocation (tile address space, absolute, set by pulp_crt0.S):
 *   CV32  stack: 0x00010000 – 0x00014000 (16 KB)
 *   PULP  stack: 0x00014000 – 0x0001C000 (32 KB, 8 harts × 2 KB each)
 *   Spatz stack: 0x0001C000 – 0x00020000 (16 KB)
 */

OUTPUT_ARCH(riscv)
ENTRY(_start)

MEMORY
{
    prog (rwxa) : ORIGIN = 0x00000000, LENGTH = 0x10000  /* 64 KB, relative */
}

SECTIONS
{
    .text : {
        . = ALIGN(4);
        KEEP(*(.text.start))
        *(.text)
        *(.text.*)
        . = ALIGN(4);
    } > prog

    .rodata : {
        . = ALIGN(4);
        *(.rodata)
        *(.rodata.*)
        . = ALIGN(4);
    } > prog

    .data : {
        . = ALIGN(4);
        *(.data)
        *(.data.*)
        *(.sdata)
        *(.sdata.*)
        . = ALIGN(4);
    } > prog

    .bss : {
        . = ALIGN(4);
        __bss_start = .;
        *(.bss)
        *(.bss.*)
        *(.sbss)
        *(.sbss.*)
        *(COMMON)
        . = ALIGN(4);
        __bss_end = .;
    } > prog

    /DISCARD/ : {
        *(.comment)
        *(.note.*)
    }
}
