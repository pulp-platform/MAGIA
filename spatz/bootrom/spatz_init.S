// Copyright 2024 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51
//
// Spatz Core Complex Boot ROM for MAGIA Tile
//
// Boot sequence:
// 1. Clear integer registers (x1-x31)
// 2. Read FUNC_PTR from OBI register 0x1704
// 3. Jump to program at FUNC_PTR address
//
// Note: Using absolute addressing to bypass any address translation

#define FUNC_PTR_ADDR     0x00001704  // OBI slave ctrl FUNC_PTR register

  .section .text.bootrom
  .global _start
  .option norvc

_start:
  // Initialize stack pointer
  lui sp, 0x2          // sp = 0x20000 (top of L1)
  
  // Clear all integer registers (except sp)
  li x1,  0
  li x3,  0
  li x4,  0
  li x5,  0
  li x6,  0
  li x7,  0
  li x8,  0
  li x9,  0
  li x10, 0
  li x11, 0
  li x12, 0
  li x13, 0
  li x14, 0
  li x15, 0
  li x16, 0
  li x17, 0
  li x18, 0
  li x19, 0
  li x20, 0
  li x21, 0
  li x22, 0
  li x23, 0
  li x24, 0
  li x25, 0
  li x26, 0
  li x27, 0
  li x28, 0
  li x29, 0
  li x30, 0
  li x31, 0

  // Load function pointer from FUNC_PTR register (0x1704)
  li      t0, 0x1704       // Load address 0x1704
  lw      t1, 0(t0)        // Read function pointer
  
  // Jump to program
  jr      t1
