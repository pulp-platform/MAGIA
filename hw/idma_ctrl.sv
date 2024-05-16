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
 * iDMA Controller
 */

module idma_ctrl 
  import redmule_tile_pkg::*;
  import cv32e40x_pkg::*;
  import idma_pkg::*;
#(
  parameter idma_pkg::error_cap_e ERROR_CAP         = idma_pkg::NO_ERROR_HANDLING,
  localparam int unsigned         DIRECTION_W       = redmule_tile_pkg::DMA_DIRECTION_W,
  localparam int unsigned         DIRECTION_OFF     = redmule_tile_pkg::DMA_DIRECTION_OFF,
  localparam type                 idma_fe_reg_req_t = redmule_tile_pkg::idma_fe_reg_req_t,
  localparam type                 idma_fe_reg_rsp_t = redmule_tile_pkg::idma_fe_reg_rsp_t,
  parameter type                  axi_req_t         = redmule_tile_pkg::idma_axi_req_t,
  parameter type                  axi_rsp_t         = redmule_tile_pkg::idma_axi_rsp_t,
  parameter type                  obi_req_t         = redmule_tile_pkg::idma_obi_req_t,
  parameter type                  obi_rsp_t         = redmule_tile_pkg::idma_obi_rsp_t
)(
  input  logic                 clk_i,
  input  logic                 rst_ni,
  input  logic                 testmode_i,
  input  logic                 clear_i,

  cv32e40x_if_xif.coproc_issue xif_issue_if_i,

  output axi_req_t             axi_read_req_o,
  input  axi_rsp_t             axi_read_rsp_i,

  output axi_req_t             axi_write_req_o,
  input  axi_rsp_t             axi_write_rsp_i,

  output obi_req_t             obi_read_req_o,
  input  obi_rsp_t             obi_read_rsp_i,

  output obi_req_t             obi_write_req_o,
  input  obi_rsp_t             obi_write_rsp_i,

  output logic                 axi2obi_start_o,  // Started L2 to L1 iDMA transfer
  output logic                 axi2obi_busy_o,   // Performing L2 to L1  iDMA transfer
  output logic                 axi2obi_done_o,   // Finished L2 to L1  iDMA transfer
  output logic                 axi2obi_error_o,  // Detected L2 to L1 transfer error

  output logic                 obi2axi_start_o,  // Started L1 to L2 iDMA transfer
  output logic                 obi2axi_busy_o,   // Performing L1 to L2 iDMA transfer
  output logic                 obi2axi_done_o,   // Finished L1 to L2 iDMA transfer
  output logic                 obi2axi_error_o   // Detected L1 to L2 transfer error
);

/*******************************************************/
/**       Internal Signal Definitions Beginning       **/
/*******************************************************/

  logic direction;  // Direction of the iDMA transfer: 0 -> AXI2OBI; 1 -> OBI2AXI
  
  idma_fe_reg_req_t idma_fe_reg_axi2obi_req;
  idma_fe_reg_rsp_t idma_fe_reg_axi2obi_rsp;
  idma_fe_reg_req_t idma_fe_reg_obi2axi_req;
  idma_fe_reg_rsp_t idma_fe_reg_obi2axi_rsp;

/*******************************************************/
/**          Internal Signal Definitions End          **/
/*******************************************************/
/**           Interface Definitions Beginning         **/
/*******************************************************/

  cv32e40x_if_xif #(
    .X_NUM_RS    ( redmule_tile_pkg::X_NUM_RS ),
    .X_ID_WIDTH  ( redmule_tile_pkg::X_ID_W   ),
    .X_MEM_WIDTH ( redmule_tile_pkg::X_MEM_W  ),
    .X_RFR_WIDTH ( redmule_tile_pkg::X_RFR_W  ),
    .X_RFW_WIDTH ( redmule_tile_pkg::X_RFW_W  ),
    .X_MISA      ( redmule_tile_pkg::X_MISA   ),
    .X_ECS_XS    ( redmule_tile_pkg::X_ECS_XS )
  ) xif_axi2obi_issue_if ();

  cv32e40x_if_xif #(
    .X_NUM_RS    ( redmule_tile_pkg::X_NUM_RS ),
    .X_ID_WIDTH  ( redmule_tile_pkg::X_ID_W   ),
    .X_MEM_WIDTH ( redmule_tile_pkg::X_MEM_W  ),
    .X_RFR_WIDTH ( redmule_tile_pkg::X_RFR_W  ),
    .X_RFW_WIDTH ( redmule_tile_pkg::X_RFW_W  ),
    .X_MISA      ( redmule_tile_pkg::X_MISA   ),
    .X_ECS_XS    ( redmule_tile_pkg::X_ECS_XS )
  ) xif_obi2axi_issue_if ();

/*******************************************************/
/**             Interface Definitions End             **/
/*******************************************************/
/**            Hardwired Signals Beginning            **/
/*******************************************************/

  assign direction = xif_issue_if_i.issue_req.instr[DIRECTION_OFF+:DIRECTION_W];

/*******************************************************/
/**               Hardwired Signals End               **/
/*******************************************************/
/**             Xif Issue DEMUX Beginning             **/
/*******************************************************/

  always_comb begin: xif_issue_demux
    if (direction) begin  // OBI2AXI
      xif_obi2axi_issue_if.issue_valid = xif_issue_if_i.issue_valid;
      xif_obi2axi_issue_if.issue_req   = xif_issue_if_i.issue_req;
      xif_issue_if_i.issue_ready       = xif_obi2axi_issue_if.issue_ready;
      xif_issue_if_i.issue_resp        = xif_obi2axi_issue_if.issue_resp;

      xif_axi2obi_issue_if.issue_valid = 1'b0;
      xif_axi2obi_issue_if.issue_req   = '0;
    end else begin        // AXI2OBI
      xif_axi2obi_issue_if.issue_valid = xif_issue_if_i.issue_valid;
      xif_axi2obi_issue_if.issue_req   = xif_issue_if_i.issue_req;
      xif_issue_if_i.issue_ready       = xif_axi2obi_issue_if.issue_ready;
      xif_issue_if_i.issue_resp        = xif_axi2obi_issue_if.issue_resp;

      xif_obi2axi_issue_if.issue_valid = 1'b0;
      xif_obi2axi_issue_if.issue_req   = '0;
    end
  end

/*******************************************************/
/**                Xif Issue DEMUX End                **/
/*******************************************************/
/**     AXI2OBI Xif Instruction Decoder Beginning     **/
/*******************************************************/

  idma_xif_inst_decoder #(
    .INSTR_W             ( redmule_tile_pkg::DMA_INSTR_W             ),
    .DATA_W              ( redmule_tile_pkg::DMA_DATA_W              ),
    .N_RF_PORTS          ( redmule_tile_pkg::DMA_N_RF_PORTS          ),
    .OPCODE_W            ( redmule_tile_pkg::DMA_OPCODE_W            ),
    .FUNC3_W             ( redmule_tile_pkg::DMA_FUNC3_W             ),
    .ND_EN_W             ( redmule_tile_pkg::DMA_ND_EN_W             ),
    .DST_MAX_LOG_LEN_W   ( redmule_tile_pkg::DMA_DST_MAX_LOG_LEN_W   ),
    .SRC_MAX_LOG_LEN_W   ( redmule_tile_pkg::DMA_SRC_MAX_LOG_LEN_W   ),
    .DST_REDUCE_LEN_W    ( redmule_tile_pkg::DMA_DST_REDUCE_LEN_W    ),
    .SRC_REDUCE_LEN_W    ( redmule_tile_pkg::DMA_SRC_REDUCE_LEN_W    ),
    .DECOUPLE_R_W_W      ( redmule_tile_pkg::DMA_DECOUPLE_R_W_W      ),
    .DECOUPLE_R_AW_W     ( redmule_tile_pkg::DMA_DECOUPLE_R_AW_W     ),
    .OPCODE_OFF          ( redmule_tile_pkg::DMA_OPCODE_OFF          ),
    .FUNC3_OFF           ( redmule_tile_pkg::DMA_FUNC3_OFF           ),
    .ND_EN_OFF           ( redmule_tile_pkg::DMA_ND_EN_OFF           ),
    .DST_MAX_LOG_LEN_OFF ( redmule_tile_pkg::DMA_DST_MAX_LOG_LEN_OFF ),
    .SRC_MAX_LOG_LEN_OFF ( redmule_tile_pkg::DMA_SRC_MAX_LOG_LEN_OFF ),
    .DST_REDUCE_LEN_OFF  ( redmule_tile_pkg::DMA_DST_REDUCE_LEN_OFF  ),
    .SRC_REDUCE_LEN_OFF  ( redmule_tile_pkg::DMA_SRC_REDUCE_LEN_OFF  ),
    .DECOUPLE_R_W_OFF    ( redmule_tile_pkg::DMA_DECOUPLE_R_W_OFF    ),
    .DECOUPLE_R_AW_OFF   ( redmule_tile_pkg::DMA_DECOUPLE_R_AW_OFF   ),
    .N_CFG_REG           ( redmule_tile_pkg::DMA_N_CFG_REG           ),
    .idma_fe_req_t       ( idma_fe_reg_req_t                         ),
    .idma_fe_rsp_t       ( idma_fe_reg_rsp_t                         )
  ) i_idma_axi2obi_inst_decoder (
    .clk_i                                                  ,
    .rst_ni                                                 ,
    .clear_i                                                ,

    .xif_issue_if_i ( xif_axi2obi_issue_if.coproc_issue    ),

    .cfg_req_o      ( idma_fe_reg_axi2obi_req              ),
    .cfg_rsp_i      ( idma_fe_reg_axi2obi_rsp              ),

    .start_o        ( axi2obi_start_o                      ),
    .busy_o         ( axi2obi_busy_o                       ),
    .done_o         ( axi2obi_done_o                       ),
    .error_o        ( axi2obi_error_o                      )
  );

/*******************************************************/
/**        AXI2OBI Xif Instruction Decoder End        **/
/*******************************************************/
/**     OBI2AXI Xif Instruction Decoder Beginning     **/
/*******************************************************/

  idma_xif_inst_decoder #(
    .INSTR_W             ( redmule_tile_pkg::DMA_INSTR_W             ),
    .DATA_W              ( redmule_tile_pkg::DMA_DATA_W              ),
    .N_RF_PORTS          ( redmule_tile_pkg::DMA_N_RF_PORTS          ),
    .OPCODE_W            ( redmule_tile_pkg::DMA_OPCODE_W            ),
    .FUNC3_W             ( redmule_tile_pkg::DMA_FUNC3_W             ),
    .ND_EN_W             ( redmule_tile_pkg::DMA_ND_EN_W             ),
    .DST_MAX_LOG_LEN_W   ( redmule_tile_pkg::DMA_DST_MAX_LOG_LEN_W   ),
    .SRC_MAX_LOG_LEN_W   ( redmule_tile_pkg::DMA_SRC_MAX_LOG_LEN_W   ),
    .DST_REDUCE_LEN_W    ( redmule_tile_pkg::DMA_DST_REDUCE_LEN_W    ),
    .SRC_REDUCE_LEN_W    ( redmule_tile_pkg::DMA_SRC_REDUCE_LEN_W    ),
    .DECOUPLE_R_W_W      ( redmule_tile_pkg::DMA_DECOUPLE_R_W_W      ),
    .DECOUPLE_R_AW_W     ( redmule_tile_pkg::DMA_DECOUPLE_R_AW_W     ),
    .OPCODE_OFF          ( redmule_tile_pkg::DMA_OPCODE_OFF          ),
    .FUNC3_OFF           ( redmule_tile_pkg::DMA_FUNC3_OFF           ),
    .ND_EN_OFF           ( redmule_tile_pkg::DMA_ND_EN_OFF           ),
    .DST_MAX_LOG_LEN_OFF ( redmule_tile_pkg::DMA_DST_MAX_LOG_LEN_OFF ),
    .SRC_MAX_LOG_LEN_OFF ( redmule_tile_pkg::DMA_SRC_MAX_LOG_LEN_OFF ),
    .DST_REDUCE_LEN_OFF  ( redmule_tile_pkg::DMA_DST_REDUCE_LEN_OFF  ),
    .SRC_REDUCE_LEN_OFF  ( redmule_tile_pkg::DMA_SRC_REDUCE_LEN_OFF  ),
    .DECOUPLE_R_W_OFF    ( redmule_tile_pkg::DMA_DECOUPLE_R_W_OFF    ),
    .DECOUPLE_R_AW_OFF   ( redmule_tile_pkg::DMA_DECOUPLE_R_AW_OFF   ),
    .N_CFG_REG           ( redmule_tile_pkg::DMA_N_CFG_REG           ),
    .idma_fe_req_t       ( idma_fe_reg_req_t                         ),
    .idma_fe_rsp_t       ( idma_fe_reg_rsp_t                         )
  ) i_idma_obi2axi_inst_decoder (
    .clk_i                                               ,
    .rst_ni                                              ,
    .clear_i                                             ,

    .xif_issue_if_i ( xif_obi2axi_issue_if.coproc_issue ),

    .cfg_req_o      ( idma_fe_reg_obi2axi_req           ),
    .cfg_rsp_i      ( idma_fe_reg_obi2axi_rsp           ),

    .start_o        ( obi2axi_start_o                   ),
    .busy_o         ( obi2axi_busy_o                    ),
    .done_o         ( obi2axi_done_o                    ),
    .error_o        ( obi2axi_error_o                   )
  );

/*******************************************************/
/**        OBI2AXI Xif Instruction Decoder End        **/
/*******************************************************/
/**   AXI2OBI (L2 to L1) Transfer Channel Beginning   **/
/*******************************************************/

  idma_axi_obi_transfer_ch #(
    .CHANNEL_T         ( redmule_tile_pkg::AXI2OBI ),
    .ERROR_CAP         ( ERROR_CAP                 ),
    .idma_fe_reg_req_t ( idma_fe_reg_req_t         ),
    .idma_fe_reg_rsp_t ( idma_fe_reg_rsp_t         ),
    .axi_req_t         ( axi_req_t                 ),
    .axi_rsp_t         ( axi_rsp_t                 ),
    .obi_req_t         ( obi_req_t                 ),
    .obi_rsp_t         ( obi_rsp_t                 )
  ) i_l2_to_l1_ch (
    .clk_i                                ,
    .rst_ni                               ,
    .testmode_i                           ,
    .clear_i                              ,
    .cfg_req_i ( idma_fe_reg_axi2obi_req ),
    .cfg_rsp_o ( idma_fe_reg_axi2obi_rsp ),
    .axi_req_o ( axi_read_req_o          ),
    .axi_rsp_i ( axi_read_rsp_i          ),
    .obi_req_o ( obi_write_req_o         ),
    .obi_rsp_i ( obi_write_rsp_i         )
  );

/*******************************************************/
/**      AXI2OBI (L2 to L1) Transfer Channel End      **/
/*******************************************************/
/**   OBI2AXI (L1 to L2) Transfer Channel Beginning   **/
/*******************************************************/

  idma_axi_obi_transfer_ch #(
    .CHANNEL_T         ( redmule_tile_pkg::OBI2AXI ),
    .ERROR_CAP         ( ERROR_CAP                 ),
    .idma_fe_reg_req_t ( idma_fe_reg_req_t         ),
    .idma_fe_reg_rsp_t ( idma_fe_reg_rsp_t         ),
    .axi_req_t         ( axi_req_t                 ),
    .axi_rsp_t         ( axi_rsp_t                 ),
    .obi_req_t         ( obi_req_t                 ),
    .obi_rsp_t         ( obi_rsp_t                 )
  ) i_l1_to_l2_ch (
    .clk_i                                ,
    .rst_ni                               ,
    .testmode_i                           ,
    .clear_i                              ,
    .cfg_req_i ( idma_fe_reg_obi2axi_req ),
    .cfg_rsp_o ( idma_fe_reg_obi2axi_rsp ),
    .axi_req_o ( axi_write_req_o         ),
    .axi_rsp_i ( axi_write_rsp_i         ),
    .obi_req_o ( obi_read_req_o          ),
    .obi_rsp_i ( obi_read_rsp_i          )
  );

/*******************************************************/
/**      OBI2AXI (L1 to L2) Transfer Channel End      **/
/*******************************************************/

endmodule: idma_ctrl