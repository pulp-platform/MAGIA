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

module magia 
  import magia_pkg::*;
  import magia_tile_pkg::*;
#(
  parameter int unsigned N_TILES_X     = magia_pkg::N_TILES_X,    // Number of Tile columns
  parameter int unsigned N_TILES_Y     = magia_pkg::N_TILES_Y,    // Number of Tile rowns
  parameter int unsigned N_TILES       = magia_pkg::N_TILES,      // Number of Tiles in the Mesh
  parameter int unsigned N_MEM_BANKS   = magia_pkg::N_MEM_BANKS,  // Number of TCDM banks (1 extra bank for missaligned accesses) per Tile
  parameter int unsigned N_WORDS_BANK  = magia_pkg::N_WORDS_BANK, // Number of words per TCDM bank

  parameter int unsigned TILE_FSYNC_W  = magia_pkg::TILE_FSYNC_W  // Width of the FractalSync level of the Tile - FS network link
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

  output logic                                  fencei_flush_req_o[N_TILES],
  input  logic                                  fencei_flush_ack_i[N_TILES],

  input  logic                                  debug_req_i,

  input  logic[magia_pkg::N_IRQ-1:0]            irq_i[N_TILES],

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
  
  magia_pkg::axi_default_req_t[N_TILES_X-1:0][N_TILES_Y-1:0] data_out_req;
  magia_pkg::axi_default_rsp_t[N_TILES_X-1:0][N_TILES_Y-1:0] data_out_rsp;

  magia_tile_pkg::axi_xbar_slv_req_t[N_TILES_X-1:0][N_TILES_Y-1:0] data_in_req;
  magia_tile_pkg::axi_xbar_slv_rsp_t[N_TILES_X-1:0][N_TILES_Y-1:0] data_in_rsp;

/*******************************************************/
/**          Internal Signal Definitions End          **/
/*******************************************************/
/**           Interface Definitions Beginning         **/
/*******************************************************/

  fractal_if #(.LVL_WIDTH(TILE_FSYNC_W)) sync_if[N_TILES]();

/*******************************************************/
/**             Interface Definitions End             **/
/*******************************************************/
/**            Hardwired Signals Beginning            **/
/*******************************************************/

  for (genvar i = 0; i < N_TILES; i++) begin: gen_mhartid
    assign mhartid[i] = i;
  end

/*******************************************************/
/**               Hardwired Signals End               **/
/*******************************************************/
/**               MAGIA Tiles Beginning               **/
/*******************************************************/

  for (genvar i = 0; i < N_TILES_X; i++) begin: gen_x_tile
    for (genvar j = 0; j < N_TILES_Y; j++) begin: gen_y_tile
      magia_tile #(
        .N_MEM_BANKS  ( N_MEM_BANKS   ),
        .N_WORDS_BANK ( N_WORDS_BANK  ),
  
        .CORE_ISA     (               ),
        .CORE_A       (               ),
        .CORE_B       (               ),
        .CORE_M       (               ),
        .ERROR_CAP    (               )
      ) i_magia_tile (
        .clk_i                                                    ,
        .rst_ni                                                   ,
        .test_mode_i                                              ,
        .tile_enable_i                                            ,
  
        .data_out_req_o      ( data_out_req[i][j]                ),
        .data_out_rsp_i      ( data_out_rsp[i][j]                ),
  
        .data_in_req_i       ( data_in_req[i][j]                 ),
        .data_in_rsp_o       ( data_in_rsp[i][j]                 ),
  
        .sync_if_o           ( sync_if[i*N_TILES_Y+j]            ),
        
        .scan_cg_en_i                                             ,
  
        .boot_addr_i                                              ,
        .mtvec_addr_i                                             ,
        .dm_halt_addr_i                                           ,
        .dm_exception_addr_i                                      ,
        .mhartid_i           ( mhartid[i*N_TILES_Y+j]            ),
        .mimpid_patch_i                                           ,
  
        .mcycle_o            ( mcycle_o[i*N_TILES_Y+j]           ),
        .time_i                                                   ,
  
        .irq_i               ( irq_i[i*N_TILES_Y+j]              ),
  
        .fencei_flush_req_o  ( fencei_flush_req_o[i*N_TILES_Y+j] ),
        .fencei_flush_ack_i  ( fencei_flush_ack_i[i*N_TILES_Y+j] ),
  
        .debug_req_i         ( debug_req_i                       ),
        .debug_havereset_o   ( debug_havereset_o[i*N_TILES_Y+j]  ),
        .debug_running_o     ( debug_running_o[i*N_TILES_Y+j]    ),
        .debug_halted_o      ( debug_halted_o[i*N_TILES_Y+j]     ),
        .debug_pc_valid_o    ( debug_pc_valid_o[i*N_TILES_Y+j]   ),
        .debug_pc_o          ( debug_pc_o[i*N_TILES_Y+j]         ),
  
        .fetch_enable_i                                           ,
        .core_sleep_o        ( core_sleep_o[i*N_TILES_Y+j]       ),
        .wu_wfe_i
      );
  `ifdef CORE_TRACES
      localparam string core_trace_file_name = $sformatf("%s%0d", "log_file_", i*N_TILES_Y+j);
      defparam i_magia_tile.i_cv32e40x_core.rvfi_i.tracer_i.LOGFILE_PATH_PLUSARG = core_trace_file_name;
  `endif
    end
  end

/*******************************************************/
/**                  MAGIA Tiles End                  **/
/*******************************************************/
/**                 Mesh NoC Beginning                **/
/*******************************************************/

  if ((N_TILES_X == 2) && (N_TILES_Y == 2)) begin: gen_2x2_noc
    floo_axi_mesh_2x2_noc i_mesh_noc (
      .clk_i                                       ,
      .rst_ni                                      ,
      .test_enable_i              ( test_mode_i   ),
      .magia_tile_data_slv_req_i  ( data_out_req  ),
      .magia_tile_data_slv_rsp_o  ( data_out_rsp  ),
      .magia_tile_data_mst_req_o  ( data_in_req   ),
      .magia_tile_data_mst_rsp_i  ( data_in_rsp   ),
      .L2_data_mst_req_o          ( l2_data_req_o ),
      .L2_data_mst_rsp_i          ( l2_data_rsp_i )
    );
  end else if ((N_TILES_X == 4) && (N_TILES_Y == 4)) begin: gen_4x4_noc
    floo_axi_mesh_4x4_noc i_mesh_noc (
      .clk_i                                       ,
      .rst_ni                                      ,
      .test_enable_i              ( test_mode_i   ),
      .magia_tile_data_slv_req_i  ( data_out_req  ),
      .magia_tile_data_slv_rsp_o  ( data_out_rsp  ),
      .magia_tile_data_mst_req_o  ( data_in_req   ),
      .magia_tile_data_mst_rsp_i  ( data_in_rsp   ),
      .L2_data_mst_req_o          ( l2_data_req_o ),
      .L2_data_mst_rsp_i          ( l2_data_rsp_i )
    );
  end else if ((N_TILES_X == 8) && (N_TILES_Y == 8)) begin: gen_8x8_noc
    floo_axi_mesh_8x8_noc i_mesh_noc (
      .clk_i                                       ,
      .rst_ni                                      ,
      .test_enable_i              ( test_mode_i   ),
      .magia_tile_data_slv_req_i  ( data_out_req  ),
      .magia_tile_data_slv_rsp_o  ( data_out_rsp  ),
      .magia_tile_data_mst_req_o  ( data_in_req   ),
      .magia_tile_data_mst_rsp_i  ( data_in_rsp   ),
      .L2_data_mst_req_o          ( l2_data_req_o ),
      .L2_data_mst_rsp_i          ( l2_data_rsp_i )
    );
  end else if ((N_TILES_X == 16) && (N_TILES_Y == 16)) begin: gen_16x16_noc
    floo_axi_mesh_16x16_noc i_mesh_noc (
      .clk_i                                       ,
      .rst_ni                                      ,
      .test_enable_i              ( test_mode_i   ),
      .magia_tile_data_slv_req_i  ( data_out_req  ),
      .magia_tile_data_slv_rsp_o  ( data_out_rsp  ),
      .magia_tile_data_mst_req_o  ( data_in_req   ),
      .magia_tile_data_mst_rsp_i  ( data_in_rsp   ),
      .L2_data_mst_req_o          ( l2_data_req_o ),
      .L2_data_mst_rsp_i          ( l2_data_rsp_i )
    );
  end else if ((N_TILES_X == 32) && (N_TILES_Y == 32)) begin: gen_32x32_noc
    floo_axi_mesh_32x32_noc i_mesh_noc (
      .clk_i                                       ,
      .rst_ni                                      ,
      .test_enable_i              ( test_mode_i   ),
      .magia_tile_data_slv_req_i  ( data_out_req  ),
      .magia_tile_data_slv_rsp_o  ( data_out_rsp  ),
      .magia_tile_data_mst_req_o  ( data_in_req   ),
      .magia_tile_data_mst_rsp_i  ( data_in_rsp   ),
      .L2_data_mst_req_o          ( l2_data_req_o ),
      .L2_data_mst_rsp_i          ( l2_data_rsp_i )
    );
  end else $fatal("Unsupported Mesh configuration");

/*******************************************************/
/**                    Mesh NoC End                    */
/*******************************************************/
/**           FractalSync Network Beginning           **/
/*******************************************************/

  // FSync Tree interfaces
  // Manually defining:
  // localparam int unsigned FSYNC_LVL_W    [FSYNC_LVL-1] = '{TILE_FSYNC_W-1, TILE_FSYNC_W-2, ...};
  // localparam int unsigned FSYNC_LVL_PORTS[FSYNC_LVL-1] = '{N_TILES/(2**1), N_TILES/(2**2), ...};
  // for (genvar i = 0; i < FSYNC_LVL-1; i++) fractal_if #(.LVL_WIDTH(FSYNC_LVL_W[i])) if_sync_tree_{i}[FSYNC_LVL_PORTS[i]]();

  if ((N_TILES_X == 2) && (N_TILES_Y == 2)) begin: gen_2x2_fsync
    localparam int unsigned FSYNC_LVL_W    [1] = '{2};
    localparam int unsigned FSYNC_LVL_PORTS[1] = '{2};
    fractal_if #(.LVL_WIDTH(FSYNC_LVL_W[0])) if_sync_tree_0[FSYNC_LVL_PORTS[0]]();
    
    logic monitor_error[1];
    localparam int unsigned FSYNC_MON_W = 1 ;
    fractal_if #(.LVL_WIDTH(FSYNC_MON_W)) if_fmon[1]();
    
    // LEVEL 1 - FSync Tree Tiles
    for (genvar i = 0; i < N_TILES/2; i++) begin: gen_cu_fsync
      fractal_sync #(
        .SLV_WIDTH  ( TILE_FSYNC_W )
      ) i_cu_fractal_sync (
        .clk_i                                       ,
        .rstn_i   ( rst_ni                          ),
        .slaves   ( '{sync_if[2*i], sync_if[2*i+1]} ),
        .masters  ( '{if_sync_tree_0[i]}            )
      );
    end

    // LEVEL 2 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[0]/2; i++) begin: gen_node_0_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[0] )
      ) i_node_0_fractal_sync (
        .clk_i                                                     ,
        .rstn_i   ( rst_ni                                        ),
        .slaves   ( '{if_sync_tree_0[2*i], if_sync_tree_0[2*i+1]} ),
        .masters  ( if_fmon                                       )
      );
    end

    // LEVEL 3 - FMonitor
    fractal_monitor #(
      .PORT_WIDTH( FSYNC_MON_W )
    ) i_top_fractal_sync_monitor (
      .clk_i                    ,
      .rstn_i  ( rst_ni        ),
      .ports   ( if_fmon       ),
      .error_o ( monitor_error )
    );
  end else if ((N_TILES_X == 4) && (N_TILES_Y == 4)) begin: gen_4x4_fsync
    localparam int unsigned FSYNC_LVL_W    [3] = '{4, 3, 2};
    localparam int unsigned FSYNC_LVL_PORTS[3] = '{8, 4, 2};
    fractal_if #(.LVL_WIDTH(FSYNC_LVL_W[0])) if_sync_tree_0[FSYNC_LVL_PORTS[0]]();
    fractal_if #(.LVL_WIDTH(FSYNC_LVL_W[1])) if_sync_tree_1[FSYNC_LVL_PORTS[1]]();
    fractal_if #(.LVL_WIDTH(FSYNC_LVL_W[2])) if_sync_tree_2[FSYNC_LVL_PORTS[2]]();
    
    logic monitor_error[1];
    localparam int unsigned FSYNC_MON_W = 1 ;
    fractal_if #(.LVL_WIDTH(FSYNC_MON_W)) if_fmon[1]();
    
    // LEVEL 1 - FSync Tree Tiles
    for (genvar i = 0; i < N_TILES/2; i++) begin: gen_cu_fsync
      fractal_sync #(
        .SLV_WIDTH  ( TILE_FSYNC_W )
      ) i_cu_fractal_sync (
        .clk_i                                       ,
        .rstn_i   ( rst_ni                          ),
        .slaves   ( '{sync_if[2*i], sync_if[2*i+1]} ),
        .masters  ( '{if_sync_tree_0[i]}            )
      );
    end

    // LEVEL 2 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[0]/2; i++) begin: gen_node_0_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[0] )
      ) i_node_0_fractal_sync (
        .clk_i                                                     ,
        .rstn_i   ( rst_ni                                        ),
        .slaves   ( '{if_sync_tree_0[2*i], if_sync_tree_0[2*i+1]} ),
        .masters  ( '{if_sync_tree_1[i]}                          )
      );
    end

    // LEVEL 3 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[1]/2; i++) begin: gen_node_1_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[1] )
      ) i_node_1_fractal_sync (
        .clk_i                                                     ,
        .rstn_i   ( rst_ni                                        ),
        .slaves   ( '{if_sync_tree_1[2*i], if_sync_tree_1[2*i+1]} ),
        .masters  ( '{if_sync_tree_2[i]}                          )
      );
    end

    // LEVEL 4 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[2]/2; i++) begin: gen_node_2_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[2] )
      ) i_node_2_fractal_sync (
        .clk_i                                                     ,
        .rstn_i   ( rst_ni                                        ),
        .slaves   ( '{if_sync_tree_2[2*i], if_sync_tree_2[2*i+1]} ),
        .masters  ( if_fmon                                       )
      );
    end

    // LEVEL 5 - FMonitor
    fractal_monitor #(
      .PORT_WIDTH( FSYNC_MON_W )
    ) i_top_fractal_sync_monitor (
      .clk_i                    ,
      .rstn_i  ( rst_ni        ),
      .ports   ( if_fmon       ),
      .error_o ( monitor_error )
    );
  end else if ((N_TILES_X == 8) && (N_TILES_Y == 8)) begin: gen_8x8_fsync
    localparam int unsigned FSYNC_LVL_W    [5] = '{6,  5,  4, 3, 2};
    localparam int unsigned FSYNC_LVL_PORTS[5] = '{32, 16, 8, 4, 2};
    fractal_if #(.LVL_WIDTH(FSYNC_LVL_W[0])) if_sync_tree_0[FSYNC_LVL_PORTS[0]]();
    fractal_if #(.LVL_WIDTH(FSYNC_LVL_W[1])) if_sync_tree_1[FSYNC_LVL_PORTS[1]]();
    fractal_if #(.LVL_WIDTH(FSYNC_LVL_W[2])) if_sync_tree_2[FSYNC_LVL_PORTS[2]]();
    fractal_if #(.LVL_WIDTH(FSYNC_LVL_W[3])) if_sync_tree_3[FSYNC_LVL_PORTS[3]]();
    fractal_if #(.LVL_WIDTH(FSYNC_LVL_W[4])) if_sync_tree_4[FSYNC_LVL_PORTS[4]]();
    
    logic monitor_error[1];
    localparam int unsigned FSYNC_MON_W = 1 ;
    fractal_if #(.LVL_WIDTH(FSYNC_MON_W)) if_fmon[1]();
    
    // LEVEL 1 - FSync Tree Tiles
    for (genvar i = 0; i < N_TILES/2; i++) begin: gen_cu_fsync
      fractal_sync #(
        .SLV_WIDTH  ( TILE_FSYNC_W )
      ) i_cu_fractal_sync (
        .clk_i                                       ,
        .rstn_i   ( rst_ni                          ),
        .slaves   ( '{sync_if[2*i], sync_if[2*i+1]} ),
        .masters  ( '{if_sync_tree_0[i]}            )
      );
    end

    // LEVEL 2 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[0]/2; i++) begin: gen_node_0_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[0] )
      ) i_node_0_fractal_sync (
        .clk_i                                                     ,
        .rstn_i   ( rst_ni                                        ),
        .slaves   ( '{if_sync_tree_0[2*i], if_sync_tree_0[2*i+1]} ),
        .masters  ( '{if_sync_tree_1[i]}                          )
      );
    end

    // LEVEL 3 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[1]/2; i++) begin: gen_node_1_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[1] )
      ) i_node_1_fractal_sync (
        .clk_i                                                     ,
        .rstn_i   ( rst_ni                                        ),
        .slaves   ( '{if_sync_tree_1[2*i], if_sync_tree_1[2*i+1]} ),
        .masters  ( '{if_sync_tree_2[i]}                          )
      );
    end

    // LEVEL 4 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[2]/2; i++) begin: gen_node_2_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[2] )
      ) i_node_2_fractal_sync (
        .clk_i                                                     ,
        .rstn_i   ( rst_ni                                        ),
        .slaves   ( '{if_sync_tree_2[2*i], if_sync_tree_2[2*i+1]} ),
        .masters  ( '{if_sync_tree_3[i]}                          )
      );
    end

    // LEVEL 5 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[3]/2; i++) begin: gen_node_3_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[3] )
      ) i_node_3_fractal_sync (
        .clk_i                                                     ,
        .rstn_i   ( rst_ni                                        ),
        .slaves   ( '{if_sync_tree_3[2*i], if_sync_tree_3[2*i+1]} ),
        .masters  ( '{if_sync_tree_4[i]}                          )
      );
    end

    // LEVEL 6 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[4]/2; i++) begin: gen_node_4_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[4] )
      ) i_node_4_fractal_sync (
        .clk_i                                                     ,
        .rstn_i   ( rst_ni                                        ),
        .slaves   ( '{if_sync_tree_4[2*i], if_sync_tree_4[2*i+1]} ),
        .masters  ( if_fmon                                       )
      );
    end

    // LEVEL 7 - FMonitor
    fractal_monitor #(
      .PORT_WIDTH( FSYNC_MON_W )
    ) i_top_fractal_sync_monitor (
      .clk_i                    ,
      .rstn_i  ( rst_ni        ),
      .ports   ( if_fmon       ),
      .error_o ( monitor_error )
    );
  end else if ((N_TILES_X == 16) && (N_TILES_Y == 16)) begin: gen_16x16_fsync
    localparam int unsigned FSYNC_LVL_W    [7] = '{8,   7,  6,  5,  4, 3, 2};
    localparam int unsigned FSYNC_LVL_PORTS[7] = '{128, 64, 32, 16, 8, 4, 2};
    fractal_if #(.LVL_WIDTH(FSYNC_LVL_W[0])) if_sync_tree_0[FSYNC_LVL_PORTS[0]]();
    fractal_if #(.LVL_WIDTH(FSYNC_LVL_W[1])) if_sync_tree_1[FSYNC_LVL_PORTS[1]]();
    fractal_if #(.LVL_WIDTH(FSYNC_LVL_W[2])) if_sync_tree_2[FSYNC_LVL_PORTS[2]]();
    fractal_if #(.LVL_WIDTH(FSYNC_LVL_W[3])) if_sync_tree_3[FSYNC_LVL_PORTS[3]]();
    fractal_if #(.LVL_WIDTH(FSYNC_LVL_W[4])) if_sync_tree_4[FSYNC_LVL_PORTS[4]]();
    fractal_if #(.LVL_WIDTH(FSYNC_LVL_W[5])) if_sync_tree_5[FSYNC_LVL_PORTS[5]]();
    fractal_if #(.LVL_WIDTH(FSYNC_LVL_W[6])) if_sync_tree_6[FSYNC_LVL_PORTS[6]]();
    
    logic monitor_error[1];
    localparam int unsigned FSYNC_MON_W = 1 ;
    fractal_if #(.LVL_WIDTH(FSYNC_MON_W)) if_fmon[1]();
    
    // LEVEL 1 - FSync Tree Tiles
    for (genvar i = 0; i < N_TILES/2; i++) begin: gen_cu_fsync
      fractal_sync #(
        .SLV_WIDTH  ( TILE_FSYNC_W )
      ) i_cu_fractal_sync (
        .clk_i                                       ,
        .rstn_i   ( rst_ni                          ),
        .slaves   ( '{sync_if[2*i], sync_if[2*i+1]} ),
        .masters  ( '{if_sync_tree_0[i]}            )
      );
    end

    // LEVEL 2 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[0]/2; i++) begin: gen_node_0_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[0] )
      ) i_node_0_fractal_sync (
        .clk_i                                                     ,
        .rstn_i   ( rst_ni                                        ),
        .slaves   ( '{if_sync_tree_0[2*i], if_sync_tree_0[2*i+1]} ),
        .masters  ( '{if_sync_tree_1[i]}                          )
      );
    end

    // LEVEL 3 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[1]/2; i++) begin: gen_node_1_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[1] )
      ) i_node_1_fractal_sync (
        .clk_i                                                     ,
        .rstn_i   ( rst_ni                                        ),
        .slaves   ( '{if_sync_tree_1[2*i], if_sync_tree_1[2*i+1]} ),
        .masters  ( '{if_sync_tree_2[i]}                          )
      );
    end

    // LEVEL 4 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[2]/2; i++) begin: gen_node_2_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[2] )
      ) i_node_2_fractal_sync (
        .clk_i                                                     ,
        .rstn_i   ( rst_ni                                        ),
        .slaves   ( '{if_sync_tree_2[2*i], if_sync_tree_2[2*i+1]} ),
        .masters  ( '{if_sync_tree_3[i]}                          )
      );
    end

    // LEVEL 5 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[3]/2; i++) begin: gen_node_3_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[3] )
      ) i_node_3_fractal_sync (
        .clk_i                                                     ,
        .rstn_i   ( rst_ni                                        ),
        .slaves   ( '{if_sync_tree_3[2*i], if_sync_tree_3[2*i+1]} ),
        .masters  ( '{if_sync_tree_4[i]}                          )
      );
    end

    // LEVEL 6 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[4]/2; i++) begin: gen_node_4_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[4] )
      ) i_node_4_fractal_sync (
        .clk_i                                                     ,
        .rstn_i   ( rst_ni                                        ),
        .slaves   ( '{if_sync_tree_4[2*i], if_sync_tree_4[2*i+1]} ),
        .masters  ( '{if_sync_tree_5[i]}                          )
      );
    end

    // LEVEL 7 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[5]/2; i++) begin: gen_node_5_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[5] )
      ) i_node_5_fractal_sync (
        .clk_i                                                     ,
        .rstn_i   ( rst_ni                                        ),
        .slaves   ( '{if_sync_tree_5[2*i], if_sync_tree_5[2*i+1]} ),
        .masters  ( '{if_sync_tree_6[i]}                          )
      );
    end

    // LEVEL 8 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[6]/2; i++) begin: gen_node_6_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[6] )
      ) i_node_6_fractal_sync (
        .clk_i                                                     ,
        .rstn_i   ( rst_ni                                        ),
        .slaves   ( '{if_sync_tree_6[2*i], if_sync_tree_6[2*i+1]} ),
        .masters  ( if_fmon                                       )
      );
    end

    // LEVEL 9 - FMonitor
    fractal_monitor #(
      .PORT_WIDTH( FSYNC_MON_W )
    ) i_top_fractal_sync_monitor (
      .clk_i                    ,
      .rstn_i  ( rst_ni        ),
      .ports   ( if_fmon       ),
      .error_o ( monitor_error )
    );
  end else if ((N_TILES_X == 32) && (N_TILES_Y == 32)) begin: gen_32x32_fsync
    localparam int unsigned FSYNC_LVL_W    [9] = '{10,  9,   8,   7,  6,  5,  4, 3, 2};
    localparam int unsigned FSYNC_LVL_PORTS[9] = '{512, 256, 128, 64, 32, 16, 8, 4, 2};
    fractal_if #(.LVL_WIDTH(FSYNC_LVL_W[0])) if_sync_tree_0[FSYNC_LVL_PORTS[0]]();
    fractal_if #(.LVL_WIDTH(FSYNC_LVL_W[1])) if_sync_tree_1[FSYNC_LVL_PORTS[1]]();
    fractal_if #(.LVL_WIDTH(FSYNC_LVL_W[2])) if_sync_tree_2[FSYNC_LVL_PORTS[2]]();
    fractal_if #(.LVL_WIDTH(FSYNC_LVL_W[3])) if_sync_tree_3[FSYNC_LVL_PORTS[3]]();
    fractal_if #(.LVL_WIDTH(FSYNC_LVL_W[4])) if_sync_tree_4[FSYNC_LVL_PORTS[4]]();
    fractal_if #(.LVL_WIDTH(FSYNC_LVL_W[5])) if_sync_tree_5[FSYNC_LVL_PORTS[5]]();
    fractal_if #(.LVL_WIDTH(FSYNC_LVL_W[6])) if_sync_tree_6[FSYNC_LVL_PORTS[6]]();
    fractal_if #(.LVL_WIDTH(FSYNC_LVL_W[7])) if_sync_tree_7[FSYNC_LVL_PORTS[7]]();
    fractal_if #(.LVL_WIDTH(FSYNC_LVL_W[8])) if_sync_tree_8[FSYNC_LVL_PORTS[8]]();
    
    logic monitor_error[1];
    localparam int unsigned FSYNC_MON_W = 1 ;
    fractal_if #(.LVL_WIDTH(FSYNC_MON_W)) if_fmon[1]();
    
    // LEVEL 1 - FSync Tree Tiles
    for (genvar i = 0; i < N_TILES/2; i++) begin: gen_cu_fsync
      fractal_sync #(
        .SLV_WIDTH  ( TILE_FSYNC_W )
      ) i_cu_fractal_sync (
        .clk_i                                       ,
        .rstn_i   ( rst_ni                          ),
        .slaves   ( '{sync_if[2*i], sync_if[2*i+1]} ),
        .masters  ( '{if_sync_tree_0[i]}            )
      );
    end

    // LEVEL 2 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[0]/2; i++) begin: gen_node_0_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[0] )
      ) i_node_0_fractal_sync (
        .clk_i                                                     ,
        .rstn_i   ( rst_ni                                        ),
        .slaves   ( '{if_sync_tree_0[2*i], if_sync_tree_0[2*i+1]} ),
        .masters  ( '{if_sync_tree_1[i]}                          )
      );
    end

    // LEVEL 3 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[1]/2; i++) begin: gen_node_1_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[1] )
      ) i_node_1_fractal_sync (
        .clk_i                                                     ,
        .rstn_i   ( rst_ni                                        ),
        .slaves   ( '{if_sync_tree_1[2*i], if_sync_tree_1[2*i+1]} ),
        .masters  ( '{if_sync_tree_2[i]}                          )
      );
    end

    // LEVEL 4 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[2]/2; i++) begin: gen_node_2_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[2] )
      ) i_node_2_fractal_sync (
        .clk_i                                                     ,
        .rstn_i   ( rst_ni                                        ),
        .slaves   ( '{if_sync_tree_2[2*i], if_sync_tree_2[2*i+1]} ),
        .masters  ( '{if_sync_tree_3[i]}                          )
      );
    end

    // LEVEL 5 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[3]/2; i++) begin: gen_node_3_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[3] )
      ) i_node_3_fractal_sync (
        .clk_i                                                     ,
        .rstn_i   ( rst_ni                                        ),
        .slaves   ( '{if_sync_tree_3[2*i], if_sync_tree_3[2*i+1]} ),
        .masters  ( '{if_sync_tree_4[i]}                          )
      );
    end

    // LEVEL 6 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[4]/2; i++) begin: gen_node_4_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[4] )
      ) i_node_4_fractal_sync (
        .clk_i                                                     ,
        .rstn_i   ( rst_ni                                        ),
        .slaves   ( '{if_sync_tree_4[2*i], if_sync_tree_4[2*i+1]} ),
        .masters  ( '{if_sync_tree_5[i]}                          )
      );
    end

    // LEVEL 7 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[5]/2; i++) begin: gen_node_5_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[5] )
      ) i_node_5_fractal_sync (
        .clk_i                                                     ,
        .rstn_i   ( rst_ni                                        ),
        .slaves   ( '{if_sync_tree_5[2*i], if_sync_tree_5[2*i+1]} ),
        .masters  ( '{if_sync_tree_6[i]}                          )
      );
    end

    // LEVEL 8 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[6]/2; i++) begin: gen_node_6_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[6] )
      ) i_node_6_fractal_sync (
        .clk_i                                                     ,
        .rstn_i   ( rst_ni                                        ),
        .slaves   ( '{if_sync_tree_6[2*i], if_sync_tree_6[2*i+1]} ),
        .masters  ( '{if_sync_tree_7[i]}                          )
      );
    end

    // LEVEL 9 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[7]/2; i++) begin: gen_node_7_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[7] )
      ) i_node_7_fractal_sync (
        .clk_i                                                     ,
        .rstn_i   ( rst_ni                                        ),
        .slaves   ( '{if_sync_tree_7[2*i], if_sync_tree_7[2*i+1]} ),
        .masters  ( '{if_sync_tree_8[i]}                          )
      );
    end

    // LEVEL 10 - FSync Tree Top
    for (genvar i = 0; i < FSYNC_LVL_PORTS[8]/2; i++) begin: gen_node_8_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[8] )
      ) i_node_8_fractal_sync (
        .clk_i                                                     ,
        .rstn_i   ( rst_ni                                        ),
        .slaves   ( '{if_sync_tree_8[2*i], if_sync_tree_8[2*i+1]} ),
        .masters  ( if_fmon                                       )
      );
    end

    // LEVEL 11 - FMonitor
    fractal_monitor #(
      .PORT_WIDTH( FSYNC_MON_W )
    ) i_top_fractal_sync_monitor (
      .clk_i                    ,
      .rstn_i  ( rst_ni        ),
      .ports   ( if_fmon       ),
      .error_o ( monitor_error )
    );
  end else $fatal("Unsupported Mesh configuration");

/*/// Elegant but causes QuestaSim crash

  // FSync Tree interfaces
  for (genvar i = 0; i < FSYNC_LVL-1; i++) begin: gen_fsync_if
    localparam int unsigned FSYNC_LVL_W     = TILE_FSYNC_W-(i+1);
    localparam int unsigned FSYNC_LVL_PORTS = N_TILES/(2**(i+1));
    fractal_if #(.LVL_WIDTH(FSYNC_LVL_W)) if_sync_tree[FSYNC_LVL_PORTS]();
  end
  
  logic monitor_error;
  localparam int unsigned FSYNC_MON_W = 1 ;
  fractal_if #(.LVL_WIDTH(FSYNC_MON_W)) if_fmon[1]();
  
  // LEVEL 1 - Tiles
  for (genvar i = 0; i < N_TILES/2; i++) begin: gen_cu_fsync
    fractal_sync #(
      .SLV_WIDTH  ( TILE_FSYNC_W )
    ) i_cu_fractal_sync (
      .clk_i                                          ,
      .rstn_i   ( rst_ni                             ),
      .slaves   ( '{sync_if[2*i], sync_if[2*i+1]}    ),
      .masters  ( '{gen_fsync_if[0].if_sync_tree[i]} )
    );
  end

  // LEVEL 2, 3, ..., N - FSync Tree
  for (genvar i = 0; i < FSYNC_LVL-1; i++) begin: gen_fsync_tree
    localparam int unsigned FSYNC_LVL_W     = TILE_FSYNC_W-(i+1);
    localparam int unsigned FSYNC_LVL_PORTS = N_TILES/(2**(i+1));
    for (genvar j = 0; j < FSYNC_LVL_PORTS/2; j++) begin: gen_node_fsync
      if (i != FSYNC_LVL-2) begin
        fractal_sync #(
          .SLV_WIDTH  ( FSYNC_LVL_W )
        ) i_node_fractal_sync (
          .clk_i                                                                                 ,
          .rstn_i   ( rst_ni                                                                    ),
          .slaves   ( '{gen_fsync_if[i].if_sync_tree[2*j], gen_fsync_if[i].if_sync_tree[2*j+1]} ),
          .masters  ( '{gen_fsync_if[i+1].if_sync_tree[j]}                                      )
        );
      end else begin
        fractal_sync #(
          .SLV_WIDTH  ( FSYNC_LVL_W )
        ) i_top_fractal_sync (
          .clk_i                                                                           ,
          .rstn_i   ( rst_ni                                                              ),
          .slaves   ( '{gen_fsync_if[i].if_sync_tree[0], gen_fsync_if[i].if_sync_tree[1]} ),
          .masters  ( if_fmon                                                             )
        );
      end
    end
  end

  // LEVEL N+1 - FMonitor
  fractal_monitor #(
    .PORT_WIDTH( FSYNC_MON_W )
  ) i_top_fractal_sync_monitor (
    .clk_i                    ,
    .rstn_i  ( rst_ni        ),
    .ports   ( if_fmon       ),
    .error_o ( monitor_error )
  );
*/
/*******************************************************/
/**              FractalSync Network End              **/
/*******************************************************/

endmodule: magia