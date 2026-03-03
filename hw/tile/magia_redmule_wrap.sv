/*
 * Copyright (C) 2024 ETH Zurich and University of Bologna
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
 * Authors: Francesco Conti <f.conti@unibo.it>
 * 
 * MAGIA RedMulE Wrapper
 * 
 * This wrapper wraps redmule_top to expose struct-based HCI and HWPE-ctrl
 * interfaces instead of the interface-based ports used by redmule_top.
 */

`include "hci_helpers.svh"

module magia_redmule_wrap
  import fpnew_pkg::*;
  import redmule_pkg::*;
  import hci_package::*;
  import hwpe_ctrl_package::*;
  import hwpe_stream_package::*;
  import magia_tile_pkg::*;
  import magia_pkg::*;
#(
  parameter int unsigned  DataW                  = magia_tile_pkg::REDMULE_DW,
  parameter fp_format_e   FpFormat               = FP16,
  parameter int unsigned  Height                 = 16,
  parameter int unsigned  Width                  = 24,            // fixme: possibly decrease to 16
  parameter int unsigned  NumPipeRegs            = 1,
  parameter pipe_config_t PipeConfig             = DISTRIBUTED,
  parameter int unsigned  EccChunkSize           = 32,
  parameter bit           LatchBuffers           = 0,
  parameter fpnew_pkg::fmt_logic_t  FpFmtConfig  = 6'b001101,
  parameter fpnew_pkg::ifmt_logic_t IntFmtConfig = 4'b1000,
  parameter ctrl_intf_e   CtrlIntfConfig         = XIF,
  parameter logic [6:0]   McnfigOpCode           = 7'b0001011,
  parameter logic [6:0]   MarithOpCode           = 7'b0001011,
  parameter logic [6:0]   MopcntOpCode           = 7'b0001011,
  parameter logic [2:0]   McnfigFunct3           = 3'b000,
  parameter logic [2:0]   MarithFunct3           = 3'b001,
  parameter logic [2:0]   MopcntFunct3           = 3'b010,
  parameter logic [1:0]   McnfigFunct2           = 2'b00,
  parameter logic [1:0]   MarithFunct2           = 2'b00,
  parameter logic [1:0]   MopcntFunct2           = 2'b00,
  parameter int unsigned  XifNumHarts            = 1,
  parameter int unsigned  XifIdWidth             = 1,
  parameter int unsigned  XifIssueRegisterSplit  = 0,
  parameter type          x_issue_req_t          = logic,
  parameter type          x_issue_resp_t         = logic,
  parameter type          x_register_t           = logic,
  parameter type          x_commit_t             = logic,
  parameter type          x_result_t             = logic,
  parameter type          redmule_data_req_t     = magia_tile_pkg::redmule_data_req_t,
  parameter type          redmule_data_rsp_t     = magia_tile_pkg::redmule_data_rsp_t,
  parameter type          redmule_ctrl_req_t     = magia_tile_pkg::redmule_ctrl_req_t,
  parameter type          redmule_ctrl_rsp_t     = magia_tile_pkg::redmule_ctrl_rsp_t,
  parameter hci_size_parameter_t `HCI_SIZE_PARAM(tcdm) = '{
    DW:  DataW,
    AW:  magia_pkg::ADDR_W,
    BW:  hci_package::DEFAULT_BW,
    UW:  magia_tile_pkg::REDMULE_UW,
    IW:  hci_package::DEFAULT_IW,
    EW:  hci_package::DEFAULT_EW,
    EHW: hci_package::DEFAULT_EHW
  }
)(
  input  logic                    clk_i,
  input  logic                    rst_ni,
  input  logic                    test_mode_i,
  output logic                    busy_o,
  output logic                    evt_o,
  // XIF ports (unused if CtrlIntfConfig = HWPE_TARGET)
  input  x_issue_req_t            x_issue_req_i,
  output x_issue_resp_t           x_issue_resp_o,
  input  logic                    x_issue_valid_i,
  output logic                    x_issue_ready_o,
  input  x_register_t             x_register_i,
  input  logic                    x_register_valid_i,
  output logic                    x_register_ready_o,
  input  x_commit_t               x_commit_i,
  input  logic                    x_commit_valid_i,
  output x_result_t               x_result_o,
  output logic                    x_result_valid_o,
  input  logic                    x_result_ready_i,
  // Struct-based HCI data ports
  output redmule_data_req_t       data_req_o,
  input  redmule_data_rsp_t       data_rsp_i,
  // Struct-based HWPE-ctrl ports
  input  redmule_ctrl_req_t       ctrl_req_i,
  output redmule_ctrl_rsp_t       ctrl_rsp_o
);

  localparam hci_size_parameter_t `HCI_SIZE_PARAM(tcdm_filtered) = `HCI_SIZE_PARAM(tcdm);

  // Internal interface instances for HCI
  `HCI_INTF(tcdm, clk_i);
  `HCI_INTF(tcdm_filtered, clk_i);
  
  // Internal interface instance for HWPE-ctrl
  hwpe_ctrl_intf_periph #( 
    .ID_WIDTH ( hci_package::DEFAULT_IW )
  ) target (
    .clk ( clk_i )
  );

  // Internal interface instances for HWPE streams (dummy, unused)
  hwpe_stream_intf_stream w_stream_i (
    .clk ( clk_i )
  );
  hwpe_stream_intf_stream x_stream_i (
    .clk ( clk_i )
  );
  hwpe_stream_intf_stream w_stream_o (
    .clk ( clk_i )
  );
  hwpe_stream_intf_stream x_stream_o (
    .clk ( clk_i )
  );

  // Tie off dummy HWPE stream inputs
  assign w_stream_i.valid = '0;
  assign w_stream_i.data  = '0;
  assign w_stream_i.strb  = '0;
  assign x_stream_i.valid = '0;
  assign x_stream_i.data  = '0;
  assign x_stream_i.strb  = '0;

  // Tie off dummy HWPE stream outputs
  assign w_stream_o.ready = '1;
  assign x_stream_o.ready = '1;

  // Filter r_id from tcdm interface
  hci_core_r_id_filter #(
    .`HCI_SIZE_PARAM(tcdm_target) ( `HCI_SIZE_PARAM(tcdm) )
  ) i_tcdm_r_id_filter (
    .clk_i           ( clk_i         ),
    .rst_ni          ( rst_ni        ),
    .clear_i         ( 1'b0          ),
    .enable_i        ( 1'b1          ),
    .tcdm_target     ( tcdm          ),
    .tcdm_initiator  ( tcdm_filtered )
  );

  // Convert struct-based ports to interface-based ports for HCI
  `HCI_ASSIGN_FROM_INTF(tcdm_filtered, data_req_o, data_rsp_i);
  
  // Convert struct-based ports to interface-based ports for HWPE-ctrl
  assign target.req        = ctrl_req_i.req;
  assign target.add        = ctrl_req_i.add;
  assign target.wen        = ctrl_req_i.wen;
  assign target.be         = ctrl_req_i.be;
  assign target.data       = ctrl_req_i.data;
  assign target.id         = ctrl_req_i.id;
  assign ctrl_rsp_o.gnt    = target.gnt;
  assign ctrl_rsp_o.r_data = target.r_data;
  assign ctrl_rsp_o.r_valid = target.r_valid;
  assign ctrl_rsp_o.r_id   = target.r_id;

  // Instantiate redmule_top with interface-based ports
  redmule_top #(
    .DataW                  ( DataW                ),
    .FpFormat               ( FpFormat             ),
    .Height                 ( Height               ),
    .Width                  ( Width                ),
    .NumPipeRegs            ( NumPipeRegs          ),
    .PipeConfig             ( PipeConfig           ),
    .EccChunkSize           ( EccChunkSize         ),
    .LatchBuffers           ( LatchBuffers         ),
    .FpFmtConfig            ( FpFmtConfig          ),
    .IntFmtConfig           ( IntFmtConfig         ),
    .CtrlIntfConfig         ( CtrlIntfConfig       ),
    .McnfigOpCode           ( McnfigOpCode         ),
    .MarithOpCode           ( MarithOpCode         ),
    .MopcntOpCode           ( MopcntOpCode         ),
    .McnfigFunct3           ( McnfigFunct3         ),
    .MarithFunct3           ( MarithFunct3         ),
    .MopcntFunct3           ( MopcntFunct3         ),
    .McnfigFunct2           ( McnfigFunct2         ),
    .MarithFunct2           ( MarithFunct2         ),
    .MopcntFunct2           ( MopcntFunct2         ),
    .XifNumHarts            ( XifNumHarts          ),
    .XifIdWidth             ( XifIdWidth           ),
    .XifIssueRegisterSplit  ( XifIssueRegisterSplit),
    .x_issue_req_t          ( x_issue_req_t        ),
    .x_issue_resp_t         ( x_issue_resp_t       ),
    .x_register_t           ( x_register_t         ),
    .x_commit_t             ( x_commit_t           ),
    .x_result_t             ( x_result_t           ),
    .`HCI_SIZE_PARAM(tcdm)  ( `HCI_SIZE_PARAM(tcdm))
  ) i_redmule_top (
    .clk_i               ( clk_i               ),
    .rst_ni              ( rst_ni              ),
    .test_mode_i         ( test_mode_i         ),
    .busy_o              ( busy_o              ),
    .evt_o               ( evt_o               ),
    .w_stream_i          ( w_stream_i          ),
    .x_stream_i          ( x_stream_i          ),
    .w_stream_o          ( w_stream_o          ),
    .x_stream_o          ( x_stream_o          ),
    .x_issue_req_i       ( x_issue_req_i       ),
    .x_issue_resp_o      ( x_issue_resp_o      ),
    .x_issue_valid_i     ( x_issue_valid_i     ),
    .x_issue_ready_o     ( x_issue_ready_o     ),
    .x_register_i        ( x_register_i        ),
    .x_register_valid_i  ( x_register_valid_i  ),
    .x_register_ready_o  ( x_register_ready_o  ),
    .x_commit_i          ( x_commit_i          ),
    .x_commit_valid_i    ( x_commit_valid_i    ),
    .x_result_o          ( x_result_o          ),
    .x_result_valid_o    ( x_result_valid_o    ),
    .x_result_ready_i    ( x_result_ready_i    ),
    .sync_o              (                     ),
    .sync_i              ( 1'b0                ),
    .tcdm                ( tcdm                ),
    .target              ( target              )
  );

endmodule
