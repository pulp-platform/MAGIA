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
  input  logic sys_clk_i,  // Gated system clock (dispatch-IRQ stretch FSM)
  input  logic rst_ni,
  input  logic test_mode_i,

  // Per-core gated clocks (one clock gate per core, driven in magia_tile).
  input  logic [NClusterCores-1:0] cluster_clk_i,

  // Tile hart-id base (control core is 0; cluster cores start after the tiles' ctrl cores)
  input  logic [31:0] mhartid_i,

  // This tile's L1 window: in-range accesses take the dedicated HCI port, else OBI crossbar.
  input  logic [magia_pkg::ADDR_W-1:0] tile_l1_start_addr_i,
  input  logic [magia_pkg::ADDR_W-1:0] tile_l1_end_addr_i,

  // Control outputs from the cluster CSR (in magia_tile).
  input  logic [31:0]              cluster_boot_addr_i    [NClusterCores-1:0],
  input  logic [NClusterCores-1:0] cluster_fetch_enable_i,
  input  logic [NClusterCores-1:0] cluster_start_irq_i,     // 1-cycle dispatch IRQ pulse per core

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

  // Data-demux slave map: [0] = TCDM (L1) fast path, [1] = OBI (peripherals / default).
  localparam int unsigned CLUSTER_DATA_N_SLV    = 2;
  localparam int unsigned CLUSTER_DATA_TCDM_IDX = 0;
  localparam int unsigned CLUSTER_DATA_OBI_IDX  = 1;

  logic [NClusterCores-1:0] cluster_core_sleep;

  // Cluster core data interface (CV32E40P native channel type).
  magia_tile_pkg::cv32e40p_core_data_req_t [NClusterCores-1:0] cluster_data_req;
  magia_tile_pkg::cv32e40p_core_data_rsp_t [NClusterCores-1:0] cluster_data_rsp;

  // Per-core demux downstream ports ([i][TCDM], [i][OBI]).
  magia_tile_pkg::cv32e40p_core_data_req_t [NClusterCores-1:0][CLUSTER_DATA_N_SLV-1:0] cluster_ddemux_req;
  magia_tile_pkg::cv32e40p_core_data_rsp_t [NClusterCores-1:0][CLUSTER_DATA_N_SLV-1:0] cluster_ddemux_rsp;

  // IRQ ack/id + stretched dispatch IRQ and the per-core 32-bit vector.
  logic [NClusterCores-1:0]                                        cluster_irq_ack;
  logic [NClusterCores-1:0][magia_tile_pkg::CLIC_ID_W_CLUSTER-1:0] cluster_irq_id;
  logic [NClusterCores-1:0]                                        cluster_start_irq_pending;
  logic [NClusterCores-1:0][31:0]                                  cluster_irq_vec;

  // Dispatch IRQ is a 1-cycle pulse from the CSR; stretch it until the core acks.
  always_ff @(posedge sys_clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      cluster_start_irq_pending <= '0;
    end else begin
      for (int unsigned i = 0; i < NClusterCores; i++) begin
        if (cluster_irq_ack[i]) begin
          cluster_start_irq_pending[i] <= 1'b0;
        end else if (cluster_start_irq_i[i]) begin
          cluster_start_irq_pending[i] <= 1'b1;
        end
      end
    end
  end

  // Per-core IRQ vector: MEI bit (11) driven by the stretched dispatch request,
  // all other interrupt bits forced to 0.
  for (genvar k = 0; k < NClusterCores; k++) begin : gen_cluster_irq_vec
    assign cluster_irq_vec[k] = {20'b0, cluster_start_irq_pending[k], 11'b0};
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
        .clk_i                  ( cluster_clk_i[i]      ),  // Per-core gated clock
        .rst_ni                 ( rst_ni                ),

        // Clock always enabled; sleep/wake via WFI / MEI (dispatch IRQ)
        .pulp_clock_en_i        ( 1'b1                        ),  // For now without custom event unit
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
        // Interrupts: only the dispatch IRQ (MEI bit 11) from the cluster CSR; no event unit
        .irq_i                  ( cluster_irq_vec[i]                  ),
        .irq_ack_o              ( cluster_irq_ack[i]                  ),
        .irq_id_o               ( cluster_irq_id[i]                   ),
    
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

  // ---------------------------------------------------------------------------
  // Per-core data demux: L1/TCDM window -> dedicated HCI port, rest -> OBI xbar
  // ---------------------------------------------------------------------------
  for (genvar i = 0; i < NClusterCores; i++) begin : gen_cluster_data_demux

    // Runtime slave address ranges: TCDM = this tile's L1 window, OBI = default.
    logic [magia_pkg::ADDR_W-1:0] cluster_ddemux_start_addr [CLUSTER_DATA_N_SLV-1:0];
    logic [magia_pkg::ADDR_W-1:0] cluster_ddemux_end_addr   [CLUSTER_DATA_N_SLV-1:0];
    assign cluster_ddemux_start_addr[CLUSTER_DATA_TCDM_IDX] = tile_l1_start_addr_i;
    assign cluster_ddemux_end_addr  [CLUSTER_DATA_TCDM_IDX] = tile_l1_end_addr_i;
    assign cluster_ddemux_start_addr[CLUSTER_DATA_OBI_IDX]  = '0; // unused (default slave)
    assign cluster_ddemux_end_addr  [CLUSTER_DATA_OBI_IDX]  = '0; // unused (default slave)

    core_data_demux #(
      .NumSlv     ( CLUSTER_DATA_N_SLV                       ),
      .DefaultSlv ( CLUSTER_DATA_OBI_IDX                     ),
      .req_t      ( magia_tile_pkg::cv32e40p_core_data_req_t ),
      .rsp_t      ( magia_tile_pkg::cv32e40p_core_data_rsp_t )
    ) i_cluster_data_demux (
      .clk_i            ( cluster_clk_i[i]          ),
      .rst_ni           ( rst_ni                    ),
      .core_data_req_i  ( cluster_data_req[i]       ),
      .core_data_rsp_o  ( cluster_data_rsp[i]       ),
      .slv_start_addr_i ( cluster_ddemux_start_addr ),
      .slv_end_addr_i   ( cluster_ddemux_end_addr   ),
      .slv_data_req_o   ( cluster_ddemux_req[i]     ),
      .slv_data_rsp_i   ( cluster_ddemux_rsp[i]     )
    );
  end

  // ---------------------------------------------------------------------------
  // Per-core converters: OBI path demux->xbar; TCDM path demux->OBI->HCI
  // ---------------------------------------------------------------------------
  for (genvar i = 0; i < NClusterCores; i++) begin : gen_cluster_data_obi

    // --- OBI (peripheral) path ---
    cv32e40p_data2obi_req i_cluster_data2obi (
      .data_req_i ( cluster_ddemux_req[i][CLUSTER_DATA_OBI_IDX] ),
      .obi_req_o  ( cluster_obi_data_req_o[i]                   )
    );

    cv32e40p_obi2data_rsp i_cluster_obi2data (
      .obi_rsp_i  ( cluster_obi_data_rsp_i[i]                   ),
      .data_rsp_o ( cluster_ddemux_rsp[i][CLUSTER_DATA_OBI_IDX] )
    );

    // --- TCDM (L1) path: native mem -> OBI -> HCI dedicated interconnect port ---
    magia_tile_pkg::core_obi_data_req_t cluster_tcdm_obi_req;
    magia_tile_pkg::core_obi_data_rsp_t cluster_tcdm_obi_rsp;

    cv32e40p_data2obi_req i_cluster_tcdm_data2obi (
      .data_req_i ( cluster_ddemux_req[i][CLUSTER_DATA_TCDM_IDX] ),
      .obi_req_o  ( cluster_tcdm_obi_req                         )
    );

    cv32e40p_obi2data_rsp i_cluster_tcdm_obi2data (
      .obi_rsp_i  ( cluster_tcdm_obi_rsp                         ),
      .data_rsp_o ( cluster_ddemux_rsp[i][CLUSTER_DATA_TCDM_IDX] )
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

endmodule: magia_cluster_wrap
