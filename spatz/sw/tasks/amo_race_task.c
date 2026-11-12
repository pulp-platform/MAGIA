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
 * Snitch half of amo_race_spatz_test: amoadd on a counter the control core increments at the same time
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "magia_spatz_utils.h"
#include "spatz_workers.h"

#define DATA_ADDR (SPATZ_DATA)

typedef struct {
  uint32_t counter_addr;
  uint32_t started_addr;  // Snitch sets it before its loop, so both loops overlap
  uint32_t num_iter;
} amo_race_params_t;

int amo_race_task(void) {
  volatile amo_race_params_t *params = (volatile amo_race_params_t *)mmio32(DATA_ADDR);
  uint32_t counter = params->counter_addr;
  uint32_t n = params->num_iter;

  mmio32(params->started_addr) = 1;
  for (uint32_t i = 0; i < n; i++) {
    uint32_t old;
    asm volatile("amoadd.w %0, %2, (%1)" : "=r"(old) : "r"(counter), "r"(1) : "memory");
  }
  return 0;
}
