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
 * Core Instruction - I$ REQ/RSP Converter
 */

module instr2cache_req 
  import redmule_tile_pkg::*;
(
  input  redmule_tile_pkg::core_instr_req_t       instr_req_i,
  output redmule_tile_pkg::core_cache_instr_req_t cache_req_o
);
  
  assign cache_req_o.addr      = instr_req_i.addr;
  assign cache_req_o.cacheable = 1'b1 /*instr_req_i.memtype[1]*/;
  assign cache_req_o.valid     = instr_req_i.req;

endmodule: instr2cache_req

module cache2instr_rsp 
  import redmule_tile_pkg::*;
(
  input  redmule_tile_pkg::core_cache_instr_rsp_t cache_rsp_i,
  output redmule_tile_pkg::core_instr_rsp_t       instr_rsp_o
);

  assign instr_rsp_o.gnt    = cache_rsp_i.ready;
  assign instr_rsp_o.rvalid = cache_rsp_i.ready;
  assign instr_rsp_o.rdata  = cache_rsp_i.data;
  assign instr_rsp_o.err    = cache_rsp_i.error;

endmodule: cache2instr_rsp