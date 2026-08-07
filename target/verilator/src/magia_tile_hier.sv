/*
 * Copyright (C) 2026 ETH Zurich and University of Bologna
 * SPDX-License-Identifier: SHL-0.51
 *
 * Simulator-neutral packed-port wrapper used as the Verilator hierarchy
 * boundary.  Interfaces are instantiated entirely inside this module.
 */

`include "fractal_sync/assign.svh"

module magia_tile_hier
  import magia_tile_pkg::*;
  import magia_pkg::*;
  import magia_noc_pkg::*;
#(
  parameter int unsigned N_MEM_BANKS  = magia_pkg::N_MEM_BANKS,
  parameter int unsigned N_WORDS_BANK = magia_pkg::N_WORDS_BANK,
  // Hierarchical Verilation (see verilator/magia_hier.vlt) only accepts
  // integer/floating point/string/type parameters on a hier_block;
  // package-scoped enum types (cv32e40x_pkg::rv32_e etc.) are rejected
  // even when never overridden. Declare these as plain logic vectors
  // sized to match each enum's own base type, keep the same default
  // values, and cast back to the real enum type only at the magia_tile
  // instantiation below.
  parameter logic       CORE_ISA     = cv32e40x_pkg::RV32I,
  parameter logic [1:0] CORE_A       = cv32e40x_pkg::A,
  parameter logic [1:0] CORE_B       = cv32e40x_pkg::ZBA_ZBB_ZBC_ZBS,
  parameter logic [1:0] CORE_M       = cv32e40x_pkg::M,
  parameter logic       ERROR_CAP    = idma_pkg::NO_ERROR_HANDLING
)(
  input  logic clk_i, rst_ni, test_mode_i, tile_enable_i,

  input  floo_req_t noc_south_req_i, output floo_rsp_t noc_south_rsp_o,
  input  floo_wide_t noc_south_wide_i, output floo_req_t noc_south_req_o,
  input  floo_rsp_t noc_south_rsp_i, output floo_wide_t noc_south_wide_o,
  input  floo_req_t noc_east_req_i, output floo_rsp_t noc_east_rsp_o,
  input  floo_wide_t noc_east_wide_i, output floo_req_t noc_east_req_o,
  input  floo_rsp_t noc_east_rsp_i, output floo_wide_t noc_east_wide_o,
  input  floo_req_t noc_north_req_i, output floo_rsp_t noc_north_rsp_o,
  input  floo_wide_t noc_north_wide_i, output floo_req_t noc_north_req_o,
  input  floo_rsp_t noc_north_rsp_i, output floo_wide_t noc_north_wide_o,
  input  floo_req_t noc_west_req_i, output floo_rsp_t noc_west_rsp_o,
  input  floo_wide_t noc_west_wide_i, output floo_req_t noc_west_req_o,
  input  floo_rsp_t noc_west_rsp_i, output floo_wide_t noc_west_wide_o,

  input  logic [31:0] x_id_i, y_id_i,
  output ht_tile_fsync_req_t ht_fsync_req_o, input ht_tile_fsync_rsp_t ht_fsync_rsp_i,
  output hn_tile_fsync_req_t hn_fsync_req_o, input hn_tile_fsync_rsp_t hn_fsync_rsp_i,
  output vt_tile_fsync_req_t vt_fsync_req_o, input vt_tile_fsync_rsp_t vt_fsync_rsp_i,
  output vn_tile_fsync_req_t vn_fsync_req_o, input vn_tile_fsync_rsp_t vn_fsync_rsp_i,

  input  logic scan_cg_en_i,
  input  logic [31:0] boot_addr_i, mtvec_addr_i, dm_halt_addr_i, dm_exception_addr_i,
  input  logic [31:0] mhartid_i,
  input  logic [3:0] mimpid_patch_i,
  output logic [63:0] mcycle_o,
  input  logic [63:0] time_i,
  input  logic [magia_pkg::N_IRQ-1:0] irq_i,
  input  logic [magia_tile_pkg::N_CLUSTER_CORES:0] debug_req_i,
  output logic debug_havereset_o, debug_running_o, debug_halted_o,
  output logic debug_pc_valid_o,
  output logic [31:0] debug_pc_o,
  input  logic fetch_enable_i,
  output logic core_sleep_o,
  input  logic wu_wfe_i,
  output magia_tile_observe_t observe_o
);

  fractal_sync_if #(.AGGR_WIDTH(FSYNC_AGGR_W), .LVL_WIDTH(FSYNC_LVL_W), .ID_WIDTH(FSYNC_ID_W)) ht_fsync_if();
  fractal_sync_if #(.AGGR_WIDTH(FSYNC_NBR_AGGR_W), .LVL_WIDTH(FSYNC_NBR_LVL_W), .ID_WIDTH(FSYNC_NBR_ID_W)) hn_fsync_if();
  fractal_sync_if #(.AGGR_WIDTH(FSYNC_AGGR_W), .LVL_WIDTH(FSYNC_LVL_W), .ID_WIDTH(FSYNC_ID_W)) vt_fsync_if();
  fractal_sync_if #(.AGGR_WIDTH(FSYNC_NBR_AGGR_W), .LVL_WIDTH(FSYNC_NBR_LVL_W), .ID_WIDTH(FSYNC_NBR_ID_W)) vn_fsync_if();

  `FSYNC_ASSIGN_I2S_REQ(ht_fsync_if, ht_fsync_req_o)
  `FSYNC_ASSIGN_S2I_RSP(ht_fsync_rsp_i, ht_fsync_if)
  `FSYNC_ASSIGN_I2S_REQ(hn_fsync_if, hn_fsync_req_o)
  `FSYNC_ASSIGN_S2I_RSP(hn_fsync_rsp_i, hn_fsync_if)
  `FSYNC_ASSIGN_I2S_REQ(vt_fsync_if, vt_fsync_req_o)
  `FSYNC_ASSIGN_S2I_RSP(vt_fsync_rsp_i, vt_fsync_if)
  `FSYNC_ASSIGN_I2S_REQ(vn_fsync_if, vn_fsync_req_o)
  `FSYNC_ASSIGN_S2I_RSP(vn_fsync_rsp_i, vn_fsync_if)

  magia_tile #(
    .N_MEM_BANKS(N_MEM_BANKS), .N_WORDS_BANK(N_WORDS_BANK),
    .CORE_ISA(cv32e40x_pkg::rv32_e'(CORE_ISA)),
    .CORE_A(cv32e40x_pkg::a_ext_e'(CORE_A)),
    .CORE_B(cv32e40x_pkg::b_ext_e'(CORE_B)),
    .CORE_M(cv32e40x_pkg::m_ext_e'(CORE_M)),
    .ERROR_CAP(idma_pkg::error_cap_e'(ERROR_CAP))
  ) i_magia_tile (
    .clk_i                ( clk_i                ),
    .rst_ni                ( rst_ni                ),
    .test_mode_i           ( test_mode_i           ),
    .tile_enable_i         ( tile_enable_i         ),

    .noc_south_req_i       ( noc_south_req_i       ),
    .noc_south_rsp_o       ( noc_south_rsp_o       ),
    .noc_south_wide_i      ( noc_south_wide_i      ),
    .noc_south_req_o       ( noc_south_req_o       ),
    .noc_south_rsp_i       ( noc_south_rsp_i       ),
    .noc_south_wide_o      ( noc_south_wide_o      ),

    .noc_east_req_i        ( noc_east_req_i        ),
    .noc_east_rsp_o        ( noc_east_rsp_o        ),
    .noc_east_wide_i       ( noc_east_wide_i       ),
    .noc_east_req_o        ( noc_east_req_o        ),
    .noc_east_rsp_i        ( noc_east_rsp_i        ),
    .noc_east_wide_o       ( noc_east_wide_o       ),

    .noc_north_req_i       ( noc_north_req_i       ),
    .noc_north_rsp_o       ( noc_north_rsp_o       ),
    .noc_north_wide_i      ( noc_north_wide_i      ),
    .noc_north_req_o       ( noc_north_req_o       ),
    .noc_north_rsp_i       ( noc_north_rsp_i       ),
    .noc_north_wide_o      ( noc_north_wide_o      ),

    .noc_west_req_i        ( noc_west_req_i        ),
    .noc_west_rsp_o        ( noc_west_rsp_o        ),
    .noc_west_wide_i       ( noc_west_wide_i       ),
    .noc_west_req_o        ( noc_west_req_o        ),
    .noc_west_rsp_i        ( noc_west_rsp_i        ),
    .noc_west_wide_o       ( noc_west_wide_o       ),

    .x_id_i                ( x_id_i                ),
    .y_id_i                ( y_id_i                ),

    .ht_fsync_if_o          ( ht_fsync_if           ),
    .hn_fsync_if_o          ( hn_fsync_if           ),
    .vt_fsync_if_o          ( vt_fsync_if           ),
    .vn_fsync_if_o          ( vn_fsync_if           ),

    .scan_cg_en_i           ( scan_cg_en_i          ),

    .boot_addr_i            ( boot_addr_i           ),
    .mtvec_addr_i           ( mtvec_addr_i          ),
    .dm_halt_addr_i         ( dm_halt_addr_i        ),
    .dm_exception_addr_i    ( dm_exception_addr_i   ),
    .mhartid_i              ( mhartid_i             ),
    .mimpid_patch_i         ( mimpid_patch_i        ),

    .mcycle_o               ( mcycle_o              ),
    .time_i                 ( time_i                ),

    .irq_i                  ( irq_i                 ),

    .debug_req_i            ( debug_req_i           ),
    .debug_havereset_o      ( debug_havereset_o     ),
    .debug_running_o        ( debug_running_o       ),
    .debug_halted_o         ( debug_halted_o        ),
    .debug_pc_valid_o       ( debug_pc_valid_o      ),
    .debug_pc_o             ( debug_pc_o            ),

    .fetch_enable_i         ( fetch_enable_i        ),
    .core_sleep_o           ( core_sleep_o          ),
    .wu_wfe_i               ( wu_wfe_i              ),

    .observe_o              ( observe_o             )
  );

endmodule
