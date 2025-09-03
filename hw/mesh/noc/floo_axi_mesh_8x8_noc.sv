// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// AUTOMATICALLY GENERATED! DO NOT EDIT!

`include "axi/typedef.svh"
`include "floo_noc/typedef.svh"

package floo_axi_mesh_8x8_noc_pkg;

  import floo_pkg::*;

  /////////////////////
  //   Address Map   //
  /////////////////////

  typedef enum logic[6:0] {
    MagiaTileX0Y0 = 0,
    MagiaTileX0Y1 = 1,
    MagiaTileX0Y2 = 2,
    MagiaTileX0Y3 = 3,
    MagiaTileX0Y4 = 4,
    MagiaTileX0Y5 = 5,
    MagiaTileX0Y6 = 6,
    MagiaTileX0Y7 = 7,
    MagiaTileX1Y0 = 8,
    MagiaTileX1Y1 = 9,
    MagiaTileX1Y2 = 10,
    MagiaTileX1Y3 = 11,
    MagiaTileX1Y4 = 12,
    MagiaTileX1Y5 = 13,
    MagiaTileX1Y6 = 14,
    MagiaTileX1Y7 = 15,
    MagiaTileX2Y0 = 16,
    MagiaTileX2Y1 = 17,
    MagiaTileX2Y2 = 18,
    MagiaTileX2Y3 = 19,
    MagiaTileX2Y4 = 20,
    MagiaTileX2Y5 = 21,
    MagiaTileX2Y6 = 22,
    MagiaTileX2Y7 = 23,
    MagiaTileX3Y0 = 24,
    MagiaTileX3Y1 = 25,
    MagiaTileX3Y2 = 26,
    MagiaTileX3Y3 = 27,
    MagiaTileX3Y4 = 28,
    MagiaTileX3Y5 = 29,
    MagiaTileX3Y6 = 30,
    MagiaTileX3Y7 = 31,
    MagiaTileX4Y0 = 32,
    MagiaTileX4Y1 = 33,
    MagiaTileX4Y2 = 34,
    MagiaTileX4Y3 = 35,
    MagiaTileX4Y4 = 36,
    MagiaTileX4Y5 = 37,
    MagiaTileX4Y6 = 38,
    MagiaTileX4Y7 = 39,
    MagiaTileX5Y0 = 40,
    MagiaTileX5Y1 = 41,
    MagiaTileX5Y2 = 42,
    MagiaTileX5Y3 = 43,
    MagiaTileX5Y4 = 44,
    MagiaTileX5Y5 = 45,
    MagiaTileX5Y6 = 46,
    MagiaTileX5Y7 = 47,
    MagiaTileX6Y0 = 48,
    MagiaTileX6Y1 = 49,
    MagiaTileX6Y2 = 50,
    MagiaTileX6Y3 = 51,
    MagiaTileX6Y4 = 52,
    MagiaTileX6Y5 = 53,
    MagiaTileX6Y6 = 54,
    MagiaTileX6Y7 = 55,
    MagiaTileX7Y0 = 56,
    MagiaTileX7Y1 = 57,
    MagiaTileX7Y2 = 58,
    MagiaTileX7Y3 = 59,
    MagiaTileX7Y4 = 60,
    MagiaTileX7Y5 = 61,
    MagiaTileX7Y6 = 62,
    MagiaTileX7Y7 = 63,
    L20 = 64,
    L21 = 65,
    L22 = 66,
    L23 = 67,
    L24 = 68,
    L25 = 69,
    L26 = 70,
    L27 = 71,
    NumEndpoints = 72} ep_id_e;



  typedef logic[0:0] rob_idx_t;
typedef logic[0:0] port_id_t;
typedef logic[3:0] x_bits_t;
typedef logic[2:0] y_bits_t;
typedef struct packed {
    x_bits_t x;
    y_bits_t y;
    port_id_t port_id;
} id_t;

typedef logic route_t;


  localparam int unsigned SamNumRules = 72;

typedef struct packed {
    id_t idx;
    logic [31:0] start_addr;
    logic [31:0] end_addr;
} sam_rule_t;

localparam sam_rule_t[SamNumRules-1:0] Sam = '{
'{idx: '{x: 0, y: 7, port_id: 0}, start_addr: 32'hf8000000, end_addr: 32'h100000000},// L2_7_sam_idx
'{idx: '{x: 0, y: 6, port_id: 0}, start_addr: 32'hf0000000, end_addr: 32'hf8000000},// L2_6_sam_idx
'{idx: '{x: 0, y: 5, port_id: 0}, start_addr: 32'he8000000, end_addr: 32'hf0000000},// L2_5_sam_idx
'{idx: '{x: 0, y: 4, port_id: 0}, start_addr: 32'he0000000, end_addr: 32'he8000000},// L2_4_sam_idx
'{idx: '{x: 0, y: 3, port_id: 0}, start_addr: 32'hd8000000, end_addr: 32'he0000000},// L2_3_sam_idx
'{idx: '{x: 0, y: 2, port_id: 0}, start_addr: 32'hd0000000, end_addr: 32'hd8000000},// L2_2_sam_idx
'{idx: '{x: 0, y: 1, port_id: 0}, start_addr: 32'hc8000000, end_addr: 32'hd0000000},// L2_1_sam_idx
'{idx: '{x: 0, y: 0, port_id: 0}, start_addr: 32'hc0000000, end_addr: 32'hc8000000},// L2_0_sam_idx
'{idx: '{x: 8, y: 7, port_id: 0}, start_addr: 32'h03f00000, end_addr: 32'h04000000},// magia_tile_x7_y7_sam_idx
'{idx: '{x: 7, y: 7, port_id: 0}, start_addr: 32'h03e00000, end_addr: 32'h03f00000},// magia_tile_x6_y7_sam_idx
'{idx: '{x: 6, y: 7, port_id: 0}, start_addr: 32'h03d00000, end_addr: 32'h03e00000},// magia_tile_x5_y7_sam_idx
'{idx: '{x: 5, y: 7, port_id: 0}, start_addr: 32'h03c00000, end_addr: 32'h03d00000},// magia_tile_x4_y7_sam_idx
'{idx: '{x: 4, y: 7, port_id: 0}, start_addr: 32'h03b00000, end_addr: 32'h03c00000},// magia_tile_x3_y7_sam_idx
'{idx: '{x: 3, y: 7, port_id: 0}, start_addr: 32'h03a00000, end_addr: 32'h03b00000},// magia_tile_x2_y7_sam_idx
'{idx: '{x: 2, y: 7, port_id: 0}, start_addr: 32'h03900000, end_addr: 32'h03a00000},// magia_tile_x1_y7_sam_idx
'{idx: '{x: 1, y: 7, port_id: 0}, start_addr: 32'h03800000, end_addr: 32'h03900000},// magia_tile_x0_y7_sam_idx
'{idx: '{x: 8, y: 6, port_id: 0}, start_addr: 32'h03700000, end_addr: 32'h03800000},// magia_tile_x7_y6_sam_idx
'{idx: '{x: 7, y: 6, port_id: 0}, start_addr: 32'h03600000, end_addr: 32'h03700000},// magia_tile_x6_y6_sam_idx
'{idx: '{x: 6, y: 6, port_id: 0}, start_addr: 32'h03500000, end_addr: 32'h03600000},// magia_tile_x5_y6_sam_idx
'{idx: '{x: 5, y: 6, port_id: 0}, start_addr: 32'h03400000, end_addr: 32'h03500000},// magia_tile_x4_y6_sam_idx
'{idx: '{x: 4, y: 6, port_id: 0}, start_addr: 32'h03300000, end_addr: 32'h03400000},// magia_tile_x3_y6_sam_idx
'{idx: '{x: 3, y: 6, port_id: 0}, start_addr: 32'h03200000, end_addr: 32'h03300000},// magia_tile_x2_y6_sam_idx
'{idx: '{x: 2, y: 6, port_id: 0}, start_addr: 32'h03100000, end_addr: 32'h03200000},// magia_tile_x1_y6_sam_idx
'{idx: '{x: 1, y: 6, port_id: 0}, start_addr: 32'h03000000, end_addr: 32'h03100000},// magia_tile_x0_y6_sam_idx
'{idx: '{x: 8, y: 5, port_id: 0}, start_addr: 32'h02f00000, end_addr: 32'h03000000},// magia_tile_x7_y5_sam_idx
'{idx: '{x: 7, y: 5, port_id: 0}, start_addr: 32'h02e00000, end_addr: 32'h02f00000},// magia_tile_x6_y5_sam_idx
'{idx: '{x: 6, y: 5, port_id: 0}, start_addr: 32'h02d00000, end_addr: 32'h02e00000},// magia_tile_x5_y5_sam_idx
'{idx: '{x: 5, y: 5, port_id: 0}, start_addr: 32'h02c00000, end_addr: 32'h02d00000},// magia_tile_x4_y5_sam_idx
'{idx: '{x: 4, y: 5, port_id: 0}, start_addr: 32'h02b00000, end_addr: 32'h02c00000},// magia_tile_x3_y5_sam_idx
'{idx: '{x: 3, y: 5, port_id: 0}, start_addr: 32'h02a00000, end_addr: 32'h02b00000},// magia_tile_x2_y5_sam_idx
'{idx: '{x: 2, y: 5, port_id: 0}, start_addr: 32'h02900000, end_addr: 32'h02a00000},// magia_tile_x1_y5_sam_idx
'{idx: '{x: 1, y: 5, port_id: 0}, start_addr: 32'h02800000, end_addr: 32'h02900000},// magia_tile_x0_y5_sam_idx
'{idx: '{x: 8, y: 4, port_id: 0}, start_addr: 32'h02700000, end_addr: 32'h02800000},// magia_tile_x7_y4_sam_idx
'{idx: '{x: 7, y: 4, port_id: 0}, start_addr: 32'h02600000, end_addr: 32'h02700000},// magia_tile_x6_y4_sam_idx
'{idx: '{x: 6, y: 4, port_id: 0}, start_addr: 32'h02500000, end_addr: 32'h02600000},// magia_tile_x5_y4_sam_idx
'{idx: '{x: 5, y: 4, port_id: 0}, start_addr: 32'h02400000, end_addr: 32'h02500000},// magia_tile_x4_y4_sam_idx
'{idx: '{x: 4, y: 4, port_id: 0}, start_addr: 32'h02300000, end_addr: 32'h02400000},// magia_tile_x3_y4_sam_idx
'{idx: '{x: 3, y: 4, port_id: 0}, start_addr: 32'h02200000, end_addr: 32'h02300000},// magia_tile_x2_y4_sam_idx
'{idx: '{x: 2, y: 4, port_id: 0}, start_addr: 32'h02100000, end_addr: 32'h02200000},// magia_tile_x1_y4_sam_idx
'{idx: '{x: 1, y: 4, port_id: 0}, start_addr: 32'h02000000, end_addr: 32'h02100000},// magia_tile_x0_y4_sam_idx
'{idx: '{x: 8, y: 3, port_id: 0}, start_addr: 32'h01f00000, end_addr: 32'h02000000},// magia_tile_x7_y3_sam_idx
'{idx: '{x: 7, y: 3, port_id: 0}, start_addr: 32'h01e00000, end_addr: 32'h01f00000},// magia_tile_x6_y3_sam_idx
'{idx: '{x: 6, y: 3, port_id: 0}, start_addr: 32'h01d00000, end_addr: 32'h01e00000},// magia_tile_x5_y3_sam_idx
'{idx: '{x: 5, y: 3, port_id: 0}, start_addr: 32'h01c00000, end_addr: 32'h01d00000},// magia_tile_x4_y3_sam_idx
'{idx: '{x: 4, y: 3, port_id: 0}, start_addr: 32'h01b00000, end_addr: 32'h01c00000},// magia_tile_x3_y3_sam_idx
'{idx: '{x: 3, y: 3, port_id: 0}, start_addr: 32'h01a00000, end_addr: 32'h01b00000},// magia_tile_x2_y3_sam_idx
'{idx: '{x: 2, y: 3, port_id: 0}, start_addr: 32'h01900000, end_addr: 32'h01a00000},// magia_tile_x1_y3_sam_idx
'{idx: '{x: 1, y: 3, port_id: 0}, start_addr: 32'h01800000, end_addr: 32'h01900000},// magia_tile_x0_y3_sam_idx
'{idx: '{x: 8, y: 2, port_id: 0}, start_addr: 32'h01700000, end_addr: 32'h01800000},// magia_tile_x7_y2_sam_idx
'{idx: '{x: 7, y: 2, port_id: 0}, start_addr: 32'h01600000, end_addr: 32'h01700000},// magia_tile_x6_y2_sam_idx
'{idx: '{x: 6, y: 2, port_id: 0}, start_addr: 32'h01500000, end_addr: 32'h01600000},// magia_tile_x5_y2_sam_idx
'{idx: '{x: 5, y: 2, port_id: 0}, start_addr: 32'h01400000, end_addr: 32'h01500000},// magia_tile_x4_y2_sam_idx
'{idx: '{x: 4, y: 2, port_id: 0}, start_addr: 32'h01300000, end_addr: 32'h01400000},// magia_tile_x3_y2_sam_idx
'{idx: '{x: 3, y: 2, port_id: 0}, start_addr: 32'h01200000, end_addr: 32'h01300000},// magia_tile_x2_y2_sam_idx
'{idx: '{x: 2, y: 2, port_id: 0}, start_addr: 32'h01100000, end_addr: 32'h01200000},// magia_tile_x1_y2_sam_idx
'{idx: '{x: 1, y: 2, port_id: 0}, start_addr: 32'h01000000, end_addr: 32'h01100000},// magia_tile_x0_y2_sam_idx
'{idx: '{x: 8, y: 1, port_id: 0}, start_addr: 32'h00f00000, end_addr: 32'h01000000},// magia_tile_x7_y1_sam_idx
'{idx: '{x: 7, y: 1, port_id: 0}, start_addr: 32'h00e00000, end_addr: 32'h00f00000},// magia_tile_x6_y1_sam_idx
'{idx: '{x: 6, y: 1, port_id: 0}, start_addr: 32'h00d00000, end_addr: 32'h00e00000},// magia_tile_x5_y1_sam_idx
'{idx: '{x: 5, y: 1, port_id: 0}, start_addr: 32'h00c00000, end_addr: 32'h00d00000},// magia_tile_x4_y1_sam_idx
'{idx: '{x: 4, y: 1, port_id: 0}, start_addr: 32'h00b00000, end_addr: 32'h00c00000},// magia_tile_x3_y1_sam_idx
'{idx: '{x: 3, y: 1, port_id: 0}, start_addr: 32'h00a00000, end_addr: 32'h00b00000},// magia_tile_x2_y1_sam_idx
'{idx: '{x: 2, y: 1, port_id: 0}, start_addr: 32'h00900000, end_addr: 32'h00a00000},// magia_tile_x1_y1_sam_idx
'{idx: '{x: 1, y: 1, port_id: 0}, start_addr: 32'h00800000, end_addr: 32'h00900000},// magia_tile_x0_y1_sam_idx
'{idx: '{x: 8, y: 0, port_id: 0}, start_addr: 32'h00700000, end_addr: 32'h00800000},// magia_tile_x7_y0_sam_idx
'{idx: '{x: 7, y: 0, port_id: 0}, start_addr: 32'h00600000, end_addr: 32'h00700000},// magia_tile_x6_y0_sam_idx
'{idx: '{x: 6, y: 0, port_id: 0}, start_addr: 32'h00500000, end_addr: 32'h00600000},// magia_tile_x5_y0_sam_idx
'{idx: '{x: 5, y: 0, port_id: 0}, start_addr: 32'h00400000, end_addr: 32'h00500000},// magia_tile_x4_y0_sam_idx
'{idx: '{x: 4, y: 0, port_id: 0}, start_addr: 32'h00300000, end_addr: 32'h00400000},// magia_tile_x3_y0_sam_idx
'{idx: '{x: 3, y: 0, port_id: 0}, start_addr: 32'h00200000, end_addr: 32'h00300000},// magia_tile_x2_y0_sam_idx
'{idx: '{x: 2, y: 0, port_id: 0}, start_addr: 32'h00100000, end_addr: 32'h00200000},// magia_tile_x1_y0_sam_idx
'{idx: '{x: 1, y: 0, port_id: 0}, start_addr: 32'h00000000, end_addr: 32'h00100000} // magia_tile_x0_y0_sam_idx

};



  localparam route_cfg_t RouteCfg = '{    RouteAlgo: XYRouting,
    UseIdTable: 1'b1,
    XYAddrOffsetX: 32,
    XYAddrOffsetY: 36,
    IdAddrOffset: 0,
    NumSamRules: 72,
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

module floo_axi_mesh_8x8_noc
  import floo_pkg::*;
  import floo_axi_mesh_8x8_noc_pkg::*;
(
  input logic clk_i,
  input logic rst_ni,
  input logic test_enable_i,
  input axi_data_slv_req_t             [7:0][7:0] magia_tile_data_slv_req_i,
  output axi_data_slv_rsp_t             [7:0][7:0] magia_tile_data_slv_rsp_o,
  output axi_data_mst_req_t             [7:0][7:0] magia_tile_data_mst_req_o,
  input axi_data_mst_rsp_t             [7:0][7:0] magia_tile_data_mst_rsp_i,
  output axi_data_mst_req_t             [7:0] L2_data_mst_req_o,
  input axi_data_mst_rsp_t             [7:0] L2_data_mst_rsp_i

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

floo_req_t router_0_1_to_router_0_2_req;
floo_rsp_t router_0_2_to_router_0_1_rsp;

floo_req_t router_0_1_to_router_1_1_req;
floo_rsp_t router_1_1_to_router_0_1_rsp;

floo_req_t router_0_1_to_magia_tile_ni_0_1_req;
floo_rsp_t magia_tile_ni_0_1_to_router_0_1_rsp;

floo_req_t router_0_1_to_L2_ni_1_req;
floo_rsp_t L2_ni_1_to_router_0_1_rsp;

floo_req_t router_0_2_to_router_0_1_req;
floo_rsp_t router_0_1_to_router_0_2_rsp;

floo_req_t router_0_2_to_router_0_3_req;
floo_rsp_t router_0_3_to_router_0_2_rsp;

floo_req_t router_0_2_to_router_1_2_req;
floo_rsp_t router_1_2_to_router_0_2_rsp;

floo_req_t router_0_2_to_magia_tile_ni_0_2_req;
floo_rsp_t magia_tile_ni_0_2_to_router_0_2_rsp;

floo_req_t router_0_2_to_L2_ni_2_req;
floo_rsp_t L2_ni_2_to_router_0_2_rsp;

floo_req_t router_0_3_to_router_0_2_req;
floo_rsp_t router_0_2_to_router_0_3_rsp;

floo_req_t router_0_3_to_router_0_4_req;
floo_rsp_t router_0_4_to_router_0_3_rsp;

floo_req_t router_0_3_to_router_1_3_req;
floo_rsp_t router_1_3_to_router_0_3_rsp;

floo_req_t router_0_3_to_magia_tile_ni_0_3_req;
floo_rsp_t magia_tile_ni_0_3_to_router_0_3_rsp;

floo_req_t router_0_3_to_L2_ni_3_req;
floo_rsp_t L2_ni_3_to_router_0_3_rsp;

floo_req_t router_0_4_to_router_0_3_req;
floo_rsp_t router_0_3_to_router_0_4_rsp;

floo_req_t router_0_4_to_router_0_5_req;
floo_rsp_t router_0_5_to_router_0_4_rsp;

floo_req_t router_0_4_to_router_1_4_req;
floo_rsp_t router_1_4_to_router_0_4_rsp;

floo_req_t router_0_4_to_magia_tile_ni_0_4_req;
floo_rsp_t magia_tile_ni_0_4_to_router_0_4_rsp;

floo_req_t router_0_4_to_L2_ni_4_req;
floo_rsp_t L2_ni_4_to_router_0_4_rsp;

floo_req_t router_0_5_to_router_0_4_req;
floo_rsp_t router_0_4_to_router_0_5_rsp;

floo_req_t router_0_5_to_router_0_6_req;
floo_rsp_t router_0_6_to_router_0_5_rsp;

floo_req_t router_0_5_to_router_1_5_req;
floo_rsp_t router_1_5_to_router_0_5_rsp;

floo_req_t router_0_5_to_magia_tile_ni_0_5_req;
floo_rsp_t magia_tile_ni_0_5_to_router_0_5_rsp;

floo_req_t router_0_5_to_L2_ni_5_req;
floo_rsp_t L2_ni_5_to_router_0_5_rsp;

floo_req_t router_0_6_to_router_0_5_req;
floo_rsp_t router_0_5_to_router_0_6_rsp;

floo_req_t router_0_6_to_router_0_7_req;
floo_rsp_t router_0_7_to_router_0_6_rsp;

floo_req_t router_0_6_to_router_1_6_req;
floo_rsp_t router_1_6_to_router_0_6_rsp;

floo_req_t router_0_6_to_magia_tile_ni_0_6_req;
floo_rsp_t magia_tile_ni_0_6_to_router_0_6_rsp;

floo_req_t router_0_6_to_L2_ni_6_req;
floo_rsp_t L2_ni_6_to_router_0_6_rsp;

floo_req_t router_0_7_to_router_0_6_req;
floo_rsp_t router_0_6_to_router_0_7_rsp;

floo_req_t router_0_7_to_router_1_7_req;
floo_rsp_t router_1_7_to_router_0_7_rsp;

floo_req_t router_0_7_to_magia_tile_ni_0_7_req;
floo_rsp_t magia_tile_ni_0_7_to_router_0_7_rsp;

floo_req_t router_0_7_to_L2_ni_7_req;
floo_rsp_t L2_ni_7_to_router_0_7_rsp;

floo_req_t router_1_0_to_router_0_0_req;
floo_rsp_t router_0_0_to_router_1_0_rsp;

floo_req_t router_1_0_to_router_1_1_req;
floo_rsp_t router_1_1_to_router_1_0_rsp;

floo_req_t router_1_0_to_router_2_0_req;
floo_rsp_t router_2_0_to_router_1_0_rsp;

floo_req_t router_1_0_to_magia_tile_ni_1_0_req;
floo_rsp_t magia_tile_ni_1_0_to_router_1_0_rsp;

floo_req_t router_1_1_to_router_0_1_req;
floo_rsp_t router_0_1_to_router_1_1_rsp;

floo_req_t router_1_1_to_router_1_0_req;
floo_rsp_t router_1_0_to_router_1_1_rsp;

floo_req_t router_1_1_to_router_1_2_req;
floo_rsp_t router_1_2_to_router_1_1_rsp;

floo_req_t router_1_1_to_router_2_1_req;
floo_rsp_t router_2_1_to_router_1_1_rsp;

floo_req_t router_1_1_to_magia_tile_ni_1_1_req;
floo_rsp_t magia_tile_ni_1_1_to_router_1_1_rsp;

floo_req_t router_1_2_to_router_0_2_req;
floo_rsp_t router_0_2_to_router_1_2_rsp;

floo_req_t router_1_2_to_router_1_1_req;
floo_rsp_t router_1_1_to_router_1_2_rsp;

floo_req_t router_1_2_to_router_1_3_req;
floo_rsp_t router_1_3_to_router_1_2_rsp;

floo_req_t router_1_2_to_router_2_2_req;
floo_rsp_t router_2_2_to_router_1_2_rsp;

floo_req_t router_1_2_to_magia_tile_ni_1_2_req;
floo_rsp_t magia_tile_ni_1_2_to_router_1_2_rsp;

floo_req_t router_1_3_to_router_0_3_req;
floo_rsp_t router_0_3_to_router_1_3_rsp;

floo_req_t router_1_3_to_router_1_2_req;
floo_rsp_t router_1_2_to_router_1_3_rsp;

floo_req_t router_1_3_to_router_1_4_req;
floo_rsp_t router_1_4_to_router_1_3_rsp;

floo_req_t router_1_3_to_router_2_3_req;
floo_rsp_t router_2_3_to_router_1_3_rsp;

floo_req_t router_1_3_to_magia_tile_ni_1_3_req;
floo_rsp_t magia_tile_ni_1_3_to_router_1_3_rsp;

floo_req_t router_1_4_to_router_0_4_req;
floo_rsp_t router_0_4_to_router_1_4_rsp;

floo_req_t router_1_4_to_router_1_3_req;
floo_rsp_t router_1_3_to_router_1_4_rsp;

floo_req_t router_1_4_to_router_1_5_req;
floo_rsp_t router_1_5_to_router_1_4_rsp;

floo_req_t router_1_4_to_router_2_4_req;
floo_rsp_t router_2_4_to_router_1_4_rsp;

floo_req_t router_1_4_to_magia_tile_ni_1_4_req;
floo_rsp_t magia_tile_ni_1_4_to_router_1_4_rsp;

floo_req_t router_1_5_to_router_0_5_req;
floo_rsp_t router_0_5_to_router_1_5_rsp;

floo_req_t router_1_5_to_router_1_4_req;
floo_rsp_t router_1_4_to_router_1_5_rsp;

floo_req_t router_1_5_to_router_1_6_req;
floo_rsp_t router_1_6_to_router_1_5_rsp;

floo_req_t router_1_5_to_router_2_5_req;
floo_rsp_t router_2_5_to_router_1_5_rsp;

floo_req_t router_1_5_to_magia_tile_ni_1_5_req;
floo_rsp_t magia_tile_ni_1_5_to_router_1_5_rsp;

floo_req_t router_1_6_to_router_0_6_req;
floo_rsp_t router_0_6_to_router_1_6_rsp;

floo_req_t router_1_6_to_router_1_5_req;
floo_rsp_t router_1_5_to_router_1_6_rsp;

floo_req_t router_1_6_to_router_1_7_req;
floo_rsp_t router_1_7_to_router_1_6_rsp;

floo_req_t router_1_6_to_router_2_6_req;
floo_rsp_t router_2_6_to_router_1_6_rsp;

floo_req_t router_1_6_to_magia_tile_ni_1_6_req;
floo_rsp_t magia_tile_ni_1_6_to_router_1_6_rsp;

floo_req_t router_1_7_to_router_0_7_req;
floo_rsp_t router_0_7_to_router_1_7_rsp;

floo_req_t router_1_7_to_router_1_6_req;
floo_rsp_t router_1_6_to_router_1_7_rsp;

floo_req_t router_1_7_to_router_2_7_req;
floo_rsp_t router_2_7_to_router_1_7_rsp;

floo_req_t router_1_7_to_magia_tile_ni_1_7_req;
floo_rsp_t magia_tile_ni_1_7_to_router_1_7_rsp;

floo_req_t router_2_0_to_router_1_0_req;
floo_rsp_t router_1_0_to_router_2_0_rsp;

floo_req_t router_2_0_to_router_2_1_req;
floo_rsp_t router_2_1_to_router_2_0_rsp;

floo_req_t router_2_0_to_router_3_0_req;
floo_rsp_t router_3_0_to_router_2_0_rsp;

floo_req_t router_2_0_to_magia_tile_ni_2_0_req;
floo_rsp_t magia_tile_ni_2_0_to_router_2_0_rsp;

floo_req_t router_2_1_to_router_1_1_req;
floo_rsp_t router_1_1_to_router_2_1_rsp;

floo_req_t router_2_1_to_router_2_0_req;
floo_rsp_t router_2_0_to_router_2_1_rsp;

floo_req_t router_2_1_to_router_2_2_req;
floo_rsp_t router_2_2_to_router_2_1_rsp;

floo_req_t router_2_1_to_router_3_1_req;
floo_rsp_t router_3_1_to_router_2_1_rsp;

floo_req_t router_2_1_to_magia_tile_ni_2_1_req;
floo_rsp_t magia_tile_ni_2_1_to_router_2_1_rsp;

floo_req_t router_2_2_to_router_1_2_req;
floo_rsp_t router_1_2_to_router_2_2_rsp;

floo_req_t router_2_2_to_router_2_1_req;
floo_rsp_t router_2_1_to_router_2_2_rsp;

floo_req_t router_2_2_to_router_2_3_req;
floo_rsp_t router_2_3_to_router_2_2_rsp;

floo_req_t router_2_2_to_router_3_2_req;
floo_rsp_t router_3_2_to_router_2_2_rsp;

floo_req_t router_2_2_to_magia_tile_ni_2_2_req;
floo_rsp_t magia_tile_ni_2_2_to_router_2_2_rsp;

floo_req_t router_2_3_to_router_1_3_req;
floo_rsp_t router_1_3_to_router_2_3_rsp;

floo_req_t router_2_3_to_router_2_2_req;
floo_rsp_t router_2_2_to_router_2_3_rsp;

floo_req_t router_2_3_to_router_2_4_req;
floo_rsp_t router_2_4_to_router_2_3_rsp;

floo_req_t router_2_3_to_router_3_3_req;
floo_rsp_t router_3_3_to_router_2_3_rsp;

floo_req_t router_2_3_to_magia_tile_ni_2_3_req;
floo_rsp_t magia_tile_ni_2_3_to_router_2_3_rsp;

floo_req_t router_2_4_to_router_1_4_req;
floo_rsp_t router_1_4_to_router_2_4_rsp;

floo_req_t router_2_4_to_router_2_3_req;
floo_rsp_t router_2_3_to_router_2_4_rsp;

floo_req_t router_2_4_to_router_2_5_req;
floo_rsp_t router_2_5_to_router_2_4_rsp;

floo_req_t router_2_4_to_router_3_4_req;
floo_rsp_t router_3_4_to_router_2_4_rsp;

floo_req_t router_2_4_to_magia_tile_ni_2_4_req;
floo_rsp_t magia_tile_ni_2_4_to_router_2_4_rsp;

floo_req_t router_2_5_to_router_1_5_req;
floo_rsp_t router_1_5_to_router_2_5_rsp;

floo_req_t router_2_5_to_router_2_4_req;
floo_rsp_t router_2_4_to_router_2_5_rsp;

floo_req_t router_2_5_to_router_2_6_req;
floo_rsp_t router_2_6_to_router_2_5_rsp;

floo_req_t router_2_5_to_router_3_5_req;
floo_rsp_t router_3_5_to_router_2_5_rsp;

floo_req_t router_2_5_to_magia_tile_ni_2_5_req;
floo_rsp_t magia_tile_ni_2_5_to_router_2_5_rsp;

floo_req_t router_2_6_to_router_1_6_req;
floo_rsp_t router_1_6_to_router_2_6_rsp;

floo_req_t router_2_6_to_router_2_5_req;
floo_rsp_t router_2_5_to_router_2_6_rsp;

floo_req_t router_2_6_to_router_2_7_req;
floo_rsp_t router_2_7_to_router_2_6_rsp;

floo_req_t router_2_6_to_router_3_6_req;
floo_rsp_t router_3_6_to_router_2_6_rsp;

floo_req_t router_2_6_to_magia_tile_ni_2_6_req;
floo_rsp_t magia_tile_ni_2_6_to_router_2_6_rsp;

floo_req_t router_2_7_to_router_1_7_req;
floo_rsp_t router_1_7_to_router_2_7_rsp;

floo_req_t router_2_7_to_router_2_6_req;
floo_rsp_t router_2_6_to_router_2_7_rsp;

floo_req_t router_2_7_to_router_3_7_req;
floo_rsp_t router_3_7_to_router_2_7_rsp;

floo_req_t router_2_7_to_magia_tile_ni_2_7_req;
floo_rsp_t magia_tile_ni_2_7_to_router_2_7_rsp;

floo_req_t router_3_0_to_router_2_0_req;
floo_rsp_t router_2_0_to_router_3_0_rsp;

floo_req_t router_3_0_to_router_3_1_req;
floo_rsp_t router_3_1_to_router_3_0_rsp;

floo_req_t router_3_0_to_router_4_0_req;
floo_rsp_t router_4_0_to_router_3_0_rsp;

floo_req_t router_3_0_to_magia_tile_ni_3_0_req;
floo_rsp_t magia_tile_ni_3_0_to_router_3_0_rsp;

floo_req_t router_3_1_to_router_2_1_req;
floo_rsp_t router_2_1_to_router_3_1_rsp;

floo_req_t router_3_1_to_router_3_0_req;
floo_rsp_t router_3_0_to_router_3_1_rsp;

floo_req_t router_3_1_to_router_3_2_req;
floo_rsp_t router_3_2_to_router_3_1_rsp;

floo_req_t router_3_1_to_router_4_1_req;
floo_rsp_t router_4_1_to_router_3_1_rsp;

floo_req_t router_3_1_to_magia_tile_ni_3_1_req;
floo_rsp_t magia_tile_ni_3_1_to_router_3_1_rsp;

floo_req_t router_3_2_to_router_2_2_req;
floo_rsp_t router_2_2_to_router_3_2_rsp;

floo_req_t router_3_2_to_router_3_1_req;
floo_rsp_t router_3_1_to_router_3_2_rsp;

floo_req_t router_3_2_to_router_3_3_req;
floo_rsp_t router_3_3_to_router_3_2_rsp;

floo_req_t router_3_2_to_router_4_2_req;
floo_rsp_t router_4_2_to_router_3_2_rsp;

floo_req_t router_3_2_to_magia_tile_ni_3_2_req;
floo_rsp_t magia_tile_ni_3_2_to_router_3_2_rsp;

floo_req_t router_3_3_to_router_2_3_req;
floo_rsp_t router_2_3_to_router_3_3_rsp;

floo_req_t router_3_3_to_router_3_2_req;
floo_rsp_t router_3_2_to_router_3_3_rsp;

floo_req_t router_3_3_to_router_3_4_req;
floo_rsp_t router_3_4_to_router_3_3_rsp;

floo_req_t router_3_3_to_router_4_3_req;
floo_rsp_t router_4_3_to_router_3_3_rsp;

floo_req_t router_3_3_to_magia_tile_ni_3_3_req;
floo_rsp_t magia_tile_ni_3_3_to_router_3_3_rsp;

floo_req_t router_3_4_to_router_2_4_req;
floo_rsp_t router_2_4_to_router_3_4_rsp;

floo_req_t router_3_4_to_router_3_3_req;
floo_rsp_t router_3_3_to_router_3_4_rsp;

floo_req_t router_3_4_to_router_3_5_req;
floo_rsp_t router_3_5_to_router_3_4_rsp;

floo_req_t router_3_4_to_router_4_4_req;
floo_rsp_t router_4_4_to_router_3_4_rsp;

floo_req_t router_3_4_to_magia_tile_ni_3_4_req;
floo_rsp_t magia_tile_ni_3_4_to_router_3_4_rsp;

floo_req_t router_3_5_to_router_2_5_req;
floo_rsp_t router_2_5_to_router_3_5_rsp;

floo_req_t router_3_5_to_router_3_4_req;
floo_rsp_t router_3_4_to_router_3_5_rsp;

floo_req_t router_3_5_to_router_3_6_req;
floo_rsp_t router_3_6_to_router_3_5_rsp;

floo_req_t router_3_5_to_router_4_5_req;
floo_rsp_t router_4_5_to_router_3_5_rsp;

floo_req_t router_3_5_to_magia_tile_ni_3_5_req;
floo_rsp_t magia_tile_ni_3_5_to_router_3_5_rsp;

floo_req_t router_3_6_to_router_2_6_req;
floo_rsp_t router_2_6_to_router_3_6_rsp;

floo_req_t router_3_6_to_router_3_5_req;
floo_rsp_t router_3_5_to_router_3_6_rsp;

floo_req_t router_3_6_to_router_3_7_req;
floo_rsp_t router_3_7_to_router_3_6_rsp;

floo_req_t router_3_6_to_router_4_6_req;
floo_rsp_t router_4_6_to_router_3_6_rsp;

floo_req_t router_3_6_to_magia_tile_ni_3_6_req;
floo_rsp_t magia_tile_ni_3_6_to_router_3_6_rsp;

floo_req_t router_3_7_to_router_2_7_req;
floo_rsp_t router_2_7_to_router_3_7_rsp;

floo_req_t router_3_7_to_router_3_6_req;
floo_rsp_t router_3_6_to_router_3_7_rsp;

floo_req_t router_3_7_to_router_4_7_req;
floo_rsp_t router_4_7_to_router_3_7_rsp;

floo_req_t router_3_7_to_magia_tile_ni_3_7_req;
floo_rsp_t magia_tile_ni_3_7_to_router_3_7_rsp;

floo_req_t router_4_0_to_router_3_0_req;
floo_rsp_t router_3_0_to_router_4_0_rsp;

floo_req_t router_4_0_to_router_4_1_req;
floo_rsp_t router_4_1_to_router_4_0_rsp;

floo_req_t router_4_0_to_router_5_0_req;
floo_rsp_t router_5_0_to_router_4_0_rsp;

floo_req_t router_4_0_to_magia_tile_ni_4_0_req;
floo_rsp_t magia_tile_ni_4_0_to_router_4_0_rsp;

floo_req_t router_4_1_to_router_3_1_req;
floo_rsp_t router_3_1_to_router_4_1_rsp;

floo_req_t router_4_1_to_router_4_0_req;
floo_rsp_t router_4_0_to_router_4_1_rsp;

floo_req_t router_4_1_to_router_4_2_req;
floo_rsp_t router_4_2_to_router_4_1_rsp;

floo_req_t router_4_1_to_router_5_1_req;
floo_rsp_t router_5_1_to_router_4_1_rsp;

floo_req_t router_4_1_to_magia_tile_ni_4_1_req;
floo_rsp_t magia_tile_ni_4_1_to_router_4_1_rsp;

floo_req_t router_4_2_to_router_3_2_req;
floo_rsp_t router_3_2_to_router_4_2_rsp;

floo_req_t router_4_2_to_router_4_1_req;
floo_rsp_t router_4_1_to_router_4_2_rsp;

floo_req_t router_4_2_to_router_4_3_req;
floo_rsp_t router_4_3_to_router_4_2_rsp;

floo_req_t router_4_2_to_router_5_2_req;
floo_rsp_t router_5_2_to_router_4_2_rsp;

floo_req_t router_4_2_to_magia_tile_ni_4_2_req;
floo_rsp_t magia_tile_ni_4_2_to_router_4_2_rsp;

floo_req_t router_4_3_to_router_3_3_req;
floo_rsp_t router_3_3_to_router_4_3_rsp;

floo_req_t router_4_3_to_router_4_2_req;
floo_rsp_t router_4_2_to_router_4_3_rsp;

floo_req_t router_4_3_to_router_4_4_req;
floo_rsp_t router_4_4_to_router_4_3_rsp;

floo_req_t router_4_3_to_router_5_3_req;
floo_rsp_t router_5_3_to_router_4_3_rsp;

floo_req_t router_4_3_to_magia_tile_ni_4_3_req;
floo_rsp_t magia_tile_ni_4_3_to_router_4_3_rsp;

floo_req_t router_4_4_to_router_3_4_req;
floo_rsp_t router_3_4_to_router_4_4_rsp;

floo_req_t router_4_4_to_router_4_3_req;
floo_rsp_t router_4_3_to_router_4_4_rsp;

floo_req_t router_4_4_to_router_4_5_req;
floo_rsp_t router_4_5_to_router_4_4_rsp;

floo_req_t router_4_4_to_router_5_4_req;
floo_rsp_t router_5_4_to_router_4_4_rsp;

floo_req_t router_4_4_to_magia_tile_ni_4_4_req;
floo_rsp_t magia_tile_ni_4_4_to_router_4_4_rsp;

floo_req_t router_4_5_to_router_3_5_req;
floo_rsp_t router_3_5_to_router_4_5_rsp;

floo_req_t router_4_5_to_router_4_4_req;
floo_rsp_t router_4_4_to_router_4_5_rsp;

floo_req_t router_4_5_to_router_4_6_req;
floo_rsp_t router_4_6_to_router_4_5_rsp;

floo_req_t router_4_5_to_router_5_5_req;
floo_rsp_t router_5_5_to_router_4_5_rsp;

floo_req_t router_4_5_to_magia_tile_ni_4_5_req;
floo_rsp_t magia_tile_ni_4_5_to_router_4_5_rsp;

floo_req_t router_4_6_to_router_3_6_req;
floo_rsp_t router_3_6_to_router_4_6_rsp;

floo_req_t router_4_6_to_router_4_5_req;
floo_rsp_t router_4_5_to_router_4_6_rsp;

floo_req_t router_4_6_to_router_4_7_req;
floo_rsp_t router_4_7_to_router_4_6_rsp;

floo_req_t router_4_6_to_router_5_6_req;
floo_rsp_t router_5_6_to_router_4_6_rsp;

floo_req_t router_4_6_to_magia_tile_ni_4_6_req;
floo_rsp_t magia_tile_ni_4_6_to_router_4_6_rsp;

floo_req_t router_4_7_to_router_3_7_req;
floo_rsp_t router_3_7_to_router_4_7_rsp;

floo_req_t router_4_7_to_router_4_6_req;
floo_rsp_t router_4_6_to_router_4_7_rsp;

floo_req_t router_4_7_to_router_5_7_req;
floo_rsp_t router_5_7_to_router_4_7_rsp;

floo_req_t router_4_7_to_magia_tile_ni_4_7_req;
floo_rsp_t magia_tile_ni_4_7_to_router_4_7_rsp;

floo_req_t router_5_0_to_router_4_0_req;
floo_rsp_t router_4_0_to_router_5_0_rsp;

floo_req_t router_5_0_to_router_5_1_req;
floo_rsp_t router_5_1_to_router_5_0_rsp;

floo_req_t router_5_0_to_router_6_0_req;
floo_rsp_t router_6_0_to_router_5_0_rsp;

floo_req_t router_5_0_to_magia_tile_ni_5_0_req;
floo_rsp_t magia_tile_ni_5_0_to_router_5_0_rsp;

floo_req_t router_5_1_to_router_4_1_req;
floo_rsp_t router_4_1_to_router_5_1_rsp;

floo_req_t router_5_1_to_router_5_0_req;
floo_rsp_t router_5_0_to_router_5_1_rsp;

floo_req_t router_5_1_to_router_5_2_req;
floo_rsp_t router_5_2_to_router_5_1_rsp;

floo_req_t router_5_1_to_router_6_1_req;
floo_rsp_t router_6_1_to_router_5_1_rsp;

floo_req_t router_5_1_to_magia_tile_ni_5_1_req;
floo_rsp_t magia_tile_ni_5_1_to_router_5_1_rsp;

floo_req_t router_5_2_to_router_4_2_req;
floo_rsp_t router_4_2_to_router_5_2_rsp;

floo_req_t router_5_2_to_router_5_1_req;
floo_rsp_t router_5_1_to_router_5_2_rsp;

floo_req_t router_5_2_to_router_5_3_req;
floo_rsp_t router_5_3_to_router_5_2_rsp;

floo_req_t router_5_2_to_router_6_2_req;
floo_rsp_t router_6_2_to_router_5_2_rsp;

floo_req_t router_5_2_to_magia_tile_ni_5_2_req;
floo_rsp_t magia_tile_ni_5_2_to_router_5_2_rsp;

floo_req_t router_5_3_to_router_4_3_req;
floo_rsp_t router_4_3_to_router_5_3_rsp;

floo_req_t router_5_3_to_router_5_2_req;
floo_rsp_t router_5_2_to_router_5_3_rsp;

floo_req_t router_5_3_to_router_5_4_req;
floo_rsp_t router_5_4_to_router_5_3_rsp;

floo_req_t router_5_3_to_router_6_3_req;
floo_rsp_t router_6_3_to_router_5_3_rsp;

floo_req_t router_5_3_to_magia_tile_ni_5_3_req;
floo_rsp_t magia_tile_ni_5_3_to_router_5_3_rsp;

floo_req_t router_5_4_to_router_4_4_req;
floo_rsp_t router_4_4_to_router_5_4_rsp;

floo_req_t router_5_4_to_router_5_3_req;
floo_rsp_t router_5_3_to_router_5_4_rsp;

floo_req_t router_5_4_to_router_5_5_req;
floo_rsp_t router_5_5_to_router_5_4_rsp;

floo_req_t router_5_4_to_router_6_4_req;
floo_rsp_t router_6_4_to_router_5_4_rsp;

floo_req_t router_5_4_to_magia_tile_ni_5_4_req;
floo_rsp_t magia_tile_ni_5_4_to_router_5_4_rsp;

floo_req_t router_5_5_to_router_4_5_req;
floo_rsp_t router_4_5_to_router_5_5_rsp;

floo_req_t router_5_5_to_router_5_4_req;
floo_rsp_t router_5_4_to_router_5_5_rsp;

floo_req_t router_5_5_to_router_5_6_req;
floo_rsp_t router_5_6_to_router_5_5_rsp;

floo_req_t router_5_5_to_router_6_5_req;
floo_rsp_t router_6_5_to_router_5_5_rsp;

floo_req_t router_5_5_to_magia_tile_ni_5_5_req;
floo_rsp_t magia_tile_ni_5_5_to_router_5_5_rsp;

floo_req_t router_5_6_to_router_4_6_req;
floo_rsp_t router_4_6_to_router_5_6_rsp;

floo_req_t router_5_6_to_router_5_5_req;
floo_rsp_t router_5_5_to_router_5_6_rsp;

floo_req_t router_5_6_to_router_5_7_req;
floo_rsp_t router_5_7_to_router_5_6_rsp;

floo_req_t router_5_6_to_router_6_6_req;
floo_rsp_t router_6_6_to_router_5_6_rsp;

floo_req_t router_5_6_to_magia_tile_ni_5_6_req;
floo_rsp_t magia_tile_ni_5_6_to_router_5_6_rsp;

floo_req_t router_5_7_to_router_4_7_req;
floo_rsp_t router_4_7_to_router_5_7_rsp;

floo_req_t router_5_7_to_router_5_6_req;
floo_rsp_t router_5_6_to_router_5_7_rsp;

floo_req_t router_5_7_to_router_6_7_req;
floo_rsp_t router_6_7_to_router_5_7_rsp;

floo_req_t router_5_7_to_magia_tile_ni_5_7_req;
floo_rsp_t magia_tile_ni_5_7_to_router_5_7_rsp;

floo_req_t router_6_0_to_router_5_0_req;
floo_rsp_t router_5_0_to_router_6_0_rsp;

floo_req_t router_6_0_to_router_6_1_req;
floo_rsp_t router_6_1_to_router_6_0_rsp;

floo_req_t router_6_0_to_router_7_0_req;
floo_rsp_t router_7_0_to_router_6_0_rsp;

floo_req_t router_6_0_to_magia_tile_ni_6_0_req;
floo_rsp_t magia_tile_ni_6_0_to_router_6_0_rsp;

floo_req_t router_6_1_to_router_5_1_req;
floo_rsp_t router_5_1_to_router_6_1_rsp;

floo_req_t router_6_1_to_router_6_0_req;
floo_rsp_t router_6_0_to_router_6_1_rsp;

floo_req_t router_6_1_to_router_6_2_req;
floo_rsp_t router_6_2_to_router_6_1_rsp;

floo_req_t router_6_1_to_router_7_1_req;
floo_rsp_t router_7_1_to_router_6_1_rsp;

floo_req_t router_6_1_to_magia_tile_ni_6_1_req;
floo_rsp_t magia_tile_ni_6_1_to_router_6_1_rsp;

floo_req_t router_6_2_to_router_5_2_req;
floo_rsp_t router_5_2_to_router_6_2_rsp;

floo_req_t router_6_2_to_router_6_1_req;
floo_rsp_t router_6_1_to_router_6_2_rsp;

floo_req_t router_6_2_to_router_6_3_req;
floo_rsp_t router_6_3_to_router_6_2_rsp;

floo_req_t router_6_2_to_router_7_2_req;
floo_rsp_t router_7_2_to_router_6_2_rsp;

floo_req_t router_6_2_to_magia_tile_ni_6_2_req;
floo_rsp_t magia_tile_ni_6_2_to_router_6_2_rsp;

floo_req_t router_6_3_to_router_5_3_req;
floo_rsp_t router_5_3_to_router_6_3_rsp;

floo_req_t router_6_3_to_router_6_2_req;
floo_rsp_t router_6_2_to_router_6_3_rsp;

floo_req_t router_6_3_to_router_6_4_req;
floo_rsp_t router_6_4_to_router_6_3_rsp;

floo_req_t router_6_3_to_router_7_3_req;
floo_rsp_t router_7_3_to_router_6_3_rsp;

floo_req_t router_6_3_to_magia_tile_ni_6_3_req;
floo_rsp_t magia_tile_ni_6_3_to_router_6_3_rsp;

floo_req_t router_6_4_to_router_5_4_req;
floo_rsp_t router_5_4_to_router_6_4_rsp;

floo_req_t router_6_4_to_router_6_3_req;
floo_rsp_t router_6_3_to_router_6_4_rsp;

floo_req_t router_6_4_to_router_6_5_req;
floo_rsp_t router_6_5_to_router_6_4_rsp;

floo_req_t router_6_4_to_router_7_4_req;
floo_rsp_t router_7_4_to_router_6_4_rsp;

floo_req_t router_6_4_to_magia_tile_ni_6_4_req;
floo_rsp_t magia_tile_ni_6_4_to_router_6_4_rsp;

floo_req_t router_6_5_to_router_5_5_req;
floo_rsp_t router_5_5_to_router_6_5_rsp;

floo_req_t router_6_5_to_router_6_4_req;
floo_rsp_t router_6_4_to_router_6_5_rsp;

floo_req_t router_6_5_to_router_6_6_req;
floo_rsp_t router_6_6_to_router_6_5_rsp;

floo_req_t router_6_5_to_router_7_5_req;
floo_rsp_t router_7_5_to_router_6_5_rsp;

floo_req_t router_6_5_to_magia_tile_ni_6_5_req;
floo_rsp_t magia_tile_ni_6_5_to_router_6_5_rsp;

floo_req_t router_6_6_to_router_5_6_req;
floo_rsp_t router_5_6_to_router_6_6_rsp;

floo_req_t router_6_6_to_router_6_5_req;
floo_rsp_t router_6_5_to_router_6_6_rsp;

floo_req_t router_6_6_to_router_6_7_req;
floo_rsp_t router_6_7_to_router_6_6_rsp;

floo_req_t router_6_6_to_router_7_6_req;
floo_rsp_t router_7_6_to_router_6_6_rsp;

floo_req_t router_6_6_to_magia_tile_ni_6_6_req;
floo_rsp_t magia_tile_ni_6_6_to_router_6_6_rsp;

floo_req_t router_6_7_to_router_5_7_req;
floo_rsp_t router_5_7_to_router_6_7_rsp;

floo_req_t router_6_7_to_router_6_6_req;
floo_rsp_t router_6_6_to_router_6_7_rsp;

floo_req_t router_6_7_to_router_7_7_req;
floo_rsp_t router_7_7_to_router_6_7_rsp;

floo_req_t router_6_7_to_magia_tile_ni_6_7_req;
floo_rsp_t magia_tile_ni_6_7_to_router_6_7_rsp;

floo_req_t router_7_0_to_router_6_0_req;
floo_rsp_t router_6_0_to_router_7_0_rsp;

floo_req_t router_7_0_to_router_7_1_req;
floo_rsp_t router_7_1_to_router_7_0_rsp;

floo_req_t router_7_0_to_magia_tile_ni_7_0_req;
floo_rsp_t magia_tile_ni_7_0_to_router_7_0_rsp;

floo_req_t router_7_1_to_router_6_1_req;
floo_rsp_t router_6_1_to_router_7_1_rsp;

floo_req_t router_7_1_to_router_7_0_req;
floo_rsp_t router_7_0_to_router_7_1_rsp;

floo_req_t router_7_1_to_router_7_2_req;
floo_rsp_t router_7_2_to_router_7_1_rsp;

floo_req_t router_7_1_to_magia_tile_ni_7_1_req;
floo_rsp_t magia_tile_ni_7_1_to_router_7_1_rsp;

floo_req_t router_7_2_to_router_6_2_req;
floo_rsp_t router_6_2_to_router_7_2_rsp;

floo_req_t router_7_2_to_router_7_1_req;
floo_rsp_t router_7_1_to_router_7_2_rsp;

floo_req_t router_7_2_to_router_7_3_req;
floo_rsp_t router_7_3_to_router_7_2_rsp;

floo_req_t router_7_2_to_magia_tile_ni_7_2_req;
floo_rsp_t magia_tile_ni_7_2_to_router_7_2_rsp;

floo_req_t router_7_3_to_router_6_3_req;
floo_rsp_t router_6_3_to_router_7_3_rsp;

floo_req_t router_7_3_to_router_7_2_req;
floo_rsp_t router_7_2_to_router_7_3_rsp;

floo_req_t router_7_3_to_router_7_4_req;
floo_rsp_t router_7_4_to_router_7_3_rsp;

floo_req_t router_7_3_to_magia_tile_ni_7_3_req;
floo_rsp_t magia_tile_ni_7_3_to_router_7_3_rsp;

floo_req_t router_7_4_to_router_6_4_req;
floo_rsp_t router_6_4_to_router_7_4_rsp;

floo_req_t router_7_4_to_router_7_3_req;
floo_rsp_t router_7_3_to_router_7_4_rsp;

floo_req_t router_7_4_to_router_7_5_req;
floo_rsp_t router_7_5_to_router_7_4_rsp;

floo_req_t router_7_4_to_magia_tile_ni_7_4_req;
floo_rsp_t magia_tile_ni_7_4_to_router_7_4_rsp;

floo_req_t router_7_5_to_router_6_5_req;
floo_rsp_t router_6_5_to_router_7_5_rsp;

floo_req_t router_7_5_to_router_7_4_req;
floo_rsp_t router_7_4_to_router_7_5_rsp;

floo_req_t router_7_5_to_router_7_6_req;
floo_rsp_t router_7_6_to_router_7_5_rsp;

floo_req_t router_7_5_to_magia_tile_ni_7_5_req;
floo_rsp_t magia_tile_ni_7_5_to_router_7_5_rsp;

floo_req_t router_7_6_to_router_6_6_req;
floo_rsp_t router_6_6_to_router_7_6_rsp;

floo_req_t router_7_6_to_router_7_5_req;
floo_rsp_t router_7_5_to_router_7_6_rsp;

floo_req_t router_7_6_to_router_7_7_req;
floo_rsp_t router_7_7_to_router_7_6_rsp;

floo_req_t router_7_6_to_magia_tile_ni_7_6_req;
floo_rsp_t magia_tile_ni_7_6_to_router_7_6_rsp;

floo_req_t router_7_7_to_router_6_7_req;
floo_rsp_t router_6_7_to_router_7_7_rsp;

floo_req_t router_7_7_to_router_7_6_req;
floo_rsp_t router_7_6_to_router_7_7_rsp;

floo_req_t router_7_7_to_magia_tile_ni_7_7_req;
floo_rsp_t magia_tile_ni_7_7_to_router_7_7_rsp;

floo_req_t magia_tile_ni_0_0_to_router_0_0_req;
floo_rsp_t router_0_0_to_magia_tile_ni_0_0_rsp;

floo_req_t magia_tile_ni_0_1_to_router_0_1_req;
floo_rsp_t router_0_1_to_magia_tile_ni_0_1_rsp;

floo_req_t magia_tile_ni_0_2_to_router_0_2_req;
floo_rsp_t router_0_2_to_magia_tile_ni_0_2_rsp;

floo_req_t magia_tile_ni_0_3_to_router_0_3_req;
floo_rsp_t router_0_3_to_magia_tile_ni_0_3_rsp;

floo_req_t magia_tile_ni_0_4_to_router_0_4_req;
floo_rsp_t router_0_4_to_magia_tile_ni_0_4_rsp;

floo_req_t magia_tile_ni_0_5_to_router_0_5_req;
floo_rsp_t router_0_5_to_magia_tile_ni_0_5_rsp;

floo_req_t magia_tile_ni_0_6_to_router_0_6_req;
floo_rsp_t router_0_6_to_magia_tile_ni_0_6_rsp;

floo_req_t magia_tile_ni_0_7_to_router_0_7_req;
floo_rsp_t router_0_7_to_magia_tile_ni_0_7_rsp;

floo_req_t magia_tile_ni_1_0_to_router_1_0_req;
floo_rsp_t router_1_0_to_magia_tile_ni_1_0_rsp;

floo_req_t magia_tile_ni_1_1_to_router_1_1_req;
floo_rsp_t router_1_1_to_magia_tile_ni_1_1_rsp;

floo_req_t magia_tile_ni_1_2_to_router_1_2_req;
floo_rsp_t router_1_2_to_magia_tile_ni_1_2_rsp;

floo_req_t magia_tile_ni_1_3_to_router_1_3_req;
floo_rsp_t router_1_3_to_magia_tile_ni_1_3_rsp;

floo_req_t magia_tile_ni_1_4_to_router_1_4_req;
floo_rsp_t router_1_4_to_magia_tile_ni_1_4_rsp;

floo_req_t magia_tile_ni_1_5_to_router_1_5_req;
floo_rsp_t router_1_5_to_magia_tile_ni_1_5_rsp;

floo_req_t magia_tile_ni_1_6_to_router_1_6_req;
floo_rsp_t router_1_6_to_magia_tile_ni_1_6_rsp;

floo_req_t magia_tile_ni_1_7_to_router_1_7_req;
floo_rsp_t router_1_7_to_magia_tile_ni_1_7_rsp;

floo_req_t magia_tile_ni_2_0_to_router_2_0_req;
floo_rsp_t router_2_0_to_magia_tile_ni_2_0_rsp;

floo_req_t magia_tile_ni_2_1_to_router_2_1_req;
floo_rsp_t router_2_1_to_magia_tile_ni_2_1_rsp;

floo_req_t magia_tile_ni_2_2_to_router_2_2_req;
floo_rsp_t router_2_2_to_magia_tile_ni_2_2_rsp;

floo_req_t magia_tile_ni_2_3_to_router_2_3_req;
floo_rsp_t router_2_3_to_magia_tile_ni_2_3_rsp;

floo_req_t magia_tile_ni_2_4_to_router_2_4_req;
floo_rsp_t router_2_4_to_magia_tile_ni_2_4_rsp;

floo_req_t magia_tile_ni_2_5_to_router_2_5_req;
floo_rsp_t router_2_5_to_magia_tile_ni_2_5_rsp;

floo_req_t magia_tile_ni_2_6_to_router_2_6_req;
floo_rsp_t router_2_6_to_magia_tile_ni_2_6_rsp;

floo_req_t magia_tile_ni_2_7_to_router_2_7_req;
floo_rsp_t router_2_7_to_magia_tile_ni_2_7_rsp;

floo_req_t magia_tile_ni_3_0_to_router_3_0_req;
floo_rsp_t router_3_0_to_magia_tile_ni_3_0_rsp;

floo_req_t magia_tile_ni_3_1_to_router_3_1_req;
floo_rsp_t router_3_1_to_magia_tile_ni_3_1_rsp;

floo_req_t magia_tile_ni_3_2_to_router_3_2_req;
floo_rsp_t router_3_2_to_magia_tile_ni_3_2_rsp;

floo_req_t magia_tile_ni_3_3_to_router_3_3_req;
floo_rsp_t router_3_3_to_magia_tile_ni_3_3_rsp;

floo_req_t magia_tile_ni_3_4_to_router_3_4_req;
floo_rsp_t router_3_4_to_magia_tile_ni_3_4_rsp;

floo_req_t magia_tile_ni_3_5_to_router_3_5_req;
floo_rsp_t router_3_5_to_magia_tile_ni_3_5_rsp;

floo_req_t magia_tile_ni_3_6_to_router_3_6_req;
floo_rsp_t router_3_6_to_magia_tile_ni_3_6_rsp;

floo_req_t magia_tile_ni_3_7_to_router_3_7_req;
floo_rsp_t router_3_7_to_magia_tile_ni_3_7_rsp;

floo_req_t magia_tile_ni_4_0_to_router_4_0_req;
floo_rsp_t router_4_0_to_magia_tile_ni_4_0_rsp;

floo_req_t magia_tile_ni_4_1_to_router_4_1_req;
floo_rsp_t router_4_1_to_magia_tile_ni_4_1_rsp;

floo_req_t magia_tile_ni_4_2_to_router_4_2_req;
floo_rsp_t router_4_2_to_magia_tile_ni_4_2_rsp;

floo_req_t magia_tile_ni_4_3_to_router_4_3_req;
floo_rsp_t router_4_3_to_magia_tile_ni_4_3_rsp;

floo_req_t magia_tile_ni_4_4_to_router_4_4_req;
floo_rsp_t router_4_4_to_magia_tile_ni_4_4_rsp;

floo_req_t magia_tile_ni_4_5_to_router_4_5_req;
floo_rsp_t router_4_5_to_magia_tile_ni_4_5_rsp;

floo_req_t magia_tile_ni_4_6_to_router_4_6_req;
floo_rsp_t router_4_6_to_magia_tile_ni_4_6_rsp;

floo_req_t magia_tile_ni_4_7_to_router_4_7_req;
floo_rsp_t router_4_7_to_magia_tile_ni_4_7_rsp;

floo_req_t magia_tile_ni_5_0_to_router_5_0_req;
floo_rsp_t router_5_0_to_magia_tile_ni_5_0_rsp;

floo_req_t magia_tile_ni_5_1_to_router_5_1_req;
floo_rsp_t router_5_1_to_magia_tile_ni_5_1_rsp;

floo_req_t magia_tile_ni_5_2_to_router_5_2_req;
floo_rsp_t router_5_2_to_magia_tile_ni_5_2_rsp;

floo_req_t magia_tile_ni_5_3_to_router_5_3_req;
floo_rsp_t router_5_3_to_magia_tile_ni_5_3_rsp;

floo_req_t magia_tile_ni_5_4_to_router_5_4_req;
floo_rsp_t router_5_4_to_magia_tile_ni_5_4_rsp;

floo_req_t magia_tile_ni_5_5_to_router_5_5_req;
floo_rsp_t router_5_5_to_magia_tile_ni_5_5_rsp;

floo_req_t magia_tile_ni_5_6_to_router_5_6_req;
floo_rsp_t router_5_6_to_magia_tile_ni_5_6_rsp;

floo_req_t magia_tile_ni_5_7_to_router_5_7_req;
floo_rsp_t router_5_7_to_magia_tile_ni_5_7_rsp;

floo_req_t magia_tile_ni_6_0_to_router_6_0_req;
floo_rsp_t router_6_0_to_magia_tile_ni_6_0_rsp;

floo_req_t magia_tile_ni_6_1_to_router_6_1_req;
floo_rsp_t router_6_1_to_magia_tile_ni_6_1_rsp;

floo_req_t magia_tile_ni_6_2_to_router_6_2_req;
floo_rsp_t router_6_2_to_magia_tile_ni_6_2_rsp;

floo_req_t magia_tile_ni_6_3_to_router_6_3_req;
floo_rsp_t router_6_3_to_magia_tile_ni_6_3_rsp;

floo_req_t magia_tile_ni_6_4_to_router_6_4_req;
floo_rsp_t router_6_4_to_magia_tile_ni_6_4_rsp;

floo_req_t magia_tile_ni_6_5_to_router_6_5_req;
floo_rsp_t router_6_5_to_magia_tile_ni_6_5_rsp;

floo_req_t magia_tile_ni_6_6_to_router_6_6_req;
floo_rsp_t router_6_6_to_magia_tile_ni_6_6_rsp;

floo_req_t magia_tile_ni_6_7_to_router_6_7_req;
floo_rsp_t router_6_7_to_magia_tile_ni_6_7_rsp;

floo_req_t magia_tile_ni_7_0_to_router_7_0_req;
floo_rsp_t router_7_0_to_magia_tile_ni_7_0_rsp;

floo_req_t magia_tile_ni_7_1_to_router_7_1_req;
floo_rsp_t router_7_1_to_magia_tile_ni_7_1_rsp;

floo_req_t magia_tile_ni_7_2_to_router_7_2_req;
floo_rsp_t router_7_2_to_magia_tile_ni_7_2_rsp;

floo_req_t magia_tile_ni_7_3_to_router_7_3_req;
floo_rsp_t router_7_3_to_magia_tile_ni_7_3_rsp;

floo_req_t magia_tile_ni_7_4_to_router_7_4_req;
floo_rsp_t router_7_4_to_magia_tile_ni_7_4_rsp;

floo_req_t magia_tile_ni_7_5_to_router_7_5_req;
floo_rsp_t router_7_5_to_magia_tile_ni_7_5_rsp;

floo_req_t magia_tile_ni_7_6_to_router_7_6_req;
floo_rsp_t router_7_6_to_magia_tile_ni_7_6_rsp;

floo_req_t magia_tile_ni_7_7_to_router_7_7_req;
floo_rsp_t router_7_7_to_magia_tile_ni_7_7_rsp;

floo_req_t L2_ni_0_to_router_0_0_req;
floo_rsp_t router_0_0_to_L2_ni_0_rsp;

floo_req_t L2_ni_1_to_router_0_1_req;
floo_rsp_t router_0_1_to_L2_ni_1_rsp;

floo_req_t L2_ni_2_to_router_0_2_req;
floo_rsp_t router_0_2_to_L2_ni_2_rsp;

floo_req_t L2_ni_3_to_router_0_3_req;
floo_rsp_t router_0_3_to_L2_ni_3_rsp;

floo_req_t L2_ni_4_to_router_0_4_req;
floo_rsp_t router_0_4_to_L2_ni_4_rsp;

floo_req_t L2_ni_5_to_router_0_5_req;
floo_rsp_t router_0_5_to_L2_ni_5_rsp;

floo_req_t L2_ni_6_to_router_0_6_req;
floo_rsp_t router_0_6_to_L2_ni_6_rsp;

floo_req_t L2_ni_7_to_router_0_7_req;
floo_rsp_t router_0_7_to_L2_ni_7_rsp;



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
) magia_tile_ni_0_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[0][2] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[0][2] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[0][2] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[0][2] ),
  .id_i             ( '{x: 1, y: 2, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_0_2_to_router_0_2_req   ),
  .floo_rsp_i       ( router_0_2_to_magia_tile_ni_0_2_rsp   ),
  .floo_req_i       ( router_0_2_to_magia_tile_ni_0_2_req   ),
  .floo_rsp_o       ( magia_tile_ni_0_2_to_router_0_2_rsp   )
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
) magia_tile_ni_0_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[0][3] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[0][3] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[0][3] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[0][3] ),
  .id_i             ( '{x: 1, y: 3, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_0_3_to_router_0_3_req   ),
  .floo_rsp_i       ( router_0_3_to_magia_tile_ni_0_3_rsp   ),
  .floo_req_i       ( router_0_3_to_magia_tile_ni_0_3_req   ),
  .floo_rsp_o       ( magia_tile_ni_0_3_to_router_0_3_rsp   )
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
) magia_tile_ni_0_4 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[0][4] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[0][4] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[0][4] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[0][4] ),
  .id_i             ( '{x: 1, y: 4, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_0_4_to_router_0_4_req   ),
  .floo_rsp_i       ( router_0_4_to_magia_tile_ni_0_4_rsp   ),
  .floo_req_i       ( router_0_4_to_magia_tile_ni_0_4_req   ),
  .floo_rsp_o       ( magia_tile_ni_0_4_to_router_0_4_rsp   )
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
) magia_tile_ni_0_5 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[0][5] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[0][5] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[0][5] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[0][5] ),
  .id_i             ( '{x: 1, y: 5, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_0_5_to_router_0_5_req   ),
  .floo_rsp_i       ( router_0_5_to_magia_tile_ni_0_5_rsp   ),
  .floo_req_i       ( router_0_5_to_magia_tile_ni_0_5_req   ),
  .floo_rsp_o       ( magia_tile_ni_0_5_to_router_0_5_rsp   )
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
) magia_tile_ni_0_6 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[0][6] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[0][6] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[0][6] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[0][6] ),
  .id_i             ( '{x: 1, y: 6, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_0_6_to_router_0_6_req   ),
  .floo_rsp_i       ( router_0_6_to_magia_tile_ni_0_6_rsp   ),
  .floo_req_i       ( router_0_6_to_magia_tile_ni_0_6_req   ),
  .floo_rsp_o       ( magia_tile_ni_0_6_to_router_0_6_rsp   )
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
) magia_tile_ni_0_7 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[0][7] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[0][7] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[0][7] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[0][7] ),
  .id_i             ( '{x: 1, y: 7, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_0_7_to_router_0_7_req   ),
  .floo_rsp_i       ( router_0_7_to_magia_tile_ni_0_7_rsp   ),
  .floo_req_i       ( router_0_7_to_magia_tile_ni_0_7_req   ),
  .floo_rsp_o       ( magia_tile_ni_0_7_to_router_0_7_rsp   )
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
) magia_tile_ni_1_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[1][2] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[1][2] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[1][2] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[1][2] ),
  .id_i             ( '{x: 2, y: 2, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_1_2_to_router_1_2_req   ),
  .floo_rsp_i       ( router_1_2_to_magia_tile_ni_1_2_rsp   ),
  .floo_req_i       ( router_1_2_to_magia_tile_ni_1_2_req   ),
  .floo_rsp_o       ( magia_tile_ni_1_2_to_router_1_2_rsp   )
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
) magia_tile_ni_1_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[1][3] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[1][3] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[1][3] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[1][3] ),
  .id_i             ( '{x: 2, y: 3, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_1_3_to_router_1_3_req   ),
  .floo_rsp_i       ( router_1_3_to_magia_tile_ni_1_3_rsp   ),
  .floo_req_i       ( router_1_3_to_magia_tile_ni_1_3_req   ),
  .floo_rsp_o       ( magia_tile_ni_1_3_to_router_1_3_rsp   )
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
) magia_tile_ni_1_4 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[1][4] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[1][4] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[1][4] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[1][4] ),
  .id_i             ( '{x: 2, y: 4, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_1_4_to_router_1_4_req   ),
  .floo_rsp_i       ( router_1_4_to_magia_tile_ni_1_4_rsp   ),
  .floo_req_i       ( router_1_4_to_magia_tile_ni_1_4_req   ),
  .floo_rsp_o       ( magia_tile_ni_1_4_to_router_1_4_rsp   )
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
) magia_tile_ni_1_5 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[1][5] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[1][5] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[1][5] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[1][5] ),
  .id_i             ( '{x: 2, y: 5, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_1_5_to_router_1_5_req   ),
  .floo_rsp_i       ( router_1_5_to_magia_tile_ni_1_5_rsp   ),
  .floo_req_i       ( router_1_5_to_magia_tile_ni_1_5_req   ),
  .floo_rsp_o       ( magia_tile_ni_1_5_to_router_1_5_rsp   )
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
) magia_tile_ni_1_6 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[1][6] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[1][6] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[1][6] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[1][6] ),
  .id_i             ( '{x: 2, y: 6, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_1_6_to_router_1_6_req   ),
  .floo_rsp_i       ( router_1_6_to_magia_tile_ni_1_6_rsp   ),
  .floo_req_i       ( router_1_6_to_magia_tile_ni_1_6_req   ),
  .floo_rsp_o       ( magia_tile_ni_1_6_to_router_1_6_rsp   )
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
) magia_tile_ni_1_7 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[1][7] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[1][7] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[1][7] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[1][7] ),
  .id_i             ( '{x: 2, y: 7, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_1_7_to_router_1_7_req   ),
  .floo_rsp_i       ( router_1_7_to_magia_tile_ni_1_7_rsp   ),
  .floo_req_i       ( router_1_7_to_magia_tile_ni_1_7_req   ),
  .floo_rsp_o       ( magia_tile_ni_1_7_to_router_1_7_rsp   )
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
) magia_tile_ni_2_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[2][0] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[2][0] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[2][0] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[2][0] ),
  .id_i             ( '{x: 3, y: 0, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_2_0_to_router_2_0_req   ),
  .floo_rsp_i       ( router_2_0_to_magia_tile_ni_2_0_rsp   ),
  .floo_req_i       ( router_2_0_to_magia_tile_ni_2_0_req   ),
  .floo_rsp_o       ( magia_tile_ni_2_0_to_router_2_0_rsp   )
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
) magia_tile_ni_2_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[2][1] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[2][1] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[2][1] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[2][1] ),
  .id_i             ( '{x: 3, y: 1, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_2_1_to_router_2_1_req   ),
  .floo_rsp_i       ( router_2_1_to_magia_tile_ni_2_1_rsp   ),
  .floo_req_i       ( router_2_1_to_magia_tile_ni_2_1_req   ),
  .floo_rsp_o       ( magia_tile_ni_2_1_to_router_2_1_rsp   )
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
) magia_tile_ni_2_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[2][2] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[2][2] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[2][2] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[2][2] ),
  .id_i             ( '{x: 3, y: 2, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_2_2_to_router_2_2_req   ),
  .floo_rsp_i       ( router_2_2_to_magia_tile_ni_2_2_rsp   ),
  .floo_req_i       ( router_2_2_to_magia_tile_ni_2_2_req   ),
  .floo_rsp_o       ( magia_tile_ni_2_2_to_router_2_2_rsp   )
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
) magia_tile_ni_2_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[2][3] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[2][3] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[2][3] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[2][3] ),
  .id_i             ( '{x: 3, y: 3, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_2_3_to_router_2_3_req   ),
  .floo_rsp_i       ( router_2_3_to_magia_tile_ni_2_3_rsp   ),
  .floo_req_i       ( router_2_3_to_magia_tile_ni_2_3_req   ),
  .floo_rsp_o       ( magia_tile_ni_2_3_to_router_2_3_rsp   )
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
) magia_tile_ni_2_4 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[2][4] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[2][4] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[2][4] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[2][4] ),
  .id_i             ( '{x: 3, y: 4, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_2_4_to_router_2_4_req   ),
  .floo_rsp_i       ( router_2_4_to_magia_tile_ni_2_4_rsp   ),
  .floo_req_i       ( router_2_4_to_magia_tile_ni_2_4_req   ),
  .floo_rsp_o       ( magia_tile_ni_2_4_to_router_2_4_rsp   )
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
) magia_tile_ni_2_5 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[2][5] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[2][5] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[2][5] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[2][5] ),
  .id_i             ( '{x: 3, y: 5, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_2_5_to_router_2_5_req   ),
  .floo_rsp_i       ( router_2_5_to_magia_tile_ni_2_5_rsp   ),
  .floo_req_i       ( router_2_5_to_magia_tile_ni_2_5_req   ),
  .floo_rsp_o       ( magia_tile_ni_2_5_to_router_2_5_rsp   )
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
) magia_tile_ni_2_6 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[2][6] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[2][6] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[2][6] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[2][6] ),
  .id_i             ( '{x: 3, y: 6, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_2_6_to_router_2_6_req   ),
  .floo_rsp_i       ( router_2_6_to_magia_tile_ni_2_6_rsp   ),
  .floo_req_i       ( router_2_6_to_magia_tile_ni_2_6_req   ),
  .floo_rsp_o       ( magia_tile_ni_2_6_to_router_2_6_rsp   )
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
) magia_tile_ni_2_7 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[2][7] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[2][7] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[2][7] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[2][7] ),
  .id_i             ( '{x: 3, y: 7, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_2_7_to_router_2_7_req   ),
  .floo_rsp_i       ( router_2_7_to_magia_tile_ni_2_7_rsp   ),
  .floo_req_i       ( router_2_7_to_magia_tile_ni_2_7_req   ),
  .floo_rsp_o       ( magia_tile_ni_2_7_to_router_2_7_rsp   )
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
) magia_tile_ni_3_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[3][0] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[3][0] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[3][0] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[3][0] ),
  .id_i             ( '{x: 4, y: 0, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_3_0_to_router_3_0_req   ),
  .floo_rsp_i       ( router_3_0_to_magia_tile_ni_3_0_rsp   ),
  .floo_req_i       ( router_3_0_to_magia_tile_ni_3_0_req   ),
  .floo_rsp_o       ( magia_tile_ni_3_0_to_router_3_0_rsp   )
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
) magia_tile_ni_3_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[3][1] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[3][1] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[3][1] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[3][1] ),
  .id_i             ( '{x: 4, y: 1, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_3_1_to_router_3_1_req   ),
  .floo_rsp_i       ( router_3_1_to_magia_tile_ni_3_1_rsp   ),
  .floo_req_i       ( router_3_1_to_magia_tile_ni_3_1_req   ),
  .floo_rsp_o       ( magia_tile_ni_3_1_to_router_3_1_rsp   )
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
) magia_tile_ni_3_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[3][2] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[3][2] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[3][2] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[3][2] ),
  .id_i             ( '{x: 4, y: 2, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_3_2_to_router_3_2_req   ),
  .floo_rsp_i       ( router_3_2_to_magia_tile_ni_3_2_rsp   ),
  .floo_req_i       ( router_3_2_to_magia_tile_ni_3_2_req   ),
  .floo_rsp_o       ( magia_tile_ni_3_2_to_router_3_2_rsp   )
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
) magia_tile_ni_3_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[3][3] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[3][3] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[3][3] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[3][3] ),
  .id_i             ( '{x: 4, y: 3, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_3_3_to_router_3_3_req   ),
  .floo_rsp_i       ( router_3_3_to_magia_tile_ni_3_3_rsp   ),
  .floo_req_i       ( router_3_3_to_magia_tile_ni_3_3_req   ),
  .floo_rsp_o       ( magia_tile_ni_3_3_to_router_3_3_rsp   )
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
) magia_tile_ni_3_4 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[3][4] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[3][4] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[3][4] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[3][4] ),
  .id_i             ( '{x: 4, y: 4, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_3_4_to_router_3_4_req   ),
  .floo_rsp_i       ( router_3_4_to_magia_tile_ni_3_4_rsp   ),
  .floo_req_i       ( router_3_4_to_magia_tile_ni_3_4_req   ),
  .floo_rsp_o       ( magia_tile_ni_3_4_to_router_3_4_rsp   )
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
) magia_tile_ni_3_5 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[3][5] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[3][5] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[3][5] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[3][5] ),
  .id_i             ( '{x: 4, y: 5, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_3_5_to_router_3_5_req   ),
  .floo_rsp_i       ( router_3_5_to_magia_tile_ni_3_5_rsp   ),
  .floo_req_i       ( router_3_5_to_magia_tile_ni_3_5_req   ),
  .floo_rsp_o       ( magia_tile_ni_3_5_to_router_3_5_rsp   )
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
) magia_tile_ni_3_6 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[3][6] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[3][6] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[3][6] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[3][6] ),
  .id_i             ( '{x: 4, y: 6, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_3_6_to_router_3_6_req   ),
  .floo_rsp_i       ( router_3_6_to_magia_tile_ni_3_6_rsp   ),
  .floo_req_i       ( router_3_6_to_magia_tile_ni_3_6_req   ),
  .floo_rsp_o       ( magia_tile_ni_3_6_to_router_3_6_rsp   )
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
) magia_tile_ni_3_7 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[3][7] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[3][7] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[3][7] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[3][7] ),
  .id_i             ( '{x: 4, y: 7, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_3_7_to_router_3_7_req   ),
  .floo_rsp_i       ( router_3_7_to_magia_tile_ni_3_7_rsp   ),
  .floo_req_i       ( router_3_7_to_magia_tile_ni_3_7_req   ),
  .floo_rsp_o       ( magia_tile_ni_3_7_to_router_3_7_rsp   )
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
) magia_tile_ni_4_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[4][0] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[4][0] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[4][0] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[4][0] ),
  .id_i             ( '{x: 5, y: 0, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_4_0_to_router_4_0_req   ),
  .floo_rsp_i       ( router_4_0_to_magia_tile_ni_4_0_rsp   ),
  .floo_req_i       ( router_4_0_to_magia_tile_ni_4_0_req   ),
  .floo_rsp_o       ( magia_tile_ni_4_0_to_router_4_0_rsp   )
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
) magia_tile_ni_4_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[4][1] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[4][1] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[4][1] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[4][1] ),
  .id_i             ( '{x: 5, y: 1, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_4_1_to_router_4_1_req   ),
  .floo_rsp_i       ( router_4_1_to_magia_tile_ni_4_1_rsp   ),
  .floo_req_i       ( router_4_1_to_magia_tile_ni_4_1_req   ),
  .floo_rsp_o       ( magia_tile_ni_4_1_to_router_4_1_rsp   )
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
) magia_tile_ni_4_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[4][2] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[4][2] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[4][2] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[4][2] ),
  .id_i             ( '{x: 5, y: 2, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_4_2_to_router_4_2_req   ),
  .floo_rsp_i       ( router_4_2_to_magia_tile_ni_4_2_rsp   ),
  .floo_req_i       ( router_4_2_to_magia_tile_ni_4_2_req   ),
  .floo_rsp_o       ( magia_tile_ni_4_2_to_router_4_2_rsp   )
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
) magia_tile_ni_4_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[4][3] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[4][3] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[4][3] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[4][3] ),
  .id_i             ( '{x: 5, y: 3, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_4_3_to_router_4_3_req   ),
  .floo_rsp_i       ( router_4_3_to_magia_tile_ni_4_3_rsp   ),
  .floo_req_i       ( router_4_3_to_magia_tile_ni_4_3_req   ),
  .floo_rsp_o       ( magia_tile_ni_4_3_to_router_4_3_rsp   )
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
) magia_tile_ni_4_4 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[4][4] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[4][4] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[4][4] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[4][4] ),
  .id_i             ( '{x: 5, y: 4, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_4_4_to_router_4_4_req   ),
  .floo_rsp_i       ( router_4_4_to_magia_tile_ni_4_4_rsp   ),
  .floo_req_i       ( router_4_4_to_magia_tile_ni_4_4_req   ),
  .floo_rsp_o       ( magia_tile_ni_4_4_to_router_4_4_rsp   )
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
) magia_tile_ni_4_5 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[4][5] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[4][5] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[4][5] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[4][5] ),
  .id_i             ( '{x: 5, y: 5, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_4_5_to_router_4_5_req   ),
  .floo_rsp_i       ( router_4_5_to_magia_tile_ni_4_5_rsp   ),
  .floo_req_i       ( router_4_5_to_magia_tile_ni_4_5_req   ),
  .floo_rsp_o       ( magia_tile_ni_4_5_to_router_4_5_rsp   )
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
) magia_tile_ni_4_6 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[4][6] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[4][6] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[4][6] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[4][6] ),
  .id_i             ( '{x: 5, y: 6, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_4_6_to_router_4_6_req   ),
  .floo_rsp_i       ( router_4_6_to_magia_tile_ni_4_6_rsp   ),
  .floo_req_i       ( router_4_6_to_magia_tile_ni_4_6_req   ),
  .floo_rsp_o       ( magia_tile_ni_4_6_to_router_4_6_rsp   )
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
) magia_tile_ni_4_7 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[4][7] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[4][7] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[4][7] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[4][7] ),
  .id_i             ( '{x: 5, y: 7, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_4_7_to_router_4_7_req   ),
  .floo_rsp_i       ( router_4_7_to_magia_tile_ni_4_7_rsp   ),
  .floo_req_i       ( router_4_7_to_magia_tile_ni_4_7_req   ),
  .floo_rsp_o       ( magia_tile_ni_4_7_to_router_4_7_rsp   )
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
) magia_tile_ni_5_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[5][0] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[5][0] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[5][0] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[5][0] ),
  .id_i             ( '{x: 6, y: 0, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_5_0_to_router_5_0_req   ),
  .floo_rsp_i       ( router_5_0_to_magia_tile_ni_5_0_rsp   ),
  .floo_req_i       ( router_5_0_to_magia_tile_ni_5_0_req   ),
  .floo_rsp_o       ( magia_tile_ni_5_0_to_router_5_0_rsp   )
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
) magia_tile_ni_5_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[5][1] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[5][1] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[5][1] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[5][1] ),
  .id_i             ( '{x: 6, y: 1, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_5_1_to_router_5_1_req   ),
  .floo_rsp_i       ( router_5_1_to_magia_tile_ni_5_1_rsp   ),
  .floo_req_i       ( router_5_1_to_magia_tile_ni_5_1_req   ),
  .floo_rsp_o       ( magia_tile_ni_5_1_to_router_5_1_rsp   )
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
) magia_tile_ni_5_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[5][2] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[5][2] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[5][2] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[5][2] ),
  .id_i             ( '{x: 6, y: 2, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_5_2_to_router_5_2_req   ),
  .floo_rsp_i       ( router_5_2_to_magia_tile_ni_5_2_rsp   ),
  .floo_req_i       ( router_5_2_to_magia_tile_ni_5_2_req   ),
  .floo_rsp_o       ( magia_tile_ni_5_2_to_router_5_2_rsp   )
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
) magia_tile_ni_5_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[5][3] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[5][3] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[5][3] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[5][3] ),
  .id_i             ( '{x: 6, y: 3, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_5_3_to_router_5_3_req   ),
  .floo_rsp_i       ( router_5_3_to_magia_tile_ni_5_3_rsp   ),
  .floo_req_i       ( router_5_3_to_magia_tile_ni_5_3_req   ),
  .floo_rsp_o       ( magia_tile_ni_5_3_to_router_5_3_rsp   )
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
) magia_tile_ni_5_4 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[5][4] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[5][4] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[5][4] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[5][4] ),
  .id_i             ( '{x: 6, y: 4, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_5_4_to_router_5_4_req   ),
  .floo_rsp_i       ( router_5_4_to_magia_tile_ni_5_4_rsp   ),
  .floo_req_i       ( router_5_4_to_magia_tile_ni_5_4_req   ),
  .floo_rsp_o       ( magia_tile_ni_5_4_to_router_5_4_rsp   )
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
) magia_tile_ni_5_5 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[5][5] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[5][5] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[5][5] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[5][5] ),
  .id_i             ( '{x: 6, y: 5, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_5_5_to_router_5_5_req   ),
  .floo_rsp_i       ( router_5_5_to_magia_tile_ni_5_5_rsp   ),
  .floo_req_i       ( router_5_5_to_magia_tile_ni_5_5_req   ),
  .floo_rsp_o       ( magia_tile_ni_5_5_to_router_5_5_rsp   )
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
) magia_tile_ni_5_6 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[5][6] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[5][6] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[5][6] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[5][6] ),
  .id_i             ( '{x: 6, y: 6, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_5_6_to_router_5_6_req   ),
  .floo_rsp_i       ( router_5_6_to_magia_tile_ni_5_6_rsp   ),
  .floo_req_i       ( router_5_6_to_magia_tile_ni_5_6_req   ),
  .floo_rsp_o       ( magia_tile_ni_5_6_to_router_5_6_rsp   )
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
) magia_tile_ni_5_7 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[5][7] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[5][7] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[5][7] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[5][7] ),
  .id_i             ( '{x: 6, y: 7, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_5_7_to_router_5_7_req   ),
  .floo_rsp_i       ( router_5_7_to_magia_tile_ni_5_7_rsp   ),
  .floo_req_i       ( router_5_7_to_magia_tile_ni_5_7_req   ),
  .floo_rsp_o       ( magia_tile_ni_5_7_to_router_5_7_rsp   )
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
) magia_tile_ni_6_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[6][0] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[6][0] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[6][0] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[6][0] ),
  .id_i             ( '{x: 7, y: 0, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_6_0_to_router_6_0_req   ),
  .floo_rsp_i       ( router_6_0_to_magia_tile_ni_6_0_rsp   ),
  .floo_req_i       ( router_6_0_to_magia_tile_ni_6_0_req   ),
  .floo_rsp_o       ( magia_tile_ni_6_0_to_router_6_0_rsp   )
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
) magia_tile_ni_6_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[6][1] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[6][1] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[6][1] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[6][1] ),
  .id_i             ( '{x: 7, y: 1, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_6_1_to_router_6_1_req   ),
  .floo_rsp_i       ( router_6_1_to_magia_tile_ni_6_1_rsp   ),
  .floo_req_i       ( router_6_1_to_magia_tile_ni_6_1_req   ),
  .floo_rsp_o       ( magia_tile_ni_6_1_to_router_6_1_rsp   )
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
) magia_tile_ni_6_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[6][2] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[6][2] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[6][2] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[6][2] ),
  .id_i             ( '{x: 7, y: 2, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_6_2_to_router_6_2_req   ),
  .floo_rsp_i       ( router_6_2_to_magia_tile_ni_6_2_rsp   ),
  .floo_req_i       ( router_6_2_to_magia_tile_ni_6_2_req   ),
  .floo_rsp_o       ( magia_tile_ni_6_2_to_router_6_2_rsp   )
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
) magia_tile_ni_6_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[6][3] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[6][3] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[6][3] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[6][3] ),
  .id_i             ( '{x: 7, y: 3, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_6_3_to_router_6_3_req   ),
  .floo_rsp_i       ( router_6_3_to_magia_tile_ni_6_3_rsp   ),
  .floo_req_i       ( router_6_3_to_magia_tile_ni_6_3_req   ),
  .floo_rsp_o       ( magia_tile_ni_6_3_to_router_6_3_rsp   )
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
) magia_tile_ni_6_4 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[6][4] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[6][4] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[6][4] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[6][4] ),
  .id_i             ( '{x: 7, y: 4, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_6_4_to_router_6_4_req   ),
  .floo_rsp_i       ( router_6_4_to_magia_tile_ni_6_4_rsp   ),
  .floo_req_i       ( router_6_4_to_magia_tile_ni_6_4_req   ),
  .floo_rsp_o       ( magia_tile_ni_6_4_to_router_6_4_rsp   )
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
) magia_tile_ni_6_5 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[6][5] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[6][5] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[6][5] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[6][5] ),
  .id_i             ( '{x: 7, y: 5, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_6_5_to_router_6_5_req   ),
  .floo_rsp_i       ( router_6_5_to_magia_tile_ni_6_5_rsp   ),
  .floo_req_i       ( router_6_5_to_magia_tile_ni_6_5_req   ),
  .floo_rsp_o       ( magia_tile_ni_6_5_to_router_6_5_rsp   )
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
) magia_tile_ni_6_6 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[6][6] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[6][6] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[6][6] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[6][6] ),
  .id_i             ( '{x: 7, y: 6, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_6_6_to_router_6_6_req   ),
  .floo_rsp_i       ( router_6_6_to_magia_tile_ni_6_6_rsp   ),
  .floo_req_i       ( router_6_6_to_magia_tile_ni_6_6_req   ),
  .floo_rsp_o       ( magia_tile_ni_6_6_to_router_6_6_rsp   )
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
) magia_tile_ni_6_7 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[6][7] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[6][7] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[6][7] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[6][7] ),
  .id_i             ( '{x: 7, y: 7, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_6_7_to_router_6_7_req   ),
  .floo_rsp_i       ( router_6_7_to_magia_tile_ni_6_7_rsp   ),
  .floo_req_i       ( router_6_7_to_magia_tile_ni_6_7_req   ),
  .floo_rsp_o       ( magia_tile_ni_6_7_to_router_6_7_rsp   )
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
) magia_tile_ni_7_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[7][0] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[7][0] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[7][0] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[7][0] ),
  .id_i             ( '{x: 8, y: 0, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_7_0_to_router_7_0_req   ),
  .floo_rsp_i       ( router_7_0_to_magia_tile_ni_7_0_rsp   ),
  .floo_req_i       ( router_7_0_to_magia_tile_ni_7_0_req   ),
  .floo_rsp_o       ( magia_tile_ni_7_0_to_router_7_0_rsp   )
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
) magia_tile_ni_7_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[7][1] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[7][1] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[7][1] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[7][1] ),
  .id_i             ( '{x: 8, y: 1, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_7_1_to_router_7_1_req   ),
  .floo_rsp_i       ( router_7_1_to_magia_tile_ni_7_1_rsp   ),
  .floo_req_i       ( router_7_1_to_magia_tile_ni_7_1_req   ),
  .floo_rsp_o       ( magia_tile_ni_7_1_to_router_7_1_rsp   )
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
) magia_tile_ni_7_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[7][2] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[7][2] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[7][2] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[7][2] ),
  .id_i             ( '{x: 8, y: 2, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_7_2_to_router_7_2_req   ),
  .floo_rsp_i       ( router_7_2_to_magia_tile_ni_7_2_rsp   ),
  .floo_req_i       ( router_7_2_to_magia_tile_ni_7_2_req   ),
  .floo_rsp_o       ( magia_tile_ni_7_2_to_router_7_2_rsp   )
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
) magia_tile_ni_7_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[7][3] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[7][3] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[7][3] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[7][3] ),
  .id_i             ( '{x: 8, y: 3, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_7_3_to_router_7_3_req   ),
  .floo_rsp_i       ( router_7_3_to_magia_tile_ni_7_3_rsp   ),
  .floo_req_i       ( router_7_3_to_magia_tile_ni_7_3_req   ),
  .floo_rsp_o       ( magia_tile_ni_7_3_to_router_7_3_rsp   )
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
) magia_tile_ni_7_4 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[7][4] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[7][4] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[7][4] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[7][4] ),
  .id_i             ( '{x: 8, y: 4, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_7_4_to_router_7_4_req   ),
  .floo_rsp_i       ( router_7_4_to_magia_tile_ni_7_4_rsp   ),
  .floo_req_i       ( router_7_4_to_magia_tile_ni_7_4_req   ),
  .floo_rsp_o       ( magia_tile_ni_7_4_to_router_7_4_rsp   )
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
) magia_tile_ni_7_5 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[7][5] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[7][5] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[7][5] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[7][5] ),
  .id_i             ( '{x: 8, y: 5, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_7_5_to_router_7_5_req   ),
  .floo_rsp_i       ( router_7_5_to_magia_tile_ni_7_5_rsp   ),
  .floo_req_i       ( router_7_5_to_magia_tile_ni_7_5_req   ),
  .floo_rsp_o       ( magia_tile_ni_7_5_to_router_7_5_rsp   )
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
) magia_tile_ni_7_6 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[7][6] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[7][6] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[7][6] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[7][6] ),
  .id_i             ( '{x: 8, y: 6, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_7_6_to_router_7_6_req   ),
  .floo_rsp_i       ( router_7_6_to_magia_tile_ni_7_6_rsp   ),
  .floo_req_i       ( router_7_6_to_magia_tile_ni_7_6_req   ),
  .floo_rsp_o       ( magia_tile_ni_7_6_to_router_7_6_rsp   )
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
) magia_tile_ni_7_7 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[7][7] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[7][7] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[7][7] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[7][7] ),
  .id_i             ( '{x: 8, y: 7, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_7_7_to_router_7_7_req   ),
  .floo_rsp_i       ( router_7_7_to_magia_tile_ni_7_7_rsp   ),
  .floo_req_i       ( router_7_7_to_magia_tile_ni_7_7_req   ),
  .floo_rsp_o       ( magia_tile_ni_7_7_to_router_7_7_rsp   )
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
) L2_ni_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( '0 ),
  .axi_in_rsp_o  (    ),
  .axi_out_req_o ( L2_data_mst_req_o[2] ),
  .axi_out_rsp_i ( L2_data_mst_rsp_i[2] ),
  .id_i             ( '{x: 0, y: 2, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( L2_ni_2_to_router_0_2_req   ),
  .floo_rsp_i       ( router_0_2_to_L2_ni_2_rsp   ),
  .floo_req_i       ( router_0_2_to_L2_ni_2_req   ),
  .floo_rsp_o       ( L2_ni_2_to_router_0_2_rsp   )
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
) L2_ni_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( '0 ),
  .axi_in_rsp_o  (    ),
  .axi_out_req_o ( L2_data_mst_req_o[3] ),
  .axi_out_rsp_i ( L2_data_mst_rsp_i[3] ),
  .id_i             ( '{x: 0, y: 3, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( L2_ni_3_to_router_0_3_req   ),
  .floo_rsp_i       ( router_0_3_to_L2_ni_3_rsp   ),
  .floo_req_i       ( router_0_3_to_L2_ni_3_req   ),
  .floo_rsp_o       ( L2_ni_3_to_router_0_3_rsp   )
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
) L2_ni_4 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( '0 ),
  .axi_in_rsp_o  (    ),
  .axi_out_req_o ( L2_data_mst_req_o[4] ),
  .axi_out_rsp_i ( L2_data_mst_rsp_i[4] ),
  .id_i             ( '{x: 0, y: 4, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( L2_ni_4_to_router_0_4_req   ),
  .floo_rsp_i       ( router_0_4_to_L2_ni_4_rsp   ),
  .floo_req_i       ( router_0_4_to_L2_ni_4_req   ),
  .floo_rsp_o       ( L2_ni_4_to_router_0_4_rsp   )
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
) L2_ni_5 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( '0 ),
  .axi_in_rsp_o  (    ),
  .axi_out_req_o ( L2_data_mst_req_o[5] ),
  .axi_out_rsp_i ( L2_data_mst_rsp_i[5] ),
  .id_i             ( '{x: 0, y: 5, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( L2_ni_5_to_router_0_5_req   ),
  .floo_rsp_i       ( router_0_5_to_L2_ni_5_rsp   ),
  .floo_req_i       ( router_0_5_to_L2_ni_5_req   ),
  .floo_rsp_o       ( L2_ni_5_to_router_0_5_rsp   )
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
) L2_ni_6 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( '0 ),
  .axi_in_rsp_o  (    ),
  .axi_out_req_o ( L2_data_mst_req_o[6] ),
  .axi_out_rsp_i ( L2_data_mst_rsp_i[6] ),
  .id_i             ( '{x: 0, y: 6, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( L2_ni_6_to_router_0_6_req   ),
  .floo_rsp_i       ( router_0_6_to_L2_ni_6_rsp   ),
  .floo_req_i       ( router_0_6_to_L2_ni_6_req   ),
  .floo_rsp_o       ( L2_ni_6_to_router_0_6_rsp   )
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
) L2_ni_7 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( '0 ),
  .axi_in_rsp_o  (    ),
  .axi_out_req_o ( L2_data_mst_req_o[7] ),
  .axi_out_rsp_i ( L2_data_mst_rsp_i[7] ),
  .id_i             ( '{x: 0, y: 7, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( L2_ni_7_to_router_0_7_req   ),
  .floo_rsp_i       ( router_0_7_to_L2_ni_7_rsp   ),
  .floo_req_i       ( router_0_7_to_L2_ni_7_req   ),
  .floo_rsp_o       ( L2_ni_7_to_router_0_7_rsp   )
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

    assign router_0_1_req_in[0] = router_0_2_to_router_0_1_req;
    assign router_0_1_req_in[1] = router_1_1_to_router_0_1_req;
    assign router_0_1_req_in[2] = router_0_0_to_router_0_1_req;
    assign router_0_1_req_in[3] = L2_ni_1_to_router_0_1_req;
    assign router_0_1_req_in[4] = magia_tile_ni_0_1_to_router_0_1_req;

    assign router_0_1_to_router_0_2_rsp = router_0_1_rsp_out[0];
    assign router_0_1_to_router_1_1_rsp = router_0_1_rsp_out[1];
    assign router_0_1_to_router_0_0_rsp = router_0_1_rsp_out[2];
    assign router_0_1_to_L2_ni_1_rsp = router_0_1_rsp_out[3];
    assign router_0_1_to_magia_tile_ni_0_1_rsp = router_0_1_rsp_out[4];

    assign router_0_1_to_router_0_2_req = router_0_1_req_out[0];
    assign router_0_1_to_router_1_1_req = router_0_1_req_out[1];
    assign router_0_1_to_router_0_0_req = router_0_1_req_out[2];
    assign router_0_1_to_L2_ni_1_req = router_0_1_req_out[3];
    assign router_0_1_to_magia_tile_ni_0_1_req = router_0_1_req_out[4];

    assign router_0_1_rsp_in[0] = router_0_2_to_router_0_1_rsp;
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


floo_req_t [4:0] router_0_2_req_in;
floo_rsp_t [4:0] router_0_2_rsp_out;
floo_req_t [4:0] router_0_2_req_out;
floo_rsp_t [4:0] router_0_2_rsp_in;

    assign router_0_2_req_in[0] = router_0_3_to_router_0_2_req;
    assign router_0_2_req_in[1] = router_1_2_to_router_0_2_req;
    assign router_0_2_req_in[2] = router_0_1_to_router_0_2_req;
    assign router_0_2_req_in[3] = L2_ni_2_to_router_0_2_req;
    assign router_0_2_req_in[4] = magia_tile_ni_0_2_to_router_0_2_req;

    assign router_0_2_to_router_0_3_rsp = router_0_2_rsp_out[0];
    assign router_0_2_to_router_1_2_rsp = router_0_2_rsp_out[1];
    assign router_0_2_to_router_0_1_rsp = router_0_2_rsp_out[2];
    assign router_0_2_to_L2_ni_2_rsp = router_0_2_rsp_out[3];
    assign router_0_2_to_magia_tile_ni_0_2_rsp = router_0_2_rsp_out[4];

    assign router_0_2_to_router_0_3_req = router_0_2_req_out[0];
    assign router_0_2_to_router_1_2_req = router_0_2_req_out[1];
    assign router_0_2_to_router_0_1_req = router_0_2_req_out[2];
    assign router_0_2_to_L2_ni_2_req = router_0_2_req_out[3];
    assign router_0_2_to_magia_tile_ni_0_2_req = router_0_2_req_out[4];

    assign router_0_2_rsp_in[0] = router_0_3_to_router_0_2_rsp;
    assign router_0_2_rsp_in[1] = router_1_2_to_router_0_2_rsp;
    assign router_0_2_rsp_in[2] = router_0_1_to_router_0_2_rsp;
    assign router_0_2_rsp_in[3] = L2_ni_2_to_router_0_2_rsp;
    assign router_0_2_rsp_in[4] = magia_tile_ni_0_2_to_router_0_2_rsp;

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
) router_0_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 1, y: 2, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_0_2_req_in),
  .floo_rsp_o (router_0_2_rsp_out),
  .floo_req_o (router_0_2_req_out),
  .floo_rsp_i (router_0_2_rsp_in)
);


floo_req_t [4:0] router_0_3_req_in;
floo_rsp_t [4:0] router_0_3_rsp_out;
floo_req_t [4:0] router_0_3_req_out;
floo_rsp_t [4:0] router_0_3_rsp_in;

    assign router_0_3_req_in[0] = router_0_4_to_router_0_3_req;
    assign router_0_3_req_in[1] = router_1_3_to_router_0_3_req;
    assign router_0_3_req_in[2] = router_0_2_to_router_0_3_req;
    assign router_0_3_req_in[3] = L2_ni_3_to_router_0_3_req;
    assign router_0_3_req_in[4] = magia_tile_ni_0_3_to_router_0_3_req;

    assign router_0_3_to_router_0_4_rsp = router_0_3_rsp_out[0];
    assign router_0_3_to_router_1_3_rsp = router_0_3_rsp_out[1];
    assign router_0_3_to_router_0_2_rsp = router_0_3_rsp_out[2];
    assign router_0_3_to_L2_ni_3_rsp = router_0_3_rsp_out[3];
    assign router_0_3_to_magia_tile_ni_0_3_rsp = router_0_3_rsp_out[4];

    assign router_0_3_to_router_0_4_req = router_0_3_req_out[0];
    assign router_0_3_to_router_1_3_req = router_0_3_req_out[1];
    assign router_0_3_to_router_0_2_req = router_0_3_req_out[2];
    assign router_0_3_to_L2_ni_3_req = router_0_3_req_out[3];
    assign router_0_3_to_magia_tile_ni_0_3_req = router_0_3_req_out[4];

    assign router_0_3_rsp_in[0] = router_0_4_to_router_0_3_rsp;
    assign router_0_3_rsp_in[1] = router_1_3_to_router_0_3_rsp;
    assign router_0_3_rsp_in[2] = router_0_2_to_router_0_3_rsp;
    assign router_0_3_rsp_in[3] = L2_ni_3_to_router_0_3_rsp;
    assign router_0_3_rsp_in[4] = magia_tile_ni_0_3_to_router_0_3_rsp;

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
) router_0_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 1, y: 3, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_0_3_req_in),
  .floo_rsp_o (router_0_3_rsp_out),
  .floo_req_o (router_0_3_req_out),
  .floo_rsp_i (router_0_3_rsp_in)
);


floo_req_t [4:0] router_0_4_req_in;
floo_rsp_t [4:0] router_0_4_rsp_out;
floo_req_t [4:0] router_0_4_req_out;
floo_rsp_t [4:0] router_0_4_rsp_in;

    assign router_0_4_req_in[0] = router_0_5_to_router_0_4_req;
    assign router_0_4_req_in[1] = router_1_4_to_router_0_4_req;
    assign router_0_4_req_in[2] = router_0_3_to_router_0_4_req;
    assign router_0_4_req_in[3] = L2_ni_4_to_router_0_4_req;
    assign router_0_4_req_in[4] = magia_tile_ni_0_4_to_router_0_4_req;

    assign router_0_4_to_router_0_5_rsp = router_0_4_rsp_out[0];
    assign router_0_4_to_router_1_4_rsp = router_0_4_rsp_out[1];
    assign router_0_4_to_router_0_3_rsp = router_0_4_rsp_out[2];
    assign router_0_4_to_L2_ni_4_rsp = router_0_4_rsp_out[3];
    assign router_0_4_to_magia_tile_ni_0_4_rsp = router_0_4_rsp_out[4];

    assign router_0_4_to_router_0_5_req = router_0_4_req_out[0];
    assign router_0_4_to_router_1_4_req = router_0_4_req_out[1];
    assign router_0_4_to_router_0_3_req = router_0_4_req_out[2];
    assign router_0_4_to_L2_ni_4_req = router_0_4_req_out[3];
    assign router_0_4_to_magia_tile_ni_0_4_req = router_0_4_req_out[4];

    assign router_0_4_rsp_in[0] = router_0_5_to_router_0_4_rsp;
    assign router_0_4_rsp_in[1] = router_1_4_to_router_0_4_rsp;
    assign router_0_4_rsp_in[2] = router_0_3_to_router_0_4_rsp;
    assign router_0_4_rsp_in[3] = L2_ni_4_to_router_0_4_rsp;
    assign router_0_4_rsp_in[4] = magia_tile_ni_0_4_to_router_0_4_rsp;

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
) router_0_4 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 1, y: 4, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_0_4_req_in),
  .floo_rsp_o (router_0_4_rsp_out),
  .floo_req_o (router_0_4_req_out),
  .floo_rsp_i (router_0_4_rsp_in)
);


floo_req_t [4:0] router_0_5_req_in;
floo_rsp_t [4:0] router_0_5_rsp_out;
floo_req_t [4:0] router_0_5_req_out;
floo_rsp_t [4:0] router_0_5_rsp_in;

    assign router_0_5_req_in[0] = router_0_6_to_router_0_5_req;
    assign router_0_5_req_in[1] = router_1_5_to_router_0_5_req;
    assign router_0_5_req_in[2] = router_0_4_to_router_0_5_req;
    assign router_0_5_req_in[3] = L2_ni_5_to_router_0_5_req;
    assign router_0_5_req_in[4] = magia_tile_ni_0_5_to_router_0_5_req;

    assign router_0_5_to_router_0_6_rsp = router_0_5_rsp_out[0];
    assign router_0_5_to_router_1_5_rsp = router_0_5_rsp_out[1];
    assign router_0_5_to_router_0_4_rsp = router_0_5_rsp_out[2];
    assign router_0_5_to_L2_ni_5_rsp = router_0_5_rsp_out[3];
    assign router_0_5_to_magia_tile_ni_0_5_rsp = router_0_5_rsp_out[4];

    assign router_0_5_to_router_0_6_req = router_0_5_req_out[0];
    assign router_0_5_to_router_1_5_req = router_0_5_req_out[1];
    assign router_0_5_to_router_0_4_req = router_0_5_req_out[2];
    assign router_0_5_to_L2_ni_5_req = router_0_5_req_out[3];
    assign router_0_5_to_magia_tile_ni_0_5_req = router_0_5_req_out[4];

    assign router_0_5_rsp_in[0] = router_0_6_to_router_0_5_rsp;
    assign router_0_5_rsp_in[1] = router_1_5_to_router_0_5_rsp;
    assign router_0_5_rsp_in[2] = router_0_4_to_router_0_5_rsp;
    assign router_0_5_rsp_in[3] = L2_ni_5_to_router_0_5_rsp;
    assign router_0_5_rsp_in[4] = magia_tile_ni_0_5_to_router_0_5_rsp;

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
) router_0_5 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 1, y: 5, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_0_5_req_in),
  .floo_rsp_o (router_0_5_rsp_out),
  .floo_req_o (router_0_5_req_out),
  .floo_rsp_i (router_0_5_rsp_in)
);


floo_req_t [4:0] router_0_6_req_in;
floo_rsp_t [4:0] router_0_6_rsp_out;
floo_req_t [4:0] router_0_6_req_out;
floo_rsp_t [4:0] router_0_6_rsp_in;

    assign router_0_6_req_in[0] = router_0_7_to_router_0_6_req;
    assign router_0_6_req_in[1] = router_1_6_to_router_0_6_req;
    assign router_0_6_req_in[2] = router_0_5_to_router_0_6_req;
    assign router_0_6_req_in[3] = L2_ni_6_to_router_0_6_req;
    assign router_0_6_req_in[4] = magia_tile_ni_0_6_to_router_0_6_req;

    assign router_0_6_to_router_0_7_rsp = router_0_6_rsp_out[0];
    assign router_0_6_to_router_1_6_rsp = router_0_6_rsp_out[1];
    assign router_0_6_to_router_0_5_rsp = router_0_6_rsp_out[2];
    assign router_0_6_to_L2_ni_6_rsp = router_0_6_rsp_out[3];
    assign router_0_6_to_magia_tile_ni_0_6_rsp = router_0_6_rsp_out[4];

    assign router_0_6_to_router_0_7_req = router_0_6_req_out[0];
    assign router_0_6_to_router_1_6_req = router_0_6_req_out[1];
    assign router_0_6_to_router_0_5_req = router_0_6_req_out[2];
    assign router_0_6_to_L2_ni_6_req = router_0_6_req_out[3];
    assign router_0_6_to_magia_tile_ni_0_6_req = router_0_6_req_out[4];

    assign router_0_6_rsp_in[0] = router_0_7_to_router_0_6_rsp;
    assign router_0_6_rsp_in[1] = router_1_6_to_router_0_6_rsp;
    assign router_0_6_rsp_in[2] = router_0_5_to_router_0_6_rsp;
    assign router_0_6_rsp_in[3] = L2_ni_6_to_router_0_6_rsp;
    assign router_0_6_rsp_in[4] = magia_tile_ni_0_6_to_router_0_6_rsp;

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
) router_0_6 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 1, y: 6, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_0_6_req_in),
  .floo_rsp_o (router_0_6_rsp_out),
  .floo_req_o (router_0_6_req_out),
  .floo_rsp_i (router_0_6_rsp_in)
);


floo_req_t [4:0] router_0_7_req_in;
floo_rsp_t [4:0] router_0_7_rsp_out;
floo_req_t [4:0] router_0_7_req_out;
floo_rsp_t [4:0] router_0_7_rsp_in;

    assign router_0_7_req_in[0] = '0;
    assign router_0_7_req_in[1] = router_1_7_to_router_0_7_req;
    assign router_0_7_req_in[2] = router_0_6_to_router_0_7_req;
    assign router_0_7_req_in[3] = L2_ni_7_to_router_0_7_req;
    assign router_0_7_req_in[4] = magia_tile_ni_0_7_to_router_0_7_req;

    assign router_0_7_to_router_1_7_rsp = router_0_7_rsp_out[1];
    assign router_0_7_to_router_0_6_rsp = router_0_7_rsp_out[2];
    assign router_0_7_to_L2_ni_7_rsp = router_0_7_rsp_out[3];
    assign router_0_7_to_magia_tile_ni_0_7_rsp = router_0_7_rsp_out[4];

    assign router_0_7_to_router_1_7_req = router_0_7_req_out[1];
    assign router_0_7_to_router_0_6_req = router_0_7_req_out[2];
    assign router_0_7_to_L2_ni_7_req = router_0_7_req_out[3];
    assign router_0_7_to_magia_tile_ni_0_7_req = router_0_7_req_out[4];

    assign router_0_7_rsp_in[0] = '0;
    assign router_0_7_rsp_in[1] = router_1_7_to_router_0_7_rsp;
    assign router_0_7_rsp_in[2] = router_0_6_to_router_0_7_rsp;
    assign router_0_7_rsp_in[3] = L2_ni_7_to_router_0_7_rsp;
    assign router_0_7_rsp_in[4] = magia_tile_ni_0_7_to_router_0_7_rsp;

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
) router_0_7 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 1, y: 7, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_0_7_req_in),
  .floo_rsp_o (router_0_7_rsp_out),
  .floo_req_o (router_0_7_req_out),
  .floo_rsp_i (router_0_7_rsp_in)
);


floo_req_t [4:0] router_1_0_req_in;
floo_rsp_t [4:0] router_1_0_rsp_out;
floo_req_t [4:0] router_1_0_req_out;
floo_rsp_t [4:0] router_1_0_rsp_in;

    assign router_1_0_req_in[0] = router_1_1_to_router_1_0_req;
    assign router_1_0_req_in[1] = router_2_0_to_router_1_0_req;
    assign router_1_0_req_in[2] = '0;
    assign router_1_0_req_in[3] = router_0_0_to_router_1_0_req;
    assign router_1_0_req_in[4] = magia_tile_ni_1_0_to_router_1_0_req;

    assign router_1_0_to_router_1_1_rsp = router_1_0_rsp_out[0];
    assign router_1_0_to_router_2_0_rsp = router_1_0_rsp_out[1];
    assign router_1_0_to_router_0_0_rsp = router_1_0_rsp_out[3];
    assign router_1_0_to_magia_tile_ni_1_0_rsp = router_1_0_rsp_out[4];

    assign router_1_0_to_router_1_1_req = router_1_0_req_out[0];
    assign router_1_0_to_router_2_0_req = router_1_0_req_out[1];
    assign router_1_0_to_router_0_0_req = router_1_0_req_out[3];
    assign router_1_0_to_magia_tile_ni_1_0_req = router_1_0_req_out[4];

    assign router_1_0_rsp_in[0] = router_1_1_to_router_1_0_rsp;
    assign router_1_0_rsp_in[1] = router_2_0_to_router_1_0_rsp;
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

    assign router_1_1_req_in[0] = router_1_2_to_router_1_1_req;
    assign router_1_1_req_in[1] = router_2_1_to_router_1_1_req;
    assign router_1_1_req_in[2] = router_1_0_to_router_1_1_req;
    assign router_1_1_req_in[3] = router_0_1_to_router_1_1_req;
    assign router_1_1_req_in[4] = magia_tile_ni_1_1_to_router_1_1_req;

    assign router_1_1_to_router_1_2_rsp = router_1_1_rsp_out[0];
    assign router_1_1_to_router_2_1_rsp = router_1_1_rsp_out[1];
    assign router_1_1_to_router_1_0_rsp = router_1_1_rsp_out[2];
    assign router_1_1_to_router_0_1_rsp = router_1_1_rsp_out[3];
    assign router_1_1_to_magia_tile_ni_1_1_rsp = router_1_1_rsp_out[4];

    assign router_1_1_to_router_1_2_req = router_1_1_req_out[0];
    assign router_1_1_to_router_2_1_req = router_1_1_req_out[1];
    assign router_1_1_to_router_1_0_req = router_1_1_req_out[2];
    assign router_1_1_to_router_0_1_req = router_1_1_req_out[3];
    assign router_1_1_to_magia_tile_ni_1_1_req = router_1_1_req_out[4];

    assign router_1_1_rsp_in[0] = router_1_2_to_router_1_1_rsp;
    assign router_1_1_rsp_in[1] = router_2_1_to_router_1_1_rsp;
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


floo_req_t [4:0] router_1_2_req_in;
floo_rsp_t [4:0] router_1_2_rsp_out;
floo_req_t [4:0] router_1_2_req_out;
floo_rsp_t [4:0] router_1_2_rsp_in;

    assign router_1_2_req_in[0] = router_1_3_to_router_1_2_req;
    assign router_1_2_req_in[1] = router_2_2_to_router_1_2_req;
    assign router_1_2_req_in[2] = router_1_1_to_router_1_2_req;
    assign router_1_2_req_in[3] = router_0_2_to_router_1_2_req;
    assign router_1_2_req_in[4] = magia_tile_ni_1_2_to_router_1_2_req;

    assign router_1_2_to_router_1_3_rsp = router_1_2_rsp_out[0];
    assign router_1_2_to_router_2_2_rsp = router_1_2_rsp_out[1];
    assign router_1_2_to_router_1_1_rsp = router_1_2_rsp_out[2];
    assign router_1_2_to_router_0_2_rsp = router_1_2_rsp_out[3];
    assign router_1_2_to_magia_tile_ni_1_2_rsp = router_1_2_rsp_out[4];

    assign router_1_2_to_router_1_3_req = router_1_2_req_out[0];
    assign router_1_2_to_router_2_2_req = router_1_2_req_out[1];
    assign router_1_2_to_router_1_1_req = router_1_2_req_out[2];
    assign router_1_2_to_router_0_2_req = router_1_2_req_out[3];
    assign router_1_2_to_magia_tile_ni_1_2_req = router_1_2_req_out[4];

    assign router_1_2_rsp_in[0] = router_1_3_to_router_1_2_rsp;
    assign router_1_2_rsp_in[1] = router_2_2_to_router_1_2_rsp;
    assign router_1_2_rsp_in[2] = router_1_1_to_router_1_2_rsp;
    assign router_1_2_rsp_in[3] = router_0_2_to_router_1_2_rsp;
    assign router_1_2_rsp_in[4] = magia_tile_ni_1_2_to_router_1_2_rsp;

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
) router_1_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 2, y: 2, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_1_2_req_in),
  .floo_rsp_o (router_1_2_rsp_out),
  .floo_req_o (router_1_2_req_out),
  .floo_rsp_i (router_1_2_rsp_in)
);


floo_req_t [4:0] router_1_3_req_in;
floo_rsp_t [4:0] router_1_3_rsp_out;
floo_req_t [4:0] router_1_3_req_out;
floo_rsp_t [4:0] router_1_3_rsp_in;

    assign router_1_3_req_in[0] = router_1_4_to_router_1_3_req;
    assign router_1_3_req_in[1] = router_2_3_to_router_1_3_req;
    assign router_1_3_req_in[2] = router_1_2_to_router_1_3_req;
    assign router_1_3_req_in[3] = router_0_3_to_router_1_3_req;
    assign router_1_3_req_in[4] = magia_tile_ni_1_3_to_router_1_3_req;

    assign router_1_3_to_router_1_4_rsp = router_1_3_rsp_out[0];
    assign router_1_3_to_router_2_3_rsp = router_1_3_rsp_out[1];
    assign router_1_3_to_router_1_2_rsp = router_1_3_rsp_out[2];
    assign router_1_3_to_router_0_3_rsp = router_1_3_rsp_out[3];
    assign router_1_3_to_magia_tile_ni_1_3_rsp = router_1_3_rsp_out[4];

    assign router_1_3_to_router_1_4_req = router_1_3_req_out[0];
    assign router_1_3_to_router_2_3_req = router_1_3_req_out[1];
    assign router_1_3_to_router_1_2_req = router_1_3_req_out[2];
    assign router_1_3_to_router_0_3_req = router_1_3_req_out[3];
    assign router_1_3_to_magia_tile_ni_1_3_req = router_1_3_req_out[4];

    assign router_1_3_rsp_in[0] = router_1_4_to_router_1_3_rsp;
    assign router_1_3_rsp_in[1] = router_2_3_to_router_1_3_rsp;
    assign router_1_3_rsp_in[2] = router_1_2_to_router_1_3_rsp;
    assign router_1_3_rsp_in[3] = router_0_3_to_router_1_3_rsp;
    assign router_1_3_rsp_in[4] = magia_tile_ni_1_3_to_router_1_3_rsp;

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
) router_1_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 2, y: 3, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_1_3_req_in),
  .floo_rsp_o (router_1_3_rsp_out),
  .floo_req_o (router_1_3_req_out),
  .floo_rsp_i (router_1_3_rsp_in)
);


floo_req_t [4:0] router_1_4_req_in;
floo_rsp_t [4:0] router_1_4_rsp_out;
floo_req_t [4:0] router_1_4_req_out;
floo_rsp_t [4:0] router_1_4_rsp_in;

    assign router_1_4_req_in[0] = router_1_5_to_router_1_4_req;
    assign router_1_4_req_in[1] = router_2_4_to_router_1_4_req;
    assign router_1_4_req_in[2] = router_1_3_to_router_1_4_req;
    assign router_1_4_req_in[3] = router_0_4_to_router_1_4_req;
    assign router_1_4_req_in[4] = magia_tile_ni_1_4_to_router_1_4_req;

    assign router_1_4_to_router_1_5_rsp = router_1_4_rsp_out[0];
    assign router_1_4_to_router_2_4_rsp = router_1_4_rsp_out[1];
    assign router_1_4_to_router_1_3_rsp = router_1_4_rsp_out[2];
    assign router_1_4_to_router_0_4_rsp = router_1_4_rsp_out[3];
    assign router_1_4_to_magia_tile_ni_1_4_rsp = router_1_4_rsp_out[4];

    assign router_1_4_to_router_1_5_req = router_1_4_req_out[0];
    assign router_1_4_to_router_2_4_req = router_1_4_req_out[1];
    assign router_1_4_to_router_1_3_req = router_1_4_req_out[2];
    assign router_1_4_to_router_0_4_req = router_1_4_req_out[3];
    assign router_1_4_to_magia_tile_ni_1_4_req = router_1_4_req_out[4];

    assign router_1_4_rsp_in[0] = router_1_5_to_router_1_4_rsp;
    assign router_1_4_rsp_in[1] = router_2_4_to_router_1_4_rsp;
    assign router_1_4_rsp_in[2] = router_1_3_to_router_1_4_rsp;
    assign router_1_4_rsp_in[3] = router_0_4_to_router_1_4_rsp;
    assign router_1_4_rsp_in[4] = magia_tile_ni_1_4_to_router_1_4_rsp;

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
) router_1_4 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 2, y: 4, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_1_4_req_in),
  .floo_rsp_o (router_1_4_rsp_out),
  .floo_req_o (router_1_4_req_out),
  .floo_rsp_i (router_1_4_rsp_in)
);


floo_req_t [4:0] router_1_5_req_in;
floo_rsp_t [4:0] router_1_5_rsp_out;
floo_req_t [4:0] router_1_5_req_out;
floo_rsp_t [4:0] router_1_5_rsp_in;

    assign router_1_5_req_in[0] = router_1_6_to_router_1_5_req;
    assign router_1_5_req_in[1] = router_2_5_to_router_1_5_req;
    assign router_1_5_req_in[2] = router_1_4_to_router_1_5_req;
    assign router_1_5_req_in[3] = router_0_5_to_router_1_5_req;
    assign router_1_5_req_in[4] = magia_tile_ni_1_5_to_router_1_5_req;

    assign router_1_5_to_router_1_6_rsp = router_1_5_rsp_out[0];
    assign router_1_5_to_router_2_5_rsp = router_1_5_rsp_out[1];
    assign router_1_5_to_router_1_4_rsp = router_1_5_rsp_out[2];
    assign router_1_5_to_router_0_5_rsp = router_1_5_rsp_out[3];
    assign router_1_5_to_magia_tile_ni_1_5_rsp = router_1_5_rsp_out[4];

    assign router_1_5_to_router_1_6_req = router_1_5_req_out[0];
    assign router_1_5_to_router_2_5_req = router_1_5_req_out[1];
    assign router_1_5_to_router_1_4_req = router_1_5_req_out[2];
    assign router_1_5_to_router_0_5_req = router_1_5_req_out[3];
    assign router_1_5_to_magia_tile_ni_1_5_req = router_1_5_req_out[4];

    assign router_1_5_rsp_in[0] = router_1_6_to_router_1_5_rsp;
    assign router_1_5_rsp_in[1] = router_2_5_to_router_1_5_rsp;
    assign router_1_5_rsp_in[2] = router_1_4_to_router_1_5_rsp;
    assign router_1_5_rsp_in[3] = router_0_5_to_router_1_5_rsp;
    assign router_1_5_rsp_in[4] = magia_tile_ni_1_5_to_router_1_5_rsp;

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
) router_1_5 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 2, y: 5, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_1_5_req_in),
  .floo_rsp_o (router_1_5_rsp_out),
  .floo_req_o (router_1_5_req_out),
  .floo_rsp_i (router_1_5_rsp_in)
);


floo_req_t [4:0] router_1_6_req_in;
floo_rsp_t [4:0] router_1_6_rsp_out;
floo_req_t [4:0] router_1_6_req_out;
floo_rsp_t [4:0] router_1_6_rsp_in;

    assign router_1_6_req_in[0] = router_1_7_to_router_1_6_req;
    assign router_1_6_req_in[1] = router_2_6_to_router_1_6_req;
    assign router_1_6_req_in[2] = router_1_5_to_router_1_6_req;
    assign router_1_6_req_in[3] = router_0_6_to_router_1_6_req;
    assign router_1_6_req_in[4] = magia_tile_ni_1_6_to_router_1_6_req;

    assign router_1_6_to_router_1_7_rsp = router_1_6_rsp_out[0];
    assign router_1_6_to_router_2_6_rsp = router_1_6_rsp_out[1];
    assign router_1_6_to_router_1_5_rsp = router_1_6_rsp_out[2];
    assign router_1_6_to_router_0_6_rsp = router_1_6_rsp_out[3];
    assign router_1_6_to_magia_tile_ni_1_6_rsp = router_1_6_rsp_out[4];

    assign router_1_6_to_router_1_7_req = router_1_6_req_out[0];
    assign router_1_6_to_router_2_6_req = router_1_6_req_out[1];
    assign router_1_6_to_router_1_5_req = router_1_6_req_out[2];
    assign router_1_6_to_router_0_6_req = router_1_6_req_out[3];
    assign router_1_6_to_magia_tile_ni_1_6_req = router_1_6_req_out[4];

    assign router_1_6_rsp_in[0] = router_1_7_to_router_1_6_rsp;
    assign router_1_6_rsp_in[1] = router_2_6_to_router_1_6_rsp;
    assign router_1_6_rsp_in[2] = router_1_5_to_router_1_6_rsp;
    assign router_1_6_rsp_in[3] = router_0_6_to_router_1_6_rsp;
    assign router_1_6_rsp_in[4] = magia_tile_ni_1_6_to_router_1_6_rsp;

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
) router_1_6 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 2, y: 6, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_1_6_req_in),
  .floo_rsp_o (router_1_6_rsp_out),
  .floo_req_o (router_1_6_req_out),
  .floo_rsp_i (router_1_6_rsp_in)
);


floo_req_t [4:0] router_1_7_req_in;
floo_rsp_t [4:0] router_1_7_rsp_out;
floo_req_t [4:0] router_1_7_req_out;
floo_rsp_t [4:0] router_1_7_rsp_in;

    assign router_1_7_req_in[0] = '0;
    assign router_1_7_req_in[1] = router_2_7_to_router_1_7_req;
    assign router_1_7_req_in[2] = router_1_6_to_router_1_7_req;
    assign router_1_7_req_in[3] = router_0_7_to_router_1_7_req;
    assign router_1_7_req_in[4] = magia_tile_ni_1_7_to_router_1_7_req;

    assign router_1_7_to_router_2_7_rsp = router_1_7_rsp_out[1];
    assign router_1_7_to_router_1_6_rsp = router_1_7_rsp_out[2];
    assign router_1_7_to_router_0_7_rsp = router_1_7_rsp_out[3];
    assign router_1_7_to_magia_tile_ni_1_7_rsp = router_1_7_rsp_out[4];

    assign router_1_7_to_router_2_7_req = router_1_7_req_out[1];
    assign router_1_7_to_router_1_6_req = router_1_7_req_out[2];
    assign router_1_7_to_router_0_7_req = router_1_7_req_out[3];
    assign router_1_7_to_magia_tile_ni_1_7_req = router_1_7_req_out[4];

    assign router_1_7_rsp_in[0] = '0;
    assign router_1_7_rsp_in[1] = router_2_7_to_router_1_7_rsp;
    assign router_1_7_rsp_in[2] = router_1_6_to_router_1_7_rsp;
    assign router_1_7_rsp_in[3] = router_0_7_to_router_1_7_rsp;
    assign router_1_7_rsp_in[4] = magia_tile_ni_1_7_to_router_1_7_rsp;

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
) router_1_7 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 2, y: 7, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_1_7_req_in),
  .floo_rsp_o (router_1_7_rsp_out),
  .floo_req_o (router_1_7_req_out),
  .floo_rsp_i (router_1_7_rsp_in)
);


floo_req_t [4:0] router_2_0_req_in;
floo_rsp_t [4:0] router_2_0_rsp_out;
floo_req_t [4:0] router_2_0_req_out;
floo_rsp_t [4:0] router_2_0_rsp_in;

    assign router_2_0_req_in[0] = router_2_1_to_router_2_0_req;
    assign router_2_0_req_in[1] = router_3_0_to_router_2_0_req;
    assign router_2_0_req_in[2] = '0;
    assign router_2_0_req_in[3] = router_1_0_to_router_2_0_req;
    assign router_2_0_req_in[4] = magia_tile_ni_2_0_to_router_2_0_req;

    assign router_2_0_to_router_2_1_rsp = router_2_0_rsp_out[0];
    assign router_2_0_to_router_3_0_rsp = router_2_0_rsp_out[1];
    assign router_2_0_to_router_1_0_rsp = router_2_0_rsp_out[3];
    assign router_2_0_to_magia_tile_ni_2_0_rsp = router_2_0_rsp_out[4];

    assign router_2_0_to_router_2_1_req = router_2_0_req_out[0];
    assign router_2_0_to_router_3_0_req = router_2_0_req_out[1];
    assign router_2_0_to_router_1_0_req = router_2_0_req_out[3];
    assign router_2_0_to_magia_tile_ni_2_0_req = router_2_0_req_out[4];

    assign router_2_0_rsp_in[0] = router_2_1_to_router_2_0_rsp;
    assign router_2_0_rsp_in[1] = router_3_0_to_router_2_0_rsp;
    assign router_2_0_rsp_in[2] = '0;
    assign router_2_0_rsp_in[3] = router_1_0_to_router_2_0_rsp;
    assign router_2_0_rsp_in[4] = magia_tile_ni_2_0_to_router_2_0_rsp;

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
) router_2_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 3, y: 0, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_2_0_req_in),
  .floo_rsp_o (router_2_0_rsp_out),
  .floo_req_o (router_2_0_req_out),
  .floo_rsp_i (router_2_0_rsp_in)
);


floo_req_t [4:0] router_2_1_req_in;
floo_rsp_t [4:0] router_2_1_rsp_out;
floo_req_t [4:0] router_2_1_req_out;
floo_rsp_t [4:0] router_2_1_rsp_in;

    assign router_2_1_req_in[0] = router_2_2_to_router_2_1_req;
    assign router_2_1_req_in[1] = router_3_1_to_router_2_1_req;
    assign router_2_1_req_in[2] = router_2_0_to_router_2_1_req;
    assign router_2_1_req_in[3] = router_1_1_to_router_2_1_req;
    assign router_2_1_req_in[4] = magia_tile_ni_2_1_to_router_2_1_req;

    assign router_2_1_to_router_2_2_rsp = router_2_1_rsp_out[0];
    assign router_2_1_to_router_3_1_rsp = router_2_1_rsp_out[1];
    assign router_2_1_to_router_2_0_rsp = router_2_1_rsp_out[2];
    assign router_2_1_to_router_1_1_rsp = router_2_1_rsp_out[3];
    assign router_2_1_to_magia_tile_ni_2_1_rsp = router_2_1_rsp_out[4];

    assign router_2_1_to_router_2_2_req = router_2_1_req_out[0];
    assign router_2_1_to_router_3_1_req = router_2_1_req_out[1];
    assign router_2_1_to_router_2_0_req = router_2_1_req_out[2];
    assign router_2_1_to_router_1_1_req = router_2_1_req_out[3];
    assign router_2_1_to_magia_tile_ni_2_1_req = router_2_1_req_out[4];

    assign router_2_1_rsp_in[0] = router_2_2_to_router_2_1_rsp;
    assign router_2_1_rsp_in[1] = router_3_1_to_router_2_1_rsp;
    assign router_2_1_rsp_in[2] = router_2_0_to_router_2_1_rsp;
    assign router_2_1_rsp_in[3] = router_1_1_to_router_2_1_rsp;
    assign router_2_1_rsp_in[4] = magia_tile_ni_2_1_to_router_2_1_rsp;

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
) router_2_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 3, y: 1, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_2_1_req_in),
  .floo_rsp_o (router_2_1_rsp_out),
  .floo_req_o (router_2_1_req_out),
  .floo_rsp_i (router_2_1_rsp_in)
);


floo_req_t [4:0] router_2_2_req_in;
floo_rsp_t [4:0] router_2_2_rsp_out;
floo_req_t [4:0] router_2_2_req_out;
floo_rsp_t [4:0] router_2_2_rsp_in;

    assign router_2_2_req_in[0] = router_2_3_to_router_2_2_req;
    assign router_2_2_req_in[1] = router_3_2_to_router_2_2_req;
    assign router_2_2_req_in[2] = router_2_1_to_router_2_2_req;
    assign router_2_2_req_in[3] = router_1_2_to_router_2_2_req;
    assign router_2_2_req_in[4] = magia_tile_ni_2_2_to_router_2_2_req;

    assign router_2_2_to_router_2_3_rsp = router_2_2_rsp_out[0];
    assign router_2_2_to_router_3_2_rsp = router_2_2_rsp_out[1];
    assign router_2_2_to_router_2_1_rsp = router_2_2_rsp_out[2];
    assign router_2_2_to_router_1_2_rsp = router_2_2_rsp_out[3];
    assign router_2_2_to_magia_tile_ni_2_2_rsp = router_2_2_rsp_out[4];

    assign router_2_2_to_router_2_3_req = router_2_2_req_out[0];
    assign router_2_2_to_router_3_2_req = router_2_2_req_out[1];
    assign router_2_2_to_router_2_1_req = router_2_2_req_out[2];
    assign router_2_2_to_router_1_2_req = router_2_2_req_out[3];
    assign router_2_2_to_magia_tile_ni_2_2_req = router_2_2_req_out[4];

    assign router_2_2_rsp_in[0] = router_2_3_to_router_2_2_rsp;
    assign router_2_2_rsp_in[1] = router_3_2_to_router_2_2_rsp;
    assign router_2_2_rsp_in[2] = router_2_1_to_router_2_2_rsp;
    assign router_2_2_rsp_in[3] = router_1_2_to_router_2_2_rsp;
    assign router_2_2_rsp_in[4] = magia_tile_ni_2_2_to_router_2_2_rsp;

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
) router_2_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 3, y: 2, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_2_2_req_in),
  .floo_rsp_o (router_2_2_rsp_out),
  .floo_req_o (router_2_2_req_out),
  .floo_rsp_i (router_2_2_rsp_in)
);


floo_req_t [4:0] router_2_3_req_in;
floo_rsp_t [4:0] router_2_3_rsp_out;
floo_req_t [4:0] router_2_3_req_out;
floo_rsp_t [4:0] router_2_3_rsp_in;

    assign router_2_3_req_in[0] = router_2_4_to_router_2_3_req;
    assign router_2_3_req_in[1] = router_3_3_to_router_2_3_req;
    assign router_2_3_req_in[2] = router_2_2_to_router_2_3_req;
    assign router_2_3_req_in[3] = router_1_3_to_router_2_3_req;
    assign router_2_3_req_in[4] = magia_tile_ni_2_3_to_router_2_3_req;

    assign router_2_3_to_router_2_4_rsp = router_2_3_rsp_out[0];
    assign router_2_3_to_router_3_3_rsp = router_2_3_rsp_out[1];
    assign router_2_3_to_router_2_2_rsp = router_2_3_rsp_out[2];
    assign router_2_3_to_router_1_3_rsp = router_2_3_rsp_out[3];
    assign router_2_3_to_magia_tile_ni_2_3_rsp = router_2_3_rsp_out[4];

    assign router_2_3_to_router_2_4_req = router_2_3_req_out[0];
    assign router_2_3_to_router_3_3_req = router_2_3_req_out[1];
    assign router_2_3_to_router_2_2_req = router_2_3_req_out[2];
    assign router_2_3_to_router_1_3_req = router_2_3_req_out[3];
    assign router_2_3_to_magia_tile_ni_2_3_req = router_2_3_req_out[4];

    assign router_2_3_rsp_in[0] = router_2_4_to_router_2_3_rsp;
    assign router_2_3_rsp_in[1] = router_3_3_to_router_2_3_rsp;
    assign router_2_3_rsp_in[2] = router_2_2_to_router_2_3_rsp;
    assign router_2_3_rsp_in[3] = router_1_3_to_router_2_3_rsp;
    assign router_2_3_rsp_in[4] = magia_tile_ni_2_3_to_router_2_3_rsp;

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
) router_2_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 3, y: 3, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_2_3_req_in),
  .floo_rsp_o (router_2_3_rsp_out),
  .floo_req_o (router_2_3_req_out),
  .floo_rsp_i (router_2_3_rsp_in)
);


floo_req_t [4:0] router_2_4_req_in;
floo_rsp_t [4:0] router_2_4_rsp_out;
floo_req_t [4:0] router_2_4_req_out;
floo_rsp_t [4:0] router_2_4_rsp_in;

    assign router_2_4_req_in[0] = router_2_5_to_router_2_4_req;
    assign router_2_4_req_in[1] = router_3_4_to_router_2_4_req;
    assign router_2_4_req_in[2] = router_2_3_to_router_2_4_req;
    assign router_2_4_req_in[3] = router_1_4_to_router_2_4_req;
    assign router_2_4_req_in[4] = magia_tile_ni_2_4_to_router_2_4_req;

    assign router_2_4_to_router_2_5_rsp = router_2_4_rsp_out[0];
    assign router_2_4_to_router_3_4_rsp = router_2_4_rsp_out[1];
    assign router_2_4_to_router_2_3_rsp = router_2_4_rsp_out[2];
    assign router_2_4_to_router_1_4_rsp = router_2_4_rsp_out[3];
    assign router_2_4_to_magia_tile_ni_2_4_rsp = router_2_4_rsp_out[4];

    assign router_2_4_to_router_2_5_req = router_2_4_req_out[0];
    assign router_2_4_to_router_3_4_req = router_2_4_req_out[1];
    assign router_2_4_to_router_2_3_req = router_2_4_req_out[2];
    assign router_2_4_to_router_1_4_req = router_2_4_req_out[3];
    assign router_2_4_to_magia_tile_ni_2_4_req = router_2_4_req_out[4];

    assign router_2_4_rsp_in[0] = router_2_5_to_router_2_4_rsp;
    assign router_2_4_rsp_in[1] = router_3_4_to_router_2_4_rsp;
    assign router_2_4_rsp_in[2] = router_2_3_to_router_2_4_rsp;
    assign router_2_4_rsp_in[3] = router_1_4_to_router_2_4_rsp;
    assign router_2_4_rsp_in[4] = magia_tile_ni_2_4_to_router_2_4_rsp;

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
) router_2_4 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 3, y: 4, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_2_4_req_in),
  .floo_rsp_o (router_2_4_rsp_out),
  .floo_req_o (router_2_4_req_out),
  .floo_rsp_i (router_2_4_rsp_in)
);


floo_req_t [4:0] router_2_5_req_in;
floo_rsp_t [4:0] router_2_5_rsp_out;
floo_req_t [4:0] router_2_5_req_out;
floo_rsp_t [4:0] router_2_5_rsp_in;

    assign router_2_5_req_in[0] = router_2_6_to_router_2_5_req;
    assign router_2_5_req_in[1] = router_3_5_to_router_2_5_req;
    assign router_2_5_req_in[2] = router_2_4_to_router_2_5_req;
    assign router_2_5_req_in[3] = router_1_5_to_router_2_5_req;
    assign router_2_5_req_in[4] = magia_tile_ni_2_5_to_router_2_5_req;

    assign router_2_5_to_router_2_6_rsp = router_2_5_rsp_out[0];
    assign router_2_5_to_router_3_5_rsp = router_2_5_rsp_out[1];
    assign router_2_5_to_router_2_4_rsp = router_2_5_rsp_out[2];
    assign router_2_5_to_router_1_5_rsp = router_2_5_rsp_out[3];
    assign router_2_5_to_magia_tile_ni_2_5_rsp = router_2_5_rsp_out[4];

    assign router_2_5_to_router_2_6_req = router_2_5_req_out[0];
    assign router_2_5_to_router_3_5_req = router_2_5_req_out[1];
    assign router_2_5_to_router_2_4_req = router_2_5_req_out[2];
    assign router_2_5_to_router_1_5_req = router_2_5_req_out[3];
    assign router_2_5_to_magia_tile_ni_2_5_req = router_2_5_req_out[4];

    assign router_2_5_rsp_in[0] = router_2_6_to_router_2_5_rsp;
    assign router_2_5_rsp_in[1] = router_3_5_to_router_2_5_rsp;
    assign router_2_5_rsp_in[2] = router_2_4_to_router_2_5_rsp;
    assign router_2_5_rsp_in[3] = router_1_5_to_router_2_5_rsp;
    assign router_2_5_rsp_in[4] = magia_tile_ni_2_5_to_router_2_5_rsp;

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
) router_2_5 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 3, y: 5, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_2_5_req_in),
  .floo_rsp_o (router_2_5_rsp_out),
  .floo_req_o (router_2_5_req_out),
  .floo_rsp_i (router_2_5_rsp_in)
);


floo_req_t [4:0] router_2_6_req_in;
floo_rsp_t [4:0] router_2_6_rsp_out;
floo_req_t [4:0] router_2_6_req_out;
floo_rsp_t [4:0] router_2_6_rsp_in;

    assign router_2_6_req_in[0] = router_2_7_to_router_2_6_req;
    assign router_2_6_req_in[1] = router_3_6_to_router_2_6_req;
    assign router_2_6_req_in[2] = router_2_5_to_router_2_6_req;
    assign router_2_6_req_in[3] = router_1_6_to_router_2_6_req;
    assign router_2_6_req_in[4] = magia_tile_ni_2_6_to_router_2_6_req;

    assign router_2_6_to_router_2_7_rsp = router_2_6_rsp_out[0];
    assign router_2_6_to_router_3_6_rsp = router_2_6_rsp_out[1];
    assign router_2_6_to_router_2_5_rsp = router_2_6_rsp_out[2];
    assign router_2_6_to_router_1_6_rsp = router_2_6_rsp_out[3];
    assign router_2_6_to_magia_tile_ni_2_6_rsp = router_2_6_rsp_out[4];

    assign router_2_6_to_router_2_7_req = router_2_6_req_out[0];
    assign router_2_6_to_router_3_6_req = router_2_6_req_out[1];
    assign router_2_6_to_router_2_5_req = router_2_6_req_out[2];
    assign router_2_6_to_router_1_6_req = router_2_6_req_out[3];
    assign router_2_6_to_magia_tile_ni_2_6_req = router_2_6_req_out[4];

    assign router_2_6_rsp_in[0] = router_2_7_to_router_2_6_rsp;
    assign router_2_6_rsp_in[1] = router_3_6_to_router_2_6_rsp;
    assign router_2_6_rsp_in[2] = router_2_5_to_router_2_6_rsp;
    assign router_2_6_rsp_in[3] = router_1_6_to_router_2_6_rsp;
    assign router_2_6_rsp_in[4] = magia_tile_ni_2_6_to_router_2_6_rsp;

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
) router_2_6 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 3, y: 6, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_2_6_req_in),
  .floo_rsp_o (router_2_6_rsp_out),
  .floo_req_o (router_2_6_req_out),
  .floo_rsp_i (router_2_6_rsp_in)
);


floo_req_t [4:0] router_2_7_req_in;
floo_rsp_t [4:0] router_2_7_rsp_out;
floo_req_t [4:0] router_2_7_req_out;
floo_rsp_t [4:0] router_2_7_rsp_in;

    assign router_2_7_req_in[0] = '0;
    assign router_2_7_req_in[1] = router_3_7_to_router_2_7_req;
    assign router_2_7_req_in[2] = router_2_6_to_router_2_7_req;
    assign router_2_7_req_in[3] = router_1_7_to_router_2_7_req;
    assign router_2_7_req_in[4] = magia_tile_ni_2_7_to_router_2_7_req;

    assign router_2_7_to_router_3_7_rsp = router_2_7_rsp_out[1];
    assign router_2_7_to_router_2_6_rsp = router_2_7_rsp_out[2];
    assign router_2_7_to_router_1_7_rsp = router_2_7_rsp_out[3];
    assign router_2_7_to_magia_tile_ni_2_7_rsp = router_2_7_rsp_out[4];

    assign router_2_7_to_router_3_7_req = router_2_7_req_out[1];
    assign router_2_7_to_router_2_6_req = router_2_7_req_out[2];
    assign router_2_7_to_router_1_7_req = router_2_7_req_out[3];
    assign router_2_7_to_magia_tile_ni_2_7_req = router_2_7_req_out[4];

    assign router_2_7_rsp_in[0] = '0;
    assign router_2_7_rsp_in[1] = router_3_7_to_router_2_7_rsp;
    assign router_2_7_rsp_in[2] = router_2_6_to_router_2_7_rsp;
    assign router_2_7_rsp_in[3] = router_1_7_to_router_2_7_rsp;
    assign router_2_7_rsp_in[4] = magia_tile_ni_2_7_to_router_2_7_rsp;

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
) router_2_7 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 3, y: 7, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_2_7_req_in),
  .floo_rsp_o (router_2_7_rsp_out),
  .floo_req_o (router_2_7_req_out),
  .floo_rsp_i (router_2_7_rsp_in)
);


floo_req_t [4:0] router_3_0_req_in;
floo_rsp_t [4:0] router_3_0_rsp_out;
floo_req_t [4:0] router_3_0_req_out;
floo_rsp_t [4:0] router_3_0_rsp_in;

    assign router_3_0_req_in[0] = router_3_1_to_router_3_0_req;
    assign router_3_0_req_in[1] = router_4_0_to_router_3_0_req;
    assign router_3_0_req_in[2] = '0;
    assign router_3_0_req_in[3] = router_2_0_to_router_3_0_req;
    assign router_3_0_req_in[4] = magia_tile_ni_3_0_to_router_3_0_req;

    assign router_3_0_to_router_3_1_rsp = router_3_0_rsp_out[0];
    assign router_3_0_to_router_4_0_rsp = router_3_0_rsp_out[1];
    assign router_3_0_to_router_2_0_rsp = router_3_0_rsp_out[3];
    assign router_3_0_to_magia_tile_ni_3_0_rsp = router_3_0_rsp_out[4];

    assign router_3_0_to_router_3_1_req = router_3_0_req_out[0];
    assign router_3_0_to_router_4_0_req = router_3_0_req_out[1];
    assign router_3_0_to_router_2_0_req = router_3_0_req_out[3];
    assign router_3_0_to_magia_tile_ni_3_0_req = router_3_0_req_out[4];

    assign router_3_0_rsp_in[0] = router_3_1_to_router_3_0_rsp;
    assign router_3_0_rsp_in[1] = router_4_0_to_router_3_0_rsp;
    assign router_3_0_rsp_in[2] = '0;
    assign router_3_0_rsp_in[3] = router_2_0_to_router_3_0_rsp;
    assign router_3_0_rsp_in[4] = magia_tile_ni_3_0_to_router_3_0_rsp;

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
) router_3_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 4, y: 0, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_3_0_req_in),
  .floo_rsp_o (router_3_0_rsp_out),
  .floo_req_o (router_3_0_req_out),
  .floo_rsp_i (router_3_0_rsp_in)
);


floo_req_t [4:0] router_3_1_req_in;
floo_rsp_t [4:0] router_3_1_rsp_out;
floo_req_t [4:0] router_3_1_req_out;
floo_rsp_t [4:0] router_3_1_rsp_in;

    assign router_3_1_req_in[0] = router_3_2_to_router_3_1_req;
    assign router_3_1_req_in[1] = router_4_1_to_router_3_1_req;
    assign router_3_1_req_in[2] = router_3_0_to_router_3_1_req;
    assign router_3_1_req_in[3] = router_2_1_to_router_3_1_req;
    assign router_3_1_req_in[4] = magia_tile_ni_3_1_to_router_3_1_req;

    assign router_3_1_to_router_3_2_rsp = router_3_1_rsp_out[0];
    assign router_3_1_to_router_4_1_rsp = router_3_1_rsp_out[1];
    assign router_3_1_to_router_3_0_rsp = router_3_1_rsp_out[2];
    assign router_3_1_to_router_2_1_rsp = router_3_1_rsp_out[3];
    assign router_3_1_to_magia_tile_ni_3_1_rsp = router_3_1_rsp_out[4];

    assign router_3_1_to_router_3_2_req = router_3_1_req_out[0];
    assign router_3_1_to_router_4_1_req = router_3_1_req_out[1];
    assign router_3_1_to_router_3_0_req = router_3_1_req_out[2];
    assign router_3_1_to_router_2_1_req = router_3_1_req_out[3];
    assign router_3_1_to_magia_tile_ni_3_1_req = router_3_1_req_out[4];

    assign router_3_1_rsp_in[0] = router_3_2_to_router_3_1_rsp;
    assign router_3_1_rsp_in[1] = router_4_1_to_router_3_1_rsp;
    assign router_3_1_rsp_in[2] = router_3_0_to_router_3_1_rsp;
    assign router_3_1_rsp_in[3] = router_2_1_to_router_3_1_rsp;
    assign router_3_1_rsp_in[4] = magia_tile_ni_3_1_to_router_3_1_rsp;

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
) router_3_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 4, y: 1, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_3_1_req_in),
  .floo_rsp_o (router_3_1_rsp_out),
  .floo_req_o (router_3_1_req_out),
  .floo_rsp_i (router_3_1_rsp_in)
);


floo_req_t [4:0] router_3_2_req_in;
floo_rsp_t [4:0] router_3_2_rsp_out;
floo_req_t [4:0] router_3_2_req_out;
floo_rsp_t [4:0] router_3_2_rsp_in;

    assign router_3_2_req_in[0] = router_3_3_to_router_3_2_req;
    assign router_3_2_req_in[1] = router_4_2_to_router_3_2_req;
    assign router_3_2_req_in[2] = router_3_1_to_router_3_2_req;
    assign router_3_2_req_in[3] = router_2_2_to_router_3_2_req;
    assign router_3_2_req_in[4] = magia_tile_ni_3_2_to_router_3_2_req;

    assign router_3_2_to_router_3_3_rsp = router_3_2_rsp_out[0];
    assign router_3_2_to_router_4_2_rsp = router_3_2_rsp_out[1];
    assign router_3_2_to_router_3_1_rsp = router_3_2_rsp_out[2];
    assign router_3_2_to_router_2_2_rsp = router_3_2_rsp_out[3];
    assign router_3_2_to_magia_tile_ni_3_2_rsp = router_3_2_rsp_out[4];

    assign router_3_2_to_router_3_3_req = router_3_2_req_out[0];
    assign router_3_2_to_router_4_2_req = router_3_2_req_out[1];
    assign router_3_2_to_router_3_1_req = router_3_2_req_out[2];
    assign router_3_2_to_router_2_2_req = router_3_2_req_out[3];
    assign router_3_2_to_magia_tile_ni_3_2_req = router_3_2_req_out[4];

    assign router_3_2_rsp_in[0] = router_3_3_to_router_3_2_rsp;
    assign router_3_2_rsp_in[1] = router_4_2_to_router_3_2_rsp;
    assign router_3_2_rsp_in[2] = router_3_1_to_router_3_2_rsp;
    assign router_3_2_rsp_in[3] = router_2_2_to_router_3_2_rsp;
    assign router_3_2_rsp_in[4] = magia_tile_ni_3_2_to_router_3_2_rsp;

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
) router_3_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 4, y: 2, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_3_2_req_in),
  .floo_rsp_o (router_3_2_rsp_out),
  .floo_req_o (router_3_2_req_out),
  .floo_rsp_i (router_3_2_rsp_in)
);


floo_req_t [4:0] router_3_3_req_in;
floo_rsp_t [4:0] router_3_3_rsp_out;
floo_req_t [4:0] router_3_3_req_out;
floo_rsp_t [4:0] router_3_3_rsp_in;

    assign router_3_3_req_in[0] = router_3_4_to_router_3_3_req;
    assign router_3_3_req_in[1] = router_4_3_to_router_3_3_req;
    assign router_3_3_req_in[2] = router_3_2_to_router_3_3_req;
    assign router_3_3_req_in[3] = router_2_3_to_router_3_3_req;
    assign router_3_3_req_in[4] = magia_tile_ni_3_3_to_router_3_3_req;

    assign router_3_3_to_router_3_4_rsp = router_3_3_rsp_out[0];
    assign router_3_3_to_router_4_3_rsp = router_3_3_rsp_out[1];
    assign router_3_3_to_router_3_2_rsp = router_3_3_rsp_out[2];
    assign router_3_3_to_router_2_3_rsp = router_3_3_rsp_out[3];
    assign router_3_3_to_magia_tile_ni_3_3_rsp = router_3_3_rsp_out[4];

    assign router_3_3_to_router_3_4_req = router_3_3_req_out[0];
    assign router_3_3_to_router_4_3_req = router_3_3_req_out[1];
    assign router_3_3_to_router_3_2_req = router_3_3_req_out[2];
    assign router_3_3_to_router_2_3_req = router_3_3_req_out[3];
    assign router_3_3_to_magia_tile_ni_3_3_req = router_3_3_req_out[4];

    assign router_3_3_rsp_in[0] = router_3_4_to_router_3_3_rsp;
    assign router_3_3_rsp_in[1] = router_4_3_to_router_3_3_rsp;
    assign router_3_3_rsp_in[2] = router_3_2_to_router_3_3_rsp;
    assign router_3_3_rsp_in[3] = router_2_3_to_router_3_3_rsp;
    assign router_3_3_rsp_in[4] = magia_tile_ni_3_3_to_router_3_3_rsp;

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
) router_3_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 4, y: 3, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_3_3_req_in),
  .floo_rsp_o (router_3_3_rsp_out),
  .floo_req_o (router_3_3_req_out),
  .floo_rsp_i (router_3_3_rsp_in)
);


floo_req_t [4:0] router_3_4_req_in;
floo_rsp_t [4:0] router_3_4_rsp_out;
floo_req_t [4:0] router_3_4_req_out;
floo_rsp_t [4:0] router_3_4_rsp_in;

    assign router_3_4_req_in[0] = router_3_5_to_router_3_4_req;
    assign router_3_4_req_in[1] = router_4_4_to_router_3_4_req;
    assign router_3_4_req_in[2] = router_3_3_to_router_3_4_req;
    assign router_3_4_req_in[3] = router_2_4_to_router_3_4_req;
    assign router_3_4_req_in[4] = magia_tile_ni_3_4_to_router_3_4_req;

    assign router_3_4_to_router_3_5_rsp = router_3_4_rsp_out[0];
    assign router_3_4_to_router_4_4_rsp = router_3_4_rsp_out[1];
    assign router_3_4_to_router_3_3_rsp = router_3_4_rsp_out[2];
    assign router_3_4_to_router_2_4_rsp = router_3_4_rsp_out[3];
    assign router_3_4_to_magia_tile_ni_3_4_rsp = router_3_4_rsp_out[4];

    assign router_3_4_to_router_3_5_req = router_3_4_req_out[0];
    assign router_3_4_to_router_4_4_req = router_3_4_req_out[1];
    assign router_3_4_to_router_3_3_req = router_3_4_req_out[2];
    assign router_3_4_to_router_2_4_req = router_3_4_req_out[3];
    assign router_3_4_to_magia_tile_ni_3_4_req = router_3_4_req_out[4];

    assign router_3_4_rsp_in[0] = router_3_5_to_router_3_4_rsp;
    assign router_3_4_rsp_in[1] = router_4_4_to_router_3_4_rsp;
    assign router_3_4_rsp_in[2] = router_3_3_to_router_3_4_rsp;
    assign router_3_4_rsp_in[3] = router_2_4_to_router_3_4_rsp;
    assign router_3_4_rsp_in[4] = magia_tile_ni_3_4_to_router_3_4_rsp;

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
) router_3_4 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 4, y: 4, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_3_4_req_in),
  .floo_rsp_o (router_3_4_rsp_out),
  .floo_req_o (router_3_4_req_out),
  .floo_rsp_i (router_3_4_rsp_in)
);


floo_req_t [4:0] router_3_5_req_in;
floo_rsp_t [4:0] router_3_5_rsp_out;
floo_req_t [4:0] router_3_5_req_out;
floo_rsp_t [4:0] router_3_5_rsp_in;

    assign router_3_5_req_in[0] = router_3_6_to_router_3_5_req;
    assign router_3_5_req_in[1] = router_4_5_to_router_3_5_req;
    assign router_3_5_req_in[2] = router_3_4_to_router_3_5_req;
    assign router_3_5_req_in[3] = router_2_5_to_router_3_5_req;
    assign router_3_5_req_in[4] = magia_tile_ni_3_5_to_router_3_5_req;

    assign router_3_5_to_router_3_6_rsp = router_3_5_rsp_out[0];
    assign router_3_5_to_router_4_5_rsp = router_3_5_rsp_out[1];
    assign router_3_5_to_router_3_4_rsp = router_3_5_rsp_out[2];
    assign router_3_5_to_router_2_5_rsp = router_3_5_rsp_out[3];
    assign router_3_5_to_magia_tile_ni_3_5_rsp = router_3_5_rsp_out[4];

    assign router_3_5_to_router_3_6_req = router_3_5_req_out[0];
    assign router_3_5_to_router_4_5_req = router_3_5_req_out[1];
    assign router_3_5_to_router_3_4_req = router_3_5_req_out[2];
    assign router_3_5_to_router_2_5_req = router_3_5_req_out[3];
    assign router_3_5_to_magia_tile_ni_3_5_req = router_3_5_req_out[4];

    assign router_3_5_rsp_in[0] = router_3_6_to_router_3_5_rsp;
    assign router_3_5_rsp_in[1] = router_4_5_to_router_3_5_rsp;
    assign router_3_5_rsp_in[2] = router_3_4_to_router_3_5_rsp;
    assign router_3_5_rsp_in[3] = router_2_5_to_router_3_5_rsp;
    assign router_3_5_rsp_in[4] = magia_tile_ni_3_5_to_router_3_5_rsp;

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
) router_3_5 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 4, y: 5, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_3_5_req_in),
  .floo_rsp_o (router_3_5_rsp_out),
  .floo_req_o (router_3_5_req_out),
  .floo_rsp_i (router_3_5_rsp_in)
);


floo_req_t [4:0] router_3_6_req_in;
floo_rsp_t [4:0] router_3_6_rsp_out;
floo_req_t [4:0] router_3_6_req_out;
floo_rsp_t [4:0] router_3_6_rsp_in;

    assign router_3_6_req_in[0] = router_3_7_to_router_3_6_req;
    assign router_3_6_req_in[1] = router_4_6_to_router_3_6_req;
    assign router_3_6_req_in[2] = router_3_5_to_router_3_6_req;
    assign router_3_6_req_in[3] = router_2_6_to_router_3_6_req;
    assign router_3_6_req_in[4] = magia_tile_ni_3_6_to_router_3_6_req;

    assign router_3_6_to_router_3_7_rsp = router_3_6_rsp_out[0];
    assign router_3_6_to_router_4_6_rsp = router_3_6_rsp_out[1];
    assign router_3_6_to_router_3_5_rsp = router_3_6_rsp_out[2];
    assign router_3_6_to_router_2_6_rsp = router_3_6_rsp_out[3];
    assign router_3_6_to_magia_tile_ni_3_6_rsp = router_3_6_rsp_out[4];

    assign router_3_6_to_router_3_7_req = router_3_6_req_out[0];
    assign router_3_6_to_router_4_6_req = router_3_6_req_out[1];
    assign router_3_6_to_router_3_5_req = router_3_6_req_out[2];
    assign router_3_6_to_router_2_6_req = router_3_6_req_out[3];
    assign router_3_6_to_magia_tile_ni_3_6_req = router_3_6_req_out[4];

    assign router_3_6_rsp_in[0] = router_3_7_to_router_3_6_rsp;
    assign router_3_6_rsp_in[1] = router_4_6_to_router_3_6_rsp;
    assign router_3_6_rsp_in[2] = router_3_5_to_router_3_6_rsp;
    assign router_3_6_rsp_in[3] = router_2_6_to_router_3_6_rsp;
    assign router_3_6_rsp_in[4] = magia_tile_ni_3_6_to_router_3_6_rsp;

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
) router_3_6 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 4, y: 6, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_3_6_req_in),
  .floo_rsp_o (router_3_6_rsp_out),
  .floo_req_o (router_3_6_req_out),
  .floo_rsp_i (router_3_6_rsp_in)
);


floo_req_t [4:0] router_3_7_req_in;
floo_rsp_t [4:0] router_3_7_rsp_out;
floo_req_t [4:0] router_3_7_req_out;
floo_rsp_t [4:0] router_3_7_rsp_in;

    assign router_3_7_req_in[0] = '0;
    assign router_3_7_req_in[1] = router_4_7_to_router_3_7_req;
    assign router_3_7_req_in[2] = router_3_6_to_router_3_7_req;
    assign router_3_7_req_in[3] = router_2_7_to_router_3_7_req;
    assign router_3_7_req_in[4] = magia_tile_ni_3_7_to_router_3_7_req;

    assign router_3_7_to_router_4_7_rsp = router_3_7_rsp_out[1];
    assign router_3_7_to_router_3_6_rsp = router_3_7_rsp_out[2];
    assign router_3_7_to_router_2_7_rsp = router_3_7_rsp_out[3];
    assign router_3_7_to_magia_tile_ni_3_7_rsp = router_3_7_rsp_out[4];

    assign router_3_7_to_router_4_7_req = router_3_7_req_out[1];
    assign router_3_7_to_router_3_6_req = router_3_7_req_out[2];
    assign router_3_7_to_router_2_7_req = router_3_7_req_out[3];
    assign router_3_7_to_magia_tile_ni_3_7_req = router_3_7_req_out[4];

    assign router_3_7_rsp_in[0] = '0;
    assign router_3_7_rsp_in[1] = router_4_7_to_router_3_7_rsp;
    assign router_3_7_rsp_in[2] = router_3_6_to_router_3_7_rsp;
    assign router_3_7_rsp_in[3] = router_2_7_to_router_3_7_rsp;
    assign router_3_7_rsp_in[4] = magia_tile_ni_3_7_to_router_3_7_rsp;

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
) router_3_7 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 4, y: 7, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_3_7_req_in),
  .floo_rsp_o (router_3_7_rsp_out),
  .floo_req_o (router_3_7_req_out),
  .floo_rsp_i (router_3_7_rsp_in)
);


floo_req_t [4:0] router_4_0_req_in;
floo_rsp_t [4:0] router_4_0_rsp_out;
floo_req_t [4:0] router_4_0_req_out;
floo_rsp_t [4:0] router_4_0_rsp_in;

    assign router_4_0_req_in[0] = router_4_1_to_router_4_0_req;
    assign router_4_0_req_in[1] = router_5_0_to_router_4_0_req;
    assign router_4_0_req_in[2] = '0;
    assign router_4_0_req_in[3] = router_3_0_to_router_4_0_req;
    assign router_4_0_req_in[4] = magia_tile_ni_4_0_to_router_4_0_req;

    assign router_4_0_to_router_4_1_rsp = router_4_0_rsp_out[0];
    assign router_4_0_to_router_5_0_rsp = router_4_0_rsp_out[1];
    assign router_4_0_to_router_3_0_rsp = router_4_0_rsp_out[3];
    assign router_4_0_to_magia_tile_ni_4_0_rsp = router_4_0_rsp_out[4];

    assign router_4_0_to_router_4_1_req = router_4_0_req_out[0];
    assign router_4_0_to_router_5_0_req = router_4_0_req_out[1];
    assign router_4_0_to_router_3_0_req = router_4_0_req_out[3];
    assign router_4_0_to_magia_tile_ni_4_0_req = router_4_0_req_out[4];

    assign router_4_0_rsp_in[0] = router_4_1_to_router_4_0_rsp;
    assign router_4_0_rsp_in[1] = router_5_0_to_router_4_0_rsp;
    assign router_4_0_rsp_in[2] = '0;
    assign router_4_0_rsp_in[3] = router_3_0_to_router_4_0_rsp;
    assign router_4_0_rsp_in[4] = magia_tile_ni_4_0_to_router_4_0_rsp;

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
) router_4_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 5, y: 0, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_4_0_req_in),
  .floo_rsp_o (router_4_0_rsp_out),
  .floo_req_o (router_4_0_req_out),
  .floo_rsp_i (router_4_0_rsp_in)
);


floo_req_t [4:0] router_4_1_req_in;
floo_rsp_t [4:0] router_4_1_rsp_out;
floo_req_t [4:0] router_4_1_req_out;
floo_rsp_t [4:0] router_4_1_rsp_in;

    assign router_4_1_req_in[0] = router_4_2_to_router_4_1_req;
    assign router_4_1_req_in[1] = router_5_1_to_router_4_1_req;
    assign router_4_1_req_in[2] = router_4_0_to_router_4_1_req;
    assign router_4_1_req_in[3] = router_3_1_to_router_4_1_req;
    assign router_4_1_req_in[4] = magia_tile_ni_4_1_to_router_4_1_req;

    assign router_4_1_to_router_4_2_rsp = router_4_1_rsp_out[0];
    assign router_4_1_to_router_5_1_rsp = router_4_1_rsp_out[1];
    assign router_4_1_to_router_4_0_rsp = router_4_1_rsp_out[2];
    assign router_4_1_to_router_3_1_rsp = router_4_1_rsp_out[3];
    assign router_4_1_to_magia_tile_ni_4_1_rsp = router_4_1_rsp_out[4];

    assign router_4_1_to_router_4_2_req = router_4_1_req_out[0];
    assign router_4_1_to_router_5_1_req = router_4_1_req_out[1];
    assign router_4_1_to_router_4_0_req = router_4_1_req_out[2];
    assign router_4_1_to_router_3_1_req = router_4_1_req_out[3];
    assign router_4_1_to_magia_tile_ni_4_1_req = router_4_1_req_out[4];

    assign router_4_1_rsp_in[0] = router_4_2_to_router_4_1_rsp;
    assign router_4_1_rsp_in[1] = router_5_1_to_router_4_1_rsp;
    assign router_4_1_rsp_in[2] = router_4_0_to_router_4_1_rsp;
    assign router_4_1_rsp_in[3] = router_3_1_to_router_4_1_rsp;
    assign router_4_1_rsp_in[4] = magia_tile_ni_4_1_to_router_4_1_rsp;

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
) router_4_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 5, y: 1, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_4_1_req_in),
  .floo_rsp_o (router_4_1_rsp_out),
  .floo_req_o (router_4_1_req_out),
  .floo_rsp_i (router_4_1_rsp_in)
);


floo_req_t [4:0] router_4_2_req_in;
floo_rsp_t [4:0] router_4_2_rsp_out;
floo_req_t [4:0] router_4_2_req_out;
floo_rsp_t [4:0] router_4_2_rsp_in;

    assign router_4_2_req_in[0] = router_4_3_to_router_4_2_req;
    assign router_4_2_req_in[1] = router_5_2_to_router_4_2_req;
    assign router_4_2_req_in[2] = router_4_1_to_router_4_2_req;
    assign router_4_2_req_in[3] = router_3_2_to_router_4_2_req;
    assign router_4_2_req_in[4] = magia_tile_ni_4_2_to_router_4_2_req;

    assign router_4_2_to_router_4_3_rsp = router_4_2_rsp_out[0];
    assign router_4_2_to_router_5_2_rsp = router_4_2_rsp_out[1];
    assign router_4_2_to_router_4_1_rsp = router_4_2_rsp_out[2];
    assign router_4_2_to_router_3_2_rsp = router_4_2_rsp_out[3];
    assign router_4_2_to_magia_tile_ni_4_2_rsp = router_4_2_rsp_out[4];

    assign router_4_2_to_router_4_3_req = router_4_2_req_out[0];
    assign router_4_2_to_router_5_2_req = router_4_2_req_out[1];
    assign router_4_2_to_router_4_1_req = router_4_2_req_out[2];
    assign router_4_2_to_router_3_2_req = router_4_2_req_out[3];
    assign router_4_2_to_magia_tile_ni_4_2_req = router_4_2_req_out[4];

    assign router_4_2_rsp_in[0] = router_4_3_to_router_4_2_rsp;
    assign router_4_2_rsp_in[1] = router_5_2_to_router_4_2_rsp;
    assign router_4_2_rsp_in[2] = router_4_1_to_router_4_2_rsp;
    assign router_4_2_rsp_in[3] = router_3_2_to_router_4_2_rsp;
    assign router_4_2_rsp_in[4] = magia_tile_ni_4_2_to_router_4_2_rsp;

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
) router_4_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 5, y: 2, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_4_2_req_in),
  .floo_rsp_o (router_4_2_rsp_out),
  .floo_req_o (router_4_2_req_out),
  .floo_rsp_i (router_4_2_rsp_in)
);


floo_req_t [4:0] router_4_3_req_in;
floo_rsp_t [4:0] router_4_3_rsp_out;
floo_req_t [4:0] router_4_3_req_out;
floo_rsp_t [4:0] router_4_3_rsp_in;

    assign router_4_3_req_in[0] = router_4_4_to_router_4_3_req;
    assign router_4_3_req_in[1] = router_5_3_to_router_4_3_req;
    assign router_4_3_req_in[2] = router_4_2_to_router_4_3_req;
    assign router_4_3_req_in[3] = router_3_3_to_router_4_3_req;
    assign router_4_3_req_in[4] = magia_tile_ni_4_3_to_router_4_3_req;

    assign router_4_3_to_router_4_4_rsp = router_4_3_rsp_out[0];
    assign router_4_3_to_router_5_3_rsp = router_4_3_rsp_out[1];
    assign router_4_3_to_router_4_2_rsp = router_4_3_rsp_out[2];
    assign router_4_3_to_router_3_3_rsp = router_4_3_rsp_out[3];
    assign router_4_3_to_magia_tile_ni_4_3_rsp = router_4_3_rsp_out[4];

    assign router_4_3_to_router_4_4_req = router_4_3_req_out[0];
    assign router_4_3_to_router_5_3_req = router_4_3_req_out[1];
    assign router_4_3_to_router_4_2_req = router_4_3_req_out[2];
    assign router_4_3_to_router_3_3_req = router_4_3_req_out[3];
    assign router_4_3_to_magia_tile_ni_4_3_req = router_4_3_req_out[4];

    assign router_4_3_rsp_in[0] = router_4_4_to_router_4_3_rsp;
    assign router_4_3_rsp_in[1] = router_5_3_to_router_4_3_rsp;
    assign router_4_3_rsp_in[2] = router_4_2_to_router_4_3_rsp;
    assign router_4_3_rsp_in[3] = router_3_3_to_router_4_3_rsp;
    assign router_4_3_rsp_in[4] = magia_tile_ni_4_3_to_router_4_3_rsp;

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
) router_4_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 5, y: 3, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_4_3_req_in),
  .floo_rsp_o (router_4_3_rsp_out),
  .floo_req_o (router_4_3_req_out),
  .floo_rsp_i (router_4_3_rsp_in)
);


floo_req_t [4:0] router_4_4_req_in;
floo_rsp_t [4:0] router_4_4_rsp_out;
floo_req_t [4:0] router_4_4_req_out;
floo_rsp_t [4:0] router_4_4_rsp_in;

    assign router_4_4_req_in[0] = router_4_5_to_router_4_4_req;
    assign router_4_4_req_in[1] = router_5_4_to_router_4_4_req;
    assign router_4_4_req_in[2] = router_4_3_to_router_4_4_req;
    assign router_4_4_req_in[3] = router_3_4_to_router_4_4_req;
    assign router_4_4_req_in[4] = magia_tile_ni_4_4_to_router_4_4_req;

    assign router_4_4_to_router_4_5_rsp = router_4_4_rsp_out[0];
    assign router_4_4_to_router_5_4_rsp = router_4_4_rsp_out[1];
    assign router_4_4_to_router_4_3_rsp = router_4_4_rsp_out[2];
    assign router_4_4_to_router_3_4_rsp = router_4_4_rsp_out[3];
    assign router_4_4_to_magia_tile_ni_4_4_rsp = router_4_4_rsp_out[4];

    assign router_4_4_to_router_4_5_req = router_4_4_req_out[0];
    assign router_4_4_to_router_5_4_req = router_4_4_req_out[1];
    assign router_4_4_to_router_4_3_req = router_4_4_req_out[2];
    assign router_4_4_to_router_3_4_req = router_4_4_req_out[3];
    assign router_4_4_to_magia_tile_ni_4_4_req = router_4_4_req_out[4];

    assign router_4_4_rsp_in[0] = router_4_5_to_router_4_4_rsp;
    assign router_4_4_rsp_in[1] = router_5_4_to_router_4_4_rsp;
    assign router_4_4_rsp_in[2] = router_4_3_to_router_4_4_rsp;
    assign router_4_4_rsp_in[3] = router_3_4_to_router_4_4_rsp;
    assign router_4_4_rsp_in[4] = magia_tile_ni_4_4_to_router_4_4_rsp;

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
) router_4_4 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 5, y: 4, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_4_4_req_in),
  .floo_rsp_o (router_4_4_rsp_out),
  .floo_req_o (router_4_4_req_out),
  .floo_rsp_i (router_4_4_rsp_in)
);


floo_req_t [4:0] router_4_5_req_in;
floo_rsp_t [4:0] router_4_5_rsp_out;
floo_req_t [4:0] router_4_5_req_out;
floo_rsp_t [4:0] router_4_5_rsp_in;

    assign router_4_5_req_in[0] = router_4_6_to_router_4_5_req;
    assign router_4_5_req_in[1] = router_5_5_to_router_4_5_req;
    assign router_4_5_req_in[2] = router_4_4_to_router_4_5_req;
    assign router_4_5_req_in[3] = router_3_5_to_router_4_5_req;
    assign router_4_5_req_in[4] = magia_tile_ni_4_5_to_router_4_5_req;

    assign router_4_5_to_router_4_6_rsp = router_4_5_rsp_out[0];
    assign router_4_5_to_router_5_5_rsp = router_4_5_rsp_out[1];
    assign router_4_5_to_router_4_4_rsp = router_4_5_rsp_out[2];
    assign router_4_5_to_router_3_5_rsp = router_4_5_rsp_out[3];
    assign router_4_5_to_magia_tile_ni_4_5_rsp = router_4_5_rsp_out[4];

    assign router_4_5_to_router_4_6_req = router_4_5_req_out[0];
    assign router_4_5_to_router_5_5_req = router_4_5_req_out[1];
    assign router_4_5_to_router_4_4_req = router_4_5_req_out[2];
    assign router_4_5_to_router_3_5_req = router_4_5_req_out[3];
    assign router_4_5_to_magia_tile_ni_4_5_req = router_4_5_req_out[4];

    assign router_4_5_rsp_in[0] = router_4_6_to_router_4_5_rsp;
    assign router_4_5_rsp_in[1] = router_5_5_to_router_4_5_rsp;
    assign router_4_5_rsp_in[2] = router_4_4_to_router_4_5_rsp;
    assign router_4_5_rsp_in[3] = router_3_5_to_router_4_5_rsp;
    assign router_4_5_rsp_in[4] = magia_tile_ni_4_5_to_router_4_5_rsp;

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
) router_4_5 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 5, y: 5, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_4_5_req_in),
  .floo_rsp_o (router_4_5_rsp_out),
  .floo_req_o (router_4_5_req_out),
  .floo_rsp_i (router_4_5_rsp_in)
);


floo_req_t [4:0] router_4_6_req_in;
floo_rsp_t [4:0] router_4_6_rsp_out;
floo_req_t [4:0] router_4_6_req_out;
floo_rsp_t [4:0] router_4_6_rsp_in;

    assign router_4_6_req_in[0] = router_4_7_to_router_4_6_req;
    assign router_4_6_req_in[1] = router_5_6_to_router_4_6_req;
    assign router_4_6_req_in[2] = router_4_5_to_router_4_6_req;
    assign router_4_6_req_in[3] = router_3_6_to_router_4_6_req;
    assign router_4_6_req_in[4] = magia_tile_ni_4_6_to_router_4_6_req;

    assign router_4_6_to_router_4_7_rsp = router_4_6_rsp_out[0];
    assign router_4_6_to_router_5_6_rsp = router_4_6_rsp_out[1];
    assign router_4_6_to_router_4_5_rsp = router_4_6_rsp_out[2];
    assign router_4_6_to_router_3_6_rsp = router_4_6_rsp_out[3];
    assign router_4_6_to_magia_tile_ni_4_6_rsp = router_4_6_rsp_out[4];

    assign router_4_6_to_router_4_7_req = router_4_6_req_out[0];
    assign router_4_6_to_router_5_6_req = router_4_6_req_out[1];
    assign router_4_6_to_router_4_5_req = router_4_6_req_out[2];
    assign router_4_6_to_router_3_6_req = router_4_6_req_out[3];
    assign router_4_6_to_magia_tile_ni_4_6_req = router_4_6_req_out[4];

    assign router_4_6_rsp_in[0] = router_4_7_to_router_4_6_rsp;
    assign router_4_6_rsp_in[1] = router_5_6_to_router_4_6_rsp;
    assign router_4_6_rsp_in[2] = router_4_5_to_router_4_6_rsp;
    assign router_4_6_rsp_in[3] = router_3_6_to_router_4_6_rsp;
    assign router_4_6_rsp_in[4] = magia_tile_ni_4_6_to_router_4_6_rsp;

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
) router_4_6 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 5, y: 6, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_4_6_req_in),
  .floo_rsp_o (router_4_6_rsp_out),
  .floo_req_o (router_4_6_req_out),
  .floo_rsp_i (router_4_6_rsp_in)
);


floo_req_t [4:0] router_4_7_req_in;
floo_rsp_t [4:0] router_4_7_rsp_out;
floo_req_t [4:0] router_4_7_req_out;
floo_rsp_t [4:0] router_4_7_rsp_in;

    assign router_4_7_req_in[0] = '0;
    assign router_4_7_req_in[1] = router_5_7_to_router_4_7_req;
    assign router_4_7_req_in[2] = router_4_6_to_router_4_7_req;
    assign router_4_7_req_in[3] = router_3_7_to_router_4_7_req;
    assign router_4_7_req_in[4] = magia_tile_ni_4_7_to_router_4_7_req;

    assign router_4_7_to_router_5_7_rsp = router_4_7_rsp_out[1];
    assign router_4_7_to_router_4_6_rsp = router_4_7_rsp_out[2];
    assign router_4_7_to_router_3_7_rsp = router_4_7_rsp_out[3];
    assign router_4_7_to_magia_tile_ni_4_7_rsp = router_4_7_rsp_out[4];

    assign router_4_7_to_router_5_7_req = router_4_7_req_out[1];
    assign router_4_7_to_router_4_6_req = router_4_7_req_out[2];
    assign router_4_7_to_router_3_7_req = router_4_7_req_out[3];
    assign router_4_7_to_magia_tile_ni_4_7_req = router_4_7_req_out[4];

    assign router_4_7_rsp_in[0] = '0;
    assign router_4_7_rsp_in[1] = router_5_7_to_router_4_7_rsp;
    assign router_4_7_rsp_in[2] = router_4_6_to_router_4_7_rsp;
    assign router_4_7_rsp_in[3] = router_3_7_to_router_4_7_rsp;
    assign router_4_7_rsp_in[4] = magia_tile_ni_4_7_to_router_4_7_rsp;

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
) router_4_7 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 5, y: 7, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_4_7_req_in),
  .floo_rsp_o (router_4_7_rsp_out),
  .floo_req_o (router_4_7_req_out),
  .floo_rsp_i (router_4_7_rsp_in)
);


floo_req_t [4:0] router_5_0_req_in;
floo_rsp_t [4:0] router_5_0_rsp_out;
floo_req_t [4:0] router_5_0_req_out;
floo_rsp_t [4:0] router_5_0_rsp_in;

    assign router_5_0_req_in[0] = router_5_1_to_router_5_0_req;
    assign router_5_0_req_in[1] = router_6_0_to_router_5_0_req;
    assign router_5_0_req_in[2] = '0;
    assign router_5_0_req_in[3] = router_4_0_to_router_5_0_req;
    assign router_5_0_req_in[4] = magia_tile_ni_5_0_to_router_5_0_req;

    assign router_5_0_to_router_5_1_rsp = router_5_0_rsp_out[0];
    assign router_5_0_to_router_6_0_rsp = router_5_0_rsp_out[1];
    assign router_5_0_to_router_4_0_rsp = router_5_0_rsp_out[3];
    assign router_5_0_to_magia_tile_ni_5_0_rsp = router_5_0_rsp_out[4];

    assign router_5_0_to_router_5_1_req = router_5_0_req_out[0];
    assign router_5_0_to_router_6_0_req = router_5_0_req_out[1];
    assign router_5_0_to_router_4_0_req = router_5_0_req_out[3];
    assign router_5_0_to_magia_tile_ni_5_0_req = router_5_0_req_out[4];

    assign router_5_0_rsp_in[0] = router_5_1_to_router_5_0_rsp;
    assign router_5_0_rsp_in[1] = router_6_0_to_router_5_0_rsp;
    assign router_5_0_rsp_in[2] = '0;
    assign router_5_0_rsp_in[3] = router_4_0_to_router_5_0_rsp;
    assign router_5_0_rsp_in[4] = magia_tile_ni_5_0_to_router_5_0_rsp;

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
) router_5_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 6, y: 0, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_5_0_req_in),
  .floo_rsp_o (router_5_0_rsp_out),
  .floo_req_o (router_5_0_req_out),
  .floo_rsp_i (router_5_0_rsp_in)
);


floo_req_t [4:0] router_5_1_req_in;
floo_rsp_t [4:0] router_5_1_rsp_out;
floo_req_t [4:0] router_5_1_req_out;
floo_rsp_t [4:0] router_5_1_rsp_in;

    assign router_5_1_req_in[0] = router_5_2_to_router_5_1_req;
    assign router_5_1_req_in[1] = router_6_1_to_router_5_1_req;
    assign router_5_1_req_in[2] = router_5_0_to_router_5_1_req;
    assign router_5_1_req_in[3] = router_4_1_to_router_5_1_req;
    assign router_5_1_req_in[4] = magia_tile_ni_5_1_to_router_5_1_req;

    assign router_5_1_to_router_5_2_rsp = router_5_1_rsp_out[0];
    assign router_5_1_to_router_6_1_rsp = router_5_1_rsp_out[1];
    assign router_5_1_to_router_5_0_rsp = router_5_1_rsp_out[2];
    assign router_5_1_to_router_4_1_rsp = router_5_1_rsp_out[3];
    assign router_5_1_to_magia_tile_ni_5_1_rsp = router_5_1_rsp_out[4];

    assign router_5_1_to_router_5_2_req = router_5_1_req_out[0];
    assign router_5_1_to_router_6_1_req = router_5_1_req_out[1];
    assign router_5_1_to_router_5_0_req = router_5_1_req_out[2];
    assign router_5_1_to_router_4_1_req = router_5_1_req_out[3];
    assign router_5_1_to_magia_tile_ni_5_1_req = router_5_1_req_out[4];

    assign router_5_1_rsp_in[0] = router_5_2_to_router_5_1_rsp;
    assign router_5_1_rsp_in[1] = router_6_1_to_router_5_1_rsp;
    assign router_5_1_rsp_in[2] = router_5_0_to_router_5_1_rsp;
    assign router_5_1_rsp_in[3] = router_4_1_to_router_5_1_rsp;
    assign router_5_1_rsp_in[4] = magia_tile_ni_5_1_to_router_5_1_rsp;

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
) router_5_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 6, y: 1, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_5_1_req_in),
  .floo_rsp_o (router_5_1_rsp_out),
  .floo_req_o (router_5_1_req_out),
  .floo_rsp_i (router_5_1_rsp_in)
);


floo_req_t [4:0] router_5_2_req_in;
floo_rsp_t [4:0] router_5_2_rsp_out;
floo_req_t [4:0] router_5_2_req_out;
floo_rsp_t [4:0] router_5_2_rsp_in;

    assign router_5_2_req_in[0] = router_5_3_to_router_5_2_req;
    assign router_5_2_req_in[1] = router_6_2_to_router_5_2_req;
    assign router_5_2_req_in[2] = router_5_1_to_router_5_2_req;
    assign router_5_2_req_in[3] = router_4_2_to_router_5_2_req;
    assign router_5_2_req_in[4] = magia_tile_ni_5_2_to_router_5_2_req;

    assign router_5_2_to_router_5_3_rsp = router_5_2_rsp_out[0];
    assign router_5_2_to_router_6_2_rsp = router_5_2_rsp_out[1];
    assign router_5_2_to_router_5_1_rsp = router_5_2_rsp_out[2];
    assign router_5_2_to_router_4_2_rsp = router_5_2_rsp_out[3];
    assign router_5_2_to_magia_tile_ni_5_2_rsp = router_5_2_rsp_out[4];

    assign router_5_2_to_router_5_3_req = router_5_2_req_out[0];
    assign router_5_2_to_router_6_2_req = router_5_2_req_out[1];
    assign router_5_2_to_router_5_1_req = router_5_2_req_out[2];
    assign router_5_2_to_router_4_2_req = router_5_2_req_out[3];
    assign router_5_2_to_magia_tile_ni_5_2_req = router_5_2_req_out[4];

    assign router_5_2_rsp_in[0] = router_5_3_to_router_5_2_rsp;
    assign router_5_2_rsp_in[1] = router_6_2_to_router_5_2_rsp;
    assign router_5_2_rsp_in[2] = router_5_1_to_router_5_2_rsp;
    assign router_5_2_rsp_in[3] = router_4_2_to_router_5_2_rsp;
    assign router_5_2_rsp_in[4] = magia_tile_ni_5_2_to_router_5_2_rsp;

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
) router_5_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 6, y: 2, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_5_2_req_in),
  .floo_rsp_o (router_5_2_rsp_out),
  .floo_req_o (router_5_2_req_out),
  .floo_rsp_i (router_5_2_rsp_in)
);


floo_req_t [4:0] router_5_3_req_in;
floo_rsp_t [4:0] router_5_3_rsp_out;
floo_req_t [4:0] router_5_3_req_out;
floo_rsp_t [4:0] router_5_3_rsp_in;

    assign router_5_3_req_in[0] = router_5_4_to_router_5_3_req;
    assign router_5_3_req_in[1] = router_6_3_to_router_5_3_req;
    assign router_5_3_req_in[2] = router_5_2_to_router_5_3_req;
    assign router_5_3_req_in[3] = router_4_3_to_router_5_3_req;
    assign router_5_3_req_in[4] = magia_tile_ni_5_3_to_router_5_3_req;

    assign router_5_3_to_router_5_4_rsp = router_5_3_rsp_out[0];
    assign router_5_3_to_router_6_3_rsp = router_5_3_rsp_out[1];
    assign router_5_3_to_router_5_2_rsp = router_5_3_rsp_out[2];
    assign router_5_3_to_router_4_3_rsp = router_5_3_rsp_out[3];
    assign router_5_3_to_magia_tile_ni_5_3_rsp = router_5_3_rsp_out[4];

    assign router_5_3_to_router_5_4_req = router_5_3_req_out[0];
    assign router_5_3_to_router_6_3_req = router_5_3_req_out[1];
    assign router_5_3_to_router_5_2_req = router_5_3_req_out[2];
    assign router_5_3_to_router_4_3_req = router_5_3_req_out[3];
    assign router_5_3_to_magia_tile_ni_5_3_req = router_5_3_req_out[4];

    assign router_5_3_rsp_in[0] = router_5_4_to_router_5_3_rsp;
    assign router_5_3_rsp_in[1] = router_6_3_to_router_5_3_rsp;
    assign router_5_3_rsp_in[2] = router_5_2_to_router_5_3_rsp;
    assign router_5_3_rsp_in[3] = router_4_3_to_router_5_3_rsp;
    assign router_5_3_rsp_in[4] = magia_tile_ni_5_3_to_router_5_3_rsp;

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
) router_5_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 6, y: 3, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_5_3_req_in),
  .floo_rsp_o (router_5_3_rsp_out),
  .floo_req_o (router_5_3_req_out),
  .floo_rsp_i (router_5_3_rsp_in)
);


floo_req_t [4:0] router_5_4_req_in;
floo_rsp_t [4:0] router_5_4_rsp_out;
floo_req_t [4:0] router_5_4_req_out;
floo_rsp_t [4:0] router_5_4_rsp_in;

    assign router_5_4_req_in[0] = router_5_5_to_router_5_4_req;
    assign router_5_4_req_in[1] = router_6_4_to_router_5_4_req;
    assign router_5_4_req_in[2] = router_5_3_to_router_5_4_req;
    assign router_5_4_req_in[3] = router_4_4_to_router_5_4_req;
    assign router_5_4_req_in[4] = magia_tile_ni_5_4_to_router_5_4_req;

    assign router_5_4_to_router_5_5_rsp = router_5_4_rsp_out[0];
    assign router_5_4_to_router_6_4_rsp = router_5_4_rsp_out[1];
    assign router_5_4_to_router_5_3_rsp = router_5_4_rsp_out[2];
    assign router_5_4_to_router_4_4_rsp = router_5_4_rsp_out[3];
    assign router_5_4_to_magia_tile_ni_5_4_rsp = router_5_4_rsp_out[4];

    assign router_5_4_to_router_5_5_req = router_5_4_req_out[0];
    assign router_5_4_to_router_6_4_req = router_5_4_req_out[1];
    assign router_5_4_to_router_5_3_req = router_5_4_req_out[2];
    assign router_5_4_to_router_4_4_req = router_5_4_req_out[3];
    assign router_5_4_to_magia_tile_ni_5_4_req = router_5_4_req_out[4];

    assign router_5_4_rsp_in[0] = router_5_5_to_router_5_4_rsp;
    assign router_5_4_rsp_in[1] = router_6_4_to_router_5_4_rsp;
    assign router_5_4_rsp_in[2] = router_5_3_to_router_5_4_rsp;
    assign router_5_4_rsp_in[3] = router_4_4_to_router_5_4_rsp;
    assign router_5_4_rsp_in[4] = magia_tile_ni_5_4_to_router_5_4_rsp;

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
) router_5_4 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 6, y: 4, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_5_4_req_in),
  .floo_rsp_o (router_5_4_rsp_out),
  .floo_req_o (router_5_4_req_out),
  .floo_rsp_i (router_5_4_rsp_in)
);


floo_req_t [4:0] router_5_5_req_in;
floo_rsp_t [4:0] router_5_5_rsp_out;
floo_req_t [4:0] router_5_5_req_out;
floo_rsp_t [4:0] router_5_5_rsp_in;

    assign router_5_5_req_in[0] = router_5_6_to_router_5_5_req;
    assign router_5_5_req_in[1] = router_6_5_to_router_5_5_req;
    assign router_5_5_req_in[2] = router_5_4_to_router_5_5_req;
    assign router_5_5_req_in[3] = router_4_5_to_router_5_5_req;
    assign router_5_5_req_in[4] = magia_tile_ni_5_5_to_router_5_5_req;

    assign router_5_5_to_router_5_6_rsp = router_5_5_rsp_out[0];
    assign router_5_5_to_router_6_5_rsp = router_5_5_rsp_out[1];
    assign router_5_5_to_router_5_4_rsp = router_5_5_rsp_out[2];
    assign router_5_5_to_router_4_5_rsp = router_5_5_rsp_out[3];
    assign router_5_5_to_magia_tile_ni_5_5_rsp = router_5_5_rsp_out[4];

    assign router_5_5_to_router_5_6_req = router_5_5_req_out[0];
    assign router_5_5_to_router_6_5_req = router_5_5_req_out[1];
    assign router_5_5_to_router_5_4_req = router_5_5_req_out[2];
    assign router_5_5_to_router_4_5_req = router_5_5_req_out[3];
    assign router_5_5_to_magia_tile_ni_5_5_req = router_5_5_req_out[4];

    assign router_5_5_rsp_in[0] = router_5_6_to_router_5_5_rsp;
    assign router_5_5_rsp_in[1] = router_6_5_to_router_5_5_rsp;
    assign router_5_5_rsp_in[2] = router_5_4_to_router_5_5_rsp;
    assign router_5_5_rsp_in[3] = router_4_5_to_router_5_5_rsp;
    assign router_5_5_rsp_in[4] = magia_tile_ni_5_5_to_router_5_5_rsp;

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
) router_5_5 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 6, y: 5, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_5_5_req_in),
  .floo_rsp_o (router_5_5_rsp_out),
  .floo_req_o (router_5_5_req_out),
  .floo_rsp_i (router_5_5_rsp_in)
);


floo_req_t [4:0] router_5_6_req_in;
floo_rsp_t [4:0] router_5_6_rsp_out;
floo_req_t [4:0] router_5_6_req_out;
floo_rsp_t [4:0] router_5_6_rsp_in;

    assign router_5_6_req_in[0] = router_5_7_to_router_5_6_req;
    assign router_5_6_req_in[1] = router_6_6_to_router_5_6_req;
    assign router_5_6_req_in[2] = router_5_5_to_router_5_6_req;
    assign router_5_6_req_in[3] = router_4_6_to_router_5_6_req;
    assign router_5_6_req_in[4] = magia_tile_ni_5_6_to_router_5_6_req;

    assign router_5_6_to_router_5_7_rsp = router_5_6_rsp_out[0];
    assign router_5_6_to_router_6_6_rsp = router_5_6_rsp_out[1];
    assign router_5_6_to_router_5_5_rsp = router_5_6_rsp_out[2];
    assign router_5_6_to_router_4_6_rsp = router_5_6_rsp_out[3];
    assign router_5_6_to_magia_tile_ni_5_6_rsp = router_5_6_rsp_out[4];

    assign router_5_6_to_router_5_7_req = router_5_6_req_out[0];
    assign router_5_6_to_router_6_6_req = router_5_6_req_out[1];
    assign router_5_6_to_router_5_5_req = router_5_6_req_out[2];
    assign router_5_6_to_router_4_6_req = router_5_6_req_out[3];
    assign router_5_6_to_magia_tile_ni_5_6_req = router_5_6_req_out[4];

    assign router_5_6_rsp_in[0] = router_5_7_to_router_5_6_rsp;
    assign router_5_6_rsp_in[1] = router_6_6_to_router_5_6_rsp;
    assign router_5_6_rsp_in[2] = router_5_5_to_router_5_6_rsp;
    assign router_5_6_rsp_in[3] = router_4_6_to_router_5_6_rsp;
    assign router_5_6_rsp_in[4] = magia_tile_ni_5_6_to_router_5_6_rsp;

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
) router_5_6 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 6, y: 6, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_5_6_req_in),
  .floo_rsp_o (router_5_6_rsp_out),
  .floo_req_o (router_5_6_req_out),
  .floo_rsp_i (router_5_6_rsp_in)
);


floo_req_t [4:0] router_5_7_req_in;
floo_rsp_t [4:0] router_5_7_rsp_out;
floo_req_t [4:0] router_5_7_req_out;
floo_rsp_t [4:0] router_5_7_rsp_in;

    assign router_5_7_req_in[0] = '0;
    assign router_5_7_req_in[1] = router_6_7_to_router_5_7_req;
    assign router_5_7_req_in[2] = router_5_6_to_router_5_7_req;
    assign router_5_7_req_in[3] = router_4_7_to_router_5_7_req;
    assign router_5_7_req_in[4] = magia_tile_ni_5_7_to_router_5_7_req;

    assign router_5_7_to_router_6_7_rsp = router_5_7_rsp_out[1];
    assign router_5_7_to_router_5_6_rsp = router_5_7_rsp_out[2];
    assign router_5_7_to_router_4_7_rsp = router_5_7_rsp_out[3];
    assign router_5_7_to_magia_tile_ni_5_7_rsp = router_5_7_rsp_out[4];

    assign router_5_7_to_router_6_7_req = router_5_7_req_out[1];
    assign router_5_7_to_router_5_6_req = router_5_7_req_out[2];
    assign router_5_7_to_router_4_7_req = router_5_7_req_out[3];
    assign router_5_7_to_magia_tile_ni_5_7_req = router_5_7_req_out[4];

    assign router_5_7_rsp_in[0] = '0;
    assign router_5_7_rsp_in[1] = router_6_7_to_router_5_7_rsp;
    assign router_5_7_rsp_in[2] = router_5_6_to_router_5_7_rsp;
    assign router_5_7_rsp_in[3] = router_4_7_to_router_5_7_rsp;
    assign router_5_7_rsp_in[4] = magia_tile_ni_5_7_to_router_5_7_rsp;

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
) router_5_7 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 6, y: 7, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_5_7_req_in),
  .floo_rsp_o (router_5_7_rsp_out),
  .floo_req_o (router_5_7_req_out),
  .floo_rsp_i (router_5_7_rsp_in)
);


floo_req_t [4:0] router_6_0_req_in;
floo_rsp_t [4:0] router_6_0_rsp_out;
floo_req_t [4:0] router_6_0_req_out;
floo_rsp_t [4:0] router_6_0_rsp_in;

    assign router_6_0_req_in[0] = router_6_1_to_router_6_0_req;
    assign router_6_0_req_in[1] = router_7_0_to_router_6_0_req;
    assign router_6_0_req_in[2] = '0;
    assign router_6_0_req_in[3] = router_5_0_to_router_6_0_req;
    assign router_6_0_req_in[4] = magia_tile_ni_6_0_to_router_6_0_req;

    assign router_6_0_to_router_6_1_rsp = router_6_0_rsp_out[0];
    assign router_6_0_to_router_7_0_rsp = router_6_0_rsp_out[1];
    assign router_6_0_to_router_5_0_rsp = router_6_0_rsp_out[3];
    assign router_6_0_to_magia_tile_ni_6_0_rsp = router_6_0_rsp_out[4];

    assign router_6_0_to_router_6_1_req = router_6_0_req_out[0];
    assign router_6_0_to_router_7_0_req = router_6_0_req_out[1];
    assign router_6_0_to_router_5_0_req = router_6_0_req_out[3];
    assign router_6_0_to_magia_tile_ni_6_0_req = router_6_0_req_out[4];

    assign router_6_0_rsp_in[0] = router_6_1_to_router_6_0_rsp;
    assign router_6_0_rsp_in[1] = router_7_0_to_router_6_0_rsp;
    assign router_6_0_rsp_in[2] = '0;
    assign router_6_0_rsp_in[3] = router_5_0_to_router_6_0_rsp;
    assign router_6_0_rsp_in[4] = magia_tile_ni_6_0_to_router_6_0_rsp;

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
) router_6_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 7, y: 0, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_6_0_req_in),
  .floo_rsp_o (router_6_0_rsp_out),
  .floo_req_o (router_6_0_req_out),
  .floo_rsp_i (router_6_0_rsp_in)
);


floo_req_t [4:0] router_6_1_req_in;
floo_rsp_t [4:0] router_6_1_rsp_out;
floo_req_t [4:0] router_6_1_req_out;
floo_rsp_t [4:0] router_6_1_rsp_in;

    assign router_6_1_req_in[0] = router_6_2_to_router_6_1_req;
    assign router_6_1_req_in[1] = router_7_1_to_router_6_1_req;
    assign router_6_1_req_in[2] = router_6_0_to_router_6_1_req;
    assign router_6_1_req_in[3] = router_5_1_to_router_6_1_req;
    assign router_6_1_req_in[4] = magia_tile_ni_6_1_to_router_6_1_req;

    assign router_6_1_to_router_6_2_rsp = router_6_1_rsp_out[0];
    assign router_6_1_to_router_7_1_rsp = router_6_1_rsp_out[1];
    assign router_6_1_to_router_6_0_rsp = router_6_1_rsp_out[2];
    assign router_6_1_to_router_5_1_rsp = router_6_1_rsp_out[3];
    assign router_6_1_to_magia_tile_ni_6_1_rsp = router_6_1_rsp_out[4];

    assign router_6_1_to_router_6_2_req = router_6_1_req_out[0];
    assign router_6_1_to_router_7_1_req = router_6_1_req_out[1];
    assign router_6_1_to_router_6_0_req = router_6_1_req_out[2];
    assign router_6_1_to_router_5_1_req = router_6_1_req_out[3];
    assign router_6_1_to_magia_tile_ni_6_1_req = router_6_1_req_out[4];

    assign router_6_1_rsp_in[0] = router_6_2_to_router_6_1_rsp;
    assign router_6_1_rsp_in[1] = router_7_1_to_router_6_1_rsp;
    assign router_6_1_rsp_in[2] = router_6_0_to_router_6_1_rsp;
    assign router_6_1_rsp_in[3] = router_5_1_to_router_6_1_rsp;
    assign router_6_1_rsp_in[4] = magia_tile_ni_6_1_to_router_6_1_rsp;

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
) router_6_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 7, y: 1, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_6_1_req_in),
  .floo_rsp_o (router_6_1_rsp_out),
  .floo_req_o (router_6_1_req_out),
  .floo_rsp_i (router_6_1_rsp_in)
);


floo_req_t [4:0] router_6_2_req_in;
floo_rsp_t [4:0] router_6_2_rsp_out;
floo_req_t [4:0] router_6_2_req_out;
floo_rsp_t [4:0] router_6_2_rsp_in;

    assign router_6_2_req_in[0] = router_6_3_to_router_6_2_req;
    assign router_6_2_req_in[1] = router_7_2_to_router_6_2_req;
    assign router_6_2_req_in[2] = router_6_1_to_router_6_2_req;
    assign router_6_2_req_in[3] = router_5_2_to_router_6_2_req;
    assign router_6_2_req_in[4] = magia_tile_ni_6_2_to_router_6_2_req;

    assign router_6_2_to_router_6_3_rsp = router_6_2_rsp_out[0];
    assign router_6_2_to_router_7_2_rsp = router_6_2_rsp_out[1];
    assign router_6_2_to_router_6_1_rsp = router_6_2_rsp_out[2];
    assign router_6_2_to_router_5_2_rsp = router_6_2_rsp_out[3];
    assign router_6_2_to_magia_tile_ni_6_2_rsp = router_6_2_rsp_out[4];

    assign router_6_2_to_router_6_3_req = router_6_2_req_out[0];
    assign router_6_2_to_router_7_2_req = router_6_2_req_out[1];
    assign router_6_2_to_router_6_1_req = router_6_2_req_out[2];
    assign router_6_2_to_router_5_2_req = router_6_2_req_out[3];
    assign router_6_2_to_magia_tile_ni_6_2_req = router_6_2_req_out[4];

    assign router_6_2_rsp_in[0] = router_6_3_to_router_6_2_rsp;
    assign router_6_2_rsp_in[1] = router_7_2_to_router_6_2_rsp;
    assign router_6_2_rsp_in[2] = router_6_1_to_router_6_2_rsp;
    assign router_6_2_rsp_in[3] = router_5_2_to_router_6_2_rsp;
    assign router_6_2_rsp_in[4] = magia_tile_ni_6_2_to_router_6_2_rsp;

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
) router_6_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 7, y: 2, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_6_2_req_in),
  .floo_rsp_o (router_6_2_rsp_out),
  .floo_req_o (router_6_2_req_out),
  .floo_rsp_i (router_6_2_rsp_in)
);


floo_req_t [4:0] router_6_3_req_in;
floo_rsp_t [4:0] router_6_3_rsp_out;
floo_req_t [4:0] router_6_3_req_out;
floo_rsp_t [4:0] router_6_3_rsp_in;

    assign router_6_3_req_in[0] = router_6_4_to_router_6_3_req;
    assign router_6_3_req_in[1] = router_7_3_to_router_6_3_req;
    assign router_6_3_req_in[2] = router_6_2_to_router_6_3_req;
    assign router_6_3_req_in[3] = router_5_3_to_router_6_3_req;
    assign router_6_3_req_in[4] = magia_tile_ni_6_3_to_router_6_3_req;

    assign router_6_3_to_router_6_4_rsp = router_6_3_rsp_out[0];
    assign router_6_3_to_router_7_3_rsp = router_6_3_rsp_out[1];
    assign router_6_3_to_router_6_2_rsp = router_6_3_rsp_out[2];
    assign router_6_3_to_router_5_3_rsp = router_6_3_rsp_out[3];
    assign router_6_3_to_magia_tile_ni_6_3_rsp = router_6_3_rsp_out[4];

    assign router_6_3_to_router_6_4_req = router_6_3_req_out[0];
    assign router_6_3_to_router_7_3_req = router_6_3_req_out[1];
    assign router_6_3_to_router_6_2_req = router_6_3_req_out[2];
    assign router_6_3_to_router_5_3_req = router_6_3_req_out[3];
    assign router_6_3_to_magia_tile_ni_6_3_req = router_6_3_req_out[4];

    assign router_6_3_rsp_in[0] = router_6_4_to_router_6_3_rsp;
    assign router_6_3_rsp_in[1] = router_7_3_to_router_6_3_rsp;
    assign router_6_3_rsp_in[2] = router_6_2_to_router_6_3_rsp;
    assign router_6_3_rsp_in[3] = router_5_3_to_router_6_3_rsp;
    assign router_6_3_rsp_in[4] = magia_tile_ni_6_3_to_router_6_3_rsp;

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
) router_6_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 7, y: 3, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_6_3_req_in),
  .floo_rsp_o (router_6_3_rsp_out),
  .floo_req_o (router_6_3_req_out),
  .floo_rsp_i (router_6_3_rsp_in)
);


floo_req_t [4:0] router_6_4_req_in;
floo_rsp_t [4:0] router_6_4_rsp_out;
floo_req_t [4:0] router_6_4_req_out;
floo_rsp_t [4:0] router_6_4_rsp_in;

    assign router_6_4_req_in[0] = router_6_5_to_router_6_4_req;
    assign router_6_4_req_in[1] = router_7_4_to_router_6_4_req;
    assign router_6_4_req_in[2] = router_6_3_to_router_6_4_req;
    assign router_6_4_req_in[3] = router_5_4_to_router_6_4_req;
    assign router_6_4_req_in[4] = magia_tile_ni_6_4_to_router_6_4_req;

    assign router_6_4_to_router_6_5_rsp = router_6_4_rsp_out[0];
    assign router_6_4_to_router_7_4_rsp = router_6_4_rsp_out[1];
    assign router_6_4_to_router_6_3_rsp = router_6_4_rsp_out[2];
    assign router_6_4_to_router_5_4_rsp = router_6_4_rsp_out[3];
    assign router_6_4_to_magia_tile_ni_6_4_rsp = router_6_4_rsp_out[4];

    assign router_6_4_to_router_6_5_req = router_6_4_req_out[0];
    assign router_6_4_to_router_7_4_req = router_6_4_req_out[1];
    assign router_6_4_to_router_6_3_req = router_6_4_req_out[2];
    assign router_6_4_to_router_5_4_req = router_6_4_req_out[3];
    assign router_6_4_to_magia_tile_ni_6_4_req = router_6_4_req_out[4];

    assign router_6_4_rsp_in[0] = router_6_5_to_router_6_4_rsp;
    assign router_6_4_rsp_in[1] = router_7_4_to_router_6_4_rsp;
    assign router_6_4_rsp_in[2] = router_6_3_to_router_6_4_rsp;
    assign router_6_4_rsp_in[3] = router_5_4_to_router_6_4_rsp;
    assign router_6_4_rsp_in[4] = magia_tile_ni_6_4_to_router_6_4_rsp;

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
) router_6_4 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 7, y: 4, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_6_4_req_in),
  .floo_rsp_o (router_6_4_rsp_out),
  .floo_req_o (router_6_4_req_out),
  .floo_rsp_i (router_6_4_rsp_in)
);


floo_req_t [4:0] router_6_5_req_in;
floo_rsp_t [4:0] router_6_5_rsp_out;
floo_req_t [4:0] router_6_5_req_out;
floo_rsp_t [4:0] router_6_5_rsp_in;

    assign router_6_5_req_in[0] = router_6_6_to_router_6_5_req;
    assign router_6_5_req_in[1] = router_7_5_to_router_6_5_req;
    assign router_6_5_req_in[2] = router_6_4_to_router_6_5_req;
    assign router_6_5_req_in[3] = router_5_5_to_router_6_5_req;
    assign router_6_5_req_in[4] = magia_tile_ni_6_5_to_router_6_5_req;

    assign router_6_5_to_router_6_6_rsp = router_6_5_rsp_out[0];
    assign router_6_5_to_router_7_5_rsp = router_6_5_rsp_out[1];
    assign router_6_5_to_router_6_4_rsp = router_6_5_rsp_out[2];
    assign router_6_5_to_router_5_5_rsp = router_6_5_rsp_out[3];
    assign router_6_5_to_magia_tile_ni_6_5_rsp = router_6_5_rsp_out[4];

    assign router_6_5_to_router_6_6_req = router_6_5_req_out[0];
    assign router_6_5_to_router_7_5_req = router_6_5_req_out[1];
    assign router_6_5_to_router_6_4_req = router_6_5_req_out[2];
    assign router_6_5_to_router_5_5_req = router_6_5_req_out[3];
    assign router_6_5_to_magia_tile_ni_6_5_req = router_6_5_req_out[4];

    assign router_6_5_rsp_in[0] = router_6_6_to_router_6_5_rsp;
    assign router_6_5_rsp_in[1] = router_7_5_to_router_6_5_rsp;
    assign router_6_5_rsp_in[2] = router_6_4_to_router_6_5_rsp;
    assign router_6_5_rsp_in[3] = router_5_5_to_router_6_5_rsp;
    assign router_6_5_rsp_in[4] = magia_tile_ni_6_5_to_router_6_5_rsp;

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
) router_6_5 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 7, y: 5, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_6_5_req_in),
  .floo_rsp_o (router_6_5_rsp_out),
  .floo_req_o (router_6_5_req_out),
  .floo_rsp_i (router_6_5_rsp_in)
);


floo_req_t [4:0] router_6_6_req_in;
floo_rsp_t [4:0] router_6_6_rsp_out;
floo_req_t [4:0] router_6_6_req_out;
floo_rsp_t [4:0] router_6_6_rsp_in;

    assign router_6_6_req_in[0] = router_6_7_to_router_6_6_req;
    assign router_6_6_req_in[1] = router_7_6_to_router_6_6_req;
    assign router_6_6_req_in[2] = router_6_5_to_router_6_6_req;
    assign router_6_6_req_in[3] = router_5_6_to_router_6_6_req;
    assign router_6_6_req_in[4] = magia_tile_ni_6_6_to_router_6_6_req;

    assign router_6_6_to_router_6_7_rsp = router_6_6_rsp_out[0];
    assign router_6_6_to_router_7_6_rsp = router_6_6_rsp_out[1];
    assign router_6_6_to_router_6_5_rsp = router_6_6_rsp_out[2];
    assign router_6_6_to_router_5_6_rsp = router_6_6_rsp_out[3];
    assign router_6_6_to_magia_tile_ni_6_6_rsp = router_6_6_rsp_out[4];

    assign router_6_6_to_router_6_7_req = router_6_6_req_out[0];
    assign router_6_6_to_router_7_6_req = router_6_6_req_out[1];
    assign router_6_6_to_router_6_5_req = router_6_6_req_out[2];
    assign router_6_6_to_router_5_6_req = router_6_6_req_out[3];
    assign router_6_6_to_magia_tile_ni_6_6_req = router_6_6_req_out[4];

    assign router_6_6_rsp_in[0] = router_6_7_to_router_6_6_rsp;
    assign router_6_6_rsp_in[1] = router_7_6_to_router_6_6_rsp;
    assign router_6_6_rsp_in[2] = router_6_5_to_router_6_6_rsp;
    assign router_6_6_rsp_in[3] = router_5_6_to_router_6_6_rsp;
    assign router_6_6_rsp_in[4] = magia_tile_ni_6_6_to_router_6_6_rsp;

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
) router_6_6 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 7, y: 6, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_6_6_req_in),
  .floo_rsp_o (router_6_6_rsp_out),
  .floo_req_o (router_6_6_req_out),
  .floo_rsp_i (router_6_6_rsp_in)
);


floo_req_t [4:0] router_6_7_req_in;
floo_rsp_t [4:0] router_6_7_rsp_out;
floo_req_t [4:0] router_6_7_req_out;
floo_rsp_t [4:0] router_6_7_rsp_in;

    assign router_6_7_req_in[0] = '0;
    assign router_6_7_req_in[1] = router_7_7_to_router_6_7_req;
    assign router_6_7_req_in[2] = router_6_6_to_router_6_7_req;
    assign router_6_7_req_in[3] = router_5_7_to_router_6_7_req;
    assign router_6_7_req_in[4] = magia_tile_ni_6_7_to_router_6_7_req;

    assign router_6_7_to_router_7_7_rsp = router_6_7_rsp_out[1];
    assign router_6_7_to_router_6_6_rsp = router_6_7_rsp_out[2];
    assign router_6_7_to_router_5_7_rsp = router_6_7_rsp_out[3];
    assign router_6_7_to_magia_tile_ni_6_7_rsp = router_6_7_rsp_out[4];

    assign router_6_7_to_router_7_7_req = router_6_7_req_out[1];
    assign router_6_7_to_router_6_6_req = router_6_7_req_out[2];
    assign router_6_7_to_router_5_7_req = router_6_7_req_out[3];
    assign router_6_7_to_magia_tile_ni_6_7_req = router_6_7_req_out[4];

    assign router_6_7_rsp_in[0] = '0;
    assign router_6_7_rsp_in[1] = router_7_7_to_router_6_7_rsp;
    assign router_6_7_rsp_in[2] = router_6_6_to_router_6_7_rsp;
    assign router_6_7_rsp_in[3] = router_5_7_to_router_6_7_rsp;
    assign router_6_7_rsp_in[4] = magia_tile_ni_6_7_to_router_6_7_rsp;

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
) router_6_7 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 7, y: 7, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_6_7_req_in),
  .floo_rsp_o (router_6_7_rsp_out),
  .floo_req_o (router_6_7_req_out),
  .floo_rsp_i (router_6_7_rsp_in)
);


floo_req_t [4:0] router_7_0_req_in;
floo_rsp_t [4:0] router_7_0_rsp_out;
floo_req_t [4:0] router_7_0_req_out;
floo_rsp_t [4:0] router_7_0_rsp_in;

    assign router_7_0_req_in[0] = router_7_1_to_router_7_0_req;
    assign router_7_0_req_in[1] = '0;
    assign router_7_0_req_in[2] = '0;
    assign router_7_0_req_in[3] = router_6_0_to_router_7_0_req;
    assign router_7_0_req_in[4] = magia_tile_ni_7_0_to_router_7_0_req;

    assign router_7_0_to_router_7_1_rsp = router_7_0_rsp_out[0];
    assign router_7_0_to_router_6_0_rsp = router_7_0_rsp_out[3];
    assign router_7_0_to_magia_tile_ni_7_0_rsp = router_7_0_rsp_out[4];

    assign router_7_0_to_router_7_1_req = router_7_0_req_out[0];
    assign router_7_0_to_router_6_0_req = router_7_0_req_out[3];
    assign router_7_0_to_magia_tile_ni_7_0_req = router_7_0_req_out[4];

    assign router_7_0_rsp_in[0] = router_7_1_to_router_7_0_rsp;
    assign router_7_0_rsp_in[1] = '0;
    assign router_7_0_rsp_in[2] = '0;
    assign router_7_0_rsp_in[3] = router_6_0_to_router_7_0_rsp;
    assign router_7_0_rsp_in[4] = magia_tile_ni_7_0_to_router_7_0_rsp;

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
) router_7_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 8, y: 0, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_7_0_req_in),
  .floo_rsp_o (router_7_0_rsp_out),
  .floo_req_o (router_7_0_req_out),
  .floo_rsp_i (router_7_0_rsp_in)
);


floo_req_t [4:0] router_7_1_req_in;
floo_rsp_t [4:0] router_7_1_rsp_out;
floo_req_t [4:0] router_7_1_req_out;
floo_rsp_t [4:0] router_7_1_rsp_in;

    assign router_7_1_req_in[0] = router_7_2_to_router_7_1_req;
    assign router_7_1_req_in[1] = '0;
    assign router_7_1_req_in[2] = router_7_0_to_router_7_1_req;
    assign router_7_1_req_in[3] = router_6_1_to_router_7_1_req;
    assign router_7_1_req_in[4] = magia_tile_ni_7_1_to_router_7_1_req;

    assign router_7_1_to_router_7_2_rsp = router_7_1_rsp_out[0];
    assign router_7_1_to_router_7_0_rsp = router_7_1_rsp_out[2];
    assign router_7_1_to_router_6_1_rsp = router_7_1_rsp_out[3];
    assign router_7_1_to_magia_tile_ni_7_1_rsp = router_7_1_rsp_out[4];

    assign router_7_1_to_router_7_2_req = router_7_1_req_out[0];
    assign router_7_1_to_router_7_0_req = router_7_1_req_out[2];
    assign router_7_1_to_router_6_1_req = router_7_1_req_out[3];
    assign router_7_1_to_magia_tile_ni_7_1_req = router_7_1_req_out[4];

    assign router_7_1_rsp_in[0] = router_7_2_to_router_7_1_rsp;
    assign router_7_1_rsp_in[1] = '0;
    assign router_7_1_rsp_in[2] = router_7_0_to_router_7_1_rsp;
    assign router_7_1_rsp_in[3] = router_6_1_to_router_7_1_rsp;
    assign router_7_1_rsp_in[4] = magia_tile_ni_7_1_to_router_7_1_rsp;

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
) router_7_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 8, y: 1, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_7_1_req_in),
  .floo_rsp_o (router_7_1_rsp_out),
  .floo_req_o (router_7_1_req_out),
  .floo_rsp_i (router_7_1_rsp_in)
);


floo_req_t [4:0] router_7_2_req_in;
floo_rsp_t [4:0] router_7_2_rsp_out;
floo_req_t [4:0] router_7_2_req_out;
floo_rsp_t [4:0] router_7_2_rsp_in;

    assign router_7_2_req_in[0] = router_7_3_to_router_7_2_req;
    assign router_7_2_req_in[1] = '0;
    assign router_7_2_req_in[2] = router_7_1_to_router_7_2_req;
    assign router_7_2_req_in[3] = router_6_2_to_router_7_2_req;
    assign router_7_2_req_in[4] = magia_tile_ni_7_2_to_router_7_2_req;

    assign router_7_2_to_router_7_3_rsp = router_7_2_rsp_out[0];
    assign router_7_2_to_router_7_1_rsp = router_7_2_rsp_out[2];
    assign router_7_2_to_router_6_2_rsp = router_7_2_rsp_out[3];
    assign router_7_2_to_magia_tile_ni_7_2_rsp = router_7_2_rsp_out[4];

    assign router_7_2_to_router_7_3_req = router_7_2_req_out[0];
    assign router_7_2_to_router_7_1_req = router_7_2_req_out[2];
    assign router_7_2_to_router_6_2_req = router_7_2_req_out[3];
    assign router_7_2_to_magia_tile_ni_7_2_req = router_7_2_req_out[4];

    assign router_7_2_rsp_in[0] = router_7_3_to_router_7_2_rsp;
    assign router_7_2_rsp_in[1] = '0;
    assign router_7_2_rsp_in[2] = router_7_1_to_router_7_2_rsp;
    assign router_7_2_rsp_in[3] = router_6_2_to_router_7_2_rsp;
    assign router_7_2_rsp_in[4] = magia_tile_ni_7_2_to_router_7_2_rsp;

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
) router_7_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 8, y: 2, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_7_2_req_in),
  .floo_rsp_o (router_7_2_rsp_out),
  .floo_req_o (router_7_2_req_out),
  .floo_rsp_i (router_7_2_rsp_in)
);


floo_req_t [4:0] router_7_3_req_in;
floo_rsp_t [4:0] router_7_3_rsp_out;
floo_req_t [4:0] router_7_3_req_out;
floo_rsp_t [4:0] router_7_3_rsp_in;

    assign router_7_3_req_in[0] = router_7_4_to_router_7_3_req;
    assign router_7_3_req_in[1] = '0;
    assign router_7_3_req_in[2] = router_7_2_to_router_7_3_req;
    assign router_7_3_req_in[3] = router_6_3_to_router_7_3_req;
    assign router_7_3_req_in[4] = magia_tile_ni_7_3_to_router_7_3_req;

    assign router_7_3_to_router_7_4_rsp = router_7_3_rsp_out[0];
    assign router_7_3_to_router_7_2_rsp = router_7_3_rsp_out[2];
    assign router_7_3_to_router_6_3_rsp = router_7_3_rsp_out[3];
    assign router_7_3_to_magia_tile_ni_7_3_rsp = router_7_3_rsp_out[4];

    assign router_7_3_to_router_7_4_req = router_7_3_req_out[0];
    assign router_7_3_to_router_7_2_req = router_7_3_req_out[2];
    assign router_7_3_to_router_6_3_req = router_7_3_req_out[3];
    assign router_7_3_to_magia_tile_ni_7_3_req = router_7_3_req_out[4];

    assign router_7_3_rsp_in[0] = router_7_4_to_router_7_3_rsp;
    assign router_7_3_rsp_in[1] = '0;
    assign router_7_3_rsp_in[2] = router_7_2_to_router_7_3_rsp;
    assign router_7_3_rsp_in[3] = router_6_3_to_router_7_3_rsp;
    assign router_7_3_rsp_in[4] = magia_tile_ni_7_3_to_router_7_3_rsp;

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
) router_7_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 8, y: 3, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_7_3_req_in),
  .floo_rsp_o (router_7_3_rsp_out),
  .floo_req_o (router_7_3_req_out),
  .floo_rsp_i (router_7_3_rsp_in)
);


floo_req_t [4:0] router_7_4_req_in;
floo_rsp_t [4:0] router_7_4_rsp_out;
floo_req_t [4:0] router_7_4_req_out;
floo_rsp_t [4:0] router_7_4_rsp_in;

    assign router_7_4_req_in[0] = router_7_5_to_router_7_4_req;
    assign router_7_4_req_in[1] = '0;
    assign router_7_4_req_in[2] = router_7_3_to_router_7_4_req;
    assign router_7_4_req_in[3] = router_6_4_to_router_7_4_req;
    assign router_7_4_req_in[4] = magia_tile_ni_7_4_to_router_7_4_req;

    assign router_7_4_to_router_7_5_rsp = router_7_4_rsp_out[0];
    assign router_7_4_to_router_7_3_rsp = router_7_4_rsp_out[2];
    assign router_7_4_to_router_6_4_rsp = router_7_4_rsp_out[3];
    assign router_7_4_to_magia_tile_ni_7_4_rsp = router_7_4_rsp_out[4];

    assign router_7_4_to_router_7_5_req = router_7_4_req_out[0];
    assign router_7_4_to_router_7_3_req = router_7_4_req_out[2];
    assign router_7_4_to_router_6_4_req = router_7_4_req_out[3];
    assign router_7_4_to_magia_tile_ni_7_4_req = router_7_4_req_out[4];

    assign router_7_4_rsp_in[0] = router_7_5_to_router_7_4_rsp;
    assign router_7_4_rsp_in[1] = '0;
    assign router_7_4_rsp_in[2] = router_7_3_to_router_7_4_rsp;
    assign router_7_4_rsp_in[3] = router_6_4_to_router_7_4_rsp;
    assign router_7_4_rsp_in[4] = magia_tile_ni_7_4_to_router_7_4_rsp;

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
) router_7_4 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 8, y: 4, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_7_4_req_in),
  .floo_rsp_o (router_7_4_rsp_out),
  .floo_req_o (router_7_4_req_out),
  .floo_rsp_i (router_7_4_rsp_in)
);


floo_req_t [4:0] router_7_5_req_in;
floo_rsp_t [4:0] router_7_5_rsp_out;
floo_req_t [4:0] router_7_5_req_out;
floo_rsp_t [4:0] router_7_5_rsp_in;

    assign router_7_5_req_in[0] = router_7_6_to_router_7_5_req;
    assign router_7_5_req_in[1] = '0;
    assign router_7_5_req_in[2] = router_7_4_to_router_7_5_req;
    assign router_7_5_req_in[3] = router_6_5_to_router_7_5_req;
    assign router_7_5_req_in[4] = magia_tile_ni_7_5_to_router_7_5_req;

    assign router_7_5_to_router_7_6_rsp = router_7_5_rsp_out[0];
    assign router_7_5_to_router_7_4_rsp = router_7_5_rsp_out[2];
    assign router_7_5_to_router_6_5_rsp = router_7_5_rsp_out[3];
    assign router_7_5_to_magia_tile_ni_7_5_rsp = router_7_5_rsp_out[4];

    assign router_7_5_to_router_7_6_req = router_7_5_req_out[0];
    assign router_7_5_to_router_7_4_req = router_7_5_req_out[2];
    assign router_7_5_to_router_6_5_req = router_7_5_req_out[3];
    assign router_7_5_to_magia_tile_ni_7_5_req = router_7_5_req_out[4];

    assign router_7_5_rsp_in[0] = router_7_6_to_router_7_5_rsp;
    assign router_7_5_rsp_in[1] = '0;
    assign router_7_5_rsp_in[2] = router_7_4_to_router_7_5_rsp;
    assign router_7_5_rsp_in[3] = router_6_5_to_router_7_5_rsp;
    assign router_7_5_rsp_in[4] = magia_tile_ni_7_5_to_router_7_5_rsp;

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
) router_7_5 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 8, y: 5, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_7_5_req_in),
  .floo_rsp_o (router_7_5_rsp_out),
  .floo_req_o (router_7_5_req_out),
  .floo_rsp_i (router_7_5_rsp_in)
);


floo_req_t [4:0] router_7_6_req_in;
floo_rsp_t [4:0] router_7_6_rsp_out;
floo_req_t [4:0] router_7_6_req_out;
floo_rsp_t [4:0] router_7_6_rsp_in;

    assign router_7_6_req_in[0] = router_7_7_to_router_7_6_req;
    assign router_7_6_req_in[1] = '0;
    assign router_7_6_req_in[2] = router_7_5_to_router_7_6_req;
    assign router_7_6_req_in[3] = router_6_6_to_router_7_6_req;
    assign router_7_6_req_in[4] = magia_tile_ni_7_6_to_router_7_6_req;

    assign router_7_6_to_router_7_7_rsp = router_7_6_rsp_out[0];
    assign router_7_6_to_router_7_5_rsp = router_7_6_rsp_out[2];
    assign router_7_6_to_router_6_6_rsp = router_7_6_rsp_out[3];
    assign router_7_6_to_magia_tile_ni_7_6_rsp = router_7_6_rsp_out[4];

    assign router_7_6_to_router_7_7_req = router_7_6_req_out[0];
    assign router_7_6_to_router_7_5_req = router_7_6_req_out[2];
    assign router_7_6_to_router_6_6_req = router_7_6_req_out[3];
    assign router_7_6_to_magia_tile_ni_7_6_req = router_7_6_req_out[4];

    assign router_7_6_rsp_in[0] = router_7_7_to_router_7_6_rsp;
    assign router_7_6_rsp_in[1] = '0;
    assign router_7_6_rsp_in[2] = router_7_5_to_router_7_6_rsp;
    assign router_7_6_rsp_in[3] = router_6_6_to_router_7_6_rsp;
    assign router_7_6_rsp_in[4] = magia_tile_ni_7_6_to_router_7_6_rsp;

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
) router_7_6 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 8, y: 6, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_7_6_req_in),
  .floo_rsp_o (router_7_6_rsp_out),
  .floo_req_o (router_7_6_req_out),
  .floo_rsp_i (router_7_6_rsp_in)
);


floo_req_t [4:0] router_7_7_req_in;
floo_rsp_t [4:0] router_7_7_rsp_out;
floo_req_t [4:0] router_7_7_req_out;
floo_rsp_t [4:0] router_7_7_rsp_in;

    assign router_7_7_req_in[0] = '0;
    assign router_7_7_req_in[1] = '0;
    assign router_7_7_req_in[2] = router_7_6_to_router_7_7_req;
    assign router_7_7_req_in[3] = router_6_7_to_router_7_7_req;
    assign router_7_7_req_in[4] = magia_tile_ni_7_7_to_router_7_7_req;

    assign router_7_7_to_router_7_6_rsp = router_7_7_rsp_out[2];
    assign router_7_7_to_router_6_7_rsp = router_7_7_rsp_out[3];
    assign router_7_7_to_magia_tile_ni_7_7_rsp = router_7_7_rsp_out[4];

    assign router_7_7_to_router_7_6_req = router_7_7_req_out[2];
    assign router_7_7_to_router_6_7_req = router_7_7_req_out[3];
    assign router_7_7_to_magia_tile_ni_7_7_req = router_7_7_req_out[4];

    assign router_7_7_rsp_in[0] = '0;
    assign router_7_7_rsp_in[1] = '0;
    assign router_7_7_rsp_in[2] = router_7_6_to_router_7_7_rsp;
    assign router_7_7_rsp_in[3] = router_6_7_to_router_7_7_rsp;
    assign router_7_7_rsp_in[4] = magia_tile_ni_7_7_to_router_7_7_rsp;

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
) router_7_7 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 8, y: 7, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_7_7_req_in),
  .floo_rsp_o (router_7_7_rsp_out),
  .floo_req_o (router_7_7_req_out),
  .floo_rsp_i (router_7_7_rsp_in)
);



endmodule
