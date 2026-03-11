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
  parameter type tcdm64_req_t = logic,  // 64-bit TCDM request type
  parameter type tcdm64_rsp_t = logic,  // 64-bit TCDM response type
  parameter type tcdm32_req_t = logic,  // 32-bit TCDM request type
  parameter type tcdm32_rsp_t = logic   // 32-bit TCDM response type
)(
  input  logic         clk_i,
  input  logic         rst_ni,
  
  // TCDM 64-bit side (Snitch data port)
  input  tcdm64_req_t  tcdm_req_i,
  output tcdm64_rsp_t  tcdm_rsp_o,
  
  // TCDM 32-bit side (Two parallel TCDM ports)
  output tcdm32_req_t  tcdm_req_lo_o,  // Lower 32-bit word (bits [31:0])
  input  tcdm32_rsp_t  tcdm_rsp_lo_i,
  output tcdm32_req_t  tcdm_req_hi_o,  // Upper 32-bit word (bits [63:32])
  input  tcdm32_rsp_t  tcdm_rsp_hi_i
);

  /*******************************************************************/
  /*   TCDM64 → Dual TCDM32: Minimal State (2 Registers Only)       */
  /*******************************************************************/
  
  // Request analysis signals
  logic strb_is_zero;
  logic is_load;
  logic access_lo, access_hi;
  
  // Decode request type
  assign strb_is_zero = (tcdm_req_i.q.strb == 8'h00);
  assign is_load = !tcdm_req_i.q.write;
  
  // Determine which banks to access:
  // - Normal operation: access banks based on strobe bits
  // - Load with strb=0: access BOTH banks (full 64-bit read)
  // - Store with strb=0: access NO banks (no-op)
  assign access_lo = |tcdm_req_i.q.strb[3:0] || (strb_is_zero && is_load);
  assign access_hi = |tcdm_req_i.q.strb[7:4] || (strb_is_zero && is_load);
  
  logic access_lo_q, access_hi_q;
  
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      access_lo_q <= 1'b0;
      access_hi_q <= 1'b0;
    end else if (tcdm_req_i.q_valid && tcdm_rsp_o.q_ready) begin
      // Latch access pattern for all requests
      // For loads with strb=0, this will be both banks (full read)
      access_lo_q <= access_lo;
      access_hi_q <= access_hi;
    end
  end
  
  // Response arrives when BOTH accessed banks have responded
  logic rsp_arriving;
  always_comb begin
    rsp_arriving = 1'b0;
    
    if (access_lo_q && access_hi_q) begin
      rsp_arriving = tcdm_rsp_lo_i.p_valid && tcdm_rsp_hi_i.p_valid;
    end else if (access_lo_q) begin
      rsp_arriving = tcdm_rsp_lo_i.p_valid;
    end else if (access_hi_q) begin
      rsp_arriving = tcdm_rsp_hi_i.p_valid;
    end
  end
  
  // Address generation for dual banks
  logic [31:0] addr_base;
  logic [31:0] addr_lo, addr_hi;
  
  assign addr_base = {tcdm_req_i.q.addr[31:3], 3'b000};  // Align to 8-byte boundary
  assign addr_lo = addr_base;                             // Lower 32-bit word [31:0]
  assign addr_hi = addr_base + 32'd4;                     // Upper 32-bit word [63:32]
  
  /*******************************************************************/
  /*                  TCDM32 Request Outputs                         */
  /*******************************************************************/
  
  // Lower bank (LO) request generation
  always_comb begin
    tcdm_req_lo_o.q_valid = 1'b0;
    tcdm_req_lo_o.q.addr  = '0;
    tcdm_req_lo_o.q.write = 1'b0;
    tcdm_req_lo_o.q.amo   = reqrsp_pkg::AMONone;
    tcdm_req_lo_o.q.data  = '0;
    tcdm_req_lo_o.q.strb  = '0;
    tcdm_req_lo_o.q.user  = '0;
    
    if (access_lo) begin
      tcdm_req_lo_o.q_valid = tcdm_req_i.q_valid;
      tcdm_req_lo_o.q.addr  = addr_lo;
      tcdm_req_lo_o.q.write = tcdm_req_i.q.write;
      tcdm_req_lo_o.q.amo   = tcdm_req_i.q.amo;
      tcdm_req_lo_o.q.data  = tcdm_req_i.q.data[31:0];
      tcdm_req_lo_o.q.user  = tcdm_req_i.q.user;
      
      // Strobe handling: load with strb=0 reads full 32-bit word
      if (strb_is_zero && is_load)
        tcdm_req_lo_o.q.strb = 4'hF;
      else
        tcdm_req_lo_o.q.strb = tcdm_req_i.q.strb[3:0];
    end
  end
  
  // Upper bank (HI) request generation
  always_comb begin
    tcdm_req_hi_o.q_valid = 1'b0;
    tcdm_req_hi_o.q.addr  = '0;
    tcdm_req_hi_o.q.write = 1'b0;
    tcdm_req_hi_o.q.amo   = reqrsp_pkg::AMONone;
    tcdm_req_hi_o.q.data  = '0;
    tcdm_req_hi_o.q.strb  = '0;
    tcdm_req_hi_o.q.user  = '0;
    
    if (access_hi) begin
      tcdm_req_hi_o.q_valid = tcdm_req_i.q_valid;
      tcdm_req_hi_o.q.addr  = addr_hi;
      tcdm_req_hi_o.q.write = tcdm_req_i.q.write;
      tcdm_req_hi_o.q.amo   = tcdm_req_i.q.amo;
      tcdm_req_hi_o.q.data  = tcdm_req_i.q.data[63:32];
      tcdm_req_hi_o.q.user  = tcdm_req_i.q.user;
      
      // Strobe handling: load with strb=0 reads full 32-bit word
      if (strb_is_zero && is_load)
        tcdm_req_hi_o.q.strb = 4'hF;
      else
        tcdm_req_hi_o.q.strb = tcdm_req_i.q.strb[7:4];
    end
  end
  
  /*******************************************************************/
  /*              TCDM64 Response & Grant                            */
  /*******************************************************************/
  
  // Ready signal: accept request when target banks are ready
  always_comb begin
    tcdm_rsp_o.q_ready = 1'b0;
    
    if (access_lo && access_hi) begin
      // Both banks accessed: need both ready
      tcdm_rsp_o.q_ready = tcdm_rsp_lo_i.q_ready && tcdm_rsp_hi_i.q_ready;
    end else if (access_lo) begin
      // Only LO bank accessed
      tcdm_rsp_o.q_ready = tcdm_rsp_lo_i.q_ready;
    end else if (access_hi) begin
      // Only HI bank accessed
      tcdm_rsp_o.q_ready = tcdm_rsp_hi_i.q_ready;
    end else if (strb_is_zero && !is_load) begin
      // Store with strb=0: no memory access needed, accept immediately
      tcdm_rsp_o.q_ready = 1'b1;
    end
  end
  
  // Response valid: asserted when all accessed banks have responded
  assign tcdm_rsp_o.p_valid = rsp_arriving;
  
  // Response data: recombine 32-bit responses into 64-bit word
  // Uses registered access pattern to handle asynchronous bank responses
  assign tcdm_rsp_o.p.data = {
    access_hi_q ? tcdm_rsp_hi_i.p.data : 32'h0,
    access_lo_q ? tcdm_rsp_lo_i.p.data : 32'h0
  };

endmodule : tcdm64_to_dual_tcdm32
