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
 * PULP cluster CRT0 for embedded binary in CV32 instrram (magia_v3).
 *
 * Bare-metal dynamic dispatch programming model.
 *
 * Boot sequence per hart:
 *   1.  CV32 writes _pulp_binary_start to PULP_BINARY (0x1744).
 *   2.  CV32 writes 1 to PULP_CLK_EN (0x1740) -> fetch_enable goes high to
 *       all cluster cores, which reset to _pulp_binary_start and execute
 *       _start.
 *   3.  Each hart computes its local ID, sets up its 2 KB stack slice and
 *       clears BSS (all-harts race, benign zero-store).
 *   4.  Install trap_handler in mtvec (direct mode, mtvec[1:0] = 00).
 *   5.  Enable mstatus.MIE and mie.MEIE (bit 11).
 *   6.  Write 1 to PULP_READY (0x175C) so CV32's pulp_init() can advance.
 *   7.  Enter dispatcher_loop: WFI; on MEI, jump to trap_handler.
 *
 * trap_handler (per dispatch):
 *   - Read PULP_TASKBIN (0x1750) -> task function pointer.
 *   - Read PULP_DATA    (0x1754) -> first argument (a0).
 *   - Write 0 to PULP_START (0x1758) to ACK *before* calling the task; this
 *     is what unblocks CV32's pulp_run_task() poll.
 *   - jalr the task function.
 *   - Write 1 to PULP_DONE (0x174C) so ClusterRegs counts the completion;
 *     after NB_CORES_TO_WAIT writes it fires PULP_DONE -> CV32 EU bit 12.
 *   - mret back into the dispatcher_loop (WFI).
 *
 * NOTE on alignment: CV32E40P's mtvec has mtvec[7:2] hardwired to 0, so the
 * trap base is always 256-byte aligned regardless of what we write. We must
 * therefore align trap_handler to 256 bytes; otherwise the trap entry would
 * jump to a lower address inside _start and execute garbage.
 *
 * Stack layout (absolute tile addresses, grows downward):
 *   Slot 0 (CV32 main): [0x1B800, 0x1C000)  — reserved by sw/kernel/crt0.S
 *   PULP STACK_TOP = 0x1B800
 *   PULP core 0: [0x1B000, 0x1B800)  (2 KB)
 *   ...
 *   PULP core 7: [0x14000, 0x14800)  (2 KB)
 *
 * NOTE: stack and PULP_* MMIO addresses are loaded with 'li' (not 'la')
 * because the binary is position-independent (ORIGIN=0x0) and 'la' would
 * produce a PC-relative reference that breaks when loaded at the instrram
 * offset.
 */

#ifndef PULP_CORE_COUNT
#define PULP_CORE_COUNT  8
#endif

#define PULP_DONE_ADDR     0x0000174C   /* PULP_CTRL_BASE + 0x0C */
#define PULP_TASKBIN_ADDR  0x00001750   /* PULP_CTRL_BASE + 0x10 */
#define PULP_DATA_ADDR     0x00001754   /* PULP_CTRL_BASE + 0x14 */
#define PULP_START_ADDR    0x00001758   /* PULP_CTRL_BASE + 0x18 */
#define PULP_READY_ADDR    0x0000175C   /* PULP_CTRL_BASE + 0x1C */

/* PULP STACK_TOP sits 2 KB below the tile-wide top (0x1C000) so the slot
 * at [0x1B800, 0x1C000) stays reserved for the CV32 main core (slot 0). */
#define STACK_TOP        0x0001B800
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

    /* Clear BSS — all harts write 0, benign race.
     *
     * NOTE: __bss_start / __bss_end are PIC symbols (linker script has
     * ORIGIN=0), so their resolved values are small (a few hundred bytes).
     * Without 'norelax' the linker collapses 'la' (auipc+addi) into 'li'
     * because the absolute value fits in a 12-bit immediate — that would
     * make the loop write zeros to tile-local MMIO (iDMA CTRL region at
     * 0x200-0x5FF), hanging the bus. Force PC-relative addressing here. */
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
    /* Install trap_handler in mtvec, direct mode (mtvec[1:0] = 00).
     * CV32E40P hardwires mtvec[7:2]=0 (only mtvec[31:8] and mtvec[0] are
     * writable), so the trap base address is rounded down to a 256-byte
     * boundary. trap_handler must therefore be 256-byte aligned. */
    .option push
    .option norelax
    la      t0, trap_handler
    .option pop
    csrw    mtvec, t0

    /* Enable MEIE (bit 11 of mie) */
    li      t0, 0x800
    csrrs   zero, mie, t0
    /* Enable MIE (bit 3 of mstatus) */
    li      t0, 0x8
    csrrs   zero, mstatus, t0

    /* Signal "core armed": write 1 to PULP_READY. CV32's pulp_init() polls
     * this until ClusterRegs has counted N_CLUSTER_CORES writes. */
    li      t0, PULP_READY_ADDR
    li      t1, 1
    sw      t1, 0(t0)

dispatcher_loop:
    wfi
    j       dispatcher_loop

/*--------------------------------------------------------------------------
 * Machine External Interrupt trap handler (target of the MEI vector slot).
 *
 * The dispatcher loop only executes WFI + jump, so no caller state needs
 * preserving — we may freely clobber t0/t1/a0/ra inside the handler.
 *
 * NOTE on mepc semantics: when MEI is taken from WFI, mepc points to the
 * instruction *after* the WFI (the back-jump). mret therefore returns to
 * that jump, which loops us back to WFI. Equivalent to "wfi again".
 *--------------------------------------------------------------------------*/
.balign 256
.global trap_handler
trap_handler:
    /* a0 = *PULP_DATA  (first argument to task) */
    li      t0, PULP_DATA_ADDR
    lw      a0, 0(t0)

    /* t1 = *PULP_TASKBIN (task function pointer) */
    li      t0, PULP_TASKBIN_ADDR
    lw      t1, 0(t0)

    /* ACK: write 0 to PULP_START before invoking the task. This unblocks
     * CV32's pulp_run_task() poll once all selected cores have written. */
    li      t0, PULP_START_ADDR
    sw      zero, 0(t0)

    /* Call task(data) */
    jalr    ra, 0(t1)

    /* Signal completion: write 1 to PULP_DONE. ClusterRegs accumulates and
     * fires cluster_done when NB_CORES_TO_WAIT writes have arrived. */
    li      t0, PULP_DONE_ADDR
    li      t1, 1
    sw      t1, 0(t0)

    mret

.global _init
.global _fini
_init:
_fini:
    ret
