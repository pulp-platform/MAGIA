/*
 * Copyright (C) 2026 ETH Zurich, University of Bologna and Fondazione Chips-IT
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
 * Authors: Niccolò Giuliani <niccolo.giuliani44@gmail.com>
 *          Luca Balboni <luca.balboni@chips.it>
 *
 * MAGIA PULP Cluster Wrapper
 *
 */

module magia_cluster_wrap
  import magia_tile_pkg::*;
  import magia_pkg::*;
#(
  parameter magia_tile_pkg::magia_tile_cfg_t TileCfg       = magia_tile_pkg::MagiaTileDefaultCfg,
  parameter int unsigned                     NClusterCores = TileCfg.Cluster.NumCores,

  // HCI types are supplied by magia_tile
  parameter type                             hci_req_t     = magia_tile_pkg::core_hci_data_req_t,
  parameter type                             hci_rsp_t     = magia_tile_pkg::core_hci_data_rsp_t
)(
  input  logic clk_i,
  input  logic rst_ni,
  input  logic test_mode_i,

  // Tile hart-id base (control core is 0; cluster cores start after the tiles' ctrl cores)
  input  logic [31:0] mhartid_i,

  // This tile's L1 (TCDM) address window: cluster data accesses in this range
  // take the dedicated HCI port, everything else goes to the OBI crossbar.
  input  logic [magia_pkg::ADDR_W-1:0] tile_l1_start_addr_i,
  input  logic [magia_pkg::ADDR_W-1:0] tile_l1_end_addr_i,

  // Control outputs from the cluster CSR (in magia_tile).
  input  logic [31:0]              cluster_boot_addr_i    [NClusterCores-1:0],
  input  logic [NClusterCores-1:0] cluster_fetch_enable_i,
  input  logic                     cluster_start_irq_i,     // 1-cycle pulse injected into cluster Event Unit as EU_OTHER_CLUSTER_START

  // Memory-mapped (speriph) port of the cluster-private Event Unit, on the tile OBI xbar
  input  magia_tile_pkg::core_obi_data_req_t cluster_eu_obi_req_i,
  output magia_tile_pkg::core_obi_data_rsp_t cluster_eu_obi_rsp_o,

  // Per-core OBI data manager ports (peripheral path -> tile OBI crossbar)
  output magia_tile_pkg::core_obi_data_req_t [NClusterCores-1:0] cluster_obi_data_req_o,
  input  magia_tile_pkg::core_obi_data_rsp_t [NClusterCores-1:0] cluster_obi_data_rsp_i,

  // Per-core HCI data manager ports (L1/TCDM path -> tile HCI interconnect)
  output hci_req_t [NClusterCores-1:0] cluster_hci_data_req_o,
  input  hci_rsp_t [NClusterCores-1:0] cluster_hci_data_rsp_i,

  // Per-core instruction fetch ports (-> tile-level shared cluster i$)
  output magia_tile_pkg::core_instr_req_t [NClusterCores-1:0] cluster_instr_req_o,
  input  magia_tile_pkg::core_instr_rsp_t [NClusterCores-1:0] cluster_instr_rsp_i
);

  // Data-demux slave map: [0] = TCDM (L1) fast path, [1] = OBI (peripherals / default), [2] = cluster Event Unit demux window
  localparam int unsigned CLUSTER_DATA_DEMUX_N_SLV    = 3;
  localparam int unsigned CLUSTER_DATA_DEMUX_TCDM_IDX = 0;
  localparam int unsigned CLUSTER_DATA_DEMUX_OBI_IDX  = 1;
  localparam int unsigned CLUSTER_DATA_DEMUX_EU_IDX   = 2;

  // -------------------------------------------------------------------------
  // Per-core sleep status, data/instruction interfaces and interrupt signals
  // -------------------------------------------------------------------------
  logic [NClusterCores-1:0] cluster_core_sleep;

  // Cluster core data interface (CV32E40P native channel type).
  magia_tile_pkg::cv32e40p_core_data_req_t [NClusterCores-1:0] cluster_data_req;
  magia_tile_pkg::cv32e40p_core_data_rsp_t [NClusterCores-1:0] cluster_data_rsp;

  // Per-core demux downstream ports ([i][TCDM], [i][OBI]).
  magia_tile_pkg::cv32e40p_core_data_req_t [NClusterCores-1:0][CLUSTER_DATA_DEMUX_N_SLV-1:0] cluster_data_demux_req;
  magia_tile_pkg::cv32e40p_core_data_rsp_t [NClusterCores-1:0][CLUSTER_DATA_DEMUX_N_SLV-1:0] cluster_data_demux_rsp;

  // Per-core 32-bit interrupt vector
  logic [NClusterCores-1:0][31:0]                                  cluster_irq_vec;

  // Event Unit <-> core IRQ
  logic [NClusterCores-1:0]                                        cluster_eu_irq_req;
  logic [NClusterCores-1:0][magia_tile_pkg::EVENT_UNIT_IRQ_WIDTH-1:0] cluster_eu_irq_id;
  logic [NClusterCores-1:0]                                        cluster_eu_clock_en;

  // Per-core Event Unit direct link
  logic [NClusterCores-1:0]       cluster_eu_direct_req;
  logic [NClusterCores-1:0][31:0] cluster_eu_direct_addr;
  logic [NClusterCores-1:0]       cluster_eu_direct_wen;
  logic [NClusterCores-1:0][31:0] cluster_eu_direct_wdata;
  logic [NClusterCores-1:0][3:0]  cluster_eu_direct_be;
  logic [NClusterCores-1:0]       cluster_eu_direct_gnt;
  logic [NClusterCores-1:0]       cluster_eu_direct_rvalid;
  logic [NClusterCores-1:0][31:0] cluster_eu_direct_rdata;
  logic [NClusterCores-1:0]       cluster_eu_direct_err;

  //The cluster Event Unit is private: from outside it sees only the per-core dispatch pulse from the cluster CSR
  logic [NClusterCores-1:0][31:0] cluster_eu_other_events;

  // Per-core IRQ vector. Every Event Unit cause is OR'd onto the single Machine External Interrupt line (bit 11)
  // Software disambiguates by reading the EU's own status (EU_CORE_BUFFER_IRQ_MASKED) after taking the trap
  for (genvar k = 0; k < NClusterCores; k++) begin : gen_cluster_irq_vec
    always_comb begin
      cluster_irq_vec[k] = '0;
      if (cluster_eu_irq_req[k]) cluster_irq_vec[k][11] = 1'b1;
    end
  end

  // ---------------------------------------------------------------------------
  // Cluster cores (always CV32E40P)
  // ---------------------------------------------------------------------------
  for (genvar i = 0; i < NClusterCores; i++) begin : CORE
    `ifndef CORE_TRACES
      cv32e40p_top #(
    `else
      cv32e40p_wrapper #(
    `endif
        .COREV_PULP          ( 1                                   ),
        .COREV_CLUSTER       ( 1                                   ),
        .FPU                 ( FPU                                 ),
        .ZFINX               ( magia_tile_pkg::ZFINX_CLUSTER       ),
        .FPU_ADDMUL_LAT      ( 1                                   ), // Match C_LAT_FP32=1 in fpnew wrapper
        .FPU_OTHERS_LAT      ( 1                                   ), // Match C_LAT_NONCOMP=1 in fpnew wrapper
        .NUM_MHPMCOUNTERS    ( 29                                  )
      ) i_cv32e40p_core (
        // Clock and Reset
        .clk_i                  ( clk_i                 ),  // Gated cluster clock
        .rst_ni                 ( rst_ni                ),
        .pulp_clock_en_i        ( cluster_eu_clock_en[i]      ),
        .scan_cg_en_i           ( test_mode_i                 ),
        .boot_addr_i            ( cluster_boot_addr_i[i]      ),  // From cluster CSR, dynamic per tile
        .mtvec_addr_i           ( cluster_boot_addr_i[i]      ),  // mtvec defaults to boot vector; SW can override via csrw
        .dm_halt_addr_i         ( magia_tile_pkg::DM_HALT_ADDR),
        .hart_id_i              ( 2 * magia_pkg::N_TILES + mhartid_i * NClusterCores + i ),
        .dm_exception_addr_i    ( magia_tile_pkg::DM_HALT_ADDR + 16'h000C), //to be checked
        // Instruction interface (-> tile-level shared cluster i$)
        .instr_req_o            ( cluster_instr_req_o[i].req         ),
        .instr_addr_o           ( cluster_instr_req_o[i].addr        ),
        .instr_gnt_i            ( cluster_instr_rsp_i[i].gnt         ),
        .instr_rvalid_i         ( cluster_instr_rsp_i[i].rvalid      ),
        .instr_rdata_i          ( cluster_instr_rsp_i[i].rdata       ),
        // Data interface (goes through the per-core data demux below)
        .data_req_o             ( cluster_data_req[i].req              ),
        .data_addr_o            ( cluster_data_req[i].addr             ),
        .data_be_o              ( cluster_data_req[i].be               ),
        .data_wdata_o           ( cluster_data_req[i].wdata            ),
        .data_we_o              ( cluster_data_req[i].we               ),
        .data_gnt_i             ( cluster_data_rsp[i].gnt              ),
        .data_rvalid_i          ( cluster_data_rsp[i].rvalid           ),
        .data_rdata_i           ( cluster_data_rsp[i].rdata            ),
        // Interrupts: Event Unit cause OR'd onto MEI (bit 11), software disambiguates by reading the EU's own status (EU_CORE_BUFFER_IRQ_MASKED) after taking the trap
        .irq_i                  ( cluster_irq_vec[i]                  ),
        .irq_ack_o              (                                     ),
        .irq_id_o               (                                     ),
    
        .debug_req_i            ( 1'b0                                ),
        // Debug status outputs unused: no tile-level output exposes per-cluster-core debug status.
        .debug_havereset_o      (                                     ),
        .debug_running_o        (                                     ),
        .debug_halted_o         (                                     ),
        // CPU control
        .fetch_enable_i         ( cluster_fetch_enable_i[i]           ),
        .core_sleep_o           ( cluster_core_sleep[i]               )
      );
  end

  // -------------------------------------------------------------------------------------------------------------------------------
  // Per-core data demux: L1/TCDM window -> dedicated HCI port, EU demux window -> per-core Event Unit direct link, rest -> OBI xbar
  // -------------------------------------------------------------------------------------------------------------------------------
  for (genvar i = 0; i < NClusterCores; i++) begin : gen_cluster_data_demux

    logic [magia_pkg::ADDR_W-1:0] cluster_data_demux_start_addr [CLUSTER_DATA_DEMUX_N_SLV-1:0];
    logic [magia_pkg::ADDR_W-1:0] cluster_data_demux_end_addr   [CLUSTER_DATA_DEMUX_N_SLV-1:0];

    assign cluster_data_demux_start_addr[CLUSTER_DATA_DEMUX_TCDM_IDX] = tile_l1_start_addr_i;
    assign cluster_data_demux_end_addr  [CLUSTER_DATA_DEMUX_TCDM_IDX] = tile_l1_end_addr_i;
    assign cluster_data_demux_start_addr[CLUSTER_DATA_DEMUX_OBI_IDX]  = '0; // unused (default slave)
    assign cluster_data_demux_end_addr  [CLUSTER_DATA_DEMUX_OBI_IDX]  = '0; // unused (default slave)
    assign cluster_data_demux_start_addr[CLUSTER_DATA_DEMUX_EU_IDX]   = magia_tile_pkg::CLUSTER_EU_DIRECT_START;
    assign cluster_data_demux_end_addr  [CLUSTER_DATA_DEMUX_EU_IDX]   = magia_tile_pkg::CLUSTER_EU_DIRECT_END - 1;

    core_data_demux #(
      .NumSlv     ( CLUSTER_DATA_DEMUX_N_SLV                       ),
      .DefaultSlv ( CLUSTER_DATA_DEMUX_OBI_IDX                     ),
      .req_t      ( magia_tile_pkg::cv32e40p_core_data_req_t ),
      .rsp_t      ( magia_tile_pkg::cv32e40p_core_data_rsp_t )
    ) i_cluster_data_demux (
      .clk_i            ( clk_i                     ),
      .rst_ni           ( rst_ni                    ),
      .core_data_req_i  ( cluster_data_req[i]       ),
      .core_data_rsp_o  ( cluster_data_rsp[i]       ),
      .slv_start_addr_i ( cluster_data_demux_start_addr ),
      .slv_end_addr_i   ( cluster_data_demux_end_addr   ),
      .slv_data_req_o   ( cluster_data_demux_req[i]     ),
      .slv_data_rsp_i   ( cluster_data_demux_rsp[i]     )
    );
  end

  // ---------------------------------------------------------------------------
  // Per-core converters:
  //   OBI (peripheral) path: demux OBI port -> OBI xbar manager port
  //   TCDM (L1) path:        demux TCDM port -> OBI -> HCI interconnect port
  // ---------------------------------------------------------------------------
  for (genvar i = 0; i < NClusterCores; i++) begin : gen_cluster_data_obi

    // --- OBI (peripheral) path ---
    cv32e40p_data2obi_req i_cluster_data2obi (
      .data_req_i ( cluster_data_demux_req[i][CLUSTER_DATA_DEMUX_OBI_IDX] ),
      .obi_req_o  ( cluster_obi_data_req_o[i]                   )
    );

    cv32e40p_obi2data_rsp i_cluster_obi2data (
      .obi_rsp_i  ( cluster_obi_data_rsp_i[i]                   ),
      .data_rsp_o ( cluster_data_demux_rsp[i][CLUSTER_DATA_DEMUX_OBI_IDX] )
    );

    // --- TCDM (L1) path: native mem -> OBI -> HCI dedicated interconnect port ---
    magia_tile_pkg::core_obi_data_req_t cluster_tcdm_obi_req;
    magia_tile_pkg::core_obi_data_rsp_t cluster_tcdm_obi_rsp;

    cv32e40p_data2obi_req i_cluster_tcdm_data2obi (
      .data_req_i ( cluster_data_demux_req[i][CLUSTER_DATA_DEMUX_TCDM_IDX] ),
      .obi_req_o  ( cluster_tcdm_obi_req                         )
    );

    cv32e40p_obi2data_rsp i_cluster_tcdm_obi2data (
      .obi_rsp_i  ( cluster_tcdm_obi_rsp                         ),
      .data_rsp_o ( cluster_data_demux_rsp[i][CLUSTER_DATA_DEMUX_TCDM_IDX] )
    );

    obi2hci_req #(
      .obi_req_t ( magia_tile_pkg::core_obi_data_req_t ),
      .hci_req_t ( hci_req_t )
    ) i_cluster_tcdm_obi2hci_req (
      .obi_req_i ( cluster_tcdm_obi_req      ),
      .hci_req_o ( cluster_hci_data_req_o[i] )
    );

    hci2obi_rsp #(
      .hci_rsp_t ( hci_rsp_t ),
      .obi_rsp_t ( magia_tile_pkg::core_obi_data_rsp_t )
    ) i_cluster_tcdm_hci2obi_rsp (
      .hci_rsp_i ( cluster_hci_data_rsp_i[i] ),
      .obi_rsp_o ( cluster_tcdm_obi_rsp      )
    );
  end

  // ---------------------------------------------------------------------------
  // Cluster-private Event Unit
  // ---------------------------------------------------------------------------

  // Demux EU port (native core channel) -> EU direct link signals. The EU decodes
  // offsets relative to its demux window, so the base address is subtracted here.
  for (genvar i = 0; i < NClusterCores; i++) begin : gen_cluster_eu_direct
    assign cluster_eu_direct_req[i]   = cluster_data_demux_req[i][CLUSTER_DATA_DEMUX_EU_IDX].req;
    assign cluster_eu_direct_addr[i]  = cluster_data_demux_req[i][CLUSTER_DATA_DEMUX_EU_IDX].addr - magia_tile_pkg::CLUSTER_EU_DIRECT_START;
    assign cluster_eu_direct_wen[i]   = ~cluster_data_demux_req[i][CLUSTER_DATA_DEMUX_EU_IDX].we;
    assign cluster_eu_direct_wdata[i] = cluster_data_demux_req[i][CLUSTER_DATA_DEMUX_EU_IDX].wdata;
    assign cluster_eu_direct_be[i]    = cluster_data_demux_req[i][CLUSTER_DATA_DEMUX_EU_IDX].be;

    assign cluster_data_demux_rsp[i][CLUSTER_DATA_DEMUX_EU_IDX].gnt    = cluster_eu_direct_gnt[i];
    assign cluster_data_demux_rsp[i][CLUSTER_DATA_DEMUX_EU_IDX].rvalid = cluster_eu_direct_rvalid[i];
    assign cluster_data_demux_rsp[i][CLUSTER_DATA_DEMUX_EU_IDX].rdata  = cluster_eu_direct_rdata[i];
    assign cluster_data_demux_rsp[i][CLUSTER_DATA_DEMUX_EU_IDX].err    = cluster_eu_direct_err[i];

    // Only event source wired from outside the cluster: the control-core pulse, which reaches core 0 only
    always_comb begin
      cluster_eu_other_events[i] = '0;
      if (i == 0) begin
        cluster_eu_other_events[i][magia_tile_pkg::EU_OTHER_CLUSTER_START] = cluster_start_irq_i;
      end
    end
  end

  magia_event_unit #(
    .NB_CORES        ( NClusterCores                                ),
    .NB_SW_EVT       ( magia_tile_pkg::CLUSTER_EU_NB_SW_EVT         ),
    .NB_BARR         ( NClusterCores                                ),  // as in pulp_cluster
    .NB_HW_MUT       ( magia_tile_pkg::CLUSTER_EU_NB_HW_MUT         ),
    .MUTEX_MSG_W     ( magia_tile_pkg::CLUSTER_EU_MUTEX_MSG_W       ),
    .DISP_FIFO_DEPTH ( magia_tile_pkg::CLUSTER_EU_DISP_FIFO_DEPTH   ),
    .EVNT_WIDTH      ( magia_tile_pkg::CLUSTER_EU_EVNT_WIDTH        ),
    .SOC_FIFO_DEPTH  ( magia_tile_pkg::CLUSTER_EU_SOC_FIFO_DEPTH    ),
    .EU_ADDR_START   ( magia_tile_pkg::CLUSTER_EU_ADDR_START        ),
    .EU_ADDR_END     ( magia_tile_pkg::CLUSTER_EU_ADDR_END          )
  ) i_cluster_event_unit (
    // Same gated clock as the cores: the Event Unit is part of the cluster block
    .clk_i                  ( clk_i                    ),
    .rst_ni                 ( rst_ni                   ),
    .test_mode_i            ( test_mode_i              ),

    // No tile accelerator / DMA / timer event reaches the cluster Event Unit
    .acc_events_i           ( '0                       ),
    .dma_events_i           ( '0                       ),
    .timer_events_i         ( '0                       ),
    .other_events_i         ( cluster_eu_other_events  ),

    // core_irq_ack_i tied to 0, same as the control core: each core's ack
    // always reports id 11, so honoring it would blindly clear the wrong cause.
    .core_irq_req_o         ( cluster_eu_irq_req       ),
    .core_irq_id_o          ( cluster_eu_irq_id        ),
    .core_irq_ack_i         ( '0                       ),
    .core_irq_ack_id_i      ( '0                       ),

    .core_busy_i            ( ~cluster_core_sleep      ),
    .core_clock_en_o        ( cluster_eu_clock_en      ),

    // Cluster cores have no debug interface in MAGIA (debug_req_i tied to 0 above)
    .dbg_req_i              ( '0                       ),
    .core_dbg_req_o         (                          ),

    .eu_direct_req_i        ( cluster_eu_direct_req    ),
    .eu_direct_addr_i       ( cluster_eu_direct_addr   ),
    .eu_direct_wen_i        ( cluster_eu_direct_wen    ),
    .eu_direct_wdata_i      ( cluster_eu_direct_wdata  ),
    .eu_direct_be_i         ( cluster_eu_direct_be     ),
    .eu_direct_gnt_o        ( cluster_eu_direct_gnt    ),
    .eu_direct_rvalid_o     ( cluster_eu_direct_rvalid ),
    .eu_direct_rdata_o      ( cluster_eu_direct_rdata  ),
    .eu_direct_err_o        ( cluster_eu_direct_err    ),

    // Unused: ctrl-core -> core 0 notification goes through EU_OTHER_CLUSTER_START
    .soc_periph_evt_valid_i ( 1'b0                      ),
    .soc_periph_evt_ready_o (                           ),
    .soc_periph_evt_data_i  ( '0                        ),

    .obi_req_i              ( cluster_eu_obi_req_i     ),
    .obi_rsp_o              ( cluster_eu_obi_rsp_o     )
  );

endmodule: magia_cluster_wrap
