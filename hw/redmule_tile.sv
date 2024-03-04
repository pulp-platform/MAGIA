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

module redemule_tile
  import redmule_tile_pkg::*;
  import hci_package::*;
  import cv32e40x_pkg::*;
#(
  // Parameters used by hci_interconnect and l1_spm
  parameter int unsigned          N_MEM_BANKS   = 16                   , // Number of memory banks 
  parameter int unsigned          N_WORDS_BANK  = 256                  , // Number of words per memory bank      

  // Parameters used by the core
  parameter cv32e40x_pkg::rv32_e  CORE_ISA      = cv32e40x_pkg::RV32I  , // RV32I (default) 32 registers in the RF - RV32E 16 registers in the RF
  parameter cv32e40x_pkg::a_ext_e CORE_A        = cv32e40x_pkg::A_NONE , // Atomic Istruction (A) support (dafault: not enabled)
  parameter cv32e40x_pkg::b_ext_e CORE_B        = cv32e40x_pkg::B_NONE , // Bit Manipulation support (dafault: not enabled)
  parameter cv32e40x_pkg::m_ext_e CORE_M        = cv32e40x_pkg::ZMMUL    // Multiply and Divide support (dafault: only Multiply upported)
)(
  input  logic                                     clk_i               ,
  input  logic                                     rstn_i              ,
  input  logic                                     test_mode_i         ,
  input  logic                                     tile_enable_i       ,
  //TODO: add tile data in/out channel(s)

  // Signals used by the core
  input  logic                                     scan_cg_en_i        ,

  input  logic [31:0]                              boot_addr_i         ,
  input  logic [31:0]                              mtvec_addr_i        ,
  input  logic [31:0]                              dm_halt_addr_i      ,
  input  logic [31:0]                              dm_exception_addr_i ,
  input  logic [31:0]                              mhartid_i           ,
  input  logic [ 3:0]                              mimpid_patch_i      ,

  output logic [63:0]                              mcycle_o            ,
  input  logic [63:0]                              time_i              ,

  input  logic [redmule_tile_pkg::N_IRQ-1:0]       irq_i               ,  //TODO: Add IRQ support: look also at redmule_complex
  
  output logic                                     fencei_flush_req_o  ,
  input  logic                                     fencei_flush_ack_i  ,

  input  logic                                     debug_req_i         ,
  output logic                                     debug_havereset_o   ,
  output logic                                     debug_running_o     ,
  output logic                                     debug_halted_o      ,
  output logic                                     debug_pc_valid_o    ,
  output logic                                     debug_pc_o          ,

  input  logic                                     fetch_enable_i      ,
  output logic                                     core_sleep_o        ,
  input  logic                                     wu_wfe_i            ,

  // Signals used by RedMulE
  output logic                                     busy_o              ,  //TODO: Manage backpressure
  output logic [redmule_tile_pkg::N_CORE-1:0][1:0] evt_o               ,  //TODO: Manage RedMulE event to Core IRQ mapping

  output redmule_tile_pkg::core_instr_req_t        core_instr_req_o    ,  //TODO: Remove, this should be managed internally by the AXI xbar
  input  redmule_tile_pkg::core_instr_rsp_t        core_instr_rsp_i    ,  //TODO: Remove, this should be managed internally by the AXI xbar

  output redmule_tile_pkg::core_data_req_t         core_data_req_o     ,  //TODO: Convert to AXI and add to the AXI xbar
  input  redmule_tile_pkg::core_data_rsp_t         core_data_rsp_i        //TODO: Convert to AXI and add to the AXI xbar
);

/*******************************************************/
/**        Internal Signal Definitions Beginning      **/
/*******************************************************/

  redmule_tile_pkg::redmule_data_req_t                                 redmule_data_req       ;
  redmule_tile_pkg::redmule_data_rsp_t                                 redmule_data_rsp       ;

  redmule_tile_pkg::redmule_ctrl_req_t                                 redmule_ctrl_req       ;  //TODO: figure out what to do with RedMulE control
  redmule_tile_pkg::redmule_ctrl_rsp_t                                 redmule_ctrl_rsp       ;  //TODO: figure out what to do with RedMulE control

  redmule_tile_pkg::core_data_req_t                                    core_data_req          ;
  redmule_tile_pkg::core_data_rsp_t                                    core_data_rsp          ;

  redmule_tile_pkg::core_data_req_t[redmule_tile_pkg::N_SBR]           core_mem_data_req      ; // Index 0 -> L1SPM, Index 1 -> L2
  redmule_tile_pkg::core_data_rsp_t[redmule_tile_pkg::N_SBR]           core_mem_data_rsp      ; // Index 0 -> L1SPM, Index 1 -> L2

  redmule_tile_pkg::core_hci_data_req_t                                core_l1_data_req       ;
  redmule_tile_pkg::core_hci_data_rsp_t                                core_l1_data_rsp       ;
  
  logic                                                                hci_clear              ;  //TODO: figure out who should clear the hci
  hci_package::hci_interconnect_ctrl_t                                 hci_ctrl               ;  //TODO: figure out who should control the hci

  redmule_tile_pkg::obi_xbar_rule_t[redmule_tile_pkg::N_ADDR_RULE-1:0] obi_xbar_rule_t        ;
  
  logic[redmule_tile_pkg::N_SBR-1:0]                                   obi_xbar_en_default_idx;
  logic[redmule_tile_pkg::N_SBR-1:0][redmule_tile_pkg::N_BIT_MGR-1:0]  obi_xbar_default_idx   ;

  logic                                                                sys_clk                ;
  logic                                                                sys_clk_en             ;

/*******************************************************/
/**           Internal Signal Definitions End         **/
/*******************************************************/
/**            Hardwired Signals Beginning            **/
/*******************************************************/

  assign obi_xbar_rule_t[0] = '{idx: 32'd0, start_addr: redmule_tile_pkg::L1_ADDR_START, end_addr: redmule_tile_pkg::L1_ADDR_END};
  assign obi_xbar_rule_t[1] = '{idx: 32'd1, start_addr: redmule_tile_pkg::L2_ADDR_START, end_addr: redmule_tile_pkg::L2_ADDR_END};
  
  assign obi_xbar_en_default_idx = '0;
  assign obi_xbar_default_idx    = '0;

  assign core_data_req_o = core_mem_data_req[1];  //TODO: add the AXI XBAR and route data out through it
  assign core_data_rsp_i = core_mem_data_rsp[1];  //TODO: add the AXI XBAR and route data out through it

/*******************************************************/
/**               Hardwired Signals End               **/
/*******************************************************/
/**             Type Conversions Beginning            **/
/*******************************************************/

  obi2hci_req #(
    .obi_req_t ( redmule_tile_pkg::core_data_req_t     ),
    .hci_req_t ( redmule_tile_pkg::core_hci_data_req_t )
  ) i_core_data_obi2hci_req (
    .obi_req_i ( core_mem_data_req[0] ),
    .hci_req_o ( core_l1_data_req     )
  );

  hci2obi_rsp #(
    .hci_rsp_t ( redmule_tile_pkg::core_hci_data_rsp_t ),
    .obi_rsp_t ( redmule_tile_pkg::core_data_rsp_t     )
  ) i_core_data_hci2obi_rsp (
    .hci_rsp_i ( core_l1_data_rsp     ),
    .obi_rsp_o ( core_mem_data_rsp[0] )
  );

/*******************************************************/
/**                Type Conversions End               **/
/*******************************************************/
/**               Clock gating Beginning              **/
/*******************************************************/

  always_ff @ (posedge clk_i, negedge rstn_i) begin: sys_clk_en_ff
    if (~rstn_i) sys_clk_en <= 1'b0;
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
    .AW ( redmule_tile_pkg::AWM    ),
    .DW ( redmule_tile_pkg::DW_LIC ),
    .BW ( redmule_tile_pkg::BW_LIC ),
    .IW ( redmule_tile_pkg::IW     )
  ) hci_tcdm_sram_if[N_MEM_BANKS-1:0] (
    .clk ( sys_clk )
  );
  
  hci_core_intf #(
    .DW ( redmule_tile_pkg::DW_LIC ),
    .AW ( redmule_tile_pkg::AWC    ),
    .OW ( redmule_tile_pkg::AWC    )
  ) hci_core_if[redmule_tile_pkg::N_CORE-1:0] (
    .clk( sys_clk )
  );

  hci_core_intf #(
    .DW ( redmule_tile_pkg::DW_LIC ),
    .AW ( redmule_tile_pkg::AWC    ),
    .OW ( redmule_tile_pkg::AWC    )
  ) hci_redmule_if[redmule_tile_pkg::N_HWPE-1:0] (
    .clk( sys_clk )
  );

  //TODO: connect after integrating the DMA
  hci_core_intf #(
    .DW ( redmule_tile_pkg::DW_LIC ),
    .AW ( redmule_tile_pkg::AWC    ),
    .OW ( redmule_tile_pkg::AWC    )
  ) hci_dma_if[redmule_tile_pkg::N_DMA-1:0] (
    .clk( sys_clk )
  );

  cv32e40x_if_xif#(
    .X_NUM_RS    ( redmule_tile_pkg::X_NUM_RS ),
    .X_ID_WIDTH  ( redmule_tile_pkg::X_ID_W   ),
    .X_MEM_WIDTH ( redmule_tile_pkg::X_MEM_W  ),
    .X_RFR_WIDTH ( redmule_tile_pkg::X_RFR_W  ),
    .X_RFW_WIDTH ( redmule_tile_pkg::X_RFW_W  ),
    .X_MISA      ( redmule_tile_pkg::X_MISA   ),
    .X_ECS_XS    ( redmule_tile_pkg::X_ECS_XS )
  ) xif_if ();

/*******************************************************/
/**             Interface Definitions End             **/
/*******************************************************/
/**          Interface Assignments Beginning          **/
/*******************************************************/

  `HCI_ASSIGN_TO_INTF(hci_core_if, core_l1_data_req, core_l1_data_rsp)
  `HCI_ASSIGN_TO_INTF(hci_redmule_if, redmule_data_req, redmule_data_rsp)
  //TODO: add DMA - HCI interfaceing 
  //`HCI_ASSIGN_TO_INTF(hci_dma_if, , )

/*******************************************************/
/**             Interface Assignments End             **/
/*******************************************************/
/**                 RedMulE Beginning                 **/
/*******************************************************/

  redmule_top #(
    .ID_WIDTH           ( redmule_tile_pkg::REDMULE_ID_W       ),
    .N_CORES            ( redmule_tile_pkg::N_CORE             ),
    .DW                 ( redmule_tile_pkg::DWH                ),
    .UW                 ( redmule_tile_pkg::REDMULE_UW         ),
    .X_EXT              ( redmule_tile_pkg::X_EXT_EN           ),
    .SysInstWidth       ( redmule_tile_pkg::INSTR_W            ),
    .SysDataWidth       ( redmule_tile_pkg::DATA_W             ),
    .redmule_data_req_t ( redmule_tile_pkg::redmule_data_req_t ),
    .redmule_data_rsp_t ( redmule_tile_pkg::redmule_data_rsp_t ),
    .redmule_ctrl_req_t ( redmule_tile_pkg::redmule_ctrl_req_t ),
    .redmule_ctrl_rsp_t ( redmule_tile_pkg::redmule_ctrl_rsp_t )
  ) i_redmule_top (
    .clk_i               ( sys_clk                  ),
    .rst_ni              ( rstn_i                   ),
    .test_mode_i                                     ,

    .busy_o                                          ,  //TODO: do not interface with the outside, interface with the core
    .evt_o                                           ,  //TODO: do not interface with the outside, interface with the core

    .xif_issue_if_i      ( xif_if.coproc_issue      ),
    .xif_result_if_o     ( xif_if.coproc_result     ),
    .xif_compressed_if_i ( xif_if.coproc_compressed ),
    .xif_mem_if_o        ( xif_if.coproc_mem        ),

    .data_req_o          ( redmule_data_req         ),
    .data_rsp_i          ( redmule_data_rsp         ),

    .ctrl_req_i          ( redmule_ctrl_req         ),
    .ctrl_rsp_o          ( redmule_ctrl_rsp         )
  );

/*******************************************************/
/**                    RedMulE End                    **/
/*******************************************************/
/**                   Core Beginning                  **/
/*******************************************************/

  // Documentation of cv32e40x_core's design parameters and interface is available at:
  // https://docs.openhwgroup.org/projects/cv32e40x-user-manual/en/latest/integration.html#core-integration

  cv32e40x_core #(
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
    .rst_ni              ( rstn_i                   ),
    .scan_cg_en_i                                    ,

    // Configuration
    .boot_addr_i                                     ,  //TODO: instead of exposing these outside the tile, manage them with a configuration ROM/RAM?
    .mtvec_addr_i                                    ,  //TODO: instead of exposing these outside the tile, manage them with a configuration ROM/RAM?
    .dm_halt_addr_i                                  ,  //TODO: instead of exposing these outside the tile, manage them with a configuration ROM/RAM?
    .dm_exception_addr_i                             ,  //TODO: instead of exposing these outside the tile, manage them with a configuration ROM/RAM?
    .mhartid_i                                       ,  //TODO: instead of exposing these outside the tile, manage them with a configuration ROM/RAM?
    .mimpid_patch_i                                  ,  //TODO: instead of exposing these outside the tile, manage them with a configuration ROM/RAM?

    // Instruction memory interface
    .instr_req_o         ( core_instr_req_o.req     ),
    .instr_gnt_i         ( core_instr_rsp_i.gnt     ),
    .instr_addr_o        ( core_instr_req_o.addr    ),
    .instr_memtype_o     ( core_instr_req_o.memtype ),
    .instr_prot_o        ( core_instr_req_o.prot    ),
    .instr_dbg_o         ( core_instr_req_o.dbg     ),
    .instr_rvalid_i      ( core_instr_rsp_i.rvalid  ),
    .instr_rdata_i       ( core_instr_rsp_i.rdata   ),
    .instr_err_i         ( core_instr_rsp_i.err     ),

    // Data memory interface
    .data_req_o          ( core_data_req.req        ),
    .data_gnt_i          ( core_data_rsp.gnt        ),
    .data_addr_o         ( core_data_req.addr       ),
    .data_atop_o         ( core_data_req.atop       ),
    .data_be_o           ( core_data_req.be         ),
    .data_memtype_o      ( core_data_req.memtype    ),
    .data_prot_o         ( core_data_req.prot       ),
    .data_dbg_o          ( core_data_req.dbg        ),
    .data_wdata_o        ( core_data_req.wdata      ),
    .data_we_o           ( core_data_req.we         ),
    .data_rvalid_i       ( core_data_rsp.rvalid     ),
    .data_rdata_i        ( core_data_rsp.rdata      ),
    .data_err_i          ( core_data_rsp.err        ),
    .data_exokay_i       ( core_data_rsp.exokay     ),

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
    .irq_i                                           ,  //TODO: manage IRQs - look at redmule_complex for an idea

    .clic_irq_i          ( '0                       ),  //TODO: CLIC not supported (yet?): see redmule_tile_pkg 
    .clic_irq_id_i       ( '0                       ),  //TODO: CLIC not supported (yet?): see redmule_tile_pkg 
    .clic_irq_level_i    ( '0                       ),  //TODO: CLIC not supported (yet?): see redmule_tile_pkg 
    .clic_irq_priv_i     ( '0                       ),  //TODO: CLIC not supported (yet?): see redmule_tile_pkg 
    .clic_irq_shv_i      ( '0                       ),  //TODO: CLIC not supported (yet?): see redmule_tile_pkg 

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

  obi_xbar #(
    .SbrPortObiCfg      (                                   ),
    .MgrPortObiCfg      (                                   ),
    .sbr_port_obi_req_t ( redmule_tile_pkg::core_data_req_t ),
    .sbr_port_a_chan_t  ( redmule_tile_pkg::obi_a_chan_t    ),
    .sbr_port_obi_rsp_t ( redmule_tile_pkg::core_data_rsp_t ),
    .sbr_port_r_chan_t  ( redmule_tile_pkg::obi_r_cnah_t    ),
    .mgr_port_obi_req_t (                                   ),
    .mgr_port_obi_rsp_t (                                   ),
    .NumSbrPorts        ( redmule_tile_pkg::N_SBR           ),
    .NumMgrPorts        ( redmule_tile_pkg::N_MGR           ),
    .NumMaxTrans        ( redmule_tile_pkg::N_MAX_TRAN      ),
    .NumAddrRules       ( redmule_tile_pkg::N_ADDR_RULE     ),
    .addr_map_rule_t    ( redmule_tile_pkg::obi_xbar_rule_t ),
    .UseIdForRouting    (                                   ),
    .Connectivity       (                                   )
  ) i_obi_xbar (
    .clk_i            ( sys_clk                 ),
    .rst_ni           ( rstn_i                  ),
    .testmode_i       ( test_mode_i             ),

    .sbr_ports_req_i  ( core_mem_data_req       ),
    .sbr_ports_rsp_o  ( core_mem_data_rsp       ),

    .mgr_ports_req_o  ( core_data_req           ),
    .mgr_ports_rsp_i  ( core_data_rsp           ),

    .addr_map_i       ( obi_xbar_rule_t         ),
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
    .clk_i   ( sys_clk          ),
    .rst_ni  ( rstn_i           ),
    .clear_i ( hci_clear        ),

    .ctrl_i  ( hci_ctrl         ),
    
    .cores   ( hci_core_if      ),
    .dma     ( hci_dma_if       ),
    .ext     (                  ),
    .mems    ( hci_tcdm_sram_if ),
    .hwpe    ( hci_redmule_if   )
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
    .SIM_INIT ( "ones"                   )
  ) i_l1_spm (
    .clk_i      ( sys_clk          ),
    .rstn_i     ( rstn_i           ),

    .tcdm_slave ( hci_tcdm_sram_if )
  );

/*******************************************************/
/**                 L1 SPM (TCDM) End                 **/
/*******************************************************/
/**                   iDMA Beginning                  **/
/*******************************************************/

//TODO

/*******************************************************/
/**                      iDMA End                     **/
/*******************************************************/
/**                    i$ Beginning                   **/
/*******************************************************/

//TODO

/*******************************************************/
/**                       i$ End                      **/
/*******************************************************/
/**         Data Out - L2 (AXI XBAR) Beginning        **/
/*******************************************************/

//TODO

/*******************************************************/
/**            Data Out - L2 (AXI XBAR) End           **/
/*******************************************************/

endmodule: redemule_tile