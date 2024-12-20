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
 * RedMulE Mesh Testbench Package
 */

package redmule_mesh_tb_pkg;

  `include "axi/typedef.svh"

  parameter int unsigned N_MEM_BANKS  = redmule_mesh_pkg::N_MEM_BANKS;  // Number of TCDM banks (1 extra bank for missaligned accesses)
  parameter int unsigned N_WORDS_BANK = redmule_mesh_pkg::N_WORDS_BANK; // Number of words per TCDM bank
  parameter int unsigned N_TILES_X    = redmule_mesh_pkg::N_TILES_X;    // Number of Tile columns
  parameter int unsigned N_TILES_Y    = redmule_mesh_pkg::N_TILES_Y;    // Number of Tile rowns
  parameter int unsigned N_TILES      = redmule_mesh_pkg::N_TILES;      // Number of Tiles in the Mesh

  parameter int unsigned L2_ID_W      = redmule_tile_pkg::AXI_ID_W;
  parameter int unsigned L2_U_W       = redmule_tile_pkg::AXI_U_W;

  parameter int unsigned FSYNC_LVL    = redmule_mesh_pkg::FSYNC_LVL;
  parameter int unsigned TILE_FSYNC_W = redmule_mesh_pkg::TILE_FSYNC_W;

  `AXI_TYPEDEF_ALL_CT(axi_l2_vip, axi_l2_vip_req_t, axi_l2_vip_rsp_t, logic[redmule_mesh_pkg::ADDR_W-1:0], logic[L2_ID_W-1:0], logic[redmule_mesh_pkg::DATA_W-1:0], logic[redmule_mesh_pkg::STRB_W-1:0], logic[L2_U_W-1:0])

endpackage: redmule_mesh_tb_pkg