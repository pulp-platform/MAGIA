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
 * MAGIA Verification IP
 */

 `include "axi/assign.svh"

module magia_vip
  import magia_tile_pkg::*;
  import magia_pkg::*;
  import magia_tile_tb_pkg::*;
  import magia_tb_pkg::*;
#(
  // Timing
  parameter time         CLK_PERIOD = 5ns,
  parameter int unsigned RST_CYCLES = 5,
  parameter real         T_APPL     = 0.1,
  parameter real         T_TEST     = 0.9
)(
  output logic                                                                                    clk,
  output logic                                                                                    rst_n,
  output logic                                                                                    test_mode,
  output logic                                                                                    tile_enable,

  input  magia_pkg::axi_default_req_t[magia_tb_pkg::N_TILES_X-1:0][magia_tb_pkg::N_TILES_Y-1:0]   data_out_req,
  output magia_pkg::axi_default_rsp_t[magia_tb_pkg::N_TILES_X-1:0][magia_tb_pkg::N_TILES_Y-1:0]   data_out_rsp,

  output magia_tb_pkg::axi_l2_vip_req_t[magia_tb_pkg::N_TILES_X-1:0][magia_tb_pkg::N_TILES_Y-1:0] data_in_req,
  input  magia_tb_pkg::axi_l2_vip_rsp_t[magia_tb_pkg::N_TILES_X-1:0][magia_tb_pkg::N_TILES_Y-1:0] data_in_rsp,

  fractal_if.slv_port                                                                             sync_if[magia_tb_pkg::N_TILES],

  output logic                                                                                    scan_cg_en,

  output logic[31:0]                                                                              boot_addr, //TODO: manage signal
  output logic[31:0]                                                                              mtvec_addr,
  output logic[31:0]                                                                              dm_halt_addr,
  output logic[31:0]                                                                              dm_exception_addr,
  output logic[31:0]                                                                              mhartid[magia_tb_pkg::N_TILES],
  output logic[ 3:0]                                                                              mimpid_patch,

  input  logic[63:0]                                                                              mcycle[magia_tb_pkg::N_TILES],
  output logic[63:0]                                                                              time_var,

  output logic[magia_pkg::N_IRQ-1:0]                                                              irq, //TODO: manage signal

  input  logic                                                                                    fencei_flush_req[magia_tb_pkg::N_TILES],
  output logic                                                                                    fencei_flush_ack,

  output logic                                                                                    debug_req,
  input  logic                                                                                    debug_havereset[magia_tb_pkg::N_TILES],
  input  logic                                                                                    debug_running[magia_tb_pkg::N_TILES],
  input  logic                                                                                    debug_halted[magia_tb_pkg::N_TILES],
  input  logic                                                                                    debug_pc_valid[magia_tb_pkg::N_TILES],
  input  logic[31:0]                                                                              debug_pc[magia_tb_pkg::N_TILES],

  output logic                                                                                    fetch_enable,  //TODO: manage signal
  input  logic                                                                                    core_sleep[magia_tb_pkg::N_TILES],
  output logic                                                                                    wu_wfe
);

/*******************************************************/
/**                   DPI Beginning                   **/
/*******************************************************/

//TODO

/*******************************************************/
/**                      DPI End                      **/
/*******************************************************/
/**       Internal Signal Definitions Beginning       **/
/*******************************************************/

  magia_tb_pkg::axi_l2_vip_req_t[magia_tb_pkg::N_TILES_X-1:0][magia_tb_pkg::N_TILES_Y-1:0] data_mst_req; // N_TILES + L2
  magia_tb_pkg::axi_l2_vip_rsp_t[magia_tb_pkg::N_TILES_X-1:0][magia_tb_pkg::N_TILES_Y-1:0] data_mst_rsp; // N_TILES + L2

  magia_tb_pkg::axi_l2_vip_req_t[magia_tb_pkg::N_TILES_Y-1:0] l2_data_mst_req;
  magia_tb_pkg::axi_l2_vip_rsp_t[magia_tb_pkg::N_TILES_Y-1:0] l2_data_mst_rsp;

/*******************************************************/
/**          Internal Signal Definitions End          **/
/*******************************************************/
/**          Interface Assignments Beginning          **/
/*******************************************************/

  generate
    for(genvar i=0; i<magia_tb_pkg::N_TILES_X; i++) begin
      for(genvar j=0; j<magia_tb_pkg::N_TILES_Y;j++) begin
        `AXI_ASSIGN_REQ_STRUCT(data_in_req[i][j], data_mst_req[i][j])
        `AXI_ASSIGN_RESP_STRUCT(data_mst_rsp[i][j], data_in_rsp[i][j])
      end
    end
  endgenerate

/*******************************************************/
/**             Interface Assignments End             **/
/*******************************************************/

  assign test_mode         = 1'b0;
  assign tile_enable       = 1'b1;
  assign scan_cg_en        = 1'b0;
  assign mtvec_addr        = '0;
  assign dm_halt_addr      = '0;
  assign dm_exception_addr = '0;
  for (genvar i = 0; i < magia_tb_pkg::N_TILES; i++) begin: gen_mhartid
    assign mhartid[i]      = i;
  end
  assign mimpid_patch      = '0;
  assign fencei_flush_ack  = 1'b0;
  assign debug_req         = 1'b0;
  assign wu_wfe            = 1'b0;

/*******************************************************/
/**               Hardwired Signals End               **/
/*******************************************************/
/**             Clock and Reset Beginning             **/
/*******************************************************/

  clk_rst_gen #(
    .ClkPeriod    ( CLK_PERIOD ),
    .RstClkCycles ( RST_CYCLES )
  ) i_clk_rst_sys (
    .clk_o  ( clk   ),
    .rst_no ( rst_n )
  );

/*******************************************************/
/**                Clock and Reset End                **/
/*******************************************************/
/**              TB Subroutines Beginning             **/
/*******************************************************/

  // Preload instruction cache subroutine
  task automatic inst_preload(input string image);
    $readmemh(image, i_l2_mem.mem);
  endtask: inst_preload

  // Preload data subroutine
  task automatic data_preload(input string image);
    $readmemh(image, i_l2_mem.mem);
  endtask: data_preload

  task wait_for_reset;
    @(posedge rst_n);
    @(posedge clk);
  endtask: wait_for_reset

  task automatic init(input bit[31:0] entry_addr);
    irq          = '0;
    fetch_enable = 1'b0;
    boot_addr    = entry_addr;
    #1000;
  endtask: init

  task automatic elf_run;
    fetch_enable = 1'b1;
    #1000;
  endtask: elf_run

  task automatic wait_for_eoc(output bit[magia_tb_pkg::N_TILES*16-1:0] exit_code);
    bit eoc = 1'b0;
    while (!eoc) begin
      eoc = 1'b1;
      for (int i = 0; i < magia_tb_pkg::N_TILES; i++)
        if ({i_l2_mem.mem[32'hCC03_0000 + (2*i + 1)], i_l2_mem.mem[32'hCC03_0000 + 2*i]} == 0)
          eoc = 1'b0;
      #10000;
    end
    
    for (int i = 0; i < magia_tb_pkg::N_TILES; i++)
      exit_code |= {i_l2_mem.mem[32'hCC03_0000 + (2*i + 1)], i_l2_mem.mem[32'hCC03_0000 + 2*i]} << i*16;
  endtask: wait_for_eoc

/*******************************************************/
/**                 TB Subroutines End                **/
/*******************************************************/
/**                  L2 MEM Beginning                 **/
/*******************************************************/

  axi_sim_mem #(
    .AddrWidth          ( magia_pkg::ADDR_W              ),
    .DataWidth          ( magia_pkg::DATA_W              ),
    .IdWidth            ( magia_tb_pkg::L2_ID_W          ),
    .UserWidth          ( magia_tb_pkg::L2_U_W           ),
    .NumPorts           ( magia_tb_pkg::N_TILES_Y        ),
    .axi_req_t          ( magia_tb_pkg::axi_l2_vip_req_t ),
    .axi_rsp_t          ( magia_tb_pkg::axi_l2_vip_rsp_t ),
    .WarnUninitialized  ( 1                              ),
    .ClearErrOnAccess   ( 1                              ),
    .ApplDelay          ( CLK_PERIOD * T_APPL            ),
    .AcqDelay           ( CLK_PERIOD * T_TEST            )
  ) i_l2_mem (
    .clk_i              ( clk             ),
    .rst_ni             ( rst_n           ),
    .axi_req_i          ( l2_data_mst_req ),
    .axi_rsp_o          ( l2_data_mst_rsp ),
    .mon_w_valid_o      (                 ),
    .mon_w_addr_o       (                 ),
    .mon_w_data_o       (                 ),
    .mon_w_id_o         (                 ),
    .mon_w_user_o       (                 ),
    .mon_w_beat_count_o (                 ),
    .mon_w_last_o       (                 ),
    .mon_r_valid_o      (                 ),
    .mon_r_addr_o       (                 ),
    .mon_r_data_o       (                 ),
    .mon_r_id_o         (                 ),
    .mon_r_user_o       (                 ),
    .mon_r_beat_count_o (                 ),
    .mon_r_last_o       (                 )
  );

/*******************************************************/
/**                     L2 MEM End                    **/
/*******************************************************/
/**           Tiles - L2 (FlooNoC) Beginning          **/
/*******************************************************/

  if ((magia_tb_pkg::N_TILES_X == 2) && (magia_tb_pkg::N_TILES_Y == 2)) begin: gen_2x2_noc
    floo_axi_mesh_2x2_noc i_mesh_noc (
      .clk_i                      ( clk             ),
      .rst_ni                     ( rst_n           ),
      .test_enable_i              ( 1'b0            ),
      .magia_tile_data_slv_req_i  ( data_out_req    ),
      .magia_tile_data_slv_rsp_o  ( data_out_rsp    ),
      .magia_tile_data_mst_req_o  ( data_mst_req    ),
      .magia_tile_data_mst_rsp_i  ( data_mst_rsp    ),
      .L2_data_mst_req_o          ( l2_data_mst_req ),
      .L2_data_mst_rsp_i          ( l2_data_mst_rsp )
    );
  end else if ((magia_tb_pkg::N_TILES_X == 4) && (magia_tb_pkg::N_TILES_Y == 4)) begin: gen_4x4_noc
    floo_axi_mesh_4x4_noc i_mesh_noc (
      .clk_i                      ( clk             ),
      .rst_ni                     ( rst_n           ),
      .test_enable_i              ( 1'b0            ),
      .magia_tile_data_slv_req_i  ( data_out_req    ),
      .magia_tile_data_slv_rsp_o  ( data_out_rsp    ),
      .magia_tile_data_mst_req_o  ( data_mst_req    ),
      .magia_tile_data_mst_rsp_i  ( data_mst_rsp    ),
      .L2_data_mst_req_o          ( l2_data_mst_req ),
      .L2_data_mst_rsp_i          ( l2_data_mst_rsp )
    );
  end else if ((magia_tb_pkg::N_TILES_X == 8) && (magia_tb_pkg::N_TILES_Y == 8)) begin: gen_8x8_noc
    floo_axi_mesh_8x8_noc i_mesh_noc (
      .clk_i                      ( clk             ),
      .rst_ni                     ( rst_n           ),
      .test_enable_i              ( 1'b0            ),
      .magia_tile_data_slv_req_i  ( data_out_req    ),
      .magia_tile_data_slv_rsp_o  ( data_out_rsp    ),
      .magia_tile_data_mst_req_o  ( data_mst_req    ),
      .magia_tile_data_mst_rsp_i  ( data_mst_rsp    ),
      .L2_data_mst_req_o          ( l2_data_mst_req ),
      .L2_data_mst_rsp_i          ( l2_data_mst_rsp )
    );
  end else if ((magia_tb_pkg::N_TILES_X == 16) && (magia_tb_pkg::N_TILES_Y == 16)) begin: gen_16x16_noc
    floo_axi_mesh_16x16_noc i_mesh_noc (
      .clk_i                      ( clk             ),
      .rst_ni                     ( rst_n           ),
      .test_enable_i              ( 1'b0            ),
      .magia_tile_data_slv_req_i  ( data_out_req    ),
      .magia_tile_data_slv_rsp_o  ( data_out_rsp    ),
      .magia_tile_data_mst_req_o  ( data_mst_req    ),
      .magia_tile_data_mst_rsp_i  ( data_mst_rsp    ),
      .L2_data_mst_req_o          ( l2_data_mst_req ),
      .L2_data_mst_rsp_i          ( l2_data_mst_rsp )
    );
  end else if ((magia_tb_pkg::N_TILES_X == 32) && (magia_tb_pkg::N_TILES_Y == 32)) begin: gen_32x32_noc
    floo_axi_mesh_32x32_noc i_mesh_noc (
      .clk_i                      ( clk             ),
      .rst_ni                     ( rst_n           ),
      .test_enable_i              ( 1'b0            ),
      .magia_tile_data_slv_req_i  ( data_out_req    ),
      .magia_tile_data_slv_rsp_o  ( data_out_rsp    ),
      .magia_tile_data_mst_req_o  ( data_mst_req    ),
      .magia_tile_data_mst_rsp_i  ( data_mst_rsp    ),
      .L2_data_mst_req_o          ( l2_data_mst_req ),
      .L2_data_mst_rsp_i          ( l2_data_mst_rsp )
    );
  end else $fatal("Unsupported Mesh configuration");

/*******************************************************/
/**              Tiles - L2 (FlooNoC) End              */
/*******************************************************/
/**         Synchronization Network Beginning         **/
/*******************************************************/

  // FSync Tree interfaces
  // Manually defining:
  // localparam int unsigned FSYNC_LVL_W    [magia_tb_pkg::FSYNC_LVL-1] = '{magia_tb_pkg::TILE_FSYNC_W-1, magia_tb_pkg::TILE_FSYNC_W-2, ...};
  // localparam int unsigned FSYNC_LVL_PORTS[magia_tb_pkg::FSYNC_LVL-1] = '{magia_tb_pkg::N_TILES/(2**1), magia_tb_pkg::N_TILES/(2**2), ...};
  // for (genvar i = 0; i < magia_tb_pkg::FSYNC_LVL-1; i++) fractal_if #(.LVL_WIDTH(FSYNC_LVL_W[i])) if_sync_tree_{i}[FSYNC_LVL_PORTS[i]]();

  if ((magia_tb_pkg::N_TILES_X == 2) && (magia_tb_pkg::N_TILES_Y == 2)) begin: gen_2x2_fsync
    localparam int unsigned FSYNC_LVL_W    [1] = '{2};
    localparam int unsigned FSYNC_LVL_PORTS[1] = '{2};
    fractal_if #(.LVL_WIDTH(FSYNC_LVL_W[0])) if_sync_tree_0[FSYNC_LVL_PORTS[0]]();
    
    logic monitor_error[1];
    localparam int unsigned FSYNC_MON_W = 1 ;
    fractal_if #(.LVL_WIDTH(FSYNC_MON_W)) if_fmon[1]();
    
    // LEVEL 1 - FSync Tree Tiles
    for (genvar i = 0; i < magia_tb_pkg::N_TILES/2; i++) begin: gen_cu_fsync
      fractal_sync #(
        .SLV_WIDTH  ( magia_tb_pkg::TILE_FSYNC_W )
      ) i_cu_fractal_sync (
        .clk_i    ( clk                             ),
        .rstn_i   ( rst_n                           ),
        .slaves   ( '{sync_if[2*i], sync_if[2*i+1]} ),
        .masters  ( '{if_sync_tree_0[i]}            )
      );
    end

    // LEVEL 2 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[0]/2; i++) begin: gen_node_0_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[0] )
      ) i_node_0_fractal_sync (
        .clk_i    ( clk                                           ),
        .rstn_i   ( rst_n                                         ),
        .slaves   ( '{if_sync_tree_0[2*i], if_sync_tree_0[2*i+1]} ),
        .masters  ( if_fmon                                       )
      );
    end

    // LEVEL 3 - FMonitor
    fractal_monitor #(
      .PORT_WIDTH( FSYNC_MON_W )
    ) i_top_fractal_sync_monitor (
      .clk_i   ( clk           ),
      .rstn_i  ( rstn          ),
      .ports   ( if_fmon       ),
      .error_o ( monitor_error )
    );
  end else if ((magia_tb_pkg::N_TILES_X == 4) && (magia_tb_pkg::N_TILES_Y == 4)) begin: gen_4x4_fsync
    localparam int unsigned FSYNC_LVL_W    [3] = '{4, 3, 2};
    localparam int unsigned FSYNC_LVL_PORTS[3] = '{8, 4, 2};
    fractal_if #(.LVL_WIDTH(FSYNC_LVL_W[0])) if_sync_tree_0[FSYNC_LVL_PORTS[0]]();
    fractal_if #(.LVL_WIDTH(FSYNC_LVL_W[1])) if_sync_tree_1[FSYNC_LVL_PORTS[1]]();
    fractal_if #(.LVL_WIDTH(FSYNC_LVL_W[2])) if_sync_tree_2[FSYNC_LVL_PORTS[2]]();
    
    logic monitor_error[1];
    localparam int unsigned FSYNC_MON_W = 1 ;
    fractal_if #(.LVL_WIDTH(FSYNC_MON_W)) if_fmon[1]();
    
    // LEVEL 1 - FSync Tree Tiles
    for (genvar i = 0; i < magia_tb_pkg::N_TILES/2; i++) begin: gen_cu_fsync
      fractal_sync #(
        .SLV_WIDTH  ( magia_tb_pkg::TILE_FSYNC_W )
      ) i_cu_fractal_sync (
        .clk_i    ( clk                             ),
        .rstn_i   ( rst_n                           ),
        .slaves   ( '{sync_if[2*i], sync_if[2*i+1]} ),
        .masters  ( '{if_sync_tree_0[i]}            )
      );
    end

    // LEVEL 2 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[0]/2; i++) begin: gen_node_0_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[0] )
      ) i_node_0_fractal_sync (
        .clk_i    ( clk                                           ),
        .rstn_i   ( rst_n                                         ),
        .slaves   ( '{if_sync_tree_0[2*i], if_sync_tree_0[2*i+1]} ),
        .masters  ( '{if_sync_tree_1[i]}                          )
      );
    end

    // LEVEL 3 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[1]/2; i++) begin: gen_node_1_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[1] )
      ) i_node_1_fractal_sync (
        .clk_i    ( clk                                           ),
        .rstn_i   ( rst_n                                         ),
        .slaves   ( '{if_sync_tree_1[2*i], if_sync_tree_1[2*i+1]} ),
        .masters  ( '{if_sync_tree_2[i]}                          )
      );
    end

    // LEVEL 4 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[2]/2; i++) begin: gen_node_2_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[2] )
      ) i_node_2_fractal_sync (
        .clk_i    ( clk                                           ),
        .rstn_i   ( rst_n                                         ),
        .slaves   ( '{if_sync_tree_2[2*i], if_sync_tree_2[2*i+1]} ),
        .masters  ( if_fmon                                       )
      );
    end

    // LEVEL 5 - FMonitor
    fractal_monitor #(
      .PORT_WIDTH( FSYNC_MON_W )
    ) i_top_fractal_sync_monitor (
      .clk_i   ( clk           ),
      .rstn_i  ( rstn          ),
      .ports   ( if_fmon       ),
      .error_o ( monitor_error )
    );
  end else if ((magia_tb_pkg::N_TILES_X == 8) && (magia_tb_pkg::N_TILES_Y == 8)) begin: gen_8x8_fsync
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
    for (genvar i = 0; i < magia_tb_pkg::N_TILES/2; i++) begin: gen_cu_fsync
      fractal_sync #(
        .SLV_WIDTH  ( magia_tb_pkg::TILE_FSYNC_W )
      ) i_cu_fractal_sync (
        .clk_i    ( clk                             ),
        .rstn_i   ( rst_n                           ),
        .slaves   ( '{sync_if[2*i], sync_if[2*i+1]} ),
        .masters  ( '{if_sync_tree_0[i]}            )
      );
    end

    // LEVEL 2 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[0]/2; i++) begin: gen_node_0_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[0] )
      ) i_node_0_fractal_sync (
        .clk_i    ( clk                                           ),
        .rstn_i   ( rst_n                                         ),
        .slaves   ( '{if_sync_tree_0[2*i], if_sync_tree_0[2*i+1]} ),
        .masters  ( '{if_sync_tree_1[i]}                          )
      );
    end

    // LEVEL 3 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[1]/2; i++) begin: gen_node_1_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[1] )
      ) i_node_1_fractal_sync (
        .clk_i    ( clk                                           ),
        .rstn_i   ( rst_n                                         ),
        .slaves   ( '{if_sync_tree_1[2*i], if_sync_tree_1[2*i+1]} ),
        .masters  ( '{if_sync_tree_2[i]}                          )
      );
    end

    // LEVEL 4 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[2]/2; i++) begin: gen_node_2_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[2] )
      ) i_node_2_fractal_sync (
        .clk_i    ( clk                                           ),
        .rstn_i   ( rst_n                                         ),
        .slaves   ( '{if_sync_tree_2[2*i], if_sync_tree_2[2*i+1]} ),
        .masters  ( '{if_sync_tree_3[i]}                          )
      );
    end

    // LEVEL 5 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[3]/2; i++) begin: gen_node_3_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[3] )
      ) i_node_3_fractal_sync (
        .clk_i    ( clk                                           ),
        .rstn_i   ( rst_n                                         ),
        .slaves   ( '{if_sync_tree_3[2*i], if_sync_tree_3[2*i+1]} ),
        .masters  ( '{if_sync_tree_4[i]}                          )
      );
    end

    // LEVEL 6 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[4]/2; i++) begin: gen_node_4_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[4] )
      ) i_node_4_fractal_sync (
        .clk_i    ( clk                                           ),
        .rstn_i   ( rst_n                                         ),
        .slaves   ( '{if_sync_tree_4[2*i], if_sync_tree_4[2*i+1]} ),
        .masters  ( if_fmon                                       )
      );
    end

    // LEVEL 7 - FMonitor
    fractal_monitor #(
      .PORT_WIDTH( FSYNC_MON_W )
    ) i_top_fractal_sync_monitor (
      .clk_i   ( clk           ),
      .rstn_i  ( rstn          ),
      .ports   ( if_fmon       ),
      .error_o ( monitor_error )
    );
  end else if ((magia_tb_pkg::N_TILES_X == 16) && (magia_tb_pkg::N_TILES_Y == 16)) begin: gen_16x16_fsync
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
    for (genvar i = 0; i < magia_tb_pkg::N_TILES/2; i++) begin: gen_cu_fsync
      fractal_sync #(
        .SLV_WIDTH  ( magia_tb_pkg::TILE_FSYNC_W )
      ) i_cu_fractal_sync (
        .clk_i    ( clk                             ),
        .rstn_i   ( rst_n                           ),
        .slaves   ( '{sync_if[2*i], sync_if[2*i+1]} ),
        .masters  ( '{if_sync_tree_0[i]}            )
      );
    end

    // LEVEL 2 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[0]/2; i++) begin: gen_node_0_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[0] )
      ) i_node_0_fractal_sync (
        .clk_i    ( clk                                           ),
        .rstn_i   ( rst_n                                         ),
        .slaves   ( '{if_sync_tree_0[2*i], if_sync_tree_0[2*i+1]} ),
        .masters  ( '{if_sync_tree_1[i]}                          )
      );
    end

    // LEVEL 3 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[1]/2; i++) begin: gen_node_1_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[1] )
      ) i_node_1_fractal_sync (
        .clk_i    ( clk                                           ),
        .rstn_i   ( rst_n                                         ),
        .slaves   ( '{if_sync_tree_1[2*i], if_sync_tree_1[2*i+1]} ),
        .masters  ( '{if_sync_tree_2[i]}                          )
      );
    end

    // LEVEL 4 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[2]/2; i++) begin: gen_node_2_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[2] )
      ) i_node_2_fractal_sync (
        .clk_i    ( clk                                           ),
        .rstn_i   ( rst_n                                         ),
        .slaves   ( '{if_sync_tree_2[2*i], if_sync_tree_2[2*i+1]} ),
        .masters  ( '{if_sync_tree_3[i]}                          )
      );
    end

    // LEVEL 5 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[3]/2; i++) begin: gen_node_3_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[3] )
      ) i_node_3_fractal_sync (
        .clk_i    ( clk                                           ),
        .rstn_i   ( rst_n                                         ),
        .slaves   ( '{if_sync_tree_3[2*i], if_sync_tree_3[2*i+1]} ),
        .masters  ( '{if_sync_tree_4[i]}                          )
      );
    end

    // LEVEL 6 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[4]/2; i++) begin: gen_node_4_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[4] )
      ) i_node_4_fractal_sync (
        .clk_i    ( clk                                           ),
        .rstn_i   ( rst_n                                         ),
        .slaves   ( '{if_sync_tree_4[2*i], if_sync_tree_4[2*i+1]} ),
        .masters  ( '{if_sync_tree_5[i]}                          )
      );
    end

    // LEVEL 7 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[5]/2; i++) begin: gen_node_5_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[5] )
      ) i_node_5_fractal_sync (
        .clk_i    ( clk                                           ),
        .rstn_i   ( rst_n                                         ),
        .slaves   ( '{if_sync_tree_5[2*i], if_sync_tree_5[2*i+1]} ),
        .masters  ( '{if_sync_tree_6[i]}                          )
      );
    end

    // LEVEL 8 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[6]/2; i++) begin: gen_node_6_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[6] )
      ) i_node_6_fractal_sync (
        .clk_i    ( clk                                           ),
        .rstn_i   ( rst_n                                         ),
        .slaves   ( '{if_sync_tree_6[2*i], if_sync_tree_6[2*i+1]} ),
        .masters  ( if_fmon                                       )
      );
    end

    // LEVEL 9 - FMonitor
    fractal_monitor #(
      .PORT_WIDTH( FSYNC_MON_W )
    ) i_top_fractal_sync_monitor (
      .clk_i   ( clk           ),
      .rstn_i  ( rstn          ),
      .ports   ( if_fmon       ),
      .error_o ( monitor_error )
    );
  end else if ((magia_tb_pkg::N_TILES_X == 32) && (magia_tb_pkg::N_TILES_Y == 32)) begin: gen_32x32_fsync
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
    for (genvar i = 0; i < magia_tb_pkg::N_TILES/2; i++) begin: gen_cu_fsync
      fractal_sync #(
        .SLV_WIDTH  ( magia_tb_pkg::TILE_FSYNC_W )
      ) i_cu_fractal_sync (
        .clk_i    ( clk                             ),
        .rstn_i   ( rst_n                           ),
        .slaves   ( '{sync_if[2*i], sync_if[2*i+1]} ),
        .masters  ( '{if_sync_tree_0[i]}            )
      );
    end

    // LEVEL 2 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[0]/2; i++) begin: gen_node_0_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[0] )
      ) i_node_0_fractal_sync (
        .clk_i    ( clk                                           ),
        .rstn_i   ( rst_n                                         ),
        .slaves   ( '{if_sync_tree_0[2*i], if_sync_tree_0[2*i+1]} ),
        .masters  ( '{if_sync_tree_1[i]}                          )
      );
    end

    // LEVEL 3 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[1]/2; i++) begin: gen_node_1_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[1] )
      ) i_node_1_fractal_sync (
        .clk_i    ( clk                                           ),
        .rstn_i   ( rst_n                                         ),
        .slaves   ( '{if_sync_tree_1[2*i], if_sync_tree_1[2*i+1]} ),
        .masters  ( '{if_sync_tree_2[i]}                          )
      );
    end

    // LEVEL 4 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[2]/2; i++) begin: gen_node_2_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[2] )
      ) i_node_2_fractal_sync (
        .clk_i    ( clk                                           ),
        .rstn_i   ( rst_n                                         ),
        .slaves   ( '{if_sync_tree_2[2*i], if_sync_tree_2[2*i+1]} ),
        .masters  ( '{if_sync_tree_3[i]}                          )
      );
    end

    // LEVEL 5 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[3]/2; i++) begin: gen_node_3_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[3] )
      ) i_node_3_fractal_sync (
        .clk_i    ( clk                                           ),
        .rstn_i   ( rst_n                                         ),
        .slaves   ( '{if_sync_tree_3[2*i], if_sync_tree_3[2*i+1]} ),
        .masters  ( '{if_sync_tree_4[i]}                          )
      );
    end

    // LEVEL 6 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[4]/2; i++) begin: gen_node_4_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[4] )
      ) i_node_4_fractal_sync (
        .clk_i    ( clk                                           ),
        .rstn_i   ( rst_n                                         ),
        .slaves   ( '{if_sync_tree_4[2*i], if_sync_tree_4[2*i+1]} ),
        .masters  ( '{if_sync_tree_5[i]}                          )
      );
    end

    // LEVEL 7 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[5]/2; i++) begin: gen_node_5_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[5] )
      ) i_node_5_fractal_sync (
        .clk_i    ( clk                                           ),
        .rstn_i   ( rst_n                                         ),
        .slaves   ( '{if_sync_tree_5[2*i], if_sync_tree_5[2*i+1]} ),
        .masters  ( '{if_sync_tree_6[i]}                          )
      );
    end

    // LEVEL 8 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[6]/2; i++) begin: gen_node_6_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[6] )
      ) i_node_6_fractal_sync (
        .clk_i    ( clk                                           ),
        .rstn_i   ( rst_n                                         ),
        .slaves   ( '{if_sync_tree_6[2*i], if_sync_tree_6[2*i+1]} ),
        .masters  ( '{if_sync_tree_7[i]}                          )
      );
    end

    // LEVEL 9 - FSync Tree
    for (genvar i = 0; i < FSYNC_LVL_PORTS[7]/2; i++) begin: gen_node_7_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[7] )
      ) i_node_7_fractal_sync (
        .clk_i    ( clk                                           ),
        .rstn_i   ( rst_n                                         ),
        .slaves   ( '{if_sync_tree_7[2*i], if_sync_tree_7[2*i+1]} ),
        .masters  ( '{if_sync_tree_8[i]}                          )
      );
    end

    // LEVEL 10 - FSync Tree Top
    for (genvar i = 0; i < FSYNC_LVL_PORTS[8]/2; i++) begin: gen_node_8_fsync
      fractal_sync #(
        .SLV_WIDTH  ( FSYNC_LVL_W[8] )
      ) i_node_8_fractal_sync (
        .clk_i    ( clk                                           ),
        .rstn_i   ( rst_n                                         ),
        .slaves   ( '{if_sync_tree_8[2*i], if_sync_tree_8[2*i+1]} ),
        .masters  ( if_fmon                                       )
      );
    end

    // LEVEL 11 - FMonitor
    fractal_monitor #(
      .PORT_WIDTH( FSYNC_MON_W )
    ) i_top_fractal_sync_monitor (
      .clk_i   ( clk           ),
      .rstn_i  ( rstn          ),
      .ports   ( if_fmon       ),
      .error_o ( monitor_error )
    );
  end else $fatal("Unsupported Mesh configuration");

/*/// Elegant but causes QuestaSim crash

  // FSync Tree interfaces
  for (genvar i = 0; i < magia_tb_pkg::FSYNC_LVL-1; i++) begin: gen_fsync_if
    localparam int unsigned FSYNC_LVL_W     = magia_tb_pkg::TILE_FSYNC_W-(i+1);
    localparam int unsigned FSYNC_LVL_PORTS = magia_tb_pkg::N_TILES/(2**(i+1));
    fractal_if #(.LVL_WIDTH(FSYNC_LVL_W)) if_sync_tree[FSYNC_LVL_PORTS]();
  end
  
  logic monitor_error;
  localparam int unsigned FSYNC_MON_W = 1 ;
  fractal_if #(.LVL_WIDTH(FSYNC_MON_W)) if_fmon[1]();
  
  // LEVEL 1 - Tiles
  for (genvar i = 0; i < magia_tb_pkg::N_TILES/2; i++) begin: gen_cu_fsync
    fractal_sync #(
      .SLV_WIDTH  ( magia_tb_pkg::TILE_FSYNC_W )
    ) i_cu_fractal_sync (
      .clk_i    ( clk                                ),
      .rstn_i   ( rst_n                              ),
      .slaves   ( '{sync_if[2*i], sync_if[2*i+1]}    ),
      .masters  ( '{gen_fsync_if[0].if_sync_tree[i]} )
    );
  end

  // LEVEL 2, 3, ..., N - FSync Tree
  for (genvar i = 0; i < magia_tb_pkg::FSYNC_LVL-1; i++) begin: gen_fsync_tree
    localparam int unsigned FSYNC_LVL_W     = magia_tb_pkg::TILE_FSYNC_W-(i+1);
    localparam int unsigned FSYNC_LVL_PORTS = magia_tb_pkg::N_TILES/(2**(i+1));
    for (genvar j = 0; j < FSYNC_LVL_PORTS/2; j++) begin: gen_node_fsync
      if (i != magia_tb_pkg::FSYNC_LVL-2) begin
        fractal_sync #(
          .SLV_WIDTH  ( FSYNC_LVL_W )
        ) i_node_fractal_sync (
          .clk_i    ( clk                                                                       ),
          .rstn_i   ( rst_n                                                                     ),
          .slaves   ( '{gen_fsync_if[i].if_sync_tree[2*j], gen_fsync_if[i].if_sync_tree[2*j+1]} ),
          .masters  ( '{gen_fsync_if[i+1].if_sync_tree[j]}                                      )
        );
      end else begin
        fractal_sync #(
          .SLV_WIDTH  ( FSYNC_LVL_W )
        ) i_top_fractal_sync (
          .clk_i    ( clk                                                                 ),
          .rstn_i   ( rst_n                                                               ),
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
    .clk_i   ( clk           ),
    .rstn_i  ( rstn          ),
    .ports   ( if_fmon       ),
    .error_o ( monitor_error )
  );

*/

/*******************************************************/
/**            Synchronization Network End            **/
/*******************************************************/
/**                 Printing Beginning                **/
/*******************************************************/

  for (genvar i = 0; i < magia_tb_pkg::N_TILES_X; i++) begin: gen_tile_print_x
    for (genvar j = 0; j < magia_tb_pkg::N_TILES_Y; j++) begin: gen_tile_print_y
      int errors = -1;
      bit stdio_ready  = 0;
      bit stderr_ready = 0;
      typedef struct packed {
        bit[31:0] data;
        bit[31:0] id;
      } string_char_t;
      bit print_line[2**magia_tb_pkg::L2_ID_W];
      string_char_t chars[$];
      bit[magia_tb_pkg::L2_ID_W-1:0] write_id;
      always @(posedge clk) begin: print_monitor
        if ((gen_x_tile[i].gen_y_tile[j].dut.i_axi_xbar.mst_ports_req_o[0].aw.addr == 32'hFFFF0000) && (gen_x_tile[i].gen_y_tile[j].dut.i_axi_xbar.mst_ports_req_o[0].aw_valid))
          stderr_ready = 1'b1;
        if ((gen_x_tile[i].gen_y_tile[j].dut.i_axi_xbar.mst_ports_req_o[0].aw.addr == 32'hFFFF0004+((i*magia_tb_pkg::N_TILES_Y+j)*4)) && (gen_x_tile[i].gen_y_tile[j].dut.i_axi_xbar.mst_ports_req_o[0].aw_valid)) begin
          stdio_ready  = 1'b1;
          write_id = gen_x_tile[i].gen_y_tile[j].dut.i_axi_xbar.mst_ports_req_o[0].aw.id;
        end
        if ((gen_x_tile[i].gen_y_tile[j].dut.i_axi_xbar.mst_ports_req_o[0].w_valid) && stderr_ready) begin
          errors       = gen_x_tile[i].gen_y_tile[j].dut.i_axi_xbar.mst_ports_req_o[0].w.data[7:0];
          stderr_ready = 1'b0;
        end
        if ((gen_x_tile[i].gen_y_tile[j].dut.i_axi_xbar.mst_ports_req_o[0].w_valid) && stdio_ready) begin
          if (gen_x_tile[i].gen_y_tile[j].dut.i_axi_xbar.mst_ports_req_o[0].w.data[7:0] == 10)  // ASCII code for new line (\n) is 10
            print_line[write_id] = 1'b1;
          chars.push_back('{gen_x_tile[i].gen_y_tile[j].dut.i_axi_xbar.mst_ports_req_o[0].w.data[7:0], write_id});
          stdio_ready = 1'b0;
        end
        for (int k = 0; k < 2**magia_tb_pkg::L2_ID_W; k++) begin
          if (print_line[k] == 1'b1) begin
            for (int j = 0; j < chars.size(); j++) begin
              if (chars[j].id == k) begin
                $write("%c", chars[j].data);
                chars.delete(j--);
              end
            end
            print_line[k] = 1'b0;
          end
        end
      end
    end
  end

/*******************************************************/
/**                    Printing End                   **/
/*******************************************************/
/**                  Timer Beginning                  **/
/*******************************************************/

  initial time_var = 0;

  always @(negedge clk) begin: timer
    time_var = time_var + CLK_PERIOD;
  end

/*******************************************************/
/**                     Timer End                     **/
/*******************************************************/
/**           Instruction Monitor Beginning           **/
/*******************************************************/

  bit[31:0] curr_instr_ex[magia_tb_pkg::N_TILES];
  bit[31:0] curr_instr_id[magia_tb_pkg::N_TILES];
  for (genvar i = 0; i < magia_tb_pkg::N_TILES_X; i++) begin: gen_tile_instr_monitor_x
    for (genvar j = 0; j < magia_tb_pkg::N_TILES_Y; j++) begin: gen_tile_instr_monitor_y 
      assign curr_instr_ex[i*magia_tb_pkg::N_TILES_Y+j] = gen_x_tile[i].gen_y_tile[j].dut.i_cv32e40x_core.core_i.id_stage_i.id_ex_pipe_o.instr.bus_resp.rdata;
      always @(curr_instr_ex[i*magia_tb_pkg::N_TILES_Y+j]) begin: instr_ex_reporter
        if (curr_instr_ex[i*magia_tb_pkg::N_TILES_Y+j] == 32'h50500013) 
          $display("[TB][mhartid %0d - Tile (%0d, %0d)] detected sentinel instruction in EX stage at time %0dns",i*magia_tb_pkg::N_TILES_Y+j , j, i, time_var);
        if (curr_instr_ex[i*magia_tb_pkg::N_TILES_Y+j] == 32'h0062A3AF) 
          $display("[TB][mhartid %0d - Tile (%0d, %0d)] detected AMO (sync) instruction at time %0dns",i*magia_tb_pkg::N_TILES_Y+j , j, i, time_var);
      end
      assign curr_instr_id[i*magia_tb_pkg::N_TILES_Y+j] = gen_x_tile[i].gen_y_tile[j].dut.i_cv32e40x_core.core_i.id_stage_i.if_id_pipe_i.instr.bus_resp.rdata;
      always @(curr_instr_id[i*magia_tb_pkg::N_TILES_Y+j]) begin: instr_id_reporter
        if (curr_instr_id[i*magia_tb_pkg::N_TILES_Y+j] == 32'h40400013) 
          $display("[TB][mhartid %0d - Tile (%0d, %0d)] detected sentinel instruction in ID stage at time %0dns",i*magia_tb_pkg::N_TILES_Y+j , j, i, time_var);
        if (curr_instr_id[i*magia_tb_pkg::N_TILES_Y+j] == 32'h0002A05B) 
          $display("[TB][mhartid %0d - Tile (%0d, %0d)] detected fsync instruction at time %0dns",i*magia_tb_pkg::N_TILES_Y+j , j, i, time_var);
      end
    end
  end

/*******************************************************/
/**              Instruction Monitor End              **/
/*******************************************************/

endmodule: magia_vip
