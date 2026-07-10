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
 * Authors: Luca Balboni <luca.balboni10@studio.unibo.it>
 *          Victor Isachi <victor.isachi@unibo.it>
 * 
 * Core Data Demux EU Direct Link
 * 
 * This module implements a demux that splits core data requests between:
 * - Regular crossbar for general memory/peripheral access
 * - EU direct link for low-latency Event Unit access (WFE control)
 * 
 * The demux decision is based on address range:
 * - EVENT_UNIT_ADDR_START to EVENT_UNIT_ADDR_END -> EU direct link
 * - All other addresses -> Regular crossbar
 * 
 */

module core_data_demux_eu_direct 
  import magia_tile_pkg::*;
  import magia_pkg::*;
#(
  parameter logic [magia_pkg::ADDR_W-1:0] EVENT_UNIT_ADDR_START = magia_tile_pkg::EVENT_UNIT_ADDR_START,
  parameter logic [magia_pkg::ADDR_W-1:0] EVENT_UNIT_ADDR_END   = magia_tile_pkg::EVENT_UNIT_ADDR_END
)(
  input  logic clk_i,
  input  logic rst_ni,

  // Core data interface (input from cv32e40p)
  input  magia_tile_pkg::core_data_req_t core_data_req_i,
  output magia_tile_pkg::core_data_rsp_t core_data_rsp_o,

  // Regular crossbar interface (for general memory/peripheral access)
  output magia_tile_pkg::core_data_req_t xbar_data_req_o,
  input  magia_tile_pkg::core_data_rsp_t xbar_data_rsp_i,

  // EU direct link interface (abstract types)
  output magia_tile_pkg::eu_direct_req_t eu_direct_req_o,
  input  magia_tile_pkg::eu_direct_rsp_t eu_direct_rsp_i
);

  // ---------------------------------------------------------------------------
  // Address decode (combinatorial)
  // ---------------------------------------------------------------------------

  logic use_eu_direct;

  assign use_eu_direct = core_data_req_i.req &&
                         (core_data_req_i.addr >= EVENT_UNIT_ADDR_START) &&
                         (core_data_req_i.addr <  EVENT_UNIT_ADDR_END);

  // ---------------------------------------------------------------------------
  // In-order response tracking — 2-entry FIFO of issued destinations
  //
  // Same approach as data_periph_demux in the PULP cluster.  The FIFO tracks
  // which path (EU or XBAR) each outstanding request was sent to and therefore
  // which path must supply the *next* response to forward to the core.
  //
  // arriving_order[0] = most-recently pushed (newest)
  // arriving_order[1] = oldest (= head, must respond first)
  //
  // CV32E40P LSU has DEPTH=2 outstanding, so a 2-entry FIFO is sufficient.
  // A single registered bit (as used previously) is NOT enough: if two
  // requests go to different paths the second grant overwrites the first
  // destination, causing the response of the first to be routed to the wrong
  // instruction or silently dropped.
  // ---------------------------------------------------------------------------

  typedef enum logic { XBAR_D = 1'b0, EU_D = 1'b1 } dest_e;

  dest_e   destination;          // combinatorial: destination of the current request
  dest_e   arriving_order [0:1]; // FIFO: [0]=newest, [1]=oldest
  logic [1:0] num_outstanding;
  dest_e   head;                 // combinatorial: oldest pending destination

  assign destination = use_eu_direct ? EU_D : XBAR_D;

  always_comb begin : _HEAD_MUX_
    case (num_outstanding)
      2'd2:    head = arriving_order[1]; // oldest
      2'd1:    head = arriving_order[0];
      default: head = XBAR_D;            // idle, value unused
    endcase
  end

  // ---------------------------------------------------------------------------
  // Out-of-order response capture
  //
  // If a path's rvalid arrives while it is NOT at the head of the FIFO the
  // response would be lost.  A 1-entry capture register per path holds it
  // until that path reaches the head.  With DEPTH=2 at most one response can
  // be queued behind the other at any time.
  // ---------------------------------------------------------------------------

  logic        eu_cap_rvalid_q;
  logic [31:0] eu_cap_rdata_q;
  logic        eu_cap_err_q;

  logic        xbar_cap_rvalid_q;
  logic [31:0] xbar_cap_rdata_q;
  logic        xbar_cap_err_q;

  // "Effective" rvalid/rdata: direct arrival OR previously captured
  logic        eu_rvalid_eff, xbar_rvalid_eff;
  logic [31:0] eu_rdata_eff,  xbar_rdata_eff;
  logic        eu_err_eff,    xbar_err_eff;

  // Direct arrival takes priority so the capture register is consumed first
  // only when nothing arrives directly that cycle.
  assign eu_rvalid_eff   = eu_direct_rsp_i.rvalid   | eu_cap_rvalid_q;
  assign eu_rdata_eff    = eu_direct_rsp_i.rvalid    ? eu_direct_rsp_i.rdata : eu_cap_rdata_q;
  assign eu_err_eff      = eu_direct_rsp_i.rvalid    ? eu_direct_rsp_i.err   : eu_cap_err_q;

  assign xbar_rvalid_eff = xbar_data_rsp_i.rvalid   | xbar_cap_rvalid_q;
  assign xbar_rdata_eff  = xbar_data_rsp_i.rvalid   ? xbar_data_rsp_i.rdata : xbar_cap_rdata_q;
  assign xbar_err_eff    = xbar_data_rsp_i.rvalid   ? xbar_data_rsp_i.err   : xbar_cap_err_q;

  // Response forwarded to the core this cycle
  logic resp_valid_to_core;
  always_comb begin : _RESP_VALID_MUX_
    if (num_outstanding == '0)
      resp_valid_to_core = 1'b0;
    else if (head == EU_D)
      resp_valid_to_core = eu_rvalid_eff;
    else
      resp_valid_to_core = xbar_rvalid_eff;
  end

  // Capture/clear FFs
  always_ff @(posedge clk_i, negedge rst_ni) begin : _CAPTURE_FFS_
    if (!rst_ni) begin
      eu_cap_rvalid_q   <= 1'b0;
      eu_cap_rdata_q    <= '0;
      eu_cap_err_q      <= 1'b0;
      xbar_cap_rvalid_q <= 1'b0;
      xbar_cap_rdata_q  <= '0;
      xbar_cap_err_q    <= 1'b0;
    end else begin
      // EU: capture when rvalid arrives and EU is not at head;
      //     clear when EU response is forwarded to core.
      if (eu_direct_rsp_i.rvalid && (num_outstanding > 0) && (head != EU_D)) begin
        eu_cap_rvalid_q <= 1'b1;
        eu_cap_rdata_q  <= eu_direct_rsp_i.rdata;
        eu_cap_err_q    <= eu_direct_rsp_i.err;
      end else if ((head == EU_D) && resp_valid_to_core) begin
        eu_cap_rvalid_q <= 1'b0;
      end

      // XBAR: same logic
      if (xbar_data_rsp_i.rvalid && (num_outstanding > 0) && (head != XBAR_D)) begin
        xbar_cap_rvalid_q <= 1'b1;
        xbar_cap_rdata_q  <= xbar_data_rsp_i.rdata;
        xbar_cap_err_q    <= xbar_data_rsp_i.err;
      end else if ((head == XBAR_D) && resp_valid_to_core) begin
        xbar_cap_rvalid_q <= 1'b0;
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
      arriving_order[0] <= XBAR_D;
      arriving_order[1] <= XBAR_D;
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
  // Gate with num_outstanding < 2 to prevent FIFO overflow (CV32E40P DEPTH=2).
  // Back-to-back allowed when a response is simultaneously being consumed.
  // ---------------------------------------------------------------------------

  logic can_issue;
  assign can_issue = (num_outstanding < 2) || fifo_pop;

  // To regular crossbar
  assign xbar_data_req_o.req     = core_data_req_i.req && !use_eu_direct && can_issue;
  assign xbar_data_req_o.addr    = core_data_req_i.addr;
  assign xbar_data_req_o.be      = core_data_req_i.be;
  assign xbar_data_req_o.wdata   = core_data_req_i.wdata;
  assign xbar_data_req_o.we      = core_data_req_i.we;
`ifdef CV32E40X
  assign xbar_data_req_o.atop    = core_data_req_i.atop;
  assign xbar_data_req_o.memtype = core_data_req_i.memtype;
  assign xbar_data_req_o.prot    = core_data_req_i.prot;
  assign xbar_data_req_o.dbg     = core_data_req_i.dbg;
`endif

  // To EU direct link
  assign eu_direct_req_o.req   = core_data_req_i.req && use_eu_direct && can_issue;
  assign eu_direct_req_o.addr  = core_data_req_i.addr - EVENT_UNIT_ADDR_START;
  assign eu_direct_req_o.wen   = ~core_data_req_i.we;
  assign eu_direct_req_o.wdata = core_data_req_i.wdata;
  assign eu_direct_req_o.be    = core_data_req_i.be;

  // ---------------------------------------------------------------------------
  // Response mux to core — select from head path (direct or captured)
  // ---------------------------------------------------------------------------

  always_comb begin : _HANDLE_RESP_
    core_data_rsp_o.rvalid = resp_valid_to_core;
    if (head == EU_D) begin
      core_data_rsp_o.rdata  = eu_rdata_eff;
      core_data_rsp_o.err    = eu_err_eff;
`ifdef CV32E40X
      core_data_rsp_o.exokay = '0;
`endif
    end else begin
      core_data_rsp_o.rdata  = xbar_rdata_eff;
      core_data_rsp_o.err    = xbar_err_eff;
`ifdef CV32E40X
      core_data_rsp_o.exokay = xbar_data_rsp_i.exokay;
`endif
    end
  end

  // GNT: combinatorial from selected path, gated by can_issue
  assign core_data_rsp_o.gnt = can_issue && (use_eu_direct ? eu_direct_rsp_i.gnt
                                                            : xbar_data_rsp_i.gnt);

endmodule