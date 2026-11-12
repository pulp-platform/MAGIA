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
 * Authors: Luca Balboni <luca.balboni10@studio.unibo.it>
 *
 * Spatz CRT0: boot, then serve the CV32 mailbox like core 0 of the PULP cluster (pulp_crt0.S), sleeping in WFI
 */

#define SPATZ_DONE_ADDR     0xA0002208   /* SPATZ_CTRL_BASE + 0x08 */
#define SPATZ_TASKBIN_ADDR  0xA000220C
#define SPATZ_DATA_ADDR     0xA0002210
#define SPATZ_START_ADDR    0xA0002214
#define SPATZ_READY_ADDR    0xA0002218
#define SPATZ_RETURN_ADDR   0xA000221C

#define MSTATUS_FS_VS_INIT  0x2200       /* FS and VS = Initial */
#define MIE_MEIE            0x800        /* START drives the machine external interrupt */
#define RETURN_CRASHED      0x80000000   /* Tags mcause in RETURN: a real exit code never sets it */

/* Top of the Spatz stack, above the CV32 and PULP slots of sw/kernel/link.ld */
#define STACK_TOP           0xA0120000

.section .text.start, "ax"
.global _start
_start:
    /* PIC binary: MMIO and stack addresses are absolute, so they are loaded with li, not la */
    li      sp, STACK_TOP

    /* norelax keeps la PC-relative in this PIC binary */
    .option push
    .option norelax
    la      t0, __bss_start
    la      t1, __bss_end
    .option pop
1:  bgeu    t0, t1, 2f
    sw      zero, 0(t0)
    addi    t0, t0, 4
    j       1b
2:
    /* Direct mode: mtvec[7:2] is hardwired to 0, hence the 256-byte alignment of trap_handler */
    .option push
    .option norelax
    la      t0, trap_handler
    .option pop
    csrw    mtvec, t0

    li      t0, MSTATUS_FS_VS_INIT
    csrs    mstatus, t0

    /* Zero the VRF: LMUL=8 clears eight registers per vmv */
    vsetvli t0, zero, e32, m8, ta, ma
    vmv.v.i v0,  0
    vmv.v.i v8,  0
    vmv.v.i v16, 0
    vmv.v.i v24, 0

    /* WFI wakes on START with mstatus.MIE still 0, so no trap is taken */
    li      t0, MIE_MEIE
    csrs    mie, t0

    /* Armed: the CV32 polls READY */
    li      t0, SPATZ_READY_ADDR
    li      t1, 1
    sw      t1, 0(t0)

/*--------------------------------------------------------------------------
 * Dispatcher loop: sleep until START, run the task, signal DONE
 *--------------------------------------------------------------------------*/
dispatcher_loop:
    wfi
    li      t0, SPATZ_START_ADDR
    lw      t1, 0(t0)
    beqz    t1, dispatcher_loop     /* Woken by the previous ACK still settling */

    /* a0 = *DATA (first argument to the task) */
    li      t0, SPATZ_DATA_ADDR
    lw      a0, 0(t0)

    li      t0, SPATZ_TASKBIN_ADDR
    lw      t1, 0(t0)

    /* ACK before the task runs: unblocks the CV32 dispatch poll and drops the interrupt */
    li      t0, SPATZ_START_ADDR
    sw      zero, 0(t0)

    jalr    ra, 0(t1)

    /* The scalar stores wait in hardware for the task's vector stores to land */
    li      t0, SPATZ_RETURN_ADDR
    sw      a0, 0(t0)

    li      t0, SPATZ_DONE_ADDR
    li      t1, 1
    sw      t1, 0(t0)

    j       dispatcher_loop

/*--------------------------------------------------------------------------
 * Only exceptions get here: report the tagged mcause in RETURN, signal DONE and park
 *--------------------------------------------------------------------------*/
.balign 256
.global trap_handler
trap_handler:
    csrr    t0, mcause
    li      t2, RETURN_CRASHED
    or      t0, t0, t2
    li      t1, SPATZ_RETURN_ADDR
    sw      t0, 0(t1)
    li      t1, SPATZ_DONE_ADDR
    li      t2, 1
    sw      t2, 0(t1)
trap_halt:
    j       trap_halt
