// Copyright 2024 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// TCDM to HCI protocol converter without AMO support


module tcdm2hci #(
  parameter int unsigned MaxPending = 4,
  parameter type tcdm_req_t = logic,
  parameter type tcdm_rsp_t = logic,
  parameter type hci_req_t  = logic,
  parameter type hci_rsp_t  = logic
) (
  input  logic      clk_i,
  input  logic      rst_ni,
  input  tcdm_req_t tcdm_req_i,
  output tcdm_rsp_t tcdm_rsp_o,
  output hci_req_t  hci_req_o,
  input  hci_rsp_t  hci_rsp_i
);

  localparam int unsigned CounterWidth = $clog2(MaxPending + 1);
  logic [CounterWidth-1:0] pending_cnt_d, pending_cnt_q;
  
  logic accept_req, recv_rsp;
  
  assign accept_req = tcdm_req_i.q_valid && tcdm_rsp_o.q_ready;
  assign recv_rsp   = hci_rsp_i.r_valid;
  
  // Request path
  assign hci_req_o.req   = tcdm_req_i.q_valid;
  assign hci_req_o.add   = tcdm_req_i.q.addr;
  assign hci_req_o.wen   = ~tcdm_req_i.q.write;  // Inverted polarity
  assign hci_req_o.data  = tcdm_req_i.q.data;
  assign hci_req_o.be    = tcdm_req_i.q.strb;
  assign hci_req_o.boffs = '0;
  assign hci_req_o.lrdy  = 1'b1;
  assign hci_req_o.user  = '0;
  
  assign tcdm_rsp_o.q_ready = hci_rsp_i.gnt && (pending_cnt_q < MaxPending);
  
  // Response path
  assign tcdm_rsp_o.p_valid = hci_rsp_i.r_valid;
  assign tcdm_rsp_o.p.data  = hci_rsp_i.r_data;
  
  // Counter update
  always_comb begin
    pending_cnt_d = pending_cnt_q;
    case ({accept_req, recv_rsp})
      2'b10: pending_cnt_d = pending_cnt_q + 1'b1;
      2'b01: pending_cnt_d = pending_cnt_q - 1'b1;
      default: pending_cnt_d = pending_cnt_q;
    endcase
  end
  
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) pending_cnt_q <= '0;
    else         pending_cnt_q <= pending_cnt_d;
  end

endmodule : tcdm2hci
