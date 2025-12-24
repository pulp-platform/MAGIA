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
typedef logic[2:0] axi_data_mst_id_t;
typedef logic[0:0] axi_data_mst_user_t;
`AXI_TYPEDEF_ALL_CT(axi_data_mst,             axi_data_mst_req_t,             axi_data_mst_rsp_t,             axi_data_mst_addr_t,             axi_data_mst_id_t,             axi_data_mst_data_t,             axi_data_mst_strb_t,             axi_data_mst_user_t)


  typedef logic[31:0] axi_data_slv_addr_t;
typedef logic[31:0] axi_data_slv_data_t;
typedef logic[3:0] axi_data_slv_strb_t;
typedef logic[5:0] axi_data_slv_id_t;
typedef logic[0:0] axi_data_slv_user_t;
`AXI_TYPEDEF_ALL_CT(axi_data_slv,             axi_data_slv_req_t,             axi_data_slv_rsp_t,             axi_data_slv_addr_t,             axi_data_slv_id_t,             axi_data_slv_data_t,             axi_data_slv_strb_t,             axi_data_slv_user_t)



  `FLOO_TYPEDEF_HDR_T(hdr_t, id_t, id_t, axi_ch_e, rob_idx_t)
  localparam axi_cfg_t AxiCfg = '{    AddrWidth: 32,
    DataWidth: 32,
    UserWidth: 1,
    InIdWidth: 6,
    OutIdWidth: 3};
`FLOO_TYPEDEF_AXI_CHAN_ALL(axi, req, rsp, axi_data_slv, AxiCfg, hdr_t)

`FLOO_TYPEDEF_AXI_LINK_ALL(req, rsp, req, rsp)


endpackage
