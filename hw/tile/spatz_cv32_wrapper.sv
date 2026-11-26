/*
 * Copyright (C) 2026 ETH Zurich, University of Bologna and Fondazione Chips-IT
 *
 * Licensed under the Solderpad Hardware License, Version 0.51 
 * (the "License"); you may not use this file except in compliance 
 * with the License. You may obtain a copy of the License at
 *
 *     http://solderpad.org/licenses/SHL-0.51
 *
 * Unless required by applicable law or agreed to in writing, software, hardware
 * and materials distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * SPDX-License-Identifier: SHL-0.51
 *
 * Authors: Luca Colombo, 2026 Fondazione Chips-IT
 * 
 * Wrapper for Spatz with CV32 control core
 * Obi interfaces for CV32 data memory accesses and HCI for Spatz memory access
 * Instruction cache is left out, simple I$, same as cluster.
 *
 */

module spatz_cv32_wrapper
  import magia_tile_pkg::*;
  import magia_pkg::*;
#(
  parameter magia_tile_pkg::magia_tile_cfg_t TileCfg       = magia_tile_pkg::MagiaTileDefaultCfg,
  // Derived from TileCfg
  localparam int unsigned                    NumMemPorts =  magia_tile_pkg::gen_tile_spatz_hci_ports(TileCfg),
  localparam int unsigned                    NClusterCores = TileCfg.Cluster.NumCores,  // MIMD: one APU port per cluster core
  parameter int unsigned                     HartIdBase    = 0,
  parameter int unsigned                     InstanceCount = magia_pkg::N_TILES,
  parameter type                             hci_req_t     = magia_tile_pkg::core_hci_data_req_t,
  parameter type                             hci_rsp_t     = magia_tile_pkg::core_hci_data_rsp_t,
  parameter int unsigned                     NumSpatzFPUs  = spatz_pkg::N_FPU
)(
  input  logic        clk_i,          // Gated Spatz clock
  input  logic        spatz_clk_en,
  input  logic        rst_ni,
  input  logic        test_mode_i,
  input  logic [31:0] mhartid_i,

  // Instruction fetch (-> Spatz i$ in the isle)
  output logic        instr_req_o,
  input  logic        instr_gnt_i,
  input  logic        instr_rvalid_i,
  output logic [31:0] instr_addr_o,
  input  logic [31:0] instr_rdata_i,

  input  logic [31:0] irq_i,
  output logic        irq_ack_o,
  output logic [4:0]  irq_id_o,

  // Scalar core data: every access goes through the tile OBI crossbar
  output magia_tile_pkg::core_obi_data_req_t             spatz_obi_data_req_o,
  input  magia_tile_pkg::core_obi_data_rsp_t             spatz_obi_data_rsp_i,

  // Vector LSU: one HCI port per Spatz memory port
  output hci_req_t [NumMemPorts-1:0]                spatz_hci_data_req_o,
  input  hci_rsp_t [NumMemPorts-1:0]                spatz_hci_data_rsp_i
);

  localparam int unsigned SpatzDataW  = magia_tile_pkg::SPATZ_TCDM_DATA_WIDTH;
  localparam int unsigned L1SizeBytes = TileCfg.L1.NumBanks * TileCfg.L1.NumWordsBank * (magia_tile_pkg::DW_LIC/8);
  // L1 base as seen by the HCI ports (full ADDR_W address, like the other Spatz wrapper).
  // TODO: replace with the package constant if one exists for the tile-private L1 base.
  localparam magia_tile_pkg::spatz_tcdm32_addr_t SpatzL1Base = magia_tile_pkg::spatz_tcdm32_addr_t'(32'hA010_0000);
  // FPU configuration, by default Snitch
  localparam fpnew_pkg::fpu_implementation_t SPATZ_FPU_IMPL = fpnew_pkg::DEFAULT_SNITCH;

`ifndef SYNTHESIS
  if (SpatzDataW != 32 || magia_tile_pkg::DW_LIC != 32) begin : gen_err_spatz_data_w
    $fatal(1, "magia_spatz_cv32_wrap: only 32-bit Spatz TCDM ports are supported (SpatzDataW=%0d, DW_LIC=%0d)",
           SpatzDataW, magia_tile_pkg::DW_LIC);
  end
  // The port of cv32e40px_spatz derives its address width from TCDMSize
  if (magia_tile_pkg::SPATZ_TCDM_ADDR_WIDTH != $clog2(L1SizeBytes)) begin : gen_err_spatz_addr_w
    $fatal(1, "magia_spatz_cv32_wrap: SPATZ_TCDM_ADDR_WIDTH=%0d differs from clog2(L1SizeBytes)=%0d",
           magia_tile_pkg::SPATZ_TCDM_ADDR_WIDTH, $clog2(L1SizeBytes));
  end
  // The VLSU of spatz_vpu moves ELEN bits per port: a narrower port truncates the upper elements.
  // spatz_pkg comes from scripts/gen_spatz_vpu_pkg.py (make spatz-vpu-pkg) with the SPATZ_* parameters.
  if (spatz_pkg::ELEN != SpatzDataW) begin : gen_err_spatz_elen
    $fatal(1, "magia_spatz_cv32_wrap: spatz_pkg::ELEN=%0d differs from SpatzDataW=%0d, regenerate the compile script (make vsim-scripts)",
           spatz_pkg::ELEN, SpatzDataW);
  end
`endif

  // Scalar core data channel (CV32E40P native type)
  magia_tile_pkg::cv32e40p_core_data_req_t spatz_data_req;
  magia_tile_pkg::cv32e40p_core_data_rsp_t spatz_data_rsp;
  // Vector memory ports as flat signals: local TCDM address (port width of cv32e40px_spatz)
  logic                               [NumMemPorts-1:0][magia_tile_pkg::SPATZ_TCDM_ADDR_WIDTH-1:0] spatz_mem_req_addr;
  logic                               [NumMemPorts-1:0] spatz_mem_req_write;
  magia_tile_pkg::spatz_tcdm32_data_t [NumMemPorts-1:0] spatz_mem_req_data;
  magia_tile_pkg::spatz_tcdm32_strb_t [NumMemPorts-1:0] spatz_mem_req_strb;
  logic                               [NumMemPorts-1:0] spatz_mem_req_valid;
  logic                               [NumMemPorts-1:0] spatz_mem_req_ready;
  magia_tile_pkg::spatz_tcdm32_data_t [NumMemPorts-1:0] spatz_mem_rsp_data;
  logic                               [NumMemPorts-1:0] spatz_mem_rsp_valid;

  cv32e40px_spatz #(
    .COREV_X_IF          ( 1                ),
    .CV32_FPU            ( 1                ),
    .FPU_ADDMUL_LAT      ( 1                ),  
    .FPU_OTHERS_LAT      ( 1                ), 
    .ZFINX               ( 0                ),
    .SpatzFPUImplementation (SPATZ_FPU_IMPL ),
    .NUM_MHPMCOUNTERS    ( 1                ),
    .SpatzDataWidth      ( SpatzDataW       ),
    .NumMemPortsPerSpatz ( NumMemPorts      ),
    .TCDMSize            ( L1SizeBytes      )  // TCDMAddrWidth is derived inside
  ) i_spatz_core (
    .clk_i                 ( clk_i                           ),
    .rst_ni                ( rst_ni                          ),
    .pulp_clock_en_i       ( spatz_clk_en                    ),
    .scan_cg_en_i          ( test_mode_i                     ),
    .boot_addr_i           ( magia_tile_pkg::SPATZ_BOOT_ADDR ),
    .mtvec_addr_i          ( magia_tile_pkg::SPATZ_BOOT_ADDR ),
    .dm_halt_addr_i        ( '0                              ),
    .dm_exception_addr_i   ( '0                              ),
    .hart_id_i             ( mhartid_i                       ),
    .instr_req_o           ( instr_req_o                     ),
    .instr_gnt_i           ( instr_gnt_i                     ),
    .instr_rvalid_i        ( instr_rvalid_i                  ),
    .instr_addr_o          ( instr_addr_o                    ),
    .instr_rdata_i         ( instr_rdata_i                   ),
    .data_req_o            ( spatz_data_req.req              ),
    .data_gnt_i            ( spatz_data_rsp.gnt              ),
    .data_rvalid_i         ( spatz_data_rsp.rvalid           ),
    .data_we_o             ( spatz_data_req.we               ),
    .data_be_o             ( spatz_data_req.be               ),
    .data_addr_o           ( spatz_data_req.addr             ),
    .data_wdata_o          ( spatz_data_req.wdata            ),
    .data_rdata_i          ( spatz_data_rsp.rdata            ),
    .spatz_mem_req_addr_o  ( spatz_mem_req_addr              ),
    .spatz_mem_req_write_o ( spatz_mem_req_write             ),
    .spatz_mem_req_data_o  ( spatz_mem_req_data              ),
    .spatz_mem_req_strb_o  ( spatz_mem_req_strb              ),
    .spatz_mem_req_valid_o ( spatz_mem_req_valid             ),
    .spatz_mem_req_ready_i ( spatz_mem_req_ready             ),
    .spatz_mem_rsp_data_i  ( spatz_mem_rsp_data              ),
    .spatz_mem_rsp_valid_i ( spatz_mem_rsp_valid             ),
    .irq_i                 ( irq_i                           ),
    .irq_ack_o             ( irq_ack_o                       ),
    .irq_id_o              ( irq_id_o                        ),
    .debug_req_i           ( 1'b0                            ),
    .debug_havereset_o     (                                 ),
    .debug_running_o       (                                 ),
    .debug_halted_o        (                                 ),
    .fetch_enable_i        ( 1'b1                            ),
    .core_sleep_o          (                                 )
  );

  // Scalar path: native data -> OBI -> tile OBI crossbar (L1, ctrl CSRs, L2, NoC)
  cv32e40p_data2obi_req i_spatz_data2obi (
    .data_req_i ( spatz_data_req       ),
    .obi_req_o  ( spatz_obi_data_req_o )
  );

  cv32e40p_obi2data_rsp i_spatz_obi2data (
    .obi_rsp_i  ( spatz_obi_data_rsp_i ),
    .data_rsp_o ( spatz_data_rsp       )
  );

   for (genvar i = 0; i < NumMemPorts; i++) begin : gen_spatz_vec_hci
    magia_tile_pkg::spatz_tcdm32_req_t tcdm_req;
    magia_tile_pkg::spatz_tcdm32_rsp_t tcdm_rsp;

    // Spatz flat signals -> TCDM32 req struct
    always_comb begin
      tcdm_req         = '0;
      // Local offset -> full address. The L1 base is aligned to the L1 size, so the sum is exact.
      tcdm_req.q.addr  = SpatzL1Base + magia_tile_pkg::spatz_tcdm32_addr_t'(spatz_mem_req_addr[i]);
      tcdm_req.q.write = spatz_mem_req_write[i];
      tcdm_req.q.data  = spatz_mem_req_data[i];
      tcdm_req.q.strb  = spatz_mem_req_strb[i];
      tcdm_req.q_valid = spatz_mem_req_valid[i];
    end

    // TCDM32 rsp struct -> Spatz flat signals
    assign spatz_mem_req_ready[i] = tcdm_rsp.q_ready;
    assign spatz_mem_rsp_valid[i] = tcdm_rsp.p_valid;
    assign spatz_mem_rsp_data[i]  = tcdm_rsp.p.data;

    // TCDM32 -> HCI (32-bit port, no dual HCI)
    tcdm2hci #(
      .tcdm_req_t ( magia_tile_pkg::spatz_tcdm32_req_t ),
      .tcdm_rsp_t ( magia_tile_pkg::spatz_tcdm32_rsp_t ),
      .hci_req_t  ( hci_req_t                          ),
      .hci_rsp_t  ( hci_rsp_t                          )
    ) i_tcdm2hci (
      .clk_i      ( clk_i                   ),
      .rst_ni     ( rst_ni                  ),
      .tcdm_req_i ( tcdm_req                ),
      .tcdm_rsp_o ( tcdm_rsp                ),
      .hci_req_o  ( spatz_hci_data_req_o[i] ),
      .hci_rsp_i  ( spatz_hci_data_rsp_i[i] )
    );
  end

endmodule: spatz_cv32_wrapper