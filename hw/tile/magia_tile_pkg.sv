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
 * MAGIA Tile Package
 */

package magia_tile_pkg;
  /*******************************************************************/
  /*                       Tile Configuration                        */
  /*******************************************************************/

  // Selects which accelerators are instantiated inside the tile 
  typedef magia_pkg::magia_tile_cfg_t magia_tile_cfg_t;

  // Default: All Accelerators are instanstiated
  localparam magia_tile_cfg_t MagiaTileDefaultCfg = magia_pkg::MagiaTileDefaultCfg;

  `include "hci_helpers.svh"
  `include "hwpe_ctrl_helpers.svh"
  `include "obi/typedef.svh"
  `include "axi/typedef.svh"
  `include "register_interface/typedef.svh"
  `include "idma/typedef.svh"
  `include "fractal_sync/typedef.svh"
  `include "reqrsp_interface/typedef.svh"
  `include "tcdm_interface/typedef.svh"

  `include "../include/alias.svh"

  // IRQ constraints
  localparam int unsigned IRQ_IDX_REDMULE_EVT_0 = 31;
  localparam int unsigned IRQ_IDX_REDMULE_EVT_1 = 30;
  localparam int unsigned IRQ_IDX_A2O_ERROR     = 29;
  localparam int unsigned IRQ_IDX_O2A_ERROR     = 28;
  localparam int unsigned IRQ_IDX_A2O_DONE      = 27;
  localparam int unsigned IRQ_IDX_O2A_DONE      = 26;
  localparam int unsigned IRQ_IDX_A2O_START     = 25;
  localparam int unsigned IRQ_IDX_O2A_START     = 24;
  localparam int unsigned IRQ_IDX_A2O_BUSY      = 23;
  localparam int unsigned IRQ_IDX_O2A_BUSY      = 22;
  localparam int unsigned IRQ_IDX_REDMULE_BUSY  = 21;
  localparam int unsigned IRQ_IDX_FSYNC_DONE    = 20;
  localparam int unsigned IRQ_IDX_FSYNC_ERROR   = 19;
  localparam int unsigned IRQ_USED              = 13;

  // Address map
  localparam logic [magia_pkg::ADDR_W-1:0] REDMULE_CTRL_ADDR_START = 32'h0000_0100;
  localparam logic [magia_pkg::ADDR_W-1:0] REDMULE_CTRL_SIZE       = 32'h0000_0100;
  localparam logic [magia_pkg::ADDR_W-1:0] REDMULE_CTRL_ADDR_END   = REDMULE_CTRL_ADDR_START + REDMULE_CTRL_SIZE;
  localparam logic [magia_pkg::ADDR_W-1:0] IDMA_CTRL_ADDR_START    = REDMULE_CTRL_ADDR_END;
  localparam logic [magia_pkg::ADDR_W-1:0] IDMA_CTRL_SIZE          = 32'h0000_0400;
  localparam logic [magia_pkg::ADDR_W-1:0] IDMA_CTRL_ADDR_END      = IDMA_CTRL_ADDR_START + IDMA_CTRL_SIZE;
  localparam logic [magia_pkg::ADDR_W-1:0] FSYNC_CTRL_ADDR_START   = IDMA_CTRL_ADDR_END;
  localparam logic [magia_pkg::ADDR_W-1:0] FSYNC_CTRL_SIZE         = 32'h0000_0100;
  localparam logic [magia_pkg::ADDR_W-1:0] FSYNC_CTRL_ADDR_END     = FSYNC_CTRL_ADDR_START + FSYNC_CTRL_SIZE;
  localparam logic [magia_pkg::ADDR_W-1:0] CTRL_EU_ADDR_START   = FSYNC_CTRL_ADDR_END;
  localparam logic [magia_pkg::ADDR_W-1:0] CTRL_EU_SIZE         = 32'h0000_1000;
  localparam logic [magia_pkg::ADDR_W-1:0] CTRL_EU_ADDR_END     = CTRL_EU_ADDR_START + CTRL_EU_SIZE;
  localparam logic [magia_pkg::ADDR_W-1:0] TILE_CSR_START          = CTRL_EU_ADDR_END;
  localparam logic [magia_pkg::ADDR_W-1:0] TILE_CSR_SIZE           = 32'h0000_0100;
  localparam logic [magia_pkg::ADDR_W-1:0] TILE_CSR_END            = TILE_CSR_START + TILE_CSR_SIZE;
  localparam logic [magia_pkg::ADDR_W-1:0] CLUSTER_EU_DIRECT_START  = TILE_CSR_END;
  localparam logic [magia_pkg::ADDR_W-1:0] CLUSTER_EU_DIRECT_SIZE   = 32'h0000_1000;
  localparam logic [magia_pkg::ADDR_W-1:0] CLUSTER_EU_DIRECT_END    = CLUSTER_EU_DIRECT_START + CLUSTER_EU_DIRECT_SIZE;
  localparam logic [magia_pkg::ADDR_W-1:0] CLUSTER_EU_ADDR_START   = CLUSTER_EU_DIRECT_END;
  localparam logic [magia_pkg::ADDR_W-1:0] CLUSTER_EU_SIZE         = 32'h0000_1000;
  localparam logic [magia_pkg::ADDR_W-1:0] CLUSTER_EU_ADDR_END     = CLUSTER_EU_ADDR_START + CLUSTER_EU_SIZE;
  localparam logic [magia_pkg::ADDR_W-1:0] RESERVED_ADDR_START     = CLUSTER_EU_ADDR_END;
  localparam logic [magia_pkg::ADDR_W-1:0] RESERVED_SIZE           = 32'h0000_C800;
  localparam logic [magia_pkg::ADDR_W-1:0] RESERVED_ADDR_END       = RESERVED_ADDR_START + RESERVED_SIZE;
  localparam logic [magia_pkg::ADDR_W-1:0] STACK_ADDR_START        = RESERVED_ADDR_END;
  localparam logic [magia_pkg::ADDR_W-1:0] STACK_SIZE              = 32'h0001_0000;
  localparam logic [magia_pkg::ADDR_W-1:0] STACK_ADDR_END          = STACK_ADDR_START + STACK_SIZE;
  localparam logic [magia_pkg::ADDR_W-1:0] L1_ADDR_START           = STACK_ADDR_END;
  localparam logic [magia_pkg::ADDR_W-1:0] L1_SIZE                 = 32'h000E_0000;
  localparam logic [magia_pkg::ADDR_W-1:0] L1_ADDR_END             = L1_ADDR_START + L1_SIZE;
  localparam logic [magia_pkg::ADDR_W-1:0] L1_TILE_OFFSET          = 32'h0010_0000;
  localparam logic [magia_pkg::ADDR_W-1:0] L2_ADDR_START           = 32'hC000_0000;
  localparam logic [magia_pkg::ADDR_W-1:0] L2_SIZE                 = 32'h4000_0000;
  localparam logic [magia_pkg::ADDR_W-1:0] L2_ADDR_END             = L2_ADDR_START + L2_SIZE;

  // Instruction region for Spatz code (cacheable region)
  localparam logic [magia_pkg::ADDR_W-1:0] INSTRRAM_ADDR_START      = 32'hCC00_0000;
  localparam logic [magia_pkg::ADDR_W-1:0] INSTRRAM_SIZE            = 32'h0000_8000;  // 32KB

  localparam logic [magia_pkg::ADDR_W-1:0] INSTRRAM_PMA_MASK        = 32'hFFFF_8000;

  // Snitch PMA Configuration - defines cacheable regions for instruction fetches
  localparam snitch_pma_pkg::snitch_pma_t SPATZ_SNITCH_PMA_CFG = '{
    NrCachedRegionRules: 1,
    CachedRegion: '{
      0: '{base: INSTRRAM_ADDR_START, mask: INSTRRAM_PMA_MASK},
      default: '0
    },
    default: 0
  };

  // Spatz parameters 

  localparam bit          SPATZ_RVD_PARAM      = magia_pkg::MagiaSpatzRVD;
  localparam int unsigned SPATZ_NUM_IPU        = magia_pkg::MagiaSpatzNumIPU;
  localparam int unsigned SPATZ_NUM_FPU        = magia_pkg::MagiaSpatzNumFPU;
  localparam bit          SPATZ_XDIVSQRT_PARAM = magia_pkg::MagiaSpatzXDivSqrt;
  localparam bit          SPATZ_XDMA_PARAM     = magia_pkg::MagiaSpatzXDMA;
  localparam bit          SPATZ_RVF_PARAM      = magia_pkg::MagiaSpatzRVF;
  localparam bit          SPATZ_RVV_PARAM      = magia_pkg::MagiaSpatzRVV;
  
  function automatic int unsigned gen_spatz_num_fu(magia_pkg::spatz_cfg_t cfg);
    return (cfg.NumFPU > cfg.NumIPU) ? cfg.NumFPU : cfg.NumIPU;
  endfunction

  function automatic int unsigned gen_spatz_tcdm_ports(magia_pkg::spatz_cfg_t cfg);
    return cfg.RVV ? (gen_spatz_num_fu(cfg) + 1) : 1;
  endfunction

  function automatic int unsigned gen_spatz_hci_ports(magia_pkg::spatz_cfg_t cfg);
    return cfg.RVD ? (gen_spatz_tcdm_ports(cfg) * 2) : gen_spatz_tcdm_ports(cfg);
  endfunction

  function automatic int unsigned gen_tile_spatz_hci_ports(magia_tile_cfg_t cfg);
    return cfg.EnSpatzCC ? gen_spatz_hci_ports(cfg.Spatz) : 0;
  endfunction

  function automatic int unsigned gen_tile_num_hci_core(magia_tile_cfg_t cfg);
    // external/mesh L1 route (via xbar) + ctrl core dedicated direct L1/TCDM port + Spatz TCDM ports + one dedicated L1/TCDM port per cluster core
    return 1 + 1 + gen_tile_spatz_hci_ports(cfg) + (cfg.EnCluster ? cfg.Cluster.NumCores : 0);
  endfunction
  localparam int unsigned SPATZ_HCI_PORTS = gen_spatz_hci_ports(magia_pkg::MagiaSpatzDefaultCfg);

  // Spatz CC outstanding transactions and timing parameters
  parameter int unsigned SPATZ_NUM_INT_OUTSTANDING_LOADS   = 1;   // Snitch core outstanding loads
  parameter int unsigned SPATZ_NUM_INT_OUTSTANDING_MEM     = 4;   // Snitch core outstanding memory ops
  parameter int unsigned SPATZ_NUM_SPATZ_OUTSTANDING_LOADS = 4;   // Spatz vector unit outstanding loads
  parameter bit          SPATZ_XDIVSQRT                    = SPATZ_XDIVSQRT_PARAM; // From Makefile define (0=disabled, 1=enabled)
  parameter bit          SPATZ_XDMA                        = SPATZ_XDMA_PARAM;     // From Makefile define (0=disabled, 1=enabled)
  parameter bit          SPATZ_RVF                         = SPATZ_RVF_PARAM;      // From Makefile define (single-precision FP)
  parameter bit          SPATZ_RVV                         = SPATZ_RVV_PARAM;      // From Makefile define (vector extension)
  parameter bit          SPATZ_REGISTER_OFFLOAD_RSP        = 1'b0; // Pipeline register on offload response
  parameter bit          SPATZ_REGISTER_CORE_REQ           = 1'b1; // Pipeline register on core request
  parameter bit          SPATZ_REGISTER_CORE_RSP           = 1'b1; // Pipeline register on core response
  
  // Spatz FPU implementation configuration
  localparam fpnew_pkg::fpu_implementation_t SPATZ_FPUImplementation = '{
    PipeRegs: // FMA Block
              '{
                '{  3,                           // FP32 FMA
                    SPATZ_RVD_PARAM ? 3 : 0,     // FP64 FMA
                    3,                           // FP16
                    3,                           // FP8
                    3,                           // FP16alt
                    3                            // FP8alt
                  },
                '{1, 1, 1, 1, 1, 1},             // DIVSQRT (all formats)
                '{1, 1, 1, 1, 1, 1},             // NONCOMP (all formats)
                '{2, 2, 2, 2, 2, 2},             // CONV (all formats)
                '{5, 5, 5, 5, 5, 5}              // DOTP
                },
  UnitTypes: '{'{ fpnew_pkg::MERGED,
                  SPATZ_RVD_PARAM ? fpnew_pkg::MERGED : fpnew_pkg::DISABLED,
                  fpnew_pkg::MERGED,
                  fpnew_pkg::MERGED,
                  fpnew_pkg::MERGED,
                  fpnew_pkg::MERGED},           // FMA 
                '{fpnew_pkg::DISABLED,
                  fpnew_pkg::DISABLED,
                  fpnew_pkg::DISABLED,
                  fpnew_pkg::DISABLED,
                  fpnew_pkg::DISABLED,
                  fpnew_pkg::DISABLED},          // DIVSQRT 
                '{fpnew_pkg::PARALLEL,
                  SPATZ_RVD_PARAM ? fpnew_pkg::PARALLEL : fpnew_pkg::DISABLED,
                  fpnew_pkg::PARALLEL,
                  fpnew_pkg::PARALLEL,
                  fpnew_pkg::PARALLEL,
                  fpnew_pkg::PARALLEL},          // NONCOMP 
                '{fpnew_pkg::MERGED,
                  SPATZ_RVD_PARAM ? fpnew_pkg::MERGED : fpnew_pkg::DISABLED,
                  fpnew_pkg::MERGED,
                  fpnew_pkg::MERGED,
                  fpnew_pkg::MERGED,
                  fpnew_pkg::MERGED},            // CONV 
                '{fpnew_pkg::MERGED,
                  SPATZ_RVD_PARAM ? fpnew_pkg::MERGED : fpnew_pkg::DISABLED,
                  fpnew_pkg::MERGED,
                  fpnew_pkg::MERGED,
                  fpnew_pkg::MERGED,
                  fpnew_pkg::MERGED}},           // DOTP 
    PipeConfig: fpnew_pkg::BEFORE 
  };

  // Spatz bootrom parameters
  parameter logic [31:0] SPATZ_BOOT_ADDR          = 32'h1000_0000;  // Spatz bootrom base address
  parameter logic [31:0] SPATZ_BOOTROM_SIZE       = 32'h0000_00FF;
  
  // Spatz TCDM parameters
  parameter int unsigned SPATZ_TCDM_ADDR_WIDTH = $clog2(magia_pkg::N_MEM_BANKS * magia_pkg::N_WORDS_BANK * magia_pkg::DATA_W / 8);  
  parameter int unsigned SPATZ_TCDM_DATA_WIDTH = SPATZ_RVD_PARAM ? 64 : 32;                  // Spatz TCDM data width
  parameter int unsigned SPATZ_TCDM_STRB_WIDTH = SPATZ_RVD_PARAM ? 8 : 4;                    // Spatz TCDM strobe width


  // Parameters used by the HCI
  parameter int unsigned N_CLUSTER_CORES = magia_pkg::MagiaClusterDefaultCfg.NumCores;   // Upper bound for TileCfg.Cluster.NumCores, from the cluster default cfg (per-tile count still comes from the config via gen_tile_num_hci_core) - kept above N_CORE so it can size the cluster L1/TCDM HCI ports. Mirrors how SPATZ_HCI_PORTS derives from MagiaSpatzDefaultCfg.
  parameter int unsigned N_HWPE  = 1;                                                // Number of HWPEs attached to the port
  parameter int unsigned N_CORE  = 1 + 1 + SPATZ_HCI_PORTS + N_CLUSTER_CORES;           // MAX number of core-side HCI ports (obi ext/mesh route + ctrl core direct TCDM port + Spatz TCDM ports + cluster cores L1/TCDM ports) - actual number comes from gen_tile_num_hci_core(); only IW is sized on it
  parameter int unsigned N_DMA   = 4;                                                   // Number of DMA ports (1 out read channel, 1 out write channel, 1 in read channel and 1 in write channel)
  typedef enum logic[1:0]{
    HCI_DMA_OUT_CH_READ_IDX  = 2'b00,
    HCI_DMA_OUT_CH_WRITE_IDX = 2'b01,
    HCI_DMA_IN_CH_READ_IDX   = 2'b10,
    HCI_DMA_IN_CH_WRITE_IDX  = 2'b11
  } hci_idma_ch_idx_e;                                                                  // Index of the HCI DMA read and write channels
  parameter int unsigned N_EXT   = 0;                                                   // Number of External ports - LEAVE TO 0 UNLESS YOU KNOW WHAT YOU ARE DOING
  parameter int unsigned AWC     = magia_pkg::ADDR_W;                                   // Address width core   (slave ports)
  parameter int unsigned DW_LIC  = magia_pkg::DATA_W;                                   // Data Width for Log Interconnect
  parameter int unsigned BW_LIC  = magia_pkg::BYTE_W;                                   // Byte Width for Log Interconnect
  localparam int unsigned AWM    = 
                          $clog2(magia_pkg::N_WORDS_BANK*DW_LIC/BW_LIC);                // Address width memory (master ports)
  parameter int unsigned UW_LIC  = magia_pkg::USR_W;                                    // User Width for Log Interconnect
  localparam int unsigned SW_LIC = DW_LIC/BW_LIC;                                       // Strobe Width for Log Interconnect
  parameter int unsigned TS_BIT  = 21;                                                  // TEST_SET_BIT (for Log Interconnect)
  parameter int unsigned HCI_QOS_NUM = 1;                                               // QoS numerator for wide<narrow arbiter
  parameter int unsigned HCI_QOS_DEN = 2;                                               // QoS denominator for wide<narrow arbiter
  parameter int unsigned IW      = N_HWPE+N_CORE+N_DMA+N_EXT;                           // ID Width HCI
  parameter int unsigned EXPFIFO = 0;                                                   // FIFO Depth for HWPE Interconnect
  parameter int unsigned DWH     = magia_pkg::MagiaRedMuleDefaultCfg.Height *
                                   (magia_pkg::MagiaRedMuleDefaultCfg.NumPipeRegs + 1) * 16 + 32;
  parameter int unsigned AWH     = magia_pkg::ADDR_W;                                   // Address Width for HWPE Interconnect
  parameter int unsigned BWH     = magia_pkg::BYTE_W;                                   // Byte Width for HWPE Interconnect
  parameter int unsigned WWH     = DWH;                                                 // Word Width for HWPE Interconnect
  parameter int unsigned UWH     = magia_pkg::USR_W;                                    // User Width for HWPE Interconnect
  parameter int unsigned SEL_LIC = 1;                                                   // Log interconnect type selector
  localparam int unsigned SWH    = DWH/BWH;                                             // Strobe Width for HWPE Interconnect

  // Parameters used by the cv32e40x core
  parameter bit          X_EXT_EN        = 1;                                           // Enable eXtension Interface (X) support, see eXtension Interface
  parameter int unsigned X_ID_W          = 4;                                           // Identification width for the eXtension interface
  parameter int unsigned X_MEM_W         = 32;                                          // Memory access width for loads/stores via the eXtension interface
  parameter int unsigned X_RFR_W         = 32;                                          // Register file read access width for the eXtension interface
  parameter int unsigned X_RFW_W         = 32;                                          // Register file write access width for the eXtension interface
  parameter bit[31:0]    X_MISA          = 32'h20;                                      // MISA extensions implemented on the eXtension interface, see Machine ISA (misa). X_MISA can only be used to set a subset of the following: {P, V, F, M}
  parameter bit[1 :0]    X_ECS_XS        = 2'b0;                                        // Default value for mstatus.XS if X_EXT = 1, see Machine Status (mstatus)
  parameter bit[31:0]    DM_REGION_START = 32'hF0000000;                                // Start address of Debug Module region, see Debug & Trigger
  parameter bit[31:0]    DM_REGION_END   = 32'hF0003FFF;                                // End address of Debug Module region, see Debug & Trigger
  parameter bit          CLIC_EN         = 1'b0;                                        // Specifies whether Smclic, Smclicshv and Smclicconfig are supported

  // Parameters used by cv32e40p core
  parameter bit          PULP_CLUSTER        = 1'b1;                                    // PULP cluster mode
  parameter bit          FPU                 = 1'b1;                                    // Enable FPU (main feature)
  parameter bit          FP_DIVSQRT          = 1'b1;                                    // FP division and square root
  parameter logic[31:0]  DM_HALT_ADDR        = 32'h1A110800;                            // Debug module halt address

  `ifdef ZFINX_CTRL
    localparam bit ZFINX_CTRL_PARAM    = `ZFINX_CTRL;
  `else
    localparam bit ZFINX_CTRL_PARAM    = 1'b1;
  `endif
  `ifdef ZFINX_CLUSTER
    localparam bit ZFINX_CLUSTER_PARAM = `ZFINX_CLUSTER;
  `else
    localparam bit ZFINX_CLUSTER_PARAM = 1'b1;
  `endif
  parameter bit           ZFINX_CTRL    = ZFINX_CTRL_PARAM;    // Zfinx for the control core
  parameter bit           ZFINX_CLUSTER = ZFINX_CLUSTER_PARAM; // Zfinx for the PULP cluster cores

`ifdef CV32E40X
  parameter int unsigned X_NUM_RS        = 3;                                           // Number of register file read ports that can be used by the eXtension interface
  parameter int unsigned CLIC_ID_W       = 1;                                           // Width of clic_irq_id_i and clic_irq_id_o. The maximum number of supported interrupts in CLIC mode is 2^CLIC_ID_WIDTH. Trap vector table alignment is restricted as described in Machine Trap Vector Table Base Address (mtvt)
`else
  parameter int unsigned X_NUM_RS            = 2;                                       // Number of register file read ports (R-type instructions have 2 source operands)
  parameter int unsigned CLIC_ID_W           = 5;                                       // CLIC interrupt ID width (5 bits for 32 interrupts)
`endif
  parameter int unsigned CLIC_ID_W_CLUSTER    = 5;                                       // cv32e40p irq_id_o/irq_id_i width (fixed, independent of the ctrl core's CLIC_ID_W)
  
  // Parameters used by Event Unit
  parameter int unsigned EVENT_UNIT_IRQ_WIDTH = 5;                                      // Width of Event Unit IRQ ID signals (supports up to 32 different event types)

  // Cluster-private Event Unit configuration
  parameter int unsigned CLUSTER_EU_NB_SW_EVT       = 8;                                // SW events (pulp-sdk uses up to 8)
  parameter int unsigned CLUSTER_EU_NB_HW_MUT       = 1;                                // HW mutexes (pulp_cluster default)
  parameter int unsigned CLUSTER_EU_MUTEX_MSG_W     = 32;                               // HW mutex message width
  parameter int unsigned CLUSTER_EU_DISP_FIFO_DEPTH = 8;                                // Dispatch FIFO depth (IP default; >=4 needed for fork/join)
  parameter int unsigned CLUSTER_EU_EVNT_WIDTH      = 8;                                // SoC event ID width
  parameter int unsigned CLUSTER_EU_SOC_FIFO_DEPTH  = 8;                                // SoC event FIFO depth

  parameter int unsigned REDMULE_DW         = DWH-32;                                   // RedMulE Data Width (default; per-tile in magia_tile.sv)
  parameter int unsigned REDMULE_UW         = UWH;                                      // RedMulE User Width

  // Parameters used by OBI
  parameter int unsigned AUSER_WIDTH  = 1;                                              // Width of the auser signal (see OBI documentation): not used by the CV32E40X
  parameter int unsigned WUSER_WIDTH  = 1;                                              // Width of the wuser signal (see OBI documentation): not used by the CV32E40X
  parameter int unsigned ACHK_WIDTH   = 1;                                              // Width of the achk  signal (see OBI documentation): not used by the CV32E40X
  parameter int unsigned RUSER_WIDTH  = 1;                                              // Width of the ruser signal (see OBI documentation): not used by the CV32E40X
  parameter int unsigned RCHK_WIDTH   = 1;                                              // Width of the rchk  signal (see OBI documentation): not used by the CV32E40X
  parameter int unsigned AID_WIDTH    = 1;                                              // Width of the aid   signal (address channel identifier, see OBI documentation)
  parameter int unsigned RID_WIDTH    = 1;                                              // Width of the rid   signal (response channel identifier, see OBI documentation)
  parameter int unsigned MID_WIDTH    = 1;                                              // Width of the mid   signal (manager identifier, see OBI documentation)
  parameter int unsigned OBI_ID_WIDTH = 1;
  parameter int unsigned N_MAX_TRAN   = 1;                                              // Number of maximum outstanding transactions

  function automatic int unsigned gen_idx_width(int unsigned num);
    return (num > 1) ? $clog2(num) : 1;
  endfunction

  typedef struct packed {
    int unsigned num_mgr;       // Number of managers attached to the crossbar
    int unsigned core;          // Ctrl core data port
    int unsigned ext;           // External (AXI-to-OBI) port
    int unsigned spatz;         // Spatz CC data port      (valid iff EnSpatzCC)
    int unsigned cluster_base;  // First cluster core port (valid iff EnCluster)
  } obi_mgr_map_t;

  function automatic obi_mgr_map_t gen_obi_mgr_map(magia_tile_cfg_t cfg);
    obi_mgr_map_t ret;
    int unsigned  idx;
    ret = '0;
    idx = 0;
    ret.core = idx++;
    ret.ext  = idx++;
    if (cfg.EnSpatzCC) ret.spatz = idx++;
    if (cfg.EnCluster) begin
      ret.cluster_base = idx;
      idx += cfg.Cluster.NumCores;  // per-tile cluster core count (<= N_CLUSTER_CORES max)
    end
    ret.num_mgr = idx;
    return ret;
  endfunction

  typedef struct packed {
    int unsigned num_sbr;    // Number of subordinates attached to the crossbar
    int unsigned num_rules;  // Number of address decode rules
    int unsigned l2;         // AXI crossbar (L2) port - must stay 0: it is the crossbar default port
    int unsigned l1;         // L1 SPM (HCI) port
    int unsigned redmule;    // RedMulE control port (valid iff EnRedMule)
    int unsigned idma;       // iDMA control port
    int unsigned fsync;      // FractalSync control port
    int unsigned eu;         // Event Unit port (control core)
    int unsigned cluster_eu; // Cluster-private Event Unit, memory-mapped view (valid iff EnCluster)
    int unsigned csr;        // Shared control-register port (valid iff EnSpatzCC or EnCluster)
  } obi_sbr_map_t;

  function automatic obi_sbr_map_t gen_obi_sbr_map(magia_tile_cfg_t cfg);
    obi_sbr_map_t ret;
    int unsigned  idx;
    ret = '0;
    idx = 0;
    ret.l2 = idx++;
    ret.l1 = idx++;
    if (cfg.EnRedMule) ret.redmule = idx++;
    ret.idma  = idx++;
    ret.fsync = idx++;
    ret.eu    = idx++;
    if (cfg.EnCluster) ret.cluster_eu = idx++;
    if (cfg.EnSpatzCC || cfg.EnCluster) ret.csr = idx++;  // hosts only Spatz/cluster control registers
    ret.num_sbr = idx;
    ret.num_rules = 7 + 32'(cfg.EnRedMule) + 32'(cfg.EnSpatzCC || cfg.EnCluster) + 32'(cfg.EnCluster);
    return ret;
  endfunction

  /*******************************************************************/
  /*                      Event Unit event map                       */
  /*******************************************************************/
  localparam int unsigned EU_ACC_SPATZ_DONE      = 0;
  localparam int unsigned EU_ACC_REDMULE_BUSY    = 1;
  localparam int unsigned EU_ACC_REDMULE_EVT_0   = 2;
  localparam int unsigned EU_ACC_REDMULE_EVT_1   = 3;

  localparam int unsigned EU_DMA_A2O_DONE        = 0;
  localparam int unsigned EU_DMA_O2A_DONE        = 1;

  localparam int unsigned EU_OTHER_CLUSTER_DONE  = 12;
  localparam int unsigned EU_OTHER_CLUSTER_START = 13;
  localparam int unsigned EU_OTHER_SPATZ_START   = 23;
  localparam int unsigned EU_OTHER_FSYNC_DONE    = 24;
  localparam int unsigned EU_OTHER_FSYNC_ERROR   = 25;
  localparam int unsigned EU_OTHER_A2O_ERROR     = 26;
  localparam int unsigned EU_OTHER_O2A_ERROR     = 27;
  localparam int unsigned EU_OTHER_A2O_START     = 28;
  localparam int unsigned EU_OTHER_O2A_START     = 29;
  localparam int unsigned EU_OTHER_A2O_BUSY      = 30;
  localparam int unsigned EU_OTHER_O2A_BUSY      = 31;

  typedef struct packed {
    logic       busy;
    logic [1:0] evt;    // evt[0]: engine event (RedMulE evt_o); evt[1]: reserved, always 0
  } redmule_events_t;

  // The assembled event bus handed to magia_event_unit (control core only).
  typedef struct packed {
    logic [3:0]  acc;
    logic [1:0]  dma;
    logic [1:0]  timer;
    logic [31:0] other;
  } eu_events_t;

  // Parameters used by AXI
  parameter int unsigned AXI_DATA_ID_W  = 3;                                            // Width of the AXI Data ID (3 bits for 5 slave ports on crossbar: 2^3=8)
  parameter int unsigned AXI_ID_W       = 3;                                            // Width of the AXI Unified Communication Channel ID (3 bits for 5 slave ports)
  parameter int unsigned AXI_DATA_U_W   = magia_pkg::USR_W;                             // Width of the AXI Data User
  parameter int unsigned AXI_INSTR_U_W  = magia_pkg::USR_W;                             // Width of the AXI Instruction User
  parameter int unsigned AXI_U_W        = magia_pkg::USR_W;                             // Width of the AXI Unified Communication Channel User

  // Parameters used by the iDMA
  localparam int unsigned iDMA_NumDims            = 3;                                  // iDMA Number of dimensions
  localparam int unsigned NumDim                  = iDMA_NumDims;                       // Needed by the iDMA typedef (wtf?)
  parameter int unsigned iDMA_DataWidth           = magia_pkg::WIDE_DATA_W;             // iDMA Data Width
  parameter int unsigned iDMA_AddrWidth           = magia_pkg::ADDR_W;                  // iDMA Address Width
  parameter int unsigned iDMA_UserWidth           = AXI_DATA_U_W;                       // iDMA AXI User Width
  parameter int unsigned iDMA_StrbWidth           = magia_pkg::WIDE_STRB_W;             // iDMA AXI Strobe Width
  parameter int unsigned iDMA_AxiIdWidth          = AXI_DATA_ID_W;                      // iDMA AXI ID Width
  parameter int unsigned iDMA_NumAxInFlight       = 16;                                 // iDMA Number of transaction that can be in-flight concurrently
  parameter int unsigned iDMA_BufferDepth         = 3;                                  // iDMA depth of the internal reorder buffer: '2' - minimal possible configuration; '3' - efficiently handle misaligned transfers (recommended)
  parameter int unsigned iDMA_TFLenWidth          = 32;                                 // iDMA With of a transfer: max transfer size is `2**TFLenWidth` bytes
  parameter int unsigned iDMA_MemSysDepth         = 0;                                  // iDMA depth of the memory system the backend is attached to
  parameter int unsigned iDMA_CombinedShifter     = 0;                                  // iDMA Should both data shifts be done before the dataflow element? If this is enabled, then the data inserted into the dataflow element will no longer be word aligned, but only a single shifter is needed
  parameter int unsigned iDMA_RAWCouplingAvail    = 0;                                  // iDMA Should the `R`-`AW` coupling hardware be present? (recommended)
  parameter int unsigned iDMA_MaskInvalidData     = 1;                                  // iDMA Mask invalid data on the manager interface
  parameter int unsigned iDMA_HardwareLegalizer   = 1;                                  // iDMA Should hardware legalization be present? (recommended) If not, software legalization is required to ensure the transfers are AXI4-conformal
  parameter int unsigned iDMA_RejectZeroTransfers = 1;                                  // iDMA Reject zero-length transfers
  parameter int unsigned iDMA_PrintFifoInfo       = 0;                                  // iDMA Print the info of the FIFO configuration
  parameter int unsigned iDMA_NumRegs             = 1;                                  // iDMA Number of configuration register ports
  parameter int unsigned iDMA_NumStreams          = 1;                                  // iDMA Number of streams (max 16)
  parameter int unsigned iDMA_JobFifoDepth        = 16;                                 // iDMA Stream FIFO depth
  parameter int unsigned iDMA_IdCounterWidth      = 32;                                 // iDMA Width of the transfer id (max 32-bit)
  parameter int unsigned iDMA_RepWidth            = 32;                                 // iDMA Width of the reps field
  localparam logic[iDMA_NumDims-1:0][31:0] 
                         iDMA_RepWidths           = '{default: 32'd32};                 // iDMA Width of the counters holding the number of repetitions
  parameter int unsigned iDMA_StrideWidth         = 32;                                 // iDMA Width of the stride field
  typedef enum logic{
    AXI2OBI = 1'b0,
    OBI2AXI = 1'b1
  } idma_transfer_ch_e;                                                                 // iDMA type of transfer channel

  // Parameters used by Fractal Sync (memory-mapped interface)
  parameter int unsigned FSYNC_AGGR_W              = magia_pkg::TILE_FSYNC_AGGR_W;      // Fractal Sync Aggr. width for non-neighbor nodes
  parameter int unsigned FSYNC_LVL_W               = magia_pkg::TILE_FSYNC_LVL_W;       // Fractal Sync Level width for non-neighbor nodes
  parameter int unsigned FSYNC_ID_W                = magia_pkg::TILE_FSYNC_ID_W;        // Fractal Sync Id width for non-neighbor nodes
  parameter int unsigned FSYNC_NBR_AGGR_W          = 1;                                 // Fractal Sync Aggr. width for neighbor nodes
  parameter int unsigned FSYNC_NBR_LVL_W           = 1;                                 // Fractal Sync Level width for neighbor nodes
  parameter int unsigned FSYNC_NBR_ID_W            = 2;                                 // Fractal Sync Id width for neighbor nodes
  parameter bit          FSYNC_STALL               = 1;                                 // Fractal Sync Stall during synchronization

  // Parameters of the AXI XBAR
  parameter int unsigned AxiXbarNoSlvPorts     = 5;                                     // Number of Slave Ports (ext, Core Data, CV32 I$, Spatz I$, Cluster I$)
  localparam int unsigned AxiXbarSlvAxiIDWidth = AXI_DATA_ID_W;                         // Number of bits to indentify each Slave Port
  parameter int unsigned AxiXbarMaxWTrans      = 16;                                    // Maximum number of outstanding transactions per write
  parameter int unsigned AxiXbarMaxMstTrans    = AxiXbarMaxWTrans;                      // Maximum number of outstanding transactions per master
  parameter int unsigned AxiXbarMaxSlvTrans    = AxiXbarMaxWTrans;                      // Maximum number of outstanding transactions per slave
  parameter bit          AxiXbarFallThrough    = 1'b0;                                  // Enabled -> MUX is purely combinational
  parameter bit          AxiXbarSpillAw        = 1'b0;                                  // Enabled -> Spill register on write master ports, +1 cycle of latency on read channels
  parameter bit          AxiXbarSpillW         = 1'b0;                                  // Enabled -> Spill register on write master ports, +1 cycle of latency on read channels
  parameter bit          AxiXbarSpillB         = 1'b0;                                  // Enabled -> Spill register on write master ports, +1 cycle of latency on read channels
  parameter bit          AxiXbarSpillAr        = 1'b0;                                  // Enabled -> Spill register on read master ports, +1 cycle of latency on write channels
  parameter bit          AxiXbarSpillR         = 1'b0;                                  // Enabled -> Spill register on read master ports, +1 cycle of latency on write channels 

  // Parameters used by the i$
  parameter int unsigned NR_FETCH_PORTS = 1;                                            // i$ Number of request (fetch) ports
  parameter int unsigned L0_LINE_COUNT  = 32;                                           // i$ L0 Cache Line Count
  parameter int unsigned LINE_WIDTH     = 128;                                          // i$ Cache Line Width; >= 64
  parameter int unsigned LINE_COUNT     = 32;                                           // i$ The number of cache lines per set. Power of two; >= 2.
  parameter int unsigned WAY_COUNT      = 32;                                           // i$ The set associativity of the cache. Power of two; >= 1.
  parameter int unsigned L0_PARITY_W    = 0;                                            // i$ Parity of the L0 cache
  parameter int unsigned L1_PARITY_W    = L0_PARITY_W;                                  // i$ Parity of the L1 cache
  parameter int unsigned FETCH_AW       = magia_pkg::ADDR_W;                            // i$ Fetch interface address width. Same as FETCH_AW; >= 1.
  parameter int unsigned FETCH_DW       = magia_pkg::DATA_W;                            // i$ Fetch interface data width. Power of two; >= 8.
  parameter int unsigned FILL_AW        = magia_pkg::ADDR_W;                            // i$ Fill interface address width. Same as FILL_AW; >= 1.
  parameter int unsigned FILL_DW        = magia_pkg::DATA_W;                            // i$ Fill interface data width. Power of two; >= 8.

  //Cluster ICache parameters (dedicated icache for cluster cores)
  parameter int unsigned CLUSTER_L0_PARITY_W    = 0;                                            // i$ Parity of the L0 cache
  parameter int unsigned CLUSTER_L1_PARITY_W    = CLUSTER_L0_PARITY_W;                          // i$ Parity of the L1 cache
  parameter int unsigned CLUSTER_FETCH_AW       = magia_pkg::ADDR_W;                            // i$ Fetch interface address width. Same as FETCH_AW; >= 1.
  parameter int unsigned CLUSTER_FETCH_DW       = magia_pkg::DATA_W;                            // i$ Fetch interface data width. Power of two; >= 8.
  parameter int unsigned CLUSTER_FILL_AW        = magia_pkg::ADDR_W;                            // i$ Fill interface address width. Same as FILL_AW; >= 1.
  parameter int unsigned CLUSTER_FILL_DW        = magia_pkg::DATA_W;                            // i$ Fill interface data width. Power of two; >= 8.

  // Parameters used by the FPU
  parameter int unsigned                    FPU_BUFFER_DEPTH   = 8;                     // FPU FIFO depth that buffers instructions coming from core
  parameter bit                             FPU_BUFFER_FT      = 0;                     // FPU FIFO fall through that buffers instructions coming from core
  parameter bit                             FPU_OOO            = 1;                     // FPU enable out-of-order execution
  parameter bit                             FPU_FWD            = 1;                     // FPU enable forwarding from output to input of FPnew
  parameter bit                             FPU_DIVSQRT        = 0;                     // FPU disable FPnew T-head-based DivSqrt unit (supported only for FP32 unit)
  parameter fpnew_pkg::fpu_features_t       FPU_FEATURES       = '{
    Width:         32,
    EnableVectors: 1'b0,
    EnableNanBox:  1'b1,
    FpFmtMask:     6'b100000,
    IntFmtMask:    4'b0010
  };                                                                                    // FPU features: support only for FP32 and INT32
  parameter fpnew_pkg::fpu_implementation_t FPU_IMPLEMENTATION = '{
    PipeRegs:   '{default: 2},
    UnitTypes:  '{'{default: fpnew_pkg::PARALLEL},
                  '{default: fpnew_pkg::MERGED},
                  '{default: fpnew_pkg::PARALLEL},
                  '{default: fpnew_pkg::MERGED},
                  '{default: fpnew_pkg::DISABLED}
                },
    PipeConfig: fpnew_pkg::DISTRIBUTED
  };                                                                                    // FPU implementation

  typedef struct packed {
    int unsigned                 idx;
    logic[magia_pkg::ADDR_W-1:0] start_addr;
    logic[magia_pkg::ADDR_W-1:0] end_addr;
  } obi_xbar_rule_t;


  typedef struct packed {
    logic                         req;
    logic[magia_pkg::INSTR_W-1:0] addr;
    logic[1                   :0] memtype;
    logic[2                   :0] prot;
    logic                         dbg;
  } core_instr_req_t;

  typedef struct packed {
    logic                         gnt;
    logic                         rvalid;
    logic[magia_pkg::INSTR_W-1:0] rdata;
    logic                         err;
  } core_instr_rsp_t;

  typedef struct packed {
    logic                        req;
    logic[magia_pkg::ADDR_W-1:0] addr;
    logic[3                  :0] be;
    logic[magia_pkg::DATA_W-1:0] wdata;
    logic                        we;
  } cv32e40p_core_data_req_t;

  typedef struct packed {
    logic                        gnt;
    logic                        rvalid;
    logic[magia_pkg::DATA_W-1:0] rdata;
    logic                        err;
  } cv32e40p_core_data_rsp_t;

  typedef struct packed {
    logic                        req;
    logic[magia_pkg::ADDR_W-1:0] addr;
    logic[5                  :0] atop;
    logic[3                  :0] be;
    logic[1                  :0] memtype;
    logic[2                  :0] prot;
    logic                        dbg;
    logic[magia_pkg::DATA_W-1:0] wdata;
    logic                        we;
  } cv32e40x_core_data_req_t;

  typedef struct packed {
    logic                        gnt;
    logic                        rvalid;
    logic[magia_pkg::DATA_W-1:0] rdata;
    logic                        err;
    logic                        exokay;
  } cv32e40x_core_data_rsp_t;

`ifdef CV32E40X
  typedef cv32e40x_core_data_req_t core_data_req_t;
  typedef cv32e40x_core_data_rsp_t core_data_rsp_t;
`else
  typedef cv32e40p_core_data_req_t core_data_req_t;
  typedef cv32e40p_core_data_rsp_t core_data_rsp_t;
`endif

  // Core data demux signals: [0] = TCDM (L1) direct path, [1] = OBI xbar (default), [2] = EU direct link window
  localparam int unsigned CORE_DATA_DEMUX_N_SLV    = 3;
  localparam int unsigned CORE_DATA_DEMUX_TCDM_IDX = 0;
  localparam int unsigned CORE_DATA_DEMUX_OBI_IDX  = 1;
  localparam int unsigned CORE_DATA_DEMUX_EU_IDX   = 2;

  // EU Direct Link interface types
  typedef struct packed {
    logic                        req;
    logic[magia_pkg::ADDR_W-1:0] addr;
    logic                        wen;      // Write enable negated (EU convention)
    logic[magia_pkg::DATA_W-1:0] wdata;
    logic[3                  :0] be;
  } eu_direct_req_t;

  typedef struct packed {
    logic                        gnt;
    logic                        rvalid;
    logic[magia_pkg::DATA_W-1:0] rdata;
    logic                        err;       // Error signal (r_opc from XBAR_PERIPH_BUS)
  } eu_direct_rsp_t;

  typedef struct packed {
    logic[NR_FETCH_PORTS-1:0]               req;
    logic[NR_FETCH_PORTS-1:0][FETCH_AW-1:0] addr;
  } core_cache_instr_req_t;

  typedef struct packed {
    logic[NR_FETCH_PORTS-1:0]               gnt;
    logic[NR_FETCH_PORTS-1:0]               rvalid;
    logic[NR_FETCH_PORTS-1:0][FETCH_DW-1:0] rdata;
    logic[NR_FETCH_PORTS-1:0]               rerror;
  } core_cache_instr_rsp_t;

  typedef enum logic[2:0]{
    AXI_XBAR_STACK_IDX    = 4,
    AXI_XBAR_RESERVED_IDX = 3,
    AXI_XBAR_L1SPM_IDX    = 2,
    AXI_XBAR_BOOTROM_IDX  = 1, 
    AXI_XBAR_L2_IDX       = 0
  } axi_mem_array_idx_e;

  typedef enum logic[2:0]{
    AXI_SLV_CLUSTER_INSTR_IDX = 4,
    AXI_SLV_SPATZ_INSTR_IDX   = 3,
    AXI_SLV_EXT_IDX           = 2,
    AXI_SLV_CORE_DATA_IDX     = 1,
    AXI_SLV_CORE_INSTR_IDX    = 0
  } axi_xbar_slv_idx_e;

  
  typedef enum logic[1:0]{
    AXI_MST_EXT_IDX     = 0,
    AXI_MST_OBI_IDX     = 1,
    AXI_MST_BOOTROM_IDX = 2
  } axi_xbar_mst_idx_e;


  typedef logic[iDMA_AddrWidth-1:0] idma_addr_t;

  `HWPE_CTRL_TYPEDEF_REQ_T(redmule_ctrl_req_t, logic[AWC-1:0], logic[DWH-1:0], logic[SWH-1:0], logic[IW-1:0])
  `HWPE_CTRL_TYPEDEF_RSP_T(redmule_ctrl_rsp_t, logic[DWH-1:0], logic[IW-1:0])

  `HCI_TYPEDEF_REQ_T(redmule_data_req_t, logic[AWC-1:0], logic[DWH-1:0], logic[SWH-1:0], logic[UWH-1:0], logic[IW-1:0], logic[0:0], logic[0:0])
  `HCI_TYPEDEF_RSP_T(redmule_data_rsp_t, logic[DWH-1:0], logic[UWH-1:0],  logic[IW-1:0], logic[0:0], logic[0:0])

  localparam obi_pkg::obi_optional_cfg_t obi_amo_optional_cfg = obi_pkg::obi_all_optional_config(AUSER_WIDTH, WUSER_WIDTH, RUSER_WIDTH, MID_WIDTH, ACHK_WIDTH, RCHK_WIDTH);
  localparam obi_pkg::obi_optional_cfg_t obi_no_amo_optional_cfg = '{UseAtop: 1'b0, UseMemtype: 1'b0, UseProt: 1'b0, UseDbg: 1'b0, AUserWidth: AUSER_WIDTH, WUserWidth: WUSER_WIDTH, RUserWidth: RUSER_WIDTH, MidWidth: MID_WIDTH, AChkWidth: ACHK_WIDTH, RChkWidth: RCHK_WIDTH};
  
  // OBI full configurations - 32-bit (default)
  localparam obi_pkg::obi_cfg_t obi_amo_cfg = obi_pkg::obi_default_cfg(magia_pkg::ADDR_W, magia_pkg::DATA_W, OBI_ID_WIDTH, obi_amo_optional_cfg);
  localparam obi_pkg::obi_cfg_t obi_no_amo_cfg = obi_pkg::obi_default_cfg(magia_pkg::ADDR_W, magia_pkg::DATA_W, OBI_ID_WIDTH, obi_no_amo_optional_cfg);
  
  // OBI full configurations - 64-bit
  localparam obi_pkg::obi_cfg_t obi_amo_cfg_64 = obi_pkg::obi_default_cfg(magia_pkg::ADDR_W, SPATZ_TCDM_DATA_WIDTH, OBI_ID_WIDTH, obi_amo_optional_cfg);
  localparam obi_pkg::obi_cfg_t obi_no_amo_cfg_64 = obi_pkg::obi_default_cfg(magia_pkg::ADDR_W, SPATZ_TCDM_DATA_WIDTH, OBI_ID_WIDTH, obi_no_amo_optional_cfg);
  localparam bit                         RegisterAmo          = 1;
  
  `OBI_TYPEDEF_ALL_A_OPTIONAL(core_data_obi_a_optional_t, AUSER_WIDTH, WUSER_WIDTH, MID_WIDTH, ACHK_WIDTH)
  `OBI_TYPEDEF_ALL_R_OPTIONAL(core_data_obi_r_optional_t, RUSER_WIDTH, RCHK_WIDTH)
  `OBI_TYPEDEF_A_CHAN_T(core_data_obi_a_chan_t, magia_pkg::ADDR_W, magia_pkg::DATA_W, AID_WIDTH, core_data_obi_a_optional_t)
  `OBI_TYPEDEF_R_CHAN_T(core_data_obi_r_chan_t, magia_pkg::DATA_W, RID_WIDTH, core_data_obi_r_optional_t)
  `OBI_TYPEDEF_DEFAULT_REQ_T(core_obi_data_req_t, core_data_obi_a_chan_t)
  `OBI_TYPEDEF_RSP_T(core_obi_data_rsp_t, core_data_obi_r_chan_t)

  `OBI_TYPEDEF_ALL_A_OPTIONAL(core_instr_obi_a_optional_t, AUSER_WIDTH, WUSER_WIDTH, MID_WIDTH, ACHK_WIDTH)
  `OBI_TYPEDEF_ALL_R_OPTIONAL(core_instr_obi_r_optional_t, RUSER_WIDTH, RCHK_WIDTH)
  `OBI_TYPEDEF_A_CHAN_T(core_instr_obi_a_chan_t, magia_pkg::ADDR_W, magia_pkg::DATA_W, AID_WIDTH, core_instr_obi_a_optional_t)
  `OBI_TYPEDEF_R_CHAN_T(core_instr_obi_r_chan_t, magia_pkg::DATA_W, RID_WIDTH, core_instr_obi_r_optional_t)
  `OBI_TYPEDEF_DEFAULT_REQ_T(core_obi_instr_req_t, core_instr_obi_a_chan_t)
  `OBI_TYPEDEF_RSP_T(core_obi_instr_rsp_t, core_instr_obi_r_chan_t)

  `HCI_TYPEDEF_REQ_T(core_hci_data_req_t, logic[AWC-1:0], logic[DW_LIC-1:0], logic[SW_LIC-1:0], logic[UWH-1:0], logic[IW-1:0], logic[0:0], logic[0:0])
  `HCI_TYPEDEF_RSP_T(core_hci_data_rsp_t, logic[DW_LIC-1:0], logic[UWH-1:0], logic[IW-1:0], logic[0:0], logic[0:0])

  `AXI_TYPEDEF_ALL_CT(core_axi_data, core_axi_data_req_t, core_axi_data_rsp_t, logic[magia_pkg::ADDR_W-1:0], logic[AXI_ID_W-1:0], logic[magia_pkg::DATA_W-1:0], logic[magia_pkg::STRB_W-1:0], logic[AXI_U_W-1:0])
  `AXI_TYPEDEF_ALL_CT(core_axi_instr, core_axi_instr_req_t, core_axi_instr_rsp_t, logic[magia_pkg::ADDR_W-1:0], logic[AXI_ID_W-1:0], logic[magia_pkg::DATA_W-1:0], logic[magia_pkg::STRB_W-1:0], logic[AXI_U_W-1:0])

  `REG_BUS_TYPEDEF_ALL(reg_dma, logic[magia_pkg::ADDR_W-1:0], logic[magia_pkg::DATA_W-1:0], logic[magia_pkg::STRB_W-1:0])
  `REG_BUS_TYPEDEF_ALL(idma_fe_reg, logic[magia_pkg::ADDR_W-1:0], logic[magia_pkg::DATA_W-1:0], logic[magia_pkg::STRB_W-1:0])

  `IDMA_TYPEDEF_FULL_REQ_T(idma_be_req_t, logic[iDMA_AxiIdWidth-1:0], idma_addr_t, logic[iDMA_TFLenWidth-1:0])
  `IDMA_TYPEDEF_FULL_RSP_T(idma_be_rsp_t, idma_addr_t)
  `IDMA_TYPEDEF_FULL_ND_REQ_T(idma_nd_req_t, idma_be_req_t, logic[iDMA_RepWidth-1:0], logic[iDMA_StrideWidth-1:0])

  `AXI_TYPEDEF_ALL_CT(idma_axi, idma_axi_req_t, idma_axi_rsp_t, logic[iDMA_AddrWidth-1:0], logic[iDMA_AxiIdWidth-1:0], logic[iDMA_DataWidth-1:0], logic[iDMA_StrbWidth-1:0], logic[iDMA_UserWidth-1:0])

  localparam obi_pkg::obi_optional_cfg_t obi_idma_optional_cfg = obi_pkg::obi_all_optional_config(AUSER_WIDTH, WUSER_WIDTH, RUSER_WIDTH, MID_WIDTH, ACHK_WIDTH, RCHK_WIDTH);
  localparam obi_pkg::obi_cfg_t          obi_idma_cfg          = obi_pkg::obi_default_cfg(iDMA_AddrWidth, iDMA_DataWidth, iDMA_AxiIdWidth, obi_idma_optional_cfg);

  `OBI_TYPEDEF_ALL(idma_obi, obi_idma_cfg)

  typedef struct packed {
    struct packed {
      idma_axi_ar_chan_t ar_chan;
    } axi;
    struct packed {
      idma_obi_a_chan_t a_chan;
    } obi;
  } idma_read_meta_channel_t;
  
  typedef struct packed {
    struct packed {
      idma_axi_aw_chan_t aw_chan;
    } axi;
    struct packed {
      idma_obi_a_chan_t a_chan;
    } obi;
  } idma_write_meta_channel_t;
 
  `AXI_TYPEDEF_ALL_CT(axi_xbar_slv, axi_xbar_slv_req_t, axi_xbar_slv_rsp_t, logic[magia_pkg::ADDR_W-1:0], logic[AXI_ID_W-1:0], logic[magia_pkg::DATA_W-1:0], logic[magia_pkg::STRB_W-1:0], logic[AXI_U_W-1:0])

  `HCI_TYPEDEF_REQ_T(idma_hci_req_t, logic[iDMA_AddrWidth-1:0], logic[iDMA_DataWidth-1:0], logic[iDMA_StrbWidth-1:0], logic[iDMA_UserWidth-1:0], logic[IW-1:0], logic[0:0], logic[0:0])
  `HCI_TYPEDEF_RSP_T(idma_hci_rsp_t, logic[iDMA_DataWidth-1:0], logic[iDMA_UserWidth-1:0], logic[IW-1:0], logic[0:0], logic[0:0])
  
  localparam axi_pkg::xbar_cfg_t axi_xbar_cfg = '{
    NoSlvPorts          : AxiXbarNoSlvPorts,
    NoMstPorts          : 0,  // placeholder: gen_axi_xbar_cfg() fills it from gen_axi_xbar_mst_map()
    MaxMstTrans         : AxiXbarMaxMstTrans,
    MaxSlvTrans         : AxiXbarMaxSlvTrans,
    FallThrough         : AxiXbarFallThrough,
    LatencyMode         : axi_pkg::CUT_ALL_PORTS,
    PipelineStages      : '0,
    AxiIdWidthSlvPorts  : AxiXbarSlvAxiIDWidth,
    AxiIdUsedSlvPorts   : AxiXbarSlvAxiIDWidth,
    UniqueIds           : 1'b0,
    AxiAddrWidth        : magia_pkg::ADDR_W,
    AxiDataWidth        : magia_pkg::DATA_W,
    NoAddrRules         : 0   // placeholder: gen_axi_xbar_cfg() fills it from gen_axi_xbar_num_rules()
  };

  typedef struct packed {
    int unsigned num_mst;   // Number of AXI xbar master ports
    int unsigned ext;       // to NoC          (always, index 0)
    int unsigned obi;       // to internal OBI (always, index 1)
    int unsigned bootrom;   // to Spatz bootrom (valid iff EnSpatzCC)
  } axi_xbar_mst_map_t;

  function automatic axi_xbar_mst_map_t gen_axi_xbar_mst_map(magia_tile_cfg_t cfg);
    axi_xbar_mst_map_t ret;
    int unsigned       idx;
    ret = '0;
    idx = 0;
    ret.ext = idx++;
    ret.obi = idx++;
    if (cfg.EnSpatzCC) ret.bootrom = idx++;
    ret.num_mst = idx;
    return ret;
  endfunction

  function automatic int unsigned gen_axi_xbar_num_rules(magia_tile_cfg_t cfg);
    return 3 + 32'(cfg.EnSpatzCC);
  endfunction

  function automatic axi_pkg::xbar_cfg_t gen_axi_xbar_cfg(magia_tile_cfg_t cfg);
    axi_pkg::xbar_cfg_t ret;
    axi_xbar_mst_map_t  mst_map;
    mst_map                = gen_axi_xbar_mst_map(cfg);
    ret                    = axi_xbar_cfg;
    ret.NoMstPorts         = mst_map.num_mst;
    ret.NoAddrRules        = gen_axi_xbar_num_rules(cfg);
    return ret;
  endfunction

  `FSYNC_TYPEDEF_ALL(ht_tile_fsync, logic[FSYNC_AGGR_W-1:0], logic[FSYNC_LVL_W-1:0], logic[FSYNC_ID_W-1:0])
  `FSYNC_TYPEDEF_ALL(vt_tile_fsync, logic[FSYNC_AGGR_W-1:0], logic[FSYNC_LVL_W-1:0], logic[FSYNC_ID_W-1:0])
  `FSYNC_TYPEDEF_ALL(hn_tile_fsync, logic[FSYNC_NBR_AGGR_W-1:0], logic[FSYNC_NBR_LVL_W-1:0], logic[FSYNC_NBR_ID_W-1:0])
  `FSYNC_TYPEDEF_ALL(vn_tile_fsync, logic[FSYNC_NBR_AGGR_W-1:0], logic[FSYNC_NBR_LVL_W-1:0], logic[FSYNC_NBR_ID_W-1:0])

`ifdef VERILATOR
  // Packed observation boundary required by hierarchical Verilation.
  typedef struct packed {
    logic [magia_pkg::ADDR_W-1:0]     axi_aw_addr;
    // axi_aw_id is driven from axi_xbar_mst_req_t.aw.id (magia_pkg's NoC AXI
    // alias), whose ID width is magia_pkg::AXI_NOC_ID_W. This tile package's
    // own AXI_ID_W (3 bits) sizes a *different* xbar (the tile-internal one
    // with 5 slave ports) and must not be reused here.
    logic [magia_pkg::AXI_NOC_ID_W-1:0] axi_aw_id;
    logic                             axi_aw_valid;
    logic [magia_pkg::DATA_W-1:0] axi_w_data;
    logic                         axi_w_valid;
    logic [31:0]                  instr_ex;
    logic [31:0]                  instr_id;
    logic [31:0]                  instr_wb;
    logic [31:0]                  wb_data;
  } magia_tile_observe_t;
`endif

  /*******************************************************************/
  /*              Spatz Core Complex Wrapper Types                   */
  /*******************************************************************/
  
  // Base types for Spatz TCDM and reqrsp
  typedef logic [magia_pkg::ADDR_W-1:0]    spatz_addr_t;
  typedef logic [magia_pkg::DATA_W-1:0]    spatz_data_t;
  typedef logic [magia_pkg::DATA_W/8-1:0]  spatz_strb_t;
  typedef logic                            spatz_tcdm_user_t;
  typedef logic [magia_tile_pkg::SPATZ_TCDM_ADDR_WIDTH-1:0] spatz_tcdm_addr_t;
  
  // 64-bit types for TCDM and reqrsp interfaces when RVD=1
  typedef logic [SPATZ_TCDM_DATA_WIDTH-1:0]     spatz_data64_t;
  typedef logic [SPATZ_TCDM_STRB_WIDTH-1:0]     spatz_strb64_t;
  
  `TCDM_TYPEDEF_ALL(spatz_tcdm, spatz_tcdm_addr_t, spatz_data_t, spatz_strb_t, spatz_tcdm_user_t)
  `REQRSP_TYPEDEF_ALL(spatz_reqrsp, spatz_addr_t, spatz_data_t, spatz_strb_t)        // 32-bit for Snitch data port (RVD=0, DataWidth=32)
  `REQRSP_TYPEDEF_ALL(spatz_reqrsp64, spatz_addr_t, spatz_data64_t, spatz_strb64_t)  // 64-bit for Snitch data port (RVD=1, DataWidth=64)

  // TCDM64 types with AMO support (using TCDM_TYPEDEF_ALL macro which includes amo field)
  typedef logic [magia_pkg::ADDR_W-1:0]        spatz_tcdm64_addr_t;
  typedef logic [SPATZ_TCDM_DATA_WIDTH-1:0]    spatz_tcdm64_data_t;
  typedef logic [SPATZ_TCDM_STRB_WIDTH-1:0]    spatz_tcdm64_strb_t;
  typedef logic                                 spatz_tcdm64_user_t;
  
  `TCDM_TYPEDEF_ALL(spatz_tcdm64, spatz_tcdm64_addr_t, spatz_tcdm64_data_t, spatz_tcdm64_strb_t, spatz_tcdm64_user_t)
  
  // Alias for backward compatibility with spatz_cc instantiation
  typedef spatz_tcdm64_req_chan_t spatz_tcdm64_payload_t;

  // TCDM32 types with AMO support (for modular atomic resolver architecture)
  typedef logic [magia_pkg::ADDR_W-1:0]        spatz_tcdm32_addr_t;
  typedef logic [31:0]                          spatz_tcdm32_data_t;
  typedef logic [3:0]                           spatz_tcdm32_strb_t;
  typedef logic                                 spatz_tcdm32_user_t;
  
  `TCDM_TYPEDEF_ALL(spatz_tcdm32, spatz_tcdm32_addr_t, spatz_tcdm32_data_t, spatz_tcdm32_strb_t, spatz_tcdm32_user_t)
  
  // OBI 32-bit types for modular atomic architecture  
  `OBI_TYPEDEF_ALL_A_OPTIONAL(spatz_obi32_a_optional_t, AUSER_WIDTH, WUSER_WIDTH, MID_WIDTH, ACHK_WIDTH)
  `OBI_TYPEDEF_ALL_R_OPTIONAL(spatz_obi32_r_optional_t, RUSER_WIDTH, RCHK_WIDTH)
  `OBI_TYPEDEF_A_CHAN_T(spatz_obi32_a_chan_t, magia_pkg::ADDR_W, 32, AID_WIDTH, spatz_obi32_a_optional_t)
  `OBI_TYPEDEF_R_CHAN_T(spatz_obi32_r_chan_t, 32, RID_WIDTH, spatz_obi32_r_optional_t)
  `OBI_TYPEDEF_DEFAULT_REQ_T(spatz_obi32_req_t, spatz_obi32_a_chan_t)
  `OBI_TYPEDEF_RSP_T(spatz_obi32_rsp_t, spatz_obi32_r_chan_t)




endpackage: magia_tile_pkg
