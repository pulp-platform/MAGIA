/*
 * Copyright (C) 2023-2024 ETH Zurich and University of Bologna
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
 * Authors: Victor Isachi <victor.isachi@unibo.it>
 * 
 * HCI - OBI REQ/RSP Converter
 */

module hci2obi_rsp #(
  parameter type hci_rsp_t = magia_tile_pkg::core_hci_data_rsp_t,
  parameter type obi_rsp_t = magia_tile_pkg::core_obi_data_rsp_t
)(
  input  hci_rsp_t hci_rsp_i,
  output obi_rsp_t obi_rsp_o
);

  // Default zero covers the parity fields of integrity OBI types
  always_comb begin
    obi_rsp_o         = '0;
    obi_rsp_o.gnt     = hci_rsp_i.gnt;
    obi_rsp_o.rvalid  = hci_rsp_i.r_valid;
    obi_rsp_o.r.rdata = hci_rsp_i.r_data;
    obi_rsp_o.r.rid   = hci_rsp_i.r_id[$bits(obi_rsp_o.r.rid)-1:0];  // Only the low ID bits travel back on OBI
    obi_rsp_o.r.err   = hci_rsp_i.r_opc;
  end

endmodule: hci2obi_rsp
