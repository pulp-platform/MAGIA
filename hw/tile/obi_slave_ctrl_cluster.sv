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
   parameter logic [31:0] BaseAddr = 32'h00001700  // Base address for PULP cluster control registers
)  (
  input  logic                                             clk_i,
  input  logic                                             rst_ni,

  // OBI interface
  input  core_obi_data_req_t                               obi_req_i,
  output core_obi_data_rsp_t                               obi_rsp_o,

  // Control outputs to PULP cluster cores
  output logic [magia_tile_pkg::N_CLUSTER_CORES-1:0]       clk_en_o,      // broadcast (replicated)
  output logic [31:0]                                      boot_addr_o  [magia_tile_pkg::N_CLUSTER_CORES-1:0],
  output logic [magia_tile_pkg::N_CLUSTER_CORES-1:0]       fetch_en_o,    // broadcast (replicated)
  output logic                                             done_o,        // DONE IRQ pulse when all selected cores complete
  output logic [magia_tile_pkg::N_CLUSTER_CORES-1:0]       start_irq_o    // per-core 1-cycle dispatch IRQ pulse
);

//-----------------------------------------------------------------------------
// Register map (offsets from BaseAddr, instantiated by tile_csr at BaseAddr+0x40 = 0x1740)
//   0x00 CLK_EN          : RW broadcast (1=enable all cores, 0=disable all)
//                              writing CLK_EN also resets the READY counter
//   0x04 BINARY          : RW PULP binary entry point (boot address)
//   0x08 NB_CORES_TO_WAIT: RW number of cores expected to ACK + DONE per dispatch
//   0x0C DONE            : W  each PULP core writes 1 after task returns;
//                              after NB_CORES_TO_WAIT writes done_o pulses
//   0x10 TASKBIN         : RW task function address; read by PULP cores
//   0x14 DATA            : RW context pointer passed as arg0 to the task
//   0x18 START           : RW CV32 writes one-hot core_mask -> 1-cycle IRQ pulse
//                              PULP cores write 0 to ACK (before task);
//                              register clears when all NB_CORES_TO_WAIT ACKs received
//   0x1C READY           : R  reads as 1 once N_CLUSTER_CORES cores have written;
//                          W  each PULP core writes 1 after boot (counter increment)
//-----------------------------------------------------------------------------
localparam logic [31:0] CLUSTER_CLK_EN            = 32'h00;
localparam logic [31:0] CLUSTER_BINARY            = 32'h04;
localparam logic [31:0] CLUSTER_NB_CORES_TO_WAIT  = 32'h08;
localparam logic [31:0] CLUSTER_DONE              = 32'h0C;
localparam logic [31:0] CLUSTER_TASKBIN           = 32'h10;
localparam logic [31:0] CLUSTER_DATA              = 32'h14;
localparam logic [31:0] CLUSTER_START             = 32'h18;
localparam logic [31:0] CLUSTER_READY             = 32'h1C;

// Address decode (offset from base)
logic [31:0] addr_offset;
logic        addr_valid;

assign addr_offset = obi_req_i.a.addr - BaseAddr;
assign addr_valid  = (obi_req_i.a.addr >= BaseAddr) &&
                     (obi_req_i.a.addr < (BaseAddr + 32));  // 8 registers * 4 bytes

// Registers
logic                                          clk_en_q,    clk_en_d;
logic [31:0]                                   entry_point_q,  entry_point_d;
logic [magia_tile_pkg::N_BIT_CLUSTER_CORES:0]  nb_cores_to_wait_q, nb_cores_to_wait_d;
logic                                          done_q,      done_d;
logic [31:0]                                   taskbin_q,   taskbin_d;
logic [31:0]                                   data_q,      data_d;
logic [magia_tile_pkg::N_CLUSTER_CORES-1:0]    start_q,     start_d;

// Counters
logic [magia_tile_pkg::N_BIT_CLUSTER_CORES:0]  nb_recv_done_reqs_q,  nb_recv_done_reqs_d;
logic [magia_tile_pkg::N_BIT_CLUSTER_CORES:0]  nb_recv_ack_reqs_q,   nb_recv_ack_reqs_d;
logic [magia_tile_pkg::N_BIT_CLUSTER_CORES:0]  nb_recv_ready_reqs_q, nb_recv_ready_reqs_d;

// One-cycle start IRQ pulse register
logic [magia_tile_pkg::N_CLUSTER_CORES-1:0]    start_irq_q, start_irq_d;

// Response pipeline
logic        rvalid_q, rvalid_d;
logic [31:0] rdata_q,  rdata_d;

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
  // Defaults: hold
  clk_en_d             = clk_en_q;
  entry_point_d        = entry_point_q;
  nb_cores_to_wait_d   = nb_cores_to_wait_q;
  done_d               = 1'b0;
  taskbin_d            = taskbin_q;
  data_d               = data_q;
  start_d              = start_q;
  nb_recv_done_reqs_d  = nb_recv_done_reqs_q;
  nb_recv_ack_reqs_d   = nb_recv_ack_reqs_q;
  nb_recv_ready_reqs_d = nb_recv_ready_reqs_q;
  start_irq_d          = '0;  // default: no IRQ pulse this cycle

  if (obi_req_i.req && addr_valid && obi_req_i.a.we) begin
    case (addr_offset)
      CLUSTER_CLK_EN: begin
        // Broadcast: any non-zero enables all cores; 0 disables all.
        clk_en_d = |obi_req_i.a.wdata;
        // Reset READY counter so CV32 can re-poll after each init.
        nb_recv_ready_reqs_d = '0;
      end
      CLUSTER_BINARY: begin
        entry_point_d = obi_req_i.a.wdata;
      end
      CLUSTER_NB_CORES_TO_WAIT: begin
        nb_cores_to_wait_d = obi_req_i.a.wdata[magia_tile_pkg::N_BIT_CLUSTER_CORES:0];
      end
      CLUSTER_DONE: begin
        // Each PULP core writes 1 here on completion (write data ignored)
        nb_recv_done_reqs_d = nb_recv_done_reqs_q + 1;
      end
      CLUSTER_TASKBIN: begin
        taskbin_d = obi_req_i.a.wdata;
      end
      CLUSTER_DATA: begin
        data_d = obi_req_i.a.wdata;
      end
      CLUSTER_START: begin
        if (obi_req_i.a.wdata != 32'h0) begin
          // CV32 dispatch: latch core_mask, reset counters, fire 1-cycle IRQ pulses
          start_d             = obi_req_i.a.wdata[magia_tile_pkg::N_CLUSTER_CORES-1:0];
          nb_recv_ack_reqs_d  = '0;
          nb_recv_done_reqs_d = '0;
          start_irq_d         = obi_req_i.a.wdata[magia_tile_pkg::N_CLUSTER_CORES-1:0];
        end else begin
          // PULP core ACK (write 0): count; when all done, clear register
          nb_recv_ack_reqs_d = nb_recv_ack_reqs_q + 1;
        end
      end
      CLUSTER_READY: begin
        // PULP core boot complete: count; saturate at N_CLUSTER_CORES
        if (nb_recv_ready_reqs_q < magia_tile_pkg::N_CLUSTER_CORES) begin
          nb_recv_ready_reqs_d = nb_recv_ready_reqs_q + 1;
        end
      end
      default: ;
    endcase
  end

  // Fire a one-cycle DONE pulse when all expected cores have completed.
  if (nb_recv_done_reqs_d >= nb_cores_to_wait_q && nb_cores_to_wait_q != '0) begin
    done_d              = 1'b1;
    nb_recv_done_reqs_d = '0;
  end

  // Clear PULP_START when all expected cores have ACK'd (write 0)
  if (nb_recv_ack_reqs_d >= nb_cores_to_wait_q && nb_cores_to_wait_q != '0) begin
    start_d            = '0;
    nb_recv_ack_reqs_d = '0;
  end
end

// ============================================
// Register sequential logic
// ============================================
always_ff @(posedge clk_i or negedge rst_ni) begin
  if (!rst_ni) begin
    clk_en_q             <= 1'b0;
    entry_point_q        <= 32'hCC000080;
    nb_cores_to_wait_q   <= magia_tile_pkg::N_CLUSTER_CORES;
    done_q               <= 1'b0;
    taskbin_q            <= 32'h0;
    data_q               <= 32'h0;
    start_q              <= '0;
    nb_recv_done_reqs_q  <= '0;
    nb_recv_ack_reqs_q   <= '0;
    nb_recv_ready_reqs_q <= '0;
    start_irq_q          <= '0;
    rvalid_q             <= 1'b0;
    rdata_q              <= 32'h0;
  end else begin
    clk_en_q             <= clk_en_d;
    entry_point_q        <= entry_point_d;
    nb_cores_to_wait_q   <= nb_cores_to_wait_d;
    done_q               <= done_d;
    taskbin_q            <= taskbin_d;
    data_q               <= data_d;
    start_q              <= start_d;
    nb_recv_done_reqs_q  <= nb_recv_done_reqs_d;
    nb_recv_ack_reqs_q   <= nb_recv_ack_reqs_d;
    nb_recv_ready_reqs_q <= nb_recv_ready_reqs_d;
    start_irq_q          <= start_irq_d;
    rvalid_q             <= rvalid_d;
    rdata_q              <= rdata_d;
  end
end

// ============================================
// OBI read response logic (combinational)
// ============================================
logic ready_reg_val;
assign ready_reg_val = (nb_recv_ready_reqs_q == magia_tile_pkg::N_CLUSTER_CORES);

always_comb begin
  rdata_d  = 32'h0;
  rvalid_d = obi_req_i.req && addr_valid;

  if (obi_req_i.req && addr_valid && !obi_req_i.a.we) begin
    case (addr_offset)
      CLUSTER_CLK_EN:           rdata_d = {31'h0, clk_en_q};
      CLUSTER_BINARY:           rdata_d = entry_point_q;
      CLUSTER_NB_CORES_TO_WAIT: rdata_d = {{(32-magia_tile_pkg::N_BIT_CLUSTER_CORES-1){1'b0}}, nb_cores_to_wait_q};
      CLUSTER_DONE:             rdata_d = {31'h0, done_q};
      CLUSTER_TASKBIN:          rdata_d = taskbin_q;
      CLUSTER_DATA:             rdata_d = data_q;
      CLUSTER_START:            rdata_d = {{(32-magia_tile_pkg::N_CLUSTER_CORES){1'b0}}, start_q};
      CLUSTER_READY:            rdata_d = {31'h0, ready_reg_val};
      default:                  rdata_d = 32'hDEADBEEF;
    endcase
  end
end

// Outputs: broadcast clk_en and fetch_en to all cores (replicated bit)
assign clk_en_o     = {magia_tile_pkg::N_CLUSTER_CORES{clk_en_q}};
assign fetch_en_o   = {magia_tile_pkg::N_CLUSTER_CORES{clk_en_q}};
assign done_o       = done_q;
assign start_irq_o  = start_irq_q;

// All cores share the same boot address (PULP binary entry point)
always_comb begin
  for (int i = 0; i < magia_tile_pkg::N_CLUSTER_CORES; i++) begin
    boot_addr_o[i] = entry_point_q;
  end
end

endmodule