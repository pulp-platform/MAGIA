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

 module redemule_tile;
  import redmule_pkg::*;
  import fpnew_pkg::*;
  import hci_package::*;
 #(
  // parameters used by redmule_complex
  parameter  redmule_pkg::core_type_e CoreType          = redmule_pkg::CV32X           , // CV32E40P, IBEX, SNITCH, CVA6
  parameter  int unsigned             ID_WIDTH          = 8                            ,
  parameter  int unsigned             N_CORES           = 8                            ,
  parameter  int unsigned             DW                = redmule_pkg::DATA_W          , // TCDM port dimension (in bits)
  parameter  int unsigned             MP                = DW/redmule_pkg::MemDw        ,
  parameter  int unsigned             NumIrqs           = 32                           ,
  parameter  int unsigned             AddrWidth         = 32                           ,
  parameter  int unsigned             XPulp             = 0                            ,
  parameter  int unsigned             FpuPresent        = 0                            ,
  parameter  int unsigned             Zfinx             = 0                            ,
  localparam fpnew_pkg::fp_format_e   FpFormat          = redmule_pkg::FPFORMAT        , // Data format (default is FP16)
  localparam int unsigned             Height            = redmule_pkg::ARRAY_HEIGHT    , // Number of PEs within a row
  localparam int unsigned             Width             = redmule_pkg::ARRAY_WIDTH     , // Number of parallel rows
  localparam int unsigned             NumPipeRegs       = redmule_pkg::PIPE_REGS       , // Number of pipeline registers within each PE
  localparam fpnew_pkg::pipe_config_t PipeConfig        = fpnew_pkg::DISTRIBUTED       ,
  localparam int unsigned             BITW              = fpnew_pkg::fp_width(FpFormat), // Number of bits for the given format

  // parameters used by hci_interconnect and l1_spm
  parameter int unsigned              N_MEM_BANKS_TILE  = 16                           , // Number of memory banks 
  parameter int unsigned              N_WORDS_BANK      = 256                            // Number of words per memory bank      
)(
  input  logic                        clk_i         ,
  input  logic                        rstn_i        ,

  // signals used by redmule_complex
  input  logic                        test_mode_i   ,
  input  logic                        fetch_enable_i,
  input  logic                        tile_enable_i ,
  input  logic  [      AddrWidth-1:0] boot_addr_i   ,
  input  logic  [        NumIrqs-1:0] irq_i         ,  //TODO: Add irq support
  output logic  [$clog2(NumIrqs)-1:0] irq_id_o      ,
  output logic                        irq_ack_o     ,
  output logic                        core_sleep_o     
  //TODO: add tile data in/out
);

/*******************************************************/
/**          Parameter Definitions Beginning          **/
/*******************************************************/

//TODO

/*******************************************************/
/**             Parameter Definitions End             **/
/*******************************************************/
/**             Type Definitions Beginning            **/
/*******************************************************/

//TODO
//TODO: define the core data types
//TODO: define the core inst types
//TODO: define the redmule data types
// core_data_req_t
// core_data_rsp_t
// core_inst_req_t
// core_inst_rsp_t
// redmule_data_req_t
// redmule_data_rsp_t

/*******************************************************/
/**                Type Definitions End               **/
/*******************************************************/
/**        Internal Signal Definitions Beginning      **/
/*******************************************************/

//TODO
//TODO: define the core data signals
//TODO: define the core inst signals
//TODO: define the redmul data signals

  logic                                hci_clear; //TODO: figure out who should clear the hci
  hci_package::hci_interconnect_ctrl_t hci_ctrl;  //TODO: figure out who should control the hci

  logic sys_clk;
  logic sys_clk_en;

/*******************************************************/
/**           Internal Signal Definitions End         **/
/*******************************************************/
/**           Interface Definitions Beginning         **/
/*******************************************************/

//TODO

  hci_mem_intf #(
    .AW ( redmule_tile_pkg::AWM_TILE    ),
    .DW ( redmule_tile_pkg::DW_LIC_TILE ),
    .BW ( redmule_tile_pkg::BW_LIC_TILE ),
    .IW ( /*TODO*/ )
  ) hci_tcdm_sram_if[N_MEM_BANKS_TILE-1:0] (
    .clk ( sys_clk )
  );
  
  hci_core_intf #(
    .DW ( redmule_tile_pkg::DW_LIC_TILE ),
    .AW ( redmule_tile_pkg::AWC_TILE    ),
    .OW ( /*TODO*/ )
  ) hci_core_if[N_CORE_TILE-1:0] (
    .clk( sys_clk )
  );

  hci_core_intf #(
    .DW ( redmule_tile_pkg::DW_LIC_TILE ),
    .AW ( redmule_tile_pkg::AWC_TILE    ),
    .OW ( /*TODO*/ )
  ) hci_redmule_if[N_HWPE_TILE-1:0] (
    .clk( sys_clk )
  );

  //TODO: connect after integrating the DMA
  hci_core_intf #(
    .DW ( redmule_tile_pkg::DW_LIC_TILE ),
    .AW ( redmule_tile_pkg::AWC_TILE    ),
    .OW ( /*TODO*/ )
  ) hci_dma_if[N_DMA_TILE-1:0] (
    .clk( sys_clk )
  );

/*******************************************************/
/**             Interface Definitions End             **/
/*******************************************************/
/**               Clock gating Beginning              **/
/*******************************************************/

  always_ff @ (posedge clk_i, negedge rstn_i) begin: sys_clk_en
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
/**                 RedMulE Beginning                 **/
/*******************************************************/

  //TODO
  redmule_top #(
    .ID_WIDTH           ( ID_WIDTH              ),
    .N_CORES            ( 1                     ),
    .DW                 ( DW                    ),
    .X_EXT              ( XExt                  ),
    .SysInstWidth       ( SysInstWidth          ),
    .SysDataWidth       ( SysDataWidth          ),
    .redmule_data_req_t ( redmule_data_req_t    ),
    .redmule_data_rsp_t ( redmule_data_rsp_t    ),
    .redmule_ctrl_req_t ( redmule_ctrl_req_t    ),
    .redmule_ctrl_rsp_t ( redmule_ctrl_rsp_t    )
  ) i_redmule_top       (
    .clk_i              ( sys_clk                    ),
    .rst_ni             ( rst_ni                     ),
    .test_mode_i        ( test_mode_i                ),
    .evt_o              ( evt                        ),
    .busy_o             ( busy                       ),
    .data_rsp_i         ( redmule_data_rsp_i         ),
    .data_req_o         ( redmule_data_req_o         ),
    .ctrl_req_i         ( '0                         ),
    .ctrl_rsp_o         (                            ),
    .xif_issue_if_i     ( core_xif.coproc_issue      ),
    .xif_result_if_o    ( core_xif.coproc_result     ),
    .xif_compressed_if_i( core_xif.coproc_compressed ),
    .xif_mem_if_o       ( core_xif.coproc_mem        )
  );

  redmule_complex #(
    .CoreType           ( CoreType    ),
    .ID_WIDTH           ( ID_WIDTH    ),  //TODO: WTF is this
    .N_CORES            ( N_CORES     ),  //TODO: WTF is this
    .DW                 ( DW          ),  //TODO: WTF is this
    .MP                 ( MP          ),  //TODO: WTF is this
    .NumIrqs            ( NumIrqs     ),  //TODO: WTF is this
    .AddrWidth          ( AddrWidth   ),  //TODO: WTF is this
    .XPulp              ( XPulp       ),  //TODO: WTF is this
    .FpuPresent         ( FpuPresent  ),  //TODO: WTF is this
    .Zfinx              ( Zfinx       ),  //TODO: WTF is this
    .core_data_req_t    ( /*TODO*/ ),
    .core_data_rsp_t    ( /*TODO*/ ),
    .core_inst_req_t    ( /*TODO*/ ),
    .core_inst_rsp_t    ( /*TODO*/ ),
    .redmule_data_req_t ( /*TODO*/ ),
    .redmule_data_rsp_t ( /*TODO*/ ),
    .FpFormat           ( FpFormat    ),
    .Height             ( Height      ),
    .Width              ( Width       ),
    .NumPipeRegs        ( NumPipeRegs ),
    .PipeConfig         ( PipeConfig  ),
    .BITW               ( BITW        )
  ) i_redmule_complex (
    .clk_i              ( sys_clk ),
    .rst_ni             ( rstn_i  ),
    .test_mode_i                   ,
    .fetch_enable_i                ,
    .boot_addr_i                   ,
    .irq_i                         ,
    .irq_id_o                      ,
    .irq_ack_o                     ,
    .core_sleep_o                  ,
    .core_inst_rsp_i    (         ),
    .core_inst_req_o    (         ),
    .core_data_rsp_i    (         ),
    .core_data_req_o    (         ),
    .redmule_data_rsp_i (         ),
    .redmule_data_req_o (         )
    //TODO: add communication channels with the DMA
  );

/*******************************************************/
/**                    RedMulE End                    **/
/*******************************************************/
/**                   Core Beginning                  **/
/*******************************************************/

//TODO

  cv32e40x_core #(
    .M_EXT       ( cv32e40x_pkg::M ),
    .X_EXT       ( 1               ),
    .X_NUM_RS    ( NumRs           ),
    .X_ID_WIDTH  ( ID_WIDTH        ),
    .X_MEM_WIDTH ( XifMemWidth     ),
    .X_RFR_WIDTH ( XifRFReadWidth  ),
    .X_RFW_WIDTH ( XifRFWriteWidth ),
    .X_MISA      ( XifMisa         ),
    .X_ECS_XS    ( XifEcsXs        )
  ) i_cv32e40x_core       (
    // Clock and Reset
    .clk_i               ( sys_clk                    ),
    .rst_ni              ( rst_ni                     ),
    .scan_cg_en_i        ( 1'b0                       ),  // Enable all clock gates for testing
    // Core ID, Cluster ID, debug mode halt address and boot address are considered more or less static
    .boot_addr_i         ( boot_addr_i                ),
    .dm_exception_addr_i ( '0                         ),
    .dm_halt_addr_i      ( '0                         ),
    .mhartid_i           ( '0                         ),
    .mimpid_patch_i      ( '0                         ),
    .mtvec_addr_i        ( '0                         ),
    // Instruction memory interface
    .instr_req_o         ( core_inst_req_o.req        ),
    .instr_gnt_i         ( core_inst_rsp_i.gnt        ),
    .instr_rvalid_i      ( core_inst_rsp_i.valid      ),
    .instr_addr_o        ( core_inst_req_o.addr       ),
    .instr_memtype_o     (                            ),
    .instr_prot_o        (                            ),
    .instr_dbg_o         (                            ),
    .instr_rdata_i       ( core_inst_rsp_i.data       ),
    .instr_err_i         ( '0                         ),
    // Data memory interface
    .data_req_o          ( core_data_req_o.req        ),
    .data_gnt_i          ( core_data_rsp_i.gnt        ),
    .data_rvalid_i       ( core_data_rsp_i.valid      ),
    .data_addr_o         ( core_data_req_o.addr       ),
    .data_be_o           ( core_data_req_o.be         ),
    .data_we_o           ( core_data_req_o.we         ),
    .data_wdata_o        ( core_data_req_o.data       ),
    .data_memtype_o      (                            ),
    .data_prot_o         (                            ),
    .data_dbg_o          (                            ),
    .data_atop_o         (                            ),
    .data_rdata_i        ( core_data_rsp_i.data       ),
    .data_err_i          ( '0                         ),
    .data_exokay_i       ( '1                         ),
    // Cycle, Time
    .mcycle_o            (                            ),
    .time_i              ( '0                         ),
    // eXtension interface
    .xif_compressed_if   ( core_xif.cpu_compressed    ),
    .xif_issue_if        ( core_xif.cpu_issue         ),
    .xif_commit_if       ( core_xif.cpu_commit        ),
    .xif_mem_if          ( core_xif.cpu_mem           ),
    .xif_mem_result_if   ( core_xif.cpu_mem_result    ),
    .xif_result_if       ( core_xif.cpu_result        ),
    // Basic interrupt architecture
    .irq_i               ( {27'd0 ,evt, 3'd0}         ),
    // Event wakeup signals
    .wu_wfe_i            ( '0                         ), // Wait-for-event wakeup
    // CLIC interrupt architecture
    .clic_irq_i          ( '0                         ),
    .clic_irq_id_i       ( '0                         ),
    .clic_irq_level_i    ( '0                         ),
    .clic_irq_priv_i     ( '0                         ),
    .clic_irq_shv_i      ( '0                         ),
    // Fence.i flush handshake
    .fencei_flush_req_o  (                            ),
    .fencei_flush_ack_i  ( '0                         ),
    // Debug Interface
    .debug_req_i         ( '0                         ),
    .debug_havereset_o   (                            ),
    .debug_running_o     (                            ),
    .debug_halted_o      (                            ),
    .debug_pc_valid_o    (                            ),
    .debug_pc_o          (                            ),
    // CPU Control Signals
    .fetch_enable_i      ( fetch_enable_i             ),
    .core_sleep_o        ( core_sleep_o               )
  );

/*******************************************************/
/**                      Core End                     **/
/*******************************************************/
/**         Local Interconnect (HCI) Beginning        **/
/*******************************************************/

  hci_interconnect #(
    .N_HWPE  ( redmule_tile_pkg::N_HWPE_TILE  ),
    .N_CORE  ( redmule_tile_pkg::N_CORE_TILE  ),
    .N_DMA   ( redmule_tile_pkg::N_DMA_TILE   ),
    .N_EXT   ( redmule_tile_pkg::N_EXT_TILE   ),
    .N_MEM   ( N_MEM_BANKS_TILE               ),
    .AWC     ( redmule_tile_pkg::AWC_TILE     ),
    .AWM     ( redmule_tile_pkg::AWM_TILE     ),
    .DW_LIC  ( redmule_tile_pkg::DW_LIC_TILE  ),
    .BW_LIC  ( redmule_tile_pkg::BW_LIC_TILE  ),
    .UW_LIC  ( redmule_tile_pkg::UW_LIC_TILE  ),
    .DW_SIC  (                                ),
    .TS_BIT  ( redmule_tile_pkg::TS_BIT_TILE  ),
    .IW      ( redmule_tile_pkg::IW_TILE      ),
    .EXPFIFO ( redmule_tile_pkg::EXPFIFO_TILE ),
    .DWH     ( redmule_tile_pkg::DWH_TILE     ),
    .AWH     ( redmule_tile_pkg::AWH_TILE     ),
    .BWH     ( redmule_tile_pkg::BWH_TILE     ),
    .WWH     ( redmule_tile_pkg::WWH_TILE     ),
    .OWH     ( redmule_tile_pkg::OWH_TILE     ),
    .UWH     ( redmule_tile_pkg::UWH_TILE     ),
    .SEL_LIC ( redmule_tile_pkg::SEL_LIC_TILE )
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
    .N_BANK   ( N_MEM_BANKS_TILE              ),
    .N_WORDS  ( N_WORDS_BANK                  ),
    .DATA_W   ( redmule_tile_pkg::DW_LIC_TILE ),
    .ID_W     ( /*TODO*/                      ),
    .SIM_INIT ( "ones"                        )
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
/**        Core - DMA IO Data Muxing Beginning        **/
/*******************************************************/

//TODO

/*******************************************************/
/**           Core - DMA IO Data Muxing End           **/
/*******************************************************/

endmodule: redemule_tile