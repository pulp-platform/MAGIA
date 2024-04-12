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
 * OBI - HCI REQ/RSP Converter
 */

module obi2hci_req
  import redmule_tile_pkg::*;
(
  input  redmule_tile_pkg::core_obi_data_req_t obi_req_i,
  output redmule_tile_pkg::core_hci_data_req_t hci_req_o
);

  assign hci_req_o.req   = obi_req_i.req;
  assign hci_req_o.add   = obi_req_i.a.addr;
  assign hci_req_o.wen   = ~obi_req_i.a.we;
  assign hci_req_o.data  = obi_req_i.a.wdata;
  assign hci_req_o.be    = obi_req_i.a.be;
  assign hci_req_o.boffs = '0;
  assign hci_req_o.lrdy  = 1'b1;
  assign hci_req_o.user  = '0;

endmodule: obi2hci_req

module hci2obi_rsp
  import redmule_tile_pkg::*;
(
  input  redmule_tile_pkg::core_hci_data_rsp_t hci_rsp_i,
  output redmule_tile_pkg::core_obi_data_rsp_t obi_rsp_o
);

  assign obi_rsp_o.gnt                 = hci_rsp_i.gnt;
  assign obi_rsp_o.rvalid              = hci_rsp_i.r_valid;
  assign obi_rsp_o.r.rdata             = hci_rsp_i.r_data;
  assign obi_rsp_o.r.rid               = '0;
  assign obi_rsp_o.r.err               = 1'b0;
  assign obi_rsp_o.r.r_optional.ruser  = 'b0;
  assign obi_rsp_o.r.r_optional.exokay = 1'b0;
  assign obi_rsp_o.r.r_optional.rchk   = 'b0;

endmodule: hci2obi_rsp