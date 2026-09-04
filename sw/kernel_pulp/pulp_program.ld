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

    /* Cluster TCDM (tile L1), ABSOLUTE addresses -- not relocated with the
     * blob. L1 is 16 banks x 8192 words x 4 B = 128 KB @ 0x0002_0000.
     * The benchmarks' own buffers (main.c X_BASE/Z_BASE/PARAMS_BASE) reach
     * at most L1_BASE + 0xC400, so the top of L1 is free. PI_L1-tagged
     * kernel variables live here so the data demux routes them through the
     * fast TCDM path instead of the OBI->AXI path to instruction RAM. */
    l1   (rw)   : ORIGIN = 0x00038000, LENGTH = 0x2000   /* 8 KB @ L1_BASE+0x18000 */
}

__prog_end = ORIGIN(prog) + LENGTH(prog);

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

    /* GOT: entries baked as ORIGIN=0 absolute (plain static link, no
     * dynamic loader). pulp_crt0.S fixes them up in software on core 0. */
    .got : {
        . = ALIGN(4);
        __got_start__ = .;
        *(.got)
        *(.got.plt)
        . = ALIGN(4);
        __got_end__ = .;
    } > prog

    /* PI_L1 variables: VMA in the TCDM (absolute), LMA inside the blob so the
     * initialised ones (e.g. ONE_f = 1.0f) travel with it; pulp_crt0.S copies
     * the image to __l1data_start on core 0 at boot. Uninitialised PI_L1
     * arrays are emitted as zeros in this image, so the same copy zeroes
     * them -- they are deliberately NOT in .bss (the .bss clear loop only
     * covers the blob). */
    .l1data : {
        . = ALIGN(4);
        __l1data_start = .;
        *(.l1data)
        *(.l1data.*)
        . = ALIGN(4);
        __l1data_end = .;
    } > l1 AT> prog
    __l1data_load = LOADADDR(.l1data);

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
