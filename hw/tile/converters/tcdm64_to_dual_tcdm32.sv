/*
 * Copyright (C) 2024 ETH Zurich and University of Bologna
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
 * Authors: Luca Balboni <luca.balboni10@studio.unibo.it>
 * 
 * TCDM 64-bit to Dual TCDM 32-bit Protocol Converter
 *
 */

module tcdm64_to_dual_tcdm32 #(
  parameter int unsigned FIFO_DEPTH = 4,  // Match Snitch's NUM_INT_OUTSTANDING_MEM
  parameter bit EnableSpill = 1'b1,
  parameter type tcdm64_req_t = logic,
  parameter type tcdm64_rsp_t = logic,
  parameter type tcdm32_req_t = logic,
  parameter type tcdm32_rsp_t = logic,
  // Local parameter matching fifo_v3 definition
  parameter int unsigned ADDR_DEPTH = (FIFO_DEPTH > 1) ? $clog2(FIFO_DEPTH) : 1
)(
  input  logic         clk_i,
  input  logic         rst_ni,
  
  input  tcdm64_req_t  tcdm_req_i,
  output tcdm64_rsp_t  tcdm_rsp_o,
  
  output tcdm32_req_t  tcdm_req_lo_o,
  input  tcdm32_rsp_t  tcdm_rsp_lo_i,
  output tcdm32_req_t  tcdm_req_hi_o,
  input  tcdm32_rsp_t  tcdm_rsp_hi_i
);

  /*******************************************************************/
  /*              Spill Register (Breaking Timing Loop)              */
  /*******************************************************************/
  
  // Internal 64-bit TCDM signals after spill register
  tcdm64_req_t tcdm_req_int;
  tcdm64_rsp_t tcdm_rsp_int;
  
  // Payload definitions for spill_register
  typedef struct packed {
    logic [31:0] addr;
    logic        write;
    reqrsp_pkg::amo_op_e amo;
    logic [63:0] data;
    logic [7:0]  strb;
    logic [31:0] user;
  } tcdm64_payload_t;
  
  tcdm64_payload_t payload_in, payload_out;
  
  // Pack input payload
  assign payload_in.addr  = tcdm_req_i.q.addr;
  assign payload_in.write = tcdm_req_i.q.write;
  assign payload_in.amo   = tcdm_req_i.q.amo;
  assign payload_in.data  = tcdm_req_i.q.data;
  assign payload_in.strb  = tcdm_req_i.q.strb;
  assign payload_in.user  = tcdm_req_i.q.user;
  
  // Unpack output payload
  assign tcdm_req_int.q.addr  = payload_out.addr;
  assign tcdm_req_int.q.write = payload_out.write;
  assign tcdm_req_int.q.amo   = payload_out.amo;
  assign tcdm_req_int.q.data  = payload_out.data;
  assign tcdm_req_int.q.strb  = payload_out.strb;
  assign tcdm_req_int.q.user  = payload_out.user;
  
  // Spill register instance
  spill_register #(
    .T      (tcdm64_payload_t),
    .Bypass (!EnableSpill    )
  ) i_req_spill_register (
    .clk_i   (clk_i                ),
    .rst_ni  (rst_ni               ),
    .valid_i (tcdm_req_i.q_valid   ),
    .ready_o (tcdm_rsp_o.q_ready   ),
    .data_i  (payload_in           ),
    .valid_o (tcdm_req_int.q_valid ),
    .ready_i (tcdm_rsp_int.q_ready ),
    .data_o  (payload_out          )
  );
  
  // Response path
  assign tcdm_rsp_o.p_valid = tcdm_rsp_int.p_valid;
  assign tcdm_rsp_o.p.data  = tcdm_rsp_int.p.data;

  /*******************************************************************/
  /*                  FIFO for Access Patterns                       */
  /*******************************************************************/
  
  // Request analysis (combinatorial)
  logic strb_is_zero, is_load, access_lo, access_hi;
  
  assign strb_is_zero = (tcdm_req_int.q.strb == 8'h00);
  assign is_load = !tcdm_req_int.q.write;
  assign access_lo = |tcdm_req_int.q.strb[3:0] || (strb_is_zero && is_load);
  assign access_hi = |tcdm_req_int.q.strb[7:4] || (strb_is_zero && is_load);
  
  // FIFO signals
  logic       fifo_full, fifo_empty;
  logic       fifo_push, fifo_pop;
  logic [1:0] fifo_wdata, fifo_rdata;
  logic [ADDR_DEPTH-1:0] fifo_usage;  // Match fifo_v3 usage_o width
  
  // FIFO push: when request is accepted 
  assign fifo_push = tcdm_req_int.q_valid && tcdm_rsp_int.q_ready;
  
  // FIFO pop: when response is sent
  assign fifo_pop = tcdm_rsp_int.p_valid;
  
  // FIFO data: {access_hi, access_lo}
  assign fifo_wdata = {access_hi, access_lo};
  
  // Instantiate common_cells FIFO
  fifo_v3 #(
    .FALL_THROUGH (1'b1       ),
    .DEPTH        (FIFO_DEPTH ),
    .DATA_WIDTH   (2          )
  ) i_access_pattern_fifo (
    .clk_i     (clk_i      ),
    .rst_ni    (rst_ni     ),
    .flush_i   (1'b0       ),
    .testmode_i(1'b0       ),
    .data_i    (fifo_wdata ),
    .push_i    (fifo_push  ),
    .full_o    (fifo_full  ),
    .data_o    (fifo_rdata ),
    .pop_i     (fifo_pop   ),
    .empty_o   (fifo_empty ),
    .usage_o   (fifo_usage )
  );
  
  // Read from FIFO (for response phase)
  logic access_lo_rsp, access_hi_rsp;
  assign {access_hi_rsp, access_lo_rsp} = fifo_rdata;
  
  /*******************************************************************/
  /*                   Response Generation                           */
  /*******************************************************************/
  
  logic rsp_arriving;
  always_comb begin
    rsp_arriving = 1'b0;
    
    if (!fifo_empty) begin
      if (access_lo_rsp && access_hi_rsp) begin
        rsp_arriving = tcdm_rsp_lo_i.p_valid && tcdm_rsp_hi_i.p_valid;
      end else if (access_lo_rsp) begin
        rsp_arriving = tcdm_rsp_lo_i.p_valid;
      end else if (access_hi_rsp) begin
        rsp_arriving = tcdm_rsp_hi_i.p_valid;
      end
    end
  end
  
  assign tcdm_rsp_int.p_valid = rsp_arriving;
  
  assign tcdm_rsp_int.p.data = {
    access_hi_rsp ? tcdm_rsp_hi_i.p.data : 32'h0,
    access_lo_rsp ? tcdm_rsp_lo_i.p.data : 32'h0
  };
  
  /*******************************************************************/
  /*                   Request Generation                            */
  /*******************************************************************/
  
  // Address generation
  logic [31:0] addr_base, addr_lo, addr_hi;
  assign addr_base = {tcdm_req_int.q.addr[31:3], 3'b000};
  assign addr_lo = addr_base;
  assign addr_hi = addr_base + 32'd4;
  
  // Lower bank request
  always_comb begin
    tcdm_req_lo_o.q_valid = 1'b0;
    tcdm_req_lo_o.q.addr  = '0;
    tcdm_req_lo_o.q.write = 1'b0;
    tcdm_req_lo_o.q.amo   = reqrsp_pkg::AMONone;
    tcdm_req_lo_o.q.data  = '0;
    tcdm_req_lo_o.q.strb  = '0;
    tcdm_req_lo_o.q.user  = '0;
    
    if (access_lo) begin
      tcdm_req_lo_o.q_valid = tcdm_req_int.q_valid;
      tcdm_req_lo_o.q.addr  = addr_lo;
      tcdm_req_lo_o.q.write = tcdm_req_int.q.write;
      tcdm_req_lo_o.q.amo   = tcdm_req_int.q.amo;
      tcdm_req_lo_o.q.data  = tcdm_req_int.q.data[31:0];
      tcdm_req_lo_o.q.user  = tcdm_req_int.q.user;
      
      if (strb_is_zero && is_load)
        tcdm_req_lo_o.q.strb = 4'hF;
      else
        tcdm_req_lo_o.q.strb = tcdm_req_int.q.strb[3:0];
    end
  end
  
  // Upper bank request
  always_comb begin
    tcdm_req_hi_o.q_valid = 1'b0;
    tcdm_req_hi_o.q.addr  = '0;
    tcdm_req_hi_o.q.write = 1'b0;
    tcdm_req_hi_o.q.amo   = reqrsp_pkg::AMONone;
    tcdm_req_hi_o.q.data  = '0;
    tcdm_req_hi_o.q.strb  = '0;
    tcdm_req_hi_o.q.user  = '0;
    
    if (access_hi) begin
      tcdm_req_hi_o.q_valid = tcdm_req_int.q_valid;
      tcdm_req_hi_o.q.addr  = addr_hi;
      tcdm_req_hi_o.q.write = tcdm_req_int.q.write;
      tcdm_req_hi_o.q.amo   = tcdm_req_int.q.amo;
      tcdm_req_hi_o.q.data  = tcdm_req_int.q.data[63:32];
      tcdm_req_hi_o.q.user  = tcdm_req_int.q.user;
      
      if (strb_is_zero && is_load)
        tcdm_req_hi_o.q.strb = 4'hF;
      else
        tcdm_req_hi_o.q.strb = tcdm_req_int.q.strb[7:4];
    end
  end
  
  /*******************************************************************/
  /*                   Ready Signal (Grant)                          */
  /*******************************************************************/
  
  always_comb begin
    tcdm_rsp_int.q_ready = 1'b0;
    
    // Block only if FIFO is full
    if (fifo_full) begin
      tcdm_rsp_int.q_ready = 1'b0;
    end else if (access_lo && access_hi) begin
      tcdm_rsp_int.q_ready = tcdm_rsp_lo_i.q_ready && tcdm_rsp_hi_i.q_ready;
    end else if (access_lo) begin
      tcdm_rsp_int.q_ready = tcdm_rsp_lo_i.q_ready;
    end else if (access_hi) begin
      tcdm_rsp_int.q_ready = tcdm_rsp_hi_i.q_ready;
    end else if (strb_is_zero && !is_load) begin
      tcdm_rsp_int.q_ready = 1'b1;
    end
  end

endmodule : tcdm64_to_dual_tcdm32
