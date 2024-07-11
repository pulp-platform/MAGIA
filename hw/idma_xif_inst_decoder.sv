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
  parameter int unsigned OPCODE_W            = redmule_tile_pkg::DMA_OPCODE_W,
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
  input  logic                 clk_i,
  input  logic                 rst_ni,
  input  logic                 clear_i,

  cv32e40x_if_xif.coproc_issue xif_issue_if_i,

  output idma_fe_req_t         cfg_req_o,
  input  idma_fe_rsp_t         cfg_rsp_i,
  
  output logic                 start_o,     // Started iDMA transfer
  output logic                 busy_o,      // Performing iDMA transfer
  output logic                 done_o,      // Finished iDMA transfer
  output logic                 error_o      // Detected error
);

/*******************************************************/
/**       Internal Signal Definitions Beginning       **/
/*******************************************************/

  logic dec_clk_req;
  logic cfg_clk_req;
  logic clk_dc_en, clk_tfr_en;
  logic clk_dc_g,  clk_tfr_g;
  
  logic[         OPCODE_W-1:0] opcode;
  logic[          FUNC3_W-1:0] func3;
  logic[          ND_EN_W-1:0] nd_en;
  logic[DST_MAX_LOG_LEN_W-1:0] dst_max_log_len;
  logic[SRC_MAX_LOG_LEN_W-1:0] src_max_log_len;
  logic[ DST_REDUCE_LEN_W-1:0] dst_reduce_len;
  logic[ SRC_REDUCE_LEN_W-1:0] src_reduce_len;
  logic[   DECOUPLE_R_W_W-1:0] decouple_r_w;
  logic[  DECOUPLE_R_AW_W-1:0] decouple_r_aw;

  logic[N_CFG_REG-1:0][DATA_W-1:0] cfg_reg_d,        cfg_reg_q;
  logic[N_CFG_REG-1:0]             cfg_reg_update_d, cfg_reg_update_q;
  logic[N_CFG_REG-1:0]             cfg_reg_update_clr;

  idma_fe_req_t cfg_configurer_req;
  idma_fe_rsp_t cfg_configurer_rsp;
  idma_fe_req_t cfg_transferer_req;
  idma_fe_rsp_t cfg_transferer_rsp;

  logic free_cfg;
  logic free_tfr;

  logic start_transfer;

  logic start_dma;
  logic busy_dma;
  logic done_dma;

  logic transfer_not_set_properly;
  logic reg_error_cfg, reg_error_tfr;

  logic rw_valid_cfg, rw_valid_tfr;

  logic[DATA_W-1:0] next_id_d, next_id_q;
  logic[DATA_W-1:0] done_id;
  
  typedef enum logic[1:0] {
    IDLE,
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

  /* Function that writes the data argument to the addr argument of the iDMA FE register
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
                                          input logic[ADDR_W-1:0] addr, input logic[DATA_W-1:0] data, 
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
                                         input logic[ADDR_W-1:0] addr, output logic[DATA_W-1:0] data, 
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

  assign clk_dc_en = dec_clk_req | cfg_clk_req;
  
  assign opcode          = xif_issue_if_i.issue_req.instr[         OPCODE_OFF+:         OPCODE_W];
  assign func3           = xif_issue_if_i.issue_req.instr[          FUNC3_OFF+:          FUNC3_W];
  assign nd_en           = xif_issue_if_i.issue_req.instr[          ND_EN_OFF+:          ND_EN_W];
  assign dst_max_log_len = xif_issue_if_i.issue_req.instr[DST_MAX_LOG_LEN_OFF+:DST_MAX_LOG_LEN_W];
  assign src_max_log_len = xif_issue_if_i.issue_req.instr[SRC_MAX_LOG_LEN_OFF+:SRC_MAX_LOG_LEN_W];
  assign dst_reduce_len  = xif_issue_if_i.issue_req.instr[ DST_REDUCE_LEN_OFF+: DST_REDUCE_LEN_W];
  assign src_reduce_len  = xif_issue_if_i.issue_req.instr[ SRC_REDUCE_LEN_OFF+: SRC_REDUCE_LEN_W];
  assign decouple_r_w    = xif_issue_if_i.issue_req.instr[   DECOUPLE_R_W_OFF+:   DECOUPLE_R_W_W];
  assign decouple_r_aw   = xif_issue_if_i.issue_req.instr[  DECOUPLE_R_AW_OFF+:  DECOUPLE_R_AW_W];

  assign free_cfg = ~(|cfg_reg_update_q);
  assign free_tfr = ~(start_dma | busy_dma);

  assign cfg_req_o = ~free_tfr ? cfg_transferer_req :
                     ~free_cfg ? cfg_configurer_req : '0;
  assign cfg_transferer_rsp = ~free_tfr ? cfg_rsp_i : '0;
  assign cfg_configurer_rsp = ~free_tfr ? '0        :
                              ~free_cfg ? cfg_rsp_i : '0;

  assign error_o = transfer_not_set_properly | reg_error_cfg | reg_error_tfr;

  assign start_o = start_dma;
  assign busy_o  = busy_dma;
  assign done_o  = done_dma;

/*******************************************************/
/**               Hardwired Signals End               **/
/*******************************************************/
/**               Clock gating Beginning              **/
/*******************************************************/

  tc_clk_gating dc_clock_gating (
    .clk_i                   ,
    .en_i      ( clk_dc_en ),
    .test_en_i ( '0         ),
    .clk_o     ( clk_dc_g  )
  );

  tc_clk_gating tfr_clock_gating (
    .clk_i                   ,
    .en_i      ( clk_tfr_en ),
    .test_en_i ( '0         ),
    .clk_o     ( clk_tfr_g  )
  );

/*******************************************************/
/**                  Clock gating End                 **/
/*******************************************************/
/**               Decoder FSM Beginning               **/
/*******************************************************/

  always_comb begin: instr_decoder
    dec_clk_req                      = 1'b0;
    start_transfer                   = 1'b0;
    cfg_reg_d                        = cfg_reg_q;
    cfg_reg_update_d                 = cfg_reg_update_q;
    xif_issue_if_i.issue_ready       = 1'b0;
    xif_issue_if_i.issue_resp        = '0;

    if (xif_issue_if_i.issue_valid) begin
      case (opcode)
        CONF_OPCODE: begin
          xif_issue_if_i.issue_ready                       = 1'b1;
          xif_issue_if_i.issue_resp.accept                 = 1'b1;
          dec_clk_req                                      = 1'b1;
          cfg_reg_d       [redmule_tile_pkg::DMA_CONF_IDX] = {nd_en, dst_max_log_len, src_max_log_len, dst_reduce_len, src_reduce_len, decouple_r_w, decouple_r_aw};
          cfg_reg_update_d[redmule_tile_pkg::DMA_CONF_IDX] = 1'b1;
        end
        SET_OPCODE: begin
          xif_issue_if_i.issue_ready       = 1'b1;
          xif_issue_if_i.issue_resp.accept = 1'b1;
          dec_clk_req                      = 1'b1;
          case (func3)
            SET_AL_FUNC3: if (xif_issue_if_i.issue_req.rs_valid) begin 
              cfg_reg_d       [redmule_tile_pkg::DMA_LENGTH_IDX]       = xif_issue_if_i.issue_req.rs[0]; 
              cfg_reg_d       [redmule_tile_pkg::DMA_SRC_ADDR_IDX]     = xif_issue_if_i.issue_req.rs[1];
              cfg_reg_d       [redmule_tile_pkg::DMA_DST_ADDR_IDX]     = xif_issue_if_i.issue_req.rs[2];
              cfg_reg_update_d[redmule_tile_pkg::DMA_LENGTH_IDX]       = 1'b1;
              cfg_reg_update_d[redmule_tile_pkg::DMA_SRC_ADDR_IDX]     = 1'b1;
              cfg_reg_update_d[redmule_tile_pkg::DMA_DST_ADDR_IDX]     = 1'b1;
            end
            SET_SR2_FUNC3: if (xif_issue_if_i.issue_req.rs_valid) begin 
              cfg_reg_d       [redmule_tile_pkg::DMA_REPS_2_IDX]       = xif_issue_if_i.issue_req.rs[0]; 
              cfg_reg_d       [redmule_tile_pkg::DMA_SRC_STRIDE_2_IDX] = xif_issue_if_i.issue_req.rs[1];
              cfg_reg_d       [redmule_tile_pkg::DMA_DST_STRIDE_2_IDX] = xif_issue_if_i.issue_req.rs[2];
              cfg_reg_update_d[redmule_tile_pkg::DMA_REPS_2_IDX]       = 1'b1;
              cfg_reg_update_d[redmule_tile_pkg::DMA_SRC_STRIDE_2_IDX] = 1'b1;
              cfg_reg_update_d[redmule_tile_pkg::DMA_DST_STRIDE_2_IDX] = 1'b1;
            end
            SET_SR3_FUNC3:  if (xif_issue_if_i.issue_req.rs_valid) begin 
              cfg_reg_d       [redmule_tile_pkg::DMA_REPS_3_IDX]       = xif_issue_if_i.issue_req.rs[0]; 
              cfg_reg_d       [redmule_tile_pkg::DMA_SRC_STRIDE_3_IDX] = xif_issue_if_i.issue_req.rs[1];
              cfg_reg_d       [redmule_tile_pkg::DMA_DST_STRIDE_3_IDX] = xif_issue_if_i.issue_req.rs[2];
              cfg_reg_update_d[redmule_tile_pkg::DMA_REPS_3_IDX]       = 1'b1;
              cfg_reg_update_d[redmule_tile_pkg::DMA_SRC_STRIDE_3_IDX] = 1'b1;
              cfg_reg_update_d[redmule_tile_pkg::DMA_DST_STRIDE_3_IDX] = 1'b1;
            end
            SET_S_FUNC3:  start_transfer = 1'b1;
          endcase
        end
      endcase
    end
  end

  always_ff @(posedge clk_dc_g, negedge rst_ni) begin: configuration_register
    if (~rst_ni)   cfg_reg_q <= '0;
    else begin
      if (clear_i) cfg_reg_q <= '0;
      else         cfg_reg_q <= cfg_reg_d;
    end
  end

/*******************************************************/
/**                  Decoder FSM End                  **/
/*******************************************************/
/**        iDMA FE Configuration FSM Beginning        **/
/*******************************************************/

  always_comb begin: idma_configurerer_next_state_output_logic
    cfg_clk_req               = 1'b0;
    reg_error_cfg             = 1'b0;
    rw_valid_cfg              = 1'b0;
    cfg_reg_update_clr        = '0;
    cfg_configurer_req.addr   = '0;
    cfg_configurer_req.write  = 1'b0;
    cfg_configurer_req.wdata  = '0;
    cfg_configurer_req.wstrb  = '0;
    cfg_configurer_req.valid  = 1'b0;

    if (free_tfr) begin
      if (~free_cfg) begin
        cfg_clk_req = 1'b1;
        case (1'b1)
          cfg_reg_update_q[redmule_tile_pkg::DMA_CONF_IDX]: begin
            rw_valid_cfg = write_idma_reg(.req(cfg_configurer_req), .rsp(cfg_configurer_rsp), .addr(idma_reg32_3d_reg_pkg::IDMA_REG32_3D_CONF_OFFSET),              .data(cfg_reg_d[redmule_tile_pkg::DMA_CONF_IDX][CONF_W-1:0]),  .reg_error(reg_error_cfg));
            cfg_reg_update_clr[redmule_tile_pkg::DMA_CONF_IDX]         = reg_error_cfg ? 1'b0 : (rw_valid_cfg ? 1'b1 : 1'b0);
          end
          cfg_reg_update_q[redmule_tile_pkg::DMA_DST_ADDR_IDX]: begin
            rw_valid_cfg = write_idma_reg(.req(cfg_configurer_req), .rsp(cfg_configurer_rsp), .addr(idma_reg32_3d_reg_pkg::IDMA_REG32_3D_DST_ADDR_LOW_OFFSET),      .data(cfg_reg_d[redmule_tile_pkg::DMA_DST_ADDR_IDX]),          .reg_error(reg_error_cfg));
            cfg_reg_update_clr[redmule_tile_pkg::DMA_DST_ADDR_IDX]     = reg_error_cfg ? 1'b0 : (rw_valid_cfg ? 1'b1 : 1'b0);
          end
          cfg_reg_update_q[redmule_tile_pkg::DMA_SRC_ADDR_IDX]: begin
            rw_valid_cfg = write_idma_reg(.req(cfg_configurer_req), .rsp(cfg_configurer_rsp), .addr(idma_reg32_3d_reg_pkg::IDMA_REG32_3D_SRC_ADDR_LOW_OFFSET),      .data(cfg_reg_d[redmule_tile_pkg::DMA_SRC_ADDR_IDX]),          .reg_error(reg_error_cfg));
            cfg_reg_update_clr[redmule_tile_pkg::DMA_SRC_ADDR_IDX]     = reg_error_cfg ? 1'b0 : (rw_valid_cfg ? 1'b1 : 1'b0);
          end
          cfg_reg_update_q[redmule_tile_pkg::DMA_LENGTH_IDX]: begin
            rw_valid_cfg = write_idma_reg(.req(cfg_configurer_req), .rsp(cfg_configurer_rsp), .addr(idma_reg32_3d_reg_pkg::IDMA_REG32_3D_LENGTH_LOW_OFFSET),        .data(cfg_reg_d[redmule_tile_pkg::DMA_LENGTH_IDX]),            .reg_error(reg_error_cfg));
            cfg_reg_update_clr[redmule_tile_pkg::DMA_LENGTH_IDX]       = reg_error_cfg ? 1'b0 : (rw_valid_cfg ? 1'b1 : 1'b0);
          end
          cfg_reg_update_q[redmule_tile_pkg::DMA_DST_STRIDE_2_IDX]: begin
            rw_valid_cfg = write_idma_reg(.req(cfg_configurer_req), .rsp(cfg_configurer_rsp), .addr(idma_reg32_3d_reg_pkg::IDMA_REG32_3D_DST_STRIDE_2_LOW_OFFSET),  .data(cfg_reg_d[redmule_tile_pkg::DMA_DST_STRIDE_2_IDX]),      .reg_error(reg_error_cfg));
            cfg_reg_update_clr[redmule_tile_pkg::DMA_DST_STRIDE_2_IDX] = reg_error_cfg ? 1'b0 : (rw_valid_cfg ? 1'b1 : 1'b0);
          end
          cfg_reg_update_q[redmule_tile_pkg::DMA_SRC_STRIDE_2_IDX]: begin
            rw_valid_cfg = write_idma_reg(.req(cfg_configurer_req), .rsp(cfg_configurer_rsp), .addr(idma_reg32_3d_reg_pkg::IDMA_REG32_3D_SRC_STRIDE_2_LOW_OFFSET),  .data(cfg_reg_d[redmule_tile_pkg::DMA_SRC_STRIDE_2_IDX]),      .reg_error(reg_error_cfg));
            cfg_reg_update_clr[redmule_tile_pkg::DMA_SRC_STRIDE_2_IDX] = reg_error_cfg ? 1'b0 : (rw_valid_cfg ? 1'b1 : 1'b0);
          end
          cfg_reg_update_q[redmule_tile_pkg::DMA_REPS_2_IDX]: begin
            rw_valid_cfg = write_idma_reg(.req(cfg_configurer_req), .rsp(cfg_configurer_rsp), .addr(idma_reg32_3d_reg_pkg::IDMA_REG32_3D_REPS_2_LOW_OFFSET),        .data(cfg_reg_d[redmule_tile_pkg::DMA_REPS_2_IDX]),            .reg_error(reg_error_cfg));
            cfg_reg_update_clr[redmule_tile_pkg::DMA_REPS_2_IDX]       = reg_error_cfg ? 1'b0 : (rw_valid_cfg ? 1'b1 : 1'b0);
          end
          cfg_reg_update_q[redmule_tile_pkg::DMA_DST_STRIDE_3_IDX]: begin
            rw_valid_cfg = write_idma_reg(.req(cfg_configurer_req), .rsp(cfg_configurer_rsp), .addr(idma_reg32_3d_reg_pkg::IDMA_REG32_3D_DST_STRIDE_3_LOW_OFFSET),  .data(cfg_reg_d[redmule_tile_pkg::DMA_DST_STRIDE_3_IDX]),      .reg_error(reg_error_cfg));
            cfg_reg_update_clr[redmule_tile_pkg::DMA_DST_STRIDE_3_IDX] = reg_error_cfg ? 1'b0 : (rw_valid_cfg ? 1'b1 : 1'b0);
          end
          cfg_reg_update_q[redmule_tile_pkg::DMA_SRC_STRIDE_3_IDX]: begin
            rw_valid_cfg = write_idma_reg(.req(cfg_configurer_req), .rsp(cfg_configurer_rsp), .addr(idma_reg32_3d_reg_pkg::IDMA_REG32_3D_SRC_STRIDE_3_LOW_OFFSET),  .data(cfg_reg_d[redmule_tile_pkg::DMA_SRC_STRIDE_3_IDX]),      .reg_error(reg_error_cfg));
            cfg_reg_update_clr[redmule_tile_pkg::DMA_SRC_STRIDE_3_IDX] = reg_error_cfg ? 1'b0 : (rw_valid_cfg ? 1'b1 : 1'b0);
          end
          cfg_reg_update_q[redmule_tile_pkg::DMA_REPS_3_IDX]: begin
            rw_valid_cfg = write_idma_reg(.req(cfg_configurer_req), .rsp(cfg_configurer_rsp), .addr(idma_reg32_3d_reg_pkg::IDMA_REG32_3D_REPS_3_LOW_OFFSET),        .data(cfg_reg_d[redmule_tile_pkg::DMA_REPS_3_IDX]),            .reg_error(reg_error_cfg));
            cfg_reg_update_clr[redmule_tile_pkg::DMA_REPS_3_IDX]       = reg_error_cfg ? 1'b0 : (rw_valid_cfg ? 1'b1 : 1'b0);
          end
        endcase
      end
    end
  end

  for (genvar i = 0; i < N_CFG_REG; i++) begin: gen_configuration_update_register
    always_ff @(posedge clk_dc_g, negedge rst_ni) begin: configuration_update_register
      if (~rst_ni)                           cfg_reg_update_q[i] <= 1'b0;
      else begin
        if (clear_i | cfg_reg_update_clr[i]) cfg_reg_update_q[i] <= 1'b0;
        else                                 cfg_reg_update_q[i] <= cfg_reg_update_d[i];
      end
    end
  end

/*******************************************************/
/**           iDMA FE Configuration FSM End           **/
/*******************************************************/
/**            iDMA Transfer FSM Beginning            **/
/*******************************************************/

  always_comb begin: idma_transferer_next_state_output_logic
    clk_tfr_en                = 1'b1;
    n_idma_state              = c_idma_state;
    start_dma                 = 1'b0;
    busy_dma                  = 1'b0;
    done_dma                  = 1'b0;
    transfer_not_set_properly = 1'b0;
    reg_error_tfr             = 1'b0;
    rw_valid_tfr              = 1'b0;
    next_id_d                 = next_id_q;
    done_id                   = '0;
    cfg_transferer_req.addr   = '0;
    cfg_transferer_req.write  = 1'b0;
    cfg_transferer_req.wdata  = '0;
    cfg_transferer_req.wstrb  = '0;
    cfg_transferer_req.valid  = 1'b0;

    case (c_idma_state)
      IDLE: if (start_transfer) n_idma_state = START; else clk_tfr_en = 1'b0;
      START: begin
        start_dma                 = 1'b1;
        rw_valid_tfr              = read_idma_reg(.req(cfg_transferer_req), .rsp(cfg_transferer_rsp), .addr(idma_reg32_3d_reg_pkg::IDMA_REG32_3D_NEXT_ID_0_OFFSET), .data(next_id_d), .reg_error(reg_error_tfr));
        transfer_not_set_properly = (rw_valid_tfr & (next_id_d == 0)) ? 1'b1 : 1'b0;
        n_idma_state              = (reg_error_tfr | transfer_not_set_properly) ? IDLE : (~rw_valid_tfr ? c_idma_state: BUSY);
      end
      BUSY: begin
        busy_dma                  = 1'b1;
        rw_valid_tfr              = read_idma_reg(.req(cfg_transferer_req), .rsp(cfg_transferer_rsp), .addr(idma_reg32_3d_reg_pkg::IDMA_REG32_3D_DONE_ID_0_OFFSET), .data(done_id),   .reg_error(reg_error_tfr));
        n_idma_state              = reg_error_tfr ? IDLE : (~rw_valid_tfr ? c_idma_state : (done_id != next_id_q ? c_idma_state : DONE));
      end
      DONE: begin
        done_dma                  = 1'b1;
        n_idma_state              = IDLE;
      end
    endcase
  end

  always_ff @(posedge clk_tfr_g, negedge rst_ni) begin: idma_state_register
    if (~rst_ni)   c_idma_state <= IDLE;
    else begin
      if (clear_i) c_idma_state <= IDLE;
      else         c_idma_state <= n_idma_state;
    end
  end

  always_ff @(posedge clk_tfr_g, negedge rst_ni) begin: next_id_register
    if (~rst_ni)   next_id_q <= 1;
    else begin
      if (clear_i) next_id_q <= 1;
      else         next_id_q <= next_id_d;
    end
  end

/*******************************************************/
/**               iDMA Transfer FSM End               **/
/*******************************************************/

endmodule: idma_xif_inst_decoder