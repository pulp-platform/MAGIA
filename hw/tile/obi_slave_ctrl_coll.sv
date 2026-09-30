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
 * Authors: Carlotta Chiarini
 *          based on obi_slave_ctrl_spatz by Luca Balboni
 *
 * OBI Slave Control Registers for the Collective Generator module
 *
 */

module obi_slave_ctrl_coll
  import magia_tile_pkg::*;
#(
  parameter logic [31:0] BaseAddr  = 32'h00001800  // Base address for control registers
) (
  input  logic              clk_i,
  input  logic              rst_ni,
  
  // OBI slave interface
  input  core_obi_data_req_t    obi_req_i,
  output core_obi_data_rsp_t    obi_rsp_o,
  
  // Control outputs
  output logic[31:0]              collective_mask_o,
  output logic[3:0]               collective_op_o
);

  // Register offsets
  localparam logic [3:0] COLLECTIVE_MASK_OFFSET  = 4'h0;  // +0x00
  localparam logic [3:0] COLLECTIVE_OP_OFFSET    = 4'h4;  // +0x04

  // Registers
  logic [31:0] collective_mask_q;
  logic [3:0] collective_op_q;
  
  // Response pipeline
  logic        rvalid_q, rvalid_d;
  logic [31:0] rdata_q, rdata_d;
  
  // Address decode (offset from base)
  logic [4:0]  addr_offset;
  logic        addr_valid;
  
  assign addr_offset = obi_req_i.a.addr[4:0];
  
  // Check if address is in valid range
  assign addr_valid = (obi_req_i.a.addr >= BaseAddr) && 
                      (obi_req_i.a.addr < (BaseAddr + 8));  // 2 registers * 4 bytes
  
  // Grant only if address is valid
  assign obi_rsp_o.gnt = obi_req_i.req && addr_valid;
  assign obi_rsp_o.r.err = 1'b0;
  
  // ============================================
  // Register write logic (combinational)
  // ============================================
  logic[31:0]        collective_mask_d;
  logic[3:0]        collective_op_d;
  
  always_comb begin
    // Default: keep current values
    collective_mask_d  = collective_mask_q;
    collective_op_d   = collective_op_q;

    // Update registers on write only if address is valid
    if (obi_req_i.req && obi_req_i.a.we && addr_valid) begin
      case (addr_offset)
        COLLECTIVE_MASK_OFFSET: collective_mask_d  = obi_req_i.a.wdata;
        COLLECTIVE_OP_OFFSET:   collective_op_d   = obi_req_i.a.wdata[3:0];
      endcase
    end
  end
  
  // ============================================
  // Register sequential logic
  // ============================================
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      collective_mask_q  <= 32'b0;
      collective_op_q   <= 4'b0;
    end else begin
      collective_mask_q  <= collective_mask_d;
      collective_op_q   <= collective_op_d;
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
        COLLECTIVE_MASK_OFFSET: rdata_d = collective_mask_q;
        COLLECTIVE_OP_OFFSET:   rdata_d = {28'h0, collective_op_q};
        default:                rdata_d = 32'hDEADBEEF;
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

  assign collective_mask_o = collective_mask_q;
  assign collective_op_o  = collective_op_q;
  

endmodule
