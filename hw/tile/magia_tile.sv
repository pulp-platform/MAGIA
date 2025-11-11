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
  *         Luca Balboni <luca.balboni10@studio.unibo.it>
 * 
 * MAGIA Tile
 */

 `include "axi/assign.svh"
 `include "hci/assign.svh"

module magia_tile
  import magia_tile_pkg::*;
  import magia_pkg::*;
  import redmule_pkg::*;
  import hci_package::*;
  import snitch_icache_pkg::*;
  import idma_pkg::*;
  import obi_pkg::*;
  import axi_pkg::*;
  import floo_pkg::*;
  `ifndef TARGET_STANDALONE_TILE
  import magia_noc_pkg::*;
  `else
  import floo_axi_mesh_1x2_noc_pkg::*;
  `endif
#(
  // Parameters used by hci_interconnect and l1_spm
  parameter int unsigned          N_MEM_BANKS              = magia_pkg::N_MEM_BANKS,         // Number of memory banks 
  parameter int unsigned          N_WORDS_BANK             = magia_pkg::N_WORDS_BANK,        // Number of words per memory bank      

  // Parameters used by the core

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
  output floo_req_t                         noc_south_req_o,
  input  floo_rsp_t                         noc_south_rsp_i,

  input  floo_req_t                         noc_east_req_i,
  output floo_rsp_t                         noc_east_rsp_o,
  output floo_req_t                         noc_east_req_o,
  input  floo_rsp_t                         noc_east_rsp_i,

  input  floo_req_t                         noc_north_req_i,
  output floo_rsp_t                         noc_north_rsp_o,
  output floo_req_t                         noc_north_req_o,
  input  floo_rsp_t                         noc_north_rsp_i,

  input  floo_req_t                         noc_west_req_i,
  output floo_rsp_t                         noc_west_rsp_o,
  output floo_req_t                         noc_west_req_o,
  input  floo_rsp_t                         noc_west_rsp_i,

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
  
  magia_tile_pkg::redmule_data_req_t redmule_data_req;
  magia_tile_pkg::redmule_data_rsp_t redmule_data_rsp;

  magia_tile_pkg::redmule_ctrl_req_t redmule_ctrl_req;  // Can be used to manage RedMulE control at top-level
  magia_tile_pkg::redmule_ctrl_rsp_t redmule_ctrl_rsp;  // Can be used to manage RedMulE control at top-level

  // OBI to iDMA Bridge (Memory-mapped interface) - now encapsulated in idma_ctrl_mm

  magia_tile_pkg::core_data_req_t core_data_req;
  magia_tile_pkg::core_data_rsp_t core_data_rsp;

  magia_tile_pkg::core_obi_data_req_t core_obi_data_req;
  magia_tile_pkg::core_obi_data_rsp_t core_obi_data_rsp;

  magia_tile_pkg::core_obi_data_req_t[magia_tile_pkg::N_SBR-1:0] core_mem_data_req; // Index 0 -> L2, Index 1 -> L1SPM, Index 2 -> RedMulE_ctrl, Index 3 -> iDMA_ctrl, Index 4 -> FSync_ctrl
  magia_tile_pkg::core_obi_data_rsp_t[magia_tile_pkg::N_SBR-1:0] core_mem_data_rsp; // Index 0 -> L2, Index 1 -> L1SPM, Index 2 -> RedMulE_ctrl, Index 3 -> iDMA_ctrl, Index 4 -> FSync_ctrl

  magia_tile_pkg::core_obi_data_req_t[magia_tile_pkg::N_SBR-1:0] core_mem_data_cut_req; // Index 0 -> L2, Index 1 -> L1SPM
  magia_tile_pkg::core_obi_data_rsp_t[magia_tile_pkg::N_SBR-1:0] core_mem_data_cut_rsp; // Index 0 -> L2, Index 1 -> L1SPM

  magia_tile_pkg::core_obi_data_req_t core_l1_data_amo_req;
  magia_tile_pkg::core_obi_data_rsp_t core_l1_data_amo_rsp;

  magia_tile_pkg::core_obi_data_req_t[magia_tile_pkg::N_MGR-1:0] obi_xbar_slv_req; // Index 0 -> core request, Index 1 -> ext request
  magia_tile_pkg::core_obi_data_rsp_t[magia_tile_pkg::N_MGR-1:0] obi_xbar_slv_rsp; // Index 0 -> core request, Index 1 -> ext request

  magia_tile_pkg::core_obi_data_req_t[magia_tile_pkg::N_MGR-1:0] obi_xbar_slv_cut_req; // Index 0 -> core request, Index 1 -> ext request
  magia_tile_pkg::core_obi_data_rsp_t[magia_tile_pkg::N_MGR-1:0] obi_xbar_slv_cut_rsp; // Index 0 -> core request, Index 1 -> ext request

  magia_tile_pkg::core_obi_data_req_t ext_obi_data_req;
  magia_tile_pkg::core_obi_data_rsp_t ext_obi_data_rsp;

  magia_tile_pkg::core_hci_data_req_t core_l1_data_req;
  magia_tile_pkg::core_hci_data_rsp_t core_l1_data_rsp;

  magia_tile_pkg::core_axi_data_req_t core_l2_data_req;
  magia_tile_pkg::core_axi_data_rsp_t core_l2_data_rsp;

  magia_tile_pkg::core_instr_req_t core_instr_req;
  magia_tile_pkg::core_instr_rsp_t core_instr_rsp;

  magia_tile_pkg::core_cache_instr_req_t core_cache_instr_req;
  magia_tile_pkg::core_cache_instr_rsp_t core_cache_instr_rsp;

  magia_tile_pkg::core_axi_instr_req_t core_l2_instr_req;
  magia_tile_pkg::core_axi_instr_rsp_t core_l2_instr_rsp;

  magia_tile_pkg::idma_axi_req_t idma_axi_read_req;
  magia_tile_pkg::idma_axi_rsp_t idma_axi_read_rsp;

  magia_tile_pkg::idma_axi_req_t idma_axi_write_req;
  magia_tile_pkg::idma_axi_rsp_t idma_axi_write_rsp;
  
  magia_tile_pkg::idma_axi_req_t idma_axi_req;
  magia_tile_pkg::idma_axi_rsp_t idma_axi_rsp;

  magia_tile_pkg::idma_obi_req_t idma_obi_read_req;
  magia_tile_pkg::idma_obi_rsp_t idma_obi_read_rsp;

  magia_tile_pkg::idma_obi_req_t idma_obi_write_req;
  magia_tile_pkg::idma_obi_rsp_t idma_obi_write_rsp;

  magia_tile_pkg::idma_hci_req_t idma_hci_read_req;
  magia_tile_pkg::idma_hci_rsp_t idma_hci_read_rsp;

  magia_tile_pkg::idma_hci_req_t idma_hci_write_req;
  magia_tile_pkg::idma_hci_rsp_t idma_hci_write_rsp;

  magia_tile_pkg::axi_xbar_slv_req_t[magia_tile_pkg::AxiXbarNoSlvPorts-1:0] axi_xbar_data_in_req; // Index 3 -> ext, Index 2 -> iDMA, Index 1 -> Core Data, Index 0 -> Core Instruction
  magia_tile_pkg::axi_xbar_slv_rsp_t[magia_tile_pkg::AxiXbarNoSlvPorts-1:0] axi_xbar_data_in_rsp; // Index 3 -> ext, Index 2 -> iDMA, Index 1 -> Core Data, Index 0 -> Core Instruction

  magia_pkg::axi_xbar_mst_req_t[magia_tile_pkg::AxiXbarNoMstPorts-1:0] axi_xbar_mst_req;
  magia_pkg::axi_xbar_mst_rsp_t[magia_tile_pkg::AxiXbarNoMstPorts-1:0] axi_xbar_mst_rsp;
  
  magia_pkg::axi_xbar_mst_req_t axi_xbar_data_out_req;
  magia_pkg::axi_xbar_mst_rsp_t axi_xbar_data_out_rsp;

  logic[magia_tile_pkg::axi_xbar_cfg.NoSlvPorts-1:0] en_default_mst_port;
  
  logic                                hci_clear; // Can be used to manage HCI clear at top-level
  hci_package::hci_interconnect_ctrl_t hci_ctrl;  // Can be used to manage HCI control at top-level

  magia_tile_pkg::obi_xbar_rule_t[magia_tile_pkg::N_ADDR_RULE-1:0] obi_xbar_rule;

  axi_pkg::xbar_rule_32_t[magia_tile_pkg::axi_xbar_cfg.NoAddrRules-1:0] axi_xbar_rule;
  
  logic[magia_tile_pkg::N_MGR-1:0]                                obi_xbar_en_default_idx;
  logic[magia_tile_pkg::N_MGR-1:0][magia_tile_pkg::N_BIT_SBR-1:0] obi_xbar_default_idx;

  logic[magia_tile_pkg::AXI_DATA_U_W-1:0] axi_data_user;
  logic[magia_tile_pkg::RUSER_WIDTH-1:0]  obi_rsp_data_user;

  logic[magia_tile_pkg::AXI_INSTR_U_W-1:0] axi_instr_user;
  logic[magia_tile_pkg::RUSER_WIDTH-1:0]   obi_rsp_instr_user;

  logic[magia_tile_pkg::AID_WIDTH-1:0]   axi2obi_req_write_aid;
  logic[magia_tile_pkg::AUSER_WIDTH-1:0] axi2obi_req_write_auser;
  logic[magia_tile_pkg::WUSER_WIDTH-1:0] axi2obi_req_write_wuser;

  logic[magia_tile_pkg::AID_WIDTH-1:0]   axi2obi_req_read_aid;
  logic[magia_tile_pkg::AUSER_WIDTH-1:0] axi2obi_req_read_auser;

  logic                                  axi2obi_rsp_b_user;
  logic                                  axi2obi_rsp_r_user;

  logic idma_clear;         // Can be used to manage iDMA clear at top-level

  
  
  logic sys_clk;
  logic sys_clk_en;

  // Core clock gating signals
  logic core_clk;           // Clock gated per il core
  logic core_clk_en;        // Enable dal tile (sempre attivo)

  // Core output signals
  logic core_busy_o;
  logic        sec_lvl_o;
  logic [14:0] apu_master_flags_o;
  logic [magia_tile_pkg::WAPUTYPE-1:0]  apu_master_type_o; // Use parameter for correct width
  logic [5:0]  apu_master_op_o;
  logic [95:0] apu_master_operands_o;
  logic        apu_master_ready_o;
  logic        apu_master_req_o;
  logic        data_unaligned_o;

  logic[magia_pkg::N_IRQ-1:0]            irq;
  logic                                  redmule_busy;
  logic[magia_tile_pkg::N_CORE-1:0][1:0] redmule_evt;

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

  // iDMA transfer channel IRQ signals
  logic idma_a2o_busy;
  logic idma_a2o_start;
  logic idma_a2o_done;
  logic idma_a2o_error;
  logic idma_o2a_busy;
  logic idma_o2a_start;
  logic idma_o2a_done;
  logic idma_o2a_error;

  // Event arrays for Event Unit (need proper 2D array structure)
  logic [0:0] [3:0] acc_events_array;
  logic [0:0] [1:0] dma_events_array;
  logic [0:0] [1:0] timer_events_array;
  logic [0:0][31:0] other_events_array;

  // FlooNoC connections between NI and router
  floo_req_t [4:0] floo_router_req_in;
  floo_rsp_t [4:0] floo_router_rsp_in;
  floo_req_t [4:0] floo_router_req_out;
  floo_rsp_t [4:0] floo_router_rsp_out;

  // Event Unit signals - Corrected for single-core array interface
  logic [0:0]                         eu_core_irq_req;    // [0:0] array for single core  
  logic [0:0][magia_tile_pkg::EVENT_UNIT_IRQ_WIDTH-1:0] eu_core_irq_id;     // [0:0][4:0] array
  logic [0:0]                         eu_core_irq_ack;    // [0:0] array
  logic [0:0][magia_tile_pkg::EVENT_UNIT_IRQ_WIDTH-1:0] eu_core_irq_ack_id; // [0:0][4:0] array
  logic [0:0]                         eu_core_clk_en;     // [0:0] array
  logic [0:0]                         eu_core_dbg_req;    // [0:0] array

/*******************************************************/
/**          Internal Signal Definitions End          **/
/*******************************************************/
/**            Hardwired Signals Beginning            **/
/*******************************************************/

  assign tile_l1_start_addr       = magia_tile_pkg::L1_ADDR_START       + mhartid_i*magia_tile_pkg::L1_TILE_OFFSET;
  assign tile_l1_end_addr         = magia_tile_pkg::L1_ADDR_END         + mhartid_i*magia_tile_pkg::L1_TILE_OFFSET;
  assign tile_reserved_start_addr = magia_tile_pkg::RESERVED_ADDR_START + mhartid_i*magia_tile_pkg::L1_TILE_OFFSET;
  assign tile_reserved_end_addr   = magia_tile_pkg::RESERVED_ADDR_END   + mhartid_i*magia_tile_pkg::L1_TILE_OFFSET;
  assign tile_redmule_ctrl_start_addr = magia_tile_pkg::REDMULE_CTRL_ADDR_START;
  assign tile_redmule_ctrl_end_addr   = magia_tile_pkg::REDMULE_CTRL_ADDR_END;
  assign tile_idma_ctrl_start_addr = magia_tile_pkg::IDMA_CTRL_ADDR_START;
  assign tile_idma_ctrl_end_addr   = magia_tile_pkg::IDMA_CTRL_ADDR_END;
  assign tile_fsync_ctrl_start_addr = magia_tile_pkg::FSYNC_CTRL_ADDR_START;
  assign tile_fsync_ctrl_end_addr   = magia_tile_pkg::FSYNC_CTRL_ADDR_END;
  assign tile_event_unit_start_addr = magia_tile_pkg::EVENT_UNIT_ADDR_START;
  assign tile_event_unit_end_addr   = magia_tile_pkg::EVENT_UNIT_ADDR_END;

  assign obi_xbar_rule[magia_tile_pkg::L2_IDX]       = '{idx: 32'd0, start_addr: magia_tile_pkg::L2_ADDR_START,    end_addr: magia_tile_pkg::L2_ADDR_END    };
  assign obi_xbar_rule[magia_tile_pkg::L1SPM_IDX]    = '{idx: 32'd1, start_addr: tile_l1_start_addr,               end_addr: tile_l1_end_addr               };
  assign obi_xbar_rule[magia_tile_pkg::RESERVED_IDX] = '{idx: 32'd1, start_addr: tile_reserved_start_addr,         end_addr: tile_reserved_end_addr         };
  assign obi_xbar_rule[magia_tile_pkg::STACK_IDX]    = '{idx: 32'd1, start_addr: magia_tile_pkg::STACK_ADDR_START, end_addr: magia_tile_pkg::STACK_ADDR_END };
  assign obi_xbar_rule[magia_tile_pkg::REDMULE_CTRL_IDX] = '{idx: 32'd2, start_addr: tile_redmule_ctrl_start_addr, end_addr: tile_redmule_ctrl_end_addr     };
  assign obi_xbar_rule[magia_tile_pkg::IDMA_IDX]     = '{idx: 32'd3, start_addr: tile_idma_ctrl_start_addr,        end_addr: tile_idma_ctrl_end_addr        };
  assign obi_xbar_rule[magia_tile_pkg::FSYNC_CTRL_IDX] = '{idx: 32'd4, start_addr: tile_fsync_ctrl_start_addr,     end_addr: tile_fsync_ctrl_end_addr       };


  assign axi_xbar_rule[magia_tile_pkg::L2_IDX]       = '{idx: 32'd0, start_addr: magia_tile_pkg::L2_ADDR_START, end_addr: magia_tile_pkg::L2_ADDR_END };
  assign axi_xbar_rule[magia_tile_pkg::L1SPM_IDX]    = '{idx: 32'd1, start_addr: tile_l1_start_addr,            end_addr: tile_l1_end_addr            };
  assign axi_xbar_rule[magia_tile_pkg::RESERVED_IDX] = '{idx: 32'd1, start_addr: tile_reserved_start_addr,      end_addr: tile_reserved_end_addr      };
  
  assign obi_xbar_en_default_idx = '1; // Routing to the AXI Xbar all requests with an address outside the range of the internal L1 and the external L2
  assign obi_xbar_default_idx    = '0;

  assign axi_xbar_data_in_req[magia_tile_pkg::AXI_IDMA_IDX]       = idma_axi_req;
  assign idma_axi_rsp                                             = axi_xbar_data_in_rsp[magia_tile_pkg::AXI_IDMA_IDX];
  assign axi_xbar_data_in_req[magia_tile_pkg::AXI_CORE_DATA_IDX]  = core_l2_data_req;
  assign core_l2_data_rsp                                         = axi_xbar_data_in_rsp[magia_tile_pkg::AXI_CORE_DATA_IDX];
  assign axi_xbar_data_in_req[magia_tile_pkg::AXI_CORE_INSTR_IDX] = core_l2_instr_req;
  assign core_l2_instr_rsp                                        = axi_xbar_data_in_rsp[magia_tile_pkg::AXI_CORE_INSTR_IDX];

  assign obi_xbar_slv_req[magia_tile_pkg::OBI_CORE_IDX] = core_obi_data_req;
  assign core_obi_data_rsp                              = obi_xbar_slv_rsp[magia_tile_pkg::OBI_CORE_IDX];
  assign obi_xbar_slv_req[magia_tile_pkg::OBI_EXT_IDX]  = ext_obi_data_req;
  assign ext_obi_data_rsp                               = obi_xbar_slv_rsp[magia_tile_pkg::OBI_EXT_IDX];

  assign axi_data_user     = '0;
  assign obi_rsp_data_user = '0;

  assign axi_instr_user     = '0;
  assign obi_rsp_instr_user = '0;

  assign axi2obi_req_write_aid   = '0;
  assign axi2obi_req_write_auser = '0;
  assign axi2obi_req_write_wuser = '0;

  assign axi2obi_req_read_aid   = '0;
  assign axi2obi_req_read_auser = '0;

  assign axi2obi_rsp_b_user = '0;
  assign axi2obi_rsp_r_user = '0;

  assign en_default_mst_port = '1;

  assign hci_clear = 1'b0;
  assign hci_ctrl  = '0;



  assign idma_clear = 1'b0;

  assign fsync_clear = 1'b0;

  // Event Unit provides unified interrupt management
  // External interrupts must be mapped to bit 11 (MEIE - Machine External Interrupt Enable)
  assign irq[magia_pkg::N_IRQ-1:12] = '0;   // Clear all high IRQs
  assign irq[11] = eu_core_irq_req[0];      // Event Unit IRQ mapped to external interrupt (bit 11)
  assign irq[10:8] = '0;                    // Clear IRQs 8-10
  assign irq[7] = 1'b0;                     // Timer interrupt (unused)
  assign irq[6:4] = '0;                     // Clear IRQs 4-6
  assign irq[3] = 1'b0;                     // Software interrupt (unused)
  assign irq[2:0] = '0;                     // Clear IRQs 0-2


/*******************************************************/
/**               Hardwired Signals End               **/
/*******************************************************/
/**             Core Data Demux & Type Conversions   **/
/*******************************************************/

  // Core data demux signals
  magia_tile_pkg::core_data_req_t core_data_req_to_xbar;
  magia_tile_pkg::core_data_rsp_t core_data_rsp_from_xbar;
  magia_tile_pkg::eu_direct_req_t eu_direct_req;
  magia_tile_pkg::eu_direct_rsp_t eu_direct_rsp;

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

  // Convert core data interface to OBI for crossbar
  data2obi_req i_core_data2obi_req (
    .data_req_i ( core_data_req_to_xbar ),
    .obi_req_o  ( core_obi_data_req     )
  );

  obi2data_rsp i_core_obi2data_rsp (
    .obi_rsp_i  ( core_obi_data_rsp         ),
    .data_rsp_o ( core_data_rsp_from_xbar   )
  );
  
  obi2hci_req #(
    .obi_req_t ( magia_tile_pkg::core_obi_data_req_t ),
    .hic_req_t ( magia_tile_pkg::core_hci_data_req_t )
  ) i_core_data_obi2hci_req (
    .obi_req_i ( core_l1_data_amo_req ),
    .hci_req_o ( core_l1_data_req     )
  );

  hci2obi_rsp #(
    .hci_rsp_t ( magia_tile_pkg::core_hci_data_rsp_t ),
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
    .clk_i               ( sys_clk                                   ),
    .rst_ni              ( rst_ni                                    ),
    .obi_req_i           ( core_mem_data_req[magia_tile_pkg::L2_IDX] ),
    .obi_rsp_o           ( core_mem_data_rsp[magia_tile_pkg::L2_IDX] ),
    .user_i              ( axi_data_user                             ),
    .axi_req_o           ( core_l2_data_req                          ),
    .axi_rsp_i           ( core_l2_data_rsp                          ),
    .axi_rsp_channel_sel (                                           ),
    .axi_rsp_b_user_o    (                                           ),
    .axi_rsp_r_user_o    (                                           ),
    .obi_rsp_user_i      ( obi_rsp_data_user                         )
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
    .hic_req_t ( magia_tile_pkg::idma_hci_req_t )
  ) i_idma_obi2hci_req (
    .obi_req_i ( idma_obi_read_req ),
    .hci_req_o ( idma_hci_read_req )
  );

  hci2obi_rsp #(
    .hci_rsp_t ( magia_tile_pkg::idma_hci_rsp_t ),
    .obi_rsp_t ( magia_tile_pkg::idma_obi_rsp_t )
  ) i_idma_hci2obi_rsp (
    .hci_rsp_i ( idma_hci_read_rsp ),
    .obi_rsp_o ( idma_obi_read_rsp )
  );

  obi2hci_req #(
    .obi_req_t ( magia_tile_pkg::idma_obi_req_t ),
    .hic_req_t ( magia_tile_pkg::idma_hci_req_t )
  ) i_idma_obi2hci_write_req (
    .obi_req_i ( idma_obi_write_req ),
    .hci_req_o ( idma_hci_write_req )
  );

  hci2obi_rsp #(
    .hci_rsp_t ( magia_tile_pkg::idma_hci_rsp_t ),
    .obi_rsp_t ( magia_tile_pkg::idma_obi_rsp_t )
  ) i_idma_hci2obi_write_rsp (
    .hci_rsp_i ( idma_hci_write_rsp ),
    .obi_rsp_o ( idma_obi_write_rsp )
  );

  axi_to_obi #(
    .ObiCfg       ( magia_tile_pkg::obi_amo_cfg             ),
    .obi_req_t    ( magia_tile_pkg::core_obi_data_req_t     ),
    .obi_rsp_t    ( magia_tile_pkg::core_obi_data_rsp_t     ),
    .obi_a_chan_t ( magia_tile_pkg::core_data_obi_a_chan_t  ),
    .obi_r_chan_t ( magia_tile_pkg::core_data_obi_r_chan_t  ),
    .AxiAddrWidth ( magia_pkg::ADDR_W                       ),
    .AxiDataWidth ( magia_pkg::DATA_W                       ),
    .AxiIdWidth   ( magia_pkg::AXI_NOC_ID_W                 ),
    .AxiUserWidth ( magia_pkg::AXI_NOC_U_W                  ),
    .MaxTrans     ( 1                                       ),
    .axi_req_t    ( magia_pkg::axi_xbar_mst_req_t           ),
    .axi_rsp_t    ( magia_pkg::axi_xbar_mst_rsp_t           )
  ) i_ext_data_axi2obi (
    .clk_i                  ( sys_clk                                       ),
    .rst_ni                 ( rst_ni                                        ),
    .testmode_i             ( test_mode_i                                   ),
    .axi_req_i              ( axi_xbar_mst_req[magia_tile_pkg::OBI_EXT_IDX] ),
    .axi_rsp_o              ( axi_xbar_mst_rsp[magia_tile_pkg::OBI_EXT_IDX] ),
    .obi_req_o              ( ext_obi_data_req                              ),
    .obi_rsp_i              ( ext_obi_data_rsp                              ),
    .req_aw_id_o            (                                               ),
    .req_aw_user_o          (                                               ),
    .req_w_user_o           (                                               ),
    .req_write_aid_i        ( axi2obi_req_write_aid                         ),
    .req_write_auser_i      ( axi2obi_req_write_auser                       ),
    .req_write_wuser_i      ( axi2obi_req_write_wuser                       ),
    .req_ar_id_o            (                                               ),
    .req_ar_user_o          (                                               ),
    .req_read_aid_i         ( axi2obi_req_read_aid                          ),
    .req_read_auser_i       ( axi2obi_req_read_auser                        ),
    .rsp_write_aw_user_o    (                                               ),
    .rsp_write_w_user_o     (                                               ),
    .rsp_write_bank_strb_o  (                                               ),
    .rsp_write_rid_o        (                                               ),
    .rsp_write_ruser_o      (                                               ),
    .rsp_write_last_o       (                                               ),
    .rsp_write_hs_o         (                                               ),
    .rsp_b_user_i           ( axi2obi_rsp_b_user                            ),
    .rsp_read_ar_user_o     (                                               ),
    .rsp_read_size_enable_o (                                               ),
    .rsp_read_rid_o         (                                               ),
    .rsp_read_ruser_o       (                                               ),
    .rsp_r_user_i           ( axi2obi_rsp_r_user                            )
  );

  // RedMule controller OBI-to-HWPE control interface
  obi2hwpe_ctrl obi2hwpe_ctrl_inst (
    .obi_req_i  ( core_mem_data_req[2]                       ),     
    .obi_rsp_o  ( core_mem_data_rsp[2]                       ),
    .ctrl_req_o ( redmule_ctrl_req                           ),
    .ctrl_rsp_i ( redmule_ctrl_rsp                           )
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

  // Core clock gating controlled by Event Unit
  assign core_clk_en = eu_core_clk_en[0];  // Event Unit controls core clock
       
  
  tc_clk_gating core_clock_gating (
    .clk_i     ( sys_clk     ),
    .en_i      ( core_clk_en ),
    .test_en_i ( test_mode_i ),
    .clk_o     ( core_clk    )
  );

/*******************************************************/
/**                  Clock gating End                 **/
/*******************************************************/
/**           Interface Definitions Beginning         **/
/*******************************************************/

  hci_mem_intf #(
    .AW ( magia_tile_pkg::AWM    ),
    .DW ( magia_tile_pkg::DW_LIC ),
    .BW ( magia_tile_pkg::BW_LIC ),
    .IW ( magia_tile_pkg::IW     ),
    .UW ( magia_tile_pkg::UW_LIC )
  ) hci_tcdm_sram_if[N_MEM_BANKS-1:0] (
    .clk ( sys_clk )
  );
  
  hci_core_intf #(
    .DW ( magia_tile_pkg::DW_LIC ),
    .AW ( magia_tile_pkg::AWC    ),
    .OW ( magia_tile_pkg::AWC    ),
    .UW ( magia_tile_pkg::UW_LIC )
  ) hci_core_if[magia_tile_pkg::N_CORE-1:0] (
    .clk( sys_clk )
  );

  hci_core_intf #(
    .DW ( magia_tile_pkg::REDMULE_DW ),
    .AW ( magia_tile_pkg::AWH        ),
    .OW ( magia_tile_pkg::OWH        ),
    .UW ( magia_tile_pkg::REDMULE_UW )
  ) hci_redmule_if[magia_tile_pkg::N_HWPE-1:0] (
    .clk( sys_clk )
  );

  hci_core_intf #(
    .DW ( magia_tile_pkg::DW_LIC ),
    .AW ( magia_tile_pkg::AWC    ),
    .OW ( magia_tile_pkg::AWC    ),
    .UW ( magia_tile_pkg::UW_LIC )
  ) hci_dma_if[magia_tile_pkg::N_DMA-1:0] (
    .clk( sys_clk )
  );

  hci_core_intf #(
    .DW ( magia_tile_pkg::DW_LIC ),
    .AW ( magia_tile_pkg::AWC    ),
    .OW ( magia_tile_pkg::AWC    ),
    .UW ( magia_tile_pkg::UW_LIC )
  ) hci_ext_if[magia_tile_pkg::N_EXT-1:0] (
    .clk( sys_clk )
  );

/*******************************************************/
/**             Interface Definitions End             **/
/*******************************************************/
/**          Interface Assignments Beginning          **/
/*******************************************************/

  `HCI_ASSIGN_TO_INTF(hci_core_if[0],                                   core_l1_data_req,   core_l1_data_rsp)   // Only 1 core supported
  `HCI_ASSIGN_TO_INTF(hci_redmule_if[0],                                redmule_data_req,   redmule_data_rsp)   // Only 1 RedMulE supported
  `HCI_ASSIGN_TO_INTF(hci_dma_if[magia_tile_pkg::HCI_DMA_CH_READ_IDX],  idma_hci_read_req,  idma_hci_read_rsp)  // iDMA HCI read channel
  `HCI_ASSIGN_TO_INTF(hci_dma_if[magia_tile_pkg::HCI_DMA_CH_WRITE_IDX], idma_hci_write_req, idma_hci_write_rsp) // iDMA HCI write channel

  `AXI_ASSIGN_REQ_STRUCT(axi_xbar_data_out_req, axi_xbar_mst_req[magia_tile_pkg::OBI_CORE_IDX])
  `AXI_ASSIGN_RESP_STRUCT(axi_xbar_mst_rsp[magia_tile_pkg::OBI_CORE_IDX], axi_xbar_data_out_rsp)

/*******************************************************/
/**             Interface Assignments End             **/
/*******************************************************/
/**                 RedMulE Beginning                 **/
/*******************************************************/

  redmule_top #(
    .ID_WIDTH           ( magia_tile_pkg::REDMULE_ID_W       ),
    .N_CORES            ( magia_tile_pkg::N_CORE             ),
    .DW                 ( magia_tile_pkg::REDMULE_DW         ),
    .UW                 ( magia_tile_pkg::REDMULE_UW         ),
    .X_EXT              ( 1'b0                               ), // RedMulE does not implement the eXtension Interface (X) - using HWPE-CTRL mode
    .SysInstWidth       ( magia_pkg::INSTR_W                 ),
    .SysDataWidth       ( magia_pkg::DATA_W                  ),
    .redmule_data_req_t ( magia_tile_pkg::redmule_data_req_t ),
    .redmule_data_rsp_t ( magia_tile_pkg::redmule_data_rsp_t ),
    .redmule_ctrl_req_t ( magia_tile_pkg::redmule_ctrl_req_t ),
    .redmule_ctrl_rsp_t ( magia_tile_pkg::redmule_ctrl_rsp_t )
  ) i_redmule_top (
    .clk_i               ( sys_clk                                                     ),
    .rst_ni              ( rst_ni                                                      ),
    .test_mode_i                                                                        ,

    .busy_o              ( redmule_busy                                                ),
    .evt_o               ( redmule_evt                                                 ),

    .data_req_o          ( redmule_data_req                                            ),
    .data_rsp_i          ( redmule_data_rsp                                            ),

    .ctrl_req_i          ( redmule_ctrl_req                                            ),
    .ctrl_rsp_o          ( redmule_ctrl_rsp                                            )
  );

/*******************************************************/
/**                    RedMulE End                    **/
/*******************************************************/
/**                   Core Beginning                  **/
/*******************************************************/

  // flex-v core with integrated FPU and tracer
  riscv_core #(
    .N_EXT_PERF_COUNTERS ( magia_tile_pkg::N_EXT_PERF_COUNTERS ),
    .INSTR_RDATA_WIDTH   ( magia_tile_pkg::INSTR_RDATA_WIDTH   ),
    .PULP_SECURE         ( magia_tile_pkg::PULP_SECURE         ),
    .N_PMP_ENTRIES       ( magia_tile_pkg::N_PMP_ENTRIES       ),
    .USE_PMP             ( magia_tile_pkg::USE_PMP             ),
    .PULP_CLUSTER        ( magia_tile_pkg::PULP_CLUSTER        ),
    .FPU                 ( magia_tile_pkg::FPU                 ),
    .Zfinx               ( magia_tile_pkg::ZFINX               ),
    .FP_DIVSQRT          ( magia_tile_pkg::FP_DIVSQRT          ),
    .SHARED_FP           ( magia_tile_pkg::SHARED_FP           ),
    .SHARED_DSP_MULT     ( magia_tile_pkg::SHARED_DSP_MULT     ),
    .SHARED_INT_MULT     ( magia_tile_pkg::SHARED_INT_MULT     ),
    .SHARED_INT_DIV      ( magia_tile_pkg::SHARED_INT_DIV      ),
    .SHARED_FP_DIVSQRT   ( magia_tile_pkg::SHARED_FP_DIVSQRT   ),
    .WAPUTYPE            ( magia_tile_pkg::WAPUTYPE            ),
    .APU_NARGS_CPU       ( magia_tile_pkg::APU_NARGS_CPU       ),
    .APU_WOP_CPU         ( magia_tile_pkg::APU_WOP_CPU         ),
    .APU_NDSFLAGS_CPU    ( magia_tile_pkg::APU_NDSFLAGS_CPU    ),
    .APU_NUSFLAGS_CPU    ( magia_tile_pkg::APU_NUSFLAGS_CPU    ),
    .DM_HaltAddress      ( magia_tile_pkg::DM_HALT_ADDR        )
  ) i_cv32e40p_core (
    // Clock and Reset
    .clk_i                  ( core_clk                 ),  // Use gated clock for core
    .rst_ni                 ( rst_ni                   ),
    
    // Clock enable and test mode
    .clock_en_i             ( sys_clk_en               ),
    .test_en_i              ( test_mode_i              ),
    
    // Floating-point register file disable (for Zfinx)
    .fregfile_disable_i     ( 1'b0                     ), // FPU enabled, use dedicated FP regfile
    
    // Boot configuration
    .boot_addr_i            ( boot_addr_i              ),

    // Cluster/Core IDs
    .cluster_id_i           ( mhartid_i[9:4]          ), 
    .core_id_i              ( mhartid_i[3:0]          ),

    // Instruction memory interface
    .instr_req_o            ( core_instr_req.req       ),
    .instr_gnt_i            ( core_instr_rsp.gnt       ),
    .instr_rvalid_i         ( core_instr_rsp.rvalid    ),
    .instr_addr_o           ( core_instr_req.addr      ),
    .instr_rdata_i          ( core_instr_rsp.rdata     ),
    
    // Data memory interface  
    .data_req_o             ( core_data_req.req        ),
    .data_gnt_i             ( core_data_rsp.gnt        ),
    .data_rvalid_i          ( core_data_rsp.rvalid     ),
    .data_addr_o            ( core_data_req.addr       ),
    .data_be_o              ( core_data_req.be         ),
    .data_wdata_o           ( core_data_req.wdata      ),
    .data_we_o              ( core_data_req.we         ),
    .data_rdata_i           ( core_data_rsp.rdata      ),

    // APU interface
    .apu_master_req_o       ( apu_master_req_o        ),
    .apu_master_ready_o     ( apu_master_ready_o      ),
    .apu_master_gnt_i       ( '0                      ),
    
    .apu_master_operands_o  ( apu_master_operands_o   ),
    .apu_master_op_o        ( apu_master_op_o         ),
    .apu_master_type_o      ( apu_master_type_o       ),
    .apu_master_flags_o     ( apu_master_flags_o      ),

    .apu_master_valid_i     ( '0                      ),
    .apu_master_result_i    ( '0                      ),
    .apu_master_flags_i     ( '0                      ),
    
    // Interrupts
    .irq_i                  ( eu_core_irq_req[0]       ),
    .irq_id_i               ( '0                      ), 
    .irq_ack_o              ( eu_core_irq_ack[0]       ),
    .irq_id_o               ( eu_core_irq_ack_id[0]    ),
    .irq_sec_i              ( '0                      ),

    // Security level
    .sec_lvl_o              ( sec_lvl_o               ),
    
    // Debug interface
    .debug_req_i            ( debug_req_i              ),
    
    // CPU control
    .fetch_enable_i         ( fetch_enable_i           ),
    .core_busy_o            ( core_busy_o              ),
    

    // Performance counters
    .ext_perf_counters_i    ( '0                      )
  );

  assign core_sleep_o = !core_busy_o;

/*******************************************************/
/**                      Core End                     **/
/*******************************************************/
/**      Core Data Demuxing (OBI XBAR) Beginning      **/
/*******************************************************/

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
    .clk_i          ( sys_clk                                      ),
    .rst_ni         ( rst_ni                                       ),
    .testmode_i     ( test_mode_i                                  ),
    .sbr_port_req_i ( core_mem_data_req[magia_tile_pkg::L1SPM_IDX] ),
    .sbr_port_rsp_o ( core_mem_data_rsp[magia_tile_pkg::L1SPM_IDX] ),
    .mgr_port_req_o ( core_l1_data_amo_req                         ),
    .mgr_port_rsp_i ( core_l1_data_amo_rsp                         )
  );

  for (genvar i = 0; i < magia_tile_pkg::N_MGR; i++) begin: gen_obi_xbar_sbr_cut
    obi_cut #(
      .ObiCfg       ( magia_tile_pkg::obi_amo_cfg            ),
      .obi_a_chan_t ( magia_tile_pkg::core_data_obi_a_chan_t ),
      .obi_r_chan_t ( magia_tile_pkg::core_data_obi_r_chan_t ),
      .obi_req_t    ( magia_tile_pkg::core_obi_data_req_t    ),
      .obi_rsp_t    ( magia_tile_pkg::core_obi_data_rsp_t    )
    ) i_obi_cut_sbr (
      .clk_i          ( sys_clk                 ),
      .rst_ni         ( rst_ni                  ),
      .sbr_port_req_i ( obi_xbar_slv_req[i]     ),
      .sbr_port_rsp_o ( obi_xbar_slv_rsp[i]     ),
      .mgr_port_req_o ( obi_xbar_slv_cut_req[i] ),
      .mgr_port_rsp_i ( obi_xbar_slv_cut_rsp[i] )
    );
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
    .NumSbrPorts        ( magia_tile_pkg::N_MGR                  ),
    .NumMgrPorts        ( magia_tile_pkg::N_SBR                  ),
    .NumMaxTrans        ( magia_tile_pkg::N_MAX_TRAN             ),
    .NumAddrRules       ( magia_tile_pkg::N_ADDR_RULE            ),
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

  for (genvar i = 0; i < magia_tile_pkg::N_SBR; i++) begin: gen_obi_xbar_mgr_cut
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

/*******************************************************/
/**         Core Data Demuxing (OBI XBAR) End         **/
/*******************************************************/
/**         Local Interconnect (HCI) Beginning        **/
/*******************************************************/

  hci_interconnect #(
    .N_HWPE  ( magia_tile_pkg::N_HWPE  ),
    .N_CORE  ( magia_tile_pkg::N_CORE  ),
    .N_DMA   ( magia_tile_pkg::N_DMA   ),
    .N_EXT   ( magia_tile_pkg::N_EXT   ),
    .N_MEM   ( N_MEM_BANKS             ),
    .AWC     ( magia_tile_pkg::AWC     ),
    .AWM     ( magia_tile_pkg::AWM     ),
    .DW_LIC  ( magia_tile_pkg::DW_LIC  ),
    .BW_LIC  ( magia_tile_pkg::BW_LIC  ),
    .UW_LIC  ( magia_tile_pkg::UW_LIC  ),
    .DW_SIC  (                         ),
    .TS_BIT  ( magia_tile_pkg::TS_BIT  ),
    .IW      ( magia_tile_pkg::IW      ),
    .EXPFIFO ( magia_tile_pkg::EXPFIFO ),
    .DWH     ( magia_tile_pkg::DWH     ),
    .AWH     ( magia_tile_pkg::AWH     ),
    .BWH     ( magia_tile_pkg::BWH     ),
    .WWH     ( magia_tile_pkg::WWH     ),
    .OWH     ( magia_tile_pkg::OWH     ),
    .UWH     ( magia_tile_pkg::UWH     ),
    .SEL_LIC ( magia_tile_pkg::SEL_LIC )
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
    .N_BANK   ( N_MEM_BANKS        ),
    .N_WORDS  ( N_WORDS_BANK       ),
    .DATA_W   ( magia_pkg::DATA_W  ),
    .ID_W     ( magia_tile_pkg::IW ),
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
    .ERROR_CAP         ( ERROR_CAP                         ),
    .obi_req_t         ( magia_tile_pkg::core_obi_data_req_t ),
    .obi_rsp_t         ( magia_tile_pkg::core_obi_data_rsp_t ),
    .idma_fe_reg_req_t ( magia_tile_pkg::idma_fe_reg_req_t   ),
    .idma_fe_reg_rsp_t ( magia_tile_pkg::idma_fe_reg_rsp_t   ),
    .axi_req_t         ( magia_tile_pkg::idma_axi_req_t      ),
    .axi_rsp_t         ( magia_tile_pkg::idma_axi_rsp_t      ),
    .idma_obi_req_t    ( magia_tile_pkg::idma_obi_req_t      ),
    .idma_obi_rsp_t    ( magia_tile_pkg::idma_obi_rsp_t      )
  ) i_idma_ctrl_mm (
    .clk_i             ( sys_clk                             ),
    .rst_ni            ( rst_ni                              ),
    .test_en_i         ( test_mode_i                         ),
    .clear_i           ( idma_clear                          ),

    // OBI Slave Interface (CPU memory-mapped access)
    .obi_req_i         ( core_mem_data_req[3]                ),
    .obi_rsp_o         ( core_mem_data_rsp[3]                ),

    // AXI Master Interfaces (to L2 memory)
    .axi_read_req_o    ( idma_axi_read_req                   ),
    .axi_read_rsp_i    ( idma_axi_read_rsp                   ),
    .axi_write_req_o   ( idma_axi_write_req                  ),
    .axi_write_rsp_i   ( idma_axi_write_rsp                  ),

    // OBI Master Interfaces (to L1 memory)
    .obi_read_req_o    ( idma_obi_read_req                   ),
    .obi_read_rsp_i    ( idma_obi_read_rsp                   ),
    .obi_write_req_o   ( idma_obi_write_req                  ),
    .obi_write_rsp_i   ( idma_obi_write_rsp                  ),

    // Serialized IRQ outputs
    .irq_a2o_busy_o    ( idma_a2o_busy                       ),
    .irq_a2o_start_o   ( idma_a2o_start                      ),
    .irq_a2o_done_o    ( idma_a2o_done                       ),
    .irq_a2o_error_o   ( idma_a2o_error                      ),
    .irq_o2a_busy_o    ( idma_o2a_busy                       ),
    .irq_o2a_start_o   ( idma_o2a_start                      ),
    .irq_o2a_done_o    ( idma_o2a_done                       ),
    .irq_o2a_error_o   ( idma_o2a_error                      )
  );

  axi_rw_join #(
    .axi_req_t  ( magia_tile_pkg::idma_axi_req_t ),
    .axi_resp_t ( magia_tile_pkg::idma_axi_rsp_t )
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

  pulp_icache_wrap #(
  .NumFetchPorts       ( magia_tile_pkg::NR_FETCH_PORTS       ),
  .L0_LINE_COUNT       ( magia_tile_pkg::L0_LINE_COUNT        ),
  .LINE_WIDTH          ( magia_tile_pkg::LINE_WIDTH           ),
  .LINE_COUNT          ( magia_tile_pkg::LINE_COUNT           ),
  .SET_COUNT           ( magia_tile_pkg::SET_COUNT            ),
  .L1DataParityWidth   ( magia_tile_pkg::L0_PARITY_W          ),
  .L0DataParityWidth   ( magia_tile_pkg::L1_PARITY_W          ),
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
    .Cfg            ( magia_tile_pkg::axi_xbar_cfg           ),
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
    .clk_i                  ( sys_clk               ),
    .rst_ni                 ( rst_ni                ),
    .test_i                 ( test_mode_i           ),
    .slv_ports_req_i        ( axi_xbar_data_in_req  ),
    .slv_ports_resp_o       ( axi_xbar_data_in_rsp  ),
    .mst_ports_req_o        ( axi_xbar_mst_req      ),
    .mst_ports_resp_i       ( axi_xbar_mst_rsp      ),
    .addr_map_i             ( axi_xbar_rule         ),
    .en_default_mst_port_i  ( en_default_mst_port   ),
    .default_mst_port_i     ( '0                    )
  );

/*******************************************************/
/**            Data Out - L2 (AXI XBAR) End           **/
/*******************************************************/
/**             FlooNoC modules Beginning             **/
/*******************************************************/
  
  floo_axi_chimney #(
    .AxiCfg         ( AxiCfg                                    ),
    .ChimneyCfg     ( set_ports(ChimneyDefaultCfg, 1'b1, 1'b1)  ),
    .RouteCfg       ( RouteCfg                                  ),
    .id_t           ( id_t                                      ),
    .rob_idx_t      ( rob_idx_t                                 ),
    .hdr_t          ( hdr_t                                     ),
    .sam_rule_t     ( sam_rule_t                                ),
    .Sam            ( Sam                                       ),
    .axi_in_req_t   ( axi_data_slv_req_t                        ),
    .axi_in_rsp_t   ( axi_data_slv_rsp_t                        ),
    .axi_out_req_t  ( axi_data_mst_req_t                        ),
    .axi_out_rsp_t  ( axi_data_mst_rsp_t                        ),
    .floo_req_t     ( floo_req_t                                ),
    .floo_rsp_t     ( floo_rsp_t                                )
  ) i_magia_tile_ni (
    .clk_i          ( sys_clk                                           ),
    .rst_ni         ( rst_ni                                            ),
    .test_enable_i  ( test_mode_i                                       ),
    .sram_cfg_i     ( '0                                                ),
    .axi_in_req_i   ( axi_xbar_data_out_req                             ),
    .axi_in_rsp_o   ( axi_xbar_data_out_rsp                             ),
    .axi_out_req_o  ( axi_xbar_data_in_req[magia_tile_pkg::AXI_EXT_IDX] ),
    .axi_out_rsp_i  ( axi_xbar_data_in_rsp[magia_tile_pkg::AXI_EXT_IDX] ),
    .id_i           ( floo_id                                           ),
    .route_table_i  ( '0                                                ),
    .floo_req_o     ( floo_router_req_in[4]                             ),
    .floo_rsp_i     ( floo_router_rsp_out[4]                            ),
    .floo_req_i     ( floo_router_req_out[4]                            ),
    .floo_rsp_o     ( floo_router_rsp_in[4]                             )
  );

  floo_axi_router #(
    .AxiCfg       ( AxiCfg      ),
    .RouteAlgo    ( XYRouting   ),
    .NumRoutes    ( 5           ),
    .NumInputs    ( 5           ),
    .NumOutputs   ( 5           ),
    .InFifoDepth  ( 2           ),
    .OutFifoDepth ( 2           ),
    .id_t         ( id_t        ),
    .hdr_t        ( hdr_t       ),
    .floo_req_t   ( floo_req_t  ),
    .floo_rsp_t   ( floo_rsp_t  )
  ) i_magia_tile_router (
    .clk_i          ( sys_clk             ),
    .rst_ni         ( rst_ni              ),
    .test_enable_i  ( test_mode_i         ),
    .id_i           ( floo_id             ),
    .id_route_map_i ( '0                  ),
    .floo_req_i     ( floo_router_req_in  ),
    .floo_rsp_o     ( floo_router_rsp_out ),
    .floo_req_o     ( floo_router_req_out ),
    .floo_rsp_i     ( floo_router_rsp_in  )
  );

  // Output requests
  assign noc_south_req_o = floo_router_req_out[0];
  assign floo_router_rsp_in[0] = noc_south_rsp_i;

  assign noc_east_req_o = floo_router_req_out[1];
  assign floo_router_rsp_in[1] = noc_east_rsp_i;

  assign noc_north_req_o = floo_router_req_out[2];
  assign floo_router_rsp_in[2] = noc_north_rsp_i;

  assign noc_west_req_o = floo_router_req_out[3];
  assign floo_router_rsp_in[3] = noc_west_rsp_i;

  // Input requests
  assign floo_router_req_in[0] = noc_south_req_i;
  assign noc_south_rsp_o = floo_router_rsp_out[0];

  assign floo_router_req_in[1] = noc_east_req_i;
  assign noc_east_rsp_o = floo_router_rsp_out[1];

  assign floo_router_req_in[2] = noc_north_req_i;
  assign noc_north_rsp_o = floo_router_rsp_out[2];

  assign floo_router_req_in[3] = noc_west_req_i;
  assign noc_west_rsp_o = floo_router_rsp_out[3];

/*******************************************************/
/**                FlooNoC modules End                **/
/*******************************************************/
/**             Fractal Sync Out Beginning            **/
/*******************************************************/

  // Fractal Sync OBI Memory-Mapped Slave (replaces XIF interface)
  obi_slave_fsync #(
    .BASE_ADDR    ( magia_tile_pkg::FSYNC_CTRL_ADDR_START ),
    .AGGR_W       ( magia_tile_pkg::FSYNC_AGGR_W         ),
    .ID_W         ( magia_tile_pkg::FSYNC_ID_W           ),
    .NBR_AGGR_W   ( magia_tile_pkg::FSYNC_NBR_AGGR_W     ),
    .NBR_ID_W     ( magia_tile_pkg::FSYNC_NBR_ID_W       )
  ) i_fsync_mm (
    .clk_i          ( sys_clk                            ),
    .rst_ni         ( rst_ni                             ),
    .clear_i        ( fsync_clear                        ),
    .obi_req_i      ( core_mem_data_req[4]               ),
    .obi_rsp_o      ( core_mem_data_rsp[4]               ),
    .ht_fsync_if_o  ( ht_fsync_if_o                      ),
    .hn_fsync_if_o  ( hn_fsync_if_o                      ),
    .vt_fsync_if_o  ( vt_fsync_if_o                      ),
    .vn_fsync_if_o  ( vn_fsync_if_o                      ),
    .done_o         ( fsync_done                         ),
    .error_o        ( fsync_error                        )
  );

/*******************************************************/
/**                Fractal Sync Out End               **/
/*******************************************************/
/**                 Event Unit Beginning              **/
/*******************************************************/

  // Event array assignments for proper 2D array structure
  assign acc_events_array[0]     = {redmule_evt[0][1], redmule_evt[0][0], redmule_busy, 1'b0};
  assign dma_events_array[0]     = {idma_o2a_done, idma_a2o_done};
  assign timer_events_array[0]   = 2'b00;
  assign other_events_array[0] = {idma_o2a_busy, idma_a2o_busy, idma_o2a_start, idma_a2o_start, idma_o2a_error, idma_a2o_error, fsync_error, fsync_done, 24'b0};  // iDMA status events [31:28]|idma_o2a_error, idma_a2o_error, iDMA error events [27:26]|fsync_error, fsync_done, Fsync events [25:24]                                                        // Reserved [23:0] - SW events are INTERNAL to Event Unit!

 
  magia_event_unit #(
    .NB_CORES         ( 1                                          ), // Single core system
    .NB_SW_EVT        ( 1                                          ), // Minimum 1 SW event to avoid indexing issues (unused but required)
    .NB_BARR          ( 0                                          ), // No barriers needed with single core
    .NB_HW_MUT        ( 0                                          ), // No mutexes needed with single core
    .MUTEX_MSG_W      ( 32                                         ), // Keep default even if unused
    .DISP_FIFO_DEPTH  ( 0                                          ), // No task dispatcher needed
    .EVNT_WIDTH       ( 8                                          ), // SOC event width (keep default)
    .SOC_FIFO_DEPTH   ( 8                                          )  // SOC FIFO depth (keep default)
  ) i_magia_event_unit (
    .clk_i            ( sys_clk                                    ),
    .rst_ni           ( rst_ni                                     ),
    .test_mode_i      ( test_mode_i                                ),

    // Event inputs - single core arrays
    .acc_events_i     ( acc_events_array     ),                    // Accelerator events
    .dma_events_i     ( dma_events_array     ),                    // iDMA completion events  
    .timer_events_i   ( timer_events_array   ),
    .other_events_i   ( other_events_array   ),                   // Combined events

    // Core IRQ interface
    .core_irq_req_o   ( eu_core_irq_req                            ),
    .core_irq_id_o    ( eu_core_irq_id                             ),
    .core_irq_ack_i   ( eu_core_irq_ack                            ),
    .core_irq_ack_id_i( eu_core_irq_ack_id                         ),

    // Core control
    .core_busy_i      ( core_busy_o                              ),
    .core_clock_en_o  ( eu_core_clk_en                             ),

    // Debug
    .dbg_req_i        ( debug_req_i                                ),
    .core_dbg_req_o   ( eu_core_dbg_req                            ),

    // EU Direct Link Interface - abstract types
    .eu_direct_req_i      ( eu_direct_req.req                      ),
    .eu_direct_addr_i     ( eu_direct_req.addr                     ),
    .eu_direct_wen_i      ( eu_direct_req.wen                      ),
    .eu_direct_wdata_i    ( eu_direct_req.wdata                    ),
    .eu_direct_be_i       ( eu_direct_req.be                       ),
    .eu_direct_gnt_o      ( eu_direct_rsp.gnt                      ),
    .eu_direct_rvalid_o   ( eu_direct_rsp.rvalid                   ),
    .eu_direct_rdata_o    ( eu_direct_rsp.rdata                    ),
    .eu_direct_err_o      ( eu_direct_rsp.err                      )
  );

/*******************************************************/
/**                    Event Unit End                 **/
/*******************************************************/

endmodule: magia_tile