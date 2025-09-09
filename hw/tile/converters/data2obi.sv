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
 * Core Data - OBI REQ/RSP Converter
 */

module data2obi_req 
  import magia_tile_pkg::*;
(
  input  magia_tile_pkg::core_data_req_t     data_req_i,
  output magia_tile_pkg::core_obi_data_req_t obi_req_o
);

  assign obi_req_o.req                  = data_req_i.req;
  assign obi_req_o.a.addr               = data_req_i.addr;
  assign obi_req_o.a.we                 = data_req_i.we;
  assign obi_req_o.a.be                 = data_req_i.be;
  assign obi_req_o.a.wdata              = data_req_i.wdata;
  assign obi_req_o.a.aid                = 'b0;
  assign obi_req_o.a.a_optional.auser   = 'b0;
  assign obi_req_o.a.a_optional.wuser   = 'b0;
  assign obi_req_o.a.a_optional.atop    = data_req_i.atop;
  assign obi_req_o.a.a_optional.memtype = data_req_i.memtype;
  assign obi_req_o.a.a_optional.mid     = 'b0;
  assign obi_req_o.a.a_optional.prot    = data_req_i.prot;
  assign obi_req_o.a.a_optional.dbg     = data_req_i.dbg;
  assign obi_req_o.a.a_optional.achk    = 'b0;

endmodule: data2obi_req
