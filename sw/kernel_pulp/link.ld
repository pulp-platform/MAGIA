/*
 * Linker script for the PULP cluster-core ELF (target: kernel_pulp).
 *
 * Layout mirrors magia-sdk targets/pulp/link.ld:
 *   instrram @ 0xC0000000  (L2 - dedicated PULP instruction image)
 *   dataram  @ 0xC0100000  (L2 - PULP data image)
 *   stack    @ 0x00014000  (SPM - segmented per PULP core)
 *
 * NOTE: The CV32 main core runs a SEPARATE ELF at 0xCC000000
 *       (see sw/kernel_main/link.ld).
 */

SEARCH_DIR(.)
__DYNAMIC  =  0;

MEMORY
{
    instrram    : ORIGIN = 0xc0000000, LENGTH = 0x00008000  /* 32K */
    dataram     : ORIGIN = 0xc0100000, LENGTH = 0x00f00000
    stack       : ORIGIN = 0x00014000, LENGTH = 0x00008000  /* 32K shared PULP region */
}

/* Stack slicing: 2KB per hart, up to 16 cores per cluster. */
_stack_slice_size = 0x800;
_stack_max_cores  = 16;
_stack_hart_count = 8;
ASSERT(_stack_hart_count > 0,                     "PULP core count must be >= 1");
ASSERT(_stack_hart_count <= _stack_max_cores,     "PULP core count must be <= 16");
_min_stack       = _stack_slice_size * _stack_hart_count;
_stack_len       = LENGTH(stack);
_stack_start     = ORIGIN(stack) + LENGTH(stack);
ASSERT(_min_stack <= _stack_len, "Configured PULP stacks exceed stack memory");

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

    .data : {
        . = ALIGN(4);
        sdata  =  .;
        _sdata  =  .;
        *(.data);
        *(.data.*)
        edata  =  .;
        _edata  =  .;
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

    /* Place the stack symbol at the TOP of the stack region so that
     * crt0 can do: sp = stack - local_id * _stack_slice_size.
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
