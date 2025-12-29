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
 * Simple Hello World Task for Spatz
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "spatz_workers.h"

// Parameters passed via L1 local memory (each tile has its own L1)
#define HELLO_PARAM_BASE  (L1_BASE + 0x00010000)

// Parameter structure
typedef struct {
    uint32_t param_addr;    // Address where tile_id is stored
} hello_params_t;

// Main entry point
int hello_task(void) {
    
    // Read parameter address from base location (always at same offset for all tiles)
    volatile hello_params_t *params = (volatile hello_params_t *)HELLO_PARAM_BASE;
    uint32_t param_addr = params->param_addr;
    
    // Read tile_id from the provided address
    uint32_t tile_id = mmio32(param_addr);
    
    // Print from Spatz!
    printf("*** Hello from Spatz task on Tile %d! ***\n", tile_id);
    
    return 0;
}
