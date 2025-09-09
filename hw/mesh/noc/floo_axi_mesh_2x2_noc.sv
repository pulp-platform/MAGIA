// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// AUTOMATICALLY GENERATED! DO NOT EDIT!

`include "axi/typedef.svh"
`include "floo_noc/typedef.svh"

package floo_axi_mesh_2x2_noc_pkg;

  import floo_pkg::*;

  /////////////////////
  //   Address Map   //
  /////////////////////

  typedef enum logic[2:0] {
    MagiaTileX0Y0 = 0,
    MagiaTileX0Y1 = 1,
    MagiaTileX1Y0 = 2,
    MagiaTileX1Y1 = 3,
    L20 = 4,
    L21 = 5,
    NumEndpoints = 6} ep_id_e;



  typedef logic[0:0] rob_idx_t;
typedef logic[0:0] port_id_t;
typedef logic[1:0] x_bits_t;
typedef logic[0:0] y_bits_t;
typedef struct packed {
    x_bits_t x;
    y_bits_t y;
    port_id_t port_id;
} id_t;

typedef logic route_t;


  localparam int unsigned SamNumRules = 6;

typedef struct packed {
    id_t idx;
    logic [31:0] start_addr;
    logic [31:0] end_addr;
} sam_rule_t;

localparam sam_rule_t[SamNumRules-1:0] Sam = '{
'{idx: '{x: 0, y: 1, port_id: 0}, start_addr: 32'he0000000, end_addr: 32'h100000000},// L2_1_sam_idx
'{idx: '{x: 0, y: 0, port_id: 0}, start_addr: 32'hc0000000, end_addr: 32'he0000000},// L2_0_sam_idx
'{idx: '{x: 2, y: 1, port_id: 0}, start_addr: 32'h00300000, end_addr: 32'h00400000},// magia_tile_x1_y1_sam_idx
'{idx: '{x: 1, y: 1, port_id: 0}, start_addr: 32'h00200000, end_addr: 32'h00300000},// magia_tile_x0_y1_sam_idx
'{idx: '{x: 2, y: 0, port_id: 0}, start_addr: 32'h00100000, end_addr: 32'h00200000},// magia_tile_x1_y0_sam_idx
'{idx: '{x: 1, y: 0, port_id: 0}, start_addr: 32'h00000000, end_addr: 32'h00100000} // magia_tile_x0_y0_sam_idx

};



  localparam route_cfg_t RouteCfg = '{    RouteAlgo: XYRouting,
    UseIdTable: 1'b1,
    XYAddrOffsetX: 32,
    XYAddrOffsetY: 34,
    IdAddrOffset: 0,
    NumSamRules: 6,
    NumRoutes: 0};


  typedef logic[31:0] axi_data_mst_addr_t;
typedef logic[31:0] axi_data_mst_data_t;
typedef logic[3:0] axi_data_mst_strb_t;
typedef logic[1:0] axi_data_mst_id_t;
typedef logic[0:0] axi_data_mst_user_t;
`AXI_TYPEDEF_ALL_CT(axi_data_mst,             axi_data_mst_req_t,             axi_data_mst_rsp_t,             axi_data_mst_addr_t,             axi_data_mst_id_t,             axi_data_mst_data_t,             axi_data_mst_strb_t,             axi_data_mst_user_t)


  typedef logic[31:0] axi_data_slv_addr_t;
typedef logic[31:0] axi_data_slv_data_t;
typedef logic[3:0] axi_data_slv_strb_t;
typedef logic[3:0] axi_data_slv_id_t;
typedef logic[0:0] axi_data_slv_user_t;
`AXI_TYPEDEF_ALL_CT(axi_data_slv,             axi_data_slv_req_t,             axi_data_slv_rsp_t,             axi_data_slv_addr_t,             axi_data_slv_id_t,             axi_data_slv_data_t,             axi_data_slv_strb_t,             axi_data_slv_user_t)



  `FLOO_TYPEDEF_HDR_T(hdr_t, id_t, id_t, axi_ch_e, rob_idx_t)
  localparam axi_cfg_t AxiCfg = '{    AddrWidth: 32,
    DataWidth: 32,
    UserWidth: 1,
    InIdWidth: 4,
    OutIdWidth: 2};
`FLOO_TYPEDEF_AXI_CHAN_ALL(axi, req, rsp, axi_data_slv, AxiCfg, hdr_t)

`FLOO_TYPEDEF_AXI_LINK_ALL(req, rsp, req, rsp)


endpackage

module floo_axi_mesh_2x2_noc
  import floo_pkg::*;
  import floo_axi_mesh_2x2_noc_pkg::*;
(
  input logic clk_i,
  input logic rst_ni,
  input logic test_enable_i,
  input axi_data_slv_req_t             [1:0][1:0] magia_tile_data_slv_req_i,
  output axi_data_slv_rsp_t             [1:0][1:0] magia_tile_data_slv_rsp_o,
  output axi_data_mst_req_t             [1:0][1:0] magia_tile_data_mst_req_o,
  input axi_data_mst_rsp_t             [1:0][1:0] magia_tile_data_mst_rsp_i,
  output axi_data_mst_req_t             [1:0] L2_data_mst_req_o,
  input axi_data_mst_rsp_t             [1:0] L2_data_mst_rsp_i

);

floo_req_t router_0_0_to_router_0_1_req;
floo_rsp_t router_0_1_to_router_0_0_rsp;

floo_req_t router_0_0_to_router_1_0_req;
floo_rsp_t router_1_0_to_router_0_0_rsp;

floo_req_t router_0_0_to_magia_tile_ni_0_0_req;
floo_rsp_t magia_tile_ni_0_0_to_router_0_0_rsp;

floo_req_t router_0_0_to_L2_ni_0_req;
floo_rsp_t L2_ni_0_to_router_0_0_rsp;

floo_req_t router_0_1_to_router_0_0_req;
floo_rsp_t router_0_0_to_router_0_1_rsp;

floo_req_t router_0_1_to_router_1_1_req;
floo_rsp_t router_1_1_to_router_0_1_rsp;

floo_req_t router_0_1_to_magia_tile_ni_0_1_req;
floo_rsp_t magia_tile_ni_0_1_to_router_0_1_rsp;

floo_req_t router_0_1_to_L2_ni_1_req;
floo_rsp_t L2_ni_1_to_router_0_1_rsp;

floo_req_t router_1_0_to_router_0_0_req;
floo_rsp_t router_0_0_to_router_1_0_rsp;

floo_req_t router_1_0_to_router_1_1_req;
floo_rsp_t router_1_1_to_router_1_0_rsp;

floo_req_t router_1_0_to_magia_tile_ni_1_0_req;
floo_rsp_t magia_tile_ni_1_0_to_router_1_0_rsp;

floo_req_t router_1_1_to_router_0_1_req;
floo_rsp_t router_0_1_to_router_1_1_rsp;

floo_req_t router_1_1_to_router_1_0_req;
floo_rsp_t router_1_0_to_router_1_1_rsp;

floo_req_t router_1_1_to_magia_tile_ni_1_1_req;
floo_rsp_t magia_tile_ni_1_1_to_router_1_1_rsp;

floo_req_t magia_tile_ni_0_0_to_router_0_0_req;
floo_rsp_t router_0_0_to_magia_tile_ni_0_0_rsp;

floo_req_t magia_tile_ni_0_1_to_router_0_1_req;
floo_rsp_t router_0_1_to_magia_tile_ni_0_1_rsp;

floo_req_t magia_tile_ni_1_0_to_router_1_0_req;
floo_rsp_t router_1_0_to_magia_tile_ni_1_0_rsp;

floo_req_t magia_tile_ni_1_1_to_router_1_1_req;
floo_rsp_t router_1_1_to_magia_tile_ni_1_1_rsp;

floo_req_t L2_ni_0_to_router_0_0_req;
floo_rsp_t router_0_0_to_L2_ni_0_rsp;

floo_req_t L2_ni_1_to_router_0_1_req;
floo_rsp_t router_0_1_to_L2_ni_1_rsp;



floo_axi_chimney  #(
  .AxiCfg(AxiCfg),
  .ChimneyCfg(set_ports(ChimneyDefaultCfg, 1'b1, 1'b1)),
  .RouteCfg(RouteCfg),
  .id_t(id_t),
  .rob_idx_t(rob_idx_t),
  .hdr_t  (hdr_t),
  .sam_rule_t(sam_rule_t),
  .Sam(Sam),
  .axi_in_req_t(axi_data_slv_req_t),
  .axi_in_rsp_t(axi_data_slv_rsp_t),
  .axi_out_req_t(axi_data_mst_req_t),
  .axi_out_rsp_t(axi_data_mst_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t)
) magia_tile_ni_0_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[0][0] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[0][0] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[0][0] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[0][0] ),
  .id_i             ( '{x: 1, y: 0, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_0_0_to_router_0_0_req   ),
  .floo_rsp_i       ( router_0_0_to_magia_tile_ni_0_0_rsp   ),
  .floo_req_i       ( router_0_0_to_magia_tile_ni_0_0_req   ),
  .floo_rsp_o       ( magia_tile_ni_0_0_to_router_0_0_rsp   )
);

floo_axi_chimney  #(
  .AxiCfg(AxiCfg),
  .ChimneyCfg(set_ports(ChimneyDefaultCfg, 1'b1, 1'b1)),
  .RouteCfg(RouteCfg),
  .id_t(id_t),
  .rob_idx_t(rob_idx_t),
  .hdr_t  (hdr_t),
  .sam_rule_t(sam_rule_t),
  .Sam(Sam),
  .axi_in_req_t(axi_data_slv_req_t),
  .axi_in_rsp_t(axi_data_slv_rsp_t),
  .axi_out_req_t(axi_data_mst_req_t),
  .axi_out_rsp_t(axi_data_mst_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t)
) magia_tile_ni_0_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[0][1] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[0][1] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[0][1] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[0][1] ),
  .id_i             ( '{x: 1, y: 1, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_0_1_to_router_0_1_req   ),
  .floo_rsp_i       ( router_0_1_to_magia_tile_ni_0_1_rsp   ),
  .floo_req_i       ( router_0_1_to_magia_tile_ni_0_1_req   ),
  .floo_rsp_o       ( magia_tile_ni_0_1_to_router_0_1_rsp   )
);

floo_axi_chimney  #(
  .AxiCfg(AxiCfg),
  .ChimneyCfg(set_ports(ChimneyDefaultCfg, 1'b1, 1'b1)),
  .RouteCfg(RouteCfg),
  .id_t(id_t),
  .rob_idx_t(rob_idx_t),
  .hdr_t  (hdr_t),
  .sam_rule_t(sam_rule_t),
  .Sam(Sam),
  .axi_in_req_t(axi_data_slv_req_t),
  .axi_in_rsp_t(axi_data_slv_rsp_t),
  .axi_out_req_t(axi_data_mst_req_t),
  .axi_out_rsp_t(axi_data_mst_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t)
) magia_tile_ni_1_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[1][0] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[1][0] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[1][0] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[1][0] ),
  .id_i             ( '{x: 2, y: 0, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_1_0_to_router_1_0_req   ),
  .floo_rsp_i       ( router_1_0_to_magia_tile_ni_1_0_rsp   ),
  .floo_req_i       ( router_1_0_to_magia_tile_ni_1_0_req   ),
  .floo_rsp_o       ( magia_tile_ni_1_0_to_router_1_0_rsp   )
);

floo_axi_chimney  #(
  .AxiCfg(AxiCfg),
  .ChimneyCfg(set_ports(ChimneyDefaultCfg, 1'b1, 1'b1)),
  .RouteCfg(RouteCfg),
  .id_t(id_t),
  .rob_idx_t(rob_idx_t),
  .hdr_t  (hdr_t),
  .sam_rule_t(sam_rule_t),
  .Sam(Sam),
  .axi_in_req_t(axi_data_slv_req_t),
  .axi_in_rsp_t(axi_data_slv_rsp_t),
  .axi_out_req_t(axi_data_mst_req_t),
  .axi_out_rsp_t(axi_data_mst_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t)
) magia_tile_ni_1_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[1][1] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[1][1] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[1][1] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[1][1] ),
  .id_i             ( '{x: 2, y: 1, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_1_1_to_router_1_1_req   ),
  .floo_rsp_i       ( router_1_1_to_magia_tile_ni_1_1_rsp   ),
  .floo_req_i       ( router_1_1_to_magia_tile_ni_1_1_req   ),
  .floo_rsp_o       ( magia_tile_ni_1_1_to_router_1_1_rsp   )
);

floo_axi_chimney  #(
  .AxiCfg(AxiCfg),
  .ChimneyCfg(set_ports(ChimneyDefaultCfg, 1'b1, 1'b0)),
  .RouteCfg(RouteCfg),
  .id_t(id_t),
  .rob_idx_t(rob_idx_t),
  .hdr_t  (hdr_t),
  .sam_rule_t(sam_rule_t),
  .Sam(Sam),
  .axi_in_req_t(axi_data_slv_req_t),
  .axi_in_rsp_t(axi_data_slv_rsp_t),
  .axi_out_req_t(axi_data_mst_req_t),
  .axi_out_rsp_t(axi_data_mst_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t)
) L2_ni_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( '0 ),
  .axi_in_rsp_o  (    ),
  .axi_out_req_o ( L2_data_mst_req_o[0] ),
  .axi_out_rsp_i ( L2_data_mst_rsp_i[0] ),
  .id_i             ( '{x: 0, y: 0, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( L2_ni_0_to_router_0_0_req   ),
  .floo_rsp_i       ( router_0_0_to_L2_ni_0_rsp   ),
  .floo_req_i       ( router_0_0_to_L2_ni_0_req   ),
  .floo_rsp_o       ( L2_ni_0_to_router_0_0_rsp   )
);

floo_axi_chimney  #(
  .AxiCfg(AxiCfg),
  .ChimneyCfg(set_ports(ChimneyDefaultCfg, 1'b1, 1'b0)),
  .RouteCfg(RouteCfg),
  .id_t(id_t),
  .rob_idx_t(rob_idx_t),
  .hdr_t  (hdr_t),
  .sam_rule_t(sam_rule_t),
  .Sam(Sam),
  .axi_in_req_t(axi_data_slv_req_t),
  .axi_in_rsp_t(axi_data_slv_rsp_t),
  .axi_out_req_t(axi_data_mst_req_t),
  .axi_out_rsp_t(axi_data_mst_rsp_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t)
) L2_ni_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( '0 ),
  .axi_in_rsp_o  (    ),
  .axi_out_req_o ( L2_data_mst_req_o[1] ),
  .axi_out_rsp_i ( L2_data_mst_rsp_i[1] ),
  .id_i             ( '{x: 0, y: 1, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( L2_ni_1_to_router_0_1_req   ),
  .floo_rsp_i       ( router_0_1_to_L2_ni_1_rsp   ),
  .floo_req_i       ( router_0_1_to_L2_ni_1_req   ),
  .floo_rsp_o       ( L2_ni_1_to_router_0_1_rsp   )
);


floo_req_t [4:0] router_0_0_req_in;
floo_rsp_t [4:0] router_0_0_rsp_out;
floo_req_t [4:0] router_0_0_req_out;
floo_rsp_t [4:0] router_0_0_rsp_in;

    assign router_0_0_req_in[0] = router_0_1_to_router_0_0_req;
    assign router_0_0_req_in[1] = router_1_0_to_router_0_0_req;
    assign router_0_0_req_in[2] = '0;
    assign router_0_0_req_in[3] = L2_ni_0_to_router_0_0_req;
    assign router_0_0_req_in[4] = magia_tile_ni_0_0_to_router_0_0_req;

    assign router_0_0_to_router_0_1_rsp = router_0_0_rsp_out[0];
    assign router_0_0_to_router_1_0_rsp = router_0_0_rsp_out[1];
    assign router_0_0_to_L2_ni_0_rsp = router_0_0_rsp_out[3];
    assign router_0_0_to_magia_tile_ni_0_0_rsp = router_0_0_rsp_out[4];

    assign router_0_0_to_router_0_1_req = router_0_0_req_out[0];
    assign router_0_0_to_router_1_0_req = router_0_0_req_out[1];
    assign router_0_0_to_L2_ni_0_req = router_0_0_req_out[3];
    assign router_0_0_to_magia_tile_ni_0_0_req = router_0_0_req_out[4];

    assign router_0_0_rsp_in[0] = router_0_1_to_router_0_0_rsp;
    assign router_0_0_rsp_in[1] = router_1_0_to_router_0_0_rsp;
    assign router_0_0_rsp_in[2] = '0;
    assign router_0_0_rsp_in[3] = L2_ni_0_to_router_0_0_rsp;
    assign router_0_0_rsp_in[4] = magia_tile_ni_0_0_to_router_0_0_rsp;

floo_axi_router #(
  .AxiCfg(AxiCfg),
  .RouteAlgo (XYRouting),
  .NumRoutes (5),
  .NumInputs (5),
  .NumOutputs (5),
  .InFifoDepth (2),
  .OutFifoDepth (2),
  .id_t(id_t),
  .hdr_t(hdr_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t)
) router_0_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 1, y: 0, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_0_0_req_in),
  .floo_rsp_o (router_0_0_rsp_out),
  .floo_req_o (router_0_0_req_out),
  .floo_rsp_i (router_0_0_rsp_in)
);


floo_req_t [4:0] router_0_1_req_in;
floo_rsp_t [4:0] router_0_1_rsp_out;
floo_req_t [4:0] router_0_1_req_out;
floo_rsp_t [4:0] router_0_1_rsp_in;

    assign router_0_1_req_in[0] = '0;
    assign router_0_1_req_in[1] = router_1_1_to_router_0_1_req;
    assign router_0_1_req_in[2] = router_0_0_to_router_0_1_req;
    assign router_0_1_req_in[3] = L2_ni_1_to_router_0_1_req;
    assign router_0_1_req_in[4] = magia_tile_ni_0_1_to_router_0_1_req;

    assign router_0_1_to_router_1_1_rsp = router_0_1_rsp_out[1];
    assign router_0_1_to_router_0_0_rsp = router_0_1_rsp_out[2];
    assign router_0_1_to_L2_ni_1_rsp = router_0_1_rsp_out[3];
    assign router_0_1_to_magia_tile_ni_0_1_rsp = router_0_1_rsp_out[4];

    assign router_0_1_to_router_1_1_req = router_0_1_req_out[1];
    assign router_0_1_to_router_0_0_req = router_0_1_req_out[2];
    assign router_0_1_to_L2_ni_1_req = router_0_1_req_out[3];
    assign router_0_1_to_magia_tile_ni_0_1_req = router_0_1_req_out[4];

    assign router_0_1_rsp_in[0] = '0;
    assign router_0_1_rsp_in[1] = router_1_1_to_router_0_1_rsp;
    assign router_0_1_rsp_in[2] = router_0_0_to_router_0_1_rsp;
    assign router_0_1_rsp_in[3] = L2_ni_1_to_router_0_1_rsp;
    assign router_0_1_rsp_in[4] = magia_tile_ni_0_1_to_router_0_1_rsp;

floo_axi_router #(
  .AxiCfg(AxiCfg),
  .RouteAlgo (XYRouting),
  .NumRoutes (5),
  .NumInputs (5),
  .NumOutputs (5),
  .InFifoDepth (2),
  .OutFifoDepth (2),
  .id_t(id_t),
  .hdr_t(hdr_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t)
) router_0_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 1, y: 1, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_0_1_req_in),
  .floo_rsp_o (router_0_1_rsp_out),
  .floo_req_o (router_0_1_req_out),
  .floo_rsp_i (router_0_1_rsp_in)
);


floo_req_t [4:0] router_1_0_req_in;
floo_rsp_t [4:0] router_1_0_rsp_out;
floo_req_t [4:0] router_1_0_req_out;
floo_rsp_t [4:0] router_1_0_rsp_in;

    assign router_1_0_req_in[0] = router_1_1_to_router_1_0_req;
    assign router_1_0_req_in[1] = '0;
    assign router_1_0_req_in[2] = '0;
    assign router_1_0_req_in[3] = router_0_0_to_router_1_0_req;
    assign router_1_0_req_in[4] = magia_tile_ni_1_0_to_router_1_0_req;

    assign router_1_0_to_router_1_1_rsp = router_1_0_rsp_out[0];
    assign router_1_0_to_router_0_0_rsp = router_1_0_rsp_out[3];
    assign router_1_0_to_magia_tile_ni_1_0_rsp = router_1_0_rsp_out[4];

    assign router_1_0_to_router_1_1_req = router_1_0_req_out[0];
    assign router_1_0_to_router_0_0_req = router_1_0_req_out[3];
    assign router_1_0_to_magia_tile_ni_1_0_req = router_1_0_req_out[4];

    assign router_1_0_rsp_in[0] = router_1_1_to_router_1_0_rsp;
    assign router_1_0_rsp_in[1] = '0;
    assign router_1_0_rsp_in[2] = '0;
    assign router_1_0_rsp_in[3] = router_0_0_to_router_1_0_rsp;
    assign router_1_0_rsp_in[4] = magia_tile_ni_1_0_to_router_1_0_rsp;

floo_axi_router #(
  .AxiCfg(AxiCfg),
  .RouteAlgo (XYRouting),
  .NumRoutes (5),
  .NumInputs (5),
  .NumOutputs (5),
  .InFifoDepth (2),
  .OutFifoDepth (2),
  .id_t(id_t),
  .hdr_t(hdr_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t)
) router_1_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 2, y: 0, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_1_0_req_in),
  .floo_rsp_o (router_1_0_rsp_out),
  .floo_req_o (router_1_0_req_out),
  .floo_rsp_i (router_1_0_rsp_in)
);


floo_req_t [4:0] router_1_1_req_in;
floo_rsp_t [4:0] router_1_1_rsp_out;
floo_req_t [4:0] router_1_1_req_out;
floo_rsp_t [4:0] router_1_1_rsp_in;

    assign router_1_1_req_in[0] = '0;
    assign router_1_1_req_in[1] = '0;
    assign router_1_1_req_in[2] = router_1_0_to_router_1_1_req;
    assign router_1_1_req_in[3] = router_0_1_to_router_1_1_req;
    assign router_1_1_req_in[4] = magia_tile_ni_1_1_to_router_1_1_req;

    assign router_1_1_to_router_1_0_rsp = router_1_1_rsp_out[2];
    assign router_1_1_to_router_0_1_rsp = router_1_1_rsp_out[3];
    assign router_1_1_to_magia_tile_ni_1_1_rsp = router_1_1_rsp_out[4];

    assign router_1_1_to_router_1_0_req = router_1_1_req_out[2];
    assign router_1_1_to_router_0_1_req = router_1_1_req_out[3];
    assign router_1_1_to_magia_tile_ni_1_1_req = router_1_1_req_out[4];

    assign router_1_1_rsp_in[0] = '0;
    assign router_1_1_rsp_in[1] = '0;
    assign router_1_1_rsp_in[2] = router_1_0_to_router_1_1_rsp;
    assign router_1_1_rsp_in[3] = router_0_1_to_router_1_1_rsp;
    assign router_1_1_rsp_in[4] = magia_tile_ni_1_1_to_router_1_1_rsp;

floo_axi_router #(
  .AxiCfg(AxiCfg),
  .RouteAlgo (XYRouting),
  .NumRoutes (5),
  .NumInputs (5),
  .NumOutputs (5),
  .InFifoDepth (2),
  .OutFifoDepth (2),
  .id_t(id_t),
  .hdr_t(hdr_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t)
) router_1_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 2, y: 1, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_1_1_req_in),
  .floo_rsp_o (router_1_1_rsp_out),
  .floo_req_o (router_1_1_req_out),
  .floo_rsp_i (router_1_1_rsp_in)
);



endmodule
