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
 * Xif Instruction Dispatcher
 */

module xif_inst_dispatcher 
  import magia_tile_pkg::*;
  import cv32e40x_pkg::*;
#(
  parameter int unsigned N_COPROC    = magia_tile_pkg::N_COPROC,
  parameter int unsigned N_RULES     = magia_tile_pkg::N_RULES,
  parameter int unsigned N_SIGN      = magia_tile_pkg::N_SIGN,
  parameter int unsigned DEFAULT_IDX = magia_tile_pkg::DEFAULT_IDX,
  parameter int unsigned OPCODE_OFF  = magia_tile_pkg::OPCODE_OFF,
  parameter int unsigned FUNC3_OFF   = magia_tile_pkg::FUNC3_OFF,
  parameter int unsigned OPCODE_W    = magia_tile_pkg::OPCODE_W,
  parameter int unsigned FUNC3_W     = magia_tile_pkg::FUNC3_W,
  parameter int unsigned SIGN_W      = magia_tile_pkg::SIGN_W,
  parameter type xif_inst_rule_t     = magia_tile_pkg::xif_inst_rule_t
)(
  input  logic                                       clk_i,
  input  logic                                       rst_ni,
  
  cv32e40x_if_xif.coproc_issue                       xif_issue_if_i,
  cv32e40x_if_xif.cpu_issue                          xif_issue_if_o[N_COPROC],

  cv32e40x_if_xif.coproc_result                      xif_result_if_o,
  cv32e40x_if_xif.cpu_result                         xif_result_if_i,

  input magia_tile_pkg::xif_inst_rule_t[N_RULES-1:0] rules_i
);

/*******************************************************/
/**        Parameters and Definitions Beginning       **/
/*******************************************************/

  // IMPORTANT NOTE: must mirror what is found in cv32e40x_if_xif.sv
  typedef struct packed {
    logic      accept;   
    logic      writeback;
    logic      dualwrite;
    logic[2:0] dualread; 
    logic      loadstore;
    logic      ecswrite ;
    logic      exc;      
  } x_issue_resp_t;

  typedef enum logic[1:0] {
    IDLE,
    WAIT,
    PROP
  } result_state_e;

/*******************************************************/
/**           Parameters and Definitions End          **/
/*******************************************************/
/**             Internal Signals Beginning            **/
/*******************************************************/
  
  logic[OPCODE_W-1:0] opcode;
  logic[ FUNC3_W-1:0] func3;
  logic[  SIGN_W-1:0] sign;
  logic[N_COPROC-1:0] coproc_sign;      // Indicates which coprocessor expects detected signiture
  logic[N_COPROC-1:0] coproc_issue;     // Indicates to which coprocessor the instruction should be dispatched
  logic[N_COPROC-1:0] coproc_issue_pr;  // Priority encoded version of the above signal: used to ensure the instruction is dispatched to only 1 coprocessor
  logic               default_issue;    // Indicates that the instruction should be dispatched to the default coprocessor

  logic         [N_COPROC-1:0] issue_ready;
  x_issue_resp_t[N_COPROC-1:0] issue_resp;

  result_state_e c_result_state, n_result_state;

/*******************************************************/
/**                Internal Signals End               **/
/*******************************************************/
/**            Hardwired Signals Beginning            **/
/*******************************************************/
  
  assign opcode        = xif_issue_if_i.issue_req.instr[OPCODE_OFF+OPCODE_W-1:OPCODE_OFF];
  assign func3         = xif_issue_if_i.issue_req.instr[  FUNC3_OFF+FUNC3_W-1:FUNC3_OFF];
  assign sign          = {opcode, func3};
  assign default_issue = ~(|coproc_sign);
  assign coproc_issue  = default_issue ? (1 << DEFAULT_IDX) : coproc_sign;

/*******************************************************/
/**               Hardwired Signals End               **/
/*******************************************************/
/**               IF to Struct Beginning              **/
/*******************************************************/

  for (genvar i = 0; i < N_COPROC; i++) begin: gen_if2signal
    assign issue_ready[i]          = xif_issue_if_o[i].issue_ready;
    assign issue_resp[i].accept    = xif_issue_if_o[i].issue_resp.accept;
    assign issue_resp[i].writeback = xif_issue_if_o[i].issue_resp.writeback;
    assign issue_resp[i].dualwrite = xif_issue_if_o[i].issue_resp.dualwrite;
    assign issue_resp[i].dualread  = xif_issue_if_o[i].issue_resp.dualread;
    assign issue_resp[i].loadstore = xif_issue_if_o[i].issue_resp.loadstore;
    assign issue_resp[i].ecswrite  = xif_issue_if_o[i].issue_resp.ecswrite;
    assign issue_resp[i].exc       = xif_issue_if_o[i].issue_resp.exc;
  end

/*******************************************************/
/**                  IF to Struct End                 **/
/*******************************************************/
/**          Instruction Dispatcher Beginning         **/
/*******************************************************/

  always_comb begin: sign_detector
    for (int i = 0; i < N_COPROC; i++) begin
      coproc_sign[i] = 1'b0;
      if (i < N_RULES) begin  // Only check first N_RULES coprocessors, the rest do not have associated rule
        for (int j = 0; j < N_SIGN; j++) begin
          coproc_sign[i] |= (sign == rules_i[i].sign_list[j]) ? 1'b1 : 1'b0;
        end
      end
    end
  end

  always_comb begin: priority_encoder
    coproc_issue_pr = '0;
    for (int i = 0; i < N_COPROC; i++) begin
      if (coproc_issue[i]) begin
        coproc_issue_pr = 1 << i;
        break;
      end
    end
  end

  for (genvar i = 0; i < N_COPROC; i++) begin: gen_issue_out
    always_comb begin
      if (coproc_issue_pr[i]) begin
        xif_issue_if_o[i].issue_valid = xif_issue_if_i.issue_valid;
        xif_issue_if_o[i].issue_req   = xif_issue_if_i.issue_req;
      end else begin
        xif_issue_if_o[i].issue_valid = '0;
        xif_issue_if_o[i].issue_req   = '0;
      end
    end
  end

  always_comb begin: issue_in
    xif_issue_if_i.issue_ready = '0;
    xif_issue_if_i.issue_resp  = '0;
    for (int i = 0; i < N_COPROC; i++) begin
      if (coproc_issue_pr[i]) begin
        xif_issue_if_i.issue_ready          = issue_ready[i];
        xif_issue_if_i.issue_resp.accept    = issue_resp[i].accept;
        xif_issue_if_i.issue_resp.writeback = issue_resp[i].writeback;
        xif_issue_if_i.issue_resp.dualwrite = issue_resp[i].dualwrite;
        xif_issue_if_i.issue_resp.dualread  = issue_resp[i].dualread;
        xif_issue_if_i.issue_resp.loadstore = issue_resp[i].loadstore;
        xif_issue_if_i.issue_resp.ecswrite  = issue_resp[i].ecswrite;
        xif_issue_if_i.issue_resp.exc       = issue_resp[i].exc;
        break;
      end
    end
  end

  always_ff @(posedge clk_i, negedge rst_ni) begin: result_state_register
    if (!rst_ni) c_result_state <= IDLE;
    else         c_result_state <= n_result_state;
  end

  always_comb begin: result_state_logic
    n_result_state = c_result_state;
    case (c_result_state)
      IDLE: if (!default_issue)                n_result_state = WAIT;
      WAIT: if (xif_result_if_o.result_ready)  n_result_state = PROP;
      PROP: if (!xif_result_if_o.result_ready) n_result_state = default_issue ? IDLE : WAIT;
    endcase
  end
  
  always_comb begin: result_handler
    xif_result_if_o.result_valid = xif_result_if_i.result_valid;
    xif_result_if_i.result_ready = xif_result_if_o.result_ready;
    xif_result_if_o.result       = xif_result_if_i.result;
    if (c_result_state == PROP) begin
      xif_result_if_o.result_valid = xif_result_if_o.result_ready;
      xif_result_if_i.result_ready = 1'b0;
      xif_result_if_o.result       = '0;
    end
  end

/*******************************************************/
/**             Instruction Dispatcher End            **/
/*******************************************************/

endmodule: xif_inst_dispatcher