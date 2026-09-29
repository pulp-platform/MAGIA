/*
 * Copyright (C) 2023-2026 ETH Zurich, University of Bologna and Fondazione Chips-IT
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
 *          Luca Balboni <luca.balboni@chips.it>
 *
 * MAGIA Isle
 */

`include "hci_helpers.svh"
`include "hwpe_ctrl_helpers.svh"

// Observation port of the Verilator testbench, dropped by MAGIA_NO_OBSERVE
`ifdef VERILATOR
`ifndef MAGIA_NO_OBSERVE
`define MAGIA_ISLE_OBSERVE
`endif
`endif

module magia_isle
  import magia_tile_pkg::*;
  import magia_pkg::*;
  import redmule_pkg::*;
  import hci_package::*;
`ifdef CV32E40X
  import cv32e40x_pkg::*;
  import fpu_ss_pkg::*;
`endif
  import snitch_icache_pkg::*;
  import idma_pkg::*;
  import obi_pkg::*;
  import axi_pkg::*;
#(
  parameter magia_tile_pkg::magia_tile_cfg_t TileCfg = magia_tile_pkg::MagiaTileDefaultCfg,

  // Hart ids: control core and Spatz at HartIdBase + mhartid_i, cluster cores after all tiles
  parameter int unsigned                     HartIdBase      = 0,
  parameter int unsigned                     InstanceCount   = magia_pkg::N_TILES,

  // Cacheable code region for the i-caches and Spatz's PMA; size 0 caches every fetch
  parameter longint unsigned                 CodeRegionBase  = 64'h0,
  parameter longint unsigned                 CodeRegionSize  = 64'h0
)(
  input  logic                                    clk_i,
  input  logic                                    rst_ni,
  input  logic                                    test_mode_i,
  input  logic                                    tile_enable_i,

  // Narrow AXI: requests leaving the isle
  output magia_pkg::axi_xbar_mst_req_t            axi_narrow_mst_req_o,
  input  magia_pkg::axi_xbar_mst_rsp_t            axi_narrow_mst_rsp_i,
  // Narrow AXI: requests entering the isle
  input  magia_tile_pkg::axi_xbar_slv_req_t       axi_narrow_slv_req_i,
  output magia_tile_pkg::axi_xbar_slv_rsp_t       axi_narrow_slv_rsp_o,
  // Wide AXI: iDMA requests leaving the isle
  output magia_tile_pkg::idma_axi_req_t           axi_wide_mst_req_o,
  input  magia_tile_pkg::idma_axi_rsp_t           axi_wide_mst_rsp_i,
  // Wide AXI: iDMA requests entering the isle
  input  magia_tile_pkg::idma_axi_req_t           axi_wide_slv_req_i,
  output magia_tile_pkg::idma_axi_rsp_t           axi_wide_slv_rsp_o,

`ifdef MAGIA_FSYNC
  fractal_sync_if.mst_port                        ht_fsync_if_o,
  fractal_sync_if.mst_port                        hn_fsync_if_o,
  fractal_sync_if.mst_port                        vt_fsync_if_o,
  fractal_sync_if.mst_port                        vn_fsync_if_o,
`endif

  input  logic[31:0]                              mhartid_i,    // Position of the isle in the global address map
  input  logic[31:0]                              boot_addr_i,
  input  logic                                    fetch_enable_i,
  output logic                                    core_sleep_o,

  // Event Unit interrupt of the control core, for an external controller (e.g. host CLIC)
  output logic                                    eu_irq_req_o,
  output logic[4:0]                               eu_irq_id_o,
  input  logic                                    eu_irq_ack_i,     // Clears event eu_irq_ack_id_i
  input  logic[4:0]                               eu_irq_ack_id_i,

  input  logic                                    debug_req_i,  // Control core, through its Event Unit
  output logic                                    debug_havereset_o,
  output logic                                    debug_running_o,
  output logic                                    debug_halted_o,
  output logic                                    debug_pc_valid_o,
  output logic[31:0]                              debug_pc_o,
  output logic[63:0]                              mcycle_o,
  // Debug halt and exception entry points of the control core
  input  logic[31:0]                              dm_halt_addr_i,
  input  logic[31:0]                              dm_exception_addr_i
`ifdef CV32E40X
  // Read only by the CV32E40X
  , input  logic                                  scan_cg_en_i,
  input  logic[31:0]                              mtvec_addr_i,
  input  logic[ 3:0]                              mimpid_patch_i,
  input  logic[63:0]                              time_i,
  input  logic                                    wu_wfe_i
`endif
`ifdef MAGIA_ISLE_OBSERVE
  , output magia_tile_observe_t                   observe_o
`endif
);

/*******************************************************/
/**              Configuration Beginning              **/
/*******************************************************/

  localparam magia_tile_pkg::obi_mgr_map_t      ObiMgr     = magia_tile_pkg::gen_obi_mgr_map(TileCfg);
  localparam magia_tile_pkg::obi_sbr_map_t      ObiSbr     = magia_tile_pkg::gen_obi_sbr_map(TileCfg);
  localparam magia_tile_pkg::axi_xbar_mst_map_t AxiMst     = magia_tile_pkg::gen_axi_xbar_mst_map(TileCfg);
  localparam axi_pkg::xbar_cfg_t                AxiXbarCfg = magia_tile_pkg::gen_axi_xbar_cfg(TileCfg);
  localparam magia_tile_pkg::ctrl_map_t         CtrlMap    = magia_tile_pkg::gen_ctrl_map(TileCfg);
  localparam magia_tile_pkg::ctrl_rules_t       CtrlRules  = magia_tile_pkg::gen_ctrl_rules(TileCfg);

  localparam int unsigned NumSpatzHciPorts = magia_tile_pkg::gen_tile_spatz_hci_ports(TileCfg);
  localparam int unsigned NumHciCore       = magia_tile_pkg::gen_tile_num_hci_core(TileCfg);
  localparam int unsigned NClusterCores    = TileCfg.Cluster.NumCores;

  localparam int unsigned NumMemBanks  = TileCfg.L1.NumBanks;
  localparam int unsigned NumWordsBank = TileCfg.L1.NumWordsBank;
  localparam int unsigned L1BankAddrW  = $clog2(NumWordsBank * magia_tile_pkg::DW_LIC / magia_tile_pkg::BW_LIC);  // Byte address within a bank

  localparam int unsigned NumHwpe = TileCfg.EnRedMule ? 1 : 0;  // 0 drops the RedMulE leaf of the HCI interconnect
  localparam int unsigned NumDma  = magia_tile_pkg::N_DMA;
  localparam int unsigned NumExt  = magia_tile_pkg::N_EXT;
  localparam int unsigned TileIW  = NumHwpe + NumHciCore + NumDma + NumExt;

  localparam int unsigned RedmuleFpW   = 16;  // FP16
  localparam int unsigned RedmuleDataW = TileCfg.RedMule.Height * (TileCfg.RedMule.NumPipeRegs + 1) * RedmuleFpW;
  localparam int unsigned RedmuleDwh   = RedmuleDataW + 32;
  localparam int unsigned RedmuleSwh   = RedmuleDwh / magia_tile_pkg::BWH;

  `HWPE_CTRL_TYPEDEF_REQ_T(tile_redmule_ctrl_req_t, logic[magia_tile_pkg::AWC-1:0], logic[RedmuleDwh-1:0], logic[RedmuleSwh-1:0], logic[TileIW-1:0])
  `HWPE_CTRL_TYPEDEF_RSP_T(tile_redmule_ctrl_rsp_t, logic[RedmuleDwh-1:0], logic[TileIW-1:0])
  `HCI_TYPEDEF_REQ_T(tile_redmule_data_req_t, logic[magia_tile_pkg::AWC-1:0], logic[RedmuleDwh-1:0], logic[RedmuleSwh-1:0], logic[magia_tile_pkg::UWH-1:0], logic[TileIW-1:0], logic[0:0], logic[0:0])
  `HCI_TYPEDEF_RSP_T(tile_redmule_data_rsp_t, logic[RedmuleDwh-1:0], logic[magia_tile_pkg::UWH-1:0], logic[TileIW-1:0], logic[0:0], logic[0:0])

  `HCI_TYPEDEF_REQ_T(tile_hci_data_req_t, logic[magia_tile_pkg::AWC-1:0], logic[magia_tile_pkg::DW_LIC-1:0], logic[magia_tile_pkg::SW_LIC-1:0], logic[magia_tile_pkg::UWH-1:0], logic[TileIW-1:0], logic[0:0], logic[0:0])
  `HCI_TYPEDEF_RSP_T(tile_hci_data_rsp_t, logic[magia_tile_pkg::DW_LIC-1:0], logic[magia_tile_pkg::UWH-1:0], logic[TileIW-1:0], logic[0:0], logic[0:0])
  `HCI_TYPEDEF_REQ_T(tile_idma_hci_req_t, logic[magia_tile_pkg::iDMA_AddrWidth-1:0], logic[magia_tile_pkg::iDMA_DataWidth-1:0], logic[magia_tile_pkg::iDMA_StrbWidth-1:0], logic[magia_tile_pkg::iDMA_UserWidth-1:0], logic[TileIW-1:0], logic[0:0], logic[0:0])
  `HCI_TYPEDEF_RSP_T(tile_idma_hci_rsp_t, logic[magia_tile_pkg::iDMA_DataWidth-1:0], logic[magia_tile_pkg::iDMA_UserWidth-1:0], logic[TileIW-1:0], logic[0:0], logic[0:0])

  localparam logic[31:0] CodeRegionMask = (CodeRegionSize == 0) ? 32'h0
                                        : ~(32'(CodeRegionSize) - 32'd1);

  if (CodeRegionSize != 0 &&
      (((CodeRegionSize & (CodeRegionSize - 1)) != 0) || ((CodeRegionBase & (CodeRegionSize - 1)) != 0)))
    $fatal(1, "magia_isle: the code region 0x%0h+0x%0h is not a power of two aligned to its size",
           CodeRegionBase, CodeRegionSize);

  // Built through a function: a nested `default:` pattern does not elaborate in every tool
  function automatic snitch_pma_pkg::rule_t [snitch_pma_pkg::NrMaxRules-1:0] spatz_code_regions();
    automatic snitch_pma_pkg::rule_t [snitch_pma_pkg::NrMaxRules-1:0] rules = '{default: '0};
    rules[0] = '{base: 48'(CodeRegionBase), mask: 48'(CodeRegionMask)};
    return rules;
  endfunction
  localparam snitch_pma_pkg::snitch_pma_t SpatzCodePmaCfg = '{
    NrCachedRegionRules: 1,
    CachedRegion: spatz_code_regions(),
    default: 0
  };
  localparam snitch_pma_pkg::snitch_pma_t SpatzPmaCfg =
    (CodeRegionSize == 0) ? magia_tile_pkg::SPATZ_SNITCH_PMA_CFG : SpatzCodePmaCfg;

/*******************************************************/
/**                 Configuration End                 **/
/*******************************************************/
/**               Clock Gating Beginning              **/
/*******************************************************/

  logic sys_clk_en;
  logic sys_clk;

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

  // The Event Unit gates the control core while it waits for an event
  logic eu_core_clk_en;
  logic core_clk_en;
  logic core_clk;

  assign core_clk_en = eu_core_clk_en;

  tc_clk_gating core_clock_gating (
    .clk_i     ( sys_clk     ),
    .en_i      ( core_clk_en ),
    .test_en_i ( test_mode_i ),
    .clk_o     ( core_clk    )
  );

/*******************************************************/
/**                  Clock Gating End                 **/
/*******************************************************/
/**             Tile Address Map Beginning            **/
/*******************************************************/

  // L1 and reserved regions are global: each tile owns the slot at mhartid*L1_TILE_OFFSET
  logic[magia_pkg::ADDR_W-1:0] tile_l1_start_addr;
  logic[magia_pkg::ADDR_W-1:0] tile_l1_end_addr;
  logic[magia_pkg::ADDR_W-1:0] tile_reserved_start_addr;
  logic[magia_pkg::ADDR_W-1:0] tile_reserved_end_addr;
  logic[magia_pkg::ADDR_W-1:0] tile_event_unit_start_addr;
  logic[magia_pkg::ADDR_W-1:0] tile_event_unit_end_addr;

  assign tile_l1_start_addr         = magia_tile_pkg::L1_ADDR_START       + mhartid_i*magia_tile_pkg::L1_TILE_OFFSET;
  assign tile_l1_end_addr           = magia_tile_pkg::L1_ADDR_END         + mhartid_i*magia_tile_pkg::L1_TILE_OFFSET;
  assign tile_reserved_start_addr   = magia_tile_pkg::RESERVED_ADDR_START + mhartid_i*magia_tile_pkg::L1_TILE_OFFSET;
  assign tile_reserved_end_addr     = magia_tile_pkg::RESERVED_ADDR_END   + mhartid_i*magia_tile_pkg::L1_TILE_OFFSET;
  assign tile_event_unit_start_addr = magia_tile_pkg::CTRL_EU_ADDR_START;
  assign tile_event_unit_end_addr   = magia_tile_pkg::CTRL_EU_ADDR_END;

/*******************************************************/
/**                Tile Address Map End               **/
/*******************************************************/
/**               Control Core Beginning              **/
/*******************************************************/

  magia_tile_pkg::core_instr_req_t core_instr_req;
  magia_tile_pkg::core_instr_rsp_t core_instr_rsp;
  magia_tile_pkg::core_data_req_t  core_data_req;
  magia_tile_pkg::core_data_rsp_t  core_data_rsp;

  logic fencei_flush_req;
  logic fencei_flush_ack;

  // No CPU interrupts: the control core waits on the Event Unit
  logic[31:0] core_irq_vec;

  assign core_irq_vec = '0;

  // Debug request, forwarded by the Event Unit
  logic eu_core_dbg_req;

`ifdef CV32E40X
  logic                                clic_irq;
  logic[magia_tile_pkg::CLIC_ID_W-1:0] clic_irq_id;
  logic[7:0]                           clic_irq_level;
  logic[1:0]                           clic_irq_priv;
  logic                                clic_irq_shv;

  assign clic_irq       = 1'b0;
  assign clic_irq_id    = '0;
  assign clic_irq_level = '0;
  assign clic_irq_priv  = '0;
  assign clic_irq_shv   = 1'b0;

  // Shared by the core (cpu_*) and the FPU (coproc_*)
  cv32e40x_if_xif #(
    .X_NUM_RS    ( magia_tile_pkg::X_NUM_RS ),
    .X_ID_WIDTH  ( magia_tile_pkg::X_ID_W   ),
    .X_MEM_WIDTH ( magia_tile_pkg::X_MEM_W  ),
    .X_RFR_WIDTH ( magia_tile_pkg::X_RFR_W  ),
    .X_RFW_WIDTH ( magia_tile_pkg::X_RFW_W  ),
    .X_MISA      ( magia_tile_pkg::X_MISA   ),
    .X_ECS_XS    ( magia_tile_pkg::X_ECS_XS )
  ) xif_if ();

`ifndef CORE_TRACES
  cv32e40x_core #(
`else
  cv32e40x_wrapper #(
`endif
    .RV32             ( TileCfg.CtrlCore.ISA            ),
    .A_EXT            ( TileCfg.CtrlCore.A              ),
    .B_EXT            ( TileCfg.CtrlCore.B              ),
    .M_EXT            ( TileCfg.CtrlCore.M              ),
    .X_EXT            ( magia_tile_pkg::X_EXT_EN        ),
    .X_NUM_RS         ( magia_tile_pkg::X_NUM_RS        ),
    .X_ID_WIDTH       ( magia_tile_pkg::X_ID_W          ),
    .X_MEM_WIDTH      ( magia_tile_pkg::X_MEM_W         ),
    .X_RFR_WIDTH      ( magia_tile_pkg::X_RFR_W         ),
    .X_RFW_WIDTH      ( magia_tile_pkg::X_RFW_W         ),
    .X_MISA           ( magia_tile_pkg::X_MISA          ),
    .X_ECS_XS         ( magia_tile_pkg::X_ECS_XS        ),
    .NUM_MHPMCOUNTERS ( 1                               ),
    .DEBUG            ( 1                               ),
    .DM_REGION_START  ( magia_tile_pkg::DM_REGION_START ),
    .DM_REGION_END    ( magia_tile_pkg::DM_REGION_END   ),
    .DBG_NUM_TRIGGERS ( 1                               ),
    .PMA_NUM_REGIONS  ( 0                               ),
    .PMA_CFG          (                                 ),
    .CLIC             ( magia_tile_pkg::CLIC_EN         ),
    .CLIC_ID_WIDTH    ( magia_tile_pkg::CLIC_ID_W       )
  ) i_cv32e40x_ctrl_core (
    .clk_i               ( core_clk               ),
    .rst_ni              ( rst_ni                 ),
    .scan_cg_en_i                                  ,

    .boot_addr_i                                   ,
    .mtvec_addr_i                                  ,
    .dm_halt_addr_i                                ,
    .dm_exception_addr_i                           ,
    .mhartid_i           ( 32'(HartIdBase) + mhartid_i ),
    .mimpid_patch_i                                ,

    .instr_req_o         ( core_instr_req.req     ),
    .instr_gnt_i         ( core_instr_rsp.gnt     ),
    .instr_addr_o        ( core_instr_req.addr    ),
    .instr_memtype_o     ( core_instr_req.memtype ),
    .instr_prot_o        ( core_instr_req.prot    ),
    .instr_dbg_o         ( core_instr_req.dbg     ),
    .instr_rvalid_i      ( core_instr_rsp.rvalid  ),
    .instr_rdata_i       ( core_instr_rsp.rdata   ),
    .instr_err_i         ( core_instr_rsp.err     ),

    .data_req_o          ( core_data_req.req      ),
    .data_gnt_i          ( core_data_rsp.gnt      ),
    .data_addr_o         ( core_data_req.addr     ),
    .data_atop_o         ( core_data_req.atop     ),
    .data_be_o           ( core_data_req.be       ),
    .data_memtype_o      ( core_data_req.memtype  ),
    .data_prot_o         ( core_data_req.prot     ),
    .data_dbg_o          ( core_data_req.dbg      ),
    .data_wdata_o        ( core_data_req.wdata    ),
    .data_we_o           ( core_data_req.we       ),
    .data_rvalid_i       ( core_data_rsp.rvalid   ),
    .data_rdata_i        ( core_data_rsp.rdata    ),
    .data_err_i          ( core_data_rsp.err      ),
    .data_exokay_i       ( core_data_rsp.exokay   ),

    .mcycle_o                                      ,
    .time_i                                        ,

    .xif_compressed_if   ( xif_if.cpu_compressed  ),
    .xif_issue_if        ( xif_if.cpu_issue       ),
    .xif_commit_if       ( xif_if.cpu_commit      ),
    .xif_mem_if          ( xif_if.cpu_mem         ),
    .xif_mem_result_if   ( xif_if.cpu_mem_result  ),
    .xif_result_if       ( xif_if.cpu_result      ),

    .irq_i               ( core_irq_vec           ),

    .clic_irq_i          ( clic_irq               ),
    .clic_irq_id_i       ( clic_irq_id            ),
    .clic_irq_level_i    ( clic_irq_level         ),
    .clic_irq_priv_i     ( clic_irq_priv          ),
    .clic_irq_shv_i      ( clic_irq_shv           ),

    .fencei_flush_req_o  ( fencei_flush_req       ),
    .fencei_flush_ack_i  ( fencei_flush_ack       ),

    .debug_req_i         ( eu_core_dbg_req        ),
    .debug_havereset_o                             ,
    .debug_running_o                               ,
    .debug_halted_o                                ,
    .debug_pc_valid_o                              ,
    .debug_pc_o                                    ,

    .fetch_enable_i                                ,
    .core_sleep_o                                  ,
    .wu_wfe_i
  );
`else
`ifndef CORE_TRACES
  cv32e40p_top #(
`else
  cv32e40p_wrapper #(
`endif
    .COREV_PULP          ( 1                                   ),
    .COREV_CLUSTER       ( 1                                   ),
    .FPU                 ( FPU                                 ),
    .ZFINX               ( magia_tile_pkg::ZFINX_CTRL          ),
    .FPU_ADDMUL_LAT      ( 1                                   ),  // Match C_LAT_FP32 in the fpnew wrapper
    .FPU_OTHERS_LAT      ( 1                                   ),  // Match C_LAT_NONCOMP in the fpnew wrapper
    .NUM_MHPMCOUNTERS    ( 29                                  )
  ) i_cv32e40p_ctrl_core (
    .clk_i                  ( core_clk              ),
    .rst_ni                 ( rst_ni                ),

    .pulp_clock_en_i        ( core_clk_en           ),
    .scan_cg_en_i           ( test_mode_i           ),
    .boot_addr_i            ( boot_addr_i           ),
    .mtvec_addr_i           ( boot_addr_i           ),  // SW can move mtvec with csrw
    .dm_halt_addr_i         ( dm_halt_addr_i        ),
    .hart_id_i              ( 32'(HartIdBase) + mhartid_i ),
    .dm_exception_addr_i    ( dm_exception_addr_i   ),

    .instr_req_o            ( core_instr_req.req    ),
    .instr_gnt_i            ( core_instr_rsp.gnt    ),
    .instr_rvalid_i         ( core_instr_rsp.rvalid ),
    .instr_addr_o           ( core_instr_req.addr   ),
    .instr_rdata_i          ( core_instr_rsp.rdata  ),

    .data_req_o             ( core_data_req.req     ),
    .data_gnt_i             ( core_data_rsp.gnt     ),
    .data_rvalid_i          ( core_data_rsp.rvalid  ),
    .data_addr_o            ( core_data_req.addr    ),
    .data_be_o              ( core_data_req.be      ),
    .data_wdata_o           ( core_data_req.wdata   ),
    .data_we_o              ( core_data_req.we      ),
    .data_rdata_i           ( core_data_rsp.rdata   ),

    .irq_i                  ( core_irq_vec          ),
    .irq_ack_o              (                       ),
    .irq_id_o               (                       ),

    .debug_req_i            ( eu_core_dbg_req       ),
    .debug_havereset_o      ( debug_havereset_o     ),
    .debug_running_o        ( debug_running_o       ),
    .debug_halted_o         ( debug_halted_o        ),

    .fetch_enable_i         ( fetch_enable_i        ),
    .core_sleep_o           ( core_sleep_o          )
  );

  assign core_instr_req.memtype = 2'b00;
  assign core_instr_req.prot    = 3'b000;
  assign core_instr_req.dbg     = 1'b0;

  assign mcycle_o         = 64'h0;
  assign debug_pc_valid_o = 1'b0;
  assign debug_pc_o       = 32'h0;
`endif

/*******************************************************/
/**                  Control Core End                 **/
/*******************************************************/
/**           Floating-Point Unit Beginning           **/
/*******************************************************/

`ifdef CV32E40X
  logic                           x_compressed_valid;
  logic                           x_compressed_ready;
  fpu_ss_pkg::x_compressed_req_t  x_compressed_req;
  fpu_ss_pkg::x_compressed_resp_t x_compressed_resp;
  logic                           x_issue_valid;
  logic                           x_issue_ready;
  fpu_ss_pkg::x_issue_req_t       x_issue_req;
  fpu_ss_pkg::x_issue_resp_t      x_issue_resp;
  logic                           x_commit_valid;
  fpu_ss_pkg::x_commit_t          x_commit;
  logic                           x_mem_valid;
  logic                           x_mem_ready;
  fpu_ss_pkg::x_mem_req_t         x_mem_req;
  fpu_ss_pkg::x_mem_resp_t        x_mem_resp;
  logic                           x_mem_result_valid;
  fpu_ss_pkg::x_mem_result_t      x_mem_result;
  logic                           x_result_valid;
  logic                           x_result_ready;
  fpu_ss_pkg::x_result_t          x_result;

  xif_if2struct i_xif_if2struct (
    .xif_compressed_if_i  ( xif_if.coproc_compressed ),
    .xif_issue_if_i       ( xif_if.coproc_issue      ),
    .xif_commit_if_i      ( xif_if.coproc_commit     ),
    .xif_mem_if_o         ( xif_if.coproc_mem        ),
    .xif_mem_result_if_i  ( xif_if.coproc_mem_result ),
    .xif_result_if_o      ( xif_if.coproc_result     ),
    .x_compressed_valid_o ( x_compressed_valid       ),
    .x_compressed_ready_i ( x_compressed_ready       ),
    .x_compressed_req_o   ( x_compressed_req         ),
    .x_compressed_resp_i  ( x_compressed_resp        ),
    .x_issue_valid_o      ( x_issue_valid            ),
    .x_issue_ready_i      ( x_issue_ready            ),
    .x_issue_req_o        ( x_issue_req              ),
    .x_issue_resp_i       ( x_issue_resp             ),
    .x_commit_valid_o     ( x_commit_valid           ),
    .x_commit_o           ( x_commit                 ),
    .x_mem_valid_i        ( x_mem_valid              ),
    .x_mem_ready_o        ( x_mem_ready              ),
    .x_mem_req_i          ( x_mem_req                ),
    .x_mem_resp_o         ( x_mem_resp               ),
    .x_mem_result_valid_o ( x_mem_result_valid       ),
    .x_mem_result_o       ( x_mem_result             ),
    .x_result_valid_i     ( x_result_valid           ),
    .x_result_ready_o     ( x_result_ready           ),
    .x_result_i           ( x_result                 )
  );

  fpu_ss #(
    .PULP_ZFINX                ( magia_tile_pkg::ZFINX_CTRL         ),
    .INPUT_BUFFER_DEPTH        ( magia_tile_pkg::FPU_BUFFER_DEPTH   ),
    .INPUT_BUFFER_FALL_THROUGH ( magia_tile_pkg::FPU_BUFFER_FT      ),
    .OUT_OF_ORDER              ( magia_tile_pkg::FPU_OOO            ),
    .FORWARDING                ( magia_tile_pkg::FPU_FWD            ),
    .PulpDivsqrt               ( magia_tile_pkg::FPU_DIVSQRT        ),
    .FPU_FEATURES              ( magia_tile_pkg::FPU_FEATURES       ),
    .FPU_IMPLEMENTATION        ( magia_tile_pkg::FPU_IMPLEMENTATION )
  ) i_fpu (
    .clk_i                ( sys_clk            ),
    .rst_ni               ( rst_ni             ),
    .x_compressed_valid_i ( x_compressed_valid ),
    .x_compressed_ready_o ( x_compressed_ready ),
    .x_compressed_req_i   ( x_compressed_req   ),
    .x_compressed_resp_o  ( x_compressed_resp  ),
    .x_issue_valid_i      ( x_issue_valid      ),
    .x_issue_ready_o      ( x_issue_ready      ),
    .x_issue_req_i        ( x_issue_req        ),
    .x_issue_resp_o       ( x_issue_resp       ),
    .x_commit_valid_i     ( x_commit_valid     ),
    .x_commit_i           ( x_commit           ),
    .x_mem_valid_o        ( x_mem_valid        ),
    .x_mem_ready_i        ( x_mem_ready        ),
    .x_mem_req_o          ( x_mem_req          ),
    .x_mem_resp_i         ( x_mem_resp         ),
    .x_mem_result_valid_i ( x_mem_result_valid ),
    .x_mem_result_i       ( x_mem_result       ),
    .x_result_valid_o     ( x_result_valid     ),
    .x_result_ready_i     ( x_result_ready     ),
    .x_result_o           ( x_result           )
  );
`endif

/*******************************************************/
/**              Floating-Point Unit End              **/
/*******************************************************/
/**         Control Core i$ Beginning                 **/
/*******************************************************/

  magia_tile_pkg::core_cache_instr_req_t core_cache_instr_req;
  magia_tile_pkg::core_cache_instr_rsp_t core_cache_instr_rsp;
  magia_tile_pkg::core_axi_instr_req_t   core_l2_instr_req;
  magia_tile_pkg::core_axi_instr_rsp_t   core_l2_instr_rsp;

  logic                                                                     enable_prefetching;
  snitch_icache_pkg::icache_l0_events_t[magia_tile_pkg::NR_FETCH_PORTS-1:0] icache_l0_events;
  snitch_icache_pkg::icache_l1_events_t                                     icache_l1_events;
  logic[magia_tile_pkg::NR_FETCH_PORTS-1:0]                                 flush_valid;
  logic[magia_tile_pkg::NR_FETCH_PORTS-1:0]                                 flush_ready;

  assign enable_prefetching = 1'b0;
`ifdef CV32E40X
  assign flush_valid[0]   = fencei_flush_req;
  assign fencei_flush_ack = flush_ready[0];
`else
  assign flush_valid      = '0;
`endif

  instr2cache_req i_core_instr2cache_req (
    .instr_req_i ( core_instr_req       ),
    .cache_req_o ( core_cache_instr_req )
  );

  cache2instr_rsp i_core_cache2instr_rsp (
    .cache_rsp_i ( core_cache_instr_rsp ),
    .instr_rsp_o ( core_instr_rsp       )
  );

  magia_tile_icache_wrap #(
    .CachedRegionBase ( 32'(CodeRegionBase)               ),
    .CachedRegionMask ( CodeRegionMask                      ),
    .NumFetchPorts   ( magia_tile_pkg::NR_FETCH_PORTS       ),
    .L0_LINE_COUNT   ( magia_tile_pkg::L0_LINE_COUNT        ),
    .LINE_WIDTH      ( magia_tile_pkg::LINE_WIDTH           ),
    .LINE_COUNT      ( magia_tile_pkg::LINE_COUNT           ),
    .WAY_COUNT       ( magia_tile_pkg::WAY_COUNT            ),
    .FetchAddrWidth  ( magia_tile_pkg::FETCH_AW             ),
    .FetchDataWidth  ( magia_tile_pkg::FETCH_DW             ),
    .AxiAddrWidth    ( magia_tile_pkg::FILL_AW              ),
    .AxiDataWidth    ( magia_tile_pkg::FILL_DW              ),
    .sram_cfg_data_t (                                      ),
    .sram_cfg_tag_t  (                                      ),
    .axi_req_t       ( magia_tile_pkg::core_axi_instr_req_t ),
    .axi_rsp_t       ( magia_tile_pkg::core_axi_instr_rsp_t )
  ) i_icache (
    .clk_i                ( sys_clk                     ),
    .rst_ni               ( rst_ni                      ),

    .fetch_req_i          ( core_cache_instr_req.req    ),
    .fetch_addr_i         ( core_cache_instr_req.addr   ),
    .fetch_gnt_o          ( core_cache_instr_rsp.gnt    ),
    .fetch_rvalid_o       ( core_cache_instr_rsp.rvalid ),
    .fetch_rdata_o        ( core_cache_instr_rsp.rdata  ),
    .fetch_rerror_o       ( core_cache_instr_rsp.rerror ),

    .enable_prefetching_i ( enable_prefetching          ),
    .icache_l0_events_o   ( icache_l0_events            ),
    .icache_l1_events_o   ( icache_l1_events            ),
    .flush_valid_i        ( flush_valid                 ),
    .flush_ready_o        ( flush_ready                 ),

    .sram_cfg_data_i      ( '0                          ),
    .sram_cfg_tag_i       ( '0                          ),

    .axi_req_o            ( core_l2_instr_req           ),
    .axi_rsp_i            ( core_l2_instr_rsp           )
  );

/*******************************************************/
/**              Control Core i$ End                  **/
/*******************************************************/
/**          Control Core Data Path Beginning         **/
/*******************************************************/

  // L1 takes a dedicated HCI port, Event Unit accesses the direct link, everything else the OBI crossbar
  magia_tile_pkg::core_data_req_t [magia_tile_pkg::CORE_DATA_DEMUX_N_SLV-1:0] core_data_demux_req;
  magia_tile_pkg::core_data_rsp_t [magia_tile_pkg::CORE_DATA_DEMUX_N_SLV-1:0] core_data_demux_rsp;
  logic[magia_pkg::ADDR_W-1:0] core_data_demux_start_addr [magia_tile_pkg::CORE_DATA_DEMUX_N_SLV-1:0];
  logic[magia_pkg::ADDR_W-1:0] core_data_demux_end_addr   [magia_tile_pkg::CORE_DATA_DEMUX_N_SLV-1:0];

  assign core_data_demux_start_addr[magia_tile_pkg::CORE_DATA_DEMUX_TCDM_IDX] = tile_l1_start_addr;
  assign core_data_demux_end_addr  [magia_tile_pkg::CORE_DATA_DEMUX_TCDM_IDX] = tile_l1_end_addr;
  assign core_data_demux_start_addr[magia_tile_pkg::CORE_DATA_DEMUX_OBI_IDX]  = '0;  // Default port
  assign core_data_demux_end_addr  [magia_tile_pkg::CORE_DATA_DEMUX_OBI_IDX]  = '0;
  assign core_data_demux_start_addr[magia_tile_pkg::CORE_DATA_DEMUX_EU_IDX]   = tile_event_unit_start_addr;
  assign core_data_demux_end_addr  [magia_tile_pkg::CORE_DATA_DEMUX_EU_IDX]   = tile_event_unit_end_addr - 1;

  core_data_demux #(
    .NumSlv      ( magia_tile_pkg::CORE_DATA_DEMUX_N_SLV   ),
    .DefaultSlv  ( magia_tile_pkg::CORE_DATA_DEMUX_OBI_IDX ),
    .EnSerialSlv ( 1'b1                                    ),  // EU waits block like cv.elw
    .SerialSlv   ( magia_tile_pkg::CORE_DATA_DEMUX_EU_IDX  ),
    .req_t       ( magia_tile_pkg::core_data_req_t         ),
    .rsp_t       ( magia_tile_pkg::core_data_rsp_t         )
  ) i_core_data_demux (
    .clk_i            ( sys_clk                    ),
    .rst_ni           ( rst_ni                     ),
    .core_clock_en_i  ( core_clk_en                ),
    .core_data_req_i  ( core_data_req              ),
    .core_data_rsp_o  ( core_data_rsp              ),
    .slv_start_addr_i ( core_data_demux_start_addr ),
    .slv_end_addr_i   ( core_data_demux_end_addr   ),
    .slv_data_req_o   ( core_data_demux_req        ),
    .slv_data_rsp_i   ( core_data_demux_rsp        )
  );

  // Event Unit direct link, addressed relative to the EU window
  magia_tile_pkg::eu_direct_req_t eu_direct_req;
  magia_tile_pkg::eu_direct_rsp_t eu_direct_rsp;
  magia_tile_pkg::eu_direct_req_t eu_direct_req_cut;
  magia_tile_pkg::eu_direct_rsp_t eu_direct_rsp_cut;

  assign eu_direct_req.req   = core_data_demux_req[magia_tile_pkg::CORE_DATA_DEMUX_EU_IDX].req;
  assign eu_direct_req.addr  = core_data_demux_req[magia_tile_pkg::CORE_DATA_DEMUX_EU_IDX].addr - tile_event_unit_start_addr;
  assign eu_direct_req.wen   = ~core_data_demux_req[magia_tile_pkg::CORE_DATA_DEMUX_EU_IDX].we;
  assign eu_direct_req.wdata = core_data_demux_req[magia_tile_pkg::CORE_DATA_DEMUX_EU_IDX].wdata;
  assign eu_direct_req.be    = core_data_demux_req[magia_tile_pkg::CORE_DATA_DEMUX_EU_IDX].be;

  assign core_data_demux_rsp[magia_tile_pkg::CORE_DATA_DEMUX_EU_IDX].gnt    = eu_direct_rsp.gnt;
  assign core_data_demux_rsp[magia_tile_pkg::CORE_DATA_DEMUX_EU_IDX].rvalid = eu_direct_rsp.rvalid;
  assign core_data_demux_rsp[magia_tile_pkg::CORE_DATA_DEMUX_EU_IDX].rdata  = eu_direct_rsp.rdata;
  assign core_data_demux_rsp[magia_tile_pkg::CORE_DATA_DEMUX_EU_IDX].err    = eu_direct_rsp.err;
`ifdef CV32E40X
  assign core_data_demux_rsp[magia_tile_pkg::CORE_DATA_DEMUX_EU_IDX].exokay = 1'b0;
`endif

  eu_direct_cut #(
    .eu_direct_req_t ( magia_tile_pkg::eu_direct_req_t ),
    .eu_direct_rsp_t ( magia_tile_pkg::eu_direct_rsp_t ),
    .Bypass          ( 1'b0                            ),
    .BypassReq       ( 1'b0                            ),
    .BypassRsp       ( 1'b0                            ),
    .NB_CORES        ( 1                               )
  ) i_eu_direct_cut (
    .clk_i     ( sys_clk           ),
    .rst_ni    ( rst_ni            ),
    .sbr_req_i ( eu_direct_req     ),
    .sbr_rsp_o ( eu_direct_rsp     ),
    .mgr_req_o ( eu_direct_req_cut ),
    .mgr_rsp_i ( eu_direct_rsp_cut )
  );

  logic        eu_direct_req_flat;
  logic [31:0] eu_direct_addr_flat;
  logic        eu_direct_wen_flat;
  logic [31:0] eu_direct_wdata_flat;
  logic [3:0]  eu_direct_be_flat;
  logic        eu_direct_gnt_flat;
  logic        eu_direct_rvalid_flat;
  logic [31:0] eu_direct_rdata_flat;
  logic        eu_direct_err_flat;

  assign eu_direct_req_flat       = eu_direct_req_cut.req;
  assign eu_direct_addr_flat      = eu_direct_req_cut.addr;
  assign eu_direct_wen_flat       = eu_direct_req_cut.wen;
  assign eu_direct_wdata_flat     = eu_direct_req_cut.wdata;
  assign eu_direct_be_flat        = eu_direct_req_cut.be;
  assign eu_direct_rsp_cut.gnt    = eu_direct_gnt_flat;
  assign eu_direct_rsp_cut.rvalid = eu_direct_rvalid_flat;
  assign eu_direct_rsp_cut.rdata  = eu_direct_rdata_flat;
  assign eu_direct_rsp_cut.err    = eu_direct_err_flat;

  magia_tile_pkg::core_obi_data_req_t core_obi_data_req;
  magia_tile_pkg::core_obi_data_rsp_t core_obi_data_rsp;

  // Control core L1 port, connected to HCI in the L1 section
  magia_tile_pkg::core_obi_data_req_t core_l1_direct_obi_req;
  magia_tile_pkg::core_obi_data_rsp_t core_l1_direct_obi_rsp;
  magia_tile_pkg::core_obi_data_req_t core_l1_direct_amo_req;
  magia_tile_pkg::core_obi_data_rsp_t core_l1_direct_amo_rsp;
  tile_hci_data_req_t                 core_l1_direct_req;
  tile_hci_data_rsp_t                 core_l1_direct_rsp;

`ifdef CV32E40X
  cv32e40x_data2obi_req i_core_data2obi_req (
    .data_req_i ( core_data_demux_req[magia_tile_pkg::CORE_DATA_DEMUX_OBI_IDX] ),
    .obi_req_o  ( core_obi_data_req                                            )
  );

  cv32e40x_obi2data_rsp i_core_obi2data_rsp (
    .obi_rsp_i  ( core_obi_data_rsp                                            ),
    .data_rsp_o ( core_data_demux_rsp[magia_tile_pkg::CORE_DATA_DEMUX_OBI_IDX] )
  );

  cv32e40x_data2obi_req i_core_l1_direct_data2obi_req (
    .data_req_i ( core_data_demux_req[magia_tile_pkg::CORE_DATA_DEMUX_TCDM_IDX] ),
    .obi_req_o  ( core_l1_direct_obi_req                                        )
  );

  cv32e40x_obi2data_rsp i_core_l1_direct_obi2data_rsp (
    .obi_rsp_i  ( core_l1_direct_obi_rsp                                        ),
    .data_rsp_o ( core_data_demux_rsp[magia_tile_pkg::CORE_DATA_DEMUX_TCDM_IDX] )
  );

  // Atomics to the local L1 are resolved before HCI
  obi_atop_resolver #(
    .SbrPortObiCfg             ( magia_tile_pkg::obi_amo_cfg                ),
    .MgrPortObiCfg             ( obi_pkg::ObiDefaultConfig                  ),
    .sbr_port_obi_req_t        ( magia_tile_pkg::core_obi_data_req_t        ),
    .sbr_port_obi_rsp_t        ( magia_tile_pkg::core_obi_data_rsp_t        ),
    .mgr_port_obi_req_t        (                                            ),
    .mgr_port_obi_rsp_t        (                                            ),
    .mgr_port_obi_a_optional_t ( magia_tile_pkg::core_data_obi_a_optional_t ),
    .mgr_port_obi_r_optional_t ( magia_tile_pkg::core_data_obi_r_optional_t ),
    .LrScEnable                (                                            ),
    .RegisterAmo               ( magia_tile_pkg::RegisterAmo                )
  ) i_core_l1_direct_atomics (
    .clk_i          ( sys_clk                ),
    .rst_ni         ( rst_ni                 ),
    .testmode_i     ( test_mode_i            ),
    .sbr_port_req_i ( core_l1_direct_obi_req ),
    .sbr_port_rsp_o ( core_l1_direct_obi_rsp ),
    .mgr_port_req_o ( core_l1_direct_amo_req ),
    .mgr_port_rsp_i ( core_l1_direct_amo_rsp )
  );
`else
  cv32e40p_data2obi_req i_core_data2obi_req (
    .data_req_i ( core_data_demux_req[magia_tile_pkg::CORE_DATA_DEMUX_OBI_IDX] ),
    .obi_req_o  ( core_obi_data_req                                            )
  );

  cv32e40p_obi2data_rsp i_core_obi2data_rsp (
    .obi_rsp_i  ( core_obi_data_rsp                                            ),
    .data_rsp_o ( core_data_demux_rsp[magia_tile_pkg::CORE_DATA_DEMUX_OBI_IDX] )
  );

  cv32e40p_data2obi_req i_core_l1_direct_data2obi_req (
    .data_req_i ( core_data_demux_req[magia_tile_pkg::CORE_DATA_DEMUX_TCDM_IDX] ),
    .obi_req_o  ( core_l1_direct_obi_req                                        )
  );

  cv32e40p_obi2data_rsp i_core_l1_direct_obi2data_rsp (
    .obi_rsp_i  ( core_l1_direct_obi_rsp                                        ),
    .data_rsp_o ( core_data_demux_rsp[magia_tile_pkg::CORE_DATA_DEMUX_TCDM_IDX] )
  );

  // No atomics on the CV32E40P
  assign core_l1_direct_amo_req = core_l1_direct_obi_req;
  assign core_l1_direct_obi_rsp = core_l1_direct_amo_rsp;
`endif

  obi2hci_req #(
    .obi_req_t ( magia_tile_pkg::core_obi_data_req_t ),
    .hci_req_t ( tile_hci_data_req_t                 )
  ) i_core_l1_direct_obi2hci_req (
    .obi_req_i ( core_l1_direct_amo_req ),
    .hci_req_o ( core_l1_direct_req     )
  );

  hci2obi_rsp #(
    .hci_rsp_t ( tile_hci_data_rsp_t                 ),
    .obi_rsp_t ( magia_tile_pkg::core_obi_data_rsp_t )
  ) i_core_l1_direct_hci2obi_rsp (
    .hci_rsp_i ( core_l1_direct_rsp     ),
    .obi_rsp_o ( core_l1_direct_amo_rsp )
  );

/*******************************************************/
/**            Control Core Data Path End             **/
/*******************************************************/
/**               OBI Crossbar Beginning              **/
/*******************************************************/

  // Managers, indexed by ObiMgr: core, ext, spatz, cluster cores
  magia_tile_pkg::core_obi_data_req_t[ObiMgr.num_mgr-1:0] obi_xbar_slv_req;
  magia_tile_pkg::core_obi_data_rsp_t[ObiMgr.num_mgr-1:0] obi_xbar_slv_rsp;
  magia_tile_pkg::core_obi_data_req_t[ObiMgr.num_mgr-1:0] obi_xbar_slv_cut_req;
  magia_tile_pkg::core_obi_data_rsp_t[ObiMgr.num_mgr-1:0] obi_xbar_slv_cut_rsp;

  // Subordinates, indexed by ObiSbr: l2, l1, eu, ctrl, cluster_eu
  magia_tile_pkg::core_obi_data_req_t[ObiSbr.num_sbr-1:0] core_mem_data_cut_req;
  magia_tile_pkg::core_obi_data_rsp_t[ObiSbr.num_sbr-1:0] core_mem_data_cut_rsp;
  magia_tile_pkg::core_obi_data_req_t[ObiSbr.num_sbr-1:0] core_mem_data_req;
  magia_tile_pkg::core_obi_data_rsp_t[ObiSbr.num_sbr-1:0] core_mem_data_rsp;

  // Remote accesses from the AXI crossbar
  magia_tile_pkg::core_obi_data_req_t ext_obi_data_req;
  magia_tile_pkg::core_obi_data_rsp_t ext_obi_data_rsp;

  assign obi_xbar_slv_req[ObiMgr.core] = core_obi_data_req;
  assign core_obi_data_rsp             = obi_xbar_slv_rsp[ObiMgr.core];
  assign obi_xbar_slv_req[ObiMgr.ext]  = ext_obi_data_req;
  assign ext_obi_data_rsp              = obi_xbar_slv_rsp[ObiMgr.ext];

  localparam int unsigned RuleL2    = 0;
  localparam int unsigned RuleL1    = 1;
  localparam int unsigned RuleRes   = 2;
  localparam int unsigned RuleStack = 3;
  localparam int unsigned RuleEu    = 4;
  localparam int unsigned RuleCtrl  = 5;  // First of CtrlMap.num_units rules
  localparam int unsigned RuleClusterEu = RuleCtrl + CtrlMap.num_units;

  magia_tile_pkg::obi_xbar_rule_t[ObiSbr.num_rules-1:0]                        obi_xbar_rule;
  logic[ObiMgr.num_mgr-1:0]                                                    obi_xbar_en_default_idx;
  logic[ObiMgr.num_mgr-1:0][magia_tile_pkg::gen_idx_width(ObiSbr.num_sbr)-1:0] obi_xbar_default_idx;

  assign obi_xbar_rule[RuleL2]    = '{idx: ObiSbr.l2, start_addr: magia_tile_pkg::L2_ADDR_START,    end_addr: magia_tile_pkg::L2_ADDR_END   };
  assign obi_xbar_rule[RuleL1]    = '{idx: ObiSbr.l1, start_addr: tile_l1_start_addr,               end_addr: tile_l1_end_addr              };
  assign obi_xbar_rule[RuleRes]   = '{idx: ObiSbr.l1, start_addr: tile_reserved_start_addr,         end_addr: tile_reserved_end_addr        };
  assign obi_xbar_rule[RuleStack] = '{idx: ObiSbr.l1, start_addr: magia_tile_pkg::STACK_ADDR_START, end_addr: magia_tile_pkg::STACK_ADDR_END};
  assign obi_xbar_rule[RuleEu]    = '{idx: ObiSbr.eu, start_addr: tile_event_unit_start_addr,       end_addr: tile_event_unit_end_addr      };

  // Disabled control units have no rule: their range falls to L2, where the assertions catch it
  for (genvar i = 0; i < CtrlMap.num_units; i++) begin: gen_ctrl_rule
    assign obi_xbar_rule[RuleCtrl+i] = '{idx: ObiSbr.ctrl, start_addr: CtrlRules[i].start_addr, end_addr: CtrlRules[i].end_addr};
  end

  if (TileCfg.EnCluster) begin: gen_cluster_eu_rule
    assign obi_xbar_rule[RuleClusterEu] = '{idx: ObiSbr.cluster_eu, start_addr: magia_tile_pkg::CLUSTER_EU_ADDR_START, end_addr: magia_tile_pkg::CLUSTER_EU_ADDR_END};
  end

  // Anything outside L1 and the control registers goes to the AXI crossbar
  assign obi_xbar_en_default_idx = '1;
  assign obi_xbar_default_idx    = '0;

  // The core and the cluster cores enter the crossbar directly, ext and Spatz through a cut
  assign obi_xbar_slv_cut_req[ObiMgr.core] = obi_xbar_slv_req[ObiMgr.core];
  assign obi_xbar_slv_rsp[ObiMgr.core]     = obi_xbar_slv_cut_rsp[ObiMgr.core];

  obi_cut #(
    .ObiCfg       ( magia_tile_pkg::obi_amo_cfg            ),
    .obi_a_chan_t ( magia_tile_pkg::core_data_obi_a_chan_t ),
    .obi_r_chan_t ( magia_tile_pkg::core_data_obi_r_chan_t ),
    .obi_req_t    ( magia_tile_pkg::core_obi_data_req_t    ),
    .obi_rsp_t    ( magia_tile_pkg::core_obi_data_rsp_t    )
  ) i_obi_cut_ext (
    .clk_i          ( sys_clk                          ),
    .rst_ni         ( rst_ni                           ),
    .sbr_port_req_i ( obi_xbar_slv_req[ObiMgr.ext]     ),
    .sbr_port_rsp_o ( obi_xbar_slv_rsp[ObiMgr.ext]     ),
    .mgr_port_req_o ( obi_xbar_slv_cut_req[ObiMgr.ext] ),
    .mgr_port_rsp_i ( obi_xbar_slv_cut_rsp[ObiMgr.ext] )
  );

  if (TileCfg.EnSpatzCC) begin: gen_spatz_obi_cut
    obi_cut #(
      .ObiCfg       ( magia_tile_pkg::obi_amo_cfg            ),
      .obi_a_chan_t ( magia_tile_pkg::core_data_obi_a_chan_t ),
      .obi_r_chan_t ( magia_tile_pkg::core_data_obi_r_chan_t ),
      .obi_req_t    ( magia_tile_pkg::core_obi_data_req_t    ),
      .obi_rsp_t    ( magia_tile_pkg::core_obi_data_rsp_t    )
    ) i_obi_cut_spatz (
      .clk_i          ( sys_clk                            ),
      .rst_ni         ( rst_ni                             ),
      .sbr_port_req_i ( obi_xbar_slv_req[ObiMgr.spatz]     ),
      .sbr_port_rsp_o ( obi_xbar_slv_rsp[ObiMgr.spatz]     ),
      .mgr_port_req_o ( obi_xbar_slv_cut_req[ObiMgr.spatz] ),
      .mgr_port_rsp_i ( obi_xbar_slv_cut_rsp[ObiMgr.spatz] )
    );
  end

  if (TileCfg.EnCluster) begin: gen_cluster_obi_passthrough
    for (genvar idx_core = 0; idx_core < NClusterCores; idx_core++) begin: gen_cluster_obi_cut_bypass
      assign obi_xbar_slv_cut_req[ObiMgr.cluster_base + idx_core] = obi_xbar_slv_req[ObiMgr.cluster_base + idx_core];
      assign obi_xbar_slv_rsp[ObiMgr.cluster_base + idx_core]     = obi_xbar_slv_cut_rsp[ObiMgr.cluster_base + idx_core];
    end
  end

  obi_xbar #(
    .SbrPortObiCfg      ( magia_tile_pkg::obi_amo_cfg            ),
    .MgrPortObiCfg      (                                        ),
    .sbr_port_obi_req_t ( magia_tile_pkg::core_obi_data_req_t    ),
    .sbr_port_a_chan_t  ( magia_tile_pkg::core_data_obi_a_chan_t ),
    .sbr_port_obi_rsp_t ( magia_tile_pkg::core_obi_data_rsp_t    ),
    .sbr_port_r_chan_t  ( magia_tile_pkg::core_data_obi_r_chan_t ),
    .mgr_port_obi_req_t (                                        ),
    .mgr_port_obi_rsp_t (                                        ),
    .NumSbrPorts        ( ObiMgr.num_mgr                         ),
    .NumMgrPorts        ( ObiSbr.num_sbr                         ),
    .NumMaxTrans        ( magia_tile_pkg::N_MAX_TRAN             ),
    .NumAddrRules       ( ObiSbr.num_rules                       ),
    .addr_map_rule_t    ( magia_tile_pkg::obi_xbar_rule_t        ),
    .UseIdForRouting    (                                        ),
    .Connectivity       (                                        )
  ) i_obi_xbar (
    .clk_i            ( sys_clk                 ),
    .rst_ni           ( rst_ni                  ),
    .testmode_i       ( test_mode_i             ),
    .sbr_ports_req_i  ( obi_xbar_slv_cut_req    ),
    .sbr_ports_rsp_o  ( obi_xbar_slv_cut_rsp    ),
    .mgr_ports_req_o  ( core_mem_data_cut_req   ),
    .mgr_ports_rsp_i  ( core_mem_data_cut_rsp   ),
    .addr_map_i       ( obi_xbar_rule           ),
    .en_default_idx_i ( obi_xbar_en_default_idx ),
    .default_idx_i    ( obi_xbar_default_idx    )
  );

  for (genvar i = 0; i < ObiSbr.num_sbr; i++) begin: gen_obi_xbar_mgr_cut
    obi_cut #(
      .ObiCfg       ( magia_tile_pkg::obi_amo_cfg            ),
      .obi_a_chan_t ( magia_tile_pkg::core_data_obi_a_chan_t ),
      .obi_r_chan_t ( magia_tile_pkg::core_data_obi_r_chan_t ),
      .obi_req_t    ( magia_tile_pkg::core_obi_data_req_t    ),
      .obi_rsp_t    ( magia_tile_pkg::core_obi_data_rsp_t    )
    ) i_obi_xbar_mgr_cut (
      .clk_i          ( sys_clk                  ),
      .rst_ni         ( rst_ni                   ),
      .sbr_port_req_i ( core_mem_data_cut_req[i] ),
      .sbr_port_rsp_o ( core_mem_data_cut_rsp[i] ),
      .mgr_port_req_o ( core_mem_data_req[i]     ),
      .mgr_port_rsp_i ( core_mem_data_rsp[i]     )
    );
  end

`ifndef SYNTHESIS
  if (!TileCfg.EnRedMule) begin: gen_assert_no_redmule_access
    assert property (@(posedge sys_clk) disable iff (!rst_ni)
      !(core_mem_data_req[ObiSbr.l2].req &&
        core_mem_data_req[ObiSbr.l2].a.addr >= magia_tile_pkg::REDMULE_CTRL_ADDR_START &&
        core_mem_data_req[ObiSbr.l2].a.addr <  magia_tile_pkg::REDMULE_CTRL_ADDR_END))
      else $error("magia_isle: OBI access to RedMulE ctrl range (0x%08x) but RedMulE is disabled",
                  core_mem_data_req[ObiSbr.l2].a.addr);
  end
`ifndef MAGIA_FSYNC
  assert property (@(posedge sys_clk) disable iff (!rst_ni)
    !(core_mem_data_req[ObiSbr.l2].req &&
      core_mem_data_req[ObiSbr.l2].a.addr >= magia_tile_pkg::FSYNC_CTRL_ADDR_START &&
      core_mem_data_req[ObiSbr.l2].a.addr <  magia_tile_pkg::FSYNC_CTRL_ADDR_END))
    else $error("magia_isle: OBI access to FractalSync ctrl range (0x%08x) but FractalSync is disabled",
                core_mem_data_req[ObiSbr.l2].a.addr);
`endif
  if (!TileCfg.EnTimer) begin: gen_assert_no_timer_access
    assert property (@(posedge sys_clk) disable iff (!rst_ni)
      !(core_mem_data_req[ObiSbr.l2].req &&
        core_mem_data_req[ObiSbr.l2].a.addr >= magia_tile_pkg::TIMER_ADDR_START &&
        core_mem_data_req[ObiSbr.l2].a.addr <  magia_tile_pkg::TIMER_ADDR_END))
      else $error("magia_isle: OBI access to timer range (0x%08x) but the timer is disabled",
                  core_mem_data_req[ObiSbr.l2].a.addr);
  end
  if (!TileCfg.EnSpatzCC) begin: gen_assert_no_spatz_access
    assert property (@(posedge sys_clk) disable iff (!rst_ni)
      !(core_mem_data_req[ObiSbr.l2].req &&
        core_mem_data_req[ObiSbr.l2].a.addr >= magia_tile_pkg::SPATZ_CTRL_ADDR_START &&
        core_mem_data_req[ObiSbr.l2].a.addr <  magia_tile_pkg::SPATZ_CTRL_ADDR_END))
      else $error("magia_isle: OBI access to Spatz ctrl range (0x%08x) but Spatz CC is disabled",
                  core_mem_data_req[ObiSbr.l2].a.addr);
  end
  if (!TileCfg.EnCluster) begin: gen_assert_no_cluster_access
    assert property (@(posedge sys_clk) disable iff (!rst_ni)
      !(core_mem_data_req[ObiSbr.l2].req &&
        core_mem_data_req[ObiSbr.l2].a.addr >= magia_tile_pkg::CLUSTER_CTRL_ADDR_START &&
        core_mem_data_req[ObiSbr.l2].a.addr <  magia_tile_pkg::CLUSTER_CTRL_ADDR_END))
      else $error("magia_isle: OBI access to cluster ctrl range (0x%08x) but the PULP cluster is disabled",
                  core_mem_data_req[ObiSbr.l2].a.addr);
    assert property (@(posedge sys_clk) disable iff (!rst_ni)
      !(core_mem_data_req[ObiSbr.l2].req &&
        core_mem_data_req[ObiSbr.l2].a.addr >= magia_tile_pkg::CLUSTER_EU_ADDR_START &&
        core_mem_data_req[ObiSbr.l2].a.addr <  magia_tile_pkg::CLUSTER_EU_ADDR_END))
      else $error("magia_isle: OBI access to cluster Event Unit range (0x%08x) but the PULP cluster is disabled",
                  core_mem_data_req[ObiSbr.l2].a.addr);
  end
  if (!TileCfg.EnCollective) begin: gen_assert_no_coll_access
    assert property (@(posedge sys_clk) disable iff (!rst_ni)
      !(core_mem_data_req[ObiSbr.l2].req &&
        core_mem_data_req[ObiSbr.l2].a.addr >= magia_tile_pkg::COLL_CTRL_ADDR_START &&
        core_mem_data_req[ObiSbr.l2].a.addr <  magia_tile_pkg::COLL_CTRL_ADDR_END))
      else $error("magia_isle: OBI access to collective ctrl range (0x%08x) but narrow collectives are disabled",
                  core_mem_data_req[ObiSbr.l2].a.addr);
  end
`endif

/*******************************************************/
/**                  OBI Crossbar End                 **/
/*******************************************************/
/**                Event Unit Beginning               **/
/*******************************************************/

  // Every event source drives its own slice in its section
  magia_tile_pkg::eu_events_t eu_events;
  logic                       eu_core_busy;

  assign eu_events.other[magia_tile_pkg::EU_OTHER_CLUSTER_DONE-1 : 0] = '0;
  assign eu_events.other[magia_tile_pkg::EU_OTHER_SPATZ_START-1  :
                         magia_tile_pkg::EU_OTHER_CLUSTER_DONE+1] = '0;

  assign eu_core_busy = ~core_sleep_o;

  magia_event_unit #(
    .NB_CORES        ( 1  ),
    .NB_SW_EVT       ( 1  ),
    .NB_BARR         ( 2  ),
    .NB_HW_MUT       ( 1  ),
    .MUTEX_MSG_W     ( 32 ),
    .DISP_FIFO_DEPTH ( 1  ),
    .EVNT_WIDTH      ( 8  ),
    .SOC_FIFO_DEPTH  ( 8  )
  ) i_magia_event_unit (
    .clk_i              ( sys_clk                      ),
    .rst_ni             ( rst_ni                       ),
    .test_mode_i        ( test_mode_i                  ),

    .acc_events_i       ( eu_events.acc                ),
    .dma_events_i       ( eu_events.dma                ),
    .timer_events_i     ( eu_events.timer              ),
    .other_events_i     ( eu_events.other              ),

    // Pending events enabled in the EU IRQ mask
    .core_irq_req_o     ( eu_irq_req_o                 ),
    .core_irq_id_o      ( eu_irq_id_o                  ),
    .core_irq_ack_i     ( eu_irq_ack_i                 ),
    .core_irq_ack_id_i  ( eu_irq_ack_id_i              ),

    .core_busy_i        ( eu_core_busy                 ),
    .core_clock_en_o    ( eu_core_clk_en               ),

    .dbg_req_i          ( debug_req_i                  ),
    .core_dbg_req_o     ( eu_core_dbg_req              ),

    .eu_direct_req_i    ( eu_direct_req_flat           ),
    .eu_direct_addr_i   ( eu_direct_addr_flat          ),
    .eu_direct_wen_i    ( eu_direct_wen_flat           ),
    .eu_direct_wdata_i  ( eu_direct_wdata_flat         ),
    .eu_direct_be_i     ( eu_direct_be_flat            ),
    .eu_direct_gnt_o    ( eu_direct_gnt_flat           ),
    .eu_direct_rvalid_o ( eu_direct_rvalid_flat        ),
    .eu_direct_rdata_o  ( eu_direct_rdata_flat         ),
    .eu_direct_err_o    ( eu_direct_err_flat           ),

    .soc_periph_evt_valid_i ( 1'b0                     ),
    .soc_periph_evt_ready_o (                          ),
    .soc_periph_evt_data_i  ( '0                       ),

    .obi_req_i          ( core_mem_data_req[ObiSbr.eu] ),
    .obi_rsp_o          ( core_mem_data_rsp[ObiSbr.eu] )
  );

/*******************************************************/
/**                   Event Unit End                  **/
/*******************************************************/
/**            Control Registers Beginning            **/
/*******************************************************/

  // One port per enabled control unit, indexed by CtrlMap
  magia_tile_pkg::core_obi_data_req_t[CtrlMap.num_units-1:0] ctrl_req;
  magia_tile_pkg::core_obi_data_rsp_t[CtrlMap.num_units-1:0] ctrl_rsp;

  ctrl_demux #(
    .TileCfg ( TileCfg )
  ) i_ctrl_demux (
    .clk_i      ( sys_clk                        ),
    .rst_ni     ( rst_ni                         ),
    .obi_req_i  ( core_mem_data_req[ObiSbr.ctrl] ),
    .obi_rsp_o  ( core_mem_data_rsp[ObiSbr.ctrl] ),
    .unit_req_o ( ctrl_req                       ),
    .unit_rsp_i ( ctrl_rsp                       )
  );

  logic[31:0] collective_mask;
  logic[3:0]  collective_op;

  if (TileCfg.EnCollective) begin: gen_collective_ctrl
    obi_slave_ctrl_coll #(
      .BaseAddr ( magia_tile_pkg::COLL_CTRL_ADDR_START )
    ) i_collective_ctrl (
      .clk_i             ( sys_clk                ),
      .rst_ni            ( rst_ni                 ),
      .obi_req_i         ( ctrl_req[CtrlMap.coll] ),
      .obi_rsp_o         ( ctrl_rsp[CtrlMap.coll] ),
      .collective_mask_o ( collective_mask        ),
      .collective_op_o   ( collective_op          )
    );
  end else begin: gen_no_collective_ctrl
    assign collective_mask = '0;
    assign collective_op   = '0;
  end

  // Tile timer: its two comparators are the timer events of the Event Unit
  if (TileCfg.EnTimer) begin: gen_timer
    obi_slave_timer #(
      .obi_req_t ( magia_tile_pkg::core_obi_data_req_t ),
      .obi_rsp_t ( magia_tile_pkg::core_obi_data_rsp_t )
    ) i_tile_timer (
      .clk_i     ( sys_clk                  ),
      .rst_ni    ( rst_ni                   ),
      .obi_req_i ( ctrl_req[CtrlMap.timer]  ),
      .obi_rsp_o ( ctrl_rsp[CtrlMap.timer]  ),
      .irq_lo_o  ( eu_events.timer[0]       ),
      .irq_hi_o  ( eu_events.timer[1]       )
    );
  end else begin: gen_no_timer
    assign eu_events.timer = '0;
  end

/*******************************************************/
/**               Control Registers End               **/
/*******************************************************/
/**         AXI Crossbar and NoC Ports Beginning      **/
/*******************************************************/

  magia_tile_pkg::core_axi_data_req_t core_l2_data_req;
  magia_tile_pkg::core_axi_data_rsp_t core_l2_data_rsp;

  logic[magia_tile_pkg::AXI_DATA_U_W-1:0] axi_data_user;
  logic[magia_tile_pkg::RUSER_WIDTH-1:0]  obi_rsp_data_user;

  assign axi_data_user     = '0;
  assign obi_rsp_data_user = '0;

  obi_to_axi #(
    .ObiCfg       ( magia_tile_pkg::obi_amo_cfg         ),
    .obi_req_t    ( magia_tile_pkg::core_obi_data_req_t ),
    .obi_rsp_t    ( magia_tile_pkg::core_obi_data_rsp_t ),
    .AxiLite      (                                     ),
    .AxiAddrWidth ( magia_pkg::ADDR_W                   ),
    .AxiDataWidth ( magia_pkg::DATA_W                   ),
    .AxiUserWidth ( magia_tile_pkg::AXI_DATA_U_W        ),
    .AxiBurstType (                                     ),
    .axi_req_t    ( magia_tile_pkg::core_axi_data_req_t ),
    .axi_rsp_t    ( magia_tile_pkg::core_axi_data_rsp_t ),
    .MaxRequests  ( 1                                   )
  ) i_core_data_obi2axi (
    .clk_i               ( sys_clk                      ),
    .rst_ni              ( rst_ni                       ),
    .obi_req_i           ( core_mem_data_req[ObiSbr.l2] ),
    .obi_rsp_o           ( core_mem_data_rsp[ObiSbr.l2] ),
    .user_i              ( axi_data_user                ),
    .axi_req_o           ( core_l2_data_req             ),
    .axi_rsp_i           ( core_l2_data_rsp             ),
    .axi_rsp_channel_sel (                              ),
    .axi_rsp_b_user_o    (                              ),
    .axi_rsp_r_user_o    (                              ),
    .obi_rsp_user_i      ( obi_rsp_data_user            )
  );

  // Subordinate ports: core instr/data, NoC, Spatz and cluster i$ (see AXI_SLV_*_IDX)
  magia_tile_pkg::axi_xbar_slv_req_t[magia_tile_pkg::AxiXbarNoSlvPorts-1:0] axi_xbar_slv_req;
  magia_tile_pkg::axi_xbar_slv_rsp_t[magia_tile_pkg::AxiXbarNoSlvPorts-1:0] axi_xbar_slv_rsp;
  // Manager ports: ext, OBI crossbar and Spatz bootrom (see AxiMst)
  magia_pkg::axi_xbar_mst_req_t[AxiXbarCfg.NoMstPorts-1:0]                  axi_xbar_mst_req;
  magia_pkg::axi_xbar_mst_rsp_t[AxiXbarCfg.NoMstPorts-1:0]                  axi_xbar_mst_rsp;

  axi_pkg::xbar_rule_32_t[AxiXbarCfg.NoAddrRules-1:0] axi_xbar_rule;
  logic[AxiXbarCfg.NoSlvPorts-1:0]                    en_default_mst_port;

  assign axi_xbar_slv_req[magia_tile_pkg::AXI_SLV_CORE_DATA_IDX]  = core_l2_data_req;
  assign core_l2_data_rsp                                         = axi_xbar_slv_rsp[magia_tile_pkg::AXI_SLV_CORE_DATA_IDX];
  assign axi_xbar_slv_req[magia_tile_pkg::AXI_SLV_CORE_INSTR_IDX] = core_l2_instr_req;
  assign core_l2_instr_rsp                                        = axi_xbar_slv_rsp[magia_tile_pkg::AXI_SLV_CORE_INSTR_IDX];
  assign axi_xbar_slv_req[magia_tile_pkg::AXI_SLV_EXT_IDX]        = axi_narrow_slv_req_i;
  assign axi_narrow_slv_rsp_o                                     = axi_xbar_slv_rsp[magia_tile_pkg::AXI_SLV_EXT_IDX];

  assign axi_xbar_rule[0] = '{idx: AxiMst.ext, start_addr: magia_tile_pkg::L2_ADDR_START, end_addr: magia_tile_pkg::L2_ADDR_END};
  assign axi_xbar_rule[1] = '{idx: AxiMst.obi, start_addr: tile_l1_start_addr,            end_addr: tile_l1_end_addr           };
  assign axi_xbar_rule[2] = '{idx: AxiMst.obi, start_addr: tile_reserved_start_addr,      end_addr: tile_reserved_end_addr     };
  if (TileCfg.EnSpatzCC) begin: gen_axi_bootrom_rule
    assign axi_xbar_rule[3] = '{idx: AxiMst.bootrom, start_addr: magia_tile_pkg::SPATZ_BOOT_ADDR, end_addr: magia_tile_pkg::SPATZ_BOOT_ADDR + magia_tile_pkg::SPATZ_BOOTROM_SIZE};
  end

  // Unmapped addresses (other tiles, prints) leave through the ext port
  assign en_default_mst_port = '1;

  axi_xbar #(
    .Cfg           ( AxiXbarCfg                             ),
    .ATOPs         (                                        ),
    .Connectivity  (                                        ),
    .slv_aw_chan_t ( magia_tile_pkg::axi_xbar_slv_aw_chan_t ),
    .mst_aw_chan_t ( magia_pkg::axi_xbar_mst_aw_chan_t      ),
    .w_chan_t      ( magia_pkg::axi_xbar_mst_w_chan_t       ),
    .slv_b_chan_t  ( magia_tile_pkg::axi_xbar_slv_b_chan_t  ),
    .mst_b_chan_t  ( magia_pkg::axi_xbar_mst_b_chan_t       ),
    .slv_ar_chan_t ( magia_tile_pkg::axi_xbar_slv_ar_chan_t ),
    .mst_ar_chan_t ( magia_pkg::axi_xbar_mst_ar_chan_t      ),
    .slv_r_chan_t  ( magia_tile_pkg::axi_xbar_slv_r_chan_t  ),
    .mst_r_chan_t  ( magia_pkg::axi_xbar_mst_r_chan_t       ),
    .slv_req_t     ( magia_tile_pkg::axi_xbar_slv_req_t     ),
    .mst_req_t     ( magia_pkg::axi_xbar_mst_req_t          ),
    .slv_resp_t    ( magia_tile_pkg::axi_xbar_slv_rsp_t     ),
    .mst_resp_t    ( magia_pkg::axi_xbar_mst_rsp_t          ),
    .rule_t        ( axi_pkg::xbar_rule_32_t                )
  ) i_axi_xbar (
    .clk_i                 ( sys_clk             ),
    .rst_ni                ( rst_ni              ),
    .test_i                ( test_mode_i         ),
    .slv_ports_req_i       ( axi_xbar_slv_req    ),
    .slv_ports_resp_o      ( axi_xbar_slv_rsp    ),
    .mst_ports_req_o       ( axi_xbar_mst_req    ),
    .mst_ports_resp_i      ( axi_xbar_mst_rsp    ),
    .addr_map_i            ( axi_xbar_rule       ),
    .en_default_mst_port_i ( en_default_mst_port ),
    .default_mst_port_i    ( '0                  )
  );

  // Writes to the collective window get the mask and op from the collective registers
  if (TileCfg.EnCollective) begin: gen_collective_gen
    collective_gen i_coll_gen (
      .clk_i             ( sys_clk                      ),
      .rst_ni            ( rst_ni                       ),
      .collective_mask_i ( collective_mask              ),
      .collective_op_i   ( collective_op                ),
      .data_req_i        ( axi_xbar_mst_req[AxiMst.ext] ),
      .data_req_o        ( axi_narrow_mst_req_o         )
    );
  end else begin: gen_no_collective_gen
    assign axi_narrow_mst_req_o = axi_xbar_mst_req[AxiMst.ext];
  end

  assign axi_xbar_mst_rsp[AxiMst.ext] = axi_narrow_mst_rsp_i;

  // Remote accesses to this tile's L1 and reserved region reach the OBI crossbar
  logic[magia_tile_pkg::AID_WIDTH-1:0]   axi2obi_req_write_aid;
  logic[magia_tile_pkg::AUSER_WIDTH-1:0] axi2obi_req_write_auser;
  logic[magia_tile_pkg::WUSER_WIDTH-1:0] axi2obi_req_write_wuser;
  logic[magia_tile_pkg::AID_WIDTH-1:0]   axi2obi_req_read_aid;
  logic[magia_tile_pkg::AUSER_WIDTH-1:0] axi2obi_req_read_auser;
  logic[magia_pkg::AXI_NOC_U_W-1:0]      axi2obi_rsp_b_user;
  logic[magia_pkg::AXI_NOC_U_W-1:0]      axi2obi_rsp_r_user;

  assign axi2obi_req_write_aid   = '0;
  assign axi2obi_req_write_auser = '0;
  assign axi2obi_req_write_wuser = '0;
  assign axi2obi_req_read_aid    = '0;
  assign axi2obi_req_read_auser  = '0;
  assign axi2obi_rsp_b_user      = '0;
  assign axi2obi_rsp_r_user      = '0;

  axi_to_obi #(
    .ObiCfg       ( magia_tile_pkg::obi_amo_cfg            ),
    .obi_req_t    ( magia_tile_pkg::core_obi_data_req_t    ),
    .obi_rsp_t    ( magia_tile_pkg::core_obi_data_rsp_t    ),
    .obi_a_chan_t ( magia_tile_pkg::core_data_obi_a_chan_t ),
    .obi_r_chan_t ( magia_tile_pkg::core_data_obi_r_chan_t ),
    .AxiAddrWidth ( magia_pkg::ADDR_W                      ),
    .AxiDataWidth ( magia_pkg::DATA_W                      ),
    .AxiIdWidth   ( magia_pkg::AXI_NOC_ID_W                ),
    .AxiUserWidth ( magia_pkg::AXI_NOC_U_W                 ),
    .MaxTrans     ( 8                                      ),
    .axi_req_t    ( magia_pkg::axi_xbar_mst_req_t          ),
    .axi_rsp_t    ( magia_pkg::axi_xbar_mst_rsp_t          )
  ) i_ext_data_axi2obi (
    .clk_i                  ( sys_clk                      ),
    .rst_ni                 ( rst_ni                       ),
    .testmode_i             ( test_mode_i                  ),
    .axi_req_i              ( axi_xbar_mst_req[AxiMst.obi] ),
    .axi_rsp_o              ( axi_xbar_mst_rsp[AxiMst.obi] ),
    .obi_req_o              ( ext_obi_data_req             ),
    .obi_rsp_i              ( ext_obi_data_rsp             ),
    .req_aw_id_o            (                              ),
    .req_aw_user_o          (                              ),
    .req_w_user_o           (                              ),
    .req_write_aid_i        ( axi2obi_req_write_aid        ),
    .req_write_auser_i      ( axi2obi_req_write_auser      ),
    .req_write_wuser_i      ( axi2obi_req_write_wuser      ),
    .req_ar_id_o            (                              ),
    .req_ar_user_o          (                              ),
    .req_read_aid_i         ( axi2obi_req_read_aid         ),
    .req_read_auser_i       ( axi2obi_req_read_auser       ),
    .rsp_write_aw_user_o    (                              ),
    .rsp_write_w_user_o     (                              ),
    .rsp_write_bank_strb_o  (                              ),
    .rsp_write_rid_o        (                              ),
    .rsp_write_ruser_o      (                              ),
    .rsp_write_last_o       (                              ),
    .rsp_write_hs_o         (                              ),
    .rsp_b_user_i           ( axi2obi_rsp_b_user           ),
    .rsp_read_ar_user_o     (                              ),
    .rsp_read_size_enable_o (                              ),
    .rsp_read_rid_o         (                              ),
    .rsp_read_ruser_o       (                              ),
    .rsp_r_user_i           ( axi2obi_rsp_r_user           )
  );

/*******************************************************/
/**           AXI Crossbar and NoC Ports End          **/
/*******************************************************/
/**                L1 Memory Beginning                **/
/*******************************************************/

  localparam hci_package::hci_size_parameter_t `HCI_SIZE_PARAM(hci_tcdm_sram_if) = '{
    DW:  magia_tile_pkg::DW_LIC,
    AW:  L1BankAddrW,
    BW:  hci_package::DEFAULT_BW,
    UW:  magia_tile_pkg::UW_LIC,
    IW:  TileIW,
    EW:  hci_package::DEFAULT_EW,
    EHW: hci_package::DEFAULT_EHW
  };
  `HCI_INTF_ARRAY(hci_tcdm_sram_if, sys_clk, 0:NumMemBanks-1);

  // Core ports: [0] remote accesses from the OBI crossbar, then Spatz, cluster cores and the control core
  localparam hci_package::hci_size_parameter_t `HCI_SIZE_PARAM(hci_core_if) = '{
    DW:  magia_tile_pkg::DW_LIC,
    AW:  magia_tile_pkg::AWC,
    BW:  magia_pkg::BYTE_W,
    UW:  magia_tile_pkg::UW_LIC,
    IW:  TileIW,
    EW:  hci_package::DEFAULT_EW,
    EHW: hci_package::DEFAULT_EHW
  };
  `HCI_INTF_ARRAY(hci_core_if, sys_clk, 0:NumHciCore-1);

  localparam hci_package::hci_size_parameter_t `HCI_SIZE_PARAM(hci_redmule_if) = '{
    DW:  RedmuleDataW,
    AW:  magia_tile_pkg::AWH,
    BW:  hci_package::DEFAULT_BW,
    UW:  magia_tile_pkg::REDMULE_UW,
    IW:  TileIW,
    EW:  hci_package::DEFAULT_EW,
    EHW: hci_package::DEFAULT_EHW
  };
  // One element even without RedMulE: the tie-off drives it by name
  `HCI_INTF_ARRAY(hci_redmule_if, sys_clk, 0:0);

  localparam hci_package::hci_size_parameter_t `HCI_SIZE_PARAM(hci_dma_if) = '{
    DW:  magia_tile_pkg::iDMA_DataWidth,
    AW:  magia_tile_pkg::iDMA_AddrWidth,
    BW:  hci_package::DEFAULT_BW,
    UW:  magia_tile_pkg::iDMA_UserWidth,
    IW:  TileIW,
    EW:  hci_package::DEFAULT_EW,
    EHW: hci_package::DEFAULT_EHW
  };
  `HCI_INTF_ARRAY(hci_dma_if, sys_clk, 0:NumDma-1);

  localparam hci_package::hci_size_parameter_t `HCI_SIZE_PARAM(hci_ext_if) = '{
    DW:  magia_tile_pkg::DW_LIC,
    AW:  magia_tile_pkg::AWC,
    BW:  hci_package::DEFAULT_BW,
    UW:  magia_tile_pkg::UW_LIC,
    IW:  hci_package::DEFAULT_IW,
    EW:  hci_package::DEFAULT_EW,
    EHW: hci_package::DEFAULT_EHW
  };
  if (NumExt > 0) begin: gen_hci_ext_if
    `HCI_INTF_ARRAY(hci_ext_if, sys_clk, 0:NumExt-1);
  end

  // Remote L1 accesses from the OBI crossbar: atomics are resolved before HCI
  magia_tile_pkg::core_obi_data_req_t ext_l1_data_amo_req;
  magia_tile_pkg::core_obi_data_rsp_t ext_l1_data_amo_rsp;
  tile_hci_data_req_t                 ext_l1_data_req;
  tile_hci_data_rsp_t                 ext_l1_data_rsp;

  obi_atop_resolver #(
    .SbrPortObiCfg             ( magia_tile_pkg::obi_amo_cfg                ),
    .MgrPortObiCfg             ( obi_pkg::ObiDefaultConfig                  ),
    .sbr_port_obi_req_t        ( magia_tile_pkg::core_obi_data_req_t        ),
    .sbr_port_obi_rsp_t        ( magia_tile_pkg::core_obi_data_rsp_t        ),
    .mgr_port_obi_req_t        (                                            ),
    .mgr_port_obi_rsp_t        (                                            ),
    .mgr_port_obi_a_optional_t ( magia_tile_pkg::core_data_obi_a_optional_t ),
    .mgr_port_obi_r_optional_t ( magia_tile_pkg::core_data_obi_r_optional_t ),
    .LrScEnable                (                                            ),
    .RegisterAmo               ( magia_tile_pkg::RegisterAmo                )
  ) i_obi_atomics (
    .clk_i          ( sys_clk                      ),
    .rst_ni         ( rst_ni                       ),
    .testmode_i     ( test_mode_i                  ),
    .sbr_port_req_i ( core_mem_data_req[ObiSbr.l1] ),
    .sbr_port_rsp_o ( core_mem_data_rsp[ObiSbr.l1] ),
    .mgr_port_req_o ( ext_l1_data_amo_req          ),
    .mgr_port_rsp_i ( ext_l1_data_amo_rsp          )
  );

  obi2hci_req #(
    .obi_req_t ( magia_tile_pkg::core_obi_data_req_t ),
    .hci_req_t ( tile_hci_data_req_t                 )
  ) i_ext_l1_data_obi2hci_req (
    .obi_req_i ( ext_l1_data_amo_req ),
    .hci_req_o ( ext_l1_data_req     )
  );

  hci2obi_rsp #(
    .hci_rsp_t ( tile_hci_data_rsp_t                 ),
    .obi_rsp_t ( magia_tile_pkg::core_obi_data_rsp_t )
  ) i_ext_l1_data_hci2obi_rsp (
    .hci_rsp_i ( ext_l1_data_rsp     ),
    .obi_rsp_o ( ext_l1_data_amo_rsp )
  );

  `HCI_ASSIGN_TO_INTF(hci_core_if[0],            ext_l1_data_req,    ext_l1_data_rsp)
  `HCI_ASSIGN_TO_INTF(hci_core_if[NumHciCore-1], core_l1_direct_req, core_l1_direct_rsp)

  logic                                hci_clear;
  hci_package::hci_interconnect_ctrl_t hci_ctrl;

  assign hci_clear = 1'b0;

  // Arbitration policy between accelerators and cores, set by software
  obi_slave_ctrl_hci #(
    .BaseAddr ( magia_tile_pkg::HCI_CTRL_ADDR_START )
  ) i_hci_ctrl (
    .clk_i     ( sys_clk               ),
    .rst_ni    ( rst_ni                ),
    .obi_req_i ( ctrl_req[CtrlMap.hci] ),
    .obi_rsp_o ( ctrl_rsp[CtrlMap.hci] ),
    .ctrl_o    ( hci_ctrl              )
  );

  magia_hci_interconnect #(
    .N_HWPE        ( NumHwpe                          ),
    .N_DMA         ( NumDma                           ),
    .N_CORE        ( NumHciCore                       ),
    .N_MEM         ( NumMemBanks                      ),
    .EXPFIFO       ( magia_tile_pkg::EXPFIFO          ),
    .MEM_DATA_W    ( magia_tile_pkg::DW_LIC           ),
    .MEM_ADDR_W    ( L1BankAddrW                      ),
    .MEM_BYTE_W    ( magia_tile_pkg::BW_LIC           ),
    .MEM_USER_W    ( magia_tile_pkg::UW_LIC           ),
    .MEM_ID_W      ( TileIW                           ),
    .HCI_SIZE_hwpe ( `HCI_SIZE_PARAM(hci_redmule_if)  ),
    .HCI_SIZE_dma  ( `HCI_SIZE_PARAM(hci_dma_if)      ),
    .HCI_SIZE_core ( `HCI_SIZE_PARAM(hci_core_if)     ),
    .HCI_SIZE_mem  ( `HCI_SIZE_PARAM(hci_tcdm_sram_if))
  ) i_magia_hci_interconnect (
    .clk_i   ( sys_clk          ),
    .rst_ni  ( rst_ni           ),
    .clear_i ( hci_clear        ),
    .ctrl_i  ( hci_ctrl         ),
    .hwpe    ( hci_redmule_if   ),
    .dma     ( hci_dma_if       ),
    .core    ( hci_core_if      ),
    .mem     ( hci_tcdm_sram_if )
  );

  l1_spm #(
    .N_BANK   ( NumMemBanks       ),
    .N_WORDS  ( NumWordsBank      ),
    .DATA_W   ( magia_pkg::DATA_W ),
    .ID_W     ( TileIW            ),
    .SIM_INIT ( "zeros"           )
  ) i_l1_spm (
    .clk_i      ( sys_clk          ),
    .rst_ni     ( rst_ni           ),
    .tcdm_slave ( hci_tcdm_sram_if )
  );

`ifndef SYNTHESIS
  // spatz_tcdm_addr_t is sized from the package-level L1 geometry, shared by all tiles
  if (TileCfg.EnSpatzCC &&
      $clog2(NumMemBanks * NumWordsBank * magia_pkg::DATA_W / 8) > magia_tile_pkg::SPATZ_TCDM_ADDR_WIDTH) begin: gen_err_spatz_tcdm_addr_w
    $fatal(1, "magia_isle: TileCfg.L1 (%0d banks x %0d words) exceeds SPATZ_TCDM_ADDR_WIDTH=%0d",
           NumMemBanks, NumWordsBank, magia_tile_pkg::SPATZ_TCDM_ADDR_WIDTH);
  end
`endif

/*******************************************************/
/**                   L1 Memory End                   **/
/*******************************************************/
/**                   iDMA Beginning                  **/
/*******************************************************/

  // "out": L1 to NoC, "in": NoC to L1
  magia_tile_pkg::idma_axi_req_t idma_axi_read_req_out;
  magia_tile_pkg::idma_axi_rsp_t idma_axi_read_rsp_out;
  magia_tile_pkg::idma_axi_req_t idma_axi_write_req_out;
  magia_tile_pkg::idma_axi_rsp_t idma_axi_write_rsp_out;
  magia_tile_pkg::idma_obi_req_t idma_obi_read_req_out;
  magia_tile_pkg::idma_obi_rsp_t idma_obi_read_rsp_out;
  magia_tile_pkg::idma_obi_req_t idma_obi_write_req_out;
  magia_tile_pkg::idma_obi_rsp_t idma_obi_write_rsp_out;

  logic idma_clear;
  logic idma_axi2obi_start;
  logic idma_axi2obi_busy;
  logic idma_axi2obi_done;
  logic idma_axi2obi_error;
  logic idma_obi2axi_start;
  logic idma_obi2axi_busy;
  logic idma_obi2axi_done;
  logic idma_obi2axi_error;

  assign idma_clear = 1'b0;

  assign eu_events.dma[magia_tile_pkg::EU_DMA_A2O_DONE]      = idma_axi2obi_done;
  assign eu_events.dma[magia_tile_pkg::EU_DMA_O2A_DONE]      = idma_obi2axi_done;
  assign eu_events.other[magia_tile_pkg::EU_OTHER_A2O_ERROR] = idma_axi2obi_error;
  assign eu_events.other[magia_tile_pkg::EU_OTHER_O2A_ERROR] = idma_obi2axi_error;
  assign eu_events.other[magia_tile_pkg::EU_OTHER_A2O_START] = idma_axi2obi_start;
  assign eu_events.other[magia_tile_pkg::EU_OTHER_O2A_START] = idma_obi2axi_start;
  assign eu_events.other[magia_tile_pkg::EU_OTHER_A2O_BUSY]  = idma_axi2obi_busy;
  assign eu_events.other[magia_tile_pkg::EU_OTHER_O2A_BUSY]  = idma_obi2axi_busy;

  idma_ctrl_mm #(
    .ERROR_CAP         ( TileCfg.IDma.ErrorCap               ),
    .obi_req_t         ( magia_tile_pkg::core_obi_data_req_t ),
    .obi_rsp_t         ( magia_tile_pkg::core_obi_data_rsp_t ),
    .idma_fe_reg_req_t ( magia_tile_pkg::idma_fe_reg_req_t   ),
    .idma_fe_reg_rsp_t ( magia_tile_pkg::idma_fe_reg_rsp_t   ),
    .axi_req_t         ( magia_tile_pkg::idma_axi_req_t      ),
    .axi_rsp_t         ( magia_tile_pkg::idma_axi_rsp_t      ),
    .idma_obi_req_t    ( magia_tile_pkg::idma_obi_req_t      ),
    .idma_obi_rsp_t    ( magia_tile_pkg::idma_obi_rsp_t      )
  ) i_idma_ctrl_mm (
    .clk_i           ( sys_clk                ),
    .rst_ni          ( rst_ni                 ),
    .test_en_i       ( test_mode_i            ),
    .clear_i         ( idma_clear             ),

    .obi_req_i       ( ctrl_req[CtrlMap.idma] ),
    .obi_rsp_o       ( ctrl_rsp[CtrlMap.idma] ),

    .axi_read_req_o  ( idma_axi_read_req_out  ),
    .axi_read_rsp_i  ( idma_axi_read_rsp_out  ),
    .axi_write_req_o ( idma_axi_write_req_out ),
    .axi_write_rsp_i ( idma_axi_write_rsp_out ),

    .obi_read_req_o  ( idma_obi_read_req_out  ),
    .obi_read_rsp_i  ( idma_obi_read_rsp_out  ),
    .obi_write_req_o ( idma_obi_write_req_out ),
    .obi_write_rsp_i ( idma_obi_write_rsp_out ),

    .irq_a2o_busy_o  ( idma_axi2obi_busy      ),
    .irq_a2o_start_o ( idma_axi2obi_start     ),
    .irq_a2o_done_o  ( idma_axi2obi_done      ),
    .irq_a2o_error_o ( idma_axi2obi_error     ),
    .irq_o2a_busy_o  ( idma_obi2axi_busy      ),
    .irq_o2a_start_o ( idma_obi2axi_start     ),
    .irq_o2a_done_o  ( idma_obi2axi_done      ),
    .irq_o2a_error_o ( idma_obi2axi_error     )
  );

  axi_rw_join #(
    .axi_req_t  ( magia_tile_pkg::idma_axi_req_t ),
    .axi_resp_t ( magia_tile_pkg::idma_axi_rsp_t )
  ) i_axi_rw_join (
    .clk_i            ( sys_clk                ),
    .rst_ni           ( rst_ni                 ),
    .slv_read_req_i   ( idma_axi_read_req_out  ),
    .slv_read_resp_o  ( idma_axi_read_rsp_out  ),
    .slv_write_req_i  ( idma_axi_write_req_out ),
    .slv_write_resp_o ( idma_axi_write_rsp_out ),
    .mst_req_o        ( axi_wide_mst_req_o     ),
    .mst_resp_i       ( axi_wide_mst_rsp_i     )
  );

  magia_tile_pkg::idma_axi_req_t idma_axi_read_req_in;
  magia_tile_pkg::idma_axi_rsp_t idma_axi_read_rsp_in;
  magia_tile_pkg::idma_axi_req_t idma_axi_write_req_in;
  magia_tile_pkg::idma_axi_rsp_t idma_axi_write_rsp_in;
  magia_tile_pkg::idma_obi_req_t idma_obi_read_req_in;
  magia_tile_pkg::idma_obi_rsp_t idma_obi_read_rsp_in;
  magia_tile_pkg::idma_obi_req_t idma_obi_write_req_in;
  magia_tile_pkg::idma_obi_rsp_t idma_obi_write_rsp_in;

  axi_rw_split #(
    .axi_req_t  ( magia_tile_pkg::idma_axi_req_t ),
    .axi_resp_t ( magia_tile_pkg::idma_axi_rsp_t )
  ) i_axi_rw_split (
    .clk_i            ( sys_clk               ),
    .rst_ni           ( rst_ni                ),
    .slv_req_i        ( axi_wide_slv_req_i    ),
    .slv_resp_o       ( axi_wide_slv_rsp_o    ),
    .mst_read_req_o   ( idma_axi_read_req_in  ),
    .mst_read_resp_i  ( idma_axi_read_rsp_in  ),
    .mst_write_req_o  ( idma_axi_write_req_in ),
    .mst_write_resp_i ( idma_axi_write_rsp_in )
  );

  axi_to_obi #(
    .ObiCfg       ( magia_tile_pkg::obi_idma_cfg      ),
    .obi_req_t    ( magia_tile_pkg::idma_obi_req_t    ),
    .obi_rsp_t    ( magia_tile_pkg::idma_obi_rsp_t    ),
    .obi_a_chan_t ( magia_tile_pkg::idma_obi_a_chan_t ),
    .obi_r_chan_t ( magia_tile_pkg::idma_obi_r_chan_t ),
    .AxiAddrWidth ( iDMA_AddrWidth                    ),
    .AxiDataWidth ( iDMA_DataWidth                    ),
    .AxiIdWidth   ( iDMA_AxiIdWidth                   ),
    .AxiUserWidth ( iDMA_UserWidth                    ),
    .MaxTrans     ( 8                                 ),
    .axi_req_t    ( magia_tile_pkg::idma_axi_req_t    ),
    .axi_rsp_t    ( magia_tile_pkg::idma_axi_rsp_t    )
  ) i_idma_read_in_axi2obi (
    .clk_i                  ( sys_clk              ),
    .rst_ni                 ( rst_ni               ),
    .testmode_i             ( test_mode_i          ),
    .axi_req_i              ( idma_axi_read_req_in ),
    .axi_rsp_o              ( idma_axi_read_rsp_in ),
    .obi_req_o              ( idma_obi_read_req_in ),
    .obi_rsp_i              ( idma_obi_read_rsp_in ),
    .req_aw_id_o            (                      ),
    .req_aw_user_o          (                      ),
    .req_w_user_o           (                      ),
    .req_write_aid_i        ( '0                   ),
    .req_write_auser_i      ( '0                   ),
    .req_write_wuser_i      ( '0                   ),
    .req_ar_id_o            (                      ),
    .req_ar_user_o          (                      ),
    .req_read_aid_i         ( '0                   ),
    .req_read_auser_i       ( '0                   ),
    .rsp_write_aw_user_o    (                      ),
    .rsp_write_w_user_o     (                      ),
    .rsp_write_bank_strb_o  (                      ),
    .rsp_write_rid_o        (                      ),
    .rsp_write_ruser_o      (                      ),
    .rsp_write_last_o       (                      ),
    .rsp_write_hs_o         (                      ),
    .rsp_b_user_i           ( '0                   ),
    .rsp_read_ar_user_o     (                      ),
    .rsp_read_size_enable_o (                      ),
    .rsp_read_rid_o         (                      ),
    .rsp_read_ruser_o       (                      ),
    .rsp_r_user_i           ( '0                   )
  );

  axi_to_obi #(
    .ObiCfg       ( magia_tile_pkg::obi_idma_cfg      ),
    .obi_req_t    ( magia_tile_pkg::idma_obi_req_t    ),
    .obi_rsp_t    ( magia_tile_pkg::idma_obi_rsp_t    ),
    .obi_a_chan_t ( magia_tile_pkg::idma_obi_a_chan_t ),
    .obi_r_chan_t ( magia_tile_pkg::idma_obi_r_chan_t ),
    .AxiAddrWidth ( iDMA_AddrWidth                    ),
    .AxiDataWidth ( iDMA_DataWidth                    ),
    .AxiIdWidth   ( iDMA_AxiIdWidth                   ),
    .AxiUserWidth ( iDMA_UserWidth                    ),
    .MaxTrans     ( 8                                 ),
    .axi_req_t    ( magia_tile_pkg::idma_axi_req_t    ),
    .axi_rsp_t    ( magia_tile_pkg::idma_axi_rsp_t    )
  ) i_idma_write_in_axi2obi (
    .clk_i                  ( sys_clk               ),
    .rst_ni                 ( rst_ni                ),
    .testmode_i             ( test_mode_i           ),
    .axi_req_i              ( idma_axi_write_req_in ),
    .axi_rsp_o              ( idma_axi_write_rsp_in ),
    .obi_req_o              ( idma_obi_write_req_in ),
    .obi_rsp_i              ( idma_obi_write_rsp_in ),
    .req_aw_id_o            (                       ),
    .req_aw_user_o          (                       ),
    .req_w_user_o           (                       ),
    .req_write_aid_i        ( '0                    ),
    .req_write_auser_i      ( '0                    ),
    .req_write_wuser_i      ( '0                    ),
    .req_ar_id_o            (                       ),
    .req_ar_user_o          (                       ),
    .req_read_aid_i         ( '0                    ),
    .req_read_auser_i       ( '0                    ),
    .rsp_write_aw_user_o    (                       ),
    .rsp_write_w_user_o     (                       ),
    .rsp_write_bank_strb_o  (                       ),
    .rsp_write_rid_o        (                       ),
    .rsp_write_ruser_o      (                       ),
    .rsp_write_last_o       (                       ),
    .rsp_write_hs_o         (                       ),
    .rsp_b_user_i           ( '0                    ),
    .rsp_read_ar_user_o     (                       ),
    .rsp_read_size_enable_o (                       ),
    .rsp_read_rid_o         (                       ),
    .rsp_read_ruser_o       (                       ),
    .rsp_r_user_i           ( '0                    )
  );

  // Four L1 channels: out/in times read/write
  tile_idma_hci_req_t idma_hci_read_req_out;
  tile_idma_hci_rsp_t idma_hci_read_rsp_out;
  tile_idma_hci_req_t idma_hci_write_req_out;
  tile_idma_hci_rsp_t idma_hci_write_rsp_out;
  tile_idma_hci_req_t idma_hci_read_req_in;
  tile_idma_hci_rsp_t idma_hci_read_rsp_in;
  tile_idma_hci_req_t idma_hci_write_req_in;
  tile_idma_hci_rsp_t idma_hci_write_rsp_in;

  obi2hci_req #(
    .obi_req_t ( magia_tile_pkg::idma_obi_req_t ),
    .hci_req_t ( tile_idma_hci_req_t            )
  ) i_idma_out_obi2hci_req (
    .obi_req_i ( idma_obi_read_req_out ),
    .hci_req_o ( idma_hci_read_req_out )
  );

  hci2obi_rsp #(
    .hci_rsp_t ( tile_idma_hci_rsp_t            ),
    .obi_rsp_t ( magia_tile_pkg::idma_obi_rsp_t )
  ) i_idma_out_hci2obi_rsp (
    .hci_rsp_i ( idma_hci_read_rsp_out ),
    .obi_rsp_o ( idma_obi_read_rsp_out )
  );

  obi2hci_req #(
    .obi_req_t ( magia_tile_pkg::idma_obi_req_t ),
    .hci_req_t ( tile_idma_hci_req_t            )
  ) i_idma_out_obi2hci_write_req (
    .obi_req_i ( idma_obi_write_req_out ),
    .hci_req_o ( idma_hci_write_req_out )
  );

  hci2obi_rsp #(
    .hci_rsp_t ( tile_idma_hci_rsp_t            ),
    .obi_rsp_t ( magia_tile_pkg::idma_obi_rsp_t )
  ) i_idma_out_hci2obi_write_rsp (
    .hci_rsp_i ( idma_hci_write_rsp_out ),
    .obi_rsp_o ( idma_obi_write_rsp_out )
  );

  obi2hci_req #(
    .obi_req_t ( magia_tile_pkg::idma_obi_req_t ),
    .hci_req_t ( tile_idma_hci_req_t            )
  ) i_idma_in_obi2hci_req (
    .obi_req_i ( idma_obi_read_req_in ),
    .hci_req_o ( idma_hci_read_req_in )
  );

  hci2obi_rsp #(
    .hci_rsp_t ( tile_idma_hci_rsp_t            ),
    .obi_rsp_t ( magia_tile_pkg::idma_obi_rsp_t )
  ) i_idma_in_hci2obi_rsp (
    .hci_rsp_i ( idma_hci_read_rsp_in ),
    .obi_rsp_o ( idma_obi_read_rsp_in )
  );

  obi2hci_req #(
    .obi_req_t ( magia_tile_pkg::idma_obi_req_t ),
    .hci_req_t ( tile_idma_hci_req_t            )
  ) i_idma_in_obi2hci_write_req (
    .obi_req_i ( idma_obi_write_req_in ),
    .hci_req_o ( idma_hci_write_req_in )
  );

  hci2obi_rsp #(
    .hci_rsp_t ( tile_idma_hci_rsp_t            ),
    .obi_rsp_t ( magia_tile_pkg::idma_obi_rsp_t )
  ) i_idma_in_hci2obi_write_rsp (
    .hci_rsp_i ( idma_hci_write_rsp_in ),
    .obi_rsp_o ( idma_obi_write_rsp_in )
  );

  `HCI_ASSIGN_TO_INTF(hci_dma_if[magia_tile_pkg::HCI_DMA_OUT_CH_READ_IDX],  idma_hci_read_req_out,  idma_hci_read_rsp_out)
  `HCI_ASSIGN_TO_INTF(hci_dma_if[magia_tile_pkg::HCI_DMA_OUT_CH_WRITE_IDX], idma_hci_write_req_out, idma_hci_write_rsp_out)
  `HCI_ASSIGN_TO_INTF(hci_dma_if[magia_tile_pkg::HCI_DMA_IN_CH_READ_IDX],   idma_hci_read_req_in,   idma_hci_read_rsp_in)
  `HCI_ASSIGN_TO_INTF(hci_dma_if[magia_tile_pkg::HCI_DMA_IN_CH_WRITE_IDX],  idma_hci_write_req_in,  idma_hci_write_rsp_in)

/*******************************************************/
/**                      iDMA End                     **/
/*******************************************************/
/**                 RedMulE Beginning                 **/
/*******************************************************/

  if (TileCfg.EnRedMule) begin: gen_redmule
    tile_redmule_ctrl_req_t          redmule_ctrl_req;
    tile_redmule_ctrl_rsp_t          redmule_ctrl_rsp;
    tile_redmule_data_req_t          redmule_data_req;
    tile_redmule_data_rsp_t          redmule_data_rsp;
    magia_tile_pkg::redmule_events_t redmule_events;

    assign redmule_events.evt[1] = 1'b0;

    assign eu_events.acc[magia_tile_pkg::EU_ACC_REDMULE_BUSY]  = redmule_events.busy;
    assign eu_events.acc[magia_tile_pkg::EU_ACC_REDMULE_EVT_0] = redmule_events.evt[0];
    assign eu_events.acc[magia_tile_pkg::EU_ACC_REDMULE_EVT_1] = redmule_events.evt[1];

    obi2hwpe_ctrl #(
      .redmule_ctrl_req_t ( tile_redmule_ctrl_req_t ),
      .redmule_ctrl_rsp_t ( tile_redmule_ctrl_rsp_t )
    ) obi2hwpe_ctrl_inst (
      .obi_req_i  ( ctrl_req[CtrlMap.redmule] ),
      .obi_rsp_o  ( ctrl_rsp[CtrlMap.redmule] ),
      .ctrl_req_o ( redmule_ctrl_req          ),
      .ctrl_rsp_i ( redmule_ctrl_rsp          )
    );

    `HCI_ASSIGN_TO_INTF(hci_redmule_if[0], redmule_data_req, redmule_data_rsp)

    magia_redmule_wrap #(
      .CtrlIntfConfig     ( redmule_pkg::HWPE_TARGET    ),
      .DataW              ( RedmuleDataW                ),
      .Height             ( TileCfg.RedMule.Height      ),
      .Width              ( TileCfg.RedMule.Width       ),
      .NumPipeRegs        ( TileCfg.RedMule.NumPipeRegs ),
      .redmule_data_req_t ( tile_redmule_data_req_t     ),
      .redmule_data_rsp_t ( tile_redmule_data_rsp_t     ),
      .redmule_ctrl_req_t ( tile_redmule_ctrl_req_t     ),
      .redmule_ctrl_rsp_t ( tile_redmule_ctrl_rsp_t     )
    ) i_redmule_wrap (
      .clk_i              ( sys_clk               ),
      .rst_ni             ( rst_ni                ),
      .test_mode_i        ( test_mode_i           ),

      .busy_o             ( redmule_events.busy   ),
      .evt_o              ( redmule_events.evt[0] ),

      // Xif ports are unused in HWPE mode
      .x_issue_req_i      (                       ),
      .x_issue_resp_o     (                       ),
      .x_issue_valid_i    ( 1'b0                  ),
      .x_issue_ready_o    (                       ),
      .x_register_i       (                       ),
      .x_register_valid_i ( 1'b0                  ),
      .x_register_ready_o (                       ),
      .x_commit_i         (                       ),
      .x_commit_valid_i   ( 1'b0                  ),
      .x_result_o         (                       ),
      .x_result_valid_o   (                       ),
      .x_result_ready_i   ( 1'b0                  ),

      .data_req_o         ( redmule_data_req      ),
      .data_rsp_i         ( redmule_data_rsp      ),
      .ctrl_req_i         ( redmule_ctrl_req      ),
      .ctrl_rsp_o         ( redmule_ctrl_rsp      )
    );
  end else begin: gen_no_redmule
    tile_redmule_data_req_t redmule_data_req_quiet;
    tile_redmule_data_rsp_t redmule_data_rsp_unused;

    // The HCI interconnect keeps one HWPE port even when it has no RedMulE leaf
    assign redmule_data_req_quiet = '0;
    `HCI_ASSIGN_TO_INTF(hci_redmule_if[0], redmule_data_req_quiet, redmule_data_rsp_unused)

    assign eu_events.acc[magia_tile_pkg::EU_ACC_REDMULE_EVT_1 :
                         magia_tile_pkg::EU_ACC_REDMULE_BUSY] = '0;
  end

/*******************************************************/
/**                    RedMulE End                    **/
/*******************************************************/
/**                FractalSync Beginning              **/
/*******************************************************/

`ifdef MAGIA_FSYNC
  logic fsync_done;
  logic fsync_error;

  assign eu_events.other[magia_tile_pkg::EU_OTHER_FSYNC_DONE]  = fsync_done;
  assign eu_events.other[magia_tile_pkg::EU_OTHER_FSYNC_ERROR] = fsync_error;

  obi_slave_fsync #(
    .BASE_ADDR  ( magia_tile_pkg::FSYNC_CTRL_ADDR_START ),
    .AGGR_W     ( magia_tile_pkg::FSYNC_AGGR_W          ),
    .ID_W       ( magia_tile_pkg::FSYNC_ID_W            ),
    .NBR_AGGR_W ( magia_tile_pkg::FSYNC_NBR_AGGR_W      ),
    .NBR_ID_W   ( magia_tile_pkg::FSYNC_NBR_ID_W        )
  ) i_fsync_mm (
    .clk_i         ( sys_clk                 ),
    .rst_ni        ( rst_ni                  ),
    .clear_i       ( 1'b0                    ),
    .obi_req_i     ( ctrl_req[CtrlMap.fsync] ),
    .obi_rsp_o     ( ctrl_rsp[CtrlMap.fsync] ),
    .ht_fsync_if_o ( ht_fsync_if_o           ),
    .hn_fsync_if_o ( hn_fsync_if_o           ),
    .vt_fsync_if_o ( vt_fsync_if_o           ),
    .vn_fsync_if_o ( vn_fsync_if_o           ),
    .done_o        ( fsync_done              ),
    .error_o       ( fsync_error             )
  );
`else
  assign eu_events.other[magia_tile_pkg::EU_OTHER_FSYNC_DONE]  = 1'b0;
  assign eu_events.other[magia_tile_pkg::EU_OTHER_FSYNC_ERROR] = 1'b0;
`endif

/*******************************************************/
/**                   FractalSync End                 **/
/*******************************************************/
/**                  Spatz CC Beginning               **/
/*******************************************************/

  if (TileCfg.EnSpatzCC) begin: gen_spatz_cc
    logic spatz_clk_en;
    logic spatz_start;
    logic spatz_done;
    logic spatz_clk;

    obi_slave_ctrl_spatz #(
      .BaseAddr ( magia_tile_pkg::SPATZ_CTRL_ADDR_START )
    ) i_spatz_csr (
      .clk_i     ( sys_clk                 ),
      .rst_ni    ( rst_ni                  ),
      .obi_req_i ( ctrl_req[CtrlMap.spatz] ),
      .obi_rsp_o ( ctrl_rsp[CtrlMap.spatz] ),
      .clk_en_o  ( spatz_clk_en            ),
      .start_o   ( spatz_start             ),
      .done_o    ( spatz_done              )
    );

    assign eu_events.acc  [magia_tile_pkg::EU_ACC_SPATZ_DONE]    = spatz_done;
    assign eu_events.other[magia_tile_pkg::EU_OTHER_SPATZ_START] = spatz_start;

    tc_clk_gating spatz_clock_gating (
      .clk_i     ( sys_clk      ),
      .en_i      ( spatz_clk_en ),
      .test_en_i ( test_mode_i  ),
      .clk_o     ( spatz_clk    )
    );

    magia_tile_pkg::core_obi_data_req_t spatz_obi_req;
    magia_tile_pkg::core_obi_data_rsp_t spatz_obi_rsp;

    assign obi_xbar_slv_req[ObiMgr.spatz] = spatz_obi_req;
    assign spatz_obi_rsp                  = obi_xbar_slv_rsp[ObiMgr.spatz];

    tile_hci_data_req_t [NumSpatzHciPorts-1:0] spatz_hci_req;
    tile_hci_data_rsp_t [NumSpatzHciPorts-1:0] spatz_hci_rsp;

    for (genvar i = 0; i < NumSpatzHciPorts; i++) begin: gen_spatz_hci_assign
      `HCI_ASSIGN_TO_INTF(hci_core_if[i+1], spatz_hci_req[i], spatz_hci_rsp[i])
    end

    logic        spatz_inst_req;
    logic [31:0] spatz_inst_addr;
    logic        spatz_inst_cacheable;
    logic        spatz_flush_i_valid;
    logic [31:0] spatz_inst_data;
    logic        spatz_inst_ready;
    logic        spatz_inst_error;
    logic        spatz_flush_i_ready;

    // The Spatz CSR start pulse is the only interrupt source
    snitch_pkg::interrupts_t  spatz_irq;
    snitch_pkg::core_events_t spatz_core_events;

    assign spatz_irq.msip  = 1'b0;
    assign spatz_irq.mtip  = 1'b0;
    assign spatz_irq.meip  = spatz_start;
    assign spatz_irq.mcip  = 1'b0;
    assign spatz_irq.debug = 1'b0;

    spatz_cc_wrapper #(
      .SnitchPMACfg      ( SpatzPmaCfg                             ),
      .AddrWidth         ( magia_pkg::ADDR_W                       ),
      .DataWidth         ( magia_tile_pkg::SPATZ_TCDM_DATA_WIDTH   ),
      .NumSpatzFPUs      ( TileCfg.Spatz.NumFPU                    ),
      .NumSpatzIPUs      ( TileCfg.Spatz.NumIPU                    ),
      .BootAddr          ( magia_tile_pkg::SPATZ_BOOT_ADDR         ),
      .RVF               ( TileCfg.Spatz.RVF                       ),
      .RVD               ( TileCfg.Spatz.RVD                       ),
      .RVV               ( TileCfg.Spatz.RVV                       ),
      .XDivSqrt          ( TileCfg.Spatz.XDivSqrt                  ),
      .FPUImplementation ( magia_tile_pkg::SPATZ_FPUImplementation ),
      .hci_req_t         ( tile_hci_data_req_t                     ),
      .hci_rsp_t         ( tile_hci_data_rsp_t                     )
    ) i_spatz_cc_core (
      .clk_i            ( spatz_clk            ),
      .rst_ni           ( rst_ni               ),
      .test_mode_i      ( test_mode_i          ),

      .hart_id_i        ( 32'(HartIdBase) + mhartid_i ),
      .tcdm_addr_base_i ( tile_l1_start_addr   ),

      .irq_i            ( spatz_irq            ),

      .hci_master_req_o ( spatz_hci_req        ),
      .hci_master_rsp_i ( spatz_hci_rsp        ),

      .obi_master_req_o ( spatz_obi_req        ),
      .obi_master_rsp_i ( spatz_obi_rsp        ),

      .inst_req_o       ( spatz_inst_req       ),
      .inst_addr_o      ( spatz_inst_addr      ),
      .inst_cacheable_o ( spatz_inst_cacheable ),
      .flush_i_valid_o  ( spatz_flush_i_valid  ),
      .inst_data_i      ( spatz_inst_data      ),
      .inst_ready_i     ( spatz_inst_ready     ),
      .inst_error_i     ( spatz_inst_error     ),
      .flush_i_ready_i  ( spatz_flush_i_ready  ),

      .core_events_o    ( spatz_core_events    )
    );

    // Spatz i$
    logic spatz_enable_prefetching;
    magia_tile_pkg::core_axi_instr_req_t spatz_icache_axi_req;
    magia_tile_pkg::core_axi_instr_rsp_t spatz_icache_axi_rsp;

    assign spatz_enable_prefetching = 1'b0;

    assign axi_xbar_slv_req[magia_tile_pkg::AXI_SLV_SPATZ_INSTR_IDX] = spatz_icache_axi_req;
    assign spatz_icache_axi_rsp = axi_xbar_slv_rsp[magia_tile_pkg::AXI_SLV_SPATZ_INSTR_IDX];

    localparam int unsigned SpatzIcacheL0EarlyTagW = snitch_pkg::PAGE_SHIFT - $clog2(TileCfg.Spatz.ICacheLineWidth/8);

    snitch_icache #(
      .NR_FETCH_PORTS      ( 1                                    ),
      .L0_LINE_COUNT       ( TileCfg.Spatz.ICacheL0LineCount      ),
      .LINE_WIDTH          ( TileCfg.Spatz.ICacheLineWidth        ),
      .LINE_COUNT          ( TileCfg.Spatz.ICacheLineCount        ),
      .WAY_COUNT           ( TileCfg.Spatz.ICacheWays             ),
      .FETCH_AW            ( magia_pkg::ADDR_W                    ),
      .FETCH_DW            ( 32                                   ),
      .FILL_AW             ( magia_pkg::ADDR_W                    ),
      .FILL_DW             ( magia_pkg::DATA_W                    ),
      .SERIAL_LOOKUP       ( 0                                    ),
      .L1_TAG_SCM          ( 0                                    ),
      .NUM_AXI_OUTSTANDING ( 2                                    ),
      .EARLY_LATCH         ( 0                                    ),
      .L0_EARLY_TAG_WIDTH  ( SpatzIcacheL0EarlyTagW               ),
      .ISO_CROSSING        ( 1'b0                                 ),
      .axi_req_t           ( magia_tile_pkg::core_axi_instr_req_t ),
      .axi_rsp_t           ( magia_tile_pkg::core_axi_instr_rsp_t )
    ) i_spatz_cc_icache (
      .clk_i                ( spatz_clk                ),
      .clk_d2_i             ( spatz_clk                ),
      .rst_ni               ( rst_ni                   ),
      .enable_prefetching_i ( spatz_enable_prefetching ),
      .icache_l0_events_o   (                          ),
      .icache_l1_events_o   (                          ),
      .flush_valid_i        ( spatz_flush_i_valid      ),
      .flush_ready_o        ( spatz_flush_i_ready      ),
      .inst_addr_i          ( spatz_inst_addr          ),
      .inst_cacheable_i     ( spatz_inst_cacheable     ),
      .inst_data_o          ( spatz_inst_data          ),
      .inst_valid_i         ( spatz_inst_req           ),
      .inst_ready_o         ( spatz_inst_ready         ),
      .inst_error_o         ( spatz_inst_error         ),
      .sram_cfg_tag_i       ( '0                       ),
      .sram_cfg_data_i      ( '0                       ),
      .axi_req_o            ( spatz_icache_axi_req     ),
      .axi_rsp_i            ( spatz_icache_axi_rsp     )
    );

    // Spatz bootrom, generated from spatz_init.S, behind an AXI-to-regbus bridge
    magia_tile_pkg::reg_dma_req_t       bootrom_reg_req;
    magia_tile_pkg::reg_dma_rsp_t       bootrom_reg_rsp;
    logic [magia_pkg::AXI_NOC_ID_W-1:0] bootrom_reg_id;
    logic                               bootrom_busy;

    axi_to_reg_v2 #(
      .AxiAddrWidth ( magia_pkg::ADDR_W             ),
      .AxiDataWidth ( magia_pkg::DATA_W             ),
      .AxiIdWidth   ( magia_pkg::AXI_NOC_ID_W       ),
      .AxiUserWidth ( magia_pkg::AXI_NOC_U_W        ),
      .RegDataWidth ( magia_pkg::DATA_W             ),
      .axi_req_t    ( magia_pkg::axi_xbar_mst_req_t ),
      .axi_rsp_t    ( magia_pkg::axi_xbar_mst_rsp_t ),
      .reg_req_t    ( magia_tile_pkg::reg_dma_req_t ),
      .reg_rsp_t    ( magia_tile_pkg::reg_dma_rsp_t )
    ) i_axi_to_reg_bootrom (
      .clk_i     ( sys_clk                          ),
      .rst_ni    ( rst_ni                           ),
      .axi_req_i ( axi_xbar_mst_req[AxiMst.bootrom] ),
      .axi_rsp_o ( axi_xbar_mst_rsp[AxiMst.bootrom] ),
      .reg_req_o ( bootrom_reg_req                  ),
      .reg_rsp_i ( bootrom_reg_rsp                  ),
      .reg_id_o  ( bootrom_reg_id                   ),
      .busy_o    ( bootrom_busy                     )
    );

    spatz_bootrom i_spatz_bootrom (
      .clk_i   ( sys_clk               ),
      .req_i   ( bootrom_reg_req.valid ),
      .addr_i  ( bootrom_reg_req.addr  ),
      .rdata_o ( bootrom_reg_rsp.rdata )
    );

    always_ff @(posedge sys_clk or negedge rst_ni) begin
      if (!rst_ni) bootrom_reg_rsp.ready <= 1'b0;
      else         bootrom_reg_rsp.ready <= bootrom_reg_req.valid;
    end

    assign bootrom_reg_rsp.error = 1'b0;
  end else begin: gen_no_spatz_cc
    assign eu_events.acc  [magia_tile_pkg::EU_ACC_SPATZ_DONE]    = 1'b0;
    assign eu_events.other[magia_tile_pkg::EU_OTHER_SPATZ_START] = 1'b0;

    assign axi_xbar_slv_req[magia_tile_pkg::AXI_SLV_SPATZ_INSTR_IDX] = '0;
  end

/*******************************************************/
/**                    Spatz CC End                   **/
/*******************************************************/
/**               PULP Cluster Beginning              **/
/*******************************************************/

  if (TileCfg.EnCluster) begin: gen_pulp_cluster
    localparam int unsigned ClusterIcacheL0LineCount = TileCfg.Cluster.IcachePrivateSize / (TileCfg.Cluster.IcacheLineWidth/8);
    localparam int unsigned ClusterIcacheLineCount   = TileCfg.Cluster.IcacheSharedSize  / (TileCfg.Cluster.IcacheLineWidth/8) / TileCfg.Cluster.IcacheNumWays;

    logic [31:0]              cluster_boot_addr [NClusterCores-1:0];
    logic [NClusterCores-1:0] cluster_fetch_enable;
    logic                     cluster_start_irq;
    logic                     cluster_done;

    obi_slave_ctrl_cluster #(
      .TileCfg  ( TileCfg                                 ),
      .BaseAddr ( magia_tile_pkg::CLUSTER_CTRL_ADDR_START )
    ) i_cluster_csr (
      .clk_i       ( sys_clk                   ),
      .rst_ni      ( rst_ni                    ),
      .obi_req_i   ( ctrl_req[CtrlMap.cluster] ),
      .obi_rsp_o   ( ctrl_rsp[CtrlMap.cluster] ),
      .boot_addr_o ( cluster_boot_addr         ),
      .fetch_en_o  ( cluster_fetch_enable      ),
      .done_o      ( cluster_done              ),
      .start_irq_o ( cluster_start_irq         )
    );

    assign eu_events.other[magia_tile_pkg::EU_OTHER_CLUSTER_DONE] = cluster_done;

    // Each core reaches L1 through HCI and everything else through the OBI crossbar
    magia_tile_pkg::core_obi_data_req_t [NClusterCores-1:0] cluster_obi_data_req;
    magia_tile_pkg::core_obi_data_rsp_t [NClusterCores-1:0] cluster_obi_data_rsp;
    tile_hci_data_req_t                 [NClusterCores-1:0] cluster_hci_data_req;
    tile_hci_data_rsp_t                 [NClusterCores-1:0] cluster_hci_data_rsp;
    magia_tile_pkg::core_instr_req_t    [NClusterCores-1:0] cluster_instr_req;
    magia_tile_pkg::core_instr_rsp_t    [NClusterCores-1:0] cluster_instr_rsp;

    magia_cluster_wrap #(
      .TileCfg       ( TileCfg             ),
      .HartIdBase    ( HartIdBase          ),
      .InstanceCount ( InstanceCount       ),
      .hci_req_t     ( tile_hci_data_req_t ),
      .hci_rsp_t     ( tile_hci_data_rsp_t )
    ) i_cluster (
      .clk_i                  ( sys_clk                              ),  // The cluster Event Unit gates each core
      .rst_ni                 ( rst_ni                               ),
      .test_mode_i            ( test_mode_i                          ),
      .mhartid_i              ( mhartid_i                            ),
      .tile_l1_start_addr_i   ( tile_l1_start_addr                   ),
      .tile_l1_end_addr_i     ( tile_l1_end_addr                     ),
      .cluster_boot_addr_i    ( cluster_boot_addr                    ),
      .cluster_fetch_enable_i ( cluster_fetch_enable                 ),
      .cluster_start_irq_i    ( cluster_start_irq                    ),
      .cluster_eu_obi_req_i   ( core_mem_data_req[ObiSbr.cluster_eu] ),
      .cluster_eu_obi_rsp_o   ( core_mem_data_rsp[ObiSbr.cluster_eu] ),
      .cluster_obi_data_req_o ( cluster_obi_data_req                 ),
      .cluster_obi_data_rsp_i ( cluster_obi_data_rsp                 ),
      .cluster_hci_data_req_o ( cluster_hci_data_req                 ),
      .cluster_hci_data_rsp_i ( cluster_hci_data_rsp                 ),
      .cluster_instr_req_o    ( cluster_instr_req                    ),
      .cluster_instr_rsp_i    ( cluster_instr_rsp                    )
    );

    for (genvar idx_core = 0; idx_core < NClusterCores; idx_core++) begin: gen_cluster_obi_port
      assign obi_xbar_slv_req[ObiMgr.cluster_base + idx_core] = cluster_obi_data_req[idx_core];
      assign cluster_obi_data_rsp[idx_core] = obi_xbar_slv_rsp[ObiMgr.cluster_base + idx_core];
    end

    for (genvar idx_core = 0; idx_core < NClusterCores; idx_core++) begin: gen_cluster_hci_assign
      `HCI_ASSIGN_TO_INTF(hci_core_if[1 + NumSpatzHciPorts + idx_core], cluster_hci_data_req[idx_core], cluster_hci_data_rsp[idx_core])
    end

    // Shared cluster i$
    logic [NClusterCores-1:0]                                       cluster_cache_req;
    logic [NClusterCores-1:0][magia_tile_pkg::CLUSTER_FETCH_AW-1:0] cluster_cache_addr;
    logic [NClusterCores-1:0]                                       cluster_cache_gnt;
    logic [NClusterCores-1:0]                                       cluster_cache_rvalid;
    logic [NClusterCores-1:0][magia_tile_pkg::CLUSTER_FETCH_DW-1:0] cluster_cache_rdata;
    logic [NClusterCores-1:0]                                       cluster_cache_rerror;

    logic                                                     cluster_enable_prefetching;
    snitch_icache_pkg::icache_l0_events_t [NClusterCores-1:0] cluster_icache_l0_events;
    snitch_icache_pkg::icache_l1_events_t                     cluster_icache_l1_events;
    logic [NClusterCores-1:0]                                 cluster_icache_flush_valid;
    logic [NClusterCores-1:0]                                 cluster_icache_flush_ready;

    magia_tile_pkg::core_axi_instr_req_t cluster_l2_instr_req;
    magia_tile_pkg::core_axi_instr_rsp_t cluster_l2_instr_rsp;

    assign cluster_enable_prefetching = 1'b0;
    assign cluster_icache_flush_valid = '0;

    for (genvar i = 0; i < NClusterCores; i++) begin: gen_cluster_icache_assign
      assign cluster_cache_req[i]        = cluster_instr_req[i].req;
      assign cluster_cache_addr[i]       = cluster_instr_req[i].addr;
      assign cluster_instr_rsp[i].gnt    = cluster_cache_gnt[i];
      assign cluster_instr_rsp[i].rvalid = cluster_cache_rvalid[i];
      assign cluster_instr_rsp[i].rdata  = cluster_cache_rdata[i];
      assign cluster_instr_rsp[i].err    = cluster_cache_rerror[i];
    end

    assign axi_xbar_slv_req[magia_tile_pkg::AXI_SLV_CLUSTER_INSTR_IDX] = cluster_l2_instr_req;
    assign cluster_l2_instr_rsp = axi_xbar_slv_rsp[magia_tile_pkg::AXI_SLV_CLUSTER_INSTR_IDX];

    magia_tile_icache_wrap #(
      .CachedRegionBase ( 32'(CodeRegionBase)                       ),
      .CachedRegionMask ( CodeRegionMask                              ),
      .NumFetchPorts  ( NClusterCores                          ),
      .L0_LINE_COUNT  ( ClusterIcacheL0LineCount               ),
      .LINE_WIDTH     ( TileCfg.Cluster.IcacheLineWidth        ),
      .LINE_COUNT     ( ClusterIcacheLineCount                 ),
      .WAY_COUNT      ( TileCfg.Cluster.IcacheNumWays          ),
      .FetchAddrWidth ( magia_tile_pkg::CLUSTER_FETCH_AW       ),
      .FetchDataWidth ( magia_tile_pkg::CLUSTER_FETCH_DW       ),
      .AxiAddrWidth   ( magia_tile_pkg::CLUSTER_FILL_AW        ),
      .AxiDataWidth   ( magia_tile_pkg::CLUSTER_FILL_DW        ),
      .axi_req_t      ( magia_tile_pkg::core_axi_instr_req_t   ),
      .axi_rsp_t      ( magia_tile_pkg::core_axi_instr_rsp_t   )
    ) cluster_icache_top_i (
      .clk_i                ( clk_i                      ),
      .rst_ni               ( rst_ni                     ),
      .fetch_req_i          ( cluster_cache_req          ),
      .fetch_addr_i         ( cluster_cache_addr         ),
      .fetch_gnt_o          ( cluster_cache_gnt          ),
      .fetch_rvalid_o       ( cluster_cache_rvalid       ),
      .fetch_rdata_o        ( cluster_cache_rdata        ),
      .fetch_rerror_o       ( cluster_cache_rerror       ),

      .enable_prefetching_i ( cluster_enable_prefetching ),
      .icache_l0_events_o   ( cluster_icache_l0_events   ),
      .icache_l1_events_o   ( cluster_icache_l1_events   ),
      .flush_valid_i        ( cluster_icache_flush_valid ),
      .flush_ready_o        ( cluster_icache_flush_ready ),

      .sram_cfg_data_i      ( '0                         ),
      .sram_cfg_tag_i       ( '0                         ),

      .axi_req_o            ( cluster_l2_instr_req       ),
      .axi_rsp_i            ( cluster_l2_instr_rsp       )
    );
  end else begin: gen_no_pulp_cluster
    assign eu_events.other[magia_tile_pkg::EU_OTHER_CLUSTER_DONE] = 1'b0;

    assign axi_xbar_slv_req[magia_tile_pkg::AXI_SLV_CLUSTER_INSTR_IDX] = '0;
  end

/*******************************************************/
/**                  PULP Cluster End                 **/
/*******************************************************/
/**            Verilator Observation Beginning        **/
/*******************************************************/

`ifdef MAGIA_ISLE_OBSERVE
  // A Verilator hierarchical block cannot be probed from outside, so the VIP reads these ports
  always_comb begin
    observe_o              = '0;
    // Prints (0xFFFF_0000/4) match no rule and leave through the ext port
    observe_o.axi_aw_addr  = axi_xbar_mst_req[magia_tile_pkg::AXI_MST_EXT_IDX].aw.addr;
    observe_o.axi_aw_id    = axi_xbar_mst_req[magia_tile_pkg::AXI_MST_EXT_IDX].aw.id;
    observe_o.axi_aw_valid = axi_xbar_mst_req[magia_tile_pkg::AXI_MST_EXT_IDX].aw_valid;
    observe_o.axi_w_data   = axi_xbar_mst_req[magia_tile_pkg::AXI_MST_EXT_IDX].w.data;
    observe_o.axi_w_valid  = axi_xbar_mst_req[magia_tile_pkg::AXI_MST_EXT_IDX].w_valid;
`ifdef CV32E40X
    observe_o.instr_ex = i_cv32e40x_ctrl_core.core_i.id_stage_i.id_ex_pipe_o.instr.bus_resp.rdata;
    observe_o.instr_id = i_cv32e40x_ctrl_core.core_i.id_stage_i.if_id_pipe_i.instr.bus_resp.rdata;
    observe_o.instr_wb = i_cv32e40x_ctrl_core.core_i.wb_stage_i.ex_wb_pipe_i.instr_valid ?
                         i_cv32e40x_ctrl_core.core_i.wb_stage_i.ex_wb_pipe_i.instr.bus_resp.rdata : '0;
    observe_o.wb_data  = observe_o.instr_wb;
`else
    // magia_dv always defines CORE_TRACES, so the control core is a cv32e40p_wrapper
    observe_o.instr_ex = i_cv32e40p_ctrl_core.cv32e40p_top_i.core_i.ex_valid ?
                         i_cv32e40p_ctrl_core.cv32e40p_top_i.core_i.id_stage_i.instr_rdata_i : '0;
    observe_o.instr_id = i_cv32e40p_ctrl_core.cv32e40p_top_i.core_i.id_stage_i.instr_rdata_i;
    observe_o.instr_wb = i_cv32e40p_ctrl_core.cv32e40p_top_i.core_i.wb_valid ?
                         i_cv32e40p_ctrl_core.cv32e40p_top_i.core_i.instr_rdata_id : '0;
    observe_o.wb_data  = i_cv32e40p_ctrl_core.cv32e40p_top_i.core_i.wb_valid ?
                         i_cv32e40p_ctrl_core.cv32e40p_top_i.core_i.regfile_wdata : '0;
`endif
  end
`endif

/*******************************************************/
/**             Verilator Observation End             **/
/*******************************************************/

endmodule: magia_isle
