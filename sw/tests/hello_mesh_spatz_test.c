/*
 * Copyright (C) 2023-2024 ETH Zurich and University of Bologna
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
 * MAGIA Hello Mesh Spatz Test
 * Simple test running Hello World on Spatz across multiple tiles
 * 
 */

#include "magia_tile_utils.h"
#include "magia_utils.h"
#include "magia_spatz_utils.h"
#include "event_unit_utils.h"
#include "hello_mesh_spatz_test_task_bin.h"

// Parameter structure
typedef struct {
    uint32_t tile_id;
} hello_params_t;

int main(void) {

  eu_init();
  eu_enable_events(EU_SPATZ_DONE_MASK);

  // Write parameters in L1 - each tile uses its own L1 region with offset
  uint32_t my_hartid = get_hartid();
  uint32_t param_base = L1_BASE + 0x00010000 + my_hartid * L1_TILE_OFFSET;
  volatile hello_params_t *params = (volatile hello_params_t *)param_base;
  params->tile_id = my_hartid;
  
  spatz_init(SPATZ_BINARY_START);
  
  printf("Starting Spatz Hello World task (tile_id=%d)...\n", my_hartid);
  
  spatz_run_task(HELLO_TASK);
  spatz_pass_params(param_base);
  
  // Wait for Spatz completion using WFE
  printf("Waiting for Spatz completion...\n");
  eu_wait_spatz_wfe(EU_SPATZ_DONE_MASK);

  printf("Spatz task completed successfully!\n");

  return 0;
}

