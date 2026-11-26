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
 *          Luca Colombo <luca.colombo07@universitadipavia.it>
 *
 * Spatz Runtime - IRQ dispatcher
 *
 * READY = 1: runtime inizializzato
 * MEI (irq 11): una nuova task è disponibile
 * La task viene eseguita nel trap handler.
 *
 * Dopo la task:
 *   RETURN = 0
 *   DONE   = 1
 *   mret   -> return to dispatcher WFI
 */

#ifndef SPATZ_INIT_VRF
#define SPATZ_INIT_VRF 0
#endif

#ifndef SPATZ_VRF_LMUL1
#define SPATZ_VRF_LMUL1 0
#endif

#define READY_ADDR        0x00001704
#define START_ADDR        0x00001708
#define TASKBIN_ADDR      0x0000170C
#define RETURN_ADDR       0x00001714
#define DONE_ADDR         0x00001718

#define MSTATUS_FS_VS_INIT 0x2200      /* FS and VS = Initial: with FS=Off the core offloads scalar FP ops to Spatz */
#define MSTATUS_MIE       0x8
#define MIE_MEIE          0x800


.section .text.start, "ax"
.global _start

_start:

    /* ------------------------------------------------ */
    /* 1. Stack initialization                          */
    /* ------------------------------------------------ */

    li      sp, 0x0001FFF8

    /* Clear integer registers */
    mv x1,  x0
    /* x2 = sp */
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


    /* ------------------------------------------------ */
    /* 2. Enable vector extension                       */
    /* ------------------------------------------------ */

    li      t0, MSTATUS_FS_VS_INIT
    csrs    mstatus, t0

    vsetvli t0, zero, e32, m8, ta, ma

    vmv.v.i v0,  0
    vmv.v.i v8,  0
    vmv.v.i v16, 0
    vmv.v.i v24, 0


    /* ------------------------------------------------ */
    /* 3. Clear BSS                                     */
    /* ------------------------------------------------ */

    la      a0, __bss_start
    la      a1, __bss_end

1:
    bgeu    a0, a1, 2f
    sw      zero, 0(a0)
    addi    a0, a0, 4
    j       1b

2:


    /* ------------------------------------------------ */
    /* 4. Install trap handler                          */
    /* ------------------------------------------------ */

    la      t0, _trap_handler
    csrw    mtvec, t0


    /* ------------------------------------------------ */
    /* 5. Enable external interrupt (MEI = IRQ 11)     */
    /* ------------------------------------------------ */

    li      t0, MIE_MEIE
    csrs    mie, t0


    /* ------------------------------------------------ */
    /* 6. Enable global interrupts                      */
    /* ------------------------------------------------ */

    li      t0, MSTATUS_MIE
    csrs    mstatus, t0


    /* ------------------------------------------------ */
    /* 7. Notify CV32 that Spatz is READY               */
    /* ------------------------------------------------ */

    li      t0, READY_ADDR
    li      t1, 1
    sw      t1, 0(t0)

    fence   iorw, iorw


    /* ------------------------------------------------ */
    /* 8. Main dispatcher                               */
    /* ------------------------------------------------ */

dispatcher_loop:

    wfi
    j       dispatcher_loop


/* ==================================================== */
/* TRAP HANDLER                                         */
/* ==================================================== */

/*
 * CV32E40P-compatible mtvec base alignment: 256 bytes.
 * Direct mode because the two lowest address bits are zero.
 */

/* ==================================================== */
/* TRAP HANDLER                                         */
/* ==================================================== */

/*
 * Aligned to 256 B within the binary; link.ld aligns .spatz_binary to 256 B
 */

.balign 256

_trap_handler:
    csrr    t0, mcause

    li      t1, RETURN_ADDR
    sw      t0, 0(t1)

    bltz    t0, _handle_interrupt

    j       _handle_exception

    
/* ---------------------------------------------------- */
/* Exception handler                                    */
/* ---------------------------------------------------- */

_handle_exception:

    csrr    t1, mcause
    andi    t1, t1, 0xFF
    ori     t1, t1, 0x100

    /* Report exception */
    li      t0, RETURN_ADDR
    sw      t1, 0(t0)

    /* Signal DONE */
    li      t0, DONE_ADDR
    li      t1, 1
    sw      t1, 0(t0)

    fence   iorw, iorw

    /* Halt on exception */
1:
    wfi
    j       1b


/* ---------------------------------------------------- */
/* Interrupt handler                                    */
/* ---------------------------------------------------- */

_handle_interrupt:

    /* Extract interrupt ID */
    andi    t0, t0, 0x7FF

    /* Only handle Machine External Interrupt (11) */
    li      t1, 11
    bne     t0, t1, _trap_ret


    /* ----------------------------------------------- */
    /* Wait until TASKBIN is valid                     */
    /* ----------------------------------------------- */

    li      t0, TASKBIN_ADDR

1:
    lw      t1, 0(t0)
    beqz    t1, 1b


    /* ----------------------------------------------- */
    /* Acknowledge START                               */
    /* ----------------------------------------------- */

    li      t0, START_ADDR
    sw      zero, 0(t0)

    fence   iorw, iorw


    /* ----------------------------------------------- */
    /* Execute task                                     */
    /* ----------------------------------------------- */

    jalr    ra, 0(t1)


    /* ----------------------------------------------- */
    /* Task completed                                  */
    /* ----------------------------------------------- */

    /* RETURN = 0 */
    li      t0, RETURN_ADDR
    sw      zero, 0(t0)

    /* DONE = 1 */
    li      t0, DONE_ADDR
    li      t1, 1
    sw      t1, 0(t0)

    fence   iorw, iorw


/* ---------------------------------------------------- */
/* Return from interrupt                                */
/* ---------------------------------------------------- */

_trap_ret:

    mret