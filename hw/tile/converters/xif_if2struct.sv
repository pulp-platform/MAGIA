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
 * Authors: Victor Isachi <victor.isachi@unibo.it>
 * 
 * Xif Interface - Struct Converter
 */

module xif_if2struct
  import cv32e40x_pkg::*;
  import fpu_ss_pkg::*;
(
  cv32e40x_if_xif.coproc_compressed      xif_compressed_if_i,
  cv32e40x_if_xif.coproc_issue           xif_issue_if_i,
  cv32e40x_if_xif.coproc_commit          xif_commit_if_i,
  cv32e40x_if_xif.coproc_mem             xif_mem_if_o,
  cv32e40x_if_xif.coproc_mem_result      xif_mem_result_if_i,
  cv32e40x_if_xif.coproc_result          xif_result_if_o,

  output logic                           x_compressed_valid_o,
  input  logic                           x_compressed_ready_i,
  output fpu_ss_pkg::x_compressed_req_t  x_compressed_req_o,
  input  fpu_ss_pkg::x_compressed_resp_t x_compressed_resp_i,

  output logic                           x_issue_valid_o,
  input  logic                           x_issue_ready_i,
  output fpu_ss_pkg::x_issue_req_t       x_issue_req_o,
  input  fpu_ss_pkg::x_issue_resp_t      x_issue_resp_i,

  output logic                           x_commit_valid_o,
  output fpu_ss_pkg::x_commit_t          x_commit_o,

  input  logic                           x_mem_valid_i,
  output logic                           x_mem_ready_o,
  input  fpu_ss_pkg::x_mem_req_t         x_mem_req_i,
  output fpu_ss_pkg::x_mem_resp_t        x_mem_resp_o,

  output logic                           x_mem_result_valid_o,
  output fpu_ss_pkg::x_mem_result_t      x_mem_result_o,

  input  logic                           x_result_valid_i,
  output logic                           x_result_ready_o,
  input  fpu_ss_pkg::x_result_t          x_result_i
);

  assign x_compressed_valid_o                 = xif_compressed_if_i.compressed_valid;
  assign xif_compressed_if_i.compressed_ready = x_compressed_ready_i;
  assign x_compressed_req_o                   = xif_compressed_if_i.compressed_req;
  assign xif_compressed_if_i.compressed_resp  = x_compressed_resp_i;

  assign x_issue_valid_o            = xif_issue_if_i.issue_valid;
  assign xif_issue_if_i.issue_ready = x_issue_ready_i;
  assign x_issue_req_o              = xif_issue_if_i.issue_req;
  assign xif_issue_if_i.issue_resp  = x_issue_resp_i;

  assign x_commit_valid_o = xif_commit_if_i.commit_valid;
  assign x_commit_o       = xif_commit_if_i.commit;

  assign xif_mem_if_o.mem_valid = x_mem_valid_i;
  assign x_mem_ready_o          = xif_mem_if_o.mem_ready;
  assign xif_mem_if_o.mem_req   = x_mem_req_i;
  assign x_mem_resp_o           = xif_mem_if_o.mem_resp;

  assign x_mem_result_valid_o = xif_mem_result_if_i.mem_result_valid;
  assign x_mem_result_o       = xif_mem_result_if_i.mem_result;

  assign xif_result_if_o.result_valid = x_result_valid_i;
  assign x_result_ready_o             = xif_result_if_o.result_ready;
  assign xif_result_if_o.result       = x_result_i;

endmodule: xif_if2struct  