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
 * Author: Luca Balboni <luca.balboni@chips.it>
 *
 * Control register of the HCI wide-vs-narrow arbiter, the last stage before the L1 banks
 *
 *   ARB_CTRL (offset 0x00, RW, reset 0, byte enables honoured)
 *     [0]     invert_prio              - 0: wide ports on the higher side, 1: narrow ports
 *     [15:8]  priority_cnt_numerator   - conflict cycles the higher side wins per window, 0: strict
 *     [23:16] priority_cnt_denominator - conflict cycles per window, 0 selects the default ratio
 *
 *   Any other offset of the window answers with an OBI error
 */

module obi_slave_ctrl_hci
  import magia_tile_pkg::*;
#(
  parameter logic [31:0] BaseAddr = magia_tile_pkg::HCI_CTRL_ADDR_START
) (
  input  logic                                clk_i,
  input  logic                                rst_ni,

  input  core_obi_data_req_t                  obi_req_i,
  output core_obi_data_rsp_t                  obi_rsp_o,

  output hci_package::hci_interconnect_ctrl_t ctrl_o  // To magia_hci_interconnect
);

  logic        arb_ctrl_sel;  // Access to the ARB_CTRL word
  logic        arb_ctrl_we;
  logic [31:0] arb_ctrl_d, arb_ctrl_q;

  logic        rvalid_d, rvalid_q;
  logic        err_d,    err_q;
  logic [31:0] rdata_d,  rdata_q;

  // Every request of the window is granted: a wrong offset faults instead of hanging
  assign arb_ctrl_sel = (obi_req_i.a.addr[31:2] == BaseAddr[31:2]);
  assign arb_ctrl_we  = obi_req_i.req & obi_req_i.a.we & arb_ctrl_sel;
  assign rvalid_d     = obi_req_i.req;
  assign err_d        = obi_req_i.req & ~arb_ctrl_sel;
  assign rdata_d      = (obi_req_i.req & ~obi_req_i.a.we & arb_ctrl_sel) ? arb_ctrl_q : 32'h0;

  always_comb begin
    arb_ctrl_d = arb_ctrl_q;
    for (int unsigned b = 0; b < 4; b++) begin
      if (obi_req_i.a.be[b]) begin
        arb_ctrl_d[8*b +: 8] = obi_req_i.a.wdata[8*b +: 8];
      end
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      arb_ctrl_q <= 32'h0;  // magia_hci_interconnect falls back to its default ratio
    end else if (arb_ctrl_we) begin
      arb_ctrl_q <= arb_ctrl_d;
    end
  end

  // Response, one cycle after the grant
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      rvalid_q <= 1'b0;
      err_q    <= 1'b0;
      rdata_q  <= 32'h0;
    end else begin
      rvalid_q <= rvalid_d;
      err_q    <= err_d;
      rdata_q  <= rdata_d;
    end
  end

  assign obi_rsp_o.gnt          = rvalid_d;
  assign obi_rsp_o.rvalid       = rvalid_q;
  assign obi_rsp_o.r.rdata      = rdata_q;
  assign obi_rsp_o.r.rid        = '0;
  assign obi_rsp_o.r.err        = err_q;
  assign obi_rsp_o.r.r_optional = '0;

  assign ctrl_o = '{
    arb_policy:               2'b00,
    invert_prio:              arb_ctrl_q[0],
    priority_cnt_numerator:   arb_ctrl_q[15:8],
    priority_cnt_denominator: arb_ctrl_q[23:16]
  };

endmodule : obi_slave_ctrl_hci
