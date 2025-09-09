/*
 * Copyright (C) 2023-2024 ETH Zurich and University of Bologna
 *
 * Licensed under the Solderpad Hardware License, Version 0.51 
 * (the "License"); you may not use this file except in compliance 
 * with the License. You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * SPDX-License-Identifier: SHL-0.51
 *
 * Authors: Victor Isachi <victor.isachi@unibo.it>
 * 
 * MAGIA Package
 */

package magia_pkg;

  `include "axi/typedef.svh"
  `include "fractal_sync/typedef.svh"

  `include "../include/alias.svh"

  // Global constants
  localparam int unsigned ADDR_W           = 32;                              // System-wide address Width
  localparam int unsigned DATA_W           = 32;                              // System-wide data Width
  localparam int unsigned INSTR_W          = 32;                              // System-wide instruction Width
  localparam int unsigned BYTE_W           = 8;                               // System-wide byte Width
  localparam int unsigned STRB_W           = DATA_W/BYTE_W;                   // System-wide strobe Width
  localparam int unsigned N_MEM_BANKS      = 32;                              // Number of TCDM banks (1 extra bank for missaligned accesses)
  localparam int unsigned N_WORDS_BANK     = 8192;                            // Number of words per TCDM bank
  localparam int unsigned N_TILES_Y        = 2;                               // Number of Tile rowns
  localparam int unsigned N_TILES_X        = 2;                               // Number of Tile columns
  localparam int unsigned N_TILES          = N_TILES_Y*N_TILES_X;             // Number of Tiles in the Mesh
  localparam int unsigned N_IRQ            = 32;                              // Number of IRQs
  localparam int unsigned IRQ_ID_W         = $clog2(N_IRQ);                   // IRQ ID Width
  localparam int unsigned ID_W_OFFSET      = 1;                               // Offset to be added to ID Width
  localparam int unsigned ID_W             = 1;                               // Default ID Width
  localparam int unsigned USR_W            = 1;                               // Default User Width

  // Parameters used by the NoC
  parameter int unsigned AXI_NOC_ID_W      = 4;                                // AXI NoC ID Width: 2 bits on slave port + 2 bits to select from i$, iDMA and core data
  parameter int unsigned AXI_NOC_U_W       = USR_W;

  // Parameters used by the L2
  parameter int unsigned L2_ID_W           = 2;                                // The ID Width reflects the ID Width of the Tile AXI XBAR
  parameter int unsigned L2_U_W            = 1;

  // Parameter used for the Fractal Sync network
  parameter int unsigned FSYNC_LVL         = (N_TILES_X == N_TILES_Y) ? 
                                              $clog2(N_TILES) : 
                                              -1;                              // Number of levels of the Fractal Sync tree
  parameter int unsigned ROOT_FSYNC_AGGR_W = 1;                                // Aggregate width of the Fractal Sync Root tree out interface
  parameter int unsigned TILE_FSYNC_AGGR_W = ROOT_FSYNC_AGGR_W+FSYNC_LVL;      // Aggregate width of the Fractal Sync interface (CU-FSync interface)
  parameter int unsigned TILE_FSYNC_LVL_W  = $clog2(TILE_FSYNC_AGGR_W-1);      // Level width of the Fractal Sync interface (CU-FSync interface)
  parameter int unsigned TILE_FSYNC_ID_W   = FSYNC_LVL-1 >= 2 ? 
                                             FSYNC_LVL-1 : 
                                             2;                                // Id width of the Fractal Sync interface (CU-FSync interface)
  parameter int unsigned ROOT_FSYNC_LVL_W  = TILE_FSYNC_LVL_W;                 // Level width of the Fractal Sync Root tree out interface
  parameter int unsigned ROOT_FSYNC_ID_W   = TILE_FSYNC_ID_W;                  // Id width of the Fractal Sync Root tree out interface

  `AXI_TYPEDEF_ALL_CT(noc_axi_data, noc_axi_data_req_t, noc_axi_data_rsp_t, logic[ADDR_W-1:0], logic[AXI_NOC_ID_W-1:0], logic[DATA_W-1:0], logic[STRB_W-1:0], logic[AXI_NOC_U_W-1:0])
  `AXI_ALIAS(noc_axi_data, axi_xbar_mst, noc_axi_data_req_t, axi_xbar_mst_req_t, noc_axi_data_rsp_t, axi_xbar_mst_rsp_t)
  `AXI_ALIAS(noc_axi_data, axi_default, noc_axi_data_req_t, axi_default_req_t, noc_axi_data_rsp_t, axi_default_rsp_t)

  `AXI_TYPEDEF_ALL_CT(axi_l2, axi_l2_req_t, axi_l2_rsp_t, logic[ADDR_W-1:0], logic[L2_ID_W-1:0], logic[DATA_W-1:0], logic[STRB_W-1:0], logic[L2_U_W-1:0])

  `FSYNC_TYPEDEF_ALL(h_root_fsync, logic[ROOT_FSYNC_AGGR_W-1:0], logic[ROOT_FSYNC_LVL_W-1:0], logic[ROOT_FSYNC_ID_W-1:0])
  `FSYNC_TYPEDEF_ALL(v_root_fsync, logic[ROOT_FSYNC_AGGR_W-1:0], logic[ROOT_FSYNC_LVL_W-1:0], logic[ROOT_FSYNC_ID_W-1:0])

endpackage: magia_pkg