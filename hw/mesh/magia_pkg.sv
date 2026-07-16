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
 * MAGIA Package
 */

package magia_pkg;

  `include "axi/typedef.svh"
  `include "fractal_sync/typedef.svh"

  `include "../include/alias.svh"

  // Global constants
  localparam int unsigned ADDR_W           = 32;                              // System-wide address Width
  localparam int unsigned DATA_W           = 32;                              // System-wide data Width
  localparam int unsigned INSTR_W          = 32;                              // System-wide instruction Width
  localparam int unsigned BYTE_W           = 8;                               // System-wide byte Width
  localparam int unsigned STRB_W           = DATA_W/BYTE_W;                   // System-wide strobe Width
  localparam int unsigned WIDE_DATA_W      = 256;                             // System-wide wide communication channel Width
  localparam int unsigned WIDE_STRB_W      = WIDE_DATA_W/BYTE_W;              // System-wide wide communication strobe Width
  localparam int unsigned N_MEM_BANKS      = 32;                              // Number of TCDM banks (1 extra bank for missaligned accesses)
  localparam int unsigned N_WORDS_BANK     = 8192;                            // Number of words per TCDM bank
  localparam int unsigned N_TILES_Y        = 4;                               // Number of Tile rowns
  localparam int unsigned N_TILES_X        = 4;                               // Number of Tile columns
  localparam int unsigned N_TILES          = N_TILES_Y*N_TILES_X;             // Number of Tiles in the Mesh
  localparam int unsigned N_IRQ            = 32;                              // Number of IRQs
  localparam int unsigned IRQ_ID_W         = $clog2(N_IRQ);                   // IRQ ID Width
  localparam int unsigned ID_W_OFFSET      = 1;                               // Offset to be added to ID Width
  localparam int unsigned ID_W             = 1;                               // Default ID Width
  localparam int unsigned USR_W            = 1;                               // Default User Width

  // Tile accelerator configuration
  typedef struct packed {
    int unsigned Height;       // Systolic array height
    int unsigned Width;        // Systolic array width
    int unsigned NumPipeRegs;  // Pipeline registers in the systolic array
  } redmule_cfg_t;

  typedef struct packed {
    bit          RVD;       // Double-precision vector support (drives 64-bit TCDM)
    bit          RVF;       // Single-precision FP support
    bit          RVV;       // Vector extension support
    int unsigned NumIPU;    // Number of integer processing units
    int unsigned NumFPU;    // Number of FP processing units
    bit          XDivSqrt;  // FP division/sqrt enable
    bit          XDMA;      // DMA inside the Spatz CC
  } spatz_cfg_t;

  typedef struct packed {
    int unsigned NumCores;  // Number of cv32e40p cluster cores
  } cluster_cfg_t;

  typedef struct packed {
    bit           EnRedMule; // RedMulE HWPE: engine + HCI HWPE port + OBI control port
    bit           EnSpatzCC; // Spatz CC: core complex + bootrom + dedicated I$ + HCI/OBI master ports
    bit           EnCluster; // PULP cluster: cv32e40p cores + shared I$ + OBI master ports
    redmule_cfg_t RedMule;   // RedMulE parameters (valid iff EnRedMule)
    spatz_cfg_t   Spatz;     // Spatz CC parameters (valid iff EnSpatzCC)
    cluster_cfg_t Cluster;   // PULP cluster parameters (valid iff EnCluster)
  } magia_tile_cfg_t;

  // Default parameter sets

  localparam redmule_cfg_t MagiaRedMuleDefaultCfg = '{
    Height:      8,
    Width:       8,
    NumPipeRegs: 1
  };

 // Derived from the MAGIA Makefile (Reflects on spatz_pkg.sv in spatz_cluster dep)
`ifdef SPATZ_RVD
  localparam bit          MagiaSpatzRVD      = `SPATZ_RVD;
`else
  localparam bit          MagiaSpatzRVD      = 1'b0;
`endif
`ifdef SPATZ_RVF
  localparam bit          MagiaSpatzRVF      = `SPATZ_RVF;
`else
  localparam bit          MagiaSpatzRVF      = 1'b1;
`endif
`ifdef SPATZ_RVV
  localparam bit          MagiaSpatzRVV      = `SPATZ_RVV;
`else
  localparam bit          MagiaSpatzRVV      = 1'b1;
`endif
`ifdef SPATZ_N_IPU
  localparam int unsigned MagiaSpatzNumIPU   = `SPATZ_N_IPU;
`else
  localparam int unsigned MagiaSpatzNumIPU   = 1;
`endif
`ifdef SPATZ_N_FPU
  localparam int unsigned MagiaSpatzNumFPU   = `SPATZ_N_FPU;
`else
  localparam int unsigned MagiaSpatzNumFPU   = 4;
`endif
`ifdef SPATZ_XDIVSQRT
  localparam bit          MagiaSpatzXDivSqrt = `SPATZ_XDIVSQRT;
`else
  localparam bit          MagiaSpatzXDivSqrt = 1'b0;
`endif
`ifdef SPATZ_XDMA
  localparam bit          MagiaSpatzXDMA     = `SPATZ_XDMA;
`else
  localparam bit          MagiaSpatzXDMA     = 1'b0;
`endif

  localparam spatz_cfg_t MagiaSpatzDefaultCfg = '{
    RVD:      MagiaSpatzRVD,
    RVF:      MagiaSpatzRVF,
    RVV:      MagiaSpatzRVV,
    NumIPU:   MagiaSpatzNumIPU,
    NumFPU:   MagiaSpatzNumFPU,
    XDivSqrt: MagiaSpatzXDivSqrt,
    XDMA:     MagiaSpatzXDMA
  };

  localparam cluster_cfg_t MagiaClusterDefaultCfg = '{
    NumCores: 8
  };

  // All accelerators enabled (full tile)
  localparam magia_tile_cfg_t MagiaTileDefaultCfg = '{
    EnRedMule: 1'b1,
    EnSpatzCC: 1'b1,
    EnCluster: 1'b1,
    RedMule:   MagiaRedMuleDefaultCfg,
    Spatz:     MagiaSpatzDefaultCfg,
    Cluster:   MagiaClusterDefaultCfg
  };

  // RedMulE-only tile
  localparam magia_tile_cfg_t MagiaTileRedMuleCfg = '{
    EnRedMule: 1'b1,
    EnSpatzCC: 1'b0,
    EnCluster: 1'b0,
    RedMule:   MagiaRedMuleDefaultCfg,
    Spatz:     MagiaSpatzDefaultCfg,
    Cluster:   MagiaClusterDefaultCfg
  };

   // SpatzCC-only tile
  localparam magia_tile_cfg_t MagiaTileSpatzCfg = '{
    EnRedMule: 1'b0,
    EnSpatzCC: 1'b1,
    EnCluster: 1'b0,
    RedMule:   MagiaRedMuleDefaultCfg,
    Spatz:     MagiaSpatzDefaultCfg,
    Cluster:   MagiaClusterDefaultCfg
  };

  // PulpCluster-only tile
  localparam magia_tile_cfg_t MagiaTileClusterCfg = '{
    EnRedMule: 1'b0,
    EnSpatzCC: 1'b0,
    EnCluster: 1'b1,
    RedMule:   MagiaRedMuleDefaultCfg,
    Spatz:     MagiaSpatzDefaultCfg,
    Cluster:   MagiaClusterDefaultCfg
  };

  localparam magia_tile_cfg_t [N_TILES-1:0] HOMO_TILE_CFGS = '{
    // Default Homogeneus Mesh
    0:  MagiaTileDefaultCfg,
    1:  MagiaTileDefaultCfg,
    2:  MagiaTileDefaultCfg,
    3:  MagiaTileDefaultCfg,
    4:  MagiaTileDefaultCfg,
    5:  MagiaTileDefaultCfg,
    6:  MagiaTileDefaultCfg,
    7:  MagiaTileDefaultCfg,
    8:  MagiaTileDefaultCfg,
    9:  MagiaTileDefaultCfg,
    10: MagiaTileDefaultCfg,
    11: MagiaTileDefaultCfg,
    12: MagiaTileDefaultCfg,
    13: MagiaTileDefaultCfg,
    14: MagiaTileDefaultCfg,
    15: MagiaTileDefaultCfg
  };


  localparam magia_tile_cfg_t [N_TILES-1:0] HETERO_TILE_CFGS = '{
    // Row 0: full tiles
    0:  MagiaTileDefaultCfg,
    1:  MagiaTileDefaultCfg,
    2:  MagiaTileDefaultCfg,
    3:  MagiaTileDefaultCfg,
    // Row 1: RedMulE-only
    4:  MagiaTileRedMuleCfg,
    5:  MagiaTileRedMuleCfg,
    6:  MagiaTileRedMuleCfg,
    7:  MagiaTileRedMuleCfg,
    // Row 2: Spatz-only (vector tiles)
    8:  MagiaTileSpatzCfg,
    9:  MagiaTileSpatzCfg,
    10: MagiaTileSpatzCfg,
    11: MagiaTileSpatzCfg,
    // Row 3: PULP cluster-only
    12: MagiaTileClusterCfg,
    13: MagiaTileClusterCfg,
    14: MagiaTileClusterCfg,
    15: MagiaTileClusterCfg
  };

  // Parameters used by the NoC
  parameter int unsigned AXI_NOC_ID_W      = 6;                                // AXI NoC ID Width: matches slave side id_width (6 bits)
  parameter int unsigned AXI_NOC_U_W       = USR_W;

  // Parameters used by the L2
  parameter int unsigned L2_ID_W           = 3;                                // The ID Width reflects the slave ID Width of the Tile AXI XBAR (for 5 ports: log2(5)=3)
  parameter int unsigned L2_U_W            = 1;

  // Parameter used for the Fractal Sync network
  parameter int unsigned FSYNC_LVL         = (N_TILES_X == N_TILES_Y) ? 
                                              $clog2(N_TILES) : 
                                              -1;                              // Number of levels of the Fractal Sync tree
  parameter int unsigned ROOT_FSYNC_AGGR_W = 1;                                // Aggregate width of the Fractal Sync Root tree out interface
  parameter int unsigned TILE_FSYNC_AGGR_W = ROOT_FSYNC_AGGR_W+FSYNC_LVL;      // Aggregate width of the Fractal Sync interface (CU-FSync interface)
  parameter int unsigned TILE_FSYNC_LVL_W  = $clog2(TILE_FSYNC_AGGR_W-1);      // Level width of the Fractal Sync interface (CU-FSync interface)
  parameter int unsigned TILE_FSYNC_ID_W   = FSYNC_LVL-1 >= 2 ? 
                                             FSYNC_LVL-1 : 
                                             2;                                // Id width of the Fractal Sync interface (CU-FSync interface)
  parameter int unsigned ROOT_FSYNC_LVL_W  = TILE_FSYNC_LVL_W;                 // Level width of the Fractal Sync Root tree out interface
  parameter int unsigned ROOT_FSYNC_ID_W   = TILE_FSYNC_ID_W;                  // Id width of the Fractal Sync Root tree out interface

  `AXI_TYPEDEF_ALL_CT(noc_axi_data, noc_axi_data_req_t, noc_axi_data_rsp_t, logic[ADDR_W-1:0], logic[AXI_NOC_ID_W-1:0], logic[DATA_W-1:0], logic[STRB_W-1:0], logic[AXI_NOC_U_W-1:0])
  `AXI_ALIAS(noc_axi_data, axi_xbar_mst, noc_axi_data_req_t, axi_xbar_mst_req_t, noc_axi_data_rsp_t, axi_xbar_mst_rsp_t)
  `AXI_ALIAS(noc_axi_data, axi_default, noc_axi_data_req_t, axi_default_req_t, noc_axi_data_rsp_t, axi_default_rsp_t)

  `AXI_TYPEDEF_ALL_CT(axi_narrow_l2, axi_narrow_l2_req_t, axi_narrow_l2_rsp_t, logic[ADDR_W-1:0], logic[L2_ID_W-1:0], logic[DATA_W-1:0], logic[STRB_W-1:0], logic[L2_U_W-1:0])
  `AXI_TYPEDEF_ALL_CT(axi_wide_l2, axi_wide_l2_req_t, axi_wide_l2_rsp_t, logic[ADDR_W-1:0], logic[L2_ID_W-1:0], logic[WIDE_DATA_W-1:0], logic[WIDE_STRB_W-1:0], logic[L2_U_W-1:0])

  `FSYNC_TYPEDEF_ALL(h_root_fsync, logic[ROOT_FSYNC_AGGR_W-1:0], logic[ROOT_FSYNC_LVL_W-1:0], logic[ROOT_FSYNC_ID_W-1:0])
  `FSYNC_TYPEDEF_ALL(v_root_fsync, logic[ROOT_FSYNC_AGGR_W-1:0], logic[ROOT_FSYNC_LVL_W-1:0], logic[ROOT_FSYNC_ID_W-1:0])

endpackage: magia_pkg