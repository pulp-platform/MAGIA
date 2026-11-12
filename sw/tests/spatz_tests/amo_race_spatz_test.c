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
 * Control core and Snitch amoadd on the same L1 counter at the same time: no increment may get lost
 */

#include "magia_tile_utils.h"
#include "magia_utils.h"
#include "magia_spatz_utils.h"
#include "event_unit_utils.h"
#include "amo_race_spatz_test_task_bin.h"

#define COUNTER_OFF  (0x00010000)  // In each tile's L1
#define STARTED_OFF  (0x00010004)
#define PARAM_OFF    (0x00010100)
#define NUM_ITER     (200)         // Increments per core
#define MAX_POLLS    (100000)

typedef struct {
  uint32_t counter_addr;
  uint32_t started_addr;
  uint32_t num_iter;
} amo_race_params_t;

int main(void) {
  uint32_t hartid = get_hartid();
  uint32_t l1 = L1_BASE + hartid * L1_TILE_OFFSET;
  uint32_t counter = l1 + COUNTER_OFF;
  volatile amo_race_params_t *params = (volatile amo_race_params_t *)(l1 + PARAM_OFF);
  int polls = 0;

  eu_init();
  eu_enable_events(EU_SPATZ_DONE_MASK);

  mmio32(counter)           = 0;
  mmio32(l1 + STARTED_OFF)  = 0;
  params->counter_addr = counter;
  params->started_addr = l1 + STARTED_OFF;
  params->num_iter     = NUM_ITER;

  spatz_init(SPATZ_BINARY_START);
  spatz_pass_params((uint32_t)params);
  spatz_run_task(AMO_RACE_TASK);

  while (mmio32(l1 + STARTED_OFF) == 0 && polls < MAX_POLLS)
    polls++;
  for (int i = 0; i < NUM_ITER; i++)
    amo_increment(counter, 1);

  eu_wait_spatz_wfe(EU_SPATZ_DONE_MASK);

  uint32_t got = mmio32(counter);
  if (polls == MAX_POLLS || spatz_get_exit_code() != 0 || got != 2 * NUM_ITER) {
    printf("Test FAILED: counter %d expected %d, polls %d\n", (int)got, 2 * NUM_ITER, polls);
    return 1;
  }
  printf("Test PASSED\n");
  return 0;
}
