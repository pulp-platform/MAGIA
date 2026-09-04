/*
 * Copyright (C) 2026 ETH Zurich, University of Bologna and Fondazione Chips-IT
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
 * Authors: Luca Balboni <luca.balboni@chips.it>
 *
 * OBI Slave Control Register for the MAGIA tile HCI interconnect arbiters.
 *
 *   It controls BOTH arbitration points:
 *   - the WIDE arbiter_tree  (RedMulE vs the DMA channels)
 *   - the WIDE-vs-NARROW arbiter (accelerators vs cores)
 *
 *   ARB_CTRL  (offset 0x00, RW, reset 0x0000_0000)
 *     [0]      invert_prio              - 0: WIDE side keeps default priority
 *                                         1: swap - NARROW (cores) keeps default priority
 *     [15:8]   priority_cnt_numerator   - max consecutive low-priority stalls under a
 *                                         bank conflict
 *     [23:16]  priority_cnt_denominator - priority-counter clear threshold.
 *                                         0 => magia_hci_interconnect ignores the
 *                                         programmed ratio and forces a fair 1:2
 *                                         round-robin on both arbiters (reset behaviour).
 *     [31:24], [7:1]  reserved, read as 0
 */

module obi_slave_ctrl_hci
  import magia_tile_pkg::*;
  import hci_package::*;
#(
  parameter logic [31:0] BaseAddr = 32'h0000_17C0  // Base address for the HCI arbiter control register
) (
  input  logic                               clk_i,
  input  logic                               rst_ni,

  // OBI slave interface (control core)
  input  core_obi_data_req_t                 obi_req_i,
  output core_obi_data_rsp_t                 obi_rsp_o,

  // Arbiter control to magia_hci_interconnect
  output hci_package::hci_interconnect_ctrl_t ctrl_o
);

  // Register offsets
  localparam logic [3:0] ARB_CTRL_OFFSET = 4'h0;  // +0x00

  // Register
  logic [31:0] arb_ctrl_q, arb_ctrl_d;

  // Response pipeline
  logic        rvalid_q, rvalid_d;
  logic [31:0] rdata_q,  rdata_d;

  // Address decode (offset from base)
  logic [3:0] addr_offset;
  logic       addr_valid;

  assign addr_offset = obi_req_i.a.addr[3:0];
  assign addr_valid  = (obi_req_i.a.addr >= BaseAddr) &&
                       (obi_req_i.a.addr <  (BaseAddr + 32'd4));  // 1 register * 4 bytes

  assign obi_rsp_o.gnt          = obi_req_i.req && addr_valid;
  assign obi_rsp_o.rvalid       = rvalid_q;
  assign obi_rsp_o.r.rdata      = rdata_q;
  assign obi_rsp_o.r.rid        = '0;
  assign obi_rsp_o.r.err        = 1'b0;
  assign obi_rsp_o.r.r_optional = '0;

  // ============================================
  // Register write logic (combinational)
  // ============================================
  always_comb begin
    arb_ctrl_d = arb_ctrl_q;  // default: hold
    if (obi_req_i.req && obi_req_i.a.we && addr_valid) begin
      case (addr_offset)
        ARB_CTRL_OFFSET: arb_ctrl_d = obi_req_i.a.wdata;
        default: ;
      endcase
    end
  end

  // ============================================
  // Register sequential logic
  // ============================================
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) arb_ctrl_q <= 32'h0;  // reset => fair 1:2 RR on both HCI arbiters
    else         arb_ctrl_q <= arb_ctrl_d;
  end

  // ============================================
  // OBI read response logic (combinational)
  // ============================================
  always_comb begin
    rdata_d  = 32'h0;
    rvalid_d = obi_req_i.req && addr_valid;

    if (obi_req_i.req && !obi_req_i.a.we && addr_valid) begin
      case (addr_offset)
        ARB_CTRL_OFFSET: rdata_d = arb_ctrl_q;
        default:         rdata_d = 32'hDEAD_BEEF;
      endcase
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      rvalid_q <= 1'b0;
      rdata_q  <= 32'h0;
    end else begin
      rvalid_q <= rvalid_d;
      rdata_q  <= rdata_d;
    end
  end

  // ============================================
  // Struct view consumed by magia_hci_interconnect
  // ============================================
  assign ctrl_o = '{
    arb_policy:               2'b00,
    invert_prio:              arb_ctrl_q[0],
    priority_cnt_numerator:   arb_ctrl_q[15:8],
    priority_cnt_denominator: arb_ctrl_q[23:16]
  };

endmodule
