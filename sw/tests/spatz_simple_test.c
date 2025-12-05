/*
 * Copyright (C) 2024 ETH Zurich and University of Bologna
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * SPDX-License-Identifier: SHL-0.51
 *
 * Simple Spatz Test - CV32 triggers Spatz to execute hello program
 * 
 * Flow:
 *   1. CV32 prints "Hello World from CV32"
 *   2. CV32 writes FUNC_PTR with Spatz binary entry point
 *   3. CV32 enables Spatz clock (CLK_EN=1)
 *   4. Spatz bootrom reads FUNC_PTR from OBI register and jumps
 *   5. Spatz program prints "Hello from Spatz_cc"
 *   6. Spatz writes DONE=1 (pulse) to signal completion
 *   7. Spatz goes to WFI
 * 
 * Register Map (obi_slave_ctrl_spatz @ 0x1700):
 *   - CLK_EN (0x00):   Write-only (CV32), enables clock gating
 *   - FUNC_PTR (0x04): Read/Write, function entry point
 *   - START (0x08):    Read/Write, start signal (sticky bit)
 *   - DONE (0x0C):     Write-only (Spatz), completion pulse (auto-clears)
 */

#include "magia_tile_utils.h"

// Include Spatz program header
#include "../../spatz/sw/headers/hello_spatz.h"

// Spatz control registers (obi_slave_ctrl_spatz at 0x1700)
#define SPATZ_BASE_ADDR     0x00001700UL
#define SPATZ_CLK_EN        (SPATZ_BASE_ADDR + 0x0)   // Write: Enable clock
#define SPATZ_FUNC_PTR      (SPATZ_BASE_ADDR + 0x4)   // Read/Write: Entry point
#define SPATZ_START         (SPATZ_BASE_ADDR + 0x8)   // Read/Write: Start signal
#define SPATZ_DONE          (SPATZ_BASE_ADDR + 0xC)   // Write: Done pulse

int main(void) {
    printf("\n========================================\n");
    printf("Hello World from CV32!\n");
    printf("========================================\n\n");
    
    // Get entry point from linker symbols
    uint32_t spatz_entry_point = HELLO_SPATZ_BINARY_START;
    uint32_t spatz_binary_size = HELLO_SPATZ_BINARY_SIZE;
    
    printf("CV32: Spatz program info:\n");
    printf("      Entry point: 0x%08X\n", spatz_entry_point);
    printf("      Size:        %u bytes\n", spatz_binary_size);
    printf("      First word:  0x%08X\n\n", mmio32(spatz_entry_point));
    
    // Step 1: Write FUNC_PTR to OBI register
    printf("CV32: Writing FUNC_PTR (0x1704) = 0x%08X\n", spatz_entry_point);
    mmio32(SPATZ_FUNC_PTR) = spatz_entry_point;
    
    // Step 2: Enable Spatz clock - bootrom starts and reads FUNC_PTR
    printf("CV32: Enabling Spatz clock (CLK_EN=1)...\n");
    mmio32(SPATZ_CLK_EN) = 1;
    
    printf("CV32: Spatz started! Bootrom will read FUNC_PTR and jump.\n");
    printf("CV32: Waiting forever...\n\n");
    
    // Infinite loop - wait forever
    while (1) {
        asm volatile ("wfi");  // Wait for interrupt (power saving)
    }
    
    return 0;
}
