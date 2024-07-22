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
 * RedMulE Tile
 */

`include "hci/assign.svh"

module redmule_tile
  import redmule_tile_pkg::*;
  import redmule_mesh_pkg::*;
  import redmule_pkg::*;
  import hci_package::*;
  import cv32e40x_pkg::*;
  import idma_pkg::*;
  import obi_pkg::*;
#(
  // Parameters used by hci_interconnect and l1_spm
  parameter int unsigned          N_MEM_BANKS   = redmule_tile_pkg::N_MEM_BANKS,  // Number of memory banks 
  parameter int unsigned          N_WORDS_BANK  = redmule_tile_pkg::N_WORDS_BANK, // Number of words per memory bank      

  // Parameters used by the core
  parameter cv32e40x_pkg::rv32_e  CORE_ISA      = cv32e40x_pkg::RV32I,            // RV32I (default) 32 registers in the RF - RV32E 16 registers in the RF
  parameter cv32e40x_pkg::a_ext_e CORE_A        = cv32e40x_pkg::A_NONE,           // Atomic Istruction (A) support (dafault: not enabled)
  parameter cv32e40x_pkg::b_ext_e CORE_B        = cv32e40x_pkg::B_NONE,           // Bit Manipulation support (dafault: not enabled)
  parameter cv32e40x_pkg::m_ext_e CORE_M        = cv32e40x_pkg::M,                // Multiply and Divide support (dafault: full support)

  // Parameters used by the iDMA
  parameter idma_pkg::error_cap_e ERROR_CAP     = idma_pkg::NO_ERROR_HANDLING     // Error handaling capability of the iDMA
)(
  input  logic                                    clk_i,
  input  logic                                    rst_ni,
  input  logic                                    test_mode_i,
  input  logic                                    tile_enable_i,

  output redmule_mesh_pkg::axi_default_req_t      data_out_req_o,
  input  redmule_mesh_pkg::axi_default_rsp_t      data_out_rsp_i,

  // Signals used by the core
  input  logic                                    scan_cg_en_i,

  input  logic[31:0]                              boot_addr_i,
  input  logic[31:0]                              mtvec_addr_i,
  input  logic[31:0]                              dm_halt_addr_i,
  input  logic[31:0]                              dm_exception_addr_i,
  input  logic[31:0]                              mhartid_i,
  input  logic[ 3:0]                              mimpid_patch_i,

  output logic[63:0]                              mcycle_o,
  input  logic[63:0]                              time_i,

  input  logic[redmule_tile_pkg::N_IRQ-1:0]       irq_i,
  
  output logic                                    fencei_flush_req_o,
  input  logic                                    fencei_flush_ack_i,

  input  logic                                    debug_req_i,
  output logic                                    debug_havereset_o,
  output logic                                    debug_running_o,
  output logic                                    debug_halted_o,
  output logic                                    debug_pc_valid_o,
  output logic[31:0]                              debug_pc_o,

  input  logic                                    fetch_enable_i,
  output logic                                    core_sleep_o,
  input  logic                                    wu_wfe_i
);

/*******************************************************/
/**       Internal Signal Definitions Beginning       **/
/*******************************************************/

  redmule_tile_pkg::redmule_data_req_t redmule_data_req;
  redmule_tile_pkg::redmule_data_rsp_t redmule_data_rsp;

  redmule_tile_pkg::redmule_ctrl_req_t redmule_ctrl_req;  //TODO: figure out what to do with RedMulE control
  redmule_tile_pkg::redmule_ctrl_rsp_t redmule_ctrl_rsp;  //TODO: figure out what to do with RedMulE control

  redmule_tile_pkg::core_data_req_t core_data_req;
  redmule_tile_pkg::core_data_rsp_t core_data_rsp;

  redmule_tile_pkg::core_obi_data_req_t core_obi_data_req;
  redmule_tile_pkg::core_obi_data_rsp_t core_obi_data_rsp;

  redmule_tile_pkg::core_obi_data_req_t[redmule_tile_pkg::N_SBR-1:0] core_mem_data_req; // Index 0 -> L2, Index 1 -> L1SPM
  redmule_tile_pkg::core_obi_data_rsp_t[redmule_tile_pkg::N_SBR-1:0] core_mem_data_rsp; // Index 0 -> L2, Index 1 -> L1SPM

  redmule_tile_pkg::core_hci_data_req_t core_l1_data_req;
  redmule_tile_pkg::core_hci_data_rsp_t core_l1_data_rsp;

  redmule_tile_pkg::core_axi_data_req_t core_l2_data_req;
  redmule_tile_pkg::core_axi_data_rsp_t core_l2_data_rsp;

  redmule_tile_pkg::core_instr_req_t core_instr_req;
  redmule_tile_pkg::core_instr_rsp_t core_instr_rsp;

  redmule_tile_pkg::core_cache_instr_req_t core_cache_instr_req;
  redmule_tile_pkg::core_cache_instr_rsp_t core_cache_instr_rsp;

  redmule_tile_pkg::axi_default_req_t core_l2_instr_req;
  redmule_tile_pkg::axi_default_rsp_t core_l2_instr_rsp;

  redmule_tile_pkg::core_axi_instr_req_t core_cache_instr_req;
  redmule_tile_pkg::core_axi_instr_rsp_t core_cache_instr_rsp;

  redmule_tile_pkg::idma_axi_req_t idma_axi_read_req;
  redmule_tile_pkg::idma_axi_rsp_t idma_axi_read_rsp;

  redmule_tile_pkg::idma_axi_req_t idma_axi_write_req;
  redmule_tile_pkg::idma_axi_rsp_t idma_axi_write_rsp;
  
  redmule_tile_pkg::idma_axi_req_t idma_axi_req;
  redmule_tile_pkg::idma_axi_rsp_t idma_axi_rsp;

  redmule_tile_pkg::idma_obi_req_t idma_obi_read_req;
  redmule_tile_pkg::idma_obi_rsp_t idma_obi_read_rsp;

  redmule_tile_pkg::idma_obi_req_t idma_obi_write_req;
  redmule_tile_pkg::idma_obi_rsp_t idma_obi_write_rsp;

  redmule_tile_pkg::idma_hci_req_t idma_hci_read_req;
  redmule_tile_pkg::idma_hci_rsp_t idma_hci_read_rsp;

  redmule_tile_pkg::idma_hci_req_t idma_hci_write_req;
  redmule_tile_pkg::idma_hci_rsp_t idma_hci_write_rsp;

  redmule_tile_pkg::axi_xbar_slv_req_t[redmule_tile_pkg::AxiXbarNoSlvPorts-1:0] axi_xbar_data_in_req; // Index 2 -> iDMA, Index 1 -> Core Data, Index 0 -> Core Instruction
  redmule_tile_pkg::axi_xbar_slv_rsp_t[redmule_tile_pkg::AxiXbarNoSlvPorts-1:0] axi_xbar_data_in_rsp; // Index 2 -> iDMA, Index 1 -> Core Data, Index 0 -> Core Instruction
  
  redmule_mesh_pkg::axi_xbar_mst_req_t axi_xbar_data_out_req;
  redmule_mesh_pkg::axi_xbar_mst_rsp_t axi_xbar_data_out_rsp;
  
  logic                                hci_clear; //TODO: figure out who should clear the hci
  hci_package::hci_interconnect_ctrl_t hci_ctrl;  //TODO: figure out who should control the hci

  redmule_tile_pkg::obi_xbar_rule_t[redmule_tile_pkg::N_ADDR_RULE-1:0] obi_xbar_rule;
  
  logic[redmule_tile_pkg::N_MGR-1:0]                                  obi_xbar_en_default_idx;
  logic[redmule_tile_pkg::N_MGR-1:0][redmule_tile_pkg::N_BIT_SBR-1:0] obi_xbar_default_idx;

  logic[redmule_tile_pkg::AXI_DATA_U_W-1:0]                   axi_data_user;
  logic[obi_pkg::ObiDefaultConfig.OptionalCfg.RUserWidth-1:0] obi_rsp_data_user;

  logic[redmule_tile_pkg::AXI_INSTR_U_W-1:0]                  axi_instr_user;
  logic[obi_pkg::ObiDefaultConfig.OptionalCfg.RUserWidth-1:0] obi_rsp_instr_user;

  logic idma_clear;         //TODO: figure out who should clear the iDMA
  logic idma_axi2obi_start;
  logic idma_axi2obi_busy;
  logic idma_axi2obi_done;
  logic idma_axi2obi_error;
  logic idma_obi2axi_start;
  logic idma_obi2axi_busy;
  logic idma_obi2axi_done;
  logic idma_obi2axi_error;

  redmule_tile_pkg::xif_inst_rule_t[redmule_tile_pkg::N_COPROC-1:0] xif_coproc_rules;
  
  logic sys_clk;
  logic sys_clk_en;

  logic[redmule_tile_pkg::N_IRQ-1:0]       irq;
  logic                                    redmule_busy;
  logic[redmule_tile_pkg::N_CORE-1:0][1:0] redmule_evt;

/*******************************************************/
/**          Internal Signal Definitions End          **/
/*******************************************************/
/**            Hardwired Signals Beginning            **/
/*******************************************************/

  assign obi_xbar_rule[redmule_tile_pkg::L2_IDX]    = '{idx: 32'd0, start_addr: redmule_tile_pkg::L2_ADDR_START, end_addr: redmule_tile_pkg::L2_ADDR_END};
  assign obi_xbar_rule[redmule_tile_pkg::L1SPM_IDX] = '{idx: 32'd1, start_addr: redmule_tile_pkg::L1_ADDR_START, end_addr: redmule_tile_pkg::L1_ADDR_END};
  
  assign obi_xbar_en_default_idx = '0;
  assign obi_xbar_default_idx    = '0;

  assign data_out_req_o        = axi_xbar_data_out_req;
  assign axi_xbar_data_out_rsp = data_out_rsp_i;

  assign axi_xbar_data_in_req[redmule_tile_pkg::AXI_IDMA_IDX]       = idma_axi_req;
  assign idma_axi_rsp                                               = axi_xbar_data_in_rsp[redmule_tile_pkg::AXI_IDMA_IDX];
  assign axi_xbar_data_in_req[redmule_tile_pkg::AXI_CORE_DATA_IDX]  = core_l2_data_req;
  assign core_l2_data_rsp                                           = axi_xbar_data_in_rsp[redmule_tile_pkg::AXI_CORE_DATA_IDX];
  assign axi_xbar_data_in_req[redmule_tile_pkg::AXI_CORE_INSTR_IDX] = core_l2_instr_req;
  assign core_l2_instr_rsp                                          = axi_xbar_data_in_rsp[redmule_tile_pkg::AXI_CORE_INSTR_IDX];

  assign axi_data_user     = '0;
  assign obi_rsp_data_user = '0;

  assign axi_instr_user     = '0;
  assign obi_rsp_instr_user = '0;

  assign hci_clear = 1'b0;  //TODO: Figure out how to manage these signals
  assign hci_ctrl  = '0;    //TODO: Figure out how to manage these signals

  assign redmule_ctrl_req = '0; //TODO: Figure out how to manage control

  assign idma_clear = 1'b0;  //TODO: Figure out how to manage the iDMA clear

  assign xif_coproc_rules[redmule_tile_pkg::XIF_REDMULE_IDX] = '{opcode_list: {{redmule_pkg::MCNFIG}, {redmule_pkg::MARITH}}};
  assign xif_coproc_rules[redmule_tile_pkg::XIF_IDMA_IDX]    = '{opcode_list: {{redmule_tile_pkg::CONF_OPCODE}, {redmule_tile_pkg::SET_OPCODE}}};

  assign irq[IRQ_IDX_REDMULE_EVT_0] = redmule_evt[0][0];  // Only 1 core supported
  assign irq[IRQ_IDX_REDMULE_EVT_1] = redmule_evt[0][1];  // Only 1 core supported
  assign irq[IRQ_IDX_A2O_ERROR]     = idma_axi2obi_error;
  assign irq[IRQ_IDX_O2A_ERROR]     = idma_obi2axi_error;
  assign irq[IRQ_IDX_A2O_DONE]      = idma_axi2obi_done;
  assign irq[IRQ_IDX_O2A_DONE]      = idma_obi2axi_done;
  assign irq[IRQ_IDX_A2O_START]     = idma_axi2obi_start;
  assign irq[IRQ_IDX_O2A_START]     = idma_obi2axi_start;
  assign irq[IRQ_IDX_A2O_BUSY]      = idma_axi2obi_busy;
  assign irq[IRQ_IDX_O2A_BUSY]      = idma_obi2axi_busy;
  assign irq[IRQ_IDX_REDMULE_BUSY]  = redmule_busy;
  assign irq[N_IRQ-IRQ_USED-1:16]   = irq_i[N_IRQ-IRQ_USED-1:16];
  assign irq[15:12]                 = '0;
  assign irq[11]                    = irq_i[11];
  assign irq[10:8]                  = '0;
  assign irq[7]                     = irq_i[7];
  assign irq[6:4]                   = '0;
  assign irq[3]                     = irq_i[3];
  assign irq[2:0]                   = '0;

/*******************************************************/
/**               Hardwired Signals End               **/
/*******************************************************/
/**             Type Conversions Beginning            **/
/*******************************************************/

  data2obi_req i_core_data2obi_req (
    .data_req_i ( core_data_req     ),
    .obi_req_o  ( core_obi_data_req )
  );

  obi2data_rsp i_core_obi2data_rsp (
    .obi_rsp_i  ( core_obi_data_rsp ),
    .data_rsp_o ( core_data_rsp     )
  );
  
  obi2hci_req #(
    .obi_req_t ( redmule_tile_pkg::core_obi_data_req_t ),
    .hic_req_t ( redmule_tile_pkg::core_hci_data_req_t )
  ) i_core_data_obi2hci_req (
    .obi_req_i ( core_mem_data_req[redmule_tile_pkg::L1SPM_IDX] ),
    .hci_req_o ( core_l1_data_req                               )
  );

  hci2obi_rsp #(
    .hci_rsp_t ( redmule_tile_pkg::core_hci_data_rsp_t ),
    .obi_rsp_t ( redmule_tile_pkg::core_obi_data_rsp_t )
  ) i_core_data_hci2obi_rsp (
    .hci_rsp_i ( core_l1_data_rsp                               ),
    .obi_rsp_o ( core_mem_data_rsp[redmule_tile_pkg::L1SPM_IDX] )
  );

  obi_to_axi #(
    .ObiCfg       (                                       ),
    .obi_req_t    ( redmule_tile_pkg::core_obi_data_req_t ),
    .obi_rsp_t    ( redmule_tile_pkg::core_obi_data_rsp_t ),
    .AxiLite      (                                       ),
    .AxiAddrWidth ( redmule_tile_pkg::ADDR_W              ),
    .AxiDataWidth ( redmule_tile_pkg::DATA_W              ),
    .AxiUserWidth ( redmule_tile_pkg::AXI_DATA_U_W        ),
    .AxiBurstType (                                       ),
    .axi_req_t    ( redmule_tile_pkg::core_axi_data_req_t ),
    .axi_rsp_t    ( redmule_tile_pkg::core_axi_data_rsp_t ),
    .MaxRequests  ( 1                                     )
  ) i_core_data_obi2axi (
    .clk_i               ( sys_clk                                     ),
    .rst_ni              ( rst_ni                                      ),
    .obi_req_i           ( core_mem_data_req[redmule_tile_pkg::L2_IDX] ),
    .obi_rsp_o           ( core_mem_data_rsp[redmule_tile_pkg::L2_IDX] ),
    .user_i              ( axi_data_user                               ),
    .axi_req_o           ( core_l2_data_req                            ),
    .axi_rsp_i           ( core_l2_data_rsp                            ),
    .axi_rsp_channel_sel (                                             ),
    .axi_rsp_b_user_o    (                                             ),
    .axi_rsp_r_user_o    (                                             ),
    .obi_rsp_user_i      ( obi_rsp_data_user                           )
  );

  instr2cache_req i_core_instr2cache_req (
    .instr_req_i ( core_instr_req       ),
    .cache_req_o ( core_cache_instr_req )
  );

  cache2instr_rsp i_core_cache2instr_rsp (
    .cache_rsp_i ( core_cache_instr_rsp ),
    .instr_rsp_o ( core_instr_rsp       )
  );

  obi2hci_req #(
    .obi_req_t ( redmule_tile_pkg::idma_obi_req_t ),
    .hic_req_t ( redmule_tile_pkg::idma_hci_req_t )
  ) i_idma_obi2hci_req (
    .obi_req_i ( idma_obi_read_req ),
    .hci_req_o ( idma_hci_read_req )
  );

  hci2obi_rsp #(
    .hci_rsp_t ( redmule_tile_pkg::idma_hci_rsp_t ),
    .obi_rsp_t ( redmule_tile_pkg::idma_obi_rsp_t )
  ) i_idma_hci2obi_rsp (
    .hci_rsp_i ( idma_hci_read_rsp ),
    .obi_rsp_o ( idma_obi_read_rsp )
  );

  obi2hci_req #(
    .obi_req_t ( redmule_tile_pkg::idma_obi_req_t ),
    .hic_req_t ( redmule_tile_pkg::idma_hci_req_t )
  ) i_idma_obi2hci_write_req (
    .obi_req_i ( idma_obi_write_req ),
    .hci_req_o ( idma_hci_write_req )
  );

  hci2obi_rsp #(
    .hci_rsp_t ( redmule_tile_pkg::idma_hci_rsp_t ),
    .obi_rsp_t ( redmule_tile_pkg::idma_obi_rsp_t )
  ) i_idma_hci2obi_write_rsp (
    .hci_rsp_i ( idma_hci_write_rsp ),
    .obi_rsp_o ( idma_obi_write_rsp )
  );

/*******************************************************/
/**                Type Conversions End               **/
/*******************************************************/
/**               Clock gating Beginning              **/
/*******************************************************/

  always_ff @(posedge clk_i, negedge rst_ni) begin: sys_clk_en_ff
    if (~rst_ni) sys_clk_en <= 1'b0;
    else         sys_clk_en <= tile_enable_i;
  end

  tc_clk_gating sys_clock_gating (
    .clk_i                    ,
    .en_i      ( sys_clk_en  ),
    .test_en_i ( test_mode_i ),
    .clk_o     ( sys_clk     )
  );

/*******************************************************/
/**                  Clock gating End                 **/
/*******************************************************/
/**           Interface Definitions Beginning         **/
/*******************************************************/

  hci_mem_intf #(
    .AW ( redmule_tile_pkg::ADDR_W ),
    .DW ( redmule_tile_pkg::DW_LIC ),
    .BW ( redmule_tile_pkg::BW_LIC ),
    .IW ( redmule_tile_pkg::IW     ),
    .UW ( redmule_tile_pkg::UW_LIC )
  ) hci_tcdm_sram_if[N_MEM_BANKS-1:0] (
    .clk ( sys_clk )
  );
  
  hci_core_intf #(
    .DW ( redmule_tile_pkg::ADDR_W ),
    .AW ( redmule_tile_pkg::AWC    ),
    .OW ( redmule_tile_pkg::AWC    ),
    .UW ( redmule_tile_pkg::UWH    )
  ) hci_core_if[redmule_tile_pkg::N_CORE-1:0] (
    .clk( sys_clk )
  );

  hci_core_intf #(
    .DW ( redmule_tile_pkg::REDMULE_DW ),
    .AW ( redmule_tile_pkg::AWC        ),
    .OW ( redmule_tile_pkg::AWC        ),
    .UW ( redmule_tile_pkg::UWH        )
  ) hci_redmule_if[redmule_tile_pkg::N_HWPE-1:0] (
    .clk( sys_clk )
  );

  hci_core_intf #(
    .DW ( redmule_tile_pkg::ADDR_W ),
    .AW ( redmule_tile_pkg::AWC    ),
    .OW ( redmule_tile_pkg::AWC    ),
    .UW ( redmule_tile_pkg::UWH    )
  ) hci_dma_if[redmule_tile_pkg::N_DMA-1:0] (
    .clk( sys_clk )
  );

  hci_core_intf #(
    .DW ( redmule_tile_pkg::ADDR_W ),
    .AW ( redmule_tile_pkg::AWC    ),
    .OW ( redmule_tile_pkg::AWC    ),
    .UW ( redmule_tile_pkg::UWH    )
  ) hci_ext_if[redmule_tile_pkg::N_EXT-1:0] (
    .clk( sys_clk )
  );

  cv32e40x_if_xif #(
    .X_NUM_RS    ( redmule_tile_pkg::X_NUM_RS ),
    .X_ID_WIDTH  ( redmule_tile_pkg::X_ID_W   ),
    .X_MEM_WIDTH ( redmule_tile_pkg::X_MEM_W  ),
    .X_RFR_WIDTH ( redmule_tile_pkg::X_RFR_W  ),
    .X_RFW_WIDTH ( redmule_tile_pkg::X_RFW_W  ),
    .X_MISA      ( redmule_tile_pkg::X_MISA   ),
    .X_ECS_XS    ( redmule_tile_pkg::X_ECS_XS )
  ) xif_if ();

  cv32e40x_if_xif #(
    .X_NUM_RS    ( redmule_tile_pkg::X_NUM_RS ),
    .X_ID_WIDTH  ( redmule_tile_pkg::X_ID_W   ),
    .X_MEM_WIDTH ( redmule_tile_pkg::X_MEM_W  ),
    .X_RFR_WIDTH ( redmule_tile_pkg::X_RFR_W  ),
    .X_RFW_WIDTH ( redmule_tile_pkg::X_RFW_W  ),
    .X_MISA      ( redmule_tile_pkg::X_MISA   ),
    .X_ECS_XS    ( redmule_tile_pkg::X_ECS_XS )
  ) xif_coproc_if[redmule_tile_pkg::N_COPROC] (); // Index 0 -> RedMulE, Index 1 -> iDMA

/*******************************************************/
/**             Interface Definitions End             **/
/*******************************************************/
/**          Interface Assignments Beginning          **/
/*******************************************************/

  `HCI_ASSIGN_TO_INTF(hci_core_if[0],                                     core_l1_data_req,   core_l1_data_rsp)   // Only 1 core supported
  `HCI_ASSIGN_TO_INTF(hci_redmule_if[0],                                  redmule_data_req,   redmule_data_rsp)   // Only 1 RedMulE supported
  `HCI_ASSIGN_TO_INTF(hci_dma_if[redmule_tile_pkg::HCI_DMA_CH_READ_IDX],  idma_hci_read_req,  idma_hci_read_rsp)  // iDMA HCI read channel
  `HCI_ASSIGN_TO_INTF(hci_dma_if[redmule_tile_pkg::HCI_DMA_CH_WRITE_IDX], idma_hci_write_req, idma_hci_write_rsp) // iDMA HCI write channel

/*******************************************************/
/**             Interface Assignments End             **/
/*******************************************************/
/**                 RedMulE Beginning                 **/
/*******************************************************/

  redmule_top #(
    .ID_WIDTH           ( redmule_tile_pkg::REDMULE_ID_W       ),
    .N_CORES            ( redmule_tile_pkg::N_CORE             ),
    .DW                 ( redmule_tile_pkg::REDMULE_DW         ),
    .UW                 ( redmule_tile_pkg::REDMULE_UW         ),
    .X_EXT              ( redmule_tile_pkg::X_EXT_EN           ),
    .SysInstWidth       ( redmule_tile_pkg::INSTR_W            ),
    .SysDataWidth       ( redmule_tile_pkg::DATA_W             ),
    .redmule_data_req_t ( redmule_tile_pkg::redmule_data_req_t ),
    .redmule_data_rsp_t ( redmule_tile_pkg::redmule_data_rsp_t ),
    .redmule_ctrl_req_t ( redmule_tile_pkg::redmule_ctrl_req_t ),
    .redmule_ctrl_rsp_t ( redmule_tile_pkg::redmule_ctrl_rsp_t )
  ) i_redmule_top (
    .clk_i               ( sys_clk                                                       ),
    .rst_ni              ( rst_ni                                                        ),
    .test_mode_i                                                                          ,

    .busy_o              ( redmule_busy                                                  ),
    .evt_o               ( redmule_evt                                                   ),

    .xif_issue_if_i      ( xif_coproc_if.coproc_issue[redmule_tile_pkg::XIF_REDMULE_IDX] ),
    .xif_result_if_o     ( xif_if.coproc_result                                          ),
    .xif_compressed_if_i ( xif_if.coproc_compressed                                      ),
    .xif_mem_if_o        ( xif_if.coproc_mem                                             ),

    .data_req_o          ( redmule_data_req                                              ),
    .data_rsp_i          ( redmule_data_rsp                                              ),

    .ctrl_req_i          ( redmule_ctrl_req                                              ),
    .ctrl_rsp_o          ( redmule_ctrl_rsp                                              )
  );

/*******************************************************/
/**                    RedMulE End                    **/
/*******************************************************/
/**                   Core Beginning                  **/
/*******************************************************/

  // Documentation of cv32e40x_core's design parameters and interface is available at:
  // https://docs.openhwgroup.org/projects/cv32e40x-user-manual/en/latest/integration.html#core-integration

`ifndef CORE_TRACES
  cv32e40x_core #(
`else
  cv32e40x_wrapper #(
`endif
    .RV32             ( CORE_ISA                          ),
    .A_EXT            ( CORE_A                            ),
    .B_EXT            ( CORE_B                            ),
    .M_EXT            ( CORE_M                            ),
    .X_EXT            ( redmule_tile_pkg::X_EXT_EN        ),    // Support for eXtension Interface (X) 
    .X_NUM_RS         ( redmule_tile_pkg::X_NUM_RS        ),    // RF read ports that can be used by the eXtension interface
    .X_ID_WIDTH       ( redmule_tile_pkg::X_ID_W          ),    // ID width of eXtension interface
    .X_MEM_WIDTH      ( redmule_tile_pkg::X_MEM_W         ),    // MEM width for loads/stores of eXtension interface
    .X_RFR_WIDTH      ( redmule_tile_pkg::X_RFR_W         ),    // RF read width of eXtension interface
    .X_RFW_WIDTH      ( redmule_tile_pkg::X_RFW_W         ),    // RF write width of eXtension interface
    .X_MISA           ( redmule_tile_pkg::X_MISA          ),    // MISA extensions implemented on the eXtension interface
    .X_ECS_XS         ( redmule_tile_pkg::X_ECS_XS        ),    // Default value for mstatus.XS if X_EXT = 1
    .NUM_MHPMCOUNTERS ( 1                                 ),    // 1 MHPMCOUNTER performance counter
    .DEBUG            ( 1                                 ),    // Enable debug support
    .DM_REGION_START  ( redmule_tile_pkg::DM_REGION_START ),    // Start address of Debug Module region
    .DM_REGION_END    ( redmule_tile_pkg::DM_REGION_END   ),    // End address of Debug Module region
    .DBG_NUM_TRIGGERS ( 1                                 ),    // 1 debug trigger
    .PMA_NUM_REGIONS  ( 0                                 ),    // No PMA (Physical Memory Attribution) regions 
    .PMA_CFG          (                                   ),    // No array of PMA configurations
    .CLIC             ( redmule_tile_pkg::CLIC_EN         ),    // Support for Smclic, Smclicshv and Smclicconfig
    .CLIC_ID_WIDTH    ( redmule_tile_pkg::CLIC_ID_W       )     // Width of clic_irq_id_i and clic_irq_id_o
  ) i_cv32e40x_core (
    // Clock and reset
    .clk_i               ( sys_clk                  ),
    .rst_ni              ( rst_ni                   ),
    .scan_cg_en_i                                    ,

    // Configuration
    .boot_addr_i                                     ,  //TODO: instead of exposing these outside the tile, manage them with a configuration ROM/RAM?
    .mtvec_addr_i                                    ,  //TODO: instead of exposing these outside the tile, manage them with a configuration ROM/RAM?
    .dm_halt_addr_i                                  ,  //TODO: instead of exposing these outside the tile, manage them with a configuration ROM/RAM?
    .dm_exception_addr_i                             ,  //TODO: instead of exposing these outside the tile, manage them with a configuration ROM/RAM?
    .mhartid_i                                       ,  //TODO: instead of exposing these outside the tile, manage them with a configuration ROM/RAM?
    .mimpid_patch_i                                  ,  //TODO: instead of exposing these outside the tile, manage them with a configuration ROM/RAM?

    // Instruction memory interface
    .instr_req_o         ( core_instr_req.req     ),
    .instr_gnt_i         ( core_instr_rsp.gnt     ),
    .instr_addr_o        ( core_instr_req.addr    ),
    .instr_memtype_o     ( core_instr_req.memtype ),
    .instr_prot_o        ( core_instr_req.prot    ),
    .instr_dbg_o         ( core_instr_req.dbg     ),
    .instr_rvalid_i      ( core_instr_rsp.rvalid  ),
    .instr_rdata_i       ( core_instr_rsp.rdata   ),
    .instr_err_i         ( core_instr_rsp.err     ),

    // Data memory interface
    .data_req_o          ( core_data_req.req     ),
    .data_gnt_i          ( core_data_rsp.gnt     ),
    .data_addr_o         ( core_data_req.addr    ),
    .data_atop_o         ( core_data_req.atop    ),
    .data_be_o           ( core_data_req.be      ),
    .data_memtype_o      ( core_data_req.memtype ),
    .data_prot_o         ( core_data_req.prot    ),
    .data_dbg_o          ( core_data_req.dbg     ),
    .data_wdata_o        ( core_data_req.wdata   ),
    .data_we_o           ( core_data_req.we      ),
    .data_rvalid_i       ( core_data_rsp.rvalid  ),
    .data_rdata_i        ( core_data_rsp.rdata   ),
    .data_err_i          ( core_data_rsp.err     ),
    .data_exokay_i       ( core_data_rsp.exokay  ),

    // Cycle, Time
    .mcycle_o                                        ,  //TODO: do we need these or can we hardwire them?
    .time_i                                          ,  //TODO: do we need these or can we hardwire them?

    // eXtension interface
    .xif_compressed_if   ( xif_if.cpu_compressed    ),
    .xif_issue_if        ( xif_if.cpu_issue         ),
    .xif_commit_if       ( xif_if.cpu_commit        ),
    .xif_mem_if          ( xif_if.cpu_mem           ),
    .xif_mem_result_if   ( xif_if.cpu_mem_result    ),
    .xif_result_if       ( xif_if.cpu_result        ),

     // Interrupt interface
    .irq_i               ( irq                      ),

    .clic_irq_i          ( '0                       ),
    .clic_irq_id_i       ( '0                       ),
    .clic_irq_level_i    ( '0                       ),
    .clic_irq_priv_i     ( '0                       ),
    .clic_irq_shv_i      ( '0                       ),

    // Fencei flush handshake
    .fencei_flush_req_o                              ,  //TODO: manage Fence.i flushing in the future or hardwire?  
    .fencei_flush_ack_i                              ,  //TODO: manage Fence.i flushing in the future or hardwire?

    // Debug interface
    .debug_req_i                                     ,  //TODO: do we need these or can we hardwire them?
    .debug_havereset_o                               ,  //TODO: do we need these or can we hardwire them?
    .debug_running_o                                 ,  //TODO: do we need these or can we hardwire them?
    .debug_halted_o                                  ,  //TODO: do we need these or can we hardwire them?
    .debug_pc_valid_o                                ,  //TODO: do we need these or can we hardwire them?
    .debug_pc_o                                      ,  //TODO: do we need these or can we hardwire them?

    // Special control signals
    .fetch_enable_i                                  ,
    .core_sleep_o                                    ,
    .wu_wfe_i            
  );

/*******************************************************/
/**                      Core End                     **/
/*******************************************************/
/**      Core Data Demuxing (OBI XBAR) Beginning      **/
/*******************************************************/

  obi_demux_addr #(
    .SbrPortObiCfg      (                                          ),
    .MgrPortObiCfg      (                                          ),
    .sbr_port_obi_req_t ( redmule_tile_pkg::core_obi_data_req_t    ),
    .sbr_port_obi_rsp_t ( redmule_tile_pkg::core_obi_data_rsp_t    ),
    .mgr_port_obi_req_t (                                          ),
    .mgr_port_obi_rsp_t (                                          ),
    .NumMgrPorts        ( redmule_tile_pkg::N_SBR                  ),
    .NumMaxTrans        ( redmule_tile_pkg::N_MAX_TRAN             ),
    .NumAddrRules       ( redmule_tile_pkg::N_ADDR_RULE            ),
    .addr_map_rule_t    ( redmule_tile_pkg::obi_xbar_rule_t        )
  ) i_obi_xbar (
    .clk_i            ( sys_clk                 ),
    .rst_ni           ( rst_ni                  ),

    .sbr_ports_req_i  ( core_obi_data_req       ),
    .sbr_ports_rsp_o  ( core_obi_data_rsp       ),

    .mgr_ports_req_o  ( core_mem_data_req       ),
    .mgr_ports_rsp_i  ( core_mem_data_rsp       ),

    .addr_map_i       ( obi_xbar_rule           ),
    .en_default_idx_i ( obi_xbar_en_default_idx ),
    .default_idx_i    ( obi_xbar_default_idx    )
  );

/*******************************************************/
/**         Core Data Demuxing (OBI XBAR) End         **/
/*******************************************************/
/**         Local Interconnect (HCI) Beginning        **/
/*******************************************************/

  hci_interconnect #(
    .N_HWPE  ( redmule_tile_pkg::N_HWPE  ),
    .N_CORE  ( redmule_tile_pkg::N_CORE  ),
    .N_DMA   ( redmule_tile_pkg::N_DMA   ),
    .N_EXT   ( redmule_tile_pkg::N_EXT   ),
    .N_MEM   ( N_MEM_BANKS               ),
    .AWC     ( redmule_tile_pkg::AWC     ),
    .AWM     ( redmule_tile_pkg::AWM     ),
    .DW_LIC  ( redmule_tile_pkg::DW_LIC  ),
    .BW_LIC  ( redmule_tile_pkg::BW_LIC  ),
    .UW_LIC  ( redmule_tile_pkg::UW_LIC  ),
    .DW_SIC  (                           ),
    .TS_BIT  ( redmule_tile_pkg::TS_BIT  ),
    .IW      ( redmule_tile_pkg::IW      ),
    .EXPFIFO ( redmule_tile_pkg::EXPFIFO ),
    .DWH     ( redmule_tile_pkg::DWH     ),
    .AWH     ( redmule_tile_pkg::AWH     ),
    .BWH     ( redmule_tile_pkg::BWH     ),
    .WWH     ( redmule_tile_pkg::WWH     ),
    .OWH     ( redmule_tile_pkg::OWH     ),
    .UWH     ( redmule_tile_pkg::UWH     ),
    .SEL_LIC ( redmule_tile_pkg::SEL_LIC )
  ) i_local_interconnect (
    .clk_i   ( sys_clk           ),
    .rst_ni  ( rst_ni            ),
    .clear_i ( hci_clear         ),

    .ctrl_i  ( hci_ctrl          ),
    
    .cores   ( hci_core_if       ),
    .dma     ( hci_dma_if        ),
    .ext     ( hci_ext_if        ),
    .mems    ( hci_tcdm_sram_if  ),
    .hwpe    ( hci_redmule_if[0] )
  );

/*******************************************************/
/**            Local Interconnect (HCI) End           **/
/*******************************************************/
/**              L1 SPM (TCDM) Beginning              **/
/*******************************************************/

  l1_spm #(
    .N_BANK   ( N_MEM_BANKS              ),
    .N_WORDS  ( N_WORDS_BANK             ),
    .DATA_W   ( redmule_tile_pkg::DW_LIC ),
    .ID_W     ( redmule_tile_pkg::IW     ),
    .SIM_INIT ( "zeros"                  )
  ) i_l1_spm (
    .clk_i      ( sys_clk          ),
    .rst_ni     ( rst_ni           ),

    .tcdm_slave ( hci_tcdm_sram_if )
  );

/*******************************************************/
/**                 L1 SPM (TCDM) End                 **/
/*******************************************************/
/**                Xif DEMUX Beginning                **/
/*******************************************************/

  xif_inst_demux #(
    .N_COPROC        ( redmule_tile_pkg::N_COPROC        ),
    .DEFAULT_IDX     ( redmule_tile_pkg::DEFAULT_IDX     ),
    .OPCODE_OFF      ( redmule_tile_pkg::DMA_OPCODE_OFF  ),
    .OPCODE_W        ( redmule_tile_pkg::DMA_OPCODE_W    ),
    .xif_inst_rule_t ( redmule_tile_pkg::xif_inst_rule_t )
  ) i_xif_inst_demux (
    .xif_issue_if_i ( xif_if.coproc_issue     ),
    .xif_issue_if_o ( xif_coproc_if.cpu_issue ),
    .rules_i        ( xif_coproc_rules        )
  );

/*******************************************************/
/**                   Xif DEMUX End                   **/
/*******************************************************/
/**                   iDMA Beginning                  **/
/*******************************************************/

  idma_ctrl #(
    .ERROR_CAP ( ERROR_CAP                        ),
    .axi_req_t ( redmule_tile_pkg::idma_axi_req_t ),
    .axi_rsp_t ( redmule_tile_pkg::idma_axi_rsp_t ),
    .obi_req_t ( redmule_tile_pkg::idma_obi_req_t ),
    .obi_rsp_t ( redmule_tile_pkg::idma_obi_rsp_t )
  ) i_idma_ctrl (
    .clk_i           ( sys_clk                                                    ),
    .rst_ni          ( rst_ni                                                     ),
    .testmode_i      ( test_mode_i                                                ),
    .clear_i         ( idma_clear                                                 ),

    .xif_issue_if_i  ( xif_coproc_if.coproc_issue[redmule_tile_pkg::XIF_IDMA_IDX] ),

    .axi_read_req_o  ( idma_axi_read_req                                          ),
    .axi_read_rsp_i  ( idma_axi_read_rsp                                          ),

    .axi_write_req_o ( idma_axi_write_req                                         ),
    .axi_write_rsp_i ( idma_axi_write_rsp                                         ),

    .obi_read_req_o  ( idma_obi_read_req                                          ),
    .obi_read_rsp_i  ( idma_obi_read_rsp                                          ),

    .obi_write_req_o ( idma_obi_write_req                                         ),
    .obi_write_rsp_i ( idma_obi_write_rsp                                         ),

    .axi2obi_start_o ( idma_axi2obi_start                                         ),
    .axi2obi_busy_o  ( idma_axi2obi_busy                                          ),
    .axi2obi_done_o  ( idma_axi2obi_done                                          ),
    .axi2obi_error_o ( idma_axi2obi_error                                         ),

    .obi2axi_start_o ( idma_obi2axi_start                                         ),
    .obi2axi_busy_o  ( idma_obi2axi_busy                                          ),
    .obi2axi_done_o  ( idma_obi2axi_done                                          ),
    .obi2axi_error_o ( idma_obi2axi_error                                         )
  );

  axi_rw_join #(
    .axi_req_t  ( redmule_tile_pkg::idma_axi_req_t ),
    .axi_resp_t ( redmule_tile_pkg::idma_axi_rsp_t )
  ) i_axi_rw_join (
    .clk_i            ( sys_clk            ),
    .rst_ni           ( rst_ni             ),
    .slv_read_req_i   ( idma_axi_read_req  ),
    .slv_read_resp_o  ( idma_axi_read_rsp  ),
    .slv_write_req_i  ( idma_axi_write_req ),
    .slv_write_resp_o ( idma_axi_write_rsp ),
    .mst_req_o        ( idma_axi_req       ),
    .mst_resp_i       ( idma_axi_rsp       )
  );

/*******************************************************/
/**                      iDMA End                     **/
/*******************************************************/
/**                    i$ Beginning                   **/
/*******************************************************/

//TODO
  snitch_icache #(
  .NR_FETCH_PORTS      ( redmule_tile_pkg::NR_FETCH_PORTS      ),
  .L0_LINE_COUNT       ( redmule_tile_pkg::L0_LINE_COUNT       ),
  .LINE_WIDTH          ( redmule_tile_pkg::LINE_WIDTH          ),
  .LINE_COUNT          ( redmule_tile_pkg::LINE_COUNT          ),
  .SET_COUNT           ( redmule_tile_pkg::SET_COUNT           ),
  .FETCH_AW            ( redmule_tile_pkg::FETCH_AW            ),
  .FETCH_DW            ( redmule_tile_pkg::FETCH_DW            ),
  .FILL_AW             ( redmule_tile_pkg::FILL_AW             ),
  .FILL_DW             ( redmule_tile_pkg::FILL_DW             ),
  .FETCH_PRIORITY      ( redmule_tile_pkg::FETCH_PRIORITY      ),
  .MERGE_FETCHES       ( redmule_tile_pkg::MERGE_FETCHES       ),
  .SERIAL_LOOKUP       ( redmule_tile_pkg::SERIAL_LOOKUP       ),
  .L1_TAG_SCM          ( redmule_tile_pkg::L1_TAG_SCM          ),
  .NUM_AXI_OUTSTANDING ( redmule_tile_pkg::NUM_AXI_OUTSTANDING ),
  .EARLY_LATCH         ( redmule_tile_pkg::EARLY_LATCH         ),
  .L0_EARLY_TAG_WIDTH  ( redmule_tile_pkg::L0_EARLY_TAG_WIDTH  ),
  .ISO_CROSSING        ( redmule_tile_pkg::ISO_CROSSING        ),
  .sram_cfg_data_t     ( /* Not Used */                        ),
  .sram_cfg_tag_t      ( /* Not Used */                        ),
  .axi_req_t           ( redmule_mesh_pkg::axi_default_req_t   ),
  .axi_rsp_t           ( redmule_mesh_pkg::axi_default_rsp_t   )
  ) i_icache (
  .clk_i                ( sys_clk                        ),
  .clk_d2_i             ( sys_clk                        ),
  .rst_ni               ( rst_ni                         ),
  .enable_prefetching_i ( 1'b1                           ), //TODO: manage
  .icache_events_o      (                                ), //TODO: manage
  .flush_valid_i        ( 1'b0                           ), //TODO: manage
  .flush_ready_o        (                                ), //TODO: manage
  .inst_addr_i          ( core_cache_instr_req.addr      ),
  .inst_data_o          ( core_cache_instr_rsp.data      ),
  .inst_cacheable_i     ( core_cache_instr_req.cacheable ),
  .inst_valid_i         ( core_cache_instr_req.valid     ),
  .inst_ready_o         ( core_cache_instr_rsp.ready     ),
  .inst_error_o         ( core_cache_instr_rsp.error     ),
  .sram_cfg_data_i      ( '0                             ),
  .sram_cfg_tag_i       ( '0                             ),
  .axi_req_o            ( core_l2_instr_req              ),
  .axi_rsp_i            ( core_l2_instr_rsp              )
  );

/*******************************************************/
/**                       i$ End                      **/
/*******************************************************/
/**         Data Out - L2 (AXI XBAR) Beginning        **/
/*******************************************************/

  axi_mux #(
    .SlvAxiIDWidth ( redmule_tile_pkg::AxiXbarSlvAxiIDWidth   ),
    .slv_aw_chan_t ( redmule_tile_pkg::axi_xbar_slv_aw_chan_t ),
    .mst_aw_chan_t ( redmule_mesh_pkg::axi_xbar_mst_aw_chan_t ),
    .w_chan_t      ( redmule_mesh_pkg::axi_xbar_mst_w_chan_t  ),
    .slv_b_chan_t  ( redmule_tile_pkg::axi_xbar_slv_b_chan_t  ),
    .mst_b_chan_t  ( redmule_mesh_pkg::axi_xbar_mst_b_chan_t  ),
    .slv_ar_chan_t ( redmule_tile_pkg::axi_xbar_slv_ar_chan_t ),
    .mst_ar_chan_t ( redmule_mesh_pkg::axi_xbar_mst_ar_chan_t ),
    .slv_r_chan_t  ( redmule_tile_pkg::axi_xbar_slv_r_chan_t  ),
    .mst_r_chan_t  ( redmule_mesh_pkg::axi_xbar_mst_r_chan_t  ),
    .slv_req_t     ( redmule_tile_pkg::axi_xbar_slv_req_t     ),
    .slv_resp_t    ( redmule_tile_pkg::axi_xbar_slv_rsp_t     ),
    .mst_req_t     ( redmule_mesh_pkg::axi_xbar_mst_req_t     ),
    .mst_resp_t    ( redmule_mesh_pkg::axi_xbar_mst_rsp_t     ),
    .NoSlvPorts    ( redmule_tile_pkg::AxiXbarNoSlvPorts      ),
    .MaxWTrans     ( redmule_tile_pkg::AxiXbarMaxWTrans       ),
    .FallThrough   ( redmule_tile_pkg::AxiXbarFallThrough     ),
    .SpillAw       ( redmule_tile_pkg::AxiXbarSpillAw         ),
    .SpillW        ( redmule_tile_pkg::AxiXbarSpillW          ),
    .SpillB        ( redmule_tile_pkg::AxiXbarSpillB          ),
    .SpillAr       ( redmule_tile_pkg::AxiXbarSpillAr         ),
    .SpillR        ( redmule_tile_pkg::AxiXbarSpillR          )
  ) i_axi_xbar (
    .clk_i       ( sys_clk               ),
    .rst_ni      ( rst_ni                ),
    .test_i      ( test_mode_i           ),
    .slv_reqs_i  ( axi_xbar_data_in_req  ),
    .slv_resps_o ( axi_xbar_data_in_rsp  ),
    .mst_req_o   ( axi_xbar_data_out_req ),
    .mst_resp_i  ( axi_xbar_data_out_rsp )   
  );

/*******************************************************/
/**            Data Out - L2 (AXI XBAR) End           **/
/*******************************************************/

endmodule: redmule_tile
