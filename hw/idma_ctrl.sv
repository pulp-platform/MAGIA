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
  parameter idma_pkg::error_cap_e ERROR_CAP = idma_pkg::NO_ERROR_HANDLING,
  parameter int unsigned          N_D       = 2
)(
  input  logic                 clk_i,
  input  logic                 rst_ni,
  input  logic                 testmode_i,
  input  logic                 clear_i,

  cv32e40x_if_xif.coproc_issue xif_issue_if_i,

  output logic                 start_o,  // Started iDMA transfer
  output logic                 busy_o,   // Performing iDMA transfer
  output logic                 done_o,   // Finished iDMA transfer
  output logic                 error_o   // Detected error
);

/*******************************************************/
/**       Internal Signal Definitions Beginning       **/
/*******************************************************/

//TODO
  redmule_tile_pkg::idma_fe_reg_req_t idma_fe_reg_req;
  redmule_tile_pkg::idma_fe_reg_rsp_t idma_fe_reg_rsp;

/*******************************************************/
/**          Internal Signal Definitions End          **/
/*******************************************************/
/**         Xif Instruction Decoder Beginning         **/
/*******************************************************/

  idma_xif_inst_decoder #(
    .INSTR_W             ( redmule_tile_pkg::DMA_INSTR_W             ),
    .DATA_W              ( redmule_tile_pkg::DMA_DATA_W              ),
    .N_RF_PORTS          ( redmule_tile_pkg::DMA_N_RF_PORTS          ),
    .OPCODE_W            ( redmule_tile_pkg::DMA_OP_CODE_W           ),
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
    .idma_fe_req_t       ( redmule_tile_pkg::idma_fe_reg_req_t       ),
    .idma_fe_rsp_t       ( redmule_tile_pkg::idma_fe_reg_rsp_t       )
  ) i_idma_inst_decoder (
    .clk_i                        ,
    .rst_ni                       ,
    .clear_i                      ,

    .xif_issue_if_i               ,

    .cfg_req_o ( idma_fe_reg_req ),
    .cfg_rsp_i ( idma_fe_reg_rsp ),

    .start_o                      ,
    .busy_o                       ,
    .done_o                       ,
    .error_o                      ,
  );

/*******************************************************/
/**            Xif Instruction Decoder End            **/
/*******************************************************/
/**                Front-end Beginning                **/
/*******************************************************/

//TODO
  idma_reg64_2d #(
    .NumRegs        ( redmule_tile_pkg::iDMA_NumRegs        ),
    .NumStreams     ( redmule_tile_pkg::iDMA_NumStreams     ),
    .IdCounterWidth ( redmule_tile_pkg::iDMA_IdCounterWidth ),
    .StreamWidth    ( /*DO NOT OVERRIDE*/ ),
    .reg_req_t      ( redmule_tile_pkg::idma_fe_reg_req_t ),
    .reg_rsp_t      ( redmule_tile_pkg::idma_fe_reg_rsp_t ),
    .dma_req_t      (  ),
    .cnt_width_t    ( /*DO NOT OVERRIDE*/ ),
    .stream_t       ( /*DO NOT OVERRIDE*/ )
  ) i_idma_frontend (
    .clk_i              ,
    .rst_ni             ,

    .dma_ctrl_req_i ( idma_fe_reg_req ),
    .dma_ctrl_rsp_o ( idma_fe_reg_rsp ),

    .dma_req_o      (  ),
    .req_valid_o    (  ),
    .req_ready_i    (  ),
    .next_id_i      (  ),
    .stream_idx_o   (  ),

    .done_id_i      (  ),
    .busy_i         (  ),
    .midend_busy_i  (  )
  );

/*******************************************************/
/**                   Front-end End                   **/
/*******************************************************/
/**                 Mid-end Beginning                 **/
/*******************************************************/

//TODO
  idma_nd_midend #(
    .NumDim        ( N_D ),
    .addr_t        (  ),
    .idma_req_t    (  ),
    .idma_rsp_t    (  ),
    .idma_nd_req_t (  ),
    .RepWidths     (     )
  ) i_idma_midend (
    .clk_i                 ,
    .rst_ni                ,

    .nd_req_i          (  ),
    .nd_req_valid_i    (  ),
    .nd_req_ready_o    (  ),

    .nd_rsp_o          (  ),
    .nd_rsp_valid_o    (  ),
    .nd_rsp_ready_i    (  ),

    .burst_req_o       (  ),
    .burst_req_valid_o (  ),
    .burst_req_ready_i (  ),

    .burst_rsp_i       (  ),
    .burst_rsp_valid_i (  ),
    .burst_rsp_ready_o (  ),

    .busy_o            (  )
  );

/*******************************************************/
/**                    Mid-end End                    **/
/*******************************************************/
/**                 Back-end Beginning                **/
/*******************************************************/

//TODO
  idma_backend_rw_axi_rw_obi #(
    .DataWidth            ( redmule_tile_pkg::iDMA_DataWidth           ),
    .AddrWidth            ( redmule_tile_pkg::iDMA_AddrWidth           ),
    .UserWidth            ( redmule_tile_pkg::iDMA_UserWidth           ),
    .AxiIdWidth           ( redmule_tile_pkg::iDMA_AxiIdWidth          ),
    .NumAxInFlight        ( redmule_tile_pkg::iDMA_NumAxInFlight       ),
    .BufferDepth          ( redmule_tile_pkg::iDMA_BufferDepth         ),
    .TFLenWidth           ( redmule_tile_pkg::iDMA_TFLenWidth          ),
    .MemSysDepth          ( redmule_tile_pkg::iDMA_MemSysDepth         ),
    .CombinedShifter      ( redmule_tile_pkg::iDMA_CombinedShifter     ),
    .RAWCouplingAvail     ( redmule_tile_pkg::iDMA_RAWCouplingAvail    ),
    .MaskInvalidData      ( redmule_tile_pkg::iDMA_MaskInvalidData     ),
    .HardwareLegalizer    ( redmule_tile_pkg::iDMA_HardwareLegalizer   ),
    .RejectZeroTransfers  ( redmule_tile_pkg::iDMA_RejectZeroTransfers ),
    .ErrorCap             ( ERROR_CAP                                  ),
    .PrintFifoInfo        ( redmule_tile_pkg::iDMA_PrintFifoInfo       ),
    .idma_req_t           (  ),
    .idma_rsp_t           (  ),
    .idma_eh_req_t        (  ),
    .idma_busy_t          (  ),
    .axi_req_t            (  ),
    .axi_rsp_t            (  ),
    .obi_req_t            (  ),
    .obi_rsp_t            (  ),
    .read_meta_channel_t  (  ),
    .write_meta_channel_t (  ),
    .StrbWidth            ( /*DO NOT OVERRIDE*/                        ),
    .OffsetWidth          ( /*DO NOT OVERRIDE*/                        )
  ) i_idma_backend (
    .clk_i               ,
    .rst_ni              ,
    .testmode_i          ,

    .idma_req_i      (  ),
    .req_valid_i     (  ),
    .req_ready_o     (  ),

    .idma_rsp_o      (  ),
    .rsp_valid_o     (  ),
    .rsp_ready_i     (  ),

    .idma_eh_req_i   (  ),
    .eh_req_valid_i  (  ),
    .eh_req_ready_o  (  ),

    .axi_read_req_o  (  ),
    .axi_read_rsp_i  (  ),

    .obi_read_req_o  (  ),
    .obi_read_rsp_i  (  ),

    .axi_write_req_o (  ),
    .axi_write_rsp_i (  ),

    .obi_write_req_o (  ),
    .obi_write_rsp_i (  ),
    
    .busy_o          (  )
  );

/*******************************************************/
/**                    Back-end End                   **/
/*******************************************************/

endmodule: idma_ctrl