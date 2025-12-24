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
 * Authors: Luca Balboni <luca.balboni10@studio.unibo.it>
 * 
 * Spatz Core Complex Wrapper for MAGIA Tile
 * 
 */

`include "snitch_vm/typedef.svh"

module spatz_cc_wrapper
  import magia_tile_pkg::*;
  import magia_pkg::*;
  import snitch_pkg::*;
  import obi_pkg::*;
  import fpnew_pkg::*;
#(
  // Spatz Core Complex Parameters
  parameter int unsigned AddrWidth                = magia_pkg::ADDR_W,
  parameter int unsigned DataWidth                = magia_tile_pkg::SPATZ_TCDM_DATA_WIDTH,
  parameter int unsigned TCDMAddrWidth            = magia_tile_pkg::SPATZ_TCDM_ADDR_WIDTH,
  parameter int unsigned NumSpatzFPUs             = magia_tile_pkg::SPATZ_NUM_FPU,
  parameter int unsigned NumSpatzIPUs             = magia_tile_pkg::SPATZ_NUM_IPU,
  parameter int unsigned NumIntOutstandingLoads   = magia_tile_pkg::SPATZ_NUM_INT_OUTSTANDING_LOADS,
  parameter int unsigned NumIntOutstandingMem     = magia_tile_pkg::SPATZ_NUM_INT_OUTSTANDING_MEM,
  parameter int unsigned NumSpatzOutstandingLoads = magia_tile_pkg::SPATZ_NUM_SPATZ_OUTSTANDING_LOADS,
  parameter bit          Xdma                     = magia_tile_pkg::SPATZ_XDMA,
  parameter bit          RVF                      = magia_tile_pkg::SPATZ_RVF,
  parameter bit          RVD                      = magia_tile_pkg::SPATZ_RVD_PARAM,
  parameter bit          RVV                      = magia_tile_pkg::SPATZ_RVV,
  parameter bit          XDivSqrt                 = magia_tile_pkg::SPATZ_XDIVSQRT,
  parameter bit          RegisterOffloadRsp       = magia_tile_pkg::SPATZ_REGISTER_OFFLOAD_RSP,
  parameter bit          RegisterCoreReq          = magia_tile_pkg::SPATZ_REGISTER_CORE_REQ,
  parameter bit          RegisterCoreRsp          = magia_tile_pkg::SPATZ_REGISTER_CORE_RSP,
  parameter logic [31:0] BootAddr                 = magia_tile_pkg::SPATZ_BOOT_ADDR,
  
  // FPU Implementation Configuration (using package parameters for pipeline stages)
  parameter fpnew_pkg::fpu_implementation_t FPUImplementation = '{
    PipeRegs: '{
      // FMA Block: [FP32, FP64, FP16, FP8, FP16ALT, FP8ALT]
      '{magia_tile_pkg::SPATZ_FPU_PIPE_FMA_FP32, magia_tile_pkg::SPATZ_FPU_PIPE_FMA_FP64, 0, 0, 0, 0},  // FMA configurable
      '{XDivSqrt ? magia_tile_pkg::SPATZ_FPU_PIPE_DIVSQRT_FP32 : 0, XDivSqrt ? magia_tile_pkg::SPATZ_FPU_PIPE_DIVSQRT_FP64 : 0, 0, 0, 0, 0},  // DIVSQRT
      '{magia_tile_pkg::SPATZ_FPU_PIPE_NONCOMP, magia_tile_pkg::SPATZ_FPU_PIPE_NONCOMP, magia_tile_pkg::SPATZ_FPU_PIPE_NONCOMP, magia_tile_pkg::SPATZ_FPU_PIPE_NONCOMP, magia_tile_pkg::SPATZ_FPU_PIPE_NONCOMP, magia_tile_pkg::SPATZ_FPU_PIPE_NONCOMP},  // NONCOMP
      '{magia_tile_pkg::SPATZ_FPU_PIPE_CONV, magia_tile_pkg::SPATZ_FPU_PIPE_CONV, magia_tile_pkg::SPATZ_FPU_PIPE_CONV, magia_tile_pkg::SPATZ_FPU_PIPE_CONV, magia_tile_pkg::SPATZ_FPU_PIPE_CONV, magia_tile_pkg::SPATZ_FPU_PIPE_CONV},  // CONV
      '{magia_tile_pkg::SPATZ_FPU_PIPE_DOTP, magia_tile_pkg::SPATZ_FPU_PIPE_DOTP, magia_tile_pkg::SPATZ_FPU_PIPE_DOTP, magia_tile_pkg::SPATZ_FPU_PIPE_DOTP, magia_tile_pkg::SPATZ_FPU_PIPE_DOTP, magia_tile_pkg::SPATZ_FPU_PIPE_DOTP}   // DOTP
    },
    UnitTypes: '{
      '{fpnew_pkg::MERGED, fpnew_pkg::MERGED, fpnew_pkg::MERGED, fpnew_pkg::MERGED, fpnew_pkg::MERGED, fpnew_pkg::MERGED},  // FMA merged
      '{XDivSqrt ? fpnew_pkg::MERGED : fpnew_pkg::DISABLED, XDivSqrt ? fpnew_pkg::MERGED : fpnew_pkg::DISABLED, fpnew_pkg::DISABLED, fpnew_pkg::DISABLED, fpnew_pkg::DISABLED, fpnew_pkg::DISABLED},  // DIVSQRT
      '{fpnew_pkg::PARALLEL, fpnew_pkg::PARALLEL, fpnew_pkg::PARALLEL, fpnew_pkg::PARALLEL, fpnew_pkg::PARALLEL, fpnew_pkg::PARALLEL},  // NONCOMP parallel
      '{fpnew_pkg::MERGED, fpnew_pkg::MERGED, fpnew_pkg::MERGED, fpnew_pkg::MERGED, fpnew_pkg::MERGED, fpnew_pkg::MERGED},  // CONV merged
      '{fpnew_pkg::MERGED, fpnew_pkg::MERGED, fpnew_pkg::MERGED, fpnew_pkg::MERGED, fpnew_pkg::MERGED, fpnew_pkg::MERGED}   // DOTP merged
    },
    PipeConfig: fpnew_pkg::BEFORE  // Pipeline registers BEFORE FPU (Spatz Cluster default)
  },
  
  // Derived parameters - calcolo dinamico basato su N_IPU e N_FPU configurabili
  localparam int unsigned NumSpatzFUs         = (NumSpatzFPUs > NumSpatzIPUs) ? NumSpatzFPUs : NumSpatzIPUs,
  localparam int unsigned NumMemPortsPerSpatz = NumSpatzFUs,
  localparam int unsigned TCDMPorts           = RVV ? NumMemPortsPerSpatz + 1 : 1,  // N_FU + 1 TCDM ports
  localparam int unsigned HCIMasterPorts      = RVD ? (TCDMPorts * 2) : TCDMPorts   // RVD=1: 2 HCI32/TCDM, RVD=0: 1 HCI32/TCDM
)(
  input  logic                                    clk_i,
  input  logic                                    rst_ni,
  input  logic                                    test_mode_i,
  
  // Core configuration
  input  logic [31:0]                             hart_id_i,
  
  // Interrupts
  input  snitch_pkg::interrupts_t                 irq_i,
  
  // HCI Master Interface(s) - Connect to MAGIA HCI Interconnect for L1 SPM access
  output magia_tile_pkg::core_hci_data_req_t [HCIMasterPorts-1:0] hci_master_req_o,
  input  magia_tile_pkg::core_hci_data_rsp_t [HCIMasterPorts-1:0] hci_master_rsp_i,
  
  // OBI Master Interface - Single port for Snitch core
  output magia_tile_pkg::core_obi_data_req_t      obi_master_req_o,
  input  magia_tile_pkg::core_obi_data_rsp_t      obi_master_rsp_i,
  
  // Core -> ICache signals (from hive_req)
  output logic                                    inst_req_o,        // Core wants instruction (inst_valid)
  output logic [AddrWidth-1:0]                    inst_addr_o,       // Instruction address
  output logic                                    inst_cacheable_o,  // Cacheable flag
  output logic                                    flush_i_valid_o,   // Flush request
  // ICache -> Core signals (to hive_rsp)
  input  logic [31:0]                             inst_data_i,       // Instruction data
  input  logic                                    inst_ready_i,      // ICache has data ready
  input  logic                                    inst_error_i,      // Fetch error
  input  logic                                    flush_i_ready_i,   // Flush complete
  
  // Events and status
  output snitch_pkg::core_events_t                core_events_o
);

  /*******************************************************************/
  /*                     Internal Type Definitions                   */
  /*******************************************************************/
  
  // Local type aliases
  typedef logic [AddrWidth-1:0] addr_t;
  typedef logic [DataWidth-1:0] data_t;
  
  // Accelerator types
  typedef struct packed {
    logic [31:0] addr;
    logic [5:0]  id;
    logic [31:0] data_op;
    data_t       data_arga;
    data_t       data_argb;
    addr_t       data_argc;
  } acc_issue_req_t;
  
  typedef struct packed {
    logic accept;
    logic writeback;
    logic loadstore;
    logic exception;
    logic isfloat;
  } acc_issue_rsp_t;
  
  typedef struct packed {
    logic [5:0] id;
    logic       error;
    data_t      data;
  } acc_rsp_t;
  
  // Virtual memory types - use macro from snitch_vm/typedef.svh
  `SNITCH_VM_TYPEDEF(AddrWidth)
  
  // Hive types (instruction fetch) - matching spatz_cluster.sv
  typedef struct packed {
    logic flush_i_valid;
    addr_t inst_addr;
    logic inst_cacheable;
    logic inst_valid;
    acc_issue_req_t acc_req;
    logic acc_qvalid;
    logic acc_pready;
    logic [1:0] ptw_valid;   
    va_t [1:0] ptw_va;        
    pa_t [1:0] ptw_ppn;        
  } hive_req_t;
  
  typedef struct packed {
    logic flush_i_ready;
    logic [31:0] inst_data;
    logic inst_ready;
    logic inst_error;
    logic acc_qready;
    acc_rsp_t acc_resp;
    logic acc_pvalid;
    logic [1:0] ptw_ready;     
    l0_pte_t [1:0] ptw_pte;     
    logic [1:0] ptw_is_4mega;    
  } hive_rsp_t;
  
  // DMA types - simplified for MAGIA (DMA disabled)
  typedef struct packed {
    logic start;
    logic complete;
    logic error;
  } dma_events_t;
  
  /*******************************************************************/
  /*                     Internal Signal Declarations                */
  /*******************************************************************/
  
  // Spatz_cc internal signals
  hive_req_t                                  hive_req;
  hive_rsp_t                                  hive_rsp;
  
  // Conditional signal declarations based on RVD parameter
  generate
    if (RVD) begin : gen_signals
      // RVD=1: 64-bit signal types
      magia_tile_pkg::spatz_reqrsp64_req_t        data_req;
      magia_tile_pkg::spatz_reqrsp64_rsp_t        data_rsp;
      magia_tile_pkg::spatz_tcdm64_req_t [TCDMPorts-1:0] tcdm_req;
      magia_tile_pkg::spatz_tcdm64_rsp_t [TCDMPorts-1:0] tcdm_rsp;
    end else begin : gen_signals
      // RVD=0: 32-bit signal types
      magia_tile_pkg::spatz_reqrsp_req_t          data_req;
      magia_tile_pkg::spatz_reqrsp_rsp_t          data_rsp;
      magia_tile_pkg::spatz_tcdm_req_t [TCDMPorts-1:0] tcdm_req;
      magia_tile_pkg::spatz_tcdm_rsp_t [TCDMPorts-1:0] tcdm_rsp;
    end
  endgenerate
  
  /*******************************************************************/
  /*                     Spatz Core Complex Instance                 */
  /*******************************************************************/
  
  generate
    if (RVD) begin : gen_spatz_cc_rvd
      // RVD=1: 64-bit configuration
      spatz_cc #(
        .AddrWidth                ( AddrWidth                 ),
        .DataWidth                ( DataWidth                 ),  // 64-bit
        .TCDMAddrWidth            ( TCDMAddrWidth             ),
        .dreq_t                   ( magia_tile_pkg::spatz_reqrsp64_req_t     ),
        .drsp_t                   ( magia_tile_pkg::spatz_reqrsp64_rsp_t     ),
        .tcdm_req_t               ( magia_tile_pkg::spatz_tcdm64_req_t       ),
        .tcdm_req_chan_t          ( magia_tile_pkg::spatz_tcdm64_payload_t   ),
        .tcdm_rsp_t               ( magia_tile_pkg::spatz_tcdm64_rsp_t       ),
        .tcdm_rsp_chan_t          ( magia_tile_pkg::spatz_tcdm64_rsp_chan_t  ),
        .axi_req_t                ( magia_tile_pkg::idma_axi_req_t        ),
        .axi_ar_chan_t            ( magia_tile_pkg::idma_axi_ar_chan_t    ),
        .axi_aw_chan_t            ( magia_tile_pkg::idma_axi_aw_chan_t    ),
        .axi_rsp_t                ( magia_tile_pkg::idma_axi_rsp_t        ),
        .hive_req_t               ( hive_req_t                ),
        .hive_rsp_t               ( hive_rsp_t                ),
        .acc_issue_req_t          ( acc_issue_req_t           ),
        .acc_issue_rsp_t          ( acc_issue_rsp_t           ),
        .acc_rsp_t                ( acc_rsp_t                 ),
        .dma_events_t             ( dma_events_t              ),
        .dma_perf_t               ( logic                     ),
        .FPUImplementation        ( FPUImplementation         ),
        .BootAddr                 ( BootAddr                  ),
        .RVE                      ( 1'b0                      ),
        .RVF                      ( RVF                       ),
        .RVD                      ( 1'b1                      ),
        .XDivSqrt                 ( XDivSqrt                  ),
        .XF8                      ( 1'b1                      ),
        .XF16                     ( 1'b1                      ),
        .XF16ALT                  ( 1'b1                      ),
        .XF8ALT                   ( 1'b1                      ),
        .Xdma                     ( Xdma                      ),
        .NumIntOutstandingLoads   ( NumIntOutstandingLoads    ),
        .NumIntOutstandingMem     ( NumIntOutstandingMem      ),
        .NumSpatzOutstandingLoads ( NumSpatzOutstandingLoads  ),
        .RVV                      ( RVV                       ),
        .NumSpatzFPUs             ( NumSpatzFPUs              ),
        .NumSpatzIPUs             ( NumSpatzIPUs              ),
        .IsoCrossing              ( 1'b0                      ),
        .RegisterOffloadRsp       ( RegisterOffloadRsp        ),
        .RegisterCoreReq          ( RegisterCoreReq           ),
        .RegisterCoreRsp          ( RegisterCoreRsp           )
      ) i_spatz_cc (
        .clk_i                    ( clk_i                     ),
        .clk_d2_i                 ( clk_i                     ),
        .rst_ni                   ( rst_ni                    ),
        .testmode_i               ( test_mode_i               ),
        .hart_id_i                ( hart_id_i                 ),
        .irq_i                    ( irq_i                     ),
        .tcdm_addr_base_i         ( magia_tile_pkg::L1_ADDR_START ),
        .hive_req_o               ( hive_req                  ),
        .hive_rsp_i               ( hive_rsp                  ),
        .data_req_o               ( gen_signals.data_req      ),
        .data_rsp_i               ( gen_signals.data_rsp      ),
        .tcdm_req_o               ( gen_signals.tcdm_req      ),
        .tcdm_rsp_i               ( gen_signals.tcdm_rsp      ),
        .axi_dma_req_o            ( /* DMA disabled */        ),
        .axi_dma_res_i            ( '0                        ),
        .axi_dma_busy_o           ( /* DMA disabled */        ),
        .axi_dma_perf_o           ( /* DMA disabled */        ),
        .axi_dma_events_o         ( /* DMA disabled */        ),
        .core_events_o            ( core_events_o             )
      );
    end else begin : gen_spatz_cc_no_rvd
      // RVD=0: 32-bit configuration
      spatz_cc #(
        .AddrWidth                ( AddrWidth                 ),
        .DataWidth                ( DataWidth                 ),  // 32-bit
        .TCDMAddrWidth            ( TCDMAddrWidth             ),
        .dreq_t                   ( magia_tile_pkg::spatz_reqrsp_req_t     ),
        .drsp_t                   ( magia_tile_pkg::spatz_reqrsp_rsp_t     ),
        .tcdm_req_t               ( magia_tile_pkg::spatz_tcdm_req_t       ),
        .tcdm_req_chan_t          ( magia_tile_pkg::spatz_tcdm_req_chan_t  ),
        .tcdm_rsp_t               ( magia_tile_pkg::spatz_tcdm_rsp_t       ),
        .tcdm_rsp_chan_t          ( magia_tile_pkg::spatz_tcdm_rsp_chan_t  ),
        .axi_req_t                ( magia_tile_pkg::idma_axi_req_t        ),
        .axi_ar_chan_t            ( magia_tile_pkg::idma_axi_ar_chan_t    ),
        .axi_aw_chan_t            ( magia_tile_pkg::idma_axi_aw_chan_t    ),
        .axi_rsp_t                ( magia_tile_pkg::idma_axi_rsp_t        ),
        .hive_req_t               ( hive_req_t                ),
        .hive_rsp_t               ( hive_rsp_t                ),
        .acc_issue_req_t          ( acc_issue_req_t           ),
        .acc_issue_rsp_t          ( acc_issue_rsp_t           ),
        .acc_rsp_t                ( acc_rsp_t                 ),
        .dma_events_t             ( dma_events_t              ),
        .dma_perf_t               ( logic                     ),
        .FPUImplementation        ( FPUImplementation         ),
        .BootAddr                 ( BootAddr                  ),
        .RVE                      ( 1'b0                      ),
        .RVF                      ( RVF                       ),
        .RVD                      ( 1'b0                      ),
        .XDivSqrt                 ( XDivSqrt                  ),
        .XF8                      ( 1'b1                      ),
        .XF16                     ( 1'b1                      ),
        .XF16ALT                  ( 1'b1                      ),
        .XF8ALT                   ( 1'b1                      ),
        .Xdma                     ( Xdma                      ),
        .NumIntOutstandingLoads   ( NumIntOutstandingLoads    ),
        .NumIntOutstandingMem     ( NumIntOutstandingMem      ),
        .NumSpatzOutstandingLoads ( NumSpatzOutstandingLoads  ),
        .RVV                      ( RVV                       ),
        .NumSpatzFPUs             ( NumSpatzFPUs              ),
        .NumSpatzIPUs             ( NumSpatzIPUs              ),
        .IsoCrossing              ( 1'b0                      ),
        .RegisterOffloadRsp       ( RegisterOffloadRsp        ),
        .RegisterCoreReq          ( RegisterCoreReq           ),
        .RegisterCoreRsp          ( RegisterCoreRsp           )
      ) i_spatz_cc (
        .clk_i                    ( clk_i                     ),
        .clk_d2_i                 ( clk_i                     ),
        .rst_ni                   ( rst_ni                    ),
        .testmode_i               ( test_mode_i               ),
        .hart_id_i                ( hart_id_i                 ),
        .irq_i                    ( irq_i                     ),
        .tcdm_addr_base_i         ( magia_tile_pkg::L1_ADDR_START ),
        .hive_req_o               ( hive_req                  ),
        .hive_rsp_i               ( hive_rsp                  ),
        .data_req_o               ( gen_signals.data_req      ),
        .data_rsp_i               ( gen_signals.data_rsp      ),
        .tcdm_req_o               ( gen_signals.tcdm_req      ),
        .tcdm_rsp_i               ( gen_signals.tcdm_rsp      ),
        .axi_dma_req_o            ( /* DMA disabled */        ),
        .axi_dma_res_i            ( '0                        ),
        .axi_dma_busy_o           ( /* DMA disabled */        ),
        .axi_dma_perf_o           ( /* DMA disabled */        ),
        .axi_dma_events_o         ( /* DMA disabled */        ),
        .core_events_o            ( core_events_o             )
      );
    end
  endgenerate
  
  /*******************************************************************/
  /*          Instruction Cache Interface (Hive) Connection         */
  /*******************************************************************/
  
  // Map hive request to external icache ports (Core → ICache)
  assign inst_req_o        = hive_req.inst_valid;
  assign inst_addr_o       = hive_req.inst_addr;
  assign inst_cacheable_o  = hive_req.inst_cacheable;
  assign flush_i_valid_o   = hive_req.flush_i_valid;
  
  // Map external icache response to hive response (ICache → Core)
  assign hive_rsp = '{
    inst_data    : inst_data_i,
    inst_ready   : inst_ready_i,
    inst_error   : inst_error_i,
    flush_i_ready: flush_i_ready_i,
    default      : '0
  };
  
  /*******************************************************************/
  /*         Protocol Conversion: reqrsp (Snitch) → OBI32           */
  /*******************************************************************/
  
  generate
    if (RVD) begin : gen_reqrsp64_to_obi32
      // RVD=1: Snitch data port 64-bit reqrsp → 32-bit OBI (for L2/peripherals)
      reqrsp64_to_obi32 #(
        .reqrsp_req_t ( magia_tile_pkg::spatz_reqrsp64_req_t    ),
        .reqrsp_rsp_t ( magia_tile_pkg::spatz_reqrsp64_rsp_t    ),
        .obi_req_t    ( magia_tile_pkg::core_obi_data_req_t      ),
        .obi_rsp_t    ( magia_tile_pkg::core_obi_data_rsp_t      )
      ) i_snitch_reqrsp_to_obi32 (
        .clk_i        ( clk_i                              ),
        .rst_ni       ( rst_ni                             ),
        .reqrsp_req_i ( gen_signals.data_req               ),
        .reqrsp_rsp_o ( gen_signals.data_rsp               ),
        .obi_req_o    ( obi_master_req_o                   ),
        .obi_rsp_i    ( obi_master_rsp_i                   )
      );
    end else begin : gen_reqrsp32_to_obi32
      // RVD=0: Snitch data port 32-bit reqrsp → 32-bit OBI (for L2/peripherals)
      reqrsp2obi #(
        .reqrsp_req_t ( magia_tile_pkg::spatz_reqrsp_req_t     ),
        .reqrsp_rsp_t ( magia_tile_pkg::spatz_reqrsp_rsp_t     ),
        .obi_req_t    ( magia_tile_pkg::core_obi_data_req_t     ),
        .obi_rsp_t    ( magia_tile_pkg::core_obi_data_rsp_t     )
      ) i_snitch_reqrsp_to_obi32 (
        .clk_i        ( clk_i                              ),
        .rst_ni       ( rst_ni                             ),
        .reqrsp_req_i ( gen_signals.data_req               ),
        .reqrsp_rsp_o ( gen_signals.data_rsp               ),
        .obi_req_o    ( obi_master_req_o                   ),
        .obi_rsp_i    ( obi_master_rsp_i                   )
      );
    end
  endgenerate
  
  /*******************************************************************/
  /*        Protocol Conversion: TCDM (Spatz) → HCI32               */
  /*******************************************************************/
  
  generate
    if (RVD) begin : gen_tcdm64_to_hci
      // RVD=1: Each 64-bit TCDM port splits into 2×32-bit HCI ports
      
      // Ports 0-3: Spatz vector memory ports (64-bit TCDM → 2×32-bit HCI)
      for (genvar i = 0; i < NumMemPortsPerSpatz; i++) begin : gen_tcdm64_to_dual_hci32_spatz
        tcdm64_to_dual_hci32 #(
          .tcdm64_req_t  ( magia_tile_pkg::spatz_tcdm64_req_t  ),
          .tcdm64_rsp_t  ( magia_tile_pkg::spatz_tcdm64_rsp_t  ),
          .tcdm32_req_t  ( magia_tile_pkg::spatz_tcdm32_req_t  ),
          .tcdm32_rsp_t  ( magia_tile_pkg::spatz_tcdm32_rsp_t  ),
          .hci_req_t     ( magia_tile_pkg::core_hci_data_req_t ),
          .hci_rsp_t     ( magia_tile_pkg::core_hci_data_rsp_t )
        ) i_tcdm64_to_dual_hci32_spatz (
          .clk_i         ( clk_i                              ),
          .rst_ni        ( rst_ni                             ),
          .tcdm_req_i    ( gen_signals.tcdm_req[i]            ),
          .tcdm_rsp_o    ( gen_signals.tcdm_rsp[i]            ),
          .hci_req_lo_o  ( hci_master_req_o[i*2]              ),
          .hci_rsp_lo_i  ( hci_master_rsp_i[i*2]              ),
          .hci_req_hi_o  ( hci_master_req_o[i*2+1]            ),
          .hci_rsp_hi_i  ( hci_master_rsp_i[i*2+1]            )
        );
      end
      
      // Port 4: Snitch RV64 TCDM (with AMO) → Dual HCI32 (ports 8-9)
      tcdm64_to_dual_hci32_atomic #(
        .tcdm64_req_t         ( magia_tile_pkg::spatz_tcdm64_req_t         ),
        .tcdm64_rsp_t         ( magia_tile_pkg::spatz_tcdm64_rsp_t         ),
        .tcdm32_req_t         ( magia_tile_pkg::spatz_tcdm32_req_t         ),
        .tcdm32_rsp_t         ( magia_tile_pkg::spatz_tcdm32_rsp_t         ),
        .obi32_req_t          ( magia_tile_pkg::spatz_obi32_req_t          ),
        .obi32_rsp_t          ( magia_tile_pkg::spatz_obi32_rsp_t          ),
        .hci_req_t            ( magia_tile_pkg::core_hci_data_req_t        ),
        .hci_rsp_t            ( magia_tile_pkg::core_hci_data_rsp_t        ),
        .obi32_a_optional_t   ( magia_tile_pkg::spatz_obi32_a_optional_t  ),
        .obi32_r_optional_t   ( magia_tile_pkg::spatz_obi32_r_optional_t  ),
        .SbrPortObiCfg        ( magia_tile_pkg::obi_amo_cfg                ),
        .MgrPortObiCfg        ( magia_tile_pkg::obi_no_amo_cfg             )
      ) i_tcdm64_to_dual_hci32_atomic_snitch (
        .clk_i         ( clk_i                                      ),
        .rst_ni        ( rst_ni                                     ),
        .tcdm_req_i    ( gen_signals.tcdm_req[NumMemPortsPerSpatz]  ),
        .tcdm_rsp_o    ( gen_signals.tcdm_rsp[NumMemPortsPerSpatz]  ),
        .hci_req_lo_o  ( hci_master_req_o[NumMemPortsPerSpatz*2]        ),
        .hci_rsp_lo_i  ( hci_master_rsp_i[NumMemPortsPerSpatz*2]        ),
        .hci_req_hi_o  ( hci_master_req_o[NumMemPortsPerSpatz*2+1]      ),
        .hci_rsp_hi_i  ( hci_master_rsp_i[NumMemPortsPerSpatz*2+1]      )
      );
      
    end else begin : gen_tcdm32_to_hci
      // RVD=0: Each 32-bit TCDM port maps directly to 1×32-bit HCI port
      
      // Ports 0-3: Spatz vector memory ports (32-bit TCDM → 32-bit HCI)
      for (genvar i = 0; i < NumMemPortsPerSpatz; i++) begin : gen_tcdm32_to_hci32_spatz
        tcdm2hci #(
          .tcdm_req_t  ( magia_tile_pkg::spatz_tcdm_req_t     ),
          .tcdm_rsp_t  ( magia_tile_pkg::spatz_tcdm_rsp_t     ),
          .hci_req_t   ( magia_tile_pkg::core_hci_data_req_t  ),
          .hci_rsp_t   ( magia_tile_pkg::core_hci_data_rsp_t  )
        ) i_tcdm32_to_hci32_spatz (
          .clk_i       ( clk_i                            ),
          .rst_ni      ( rst_ni                           ),
          .tcdm_req_i  ( gen_signals.tcdm_req[i]          ),
          .tcdm_rsp_o  ( gen_signals.tcdm_rsp[i]          ),
          .hci_req_o   ( hci_master_req_o[i]              ),
          .hci_rsp_i   ( hci_master_rsp_i[i]              )
        );
      end
      
      // Port 4: Snitch RV32 TCDM (with AMO) → HCI32
      tcdm2hci_atomic #(
        .tcdm_req_t         ( magia_tile_pkg::spatz_tcdm_req_t         ),
        .tcdm_rsp_t         ( magia_tile_pkg::spatz_tcdm_rsp_t         ),
        .obi_req_t          ( magia_tile_pkg::core_obi_data_req_t      ),
        .obi_rsp_t          ( magia_tile_pkg::core_obi_data_rsp_t      ),
        .hci_req_t          ( magia_tile_pkg::core_hci_data_req_t      ),
        .hci_rsp_t          ( magia_tile_pkg::core_hci_data_rsp_t      ),
        .obi_a_optional_t   ( magia_tile_pkg::core_data_obi_a_optional_t ),
        .obi_r_optional_t   ( magia_tile_pkg::core_data_obi_r_optional_t ),
        .SbrPortObiCfg      ( magia_tile_pkg::obi_amo_cfg              ),
        .MgrPortObiCfg      ( magia_tile_pkg::obi_no_amo_cfg           )
      ) i_tcdm32_to_hci32_atomic_snitch (
        .clk_i       ( clk_i                                      ),
        .rst_ni      ( rst_ni                                     ),
        .tcdm_req_i  ( gen_signals.tcdm_req[NumMemPortsPerSpatz]  ),
        .tcdm_rsp_o  ( gen_signals.tcdm_rsp[NumMemPortsPerSpatz]  ),
        .hci_req_o   ( hci_master_req_o[NumMemPortsPerSpatz]             ),
        .hci_rsp_i   ( hci_master_rsp_i[NumMemPortsPerSpatz]             )
      );
    end
  endgenerate

endmodule : spatz_cc_wrapper
