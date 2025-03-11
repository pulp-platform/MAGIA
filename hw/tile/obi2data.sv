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
 * OBI - Core Data REQ/RSP Converter
 */

module obi2data_rsp 
  import magia_tile_pkg::*;
(
  input  magia_tile_pkg::core_obi_data_rsp_t obi_rsp_i,
  output magia_tile_pkg::core_data_rsp_t     data_rsp_o
);

  assign data_rsp_o.gnt    = obi_rsp_i.gnt;
  assign data_rsp_o.rvalid = obi_rsp_i.rvalid;
  assign data_rsp_o.rdata  = obi_rsp_i.r.rdata;
  assign data_rsp_o.err    = obi_rsp_i.r.err;
  assign data_rsp_o.exokay = obi_rsp_i.r.r_optional.exokay;

endmodule: obi2data_rsp