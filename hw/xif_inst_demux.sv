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
 * Xif Instruction Demuxer
 */

module xif_inst_demux 
  import redmule_tile_pkg::*;
  import cv32e40x_pkg::*;
#(
  parameter int unsigned N_COPROC    = redmule_tile_pkg::N_COPROC,
  parameter int unsigned N_OPCODE    = redmule_tile_pkg::N_OPCODE,
  parameter int unsigned DEFAULT_IDX = redmule_tile_pkg::DEFAULT_IDX,
  parameter int unsigned OPCODE_OFF  = redmule_tile_pkg::DMA_OPCODE_OFF,
  parameter int unsigned OPCODE_W    = redmule_tile_pkg::DMA_OPCODE_W,
  parameter type xif_inst_rule_t     = redmule_tile_pkg::xif_inst_rule_t
)(
  cv32e40x_if_xif.coproc_issue                          xif_issue_if_i,
  cv32e40x_if_xif.cpu_issue                             xif_issue_if_o[N_COPROC],

  input redmule_tile_pkg::xif_inst_rule_t[N_COPROC-1:0] rules_i
);

  logic[OPCODE_W-1:0] opcode;
  logic[N_COPROC-1:0] coproc_opcode;    // Indicates which coprocessor expects detected OPCODE
  logic[N_COPROC-1:0] coproc_issue;     // Indicates to which coprocessor the instruction should be dispatched
  logic[N_COPROC-1:0] coproc_issue_pr;  // Priority encoded version of the above signal: used to ensure the instruction is dispatched to only 1 coprocessor
  logic               default_issue;    // Indicates that the instruction should be dispatched to the default coprocessor

  assign opcode        = xif_issue_if_i.issue_req.instr[OPCODE_OFF+OPCODE_W-1:OPCODE_OFF];
  assign default_issue = ~(|coproc_opcode);
  assign coproc_issue  = default_issue ? (1 << DEFAULT_IDX) : coproc_opcode;

  always_comb begin
    for (int i = 0; i < N_COPROC; i++) begin
      coproc_opcode[i] = 1'b0;
      for (int j = 0; j < N_OPCODE; j++) begin
        coproc_opcode[i] |= (opcode == rules_i[i].opcode_list[j]) ? 1'b1 : 1'b0;
      end
    end
  end

  always_comb begin
    coproc_issue_pr = '0;
    for (int i = N_COPROC-1; i >= 0; i--) begin
      coproc_issue_pr = coproc_issue[i] ? 1 << i : coproc_issue_pr;
    end
  end

  generate
    for (genvar i = 0; i < N_COPROC; i++) begin
      always_comb begin
        XIF_DISPATCHER_NOT_ONEHOT: assert ($onehot(coproc_issue_pr)) else $fatal("Xif dispatcher detected a number of isses != 1");
        if (coproc_issue_pr[i]) begin
          xif_issue_if_o[i].issue_valid = xif_issue_if_i.issue_valid;
          xif_issue_if_i.issue_ready    = xif_issue_if_o[i].issue_ready;
          xif_issue_if_o[i].issue_req   = xif_issue_if_i.issue_req;
          xif_issue_if_i.issue_resp     = xif_issue_if_o[i].issue_resp;
        end else begin
          xif_issue_if_o[i].issue_valid = '0;
          xif_issue_if_o[i].issue_req   = '0;
        end
      end
    end
  endgenerate

endmodule: xif_inst_demux