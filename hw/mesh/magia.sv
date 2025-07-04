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
 * MAGIA
 */

`include "fractal_sync/assign.svh"

module magia 
  import magia_pkg::*;
  import magia_tile_pkg::*;
#(
  parameter int unsigned N_TILES_Y         = magia_pkg::N_TILES_Y,          // Number of Tile rowns
  parameter int unsigned N_TILES_X         = magia_pkg::N_TILES_X,          // Number of Tile columns
  parameter int unsigned N_TILES           = magia_pkg::N_TILES,            // Number of Tiles in the Mesh
  parameter int unsigned N_MEM_BANKS       = magia_pkg::N_MEM_BANKS,        // Number of TCDM banks (1 extra bank for missaligned accesses) per Tile
  parameter int unsigned N_WORDS_BANK      = magia_pkg::N_WORDS_BANK,       // Number of words per TCDM bank

  parameter int unsigned TILE_FSYNC_AGGR_W = magia_pkg::TILE_FSYNC_AGGR_W,  // Width of the FractalSync aggr of the Tile - FS network link
  parameter int unsigned TILE_FSYNC_LVL_W  = magia_pkg::TILE_FSYNC_LVL_W,   // Width of the FractalSync lvl of the Tile - FS network link
  parameter int unsigned TILE_FSYNC_ID_W   = magia_pkg::TILE_FSYNC_ID_W     // Width of the FractalSync id of the Tile - FS network link
)(
  input  logic                                  clk_i,
  input  logic                                  rst_ni,
  input  logic                                  test_mode_i,
  input  logic                                  tile_enable_i,

  input  logic                                  scan_cg_en_i,

  input  logic[31:0]                            boot_addr_i,
  input  logic[31:0]                            mtvec_addr_i,
  input  logic[31:0]                            dm_halt_addr_i,
  input  logic[31:0]                            dm_exception_addr_i,
  input  logic[ 3:0]                            mimpid_patch_i,

  output logic[63:0]                            mcycle_o[N_TILES],
  input  logic[63:0]                            time_i,

  input  logic[magia_pkg::N_IRQ-1:0]            irq_i[N_TILES],

  input  logic                                  debug_req_i,
  output logic                                  debug_havereset_o[N_TILES],
  output logic                                  debug_running_o[N_TILES],
  output logic                                  debug_halted_o[N_TILES],
  output logic                                  debug_pc_valid_o[N_TILES],
  output logic[31:0]                            debug_pc_o[N_TILES],

  input  logic                                  fetch_enable_i,
  output logic                                  core_sleep_o[N_TILES],

  input  logic                                  wu_wfe_i,

  // Only west-side L2
  output magia_pkg::axi_l2_req_t[N_TILES_Y-1:0] l2_data_req_o,
  input  magia_pkg::axi_l2_rsp_t[N_TILES_Y-1:0] l2_data_rsp_i
);

/*******************************************************/
/**       Internal Signal Definitions Beginning       **/
/*******************************************************/

  logic[31:0] mhartid[N_TILES];
  
  magia_pkg::axi_default_req_t[N_TILES_Y-1:0][N_TILES_X-1:0] data_out_req;
  magia_pkg::axi_default_rsp_t[N_TILES_Y-1:0][N_TILES_X-1:0] data_out_rsp;

  magia_tile_pkg::axi_xbar_slv_req_t[N_TILES_Y-1:0][N_TILES_X-1:0] data_in_req;
  magia_tile_pkg::axi_xbar_slv_rsp_t[N_TILES_Y-1:0][N_TILES_X-1:0] data_in_rsp;

  magia_tile_pkg::ht_tile_fsync_req_t ht_tile_fsync_req[N_TILES][1]; // Single link CU-FSync interface
  magia_tile_pkg::ht_tile_fsync_rsp_t ht_tile_fsync_rsp[N_TILES][1]; // Single link CU-FSync interface
  magia_tile_pkg::hn_tile_fsync_req_t hn_tile_fsync_req[N_TILES];
  magia_tile_pkg::hn_tile_fsync_rsp_t hn_tile_fsync_rsp[N_TILES];
  magia_tile_pkg::vt_tile_fsync_req_t vt_tile_fsync_req[N_TILES][1]; // Single link CU-FSync interface
  magia_tile_pkg::vt_tile_fsync_rsp_t vt_tile_fsync_rsp[N_TILES][1]; // Single link CU-FSync interface
  magia_tile_pkg::vn_tile_fsync_req_t vn_tile_fsync_req[N_TILES];
  magia_tile_pkg::vn_tile_fsync_rsp_t vn_tile_fsync_rsp[N_TILES];

  magia_pkg::h_root_fsync_req_t h_root_fsync_req[1][1]; // Single node, single link root node out interface
  magia_pkg::h_root_fsync_rsp_t h_root_fsync_rsp[1][1]; // Single node, single link root node out interface
  magia_pkg::v_root_fsync_req_t v_root_fsync_req[1][1]; // Single node, single link root node out interface
  magia_pkg::v_root_fsync_rsp_t v_root_fsync_rsp[1][1]; // Single node, single link root node out interface

/*******************************************************/
/**          Internal Signal Definitions End          **/
/*******************************************************/
/**           Interface Definitions Beginning         **/
/*******************************************************/

  fractal_sync_if #(.AGGR_WIDTH(TILE_FSYNC_AGGR_W),                .LVL_WIDTH(TILE_FSYNC_LVL_W),                .ID_WIDTH(TILE_FSYNC_ID_W))                ht_fsync_if[N_TILES]();
  fractal_sync_if #(.AGGR_WIDTH(magia_tile_pkg::FSYNC_NBR_AGGR_W), .LVL_WIDTH(magia_tile_pkg::FSYNC_NBR_LVL_W), .ID_WIDTH(magia_tile_pkg::FSYNC_NBR_ID_W)) hn_fsync_if[N_TILES]();
  fractal_sync_if #(.AGGR_WIDTH(TILE_FSYNC_AGGR_W),                .LVL_WIDTH(TILE_FSYNC_LVL_W),                .ID_WIDTH(TILE_FSYNC_ID_W))                vt_fsync_if[N_TILES]();
  fractal_sync_if #(.AGGR_WIDTH(magia_tile_pkg::FSYNC_NBR_AGGR_W), .LVL_WIDTH(magia_tile_pkg::FSYNC_NBR_LVL_W), .ID_WIDTH(magia_tile_pkg::FSYNC_NBR_ID_W)) vn_fsync_if[N_TILES]();

/*******************************************************/
/**             Interface Definitions End             **/
/*******************************************************/
/**          Interface Assignments Beginning          **/
/*******************************************************/

  for (genvar i = 0; i < N_TILES; i++) begin: gen_fsync_if_assign
    `FSYNC_ASSIGN_I2S_REQ(ht_fsync_if[i],          ht_tile_fsync_req[i][0])
    `FSYNC_ASSIGN_S2I_RSP(ht_tile_fsync_rsp[i][0], ht_fsync_if[i])
    `FSYNC_ASSIGN_I2S_REQ(hn_fsync_if[i],          hn_tile_fsync_req[i])
    `FSYNC_ASSIGN_S2I_RSP(hn_tile_fsync_rsp[i],    hn_fsync_if[i])
    `FSYNC_ASSIGN_I2S_REQ(vt_fsync_if[i],          vt_tile_fsync_req[i][0])
    `FSYNC_ASSIGN_S2I_RSP(vt_tile_fsync_rsp[i][0], vt_fsync_if[i])
    `FSYNC_ASSIGN_I2S_REQ(vn_fsync_if[i],          vn_tile_fsync_req[i])
    `FSYNC_ASSIGN_S2I_RSP(vn_tile_fsync_rsp[i],    vn_fsync_if[i])
  end

/*******************************************************/
/**             Interface Assignments End             **/
/*******************************************************/
/**            Hardwired Signals Beginning            **/
/*******************************************************/

  for (genvar i = 0; i < N_TILES; i++) begin: gen_mhartid
    assign mhartid[i] = i;
  end

  assign h_root_fsync_rsp[0][0].wake    = 1'b0;
  assign h_root_fsync_rsp[0][0].sig.lvl = '0;
  assign h_root_fsync_rsp[0][0].sig.id  = '0;
  assign h_root_fsync_rsp[0][0].error   = 1'b0;
  assign v_root_fsync_rsp[0][0].wake    = 1'b0;
  assign v_root_fsync_rsp[0][0].sig.lvl = '0;
  assign v_root_fsync_rsp[0][0].sig.id  = '0;
  assign v_root_fsync_rsp[0][0].error   = 1'b0;

/*******************************************************/
/**               Hardwired Signals End               **/
/*******************************************************/
/**               MAGIA Tiles Beginning               **/
/*******************************************************/

  for (genvar i = 0; i < N_TILES_Y; i++) begin: gen_y_tile
    for (genvar j = 0; j < N_TILES_X; j++) begin: gen_x_tile
      magia_tile #(
        .N_MEM_BANKS  ( N_MEM_BANKS   ),
        .N_WORDS_BANK ( N_WORDS_BANK  ),
  
        .CORE_ISA     (               ),
        .CORE_A       (               ),
        .CORE_B       (               ),
        .CORE_M       (               ),
        .ERROR_CAP    (               )
      ) i_magia_tile (
        .clk_i                                                   ,
        .rst_ni                                                  ,
        .test_mode_i                                             ,
        .tile_enable_i                                           ,
  
        .data_out_req_o      ( data_out_req[i][j]               ),
        .data_out_rsp_i      ( data_out_rsp[i][j]               ),
  
        .data_in_req_i       ( data_in_req[i][j]                ),
        .data_in_rsp_o       ( data_in_rsp[i][j]                ),
  
        .ht_fsync_if_o       ( ht_fsync_if[i*N_TILES_X+j]       ),
        .hn_fsync_if_o       ( hn_fsync_if[i*N_TILES_X+j]       ),
        .vt_fsync_if_o       ( vt_fsync_if[i*N_TILES_X+j]       ),
        .vn_fsync_if_o       ( vn_fsync_if[i*N_TILES_X+j]       ),
        
        .scan_cg_en_i                                            ,
  
        .boot_addr_i                                             ,
        .mtvec_addr_i                                            ,
        .dm_halt_addr_i                                          ,
        .dm_exception_addr_i                                     ,
        .mhartid_i           ( mhartid[i*N_TILES_X+j]           ),
        .mimpid_patch_i                                          ,
  
        .mcycle_o            ( mcycle_o[i*N_TILES_X+j]          ),
        .time_i                                                  ,
  
        .irq_i               ( irq_i[i*N_TILES_X+j]             ),
  
        .debug_req_i                                             ,
        .debug_havereset_o   ( debug_havereset_o[i*N_TILES_X+j] ),
        .debug_running_o     ( debug_running_o[i*N_TILES_X+j]   ),
        .debug_halted_o      ( debug_halted_o[i*N_TILES_X+j]    ),
        .debug_pc_valid_o    ( debug_pc_valid_o[i*N_TILES_X+j]  ),
        .debug_pc_o          ( debug_pc_o[i*N_TILES_X+j]        ),
  
        .fetch_enable_i                                          ,
        .core_sleep_o        ( core_sleep_o[i*N_TILES_X+j]      ),
        .wu_wfe_i
      );
  `ifdef CORE_TRACES
      localparam string core_trace_file_name = $sformatf("%s%0d", "log_file_", i*N_TILES_X+j);
      defparam i_magia_tile.i_cv32e40x_core.rvfi_i.tracer_i.LOGFILE_PATH_PLUSARG = core_trace_file_name;
  `endif
    end
  end

/*******************************************************/
/**                  MAGIA Tiles End                  **/
/*******************************************************/
/**                 Mesh NoC Beginning                **/
/*******************************************************/

  if ((N_TILES_Y == 2) && (N_TILES_X == 2)) begin: gen_2x2_noc
    floo_axi_mesh_2x2_noc i_mesh_noc (
      .clk_i                                      ,
      .rst_ni                                     ,
      .test_enable_i             ( test_mode_i   ),
      .magia_tile_data_slv_req_i ( data_out_req  ),
      .magia_tile_data_slv_rsp_o ( data_out_rsp  ),
      .magia_tile_data_mst_req_o ( data_in_req   ),
      .magia_tile_data_mst_rsp_i ( data_in_rsp   ),
      .L2_data_mst_req_o         ( l2_data_req_o ),
      .L2_data_mst_rsp_i         ( l2_data_rsp_i )
    );
  end else if ((N_TILES_Y == 4) && (N_TILES_X == 4)) begin: gen_4x4_noc
    floo_axi_mesh_4x4_noc i_mesh_noc (
      .clk_i                                      ,
      .rst_ni                                     ,
      .test_enable_i             ( test_mode_i   ),
      .magia_tile_data_slv_req_i ( data_out_req  ),
      .magia_tile_data_slv_rsp_o ( data_out_rsp  ),
      .magia_tile_data_mst_req_o ( data_in_req   ),
      .magia_tile_data_mst_rsp_i ( data_in_rsp   ),
      .L2_data_mst_req_o         ( l2_data_req_o ),
      .L2_data_mst_rsp_i         ( l2_data_rsp_i )
    );
  end else if ((N_TILES_Y == 8) && (N_TILES_X == 8)) begin: gen_8x8_noc
    floo_axi_mesh_8x8_noc i_mesh_noc (
      .clk_i                                      ,
      .rst_ni                                     ,
      .test_enable_i             ( test_mode_i   ),
      .magia_tile_data_slv_req_i ( data_out_req  ),
      .magia_tile_data_slv_rsp_o ( data_out_rsp  ),
      .magia_tile_data_mst_req_o ( data_in_req   ),
      .magia_tile_data_mst_rsp_i ( data_in_rsp   ),
      .L2_data_mst_req_o         ( l2_data_req_o ),
      .L2_data_mst_rsp_i         ( l2_data_rsp_i )
    );
  end else if ((N_TILES_Y == 16) && (N_TILES_X == 16)) begin: gen_16x16_noc
    floo_axi_mesh_16x16_noc i_mesh_noc (
      .clk_i                                      ,
      .rst_ni                                     ,
      .test_enable_i             ( test_mode_i   ),
      .magia_tile_data_slv_req_i ( data_out_req  ),
      .magia_tile_data_slv_rsp_o ( data_out_rsp  ),
      .magia_tile_data_mst_req_o ( data_in_req   ),
      .magia_tile_data_mst_rsp_i ( data_in_rsp   ),
      .L2_data_mst_req_o         ( l2_data_req_o ),
      .L2_data_mst_rsp_i         ( l2_data_rsp_i )
    );
  end else if ((N_TILES_Y == 32) && (N_TILES_X == 32)) begin: gen_32x32_noc
    floo_axi_mesh_32x32_noc i_mesh_noc (
      .clk_i                                      ,
      .rst_ni                                     ,
      .test_enable_i             ( test_mode_i   ),
      .magia_tile_data_slv_req_i ( data_out_req  ),
      .magia_tile_data_slv_rsp_o ( data_out_rsp  ),
      .magia_tile_data_mst_req_o ( data_in_req   ),
      .magia_tile_data_mst_rsp_i ( data_in_rsp   ),
      .L2_data_mst_req_o         ( l2_data_req_o ),
      .L2_data_mst_rsp_i         ( l2_data_rsp_i )
    );
  end else $fatal("Unsupported Mesh configuration");

/*******************************************************/
/**                    Mesh NoC End                    */
/*******************************************************/
/**           FractalSync Network Beginning           **/
/*******************************************************/

  if ((N_TILES_Y == 2) && (N_TILES_X == 2)) begin: gen_2x2_fsync
    fractal_sync_2x2 i_mesh_fsync (
      .clk_i                                  ,
      .rst_ni                                 ,
      .h_1d_fsync_req_i  ( ht_tile_fsync_req ),
      .h_1d_fsync_rsp_o  ( ht_tile_fsync_rsp ),
      .v_1d_fsync_req_i  ( vt_tile_fsync_req ),
      .v_1d_fsync_rsp_o  ( vt_tile_fsync_rsp ),
      .h_nbr_fsycn_req_i ( hn_tile_fsync_req ),
      .h_nbr_fsycn_rsp_o ( hn_tile_fsync_rsp ),
      .v_nbr_fsycn_req_i ( vn_tile_fsync_req ),
      .v_nbr_fsycn_rsp_o ( vn_tile_fsync_rsp ),
      .h_2d_fsync_req_o  ( h_root_fsync_req  ),
      .h_2d_fsync_rsp_i  ( h_root_fsync_rsp  ),
      .v_2d_fsync_req_o  ( v_root_fsync_req  ),
      .v_2d_fsync_rsp_i  ( v_root_fsync_rsp  )
    );
  end else if ((N_TILES_Y == 4) && (N_TILES_X == 4)) begin: gen_4x4_fsync
    fractal_sync_4x4 i_mesh_fsync (
      .clk_i                                  ,
      .rst_ni                                 ,
      .h_1d_fsync_req_i  ( ht_tile_fsync_req ),
      .h_1d_fsync_rsp_o  ( ht_tile_fsync_rsp ),
      .v_1d_fsync_req_i  ( vt_tile_fsync_req ),
      .v_1d_fsync_rsp_o  ( vt_tile_fsync_rsp ),
      .h_nbr_fsycn_req_i ( hn_tile_fsync_req ),
      .h_nbr_fsycn_rsp_o ( hn_tile_fsync_rsp ),
      .v_nbr_fsycn_req_i ( vn_tile_fsync_req ),
      .v_nbr_fsycn_rsp_o ( vn_tile_fsync_rsp ),
      .h_2d_fsync_req_o  ( h_root_fsync_req  ),
      .h_2d_fsync_rsp_i  ( h_root_fsync_rsp  ),
      .v_2d_fsync_req_o  ( v_root_fsync_req  ),
      .v_2d_fsync_rsp_i  ( v_root_fsync_rsp  )
    );
  end else if ((N_TILES_Y == 8) && (N_TILES_X == 8)) begin: gen_8x8_fsync
    fractal_sync_8x8 i_mesh_fsync (
      .clk_i                                  ,
      .rst_ni                                 ,
      .h_1d_fsync_req_i  ( ht_tile_fsync_req ),
      .h_1d_fsync_rsp_o  ( ht_tile_fsync_rsp ),
      .v_1d_fsync_req_i  ( vt_tile_fsync_req ),
      .v_1d_fsync_rsp_o  ( vt_tile_fsync_rsp ),
      .h_nbr_fsycn_req_i ( hn_tile_fsync_req ),
      .h_nbr_fsycn_rsp_o ( hn_tile_fsync_rsp ),
      .v_nbr_fsycn_req_i ( vn_tile_fsync_req ),
      .v_nbr_fsycn_rsp_o ( vn_tile_fsync_rsp ),
      .h_2d_fsync_req_o  ( h_root_fsync_req  ),
      .h_2d_fsync_rsp_i  ( h_root_fsync_rsp  ),
      .v_2d_fsync_req_o  ( v_root_fsync_req  ),
      .v_2d_fsync_rsp_i  ( v_root_fsync_rsp  )
    );
  end else if ((N_TILES_Y == 16) && (N_TILES_X == 16)) begin: gen_16x16_fsync
    fractal_sync_16x16 i_mesh_fsync (
      .clk_i                                  ,
      .rst_ni                                 ,
      .h_1d_fsync_req_i  ( ht_tile_fsync_req ),
      .h_1d_fsync_rsp_o  ( ht_tile_fsync_rsp ),
      .v_1d_fsync_req_i  ( vt_tile_fsync_req ),
      .v_1d_fsync_rsp_o  ( vt_tile_fsync_rsp ),
      .h_nbr_fsycn_req_i ( hn_tile_fsync_req ),
      .h_nbr_fsycn_rsp_o ( hn_tile_fsync_rsp ),
      .v_nbr_fsycn_req_i ( vn_tile_fsync_req ),
      .v_nbr_fsycn_rsp_o ( vn_tile_fsync_rsp ),
      .h_2d_fsync_req_o  ( h_root_fsync_req  ),
      .h_2d_fsync_rsp_i  ( h_root_fsync_rsp  ),
      .v_2d_fsync_req_o  ( v_root_fsync_req  ),
      .v_2d_fsync_rsp_i  ( v_root_fsync_rsp  )
    );
  end else if ((N_TILES_Y == 32) && (N_TILES_X == 32)) begin: gen_32x32_fsync
    fractal_sync_32x32 i_mesh_fsync (
      .clk_i                                  ,
      .rst_ni                                 ,
      .h_1d_fsync_req_i  ( ht_tile_fsync_req ),
      .h_1d_fsync_rsp_o  ( ht_tile_fsync_rsp ),
      .v_1d_fsync_req_i  ( vt_tile_fsync_req ),
      .v_1d_fsync_rsp_o  ( vt_tile_fsync_rsp ),
      .h_nbr_fsycn_req_i ( hn_tile_fsync_req ),
      .h_nbr_fsycn_rsp_o ( hn_tile_fsync_rsp ),
      .v_nbr_fsycn_req_i ( vn_tile_fsync_req ),
      .v_nbr_fsycn_rsp_o ( vn_tile_fsync_rsp ),
      .h_2d_fsync_req_o  ( h_root_fsync_req  ),
      .h_2d_fsync_rsp_i  ( h_root_fsync_rsp  ),
      .v_2d_fsync_req_o  ( v_root_fsync_req  ),
      .v_2d_fsync_rsp_i  ( v_root_fsync_rsp  )
    );
  end else $fatal("Unsupported Mesh configuration");

/*******************************************************/
/**              FractalSync Network End              **/
/*******************************************************/

endmodule: magia