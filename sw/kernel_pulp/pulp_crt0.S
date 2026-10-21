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
 * PULP cluster CRT0: core 0 serves the CV32 mailbox (dispatcher_loop), the other cores the EU dispatch FIFO (worker_wait)
 */

#ifndef PULP_CORE_COUNT
#define PULP_CORE_COUNT  8
#endif

#define PULP_DONE_ADDR     0x00001748   /* PULP_CTRL_BASE + 0x08 */
#define PULP_TASKBIN_ADDR  0x0000174C   /* PULP_CTRL_BASE + 0x0C */
#define PULP_DATA_ADDR     0x00001750   /* PULP_CTRL_BASE + 0x10 */
#define PULP_START_ADDR    0x00001754   /* PULP_CTRL_BASE + 0x14 */
#define PULP_READY_ADDR    0x00001758   /* PULP_CTRL_BASE + 0x18 */
#define PULP_RETURN_ADDR   0x0000175C   /* PULP_CTRL_BASE + 0x1C */

#define EU_DEMUX_BASE           0x00001900   /* CLUSTER_EU_DIRECT_BASE */
#define EU_CORE_MASK_OR         (EU_DEMUX_BASE + 0x08)
#define EU_EVENT_WAIT_CLR       (EU_DEMUX_BASE + 0x3C)
#define EU_DISPATCH_FIFO        (EU_DEMUX_BASE + 0x80)
#define EU_BARRIER0_WAIT_CLEAR  (EU_DEMUX_BASE + 0x200 + 0x1C)
#define EU_DISPATCH_EVT_MASK        (1 << 13)
#define EU_MASK_BAR_MUTEX_DISPATCH  ((1 << 16) | (1 << 17) | (1 << 18))

/* PIC binary: MMIO and stack addresses are absolute, so they are loaded with li, not la */
#define STACK_TOP        0x0001B800   /* 2KB below tile top (0x1C000): reserves CV32's slot */
#define LOG2_SLICE       11           /* log2(2 KB) — each hart gets 2 KB */

.section .text.start, "ax"
.global _start
_start:
    /* Compute local core ID = mhartid % PULP_CORE_COUNT */
    csrr    a0, mhartid
    li      t0, PULP_CORE_COUNT
    remu    a1, a0, t0

    /* Per-hart stack pointer: sp = STACK_TOP - local_id * 2KB */
    li      x2, STACK_TOP
    slli    t0, a1, LOG2_SLICE
    sub     x2, x2, t0

    /* Clear BSS (benign all-harts race); norelax keeps la PC-relative, relaxed to li it would zero tile MMIO */
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
    /* Install trap_handler in mtvec, direct mode: mtvec[7:2] is hardwired to 0, hence the 256-byte alignment */
    .option push
    .option norelax
    la      t0, trap_handler
    .option pop
    csrw    mtvec, t0

    /* Unmask barrier/mutex/dispatch events for every core */
    li      t0, EU_CORE_MASK_OR
    li      t1, EU_MASK_BAR_MUTEX_DISPATCH
    sw      t1, 0(t0)

    /* Only core 0 takes dispatches from the control core, the others park on the EU dispatch FIFO */
    bnez    a1, worker_start

    /* Unmask the CV32 dispatch event on core 0 */
    li      t0, EU_CORE_MASK_OR
    li      t1, EU_DISPATCH_EVT_MASK
    sw      t1, 0(t0)

#ifdef __riscv_f
    li      t0, 0x2000
    csrrs   zero, mstatus, t0
#endif

    /* Core armed: CV32 polls PULP_READY until every core has written it */
    li      t0, PULP_READY_ADDR
    li      t1, 1
    sw      t1, 0(t0)

    /* GOT fixup, once by core 0: add the runtime base to each entry, linked at ORIGIN=0 */
    .option push
    .option norelax
    la      t3, _start              /* t3 = runtime base (link-time base is 0) */
    la      t4, __got_start__
    la      t5, __got_end__
    .option pop
gotfix_loop:
    bgeu    t4, t5, gotfix_done
    lw      t6, 0(t4)
    add     t6, t6, t3
    sw      t6, 0(t4)
    addi    t4, t4, 4
    j       gotfix_loop
gotfix_done:

/*--------------------------------------------------------------------------
 * Dispatcher loop (core 0): sleep on the dispatch event, run the task, signal DONE
 *--------------------------------------------------------------------------*/
dispatcher_loop:
    li      t0, EU_EVENT_WAIT_CLR
    cv.elw  t1, 0(t0)               /* sleep until the dispatch event arrives */

    /* a0 = *PULP_DATA  (first argument to task) */
    li      t0, PULP_DATA_ADDR
    lw      a0, 0(t0)

    /* t1 = *PULP_TASKBIN (task function pointer) */
    li      t0, PULP_TASKBIN_ADDR
    lw      t1, 0(t0)

    /* ACK before the task runs: unblocks the CV32 dispatch poll */
    li      t0, PULP_START_ADDR
    sw      zero, 0(t0)

    /* Call task(data) */
    jalr    ra, 0(t1)

    /* Exit code (meaningful only if the task returns int) */
    li      t0, PULP_RETURN_ADDR
    sw      a0, 0(t0)

    /* Completion: each write pulses EU bit 12 on the CV32 */
    li      t0, PULP_DONE_ADDR
    li      t1, 1
    sw      t1, 0(t0)

    j       dispatcher_loop

/*--------------------------------------------------------------------------
 * Worker cores (local id != 0)
 *--------------------------------------------------------------------------*/
worker_start:
    /* Signal "core armed" as well, so PULP_READY counts every hart. */
    li      t0, PULP_READY_ADDR
    li      t1, 1
    sw      t1, 0(t0)

worker_wait:
    li      t0, EU_DISPATCH_FIFO
    cv.elw  t1, 0(t0)               /* entry PC (bit 0 = "other entry" flag) */
    cv.elw  a0, 0(t0)               /* argument                              */
    andi    s1, t1, 1               /* s1 = other-entry flag (callee-saved)  */
    jalr    ra, 0(t1)               /* call entry(arg); jalr drops bit 0     */
    bnez    s1, worker_wait          /* other entry: no barrier, straight back */

    /* Fork entry: rendez-vous on the team barrier before parking again */
    li      t0, EU_BARRIER0_WAIT_CLEAR
    cv.elw  x0, 0(t0)
    j       worker_wait

/*--------------------------------------------------------------------------
 * Only exceptions get here: report the tagged mcause in PULP_RETURN, signal DONE and park
 *--------------------------------------------------------------------------*/
.balign 256
.global trap_handler
trap_handler:
    csrr    t0, mcause
    li      t2, 0x80000000          /* poison tag: real mcause never sets bit 31 here */
    or      t0, t0, t2
    li      t1, PULP_RETURN_ADDR
    sw      t0, 0(t1)
    li      t1, PULP_DONE_ADDR
    li      t2, 1
    sw      t2, 0(t1)
trap_halt:
    j       trap_halt

.global _init
.global _fini
_init:
_fini:
    ret
