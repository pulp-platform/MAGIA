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
 * Authors: Carlotta Chiarini
 
 * Mcast Generator
 
 * This module sets up the user field for a broadcast operation.
 * If the MSB is B, the transaction is recognized as a broadcast operation.
 */

module mcast_gen
  import magia_noc_pkg::*;
(
  input  magia_tile_pkg::core_axi_data_req_t data_req_i,
  output magia_tile_pkg::core_axi_data_req_t data_req_o
);


// w chan
assign data_req_o.w = data_req_i.w;
assign data_req_o.w_valid = data_req_i.w_valid;
assign data_req_o.b_ready = data_req_i.b_ready;

// ar chan
assign data_req_o.ar = data_req_i.ar;
assign data_req_o.ar_valid = data_req_i.ar_valid;
assign data_req_o.r_ready = data_req_i.r_ready;

// aw chan
assign data_req_o.aw_valid = data_req_i.aw_valid;
assign data_req_o.aw.id = data_req_i.aw.id;
assign data_req_o.aw.addr = (data_req_i.aw.addr[31:28] == 4'hb) ? (data_req_i.aw.addr & 32'h0FFFFFFF) : data_req_i.aw.addr;
assign data_req_o.aw.len = data_req_i.aw.len;
assign data_req_o.aw.size = data_req_i.aw.size;
assign data_req_o.aw.burst = data_req_i.aw.burst;
assign data_req_o.aw.lock = data_req_i.aw.lock;
assign data_req_o.aw.cache = data_req_i.aw.cache;
assign data_req_o.aw.prot = data_req_i.aw.prot;
assign data_req_o.aw.qos = data_req_i.aw.qos;
assign data_req_o.aw.region = data_req_i.aw.region;
assign data_req_o.aw.atop = data_req_i.aw.atop;
assign data_req_o.aw.user = (data_req_i.aw.addr[31:28] == 4'hb) ? {magia_noc_pkg::BroadcastMask, magia_noc_pkg::CollectiveOp} : '0;

endmodule: mcast_gen