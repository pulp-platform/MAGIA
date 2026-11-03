/*
 * Copyright (C) 2026 Fondazione Chips-IT
 * SPDX-License-Identifier: Apache-2.0
 *
 * Authors: Niccolò Giuliani <niccolo.giuliani@chips.it>
 *
 * Shared between the control core and the cluster task of coremark_cluster_test.
 */

#ifndef COREMARK_CLUSTER_TEST_H
#define COREMARK_CLUSTER_TEST_H

#include <stdint.h>

typedef struct {
    uint32_t results;                         /* core_results[8], one per core, in the L1 */
    uint32_t cycles[8];
} coremark_cluster_params_t;

#endif /* COREMARK_CLUSTER_TEST_H */
