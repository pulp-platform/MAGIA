/*
 * Copyright (C) 2026 Fondazione Chips-IT
 * SPDX-License-Identifier: Apache-2.0
 *
 * Authors: Niccolò Giuliani <niccolo.giuliani@chips.it>
 *
 * Include guard around the EEMBC coremark.h (eembc/coremark.h, unchanged): the test is one source file that
 * includes every EEMBC file, and coremark.h has no guard of its own. And the exit code of main.
 */

#ifndef MAGIA_COREMARK_H
#define MAGIA_COREMARK_H
#include "eembc/coremark.h"

/* main returns 0 when the CRCs of the run are the known ones (eembc/coremark.h sets 0). The "at least 10 secs"
 * rule of a reported CoreMark is not checked: a simulation runs for milliseconds. */
#undef MAIN_RETURN_VAL
#define MAIN_RETURN_VAL ((known_id < 0 || results[0].err != 0) ? 1 : 0)
#endif
