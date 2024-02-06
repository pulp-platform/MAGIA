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
  parameter  redmule_pkg::core_type_e CoreType    = redmule_pkg::CV32X           , // CV32E40P, IBEX, SNITCH, CVA6
  parameter  int unsigned             ID_WIDTH    = 8                            ,
  parameter  int unsigned             N_CORES     = 8                            ,
  parameter  int unsigned             DW          = redmule_pkg::DATA_W          , // TCDM port dimension (in bits)
  parameter  int unsigned             MP          = DW/redmule_pkg::MemDw        ,
  parameter  int unsigned             NumIrqs     = 32                           ,
  parameter  int unsigned             AddrWidth   = 32                           ,
  parameter  int unsigned             XPulp       = 0                            ,
  parameter  int unsigned             FpuPresent  = 0                            ,
  parameter  int unsigned             Zfinx       = 0                            ,
  localparam fpnew_pkg::fp_format_e   FpFormat    = redmule_pkg::FPFORMAT        , // Data format (default is FP16)
  localparam int unsigned             Height      = redmule_pkg::ARRAY_HEIGHT    , // Number of PEs within a row
  localparam int unsigned             Width       = redmule_pkg::ARRAY_WIDTH     , // Number of parallel rows
  localparam int unsigned             NumPipeRegs = redmule_pkg::PIPE_REGS       , // Number of pipeline registers within each PE
  localparam fpnew_pkg::pipe_config_t PipeConfig  = fpnew_pkg::DISTRIBUTED       ,
  localparam int unsigned             BITW        = fpnew_pkg::fp_width(FpFormat), // Number of bits for the given format

  // parameters used by hci_interconnect
  parameter int unsigned              N_MEM_TILE  = 16                           , // Number of memory banks 
  parameter int unsigned              N_WORDS     = 256                            // Number of words per memory bank      
)(
  input  logic                        clk_i         ,
  input  logic                        rstn_i        ,

  // signals used by redmule_complex
  input  logic                        test_mode_i   ,
  input  logic                        fetch_enable_i,
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
//TODO: maybe later add these parameters into a package?

// parameters used by the HCI
  parameter int unsigned N_HWPE_TILE  = 1;                                                   // Number of HWPEs attached to the port
  parameter int unsigned N_CORE_TILE  = 1;                                                   // Number of Core ports
  parameter int unsigned N_DMA_TILE   = 0;                                                   // Number of DMA ports /*TODO: add DMA and update interconnect parameter*/
  parameter int unsigned N_EXT_TILE   = 0;                                                   // Number of External ports /*TODO: can this be 0? Will it not cause problems? Is the HCI Interconnect robust?*/
  parameter int unsigned AWC_TILE     = 32;                                                  // Address Width Core   (slave ports)
  parameter int unsigned AWM_TILE     = 32;                                                  // Address width memory (master ports)
  parameter int unsigned DW_LIC_TILE  = 32;                                                  // Data Width for Log Interconnect
  parameter int unsigned BW_LIC_TILE  = 8;                                                   // Byte Width for Log Interconnect
  parameter int unsigned UW_LIC_TILE  = 0;                                                   // User Width for Log Interconnect
  parameter int unsigned TS_BIT_TILE  = 21;                                                  // TEST_SET_BIT (for Log Interconnect)
  parameter int unsigned IW_TILE      = N_HWPE_TILE + N_CORE_TILE + N_DMA_TILE + N_EXT_TILE; // ID Width
  parameter int unsigned EXPFIFO_TILE = 0;                                                   // FIFO Depth for HWPE Interconnect
  parameter int unsigned DWH_TILE     = 32;                                                  // Data Width for HWPE Interconnect
  parameter int unsigned AWH_TILE     = 32;                                                  // Address Width for HWPE Interconnect
  parameter int unsigned BWH_TILE     = 8;                                                   // Byte Width for HWPE Interconnect
  parameter int unsigned WWH_TILE     = 32;                                                  // Word Width for HWPE Interconnect
  parameter int unsigned OWH_TILE     = AWH_TILE;                                            // Offset Width for HWPE Interconnect
  parameter int unsigned UWH_TILE     = 0;                                                   // User Width for HWPE Interconnect
  parameter int unsigned SEL_LIC_TILE = 0;                                                   // Log interconnect type selector

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

/*******************************************************/
/**           Internal Signal Definitions End         **/
/*******************************************************/
/**           Interface Definitions Beginning         **/
/*******************************************************/

//TODO

  hci_mem_intf #(
    .AW ( /*TODO*/ ),
    .DW ( /*TODO*/ ),
    .BW ( /*TODO*/ ),
    .IW ( /*TODO*/ )
  ) tcdm_bus_sram[N_MEM_TILE-1:0] (
    .clk ( clk_i )
  );
  
  hci_core_intf #(
    .DW ( /*TODO*/ ),
    .AW ( /*TODO*/ ),
    .OW ( /*TODO*/ )
  ) hci_core_if[N_CORE_TILE-1:0] (
    .clk( clk_i )
  );

  hci_core_intf #(
    .DW ( /*TODO*/ ),
    .AW ( /*TODO*/ ),
    .OW ( /*TODO*/ )
  ) hci_redmule_if[N_HWPE_TILE-1:0] (
    .clk( clk_i )
  );

  //TODO: connect after integrating the DMA
  hci_core_intf #(
    .DW ( /*TODO*/ ),
    .AW ( /*TODO*/ ),
    .OW ( /*TODO*/ )
  ) hci_dma_if[N_DMA_TILE-1:0] (
    .clk( clk_i )
  );

/*******************************************************/
/**             Interface Definitions End             **/
/*******************************************************/
/**             RedMulE Complex Beginning             **/
/*******************************************************/

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
    .clk_i                        ,
    .rst_ni             ( rstn_i ),
    .test_mode_i                  ,
    .fetch_enable_i               ,
    .boot_addr_i                  ,
    .irq_i                        ,
    .irq_id_o                     ,
    .irq_ack_o                    ,
    .core_sleep_o                 ,
    .core_inst_rsp_i    (        ),
    .core_inst_req_o    (        ),
    .core_data_rsp_i    (        ),
    .core_data_req_o    (        ),
    .redmule_data_rsp_i (        ),
    .redmule_data_req_o (        )
    //TODO: add communication channels with the DMA
  );

/*******************************************************/
/**                RedMulE Complex End                **/
/*******************************************************/
/**         Local Interconnect (HCI) Beginning        **/
/*******************************************************/

  hci_interconnect #(
    .N_HWPE  ( N_HWPE_TILE  ),
    .N_CORE  ( N_CORE_TILE  ),
    .N_DMA   ( N_DMA_TILE   ),
    .N_EXT   ( N_EXT_TILE   ),
    .N_MEM   ( N_MEM_TILE   ),
    .AWC     ( AWC_TILE     ),
    .AWM     ( AWM_TILE     ),
    .DW_LIC  ( DW_LIC_TILE  ),
    .BW_LIC  ( BW_LIC_TILE  ),
    .UW_LIC  ( UW_LIC_TILE  ),
    .DW_SIC  (              ),
    .TS_BIT  ( TS_BIT_TILE  ),
    .IW      ( IW_TILE      ),
    .EXPFIFO ( EXPFIFO_TILE ),
    .DWH     ( DWH_TILE     ),
    .AWH     ( AWH_TILE     ),
    .BWH     ( BWH_TILE     ),
    .WWH     ( WWH_TILE     ),
    .OWH     ( OWH_TILE     ),
    .UWH     ( UWH_TILE     ),
    .SEL_LIC ( SEL_LIC_TILE )
  ) i_local_interconnect (
    .clk_i                     ,
    .rst_ni  ( rstn_i         ),
    .clear_i ( hci_clear      ),
    .ctrl_i  ( hci_ctrl       ),
    .cores   ( hci_core_if    ),
    .dma     ( hci_dma_if     ),
    .ext     (                ),
    .mems    ( tcdm_bus_sram  ),
    .hwpe    ( hci_redmule_if )
  );

/*******************************************************/
/**            Local Interconnect (HCI) End           **/
/*******************************************************/
/**              L1 SPM (TCDM) Beginning              **/
/*******************************************************/

  l1_mem_wrap #(
    .N_BANK   ( N_MEM_TILE ),
    .N_WORDS  ( N_WORDS ),
    .DATA_W   ( /*TODO*/ ),
    .ID_W     ( /*TODO*/ ),
    .SIM_INIT ( "ones" )
  ) i_l1_spm (
    .clk_i      ( clk_i         ),
    .rstn_i     ( rstn_i        ),
    .tcdm_slave ( tcdm_bus_sram )
  );

/*******************************************************/
/**                 L1 SPM (TCDM) End                 **/
/*******************************************************/
/**                   DMA Beginning                   **/
/*******************************************************/

//TODO

/*******************************************************/
/**                      DMA End                      **/
/*******************************************************/
/**        Core - DMA IO Data Muxing Beginning        **/
/*******************************************************/

//TODO

/*******************************************************/
/**           Core - DMA IO Data Muxing End           **/
/*******************************************************/

endmodule: redemule_tile