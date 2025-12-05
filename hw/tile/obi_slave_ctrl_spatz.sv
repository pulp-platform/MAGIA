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
 * OBI Slave Control Registers for Spatz Core Complex
 *
 */

module obi_slave_ctrl_spatz
  import magia_tile_pkg::*;
#(
  parameter logic [31:0] BaseAddr  = 32'h00001700  // Base address for control registers
) (
  input  logic              clk_i,
  input  logic              rst_ni,
  
  // OBI slave interface
  input  core_obi_data_req_t    obi_req_i,
  output core_obi_data_rsp_t    obi_rsp_o,
  
  // Control outputs
  output logic              clk_en_o,
  output logic              start_o,
  output logic              done_o
);

  // Register offsets
  localparam logic [3:0] CLK_EN_OFFSET   = 4'h0;  // +0x00
  localparam logic [3:0] FUNC_PTR_OFFSET = 4'h4;  // +0x04
  localparam logic [3:0] START_OFFSET    = 4'h8;  // +0x08
  localparam logic [3:0] DONE_OFFSET     = 4'hC;  // +0x0C

  // Registers
  logic        clk_en_q;
  logic [31:0] func_ptr_q;
  logic        start_q;
  logic        done_q;
  
  // Response pipeline
  logic        rvalid_q, rvalid_d;
  logic [31:0] rdata_q, rdata_d;
  
  // Address decode (offset from base)
  logic [3:0]  addr_offset;
  logic        addr_valid;
  
  assign addr_offset = obi_req_i.a.addr[3:0];
  
  // Check if address is in valid range
  assign addr_valid = (obi_req_i.a.addr >= BaseAddr) && 
                      (obi_req_i.a.addr < (BaseAddr + 16));  // 4 registers * 4 bytes
  
  // Grant only if address is valid
  assign obi_rsp_o.gnt = obi_req_i.req && addr_valid;
  assign obi_rsp_o.r.err = 1'b0;
  
  // ============================================
  // Register write logic (combinational)
  // ============================================
  logic        clk_en_d;
  logic [31:0] func_ptr_d;
  logic        start_d;
  logic        done_d;
  
  always_comb begin
    // Default: keep current values
    clk_en_d   = clk_en_q;
    func_ptr_d = func_ptr_q;
    start_d    = start_q;
    done_d     = 1'b0;  // Done is a pulse, auto-clears
    
    // Update registers on write only if address is valid
    if (obi_req_i.req && obi_req_i.a.we && addr_valid) begin
      case (addr_offset)
        CLK_EN_OFFSET:   clk_en_d   = obi_req_i.a.wdata[0];
        FUNC_PTR_OFFSET: func_ptr_d = obi_req_i.a.wdata;
        START_OFFSET:    start_d    = obi_req_i.a.wdata[0];  // CV32 sets to 1, Spatz clears to 0
        DONE_OFFSET:     done_d     = obi_req_i.a.wdata[0];  // Spatz writes 1, creates pulse
      endcase
    end
  end
  
  // ============================================
  // Register sequential logic
  // ============================================
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      clk_en_q   <= 1'b0;
      func_ptr_q <= 32'h0;
      start_q    <= 1'b0;
      done_q     <= 1'b0;
    end else begin
      clk_en_q   <= clk_en_d;
      func_ptr_q <= func_ptr_d;
      start_q    <= start_d;
      done_q     <= done_d;
    end
  end
  
  // ============================================
  // OBI read response logic (combinational)
  // ============================================
  always_comb begin
    rdata_d  = 32'h0;
    rvalid_d = obi_req_i.req && addr_valid;
    
    if (obi_req_i.req && !obi_req_i.a.we && addr_valid) begin
      case (addr_offset)
        CLK_EN_OFFSET:   rdata_d = {31'h0, clk_en_q};
        FUNC_PTR_OFFSET: rdata_d = func_ptr_q;
        START_OFFSET:    rdata_d = {31'h0, start_q};
        DONE_OFFSET:     rdata_d = {31'h0, done_q};
        default:         rdata_d = 32'hDEADBEEF;
      endcase
    end
  end
  
  // ============================================
  // OBI response sequential logic
  // ============================================
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      rvalid_q <= 1'b0;
      rdata_q  <= 32'h0;
    end else begin
      rvalid_q <= rvalid_d;
      rdata_q  <= rdata_d;
    end
  end
  
  // Output assignments
  assign obi_rsp_o.rvalid = rvalid_q;
  assign obi_rsp_o.r.rdata  = rdata_q;
  assign obi_rsp_o.r.rid = obi_req_i.a.aid;
  assign obi_rsp_o.r.r_optional = '0;
  assign clk_en_o         = clk_en_q;
  assign start_o          = start_q;
  assign done_o           = done_q;
  

endmodule
