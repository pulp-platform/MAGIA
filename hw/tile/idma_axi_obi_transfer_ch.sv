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
 * iDMA AXI-OBI Transfer Channel
 */

module idma_axi_obi_transfer_ch 
  import magia_tile_pkg::*;
  import cv32e40x_pkg::*;
  import idma_pkg::*;
#(
  parameter magia_tile_pkg::idma_transfer_ch_e CHANNEL_T         = magia_tile_pkg::AXI2OBI,
  parameter idma_pkg::error_cap_e              ERROR_CAP         = idma_pkg::NO_ERROR_HANDLING,
  parameter type                               idma_fe_reg_req_t = magia_tile_pkg::idma_fe_reg_req_t,
  parameter type                               idma_fe_reg_rsp_t = magia_tile_pkg::idma_fe_reg_rsp_t,
  parameter type                               axi_req_t         = magia_tile_pkg::idma_axi_req_t,
  parameter type                               axi_rsp_t         = magia_tile_pkg::idma_axi_rsp_t,
  parameter type                               obi_req_t         = magia_tile_pkg::idma_obi_req_t,
  parameter type                               obi_rsp_t         = magia_tile_pkg::idma_obi_rsp_t
)(
  input  logic             clk_i,
  input  logic             rst_ni,
  input  logic             testmode_i,
  input  logic             clear_i,

  input  idma_fe_reg_req_t cfg_req_i,
  output idma_fe_reg_rsp_t cfg_rsp_o,

  output axi_req_t         axi_req_o,
  input  axi_rsp_t         axi_rsp_i,

  output obi_req_t         obi_req_o,
  input  obi_rsp_t         obi_rsp_i,

  // IRQ-related outputs
  output logic             transfer_busy_o,
  output logic             transfer_start_o,
  output logic             transfer_done_o,
  output logic             transfer_error_o
);

/*******************************************************/
/**       Internal Signal Definitions Beginning       **/
/*******************************************************/

  magia_tile_pkg::idma_nd_req_t idma_fe_req_d;
  magia_tile_pkg::idma_nd_req_t idma_fe_req;

  magia_tile_pkg::idma_be_req_t idma_be_req;
  magia_tile_pkg::idma_be_rsp_t idma_be_rsp;

  logic fe_req_valid_d, fe_req_ready_d;
  logic fe_req_valid,   fe_req_ready;
  logic fe_rsp_valid,   fe_rsp_ready;
  logic be_req_valid,   be_req_ready;
  logic be_rsp_valid,   be_rsp_ready;

  logic                                          issue_id, retire_id;
  logic[magia_tile_pkg::iDMA_IdCounterWidth-1:0] next_id,  done_id;

  logic stream_fifo_flush;

  idma_pkg::idma_busy_t busy;
  logic                 me_busy;

  idma_pkg::idma_eh_req_t idma_eh_req;
  logic                   eh_req_valid;

/*******************************************************/
/**          Internal Signal Definitions End          **/
/*******************************************************/
/**            Hardwired Signals Beginning            **/
/*******************************************************/

  assign issue_id  = fe_req_valid_d & fe_req_ready_d;
  assign retire_id = fe_rsp_valid   & fe_rsp_ready;
  
  assign fe_rsp_ready = 1'b1;

  assign idma_eh_req  = '0;
  assign eh_req_valid = 1'b0;

  assign stream_fifo_flush = 1'b0;

/*******************************************************/
/**               Hardwired Signals End               **/
/*******************************************************/
/**                Front-end Beginning                **/
/*******************************************************/

  idma_reg32_3d #(
    .NumRegs        ( magia_tile_pkg::iDMA_NumRegs        ),
    .NumStreams     ( magia_tile_pkg::iDMA_NumStreams     ),
    .IdCounterWidth ( magia_tile_pkg::iDMA_IdCounterWidth ),
    .StreamWidth    ( /*DO NOT OVERRIDE*/                 ),
    .reg_req_t      ( idma_fe_reg_req_t                   ),
    .reg_rsp_t      ( idma_fe_reg_rsp_t                   ),
    .dma_req_t      ( magia_tile_pkg::idma_nd_req_t       ),
    .cnt_width_t    ( /*DO NOT OVERRIDE*/                 ),
    .stream_t       ( /*DO NOT OVERRIDE*/                 )
  ) i_idma_frontend (
    .clk_i                             ,
    .rst_ni                            ,

    .dma_ctrl_req_i ( cfg_req_i       ),
    .dma_ctrl_rsp_o ( cfg_rsp_o       ),

    .dma_req_o      ( idma_fe_req_d   ),
    .req_valid_o    ( fe_req_valid_d  ),
    .req_ready_i    ( fe_req_ready_d  ),
    .next_id_i      ( next_id         ),
    .stream_idx_o   (                 ),

    .done_id_i      ( done_id         ),
    .busy_i         ( busy            ),
    .midend_busy_i  ( me_busy         )
  );

/*******************************************************/
/**                   Front-end End                   **/
/*******************************************************/
/**               Transfer ID Beginning               **/
/*******************************************************/

  idma_transfer_id_gen #(
    .IdWidth ( magia_tile_pkg::iDMA_IdCounterWidth )
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
/**               Stream FIFO Beginning               **/
/*******************************************************/

  stream_fifo_optimal_wrap #(
    .Depth     ( magia_tile_pkg::iDMA_JobFifoDepth  ),
    .type_t    ( magia_tile_pkg::idma_nd_req_t      ),
    .PrintInfo ( magia_tile_pkg::iDMA_PrintFifoInfo )
  ) i_stream_fifo_jobs_2d (
    .clk_i                           ,
    .rst_ni                          ,
    .testmode_i                      ,
    .flush_i    ( stream_fifo_flush ),
    .usage_o    (                   ),
    .data_i     ( idma_fe_req_d     ),
    .valid_i    ( fe_req_valid_d    ),
    .ready_o    ( fe_req_ready_d    ),
    .data_o     ( idma_fe_req       ),
    .valid_o    ( fe_req_valid      ),
    .ready_i    ( fe_req_ready      )
  );

/*******************************************************/
/**                  Stream FIFO End                  **/
/*******************************************************/
/**                 Mid-end Beginning                 **/
/*******************************************************/

  idma_nd_midend #(
    .NumDim        ( magia_tile_pkg::iDMA_NumDims   ),
    .addr_t        ( magia_tile_pkg::idma_addr_t    ),
    .idma_req_t    ( magia_tile_pkg::idma_be_req_t  ),
    .idma_rsp_t    ( magia_tile_pkg::idma_be_rsp_t  ),
    .idma_nd_req_t ( magia_tile_pkg::idma_nd_req_t  ),
    .RepWidths     ( magia_tile_pkg::iDMA_RepWidths )
  ) i_idma_midend (
    .clk_i                             ,
    .rst_ni                            ,

    .nd_req_i          ( idma_fe_req  ),
    .nd_req_valid_i    ( fe_req_valid ),
    .nd_req_ready_o    ( fe_req_ready ),

    .nd_rsp_o          (              ),
    .nd_rsp_valid_o    ( fe_rsp_valid ),
    .nd_rsp_ready_i    ( fe_rsp_ready ),

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

  generate if (CHANNEL_T == magia_tile_pkg::AXI2OBI) begin: gen_axi2obi_ch
    idma_backend_r_axi_w_obi #(
      .DataWidth            ( magia_tile_pkg::iDMA_DataWidth            ),
      .AddrWidth            ( magia_tile_pkg::iDMA_AddrWidth            ),
      .UserWidth            ( magia_tile_pkg::iDMA_UserWidth            ),
      .AxiIdWidth           ( magia_tile_pkg::iDMA_AxiIdWidth           ),
      .NumAxInFlight        ( magia_tile_pkg::iDMA_NumAxInFlight        ),
      .BufferDepth          ( magia_tile_pkg::iDMA_BufferDepth          ),
      .TFLenWidth           ( magia_tile_pkg::iDMA_TFLenWidth           ),
      .MemSysDepth          ( magia_tile_pkg::iDMA_MemSysDepth          ),
      .CombinedShifter      ( magia_tile_pkg::iDMA_CombinedShifter      ),
      .RAWCouplingAvail     ( magia_tile_pkg::iDMA_RAWCouplingAvail     ),
      .MaskInvalidData      ( magia_tile_pkg::iDMA_MaskInvalidData      ),
      .HardwareLegalizer    ( magia_tile_pkg::iDMA_HardwareLegalizer    ),
      .RejectZeroTransfers  ( magia_tile_pkg::iDMA_RejectZeroTransfers  ),
      .ErrorCap             ( ERROR_CAP                                 ),
      .PrintFifoInfo        ( magia_tile_pkg::iDMA_PrintFifoInfo        ),
      .idma_req_t           ( magia_tile_pkg::idma_be_req_t             ),
      .idma_rsp_t           ( magia_tile_pkg::idma_be_rsp_t             ),
      .idma_eh_req_t        ( idma_pkg::idma_eh_req_t                   ),
      .idma_busy_t          ( idma_pkg::idma_busy_t                     ),
      .axi_req_t            ( magia_tile_pkg::idma_axi_req_t            ),
      .axi_rsp_t            ( magia_tile_pkg::idma_axi_rsp_t            ),
      .obi_req_t            ( magia_tile_pkg::idma_obi_req_t            ),
      .obi_rsp_t            ( magia_tile_pkg::idma_obi_rsp_t            ),
      .read_meta_channel_t  ( magia_tile_pkg::idma_read_meta_channel_t  ),
      .write_meta_channel_t ( magia_tile_pkg::idma_write_meta_channel_t ),
      .StrbWidth            ( /*DO NOT OVERRIDE*/                       ),
      .OffsetWidth          ( /*DO NOT OVERRIDE*/                       )
    ) i_idma_backend (
      .clk_i                           ,
      .rst_ni                          ,
      .testmode_i                      ,

      .idma_req_i      ( idma_be_req  ),
      .req_valid_i     ( be_req_valid ),
      .req_ready_o     ( be_req_ready ),

      .idma_rsp_o      ( idma_be_rsp  ),
      .rsp_valid_o     ( be_rsp_valid ),
      .rsp_ready_i     ( be_rsp_ready ),

      .idma_eh_req_i   ( idma_eh_req  ),
      .eh_req_valid_i  ( eh_req_valid ),
      .eh_req_ready_o  (              ),

      .axi_read_req_o  ( axi_req_o    ),
      .axi_read_rsp_i  ( axi_rsp_i    ),

      .obi_write_req_o ( obi_req_o    ),
      .obi_write_rsp_i ( obi_rsp_i    ),
      
      .busy_o          ( busy         )
    );
  end else if (CHANNEL_T == magia_tile_pkg::OBI2AXI) begin: gen_obi2axi_ch
    idma_backend_r_obi_w_axi #(
      .DataWidth            ( magia_tile_pkg::iDMA_DataWidth            ),
      .AddrWidth            ( magia_tile_pkg::iDMA_AddrWidth            ),
      .UserWidth            ( magia_tile_pkg::iDMA_UserWidth            ),
      .AxiIdWidth           ( magia_tile_pkg::iDMA_AxiIdWidth           ),
      .NumAxInFlight        ( magia_tile_pkg::iDMA_NumAxInFlight        ),
      .BufferDepth          ( magia_tile_pkg::iDMA_BufferDepth          ),
      .TFLenWidth           ( magia_tile_pkg::iDMA_TFLenWidth           ),
      .MemSysDepth          ( magia_tile_pkg::iDMA_MemSysDepth          ),
      .CombinedShifter      ( magia_tile_pkg::iDMA_CombinedShifter      ),
      .RAWCouplingAvail     ( magia_tile_pkg::iDMA_RAWCouplingAvail     ),
      .MaskInvalidData      ( magia_tile_pkg::iDMA_MaskInvalidData      ),
      .HardwareLegalizer    ( magia_tile_pkg::iDMA_HardwareLegalizer    ),
      .RejectZeroTransfers  ( magia_tile_pkg::iDMA_RejectZeroTransfers  ),
      .ErrorCap             ( ERROR_CAP                                 ),
      .PrintFifoInfo        ( magia_tile_pkg::iDMA_PrintFifoInfo        ),
      .idma_req_t           ( magia_tile_pkg::idma_be_req_t             ),
      .idma_rsp_t           ( magia_tile_pkg::idma_be_rsp_t             ),
      .idma_eh_req_t        ( idma_pkg::idma_eh_req_t                   ),
      .idma_busy_t          ( idma_pkg::idma_busy_t                     ),
      .axi_req_t            ( magia_tile_pkg::idma_axi_req_t            ),
      .axi_rsp_t            ( magia_tile_pkg::idma_axi_rsp_t            ),
      .obi_req_t            ( magia_tile_pkg::idma_obi_req_t            ),
      .obi_rsp_t            ( magia_tile_pkg::idma_obi_rsp_t            ),
      .read_meta_channel_t  ( magia_tile_pkg::idma_read_meta_channel_t  ),
      .write_meta_channel_t ( magia_tile_pkg::idma_write_meta_channel_t ),
      .StrbWidth            ( /*DO NOT OVERRIDE*/                       ),
      .OffsetWidth          ( /*DO NOT OVERRIDE*/                       )
    ) i_idma_backend (
      .clk_i                           ,
      .rst_ni                          ,
      .testmode_i                      ,

      .idma_req_i      ( idma_be_req  ),
      .req_valid_i     ( be_req_valid ),
      .req_ready_o     ( be_req_ready ),

      .idma_rsp_o      ( idma_be_rsp  ),
      .rsp_valid_o     ( be_rsp_valid ),
      .rsp_ready_i     ( be_rsp_ready ),

      .idma_eh_req_i   ( idma_eh_req  ),
      .eh_req_valid_i  ( eh_req_valid ),
      .eh_req_ready_o  (              ),

      .obi_read_req_o  ( obi_req_o    ),
      .obi_read_rsp_i  ( obi_rsp_i    ),

      .axi_write_req_o ( axi_req_o    ),
      .axi_write_rsp_i ( axi_rsp_i    ),
      
      .busy_o          ( busy         )
    );
  end endgenerate

/*******************************************************/
/**                    Back-end End                   **/
/*******************************************************/
/**                 IRQ Signal Generation             **/
/*******************************************************/

  // Generate IRQ signals from internal transfer state
  assign transfer_busy_o  = |busy;           // Any busy indication from iDMA
  assign transfer_start_o = issue_id;        // Transfer started (ID issued)
  assign transfer_done_o  = retire_id;       // Transfer completed (ID retired)
  assign transfer_error_o = eh_req_valid;    // Error handling request indicates error

endmodule: idma_axi_obi_transfer_ch