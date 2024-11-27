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

  parameter int unsigned N_MEM_BANKS  = 32;    // Number of memory banks 
  parameter int unsigned N_WORDS_BANK = 8192;  // Number of words per memory bank   
  parameter int unsigned N_TILES      = 4;     // Number of tiles per mesh

  parameter int unsigned L2_ID_W      = redmule_mesh_pkg::AXI_NOC_ID_W + $clog2(N_TILES);
  parameter int unsigned L2_U_W       = redmule_mesh_pkg::AXI_NOC_U_W;

  `AXI_TYPEDEF_ALL_CT(axi_l2_vip, axi_l2_vip_req_t, axi_l2_vip_rsp_t, logic[redmule_mesh_pkg::ADDR_W-1:0], logic[L2_ID_W-1:0], logic[redmule_mesh_pkg::DATA_W-1:0], logic[redmule_mesh_pkg::STRB_W-1:0], logic[L2_U_W-1:0])

endpackage: redmule_mesh_tb_pkg