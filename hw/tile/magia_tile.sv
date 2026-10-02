/*
 * Copyright (C) 2023-2026 ETH Zurich and University of Bologna
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
 *          Luca Balboni <luca.balboni10@studio.unibo.it>
 *
 * MAGIA Tile: MAGIA Isle, FlooNoC network interface and router.
 */

`include "fractal_sync/assign.svh"

module magia_tile
  import magia_tile_pkg::*;
  import magia_pkg::*;
  import floo_pkg::*;
`ifndef TARGET_STANDALONE_TILE
  import magia_noc_pkg::*;
`else
  import floo_axi_nw_mesh_1x2_noc_pkg::*;
`endif
#(
  parameter magia_tile_pkg::magia_tile_cfg_t TileCfg = magia_tile_pkg::MagiaTileDefaultCfg
)(
  input  logic                                    clk_i,
  input  logic                                    rst_ni,
  input  logic                                    test_mode_i,
  input  logic                                    tile_enable_i,

  input  floo_req_t                               noc_south_req_i,
  output floo_rsp_t                               noc_south_rsp_o,
  input  floo_wide_t                              noc_south_wide_i,
  output floo_req_t                               noc_south_req_o,
  input  floo_rsp_t                               noc_south_rsp_i,
  output floo_wide_t                              noc_south_wide_o,

  input  floo_req_t                               noc_east_req_i,
  output floo_rsp_t                               noc_east_rsp_o,
  input  floo_wide_t                              noc_east_wide_i,
  output floo_req_t                               noc_east_req_o,
  input  floo_rsp_t                               noc_east_rsp_i,
  output floo_wide_t                              noc_east_wide_o,

  input  floo_req_t                               noc_north_req_i,
  output floo_rsp_t                               noc_north_rsp_o,
  input  floo_wide_t                              noc_north_wide_i,
  output floo_req_t                               noc_north_req_o,
  input  floo_rsp_t                               noc_north_rsp_i,
  output floo_wide_t                              noc_north_wide_o,

  input  floo_req_t                               noc_west_req_i,
  output floo_rsp_t                               noc_west_rsp_o,
  input  floo_wide_t                              noc_west_wide_i,
  output floo_req_t                               noc_west_req_o,
  input  floo_rsp_t                               noc_west_rsp_i,
  output floo_wide_t                              noc_west_wide_o,

  // Mesh coordinates of the router
  input  logic [31:0]                             x_id_i,
  input  logic [31:0]                             y_id_i,

`ifdef MAGIA_FSYNC
  output magia_tile_pkg::ht_tile_fsync_req_t      ht_fsync_req_o,
  input  magia_tile_pkg::ht_tile_fsync_rsp_t      ht_fsync_rsp_i,
  output magia_tile_pkg::hn_tile_fsync_req_t      hn_fsync_req_o,
  input  magia_tile_pkg::hn_tile_fsync_rsp_t      hn_fsync_rsp_i,
  output magia_tile_pkg::vt_tile_fsync_req_t      vt_fsync_req_o,
  input  magia_tile_pkg::vt_tile_fsync_rsp_t      vt_fsync_rsp_i,
  output magia_tile_pkg::vn_tile_fsync_req_t      vn_fsync_req_o,
  input  magia_tile_pkg::vn_tile_fsync_rsp_t      vn_fsync_rsp_i,
`endif

  input  logic                                    scan_cg_en_i,

  input  logic[31:0]                              boot_addr_i,
  input  logic[31:0]                              mtvec_addr_i,
  input  logic[31:0]                              dm_halt_addr_i,
  input  logic[31:0]                              dm_exception_addr_i,
  input  logic[31:0]                              mhartid_i,
  input  logic[ 3:0]                              mimpid_patch_i,

  output logic[63:0]                              mcycle_o,
  input  logic[63:0]                              time_i,

  input  logic[magia_pkg::N_IRQ-1:0]              irq_i,

  input  logic[magia_tile_pkg::N_CLUSTER_CORES:0] debug_req_i,
  output logic                                    debug_havereset_o,
  output logic                                    debug_running_o,
  output logic                                    debug_halted_o,
  output logic                                    debug_pc_valid_o,
  output logic[31:0]                              debug_pc_o,

  input  logic                                    fetch_enable_i,
  output logic                                    core_sleep_o,
  input  logic                                    wu_wfe_i
`ifdef VERILATOR
  , output magia_tile_observe_t                   observe_o
`endif
);

/*******************************************************/
/**                FractalSync Beginning              **/
/*******************************************************/

`ifdef MAGIA_FSYNC
  // The isle drives FractalSync interfaces, the tile boundary carries structs
  fractal_sync_if #(.AGGR_WIDTH(magia_tile_pkg::FSYNC_AGGR_W),     .LVL_WIDTH(magia_tile_pkg::FSYNC_LVL_W),     .ID_WIDTH(magia_tile_pkg::FSYNC_ID_W))     ht_fsync_if();
  fractal_sync_if #(.AGGR_WIDTH(magia_tile_pkg::FSYNC_NBR_AGGR_W), .LVL_WIDTH(magia_tile_pkg::FSYNC_NBR_LVL_W), .ID_WIDTH(magia_tile_pkg::FSYNC_NBR_ID_W)) hn_fsync_if();
  fractal_sync_if #(.AGGR_WIDTH(magia_tile_pkg::FSYNC_AGGR_W),     .LVL_WIDTH(magia_tile_pkg::FSYNC_LVL_W),     .ID_WIDTH(magia_tile_pkg::FSYNC_ID_W))     vt_fsync_if();
  fractal_sync_if #(.AGGR_WIDTH(magia_tile_pkg::FSYNC_NBR_AGGR_W), .LVL_WIDTH(magia_tile_pkg::FSYNC_NBR_LVL_W), .ID_WIDTH(magia_tile_pkg::FSYNC_NBR_ID_W)) vn_fsync_if();

  `FSYNC_ASSIGN_I2S_REQ(ht_fsync_if,    ht_fsync_req_o)
  `FSYNC_ASSIGN_S2I_RSP(ht_fsync_rsp_i, ht_fsync_if)
  `FSYNC_ASSIGN_I2S_REQ(hn_fsync_if,    hn_fsync_req_o)
  `FSYNC_ASSIGN_S2I_RSP(hn_fsync_rsp_i, hn_fsync_if)
  `FSYNC_ASSIGN_I2S_REQ(vt_fsync_if,    vt_fsync_req_o)
  `FSYNC_ASSIGN_S2I_RSP(vt_fsync_rsp_i, vt_fsync_if)
  `FSYNC_ASSIGN_I2S_REQ(vn_fsync_if,    vn_fsync_req_o)
  `FSYNC_ASSIGN_S2I_RSP(vn_fsync_rsp_i, vn_fsync_if)
`endif

/*******************************************************/
/**                  FractalSync End                  **/
/*******************************************************/
/**                MAGIA Isle Beginning               **/
/*******************************************************/

  magia_pkg::axi_xbar_mst_req_t      isle_narrow_mst_req;
  magia_pkg::axi_xbar_mst_rsp_t      isle_narrow_mst_rsp;
  magia_tile_pkg::axi_xbar_slv_req_t isle_narrow_slv_req;
  magia_tile_pkg::axi_xbar_slv_rsp_t isle_narrow_slv_rsp;
  magia_tile_pkg::idma_axi_req_t     isle_wide_mst_req;
  magia_tile_pkg::idma_axi_rsp_t     isle_wide_mst_rsp;
  magia_tile_pkg::idma_axi_req_t     isle_wide_slv_req;
  magia_tile_pkg::idma_axi_rsp_t     isle_wide_slv_rsp;

  magia_isle #(
    .TileCfg ( TileCfg )
  ) i_magia_isle (
    .clk_i                                    ,
    .rst_ni                                   ,
    .test_mode_i                              ,
    .tile_enable_i                            ,

    .axi_narrow_mst_req_o ( isle_narrow_mst_req ),
    .axi_narrow_mst_rsp_i ( isle_narrow_mst_rsp ),
    .axi_narrow_slv_req_i ( isle_narrow_slv_req ),
    .axi_narrow_slv_rsp_o ( isle_narrow_slv_rsp ),
    .axi_wide_mst_req_o   ( isle_wide_mst_req   ),
    .axi_wide_mst_rsp_i   ( isle_wide_mst_rsp   ),
    .axi_wide_slv_req_i   ( isle_wide_slv_req   ),
    .axi_wide_slv_rsp_o   ( isle_wide_slv_rsp   ),

`ifdef MAGIA_FSYNC
    .ht_fsync_if_o        ( ht_fsync_if         ),
    .hn_fsync_if_o        ( hn_fsync_if         ),
    .vt_fsync_if_o        ( vt_fsync_if         ),
    .vn_fsync_if_o        ( vn_fsync_if         ),
`endif

    .mhartid_i                                ,
    .boot_addr_i                              ,
    .mcycle_o                                 ,
    // No external interrupt controller in the mesh
    .eu_irq_req_o         (                     ),
    .eu_irq_id_o          (                     ),
    .eu_irq_ack_i         ( 1'b0                ),
    .eu_irq_ack_id_i      ( '0                  ),
    .debug_req_i                              ,
    .debug_havereset_o                        ,
    .debug_running_o                          ,
    .debug_halted_o                           ,
    .debug_pc_valid_o                         ,
    .debug_pc_o                               ,
    .fetch_enable_i                           ,
    .core_sleep_o
`ifdef CV32E40X
    , .scan_cg_en_i                           ,
    .mtvec_addr_i                             ,
    .dm_halt_addr_i                           ,
    .dm_exception_addr_i                      ,
    .mimpid_patch_i                           ,
    .time_i                                   ,
    .wu_wfe_i
`endif
`ifdef VERILATOR
    , .observe_o
`endif
  );

/*******************************************************/
/**                   MAGIA Isle End                  **/
/*******************************************************/
/**             NoC Clock Gating Beginning            **/
/*******************************************************/

  // Same enable as the isle system clock
  logic noc_clk_en;
  logic noc_clk;

  always_ff @(posedge clk_i, negedge rst_ni) begin: noc_clk_en_ff
    if (~rst_ni) noc_clk_en <= 1'b0;
    else         noc_clk_en <= tile_enable_i;
  end

  tc_clk_gating noc_clock_gating (
    .clk_i                    ,
    .en_i      ( noc_clk_en  ),
    .test_en_i ( test_mode_i ),
    .clk_o     ( noc_clk     )
  );

/*******************************************************/
/**                NoC Clock Gating End               **/
/*******************************************************/
/**             Network Interface Beginning           **/
/*******************************************************/

  id_t floo_id;

  assign floo_id = '{x: x_id_i, y: y_id_i, port_id: 0};

  // Router port 4 is the local port
  floo_req_t  [4:0] floo_router_req_in;
  floo_rsp_t  [4:0] floo_router_rsp_in;
  floo_wide_t [4:0] floo_router_wide_in;
  floo_req_t  [4:0] floo_router_req_out;
  floo_rsp_t  [4:0] floo_router_rsp_out;
  floo_wide_t [4:0] floo_router_wide_out;

  floo_nw_chimney #(
    .AxiCfgN              ( AxiCfgN                                  ),
    .AxiCfgW              ( AxiCfgW                                  ),
    .ChimneyCfgN          ( set_ports(ChimneyDefaultCfg, 1'b1, 1'b1) ),
    .ChimneyCfgW          ( set_ports(ChimneyDefaultCfg, 1'b1, 1'b1) ),
    .RouteCfg             ( RouteCfg                                 ),
    .id_t                 ( id_t                                     ),
    .rob_idx_t            ( rob_idx_t                                ),
    .hdr_t                ( hdr_t                                    ),
`ifndef TARGET_STANDALONE_TILE
    .sam_rule_t           ( collective_sam_rule_t                    ),
    .sam_idx_t            ( collective_idx_t                         ),
    .mask_sel_t           ( collective_mask_sel_t                    ),
    .Sam                  ( CollectiveSam                            ),
`else
    .sam_rule_t           ( sam_rule_t                               ),
    .Sam                  ( Sam                                      ),
`endif
    .user_wide_struct_t   ( axi_wide_data_slv_user_t                 ),
    .user_narrow_struct_t ( axi_narrow_data_slv_user_t               ),
    .axi_narrow_in_req_t  ( axi_narrow_data_slv_req_t                ),
    .axi_narrow_in_rsp_t  ( axi_narrow_data_slv_rsp_t                ),
    .axi_narrow_out_req_t ( axi_narrow_data_mst_req_t                ),
    .axi_narrow_out_rsp_t ( axi_narrow_data_mst_rsp_t                ),
    .axi_wide_in_req_t    ( axi_wide_data_slv_req_t                  ),
    .axi_wide_in_rsp_t    ( axi_wide_data_slv_rsp_t                  ),
    .axi_wide_out_req_t   ( axi_wide_data_mst_req_t                  ),
    .axi_wide_out_rsp_t   ( axi_wide_data_mst_rsp_t                  ),
    .floo_req_t           ( floo_req_t                               ),
    .floo_rsp_t           ( floo_rsp_t                               ),
    .floo_wide_t          ( floo_wide_t                              )
  ) i_magia_tile_ni (
    .clk_i                ( noc_clk                 ),
    .rst_ni               ( rst_ni                  ),
    .test_enable_i        ( test_mode_i             ),
    .sram_cfg_i           ( '0                      ),
    .axi_narrow_in_req_i  ( isle_narrow_mst_req     ),
    .axi_narrow_in_rsp_o  ( isle_narrow_mst_rsp     ),
    .axi_narrow_out_req_o ( isle_narrow_slv_req     ),
    .axi_narrow_out_rsp_i ( isle_narrow_slv_rsp     ),
    .axi_wide_in_req_i    ( isle_wide_mst_req       ),
    .axi_wide_in_rsp_o    ( isle_wide_mst_rsp       ),
    .axi_wide_out_req_o   ( isle_wide_slv_req       ),
    .axi_wide_out_rsp_i   ( isle_wide_slv_rsp       ),
    .id_i                 ( floo_id                 ),
    .route_table_i        ( '0                      ),
    .floo_req_o           ( floo_router_req_in[4]   ),
    .floo_rsp_i           ( floo_router_rsp_out[4]  ),
    .floo_wide_o          ( floo_router_wide_in[4]  ),
    .floo_req_i           ( floo_router_req_out[4]  ),
    .floo_rsp_o           ( floo_router_rsp_in[4]   ),
    .floo_wide_i          ( floo_router_wide_out[4] )
  );

/*******************************************************/
/**                Network Interface End              **/
/*******************************************************/
/**                  Router Beginning                 **/
/*******************************************************/

  // Narrow reductions run on a local ALU, wide ones are not offloaded
  red_wide_req_t   offload_wide_req;
  red_wide_rsp_t   offload_wide_rsp;
  red_narrow_req_t offload_narrow_req;
  red_narrow_rsp_t offload_narrow_rsp;
  logic[63:0]      narrow_alu_result;

  floo_reduction_alu i_narrow_floo_alu (
    .clk_i            ( noc_clk                                        ),
    .rst_ni           ( rst_ni                                         ),
    .flush_i          ( 1'b0                                           ),
    .alu_req_op1_i    ( {{32{1'b0}}, offload_narrow_req.req.operand1} ),
    .alu_req_op2_i    ( {{32{1'b0}}, offload_narrow_req.req.operand2} ),
    .alu_req_type_i   ( offload_narrow_req.req.op                      ),
    .alu_req_valid_i  ( offload_narrow_req.valid                       ),
    .alu_req_ready_o  ( offload_narrow_rsp.ready                       ),
    .alu_resp_data_o  ( narrow_alu_result                              ),
    .alu_resp_valid_o ( offload_narrow_rsp.valid                       ),
    .alu_resp_ready_i ( offload_narrow_req.ready                       )
  );

  assign offload_narrow_rsp.rsp.result = narrow_alu_result[31:0];

  floo_nw_router #(
    .AxiCfgN          ( AxiCfgN                ),
    .AxiCfgW          ( AxiCfgW                ),
    .RouteAlgo        ( XYRouting              ),
    .NumRoutes        ( 5                      ),
    .NumInputs        ( 5                      ),
    .NumOutputs       ( 5                      ),
    .InFifoDepth      ( 2                      ),
    .OutFifoDepth     ( 2                      ),
    .NoLoopback       ( 1'b0                   ),
    .CollectiveCfg    ( RouteCfg.CollectiveCfg ),
    .id_t             ( id_t                   ),
    .hdr_t            ( hdr_t                  ),
    .floo_req_t       ( floo_req_t             ),
    .floo_rsp_t       ( floo_rsp_t             ),
    .floo_wide_t      ( floo_wide_t            ),
    .red_wide_req_t   ( red_wide_req_t         ),
    .red_wide_rsp_t   ( red_wide_rsp_t         ),
    .red_narrow_req_t ( red_narrow_req_t       ),
    .red_narrow_rsp_t ( red_narrow_rsp_t       )
  ) i_magia_tile_router (
    .clk_i                ( noc_clk              ),
    .rst_ni               ( rst_ni               ),
    .test_enable_i        ( test_mode_i          ),
    .id_i                 ( floo_id              ),
    .id_route_map_i       ( '0                   ),
    .floo_req_i           ( floo_router_req_in   ),
    .floo_rsp_o           ( floo_router_rsp_out  ),
    .floo_req_o           ( floo_router_req_out  ),
    .floo_rsp_i           ( floo_router_rsp_in   ),
    .floo_wide_i          ( floo_router_wide_in  ),
    .floo_wide_o          ( floo_router_wide_out ),
    .offload_wide_req_o   ( offload_wide_req     ),
    .offload_wide_rsp_i   ( offload_wide_rsp     ),
    .offload_narrow_req_o ( offload_narrow_req   ),
    .offload_narrow_rsp_i ( offload_narrow_rsp   )
  );

  // Router ports: 0 south, 1 east, 2 north, 3 west
  assign noc_south_req_o        = floo_router_req_out[0];
  assign floo_router_rsp_in[0]  = noc_south_rsp_i;
  assign noc_south_wide_o       = floo_router_wide_out[0];
  assign floo_router_req_in[0]  = noc_south_req_i;
  assign noc_south_rsp_o        = floo_router_rsp_out[0];
  assign floo_router_wide_in[0] = noc_south_wide_i;

  assign noc_east_req_o         = floo_router_req_out[1];
  assign floo_router_rsp_in[1]  = noc_east_rsp_i;
  assign noc_east_wide_o        = floo_router_wide_out[1];
  assign floo_router_req_in[1]  = noc_east_req_i;
  assign noc_east_rsp_o         = floo_router_rsp_out[1];
  assign floo_router_wide_in[1] = noc_east_wide_i;

  assign noc_north_req_o        = floo_router_req_out[2];
  assign floo_router_rsp_in[2]  = noc_north_rsp_i;
  assign noc_north_wide_o       = floo_router_wide_out[2];
  assign floo_router_req_in[2]  = noc_north_req_i;
  assign noc_north_rsp_o        = floo_router_rsp_out[2];
  assign floo_router_wide_in[2] = noc_north_wide_i;

  assign noc_west_req_o         = floo_router_req_out[3];
  assign floo_router_rsp_in[3]  = noc_west_rsp_i;
  assign noc_west_wide_o        = floo_router_wide_out[3];
  assign floo_router_req_in[3]  = noc_west_req_i;
  assign noc_west_rsp_o         = floo_router_rsp_out[3];
  assign floo_router_wide_in[3] = noc_west_wide_i;

/*******************************************************/
/**                     Router End                    **/
/*******************************************************/

endmodule: magia_tile
