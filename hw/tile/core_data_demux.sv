/*
 * Copyright (C) 2026 ETH Zurich, University of Bologna and Fondazione Chips-IT
 *
 * Licensed under the Solderpad Hardware License, Version 0.51
 * (the "License"); you may not use this file except in compliance
 * with the License. You may obtain a copy of the License at
 *
 *     http://solderpad.org/licenses/SHL-0.51
 *
 * Unless required by applicable law or agreed to in writing, software, hardware
 * and materials distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * SPDX-License-Identifier: SHL-0.51
 *
 * Authors: Niccolò Giuliani <niccolo.giuliani@chips.it>
 *          Luca Balboni <luca.balboni@chips.it>
 *
 * Core Data Demux: address demux of a core data port with in-order responses and AMO ordering
 *
 */

module core_data_demux
  import magia_tile_pkg::*;
  import magia_pkg::*;
#(
  parameter int unsigned       NumSlv     = 2,             // Number of downstream slave ports
  parameter int unsigned       NumRules   = 1,             // Number of address rules
  parameter int unsigned       DefaultSlv = NumSlv-1,      // Unmapped addresses and atomics
  parameter logic [NumSlv-1:0] SerialSlv  = '0,            // Slaves whose accesses block later ones
  parameter logic [NumSlv-1:0] BypassSlv  = '0,            // Slaves that skip the AMO resolver
  parameter type               req_t      = magia_tile_pkg::core_data_req_t,
  parameter type               rsp_t      = magia_tile_pkg::core_data_rsp_t,
  localparam int unsigned      SelW       = magia_tile_pkg::gen_idx_width(NumSlv)
)(
  input  logic clk_i,
  input  logic rst_ni,
  input  logic clk_en_i,  // Core clock enable: nothing is issued or answered while low

  input  req_t core_data_req_i,
  input  logic core_data_atomic_i,  // Travels alone to DefaultSlv, home of the AMO resolver
  output rsp_t core_data_rsp_o,

  input  magia_tile_pkg::obi_xbar_rule_t [NumRules-1:0] addr_map_i,

  output req_t [NumSlv-1:0] slv_data_req_o,
  input  rsp_t [NumSlv-1:0] slv_data_rsp_i
);

  // The cores keep at most 2 requests outstanding and take responses in issue order
  localparam int unsigned MaxTrans = 2;

  logic [SelW-1:0] addr_slv;
  logic [SelW-1:0] destination;
  logic            redirect;
  logic            serial;

  logic [SelW-1:0] order_d [MaxTrans];  // Destinations of the outstanding requests, oldest first
  logic [SelW-1:0] order_q [MaxTrans];
  logic [1:0]      cnt_d, cnt_q;                // Outstanding requests
  logic            serial_d, serial_q;          // The newest outstanding request is serializing
  logic            amo_shadow_d, amo_shadow_q;  // An AMO write-back may still be pending

  rsp_t [NumSlv-1:0] rsp;
  logic [NumSlv-1:0] rsp_empty;
  logic [NumSlv-1:0] rsp_pop;
  logic [SelW-1:0]   head;
  logic              serial_pending;
  logic              drained;
  logic              can_issue;
  logic              push, pop;

  // ---------------------------------------------------------------------------
  // Address decode
  // ---------------------------------------------------------------------------

  addr_decode #(
    .NoIndices ( NumSlv                          ),
    .NoRules   ( NumRules                        ),
    .addr_t    ( logic [magia_pkg::ADDR_W-1:0]   ),
    .rule_t    ( magia_tile_pkg::obi_xbar_rule_t )
  ) i_addr_decode (
    .addr_i           ( core_data_req_i.addr ),
    .addr_map_i       ( addr_map_i           ),
    .idx_o            ( addr_slv             ),
    .dec_valid_o      (                      ),
    .dec_error_o      (                      ),
    .en_default_idx_i ( 1'b1                 ),
    .default_idx_i    ( SelW'(DefaultSlv)    )
  );

  // The resolver answers an AMO before its write-back: the next bypassing access queues behind it
  assign redirect    = amo_shadow_q & BypassSlv[addr_slv];
  assign destination = (core_data_atomic_i | redirect) ? SelW'(DefaultSlv) : addr_slv;
  // Atomics and redirected accesses serialize: a later access on another path could overtake them
  assign serial      = core_data_atomic_i | redirect | SerialSlv[destination];

  // ---------------------------------------------------------------------------
  // Request issue and in-order responses
  // ---------------------------------------------------------------------------

  // Responses wait for their turn here, also while the core clock is off: up to MaxTrans per slave
  for (genvar s = 0; s < NumSlv; s++) begin : gen_rsp_fifo
    assign rsp_pop[s] = pop & (head == SelW'(s));

    fifo_v3 #(
      .FALL_THROUGH ( 1'b1     ),
      .DEPTH        ( MaxTrans ),
      .dtype        ( rsp_t    )
    ) i_rsp_fifo (
      .clk_i,
      .rst_ni,
      .flush_i    ( 1'b0                     ),
      .testmode_i ( 1'b0                     ),
      .full_o     (                          ),
      .empty_o    ( rsp_empty[s]             ),
      .usage_o    (                          ),
      .data_i     ( slv_data_rsp_i[s]        ),
      .push_i     ( slv_data_rsp_i[s].rvalid ),
      .data_o     ( rsp[s]                   ),
      .pop_i      ( rsp_pop[s]               )
    );
  end

  assign head           = order_q[0];
  assign pop            = clk_en_i & (cnt_q != '0) & ~rsp_empty[head];
  assign serial_pending = serial_q & ~(pop & (cnt_q == 2'd1));
  assign drained        = (cnt_q == '0) | ((cnt_q == 2'd1) & pop);
  // An atomic also waits for earlier accesses: a granted TCDM write may not have reached its bank
  assign can_issue      = clk_en_i & ((cnt_q != 2'(MaxTrans)) | pop) & ~serial_pending &
                          (~core_data_atomic_i | drained);
  assign push           = can_issue & core_data_req_i.req & slv_data_rsp_i[destination].gnt;

  always_comb begin : _REQ_FWD_
    for (int unsigned s = 0; s < NumSlv; s++) begin
      slv_data_req_o[s]     = core_data_req_i;
      slv_data_req_o[s].req = core_data_req_i.req & (destination == SelW'(s)) & can_issue;
    end
  end

  always_comb begin : _RSP_FWD_
    core_data_rsp_o        = rsp[head];
    core_data_rsp_o.rvalid = pop;
    core_data_rsp_o.gnt    = ~clk_en_i | (can_issue & slv_data_rsp_i[destination].gnt);
  end

  // ---------------------------------------------------------------------------
  // Next state and flops
  // ---------------------------------------------------------------------------

  always_comb begin : _ORDER_
    order_d = order_q;
    cnt_d   = cnt_q;
    if (pop) begin
      order_d[0] = order_q[1];
      cnt_d      = cnt_q - 2'd1;
    end
    if (push) begin
      order_d[cnt_d[0]] = destination;
      cnt_d             = cnt_d + 2'd1;
    end
  end

  always_comb begin : _SERIAL_
    serial_d = serial_q;
    if (push) begin
      serial_d = serial;
    end else if (pop & (cnt_q == 2'd1)) begin
      serial_d = 1'b0;
    end
  end

  always_comb begin : _AMO_SHADOW_
    amo_shadow_d = amo_shadow_q;
    if (push & core_data_atomic_i) begin
      amo_shadow_d = 1'b1;
    end else if (push & redirect) begin
      amo_shadow_d = 1'b0;
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin : _STATE_
    if (!rst_ni) begin
      order_q      <= '{default: '0};
      cnt_q        <= '0;
      serial_q     <= 1'b0;
      amo_shadow_q <= 1'b0;
    end else begin
      order_q      <= order_d;
      cnt_q        <= cnt_d;
      serial_q     <= serial_d;
      amo_shadow_q <= amo_shadow_d;
    end
  end

`ifndef SYNTHESIS
  for (genvar s = 0; s < NumSlv; s++) begin : gen_assert
    assert property (@(posedge clk_i) disable iff (!rst_ni)
                     !(slv_data_rsp_i[s].rvalid & (cnt_q == '0)))
      else $fatal(1, "core_data_demux: response from slave %0d without an outstanding request", s);
  end
`endif

endmodule
