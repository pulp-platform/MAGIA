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
 * Author: Carlotta Chiarini, Fondazione Chips-IT
 * 
 * MAGIA Mesh Reduce test over the narrow channel using the built-in FlooNoC collectives
 *
 * At the current development stage of the FlooNoC built-in collectives, a single reduce over the mesh is not possible.
 * Therefore, the reduce is split in a reduce over all the columns of the mesh, followed by a reduce over a single row.
 *
 * Steps of the test:
 * 1) Integer Add Test
 * 2) Barrier
 * 3) Integer Mul Test
 */

#include "magia_utils.h"
#include "magia_coll_utils.h"

#define REDUCE_OFFSET (0x1000)
#define SYNC_OFFSET (0x2000)

#define DESTINATION_HART_ID 0
#define SYNC_PATTERN 3


int main() {
    
  uint32_t unreduced_data;
  uint32_t reduced_data;


  // ********************** INT SUM TEST *************************** //
  unreduced_data = 100;
  /*
  * Hardware configuration:
  * 1) Collective Operation opcode -> INT_ADD
  * 2) Nodes taking part to the transactions -> COLUMN
  */
  set_collective_op(INT_ADD);
  set_collective_mask(gen_collective_mask(COLUMN));
  printf("Summing over column...\n");
  /*
  * Nodes in each column perform a reduction targeting the topmost node of that column. 
  * The target hart ID is computed using GET_X_ID(get_hartid()).
  */
  mmio32(COLLECTIVE_ADDR_OFFSET +  L1_BASE + GET_X_ID(get_hartid())*L1_TILE_OFFSET + REDUCE_OFFSET) = unreduced_data;

  /*
  * If the current node is a topmost node, it is expected to be the destination of a reduction operation. 
  * All topmost nodes also initiate a reduction across their row, targeting DESTINATION_HART_ID.
  */
  if(get_hartid() < MESH_X_TILES){
    /*
    * Receive the final reduced data over the column
    */
    reduced_data = unreduced_data * MESH_X_TILES;
    while(mmio32(L1_BASE + get_hartid()*L1_TILE_OFFSET + REDUCE_OFFSET) != reduced_data) {};
    printf("Summing over column complete\n");

    /*
    * Taking part to the final reduction transaction over the row
    */
    set_collective_mask(gen_collective_mask(ROW));

    printf("Summing over row...\n");
    unreduced_data = mmio32(L1_BASE + get_hartid()*L1_TILE_OFFSET + REDUCE_OFFSET);
    mmio32(COLLECTIVE_ADDR_OFFSET +  L1_BASE + DESTINATION_HART_ID*L1_TILE_OFFSET + REDUCE_OFFSET) = unreduced_data;
  }

  /*
  * If the current node is the DESTINATION_HART_ID node, it waits for the final reduced data.
  */
  if(get_hartid() == DESTINATION_HART_ID){
    /*
    * Compute the expected reduction result and check it against the final result.
    */
    reduced_data = unreduced_data * MESH_Y_TILES;
    while(mmio32(L1_BASE + get_hartid()*L1_TILE_OFFSET + REDUCE_OFFSET) != reduced_data) {};
    printf("Summing over row complete\n");
    printf("SUM TEST PASSED | RESULT 0x%x\n", reduced_data);
  }


  // ************************** BARRIER ***************************** //
  /*
  * To avoid overlapping the SUM and MUL test, we use a barrier.
  */
  printf("Barrier...\n");
  set_collective_mask(gen_collective_mask(ALL));
  set_collective_op(LSBAND);
  mmio32(COLLECTIVE_ADDR_OFFSET + L1_BASE + DESTINATION_HART_ID*L1_TILE_OFFSET + SYNC_OFFSET) = SYNC_PATTERN;



  // ************************* INT MUL TEST ********************** //
  unreduced_data = 2;
  /*
  * Hardware configuration:
  * 1) Collective Operation opcode -> INT_MUL
  * 2) Nodes taking part to the transactions -> COLUMN
  */
  set_collective_op(INT_MUL);
  set_collective_mask(gen_collective_mask(COLUMN));
  printf("Multiplying over column...\n");
  
  /*
  * Nodes in each column perform a reduction targeting the topmost node of that column. 
  * The target hart ID is computed using GET_X_ID(get_hartid()).
  */
  mmio32(COLLECTIVE_ADDR_OFFSET +  L1_BASE + GET_X_ID(get_hartid())*L1_TILE_OFFSET + REDUCE_OFFSET) = unreduced_data;

  /*
  * If the current node is a topmost node, it is expected to be the destination of a reduction operation. 
  * All topmost nodes also initiate a reduction across their row, targeting DESTINATION_HART_ID.
  */
  if(get_hartid() < MESH_X_TILES){
    /*
    * Receive the final reduced data over the column
    */
    reduced_data = unreduced_data;
    for(int i = 0; i < (MESH_X_TILES-1); i++)
      reduced_data = reduced_data*unreduced_data;

    while(mmio32(L1_BASE + get_hartid()*L1_TILE_OFFSET + REDUCE_OFFSET) != reduced_data) {};
    printf("Multiplying over column complete\n");

    /*
    * Taking part to the final reduction transaction over the row
    */
    set_collective_mask(gen_collective_mask(ROW));
    
    printf("Multiplying over row...\n");
    unreduced_data = mmio32(L1_BASE + get_hartid()*L1_TILE_OFFSET + REDUCE_OFFSET);
    mmio32(COLLECTIVE_ADDR_OFFSET +  L1_BASE + DESTINATION_HART_ID*L1_TILE_OFFSET + REDUCE_OFFSET) = unreduced_data;
  }

  /*
  * If the current node is the DESTINATION_HART_ID node, it waits for the final reduced data.
  */
  if(get_hartid() == DESTINATION_HART_ID){
    /*
    * Compute the expected reduction result and check it against the final result.
    */
    reduced_data = unreduced_data;
    for(int i = 0; i < (MESH_Y_TILES-1); i++)
      reduced_data = reduced_data*unreduced_data;

    while(mmio32(L1_BASE + get_hartid()*L1_TILE_OFFSET + REDUCE_OFFSET) != reduced_data) {};
    printf("Multiplying over row complete\n");
    printf("MUL TEST PASSED | RESULT 0x%x\n", reduced_data);
  }

  return 0;
}
