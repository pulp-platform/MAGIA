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
 * RedMulE Tile Package
 */

package redmule_mesh_pkg;

  `include "axi/typedef.svh"

  `include "../include/alias.svh"

  // Global constants
  localparam int unsigned ADDR_W       = 32;                              // System-wide address Width
  localparam int unsigned DATA_W       = 32;                              // System-wide data Width
  localparam int unsigned INSTR_W      = 32;                              // System-wide instruction Width
  localparam int unsigned BYTE_W       = 8;                               // System-wide byte Width
  localparam int unsigned STRB_W       = DATA_W/BYTE_W;                   // System-wide strobe Width
  localparam int unsigned N_MEM_BANKS  = 32;                              // Number of TCDM banks (1 extra bank for missaligned accesses)
  localparam int unsigned N_WORDS_BANK = 4096;                            // Number of words per TCDM bank
  localparam int unsigned N_IRQ        = 32;                              // Number of IRQs
  localparam int unsigned IRQ_ID_W     = $clog2(N_IRQ);                   // IRQ ID Width
  localparam int unsigned ID_W_OFFSET  = 1;                               // Offset to be added to ID Width
  localparam int unsigned ID_W         = 1;                               // Default ID Width
  localparam int unsigned USR_W        = 1;                               // Default User Width

  // Parameters used by the NoC
  parameter int unsigned AXI_NOC_ID_W = 4;                                // AXI NoC ID Width: 2 bits on slave port + 2 bits to select from i$, iDMA and core data
  parameter int unsigned AXI_NOC_U_W  = USR_W;

  // Parameter used for the Fractal Sync network
  parameter int unsigned TILE_FSYNC_W = 2;                                // Level width of the Fractal Sync interface

  `AXI_TYPEDEF_ALL_CT(noc_axi_data, noc_axi_data_req_t, noc_axi_data_rsp_t, logic[ADDR_W-1:0], logic[AXI_NOC_ID_W-1:0], logic[DATA_W-1:0], logic[STRB_W-1:0], logic[AXI_NOC_U_W-1:0])
  `AXI_ALIAS(noc_axi_data, axi_xbar_mst, noc_axi_data_req_t, axi_xbar_mst_req_t, noc_axi_data_rsp_t, axi_xbar_mst_rsp_t)
  `AXI_ALIAS(noc_axi_data, axi_default, noc_axi_data_req_t, axi_default_req_t, noc_axi_data_rsp_t, axi_default_rsp_t)

  typedef axi_pkg::xbar_rule_32_t mesh_xbar_rule_t;

  localparam axi_pkg::xbar_cfg_t mesh_xbar_cfg = '{
    NoSlvPorts          : 4,    // TODO: redmule_mesh_tb_pkg::N_TILES,
    NoMstPorts          : 5,    // TODO: redmule_mesh_tb_pkg::N_TILES + 1,
    MaxMstTrans         : 64,   // TODO: redmule_tile_pkg::AxiXbarMaxWTrans*4
    MaxSlvTrans         : 64,
    FallThrough         : 1'b0,
    LatencyMode         : axi_pkg::CUT_ALL_PORTS,
    PipelineStages      : '0,   // TODO: make it parametric
    AxiIdWidthSlvPorts  : AXI_NOC_ID_W,
    AxiIdUsedSlvPorts   : AXI_NOC_ID_W, // TODO: check me!
    UniqueIds           : 1'b0,
    AxiAddrWidth        : ADDR_W,
    AxiDataWidth        : DATA_W,
    NoAddrRules         : 5    // TODO: redmule_mesh_tb_pkg::N_TILES + 1
  };

endpackage: redmule_mesh_pkg