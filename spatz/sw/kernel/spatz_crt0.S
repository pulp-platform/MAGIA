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
 * Authors: Luca Balboni <luca.balboni10@studio.unibo.it>
 *
 * Spatz Runtime
 * Entry: Bootrom should jumps here
 *
 */

#define EXCHANGE_REG_ADDR 0x00001704
#define START_ADDR        0x00001708
#define DONE_ADDR         0x0000170C
#define MSTATUS_VS        0x200        // Vector Status [9:8] = 01
#define MSTATUS_MIE       0x8          // Machine Interrupt Enable
#define MIE_MEIE          0x800        // External interrupt enable

.section .text.start, "ax"
.global _start

_start:
    /* Init stack pointer */
    li      sp, 0x0001FFFC

    /* Clear ALL integer registers */
    mv x1,  x0
    // x2 = sp just initialized
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

    /* Enable vector extension (VS=Initial for Spatz) */
    li      t0, MSTATUS_VS
    csrs    mstatus, t0

    /* Clear BSS section */
    la      a0, __bss_start
    la      a1, __bss_end
1:  bgeu    a0, a1, 2f
    sw      zero, 0(a0)
    addi    a0, a0, 4
    j       1b
2:
    /* Setup trap handler for interrupt */
    la      t0, _trap_handler
    csrw    mtvec, t0
    
    /* Enable external interrupts (MEIE) */
    li      t0, MIE_MEIE
    csrs    mie, t0
    
    /* Enable global interrupts (MIE bit in mstatus) */
    li      t0, MSTATUS_MIE
    csrs    mstatus, t0
    
    /* Fall through to dispatcher loop */

dispatcher_loop:
    /* Wait for interrupt from CV32 */
    wfi
    
    /* After wakeup from interrupt, task has been executed */
    /* Loop back */
    j       dispatcher_loop

/* Trap handler - distinguishes interrupts from exceptions */
_trap_handler:
    csrr    t0, mcause
    bltz    t0, _handle_interrupt   // mcause[31]=1 → interrupt
    
    /* EXCEPTION: Write error code to EXCHANGE_REG, signal DONE, halt */
_handle_exception:
    csrr    t1, mcause      // Read full mcause
    andi    t1, t1, 0xFF    // Extract exception code [7:0]
    ori     t1, t1, 0x100   // Set bit 8 to distinguish from task errors
    li      t0, EXCHANGE_REG_ADDR
    sw      t1, 0(t0)
    
    li      t0, DONE_ADDR
    li      t1, 1
    sw      t1, 0(t0)
    
    /* Halt */
1:  wfi
    j       1b

_handle_interrupt:
    /* Check if external interrupt */
    andi    t0, t0, 0x7FF
    li      t1, 11
    bne     t0, t1, _trap_ret
    
    /* Read task address from EXCHANGE_REG and save it in t1 */
    li      t0, EXCHANGE_REG_ADDR
    lw      t1, 0(t0)
    beqz    t1, _trap_ret
    
    /* Clear START */
    li      t0, START_ADDR
    sw      zero, 0(t0)
    
    /* Jump to saved task address */
    jalr    ra, 0(t1)
    
    /* Task completed - write exit code 0 (success, no exceptions) */
    li      t0, EXCHANGE_REG_ADDR
    sw      zero, 0(t0)
    
    /* Signal done */
    li      t0, DONE_ADDR
    li      t1, 1
    sw      t1, 0(t0)

_trap_ret:
    mret
