/*
 * Copyright (C) 2026 Fondazione Chips-IT
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * SPDX-License-Identifier: Apache-2.0
 *
 * Authors: Niccolò Giuliani, Fondazione Chips-IT
 */


module obi_slave_ctrl_cluster
  import magia_tile_pkg::*;
#(
   parameter logic [31:0] BaseAddr       = 32'h00001700  // Base address for Cluster control registers

)  (
  input  logic                                             clk_i,
  input  logic                                             rst_ni,

  // OBI interface
  input  core_obi_data_req_t                               obi_req_i,
  output core_obi_data_rsp_t                               obi_rsp_o,

  //Control Outputs
  output logic [magia_tile_pkg::N_CLUSTER_CORES-1:0]       clk_en_o,
  output logic [31:0]                                      boot_addr_o  [magia_tile_pkg::N_CLUSTER_CORES-1:0],
  output logic [magia_tile_pkg::N_CLUSTER_CORES-1:0]       fetch_en_o,
  output logic                                             done_o

);

//Registers offset

localparam logic [31:0] CLUSTER_FETCH_EN          = 32'h00;
localparam logic [31:0] CLUSTER_BINARY            = 32'h04;
localparam logic [31:0] CLUSTER_NB_CORES_TO_WAIT  = 32'h08;
localparam logic [31:0] CLUSTER_DONE              = 32'h0C;


// Address decode (offset from base)
logic [31:0]  addr_offset;
logic         addr_valid;

assign addr_offset = obi_req_i.a.addr - BaseAddr;

// Registers
logic [magia_tile_pkg::N_CLUSTER_CORES-1:0] fetch_en_q;
logic done_q;
logic [magia_tile_pkg::N_BIT_CLUSTER_CORES:0]  nb_recv_end_reqs_q;
logic [magia_tile_pkg::N_BIT_CLUSTER_CORES:0]  nb_cores_to_wait_q;
logic [31:0]                                   entry_point_q [magia_tile_pkg::N_CLUSTER_CORES-1:0];

// Response pipeline
logic        rvalid_q, rvalid_d;
logic [31:0] rdata_q, rdata_d;

assign addr_valid = (obi_req_i.a.addr >= BaseAddr) &&
                    (obi_req_i.a.addr < (BaseAddr + 16));  // 4 registers * 4 bytes

assign obi_rsp_o.gnt    = obi_req_i.req && addr_valid;
assign obi_rsp_o.rvalid = rvalid_q;
assign obi_rsp_o.r.rdata      = rdata_q;
assign obi_rsp_o.r.rid        = '0;
assign obi_rsp_o.r.err        = 1'b0;
assign obi_rsp_o.r.r_optional = '0;


// ============================================
// Register write logic (combinational)
// ============================================
logic  done_d;
logic [magia_tile_pkg::N_BIT_CLUSTER_CORES:0]  nb_recv_end_reqs_d;
logic [magia_tile_pkg::N_BIT_CLUSTER_CORES:0]  nb_cores_to_wait_d;
logic  done_clear;
logic [magia_tile_pkg::N_CLUSTER_CORES-1:0]    fetch_en_d;
logic [31:0]                                   entry_point_d [magia_tile_pkg::N_CLUSTER_CORES-1:0];

// Done is sticky: clears only when software reads the CLUSTER_DONE register
assign done_clear = obi_req_i.req && addr_valid && !obi_req_i.a.we &&
                    (addr_offset == CLUSTER_DONE);

always_comb begin

  fetch_en_d = fetch_en_q;
  done_d = done_q;  // sticky: keep previous value
  nb_recv_end_reqs_d = nb_recv_end_reqs_q;
  nb_cores_to_wait_d = nb_cores_to_wait_q;
  entry_point_d = entry_point_q;
  // Clear done on read (read-to-clear)
  if (done_clear) begin
    done_d = 1'b0;
  end

  if (obi_req_i.req && addr_valid && obi_req_i.a.we) begin
    case (addr_offset)
      CLUSTER_FETCH_EN: 
        for (int i = 0; i < magia_tile_pkg::N_CLUSTER_CORES; i++) begin
          fetch_en_d[i] = obi_req_i.a.wdata >> i & 1'b1;
        end
      CLUSTER_BINARY:   begin
        for (int i = 0; i < magia_tile_pkg::N_CLUSTER_CORES; i++) begin
          entry_point_d[i] = obi_req_i.a.wdata; 
        end
      end
      CLUSTER_NB_CORES_TO_WAIT: nb_cores_to_wait_d = obi_req_i.a.wdata;
      CLUSTER_DONE: begin
        nb_recv_end_reqs_d = nb_recv_end_reqs_q + 1;
      end
    endcase
  end

  // Set done when all cores have reported
  if (nb_recv_end_reqs_d == nb_cores_to_wait_q) begin
    done_d = 1'b1;
    nb_recv_end_reqs_d = '0;
  end
end

// ============================================
// Register sequential logic
// ============================================

always_ff @(posedge clk_i or negedge rst_ni) begin
  if (!rst_ni) begin
    fetch_en_q         <= 1'b0;
    done_q             <= 1'b0;
    nb_recv_end_reqs_q <= '0;
    rvalid_q           <= 1'b0;
    rdata_q            <= 32'h0;
    nb_cores_to_wait_q <= magia_tile_pkg::N_CLUSTER_CORES;  // Default to waiting for all cores
    for (int i = 0; i < magia_tile_pkg::N_CLUSTER_CORES; i++)
      entry_point_q[i]  <= 32'hC0000080;  // Default entry point for all cores
  end else begin
    fetch_en_q         <= fetch_en_d;
    done_q             <= done_d;
    nb_recv_end_reqs_q <= nb_recv_end_reqs_d;
    rvalid_q           <= rvalid_d;
    rdata_q            <= rdata_d;
    nb_cores_to_wait_q <= nb_cores_to_wait_d;
    entry_point_q       <= entry_point_d;
  end
end

// ============================================
// OBI read response logic (combinational)
// ============================================

always_comb begin
  rdata_d  = 32'h0;
  rvalid_d = obi_req_i.req && addr_valid;

  if (obi_req_i.req && addr_valid && !obi_req_i.a.we) begin
    case (addr_offset)
      CLUSTER_FETCH_EN:         rdata_d = {{(32-magia_tile_pkg::N_CLUSTER_CORES){1'b0}}, fetch_en_q};
      CLUSTER_BINARY:           rdata_d = entry_point_q[0];  // Assuming all cores have the same entry point
      CLUSTER_NB_CORES_TO_WAIT: rdata_d = nb_cores_to_wait_q;
      CLUSTER_DONE:             rdata_d = {31'h0, done_q};
      default:                  rdata_d = 32'hDEADBEEF;
    endcase
  end
end

assign done_o     = done_q;
assign fetch_en_o = fetch_en_q;
assign clk_en_o   = '1;
assign boot_addr_o = entry_point_q;

endmodule