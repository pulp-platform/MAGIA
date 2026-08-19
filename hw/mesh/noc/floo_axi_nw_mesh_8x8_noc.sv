// Copyright 2026 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// AUTOMATICALLY GENERATED! DO NOT EDIT!

`include "axi/typedef.svh"
`include "floo_noc/typedef.svh"

package floo_axi_nw_mesh_8x8_noc_pkg;

  import floo_pkg::*;

  /////////////////////////////
  //   Endpoint Dimensions   //
  /////////////////////////////

  localparam int unsigned NumMagiaTileX = 8;
localparam int unsigned NumMagiaTileY = 8;
localparam int unsigned NumL2 = 8;


  /////////////////////
  //   Address Map   //
  /////////////////////

  typedef enum logic[6:0] {
    MagiaTileX0Y0 = 0,
    MagiaTileX1Y0 = 1,
    MagiaTileX2Y0 = 2,
    MagiaTileX3Y0 = 3,
    MagiaTileX4Y0 = 4,
    MagiaTileX5Y0 = 5,
    MagiaTileX6Y0 = 6,
    MagiaTileX7Y0 = 7,
    MagiaTileX0Y1 = 8,
    MagiaTileX1Y1 = 9,
    MagiaTileX2Y1 = 10,
    MagiaTileX3Y1 = 11,
    MagiaTileX4Y1 = 12,
    MagiaTileX5Y1 = 13,
    MagiaTileX6Y1 = 14,
    MagiaTileX7Y1 = 15,
    MagiaTileX0Y2 = 16,
    MagiaTileX1Y2 = 17,
    MagiaTileX2Y2 = 18,
    MagiaTileX3Y2 = 19,
    MagiaTileX4Y2 = 20,
    MagiaTileX5Y2 = 21,
    MagiaTileX6Y2 = 22,
    MagiaTileX7Y2 = 23,
    MagiaTileX0Y3 = 24,
    MagiaTileX1Y3 = 25,
    MagiaTileX2Y3 = 26,
    MagiaTileX3Y3 = 27,
    MagiaTileX4Y3 = 28,
    MagiaTileX5Y3 = 29,
    MagiaTileX6Y3 = 30,
    MagiaTileX7Y3 = 31,
    MagiaTileX0Y4 = 32,
    MagiaTileX1Y4 = 33,
    MagiaTileX2Y4 = 34,
    MagiaTileX3Y4 = 35,
    MagiaTileX4Y4 = 36,
    MagiaTileX5Y4 = 37,
    MagiaTileX6Y4 = 38,
    MagiaTileX7Y4 = 39,
    MagiaTileX0Y5 = 40,
    MagiaTileX1Y5 = 41,
    MagiaTileX2Y5 = 42,
    MagiaTileX3Y5 = 43,
    MagiaTileX4Y5 = 44,
    MagiaTileX5Y5 = 45,
    MagiaTileX6Y5 = 46,
    MagiaTileX7Y5 = 47,
    MagiaTileX0Y6 = 48,
    MagiaTileX1Y6 = 49,
    MagiaTileX2Y6 = 50,
    MagiaTileX3Y6 = 51,
    MagiaTileX4Y6 = 52,
    MagiaTileX5Y6 = 53,
    MagiaTileX6Y6 = 54,
    MagiaTileX7Y6 = 55,
    MagiaTileX0Y7 = 56,
    MagiaTileX1Y7 = 57,
    MagiaTileX2Y7 = 58,
    MagiaTileX3Y7 = 59,
    MagiaTileX4Y7 = 60,
    MagiaTileX5Y7 = 61,
    MagiaTileX6Y7 = 62,
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



  typedef enum logic[6:0] {
    MagiaTileX0Y0SamIdx = 0,
    MagiaTileX1Y0SamIdx = 1,
    MagiaTileX2Y0SamIdx = 2,
    MagiaTileX3Y0SamIdx = 3,
    MagiaTileX4Y0SamIdx = 4,
    MagiaTileX5Y0SamIdx = 5,
    MagiaTileX6Y0SamIdx = 6,
    MagiaTileX7Y0SamIdx = 7,
    MagiaTileX0Y1SamIdx = 8,
    MagiaTileX1Y1SamIdx = 9,
    MagiaTileX2Y1SamIdx = 10,
    MagiaTileX3Y1SamIdx = 11,
    MagiaTileX4Y1SamIdx = 12,
    MagiaTileX5Y1SamIdx = 13,
    MagiaTileX6Y1SamIdx = 14,
    MagiaTileX7Y1SamIdx = 15,
    MagiaTileX0Y2SamIdx = 16,
    MagiaTileX1Y2SamIdx = 17,
    MagiaTileX2Y2SamIdx = 18,
    MagiaTileX3Y2SamIdx = 19,
    MagiaTileX4Y2SamIdx = 20,
    MagiaTileX5Y2SamIdx = 21,
    MagiaTileX6Y2SamIdx = 22,
    MagiaTileX7Y2SamIdx = 23,
    MagiaTileX0Y3SamIdx = 24,
    MagiaTileX1Y3SamIdx = 25,
    MagiaTileX2Y3SamIdx = 26,
    MagiaTileX3Y3SamIdx = 27,
    MagiaTileX4Y3SamIdx = 28,
    MagiaTileX5Y3SamIdx = 29,
    MagiaTileX6Y3SamIdx = 30,
    MagiaTileX7Y3SamIdx = 31,
    MagiaTileX0Y4SamIdx = 32,
    MagiaTileX1Y4SamIdx = 33,
    MagiaTileX2Y4SamIdx = 34,
    MagiaTileX3Y4SamIdx = 35,
    MagiaTileX4Y4SamIdx = 36,
    MagiaTileX5Y4SamIdx = 37,
    MagiaTileX6Y4SamIdx = 38,
    MagiaTileX7Y4SamIdx = 39,
    MagiaTileX0Y5SamIdx = 40,
    MagiaTileX1Y5SamIdx = 41,
    MagiaTileX2Y5SamIdx = 42,
    MagiaTileX3Y5SamIdx = 43,
    MagiaTileX4Y5SamIdx = 44,
    MagiaTileX5Y5SamIdx = 45,
    MagiaTileX6Y5SamIdx = 46,
    MagiaTileX7Y5SamIdx = 47,
    MagiaTileX0Y6SamIdx = 48,
    MagiaTileX1Y6SamIdx = 49,
    MagiaTileX2Y6SamIdx = 50,
    MagiaTileX3Y6SamIdx = 51,
    MagiaTileX4Y6SamIdx = 52,
    MagiaTileX5Y6SamIdx = 53,
    MagiaTileX6Y6SamIdx = 54,
    MagiaTileX7Y6SamIdx = 55,
    MagiaTileX0Y7SamIdx = 56,
    MagiaTileX1Y7SamIdx = 57,
    MagiaTileX2Y7SamIdx = 58,
    MagiaTileX3Y7SamIdx = 59,
    MagiaTileX4Y7SamIdx = 60,
    MagiaTileX5Y7SamIdx = 61,
    MagiaTileX6Y7SamIdx = 62,
    MagiaTileX7Y7SamIdx = 63,
    L20SamIdx = 64,
    L21SamIdx = 65,
    L22SamIdx = 66,
    L23SamIdx = 67,
    L24SamIdx = 68,
    L25SamIdx = 69,
    L26SamIdx = 70,
    L27SamIdx = 71} sam_idx_e;



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


  typedef struct packed {
    id_t idx;
    id_t start_addr;
    id_t end_addr;
  } route_map_rule_t;

  localparam int unsigned SamNumRules = 72;

typedef struct packed {
    id_t idx;
    logic [31:0] start_addr;
    logic [31:0] end_addr;
} sam_rule_t;

localparam sam_rule_t[SamNumRules-1:0] Sam = '{
'{    idx: '{x: 0, y: 7, port_id: 0},
    start_addr: 32'hf8000000,
    end_addr: 32'h100000000},// L27
'{    idx: '{x: 0, y: 6, port_id: 0},
    start_addr: 32'hf0000000,
    end_addr: 32'hf8000000},// L26
'{    idx: '{x: 0, y: 5, port_id: 0},
    start_addr: 32'he8000000,
    end_addr: 32'hf0000000},// L25
'{    idx: '{x: 0, y: 4, port_id: 0},
    start_addr: 32'he0000000,
    end_addr: 32'he8000000},// L24
'{    idx: '{x: 0, y: 3, port_id: 0},
    start_addr: 32'hd8000000,
    end_addr: 32'he0000000},// L23
'{    idx: '{x: 0, y: 2, port_id: 0},
    start_addr: 32'hd0000000,
    end_addr: 32'hd8000000},// L22
'{    idx: '{x: 0, y: 1, port_id: 0},
    start_addr: 32'hc8000000,
    end_addr: 32'hd0000000},// L21
'{    idx: '{x: 0, y: 0, port_id: 0},
    start_addr: 32'hc0000000,
    end_addr: 32'hc8000000},// L20
'{    idx: '{x: 15, y: 7, port_id: 0},
    start_addr: 32'h03f00000,
    end_addr: 32'h04000000},// MagiaTileX7Y7
'{    idx: '{x: 14, y: 7, port_id: 0},
    start_addr: 32'h03e00000,
    end_addr: 32'h03f00000},// MagiaTileX6Y7
'{    idx: '{x: 13, y: 7, port_id: 0},
    start_addr: 32'h03d00000,
    end_addr: 32'h03e00000},// MagiaTileX5Y7
'{    idx: '{x: 12, y: 7, port_id: 0},
    start_addr: 32'h03c00000,
    end_addr: 32'h03d00000},// MagiaTileX4Y7
'{    idx: '{x: 11, y: 7, port_id: 0},
    start_addr: 32'h03b00000,
    end_addr: 32'h03c00000},// MagiaTileX3Y7
'{    idx: '{x: 10, y: 7, port_id: 0},
    start_addr: 32'h03a00000,
    end_addr: 32'h03b00000},// MagiaTileX2Y7
'{    idx: '{x: 9, y: 7, port_id: 0},
    start_addr: 32'h03900000,
    end_addr: 32'h03a00000},// MagiaTileX1Y7
'{    idx: '{x: 8, y: 7, port_id: 0},
    start_addr: 32'h03800000,
    end_addr: 32'h03900000},// MagiaTileX0Y7
'{    idx: '{x: 15, y: 6, port_id: 0},
    start_addr: 32'h03700000,
    end_addr: 32'h03800000},// MagiaTileX7Y6
'{    idx: '{x: 14, y: 6, port_id: 0},
    start_addr: 32'h03600000,
    end_addr: 32'h03700000},// MagiaTileX6Y6
'{    idx: '{x: 13, y: 6, port_id: 0},
    start_addr: 32'h03500000,
    end_addr: 32'h03600000},// MagiaTileX5Y6
'{    idx: '{x: 12, y: 6, port_id: 0},
    start_addr: 32'h03400000,
    end_addr: 32'h03500000},// MagiaTileX4Y6
'{    idx: '{x: 11, y: 6, port_id: 0},
    start_addr: 32'h03300000,
    end_addr: 32'h03400000},// MagiaTileX3Y6
'{    idx: '{x: 10, y: 6, port_id: 0},
    start_addr: 32'h03200000,
    end_addr: 32'h03300000},// MagiaTileX2Y6
'{    idx: '{x: 9, y: 6, port_id: 0},
    start_addr: 32'h03100000,
    end_addr: 32'h03200000},// MagiaTileX1Y6
'{    idx: '{x: 8, y: 6, port_id: 0},
    start_addr: 32'h03000000,
    end_addr: 32'h03100000},// MagiaTileX0Y6
'{    idx: '{x: 15, y: 5, port_id: 0},
    start_addr: 32'h02f00000,
    end_addr: 32'h03000000},// MagiaTileX7Y5
'{    idx: '{x: 14, y: 5, port_id: 0},
    start_addr: 32'h02e00000,
    end_addr: 32'h02f00000},// MagiaTileX6Y5
'{    idx: '{x: 13, y: 5, port_id: 0},
    start_addr: 32'h02d00000,
    end_addr: 32'h02e00000},// MagiaTileX5Y5
'{    idx: '{x: 12, y: 5, port_id: 0},
    start_addr: 32'h02c00000,
    end_addr: 32'h02d00000},// MagiaTileX4Y5
'{    idx: '{x: 11, y: 5, port_id: 0},
    start_addr: 32'h02b00000,
    end_addr: 32'h02c00000},// MagiaTileX3Y5
'{    idx: '{x: 10, y: 5, port_id: 0},
    start_addr: 32'h02a00000,
    end_addr: 32'h02b00000},// MagiaTileX2Y5
'{    idx: '{x: 9, y: 5, port_id: 0},
    start_addr: 32'h02900000,
    end_addr: 32'h02a00000},// MagiaTileX1Y5
'{    idx: '{x: 8, y: 5, port_id: 0},
    start_addr: 32'h02800000,
    end_addr: 32'h02900000},// MagiaTileX0Y5
'{    idx: '{x: 15, y: 4, port_id: 0},
    start_addr: 32'h02700000,
    end_addr: 32'h02800000},// MagiaTileX7Y4
'{    idx: '{x: 14, y: 4, port_id: 0},
    start_addr: 32'h02600000,
    end_addr: 32'h02700000},// MagiaTileX6Y4
'{    idx: '{x: 13, y: 4, port_id: 0},
    start_addr: 32'h02500000,
    end_addr: 32'h02600000},// MagiaTileX5Y4
'{    idx: '{x: 12, y: 4, port_id: 0},
    start_addr: 32'h02400000,
    end_addr: 32'h02500000},// MagiaTileX4Y4
'{    idx: '{x: 11, y: 4, port_id: 0},
    start_addr: 32'h02300000,
    end_addr: 32'h02400000},// MagiaTileX3Y4
'{    idx: '{x: 10, y: 4, port_id: 0},
    start_addr: 32'h02200000,
    end_addr: 32'h02300000},// MagiaTileX2Y4
'{    idx: '{x: 9, y: 4, port_id: 0},
    start_addr: 32'h02100000,
    end_addr: 32'h02200000},// MagiaTileX1Y4
'{    idx: '{x: 8, y: 4, port_id: 0},
    start_addr: 32'h02000000,
    end_addr: 32'h02100000},// MagiaTileX0Y4
'{    idx: '{x: 15, y: 3, port_id: 0},
    start_addr: 32'h01f00000,
    end_addr: 32'h02000000},// MagiaTileX7Y3
'{    idx: '{x: 14, y: 3, port_id: 0},
    start_addr: 32'h01e00000,
    end_addr: 32'h01f00000},// MagiaTileX6Y3
'{    idx: '{x: 13, y: 3, port_id: 0},
    start_addr: 32'h01d00000,
    end_addr: 32'h01e00000},// MagiaTileX5Y3
'{    idx: '{x: 12, y: 3, port_id: 0},
    start_addr: 32'h01c00000,
    end_addr: 32'h01d00000},// MagiaTileX4Y3
'{    idx: '{x: 11, y: 3, port_id: 0},
    start_addr: 32'h01b00000,
    end_addr: 32'h01c00000},// MagiaTileX3Y3
'{    idx: '{x: 10, y: 3, port_id: 0},
    start_addr: 32'h01a00000,
    end_addr: 32'h01b00000},// MagiaTileX2Y3
'{    idx: '{x: 9, y: 3, port_id: 0},
    start_addr: 32'h01900000,
    end_addr: 32'h01a00000},// MagiaTileX1Y3
'{    idx: '{x: 8, y: 3, port_id: 0},
    start_addr: 32'h01800000,
    end_addr: 32'h01900000},// MagiaTileX0Y3
'{    idx: '{x: 15, y: 2, port_id: 0},
    start_addr: 32'h01700000,
    end_addr: 32'h01800000},// MagiaTileX7Y2
'{    idx: '{x: 14, y: 2, port_id: 0},
    start_addr: 32'h01600000,
    end_addr: 32'h01700000},// MagiaTileX6Y2
'{    idx: '{x: 13, y: 2, port_id: 0},
    start_addr: 32'h01500000,
    end_addr: 32'h01600000},// MagiaTileX5Y2
'{    idx: '{x: 12, y: 2, port_id: 0},
    start_addr: 32'h01400000,
    end_addr: 32'h01500000},// MagiaTileX4Y2
'{    idx: '{x: 11, y: 2, port_id: 0},
    start_addr: 32'h01300000,
    end_addr: 32'h01400000},// MagiaTileX3Y2
'{    idx: '{x: 10, y: 2, port_id: 0},
    start_addr: 32'h01200000,
    end_addr: 32'h01300000},// MagiaTileX2Y2
'{    idx: '{x: 9, y: 2, port_id: 0},
    start_addr: 32'h01100000,
    end_addr: 32'h01200000},// MagiaTileX1Y2
'{    idx: '{x: 8, y: 2, port_id: 0},
    start_addr: 32'h01000000,
    end_addr: 32'h01100000},// MagiaTileX0Y2
'{    idx: '{x: 15, y: 1, port_id: 0},
    start_addr: 32'h00f00000,
    end_addr: 32'h01000000},// MagiaTileX7Y1
'{    idx: '{x: 14, y: 1, port_id: 0},
    start_addr: 32'h00e00000,
    end_addr: 32'h00f00000},// MagiaTileX6Y1
'{    idx: '{x: 13, y: 1, port_id: 0},
    start_addr: 32'h00d00000,
    end_addr: 32'h00e00000},// MagiaTileX5Y1
'{    idx: '{x: 12, y: 1, port_id: 0},
    start_addr: 32'h00c00000,
    end_addr: 32'h00d00000},// MagiaTileX4Y1
'{    idx: '{x: 11, y: 1, port_id: 0},
    start_addr: 32'h00b00000,
    end_addr: 32'h00c00000},// MagiaTileX3Y1
'{    idx: '{x: 10, y: 1, port_id: 0},
    start_addr: 32'h00a00000,
    end_addr: 32'h00b00000},// MagiaTileX2Y1
'{    idx: '{x: 9, y: 1, port_id: 0},
    start_addr: 32'h00900000,
    end_addr: 32'h00a00000},// MagiaTileX1Y1
'{    idx: '{x: 8, y: 1, port_id: 0},
    start_addr: 32'h00800000,
    end_addr: 32'h00900000},// MagiaTileX0Y1
'{    idx: '{x: 15, y: 0, port_id: 0},
    start_addr: 32'h00700000,
    end_addr: 32'h00800000},// MagiaTileX7Y0
'{    idx: '{x: 14, y: 0, port_id: 0},
    start_addr: 32'h00600000,
    end_addr: 32'h00700000},// MagiaTileX6Y0
'{    idx: '{x: 13, y: 0, port_id: 0},
    start_addr: 32'h00500000,
    end_addr: 32'h00600000},// MagiaTileX5Y0
'{    idx: '{x: 12, y: 0, port_id: 0},
    start_addr: 32'h00400000,
    end_addr: 32'h00500000},// MagiaTileX4Y0
'{    idx: '{x: 11, y: 0, port_id: 0},
    start_addr: 32'h00300000,
    end_addr: 32'h00400000},// MagiaTileX3Y0
'{    idx: '{x: 10, y: 0, port_id: 0},
    start_addr: 32'h00200000,
    end_addr: 32'h00300000},// MagiaTileX2Y0
'{    idx: '{x: 9, y: 0, port_id: 0},
    start_addr: 32'h00100000,
    end_addr: 32'h00200000},// MagiaTileX1Y0
'{    idx: '{x: 8, y: 0, port_id: 0},
    start_addr: 32'h00000000,
    end_addr: 32'h00100000} // MagiaTileX0Y0

};

    localparam int unsigned CollectiveSamNumRules = 72;

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
'{    idx: '{    id: '{x: 0, y: 7, port_id: 0},
    mask_x: '{    default: '0},
    mask_y: '{    default: '0}},
    start_addr: 32'hf8000000,
    end_addr: 32'h100000000},// L27
'{    idx: '{    id: '{x: 0, y: 6, port_id: 0},
    mask_x: '{    default: '0},
    mask_y: '{    default: '0}},
    start_addr: 32'hf0000000,
    end_addr: 32'hf8000000},// L26
'{    idx: '{    id: '{x: 0, y: 5, port_id: 0},
    mask_x: '{    default: '0},
    mask_y: '{    default: '0}},
    start_addr: 32'he8000000,
    end_addr: 32'hf0000000},// L25
'{    idx: '{    id: '{x: 0, y: 4, port_id: 0},
    mask_x: '{    default: '0},
    mask_y: '{    default: '0}},
    start_addr: 32'he0000000,
    end_addr: 32'he8000000},// L24
'{    idx: '{    id: '{x: 0, y: 3, port_id: 0},
    mask_x: '{    default: '0},
    mask_y: '{    default: '0}},
    start_addr: 32'hd8000000,
    end_addr: 32'he0000000},// L23
'{    idx: '{    id: '{x: 0, y: 2, port_id: 0},
    mask_x: '{    default: '0},
    mask_y: '{    default: '0}},
    start_addr: 32'hd0000000,
    end_addr: 32'hd8000000},// L22
'{    idx: '{    id: '{x: 0, y: 1, port_id: 0},
    mask_x: '{    default: '0},
    mask_y: '{    default: '0}},
    start_addr: 32'hc8000000,
    end_addr: 32'hd0000000},// L21
'{    idx: '{    id: '{x: 0, y: 0, port_id: 0},
    mask_x: '{    default: '0},
    mask_y: '{    default: '0}},
    start_addr: 32'hc0000000,
    end_addr: 32'hc8000000},// L20
'{    idx: '{    id: '{x: 15, y: 7, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h03f00000,
    end_addr: 32'h04000000},// MagiaTileX7Y7
'{    idx: '{    id: '{x: 14, y: 7, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h03e00000,
    end_addr: 32'h03f00000},// MagiaTileX6Y7
'{    idx: '{    id: '{x: 13, y: 7, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h03d00000,
    end_addr: 32'h03e00000},// MagiaTileX5Y7
'{    idx: '{    id: '{x: 12, y: 7, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h03c00000,
    end_addr: 32'h03d00000},// MagiaTileX4Y7
'{    idx: '{    id: '{x: 11, y: 7, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h03b00000,
    end_addr: 32'h03c00000},// MagiaTileX3Y7
'{    idx: '{    id: '{x: 10, y: 7, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h03a00000,
    end_addr: 32'h03b00000},// MagiaTileX2Y7
'{    idx: '{    id: '{x: 9, y: 7, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h03900000,
    end_addr: 32'h03a00000},// MagiaTileX1Y7
'{    idx: '{    id: '{x: 8, y: 7, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h03800000,
    end_addr: 32'h03900000},// MagiaTileX0Y7
'{    idx: '{    id: '{x: 15, y: 6, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h03700000,
    end_addr: 32'h03800000},// MagiaTileX7Y6
'{    idx: '{    id: '{x: 14, y: 6, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h03600000,
    end_addr: 32'h03700000},// MagiaTileX6Y6
'{    idx: '{    id: '{x: 13, y: 6, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h03500000,
    end_addr: 32'h03600000},// MagiaTileX5Y6
'{    idx: '{    id: '{x: 12, y: 6, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h03400000,
    end_addr: 32'h03500000},// MagiaTileX4Y6
'{    idx: '{    id: '{x: 11, y: 6, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h03300000,
    end_addr: 32'h03400000},// MagiaTileX3Y6
'{    idx: '{    id: '{x: 10, y: 6, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h03200000,
    end_addr: 32'h03300000},// MagiaTileX2Y6
'{    idx: '{    id: '{x: 9, y: 6, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h03100000,
    end_addr: 32'h03200000},// MagiaTileX1Y6
'{    idx: '{    id: '{x: 8, y: 6, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h03000000,
    end_addr: 32'h03100000},// MagiaTileX0Y6
'{    idx: '{    id: '{x: 15, y: 5, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h02f00000,
    end_addr: 32'h03000000},// MagiaTileX7Y5
'{    idx: '{    id: '{x: 14, y: 5, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h02e00000,
    end_addr: 32'h02f00000},// MagiaTileX6Y5
'{    idx: '{    id: '{x: 13, y: 5, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h02d00000,
    end_addr: 32'h02e00000},// MagiaTileX5Y5
'{    idx: '{    id: '{x: 12, y: 5, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h02c00000,
    end_addr: 32'h02d00000},// MagiaTileX4Y5
'{    idx: '{    id: '{x: 11, y: 5, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h02b00000,
    end_addr: 32'h02c00000},// MagiaTileX3Y5
'{    idx: '{    id: '{x: 10, y: 5, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h02a00000,
    end_addr: 32'h02b00000},// MagiaTileX2Y5
'{    idx: '{    id: '{x: 9, y: 5, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h02900000,
    end_addr: 32'h02a00000},// MagiaTileX1Y5
'{    idx: '{    id: '{x: 8, y: 5, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h02800000,
    end_addr: 32'h02900000},// MagiaTileX0Y5
'{    idx: '{    id: '{x: 15, y: 4, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h02700000,
    end_addr: 32'h02800000},// MagiaTileX7Y4
'{    idx: '{    id: '{x: 14, y: 4, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h02600000,
    end_addr: 32'h02700000},// MagiaTileX6Y4
'{    idx: '{    id: '{x: 13, y: 4, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h02500000,
    end_addr: 32'h02600000},// MagiaTileX5Y4
'{    idx: '{    id: '{x: 12, y: 4, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h02400000,
    end_addr: 32'h02500000},// MagiaTileX4Y4
'{    idx: '{    id: '{x: 11, y: 4, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h02300000,
    end_addr: 32'h02400000},// MagiaTileX3Y4
'{    idx: '{    id: '{x: 10, y: 4, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h02200000,
    end_addr: 32'h02300000},// MagiaTileX2Y4
'{    idx: '{    id: '{x: 9, y: 4, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h02100000,
    end_addr: 32'h02200000},// MagiaTileX1Y4
'{    idx: '{    id: '{x: 8, y: 4, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h02000000,
    end_addr: 32'h02100000},// MagiaTileX0Y4
'{    idx: '{    id: '{x: 15, y: 3, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h01f00000,
    end_addr: 32'h02000000},// MagiaTileX7Y3
'{    idx: '{    id: '{x: 14, y: 3, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h01e00000,
    end_addr: 32'h01f00000},// MagiaTileX6Y3
'{    idx: '{    id: '{x: 13, y: 3, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h01d00000,
    end_addr: 32'h01e00000},// MagiaTileX5Y3
'{    idx: '{    id: '{x: 12, y: 3, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h01c00000,
    end_addr: 32'h01d00000},// MagiaTileX4Y3
'{    idx: '{    id: '{x: 11, y: 3, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h01b00000,
    end_addr: 32'h01c00000},// MagiaTileX3Y3
'{    idx: '{    id: '{x: 10, y: 3, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h01a00000,
    end_addr: 32'h01b00000},// MagiaTileX2Y3
'{    idx: '{    id: '{x: 9, y: 3, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h01900000,
    end_addr: 32'h01a00000},// MagiaTileX1Y3
'{    idx: '{    id: '{x: 8, y: 3, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h01800000,
    end_addr: 32'h01900000},// MagiaTileX0Y3
'{    idx: '{    id: '{x: 15, y: 2, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h01700000,
    end_addr: 32'h01800000},// MagiaTileX7Y2
'{    idx: '{    id: '{x: 14, y: 2, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h01600000,
    end_addr: 32'h01700000},// MagiaTileX6Y2
'{    idx: '{    id: '{x: 13, y: 2, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h01500000,
    end_addr: 32'h01600000},// MagiaTileX5Y2
'{    idx: '{    id: '{x: 12, y: 2, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h01400000,
    end_addr: 32'h01500000},// MagiaTileX4Y2
'{    idx: '{    id: '{x: 11, y: 2, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h01300000,
    end_addr: 32'h01400000},// MagiaTileX3Y2
'{    idx: '{    id: '{x: 10, y: 2, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h01200000,
    end_addr: 32'h01300000},// MagiaTileX2Y2
'{    idx: '{    id: '{x: 9, y: 2, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h01100000,
    end_addr: 32'h01200000},// MagiaTileX1Y2
'{    idx: '{    id: '{x: 8, y: 2, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h01000000,
    end_addr: 32'h01100000},// MagiaTileX0Y2
'{    idx: '{    id: '{x: 15, y: 1, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h00f00000,
    end_addr: 32'h01000000},// MagiaTileX7Y1
'{    idx: '{    id: '{x: 14, y: 1, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h00e00000,
    end_addr: 32'h00f00000},// MagiaTileX6Y1
'{    idx: '{    id: '{x: 13, y: 1, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h00d00000,
    end_addr: 32'h00e00000},// MagiaTileX5Y1
'{    idx: '{    id: '{x: 12, y: 1, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h00c00000,
    end_addr: 32'h00d00000},// MagiaTileX4Y1
'{    idx: '{    id: '{x: 11, y: 1, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h00b00000,
    end_addr: 32'h00c00000},// MagiaTileX3Y1
'{    idx: '{    id: '{x: 10, y: 1, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h00a00000,
    end_addr: 32'h00b00000},// MagiaTileX2Y1
'{    idx: '{    id: '{x: 9, y: 1, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h00900000,
    end_addr: 32'h00a00000},// MagiaTileX1Y1
'{    idx: '{    id: '{x: 8, y: 1, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h00800000,
    end_addr: 32'h00900000},// MagiaTileX0Y1
'{    idx: '{    id: '{x: 15, y: 0, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h00700000,
    end_addr: 32'h00800000},// MagiaTileX7Y0
'{    idx: '{    id: '{x: 14, y: 0, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h00600000,
    end_addr: 32'h00700000},// MagiaTileX6Y0
'{    idx: '{    id: '{x: 13, y: 0, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h00500000,
    end_addr: 32'h00600000},// MagiaTileX5Y0
'{    idx: '{    id: '{x: 12, y: 0, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h00400000,
    end_addr: 32'h00500000},// MagiaTileX4Y0
'{    idx: '{    id: '{x: 11, y: 0, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h00300000,
    end_addr: 32'h00400000},// MagiaTileX3Y0
'{    idx: '{    id: '{x: 10, y: 0, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h00200000,
    end_addr: 32'h00300000},// MagiaTileX2Y0
'{    idx: '{    id: '{x: 9, y: 0, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h00100000,
    end_addr: 32'h00200000},// MagiaTileX1Y0
'{    idx: '{    id: '{x: 8, y: 0, port_id: 0},
    mask_x: '{    offset: 23,
    len: 3,
    base_id: 8},
    mask_y: '{    offset: 20,
    len: 3,
    base_id: 0}},
    start_addr: 32'h00000000,
    end_addr: 32'h00100000} // MagiaTileX0Y0

};



  localparam route_cfg_t RouteCfg = '{    RouteAlgo: XYRouting,
    UseIdTable: 1'b1,
    XYAddrOffsetX: 32,
    XYAddrOffsetY: 36,
    IdAddrOffset: 0,
    NumSamRules: 72,
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
