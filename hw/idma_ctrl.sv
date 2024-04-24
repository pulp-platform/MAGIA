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
  parameter type                  axi_req_t = redmule_tile_pkg::idma_axi_req_t,
  parameter type                  axi_rsp_t = redmule_tile_pkg::idma_axi_rsp_t,
  parameter type                  obi_req_t = redmule_tile_pkg::idma_obi_req_t,
  parameter type                  obi_rsp_t = redmule_tile_pkg::idma_obi_rsp_t
)(
  input  logic                 clk_i,
  input  logic                 rst_ni,
  input  logic                 testmode_i,
  input  logic                 clear_i,

  cv32e40x_if_xif.coproc_issue xif_issue_if_i,

  output axi_req_t             axi_req_o,
  input  axi_rsp_t             axi_rsp_i,

  output obi_req_t             obi_req_o,
  input  obi_rsp_t             obi_rsp_i,

  output logic                 start_o,  // Started iDMA transfer
  output logic                 busy_o,   // Performing iDMA transfer
  output logic                 done_o,   // Finished iDMA transfer
  output logic                 error_o   // Detected error
);

/*******************************************************/
/**       Internal Signal Definitions Beginning       **/
/*******************************************************/

  redmule_tile_pkg::idma_fe_reg_req_t              idma_fe_reg_req;
  redmule_tile_pkg::idma_fe_reg_rsp_t              idma_fe_reg_rsp;

  redmule_tile_pkg::idma_nd_req_t                  idma_fe_req;

  redmule_tile_pkg::idma_be_req_t                  idma_be_req;
  redmule_tile_pkg::idma_be_rsp_t                  idma_be_rsp;

  logic                                            fe_req_valid, fe_req_ready;
  logic                                            be_req_valid, be_req_ready;
  logic                                            be_rsp_valid, be_rsp_ready;
  logic                                            nd_rsp_valid, nd_rsp_ready;

  logic                                            issue_id, retire_id;
  logic[redmule_tile_pkg::iDMA_IdCounterWidth-1:0] next_id, done_id;

  idma_pkg::idma_busy_t                            busy;
  logic                                            me_busy;

  idma_pkg::idma_eh_req_t                          idma_eh_req;
  logic                                            eh_req_valid;

  logic                                            direction;

/*******************************************************/
/**          Internal Signal Definitions End          **/
/*******************************************************/
/**            Hardwired Signals Beginning            **/
/*******************************************************/

  assign issue_id  = fe_req_valid & fe_req_ready;
  assign retire_id = nd_rsp_valid & nd_rsp_ready;

  assign idma_eh_req  = '0;
  assign eh_req_valid = 1'b0;

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
    .idma_fe_req_t       ( redmule_tile_pkg::idma_fe_reg_req_t       ),
    .idma_fe_rsp_t       ( redmule_tile_pkg::idma_fe_reg_rsp_t       )
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
/**                Front-end Beginning                **/
/*******************************************************/

  idma_reg64_2d #(
    .NumRegs        ( redmule_tile_pkg::iDMA_NumRegs        ),
    .NumStreams     ( redmule_tile_pkg::iDMA_NumStreams     ),
    .IdCounterWidth ( redmule_tile_pkg::iDMA_IdCounterWidth ),
    .StreamWidth    ( /*DO NOT OVERRIDE*/                   ),
    .reg_req_t      ( redmule_tile_pkg::idma_fe_reg_req_t   ),
    .reg_rsp_t      ( redmule_tile_pkg::idma_fe_reg_rsp_t   ),
    .dma_req_t      ( redmule_tile_pkg::idma_nd_req_t       ),
    .cnt_width_t    ( /*DO NOT OVERRIDE*/                   ),
    .stream_t       ( /*DO NOT OVERRIDE*/                   )
  ) i_idma_frontend (
    .clk_i                             ,
    .rst_ni                            ,

    .dma_ctrl_req_i ( idma_fe_reg_req ),
    .dma_ctrl_rsp_o ( idma_fe_reg_rsp ),

    .dma_req_o      ( idma_fe_req     ),
    .req_valid_o    ( fe_req_valid    ),
    .req_ready_i    ( fe_req_ready    ),
    .next_id_i      ( next_id         ),
    .stream_idx_o   (                 ),

    .done_id_i      ( done_id         ),
    .busy_i         ( busy            ),
    .midend_busy_i  ( me_busy         )
  );

/*******************************************************/
/**                   Front-end End                   **/
/*******************************************************/
/**                 Mid-end Beginning                 **/
/*******************************************************/

  idma_nd_midend #(
    .NumDim        ( redmule_tile_pkg::iDMA_NumDims   ),
    .addr_t        ( redmule_tile_pkg::idma_addr_t    ),
    .idma_req_t    ( redmule_tile_pkg::idma_be_req_t  ),
    .idma_rsp_t    ( redmule_tile_pkg::idma_be_rsp_t  ),
    .idma_nd_req_t ( redmule_tile_pkg::idma_nd_req_t  ),
    .RepWidths     ( redmule_tile_pkg::iDMA_RepWidths )
  ) i_idma_midend (
    .clk_i                             ,
    .rst_ni                            ,

    .nd_req_i          ( idma_fe_req  ),
    .nd_req_valid_i    ( fe_req_valid ),
    .nd_req_ready_o    ( fe_req_ready ),

    .nd_rsp_o          (              ),
    .nd_rsp_valid_o    ( nd_rsp_valid ),
    .nd_rsp_ready_i    ( nd_rsp_ready ),

    .burst_req_o       ( idma_be_req  ),
    .burst_req_valid_o ( be_req_valid ),
    .burst_req_ready_i ( be_req_ready ),

    .burst_rsp_i       ( idma_be_rsp  ),
    .burst_rsp_valid_i ( be_rsp_valid ),
    .burst_rsp_ready_o ( be_rsp_ready ),

    .busy_o            ( me_busy      )
  );

/*******************************************************/
/**                    Mid-end End                    **/
/*******************************************************/
/**                 Back-end Beginning                **/
/*******************************************************/

  idma_backend_rw_axi_rw_obi #(
    .DataWidth            ( redmule_tile_pkg::iDMA_DataWidth            ),
    .AddrWidth            ( redmule_tile_pkg::iDMA_AddrWidth            ),
    .UserWidth            ( redmule_tile_pkg::iDMA_UserWidth            ),
    .AxiIdWidth           ( redmule_tile_pkg::iDMA_AxiIdWidth           ),
    .NumAxInFlight        ( redmule_tile_pkg::iDMA_NumAxInFlight        ),
    .BufferDepth          ( redmule_tile_pkg::iDMA_BufferDepth          ),
    .TFLenWidth           ( redmule_tile_pkg::iDMA_TFLenWidth           ),
    .MemSysDepth          ( redmule_tile_pkg::iDMA_MemSysDepth          ),
    .CombinedShifter      ( redmule_tile_pkg::iDMA_CombinedShifter      ),
    .RAWCouplingAvail     ( redmule_tile_pkg::iDMA_RAWCouplingAvail     ),
    .MaskInvalidData      ( redmule_tile_pkg::iDMA_MaskInvalidData      ),
    .HardwareLegalizer    ( redmule_tile_pkg::iDMA_HardwareLegalizer    ),
    .RejectZeroTransfers  ( redmule_tile_pkg::iDMA_RejectZeroTransfers  ),
    .ErrorCap             ( ERROR_CAP                                   ),
    .PrintFifoInfo        ( redmule_tile_pkg::iDMA_PrintFifoInfo        ),
    .idma_req_t           ( redmule_tile_pkg::idma_be_req_t             ),
    .idma_rsp_t           ( redmule_tile_pkg::idma_be_rsp_t             ),
    .idma_eh_req_t        ( idma_pkg::idma_eh_req_t                     ),
    .idma_busy_t          ( idma_pkg::idma_busy_t                       ),
    .axi_req_t            ( redmule_tile_pkg::idma_axi_req_t            ),
    .axi_rsp_t            ( redmule_tile_pkg::idma_axi_rsp_t            ),
    .obi_req_t            ( redmule_tile_pkg::idma_obi_req_t            ),
    .obi_rsp_t            ( redmule_tile_pkg::idma_obi_rsp_t            ),
    .read_meta_channel_t  ( redmule_tile_pkg::idma_read_meta_channel_t  ),
    .write_meta_channel_t ( redmule_tile_pkg::idma_write_meta_channel_t ),
    .StrbWidth            ( /*DO NOT OVERRIDE*/                         ),
    .OffsetWidth          ( /*DO NOT OVERRIDE*/                         )
  ) i_idma_backend (
    .clk_i                              ,
    .rst_ni                             ,
    .testmode_i                         ,

    .idma_req_i      ( idma_be_req     ),
    .req_valid_i     ( be_req_valid    ),
    .req_ready_o     ( be_req_ready    ),

    .idma_rsp_o      ( idma_be_rsp     ),
    .rsp_valid_o     ( be_rsp_valid    ),
    .rsp_ready_i     ( be_rsp_ready    ),

    .idma_eh_req_i   ( idma_eh_req     ),
    .eh_req_valid_i  ( eh_req_valid    ),
    .eh_req_ready_o  (                 ),

    .axi_read_req_o  ( axi_read_req_o  ),
    .axi_read_rsp_i  ( axi_read_rsp_i  ),

    .obi_read_req_o  ( obi_read_req_o  ),
    .obi_read_rsp_i  ( obi_read_rsp_i  ),

    .axi_write_req_o ( axi_write_req_o ),
    .axi_write_rsp_i ( axi_write_rsp_i ),

    .obi_write_req_o ( obi_write_req_o ),
    .obi_write_rsp_i ( obi_write_rsp_i ),
    
    .busy_o          ( busy            )
  );

/*******************************************************/
/**                    Back-end End                   **/
/*******************************************************/
/**               Transfer ID Beginning               **/
/*******************************************************/

  idma_transfer_id_gen #(
    .IdWidth ( redmule_tile_pkg::iDMA_IdCounterWidth )
  ) i_transfer_id_gen (
    .clk_i                    ,
    .rst_ni                   ,
    .issue_i     ( issue_id  ),
    .retire_i    ( retire_id ),
    .next_o      ( next_id   ),
    .completed_o ( done_id   )
  );

/*******************************************************/
/**                  Transfer ID End                  **/
/*******************************************************/
/**                 AXI MUX Beginning                 **/
/*******************************************************/

//TODO: Do we even need this???
  assign axi_req_o = direction ? axi_write_req_o : axi_read_req_o;
  assign axi_rsp_i = direction ? axi_write_rsp_i : axi_read_rsp_i;
  assign axi_write_rsp_i = direction ? axi_write_rsp_i : '0;
  assign axi_read_rsp_i  = direction ? '0              : axi_read_rsp_i;

/*******************************************************/
/**                    AXI MUX End                    **/
/*******************************************************/
/**                 OBI MUX Beginning                 **/
/*******************************************************/

//TODO: Do we even need this???
  assign obi_req_o = direction ? obi_read_req_o : obi_write_req_o;
  assign obi_rsp_i = direction ? obi_read_rsp_i : obi_write_rsp_i;
  assign obi_read_rsp_i  = direction ? obi_read_rsp_i : '0;
  assign obi_write_rsp_i = direction ? '0             : obi_write_rsp_i;

/*******************************************************/
/**                    OBI MUX End                    **/
/*******************************************************/

endmodule: idma_ctrl