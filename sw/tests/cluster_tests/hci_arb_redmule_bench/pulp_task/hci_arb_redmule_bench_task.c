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
 * Authors: Luca Balboni <luca.balboni10@studio.unibo.it>
 *
 * HCI Arbitration RedMulE Benchmark: PULP cluster stress task
 */

#include "magia_tile_utils.h"
#include "cluster_utils.h"

#define HCI_STRESS_ITERS  (4096)
#define HCI_STRESS_BASE   (L1_BASE + 0x00060000)
#define HCI_STRESS_STRIDE (0x00000400)
#define HCI_STRESS_WORDS  (HCI_STRESS_STRIDE / 4)

static void hci_stress_worker(void *arg) {
    (void)arg;
    volatile uint32_t *p = (volatile uint32_t *)(HCI_STRESS_BASE + pi_core_id() * HCI_STRESS_STRIDE);
    for (uint32_t i = 0; i < HCI_STRESS_ITERS; i++) {
        p[i % HCI_STRESS_WORDS] = i;
        (void)p[i % HCI_STRESS_WORDS];
    }
}

void hci_arb_redmule_bench_task(void *data) {
    (void)data;
    pi_cl_team_fork(PULP_CORE_COUNT, hci_stress_worker, 0);
}
