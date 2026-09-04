/*
 * Copyright (C) 2023-2024 ETH Zurich and University of Bologna and Fondazione Chips-IT
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
 * MAGIA Stats / Performance Counters
 */

#ifndef MAGIA_STATS_H
#define MAGIA_STATS_H

#include <stdint.h>

static inline void ccount_en(void){
#if defined(CV32E40X) || defined(CV32E40P)
    asm volatile("csrrci zero, 0x320, 0x1" ::);
#else
    asm volatile("csrw 0x7E0, %0" :: "r"(0x1));
    asm volatile("csrw 0x7E1, %0" :: "r"(0x1));
#endif
}

static inline void ccount_dis(void){
#if defined(CV32E40X) || defined(CV32E40P)
    asm volatile("csrrsi zero, 0x320, 0x1" ::);
#else
    asm volatile("csrw 0x7E1, %0" :: "r"(0x0));
#endif
}

static inline uint32_t perf_csr_cycle(void){
    uint32_t v;
    asm volatile("csrr %0, 0xB00" : "=r"(v));
    return v;
}

static inline uint32_t perf_csr_instret(void){
    uint32_t v;
    asm volatile("csrr %0, 0xB02" : "=r"(v));
    return v;
}

#define EVT_LD_STALL  (1u << 2)
#define EVT_JR_STALL  (1u << 3)
#define EVT_IMISS     (1u << 4)
#define EVT_LD        (1u << 5)
#define EVT_ST        (1u << 6)
#define EVT_JUMP      (1u << 7)
#define EVT_BRANCH    (1u << 8)
#define EVT_BTAKEN    (1u << 9)
#define EVT_RVC       (1u << 10)

#define MHPMCTR_INHIBIT_MASK (0xFF8u)

#if defined(CV32E40P)

static inline void hpmcount_ext_en(void){
    uint32_t mask = MHPMCTR_INHIBIT_MASK;
    asm volatile("csrrc zero, 0x320, %0" :: "r"(mask));
}

static inline void hpmcount_ext_dis(void){
    uint32_t mask = MHPMCTR_INHIBIT_MASK;
    asm volatile("csrrs zero, 0x320, %0" :: "r"(mask));
}

#define DECL_MHPMCTR(NAME, EVENT_CSR, COUNTER_CSR, EVENT_MASK)                   \
    static inline void hpmevent_set_##NAME(void) {                              \
        asm volatile("csrw " #EVENT_CSR ", %0" :: "r"((uint32_t)(EVENT_MASK))); \
    }                                                                           \
    static inline uint32_t hpmcounter_get_##NAME(void) {                        \
        uint32_t v;                                                             \
        asm volatile("csrr %0, " #COUNTER_CSR : "=r"(v));                       \
        return v;                                                               \
    }                                                                           \
    static inline void hpmcounter_reset_##NAME(void) {                          \
        asm volatile("csrw " #COUNTER_CSR ", zero");                            \
    }

#else

static inline void hpmcount_ext_en(void){ }
static inline void hpmcount_ext_dis(void){ }

#define DECL_MHPMCTR(NAME, EVENT_CSR, COUNTER_CSR, EVENT_MASK)       \
    static inline void hpmevent_set_##NAME(void) { }                \
    static inline uint32_t hpmcounter_get_##NAME(void) { return 0; } \
    static inline void hpmcounter_reset_##NAME(void) { }

#endif

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

static inline void hpmevent_configure_all(void){
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

static inline void hpmcounter_reset_all(void){
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

#endif /*MAGIA_STATS_H*/
