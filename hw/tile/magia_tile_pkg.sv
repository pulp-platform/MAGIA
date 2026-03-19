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
  localparam logic [magia_pkg::ADDR_W-1:0] REDMULE_CTRL_SIZE       = 32'h0000_00FF; 
  localparam logic [magia_pkg::ADDR_W-1:0] REDMULE_CTRL_ADDR_END   = REDMULE_CTRL_ADDR_START + REDMULE_CTRL_SIZE;
  localparam logic [magia_pkg::ADDR_W-1:0] IDMA_CTRL_ADDR_START    = REDMULE_CTRL_ADDR_END + 1;
  localparam logic [magia_pkg::ADDR_W-1:0] IDMA_CTRL_SIZE          = 32'h0000_03FF;
  localparam logic [magia_pkg::ADDR_W-1:0] IDMA_CTRL_ADDR_END      = IDMA_CTRL_ADDR_START + IDMA_CTRL_SIZE;
  localparam logic [magia_pkg::ADDR_W-1:0] FSYNC_CTRL_ADDR_START   = IDMA_CTRL_ADDR_END + 1;
  localparam logic [magia_pkg::ADDR_W-1:0] FSYNC_CTRL_SIZE         = 32'h0000_00FF; 
  localparam logic [magia_pkg::ADDR_W-1:0] FSYNC_CTRL_ADDR_END     = FSYNC_CTRL_ADDR_START + FSYNC_CTRL_SIZE;
  localparam logic [magia_pkg::ADDR_W-1:0] EVENT_UNIT_ADDR_START   = FSYNC_CTRL_ADDR_END + 1;
  localparam logic [magia_pkg::ADDR_W-1:0] EVENT_UNIT_SIZE         = 32'h0000_0FFF; 
  localparam logic [magia_pkg::ADDR_W-1:0] EVENT_UNIT_ADDR_END     = EVENT_UNIT_ADDR_START + EVENT_UNIT_SIZE;
  localparam logic [magia_pkg::ADDR_W-1:0] SPATZ_CTRL_ADDR_START   = EVENT_UNIT_ADDR_END + 1;
  localparam logic [magia_pkg::ADDR_W-1:0] SPATZ_CTRL_SIZE         = 32'h0000_00FF; 
  localparam logic [magia_pkg::ADDR_W-1:0] SPATZ_CTRL_ADDR_END     = SPATZ_CTRL_ADDR_START + SPATZ_CTRL_SIZE;
  localparam logic [magia_pkg::ADDR_W-1:0] RESERVED_ADDR_START     = SPATZ_CTRL_ADDR_END + 1;
  localparam logic [magia_pkg::ADDR_W-1:0] RESERVED_SIZE           = 32'h0000_E7FF;  // Calculated to make RESERVED_ADDR_END = 0x0001_0000
  localparam logic [magia_pkg::ADDR_W-1:0] RESERVED_ADDR_END       = RESERVED_ADDR_START + RESERVED_SIZE;
  localparam logic [magia_pkg::ADDR_W-1:0] STACK_ADDR_START        = RESERVED_ADDR_END +1;
  localparam logic [magia_pkg::ADDR_W-1:0] STACK_SIZE              = 32'h0000_FFFF;
  localparam logic [magia_pkg::ADDR_W-1:0] STACK_ADDR_END          = STACK_ADDR_START + STACK_SIZE;
  localparam logic [magia_pkg::ADDR_W-1:0] L1_ADDR_START           = STACK_ADDR_END + 1;
  localparam logic [magia_pkg::ADDR_W-1:0] L1_SIZE                 = 32'h000D_FFFF;
  localparam logic [magia_pkg::ADDR_W-1:0] L1_ADDR_END             = L1_ADDR_START + L1_SIZE;
  localparam logic [magia_pkg::ADDR_W-1:0] L1_TILE_OFFSET          = 32'h0010_0000;
  localparam logic [magia_pkg::ADDR_W-1:0] L2_ADDR_START           = 32'hC000_0000;
  localparam logic [magia_pkg::ADDR_W-1:0] L2_SIZE                 = 32'h3FFF_FFFF;
  localparam logic [magia_pkg::ADDR_W-1:0] L2_ADDR_END             = L2_ADDR_START + L2_SIZE;

  // Instruction region for Spatz code (cacheable region)
  localparam logic [magia_pkg::ADDR_W-1:0] INSTRRAM_ADDR_START      = 32'hCC00_0000;
  localparam logic [magia_pkg::ADDR_W-1:0] INSTRRAM_SIZE            = 32'h0000_8000;  // 32KB

  localparam logic [magia_pkg::ADDR_W-1:0] INSTRRAM_PMA_MASK        = 32'hFFFF_8000;

  // Snitch PMA Configuration - defines cacheable regions for instruction fetches
  function automatic snitch_pma_pkg::rule_t [snitch_pma_pkg::NrMaxRules-1:0] get_snitch_cached_regions();
    automatic snitch_pma_pkg::rule_t [snitch_pma_pkg::NrMaxRules-1:0] cached_regions;
    cached_regions = '{default: '0};
    cached_regions[0] = '{base: INSTRRAM_ADDR_START, mask: INSTRRAM_PMA_MASK};
    return cached_regions;
  endfunction

  localparam snitch_pma_pkg::snitch_pma_t SPATZ_SNITCH_PMA_CFG = '{
    NrCachedRegionRules: 1,
    CachedRegion: get_snitch_cached_regions(),
    default: 0
  };

  //SPATZ PARAMETERS from Makefile defines
  //SPATZ_RVD (Double-width vector extension support)
  `ifdef SPATZ_RVD
    localparam bit SPATZ_RVD_PARAM = `SPATZ_RVD;
  `else
    localparam bit SPATZ_RVD_PARAM = 1'b0;
  `endif
  
  //SPATZ_N_IPU and SPATZ_N_FPU
  `ifdef SPATZ_N_IPU
    localparam int unsigned SPATZ_NUM_IPU = `SPATZ_N_IPU;
  `else
    localparam int unsigned SPATZ_NUM_IPU = 1;
  `endif
  
  `ifdef SPATZ_N_FPU
    localparam int unsigned SPATZ_NUM_FPU = `SPATZ_N_FPU;
  `else
    localparam int unsigned SPATZ_NUM_FPU = 4;
  `endif
  
  //SPATZ_XDIVSQRT (FP division/sqrt enable)
  `ifdef SPATZ_XDIVSQRT
    localparam bit SPATZ_XDIVSQRT_PARAM = `SPATZ_XDIVSQRT;
  `else
    localparam bit SPATZ_XDIVSQRT_PARAM = 1'b0;
  `endif
  
  //SPATZ_XDMA (DMA inside Spatz_cc)
  `ifdef SPATZ_XDMA
    localparam bit SPATZ_XDMA_PARAM = `SPATZ_XDMA;
  `else
    localparam bit SPATZ_XDMA_PARAM = 1'b0;
  `endif
  
  //SPATZ_RVF (Single-precision FP support)
  `ifdef SPATZ_RVF
    localparam bit SPATZ_RVF_PARAM = `SPATZ_RVF;
  `else
    localparam bit SPATZ_RVF_PARAM = 1'b1;
  `endif
  
  //SPATZ_RVV (Vector extension support)
  `ifdef SPATZ_RVV
    localparam bit SPATZ_RVV_PARAM = `SPATZ_RVV;
  `else
    localparam bit SPATZ_RVV_PARAM = 1'b1;
  `endif
  
  // Spatz CC parameters (must be defined before HCI parameters)
  localparam int unsigned SPATZ_NUM_FU            = (SPATZ_NUM_FPU > SPATZ_NUM_IPU) ? SPATZ_NUM_FPU : SPATZ_NUM_IPU;  // Max of FPU and IPU
  localparam int unsigned SPATZ_TCDM_PORTS        = SPATZ_NUM_FU + 1;  // N_FU + 1 TCDM ports (N_FU vector + 1 snitch)
  localparam int unsigned SPATZ_HCI_PORTS         = SPATZ_RVD_PARAM ? (SPATZ_TCDM_PORTS * 2) : SPATZ_TCDM_PORTS;  // RVD=1: 2xTCDM HCI32, RVD=0: 1xTCDM HCI32

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
  parameter int unsigned N_HWPE  = 1;                                                   // Number of HWPEs attached to the port
  parameter int unsigned N_CORE  = 1 + SPATZ_HCI_PORTS;                                 // Number of Core ports: 1 CV32 + Spatz HCI ports (RVD=1: 11 total, RVD=0: 6 total)
  parameter int unsigned N_DMA   = 2;                                                   // Number of DMA ports (1 for the read channel and 1 for the write channel)
  typedef enum logic{
    HCI_DMA_CH_READ_IDX  = 1'b0,
    HCI_DMA_CH_WRITE_IDX = 1'b1
  } hci_idma_ch_idx_e;                                                                  // Index of the HCI DMA read and write channels
  parameter int unsigned N_EXT   = 0;                                                   // Number of External ports - LEAVE TO 0 UNLESS YOU KNOW WHAT YOU ARE DOING
  parameter int unsigned AWC     = magia_pkg::ADDR_W;                                   // Address width core   (slave ports)
  parameter int unsigned DW_LIC  = magia_pkg::DATA_W;                                   // Data Width for Log Interconnect
  parameter int unsigned BW_LIC  = magia_pkg::BYTE_W;                                   // Byte Width for Log Interconnect
  localparam int unsigned AWM    = 
                          $clog2(magia_pkg::N_WORDS_BANK*DW_LIC/BW_LIC);                // Address width memory (master ports)
  parameter int unsigned UW_LIC  = magia_pkg::USR_W;                                    // User Width for Log Interconnect
  localparam int unsigned SW_LIC = DW_LIC/BW_LIC;                                       // Strobe Width for Log Interconnect
  localparam int unsigned WD_LIC = DW_LIC/DW_LIC;                                       // Number of words per data for Log Interconnect
  parameter int unsigned TS_BIT  = 21;                                                  // TEST_SET_BIT (for Log Interconnect)
  parameter int unsigned IW      = N_HWPE+N_CORE+N_DMA+N_EXT;                           // ID Width HCI
  parameter int unsigned EXPFIFO = 0;                                                   // FIFO Depth for HWPE Interconnect
  parameter int unsigned DWH     = 544;                                                 // Data Width for HWPE Interconnect: RedMulE Hx(P+1)xBits + Bank width for misaligned access = 8x(3+1)x16+32 
  parameter int unsigned AWH     = magia_pkg::ADDR_W;                                   // Address Width for HWPE Interconnect
  parameter int unsigned BWH     = magia_pkg::BYTE_W;                                   // Byte Width for HWPE Interconnect
  parameter int unsigned WWH     = DWH;                                                 // Word Width for HWPE Interconnect
  parameter int unsigned OWH     = AWH;                                                 // Offset Width for HWPE Interconnect
  parameter int unsigned UWH     = magia_pkg::USR_W;                                    // User Width for HWPE Interconnect
  parameter int unsigned SEL_LIC = 1;                                                   // Log interconnect type selector
  localparam int unsigned SWH    = DWH/BWH;                                             // Strobe Width for HWPE Interconnect
  localparam int unsigned WDH    = DWH/WWH;                                             // Number of words per data for HWPE Interconnect

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
  parameter int unsigned N_EXT_PERF_COUNTERS = 0;                                       // Number of external performance counters
  parameter int unsigned INSTR_RDATA_WIDTH   = 32;                                      // Instruction data width  
  parameter bit          PULP_SECURE         = 1'b0;                                    // PULP security features
  parameter int unsigned N_PMP_ENTRIES       = 16;                                      // Number of PMP entries
  parameter bit          USE_PMP             = 1'b1;                                    // Enable PMP
  parameter bit          PULP_CLUSTER        = 1'b1;                                    // PULP cluster mode
  parameter bit          FPU                 = 1'b1;                                    // Enable FPU (main feature)
  parameter bit          ZFINX               = 1'b1;                                    // Zfinx extension (integer FP in GPR) - Must be 1 for CV32E40P with FP16/FP16alt
  parameter bit          FP_DIVSQRT          = 1'b1;                                    // FP division and square root
  parameter bit          SHARED_FP           = 1'b0;                                    // Shared FP unit
  parameter bit          SHARED_DSP_MULT     = 1'b0;                                    // Shared DSP multiplier
  parameter bit          SHARED_INT_MULT     = 1'b0;                                    // Shared integer multiplier
  parameter bit          SHARED_INT_DIV      = 1'b0;                                    // Shared integer divider
  parameter bit          SHARED_FP_DIVSQRT   = 1'b0;                                    // Shared FP div/sqrt
  parameter int unsigned WAPUTYPE            = 0;                                       // APU type width
  parameter int unsigned APU_NARGS_CPU       = 3;                                       // APU number of arguments
  parameter int unsigned APU_WOP_CPU         = 6;                                       // APU operation width
  parameter int unsigned APU_NDSFLAGS_CPU    = 15;                                      // APU data side flags
  parameter int unsigned APU_NUSFLAGS_CPU    = 5;                                       // APU user side flags
  parameter logic[31:0]  DM_HALT_ADDR        = 32'h1A110800;                            // Debug module halt address

`ifdef CV32E40X
  parameter int unsigned X_NUM_RS        = 3;                                           // Number of register file read ports that can be used by the eXtension interface
  parameter int unsigned CLIC_ID_W       = 1;                                           // Width of clic_irq_id_i and clic_irq_id_o. The maximum number of supported interrupts in CLIC mode is 2^CLIC_ID_WIDTH. Trap vector table alignment is restricted as described in Machine Trap Vector Table Base Address (mtvt)
`else
  parameter int unsigned X_NUM_RS            = 2;                                       // Number of register file read ports (R-type instructions have 2 source operands)
  parameter int unsigned CLIC_ID_W           = 5;                                       // CLIC interrupt ID width (5 bits for 32 interrupts)
`endif
  
  // Parameters used by Event Unit
  parameter int unsigned EVENT_UNIT_IRQ_WIDTH = 5;                                      // Width of Event Unit IRQ ID signals (supports up to 32 different event types)

  // Parameters used by RedMulE
  parameter int unsigned REDMULE_DW   = DWH-32;                                         // RedMulE Data Width
  parameter int unsigned REDMULE_ID_W = magia_pkg::ID_W + 
                                        magia_pkg::ID_W_OFFSET;                         // RedMulE ID Width
  parameter int unsigned REDMULE_UW   = UWH;                                            // RedMulE User Width
  
  // Parameters used by OBI
  parameter int unsigned AUSER_WIDTH  = 1;                                              // Width of the auser signal (see OBI documentation): not used by the CV32E40X
  parameter int unsigned WUSER_WIDTH  = 1;                                              // Width of the wuser signal (see OBI documentation): not used by the CV32E40X
  parameter int unsigned ACHK_WIDTH   = 1;                                              // Width of the achk  signal (see OBI documentation): not used by the CV32E40X
  parameter int unsigned RUSER_WIDTH  = 1;                                              // Width of the ruser signal (see OBI documentation): not used by the CV32E40X
  parameter int unsigned RCHK_WIDTH   = 1;                                              // Width of the rchk  signal (see OBI documentation): not used by the CV32E40X
  parameter int unsigned AID_WIDTH    = 1;                                              // Width of the aid   signal (address channel identifier, see OBI documentation)
  parameter int unsigned RID_WIDTH    = 1;                                              // Width of the rid   signal (response channel identifier, see OBI documentation)
  parameter int unsigned MID_WIDTH    = 1;                                              // Width of the mid   signal (manager identifier, see OBI documentation)
  parameter int unsigned OBI_ID_WIDTH = 1;                                              // Width of the id - configuration
`ifdef CV32E40X
  parameter int unsigned N_SBR        = 4;                                              // Number of slaves (HCI, AXI XBAR, Event_Unit, Spatz_Ctrl)
`else
  parameter int unsigned N_SBR        = 7;                                              // Number of OBI slaves (HCI, AXI XBAR, RedMulE_Ctrl, iDMA_Ctrl, FSync_Ctrl, Event_Unit, Spatz_Ctrl)
`endif  
  parameter int unsigned N_MGR        = 3;                                              // Number of masters (Core, AXI XBAR, Spatz CC)
  parameter int unsigned N_MAX_TRAN   = 1;                                              // Number of maximum outstanding transactions
`ifdef CV32E40X
  parameter int unsigned N_ADDR_RULE  = 6;                                              // Number of address rules (L2, L1, Stack, Reserved, Event_Unit, Spatz_Ctrl)
`else
  parameter int unsigned N_ADDR_RULE  = 9;                                              // Number of OBI address rules (L2, L1, Stack, Reserved, RedMulE_Ctrl, iDMA_Ctrl, FSync_Ctrl, Event_Unit, Spatz_Ctrl)
`endif  
  localparam int unsigned N_BIT_SBR   = $clog2(N_SBR);                                  // Number of bits required to identify each slave

  // Parameters used by AXI
  parameter int unsigned AXI_DATA_ID_W  = 3;                                            // Width of the AXI Data ID (3 bits for 5 slave ports on crossbar: 2^3=8)
  parameter int unsigned AXI_INSTR_ID_W = 3;                                            // Width of the AXI Instruction ID (3 bits for 5 slave ports on crossbar)
  parameter int unsigned AXI_ID_W       = 3;                                            // Width of the AXI Unified Communication Channel ID (3 bits for 5 slave ports)
  localparam int unsigned AXI_MST_ID_W  = 6;                                            // Width of master port ID (slave 3b + prepend 3b for 5 ports)
  parameter int unsigned AXI_DATA_U_W   = magia_pkg::USR_W;                             // Width of the AXI Data User
  parameter int unsigned AXI_INSTR_U_W  = magia_pkg::USR_W;                             // Width of the AXI Instruction User
  parameter int unsigned AXI_U_W        = magia_pkg::USR_W;                             // Width of the AXI Unified Communication Channel User

  // Parameters used by the iDMA
  localparam int unsigned iDMA_NumDims            = 3;                                  // iDMA Number of dimensions
  localparam int unsigned NumDim                  = iDMA_NumDims;                       // Needed by the iDMA typedef (wtf?)
  parameter int unsigned iDMA_DataWidth           = magia_pkg::DATA_W;                  // iDMA Data Width
  parameter int unsigned iDMA_AddrWidth           = magia_pkg::ADDR_W;                  // iDMA Address Width
  parameter int unsigned iDMA_UserWidth           = AXI_DATA_U_W;                       // iDMA AXI User Width
  parameter int unsigned iDMA_StrbWidth           = magia_pkg::STRB_W;                  // iDMA AXI Strobe Width
  parameter int unsigned iDMA_AxiIdWidth          = AXI_DATA_ID_W;                      // iDMA AXI ID Width
  parameter int unsigned iDMA_NumAxInFlight       = 2;                                  // iDMA Number of transaction that can be in-flight concurrently
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
  parameter int unsigned iDMA_JobFifoDepth        = 2;                                  // iDMA Stream FIFO depth
  parameter int unsigned iDMA_IdCounterWidth      = 32;                                 // iDMA Width of the transfer id (max 32-bit)
  parameter int unsigned iDMA_RepWidth            = 32;                                 // iDMA Width of the reps field
  localparam logic[iDMA_NumDims-1:0][31:0] 
                         iDMA_RepWidths           = '{default: 32'd32};                 // iDMA Width of the counters holding the number of repetitions
  parameter int unsigned iDMA_StrideWidth         = 32;                                 // iDMA Width of the stride field
  typedef enum logic{
    AXI2OBI = 1'b0,
    OBI2AXI = 1'b1
  } idma_transfer_ch_e;                                                                 // iDMA type of transfer channel

  // Parameters used by the Xif Instruction Dispatcher
  parameter int unsigned N_COPROC         = 4;                                          // RedMulE, iDMA, Fractal Sync and FPU
  parameter int unsigned N_RULES          = N_COPROC-1;                                 // RedMulE, iDMA and Fractal Sync all have custom Xif instructions but not FPU
  parameter int unsigned N_REDMULE_SIGN   = 9;                                          // Number of signitures (= {opcode, func3}) in the programming model of RedMulE
  parameter int unsigned N_IDMA_SIGN      = 5;                                          // Number of signitures (= {opcode, func3}) in the programming model of the iDMA decoder
  parameter int unsigned N_FSYNC_SIGN     = 1;                                          // Number of signitures (= {opcode, func3}) in the programming model of Fractal Sync
  parameter int unsigned N_SIGN           = 9;                                          // Number of opcodes = max{RedMulE_signitures, iDMA_signitures, FractalSync_signitures}
  typedef enum logic[1:0]{
    XIF_REDMULE_IDX = 2'b00,
    XIF_IDMA_IDX    = 2'b01,
    XIF_FSYNC_IDX   = 2'b10,
    XIF_FPU_IDX     = 2'b11
  } xif_inst_dispatch_idx_e;
  parameter int unsigned DEFAULT_IDX      = XIF_FPU_IDX;                                // FPU will handle the instructions by default
  parameter int unsigned OPCODE_W         = 7;                                          // ISA OPCODE Width
  parameter int unsigned OPCODE_OFF       = 0;                                          // ISA OPCODE Offset
  parameter int unsigned FUNC3_W          = 3;                                          // ISA FUNC3 Width
  parameter int unsigned FUNC3_OFF        = 12;                                         // ISA FUNC3 Offset
  parameter int unsigned SIGN_W           = OPCODE_W + FUNC3_W;                         // Width of the instruction signiture
  parameter bit          PRIORITY         = 0;                                          // Indicates that the dispatcher should rout the instruction to only 1 coprocessor (with highest priority)

  // Parameters used by the iDMA instruction decoder
  parameter int unsigned DMA_INSTR_W              = magia_pkg::INSTR_W;                 // iDMA Decoder instruction width
  parameter int unsigned DMA_DATA_W               = magia_pkg::DATA_W;                  // iDMA Decoder data width
  parameter int unsigned DMA_ADDR_W               = magia_pkg::ADDR_W;                  // iDMA Decoder address width
  parameter int unsigned DMA_N_RF_PORTS           = X_NUM_RS;                           // iDMA Decoder number of register file read ports
  parameter int unsigned DMA_OPCODE_W             = OPCODE_W;                           // iDMA Decoder OPCODE field width
  parameter int unsigned DMA_FUNC3_W              = FUNC3_W;                            // iDMA Decoder FUNC3 field width
  parameter int unsigned DMA_ND_EN_W              = 2;                                  // iDMA Decoder ND_EN field width
  parameter int unsigned DMA_DST_MAX_LOG_LEN_W    = 3;                                  // iDMA Decoder DST_MAX_LOG_LEN field width
  parameter int unsigned DMA_SRC_MAX_LOG_LEN_W    = 3;                                  // iDMA Decoder SRC_MAX_LOG_LEN field width
  parameter int unsigned DMA_DST_REDUCE_LEN_W     = 1;                                  // iDMA Decoder DST_REDUCE_LEN field width
  parameter int unsigned DMA_SRC_REDUCE_LEN_W     = 1;                                  // iDMA Decoder SRC_REDUCE_LEN field width
  parameter int unsigned DMA_DECOUPLE_R_W_W       = 1;                                  // iDMA Decoder DECOUPLE_R_W field width
  parameter int unsigned DMA_DECOUPLE_R_AW_W      = 1;                                  // iDMA Decoder DECOUPLE_R_AW field width
  parameter int unsigned DMA_DIRECTION_W          = 1;                                  // iDMA Decoder DIRECTION field width
  parameter int unsigned DMA_OPCODE_OFF           = OPCODE_OFF;                         // iDMA Decoder OPCODE field offset
  parameter int unsigned DMA_FUNC3_OFF            = FUNC3_OFF;                          // iDMA Decoder FUNC3 field offset
  parameter int unsigned DMA_ND_EN_OFF            = 26;                                 // iDMA Decoder ND_EN field offset
  parameter int unsigned DMA_DST_MAX_LOG_LEN_OFF  = 22;                                 // iDMA Decoder DST_MAX_LOG_LEN field offset
  parameter int unsigned DMA_SRC_MAX_LOG_LEN_OFF  = 19;                                 // iDMA Decoder SRC_MAX_LOG_LEN field offset
  parameter int unsigned DMA_DST_REDUCE_LEN_OFF   = 18;                                 // iDMA Decoder DST_REDUCE_LEN field offset
  parameter int unsigned DMA_SRC_REDUCE_LEN_OFF   = 17;                                 // iDMA Decoder SRC_REDUCE_LEN field offset
  parameter int unsigned DMA_DECOUPLE_R_W_OFF     = 16;                                 // iDMA Decoder DECOUPLE_R_W field offset
  parameter int unsigned DMA_DECOUPLE_R_AW_OFF    = 15;                                 // iDMA Decoder DECOUPLE_R_AW field offset
  parameter int unsigned DMA_DIRECTION_OFF        = 25;                                 // iDMA Decoder DIRECTION field offset
  parameter int unsigned DMA_N_CFG_REG            = 10;                                 // iDMA Decoder number of configuration registers of the iDMA forntend: CONF, DST_ADDR, SRC_ADDR, LENGTH, DST_STRIDE_2, SRC_STRIDE_2, REPS_2, DST_STRIDE_3, SRC_STRIDE_3, REPS_3
  parameter int unsigned DMA_CONF_IDX             = 0;                                  // iDMA Decoder CONF cofiguration register index 
  parameter int unsigned DMA_DST_ADDR_IDX         = 1;                                  // iDMA Decoder DST_ADDR cofiguration register index 
  parameter int unsigned DMA_SRC_ADDR_IDX         = 2;                                  // iDMA Decoder SRC_ADDR cofiguration register index 
  parameter int unsigned DMA_LENGTH_IDX           = 3;                                  // iDMA Decoder LENGTH cofiguration register index 
  parameter int unsigned DMA_DST_STRIDE_2_IDX     = 4;                                  // iDMA Decoder DST_STRIDE_2 cofiguration register index 
  parameter int unsigned DMA_SRC_STRIDE_2_IDX     = 5;                                  // iDMA Decoder SRC_STRIDE_2 cofiguration register index 
  parameter int unsigned DMA_REPS_2_IDX           = 6;                                  // iDMA Decoder REPS_2 configuration register index
  parameter int unsigned DMA_DST_STRIDE_3_IDX     = 7;                                  // iDMA Decoder DST_STRIDE_3 cofiguration register index 
  parameter int unsigned DMA_SRC_STRIDE_3_IDX     = 8;                                  // iDMA Decoder SRC_STRIDE_3 cofiguration register index 
  parameter int unsigned DMA_REPS_3_IDX           = 9;                                  // iDMA Decoder REPS_3 configuration register index
  parameter logic[DMA_OPCODE_W-1:0] CONF_OPCODE   = 7'b101_1011;                        // iDMA Decoder CONF instruction OPCODE
  parameter logic[ DMA_FUNC3_W-1:0] CONF_FUNC3    = 3'b000;                             // iDMA Decoder CONF instruction FUNC3
  parameter logic[DMA_OPCODE_W-1:0] SET_OPCODE    = 7'b111_1011;                        // iDMA Decoder SET (ADDR/LEN, STD_2/REP_2, STD_3/REP_3, START) instruction OPCODE
  parameter logic[ DMA_FUNC3_W-1:0] SET_AL_FUNC3  = 3'b000;                             // iDMA Decoder ADDR/LEN instruction FUNC3
  parameter logic[ DMA_FUNC3_W-1:0] SET_SR2_FUNC3 = 3'b001;                             // iDMA Decoder STD_2/REP_2 instruction FUNC3
  parameter logic[ DMA_FUNC3_W-1:0] SET_SR3_FUNC3 = 3'b010;                             // iDMA Decoder STD_3/REP_3 instruction FUNC3
  parameter logic[ DMA_FUNC3_W-1:0] SET_S_FUNC3   = 3'b111;                             // iDMA Decoder START instruction FUNC3

  // Parameters used by the Fractal Sync instruction decoder
  parameter int unsigned FSYNC_INSTR_W             = magia_pkg::INSTR_W;                // Fractal Sync Decoder instruction width
  parameter int unsigned FSYNC_DATA_W              = magia_pkg::DATA_W;                 // Fractal Sync Decoder data width
  parameter int unsigned FSYNC_ADDR_W              = magia_pkg::ADDR_W;                 // Fractal Sync Decoder address width
  parameter int unsigned FSYNC_N_RF_PORTS          = X_NUM_RS;                          // Fractal Sync Decoder number of register file read ports
  parameter int unsigned FSYNC_OPCODE_W            = OPCODE_W;                          // Fractal Sync Decoder OPCODE field width
  parameter int unsigned FSYNC_FUNC3_W             = FUNC3_W;                           // Fractal Sync Decoder FUNC3 field width
  parameter int unsigned FSYNC_OPCODE_OFF          = OPCODE_OFF;                        // Fractal Sync Decoder OPCODE field offset
  parameter int unsigned FSYNC_FUNC3_OFF           = FUNC3_OFF;                         // Fractal Sync Decoder FUNC3 field offset
  parameter int unsigned FSYNC_N_CFG_REG           = 2;                                 // Fractal Sync Decoder number of configuration registers: AGGR, ID
  parameter int unsigned FSYNC_AGGR_IDX            = 0;                                 // Fractal Sync Decoder AGGR cofiguration register index 
  parameter int unsigned FSYNC_ID_IDX              = 1;                                 // Fractal Sync Decoder ID cofiguration register index 
  parameter logic[FSYNC_OPCODE_W-1:0] FSYNC_OPCODE = 7'b101_1011;                       // Fractal Sync Decoder instruction OPCODE
  parameter logic[ FSYNC_FUNC3_W-1:0] FSYNC_FUNC3  = 3'b010;                            // Fractal Sync Decoder instruction FUNC3
  parameter int unsigned FSYNC_AGGR_W              = magia_pkg::TILE_FSYNC_AGGR_W;      // Fractal Sync Aggr. width for non-neighbor nodes
  parameter int unsigned FSYNC_LVL_W               = magia_pkg::TILE_FSYNC_LVL_W;       // Fractal Sync Level width for non-neighbor nodes
  parameter int unsigned FSYNC_ID_W                = magia_pkg::TILE_FSYNC_ID_W;        // Fractal Sync Id width for non-neighbor nodes
  parameter int unsigned FSYNC_NBR_AGGR_W          = 1;                                 // Fractal Sync Aggr. width for neighbor nodes
  parameter int unsigned FSYNC_NBR_LVL_W           = 1;                                 // Fractal Sync Level width for neighbor nodes
  parameter int unsigned FSYNC_NBR_ID_W            = 2;                                 // Fractal Sync Id width for neighbor nodes
  parameter bit          FSYNC_STALL               = 1;                                 // Fractal Sync Stall during synchronization

  // Parameters of the AXI XBAR
  parameter int unsigned AxiXbarNoSlvPorts     = 5;                                     // Number of Slave Ports (ext, iDMA, Core Data, CV32 I$, Spatz I$)
  parameter int unsigned AxiXbarNoMstPorts     = 3;                                     // Number of Master Ports (to ext, to internal L1, to Spatz bootrom)
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
  parameter int unsigned SET_COUNT      = 32;                                           // i$ The set associativity of the cache. Power of two; >= 1.
  parameter int unsigned L0_PARITY_W    = 0;                                            // i$ Parity of the L0 cache
  parameter int unsigned L1_PARITY_W    = L0_PARITY_W;                                  // i$ Parity of the L1 cache
  parameter int unsigned FETCH_AW       = magia_pkg::ADDR_W;                            // i$ Fetch interface address width. Same as FETCH_AW; >= 1.
  parameter int unsigned FETCH_DW       = magia_pkg::DATA_W;                            // i$ Fetch interface data width. Power of two; >= 8.
  parameter int unsigned FILL_AW        = magia_pkg::ADDR_W;                            // i$ Fill interface address width. Same as FILL_AW; >= 1.
  parameter int unsigned FILL_DW        = magia_pkg::DATA_W;                            // i$ Fill interface data width. Power of two; >= 8.

  // Spatz ICache parameters (dedicated icache for Spatz CC)
  parameter int unsigned SPATZ_ICACHE_LINE_WIDTH = 256;                                 // Spatz i$ cache line width (should be investigated which is the best value)
  parameter int unsigned SPATZ_ICACHE_LINE_COUNT = 32;                                  // Spatz i$ number of cache lines
  parameter int unsigned SPATZ_ICACHE_WAYS       = 2;                                   // Spatz i$ number of ways (2-way set associative)
  localparam int unsigned SPATZ_L0_EARLY_TAG_W   = snitch_pkg::PAGE_SHIFT - $clog2(SPATZ_ICACHE_LINE_WIDTH/8); // L0 early tag width
  
  // Parameters used by the FPU
  parameter bit                             FPU_ZFINX          = 0;                     // FPU use Zfinx extension instead of the F ISA extention
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

  typedef enum logic[1:0]{
    OBI_SPATZ_IDX = 2,
    OBI_EXT_IDX   = 1,
    OBI_CORE_IDX  = 0
  } obi_xbar_idx_e;

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

`ifdef CV32E40X
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
  } core_data_req_t;

  typedef struct packed {
    logic                        gnt;
    logic                        rvalid;
    logic[magia_pkg::DATA_W-1:0] rdata;
    logic                        err;
    logic                        exokay;
  } core_data_rsp_t;
`else
  typedef struct packed {
    logic                        req;
    logic[magia_pkg::ADDR_W-1:0] addr;
    logic[3                  :0] be;
    logic[magia_pkg::DATA_W-1:0] wdata;
    logic                        we;
  } core_data_req_t;

  typedef struct packed {
    logic                        gnt;
    logic                        rvalid;
    logic[magia_pkg::DATA_W-1:0] rdata;
    logic                        err;
  } core_data_rsp_t;
`endif

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

`ifdef CV32E40X
  typedef enum logic[2:0]{
    OBI_XBAR_STACK_IDX        = 5,
    OBI_XBAR_SPATZ_CTRL_IDX   = 4,
    OBI_XBAR_EVENT_UNIT_IDX   = 3,
    OBI_XBAR_RESERVED_IDX     = 2,
    OBI_XBAR_L1SPM_IDX        = 1,
    OBI_XBAR_L2_IDX           = 0
  } obi_mem_array_idx_e;
`else
  typedef enum logic[3:0]{
    OBI_XBAR_STACK_IDX        = 8,
    OBI_XBAR_RESERVED_IDX     = 7,
    OBI_XBAR_SPATZ_CTRL_IDX   = 6,
    OBI_XBAR_EVENT_UNIT_IDX   = 5,
    OBI_XBAR_FSYNC_CTRL_IDX   = 4,
    OBI_XBAR_IDMA_IDX         = 3,
    OBI_XBAR_REDMULE_CTRL_IDX = 2,
    OBI_XBAR_L1SPM_IDX        = 1,
    OBI_XBAR_L2_IDX           = 0
  } obi_mem_array_idx_e;
`endif

  typedef enum logic[2:0]{
    AXI_XBAR_STACK_IDX    = 4,
    AXI_XBAR_RESERVED_IDX = 3,
    AXI_XBAR_L1SPM_IDX    = 2,
    AXI_XBAR_BOOTROM_IDX  = 1, 
    AXI_XBAR_L2_IDX       = 0
  } axi_mem_array_idx_e;


  typedef enum logic[2:0]{
    AXI_SPATZ_INSTR_IDX =  4,
    AXI_EXT_IDX          = 3,
    AXI_IDMA_IDX         = 2,
    AXI_CORE_DATA_IDX    = 1,
    AXI_CORE_INSTR_IDX   = 0
  } axi_xbar_idx_e;

  
  typedef enum logic[1:0]{
    AXI_XBAR_MST_EXT_IDX     = 0,
    AXI_XBAR_MST_INT_IDX     = 1,
    AXI_XBAR_MST_BOOTROM_IDX = 2
  } axi_xbar_mst_idx_e;

  typedef struct packed {
    logic[N_SIGN-1:0][SIGN_W-1:0] sign_list;
  } xif_inst_rule_t;

  typedef logic[iDMA_AddrWidth-1:0] idma_addr_t;

  `HWPE_CTRL_TYPEDEF_REQ_T(redmule_ctrl_req_t, logic[AWC-1:0], logic[DWH-1:0], logic[SWH-1:0], logic[IW-1:0])
  `HWPE_CTRL_TYPEDEF_RSP_T(redmule_ctrl_rsp_t, logic[DWH-1:0], logic[IW-1:0])
  
  `HCI_TYPEDEF_REQ_T(redmule_data_req_t, logic[AWC-1:0], logic[DWH-1:0], logic[SWH-1:0], logic[UWH-1:0], logic[0:0], logic[0:0], logic[0:0])
  `HCI_TYPEDEF_RSP_T(redmule_data_rsp_t, logic[DWH-1:0], logic[UWH-1:0], logic[0:0], logic[0:0], logic[0:0])

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

  `HCI_TYPEDEF_REQ_T(core_hci_data_req_t, logic[AWC-1:0], logic[DW_LIC-1:0], logic[SW_LIC-1:0], logic[UWH-1:0], logic[0:0], logic[0:0], logic[0:0])
  `HCI_TYPEDEF_RSP_T(core_hci_data_rsp_t, logic[DW_LIC-1:0], logic[UWH-1:0], logic[0:0], logic[0:0], logic[0:0])

  `AXI_TYPEDEF_ALL_CT(core_axi_data, core_axi_data_req_t, core_axi_data_rsp_t, logic[magia_pkg::ADDR_W-1:0], logic[AXI_ID_W-1:0], logic[magia_pkg::DATA_W-1:0], logic[magia_pkg::STRB_W-1:0], logic[AXI_U_W-1:0])
  `AXI_TYPEDEF_ALL_CT(core_axi_instr, core_axi_instr_req_t, core_axi_instr_rsp_t, logic[magia_pkg::ADDR_W-1:0], logic[AXI_ID_W-1:0], logic[magia_pkg::DATA_W-1:0], logic[magia_pkg::STRB_W-1:0], logic[AXI_U_W-1:0])

  `REG_BUS_TYPEDEF_ALL(reg_dma, logic[magia_pkg::ADDR_W-1:0], logic[magia_pkg::DATA_W-1:0], logic[magia_pkg::STRB_W-1:0])
  `REG_BUS_TYPEDEF_ALL(idma_fe_reg, logic[magia_pkg::ADDR_W-1:0], logic[magia_pkg::DATA_W-1:0], logic[magia_pkg::STRB_W-1:0])

  `IDMA_TYPEDEF_FULL_REQ_T(idma_be_req_t, logic[iDMA_AxiIdWidth-1:0], idma_addr_t, logic[iDMA_TFLenWidth-1:0])
  `IDMA_TYPEDEF_FULL_RSP_T(idma_be_rsp_t, idma_addr_t)
  `IDMA_TYPEDEF_FULL_ND_REQ_T(idma_nd_req_t, idma_be_req_t, logic[iDMA_RepWidth-1:0], logic[iDMA_StrideWidth-1:0])

  `AXI_TYPEDEF_ALL_CT(idma_axi, idma_axi_req_t, idma_axi_rsp_t, logic[iDMA_AddrWidth-1:0], logic[iDMA_AxiIdWidth-1:0], logic[iDMA_DataWidth-1:0], logic[iDMA_StrbWidth-1:0], logic[iDMA_UserWidth-1:0])
  
  parameter obi_pkg::obi_optional_cfg_t OptionalCfg = obi_pkg::ObiMinimalOptionalConfig;
  parameter obi_pkg::obi_cfg_t obi_cfg = '{
       OptionalCfg : OptionalCfg,
       AddrWidth   : iDMA_AddrWidth, 
       DataWidth   : iDMA_DataWidth,
       IdWidth     : iDMA_AxiIdWidth,
       UseRReady   : 1'b0,
       CombGnt     : 1'b0,
       Integrity   : 1'b0,
       BeFull      : 1'b1
  };

  `OBI_TYPEDEF_ALL(idma_obi, obi_cfg)

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
  `AXI_TYPEDEF_ALL_CT(axi_xbar_mst, axi_xbar_mst_req_t, axi_xbar_mst_rsp_t, logic[magia_pkg::ADDR_W-1:0], logic[AXI_MST_ID_W-1:0], logic[magia_pkg::DATA_W-1:0], logic[magia_pkg::STRB_W-1:0], logic[AXI_U_W-1:0])

  `HCI_TYPEDEF_REQ_T(idma_hci_req_t, logic[AWC-1:0], logic[DW_LIC-1:0], logic[SW_LIC-1:0], logic[UWH-1:0], logic[0:0], logic[0:0], logic[0:0])
  `HCI_TYPEDEF_RSP_T(idma_hci_rsp_t, logic[DW_LIC-1:0], logic[UWH-1:0], logic[0:0], logic[0:0], logic[0:0])
  
  localparam axi_pkg::xbar_cfg_t axi_xbar_cfg = '{
    NoSlvPorts          : AxiXbarNoSlvPorts,
    NoMstPorts          : AxiXbarNoMstPorts,
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
    NoAddrRules         : 4
  };

  `FSYNC_TYPEDEF_ALL(ht_tile_fsync, logic[FSYNC_AGGR_W-1:0], logic[FSYNC_LVL_W-1:0], logic[FSYNC_ID_W-1:0])
  `FSYNC_TYPEDEF_ALL(vt_tile_fsync, logic[FSYNC_AGGR_W-1:0], logic[FSYNC_LVL_W-1:0], logic[FSYNC_ID_W-1:0])
  `FSYNC_TYPEDEF_ALL(hn_tile_fsync, logic[FSYNC_NBR_AGGR_W-1:0], logic[FSYNC_NBR_LVL_W-1:0], logic[FSYNC_NBR_ID_W-1:0])
  `FSYNC_TYPEDEF_ALL(vn_tile_fsync, logic[FSYNC_NBR_AGGR_W-1:0], logic[FSYNC_NBR_LVL_W-1:0], logic[FSYNC_NBR_ID_W-1:0])

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