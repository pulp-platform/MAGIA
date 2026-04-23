/*
 * Linker script for the CV32 main-core ELF (target: kernel_main).
 *
 * Layout mirrors magia-sdk targets/magia_v3/link.ld:
 *   instrram @ 0xCC000000  (L2 - main-core instruction image)
 *   dataram  @ 0xCC010000  (L2 - main-core data image)
 *   stack    @ 0x00010000  (SPM - private stack of the main core)
 *
 * NOTE: PULP cluster cores run a SEPARATE ELF linked at 0xC0000000
 *       (see sw/kernel_pulp/link.ld).
 */

SEARCH_DIR(.)
__DYNAMIC  =  0;

MEMORY
{
    instrram    : ORIGIN = 0xcc000000, LENGTH = 0x00008000  /* 32K */
    dataram     : ORIGIN = 0xcc010000, LENGTH = 0x00f00000
    stack       : ORIGIN = 0x00010000, LENGTH = 0x00004000  /* 16K main stack */
}

_min_stack     = 0x1000;
_stack_len     = LENGTH(stack);
_stack_start   = ORIGIN(stack) + LENGTH(stack);
ASSERT(_min_stack <= _stack_len, "Main-core stack too small");

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

    /* Optional: Spatz embedded binary slot (unused for hello_pulp). */
    . = ALIGN(4);
    _spatz_binary_start = .;
    .spatz_binary : {
        KEEP(*(.spatz_binary))
    } > instrram
    _spatz_binary_end  = .;
    _spatz_binary_size = _spatz_binary_end - _spatz_binary_start;

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

    .stack (NOLOAD): {
        . = ALIGN(4);
        . = . + _min_stack ;
        . = ALIGN(4);
        stack = . ;
        _stack = . ;
    } > stack
}
