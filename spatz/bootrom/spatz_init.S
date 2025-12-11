// Copyright 2024 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51
//
// Spatz Core Complex Boot ROM for MAGIA Tile
// Based on spatz_cluster bootrom.S
//
// Boot sequence:
// 1. Clear ALL integer registers (x1-x31, including sp)
// 2. Enable vector extension (VS=Initial)
// 3. Setup trap handler
// 4. Enable external interrupt (MEIE)
// 5. WFI - wait for CV32 START interrupt
// 6. Trap handler: verify MEIP, load FUNC_PTR, jump

#define CLK_EN_ADDR       0x00001700  // OBI slave ctrl CLK_EN register
#define FUNC_PTR_ADDR     0x00001704  // OBI slave ctrl FUNC_PTR register
#define START_ADDR        0x00001708  // OBI slave ctrl START register
#define MSTATUS_VS        0x200        // Vector Status [9:8] = 01 (Initial)
#define MSTATUS_MIE       0x8          // Machine Interrupt Enable
#define MIE_MEIE          0x800        // External interrupt enable
#define MIP_MEIP          0x800        // External interrupt pending

  .section .text.bootrom
  .global _start
  .option norvc

_start:
  // Clear ALL integer registers (like spatz_cluster bootrom)
  mv x1,  x0
  mv x2,  x0   // Clear sp too
  mv x3,  x0
  mv x4,  x0
  mv x5,  x0
  mv x6,  x0
  mv x7,  x0
  mv x8,  x0
  mv x9,  x0
  mv x10, x0
  mv x11, x0
  mv x12, x0
  mv x13, x0
  mv x14, x0
  mv x15, x0
  mv x16, x0
  mv x17, x0
  mv x18, x0
  mv x19, x0
  mv x20, x0
  mv x21, x0
  mv x22, x0
  mv x23, x0
  mv x24, x0
  mv x25, x0
  mv x26, x0
  mv x27, x0
  mv x28, x0
  mv x29, x0
  mv x30, x0
  mv x31, x0

  // Enable vector extension (VS=Initial for Spatz)
  li      t0, MSTATUS_VS
  csrs    mstatus, t0
  
  // Setup trap handler
  la      t0, _trap_handler
  csrw    mtvec, t0
  
  // Enable machine external interrupt (MEIE)
  li      t0, MIE_MEIE
  csrs    mie, t0
  
  // Enable global interrupts (MIE bit in mstatus)
  li      t0, MSTATUS_MIE
  csrs    mstatus, t0
  
  // Wait for START interrupt from CV32
  wfi
  
  // Loop back if spurious wakeup
  j       _start

// Trap handler - executed when external interrupt arrives
_trap_handler:
  // Verify this is MEIP (external interrupt)
  csrr    t0, mip
  li      t1, MIP_MEIP
  and     t0, t0, t1
  beqz    t0, _start        // If not MEIP, go back to WFI
  
  // Disable hardware interrupt: write START=0 to OBI slave ctrl
  li      t0, START_ADDR
  sw      x0, 0(t0)         // Write 0 to START register (disable interrupt)
  
  // Disable external interrupts in CSR (clear MEIE bit in mie)
  li      t0, MIE_MEIE
  csrc    mie, t0           // Clear MEIE bit to prevent re-entry
  
  // Disable global interrupts (clear MIE bit in mstatus)
  li      t0, MSTATUS_MIE
  csrc    mstatus, t0       // Clear MIE bit
  
  // Read function pointer from OBI slave ctrl register
  li      t0, FUNC_PTR_ADDR
  lw      t1, 0(t0)
  
  // Jump to user code
  jr      t1
