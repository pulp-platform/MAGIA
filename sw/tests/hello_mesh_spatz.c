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
#include "hello_mesh_spatz_task_bin.h"

// Spatz parameter area - each tile accesses its own L1 via L1_TILE_OFFSET
#define HELLO_PARAM_BASE (L1_BASE + 0x00010000)


int main(void) {

  printf("=== MAGIA Hello Mesh Spatz ===\n");
  printf("Running on Tile %d\n", get_hartid());

  // Initialize Event Unit and Spatz
  printf("Initializing Event Unit...\n");
  eu_init();
  eu_enable_events(EU_SPATZ_DONE_MASK);
  
  printf("Initializing Spatz...\n");
  spatz_init(SPATZ_BINARY_START);
  
  // Write tile_id parameter - each tile uses its own L1 region with offset
  uint32_t my_hartid = get_hartid();
  uint32_t param_base = HELLO_PARAM_BASE + my_hartid * L1_TILE_OFFSET;
  uint32_t data_addr = param_base + 0x100;  // Data offset from param base
  
  // Write tile_id data
  mmio32(data_addr) = my_hartid;
  
  // Write parameter: address where tile_id is stored
  mmio32(param_base) = data_addr;
  
  printf("Starting Spatz Hello World task (tile_id=%d, data_addr=0x%08x)...\n", my_hartid, data_addr);
  
  spatz_run_task(HELLO_TASK);
  
  // Wait for Spatz completion using WFE
  printf("Waiting for Spatz completion...\n");
  eu_wait_spatz_wfe(EU_SPATZ_DONE_MASK);

  printf("Spatz task completed successfully!\n");

  return 0;
}

