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
 * Memory Layout (when embedded in CV32 instrram):
 *   0xCC000000: CV32 .text
 *   0xCC000000 + CV32_size: .spatz_binary (Spatz code inline)
 * 
 * Stack: Spatz uses remaining 16KB after CV32 (0x0001C000-0x00020000)
 *   - CV32 uses: 0x00010000-0x0001C000 (48KB)
 *   - Spatz uses: 0x0001C000-0x00020000 (16KB)
 */

OUTPUT_ARCH(riscv)
ENTRY(_start)

MEMORY
{
    prog (rwxa)  : ORIGIN = 0x00000000, LENGTH = 0x10000  /* 64KB max - relative addressing */
}

/* Stack configuration - Spatz uses remaining 16KB after CV32 */
/* CV32 uses: 0x00010000-0x0001C000 (48KB, from CV32 link.ld) */
/* Spatz uses: 0x0001C000-0x00020000 (16KB) */
_stack_start = 0x00020000;  /* Top of Spatz stack (grows downward) */

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

    /* Stack symbol for spatz_crt0.S */
    /* spatz_crt0.S uses: la sp, stack */
    stack = _stack_start;

    /* Discard debug sections */
    /DISCARD/ : {
        *(.comment)
        *(.note.*)
    }
}
