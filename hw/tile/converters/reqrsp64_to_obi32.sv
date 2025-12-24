/*
 * Copyright (C) 2024 ETH Zurich and University of Bologna
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
 * Authors: Luca Balboni <luca.balboni10@studio.unibo.it>
 * 
 * REQRSP 64-bit to OBI 32-bit Protocol Converter
 * 
 */

module reqrsp64_to_obi32
  import obi_pkg::*;
#(
  parameter type reqrsp_req_t = logic,  // 64-bit reqrsp request type
  parameter type reqrsp_rsp_t = logic,  // 64-bit reqrsp response type
  parameter type obi_req_t    = logic,  // 32-bit OBI request type
  parameter type obi_rsp_t    = logic,  // 32-bit OBI response type
  parameter obi_pkg::obi_cfg_t ObiCfg = obi_pkg::ObiDefaultConfig
)(
  input  logic         clk_i,
  input  logic         rst_ni,
  
  // REQRSP side (64-bit from Snitch RV64)
  input  reqrsp_req_t  reqrsp_req_i,
  output reqrsp_rsp_t  reqrsp_rsp_o,
  
  // OBI side (32-bit to peripherals/L2)
  output obi_req_t     obi_req_o,
  input  obi_rsp_t     obi_rsp_i
);

  /*******************************************************************/
  /*            REQRSP64 → OBI32 Request Conversion                  */
  /*******************************************************************/
  // Determine if accessing upper or lower word based on strb
  logic upper_word_req;
  assign upper_word_req = |reqrsp_req_i.q.strb[7:4];
  
  // Select based on which half is being accessed
  logic [31:0] wdata_32bit;
  assign wdata_32bit = upper_word_req ? reqrsp_req_i.q.data[63:32] : reqrsp_req_i.q.data[31:0];
  
  logic [3:0] be_32bit;
  assign be_32bit = upper_word_req ? reqrsp_req_i.q.strb[7:4] : reqrsp_req_i.q.strb[3:0];
  
  // OBI Request signals
  assign obi_req_o.req                  = reqrsp_req_i.q_valid;
  assign obi_req_o.a.addr               = reqrsp_req_i.q.addr;
  assign obi_req_o.a.we                 = reqrsp_req_i.q.write;
  assign obi_req_o.a.wdata              = wdata_32bit;
  assign obi_req_o.a.be                 = be_32bit;
  assign obi_req_o.a.aid                = '0;
  assign obi_req_o.a.a_optional.auser   = '0;
  assign obi_req_o.a.a_optional.wuser   = '0;
  assign obi_req_o.a.a_optional.atop    = 6'h00;  // No atomics on this path
  assign obi_req_o.a.a_optional.memtype = 2'b00;
  assign obi_req_o.a.a_optional.mid     = '0;
  assign obi_req_o.a.a_optional.prot    = 3'b000;
  assign obi_req_o.a.a_optional.dbg     = 1'b0;
  assign obi_req_o.a.a_optional.achk    = '0;
  
  /*******************************************************************/
  /*            OBI32 → REQRSP64 Response Conversion                 */
  /*******************************************************************/
  
  // Response handshaking
  assign reqrsp_rsp_o.q_ready = obi_rsp_i.gnt;
  assign reqrsp_rsp_o.p_valid = obi_rsp_i.rvalid;
  
  // Track which word half was requested (for correct response data placement)
  logic [7:0] req_strb_q;
  
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      req_strb_q <= 8'h0;
    end else if (reqrsp_req_i.q_valid && obi_rsp_i.gnt) begin
      req_strb_q <= reqrsp_req_i.q.strb;
    end
  end
  
  // Data placement based on which half was requested:
  logic upper_word_access;
  assign upper_word_access = |req_strb_q[7:4];
  
  assign reqrsp_rsp_o.p.data = upper_word_access ? 
                                {obi_rsp_i.r.rdata, 32'h0000_0000} :  // Upper word → [63:32]
                                {32'h0000_0000, obi_rsp_i.r.rdata};   // Lower word → [31:0]
  
  // Error propagation
  assign reqrsp_rsp_o.p.error = obi_rsp_i.r.err;

endmodule : reqrsp64_to_obi32
