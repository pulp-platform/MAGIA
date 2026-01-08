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
 * Authors: Luca Balboni <luca.balboni10@studio.unibo.it>
 * 
 * TCDM to OBI Protocol Converter - Combinatorial conversion
 *
 */

module tcdm2obi
  import reqrsp_pkg::*;
#(
  parameter type tcdm_req_t = logic,
  parameter type tcdm_rsp_t = logic,
  parameter type obi_req_t  = logic,
  parameter type obi_rsp_t  = logic
)(
  input  logic       clk_i,
  input  logic       rst_ni,
  
  input  tcdm_req_t  tcdm_req_i,
  output tcdm_rsp_t  tcdm_rsp_o,
  
  output obi_req_t   obi_req_o,
  input  obi_rsp_t   obi_rsp_i
);

  // Convert TCDM AMO to OBI ATOP encoding
  function automatic logic [5:0] amo_to_atop(reqrsp_pkg::amo_op_e amo);
    case (amo)
      reqrsp_pkg::AMONone:  return 6'h00;  // ATOPNONE
      reqrsp_pkg::AMOSwap:  return 6'h21;  // AMOSWAP
      reqrsp_pkg::AMOAdd:   return 6'h20;  // AMOADD
      reqrsp_pkg::AMOAnd:   return 6'h2C;  // AMOAND
      reqrsp_pkg::AMOOr:    return 6'h28;  // AMOOR
      reqrsp_pkg::AMOXor:   return 6'h24;  // AMOXOR
      reqrsp_pkg::AMOMax:   return 6'h34;  // AMOMAX (signed)
      reqrsp_pkg::AMOMaxu:  return 6'h3C;  // AMOMAXU (unsigned)
      reqrsp_pkg::AMOMin:   return 6'h30;  // AMOMIN (signed)
      reqrsp_pkg::AMOMinu:  return 6'h38;  // AMOMINU (unsigned)
      reqrsp_pkg::AMOLR:    return 6'h22;  // ATOPLR (Load-Reserved)
      reqrsp_pkg::AMOSC:    return 6'h23;  // ATOPSC (Store-Conditional)
      default:              return 6'h00;  // Safe default: ATOPNONE
    endcase
  endfunction

  logic amo_detected;
  assign amo_detected = (tcdm_req_i.q.amo != reqrsp_pkg::AMONone);

  // TCDM → OBI Request (combinatorial)
  assign obi_req_o.req                  = tcdm_req_i.q_valid;
  assign obi_req_o.a.addr               = tcdm_req_i.q.addr;
  assign obi_req_o.a.we                 = tcdm_req_i.q.write || amo_detected;
  assign obi_req_o.a.wdata              = tcdm_req_i.q.data;
  assign obi_req_o.a.be                 = tcdm_req_i.q.strb;
  assign obi_req_o.a.aid                = '0;
  assign obi_req_o.a.a_optional.auser   = '0;
  assign obi_req_o.a.a_optional.wuser   = '0;
  assign obi_req_o.a.a_optional.atop    = amo_to_atop(tcdm_req_i.q.amo);
  assign obi_req_o.a.a_optional.memtype = 2'b00;
  assign obi_req_o.a.a_optional.mid     = '0;
  assign obi_req_o.a.a_optional.prot    = 3'b000;
  assign obi_req_o.a.a_optional.dbg     = 1'b0;
  assign obi_req_o.a.a_optional.achk    = '0;
  
  // OBI → TCDM Response
  assign tcdm_rsp_o.q_ready = obi_rsp_i.gnt;
  assign tcdm_rsp_o.p_valid = obi_rsp_i.rvalid;
  assign tcdm_rsp_o.p.data  = obi_rsp_i.r.rdata;

endmodule : tcdm2obi
