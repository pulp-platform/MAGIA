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
 * 
 * EU Direct Link Cut
 */

module eu_direct_cut 
  import magia_tile_pkg::*;
#(
  parameter type eu_direct_req_t = logic,
  parameter type eu_direct_rsp_t = logic,
  parameter bit  Bypass          = 1'b0,
  parameter bit  BypassReq       = Bypass,
  parameter bit  BypassRsp       = Bypass
)(
  input  logic           clk_i,
  input  logic           rst_ni,

  input  eu_direct_req_t sbr_req_i,
  output eu_direct_rsp_t sbr_rsp_o,

  output eu_direct_req_t mgr_req_o,
  input  eu_direct_rsp_t mgr_rsp_i
);

  // Request payload (exclude req signal for valid/ready)
  typedef struct packed {
    logic[magia_pkg::ADDR_W-1:0] addr;
    logic                        wen;
    logic[magia_pkg::DATA_W-1:0] wdata;
    logic[3:0]                   be;
  } eu_req_payload_t;
  
  eu_req_payload_t sbr_req_payload, mgr_req_payload;
  
  assign sbr_req_payload.addr  = sbr_req_i.addr;
  assign sbr_req_payload.wen   = sbr_req_i.wen;
  assign sbr_req_payload.wdata = sbr_req_i.wdata;
  assign sbr_req_payload.be    = sbr_req_i.be;
  
  assign mgr_req_o.addr  = mgr_req_payload.addr;
  assign mgr_req_o.wen   = mgr_req_payload.wen;
  assign mgr_req_o.wdata = mgr_req_payload.wdata;
  assign mgr_req_o.be    = mgr_req_payload.be;

  // Request spill register
  spill_register #(
    .T      ( eu_req_payload_t ),
    .Bypass ( BypassReq        )
  ) i_req_spill (
    .clk_i   ( clk_i              ),
    .rst_ni  ( rst_ni             ),
    .valid_i ( sbr_req_i.req      ),
    .ready_o ( sbr_rsp_o.gnt      ),
    .data_i  ( sbr_req_payload    ),
    .valid_o ( mgr_req_o.req      ),
    .ready_i ( mgr_rsp_i.gnt      ),
    .data_o  ( mgr_req_payload    )
  );

  // Response payload (exclude rvalid for valid/ready)
  typedef struct packed {
    logic[magia_pkg::DATA_W-1:0] rdata;
    logic                        err;
  } eu_rsp_payload_t;
  
  eu_rsp_payload_t sbr_rsp_payload, mgr_rsp_payload;
  
  assign mgr_rsp_payload.rdata = mgr_rsp_i.rdata;
  assign mgr_rsp_payload.err   = mgr_rsp_i.err;
  
  assign sbr_rsp_o.rdata = sbr_rsp_payload.rdata;
  assign sbr_rsp_o.err   = sbr_rsp_payload.err;

  // Response spill register
  spill_register #(
    .T      ( eu_rsp_payload_t ),
    .Bypass ( BypassRsp        )
  ) i_rsp_spill (
    .clk_i   ( clk_i              ),
    .rst_ni  ( rst_ni             ),
    .valid_i ( mgr_rsp_i.rvalid   ),
    .ready_o (                    ),
    .data_i  ( mgr_rsp_payload    ),
    .valid_o ( sbr_rsp_o.rvalid   ),
    .ready_i ( 1'b1               ),
    .data_o  ( sbr_rsp_payload    )
  );

endmodule
