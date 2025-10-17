// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// AUTOMATICALLY GENERATED! DO NOT EDIT!

`include "axi/typedef.svh"
`include "floo_noc/typedef.svh"

package floo_axi_nw_mesh_4x4_noc_pkg;

  import floo_pkg::*;

  /////////////////////
  //   Address Map   //
  /////////////////////

  typedef enum logic[4:0] {
    MagiaTileX0Y0 = 0,
    MagiaTileX0Y1 = 1,
    MagiaTileX0Y2 = 2,
    MagiaTileX0Y3 = 3,
    MagiaTileX1Y0 = 4,
    MagiaTileX1Y1 = 5,
    MagiaTileX1Y2 = 6,
    MagiaTileX1Y3 = 7,
    MagiaTileX2Y0 = 8,
    MagiaTileX2Y1 = 9,
    MagiaTileX2Y2 = 10,
    MagiaTileX2Y3 = 11,
    MagiaTileX3Y0 = 12,
    MagiaTileX3Y1 = 13,
    MagiaTileX3Y2 = 14,
    MagiaTileX3Y3 = 15,
    L20 = 16,
    L21 = 17,
    L22 = 18,
    L23 = 19,
    NumEndpoints = 20} ep_id_e;



  typedef logic[0:0] rob_idx_t;
typedef logic[0:0] port_id_t;
typedef logic[2:0] x_bits_t;
typedef logic[1:0] y_bits_t;
typedef struct packed {
    x_bits_t x;
    y_bits_t y;
    port_id_t port_id;
} id_t;

typedef logic route_t;


  localparam int unsigned SamNumRules = 20;

typedef struct packed {
    id_t idx;
    logic [31:0] start_addr;
    logic [31:0] end_addr;
} sam_rule_t;

localparam sam_rule_t[SamNumRules-1:0] Sam = '{
'{idx: '{x: 0, y: 3, port_id: 0}, start_addr: 32'hf0000000, end_addr: 32'h100000000},// L2_3_sam_idx
'{idx: '{x: 0, y: 2, port_id: 0}, start_addr: 32'he0000000, end_addr: 32'hf0000000},// L2_2_sam_idx
'{idx: '{x: 0, y: 1, port_id: 0}, start_addr: 32'hd0000000, end_addr: 32'he0000000},// L2_1_sam_idx
'{idx: '{x: 0, y: 0, port_id: 0}, start_addr: 32'hc0000000, end_addr: 32'hd0000000},// L2_0_sam_idx
'{idx: '{x: 4, y: 3, port_id: 0}, start_addr: 32'h00f00000, end_addr: 32'h01000000},// magia_tile_x3_y3_sam_idx
'{idx: '{x: 3, y: 3, port_id: 0}, start_addr: 32'h00e00000, end_addr: 32'h00f00000},// magia_tile_x2_y3_sam_idx
'{idx: '{x: 2, y: 3, port_id: 0}, start_addr: 32'h00d00000, end_addr: 32'h00e00000},// magia_tile_x1_y3_sam_idx
'{idx: '{x: 1, y: 3, port_id: 0}, start_addr: 32'h00c00000, end_addr: 32'h00d00000},// magia_tile_x0_y3_sam_idx
'{idx: '{x: 4, y: 2, port_id: 0}, start_addr: 32'h00b00000, end_addr: 32'h00c00000},// magia_tile_x3_y2_sam_idx
'{idx: '{x: 3, y: 2, port_id: 0}, start_addr: 32'h00a00000, end_addr: 32'h00b00000},// magia_tile_x2_y2_sam_idx
'{idx: '{x: 2, y: 2, port_id: 0}, start_addr: 32'h00900000, end_addr: 32'h00a00000},// magia_tile_x1_y2_sam_idx
'{idx: '{x: 1, y: 2, port_id: 0}, start_addr: 32'h00800000, end_addr: 32'h00900000},// magia_tile_x0_y2_sam_idx
'{idx: '{x: 4, y: 1, port_id: 0}, start_addr: 32'h00700000, end_addr: 32'h00800000},// magia_tile_x3_y1_sam_idx
'{idx: '{x: 3, y: 1, port_id: 0}, start_addr: 32'h00600000, end_addr: 32'h00700000},// magia_tile_x2_y1_sam_idx
'{idx: '{x: 2, y: 1, port_id: 0}, start_addr: 32'h00500000, end_addr: 32'h00600000},// magia_tile_x1_y1_sam_idx
'{idx: '{x: 1, y: 1, port_id: 0}, start_addr: 32'h00400000, end_addr: 32'h00500000},// magia_tile_x0_y1_sam_idx
'{idx: '{x: 4, y: 0, port_id: 0}, start_addr: 32'h00300000, end_addr: 32'h00400000},// magia_tile_x3_y0_sam_idx
'{idx: '{x: 3, y: 0, port_id: 0}, start_addr: 32'h00200000, end_addr: 32'h00300000},// magia_tile_x2_y0_sam_idx
'{idx: '{x: 2, y: 0, port_id: 0}, start_addr: 32'h00100000, end_addr: 32'h00200000},// magia_tile_x1_y0_sam_idx
'{idx: '{x: 1, y: 0, port_id: 0}, start_addr: 32'h00000000, end_addr: 32'h00100000} // magia_tile_x0_y0_sam_idx

};



  localparam route_cfg_t RouteCfg = '{    RouteAlgo: XYRouting,
    UseIdTable: 1'b1,
    XYAddrOffsetX: 32,
    XYAddrOffsetY: 35,
    IdAddrOffset: 0,
    NumSamRules: 20,
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
