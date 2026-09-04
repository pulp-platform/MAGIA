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
 * Boot sequence:
 *   1.  CV32 writes _pulp_binary_start to PULP_BINARY (0x1744).
 *   2.  CV32 writes 1 to PULP_CLK_EN (0x1740) -> fetch_enable goes high to
 *       all cluster cores, which reset to _pulp_binary_start and execute
 *       _start.
 *   3.  Every hart: compute local ID, set up its 2 KB stack slice, clear
 *       BSS (all-harts race, benign zero-store).
 *   4.  Every hart: install trap_handler in mtvec (direct mode, mtvec[1:0] = 00)
 *   5.  Every hart: unmask barrier/mutex/dispatch (EU_CORE_MASK_OR, bits
 *       16-18) -- needed before either role's first cv.elw below.
 *   6.  Role split (local id 0 vs not):
 *       - dispatcher: also unmask its own dispatch event (bit 13), write
 *         PULP_READY, fix up the GOT (core 0 only, see below), enter
 *         dispatcher_loop.
 *       - workers: write PULP_READY, enter worker_wait.
 *
 * dispatcher_loop (per dispatch, core 0 only):
 *   - cv.elw on EU_CORE_EVENT_WAIT_CLEAR: sleep until the dispatch event
 *     arrives, then clear it.
 *   - Read PULP_TASKBIN (0x1750) -> task function pointer.
 *   - Read PULP_DATA    (0x1754) -> first argument (a0).
 *   - Write 0 to PULP_START (0x1758) to ACK *before* calling the task; this
 *     is what unblocks CV32's pulp_run_task() poll.
 *   - jalr the task function.
 *   - Write 1 to PULP_DONE (0x174C): one write is one completed dispatch and
 *     fires cluster_done -> CV32 EU bit 12.
 *   - back to the cv.elw.
 *
 * NOTE on alignment: CV32E40P's mtvec has mtvec[7:2] hardwired to 0, so the
 * trap base is always 256-byte aligned regardless of what we write. The trap
 * entry point must therefore be 256-byte aligned; otherwise the trap would
 * jump to a lower address inside _start and execute garbage.
 *
 * Stack layout (absolute tile addresses, grows downward):
 *   PULP STACK_TOP = 0x00040000
 *   PULP core 0: [0x3F800, 0x40000)  (2 KB)
 *   ...
 *   PULP core 7: [0x3C000, 0x3C800)  (2 KB)
 *
 * The stacks live INSIDE the cluster TCDM, not in the tile's STACK region
 * at 0x00010000-0x00020000 where they used to sit. That region is outside
 * the cluster data demux's L1 window (magia_cluster_wrap.sv:
 * demux[TCDM_IDX] covers tile_l1_start..end only), so a stack access there
 * fell through to the default slave and took the OBI -> obi_xbar ->
 * obi_atomics -> obi2hci -> HCI path. Measured from the cluster traces,
 * inside the stats window: 19-31 cycles per stack access, against 1.0-1.5
 * cycles for the same access through the direct TCDM port. On the short
 * kernels that was 10-15% of the measured cycles (linalg_gemv 14.9%,
 * linalg_gemv_trans 14.1%, matrix_swap_rows 11.9%, matrix_trans 10.2%) --
 * a pure platform artefact, since pulp-sdk puts the cluster stacks in L1
 * too (pi_cl_l1_malloc() in drivers/cluster/cluster.c:
 * pos_cluster_task_set_stack), which is what the standalone pulp_cluster
 * benchmark run compares against.
 *
 * The CV32 control core keeps its own stack in the STACK region
 * (sw/kernel/crt0.S) -- only the 8 cluster harts move.
 *
 * L1 budget: the benchmark ports' buffers reach at most L1_BASE+0xE000
 * (linalg_svd_jacobi's MAT_SRC), .l1data occupies [0x38000, 0x3A000) and
 * the pmsis_l1_malloc arena [0x3A000, 0x3C000) (sw/utils/pmsis.h), so
 * [0x3C000, 0x40000) is free. Physical L1 is 16 banks x 8192 words x 4 B
 * = 512 KB at 0x00020000 (magia_pkg::N_MEM_BANKS/N_WORDS_BANK).
 *
 * NOTE: stack and PULP_* MMIO addresses are loaded with 'li' (not 'la')
 * because the binary is position-independent (ORIGIN=0x0) and 'la' would
 * produce a PC-relative reference that breaks when loaded at the instrram
 * offset.
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

#define EU_DEMUX_BASE           0x00001800
#define EU_CORE_MASK_OR         (EU_DEMUX_BASE + 0x08)
#define EU_EVENT_WAIT_CLR       (EU_DEMUX_BASE + 0x3C)
#define EU_DISPATCH_FIFO        (EU_DEMUX_BASE + 0x80)
#define EU_BARRIER0_WAIT_CLEAR  (EU_DEMUX_BASE + 0x200 + 0x1C)
#define EU_DISPATCH_EVT_MASK        (1 << 13)
#define EU_MASK_BAR_MUTEX_DISPATCH  ((1 << 16) | (1 << 17) | (1 << 18))

#define STACK_TOP        0x00040000   /* top of the cluster stacks, inside the TCDM */
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

    /* Unmask barrier/mutex/dispatch events for every core */
    li      t0, EU_CORE_MASK_OR
    li      t1, EU_MASK_BAR_MUTEX_DISPATCH
    sw      t1, 0(t0)

    /* Split the two roles: only local id 0 takes dispatches from the control
     * core, every other hart parks on the Event Unit dispatch FIFO. */
    bnez    a1, worker_start

    /* Unmask the dispatch event in core 0's Event Unit slice: the core is woken by an event */
    li      t0, EU_CORE_MASK_OR
    li      t1, EU_DISPATCH_EVT_MASK
    sw      t1, 0(t0)

#ifdef __riscv_f
    li      t0, 0x2000
    csrrs   zero, mstatus, t0
#endif

    /* Signal "core armed": write 1 to PULP_READY. CV32's pulp_init() polls
     * this until ClusterRegs has counted N_CLUSTER_CORES writes. */
    li      t0, PULP_READY_ADDR
    li      t1, 1
    sw      t1, 0(t0)

    /* GOT fixup, core 0 only, once: -fPIC GOT entries are baked as if
     * linked at ORIGIN=0, but we run at _pulp_binary_start instead. Add
     * that runtime base (= 'la _start', link-time address 0) to each slot. */
    .option push
    .option norelax
    la      t3, _start              /* t3 = runtime base (link-time base is 0) */
    la      t4, __got_start__
    la      t5, __got_end__
    .option pop
gotfix_loop:
    bgeu    t4, t5, gotfix_done
    lw      t6, 0(t4)
    /* Only blob-relative entries get the runtime base added. Entries that
     * point at a PI_L1 variable hold an ABSOLUTE TCDM address (the .l1data
     * section has its VMA in L1) and must be left untouched -- adding the
     * base would corrupt them. Test against the exact [__l1data_start,
     * __l1data_end) range: a blanket "large value" test would be wrong,
     * since genuine blob-relative entries can be negative (e.g. 0xffffffff
     * for _start-1). */
    lui     t2, %hi(__l1data_start)
    addi    t2, t2, %lo(__l1data_start)
    bltu    t6, t2, gotfix_reloc        /* below .l1data -> blob-relative   */
    lui     t2, %hi(__l1data_end)
    addi    t2, t2, %lo(__l1data_end)
    bltu    t6, t2, gotfix_skip         /* inside .l1data -> absolute, keep */
gotfix_reloc:
    add     t6, t6, t3
    sw      t6, 0(t4)
gotfix_skip:
    addi    t4, t4, 4
    j       gotfix_loop
gotfix_done:

    /* Copy the .l1data image (PI_L1 variables) from inside the relocated
     * blob to its absolute home in the cluster TCDM. Core 0 only, once,
     * before any dispatch is serviced -- the worker cores can only reach
     * these variables from inside a forked task, which core 0 itself starts
     * later. Source is blob-relative (PC-relative 'la'); destination is an
     * absolute TCDM address (%hi/%lo -- crt0 is built without -fPIC).
     * Uninitialised PI_L1 arrays are zeros in this image, so this also
     * zero-initialises them (they are not covered by the .bss clear). */
    .option push
    .option norelax
    la      t0, __l1data_load           /* src: inside the relocated blob   */
    .option pop
    lui     t1, %hi(__l1data_start)     /* dst: absolute TCDM address       */
    addi    t1, t1, %lo(__l1data_start)
    lui     t2, %hi(__l1data_end)
    addi    t2, t2, %lo(__l1data_end)
l1copy_loop:
    bgeu    t1, t2, l1copy_done
    lw      t6, 0(t0)
    sw      t6, 0(t1)
    addi    t0, t0, 4
    addi    t1, t1, 4
    j       l1copy_loop
l1copy_done:

/*--------------------------------------------------------------------------
 * Dispatcher loop.
 *
 * cv.elw blocks until an unmasked event is in this core 0's event buffer; while
 * blocked the Event Unit gates the core clock. The _CLEAR flavour clears the
 * event on wake-up, so the next cv.elw blocks again.
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

    /* ACK: write 0 to PULP_START before invoking the task. This unblocks
     * CV32's pulp_run_task() poll. */
    li      t0, PULP_START_ADDR
    sw      zero, 0(t0)

    /* Call task(data) */
    jalr    ra, 0(t1)

    /* Exit code: write a0 (task's return value, real only if the task
     * actually returns int) to PULP_RETURN before signaling DONE. */
    li      t0, PULP_RETURN_ADDR
    sw      a0, 0(t0)

    /* Signal completion: write 1 to PULP_DONE. Each write pulses cluster_done
     * (EU bit 12 on the CV32 side). */
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

    /* fork entry (bit 0 was clear, the default for any real function pointer):
     * rendez-vous on the team barrier before parking again */
    li      t0, EU_BARRIER0_WAIT_CLEAR
    cv.elw  x0, 0(t0)
    j       worker_wait

/*--------------------------------------------------------------------------
 * Any trap here is a bug (no interrupt source is enabled, only exceptions
 * reach this). Report mcause via PULP_RETURN and signal DONE (same idea as
 * Spatz's own exception path) instead of hanging silently, then park.
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
