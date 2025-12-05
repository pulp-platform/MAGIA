// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51


module tcdm2reqrsp #(
  parameter int unsigned AddrWidth  = 32,
  parameter int unsigned DataWidth  = 32,
  parameter type tcdm_req_t = logic,
  parameter type tcdm_rsp_t = logic,
  parameter type reqrsp_req_t = logic,
  parameter type reqrsp_rsp_t = logic
) (
  input  tcdm_req_t   tcdm_req_i,
  output tcdm_rsp_t   tcdm_rsp_o,
  output reqrsp_req_t reqrsp_req_o,
  input  reqrsp_rsp_t reqrsp_rsp_i
);

  assign reqrsp_req_o.q.addr  = tcdm_req_i.q.addr;
  assign reqrsp_req_o.q.write = tcdm_req_i.q.write;
  assign reqrsp_req_o.q.amo   = tcdm_req_i.q.amo;
  assign reqrsp_req_o.q.data  = tcdm_req_i.q.data;
  assign reqrsp_req_o.q.strb  = tcdm_req_i.q.strb;
  assign reqrsp_req_o.q.size  = 3'b010;
  assign reqrsp_req_o.q_valid = tcdm_req_i.q_valid;
  assign reqrsp_req_o.p_ready = 1'b1;
  
  assign tcdm_rsp_o.q_ready = reqrsp_rsp_i.q_ready;
  assign tcdm_rsp_o.p.data  = reqrsp_rsp_i.p.data;
  assign tcdm_rsp_o.p_valid = reqrsp_rsp_i.p_valid;

endmodule
