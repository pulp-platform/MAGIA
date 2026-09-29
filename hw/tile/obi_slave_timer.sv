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
 * OBI adapter of the PULP timer_unit: aligned 32-bit accesses only, no reference clock nor external start events
 */

module obi_slave_timer #(
  parameter type obi_req_t = logic,
  parameter type obi_rsp_t = logic
)(
  input  logic clk_i,
  input  logic rst_ni,
  input  obi_req_t obi_req_i,
  output obi_rsp_t obi_rsp_o,
  output logic irq_lo_o,
  output logic irq_hi_o
);
  localparam int unsigned IdWidth = $bits(obi_req_i.a.aid);
  logic valid_access, error_q, response_q;
  logic [IdWidth-1:0] id_q;
  logic [31:0] rdata;

  assign valid_access = (obi_req_i.a.addr[7:0] <= 8'h24) &&
                        (obi_req_i.a.addr[1:0] == 2'b00) &&
                        (!obi_req_i.a.we || (&obi_req_i.a.be));

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      response_q <= 1'b0;
      error_q <= 1'b0;
      id_q <= '0;
    end else begin
      response_q <= obi_req_i.req;
      error_q <= !valid_access;
      id_q <= obi_req_i.a.aid;
    end
  end

  always_comb begin
    obi_rsp_o = '0;
    obi_rsp_o.gnt = 1'b1;
    obi_rsp_o.rvalid = response_q;
    obi_rsp_o.r.rid = id_q;
    obi_rsp_o.r.err = error_q;
    obi_rsp_o.r.rdata = error_q ? '0 : rdata;
  end

  timer_unit #(.ID_WIDTH(IdWidth)) timer_unit_i (
    .clk_i,
    .rst_ni,
    .ref_clk_i (1'b0),
    .req_i (obi_req_i.req && valid_access),
    .addr_i (obi_req_i.a.addr),
    .wen_i (~obi_req_i.a.we),
    .wdata_i (obi_req_i.a.wdata),
    .be_i (obi_req_i.a.be),
    .id_i (obi_req_i.a.aid),
    .gnt_o (),
    .r_valid_o (),
    .r_opc_o (),
    .r_id_o (),
    .r_rdata_o (rdata),
    .event_lo_i (1'b0),
    .event_hi_i (1'b0),
    .irq_lo_o,
    .irq_hi_o,
    .busy_o ()
  );
endmodule
