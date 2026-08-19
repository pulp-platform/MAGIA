// Copyright 2026 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// AUTOMATICALLY GENERATED! DO NOT EDIT!

`include "axi/typedef.svh"
`include "floo_noc/typedef.svh"

package floo_axi_nw_mesh_2x2_noc_pkg;

  import floo_pkg::*;

  /////////////////////////////
  //   Endpoint Dimensions   //
  /////////////////////////////

  localparam int unsigned NumMagiaTileX = 2;
localparam int unsigned NumMagiaTileY = 2;
localparam int unsigned NumL2 = 2;


  /////////////////////
  //   Address Map   //
  /////////////////////

  typedef enum logic[2:0] {
    MagiaTileX0Y0 = 0,
    MagiaTileX1Y0 = 1,
    MagiaTileX0Y1 = 2,
    MagiaTileX1Y1 = 3,
    L20 = 4,
    L21 = 5,
    NumEndpoints = 6} ep_id_e;



  typedef enum logic[2:0] {
    MagiaTileX0Y0SamIdx = 0,
    MagiaTileX1Y0SamIdx = 1,
    MagiaTileX0Y1SamIdx = 2,
    MagiaTileX1Y1SamIdx = 3,
    L20SamIdx = 4,
    L21SamIdx = 5} sam_idx_e;



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


  typedef struct packed {
    id_t idx;
    id_t start_addr;
    id_t end_addr;
  } route_map_rule_t;

  localparam int unsigned SamNumRules = 6;

typedef struct packed {
    id_t idx;
    logic [31:0] start_addr;
    logic [31:0] end_addr;
} sam_rule_t;

localparam sam_rule_t[SamNumRules-1:0] Sam = '{
'{    idx: '{x: 0, y: 1, port_id: 0},
    start_addr: 32'he0000000,
    end_addr: 32'h100000000},// L21
'{    idx: '{x: 0, y: 0, port_id: 0},
    start_addr: 32'hc0000000,
    end_addr: 32'he0000000},// L20
'{    idx: '{x: 3, y: 1, port_id: 0},
    start_addr: 32'h00300000,
    end_addr: 32'h00400000},// MagiaTileX1Y1
'{    idx: '{x: 2, y: 1, port_id: 0},
    start_addr: 32'h00100000,
    end_addr: 32'h00200000},// MagiaTileX0Y1
'{    idx: '{x: 3, y: 0, port_id: 0},
    start_addr: 32'h00200000,
    end_addr: 32'h00300000},// MagiaTileX1Y0
'{    idx: '{x: 2, y: 0, port_id: 0},
    start_addr: 32'h00000000,
    end_addr: 32'h00100000} // MagiaTileX0Y0

};

    localparam int unsigned CollectiveSamNumRules = 6;

typedef struct packed {
    int unsigned offset;
    int unsigned len;
    int unsigned base_id;
} collective_mask_sel_t;

typedef struct packed {
    id_t id;
    collective_mask_sel_t mask_x;
    collective_mask_sel_t mask_y;
} collective_idx_t;

typedef struct packed {
    collective_idx_t idx;
    logic [31:0] start_addr;
    logic [31:0] end_addr;
} collective_sam_rule_t;

localparam collective_sam_rule_t[CollectiveSamNumRules-1:0] CollectiveSam = '{
'{    idx: '{    id: '{x: 0, y: 1, port_id: 0},
    mask_x: '{    default: '0},
    mask_y: '{    default: '0}},
    start_addr: 32'he0000000,
    end_addr: 32'h100000000},// L21
'{    idx: '{    id: '{x: 0, y: 0, port_id: 0},
    mask_x: '{    default: '0},
    mask_y: '{    default: '0}},
    start_addr: 32'hc0000000,
    end_addr: 32'he0000000},// L20
'{    idx: '{    id: '{x: 3, y: 1, port_id: 0},
    mask_x: '{    offset: 21,
    len: 2,
    base_id: 2},
    mask_y: '{    offset: 20,
    len: 1,
    base_id: 0}},
    start_addr: 32'h00300000,
    end_addr: 32'h00400000},// MagiaTileX1Y1
'{    idx: '{    id: '{x: 2, y: 1, port_id: 0},
    mask_x: '{    offset: 21,
    len: 2,
    base_id: 2},
    mask_y: '{    offset: 20,
    len: 1,
    base_id: 0}},
    start_addr: 32'h00200000,
    end_addr: 32'h00300000},// MagiaTileX0Y1
'{    idx: '{    id: '{x: 3, y: 0, port_id: 0},
    mask_x: '{    offset: 21,
    len: 2,
    base_id: 2},
    mask_y: '{    offset: 20,
    len: 1,
    base_id: 0}},
    start_addr: 32'h00100000,
    end_addr: 32'h00200000},// MagiaTileX1Y0
'{    idx: '{    id: '{x: 2, y: 0, port_id: 0},
    mask_x: '{    offset: 21,
    len: 2,
    base_id: 2},
    mask_y: '{    offset: 20,
    len: 1,
    base_id: 0}},
    start_addr: 32'h00000000,
    end_addr: 32'h00100000} // MagiaTileX0Y0

};



  localparam route_cfg_t RouteCfg = '{    RouteAlgo: XYRouting,
    UseIdTable: 1'b1,
    XYAddrOffsetX: 32,
    XYAddrOffsetY: 34,
    IdAddrOffset: 0,
    NumSamRules: 6,
    NumRoutes: 0,
    CollectiveCfg: '{    OpCfg: '{    EnNarrowMulticast: 1'b1,
    EnWideMulticast: 1'b1,
    EnLsbAnd: 1'b1,
    EnFpAdd: 1'b0,
    EnFpMul: 1'b0,
    EnFpMin: 1'b0,
    EnFpMax: 1'b0,
    EnIntAdd: 1'b1,
    EnIntMul: 1'b1,
    EnIntMinS: 1'b1,
    EnIntMinU: 1'b1,
    EnIntMaxS: 1'b1,
    EnIntMaxU: 1'b1},
    NarrRedCfg: RedDefaultCfg,
    WideRedCfg: '{    RdPipelineDepth: 0,
    CutOffloadIntf: 1'b0}}};

  

    typedef logic[31:0] collective_axi_narrow_data_mst_addr_t;
typedef logic[31:0] collective_axi_narrow_data_mst_data_t;
typedef logic[3:0] collective_axi_narrow_data_mst_strb_t;
typedef logic[1:0] collective_axi_narrow_data_mst_id_t;
typedef struct packed {
    logic [31:0] collective_mask;
    logic [3:0] collective_op;
} collective_axi_narrow_data_mst_user_t;

`AXI_TYPEDEF_ALL_CT(collective_axi_narrow_data_mst,             collective_axi_narrow_data_mst_req_t,             collective_axi_narrow_data_mst_rsp_t,             collective_axi_narrow_data_mst_addr_t,             collective_axi_narrow_data_mst_id_t,             collective_axi_narrow_data_mst_data_t,             collective_axi_narrow_data_mst_strb_t,             collective_axi_narrow_data_mst_user_t)


    typedef logic[31:0] axi_narrow_data_mst_addr_t;
typedef logic[31:0] axi_narrow_data_mst_data_t;
typedef logic[3:0] axi_narrow_data_mst_strb_t;
typedef logic[2:0] axi_narrow_data_mst_id_t;
typedef logic[0:0] axi_narrow_data_mst_user_t;
`AXI_TYPEDEF_ALL_CT(axi_narrow_data_mst,             axi_narrow_data_mst_req_t,             axi_narrow_data_mst_rsp_t,             axi_narrow_data_mst_addr_t,             axi_narrow_data_mst_id_t,             axi_narrow_data_mst_data_t,             axi_narrow_data_mst_strb_t,             axi_narrow_data_mst_user_t)


    typedef logic[31:0] collective_axi_narrow_data_slv_addr_t;
typedef logic[31:0] collective_axi_narrow_data_slv_data_t;
typedef logic[3:0] collective_axi_narrow_data_slv_strb_t;
typedef logic[3:0] collective_axi_narrow_data_slv_id_t;
typedef struct packed {
    logic [31:0] collective_mask;
    logic [3:0] collective_op;
} collective_axi_narrow_data_slv_user_t;

`AXI_TYPEDEF_ALL_CT(collective_axi_narrow_data_slv,             collective_axi_narrow_data_slv_req_t,             collective_axi_narrow_data_slv_rsp_t,             collective_axi_narrow_data_slv_addr_t,             collective_axi_narrow_data_slv_id_t,             collective_axi_narrow_data_slv_data_t,             collective_axi_narrow_data_slv_strb_t,             collective_axi_narrow_data_slv_user_t)


    typedef logic[31:0] axi_narrow_data_slv_addr_t;
typedef logic[31:0] axi_narrow_data_slv_data_t;
typedef logic[3:0] axi_narrow_data_slv_strb_t;
typedef logic[5:0] axi_narrow_data_slv_id_t;
typedef logic[0:0] axi_narrow_data_slv_user_t;
`AXI_TYPEDEF_ALL_CT(axi_narrow_data_slv,             axi_narrow_data_slv_req_t,             axi_narrow_data_slv_rsp_t,             axi_narrow_data_slv_addr_t,             axi_narrow_data_slv_id_t,             axi_narrow_data_slv_data_t,             axi_narrow_data_slv_strb_t,             axi_narrow_data_slv_user_t)


    typedef logic[31:0] collective_axi_wide_data_mst_addr_t;
typedef logic[255:0] collective_axi_wide_data_mst_data_t;
typedef logic[31:0] collective_axi_wide_data_mst_strb_t;
typedef logic[1:0] collective_axi_wide_data_mst_id_t;
typedef struct packed {
    logic [31:0] collective_mask;
    logic [3:0] collective_op;
} collective_axi_wide_data_mst_user_t;

`AXI_TYPEDEF_ALL_CT(collective_axi_wide_data_mst,             collective_axi_wide_data_mst_req_t,             collective_axi_wide_data_mst_rsp_t,             collective_axi_wide_data_mst_addr_t,             collective_axi_wide_data_mst_id_t,             collective_axi_wide_data_mst_data_t,             collective_axi_wide_data_mst_strb_t,             collective_axi_wide_data_mst_user_t)


    typedef logic[31:0] axi_wide_data_mst_addr_t;
typedef logic[255:0] axi_wide_data_mst_data_t;
typedef logic[31:0] axi_wide_data_mst_strb_t;
typedef logic[2:0] axi_wide_data_mst_id_t;
typedef logic[0:0] axi_wide_data_mst_user_t;
`AXI_TYPEDEF_ALL_CT(axi_wide_data_mst,             axi_wide_data_mst_req_t,             axi_wide_data_mst_rsp_t,             axi_wide_data_mst_addr_t,             axi_wide_data_mst_id_t,             axi_wide_data_mst_data_t,             axi_wide_data_mst_strb_t,             axi_wide_data_mst_user_t)


    typedef logic[31:0] collective_axi_wide_data_slv_addr_t;
typedef logic[255:0] collective_axi_wide_data_slv_data_t;
typedef logic[31:0] collective_axi_wide_data_slv_strb_t;
typedef logic[1:0] collective_axi_wide_data_slv_id_t;
typedef struct packed {
    logic [31:0] collective_mask;
    logic [3:0] collective_op;
} collective_axi_wide_data_slv_user_t;

`AXI_TYPEDEF_ALL_CT(collective_axi_wide_data_slv,             collective_axi_wide_data_slv_req_t,             collective_axi_wide_data_slv_rsp_t,             collective_axi_wide_data_slv_addr_t,             collective_axi_wide_data_slv_id_t,             collective_axi_wide_data_slv_data_t,             collective_axi_wide_data_slv_strb_t,             collective_axi_wide_data_slv_user_t)


    typedef logic[31:0] axi_wide_data_slv_addr_t;
typedef logic[255:0] axi_wide_data_slv_data_t;
typedef logic[31:0] axi_wide_data_slv_strb_t;
typedef logic[2:0] axi_wide_data_slv_id_t;
typedef logic[0:0] axi_wide_data_slv_user_t;
`AXI_TYPEDEF_ALL_CT(axi_wide_data_slv,             axi_wide_data_slv_req_t,             axi_wide_data_slv_rsp_t,             axi_wide_data_slv_addr_t,             axi_wide_data_slv_id_t,             axi_wide_data_slv_data_t,             axi_wide_data_slv_strb_t,             axi_wide_data_slv_user_t)



  `FLOO_TYPEDEF_HDR_T(hdr_t, id_t, id_t, nw_ch_e, rob_idx_t, id_t, collect_op_t)
  localparam axi_cfg_t AxiCfgN = '{    AddrWidth: 32,
    DataWidth: 32,
    InIdWidth: 6,
    OutIdWidth: 3,
    UserWidth: 1};
localparam axi_cfg_t AxiCfgW = '{    AddrWidth: 32,
    DataWidth: 256,
    InIdWidth: 3,
    OutIdWidth: 3,
    UserWidth: 1};
`FLOO_TYPEDEF_NW_CHAN_ALL(axi, req, rsp, wide,             axi_narrow_data_slv, axi_wide_data_slv, AxiCfgN, AxiCfgW, hdr_t)

`FLOO_TYPEDEF_NW_LINK_ALL(req, rsp, wide, req, rsp, wide)

  typedef logic [AxiCfgW.DataWidth-1:0] floo_wide_red_data_t;
`FLOO_RED_TYPEDEF_REQ_RSP_LINK(wide, floo_wide_red_data_t, wide_req, wide_rsp)


endpackage
