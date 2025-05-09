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
  parameter int unsigned AGGR_W     = magia_tile_pkg::FSYNC_AGGR_W,
  parameter int unsigned ID_W       = magia_tile_pkg::FSYNC_ID_W,
  parameter int unsigned NBR_AGGR_W = magia_tile_pkg::FSYNC_NBR_AGGR_W,
  parameter int unsigned NBR_ID_W   = magia_tile_pkg::FSYNC_NBR_ID_W,
  parameter bit          STALL      = magia_tile_pkg::FSYNC_STALL
)(
  input  logic                 clk_i,
  input  logic                 rst_ni,
  input  logic                 clear_i,

  cv32e40x_if_xif.coproc_issue xif_issue_if_i,

  fractal_sync_if.mst_port     ht_fsync_if_o,
  fractal_sync_if.mst_port     hn_fsync_if_o,
  fractal_sync_if.mst_port     vt_fsync_if_o,
  fractal_sync_if.mst_port     vn_fsync_if_o,

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
    DONE
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
  assign error_o = ht_fsync_if_o.error | hn_fsync_if_o.error | vt_fsync_if_o.error | vn_fsync_if_o.error;

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
              cfg_reg_d[magia_tile_pkg::FSYNC_AGGR_IDX] = xif_issue_if_i.issue_req.rs[0];
              cfg_reg_d[magia_tile_pkg::FSYNC_ID_IDX]   = xif_issue_if_i.issue_req.rs[1];
              sync                                      = 1'b1;
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
              cfg_reg_d[magia_tile_pkg::FSYNC_AGGR_IDX] = xif_issue_if_i.issue_req.rs[0];
              cfg_reg_d[magia_tile_pkg::FSYNC_ID_IDX]   = xif_issue_if_i.issue_req.rs[1];
              sync                                      = 1'b1;
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
      ht_fsync_if_o.sync         = 1'b0;
      ht_fsync_if_o.aggr         = '0;
      ht_fsync_if_o.id           = '0;
      ht_fsync_if_o.src          = '0;
      hn_fsync_if_o.sync         = 1'b0;
      hn_fsync_if_o.aggr         = '0;
      hn_fsync_if_o.id           = '0;
      hn_fsync_if_o.src          = '0;
      vt_fsync_if_o.sync         = 1'b0;
      vt_fsync_if_o.aggr         = '0;
      vt_fsync_if_o.id           = '0;
      vt_fsync_if_o.src          = '0;
      vn_fsync_if_o.sync         = 1'b0;
      vn_fsync_if_o.aggr         = '0;
      vn_fsync_if_o.id           = '0;
      vn_fsync_if_o.src          = '0;
      xif_issue_if_i.issue_ready = 1'b0;
      xif_issue_if_i.issue_resp  = '0;

      case (c_sync_state)
        IDLE: if (sync) n_sync_state = SYNC; else clk_sync_en = 1'b0;
        SYNC: begin
          n_sync_state = WAIT;
          if (cfg_reg_q[magia_tile_pkg::FSYNC_AGGR_IDX] != 1) begin // Tree (level > 1) request
            case (cfg_reg_q[magia_tile_pkg::FSYNC_ID_IDX][0])
              1'b0: begin                                           // Horizontal tree node request
                ht_fsync_if_o.sync = 1'b1; 
                ht_fsync_if_o.aggr = cfg_reg_q[magia_tile_pkg::FSYNC_AGGR_IDX][AGGR_W-1:0];
                ht_fsync_if_o.id   = cfg_reg_q[magia_tile_pkg::FSYNC_ID_IDX][    ID_W-1:0];
              end  
              1'b1: begin                                           // Vertical tree node request
                vt_fsync_if_o.sync = 1'b1; 
                vt_fsync_if_o.aggr = cfg_reg_q[magia_tile_pkg::FSYNC_AGGR_IDX][AGGR_W-1:0];
                vt_fsync_if_o.id   = cfg_reg_q[magia_tile_pkg::FSYNC_ID_IDX][    ID_W-1:0];
              end
            endcase
          end else begin                                            // Neighbor (level = 1) request
            case (cfg_reg_q[magia_tile_pkg::FSYNC_ID_IDX][1:0])
              2'b00: begin                                          // Horizontal tree node request
                ht_fsync_if_o.sync = 1'b1; 
                ht_fsync_if_o.aggr = cfg_reg_q[magia_tile_pkg::FSYNC_AGGR_IDX][AGGR_W-1:0];
                ht_fsync_if_o.id   = cfg_reg_q[magia_tile_pkg::FSYNC_ID_IDX][    ID_W-1:0];
              end  
              2'b01: begin                                          // Vertical tree node request
                vt_fsync_if_o.sync = 1'b1; 
                vt_fsync_if_o.aggr = cfg_reg_q[magia_tile_pkg::FSYNC_AGGR_IDX][AGGR_W-1:0];
                vt_fsync_if_o.id   = cfg_reg_q[magia_tile_pkg::FSYNC_ID_IDX][    ID_W-1:0];
              end
              2'b10: begin                                          // Horizontal neighbor node request
                hn_fsync_if_o.sync = 1'b1; 
                hn_fsync_if_o.aggr = cfg_reg_q[magia_tile_pkg::FSYNC_AGGR_IDX][NBR_AGGR_W-1:0];
                hn_fsync_if_o.id   = cfg_reg_q[magia_tile_pkg::FSYNC_ID_IDX][    NBR_ID_W-1:0];
              end  
              2'b11: begin                                          // Vertical neighbor node request
                vn_fsync_if_o.sync = 1'b1; 
                vn_fsync_if_o.aggr = cfg_reg_q[magia_tile_pkg::FSYNC_AGGR_IDX][NBR_AGGR_W-1:0];
                vn_fsync_if_o.id   = cfg_reg_q[magia_tile_pkg::FSYNC_ID_IDX][    NBR_ID_W-1:0];
              end
            endcase
          end
        end
        WAIT: begin
          n_sync_state = (ht_fsync_if_o.wake | hn_fsync_if_o.wake | vt_fsync_if_o.wake | vn_fsync_if_o.wake) ? DONE : WAIT;
        end
        DONE: begin
          n_sync_state                     = IDLE;
          done                             = 1'b1;
          xif_issue_if_i.issue_ready       = 1'b1;
          xif_issue_if_i.issue_resp.accept = 1'b1;
        end
      endcase
    end
  end else begin: gen_non_stalling_sync
    always_comb begin: sync_logic
      n_sync_state       = c_sync_state;
      clk_sync_en        = 1'b1;
      done               = 1'b0;
      ht_fsync_if_o.sync = 1'b0;
      ht_fsync_if_o.aggr = '0;
      ht_fsync_if_o.id   = '0;
      ht_fsync_if_o.src  = '0;
      hn_fsync_if_o.sync = 1'b0;
      hn_fsync_if_o.aggr = '0;
      hn_fsync_if_o.id   = '0;
      hn_fsync_if_o.src  = '0;
      vt_fsync_if_o.sync = 1'b0;
      vt_fsync_if_o.aggr = '0;
      vt_fsync_if_o.id   = '0;
      vt_fsync_if_o.src  = '0;
      vn_fsync_if_o.sync = 1'b0;
      vn_fsync_if_o.aggr = '0;
      vn_fsync_if_o.id   = '0;
      vn_fsync_if_o.src  = '0;

      case (c_sync_state)
        IDLE: if (sync) n_sync_state = SYNC; else clk_sync_en = 1'b0;
        SYNC: begin
          n_sync_state = WAIT;
          if (cfg_reg_q[magia_tile_pkg::FSYNC_AGGR_IDX] != 1) begin // Tree (level > 1) request
            case (cfg_reg_q[magia_tile_pkg::FSYNC_ID_IDX][0])
              1'b0: begin                                           // Horizontal tree node request
                ht_fsync_if_o.sync = 1'b1; 
                ht_fsync_if_o.aggr = cfg_reg_q[magia_tile_pkg::FSYNC_AGGR_IDX][AGGR_W-1:0];
                ht_fsync_if_o.id   = cfg_reg_q[magia_tile_pkg::FSYNC_ID_IDX][    ID_W-1:0];
              end  
              1'b1: begin                                           // Vertical tree node request
                vt_fsync_if_o.sync = 1'b1; 
                vt_fsync_if_o.aggr = cfg_reg_q[magia_tile_pkg::FSYNC_AGGR_IDX][AGGR_W-1:0];
                vt_fsync_if_o.id   = cfg_reg_q[magia_tile_pkg::FSYNC_ID_IDX][    ID_W-1:0];
              end
            endcase
          end else begin                                            // Neighbor (level = 1) request
            case (cfg_reg_q[magia_tile_pkg::FSYNC_ID_IDX][1:0])
              2'b00: begin                                          // Horizontal tree node request
                ht_fsync_if_o.sync = 1'b1; 
                ht_fsync_if_o.aggr = cfg_reg_q[magia_tile_pkg::FSYNC_AGGR_IDX][AGGR_W-1:0];
                ht_fsync_if_o.id   = cfg_reg_q[magia_tile_pkg::FSYNC_ID_IDX][    ID_W-1:0];
              end  
              2'b01: begin                                          // Vertical tree node request
                vt_fsync_if_o.sync = 1'b1; 
                vt_fsync_if_o.aggr = cfg_reg_q[magia_tile_pkg::FSYNC_AGGR_IDX][AGGR_W-1:0];
                vt_fsync_if_o.id   = cfg_reg_q[magia_tile_pkg::FSYNC_ID_IDX][    ID_W-1:0];
              end
              2'b10: begin                                          // Horizontal neighbor node request
                hn_fsync_if_o.sync = 1'b1; 
                hn_fsync_if_o.aggr = cfg_reg_q[magia_tile_pkg::FSYNC_AGGR_IDX][NBR_AGGR_W-1:0];
                hn_fsync_if_o.id   = cfg_reg_q[magia_tile_pkg::FSYNC_ID_IDX][    NBR_ID_W-1:0];
              end  
              2'b11: begin                                          // Vertical neighbor node request
                vn_fsync_if_o.sync = 1'b1; 
                vn_fsync_if_o.aggr = cfg_reg_q[magia_tile_pkg::FSYNC_AGGR_IDX][NBR_AGGR_W-1:0];
                vn_fsync_if_o.id   = cfg_reg_q[magia_tile_pkg::FSYNC_ID_IDX][    NBR_ID_W-1:0];
              end
            endcase
          end
        end
        WAIT: begin
          n_sync_state = (ht_fsync_if_o.wake | hn_fsync_if_o.wake | vt_fsync_if_o.wake | vn_fsync_if_o.errowaker) ? DONE : WAIT;
        end
        DONE: begin
          n_sync_state = IDLE;
          done         = 1'b1;
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