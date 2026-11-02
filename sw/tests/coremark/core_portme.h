/*
 * Copyright 2018 Embedded Microprocessor Benchmark Consortium (EEMBC)
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
 * Original Author: Shay Gal-on (EEMBC, barebones/core_portme.h)
 * Authors: Niccolò Giuliani <niccolo.giuliani@chips.it> (MAGIA port)
 *
 * CoreMark port for the MAGIA control core (CV32, bare metal). Where the data of the benchmark live
 * (make EXTRA_CFLAGS=-DCOREMARK_MEM=n):
 *   0: the L1 scratchpad (MEM_STACK: the stack of the control core is in its L1)
 *   1: the L2, through the data cache (MEM_STATIC: .bss, inside the cacheable region); needs dcache=1
 *   2: the L2, with the data cache off (MEM_STATIC, CACHE_EN = 0 during the run)
 * COREMARK_PF=1 turns the next-line prefetch on (variant 1). ITERATIONS (default 1) sets the iterations.
 */

#ifndef CORE_PORTME_H
#define CORE_PORTME_H

#include <stddef.h>
#include <stdint.h>

#ifndef COREMARK_MEM
#define COREMARK_MEM 1
#endif
#ifndef COREMARK_PF
#define COREMARK_PF 0
#endif
#ifndef ITERATIONS
#define ITERATIONS 1
#endif

/* No float, no time.h, no stdio: cycles from mcycle, ee_printf on tinyprintf */
#define HAS_FLOAT  0
#define HAS_TIME_H 0
#define USE_CLOCK  0
#define HAS_STDIO  0
#define HAS_PRINTF 0

#define COMPILER_VERSION "GCC" __VERSION__
#ifndef COMPILER_FLAGS
#define COMPILER_FLAGS "-O2 (MAGIA sw/tests)"
#endif

#if COREMARK_MEM == 0
#define MEM_METHOD   MEM_STACK
#define MEM_LOCATION "L1 SPM (stack)"
#elif COREMARK_MEM == 1
#define MEM_METHOD   MEM_STATIC
#define MEM_LOCATION "L2 through the data cache"
#else
#define MEM_METHOD   MEM_STATIC
#define MEM_LOCATION "L2, data cache off"
#endif

typedef signed short   ee_s16;
typedef unsigned short ee_u16;
typedef signed int     ee_s32;
typedef double         ee_f32;
typedef unsigned char  ee_u8;
typedef unsigned int   ee_u32;
typedef ee_u32         ee_ptr_int;
typedef size_t         ee_size_t;

#define align_mem(x) (void *)(4 + (((ee_ptr_int)(x)-1) & ~3))

typedef ee_u32 CORE_TICKS;

#define SEED_METHOD       SEED_VOLATILE
#define MULTITHREAD       1
#define USE_PTHREAD       0
#define USE_FORK          0
#define USE_SOCKET        0
#define MAIN_HAS_NOARGC   1
#define MAIN_HAS_NORETURN 0
#define PERFORMANCE_RUN   1
#define VALIDATION_RUN    0
#define PROFILE_RUN       0
#define CORE_DEBUG        0
#define CALLGRIND_RUN     0
#define COMPILER_REQUIRES_SORT_RETURN 0

extern ee_u32 default_num_contexts;

typedef struct CORE_PORTABLE_S {
    ee_u8 portable_id;
} core_portable;

void portable_init(core_portable *p, int *argc, char *argv[]);
void portable_fini(core_portable *p);

int ee_printf(const char *fmt, ...);

#endif /* CORE_PORTME_H */
