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
  parameter type                  idma_fe_reg_req_t = redmule_tile_pkg::idma_fe_reg_req_t,
  parameter type                  idma_fe_reg_rsp_t = redmule_tile_pkg::idma_fe_reg_rsp_t,
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

  output axi_req_t             axi_req_o, //TODO: add separate channels for read and write
  input  axi_rsp_t             axi_rsp_i, //TODO: add separate channels for read and write

  output obi_req_t             obi_req_o, //TODO: add separate channels for read and write
  input  obi_rsp_t             obi_rsp_i, //TODO: add separate channels for read and write

  output logic                 start_o,  // Started iDMA transfer
  output logic                 busy_o,   // Performing iDMA transfer
  output logic                 done_o,   // Finished iDMA transfer
  output logic                 error_o   // Detected error
);

/*******************************************************/
/**       Internal Signal Definitions Beginning       **/
/*******************************************************/

  idma_fe_reg_req_t idma_fe_reg_req;
  idma_fe_reg_rsp_t idma_fe_reg_rsp;

  idma_fe_reg_req_t idma_fe_reg_axi2obi_req;
  idma_fe_reg_rsp_t idma_fe_reg_axi2obi_rsp;
  idma_fe_reg_req_t idma_fe_reg_obi2axi_req;
  idma_fe_reg_rsp_t idma_fe_reg_obi2axi_rsp;

  logic direction;

  redmule_tile_pkg::idma_axi_req_t axi_read_req;
  redmule_tile_pkg::idma_axi_rsp_t axi_read_rsp;
  redmule_tile_pkg::idma_axi_req_t axi_write_req;
  redmule_tile_pkg::idma_axi_rsp_t axi_write_rsp;

  redmule_tile_pkg::idma_obi_req_t obi_read_req;
  redmule_tile_pkg::idma_obi_rsp_t obi_read_rsp;
  redmule_tile_pkg::idma_obi_req_t obi_write_req;
  redmule_tile_pkg::idma_obi_rsp_t obi_write_rsp;

/*******************************************************/
/**          Internal Signal Definitions End          **/
/*******************************************************/
/**            Hardwired Signals Beginning            **/
/*******************************************************/

  assign axi_req_o     = direction ? axi_write_req : axi_read_req;
  assign axi_write_rsp = direction ? axi_rsp_i     : '0;
  assign axi_read_rsp  = direction ? '0            : axi_rsp_i;

  assign obi_req_o     = direction ? obi_read_req : obi_write_req;
  assign obi_read_rsp  = direction ? obi_rsp_i    : '0;
  assign obi_write_rsp = direction ? '0           : obi_rsp_i;

  assign idma_fe_reg_rsp         = direction ? idma_fe_reg_obi2axi_rsp : idma_fe_reg_axi2obi_rsp;
  assign idma_fe_reg_axi2obi_req = direction ? '0                      : idma_fe_reg_req;
  assign idma_fe_reg_obi2axi_req = direction ? idma_fe_reg_req         : '0;

/*******************************************************/
/**               Hardwired Signals End               **/
/*******************************************************/
/**         Xif Instruction Decoder Beginning         **/
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
  ) i_idma_inst_decoder (
    .clk_i                          ,
    .rst_ni                         ,
    .clear_i                        ,

    .xif_issue_if_i                 ,

    .cfg_req_o   ( idma_fe_reg_req ),
    .cfg_rsp_i   ( idma_fe_reg_rsp ),

    .direction_o ( direction       ),
    .start_o                        ,
    .busy_o                         ,
    .done_o                         ,
    .error_o                        
  );

/*******************************************************/
/**            Xif Instruction Decoder End            **/
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
    .axi_req_o ( axi_read_req            ),
    .axi_rsp_i ( axi_read_rsp            ),
    .obi_req_o ( obi_write_req           ),
    .obi_rsp_i ( obi_write_rsp           )
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
    .axi_req_o ( axi_write_req           ),
    .axi_rsp_i ( axi_write_rsp           ),
    .obi_req_o ( obi_read_req            ),
    .obi_rsp_i ( obi_read_rsp            )
  );

/*******************************************************/
/**      OBI2AXI (L1 to L2) Transfer Channel End      **/
/*******************************************************/

endmodule: idma_ctrl