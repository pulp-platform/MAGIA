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

module obi2hci_req #(
  parameter type obi_req_t = logic,
  parameter type hci_req_t = logic
)(
  input  obi_req_t obi_req_i,
  output hci_req_t hci_req_o
);

  assign hci_req_o.req  = obi_req_i.req;
  assign hci_req_o.add  = obi_req_i.a.addr;
  assign hci_req_o.wen  = ~obi_req_i.a.we;
  assign hci_req_o.data = obi_req_i.a.wdata;
  assign hci_req_o.be   = obi_req_i.a.be;
  assign hci_req_o.user = '0;
  assign hci_req_o.id   = '0;
  assign hci_req_o.ecc  = '0;
  assign hci_req_o.ereq = '0;
  assign hci_req_o.r_ready = 1'b1;
  assign hci_req_o.r_eready = '1;

endmodule: obi2hci_req
