/*
 * Spatz Program Linker Script for MAGIA Tile - INLINE EMBEDDING
 * 
 * This script generates RELATIVE addressing for inline embedding in CV32 instrram.
 * The binary will be placed in .spatz_binary section right after CV32 .text.
 * 
 * Position: Linked at 0x00000000 (relative) - actual address determined by linker
 * when embedding in CV32 instrram after .text section.
 * 
 * Memory Layout (when loaded in CV32 instrram):
 *   0xCC000000 + CV32_size: Spatz program embedded inline
 * 
 * Stack: SHARED with CV32 in L1 memory (0x00010000-0x00020000, 64KB)
 */

SEARCH_DIR(.)
OUTPUT_ARCH(riscv)
ENTRY(_start)

MEMORY
{
    prog (rwxa)  : ORIGIN = 0x00000000, LENGTH = 0x8000  /* 32KB max - relative addressing */
}

/* Stack configuration - SHARED with CV32 in L1 memory (0x10000-0x20000, 64KB) */
_min_stack   = 0x1000;    /* 4KB minimum stack space */
_stack_start = 0x00020000; /* Top of shared stack in L1 (grows downward) - ABSOLUTE address */

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

    /* Provide stack symbols for runtime initialization */
    /* Stack is in L1 memory (0x00018000-0x00020000), not allocated here */
    /* These symbols are used by crt0.S: la sp, _stack_start */
    PROVIDE(_stack = _stack_start);
    PROVIDE(__stack_top = _stack_start);

    /* Discard debug sections */
    /DISCARD/ : {
        *(.comment)
        *(.note.*)
    }
}
