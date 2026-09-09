// Copyright 2026 ETH Zurich, University of Bologna and Fondazione Chips-IT.
// SPDX-License-Identifier: SHL-0.51

// OBI adapter for the PULP timer. Register offsets and configuration bits are
// unchanged. Only aligned 32-bit accesses are supported: timer_unit ignores BE.
// No reference clock or external start events are provided by the tile.
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
