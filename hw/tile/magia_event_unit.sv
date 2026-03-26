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
 * Authors: Luca Balboni <luca.balboni10@studio.unibo.it>
 *          
 * Wrapper module for MAGIA Event Unit optimized for single-core systems
*/

module magia_event_unit
import magia_tile_pkg::*;
#(
  // MAGIA Event Unit Parameters - Optimized for single-core system
  parameter int unsigned NB_CORES = 1,              // Single core system
  parameter int unsigned NB_SW_EVT = 1,             // Minimal SW events for basic functionality
  parameter int unsigned NB_BARR  = 2,              // Minimum 2 barriers (workaround: $clog2(1)=0 causes issues)
  parameter int unsigned NB_HW_MUT = 2,             // Minimum 2 mutexes (workaround: $clog2(1)=0 causes issues)
  parameter int unsigned MUTEX_MSG_W = 32,          // Mutex message width (unused but kept for compatibility)
  parameter int unsigned DISP_FIFO_DEPTH = 1,       // Minimal dispatcher FIFO (workaround for synthesis)
  parameter int unsigned EVNT_WIDTH = 8,            // SOC event width (external events)
  parameter int unsigned SOC_FIFO_DEPTH = 8         // SOC event FIFO depth (external events)
)
(
  // clock and reset
  input  logic  clk_i,
  input  logic  rst_ni,
  input  logic  test_mode_i,

  // Event inputs (from accelerators, DMA, etc.)
  input  logic [NB_CORES-1:0] [3:0] acc_events_i,
  input  logic [NB_CORES-1:0] [1:0] dma_events_i,
  input  logic [NB_CORES-1:0] [1:0] timer_events_i,
  input  logic [NB_CORES-1:0][31:0] other_events_i,

  // Core IRQ interface (both directions needed for proper operation)
  output logic [NB_CORES-1:0]       core_irq_req_o,
  output logic [NB_CORES-1:0] [4:0] core_irq_id_o,
  input  logic [NB_CORES-1:0]       core_irq_ack_i,
  input  logic [NB_CORES-1:0] [4:0] core_irq_ack_id_i,

  // Core control interface
  input  logic [NB_CORES-1:0]       core_busy_i,
  output logic [NB_CORES-1:0]       core_clock_en_o,

  // Debug interface (bidirectional)
  input  logic [NB_CORES-1:0]       dbg_req_i,
  output logic [NB_CORES-1:0]       core_dbg_req_o,

  // EU Direct Link interface 
  input  logic                      eu_direct_req_i,
  input  logic [31:0]               eu_direct_addr_i,
  input  logic                      eu_direct_wen_i,
  input  logic [31:0]               eu_direct_wdata_i,
  input  logic [3:0]                eu_direct_be_i,
  output logic                      eu_direct_gnt_o,
  output logic                      eu_direct_rvalid_o,
  output logic [31:0]               eu_direct_rdata_o,
  output logic                      eu_direct_err_o,

   // OBI slave connection
  input  core_obi_data_req_t        obi_req_i,
  output core_obi_data_rsp_t        obi_rsp_o
);

  // Create internal interface instances
  XBAR_PERIPH_BUS #(.ID_WIDTH(NB_CORES+1)) eu_direct_link[NB_CORES-1:0]();
  XBAR_PERIPH_BUS #(.ID_WIDTH(NB_CORES+1)) speriph_slave();

  // Internal signals
  logic soc_periph_evt_ready_internal;
  
  // Convert abstract eu_direct interface to XBAR_PERIPH_BUS
  // eu_direct_addr_i already contains relative offset (subtracted by demux)
  assign eu_direct_link[0].req   = eu_direct_req_i;
  assign eu_direct_link[0].add   = eu_direct_addr_i;
  assign eu_direct_link[0].wen   = eu_direct_wen_i;
  assign eu_direct_link[0].wdata = eu_direct_wdata_i;
  assign eu_direct_link[0].be    = eu_direct_be_i;
  assign eu_direct_link[0].id    = '0;

  // Convert XBAR_PERIPH_BUS response to abstract interface
  // Event Unit handles all power management and grant logic internally
  assign eu_direct_gnt_o    = eu_direct_link[0].gnt;
  assign eu_direct_rvalid_o = eu_direct_link[0].r_valid;
  assign eu_direct_rdata_o  = eu_direct_link[0].r_rdata;
  assign eu_direct_err_o    = eu_direct_link[0].r_opc;  // r_opc: 0=OK, 1=ERROR

  // Address range check and offset calculation
  localparam logic [magia_pkg::ADDR_W-1:0] EU_BASE_ADDR = magia_tile_pkg::EVENT_UNIT_ADDR_START;
  logic addr_in_range;
  logic [magia_pkg::ADDR_W-1:0] addr_offset;
  
  assign addr_in_range = (obi_req_i.a.addr >= magia_tile_pkg::EVENT_UNIT_ADDR_START) && 
                         (obi_req_i.a.addr <= magia_tile_pkg::EVENT_UNIT_ADDR_END);
  assign addr_offset   = obi_req_i.a.addr - EU_BASE_ADDR;
  
  // OBI to XBAR_PERIPH_BUS conversion - pass RELATIVE address (offset from base)
  assign speriph_slave.req   = obi_req_i.req && addr_in_range;
  assign speriph_slave.add   = addr_offset;           
  assign speriph_slave.wen   = ~obi_req_i.a.we;       
  assign speriph_slave.wdata = obi_req_i.a.wdata;
  assign speriph_slave.be    = obi_req_i.a.be;
  assign speriph_slave.id    = '0;                   

  // Direct response mapping - no mux needed
  assign obi_rsp_o.gnt         = speriph_slave.gnt;
  assign obi_rsp_o.rvalid      = speriph_slave.r_valid;
  assign obi_rsp_o.r.rdata     = speriph_slave.r_rdata;
  assign obi_rsp_o.r.err       = speriph_slave.r_opc;  // r_opc: 0=OK, 1=ERROR
  

  // Event Unit Flex instantiation
  event_unit_top #(
    .NB_CORES         ( NB_CORES         ),
    .NB_SW_EVT        ( NB_SW_EVT        ),
    .NB_BARR          ( NB_BARR          ),
    .NB_HW_MUT        ( NB_HW_MUT        ),
    .MUTEX_MSG_W      ( MUTEX_MSG_W      ),
    .DISP_FIFO_DEPTH  ( DISP_FIFO_DEPTH  ),
    .PER_ID_WIDTH     ( NB_CORES+1       ),
    .EVNT_WIDTH       ( EVNT_WIDTH       ),
    .SOC_FIFO_DEPTH   ( SOC_FIFO_DEPTH   )
  ) i_event_unit_top (
    .clk_i                    ( clk_i                         ),
    .rst_ni                   ( rst_ni                        ),
    .test_mode_i              ( test_mode_i                   ),
    .acc_events_i             ( acc_events_i                  ),
    .dma_events_i             ( dma_events_i                  ),
    .timer_events_i           ( timer_events_i                ),
    .cluster_events_i         ( other_events_i                ),
    .core_irq_req_o           ( core_irq_req_o                ),
    .core_irq_id_o            ( core_irq_id_o                 ),
    .core_irq_ack_i           ( core_irq_ack_i                ),
    .core_irq_ack_id_i        ( core_irq_ack_id_i             ),
    .core_busy_i              ( core_busy_i                   ),
    .core_clock_en_o          ( core_clock_en_o               ),
    .dbg_req_i                ( dbg_req_i                     ),
    .core_dbg_req_o           ( core_dbg_req_o                ),
    .soc_periph_evt_valid_i   ( 1'b0                          ),
    .soc_periph_evt_ready_o   ( soc_periph_evt_ready_internal ),
    .soc_periph_evt_data_i    ( '0                            ),
    .speriph_slave            ( speriph_slave                 ),
    .eu_direct_link           ( eu_direct_link                )
  );
 
endmodule: magia_event_unit