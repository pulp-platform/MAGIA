/*
 * Copyright (C) 2024 ETH Zurich and University of Bologna
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
 * MAGIA Mesh Atomic Test with Spatz (Snitch)
 * 
 */

#include "magia_tile_utils.h"
#include "magia_utils.h"
#include "magia_spatz_utils.h"
#include "event_unit_utils.h"
#include "atomic_mesh_spatz_test_task_bin.h"

#define SYNC_BASE      (L1_BASE + 0x00010000)  // L1 base where counters are stored
#define PARAM_BASE     (L1_BASE + 0x00010100)  // Parameters area (separate from counter)

// Parameter structure for Spatz task
typedef struct {
    uint32_t hartid;
    uint32_t counter_addr;
    uint32_t sync_base;
} atomic_params_t;

int main(void) {
  uint32_t hartid = get_hartid();
  
  printf("[Tile %d] Starting Mesh Atomic Test with Spatz\n", hartid);
  
  // Initialize Event Unit
  eu_init();
  eu_enable_events(EU_SPATZ_DONE_MASK);
  
  // Initialize all counters to 0 across mesh
  printf("[Tile %d] Initializing counter to 0\n", hartid);
  uint32_t my_counter_addr = SYNC_BASE + hartid * L1_TILE_OFFSET;
  mmio32(my_counter_addr) = 0;
  
  // Setup parameters in L1 - each tile uses its own L1 region
  uint32_t param_base = PARAM_BASE + hartid * L1_TILE_OFFSET;
  volatile atomic_params_t *params = (volatile atomic_params_t *)param_base;
  params->hartid = hartid;
  params->counter_addr = my_counter_addr;
  params->sync_base = SYNC_BASE;
  
  printf("[Tile %d] Initializing Spatz with atomic task\n", hartid);
  
  // Initialize Spatz with atomic remote task binary
  spatz_init(SPATZ_BINARY_START);
  
  printf("[Tile %d] Starting Spatz task\n", hartid);
  
  // Launch Spatz task with parameters via EXCHANGE_REG
  spatz_run_task(ATOMIC_REMOTE_TASK);
  spatz_pass_params(param_base);
  
  printf("[Tile %d] Waiting for Spatz completion...\n", hartid);
  
  // Wait for Spatz done event using WFE
  eu_wait_spatz_wfe(EU_SPATZ_DONE_MASK);
  
  printf("[Tile %d] Spatz completed! Checking result...\n", hartid);
  
  // Check Spatz exit code (0 = pass, 1 = fail)
  uint32_t exit_code = spatz_get_exit_code();
  
  // Read final counter value
  uint32_t final_count = mmio32(my_counter_addr);
  uint32_t expected = 6;  // NUM_ITER (2) * NUM_TARGETS (3) from task
  
  printf("[Tile %d] Counter: %d (expected %d), exit_code: %d\n", 
         hartid, final_count, expected, exit_code);
  
  if (exit_code == 0 && final_count == expected) {
    printf("[Tile %d] [PASS] Test completed successfully!\n", hartid);
    return 0;
  } else {
    printf("[Tile %d] [FAIL] Test failed!\n", hartid);
    return 1;
  }
}
