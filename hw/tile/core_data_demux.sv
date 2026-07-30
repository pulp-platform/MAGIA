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
 * Authors: Niccolò Giuliani <niccolo.giuliani44@gmail.com>
 *
 * Core Data Demux
 *
 */

module core_data_demux
  import magia_tile_pkg::*;
  import magia_pkg::*;
#(
  parameter int unsigned NumSlv     = 2,             // Number of downstream slave ports
  parameter int unsigned DefaultSlv = NumSlv-1,      // Slave selected when no address range matches
  parameter type         req_t      = magia_tile_pkg::core_data_req_t,
  parameter type         rsp_t      = magia_tile_pkg::core_data_rsp_t,
  // Dependent parameter, DO NOT OVERRIDE!
  parameter int unsigned SelW       = (NumSlv > 1) ? $clog2(NumSlv) : 1
)(
  input  logic clk_i,
  input  logic rst_ni,

  // Core data interface (input from the core)
  input  req_t core_data_req_i,
  output rsp_t core_data_rsp_o,

  // Per-slave address ranges (runtime, inclusive). The DefaultSlv entry is ignored.
  input  logic [magia_pkg::ADDR_W-1:0] slv_start_addr_i [NumSlv-1:0],
  input  logic [magia_pkg::ADDR_W-1:0] slv_end_addr_i   [NumSlv-1:0],

  // Downstream slave interfaces
  output req_t [NumSlv-1:0] slv_data_req_o,
  input  rsp_t [NumSlv-1:0] slv_data_rsp_i
);

  // ---------------------------------------------------------------------------
  // Address decode (combinatorial)
  // ---------------------------------------------------------------------------

  logic [SelW-1:0] destination;          // combinatorial: destination of the current request

  always_comb begin : _ADDR_DECODE_
    logic found;
    destination = SelW'(DefaultSlv);
    found       = 1'b0;
    for (int unsigned s = 0; s < NumSlv; s++) begin
      if (!found && (s != DefaultSlv) &&
          core_data_req_i.req &&
          (core_data_req_i.addr >= slv_start_addr_i[s]) &&
          (core_data_req_i.addr <= slv_end_addr_i[s])) begin
        destination = SelW'(s);
        found       = 1'b1;
      end
    end
  end

  // ---------------------------------------------------------------------------
  // In-order response tracking — 2-entry FIFO
  // ---------------------------------------------------------------------------

  logic [SelW-1:0] arriving_order [1:0]; // FIFO: [0]=newest, [1]=oldest
  logic [1:0]      num_outstanding;
  logic [SelW-1:0] head;                 // combinatorial: oldest pending destination

  always_comb begin : _HEAD_MUX_
    case (num_outstanding)
      2'd2:    head = arriving_order[1]; // oldest
      2'd1:    head = arriving_order[0];
      default: head = SelW'(DefaultSlv); // idle, value unused
    endcase
  end

  // ---------------------------------------------------------------------------
  // Out-of-order response capture
  // ---------------------------------------------------------------------------

  logic [NumSlv-1:0]                    cap_rvalid_q;
  logic [magia_pkg::DATA_W-1:0]         cap_rdata_q [NumSlv-1:0];
  logic [NumSlv-1:0]                    cap_err_q;

  // "Effective" rvalid/rdata/err per slave: direct arrival OR previously captured
  logic [NumSlv-1:0]                    rvalid_eff;
  logic [magia_pkg::DATA_W-1:0]         rdata_eff [NumSlv-1:0];
  logic [NumSlv-1:0]                    err_eff;

  // Direct arrival takes priority so the capture register is consumed first only when nothing arrives directly that cycle.
  for (genvar s = 0; s < NumSlv; s++) begin : gen_resp_eff
    assign rvalid_eff[s] = slv_data_rsp_i[s].rvalid | cap_rvalid_q[s];
    assign rdata_eff[s]  = slv_data_rsp_i[s].rvalid ? slv_data_rsp_i[s].rdata : cap_rdata_q[s];
    assign err_eff[s]    = slv_data_rsp_i[s].rvalid ? slv_data_rsp_i[s].err   : cap_err_q[s];
  end

  // Response forwarded to the core this cycle
  logic resp_valid_to_core;
  always_comb begin : _RESP_VALID_MUX_
    if (num_outstanding == '0)
      resp_valid_to_core = 1'b0;
    else
      resp_valid_to_core = rvalid_eff[head];
  end

  // Capture/clear FFs
  always_ff @(posedge clk_i, negedge rst_ni) begin : _CAPTURE_FFS_
    if (!rst_ni) begin
      cap_rvalid_q <= '0;
      cap_rdata_q  <= '{default: '0};
      cap_err_q    <= '0;
    end else begin
      // Per slave: capture when rvalid arrives and the slave is not at head; clear when the slave's response is forwarded to the core.
      for (int unsigned s = 0; s < NumSlv; s++) begin
        if (slv_data_rsp_i[s].rvalid && (num_outstanding > 0) && (head != SelW'(s))) begin
          cap_rvalid_q[s] <= 1'b1;
          cap_rdata_q[s]  <= slv_data_rsp_i[s].rdata;
          cap_err_q[s]    <= slv_data_rsp_i[s].err;
        end else if ((head == SelW'(s)) && resp_valid_to_core) begin
          cap_rvalid_q[s] <= 1'b0;
        end
      end
    end
  end

  // ---------------------------------------------------------------------------
  // FIFO push/pop
  // ---------------------------------------------------------------------------

  logic request_granted;
  logic fifo_push, fifo_pop;

  assign request_granted = core_data_req_i.req && core_data_rsp_o.gnt;
  assign fifo_push       = request_granted;
  assign fifo_pop        = resp_valid_to_core && (num_outstanding > 0);

  always_ff @(posedge clk_i, negedge rst_ni) begin : _FIFO_
    if (!rst_ni) begin
      arriving_order[0] <= SelW'(DefaultSlv);
      arriving_order[1] <= SelW'(DefaultSlv);
      num_outstanding   <= 2'b0;
    end else begin
      if (fifo_push && fifo_pop) begin
        // Back-to-back: pop the old head, push the new destination
        arriving_order[0] <= destination;
        if (num_outstanding == 2)
          arriving_order[1] <= arriving_order[0]; // shift oldest away
        // num_outstanding unchanged
      end else if (fifo_push) begin
        arriving_order[1] <= arriving_order[0];
        arriving_order[0] <= destination;
        num_outstanding   <= num_outstanding + 1;
      end else if (fifo_pop) begin
        arriving_order[1] <= arriving_order[0];
        num_outstanding   <= num_outstanding - 1;
      end
    end
  end

  // ---------------------------------------------------------------------------
  // Request forwarding
  // ---------------------------------------------------------------------------

  logic can_issue;
  assign can_issue = (num_outstanding < 2) || fifo_pop;

  always_comb begin : _REQ_FWD_
    for (int unsigned s = 0; s < NumSlv; s++) begin
      slv_data_req_o[s]     = core_data_req_i;
      slv_data_req_o[s].req = core_data_req_i.req && (destination == SelW'(s)) && can_issue;
    end
  end

  always_comb begin : _HANDLE_RESP_
    core_data_rsp_o        = slv_data_rsp_i[head];
    core_data_rsp_o.rvalid = resp_valid_to_core;
    core_data_rsp_o.rdata  = rdata_eff[head];
    core_data_rsp_o.err    = err_eff[head];
    // GNT: combinatorial from selected slave, gated by can_issue
    core_data_rsp_o.gnt    = can_issue && slv_data_rsp_i[destination].gnt;
  end

endmodule
