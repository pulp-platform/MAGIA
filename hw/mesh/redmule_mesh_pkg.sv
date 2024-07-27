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

  // Parameters used by the NoC
  parameter int unsigned AXI_NOC_ID_W = 4;
  parameter int unsigned AXI_NOC_U_W  = redmule_tile_pkg::USR_W;

  `AXI_TYPEDEF_ALL_CT(noc_axi_data, noc_axi_data_req_t, noc_axi_data_rsp_t, logic[redmule_tile_pkg::ADDR_W-1:0], logic[AXI_NOC_ID_W-1:0], logic[redmule_tile_pkg::DATA_W-1:0], logic[redmule_tile_pkg::STRB_W-1:0], logic[AXI_NOC_U_W-1:0])
  `AXI_ALIAS(noc_axi_data, axi_xbar_mst, noc_axi_data_req_t, axi_xbar_mst_req_t, noc_axi_data_rsp_t, axi_xbar_mst_rsp_t)
  `AXI_ALIAS(noc_axi_data, axi_default, noc_axi_data_req_t, axi_default_req_t, noc_axi_data_rsp_t, axi_default_rsp_t)

endpackage: redmule_mesh_pkg