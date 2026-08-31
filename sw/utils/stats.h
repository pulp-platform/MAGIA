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
 * MAGIA port of PLAY's test/common/stats.h
 * (https://github.com/FondazioneChipsIT/PLAY), so that MAGIA PULP-cluster
 * kernels can be timed with the same HOTTING/REPEAT methodology PLAY uses
 * for its own PULP-Open target.
 *
 * This header deliberately reports ONLY the metrics that are genuinely
 * 1:1 with pulp_cluster's own measurement, verified by reading pulp-sdk's
 * CV32E40P HAL directly (archi/riscv/pcer_cv32e40p.h + hal/riscv/riscv_v5.h,
 * pulp_cluster-ohw-cv32/regression_tests/play_bench/pulp-sdk/):
 *
 *   - pulp-sdk's cpu_perf_get()/cpu_perf_set() read/write per-core
 *     mhpmcounterN CSRs, exactly like this file does below.
 *   - pcer_cv32e40p.h's event-id table is itself derived from the same
 *     hpm_events[] in cv32e40p_cs_registers.sv used here -- same bit
 *     assignment: 2=ld_stall, 3=jr_stall(jmp_stall), 4=imiss, 5=ld, 6=st,
 *     7=jump, 8=branch, 9=btaken(taken_branch), 10=rvc. instret (minstret,
 *     CSR 0xB02) is written directly by pulp-sdk's cpu_perf_setall() too.
 *   Both sides end up reading the identical physical per-core CSR for each
 *   of these -- a clean, direct comparison.
 *
 * cycles is included too: pulp_cluster's own PI_PERF_CYCLES is NOT used for
 * the comparison (pi_perf_cl_read() special-cases that one event to read
 * timer_count_get(timer_base_cl(0,0,0)) -- a single HW timer PERIPHERAL
 * shared by all 8 cores, not a per-core CSR). Instead, PLAY's own
 * test/common/stats.h (pulp_cluster-ohw-cv32) now reads mcycle directly via
 * CSR, bypassing pi_perf for this one event exactly like it already does
 * for instret -- see perf_csr_cycle() there. Both sides end up reading a
 * real per-core cycle counter.
 *
 * Left out on purpose, NOT 1:1:
 *   - PI_PERF_ACTIVE_CYCLES: not a distinct hpm_events[] bit on CV32E40P at
 *     all (neither platform can produce a real one without approximating).
 *   - PI_PERF_LD_EXT/ST_EXT/*_CYC/TCDM_CONT: come from a TCDM-contention
 *     counter outside the core (cluster interconnect), which MAGIA doesn't
 *     expose as a counter.
 *   - `elw_stall` (hpm_events[11], COREV_CLUSTER-only "extra cycles from
 *     cv.elw"): a real per-core CV32E40P counter, but PLAY doesn't
 *     configure/read this event at all, so there's no pulp_cluster number
 *     to compare it against either.
 *
 * The cluster cores that run PLAY kernels are built with NUM_MHPMCOUNTERS=29
 * (magia_cluster_wrap.sv i_cv32e40p_core), enough to read all 9 events below
 * simultaneously, no multiplexing across runs needed.
 *
 * Usage (see sw/tests/cluster_tests/vector_add/pulp_task/vector_add_task.c):
 *
 *   static void my_fork_entry(void *arg) {
 *       INIT_STATS();
 *       START_LOOP_STATS();
 *       START_STATS();
 *       kernel(...);
 *       STOP_STATS();
 *       END_LOOP_STATS();
 *   }
 *   pi_cl_team_fork(PULP_CORE_COUNT, my_fork_entry, params);
 *
 * Build with `stats=1` (see sw/kernel_pulp/Makefile) to define STATS;
 * without it every macro below is a no-op, exactly like PLAY's own.
 */

#ifndef STATS_H_
#define STATS_H_

#ifdef STATS

/* The mhpmevent/mhpmcounter CSR numbers and hpm_events[] bit assignment
 * below are CV32E40P-specific (cv32e40p_cs_registers.sv). This is safe in
 * practice: stats.h is only ever compiled into pulp_task/*.c, which
 * sw/kernel_pulp/Makefile always builds with core=CV32E40P regardless of
 * the top-level `core=` (the ctrl core's own choice) -- MAGIA's cluster
 * cores are always CV32E40P (see magia_cluster_wrap.sv, "Cluster cores
 * (always CV32E40P)"). Fail loudly instead of silently misreading CSRs if
 * that assumption is ever violated (e.g. this header reused on a
 * CV32E40X-built ctrl core, which has NUM_MHPMCOUNTERS=1 and a different
 * hpm_events[] map).
 */
#if !defined(CV32E40P) || defined(CV32E40X)
#error "stats.h's mhpmcounter reads are CV32E40P-specific; build with core=CV32E40P"
#endif

#include "magia_tile_utils.h"
#include "cluster_utils.h"

/* Same constants as PLAY's TARGET_IS_PULP_OPEN path (test/common/stats.h):
 * 2 warm-up iterations (icache/branch-predictor settle) discarded, then 5
 * measured iterations averaged. */
#define HOTTING (3)
#define REPEAT  (2)

/* cv32e40p_cs_registers.sv hpm_events[] bit -> mhpmcounter/mhpmevent index
 * assignment. Bit 1 (minstret) is covered by the standard `instret` CSR
 * already (get_instret()), so the configurable counters start at
 * mhpmcounter3 for bit 2 onward. */
#define EVT_LD_STALL  (1u << 2)
#define EVT_JR_STALL  (1u << 3)
#define EVT_IMISS     (1u << 4)
#define EVT_LD        (1u << 5)
#define EVT_ST        (1u << 6)
#define EVT_JUMP      (1u << 7)
#define EVT_BRANCH    (1u << 8)
#define EVT_BTAKEN    (1u << 9)
#define EVT_RVC       (1u << 10)

/* Raw single-instruction mcycle/minstret reads for stats.h specifically --
 * NOT magia_tile_utils.h's get_cycle()/get_instret(), which also read the
 * 32-bit-high half (cycleh/instreth) and return 0 on overflow: that guard
 * costs ~5 instructions per call instead of 1, and is pointless here since
 * one HOTTING+REPEAT iteration is a few thousand cycles, nowhere near a
 * 32-bit wraparound. Matches PLAY's perf_csr_cycle()/perf_csr_instret()
 * (test/common/stats.h) exactly -- same single `csrr`, no guard -- so the
 * two sides' measured windows contain the same instruction count for this
 * part instead of MAGIA paying ~16 extra instructions/iteration for a check
 * that never fires. */
static inline unsigned long perf_csr_cycle(void) {
    unsigned long v;
    asm volatile("csrr %0, 0xB00" : "=r"(v));
    return v;
}

static inline unsigned long perf_csr_instret(void) {
    unsigned long v;
    asm volatile("csrr %0, 0xB02" : "=r"(v));
    return v;
}

/* mcountinhibit (CSR 0x320) bit N inhibits mhpmcounterN for N=3..31 (same
 * indexing as the counter number). Bits 0 (CY, cycle) and 2 (IR, instret)
 * are already handled by magia_tile_utils.h's ccount_en()/ccount_dis().
 * Mask covers mhpmcounter3..mhpmcounter11 (bits 3..11). This needs the
 * register-operand form (csrrc/csrrs), not the 5-bit-immediate form
 * (csrrci/csrrsi) that ccount_en/dis use -- the mask doesn't fit in 5 bits. */
#define MHPMCTR_INHIBIT_MASK (0xFF8u)

static inline void hpmcount_ext_en(void) {
    unsigned long mask = MHPMCTR_INHIBIT_MASK;
    asm volatile("csrrc zero, 0x320, %0" :: "r"(mask));
}

static inline void hpmcount_ext_dis(void) {
    unsigned long mask = MHPMCTR_INHIBIT_MASK;
    asm volatile("csrrs zero, 0x320, %0" :: "r"(mask));
}

/* mhpmeventN (CSR 0x320+N) selects which hpm_events[] bit mhpmcounterN
 * tallies; mhpmcounterN (CSR 0xB00+N) is the counter itself. CSR addresses
 * must be compile-time immediates, hence one function pair per counter
 * instead of a runtime-indexed helper. */
#define DECL_MHPMCTR(NAME, EVENT_CSR, COUNTER_CSR, EVENT_MASK)                 \
    static inline void hpmevent_set_##NAME(void) {                             \
        asm volatile("csrw " #EVENT_CSR ", %0" :: "r"((unsigned long)(EVENT_MASK)));\
    }                                                                          \
    static inline unsigned long hpmcounter_get_##NAME(void) {                       \
        unsigned long v;                                                            \
        asm volatile("csrr %0, " #COUNTER_CSR : "=r"(v));                      \
        return v;                                                              \
    }                                                                          \
    static inline void hpmcounter_reset_##NAME(void) {                        \
        asm volatile("csrw " #COUNTER_CSR ", zero");                          \
    }

DECL_MHPMCTR(ld_stall, 0x323, 0xB03, EVT_LD_STALL)
DECL_MHPMCTR(jr_stall, 0x324, 0xB04, EVT_JR_STALL)
DECL_MHPMCTR(imiss,    0x325, 0xB05, EVT_IMISS)
DECL_MHPMCTR(ld,       0x326, 0xB06, EVT_LD)
DECL_MHPMCTR(st,       0x327, 0xB07, EVT_ST)
DECL_MHPMCTR(jump,     0x328, 0xB08, EVT_JUMP)
DECL_MHPMCTR(branch,   0x329, 0xB09, EVT_BRANCH)
DECL_MHPMCTR(btaken,   0x32A, 0xB0A, EVT_BTAKEN)
DECL_MHPMCTR(rvc,      0x32B, 0xB0B, EVT_RVC)

#undef DECL_MHPMCTR

static inline void hpmevent_configure_all(void) {
    hpmevent_set_ld_stall();
    hpmevent_set_jr_stall();
    hpmevent_set_imiss();
    hpmevent_set_ld();
    hpmevent_set_st();
    hpmevent_set_jump();
    hpmevent_set_branch();
    hpmevent_set_btaken();
    hpmevent_set_rvc();
}

/* Reset all 9 counters to 0, mirroring pulp-sdk's pi_perf_reset(): STOP_STATS
 * can then accumulate a raw read directly instead of reading-and-subtracting
 * a saved start value. Fewer instructions in the measured window (no stack
 * reload of 9 saved values, no subtraction) -- see
 * sw/tests/cluster_tests/benchmarks/PIC_CALL_OVERHEAD.md Sec. 11, which
 * traced the previous read-save-subtract scheme to ~25 extra (mostly
 * compressed) instructions per iteration versus pulp-sdk's reset-then-read. */
static inline void hpmcounter_reset_all(void) {
    hpmcounter_reset_ld_stall();
    hpmcounter_reset_jr_stall();
    hpmcounter_reset_imiss();
    hpmcounter_reset_ld();
    hpmcounter_reset_st();
    hpmcounter_reset_jump();
    hpmcounter_reset_branch();
    hpmcounter_reset_btaken();
    hpmcounter_reset_rvc();
}

static inline void print_stats(unsigned long _cycles, unsigned long _instr,
                                unsigned long _ldstall, unsigned long _jrstall, unsigned long _imiss,
                                unsigned long _ld, unsigned long _st, unsigned long _jump,
                                unsigned long _branch, unsigned long _btaken, unsigned long _rvc) {
    unsigned long id = pi_core_id();
    unsigned long cycles_avg  = _cycles  / REPEAT;
    unsigned long instr_avg   = _instr   / REPEAT;
    unsigned long ldstall_avg = _ldstall / REPEAT;
    unsigned long jrstall_avg = _jrstall / REPEAT;
    unsigned long imiss_avg   = _imiss   / REPEAT;
    unsigned long ld_avg      = _ld      / REPEAT;
    unsigned long st_avg      = _st      / REPEAT;
    unsigned long jump_avg    = _jump    / REPEAT;
    unsigned long branch_avg  = _branch  / REPEAT;
    unsigned long btaken_avg  = _btaken  / REPEAT;
    unsigned long rvc_avg     = _rvc     / REPEAT;

    if (id == 0)
        printf("INFO | Printing statistics:\n");

    pi_cl_team_barrier();

    for (unsigned long i = 0; i < PULP_CORE_COUNT; i++) {
        if (id == i) {
            printf("[%u] cycles:\t%u\n",       (unsigned)id, (unsigned)cycles_avg);
            printf("[%u] instr execd:\t%u\n", (unsigned)id, (unsigned)instr_avg);
            printf("[%u] ld stall:\t%u\n",    (unsigned)id, (unsigned)ldstall_avg);
            printf("[%u] jr stall:\t%u\n",    (unsigned)id, (unsigned)jrstall_avg);
            printf("[%u] imiss:\t%u\n",       (unsigned)id, (unsigned)imiss_avg);
            printf("[%u] ld:\t%u\n",          (unsigned)id, (unsigned)ld_avg);
            printf("[%u] st:\t%u\n",          (unsigned)id, (unsigned)st_avg);
            printf("[%u] jump:\t%u\n",        (unsigned)id, (unsigned)jump_avg);
            printf("[%u] branch:\t%u\n",      (unsigned)id, (unsigned)branch_avg);
            printf("[%u] btaken:\t%u\n",      (unsigned)id, (unsigned)btaken_avg);
            printf("[%u] rvc:\t%u\n",         (unsigned)id, (unsigned)rvc_avg);
        }
        pi_cl_team_barrier();
    }
}

#define INIT_STATS()                     \
    unsigned long _start_cycles  = 0;         \
    unsigned long _end_cycles    = 0;         \
    unsigned long _cycles        = 0;         \
    unsigned long _start_instr   = 0;         \
    unsigned long _end_instr     = 0;         \
    unsigned long _instr         = 0;         \
    unsigned long _ldstall       = 0;         \
    unsigned long _jrstall       = 0;         \
    unsigned long _imiss         = 0;         \
    unsigned long _ld            = 0;         \
    unsigned long _st            = 0;         \
    unsigned long _jump          = 0;         \
    unsigned long _branch        = 0;         \
    unsigned long _btaken        = 0;         \
    unsigned long _rvc           = 0;         \

#define START_LOOP_STATS()                              \
    for (int _k = 0; _k < (HOTTING + REPEAT); _k++) {    \
        hpmevent_configure_all();                        \

#define START_STATS()                            \
        /* Reset instead of read-and-later-subtract (see hpmcounter_reset_all's \
         * comment): the 9 counters start at 0, so STOP_STATS below can just  \
         * accumulate a raw read. Order is configure (START_LOOP_STATS,       \
         * above) -> reset -> enable -> read, matching PLAY's own             \
         * START_STATS() exactly (hpmcounter_reset_all(); hpmcount_ext_en();  \
         * perf_csr_enable(); ...) -- enable used to run in START_LOOP_STATS, \
         * before the reset, a third ordering that differed from PLAY's       \
         * without being any less correct (a reset after enable just          \
         * overwrites whatever the counter briefly picked up); moved here to  \
         * match PLAY's instruction layout as closely as possible. */         \
        hpmcounter_reset_all();                                               \
        ccount_en();                                                          \
        hpmcount_ext_en();                                                    \
        /* instret, then cycles, snapshotted LAST (in that order): keeps the  \
         * 9 csrw resets above out of their deltas, and gives `cycles` the    \
         * tightest possible window right up to the kernel call -- it's the  \
         * metric under the most scrutiny (see stats.h's header comment). */ \
        _start_instr   = perf_csr_instret();     \
        _start_cycles  = perf_csr_cycle();       \

#define STOP_STATS()                                                    \
        /* cycles/instret read FIRST, right after the kernel call       \
         * returns, mirroring the tight start-side window above. Then   \
         * disable BEFORE the accumulation block runs below, not after: \
         * matches PLAY's own STOP_STATS ordering exactly (perf_csr_disable()/ \
         * pi_perf_stop() before its 9-counter accumulation) -- reading a  \
         * disabled mhpmcounter is still valid (mcountinhibit only stops  \
         * it incrementing further, doesn't invalidate the frozen value), \
         * so this doesn't change any reported number, only which side of \
         * the enable/disable boundary the accumulation code's own retired \
         * instructions land on. With disable AFTER (as before), the      \
         * accumulation loop's own ~18 compressed instructions counted    \
         * themselves in `rvc`; PLAY's equivalent loop never did, since   \
         * it was already past its own disable point -- see              \
         * PIC_CALL_OVERHEAD.md's wrapper section for the trace-level     \
         * proof. */                                                     \
        _end_cycles = perf_csr_cycle();                                \
        _end_instr  = perf_csr_instret();                              \
        ccount_dis();                                                    \
        hpmcount_ext_dis();                                              \
        if (_k >= HOTTING) {                                            \
            _cycles   += _end_cycles - _start_cycles;                   \
            _instr    += _end_instr  - _start_instr;                    \
            _ldstall  += hpmcounter_get_ld_stall();                     \
            _jrstall  += hpmcounter_get_jr_stall();                     \
            _imiss    += hpmcounter_get_imiss();                        \
            _ld       += hpmcounter_get_ld();                           \
            _st       += hpmcounter_get_st();                           \
            _jump     += hpmcounter_get_jump();                         \
            _branch   += hpmcounter_get_branch();                       \
            _btaken   += hpmcounter_get_btaken();                       \
            _rvc      += hpmcounter_get_rvc();                          \
        }                                                                \

#define END_LOOP_STATS()                                              \
        if (_k == HOTTING + REPEAT - 1) {                             \
            print_stats(_cycles, _instr, _ldstall, _jrstall, _imiss,  \
                        _ld, _st, _jump, _branch, _btaken, _rvc);     \
        }                                                              \
    }

#else /* STATS */

#define INIT_STATS()
#define START_LOOP_STATS()
#define START_STATS()
#define STOP_STATS()
#define END_LOOP_STATS()

#endif /* STATS */

#endif /* STATS_H_ */
