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
 * Core Instruction - OBI REQ/RSP Converter
 */

module instr2obi_req 
  import redmule_tile_pkg::*;
(
  input  redmule_tile_pkg::core_instr_req_t     instr_req_i,
  output redmule_tile_pkg::core_obi_instr_req_t obi_req_o
);

  assign obi_req_o.req                  = instr_req_i.req;
  assign obi_req_o.a.addr               = instr_req_i.addr;
  assign obi_req_o.a.we                 = 1'b0;
  assign obi_req_o.a.be                 = 4'hF;
  assign obi_req_o.a.wdata              = 32'h0;
  assign obi_req_o.a.aid                = 'b0;
  assign obi_req_o.a.a_optional.auser   = 'b0;
  assign obi_req_o.a.a_optional.wuser   = 'b0;
  assign obi_req_o.a.a_optional.atop    = 6'h0;
  assign obi_req_o.a.a_optional.memtype = instr_req_i.memtype;
  assign obi_req_o.a.a_optional.mid     = 'b0;
  assign obi_req_o.a.a_optional.prot    = instr_req_i.prot;
  assign obi_req_o.a.a_optional.dbg     = instr_req_i.dbg;
  assign obi_req_o.a.a_optional.achk    = 'b0;

endmodule: instr2obi_req

module obi2instr_rsp 
  import redmule_tile_pkg::*;
(
  input  redmule_tile_pkg::core_obi_instr_rsp_t obi_rsp_i,
  output redmule_tile_pkg::core_instr_rsp_t     instr_rsp_o
);

  assign instr_rsp_o.gnt    = obi_rsp_i.gnt;
  assign instr_rsp_o.rvalid = obi_rsp_i.rvalid;
  assign instr_rsp_o.rdata  = obi_rsp_i.r.rdata;
  assign instr_rsp_o.err    = obi_rsp_i.r.err;

endmodule: obi2instr_rsp