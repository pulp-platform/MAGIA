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
 * MAGIA Mesh Test - Spatz Dot Product
 * 
 */

#include "magia_tile_utils.h"
#include "magia_utils.h"
#include "magia_spatz_utils.h"
#include "event_unit_utils.h"
#include "idma_mm_utils.h"
#include "mesh_dotp_spatz_task_bin.h"

// Test configuration  
#define DOTP_SIZE 1024  // Elements per tile
#define DIFF_TH (0x0011)  // Threshold for FP16 comparison

// FP16 test pattern: A[i] = 1.0, B[i] = 2.0
// Expected result: 1024 * 1.0 * 2.0 = 2048.0
typedef uint16_t fp16_t;
static const fp16_t dotp_a_value = 0x3C00;  // 1.0 in FP16
static const fp16_t dotp_b_value = 0x4000;  // 2.0 in FP16
static const fp16_t dotp_golden = 0x6800;   // 2048.0 in FP16

static const fp16_t a_vec[DOTP_SIZE] = {
    [0 ... DOTP_SIZE-1] = 0x3C00  // All elements = 1.0 in FP16
};
static const fp16_t b_vec[DOTP_SIZE] = {
    [0 ... DOTP_SIZE-1] = 0x4000  // All elements = 2.0 in FP16
};

#define A_VEC_BASE      (L1_BASE + 0x00010000)
#define B_VEC_BASE      (L1_BASE + 0x00012000)
#define RESULT_BASE     (L1_BASE + 0x00014000)

#define T_BASE          (L2_BASE + 0x0004A000)  
#define L2_RESULTS_BASE (L2_BASE + 0x00050000)
#define MHARTID_OFFSET  (0x00010000)  

#define DOTP_PARAM_BASE (L1_BASE + 0x00015000)

// Parameter structure for Spatz task
typedef struct {
    uint32_t a_addr;        // Vector A address
    uint32_t b_addr;        // Vector B address  
    uint32_t result_addr;   // Result address (scalar)
    uint32_t n_elements;    // Number of elements
} dotp_params_t;

int main(void) {
    uint32_t my_hartid = get_hartid();
    uint32_t l2_temp = T_BASE + my_hartid * MHARTID_OFFSET;
    uint32_t transfer_id;

    // Transfer vector A to L1 through iDMA
    printf("Initializing vector A through iDMA...\n");
    for (unsigned int i = 0; i < DOTP_SIZE; i++) {
        mmio16(l2_temp + 2*i) = a_vec[i];
    }
    transfer_id = idma_L2ToL1(l2_temp, A_VEC_BASE + my_hartid * L1_TILE_OFFSET, DOTP_SIZE * 2);
    dma_wait(transfer_id);
    
    // Transfer vector B to L1 through iDMA
    printf("Initializing vector B through iDMA...\n");
    for (unsigned int i = 0; i < DOTP_SIZE; i++) {
        mmio16(l2_temp + 2*i) = b_vec[i];
    }
    transfer_id = idma_L2ToL1(l2_temp, B_VEC_BASE + my_hartid * L1_TILE_OFFSET, DOTP_SIZE * 2);
    dma_wait(transfer_id);
    
    // Initialize Event Unit
    printf("Initializing Event Unit and Spatz...\n");
    eu_init();
    eu_enable_events(EU_SPATZ_DONE_MASK);
    
    // Initialize Spatz BEFORE writing parameters
    spatz_init(SPATZ_BINARY_START);

    // Write parameters to tile-specific L1 using L1_TILE_OFFSET
    uint32_t param_base = DOTP_PARAM_BASE + my_hartid * L1_TILE_OFFSET;
    mmio32(param_base + 0)  = A_VEC_BASE;     
    mmio32(param_base + 4)  = B_VEC_BASE;     
    mmio32(param_base + 8)  = RESULT_BASE;    
    mmio32(param_base + 12) = DOTP_SIZE;      
    
    printf("Starting Spatz dot product...\n");
    
    // Launch Spatz task
    spatz_run_task(DOTP_TASK);
    
    // Wait for Spatz completion
    eu_wait_spatz_wfe(EU_SPATZ_DONE_MASK);
    
    printf("Spatz task completed.\n");
    
    // Check Spatz exit code
    uint32_t exit_code = spatz_get_exit_code();
    if (exit_code != 0) {
        printf("ERROR: Spatz exit code = 0x%08x\n", exit_code);
    }
    
    // Move result from L1 to L2 using iDMA
    printf("Moving result to L2 through iDMA...\n");
    uint32_t l1_result_addr = RESULT_BASE + my_hartid * L1_TILE_OFFSET;
    uint32_t l2_result_addr = L2_RESULTS_BASE + my_hartid * MHARTID_OFFSET;
    transfer_id = idma_L1ToL2(l1_result_addr, l2_result_addr, 4);
    dma_wait(transfer_id);
    
    // Read result from L2
    fp16_t result = mmio16(l2_result_addr);
    
    uint16_t computed = result;
    uint16_t expected = dotp_golden;
    uint16_t diff = (computed > expected) ? (computed - expected) : (expected - computed);
    
    unsigned int num_errors = 0;
    if (diff > DIFF_TH) {
        num_errors++;
        printf("ERROR: Tile %d result (=0x%04x) != Golden (=0x%04x), diff=0x%04x\n", 
               my_hartid, computed, expected, diff);
    } else {
        printf("OK: Tile %d result matches golden value\n", my_hartid);
    }
    
    printf("\nFinished test with %u error(s)\n", num_errors);
    
    return num_errors;
}
