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
 */

SEARCH_DIR(.)
__DYNAMIC  =  0;

MEMORY
{
    instrram    : ORIGIN = 0xcc000000, LENGTH = 0x8000
    dataram     : ORIGIN = 0xcc010000, LENGTH = 0xF00000
    stack       : ORIGIN = 0x00010000, LENGTH = 0x10000 /* 64K stack region */
}

/* Stack information variables.
 * Layout (mirrors magia-sdk targets/pulp/link.ld):
 *   - Each hart gets _stack_slice_size bytes.
 *   - Slot 0 (top) is reserved for the CV32 main core.
 *   - Slots 1..PULP_CORE_COUNT are used by PULP cluster cores
 *     (local_id 0..PULP_CORE_COUNT-1 maps to slot local_id+1).
 *   - crt0 computes: sp = stack - local_id * _stack_slice_size
 *     so the main core uses the topmost slice and each PULP core
 *     gets its own dedicated slice below.
 */
_stack_slice_size = 0x800;                       /* 2 KB per hart */
_stack_hart_count = 9;                           /* 1 main + 8 PULP cores */
_min_stack        = _stack_slice_size * _stack_hart_count;  /* 18 KB */
_stack_len        = LENGTH(stack);
_stack_start      = ORIGIN(stack) + LENGTH(stack);
ASSERT(_min_stack <= _stack_len, "Configured stacks exceed stack memory");

/* We have to align each sector to word boundaries as our current s19->slm
 * conversion scripts are not able to handle non-word aligned sections. */

SECTIONS
{
    .vectors :
    {
        . = ALIGN(4);
        KEEP(*(.vectors))
    } > instrram

    .text : {
        . = ALIGN(4);
        _stext = .;
        *(.text)
        _etext  =  .;
        __CTOR_LIST__ = .;
        LONG((__CTOR_END__ - __CTOR_LIST__) / 4 - 2)
        *(.ctors)
        LONG(0)
        __CTOR_END__ = .;
        __DTOR_LIST__ = .;
        LONG((__DTOR_END__ - __DTOR_LIST__) / 4 - 2)
        *(.dtors)
        LONG(0)
        __DTOR_END__ = .;
        *(.lit)
        *(.shdata)
        _endtext = .;
    }  > instrram

    /* Spatz embedded binary - inlined from header file */
    /* Positioned right after CV32 .text in instrram */
    
    . = ALIGN(4);
    _spatz_binary_start = .;
    
    .spatz_binary : {
        KEEP(*(.spatz_binary))
    } > instrram
    
    _spatz_binary_end = .;
    _spatz_binary_size = _spatz_binary_end - _spatz_binary_start;

    /*--------------------------------------------------------------------*/
    /* Global constructor/destructor segment                              */
    /*--------------------------------------------------------------------*/

    .preinit_array     :
    {
      PROVIDE_HIDDEN (__preinit_array_start = .);
      KEEP (*(.preinit_array))
      PROVIDE_HIDDEN (__preinit_array_end = .);
    } > dataram

    .init_array     :
    {
      PROVIDE_HIDDEN (__init_array_start = .);
      KEEP (*(SORT(.init_array.*)))
      KEEP (*(.init_array ))
      PROVIDE_HIDDEN (__init_array_end = .);
    } > dataram

    .fini_array     :
    {
      PROVIDE_HIDDEN (__fini_array_start = .);
      KEEP (*(SORT(.fini_array.*)))
      KEEP (*(.fini_array ))
      PROVIDE_HIDDEN (__fini_array_end = .);
    } > dataram

    .rodata : {
        . = ALIGN(4);
        *(.rodata);
        *(.rodata.*)
    } > dataram

    .shbss :
    {
        . = ALIGN(4);
        *(.shbss)
    } > dataram

    .data : {
        . = ALIGN(4);
        sdata  =  .;
        _sdata  =  .;
        *(.data);
        *(.data.*)
        edata  =  .;
        _edata  =  .;
    } > dataram

    .bss :
    {
        . = ALIGN(4);
        _bss_start = .;
        *(.bss)
        *(.bss.*)
        *(.sbss)
        *(.sbss.*)
        *(COMMON)
        _bss_end = .;
    } > dataram

    /* Place the stack at the TOP of the stack memory region so that
     * `stack` resolves to the highest address. crt0 then subtracts
     * local_id * _stack_slice_size to give each hart its own slice.
     */
    .stack ORIGIN(stack) + LENGTH(stack) - _min_stack (NOLOAD): {
        . = ALIGN(4);
        _stack_bottom = .;
        . = . + _min_stack ;
        . = ALIGN(4);
        stack = . ;
        _stack = . ;
    } > stack

}