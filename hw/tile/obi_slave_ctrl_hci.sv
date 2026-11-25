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
 * Author: Luca Balboni, Fondazione Chips-IT
 *
 * Control registers of the HCI arbiters: the wide-vs-narrow one and every node of the wide tree
 *
 *   ARB_CTRL[a] (offset 4*a, RW, reset 0, byte enables honoured), a < NumArb
 *     a = 0: wide-vs-narrow arbiter, the last stage before the L1 banks
 *     a > 0: wide tree node a-1, see magia_hci_arbiter_tree for the numbering
 *     [0]     invert_prio              - 0: in_high side wins (wide, lower leaves), 1: in_low
 *     [15:8]  priority_cnt_numerator   - conflict cycles the higher side wins per window, 0: strict
 *     [23:16] priority_cnt_denominator - conflict cycles per window, 0 selects the default ratio
 *
 *   Any other offset of the window answers with an OBI error
 */

module obi_slave_ctrl_hci
  import magia_tile_pkg::*;
#(
  parameter logic [31:0] BaseAddr = magia_tile_pkg::HCI_CTRL_ADDR_START,
  parameter int unsigned NumArb   = 1
) (
  input  logic                                clk_i,
  input  logic                                rst_ni,

  input  core_obi_data_req_t                  obi_req_i,
  output core_obi_data_rsp_t                  obi_rsp_o,

  output hci_package::hci_interconnect_ctrl_t ctrl_o [NumArb]  // To magia_hci_interconnect
);

  localparam int unsigned IdxW = gen_idx_width(NumArb);

  if (NumArb * 4 > HCI_CTRL_SIZE) begin : gen_window_error
    $fatal(1, "obi_slave_ctrl_hci: NumArb registers do not fit in HCI_CTRL_SIZE");
  end

  logic [29:0]             word_off;  // From BaseAddr, in 32-bit words
  logic                    arb_ctrl_sel;
  logic [IdxW-1:0]         arb_idx;
  logic [31:0]             arb_ctrl_wdata;  // Selected word with the written bytes merged in
  logic [NumArb-1:0]       arb_ctrl_we;
  logic [31:0]             arb_ctrl_q [NumArb];

  logic        rvalid_d, rvalid_q;
  logic        err_d,    err_q;
  logic [31:0] rdata_d,  rdata_q;

  // Every request of the window is granted: a wrong offset faults instead of hanging
  assign word_off     = obi_req_i.a.addr[31:2] - BaseAddr[31:2];
  assign arb_ctrl_sel = (word_off < 30'(NumArb));
  assign arb_idx      = word_off[IdxW-1:0];
  assign rvalid_d     = obi_req_i.req;
  assign err_d        = obi_req_i.req & ~arb_ctrl_sel;

  always_comb begin
    rdata_d        = 32'h0;
    arb_ctrl_wdata = 32'h0;
    if (arb_ctrl_sel) begin
      arb_ctrl_wdata = arb_ctrl_q[arb_idx];
      if (obi_req_i.req & ~obi_req_i.a.we) begin
        rdata_d = arb_ctrl_q[arb_idx];
      end
    end
    for (int unsigned b = 0; b < 4; b++) begin
      if (obi_req_i.a.be[b]) begin
        arb_ctrl_wdata[8*b +: 8] = obi_req_i.a.wdata[8*b +: 8];
      end
    end
  end

  for (genvar a = 0; a < NumArb; a++) begin : gen_arb_ctrl
    assign arb_ctrl_we[a] = obi_req_i.req & obi_req_i.a.we & arb_ctrl_sel & (arb_idx == IdxW'(a));

    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        arb_ctrl_q[a] <= 32'h0;  // magia_hci_interconnect falls back to its default ratio
      end else if (arb_ctrl_we[a]) begin
        arb_ctrl_q[a] <= arb_ctrl_wdata;
      end
    end

    assign ctrl_o[a] = '{
      arb_policy:               2'b00,
      invert_prio:              arb_ctrl_q[a][0],
      priority_cnt_numerator:   arb_ctrl_q[a][15:8],
      priority_cnt_denominator: arb_ctrl_q[a][23:16]
    };
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

endmodule : obi_slave_ctrl_hci
