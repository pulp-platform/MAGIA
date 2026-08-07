/*
 * Copyright (C) 2026 ETH Zurich, University of Bologna and Fondazione Chips-IT
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
   parameter magia_tile_pkg::magia_tile_cfg_t TileCfg = magia_tile_pkg::MagiaTileDefaultCfg,
   parameter logic [31:0] BaseAddr = 32'h00001700,  // Base address for PULP cluster control registers
   localparam int unsigned NumCores = TileCfg.Cluster.NumCores
)  (
  input  logic                                             clk_i,
  input  logic                                             rst_ni,

  // OBI interface
  input  core_obi_data_req_t                               obi_req_i,
  output core_obi_data_rsp_t                               obi_rsp_o,

  // Control outputs to PULP cluster cores
  output logic                clk_en_o,                  // gates the whole cluster block
  output logic [31:0]         boot_addr_o [NumCores-1:0],
  output logic [NumCores-1:0] fetch_en_o,                // broadcast (replicated)
  output logic                done_o,                    // 1-cycle pulse on a DONE write
  output logic                start_irq_o                // 1-cycle event pulse, wired directly into core 0's Cluster Event Unit Buffer
);

//-----------------------------------------------------------------------------
// Register map (offsets from BaseAddr; instantiated inside gen_pulp_cluster at TILE_CSR_START+0x40 = 0x1740)
//   0x00 CLK_EN          : RW broadcast (1=enable all cores, 0=disable all)
//                              writing CLK_EN also resets the READY counter
//   0x04 BINARY          : RW PULP binary entry point (boot address)
//   0x08 DONE            : W  the dispatcher core writes 1 after the task returns -> done_o pulses
//   0x0C TASKBIN         : RW task function address; read by PULP cores
//   0x10 DATA            : RW context pointer passed as arg0 to the task
//   0x14 START           : RW CV32 writes non-zero -> 1-cycle dispatch event on Cluster core 0's Event Unit; core 0 writes 0 to ACK
//   0x18 READY           : R  reads as 1 once NumCores cores have written;
//                          W  each PULP core writes 1 after boot (counter increment)
//   0x1C RETURN          : RW task exit code; the dispatcher core writes it right before DONE
//-----------------------------------------------------------------------------
localparam logic [31:0] CLUSTER_CLK_EN            = 32'h00;
localparam logic [31:0] CLUSTER_BINARY            = 32'h04;
localparam logic [31:0] CLUSTER_DONE              = 32'h08;
localparam logic [31:0] CLUSTER_TASKBIN           = 32'h0C;
localparam logic [31:0] CLUSTER_DATA              = 32'h10;
localparam logic [31:0] CLUSTER_START             = 32'h14;
localparam logic [31:0] CLUSTER_READY             = 32'h18;
localparam logic [31:0] CLUSTER_RETURN            = 32'h1C;

localparam int unsigned NumCoresW = magia_tile_pkg::gen_idx_width(NumCores);

// Address decode (offset from base)
logic [31:0] addr_offset;
logic        addr_valid;

assign addr_offset = obi_req_i.a.addr - BaseAddr;
assign addr_valid  = (obi_req_i.a.addr >= BaseAddr) &&
                     (obi_req_i.a.addr < (BaseAddr + 32));  // 8 registers * 4 bytes

// Registers
logic                clk_en_q,           clk_en_d;
logic [31:0]         entry_point_q,      entry_point_d;
logic                done_q,             done_d;
logic [31:0]         taskbin_q,          taskbin_d;
logic [31:0]         data_q,             data_d;
logic                start_q,            start_d;
logic [31:0]         retval_q,           retval_d;

// Boot counter (READY): still per-core, every hart reports once
logic [NumCoresW:0]  nb_recv_ready_reqs_q, nb_recv_ready_reqs_d;

// One-cycle start IRQ pulse register
logic                start_irq_q, start_irq_d;

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
  done_d               = 1'b0;
  taskbin_d            = taskbin_q;
  data_d               = data_q;
  start_d              = start_q;
  retval_d             = retval_q;
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
      CLUSTER_DONE: begin
        // The dispatcher core writes 1 here when the task returns (data ignored):
        // one write is one completed dispatch, no quorum involved.
        done_d = 1'b1;
      end
      CLUSTER_TASKBIN: begin
        taskbin_d = obi_req_i.a.wdata;
      end
      CLUSTER_DATA: begin
        data_d = obi_req_i.a.wdata;
      end
      CLUSTER_RETURN: begin
        // The dispatcher core writes the task's exit code here, right before DONE.
        retval_d = obi_req_i.a.wdata;
      end
      CLUSTER_START: begin
        if (obi_req_i.a.wdata != 32'h0) begin
          // CV32 dispatch: latch the request and fire the 1-cycle event pulse
          start_d     = 1'b1;
          start_irq_d = 1'b1;
        end else begin
          // ACK from core 0: clear the register, unblocking the CV32 poll
          start_d = 1'b0;
        end
      end
      CLUSTER_READY: begin
        // PULP core boot complete: count; saturate at N_CLUSTER_CORES
        if (nb_recv_ready_reqs_q < NumCores) begin
          nb_recv_ready_reqs_d = nb_recv_ready_reqs_q + 1;
        end
      end
      default: ;
    endcase
  end
end

// ============================================
// Register sequential logic
// ============================================
always_ff @(posedge clk_i or negedge rst_ni) begin
  if (!rst_ni) begin
    clk_en_q             <= 1'b0;
    entry_point_q        <= 32'hCC000080;
    done_q               <= 1'b0;
    taskbin_q            <= 32'h0;
    data_q               <= 32'h0;
    start_q              <= 1'b0;
    retval_q             <= 32'h0;
    nb_recv_ready_reqs_q <= '0;
    start_irq_q          <= 1'b0;
    rvalid_q             <= 1'b0;
    rdata_q              <= 32'h0;
  end else begin
    clk_en_q             <= clk_en_d;
    entry_point_q        <= entry_point_d;
    done_q               <= done_d;
    taskbin_q            <= taskbin_d;
    data_q               <= data_d;
    start_q              <= start_d;
    retval_q             <= retval_d;
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
assign ready_reg_val = (nb_recv_ready_reqs_q == NumCores);

always_comb begin
  rdata_d  = 32'h0;
  rvalid_d = obi_req_i.req && addr_valid;

  if (obi_req_i.req && addr_valid && !obi_req_i.a.we) begin
    case (addr_offset)
      CLUSTER_CLK_EN:           rdata_d = {31'h0, clk_en_q};
      CLUSTER_BINARY:           rdata_d = entry_point_q;
      CLUSTER_DONE:             rdata_d = {31'h0, done_q};
      CLUSTER_TASKBIN:          rdata_d = taskbin_q;
      CLUSTER_DATA:             rdata_d = data_q;
      CLUSTER_RETURN:           rdata_d = retval_q;
      CLUSTER_START:            rdata_d = {31'h0, start_q};
      CLUSTER_READY:            rdata_d = {31'h0, ready_reg_val};
      default:                  rdata_d = 32'hDEADBEEF;
    endcase
  end
end

// Outputs: single clock enable for the cluster block, fetch_en replicated per core
assign clk_en_o     = clk_en_q;
assign fetch_en_o   = {NumCores{clk_en_q}};
assign done_o       = done_q;
assign start_irq_o  = start_irq_q;

// All cores share the same boot address (PULP binary entry point)
always_comb begin
  for (int i = 0; i < NumCores; i++) begin
    boot_addr_o[i] = entry_point_q;
  end
end

endmodule