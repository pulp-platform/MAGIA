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
 * Fractal Sync Xif Instruction Decoder
 */

module fractal_sync_xif_inst_decoder 
  import magia_tile_pkg::*;
  import cv32e40x_pkg::*;
#(
  parameter int unsigned INSTR_W    = magia_tile_pkg::FSYNC_INSTR_W,
  parameter int unsigned DATA_W     = magia_tile_pkg::FSYNC_DATA_W,
  parameter int unsigned ADDR_W     = magia_tile_pkg::FSYNC_ADDR_W,
  parameter int unsigned N_RF_PORTS = magia_tile_pkg::FSYNC_N_RF_PORTS,
  parameter int unsigned OPCODE_W   = magia_tile_pkg::FSYNC_OPCODE_W,
  parameter int unsigned FUNC3_W    = magia_tile_pkg::FSYNC_FUNC3_W,
  parameter int unsigned OPCODE_OFF = magia_tile_pkg::FSYNC_OPCODE_OFF,
  parameter int unsigned FUNC3_OFF  = magia_tile_pkg::FSYNC_FUNC3_OFF,
  parameter int unsigned N_CFG_REG  = magia_tile_pkg::FSYNC_N_CFG_REG,
  parameter int unsigned LVL_W      = magia_tile_pkg::FSYNC_LVL_W,
  parameter bit          STALL      = magia_tile_pkg::FSYNC_STALL
)(
  input  logic                 clk_i,
  input  logic                 rst_ni,
  input  logic                 clear_i,

  cv32e40x_if_xif.coproc_issue xif_issue_if_i,
  fractal_if.mst_port          sync_if_o,

  output logic                 done_o,
  output logic                 error_o
);

/*******************************************************/
/**       Internal Signal Definitions Beginning       **/
/*******************************************************/

  logic clk_dec_en, clk_sync_en;
  logic clk_dec_g,  clk_sync_g;
  
  logic[OPCODE_W-1:0] opcode;
  logic[ FUNC3_W-1:0] func3;

  logic sync;
  logic done;

  logic[N_CFG_REG-1:0][DATA_W-1:0] cfg_reg_d, cfg_reg_q;
  
  typedef enum logic[1:0] {
    IDLE,
    SYNC,
    WAIT,
    ACK
  } sync_state_e;

  sync_state_e c_sync_state, n_sync_state;

/*******************************************************/
/**          Internal Signal Definitions End          **/
/*******************************************************/
/**            Hardwired Signals Beginning            **/
/*******************************************************/
  
  assign opcode = xif_issue_if_i.issue_req.instr[OPCODE_OFF+:OPCODE_W];
  assign func3  = xif_issue_if_i.issue_req.instr[ FUNC3_OFF+: FUNC3_W];

  assign done_o  = done;
  assign error_o = sync_if_o.error;

/*******************************************************/
/**               Hardwired Signals End               **/
/*******************************************************/
/**               Clock gating Beginning              **/
/*******************************************************/

  tc_clk_gating i_dec_clock_gating (
    .clk_i                   ,
    .en_i      ( clk_dec_en ),
    .test_en_i ( '0         ),
    .clk_o     ( clk_dec_g  )
  );

  tc_clk_gating i_sync_clock_gating (
    .clk_i                    ,
    .en_i      ( clk_sync_en ),
    .test_en_i ( '0          ),
    .clk_o     ( clk_sync_g  )
  );

/*******************************************************/
/**                  Clock gating End                 **/
/*******************************************************/
/**               Decoder FSM Beginning               **/
/*******************************************************/

  generate if (STALL) begin: gen_stalling_decoder
    always_comb begin: instruction_decoder
      clk_dec_en = 1'b0;
      cfg_reg_d  = cfg_reg_q;
      sync       = 1'b0;

      if (xif_issue_if_i.issue_valid) begin
        case (opcode)
          FSYNC_OPCODE: begin
            clk_dec_en = 1'b1;
            if ((func3 == FSYNC_FUNC3) && (xif_issue_if_i.issue_req.rs_valid)) begin
              cfg_reg_d[magia_tile_pkg::FSYNC_LEVEL_IDX] = xif_issue_if_i.issue_req.rs[0];
              sync                                       = 1'b1;
            end
          end
        endcase
      end
    end
  end else begin: gen_non_stalling_decoder
    always_comb begin: instruction_decoder
      clk_dec_en                 = 1'b0;
      cfg_reg_d                  = cfg_reg_q;
      sync                       = 1'b0;
      xif_issue_if_i.issue_ready = 1'b0;
      xif_issue_if_i.issue_resp  = '0;

      if (xif_issue_if_i.issue_valid) begin
        case (opcode)
          FSYNC_OPCODE: begin
            xif_issue_if_i.issue_ready       = 1'b1;
            xif_issue_if_i.issue_resp.accept = 1'b1;
            clk_dec_en                       = 1'b1;
            if ((func3 == FSYNC_FUNC3) && (xif_issue_if_i.issue_req.rs_valid)) begin
              cfg_reg_d[magia_tile_pkg::FSYNC_LEVEL_IDX] = xif_issue_if_i.issue_req.rs[0];
              sync                                       = 1'b1;
            end
          end
        endcase
      end
    end
  end endgenerate

  always_ff @(posedge clk_dec_g, negedge rst_ni) begin: configuration_register
    if (~rst_ni)   cfg_reg_q <= '0;
    else begin
      if (clear_i) cfg_reg_q <= '0;
      else         cfg_reg_q <= cfg_reg_d;
    end
  end

/*******************************************************/
/**                  Decoder FSM End                  **/
/*******************************************************/
/**           Synchronization FSM Beginning           **/
/*******************************************************/

  generate if (STALL) begin: gen_stalling_sync
    always_comb begin: sync_logic
      n_sync_state               = c_sync_state;
      clk_sync_en                = 1'b1;
      done                       = 1'b0;
      sync_if_o.sync             = 1'b0;
      sync_if_o.level            = '0;
      sync_if_o.ack              = 1'b0;
      xif_issue_if_i.issue_ready = 1'b0;
      xif_issue_if_i.issue_resp  = '0;

      case (c_sync_state)
        IDLE: if (sync) n_sync_state = SYNC; else clk_sync_en = 1'b0;
        SYNC: begin
          sync_if_o.sync                   = 1'b1;
          sync_if_o.level                  = cfg_reg_q[magia_tile_pkg::FSYNC_LEVEL_IDX][FSYNC_LVL_W-1:0];
          n_sync_state                     = WAIT;
        end
        WAIT: begin
          n_sync_state                     = sync_if_o.wake ? ACK : WAIT;
        end
        ACK: begin
          sync_if_o.ack                    = 1'b1;
          done                             = 1'b1;
          n_sync_state                     = IDLE;
          xif_issue_if_i.issue_ready       = 1'b1;
          xif_issue_if_i.issue_resp.accept = 1'b1;
        end
      endcase
    end
  end else begin: gen_non_stalling_sync
    always_comb begin: sync_logic
      n_sync_state    = c_sync_state;
      clk_sync_en     = 1'b1;
      done            = 1'b0;
      sync_if_o.sync  = 1'b0;
      sync_if_o.level = '0;
      sync_if_o.ack   = 1'b0;

      case (c_sync_state)
        IDLE: if (sync) n_sync_state = SYNC; else clk_sync_en = 1'b0;
        SYNC: begin
          sync_if_o.sync  = 1'b1;
          sync_if_o.level = cfg_reg_q[magia_tile_pkg::FSYNC_LEVEL_IDX][FSYNC_LVL_W-1:0];
          n_sync_state    = WAIT;
        end
        WAIT: begin
          n_sync_state    = sync_if_o.wake ? ACK : WAIT;
        end
        ACK: begin
          sync_if_o.ack   = 1'b1;
          done            = 1'b1;
          n_sync_state    = IDLE;
        end
      endcase
    end
  end endgenerate

  always_ff @(posedge clk_sync_g, negedge rst_ni) begin: sync_state
    if (~rst_ni)   c_sync_state <= IDLE;
    else begin
      if (clear_i) c_sync_state <= IDLE;
      else         c_sync_state <= n_sync_state;
    end
  end

/*******************************************************/
/**              Synchronization FSM End              **/
/*******************************************************/

endmodule: fractal_sync_xif_inst_decoder