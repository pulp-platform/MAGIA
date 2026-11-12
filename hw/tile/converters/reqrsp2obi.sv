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
 * Convert reqrsp to OBI protocol - Direct conversion without AXI intermediate step
 */

module reqrsp2obi
  import reqrsp_pkg::*;
#(
  parameter obi_pkg::obi_cfg_t ObiCfg = obi_pkg::ObiDefaultConfig
) (
  input  logic                               clk_i,
  input  logic                               rst_ni,

  input  magia_tile_pkg::spatz_reqrsp_req_t  reqrsp_req_i,
  output magia_tile_pkg::spatz_reqrsp_rsp_t  reqrsp_rsp_o,

  output magia_tile_pkg::core_obi_data_req_t obi_req_o,
  input  magia_tile_pkg::core_obi_data_rsp_t obi_rsp_i
);

  /*******************************************************************/
  /*               Direct reqrsp → OBI conversion                    */
  /*******************************************************************/

  assign obi_req_o.req                  = reqrsp_req_i.q_valid;
  assign obi_req_o.a.addr               = reqrsp_req_i.q.addr;
  assign obi_req_o.a.we                 = reqrsp_req_i.q.write | magia_tile_pkg::amo_writes(reqrsp_req_i.q.amo);
  assign obi_req_o.a.wdata              = reqrsp_req_i.q.data;
  assign obi_req_o.a.be                 = reqrsp_req_i.q.strb;
  assign obi_req_o.a.aid                = '0;
  
  // Optional request fields
  assign obi_req_o.a.a_optional.auser   = '0;
  assign obi_req_o.a.a_optional.wuser   = '0;
  assign obi_req_o.a.a_optional.atop    = magia_tile_pkg::amo_to_atop(reqrsp_req_i.q.amo);
  assign obi_req_o.a.a_optional.memtype = 2'b00;
  assign obi_req_o.a.a_optional.mid     = '0;
  assign obi_req_o.a.a_optional.prot    = 3'b000;
  assign obi_req_o.a.a_optional.dbg     = 1'b0;
  assign obi_req_o.a.a_optional.achk    = '0;

  // OBI → reqrsp Response
  assign reqrsp_rsp_o.q_ready = obi_rsp_i.gnt;
  assign reqrsp_rsp_o.p_valid = obi_rsp_i.rvalid;
  assign reqrsp_rsp_o.p.data  = obi_rsp_i.r.rdata;
  assign reqrsp_rsp_o.p.error = obi_rsp_i.r.err;

endmodule

