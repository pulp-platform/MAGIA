/*
 * Copyright (C) 2026 ETH Zurich, University of Bologna and Fondazione Chips-IT
 *
 * Licensed under the Solderpad Hardware License, Version 0.51 
 * (the "License"); you may not use this file except in compliance 
 * with the License. You may obtain a copy of the License at
 *
 *     http://solderpad.org/licenses/SHL-0.51
 *
 * Unless required by applicable law or agreed to in writing, software, hardware
 * and materials distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * SPDX-License-Identifier: SHL-0.51
 *
 * Authors: Luca Balboni <luca.balboni10@studio.unibo.it>
 *          
 * 
 * OBI to iDMA Bridge - Memory-mapped control interface for iDMA
 *
 */

module obi2hwpe_ctrl
  import magia_tile_pkg::*;
(
  input  logic               clk_i,
  input  logic               rst_ni,

  //OBI side
  input  obi_sbr_req_t obi_req_i,
  output obi_sbr_rsp_t obi_rsp_o,

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
  assign ctrl_req_o.id     = '0;

  logic                    rid_en;
  logic [SBR_AID_WIDTH-1:0] rid_q;

  assign rid_en = obi_req_i.req & ctrl_rsp_i.gnt;

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      rid_q <= '0;
    end else if (rid_en) begin
      rid_q <= obi_req_i.a.aid;
    end
  end

  // ------------------------
  // Response channel mapping  
  // ------------------------
  assign obi_rsp_o.rvalid   = ctrl_rsp_i.r_valid;

  assign obi_rsp_o.r.rdata  = ctrl_rsp_i.r_data;
  assign obi_rsp_o.r.err    = 1'b0; // RedMulE ctrl no errors
  assign obi_rsp_o.r.rid    = rid_q;
  
  // Optional response fields set to zero to prevent X propagation (not used by RedMulE ctrl)
  assign obi_rsp_o.r.r_optional.ruser  = '0;
  assign obi_rsp_o.r.r_optional.exokay = 1'b0;
  assign obi_rsp_o.r.r_optional.rchk   = '0;

endmodule

