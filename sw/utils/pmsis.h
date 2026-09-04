/*
 * Copyright (C) 2026 Fondazione Chips-IT
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
 * MAGIA's "pmsis.h" -- NOT the real PMSIS. PLAY's cluster-side kernel
 * sources (PLAY/source/<kernel>/arch, the "_pulp_open.c" files) #include
 * "pmsis.h" expecting
 * pulp-sdk's PMSIS API. Rather than vendor that whole runtime (device
 * open/close, OS kickoff, DMA, ...), this shim supplies just the handful of
 * symbols those kernel sources actually call -- pi_core_id(),
 * pi_cl_team_barrier(), pi_cl_team_critical_enter()/exit(),
 * pmsis_l1_malloc()/pmsis_l1_malloc_free() -- backed by cluster_utils.h's
 * native, bare-metal reimplementation (ported from pulp-sdk's
 * pos/implem/pe.h, ARCHI/HAL-free) plus a small bump allocator below.
 * Anything from real PMSIS beyond that set (pi_cluster_open, pi_evt_*,
 * DMA, ...) is deliberately absent: a PLAY kernel that needs it will fail
 * to compile here, which is the point -- silent stubs would be worse than
 * a clear "not implemented".
 */

#ifndef MAGIA_PMSIS_H
#define MAGIA_PMSIS_H

#include <stdint.h>

#include "cluster_utils.h"

/* PLAY's PI_L2/PI_L1-tagged data expects real section-placement attributes,
 * exactly like pulp-sdk's own (pos/data/data.h:62 -- PI_CL_L1 is
 * __attribute__((section(".data_l1"))), which its linker script maps into
 * the cluster TCDM).
 *
 * PI_L1 used to expand to nothing here, which was a real (and expensive)
 * bug: the cluster task binary is linked PIC at ORIGIN=0 and relocated into
 * the *instruction RAM* at 0xCC00_0000, so an untagged PI_L1 array landed in
 * that blob's .bss at 0xCC00_1Fxx. That address is outside the data demux's
 * L1 window (magia_cluster_wrap.sv: demux[TCDM_IDX] covers only
 * tile_l1_start..end), so every access to it fell through to the default
 * slave -- the OBI->AXI path to instruction RAM. Measured on
 * linalg_cholesky_decomp: accesses to dst[]/src[] (in L1) cost 1.05 cycles,
 * accesses to local_sum1[]/local_sum2[] (in the blob's .bss) cost 50-125
 * cycles each, and 8.4% of instructions burned 71% of all cycles.
 *
 * .l1data is placed at an absolute address inside the TCDM by
 * pulp_program.ld; pulp_crt0.S copies its initial image there at boot and
 * skips GOT relocation for the (absolute) pointers into it. */
#define PI_L1 __attribute__((section(".l1data")))
#define PI_L2

/* pmsis_l1_malloc()/pmsis_l1_malloc_free() -- a handful of PLAY cluster
 * kernels (linalg_lu_solve, linalg_svd) allocate a small scratch buffer
 * this way, always from core 0 only, always freed (same size) before the
 * next call, never nested (verified against every current caller). A
 * plain LIFO bump allocator over a fixed arena is exactly correct for
 * that pattern and needs no locking: only core 0 ever touches it, and
 * every caller pairs its malloc with a free before another one happens.
 * A real PMSIS pmsis_l1_malloc's failure mode is returning NULL; this one
 * matches that instead of asserting, in case a future caller doesn't fit
 * the pattern above.
 *
 * The arena is a FIXED ABSOLUTE ADDRESS in the cluster TCDM, not a C
 * object. That is deliberate, and it is the only formulation that works
 * here:
 *   - a plain `static uint8_t arena[]` lands in the blob's .bss, i.e. in
 *     the instruction RAM at 0xCC00_1xxx, outside the data demux's L1
 *     window -- every access then goes OBI->AXI. Measured on
 *     linalg_lu_solve: 275 accesses inside the timed window at ~79 cycles
 *     each = 48% of the kernel's cycles, against ~1.0-1.5 cycles for the
 *     same access in L1. pulp-sdk's pmsis_l1_malloc is pi_cl_l1_malloc(),
 *     which serves from the cluster L1 heap, so that was also a
 *     platform-vs-platform benchmarking artefact, not just slow code.
 *   - tagging it PI_L1 does not work either: it would be an
 *     internal-linkage object in .l1data, which GCC addresses PC-relative
 *     under -fPIC and which therefore resolves to blob_base + VMA. See
 *     sw/utils/play_l1_linkage.h for the full story and the build-time
 *     check that rejects exactly that.
 * A literal address is materialised as a `lui`+`addi` immediate: no GOT
 * entry, no PC-relative form, nothing for the crt0 fixup to get wrong.
 *
 * Tile L1 map used by the benchmark ports (see pulp_program.ld and
 * pulp_crt0.S, which have to agree with this):
 *   0x00020000 .. 0x0002E000   test buffers seeded by the CV32 ctrl core
 *   0x00038000 .. 0x0003A000   .l1data  (PI_L1 kernel globals)
 *   0x0003A000 .. 0x0003C000   this arena
 *   0x0003C000 .. 0x00040000   the 8 cluster core stacks (2 KB each)
 * The largest live allocation across all PLAY kernels is linalg_svd's
 * tmp[dim_N*dim_N] = 32*32*4 = 4 KB, so 8 KB leaves headroom. */
#define PMSIS_L1_MALLOC_ARENA_BASE 0x0003A000u
#define PMSIS_L1_MALLOC_ARENA_SIZE 0x2000u

/* Bump index. Stays an ordinary static (it is read/written twice per
 * malloc and twice per free, by core 0 only -- ~4 slow accesses per kernel
 * invocation, under 0.3% of the shortest timed window), and it cannot go
 * in .l1data anyway for the internal-linkage reason above. */
static uint32_t pmsis_l1_malloc_bump_ = 0;

static inline void *pmsis_l1_malloc(int size) {
    uint32_t sz = ((uint32_t)size + 3u) & ~3u; /* 4-byte align */
    if (pmsis_l1_malloc_bump_ + sz > PMSIS_L1_MALLOC_ARENA_SIZE)
        return (void *)0;
    void *ptr = (void *)(PMSIS_L1_MALLOC_ARENA_BASE + pmsis_l1_malloc_bump_);
    pmsis_l1_malloc_bump_ += sz;
    return ptr;
}

static inline void pmsis_l1_malloc_free(void *chunk, int size) {
    uint32_t sz = ((uint32_t)size + 3u) & ~3u;
    uint32_t p  = (uint32_t)chunk;
    /* Only actually reclaims space for a proper LIFO free (this chunk is
     * the most recent allocation); a non-LIFO free just leaks within the
     * arena, matching the "no current caller does that" note above. */
    if (p && (p + sz == PMSIS_L1_MALLOC_ARENA_BASE + pmsis_l1_malloc_bump_))
        pmsis_l1_malloc_bump_ -= sz;
}

/* sqrtf() -- a couple of PLAY cluster kernels (linalg_cholesky_decomp,
 * linalg_svd_jacobi) call it. -nostdlib means no libm; the toolchain's
 * multilib match for our XPULP march also has no hardware-FP libm variant
 * (falls back to software sqrtf needing newlib's __errno/reentrancy this
 * bare-metal target doesn't have -- a deeper hole than this shim's scope).
 * The core has a real fsqrt.s in hardware (F ops via integer registers
 * under zfinx), so this just issues it directly instead: correct, and
 * actual hardware latency rather than a software fallback. */
/* Not `static`: some PLAY kernel sources pull in the toolchain's own
 * <math.h> too (for fabs()/etc.), which declares `extern float
 * sqrtf(float);` -- a `static` definition here would conflict with that
 * non-static declaration. Plain `inline` still lets it fold away like the
 * rest of this header when unused. */
inline float sqrtf(float x) {
    float result;
    asm volatile("fsqrt.s %0, %1" : "=r"(result) : "r"(x));
    return result;
}

/* pmsis_exit() -- called by a couple of PLAY cluster kernels
 * (linalg_lu_decomp, linalg_svd_jacobi) only on a genuine algorithm
 * precondition failure (singular matrix, problem too small for the core
 * count) -- not expected to actually be reached by any of MAGIA's ported
 * benchmark test data. A PULP core can't cleanly "exit" mid-pi_cl_team_fork
 * the way a hosted PMSIS environment would; spin so a real hit is visible
 * as a hang instead of silently corrupting whatever came next. */
static inline void pmsis_exit(int status) {
    (void)status;
    while (1) {}
}

#endif /* MAGIA_PMSIS_H */
