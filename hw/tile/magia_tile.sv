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
 *          Luca Balboni <luca.balboni10@studio.unibo.it>
 * 
 * MAGIA Tile
 */

 `include "axi/assign.svh"
 `include "hci_helpers.svh"
 `include "hwpe_ctrl_helpers.svh"

module magia_tile
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
  import floo_pkg::*;
`ifndef TARGET_STANDALONE_TILE
  import magia_noc_pkg::*;
`else
  import floo_axi_nw_mesh_1x2_noc_pkg::*;
`endif
#(
  parameter magia_tile_pkg::magia_tile_cfg_t TileCfg       = magia_tile_pkg::MagiaTileDefaultCfg,
  // Parameters used by hci_interconnect and l1_spm
  parameter int unsigned          N_MEM_BANKS              = magia_pkg::N_MEM_BANKS,         // Number of memory banks
  parameter int unsigned          N_WORDS_BANK             = magia_pkg::N_WORDS_BANK,        // Number of words per memory bank

  // Parameters used by the core
  parameter cv32e40x_pkg::rv32_e  CORE_ISA                 = cv32e40x_pkg::RV32I,            // RV32I (default) 32 registers in the RF - RV32E 16 registers in the RF
  parameter cv32e40x_pkg::a_ext_e CORE_A                   = cv32e40x_pkg::A,                // Atomic Istruction (A) support (dafault: full support)
  parameter cv32e40x_pkg::b_ext_e CORE_B                   = cv32e40x_pkg::ZBA_ZBB_ZBC_ZBS,  // Bit Manipulation support (dafault: full support)
  parameter cv32e40x_pkg::m_ext_e CORE_M                   = cv32e40x_pkg::M,                // Multiply and Divide support (dafault: full support)

  // Parameters used by the iDMA
  parameter idma_pkg::error_cap_e ERROR_CAP                = idma_pkg::NO_ERROR_HANDLING     // Error handaling capability of the iDMA
)(
  input  logic                              clk_i,
  input  logic                              rst_ni,
  input  logic                              test_mode_i,
  input  logic                              tile_enable_i,

  // NoC input and output links
  input  floo_req_t                         noc_south_req_i,
  output floo_rsp_t                         noc_south_rsp_o,
  input  floo_wide_t                        noc_south_wide_i,
  output floo_req_t                         noc_south_req_o,
  input  floo_rsp_t                         noc_south_rsp_i,
  output floo_wide_t                        noc_south_wide_o,

  input  floo_req_t                         noc_east_req_i,
  output floo_rsp_t                         noc_east_rsp_o,
  input  floo_wide_t                        noc_east_wide_i,
  output floo_req_t                         noc_east_req_o,
  input  floo_rsp_t                         noc_east_rsp_i,
  output floo_wide_t                        noc_east_wide_o,

  input  floo_req_t                         noc_north_req_i,
  output floo_rsp_t                         noc_north_rsp_o,
  input  floo_wide_t                        noc_north_wide_i,
  output floo_req_t                         noc_north_req_o,
  input  floo_rsp_t                         noc_north_rsp_i,
  output floo_wide_t                        noc_north_wide_o,

  input  floo_req_t                         noc_west_req_i,
  output floo_rsp_t                         noc_west_rsp_o,
  input  floo_wide_t                        noc_west_wide_i,
  output floo_req_t                         noc_west_req_o,
  input  floo_rsp_t                         noc_west_rsp_i,
  output floo_wide_t                        noc_west_wide_o,

  // Tile spatial IDs
  input  logic [31:0]                       x_id_i,
  input  logic [31:0]                       y_id_i,

  // FractalSync interface
  fractal_sync_if.mst_port                  ht_fsync_if_o,
  fractal_sync_if.mst_port                  hn_fsync_if_o,
  fractal_sync_if.mst_port                  vt_fsync_if_o,
  fractal_sync_if.mst_port                  vn_fsync_if_o,

  // Signals used by the core
  input  logic                              scan_cg_en_i,

  input  logic[31:0]                        boot_addr_i,
  input  logic[31:0]                        mtvec_addr_i,
  input  logic[31:0]                        dm_halt_addr_i,
  input  logic[31:0]                        dm_exception_addr_i,
  input  logic[31:0]                        mhartid_i,
  input  logic[ 3:0]                        mimpid_patch_i,

  output logic[63:0]                        mcycle_o,
  input  logic[63:0]                        time_i,

  input  logic[magia_pkg::N_IRQ-1:0]        irq_i,

  input  logic                              debug_req_i,
  output logic                              debug_havereset_o,
  output logic                              debug_running_o,
  output logic                              debug_halted_o,
  output logic                              debug_pc_valid_o,
  output logic[31:0]                        debug_pc_o,

  input  logic                              fetch_enable_i,
  output logic                              core_sleep_o,
  input  logic                              wu_wfe_i
);

/*******************************************************/
/**     Configuration-Derived Localparams Beginning   **/
/*******************************************************/
  localparam magia_tile_pkg::obi_mgr_map_t ObiMgr = magia_tile_pkg::gen_obi_mgr_map(TileCfg);
  localparam magia_tile_pkg::obi_sbr_map_t ObiSbr = magia_tile_pkg::gen_obi_sbr_map(TileCfg);

  localparam magia_tile_pkg::axi_xbar_mst_map_t AxiMst    = magia_tile_pkg::gen_axi_xbar_mst_map(TileCfg);
  localparam axi_pkg::xbar_cfg_t                AxiXbarCfg = magia_tile_pkg::gen_axi_xbar_cfg(TileCfg);

  localparam int unsigned NumSpatzHciPorts = magia_tile_pkg::gen_tile_spatz_hci_ports(TileCfg);
  localparam int unsigned NumHciCore       = magia_tile_pkg::gen_tile_num_hci_core(TileCfg);

  localparam bit HasCsrPort = TileCfg.EnSpatzCC || TileCfg.EnCluster;

  localparam int unsigned NClusterCores = TileCfg.Cluster.NumCores;

  localparam int unsigned NumHwpe = magia_tile_pkg::N_HWPE; // RedMulE; stays 1 if !EnRedMule (tied off) - local_interconnect is not 0-safe
  localparam int unsigned NumDma  = magia_tile_pkg::N_DMA;
  localparam int unsigned NumExt  = magia_tile_pkg::N_EXT;

  localparam int unsigned TileIW = NumHwpe + NumHciCore + NumDma + NumExt;

  localparam int unsigned RedmuleFpW   = 16;  // fp_width(FP16) - RedMulE format in MAGIA
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

  // OBI address decode rule indices
  localparam int unsigned RuleL2      = 0;
  localparam int unsigned RuleL1      = 1;
  localparam int unsigned RuleRes     = 2;
  localparam int unsigned RuleStack   = 3;
  localparam int unsigned RuleRedmule = 4;                            // valid iff EnRedMule
  localparam int unsigned RuleIdma    = 4 + 32'(TileCfg.EnRedMule);
  localparam int unsigned RuleFsync   = RuleIdma  + 1;
  localparam int unsigned RuleEu      = RuleFsync + 1;
  localparam int unsigned RuleCsr     = RuleEu    + 1;                // valid iff HasCsrPort

/*******************************************************/
/**       Configuration-Derived Localparams End       **/
/*******************************************************/
/**       Internal Signal Definitions Beginning       **/
/*******************************************************/

  logic[magia_pkg::ADDR_W-1:0] tile_l1_start_addr;
  logic[magia_pkg::ADDR_W-1:0] tile_l1_end_addr;
  logic[magia_pkg::ADDR_W-1:0] tile_reserved_start_addr;
  logic[magia_pkg::ADDR_W-1:0] tile_reserved_end_addr;
  logic[magia_pkg::ADDR_W-1:0] tile_redmule_ctrl_start_addr;
  logic[magia_pkg::ADDR_W-1:0] tile_redmule_ctrl_end_addr;
  logic[magia_pkg::ADDR_W-1:0] tile_idma_ctrl_start_addr;
  logic[magia_pkg::ADDR_W-1:0] tile_idma_ctrl_end_addr;
  logic[magia_pkg::ADDR_W-1:0] tile_fsync_ctrl_start_addr;
  logic[magia_pkg::ADDR_W-1:0] tile_fsync_ctrl_end_addr;
  logic[magia_pkg::ADDR_W-1:0] tile_event_unit_start_addr;
  logic[magia_pkg::ADDR_W-1:0] tile_event_unit_end_addr;


  magia_tile_pkg::core_data_req_t core_data_req;
  magia_tile_pkg::core_data_rsp_t core_data_rsp;

  magia_tile_pkg::core_obi_data_req_t core_obi_data_req;
  magia_tile_pkg::core_obi_data_rsp_t core_obi_data_rsp;

  magia_tile_pkg::core_obi_data_req_t[ObiSbr.num_sbr-1:0] core_mem_data_req; // Subordinate ports: indices from ObiSbr (l2, l1, redmule*, idma, fsync, eu, csr - *if enabled)
  magia_tile_pkg::core_obi_data_rsp_t[ObiSbr.num_sbr-1:0] core_mem_data_rsp; // Subordinate ports: indices from ObiSbr (l2, l1, redmule*, idma, fsync, eu, csr - *if enabled)

  magia_tile_pkg::core_obi_data_req_t[ObiSbr.num_sbr-1:0] core_mem_data_cut_req; // Subordinate ports (before cut): indices from ObiSbr
  magia_tile_pkg::core_obi_data_rsp_t[ObiSbr.num_sbr-1:0] core_mem_data_cut_rsp; // Subordinate ports (before cut): indices from ObiSbr

  magia_tile_pkg::core_obi_data_req_t core_l1_data_amo_req;
  magia_tile_pkg::core_obi_data_rsp_t core_l1_data_amo_rsp;

  magia_tile_pkg::core_obi_data_req_t[ObiMgr.num_mgr-1:0] obi_xbar_slv_req; // Manager ports: indices from ObiMgr (core, ext, spatz*, cluster_base+i* - *if enabled)
  magia_tile_pkg::core_obi_data_rsp_t[ObiMgr.num_mgr-1:0] obi_xbar_slv_rsp; // Manager ports: indices from ObiMgr (core, ext, spatz*, cluster_base+i* - *if enabled)

  magia_tile_pkg::core_obi_data_req_t[ObiMgr.num_mgr-1:0] obi_xbar_slv_cut_req; // Manager ports (after cut): indices from ObiMgr
  magia_tile_pkg::core_obi_data_rsp_t[ObiMgr.num_mgr-1:0] obi_xbar_slv_cut_rsp; // Manager ports (after cut): indices from ObiMgr

  magia_tile_pkg::core_obi_data_req_t ext_obi_data_req;
  magia_tile_pkg::core_obi_data_rsp_t ext_obi_data_rsp;

  tile_hci_data_req_t core_l1_data_req;
  tile_hci_data_rsp_t core_l1_data_rsp;

  magia_tile_pkg::core_axi_data_req_t core_l2_data_req;
  magia_tile_pkg::core_axi_data_rsp_t core_l2_data_rsp;

  magia_tile_pkg::core_instr_req_t core_instr_req;
  magia_tile_pkg::core_instr_rsp_t core_instr_rsp;

  magia_tile_pkg::core_cache_instr_req_t core_cache_instr_req;
  magia_tile_pkg::core_cache_instr_rsp_t core_cache_instr_rsp;

  magia_tile_pkg::core_axi_instr_req_t core_l2_instr_req;
  magia_tile_pkg::core_axi_instr_rsp_t core_l2_instr_rsp;

  magia_tile_pkg::idma_axi_req_t idma_axi_read_req_out;
  magia_tile_pkg::idma_axi_rsp_t idma_axi_read_rsp_out;

  magia_tile_pkg::idma_axi_req_t idma_axi_write_req_out;
  magia_tile_pkg::idma_axi_rsp_t idma_axi_write_rsp_out;
  
  magia_tile_pkg::idma_axi_req_t idma_axi_req_out;
  magia_tile_pkg::idma_axi_rsp_t idma_axi_rsp_out;

  magia_tile_pkg::idma_axi_req_t idma_axi_read_req_in;
  magia_tile_pkg::idma_axi_rsp_t idma_axi_read_rsp_in;

  magia_tile_pkg::idma_axi_req_t idma_axi_write_req_in;
  magia_tile_pkg::idma_axi_rsp_t idma_axi_write_rsp_in;

  magia_tile_pkg::idma_axi_req_t idma_axi_req_in;
  magia_tile_pkg::idma_axi_rsp_t idma_axi_rsp_in;

  magia_tile_pkg::idma_obi_req_t idma_obi_read_req_out;
  magia_tile_pkg::idma_obi_rsp_t idma_obi_read_rsp_out;

  magia_tile_pkg::idma_obi_req_t idma_obi_write_req_out;
  magia_tile_pkg::idma_obi_rsp_t idma_obi_write_rsp_out;

  magia_tile_pkg::idma_obi_req_t idma_obi_read_req_in;
  magia_tile_pkg::idma_obi_rsp_t idma_obi_read_rsp_in;

  magia_tile_pkg::idma_obi_req_t idma_obi_write_req_in;
  magia_tile_pkg::idma_obi_rsp_t idma_obi_write_rsp_in;

  tile_idma_hci_req_t idma_hci_read_req_out;
  tile_idma_hci_rsp_t idma_hci_read_rsp_out;

  tile_idma_hci_req_t idma_hci_write_req_out;
  tile_idma_hci_rsp_t idma_hci_write_rsp_out;

  tile_idma_hci_req_t idma_hci_read_req_in;
  tile_idma_hci_rsp_t idma_hci_read_rsp_in;

  tile_idma_hci_req_t idma_hci_write_req_in;
  tile_idma_hci_rsp_t idma_hci_write_rsp_in;

  magia_tile_pkg::axi_xbar_slv_req_t[magia_tile_pkg::AxiXbarNoSlvPorts-1:0] axi_xbar_slv_req; // Index 2 -> ext, Index 1 -> Core Data, Index 0 -> Core Instruction
  magia_tile_pkg::axi_xbar_slv_rsp_t[magia_tile_pkg::AxiXbarNoSlvPorts-1:0] axi_xbar_slv_rsp; // Index 2 -> ext, Index 1 -> Core Data, Index 0 -> Core Instruction

  magia_pkg::axi_xbar_mst_req_t[AxiXbarCfg.NoMstPorts-1:0] axi_xbar_mst_req;  // ext(0), OBI(1), Spatz bootrom(2, iff EnSpatzCC)
  magia_pkg::axi_xbar_mst_rsp_t[AxiXbarCfg.NoMstPorts-1:0] axi_xbar_mst_rsp;  // ext(0), OBI(1), Spatz bootrom(2, iff EnSpatzCC)

  logic[AxiXbarCfg.NoSlvPorts-1:0] en_default_mst_port;
  
  logic                                hci_clear; // Can be used to manage HCI clear at top-level
  hci_package::hci_interconnect_ctrl_t hci_ctrl;  // Can be used to manage HCI control at top-level

  magia_tile_pkg::obi_xbar_rule_t[ObiSbr.num_rules-1:0] obi_xbar_rule;

  axi_pkg::xbar_rule_32_t[AxiXbarCfg.NoAddrRules-1:0] axi_xbar_rule;

  logic[ObiMgr.num_mgr-1:0]                                                        obi_xbar_en_default_idx;
  logic[ObiMgr.num_mgr-1:0][magia_tile_pkg::gen_idx_width(ObiSbr.num_sbr)-1:0]     obi_xbar_default_idx;

  logic[magia_tile_pkg::AXI_DATA_U_W-1:0] axi_data_user;
  logic[magia_tile_pkg::RUSER_WIDTH-1:0]  obi_rsp_data_user;

  logic[magia_tile_pkg::AID_WIDTH-1:0]   axi2obi_req_write_aid;
  logic[magia_tile_pkg::AUSER_WIDTH-1:0] axi2obi_req_write_auser;
  logic[magia_tile_pkg::WUSER_WIDTH-1:0] axi2obi_req_write_wuser;

  logic[magia_tile_pkg::AID_WIDTH-1:0]   axi2obi_req_read_aid;
  logic[magia_tile_pkg::AUSER_WIDTH-1:0] axi2obi_req_read_auser;

  logic                                  axi2obi_rsp_b_user;
  logic                                  axi2obi_rsp_r_user;

  logic idma_clear;         // Can be used to manage iDMA clear at top-level
  logic idma_axi2obi_start;
  logic idma_axi2obi_busy;
  logic idma_axi2obi_done;
  logic idma_axi2obi_error;
  logic idma_obi2axi_start;
  logic idma_obi2axi_busy;
  logic idma_obi2axi_done;
  logic idma_obi2axi_error;

  
  logic sys_clk;
  logic sys_clk_en;

  // Core clock gating signals
  logic core_clk;           // Clock gated per il core
  logic core_clk_en;        // Enable dal tile (sempre attivo)

  // Core output signals
  logic[magia_pkg::N_IRQ-1:0] irq;

  magia_tile_pkg::eu_events_t eu_events;

  logic                                clic_irq;
  logic[magia_tile_pkg::CLIC_ID_W-1:0] clic_irq_id;
  logic[7:0]                           clic_irq_level;
  logic[1:0]                           clic_irq_priv;
  logic                                clic_irq_shv;

  logic fencei_flush_req;
  logic fencei_flush_ack;

  logic                                                                     enable_prefetching;
  snitch_icache_pkg::icache_l0_events_t[magia_tile_pkg::NR_FETCH_PORTS-1:0] icache_l0_events; // Can be used to implement i$ IRQs
  snitch_icache_pkg::icache_l1_events_t                                     icache_l1_events; // Can be used to implement i$ IRQs
  logic[magia_tile_pkg::NR_FETCH_PORTS-1:0]                                 flush_valid;
  logic[magia_tile_pkg::NR_FETCH_PORTS-1:0]                                 flush_ready;

  logic fsync_clear;   // Can be used to manage iDMA clear at top-level
  logic fsync_done;
  logic fsync_error;

  // FlooNoC connections between NI and router
  id_t              floo_id;
  floo_req_t  [4:0] floo_router_req_in;
  floo_rsp_t  [4:0] floo_router_rsp_in;
  floo_wide_t [4:0] floo_router_wide_in;
  floo_req_t  [4:0] floo_router_req_out;
  floo_rsp_t  [4:0] floo_router_rsp_out;
  floo_wide_t [4:0] floo_router_wide_out;
  
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

  // Event Unit signals
  logic                                           eu_core_irq_req;
  logic [magia_tile_pkg::EVENT_UNIT_IRQ_WIDTH-1:0] eu_core_irq_id;
  logic                                           eu_core_irq_ack;
  logic [magia_tile_pkg::EVENT_UNIT_IRQ_WIDTH-1:0] eu_core_irq_ack_id;
  logic                                           eu_core_clk_en;
  logic                                           eu_core_dbg_req;
  // Per-core 32-bit irq vector for CV32E40P. EU IRQ is mapped to MEI (bit 11),
  // all other bits forced to 0 to avoid X-propagation through irq_i.
  logic [31:0]                                   core_irq_vec;  // Ctrl core IRQ vector only (cluster cores use cluster_irq_vec)

  // Core data demux signals
  magia_tile_pkg::core_data_req_t core_data_req_to_xbar;
  magia_tile_pkg::core_data_rsp_t core_data_rsp_from_xbar;
  magia_tile_pkg::eu_direct_req_t eu_direct_req;
  magia_tile_pkg::eu_direct_rsp_t eu_direct_rsp;

  // EU direct link, after the pipeline cut (control core only)
  magia_tile_pkg::eu_direct_req_t eu_direct_req_cut;
  magia_tile_pkg::eu_direct_rsp_t eu_direct_rsp_cut;

  // Flat EU direct signals for event unit connection
  logic        eu_direct_req_flat;
  logic [31:0] eu_direct_addr_flat;
  logic        eu_direct_wen_flat;
  logic [31:0] eu_direct_wdata_flat;
  logic [3:0]  eu_direct_be_flat;
  logic        eu_direct_gnt_flat;
  logic        eu_direct_rvalid_flat;
  logic [31:0] eu_direct_rdata_flat;
  logic        eu_direct_err_flat;

  // Core busy signal for event unit (control core)
  logic eu_core_busy;
  magia_tile_pkg::core_obi_data_rsp_t spatz_csr_rsp;
  magia_tile_pkg::core_obi_data_rsp_t cluster_csr_rsp;


/*******************************************************/
/**          Internal Signal Definitions End          **/
/*******************************************************/
/**            Hardwired Signals Beginning            **/
/*******************************************************/

  assign tile_redmule_ctrl_start_addr = magia_tile_pkg::REDMULE_CTRL_ADDR_START;
  assign tile_redmule_ctrl_end_addr   = magia_tile_pkg::REDMULE_CTRL_ADDR_END;
  assign tile_idma_ctrl_start_addr    = magia_tile_pkg::IDMA_CTRL_ADDR_START;
  assign tile_idma_ctrl_end_addr      = magia_tile_pkg::IDMA_CTRL_ADDR_END;
  assign tile_fsync_ctrl_start_addr   = magia_tile_pkg::FSYNC_CTRL_ADDR_START;
  assign tile_fsync_ctrl_end_addr     = magia_tile_pkg::FSYNC_CTRL_ADDR_END;
  assign tile_event_unit_start_addr   = magia_tile_pkg::EVENT_UNIT_ADDR_START;
  assign tile_event_unit_end_addr     = magia_tile_pkg::EVENT_UNIT_ADDR_END;
  assign tile_reserved_start_addr     = magia_tile_pkg::RESERVED_ADDR_START + mhartid_i*magia_tile_pkg::L1_TILE_OFFSET;
  assign tile_reserved_end_addr       = magia_tile_pkg::RESERVED_ADDR_END   + mhartid_i*magia_tile_pkg::L1_TILE_OFFSET;
  assign tile_l1_start_addr           = magia_tile_pkg::L1_ADDR_START       + mhartid_i*magia_tile_pkg::L1_TILE_OFFSET;
  assign tile_l1_end_addr             = magia_tile_pkg::L1_ADDR_END         + mhartid_i*magia_tile_pkg::L1_TILE_OFFSET;

  assign obi_xbar_rule[RuleL2]    = '{idx: ObiSbr.l2,    start_addr: magia_tile_pkg::L2_ADDR_START,    end_addr: magia_tile_pkg::L2_ADDR_END     };
  assign obi_xbar_rule[RuleL1]    = '{idx: ObiSbr.l1,    start_addr: tile_l1_start_addr,               end_addr: tile_l1_end_addr                };
  assign obi_xbar_rule[RuleRes]   = '{idx: ObiSbr.l1,    start_addr: tile_reserved_start_addr,         end_addr: tile_reserved_end_addr          };
  assign obi_xbar_rule[RuleStack] = '{idx: ObiSbr.l1,    start_addr: magia_tile_pkg::STACK_ADDR_START, end_addr: magia_tile_pkg::STACK_ADDR_END  };

  if (TileCfg.EnRedMule) begin: gen_redmule_rule
    assign obi_xbar_rule[RuleRedmule] = '{idx: ObiSbr.redmule, start_addr: tile_redmule_ctrl_start_addr, end_addr: tile_redmule_ctrl_end_addr    };
  end
  assign obi_xbar_rule[RuleIdma]  = '{idx: ObiSbr.idma,  start_addr: tile_idma_ctrl_start_addr,        end_addr: tile_idma_ctrl_end_addr         };
  assign obi_xbar_rule[RuleFsync] = '{idx: ObiSbr.fsync, start_addr: tile_fsync_ctrl_start_addr,       end_addr: tile_fsync_ctrl_end_addr        };
  assign obi_xbar_rule[RuleEu]    = '{idx: ObiSbr.eu,    start_addr: tile_event_unit_start_addr,       end_addr: tile_event_unit_end_addr        };

  if (HasCsrPort) begin: gen_csr_rule
    assign obi_xbar_rule[RuleCsr] = '{idx: ObiSbr.csr,   start_addr: magia_tile_pkg::TILE_CSR_START,   end_addr: magia_tile_pkg::TILE_CSR_END    };
  end

  assign axi_xbar_rule[0] = '{idx: AxiMst.ext, start_addr: magia_tile_pkg::L2_ADDR_START, end_addr: magia_tile_pkg::L2_ADDR_END };
  assign axi_xbar_rule[1] = '{idx: AxiMst.obi, start_addr: tile_l1_start_addr,            end_addr: tile_l1_end_addr            };
  assign axi_xbar_rule[2] = '{idx: AxiMst.obi, start_addr: tile_reserved_start_addr,      end_addr: tile_reserved_end_addr      };

  if (TileCfg.EnSpatzCC) begin: gen_axi_bootrom_rule
    assign axi_xbar_rule[3] = '{idx: AxiMst.bootrom, start_addr: magia_tile_pkg::SPATZ_BOOT_ADDR, end_addr: magia_tile_pkg::SPATZ_BOOT_ADDR + magia_tile_pkg::SPATZ_BOOTROM_SIZE};
  end
  assign obi_xbar_en_default_idx = '1; // Routing to the AXI Xbar all requests with an address outside the range of the internal L1 and the external L2
  assign obi_xbar_default_idx    = '0;

  assign axi_xbar_slv_req[magia_tile_pkg::AXI_SLV_CORE_DATA_IDX]   = core_l2_data_req;
  assign core_l2_data_rsp                                          = axi_xbar_slv_rsp[magia_tile_pkg::AXI_SLV_CORE_DATA_IDX];
  assign axi_xbar_slv_req[magia_tile_pkg::AXI_SLV_CORE_INSTR_IDX]  = core_l2_instr_req;
  assign core_l2_instr_rsp                                         = axi_xbar_slv_rsp[magia_tile_pkg::AXI_SLV_CORE_INSTR_IDX];

  assign obi_xbar_slv_req[ObiMgr.core] = core_obi_data_req;
  assign core_obi_data_rsp             = obi_xbar_slv_rsp[ObiMgr.core];
  assign obi_xbar_slv_req[ObiMgr.ext]  = ext_obi_data_req;
  assign ext_obi_data_rsp              = obi_xbar_slv_rsp[ObiMgr.ext];

  assign axi_data_user     = '0;
  assign obi_rsp_data_user = '0;

  assign axi2obi_req_write_aid   = '0;
  assign axi2obi_req_write_auser = '0;
  assign axi2obi_req_write_wuser = '0;

  assign axi2obi_req_read_aid   = '0;
  assign axi2obi_req_read_auser = '0;

  assign axi2obi_rsp_b_user = '0;
  assign axi2obi_rsp_r_user = '0;

  assign en_default_mst_port = '1;

  assign floo_id = '{x: (x_id_i+1), y: y_id_i, port_id: 0};

  assign hci_clear = 1'b0;
  assign hci_ctrl  = '0;

  assign idma_clear = 1'b0;

  assign fsync_clear = 1'b0;

`ifdef CV32E40X
  assign enable_prefetching = 1'b0;
  assign flush_valid[0]     = fencei_flush_req; // Single port i$
  assign fencei_flush_ack   = flush_ready[0];   // Signle port i$

  assign irq[N_IRQ-1:19] = '0;
  assign irq[18:16] = irq_i[18:16];
  assign irq[15:12]                                 = '0;
  assign irq[11]                                    = eu_core_irq_req; // Event Unit IRQ mapped to external interrupt (bit 11)
  assign irq[10:8]                                  = '0;
  assign irq[7]                                     = irq_i[7];
  assign irq[6:4]                                   = '0;
  assign irq[3]                                     = irq_i[3];
  assign irq[2:0]                                   = '0;
  // CLIC unused
  assign clic_irq       = 1'b0;
  assign clic_irq_id    = '0;
  assign clic_irq_level = '0;
  assign clic_irq_priv  = '0;
  assign clic_irq_shv   = 1'b0;
`else
  // Icache control signals
  assign enable_prefetching = 1'b0;
  assign flush_valid        = '0;

  assign irq[magia_pkg::N_IRQ-1:12] = '0;                 // Clear all high IRQs
  assign irq[11]                    = eu_core_irq_req; // Event Unit IRQ mapped to external interrupt (bit 11)
  assign irq[10:8]                  = '0;                 // Clear IRQs 8-10
  assign irq[7]                     = 1'b0;               // Timer interrupt (unused)
  assign irq[6:4]                   = '0;                 // Clear IRQs 4-6
  assign irq[3]                     = 1'b0;               // Software interrupt (unused)
  assign irq[2:0]                   = '0;                 // Clear IRQs 0-2
`endif

/*******************************************************/
/**               Hardwired Signals End               **/
/*******************************************************/
/**             Type Conversions Beginning            **/
/*******************************************************/

  // Convert control-core data interface to OBI for the crossbar
`ifdef CV32E40X
  cv32e40x_data2obi_req i_core_data2obi_req (
    .data_req_i ( core_data_req_to_xbar ),
    .obi_req_o  ( core_obi_data_req     )
  );

  cv32e40x_obi2data_rsp i_core_obi2data_rsp (
    .obi_rsp_i  ( core_obi_data_rsp         ),
    .data_rsp_o ( core_data_rsp_from_xbar   )
  );
`else
  cv32e40p_data2obi_req i_core_data2obi_req (
    .data_req_i ( core_data_req_to_xbar ),
    .obi_req_o  ( core_obi_data_req     )
  );

  cv32e40p_obi2data_rsp i_core_obi2data_rsp (
    .obi_rsp_i  ( core_obi_data_rsp         ),
    .data_rsp_o ( core_data_rsp_from_xbar   )
  );
`endif
  
  obi2hci_req #(
    .obi_req_t ( magia_tile_pkg::core_obi_data_req_t ),
    .hci_req_t ( tile_hci_data_req_t )
  ) i_core_data_obi2hci_req (
    .obi_req_i ( core_l1_data_amo_req ),
    .hci_req_o ( core_l1_data_req     )
  );

  hci2obi_rsp #(
    .hci_rsp_t ( tile_hci_data_rsp_t ),
    .obi_rsp_t ( magia_tile_pkg::core_obi_data_rsp_t )
  ) i_core_data_hci2obi_rsp (
    .hci_rsp_i ( core_l1_data_rsp     ),
    .obi_rsp_o ( core_l1_data_amo_rsp )
  );

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
    .clk_i               ( sys_clk                                            ),
    .rst_ni              ( rst_ni                                             ),
    .obi_req_i           ( core_mem_data_req[ObiSbr.l2]                       ),
    .obi_rsp_o           ( core_mem_data_rsp[ObiSbr.l2]                       ),
    .user_i              ( axi_data_user                                      ),
    .axi_req_o           ( core_l2_data_req                                   ),
    .axi_rsp_i           ( core_l2_data_rsp                                   ),
    .axi_rsp_channel_sel (                                                    ),
    .axi_rsp_b_user_o    (                                                    ),
    .axi_rsp_r_user_o    (                                                    ),
    .obi_rsp_user_i      ( obi_rsp_data_user                                  )
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
    .obi_req_t ( magia_tile_pkg::idma_obi_req_t ),
    .hci_req_t ( tile_idma_hci_req_t )
  ) i_idma_out_obi2hci_req (
    .obi_req_i ( idma_obi_read_req_out ),
    .hci_req_o ( idma_hci_read_req_out )
  );

  hci2obi_rsp #(
    .hci_rsp_t ( tile_idma_hci_rsp_t ),
    .obi_rsp_t ( magia_tile_pkg::idma_obi_rsp_t )
  ) i_idma_out_hci2obi_rsp (
    .hci_rsp_i ( idma_hci_read_rsp_out ),
    .obi_rsp_o ( idma_obi_read_rsp_out )
  );

  obi2hci_req #(
    .obi_req_t ( magia_tile_pkg::idma_obi_req_t ),
    .hci_req_t ( tile_idma_hci_req_t )
  ) i_idma_out_obi2hci_write_req (
    .obi_req_i ( idma_obi_write_req_out ),
    .hci_req_o ( idma_hci_write_req_out )
  );

  hci2obi_rsp #(
    .hci_rsp_t ( tile_idma_hci_rsp_t ),
    .obi_rsp_t ( magia_tile_pkg::idma_obi_rsp_t )
  ) i_idma_out_hci2obi_write_rsp (
    .hci_rsp_i ( idma_hci_write_rsp_out ),
    .obi_rsp_o ( idma_obi_write_rsp_out )
  );

  obi2hci_req #(
    .obi_req_t ( magia_tile_pkg::idma_obi_req_t ),
    .hci_req_t ( tile_idma_hci_req_t )
  ) i_idma_in_obi2hci_req (
    .obi_req_i ( idma_obi_read_req_in ),
    .hci_req_o ( idma_hci_read_req_in )
  );

  hci2obi_rsp #(
    .hci_rsp_t ( tile_idma_hci_rsp_t ),
    .obi_rsp_t ( magia_tile_pkg::idma_obi_rsp_t )
  ) i_idma_in_hci2obi_rsp (
    .hci_rsp_i ( idma_hci_read_rsp_in ),
    .obi_rsp_o ( idma_obi_read_rsp_in )
  );

  obi2hci_req #(
    .obi_req_t ( magia_tile_pkg::idma_obi_req_t ),
    .hci_req_t ( tile_idma_hci_req_t )
  ) i_idma_in_obi2hci_write_req (
    .obi_req_i ( idma_obi_write_req_in ),
    .hci_req_o ( idma_hci_write_req_in )
  );

  hci2obi_rsp #(
    .hci_rsp_t ( tile_idma_hci_rsp_t ),
    .obi_rsp_t ( magia_tile_pkg::idma_obi_rsp_t )
  ) i_idma_in_hci2obi_write_rsp (
    .hci_rsp_i ( idma_hci_write_rsp_in ),
    .obi_rsp_o ( idma_obi_write_rsp_in )
  );

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
    .clk_i                  ( sys_clk                                           ),
    .rst_ni                 ( rst_ni                                            ),
    .testmode_i             ( test_mode_i                                       ),
    .axi_req_i              ( axi_xbar_mst_req[AxiMst.obi] ),
    .axi_rsp_o              ( axi_xbar_mst_rsp[AxiMst.obi] ),
    .obi_req_o              ( ext_obi_data_req                                  ),
    .obi_rsp_i              ( ext_obi_data_rsp                                  ),
    .req_aw_id_o            (                                                   ),
    .req_aw_user_o          (                                                   ),
    .req_w_user_o           (                                                   ),
    .req_write_aid_i        ( axi2obi_req_write_aid                             ),
    .req_write_auser_i      ( axi2obi_req_write_auser                           ),
    .req_write_wuser_i      ( axi2obi_req_write_wuser                           ),
    .req_ar_id_o            (                                                   ),
    .req_ar_user_o          (                                                   ),
    .req_read_aid_i         ( axi2obi_req_read_aid                              ),
    .req_read_auser_i       ( axi2obi_req_read_auser                            ),
    .rsp_write_aw_user_o    (                                                   ),
    .rsp_write_w_user_o     (                                                   ),
    .rsp_write_bank_strb_o  (                                                   ),
    .rsp_write_rid_o        (                                                   ),
    .rsp_write_ruser_o      (                                                   ),
    .rsp_write_last_o       (                                                   ),
    .rsp_write_hs_o         (                                                   ),
    .rsp_b_user_i           ( axi2obi_rsp_b_user                                ),
    .rsp_read_ar_user_o     (                                                   ),
    .rsp_read_size_enable_o (                                                   ),
    .rsp_read_rid_o         (                                                   ),
    .rsp_read_ruser_o       (                                                   ),
    .rsp_r_user_i           ( axi2obi_rsp_r_user                                )
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
    .clk_i                  ( sys_clk               ),
    .rst_ni                 ( rst_ni                ),
    .testmode_i             ( test_mode_i           ),
    .axi_req_i              ( idma_axi_read_req_in  ),
    .axi_rsp_o              ( idma_axi_read_rsp_in  ),
    .obi_req_o              ( idma_obi_read_req_in  ),
    .obi_rsp_i              ( idma_obi_read_rsp_in  ),
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


/*******************************************************/
/**                Type Conversions End               **/
/*******************************************************/
/**             Core Data Demux Beginning             **/
/*******************************************************/

  // Core data demux: splits requests between regular crossbar and EU direct link
  core_data_demux_eu_direct i_core_data_demux_eu_direct (
    .clk_i              ( sys_clk                 ),
    .rst_ni             ( rst_ni                  ),
    
    // Core interface
    .core_data_req_i    ( core_data_req           ),
    .core_data_rsp_o    ( core_data_rsp           ),
    
    // Regular crossbar interface
    .xbar_data_req_o    ( core_data_req_to_xbar   ),
    .xbar_data_rsp_i    ( core_data_rsp_from_xbar ),
    
    // EU direct link interface
    .eu_direct_req_o    ( eu_direct_req           ),
    .eu_direct_rsp_i    ( eu_direct_rsp           )
  );
  eu_direct_cut #(
    .eu_direct_req_t ( magia_tile_pkg::eu_direct_req_t ),
    .eu_direct_rsp_t ( magia_tile_pkg::eu_direct_rsp_t ),
    .Bypass          ( 1'b0                            ),
    .BypassReq       ( 1'b0                            ),
    .BypassRsp       ( 1'b0                            ),
    .NB_CORES        ( 1                               )
  ) i_eu_direct_cut (
    .clk_i       ( sys_clk           ),
    .rst_ni      ( rst_ni            ),
    .sbr_req_i   ( eu_direct_req     ),
    .sbr_rsp_o   ( eu_direct_rsp     ),
    .mgr_req_o   ( eu_direct_req_cut ),
    .mgr_rsp_i   ( eu_direct_rsp_cut )
  );

  // Flatten eu_direct_cut output for event unit connection
  assign eu_direct_req_flat      = eu_direct_req_cut.req;
  assign eu_direct_addr_flat     = eu_direct_req_cut.addr;
  assign eu_direct_wen_flat      = eu_direct_req_cut.wen;
  assign eu_direct_wdata_flat    = eu_direct_req_cut.wdata;
  assign eu_direct_be_flat       = eu_direct_req_cut.be;
  assign eu_direct_rsp_cut.gnt    = eu_direct_gnt_flat;
  assign eu_direct_rsp_cut.rvalid = eu_direct_rvalid_flat;
  assign eu_direct_rsp_cut.rdata  = eu_direct_rdata_flat;
  assign eu_direct_rsp_cut.err    = eu_direct_err_flat;

/*******************************************************/
/**                Core Data Demux End                **/
/*******************************************************/
/**               Clock Gating Beginning              **/
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

  // Core clock gating controlled by Event Unit
  assign core_clk_en = eu_core_clk_en;  // Event Unit controls core clock
  
  tc_clk_gating core_clock_gating (
    .clk_i     ( sys_clk     ),
    .en_i      ( core_clk_en ),
    .test_en_i ( test_mode_i ),
    .clk_o     ( core_clk    )
  );

/*******************************************************/
/**                  Clock Gating End                 **/
/*******************************************************/
/**           Interface Definitions Beginning         **/
/*******************************************************/

  localparam hci_package::hci_size_parameter_t `HCI_SIZE_PARAM(hci_tcdm_sram_if) = '{
    DW:  magia_tile_pkg::DW_LIC,
    AW:  magia_tile_pkg::AWM,
    BW:  hci_package::DEFAULT_BW,
    UW:  magia_tile_pkg::UW_LIC,
    IW:  TileIW,
    EW:  hci_package::DEFAULT_EW,
    EHW: hci_package::DEFAULT_EHW
  };
  `HCI_INTF_ARRAY(hci_tcdm_sram_if, sys_clk, 0:N_MEM_BANKS-1);
  
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
  `HCI_INTF_ARRAY(hci_redmule_if, sys_clk, 0:NumHwpe-1);

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
  generate;
    if (NumExt > 0) begin
      `HCI_INTF_ARRAY(hci_ext_if, sys_clk, 0:NumExt-1);
    end else begin
      // NumExt == 0 would give the illegal range [0:-1]; keep one dummy element.
      `HCI_INTF_ARRAY(hci_ext_if, sys_clk, 0:0);
    end
  endgenerate

  // Single Xif interface shared between core (cpu_*) and FPU (coproc_*)
  cv32e40x_if_xif #(
    .X_NUM_RS    ( magia_tile_pkg::X_NUM_RS ),
    .X_ID_WIDTH  ( magia_tile_pkg::X_ID_W   ),
    .X_MEM_WIDTH ( magia_tile_pkg::X_MEM_W  ),
    .X_RFR_WIDTH ( magia_tile_pkg::X_RFR_W  ),
    .X_RFW_WIDTH ( magia_tile_pkg::X_RFW_W  ),
    .X_MISA      ( magia_tile_pkg::X_MISA   ),
    .X_ECS_XS    ( magia_tile_pkg::X_ECS_XS )
  ) xif_if    ();



/*******************************************************/
/**             Interface Definitions End             **/
/*******************************************************/
/**          Interface Assignments Beginning          **/
/*******************************************************/

  `HCI_ASSIGN_TO_INTF(hci_core_if[0],                                       core_l1_data_req,       core_l1_data_rsp)       // Only 1 core supported
  `HCI_ASSIGN_TO_INTF(hci_dma_if[magia_tile_pkg::HCI_DMA_OUT_CH_READ_IDX],  idma_hci_read_req_out,  idma_hci_read_rsp_out)  // iDMA out HCI read channel
  `HCI_ASSIGN_TO_INTF(hci_dma_if[magia_tile_pkg::HCI_DMA_OUT_CH_WRITE_IDX], idma_hci_write_req_out, idma_hci_write_rsp_out) // iDMA out HCI write channel
  `HCI_ASSIGN_TO_INTF(hci_dma_if[magia_tile_pkg::HCI_DMA_IN_CH_READ_IDX],   idma_hci_read_req_in,   idma_hci_read_rsp_in)   // iDMA in HCI read channel
  `HCI_ASSIGN_TO_INTF(hci_dma_if[magia_tile_pkg::HCI_DMA_IN_CH_WRITE_IDX],  idma_hci_write_req_in,  idma_hci_write_rsp_in)  // iDMA in HCI write channel

/*******************************************************/
/**             Interface Assignments End             **/
/*******************************************************/
/**                 RedMulE Beginning                 **/
/*******************************************************/
if (TileCfg.EnRedMule) begin: gen_redmule

  tile_redmule_data_req_t redmule_data_req;
  tile_redmule_data_rsp_t redmule_data_rsp;

  `HCI_ASSIGN_TO_INTF(hci_redmule_if[0], redmule_data_req, redmule_data_rsp)

  tile_redmule_ctrl_req_t redmule_ctrl_req;
  tile_redmule_ctrl_rsp_t redmule_ctrl_rsp;

  obi2hwpe_ctrl #(
    .redmule_ctrl_req_t ( tile_redmule_ctrl_req_t ),
    .redmule_ctrl_rsp_t ( tile_redmule_ctrl_rsp_t )
  ) obi2hwpe_ctrl_inst (
    .obi_req_i  ( core_mem_data_req[ObiSbr.redmule] ),
    .obi_rsp_o  ( core_mem_data_rsp[ObiSbr.redmule] ),
    .ctrl_req_o ( redmule_ctrl_req                  ),
    .ctrl_rsp_i ( redmule_ctrl_rsp                  )
  );

  magia_tile_pkg::redmule_events_t redmule_events;
  assign redmule_events.evt[1] = 1'b0;

  assign eu_events.acc[magia_tile_pkg::EU_ACC_REDMULE_BUSY]  = redmule_events.busy;
  assign eu_events.acc[magia_tile_pkg::EU_ACC_REDMULE_EVT_0] = redmule_events.evt[0];
  assign eu_events.acc[magia_tile_pkg::EU_ACC_REDMULE_EVT_1] = redmule_events.evt[1];

  magia_redmule_wrap #(
    .CtrlIntfConfig     ( redmule_pkg::HWPE_TARGET     ),
    .DataW              ( RedmuleDataW                ),
    .Height             ( TileCfg.RedMule.Height      ),
    .Width              ( TileCfg.RedMule.Width       ),
    .NumPipeRegs        ( TileCfg.RedMule.NumPipeRegs ),
    .redmule_data_req_t ( tile_redmule_data_req_t     ),
    .redmule_data_rsp_t ( tile_redmule_data_rsp_t     ),
    .redmule_ctrl_req_t ( tile_redmule_ctrl_req_t     ),
    .redmule_ctrl_rsp_t ( tile_redmule_ctrl_rsp_t     )
  ) i_redmule_wrap (
    .clk_i               ( sys_clk                                                     ),
    .rst_ni              ( rst_ni                                                      ),
    .test_mode_i         ( test_mode_i                                                 ),

    .busy_o              ( redmule_events.busy                                         ),
    .evt_o               ( redmule_events.evt[0]                                       ),
    .x_issue_req_i       (                                                             ), // Not used in HWPE mode
    .x_issue_resp_o      (                                                             ), // Not used in HWPE mode
    .x_issue_valid_i     ( 1'b0                                                        ), // Not used in HWPE mode
    .x_issue_ready_o     (                                                             ), // Not used in HWPE mode
    .x_register_i        (                                                             ), // Not used in HWPE mode
    .x_register_valid_i  ( 1'b0                                                        ), // Not used in HWPE mode
    .x_register_ready_o  (                                                             ), // Not used in HWPE mode
    .x_commit_i          (                                                             ), // Not used in HWPE mode
    .x_commit_valid_i    ( 1'b0                                                        ), // Not used in HWPE mode
    .x_result_o          (                                                             ), // Not used in HWPE mode
    .x_result_valid_o    (                                                             ), // Not used in HWPE mode
    .x_result_ready_i    ( 1'b0                                                        ), // Not used in HWPE mode
    .data_req_o          ( redmule_data_req                                            ),
    .data_rsp_i          ( redmule_data_rsp                                            ),

    .ctrl_req_i          ( redmule_ctrl_req                                            ),
    .ctrl_rsp_o          ( redmule_ctrl_rsp                                            )
  );
end else begin: gen_no_redmule

  tile_redmule_data_req_t redmule_data_req_quiet;
  tile_redmule_data_rsp_t redmule_data_rsp_unused;

  assign redmule_data_req_quiet = '0;
  `HCI_ASSIGN_TO_INTF(hci_redmule_if[0], redmule_data_req_quiet, redmule_data_rsp_unused)

  // Keep the RedMulE slice of the Event Unit bus quiet
  assign eu_events.acc[magia_tile_pkg::EU_ACC_REDMULE_EVT_1 :
                       magia_tile_pkg::EU_ACC_REDMULE_BUSY] = '0;
end

/*******************************************************/
/**                    RedMulE End                    **/
/*******************************************************/
/**                   Core Beginning                  **/
/*******************************************************/

`ifdef CV32E40X
  // Documentation of cv32e40x_core's design parameters and interface is available at:
  // https://docs.openhwgroup.org/projects/cv32e40x-user-manual/en/latest/integration.html#core-integration

`ifndef CORE_TRACES
  cv32e40x_core #(
`else
  cv32e40x_wrapper #(
`endif
    .RV32             ( CORE_ISA                        ),
    .A_EXT            ( CORE_A                          ),
    .B_EXT            ( CORE_B                          ),
    .M_EXT            ( CORE_M                          ),
    .X_EXT            ( magia_tile_pkg::X_EXT_EN        ),    // Support for eXtension Interface (X) 
    .X_NUM_RS         ( magia_tile_pkg::X_NUM_RS        ),    // RF read ports that can be used by the eXtension interface
    .X_ID_WIDTH       ( magia_tile_pkg::X_ID_W          ),    // ID width of eXtension interface
    .X_MEM_WIDTH      ( magia_tile_pkg::X_MEM_W         ),    // MEM width for loads/stores of eXtension interface
    .X_RFR_WIDTH      ( magia_tile_pkg::X_RFR_W         ),    // RF read width of eXtension interface
    .X_RFW_WIDTH      ( magia_tile_pkg::X_RFW_W         ),    // RF write width of eXtension interface
    .X_MISA           ( magia_tile_pkg::X_MISA          ),    // MISA extensions implemented on the eXtension interface
    .X_ECS_XS         ( magia_tile_pkg::X_ECS_XS        ),    // Default value for mstatus.XS if X_EXT = 1
    .NUM_MHPMCOUNTERS ( 1                               ),    // 1 MHPMCOUNTER performance counter
    .DEBUG            ( 1                               ),    // Enable debug support
    .DM_REGION_START  ( magia_tile_pkg::DM_REGION_START ),    // Start address of Debug Module region
    .DM_REGION_END    ( magia_tile_pkg::DM_REGION_END   ),    // End address of Debug Module region
    .DBG_NUM_TRIGGERS ( 1                               ),    // 1 debug trigger
    .PMA_NUM_REGIONS  ( 0                               ),    // No PMA (Physical Memory Attribution) regions 
    .PMA_CFG          (                                 ),    // No array of PMA configurations
    .CLIC             ( magia_tile_pkg::CLIC_EN         ),    // Support for Smclic, Smclicshv and Smclicconfig
    .CLIC_ID_WIDTH    ( magia_tile_pkg::CLIC_ID_W       )     // Width of clic_irq_id_i and clic_irq_id_o
  ) i_cv32e40x_ctrl_core (
    // Clock and reset
    .clk_i               ( core_clk               ),
    .rst_ni              ( rst_ni                 ),
    .scan_cg_en_i                                  ,

    // Configuration
    .boot_addr_i                                   ,  // instead of exposing these outside the tile, they could be managed with a configuration ROM/RAM
    .mtvec_addr_i                                  ,  // instead of exposing these outside the tile, they could be managed with a configuration ROM/RAM
    .dm_halt_addr_i                                ,  // instead of exposing these outside the tile, they could be managed with a configuration ROM/RAM
    .dm_exception_addr_i                           ,  // instead of exposing these outside the tile, they could be managed with a configuration ROM/RAM
    .mhartid_i                                     ,  // instead of exposing these outside the tile, they could be managed with a configuration ROM/RAM
    .mimpid_patch_i                                ,  // instead of exposing these outside the tile, they could be managed with a configuration ROM/RAM

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

    // Cycle, Time
    .mcycle_o                                      ,
    .time_i                                        ,

    // eXtension interface
    .xif_compressed_if   ( xif_if.cpu_compressed  ),
    .xif_issue_if        ( xif_if.cpu_issue       ),
    .xif_commit_if       ( xif_if.cpu_commit      ),
    .xif_mem_if          ( xif_if.cpu_mem         ),
    .xif_mem_result_if   ( xif_if.cpu_mem_result  ),
    .xif_result_if       ( xif_if.cpu_result      ),

     // Interrupt interface
    .irq_i               ( irq                    ),

    .clic_irq_i          ( clic_irq               ),
    .clic_irq_id_i       ( clic_irq_id            ),
    .clic_irq_level_i    ( clic_irq_level         ),
    .clic_irq_priv_i     ( clic_irq_priv          ),
    .clic_irq_shv_i      ( clic_irq_shv           ),

    // Fence.i flush handshake
    .fencei_flush_req_o  ( fencei_flush_req       ), 
    .fencei_flush_ack_i  ( fencei_flush_ack       ),

    // Debug interface
    .debug_req_i                                   ,
    .debug_havereset_o                             ,
    .debug_running_o                               ,
    .debug_halted_o                                ,
    .debug_pc_valid_o                              ,
    .debug_pc_o                                    ,

    // Special control signals
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
    .COREV_PULP          ( 1                                   ), // For now this is a no
    .COREV_CLUSTER       ( 1                                   ),
    .FPU                 ( FPU                                 ),
    .ZFINX               ( magia_tile_pkg::ZFINX_CTRL          ),
    .FPU_ADDMUL_LAT      ( 1                                   ), // Match C_LAT_FP32=1 in fpnew wrapper
    .FPU_OTHERS_LAT      ( 1                                   ), // Match C_LAT_NONCOMP=1 in fpnew wrapper
    .NUM_MHPMCOUNTERS    ( 29                                  )
  ) i_cv32e40p_ctrl_core (
    // Clock and Reset
    .clk_i                  ( core_clk              ),  // Use gated clock for core
    .rst_ni                 ( rst_ni                ),
    
    // Clock Interface
    .pulp_clock_en_i        ( sys_clk_en            ),
    .scan_cg_en_i           ( test_mode_i           ),
    .boot_addr_i            ( boot_addr_i           ),
    .mtvec_addr_i           ( boot_addr_i           ),  // mtvec defaults to boot vector; SW can override via csrw
    .dm_halt_addr_i         ( magia_tile_pkg::DM_HALT_ADDR),
    .hart_id_i              ( mhartid_i             ),
    .dm_exception_addr_i    ( magia_tile_pkg::DM_HALT_ADDR + 16'h000C), //to be checked
    // Instruction interface
    .instr_req_o            ( core_instr_req.req    ),
    .instr_gnt_i            ( core_instr_rsp.gnt    ),
    .instr_rvalid_i         ( core_instr_rsp.rvalid ),
    .instr_addr_o           ( core_instr_req.addr   ),
    .instr_rdata_i          ( core_instr_rsp.rdata  ),
    // Data interface
    .data_req_o             ( core_data_req.req     ),
    .data_gnt_i             ( core_data_rsp.gnt     ),
    .data_rvalid_i          ( core_data_rsp.rvalid  ),
    .data_addr_o            ( core_data_req.addr    ),
    .data_be_o              ( core_data_req.be      ),
    .data_wdata_o           ( core_data_req.wdata   ),
    .data_we_o              ( core_data_req.we      ),
    .data_rdata_i           ( core_data_rsp.rdata   ),
    .irq_i                  ( core_irq_vec          ),
    .irq_ack_o              ( eu_core_irq_ack       ),
    .irq_id_o               ( eu_core_irq_ack_id    ),
    // Debug interface
    .debug_req_i            ( debug_req_i           ),
    .debug_havereset_o      ( debug_havereset_o     ),
    .debug_running_o        ( debug_running_o       ),
    .debug_halted_o         ( debug_halted_o        ),
    // CPU control
    .fetch_enable_i         ( fetch_enable_i        ),
    .core_sleep_o           ( core_sleep_o          )
  );



  assign core_instr_req.memtype = 2'b00;
  assign core_instr_req.prot    = 3'b000;
  assign core_instr_req.dbg     = 1'b0;

  assign mcycle_o          = 64'h0;
  assign debug_pc_valid_o  = 1'b0;
  assign debug_pc_o        = 32'h0;
`endif

/*******************************************************/
/**                      Core End                     **/
/*******************************************************/
/**      Core Data Demuxing (OBI XBAR) Beginning      **/
/*******************************************************/
  // OBI cut on the EXT manager port (always present)
  obi_cut #(
    .ObiCfg       ( magia_tile_pkg::obi_amo_cfg            ),
    .obi_a_chan_t ( magia_tile_pkg::core_data_obi_a_chan_t ),
    .obi_r_chan_t ( magia_tile_pkg::core_data_obi_r_chan_t ),
    .obi_req_t    ( magia_tile_pkg::core_obi_data_req_t    ),
    .obi_rsp_t    ( magia_tile_pkg::core_obi_data_rsp_t    )
  ) i_obi_cut_ext (
    .clk_i          ( sys_clk                           ),
    .rst_ni         ( rst_ni                            ),
    .sbr_port_req_i ( obi_xbar_slv_req[ObiMgr.ext]      ),
    .sbr_port_rsp_o ( obi_xbar_slv_rsp[ObiMgr.ext]      ),
    .mgr_port_req_o ( obi_xbar_slv_cut_req[ObiMgr.ext]  ),
    .mgr_port_rsp_i ( obi_xbar_slv_cut_rsp[ObiMgr.ext]  )
  );

  // OBI cut on the Spatz CC manager port (only when Spatz CC is present)
  if (TileCfg.EnSpatzCC) begin : gen_spatz_obi_cut
    obi_cut #(
      .ObiCfg       ( magia_tile_pkg::obi_amo_cfg            ),
      .obi_a_chan_t ( magia_tile_pkg::core_data_obi_a_chan_t ),
      .obi_r_chan_t ( magia_tile_pkg::core_data_obi_r_chan_t ),
      .obi_req_t    ( magia_tile_pkg::core_obi_data_req_t    ),
      .obi_rsp_t    ( magia_tile_pkg::core_obi_data_rsp_t    )
    ) i_obi_cut_spatz (
      .clk_i          ( sys_clk                             ),
      .rst_ni         ( rst_ni                              ),
      .sbr_port_req_i ( obi_xbar_slv_req[ObiMgr.spatz]      ),
      .sbr_port_rsp_o ( obi_xbar_slv_rsp[ObiMgr.spatz]      ),
      .mgr_port_req_o ( obi_xbar_slv_cut_req[ObiMgr.spatz]  ),
      .mgr_port_rsp_i ( obi_xbar_slv_cut_rsp[ObiMgr.spatz]  )
    );
  end

  assign obi_xbar_slv_cut_req[ObiMgr.core]  = obi_xbar_slv_req[ObiMgr.core];
  assign obi_xbar_slv_rsp[ObiMgr.core]      = obi_xbar_slv_cut_rsp[ObiMgr.core];

  if (TileCfg.EnCluster) begin : gen_cluster_obi_passthrough
    for (genvar idx_core = 0; idx_core < NClusterCores; idx_core++) begin : gen_cluster_obi_cut_bypass
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
      else $error("magia_tile: OBI access to RedMulE ctrl range (0x%08x) but RedMulE is disabled",
                  core_mem_data_req[ObiSbr.l2].a.addr);
  end
  if (!HasCsrPort) begin: gen_assert_no_csr_access
    assert property (@(posedge sys_clk) disable iff (!rst_ni)
      !(core_mem_data_req[ObiSbr.l2].req &&
        core_mem_data_req[ObiSbr.l2].a.addr >= magia_tile_pkg::TILE_CSR_START &&
        core_mem_data_req[ObiSbr.l2].a.addr <  magia_tile_pkg::TILE_CSR_END))
      else $error("magia_tile: OBI access to Tile CSR range (0x%08x) but no Spatz CC / cluster present",
                  core_mem_data_req[ObiSbr.l2].a.addr);
  end
`endif

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
    .clk_i          ( sys_clk                                               ),
    .rst_ni         ( rst_ni                                                ),
    .testmode_i     ( test_mode_i                                           ),
    .sbr_port_req_i ( core_mem_data_req[ObiSbr.l1]                          ),
    .sbr_port_rsp_o ( core_mem_data_rsp[ObiSbr.l1]                          ),
    .mgr_port_req_o ( core_l1_data_amo_req                                  ),
    .mgr_port_rsp_i ( core_l1_data_amo_rsp                                  )
  );

/*******************************************************/
/**         Core Data Demuxing (OBI XBAR) End         **/
/*******************************************************/
/**         Local Interconnect (HCI) Beginning        **/
/*******************************************************/

   local_interconnect #(
    // Same localparams TileIW is built from - see their definition.
    .N_HWPE               ( NumHwpe                         ),
    .N_DMA                ( NumDma                          ),
    .N_CORE               ( NumHciCore                      ),
    .N_MEM                ( N_MEM_BANKS                     ),
    .EXPFIFO              ( magia_tile_pkg::EXPFIFO         ),
    .MEM_DATA_W           ( magia_tile_pkg::DW_LIC          ),
    .MEM_ADDR_W           ( magia_tile_pkg::AWM             ),
    .MEM_BYTE_W           ( magia_tile_pkg::BW_LIC          ),
    .MEM_USER_W           ( magia_tile_pkg::UW_LIC          ),
    .MEM_ID_W             ( TileIW              ),
    .HCI_SIZE_hwpe        (`HCI_SIZE_PARAM(hci_redmule_if)  ),
    .HCI_SIZE_dma         (`HCI_SIZE_PARAM(hci_dma_if)      ),
    .HCI_SIZE_core        (`HCI_SIZE_PARAM(hci_core_if)     ),
    .HCI_SIZE_mem         (`HCI_SIZE_PARAM(hci_tcdm_sram_if))
  ) i_local_interconnect (
    .clk_i   ( sys_clk          ),
    .rst_ni  ( rst_ni           ),

    .clear_i ( hci_clear        ),
    .ctrl_i  ( hci_ctrl         ),
    
    .hwpe    ( hci_redmule_if   ),
    .dma     ( hci_dma_if       ),
    .core    ( hci_core_if      ),
    .mem     ( hci_tcdm_sram_if )
  );

/*******************************************************/
/**            Local Interconnect (HCI) End           **/
/*******************************************************/
/**              L1 SPM (TCDM) Beginning              **/
/*******************************************************/

  l1_spm #(
    .N_BANK   ( N_MEM_BANKS        ),
    .N_WORDS  ( N_WORDS_BANK       ),
    .DATA_W   ( magia_pkg::DATA_W  ),
    .ID_W     ( TileIW ),
    .SIM_INIT ( "zeros"            )
  ) i_l1_spm (
    .clk_i      ( sys_clk          ),
    .rst_ni     ( rst_ni           ),

    .tcdm_slave ( hci_tcdm_sram_if )
  );

/*******************************************************/
/**                 L1 SPM (TCDM) End                 **/
/*******************************************************/
/**                   iDMA Beginning                  **/
/*******************************************************/

  idma_ctrl_mm #(
    .ERROR_CAP         ( ERROR_CAP                           ),
    .obi_req_t         ( magia_tile_pkg::core_obi_data_req_t ),
    .obi_rsp_t         ( magia_tile_pkg::core_obi_data_rsp_t ),
    .idma_fe_reg_req_t ( magia_tile_pkg::idma_fe_reg_req_t   ),
    .idma_fe_reg_rsp_t ( magia_tile_pkg::idma_fe_reg_rsp_t   ),
    .axi_req_t         ( magia_tile_pkg::idma_axi_req_t      ),
    .axi_rsp_t         ( magia_tile_pkg::idma_axi_rsp_t      ),
    .idma_obi_req_t    ( magia_tile_pkg::idma_obi_req_t      ),
    .idma_obi_rsp_t    ( magia_tile_pkg::idma_obi_rsp_t      )
  ) i_idma_ctrl_mm (
    .clk_i             ( sys_clk                                              ),
    .rst_ni            ( rst_ni                                               ),
    .test_en_i         ( test_mode_i                                          ),
    .clear_i           ( idma_clear                                           ),

    // OBI Slave Interface (CPU memory-mapped access)
    .obi_req_i         ( core_mem_data_req[ObiSbr.idma]                       ),
    .obi_rsp_o         ( core_mem_data_rsp[ObiSbr.idma]                       ),

    // AXI Master Interfaces (to L2 memory)
    .axi_read_req_o    ( idma_axi_read_req_out                                ),
    .axi_read_rsp_i    ( idma_axi_read_rsp_out                                ),
    .axi_write_req_o   ( idma_axi_write_req_out                               ),
    .axi_write_rsp_i   ( idma_axi_write_rsp_out                               ),

    // OBI Master Interfaces (to L1 memory)
    .obi_read_req_o    ( idma_obi_read_req_out                                ),
    .obi_read_rsp_i    ( idma_obi_read_rsp_out                                ),
    .obi_write_req_o   ( idma_obi_write_req_out                               ),
    .obi_write_rsp_i   ( idma_obi_write_rsp_out                               ),

    // Serialized IRQ outputs
    .irq_a2o_busy_o    ( idma_axi2obi_busy                                    ),
    .irq_a2o_start_o   ( idma_axi2obi_start                                   ),
    .irq_a2o_done_o    ( idma_axi2obi_done                                    ),
    .irq_a2o_error_o   ( idma_axi2obi_error                                   ),
    .irq_o2a_busy_o    ( idma_obi2axi_busy                                    ),
    .irq_o2a_start_o   ( idma_obi2axi_start                                   ),
    .irq_o2a_done_o    ( idma_obi2axi_done                                    ),
    .irq_o2a_error_o   ( idma_obi2axi_error                                   )
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
    .mst_req_o        ( idma_axi_req_out       ),
    .mst_resp_i       ( idma_axi_rsp_out       )
  );

/*******************************************************/
/**                      iDMA End                     **/
/*******************************************************/
/**                    i$ Beginning                   **/
/*******************************************************/

  magia_tile_icache_wrap #(
  .NumFetchPorts       ( magia_tile_pkg::NR_FETCH_PORTS       ),
  .L0_LINE_COUNT       ( magia_tile_pkg::L0_LINE_COUNT        ),
  .LINE_WIDTH          ( magia_tile_pkg::LINE_WIDTH           ),
  .LINE_COUNT          ( magia_tile_pkg::LINE_COUNT           ),
  .WAY_COUNT           ( magia_tile_pkg::WAY_COUNT            ),
  .FetchAddrWidth      ( magia_tile_pkg::FETCH_AW             ),
  .FetchDataWidth      ( magia_tile_pkg::FETCH_DW             ),
  .AxiAddrWidth        ( magia_tile_pkg::FILL_AW              ),
  .AxiDataWidth        ( magia_tile_pkg::FILL_DW              ),
  .sram_cfg_data_t     ( /* Not Used */                       ),
  .sram_cfg_tag_t      ( /* Not Used */                       ),
  .axi_req_t           ( magia_tile_pkg::core_axi_instr_req_t ),
  .axi_rsp_t           ( magia_tile_pkg::core_axi_instr_rsp_t )
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
/**                       i$ End                      **/
/*******************************************************/
/**         Data Out - L2 (AXI XBAR) Beginning        **/
/*******************************************************/

  axi_xbar #(
    .Cfg            ( AxiXbarCfg                             ),
    .ATOPs          (                                        ),
    .Connectivity   (                                        ),
    .slv_aw_chan_t  ( magia_tile_pkg::axi_xbar_slv_aw_chan_t ),
    .mst_aw_chan_t  ( magia_pkg::axi_xbar_mst_aw_chan_t      ),
    .w_chan_t       ( magia_pkg::axi_xbar_mst_w_chan_t       ),
    .slv_b_chan_t   ( magia_tile_pkg::axi_xbar_slv_b_chan_t  ),
    .mst_b_chan_t   ( magia_pkg::axi_xbar_mst_b_chan_t       ),
    .slv_ar_chan_t  ( magia_tile_pkg::axi_xbar_slv_ar_chan_t ),
    .mst_ar_chan_t  ( magia_pkg::axi_xbar_mst_ar_chan_t      ),
    .slv_r_chan_t   ( magia_tile_pkg::axi_xbar_slv_r_chan_t  ),
    .mst_r_chan_t   ( magia_pkg::axi_xbar_mst_r_chan_t       ),
    .slv_req_t      ( magia_tile_pkg::axi_xbar_slv_req_t     ),
    .mst_req_t      ( magia_pkg::axi_xbar_mst_req_t          ),
    .slv_resp_t     ( magia_tile_pkg::axi_xbar_slv_rsp_t     ),
    .mst_resp_t     ( magia_pkg::axi_xbar_mst_rsp_t          ),
    .rule_t         ( axi_pkg::xbar_rule_32_t                )
  ) i_axi_xbar (
    .clk_i                  ( sys_clk             ),
    .rst_ni                 ( rst_ni              ),
    .test_i                 ( test_mode_i         ),
    .slv_ports_req_i        ( axi_xbar_slv_req    ),
    .slv_ports_resp_o       ( axi_xbar_slv_rsp    ),
    .mst_ports_req_o        ( axi_xbar_mst_req    ),
    .mst_ports_resp_i       ( axi_xbar_mst_rsp    ),
    .addr_map_i             ( axi_xbar_rule       ),
    .en_default_mst_port_i  ( en_default_mst_port ),
    .default_mst_port_i     ( '0                  )
  );

/*******************************************************/
/**            Data Out - L2 (AXI XBAR) End           **/
/*******************************************************/
/**             FlooNoC Modules Beginning             **/
/*******************************************************/
  
  floo_nw_router #(
    .AxiCfgN      ( AxiCfgN     ),
    .AxiCfgW      ( AxiCfgW     ),
    .RouteAlgo    ( XYRouting   ),
    .NumRoutes    ( 5           ),
    .NumInputs    ( 5           ),
    .NumOutputs   ( 5           ),
    .InFifoDepth  ( 2           ),
    .OutFifoDepth ( 2           ),
    .id_t         ( id_t        ),
    .hdr_t        ( hdr_t       ),
    .floo_req_t   ( floo_req_t  ),
    .floo_rsp_t   ( floo_rsp_t  ),
    .floo_wide_t  ( floo_wide_t )
  ) i_magia_tile_router (
    .clk_i          ( sys_clk              ),
    .rst_ni         ( rst_ni               ),
    .test_enable_i  ( test_mode_i          ),
    .id_i           ( floo_id              ),
    .id_route_map_i ( '0                   ),
    .floo_req_i     ( floo_router_req_in   ),
    .floo_rsp_o     ( floo_router_rsp_out  ),
    .floo_req_o     ( floo_router_req_out  ),
    .floo_rsp_i     ( floo_router_rsp_in   ),
    .floo_wide_i    ( floo_router_wide_in  ),
    .floo_wide_o    ( floo_router_wide_out )
  );

  // Output requests
  assign noc_south_req_o = floo_router_req_out[0];
  assign floo_router_rsp_in[0] = noc_south_rsp_i;
  assign noc_south_wide_o = floo_router_wide_out[0];

  assign noc_east_req_o = floo_router_req_out[1];
  assign floo_router_rsp_in[1] = noc_east_rsp_i;
  assign noc_east_wide_o = floo_router_wide_out[1];

  assign noc_north_req_o = floo_router_req_out[2];
  assign floo_router_rsp_in[2] = noc_north_rsp_i;
  assign noc_north_wide_o = floo_router_wide_out[2];

  assign noc_west_req_o = floo_router_req_out[3];
  assign floo_router_rsp_in[3] = noc_west_rsp_i;
  assign noc_west_wide_o = floo_router_wide_out[3];

  // Input requests
  assign floo_router_req_in[0] = noc_south_req_i;
  assign noc_south_rsp_o = floo_router_rsp_out[0];
  assign floo_router_wide_in[0] = noc_south_wide_i;

  assign floo_router_req_in[1] = noc_east_req_i;
  assign noc_east_rsp_o = floo_router_rsp_out[1];
  assign floo_router_wide_in[1] = noc_east_wide_i;

  assign floo_router_req_in[2] = noc_north_req_i;
  assign noc_north_rsp_o = floo_router_rsp_out[2];
  assign floo_router_wide_in[2] = noc_north_wide_i;

  assign floo_router_req_in[3] = noc_west_req_i;
  assign noc_west_rsp_o = floo_router_rsp_out[3];
  assign floo_router_wide_in[3] = noc_west_wide_i;
  
  floo_nw_chimney #(
    .AxiCfgN              ( AxiCfgN                                  ),
    .AxiCfgW              ( AxiCfgW                                  ),
    .ChimneyCfgN          ( set_ports(ChimneyDefaultCfg, 1'b1, 1'b1) ),
    .ChimneyCfgW          ( set_ports(ChimneyDefaultCfg, 1'b1, 1'b1) ),
    .RouteCfg             ( RouteCfg                                 ),
    .id_t                 ( id_t                                     ),
    .rob_idx_t            ( rob_idx_t                                ),
    .hdr_t                ( hdr_t                                    ),
    .sam_rule_t           ( sam_rule_t                               ),
    .Sam                  ( Sam                                      ),
    .axi_narrow_in_req_t  ( axi_narrow_data_slv_req_t                ),
    .axi_narrow_in_rsp_t  ( axi_narrow_data_slv_rsp_t                ),
    .axi_narrow_out_req_t ( axi_narrow_data_mst_req_t                ),
    .axi_narrow_out_rsp_t ( axi_narrow_data_mst_rsp_t                ),
    .axi_wide_in_req_t    ( axi_wide_data_slv_req_t                  ),
    .axi_wide_in_rsp_t    ( axi_wide_data_slv_rsp_t                  ),
    .axi_wide_out_req_t   ( axi_wide_data_mst_req_t                  ),
    .axi_wide_out_rsp_t   ( axi_wide_data_mst_rsp_t                  ),
    .floo_req_t           ( floo_req_t                               ),
    .floo_rsp_t           ( floo_rsp_t                               ),
    .floo_wide_t          ( floo_wide_t                              )
  ) i_magia_tile_ni (
    .clk_i                ( sys_clk                                           ),
    .rst_ni               ( rst_ni                                            ),
    .test_enable_i        ( test_mode_i                                       ),
    .sram_cfg_i           ( '0                                                ),
    .axi_narrow_in_req_i  ( axi_xbar_mst_req[AxiMst.ext]                      ),
    .axi_narrow_in_rsp_o  ( axi_xbar_mst_rsp[AxiMst.ext]                      ),
    .axi_narrow_out_req_o ( axi_xbar_slv_req[magia_tile_pkg::AXI_SLV_EXT_IDX] ),
    .axi_narrow_out_rsp_i ( axi_xbar_slv_rsp[magia_tile_pkg::AXI_SLV_EXT_IDX] ),
    .axi_wide_in_req_i    ( idma_axi_req_out                                  ),
    .axi_wide_in_rsp_o    ( idma_axi_rsp_out                                  ),
    .axi_wide_out_req_o   ( idma_axi_req_in                                   ),
    .axi_wide_out_rsp_i   ( idma_axi_rsp_in                                   ),
    .id_i                 ( floo_id                                           ),
    .route_table_i        ( '0                                                ),
    .floo_req_o           ( floo_router_req_in[4]                             ),
    .floo_rsp_i           ( floo_router_rsp_out[4]                            ),
    .floo_wide_o          ( floo_router_wide_in[4]                            ),
    .floo_req_i           ( floo_router_req_out[4]                            ),
    .floo_rsp_o           ( floo_router_rsp_in[4]                             ),
    .floo_wide_i          ( floo_router_wide_out[4]                           )
  );

  axi_rw_split #(
    .axi_req_t  ( magia_tile_pkg::idma_axi_req_t ),
    .axi_resp_t ( magia_tile_pkg::idma_axi_rsp_t )
  ) i_axi_rw_split (
    .clk_i            ( sys_clk               ),
    .rst_ni           ( rst_ni                ),
    .slv_req_i        ( idma_axi_req_in       ),
    .slv_resp_o       ( idma_axi_rsp_in       ),
    .mst_read_req_o   ( idma_axi_read_req_in  ),
    .mst_read_resp_i  ( idma_axi_read_rsp_in  ),
    .mst_write_req_o  ( idma_axi_write_req_in ),
    .mst_write_resp_i ( idma_axi_write_rsp_in )
  );

/*******************************************************/
/**                FlooNoC Modules End                **/
/*******************************************************/
/**             Fractal Sync Out Beginning            **/
/*******************************************************/
  
  // Fractal Sync OBI Memory-Mapped Slave
  obi_slave_fsync #(
    .BASE_ADDR    ( magia_tile_pkg::FSYNC_CTRL_ADDR_START ),
    .AGGR_W       ( magia_tile_pkg::FSYNC_AGGR_W          ),
    .ID_W         ( magia_tile_pkg::FSYNC_ID_W            ),
    .NBR_AGGR_W   ( magia_tile_pkg::FSYNC_NBR_AGGR_W      ),
    .NBR_ID_W     ( magia_tile_pkg::FSYNC_NBR_ID_W        )
  ) i_fsync_mm (
    .clk_i          ( sys_clk                                                    ),
    .rst_ni         ( rst_ni                                                     ),
    .clear_i        ( fsync_clear                                                ),
    .obi_req_i      ( core_mem_data_req[ObiSbr.fsync]                            ),
    .obi_rsp_o      ( core_mem_data_rsp[ObiSbr.fsync]                            ),
    .ht_fsync_if_o  ( ht_fsync_if_o                                              ),
    .hn_fsync_if_o  ( hn_fsync_if_o                                              ),
    .vt_fsync_if_o  ( vt_fsync_if_o                                              ),
    .vn_fsync_if_o  ( vn_fsync_if_o                                              ),
    .done_o         ( fsync_done                                                 ),
    .error_o        ( fsync_error                                                )
  );

/*******************************************************/
/**                Fractal Sync Out End               **/
/*******************************************************/
/**           Floating-Point Unit Beginning           **/
/*******************************************************/

`ifdef CV32E40X
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

  xif_if2struct i_xif_if2struct (
    .xif_compressed_if_i  ( xif_if.coproc_compressed ),
    .xif_issue_if_i       ( xif_if.coproc_issue      ),
    .xif_commit_if_i      ( xif_if.coproc_commit     ),
    .xif_mem_if_o         ( xif_if.coproc_mem        ),
    .xif_mem_result_if_i  ( xif_if.coproc_mem_result ),
    .xif_result_if_o      ( xif_if.coproc_result     ),
    .x_compressed_valid_o ( x_compressed_valid                                      ),
    .x_compressed_ready_i ( x_compressed_ready                                      ),
    .x_compressed_req_o   ( x_compressed_req                                        ),
    .x_compressed_resp_i  ( x_compressed_resp                                       ),
    .x_issue_valid_o      ( x_issue_valid                                           ),
    .x_issue_ready_i      ( x_issue_ready                                           ),
    .x_issue_req_o        ( x_issue_req                                             ),
    .x_issue_resp_i       ( x_issue_resp                                            ),
    .x_commit_valid_o     ( x_commit_valid                                          ),
    .x_commit_o           ( x_commit                                                ),
    .x_mem_valid_i        ( x_mem_valid                                             ),
    .x_mem_ready_o        ( x_mem_ready                                             ),
    .x_mem_req_i          ( x_mem_req                                               ),
    .x_mem_resp_o         ( x_mem_resp                                              ),
    .x_mem_result_valid_o ( x_mem_result_valid                                      ),
    .x_mem_result_o       ( x_mem_result                                            ),
    .x_result_valid_i     ( x_result_valid                                          ),
    .x_result_ready_o     ( x_result_ready                                          ),
    .x_result_i           ( x_result                                                )
  );
`endif

/*******************************************************/
/**              Floating-Point Unit End              **/
/*******************************************************/
/**              CSR Response Mux Beginning           **/
/*******************************************************/
  if (HasCsrPort) begin: gen_csr_rsp_mux
    assign core_mem_data_rsp[ObiSbr.csr].gnt          = spatz_csr_rsp.gnt    | cluster_csr_rsp.gnt;
    assign core_mem_data_rsp[ObiSbr.csr].rvalid       = spatz_csr_rsp.rvalid | cluster_csr_rsp.rvalid;
    assign core_mem_data_rsp[ObiSbr.csr].r.rdata      = spatz_csr_rsp.rvalid ? spatz_csr_rsp.r.rdata
                                                                             : cluster_csr_rsp.r.rdata;
    assign core_mem_data_rsp[ObiSbr.csr].r.rid        = '0;
    assign core_mem_data_rsp[ObiSbr.csr].r.err        = spatz_csr_rsp.r.err  | cluster_csr_rsp.r.err;
    assign core_mem_data_rsp[ObiSbr.csr].r.r_optional = '0;
  end


/*******************************************************/
/**                CSR Response Mux End               **/
/*******************************************************/
/**                Event Unit Beginning               **/
/*******************************************************/

  assign eu_events.timer = '0;  // MAGIA has no timer event source

  assign eu_events.dma[magia_tile_pkg::EU_DMA_A2O_DONE] = idma_axi2obi_done;
  assign eu_events.dma[magia_tile_pkg::EU_DMA_O2A_DONE] = idma_obi2axi_done;

  assign eu_events.other[magia_tile_pkg::EU_OTHER_A2O_ERROR]   = idma_axi2obi_error;
  assign eu_events.other[magia_tile_pkg::EU_OTHER_O2A_ERROR]   = idma_obi2axi_error;
  assign eu_events.other[magia_tile_pkg::EU_OTHER_A2O_START]   = idma_axi2obi_start;
  assign eu_events.other[magia_tile_pkg::EU_OTHER_O2A_START]   = idma_obi2axi_start;
  assign eu_events.other[magia_tile_pkg::EU_OTHER_A2O_BUSY]    = idma_axi2obi_busy;
  assign eu_events.other[magia_tile_pkg::EU_OTHER_O2A_BUSY]    = idma_obi2axi_busy;
  assign eu_events.other[magia_tile_pkg::EU_OTHER_FSYNC_DONE]  = fsync_done;
  assign eu_events.other[magia_tile_pkg::EU_OTHER_FSYNC_ERROR] = fsync_error;

  assign eu_events.other[magia_tile_pkg::EU_OTHER_CLUSTER_DONE-1 : 0] = '0;
  assign eu_events.other[magia_tile_pkg::EU_OTHER_SPATZ_START-1  :
                         magia_tile_pkg::EU_OTHER_CLUSTER_DONE+1] = '0;

  // The cluster i$ control signals (prefetch enable, flush) are driven inside
  // gen_pulp_cluster, next to the i$ they belong to.

  // Core busy for the Event Unit (control core)
  assign eu_core_busy = ~core_sleep_o;

  assign core_irq_vec = {13'b0, irq_i[18:16], 4'b0, eu_core_irq_req,
                         3'b0, irq_i[7], 3'b0, irq_i[3], 3'b0};

`ifdef CV32E40X
  assign eu_core_irq_ack    = eu_core_irq_req;
  assign eu_core_irq_ack_id = eu_core_irq_id;
`endif
  
 magia_event_unit #(
    .NB_CORES         ( 1                                          ),  // control core only
    .NB_SW_EVT        ( 1                                          ), 
    .NB_BARR          ( 2                                          ), 
    .NB_HW_MUT        ( 1                                          ), 
    .MUTEX_MSG_W      ( 32                                         ), 
    .DISP_FIFO_DEPTH  ( 1                                          ), 
    .EVNT_WIDTH       ( 8                                          ), 
    .SOC_FIFO_DEPTH   ( 8                                          )  
  ) i_magia_event_unit (
    .clk_i            ( sys_clk                                    ),
    .rst_ni           ( rst_ni                                     ),
    .test_mode_i      ( test_mode_i                                ),

    // Event inputs (control core)
    .acc_events_i     ( eu_events.acc                              ),
    .dma_events_i     ( eu_events.dma                              ),
    .timer_events_i   ( eu_events.timer                            ),
    .other_events_i   ( eu_events.other                            ),

    // Core IRQ interface
    .core_irq_req_o   ( eu_core_irq_req                            ),
    .core_irq_id_o    ( eu_core_irq_id                             ),
    .core_irq_ack_i   ( eu_core_irq_ack                            ),
    .core_irq_ack_id_i( eu_core_irq_ack_id                         ),

    // Core control
    .core_busy_i      ( eu_core_busy                               ),
    .core_clock_en_o  ( eu_core_clk_en                             ),

    .dbg_req_i        ( debug_req_i                                ),
    .core_dbg_req_o   ( eu_core_dbg_req                            ),

    // EU Direct Link Interface (with cut for timing)
    .eu_direct_req_i      ( eu_direct_req_flat                     ),
    .eu_direct_addr_i     ( eu_direct_addr_flat                    ),
    .eu_direct_wen_i      ( eu_direct_wen_flat                     ),
    .eu_direct_wdata_i    ( eu_direct_wdata_flat                   ),
    .eu_direct_be_i       ( eu_direct_be_flat                      ),
    .eu_direct_gnt_o      ( eu_direct_gnt_flat                     ),
    .eu_direct_rvalid_o   ( eu_direct_rvalid_flat                  ),
    .eu_direct_rdata_o    ( eu_direct_rdata_flat                   ),
    .eu_direct_err_o      ( eu_direct_err_flat                     ),
    
    // OBI Peripheral Slave Interface
    .obi_req_i        ( core_mem_data_req[ObiSbr.eu]                               ),
    .obi_rsp_o        ( core_mem_data_rsp[ObiSbr.eu]                               )
  );

/*******************************************************/
/**                    Event Unit End                 **/
/*******************************************************/

/*******************************************************/
/**                  Spatz CC Beginning               **/
/*******************************************************/
if (TileCfg.EnSpatzCC) begin: gen_spatz_cc

  logic spatz_clk_en;
  logic spatz_start;
  logic spatz_done;

  obi_slave_ctrl_spatz #(
    .BaseAddr  ( magia_tile_pkg::TILE_CSR_START )
  ) i_spatz_csr (
    .clk_i     ( sys_clk                        ),
    .rst_ni    ( rst_ni                         ),
    .obi_req_i ( core_mem_data_req[ObiSbr.csr]  ),
    .obi_rsp_o ( spatz_csr_rsp                  ),
    .clk_en_o  ( spatz_clk_en                   ),
    .start_o   ( spatz_start                    ),
    .done_o    ( spatz_done                     )
  );

  // Spatz CC Events
  assign eu_events.acc  [magia_tile_pkg::EU_ACC_SPATZ_DONE]    = spatz_done;
  assign eu_events.other[magia_tile_pkg::EU_OTHER_SPATZ_START] = spatz_start;

  // Spatz CC gated clock
  logic spatz_clk;
  tc_clk_gating spatz_clock_gating (
    .clk_i     ( sys_clk       ),
    .en_i      ( spatz_clk_en  ),
    .test_en_i ( test_mode_i   ),
    .clk_o     ( spatz_clk     )
  );

  // Spatz CC i$ instruction fetch signals
  logic        spatz_inst_req;
  logic [31:0] spatz_inst_addr;
  logic        spatz_inst_cacheable;
  logic        spatz_flush_i_valid;
  logic [31:0] spatz_inst_data;
  logic        spatz_inst_ready;
  logic        spatz_inst_error;
  logic        spatz_flush_i_ready;
  logic        spatz_enable_prefetching;

  
  magia_tile_pkg::core_axi_instr_req_t spatz_icache_axi_req;
  magia_tile_pkg::core_axi_instr_rsp_t spatz_icache_axi_rsp;

  assign axi_xbar_slv_req[magia_tile_pkg::AXI_SLV_SPATZ_INSTR_IDX] = spatz_icache_axi_req;
  assign spatz_icache_axi_rsp = axi_xbar_slv_rsp[magia_tile_pkg::AXI_SLV_SPATZ_INSTR_IDX];

  
  magia_tile_pkg::core_obi_data_req_t spatz_obi_req;
  magia_tile_pkg::core_obi_data_rsp_t spatz_obi_rsp;

  assign obi_xbar_slv_req[ObiMgr.spatz] = spatz_obi_req;
  assign spatz_obi_rsp                  = obi_xbar_slv_rsp[ObiMgr.spatz];

  
  tile_hci_data_req_t [NumSpatzHciPorts-1:0] spatz_hci_req;
  tile_hci_data_rsp_t [NumSpatzHciPorts-1:0] spatz_hci_rsp;

  for (genvar i = 0; i < NumSpatzHciPorts; i++) begin : gen_spatz_hci_assign
    `HCI_ASSIGN_TO_INTF(hci_core_if[i+1], spatz_hci_req[i], spatz_hci_rsp[i])
  end

  // Spatz interrupt + event signals
  snitch_pkg::interrupts_t  spatz_irq;
  snitch_pkg::core_events_t spatz_core_events;
  assign spatz_irq.msip      = 1'b0;              // Machine software interrupt (unused - no multi-core)
  assign spatz_irq.mtip      = 1'b0;              // Machine timer interrupt (unused)
  assign spatz_irq.meip      = spatz_start;        // Machine external interrupt - from the Spatz CSR
  assign spatz_irq.mcip      = 1'b0;              // Machine cluster-local interrupt (unused - no cluster)
  assign spatz_irq.debug     = 1'b0;              // Debug request from external debugger

  spatz_cc_wrapper #(
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
    .clk_i             ( spatz_clk                               ),  // Use gated clock
    .rst_ni            ( rst_ni                                  ),
    .test_mode_i       ( test_mode_i                             ),
    
    // Hart ID
    .hart_id_i         ( mhartid_i                               ),  // Same as CV32
    .tcdm_addr_base_i  ( tile_l1_start_addr                      ),  // Dynamic L1 base per tile
    
    // Interrupts
    .irq_i             ( spatz_irq                               ),
    
    // HCI Master Interface - Connect to HCI interconnect
    .hci_master_req_o  ( spatz_hci_req                           ),
    .hci_master_rsp_i  ( spatz_hci_rsp                           ),
    
    // OBI Master Interface - Connect to OBI crossbar
    .obi_master_req_o  ( spatz_obi_req                           ),
    .obi_master_rsp_i  ( spatz_obi_rsp                           ),
    
    // Instruction Cache Interface
    .inst_req_o        ( spatz_inst_req                          ),
    .inst_addr_o       ( spatz_inst_addr                         ),
    .inst_cacheable_o  ( spatz_inst_cacheable                    ),
    .flush_i_valid_o   ( spatz_flush_i_valid                     ),
    .inst_data_i       ( spatz_inst_data                         ),
    .inst_ready_i      ( spatz_inst_ready                        ),
    .inst_error_i      ( spatz_inst_error                        ),
    .flush_i_ready_i   ( spatz_flush_i_ready                     ),
    
    // Events and status
    .core_events_o     ( spatz_core_events                       )
  );

/*******************************************************/
/**                    Spatz CC End                   **/
/*******************************************************/
/**              Spatz ICache Beginning               **/
/*******************************************************/

  assign spatz_enable_prefetching = 1'b0;  

  snitch_icache #(
    .NR_FETCH_PORTS     ( 1                                                  ), // Single Spatz CC core
    .L0_LINE_COUNT      ( 8                                                  ), // L0 cache lines
    .LINE_WIDTH         ( magia_tile_pkg::SPATZ_ICACHE_LINE_WIDTH            ), // 256 bits
    .LINE_COUNT         ( magia_tile_pkg::SPATZ_ICACHE_LINE_COUNT            ), // 32 lines
    .WAY_COUNT          ( magia_tile_pkg::SPATZ_ICACHE_WAYS                  ), // 2-way set associative
    .FETCH_AW           ( magia_pkg::ADDR_W                                  ), // Address width
    .FETCH_DW           ( 32                                                 ), // 32-bit instructions
    .FILL_AW            ( magia_pkg::ADDR_W                                  ), // AXI address width
    .FILL_DW            ( magia_pkg::DATA_W                                  ), // AXI data width
    .SERIAL_LOOKUP      ( 0                                                  ),
    .L1_TAG_SCM         ( 0                                                  ),
    .NUM_AXI_OUTSTANDING( 2                                                  ),
    .EARLY_LATCH        ( 0                                                  ),
    .L0_EARLY_TAG_WIDTH ( magia_tile_pkg::SPATZ_L0_EARLY_TAG_W               ),
    .ISO_CROSSING       ( 1'b0                                               ),
    .axi_req_t          ( magia_tile_pkg::core_axi_instr_req_t               ),
    .axi_rsp_t          ( magia_tile_pkg::core_axi_instr_rsp_t               )
  ) i_spatz_cc_icache (
    .clk_i                ( spatz_clk                                        ), 
    .clk_d2_i             ( spatz_clk                                        ),  
    .rst_ni               ( rst_ni                                           ),
    .enable_prefetching_i ( spatz_enable_prefetching                         ),
    .icache_l0_events_o   (                                                  ),
    .icache_l1_events_o   (                                                  ), 
    .flush_valid_i        ( spatz_flush_i_valid                              ),
    .flush_ready_o        ( spatz_flush_i_ready                              ),
    .inst_addr_i          ( spatz_inst_addr                                  ),
    .inst_cacheable_i     ( spatz_inst_cacheable                             ),
    .inst_data_o          ( spatz_inst_data                                  ),
    .inst_valid_i         ( spatz_inst_req                                   ),  
    .inst_ready_o         ( spatz_inst_ready                                 ),  
    .inst_error_o         ( spatz_inst_error                                 ),
    .sram_cfg_tag_i       ( '0                                               ),
    .sram_cfg_data_i      ( '0                                               ),
    .axi_req_o            ( spatz_icache_axi_req                             ),
    .axi_rsp_i            ( spatz_icache_axi_rsp                             )
  );

/*******************************************************/
/**                Spatz ICache End                   **/
/*******************************************************/
/**            Spatz Bootrom Beginning                **/
/*******************************************************/
  // AXI to regbus converter for bootrom
  magia_tile_pkg::reg_dma_req_t bootrom_reg_req;
  magia_tile_pkg::reg_dma_rsp_t bootrom_reg_rsp;
  logic [magia_pkg::AXI_NOC_ID_W-1:0] bootrom_reg_id;
  logic bootrom_busy;

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
    .clk_i      ( sys_clk                                                     ),
    .rst_ni     ( rst_ni                                                      ),
    .axi_req_i  ( axi_xbar_mst_req[AxiMst.bootrom]                            ),
    .axi_rsp_o  ( axi_xbar_mst_rsp[AxiMst.bootrom]                            ),
    .reg_req_o  ( bootrom_reg_req                                             ),
    .reg_rsp_i  ( bootrom_reg_rsp                                             ),
    .reg_id_o   ( bootrom_reg_id                                              ),
    .busy_o     ( bootrom_busy                                                )
  );

  // Spatz bootrom module (generated from spatz_init.S)
  spatz_bootrom i_spatz_bootrom (
    .clk_i   ( sys_clk                 ),
    .req_i   ( bootrom_reg_req.valid   ),
    .addr_i  ( bootrom_reg_req.addr    ),
    .rdata_o ( bootrom_reg_rsp.rdata   )
  );
  
  // Regbus response handling instead of macro
  always_ff @(posedge sys_clk or negedge rst_ni) begin
    if (!rst_ni) begin
      bootrom_reg_rsp.ready <= 1'b0;
    end else begin
      bootrom_reg_rsp.ready <= bootrom_reg_req.valid;
    end
  end
  
  assign bootrom_reg_rsp.error = 1'b0;

end else begin: gen_no_spatz_cc

  assign spatz_csr_rsp = '0;
  assign eu_events.acc  [magia_tile_pkg::EU_ACC_SPATZ_DONE]    = 1'b0;
  assign eu_events.other[magia_tile_pkg::EU_OTHER_SPATZ_START] = 1'b0;

  assign axi_xbar_slv_req[magia_tile_pkg::AXI_SLV_SPATZ_INSTR_IDX] = '0;
end

/*******************************************************/
/**              Spatz Bootrom End                    **/
/*******************************************************/

/*******************************************************/
/**            Cluster Beginninng                     **/
/*******************************************************/

if (TileCfg.EnCluster) begin: gen_pulp_cluster

  localparam int unsigned ClusterIcacheLineCount = magia_tile_pkg::CLUSTER_LINES_PER_CORE * NClusterCores;

  // Cluster control-register signals
  logic [31:0]              cluster_boot_addr [NClusterCores-1:0];
  logic [NClusterCores-1:0] cluster_clk_en;
  logic [NClusterCores-1:0] cluster_fetch_enable;
  logic [NClusterCores-1:0] cluster_start_irq;
  logic                     cluster_done;

  // Per-core gated clocks
  logic [NClusterCores-1:0] cluster_clk;

  // Per-core OBI data manager ports (tile OBI crossbar) 
  // per-core HCI data manager ports (HCI interconnect)
  magia_tile_pkg::core_obi_data_req_t [NClusterCores-1:0] cluster_obi_data_req;
  magia_tile_pkg::core_obi_data_rsp_t [NClusterCores-1:0] cluster_obi_data_rsp;
  tile_hci_data_req_t [NClusterCores-1:0] cluster_hci_data_req;
  tile_hci_data_rsp_t [NClusterCores-1:0] cluster_hci_data_rsp;

  // Per-core instruction fetch ports
  magia_tile_pkg::core_instr_req_t [NClusterCores-1:0] cluster_instr_req;
  magia_tile_pkg::core_instr_rsp_t [NClusterCores-1:0] cluster_instr_rsp;

  // Cluster i$ AXI refill ports
  magia_tile_pkg::core_axi_instr_req_t cluster_l2_instr_req;
  magia_tile_pkg::core_axi_instr_rsp_t cluster_l2_instr_rsp;

  // Cluster control registers
  obi_slave_ctrl_cluster #(
    .TileCfg     ( TileCfg                                 ),
    .BaseAddr    ( magia_tile_pkg::TILE_CSR_START + 32'h40 )
  ) i_cluster_csr (
    .clk_i       ( sys_clk                       ),
    .rst_ni      ( rst_ni                        ),
    .obi_req_i   ( core_mem_data_req[ObiSbr.csr] ),
    .obi_rsp_o   ( cluster_csr_rsp               ),
    .clk_en_o    ( cluster_clk_en                ),
    .boot_addr_o ( cluster_boot_addr             ),
    .fetch_en_o  ( cluster_fetch_enable          ),
    .done_o      ( cluster_done                  ),
    .start_irq_o ( cluster_start_irq             )
  );

  // Cluster Events
  assign eu_events.other[magia_tile_pkg::EU_OTHER_CLUSTER_DONE] = cluster_done;

  // Per-core cluster clock cells: pass-through
  for (genvar j = 0; j < NClusterCores; j++) begin : gen_cluster_clk_gate
    tc_clk_gating i_cluster_clk_gate (
      .clk_i     ( sys_clk           ),
      .en_i      ( cluster_clk_en[j] ),
      .test_en_i ( test_mode_i       ),
      .clk_o     ( cluster_clk[j]    )
    );
  end

  // Cluster cores + per-core data demux + OBI/HCI converters.
  magia_cluster_wrap #(
    .TileCfg       ( TileCfg             ),
    .NClusterCores ( NClusterCores       ),
    .hci_req_t     ( tile_hci_data_req_t ),
    .hci_rsp_t     ( tile_hci_data_rsp_t )
  ) i_cluster (
    .sys_clk_i              ( sys_clk              ),  // Gated system clock (dispatch-IRQ FSM)
    .rst_ni                 ( rst_ni               ),
    .test_mode_i            ( test_mode_i          ),
    .cluster_clk_i          ( cluster_clk          ),  // Per-core gated clocks
    .mhartid_i              ( mhartid_i            ),
    .tile_l1_start_addr_i   ( tile_l1_start_addr   ),
    .tile_l1_end_addr_i     ( tile_l1_end_addr     ),
    // Control from the cluster CSR
    .cluster_boot_addr_i    ( cluster_boot_addr    ),
    .cluster_fetch_enable_i ( cluster_fetch_enable ),
    .cluster_start_irq_i    ( cluster_start_irq    ),
    // Per-core data manager ports
    .cluster_obi_data_req_o ( cluster_obi_data_req ),
    .cluster_obi_data_rsp_i ( cluster_obi_data_rsp ),
    .cluster_hci_data_req_o ( cluster_hci_data_req ),
    .cluster_hci_data_rsp_i ( cluster_hci_data_rsp ),
    // Per-core instruction fetch ports (shared cluster i$)
    .cluster_instr_req_o    ( cluster_instr_req    ),
    .cluster_instr_rsp_i    ( cluster_instr_rsp    )
  );

  // OBI xbar path
  for (genvar idx_core = 0; idx_core < NClusterCores; idx_core++) begin: gen_cluster_obi_port
    assign obi_xbar_slv_req[ObiMgr.cluster_base + idx_core] = cluster_obi_data_req[idx_core];
    assign cluster_obi_data_rsp[idx_core] = obi_xbar_slv_rsp[ObiMgr.cluster_base + idx_core];
  end

  // L1/TCDM fast path
  for (genvar idx_core = 0; idx_core < NClusterCores; idx_core++) begin: gen_cluster_hci_assign
    `HCI_ASSIGN_TO_INTF(hci_core_if[1 + NumSpatzHciPorts + idx_core], cluster_hci_data_req[idx_core], cluster_hci_data_rsp[idx_core])
  end

  // Shared cluster instruction cache (outside the core wrapper)
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

  assign cluster_enable_prefetching = 1'b0;
  assign cluster_icache_flush_valid = '0;
  
  for (genvar i = 0; i < NClusterCores; i++) begin : gen_cluster_icache_assign
    assign cluster_cache_req[i]        = cluster_instr_req[i].req;
    assign cluster_cache_addr[i]       = cluster_instr_req[i].addr;
    assign cluster_instr_rsp[i].gnt    = cluster_cache_gnt[i];
    assign cluster_instr_rsp[i].rvalid = cluster_cache_rvalid[i];
    assign cluster_instr_rsp[i].rdata  = cluster_cache_rdata[i];
    assign cluster_instr_rsp[i].err    = cluster_cache_rerror[i];
  end

  // Cluster i$ AXI instruction slave port on the  AXI crossbar
  assign axi_xbar_slv_req[magia_tile_pkg::AXI_SLV_CLUSTER_INSTR_IDX] = cluster_l2_instr_req;
  assign cluster_l2_instr_rsp = axi_xbar_slv_rsp[magia_tile_pkg::AXI_SLV_CLUSTER_INSTR_IDX];

  magia_tile_icache_wrap #(
    .NumFetchPorts       ( NClusterCores                        ),
    .L0_LINE_COUNT       ( ClusterIcacheLineCount               ),
    .LINE_WIDTH          ( magia_tile_pkg::CLUSTER_LINE_WIDTH   ),
    .LINE_COUNT          ( ClusterIcacheLineCount               ),
    .WAY_COUNT           ( magia_tile_pkg::CLUSTER_WAY_COUNT    ),
    .FetchAddrWidth      ( magia_tile_pkg::CLUSTER_FETCH_AW     ),
    .FetchDataWidth      ( magia_tile_pkg::CLUSTER_FETCH_DW     ),
    .AxiAddrWidth        ( magia_tile_pkg::CLUSTER_FILL_AW      ),
    .AxiDataWidth        ( magia_tile_pkg::CLUSTER_FILL_DW      ),
    .sram_cfg_data_t     ( /* Not Used */                       ),
    .sram_cfg_tag_t      ( /* Not Used */                       ),
    .axi_req_t           ( magia_tile_pkg::core_axi_instr_req_t ),
    .axi_rsp_t           ( magia_tile_pkg::core_axi_instr_rsp_t )
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

    .sram_cfg_data_i      ( '0 ),
    .sram_cfg_tag_i       ( '0 ),

    .axi_req_o            ( cluster_l2_instr_req       ),
    .axi_rsp_i            ( cluster_l2_instr_rsp       )
  );

end else begin: gen_no_pulp_cluster

  // No cluster control registers
  assign cluster_csr_rsp = '0;
  assign eu_events.other[magia_tile_pkg::EU_OTHER_CLUSTER_DONE] = 1'b0;

  // PULP cluster absent
  assign axi_xbar_slv_req[magia_tile_pkg::AXI_SLV_CLUSTER_INSTR_IDX] = '0;

end

/*******************************************************/
/**                   Cluster End                     **/
/*******************************************************/

endmodule: magia_tile