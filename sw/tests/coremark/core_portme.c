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
 * Original Author: Shay Gal-on (EEMBC, barebones/core_portme.c)
 * Authors: Niccolò Giuliani <niccolo.giuliani@chips.it> (MAGIA port)
 *
 * CoreMark port for the MAGIA control core: time from mcycle, the data cache set up for the variant
 * (core_portme.h), ee_printf on tinyprintf, and one result line at the end:
 *   COREMARK mem=<n> pf=<0/1> iterations=<n> cycles=<n> cycles_per_iter=<n> coremark_per_mhz_x1000=<n>
 */

#include <stdarg.h>
#include "coremark.h"
#include "magia_tile_utils.h"
#include "magia_dcache_utils.h"

#define TICKS_PER_SEC (200000000u)   /* the tile clock: 200 MHz */
#define PRINT_BUF     (256)

/* Seeds of a performance run (the values of the EEMBC reference port) */
volatile ee_s32 seed1_volatile = 0x0;
volatile ee_s32 seed2_volatile = 0x0;
volatile ee_s32 seed3_volatile = 0x66;
volatile ee_s32 seed4_volatile = ITERATIONS;
volatile ee_s32 seed5_volatile = 0;

ee_u32 default_num_contexts = 1;

static CORE_TICKS    start_time_val, stop_time_val;
static dcache_perf_t run_perf;

static inline ee_u32 read_mcycle(void) {
    ee_u32 cycles;
    asm volatile("csrr %0, mcycle" : "=r"(cycles));
    return cycles;
}

/* Start of the timed part: the cache counters count it too */
void start_time(void) {
    dcache_perf_start();
    start_time_val = read_mcycle();
}

void stop_time(void) {
    stop_time_val = read_mcycle();
    dcache_perf_stop();
    dcache_perf_read(&run_perf);
}

CORE_TICKS get_time(void) {
    return stop_time_val - start_time_val;
}

secs_ret time_in_secs(CORE_TICKS ticks) {
    return (secs_ret)(ticks / TICKS_PER_SEC);
}

/* Before the benchmark: the cycle counter on, the cache as the variant wants it */
void portable_init(core_portable *p, int *argc, char *argv[]) {
    (void)argc;
    (void)argv;
    asm volatile("csrw mcountinhibit, zero");
    if (sizeof(ee_ptr_int) != sizeof(ee_u8 *))
        ee_printf("ERROR! ee_ptr_int must hold a pointer\n");
    if (sizeof(ee_u32) != 4)
        ee_printf("ERROR! ee_u32 must be 32 bits\n");
    dcache_flush();
#if COREMARK_MEM == 2
    dcache_enable(0);
#else
    dcache_enable(1);
#endif
    dcache_set_prefetch(COREMARK_PF);
    p->portable_id = 1;
}

/* After the benchmark: the result line and the cache counters of the timed part */
void portable_fini(core_portable *p) {
    ee_u32 cycles   = get_time();
    ee_u32 per_iter = cycles / ITERATIONS;
    ee_u32 cm_x1000 = (per_iter > 0) ? (1000000000u / per_iter) : 0;

    printf("COREMARK mem=%d pf=%d iterations=%d cycles=%u cycles_per_iter=%u coremark_per_mhz_x1000=%u\n",
           COREMARK_MEM, COREMARK_PF, ITERATIONS, (unsigned)cycles, (unsigned)per_iter, (unsigned)cm_x1000);
    dcache_perf_print(&run_perf);
    dcache_set_prefetch(0);
    dcache_enable(1);
    p->portable_id = 0;
}

/* printf of CoreMark: tinyprintf has no long support, and long is 32 bits here: the 'l' of the
 * conversions is dropped */
int ee_printf(const char *fmt, ...) {
    char    format[PRINT_BUF];
    char    text[PRINT_BUF];
    int     in_conversion = 0;
    int     n = 0;
    va_list args;

    for (int i = 0; fmt[i] != '\0' && n < PRINT_BUF - 1; i++) {
        char c = fmt[i];
        if (c == '%')
            in_conversion = !in_conversion;
        else if (in_conversion && c == 'l')
            continue;
        else if (in_conversion && ((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z')))
            in_conversion = 0;
        format[n++] = c;
    }
    format[n] = '\0';

    va_start(args, fmt);
    n = vsnprintf(text, PRINT_BUF, format, args);
    va_end(args);
    printf("%s", text);
    return n;
}
