// Copyright 2024 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// AUTOMATICALLY GENERATED! DO NOT EDIT!

`include "axi/typedef.svh"
`include "floo_noc/typedef.svh"

package floo_redmule_single_router_axi_2x2_noc_pkg;

  import floo_pkg::*;

  /////////////////////
  //   Address Map   //
  /////////////////////

  typedef enum logic[2:0] {
    L2Ni = 0,
    RedmuleTileNi0 = 1,
    RedmuleTileNi1 = 2,
    RedmuleTileNi2 = 3,
    RedmuleTileNi3 = 4,
    NumEndpoints = 5} ep_id_e;



  typedef logic[0:0] rob_idx_t;
typedef logic[0:0] port_id_t;
typedef logic[2:0] id_t;
typedef logic route_t;


  localparam int unsigned SamNumRules = 5;

typedef struct packed {
    id_t idx;
    logic [31:0] start_addr;
    logic [31:0] end_addr;
} sam_rule_t;

localparam sam_rule_t[SamNumRules-1:0] Sam = '{
'{idx: 0, start_addr: 32'h50000000, end_addr: 32'h60000000},// L2_ni
'{idx: 4, start_addr: 32'h40000000, end_addr: 32'h50000000},// redmule_tile_ni_3
'{idx: 3, start_addr: 32'h30000000, end_addr: 32'h40000000},// redmule_tile_ni_2
'{idx: 2, start_addr: 32'h20000000, end_addr: 32'h30000000},// redmule_tile_ni_1
'{idx: 1, start_addr: 32'h10000000, end_addr: 32'h20000000} // redmule_tile_ni_0

};



  localparam route_cfg_t RouteCfg = '{    RouteAlgo: IdTable,
    UseIdTable: 1'b1,
    XYAddrOffsetX: 0,
    XYAddrOffsetY: 0,
    IdAddrOffset: 0,
    NumSamRules: 5,
    NumRoutes: 0};


  typedef logic[31:0] axi_data_mst_addr_t;
typedef logic[31:0] axi_data_mst_data_t;
typedef logic[3:0] axi_data_mst_strb_t;
typedef logic[5:0] axi_data_mst_id_t;
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
    OutIdWidth: 6};
`FLOO_TYPEDEF_AXI_CHAN_ALL(axi, req, rsp, axi_data_slv, AxiCfg, hdr_t)

`FLOO_TYPEDEF_AXI_LINK_ALL(req, rsp, req, rsp)


endpackage

module floo_redmule_single_router_axi_2x2_noc
  import floo_pkg::*;
  import floo_redmule_single_router_axi_2x2_noc_pkg::*;
(
  input logic clk_i,
  input logic rst_ni,
  input logic test_enable_i,
  input axi_data_slv_req_t             [3:0] redmule_tile_data_slv_req_i,
  output axi_data_slv_rsp_t             [3:0] redmule_tile_data_slv_rsp_o,
  output axi_data_mst_req_t             [3:0] redmule_tile_data_mst_req_o,
  input axi_data_mst_rsp_t             [3:0] redmule_tile_data_mst_rsp_i,
  output axi_data_mst_req_t              L2_data_mst_req_o,
  input axi_data_mst_rsp_t              L2_data_mst_rsp_i

);

floo_req_t router_to_redmule_tile_ni_0_req;
floo_rsp_t redmule_tile_ni_0_to_router_rsp;

floo_req_t router_to_redmule_tile_ni_1_req;
floo_rsp_t redmule_tile_ni_1_to_router_rsp;

floo_req_t router_to_redmule_tile_ni_2_req;
floo_rsp_t redmule_tile_ni_2_to_router_rsp;

floo_req_t router_to_redmule_tile_ni_3_req;
floo_rsp_t redmule_tile_ni_3_to_router_rsp;

floo_req_t router_to_L2_ni_req;
floo_rsp_t L2_ni_to_router_rsp;

floo_req_t redmule_tile_ni_0_to_router_req;
floo_rsp_t router_to_redmule_tile_ni_0_rsp;

floo_req_t redmule_tile_ni_1_to_router_req;
floo_rsp_t router_to_redmule_tile_ni_1_rsp;

floo_req_t redmule_tile_ni_2_to_router_req;
floo_rsp_t router_to_redmule_tile_ni_2_rsp;

floo_req_t redmule_tile_ni_3_to_router_req;
floo_rsp_t router_to_redmule_tile_ni_3_rsp;

floo_req_t L2_ni_to_router_req;
floo_rsp_t router_to_L2_ni_rsp;



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
) redmule_tile_ni_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( redmule_tile_data_slv_req_i[0] ),
  .axi_in_rsp_o  ( redmule_tile_data_slv_rsp_o[0] ),
  .axi_out_req_o ( redmule_tile_data_mst_req_o[0] ),
  .axi_out_rsp_i ( redmule_tile_data_mst_rsp_i[0] ),
  .id_i             ( id_t'(1) ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( redmule_tile_ni_0_to_router_req   ),
  .floo_rsp_i       ( router_to_redmule_tile_ni_0_rsp   ),
  .floo_req_i       ( router_to_redmule_tile_ni_0_req   ),
  .floo_rsp_o       ( redmule_tile_ni_0_to_router_rsp   )
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
) redmule_tile_ni_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( redmule_tile_data_slv_req_i[1] ),
  .axi_in_rsp_o  ( redmule_tile_data_slv_rsp_o[1] ),
  .axi_out_req_o ( redmule_tile_data_mst_req_o[1] ),
  .axi_out_rsp_i ( redmule_tile_data_mst_rsp_i[1] ),
  .id_i             ( id_t'(2) ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( redmule_tile_ni_1_to_router_req   ),
  .floo_rsp_i       ( router_to_redmule_tile_ni_1_rsp   ),
  .floo_req_i       ( router_to_redmule_tile_ni_1_req   ),
  .floo_rsp_o       ( redmule_tile_ni_1_to_router_rsp   )
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
) redmule_tile_ni_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( redmule_tile_data_slv_req_i[2] ),
  .axi_in_rsp_o  ( redmule_tile_data_slv_rsp_o[2] ),
  .axi_out_req_o ( redmule_tile_data_mst_req_o[2] ),
  .axi_out_rsp_i ( redmule_tile_data_mst_rsp_i[2] ),
  .id_i             ( id_t'(3) ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( redmule_tile_ni_2_to_router_req   ),
  .floo_rsp_i       ( router_to_redmule_tile_ni_2_rsp   ),
  .floo_req_i       ( router_to_redmule_tile_ni_2_req   ),
  .floo_rsp_o       ( redmule_tile_ni_2_to_router_rsp   )
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
) redmule_tile_ni_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( redmule_tile_data_slv_req_i[3] ),
  .axi_in_rsp_o  ( redmule_tile_data_slv_rsp_o[3] ),
  .axi_out_req_o ( redmule_tile_data_mst_req_o[3] ),
  .axi_out_rsp_i ( redmule_tile_data_mst_rsp_i[3] ),
  .id_i             ( id_t'(4) ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( redmule_tile_ni_3_to_router_req   ),
  .floo_rsp_i       ( router_to_redmule_tile_ni_3_rsp   ),
  .floo_req_i       ( router_to_redmule_tile_ni_3_req   ),
  .floo_rsp_o       ( redmule_tile_ni_3_to_router_rsp   )
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
) L2_ni (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( '0 ),
  .axi_in_rsp_o  (    ),
  .axi_out_req_o ( L2_data_mst_req_o ),
  .axi_out_rsp_i ( L2_data_mst_rsp_i ),
  .id_i             ( id_t'(0) ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( L2_ni_to_router_req   ),
  .floo_rsp_i       ( router_to_L2_ni_rsp   ),
  .floo_req_i       ( router_to_L2_ni_req   ),
  .floo_rsp_o       ( L2_ni_to_router_rsp   )
);

localparam int unsigned RouterMapNumRules = 5;

typedef struct packed {
    id_t idx;
    id_t start_addr;
    id_t end_addr;
} router_map_rule_t;

localparam router_map_rule_t[RouterMapNumRules-1:0] RouterMap = '{
'{idx: 0, start_addr: 1, end_addr: 2},// redmule_tile_ni_0
'{idx: 1, start_addr: 2, end_addr: 3},// redmule_tile_ni_1
'{idx: 2, start_addr: 3, end_addr: 4},// redmule_tile_ni_2
'{idx: 3, start_addr: 4, end_addr: 5},// redmule_tile_ni_3
'{idx: 4, start_addr: 0, end_addr: 1} // L2_ni

};


floo_req_t [4:0] router_req_in;
floo_rsp_t [4:0] router_rsp_out;
floo_req_t [4:0] router_req_out;
floo_rsp_t [4:0] router_rsp_in;

    assign router_req_in[0] = redmule_tile_ni_0_to_router_req;
    assign router_req_in[1] = redmule_tile_ni_1_to_router_req;
    assign router_req_in[2] = redmule_tile_ni_2_to_router_req;
    assign router_req_in[3] = redmule_tile_ni_3_to_router_req;
    assign router_req_in[4] = L2_ni_to_router_req;

    assign router_to_redmule_tile_ni_0_rsp = router_rsp_out[0];
    assign router_to_redmule_tile_ni_1_rsp = router_rsp_out[1];
    assign router_to_redmule_tile_ni_2_rsp = router_rsp_out[2];
    assign router_to_redmule_tile_ni_3_rsp = router_rsp_out[3];
    assign router_to_L2_ni_rsp = router_rsp_out[4];

    assign router_to_redmule_tile_ni_0_req = router_req_out[0];
    assign router_to_redmule_tile_ni_1_req = router_req_out[1];
    assign router_to_redmule_tile_ni_2_req = router_req_out[2];
    assign router_to_redmule_tile_ni_3_req = router_req_out[3];
    assign router_to_L2_ni_req = router_req_out[4];

    assign router_rsp_in[0] = redmule_tile_ni_0_to_router_rsp;
    assign router_rsp_in[1] = redmule_tile_ni_1_to_router_rsp;
    assign router_rsp_in[2] = redmule_tile_ni_2_to_router_rsp;
    assign router_rsp_in[3] = redmule_tile_ni_3_to_router_rsp;
    assign router_rsp_in[4] = L2_ni_to_router_rsp;

floo_axi_router #(
  .AxiCfg(AxiCfg),
  .RouteAlgo (IdTable),
  .NumRoutes (5),
  .NumInputs (5),
  .NumOutputs (5),
  .InFifoDepth (2),
  .OutFifoDepth (2),
  .id_t(id_t),
  .hdr_t(hdr_t),
  .NumAddrRules (5),
  .addr_rule_t (router_map_rule_t),
  .floo_req_t(floo_req_t),
  .floo_rsp_t(floo_rsp_t)
) router (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('0),
  .id_route_map_i (RouterMap),
  .floo_req_i (router_req_in),
  .floo_rsp_o (router_rsp_out),
  .floo_req_o (router_req_out),
  .floo_rsp_i (router_rsp_in)
);



endmodule
