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
 * iDMA Xif Instruction Decoder
 */

module idma_xif_inst_decoder 
  import redmule_tile_pkg::*;
  import cv32e40x_pkg::*;
  import idma_pkg::*;
#(
  parameter int unsigned INSTR_W             = redmule_tile_pkg::DMA_INSTR_W,
  parameter int unsigned DATA_W              = redmule_tile_pkg::DMA_DATA_W,
  parameter int unsigned ADDR_W              = redmule_tile_pkg::DMA_ADDR_W,
  parameter int unsigned N_RF_PORTS          = redmule_tile_pkg::DMA_N_RF_PORTS,
  parameter int unsigned OPCODE_W            = redmule_tile_pkg::DMA_OP_CODE_W,
  parameter int unsigned FUNC3_W             = redmule_tile_pkg::DMA_FUNC3_W,
  parameter int unsigned ND_EN_W             = redmule_tile_pkg::DMA_ND_EN_W,
  parameter int unsigned DST_MAX_LOG_LEN_W   = redmule_tile_pkg::DMA_DST_MAX_LOG_LEN_W,
  parameter int unsigned SRC_MAX_LOG_LEN_W   = redmule_tile_pkg::DMA_SRC_MAX_LOG_LEN_W,
  parameter int unsigned DST_REDUCE_LEN_W    = redmule_tile_pkg::DMA_DST_REDUCE_LEN_W,
  parameter int unsigned SRC_REDUCE_LEN_W    = redmule_tile_pkg::DMA_SRC_REDUCE_LEN_W,
  parameter int unsigned DECOUPLE_R_W_W      = redmule_tile_pkg::DMA_DECOUPLE_R_W_W,
  parameter int unsigned DECOUPLE_R_AW_W     = redmule_tile_pkg::DMA_DECOUPLE_R_AW_W,
  localparam int unsigned CONF_W             = ND_EN_W +
                                               DST_MAX_LOG_LEN_W +
                                               SRC_MAX_LOG_LEN_W +
                                               DST_REDUCE_LEN_W +
                                               SRC_REDUCE_LEN_W +
                                               DECOUPLE_R_W_W +
                                               DECOUPLE_R_AW_W,
  parameter int unsigned OPCODE_OFF          = redmule_tile_pkg::DMA_OPCODE_OFF,
  parameter int unsigned FUNC3_OFF           = redmule_tile_pkg::DMA_FUNC3_OFF,
  parameter int unsigned ND_EN_OFF           = redmule_tile_pkg::DMA_ND_EN_OFF,
  parameter int unsigned DST_MAX_LOG_LEN_OFF = redmule_tile_pkg::DMA_DST_MAX_LOG_LEN_OFF,
  parameter int unsigned SRC_MAX_LOG_LEN_OFF = redmule_tile_pkg::DMA_SRC_MAX_LOG_LEN_OFF,
  parameter int unsigned DST_REDUCE_LEN_OFF  = redmule_tile_pkg::DMA_DST_REDUCE_LEN_OFF,
  parameter int unsigned SRC_REDUCE_LEN_OFF  = redmule_tile_pkg::DMA_SRC_REDUCE_LEN_OFF,
  parameter int unsigned DECOUPLE_R_W_OFF    = redmule_tile_pkg::DMA_DECOUPLE_R_W_OFF,
  parameter int unsigned DECOUPLE_R_AW_OFF   = redmule_tile_pkg::DMA_DECOUPLE_R_AW_OFF,
  parameter int unsigned N_CFG_REG           = redmule_tile_pkg::DMA_N_CFG_REG,
  parameter type         idma_fe_req_t       = redmule_tile_pkg::idma_fe_reg_req_t,
  parameter type         idma_fe_rsp_t       = redmule_tile_pkg::idma_fe_reg_rsp_t
)(
  input  logic                      clk_i,
  input  logic                      rst_ni,
  input  logic                      clear_i,

  cv32e40x_if_xif.coproc_issue      xif_issue_if_i,

  output idma_fe_req_t              cfg_req_o,
  input  idma_fe_rsp_t              cfg_rsp_i,

  output logic                      start_o,  // Started iDMA transfer
  output logic                      busy_o,   // Performing iDMA transfer
  output logic                      done_o,   // Finished iDMA transfer
  output logic                      error_o   // Detected error
);

/*******************************************************/
/**       Internal Signal Definitions Beginning       **/
/*******************************************************/

  logic clk_dec_en, clk_cfg_en;
  logic clk_dec_g,  clk_cfg_g;
  
  logic [         OPCODE_W-1:0] opcode;
  logic [          FUNC3_W-1:0] func3;
  logic [          ND_EN_W-1:0] nd_en;
  logic [DST_MAX_LOG_LEN_W-1:0] dst_max_log_len;
  logic [SRC_MAX_LOG_LEN_W-1:0] src_max_log_len;
  logic [ DST_REDUCE_LEN_W-1:0] dst_reduce_len;
  logic [ SRC_REDUCE_LEN_W-1:0] src_reduce_len;
  logic [   DECOUPLE_R_W_W-1:0] decouple_r_w;
  logic [  DECOUPLE_R_AW_W-1:0] decouple_r_aw;

  logic [DATA_W-1:0] cfg_reg_d [N_CFG_REG], cfg_reg_q [N_CFG_REG];

  logic start_cfg;
  logic start_dma;
  logic busy_dma;
  logic done_dma;

  logic transfer_not_set_properly;
  logic reg_error;

  logic rw_valid;

  logic [DATA_W-1:0] next_id_d, next_id_q;

  typedef enum logic[3:0] {
    IDLE,
    WR_CFG, WR_DST_ADDR, WR_SRC_ADDR, WR_LEN, WR_DST_STR2_LO, WR_DST_STR2_HI, WR_SRC_STR2_LO, WR_SRC_STR2_HI, WR_REPS2_LO, WR_REPS2_HI,
    START,
    BUSY,
    DONE
  } idma_state_e;

  idma_state_e c_idma_state, n_idma_state;

/*******************************************************/
/**          Internal Signal Definitions End          **/
/*******************************************************/
/**           Function Definitions Beginning          **/
/*******************************************************/

  /* Function that writes the data argument to the addr argument of the iDMA FE register and returns the next state of the configuration FSM
   * OUTPUT:
   * req       - iDMA FE register request channel
   * reg_error - indicates that the req/rsp of the iDMA FE asserted the error signal
   * INPUT:
   * rsp       - iDMA FE register response channel
   * addr      - iDMA FE register address
   * data      - iDMA FE register data
   * RETURN:
   * 1'b1 if the write was acknowledged, 1'b0 otherwise
   */
  function automatic logic write_idma_reg(output idma_fe_req_t req, input idma_fe_rsp_t rsp, 
                                          input logic [ADDR_W-1:0] addr, input logic [DATA_W-1:0] data, 
                                          output logic reg_error);
    req.addr       = addr;
    req.write      = 1'b1;
    req.wdata      = data;
    req.wstrb      = '1;
    req.valid      = 1'b1;

    reg_error      = rsp.error       ? 1'b1 : 1'b0;
    write_idma_reg = cfg_rsp_i.ready ? 1'b1 : 1'b0;
  endfunction: write_idma_reg

  /*
   * Function that reads the data argument of the iDMA FE register
   * OUTPUT:
   * req       - iDMA FE register request channel
   * reg_error - indicates that the req/rsp of the iDMA FE asserted the error signal
   * data      - iDMA FE register read data
   * INPUT:
   * rsp       - iDMA FE register response channel
   * addr      - iDMA FE register address
   * RETURN:
   * 1'b1 if the read data is valid, 1'b0 otherwise
   */
  function automatic logic read_idma_reg(output idma_fe_req_t req, input idma_fe_rsp_t rsp, 
                                         input logic [ADDR_W-1:0] addr, output logic [DATA_W-1:0] data, 
                                         output logic reg_error);
    req.addr      = addr;
    req.write     = 1'b0;
    req.wdata     = '0;
    req.wstrb     = '0;
    req.valid     = 1'b1;

    data          = cfg_rsp_i.rdata;
    
    reg_error     = rsp.error       ? 1'b1 : 1'b0;
    read_idma_reg = cfg_rsp_i.ready ? 1'b1 : 1'b0;
  endfunction: read_idma_reg

/*******************************************************/
/**              Function Definitions End             **/
/*******************************************************/
/**            Hardwired Signals Beginning            **/
/*******************************************************/

  assign opcode          = xif_issue_if_i.issue_req.instr[         OPCODE_OFF +          OPCODE_W-1:         OPCODE_OFF];
  assign func3           = xif_issue_if_i.issue_req.instr[          FUNC3_OFF +           FUNC3_W-1:          FUNC3_OFF];
  assign nd_en           = xif_issue_if_i.issue_req.instr[          ND_EN_OFF +           ND_EN_W-1:          ND_EN_OFF];
  assign dst_max_log_len = xif_issue_if_i.issue_req.instr[DST_MAX_LOG_LEN_OFF + DST_MAX_LOG_LEN_W-1:DST_MAX_LOG_LEN_OFF];
  assign src_max_log_len = xif_issue_if_i.issue_req.instr[SRC_MAX_LOG_LEN_OFF + SRC_MAX_LOG_LEN_W-1:SRC_MAX_LOG_LEN_OFF];
  assign dst_reduce_len  = xif_issue_if_i.issue_req.instr[ DST_REDUCE_LEN_OFF +  DST_REDUCE_LEN_W-1: DST_REDUCE_LEN_OFF];
  assign src_reduce_len  = xif_issue_if_i.issue_req.instr[ SRC_REDUCE_LEN_OFF +  SRC_REDUCE_LEN_W-1: SRC_REDUCE_LEN_OFF];
  assign decouple_r_w    = xif_issue_if_i.issue_req.instr[   DECOUPLE_R_W_OFF +    DECOUPLE_R_W_W-1:   DECOUPLE_R_W_OFF];
  assign decouple_r_aw   = xif_issue_if_i.issue_req.instr[  DECOUPLE_R_AW_OFF +   DECOUPLE_R_AW_W-1:  DECOUPLE_R_AW_OFF];

  assign error_o = transfer_not_set_properly | reg_error;

  assign start_o = start_dma;
  assign busy_o  = busy_dma;
  assign done_o  = done_dma;

/*******************************************************/
/**               Hardwired Signals End               **/
/*******************************************************/
/**               Clock gating Beginning              **/
/*******************************************************/

  tc_clk_gating dec_clock_gating (
    .clk_i                   ,
    .en_i      ( clk_dec_en ),
    .test_en_i ( '0'        ),
    .clk_o     ( clk_dec_g  )
  );

  tc_clk_gating cfg_clock_gating (
    .clk_i                   ,
    .en_i      ( clk_cfg_en ),
    .test_en_i ( '0'        ),
    .clk_o     ( clk_cfg_g  )
  );

/*******************************************************/
/**                  Clock gating End                 **/
/*******************************************************/
/**               Decoder FSM Beginning               **/
/*******************************************************/

  always_comb begin:  instr_decoder
    clk_dec_en                       = 1'b0;
    start_cfg                        = 1'b0;
    cfg_reg_d                        = cfg_reg_q;
    xif_issue_if_i.issue_ready       = 1'b0;
    xif_issue_if_i.issue_resp.accept = 1'b0;

    if (xif_issue_if_i.issue_valid) begin
      case (opcode)
        CONF_OPCODE: begin
          xif_issue_if_i.issue_ready                = 1'b1;
          xif_issue_if_i.issue_resp.accept          = 1'b1;
          clk_dec_en                                = 1'b1;
          cfg_reg_d[redmule_tile_pkg::DMA_CONF_IDX] = {decouple_r_aw, decouple_r_w, src_reduce_len, dst_reduce_len, src_max_log_len, dst_max_log_len, nd_en};
        end
        SET_OPCODE: begin
          xif_issue_if_i.issue_ready       = 1'b1;
          xif_issue_if_i.issue_resp.accept = 1'b1;
          clk_dec_en                       = 1'b1;
          case (func3)
            SET_DA_FUNC3: if (xif_issue_if_i.issue_req.rs_valid) begin 
              cfg_reg_d[ redmule_tile_pkg::DMA_DST_ADDR_LOW_IDX]     = xif_issue_if_i.issue_req.rs[0]; 
              cfg_reg_d[redmule_tile_pkg::DMA_DST_ADDR_HIGH_IDX]     = xif_issue_if_i.issue_req.rs[1]; 
            end
            SET_SA_FUNC3: if (xif_issue_if_i.issue_req.rs_valid) begin 
              cfg_reg_d[ redmule_tile_pkg::DMA_SRC_ADDR_LOW_IDX]     = xif_issue_if_i.issue_req.rs[0]; 
              cfg_reg_d[redmule_tile_pkg::DMA_SRC_ADDR_HIGH_IDX]     = xif_issue_if_i.issue_req.rs[1]; 
            end
            SET_L_FUNC3:  if (xif_issue_if_i.issue_req.rs_valid) begin 
              cfg_reg_d[ redmule_tile_pkg::DMA_LENGTH_LOW_IDX]       = xif_issue_if_i.issue_req.rs[0]; 
              cfg_reg_d[redmule_tile_pkg::DMA_LENGTH_HIGH_IDX]       = xif_issue_if_i.issue_req.rs[1]; 
            end
            SET_DS_FUNC3: if (xif_issue_if_i.issue_req.rs_valid) begin 
              cfg_reg_d[ redmule_tile_pkg::DMA_DST_STRIDE_2_LOW_IDX] = xif_issue_if_i.issue_req.rs[0]; 
              cfg_reg_d[redmule_tile_pkg::DMA_DST_STRIDE_2_HIGH_IDX] = xif_issue_if_i.issue_req.rs[1]; 
            end
            SET_SS_FUNC3: if (xif_issue_if_i.issue_req.rs_valid) begin 
              cfg_reg_d[ redmule_tile_pkg::DMA_SRC_STRIDE_2_LOW_IDX] = xif_issue_if_i.issue_req.rs[0]; 
              cfg_reg_d[redmule_tile_pkg::DMA_SRC_STRIDE_2_HIGH_IDX] = xif_issue_if_i.issue_req.rs[1]; 
            end
            SET_R_FUNC3:  if (xif_issue_if_i.issue_req.rs_valid) begin 
              cfg_reg_d[ redmule_tile_pkg::DMA_REPS_2_LOW_IDX]       = xif_issue_if_i.issue_req.rs[0]; 
              cfg_reg_d[redmule_tile_pkg::DMA_REPS_2_HIGH_IDX]       = xif_issue_if_i.issue_req.rs[1]; 
            end
            SET_S_FUNC3:  start_cfg = 1'b1;
          endcase
        end
      endcase
    end
  end

  always_ff @(posedge clk_dec_g, negedge rst_ni) begin : configuration_register
    if (~rst_ni)   cfg_reg_q <= '0;
    else begin
      if (clear_i) cfg_reg_q <= '0;
      else         cfg_reg_q <= cfg_reg_d;
    end
  end

/*******************************************************/
/**                  Decoder FSM End                  **/
/*******************************************************/
/**       Front-end Configuration FSM Beginning       **/
/*******************************************************/

  always_comb begin: idma_next_state_output_logic
    clk_cfg_en                = 1'b1;
    n_idma_state              = c_idma_state;
    start_dma                 = 1'b0;
    busy_dma                  = 1'b0;
    done_dma                  = 1'b0;
    transfer_not_set_properly = 1'b0;
    reg_error                 = 1'b0;
    rw_valid                  = 1'b0;
    next_id_d                 = next_id_q;
    cfg_req_o.addr            = '0;
    cfg_req_o.write           = 1'b0;
    cfg_req_o.wdata           = '0;
    cfg_req_o.wstrb           = '0;
    cfg_req_o.valid           = 1'b0;

    case (c_idma_state)
      IDLE: if (start_cfg) n_idma_state = WR_CFG; else clk_cfg_en = 1'b0;
      WR_CFG: begin
        rw_valid     = write_idma_reg(.req(cfg_req_o), .rsp(cfg_rsp_i), .addr(idma_reg64_2d_reg_pkg::IDMA_REG64_2D_CONF_OFFSET),              .data(cfg_reg_d[redmule_tile_pkg::DMA_CONF_IDX][CONF_W-1:0]),  .reg_error(reg_error));
        n_idma_state = reg_error ? IDLE : (~rw_valid ? c_idma_state : WR_DST_ADDR);
      end
      WR_DST_ADDR: begin
        rw_valid     = write_idma_reg(.req(cfg_req_o), .rsp(cfg_rsp_i), .addr(idma_reg64_2d_reg_pkg::IDMA_REG64_2D_DST_ADDR_LOW_OFFSET),      .data(cfg_reg_d[redmule_tile_pkg::DMA_DST_ADDR_LOW_IDX]),      .reg_error(reg_error));
        n_idma_state = reg_error ? IDLE : (~rw_valid ? c_idma_state : WR_SRC_ADDR);
      end
      WR_SRC_ADDR: begin
        rw_valid     = write_idma_reg(.req(cfg_req_o), .rsp(cfg_rsp_i), .addr(idma_reg64_2d_reg_pkg::IDMA_REG64_2D_SRC_ADDR_LOW_OFFSET),      .data(cfg_reg_d[redmule_tile_pkg::DMA_SRC_ADDR_LOW_IDX]),      .reg_error(reg_error));
        n_idma_state = reg_error ? IDLE : (~rw_valid ? c_idma_state : WR_LEN);
      end
      WR_LEN: begin
        rw_valid     = write_idma_reg(.req(cfg_req_o), .rsp(cfg_rsp_i), .addr(idma_reg64_2d_reg_pkg::IDMA_REG64_2D_LENGTH_LOW_OFFSET),        .data(cfg_reg_d[redmule_tile_pkg::DMA_LENGTH_LOW_IDX]),        .reg_error(reg_error));
        n_idma_state = reg_error ? IDLE : (~rw_valid ? c_idma_state : WR_DST_STR2_LO);
      end
      WR_DST_STR2_LO: begin
        rw_valid     = write_idma_reg(.req(cfg_req_o), .rsp(cfg_rsp_i), .addr(idma_reg64_2d_reg_pkg::IDMA_REG64_2D_DST_STRIDE_2_LOW_OFFSET),  .data(cfg_reg_d[redmule_tile_pkg::DMA_DST_STRIDE_2_LOW_IDX]),  .reg_error(reg_error));
        n_idma_state = reg_error ? IDLE : (~rw_valid ? c_idma_state : WR_DST_STR2_HI);
      end
      WR_DST_STR2_HI: begin
        rw_valid     = write_idma_reg(.req(cfg_req_o), .rsp(cfg_rsp_i), .addr(idma_reg64_2d_reg_pkg::IDMA_REG64_2D_DST_STRIDE_2_HIGH_OFFSET), .data(cfg_reg_d[redmule_tile_pkg::DMA_DST_STRIDE_2_HIGH_IDX]), .reg_error(reg_error));
        n_idma_state = reg_error ? IDLE : (~rw_valid ? c_idma_state : WR_SRC_STR2_LO);
      end
      WR_SRC_STR2_LO: begin
        rw_valid     = write_idma_reg(.req(cfg_req_o), .rsp(cfg_rsp_i), .addr(idma_reg64_2d_reg_pkg::IDMA_REG64_2D_SRC_STRIDE_2_LOW_OFFSET),  .data(cfg_reg_d[redmule_tile_pkg::DMA_SRC_STRIDE_2_LOW_IDX]),  .reg_error(reg_error));
        n_idma_state = reg_error ? IDLE : (~rw_valid ? c_idma_state : WR_SRC_STR2_HI);
      end
      WR_SRC_STR2_HI: begin
        rw_valid     = write_idma_reg(.req(cfg_req_o), .rsp(cfg_rsp_i), .addr(idma_reg64_2d_reg_pkg::IDMA_REG64_2D_SRC_STRIDE_2_HIGH_OFFSET), .data(cfg_reg_d[redmule_tile_pkg::DMA_SRC_STRIDE_2_HIGH_IDX]), .reg_error(reg_error));
        n_idma_state = reg_error ? IDLE : (~rw_valid ? c_idma_state : WR_REPS2_LO);
      end
      WR_REPS2_LO: begin
        rw_valid     = write_idma_reg(.req(cfg_req_o), .rsp(cfg_rsp_i), .addr(idma_reg64_2d_reg_pkg::IDMA_REG64_2D_REPS_2_LOW_OFFSET),        .data(cfg_reg_d[redmule_tile_pkg::DMA_REPS_2_LOW_IDX]),        .reg_error(reg_error));
        n_idma_state = reg_error ? IDLE : (~rw_valid ? c_idma_state : WR_REPS2_HI);
      end
      WR_REPS2_HI: begin
        rw_valid     = write_idma_reg(.req(cfg_req_o), .rsp(cfg_rsp_i), .addr(idma_reg64_2d_reg_pkg::IDMA_REG64_2D_REPS_2_HIGH_OFFSET),       .data(cfg_reg_d[redmule_tile_pkg::DMA_REPS_2_HIGH_IDX]),       .reg_error(reg_error));
        n_idma_state = reg_error ? IDLE : (~rw_valid ? c_idma_state : START);
      end
      START: begin
        start_dma                 = 1'b1;
        rw_valid                  = read_idma_reg(.req(cfg_req_o), .rsp(cfg_rsp_i), .addr(idma_reg64_2d_reg_pkg::IDMA_REG64_2D_NEXT_ID_0_OFFSET), data(next_id_d), .reg_error(reg_error));
        transfer_not_set_properly = (rw_valid & (next_id_d == 0)) ? 1'b1 : 1'b0;
        n_idma_state              = (reg_error | transfer_not_set_properly) ? IDLE : (~rw_valid ? c_idma_state: BUSY);
      end
      BUSY: begin
        busy_dma                  = 1'b1;
        rw_valid                  = read_idma_reg(.req(cfg_req_o), .rsp(cfg_rsp_i), .addr(idma_reg64_2d_reg_pkg::IDMA_REG64_2D_NEXT_ID_0_OFFSET), data(next_id_d), .reg_error(reg_error));
        n_idma_state              = reg_error ? IDLE : (~rw_valid ? c_idma_state : (next_id_d == next_id_q ? c_idma_state : DONE));
      end
      DONE: begin
        done_dma                  = 1'b1;
        n_idma_state              = IDLE;
      end
    endcase
  end

  always_ff @(posedge clk_cfg_g, negedge rst_ni) begin : idma_state_register
    if (~rst_ni)   c_idma_state <= IDLE;
    else begin
      if (clear_i) c_idma_state <= IDLE;
      else         c_idma_state <= n_idma_state;
    end
  end

  always_ff @(posedge clk_cfg_g, negedge rst_ni) begin : next_id_register
    if (~rst_ni)   next_id_q <= '0;
    else begin
      if (clear_i) next_id_q <= '0;
      else         next_id_q <= next_id_d;
    end
  end

/*******************************************************/
/**          Front-end Configuration FSM End          **/
/*******************************************************/

endmodule: idma_xif_inst_decoder