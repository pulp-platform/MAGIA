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
 * Author: Luca Balboni, Fondazione Chips-IT
 *
 * string.h of the riscvTests: the Spatz binary is linked without a libc
 */
#ifndef STRING_H
#define STRING_H

#include <stddef.h>

// Real symbols: the compiler also calls memcpy/memset for array initializers; one includer per binary
// volatile keeps the loops from being turned back into a memcpy call
void *memcpy(void *dst, const void *src, size_t n) {
    // Word copies when possible: the sources are in L2, a slow access each
    if ((((size_t)dst | (size_t)src | n) & 3u) == 0u) {
        volatile unsigned int *dw = dst;
        const volatile unsigned int *sw = src;
        for (size_t i = 0; i < n / 4u; i++) dw[i] = sw[i];
        return dst;
    }
    volatile unsigned char *d = dst;
    const volatile unsigned char *s = src;
    while (n--) *d++ = *s++;
    return dst;
}

void *memset(void *dst, int c, size_t n) {
    volatile unsigned char *d = dst;
    while (n--) *d++ = (unsigned char)c;
    return dst;
}

#endif
