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
  parameter int unsigned DEFAULT_IDX = redmule_tile_pkg::DEFAULT_IDX,
  parameter int unsigned OPCODE_OFF  = redmule_tile_pkg::DMA_OPCODE_OFF,
  parameter int unsigned OPCODE_W    = redmule_tile_pkg::DMA_OPCODE_W,
  parameter type xif_inst_rule_t     = redmule_tile_pkg::xif_inst_rule_t
)(
  cv32e40x_if_xif.coproc_issue                          xif_issue_if_i,
  cv32e40x_if_xif.coproc_issue[N_COPROC-1:0]            xif_issue_if_o,

  input redmule_tile_pkg::xif_inst_rule_t[N_COPROC-1:0] rules_i
);

  assert(N_COPROC > 1) else $fatal("Xif instruction demux requires 2+ coprocessors");
  assert(DEFAULT_IDX >= 0 && DEFAULT_IDX < N_COPROC) else $fatal("Xif instruction demux defult index must be within [0:N_COPROC[");

  always_comb begin: instruction_dispatcher
    xif_issue_if_o[DEFAULT_IDX].issue_valid = xif_issue_if_i.issue_valid;
    xif_issue_if_i.issue_ready              = xif_issue_if_o[DEFAULT_IDX].issue_ready;
    xif_issue_if_o[DEFAULT_IDX].issue_req   = xif_issue_if_i.issue_req;
    xif_issue_if_i.issue_resp               = xif_issue_if_o[DEFAULT_IDX].issue_resp;
    for (genvar i = 0; i < N_COPROC; i++) begin: coproc_opcode_decoder
      for (int j = 0; j < rules_i[i].n_opcode; j++) begin
        if (rules_i[i].opcode_list[j] == xif_issue_if_i.issue_req.instr[OPCODE_OFF + OPCODE_W-1:OPCODE_OFF]) begin
          xif_issue_if_o[i].issue_valid = xif_issue_if_i.issue_valid;
          xif_issue_if_i.issue_ready    = xif_issue_if_o[i].issue_ready;
          xif_issue_if_o[i].issue_req   = xif_issue_if_i.issue_req;
          xif_issue_if_i.issue_resp     = xif_issue_if_o[i].issue_resp;
        end
      end
    end
  end

endmodule: xif_inst_demux