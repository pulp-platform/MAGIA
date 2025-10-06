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
 * Authors: 
 * 
 * OBI to iDMA Bridge - Memory-mapped control interface for iDMA
 *
 */

module obi2hwpe_ctrl
  import magia_tile_pkg::*;
(
  //OBI side
  input  core_obi_data_req_t obi_req_i,
  output core_obi_data_rsp_t obi_rsp_o,

  //HWPE-ctrl (RedMulE) side
  output redmule_ctrl_req_t  ctrl_req_o,
  input  redmule_ctrl_rsp_t  ctrl_rsp_i
);

  // ------------------------
  // Address channel mapping
  // ------------------------
  assign ctrl_req_o.req    = obi_req_i.req;
  assign obi_rsp_o.gnt     = ctrl_rsp_i.gnt;  // handshake 1:1

  assign ctrl_req_o.add    = obi_req_i.a.addr;
  assign ctrl_req_o.data   = obi_req_i.a.wdata;
  assign ctrl_req_o.be     = obi_req_i.a.be;
  assign ctrl_req_o.wen    = ~obi_req_i.a.we; // inversione semantica
  assign ctrl_req_o.id     = '0; // OBI doesn't have ID in this config

  // ------------------------
  // Response channel mapping  
  // ------------------------
  assign obi_rsp_o.rvalid   = ctrl_rsp_i.r_valid;

  assign obi_rsp_o.r.rdata  = ctrl_rsp_i.r_data;
  assign obi_rsp_o.r.err    = 1'b0; // RedMulE ctrl no errors


endmodule

