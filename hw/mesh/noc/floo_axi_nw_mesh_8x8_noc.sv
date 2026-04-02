// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// AUTOMATICALLY GENERATED! DO NOT EDIT!

`include "axi/typedef.svh"
`include "floo_noc/typedef.svh"

package floo_axi_nw_mesh_8x8_noc_pkg;

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


  typedef logic[31:0] axi_narrow_data_mst_addr_t;
typedef logic[31:0] axi_narrow_data_mst_data_t;
typedef logic[3:0] axi_narrow_data_mst_strb_t;
typedef logic[1:0] axi_narrow_data_mst_id_t;
typedef logic[0:0] axi_narrow_data_mst_user_t;
`AXI_TYPEDEF_ALL_CT(axi_narrow_data_mst,             axi_narrow_data_mst_req_t,             axi_narrow_data_mst_rsp_t,             axi_narrow_data_mst_addr_t,             axi_narrow_data_mst_id_t,             axi_narrow_data_mst_data_t,             axi_narrow_data_mst_strb_t,             axi_narrow_data_mst_user_t)


  typedef logic[31:0] axi_narrow_data_slv_addr_t;
typedef logic[31:0] axi_narrow_data_slv_data_t;
typedef logic[3:0] axi_narrow_data_slv_strb_t;
typedef logic[3:0] axi_narrow_data_slv_id_t;
typedef logic[0:0] axi_narrow_data_slv_user_t;
`AXI_TYPEDEF_ALL_CT(axi_narrow_data_slv,             axi_narrow_data_slv_req_t,             axi_narrow_data_slv_rsp_t,             axi_narrow_data_slv_addr_t,             axi_narrow_data_slv_id_t,             axi_narrow_data_slv_data_t,             axi_narrow_data_slv_strb_t,             axi_narrow_data_slv_user_t)


  typedef logic[31:0] axi_wide_data_mst_addr_t;
typedef logic[255:0] axi_wide_data_mst_data_t;
typedef logic[31:0] axi_wide_data_mst_strb_t;
typedef logic[1:0] axi_wide_data_mst_id_t;
typedef logic[0:0] axi_wide_data_mst_user_t;
`AXI_TYPEDEF_ALL_CT(axi_wide_data_mst,             axi_wide_data_mst_req_t,             axi_wide_data_mst_rsp_t,             axi_wide_data_mst_addr_t,             axi_wide_data_mst_id_t,             axi_wide_data_mst_data_t,             axi_wide_data_mst_strb_t,             axi_wide_data_mst_user_t)


  typedef logic[31:0] axi_wide_data_slv_addr_t;
typedef logic[255:0] axi_wide_data_slv_data_t;
typedef logic[31:0] axi_wide_data_slv_strb_t;
typedef logic[1:0] axi_wide_data_slv_id_t;
typedef logic[0:0] axi_wide_data_slv_user_t;
`AXI_TYPEDEF_ALL_CT(axi_wide_data_slv,             axi_wide_data_slv_req_t,             axi_wide_data_slv_rsp_t,             axi_wide_data_slv_addr_t,             axi_wide_data_slv_id_t,             axi_wide_data_slv_data_t,             axi_wide_data_slv_strb_t,             axi_wide_data_slv_user_t)



  `FLOO_TYPEDEF_HDR_T(hdr_t, id_t, id_t, nw_ch_e, rob_idx_t)
  localparam axi_cfg_t AxiCfgN = '{    AddrWidth: 32,
    DataWidth: 32,
    UserWidth: 1,
    InIdWidth: 4,
    OutIdWidth: 2};
localparam axi_cfg_t AxiCfgW = '{    AddrWidth: 32,
    DataWidth: 256,
    UserWidth: 1,
    InIdWidth: 2,
    OutIdWidth: 2};
`FLOO_TYPEDEF_NW_CHAN_ALL(axi, req, rsp, wide,             axi_narrow_data_slv, axi_wide_data_slv, AxiCfgN, AxiCfgW, hdr_t)

`FLOO_TYPEDEF_NW_LINK_ALL(req, rsp, wide, req, rsp, wide)


endpackage
