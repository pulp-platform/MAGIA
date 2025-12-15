/*
 * Copyright (C) 2023-2024 ETH Zurich and University of Bologna
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

  enum logic {XBAR, EU} request_destination, request_destination_next;

  // Address range detection for EU direct access (pure combinatorial)
  logic use_eu_direct;
  logic request_granted;
  
  assign use_eu_direct = core_data_req_i.req && 
                        (core_data_req_i.addr >= EVENT_UNIT_ADDR_START) &&
                        (core_data_req_i.addr <= EVENT_UNIT_ADDR_END);

  // Grant occurs when request is accepted by the selected path
  assign request_granted = core_data_req_i.req && core_data_rsp_o.gnt;

  // Determine next destination when a request is granted
  assign request_destination_next = use_eu_direct ? EU : XBAR;

  // Update response destination based on GRANTED request
  always_ff @(posedge clk_i, negedge rst_ni) begin : _UPDATE_RESPONSE_DESTINATION_
    if (!rst_ni) begin
      request_destination <= XBAR;
    end else begin
      if (request_granted) begin
        request_destination <= request_destination_next;
      end
    end
  end

  // To regular crossbar
  assign xbar_data_req_o.req     = core_data_req_i.req && !use_eu_direct;
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

  // To EU direct link (abstract interface)
  // Pass relative offset to Event Unit (subtract base address)
  // Event Unit expects offset within its address space [9:0], not absolute address
  assign eu_direct_req_o.req   = core_data_req_i.req && use_eu_direct;
  assign eu_direct_req_o.addr  = core_data_req_i.addr - EVENT_UNIT_ADDR_START;
  assign eu_direct_req_o.wen   = ~core_data_req_i.we;  // EU expects wen (write enable negated)
  assign eu_direct_req_o.wdata = core_data_req_i.wdata;
  assign eu_direct_req_o.be    = core_data_req_i.be;

  // Response routing - uses stored destination
  always_comb begin : _HANDLE_RESP_
    case (request_destination)
      XBAR: begin
        core_data_rsp_o.rvalid = xbar_data_rsp_i.rvalid;
        core_data_rsp_o.rdata  = xbar_data_rsp_i.rdata;
        core_data_rsp_o.err    = xbar_data_rsp_i.err;
`ifdef CV32E40X
        core_data_rsp_o.exokay = xbar_data_rsp_i.exokay;
`endif
      end
      EU: begin
        core_data_rsp_o.rvalid = eu_direct_rsp_i.rvalid;
        core_data_rsp_o.rdata  = eu_direct_rsp_i.rdata;
        core_data_rsp_o.err    = eu_direct_rsp_i.err;
`ifdef CV32E40X
        core_data_rsp_o.exokay = '0;
`endif
      end
    endcase
  end

  // GNT is combinatorial
  assign core_data_rsp_o.gnt = use_eu_direct ? eu_direct_rsp_i.gnt : xbar_data_rsp_i.gnt;

endmodule