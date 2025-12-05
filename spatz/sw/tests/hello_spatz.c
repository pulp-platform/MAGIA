/*
 * Copyright (C) 2024 ETH Zurich and University of Bologna
 *
 * Licensed under the Solderpad Hardware License, Version 0.51
 * SPDX-License-Identifier: SHL-0.51
 *
 * Hello World program for Spatz CC in MAGIA Tile
 * 
 * Register map (obi_slave_ctrl_spatz @ 0x1700):
 * - DONE (0x0C): Write to signal completion (creates pulse)
 */

#include <stdint.h>
#include <stddef.h>
#include "magia_tile_utils.h"

// Spatz control registers
#define SPATZ_BASE_ADDR  0x00001700UL
#define SPATZ_DONE       (SPATZ_BASE_ADDR + 0xC)   // Write: Done pulse

// Entry point (must be in .text.start section for linker)
void _start(void) __attribute__((section(".text.start")));

void _start(void) {
    // Print hello message
    printf("\n========================================\n");
    printf("Hello from Spatz_cc!\n");
    printf("========================================\n\n");
    
    // Signal completion by writing DONE=1 (creates pulse)
    printf("Spatz: Writing DONE=1 to signal completion...\n");
    mmio32(SPATZ_DONE) = 1;
    
    printf("Spatz: Going to WFI...\n\n");
    
    // Wait for interrupt (low power mode)
    while (1) {
        asm volatile ("wfi");
    }
}
