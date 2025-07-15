// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// AUTOMATICALLY GENERATED! DO NOT EDIT!

`include "axi/typedef.svh"
`include "floo_noc/typedef.svh"

package floo_axi_mesh_16x16_noc_pkg;

  import floo_pkg::*;

  /////////////////////
  //   Address Map   //
  /////////////////////

  typedef enum logic[8:0] {
    MagiaTileX0Y0 = 0,
    MagiaTileX0Y1 = 1,
    MagiaTileX0Y2 = 2,
    MagiaTileX0Y3 = 3,
    MagiaTileX0Y4 = 4,
    MagiaTileX0Y5 = 5,
    MagiaTileX0Y6 = 6,
    MagiaTileX0Y7 = 7,
    MagiaTileX0Y8 = 8,
    MagiaTileX0Y9 = 9,
    MagiaTileX0Y10 = 10,
    MagiaTileX0Y11 = 11,
    MagiaTileX0Y12 = 12,
    MagiaTileX0Y13 = 13,
    MagiaTileX0Y14 = 14,
    MagiaTileX0Y15 = 15,
    MagiaTileX1Y0 = 16,
    MagiaTileX1Y1 = 17,
    MagiaTileX1Y2 = 18,
    MagiaTileX1Y3 = 19,
    MagiaTileX1Y4 = 20,
    MagiaTileX1Y5 = 21,
    MagiaTileX1Y6 = 22,
    MagiaTileX1Y7 = 23,
    MagiaTileX1Y8 = 24,
    MagiaTileX1Y9 = 25,
    MagiaTileX1Y10 = 26,
    MagiaTileX1Y11 = 27,
    MagiaTileX1Y12 = 28,
    MagiaTileX1Y13 = 29,
    MagiaTileX1Y14 = 30,
    MagiaTileX1Y15 = 31,
    MagiaTileX2Y0 = 32,
    MagiaTileX2Y1 = 33,
    MagiaTileX2Y2 = 34,
    MagiaTileX2Y3 = 35,
    MagiaTileX2Y4 = 36,
    MagiaTileX2Y5 = 37,
    MagiaTileX2Y6 = 38,
    MagiaTileX2Y7 = 39,
    MagiaTileX2Y8 = 40,
    MagiaTileX2Y9 = 41,
    MagiaTileX2Y10 = 42,
    MagiaTileX2Y11 = 43,
    MagiaTileX2Y12 = 44,
    MagiaTileX2Y13 = 45,
    MagiaTileX2Y14 = 46,
    MagiaTileX2Y15 = 47,
    MagiaTileX3Y0 = 48,
    MagiaTileX3Y1 = 49,
    MagiaTileX3Y2 = 50,
    MagiaTileX3Y3 = 51,
    MagiaTileX3Y4 = 52,
    MagiaTileX3Y5 = 53,
    MagiaTileX3Y6 = 54,
    MagiaTileX3Y7 = 55,
    MagiaTileX3Y8 = 56,
    MagiaTileX3Y9 = 57,
    MagiaTileX3Y10 = 58,
    MagiaTileX3Y11 = 59,
    MagiaTileX3Y12 = 60,
    MagiaTileX3Y13 = 61,
    MagiaTileX3Y14 = 62,
    MagiaTileX3Y15 = 63,
    MagiaTileX4Y0 = 64,
    MagiaTileX4Y1 = 65,
    MagiaTileX4Y2 = 66,
    MagiaTileX4Y3 = 67,
    MagiaTileX4Y4 = 68,
    MagiaTileX4Y5 = 69,
    MagiaTileX4Y6 = 70,
    MagiaTileX4Y7 = 71,
    MagiaTileX4Y8 = 72,
    MagiaTileX4Y9 = 73,
    MagiaTileX4Y10 = 74,
    MagiaTileX4Y11 = 75,
    MagiaTileX4Y12 = 76,
    MagiaTileX4Y13 = 77,
    MagiaTileX4Y14 = 78,
    MagiaTileX4Y15 = 79,
    MagiaTileX5Y0 = 80,
    MagiaTileX5Y1 = 81,
    MagiaTileX5Y2 = 82,
    MagiaTileX5Y3 = 83,
    MagiaTileX5Y4 = 84,
    MagiaTileX5Y5 = 85,
    MagiaTileX5Y6 = 86,
    MagiaTileX5Y7 = 87,
    MagiaTileX5Y8 = 88,
    MagiaTileX5Y9 = 89,
    MagiaTileX5Y10 = 90,
    MagiaTileX5Y11 = 91,
    MagiaTileX5Y12 = 92,
    MagiaTileX5Y13 = 93,
    MagiaTileX5Y14 = 94,
    MagiaTileX5Y15 = 95,
    MagiaTileX6Y0 = 96,
    MagiaTileX6Y1 = 97,
    MagiaTileX6Y2 = 98,
    MagiaTileX6Y3 = 99,
    MagiaTileX6Y4 = 100,
    MagiaTileX6Y5 = 101,
    MagiaTileX6Y6 = 102,
    MagiaTileX6Y7 = 103,
    MagiaTileX6Y8 = 104,
    MagiaTileX6Y9 = 105,
    MagiaTileX6Y10 = 106,
    MagiaTileX6Y11 = 107,
    MagiaTileX6Y12 = 108,
    MagiaTileX6Y13 = 109,
    MagiaTileX6Y14 = 110,
    MagiaTileX6Y15 = 111,
    MagiaTileX7Y0 = 112,
    MagiaTileX7Y1 = 113,
    MagiaTileX7Y2 = 114,
    MagiaTileX7Y3 = 115,
    MagiaTileX7Y4 = 116,
    MagiaTileX7Y5 = 117,
    MagiaTileX7Y6 = 118,
    MagiaTileX7Y7 = 119,
    MagiaTileX7Y8 = 120,
    MagiaTileX7Y9 = 121,
    MagiaTileX7Y10 = 122,
    MagiaTileX7Y11 = 123,
    MagiaTileX7Y12 = 124,
    MagiaTileX7Y13 = 125,
    MagiaTileX7Y14 = 126,
    MagiaTileX7Y15 = 127,
    MagiaTileX8Y0 = 128,
    MagiaTileX8Y1 = 129,
    MagiaTileX8Y2 = 130,
    MagiaTileX8Y3 = 131,
    MagiaTileX8Y4 = 132,
    MagiaTileX8Y5 = 133,
    MagiaTileX8Y6 = 134,
    MagiaTileX8Y7 = 135,
    MagiaTileX8Y8 = 136,
    MagiaTileX8Y9 = 137,
    MagiaTileX8Y10 = 138,
    MagiaTileX8Y11 = 139,
    MagiaTileX8Y12 = 140,
    MagiaTileX8Y13 = 141,
    MagiaTileX8Y14 = 142,
    MagiaTileX8Y15 = 143,
    MagiaTileX9Y0 = 144,
    MagiaTileX9Y1 = 145,
    MagiaTileX9Y2 = 146,
    MagiaTileX9Y3 = 147,
    MagiaTileX9Y4 = 148,
    MagiaTileX9Y5 = 149,
    MagiaTileX9Y6 = 150,
    MagiaTileX9Y7 = 151,
    MagiaTileX9Y8 = 152,
    MagiaTileX9Y9 = 153,
    MagiaTileX9Y10 = 154,
    MagiaTileX9Y11 = 155,
    MagiaTileX9Y12 = 156,
    MagiaTileX9Y13 = 157,
    MagiaTileX9Y14 = 158,
    MagiaTileX9Y15 = 159,
    MagiaTileX10Y0 = 160,
    MagiaTileX10Y1 = 161,
    MagiaTileX10Y2 = 162,
    MagiaTileX10Y3 = 163,
    MagiaTileX10Y4 = 164,
    MagiaTileX10Y5 = 165,
    MagiaTileX10Y6 = 166,
    MagiaTileX10Y7 = 167,
    MagiaTileX10Y8 = 168,
    MagiaTileX10Y9 = 169,
    MagiaTileX10Y10 = 170,
    MagiaTileX10Y11 = 171,
    MagiaTileX10Y12 = 172,
    MagiaTileX10Y13 = 173,
    MagiaTileX10Y14 = 174,
    MagiaTileX10Y15 = 175,
    MagiaTileX11Y0 = 176,
    MagiaTileX11Y1 = 177,
    MagiaTileX11Y2 = 178,
    MagiaTileX11Y3 = 179,
    MagiaTileX11Y4 = 180,
    MagiaTileX11Y5 = 181,
    MagiaTileX11Y6 = 182,
    MagiaTileX11Y7 = 183,
    MagiaTileX11Y8 = 184,
    MagiaTileX11Y9 = 185,
    MagiaTileX11Y10 = 186,
    MagiaTileX11Y11 = 187,
    MagiaTileX11Y12 = 188,
    MagiaTileX11Y13 = 189,
    MagiaTileX11Y14 = 190,
    MagiaTileX11Y15 = 191,
    MagiaTileX12Y0 = 192,
    MagiaTileX12Y1 = 193,
    MagiaTileX12Y2 = 194,
    MagiaTileX12Y3 = 195,
    MagiaTileX12Y4 = 196,
    MagiaTileX12Y5 = 197,
    MagiaTileX12Y6 = 198,
    MagiaTileX12Y7 = 199,
    MagiaTileX12Y8 = 200,
    MagiaTileX12Y9 = 201,
    MagiaTileX12Y10 = 202,
    MagiaTileX12Y11 = 203,
    MagiaTileX12Y12 = 204,
    MagiaTileX12Y13 = 205,
    MagiaTileX12Y14 = 206,
    MagiaTileX12Y15 = 207,
    MagiaTileX13Y0 = 208,
    MagiaTileX13Y1 = 209,
    MagiaTileX13Y2 = 210,
    MagiaTileX13Y3 = 211,
    MagiaTileX13Y4 = 212,
    MagiaTileX13Y5 = 213,
    MagiaTileX13Y6 = 214,
    MagiaTileX13Y7 = 215,
    MagiaTileX13Y8 = 216,
    MagiaTileX13Y9 = 217,
    MagiaTileX13Y10 = 218,
    MagiaTileX13Y11 = 219,
    MagiaTileX13Y12 = 220,
    MagiaTileX13Y13 = 221,
    MagiaTileX13Y14 = 222,
    MagiaTileX13Y15 = 223,
    MagiaTileX14Y0 = 224,
    MagiaTileX14Y1 = 225,
    MagiaTileX14Y2 = 226,
    MagiaTileX14Y3 = 227,
    MagiaTileX14Y4 = 228,
    MagiaTileX14Y5 = 229,
    MagiaTileX14Y6 = 230,
    MagiaTileX14Y7 = 231,
    MagiaTileX14Y8 = 232,
    MagiaTileX14Y9 = 233,
    MagiaTileX14Y10 = 234,
    MagiaTileX14Y11 = 235,
    MagiaTileX14Y12 = 236,
    MagiaTileX14Y13 = 237,
    MagiaTileX14Y14 = 238,
    MagiaTileX14Y15 = 239,
    MagiaTileX15Y0 = 240,
    MagiaTileX15Y1 = 241,
    MagiaTileX15Y2 = 242,
    MagiaTileX15Y3 = 243,
    MagiaTileX15Y4 = 244,
    MagiaTileX15Y5 = 245,
    MagiaTileX15Y6 = 246,
    MagiaTileX15Y7 = 247,
    MagiaTileX15Y8 = 248,
    MagiaTileX15Y9 = 249,
    MagiaTileX15Y10 = 250,
    MagiaTileX15Y11 = 251,
    MagiaTileX15Y12 = 252,
    MagiaTileX15Y13 = 253,
    MagiaTileX15Y14 = 254,
    MagiaTileX15Y15 = 255,
    L20 = 256,
    L21 = 257,
    L22 = 258,
    L23 = 259,
    L24 = 260,
    L25 = 261,
    L26 = 262,
    L27 = 263,
    L28 = 264,
    L29 = 265,
    L210 = 266,
    L211 = 267,
    L212 = 268,
    L213 = 269,
    L214 = 270,
    L215 = 271,
    NumEndpoints = 272} ep_id_e;



  typedef logic[0:0] rob_idx_t;
typedef logic[0:0] port_id_t;
typedef logic[4:0] x_bits_t;
typedef logic[3:0] y_bits_t;
typedef struct packed {
    x_bits_t x;
    y_bits_t y;
    port_id_t port_id;
} id_t;

typedef logic route_t;


  localparam int unsigned SamNumRules = 272;

typedef struct packed {
    id_t idx;
    logic [31:0] start_addr;
    logic [31:0] end_addr;
} sam_rule_t;

localparam sam_rule_t[SamNumRules-1:0] Sam = '{
'{idx: '{x: 0, y: 15, port_id: 0}, start_addr: 32'hfc000000, end_addr: 32'h100000000},// L2_15_sam_idx
'{idx: '{x: 0, y: 14, port_id: 0}, start_addr: 32'hf8000000, end_addr: 32'hfc000000},// L2_14_sam_idx
'{idx: '{x: 0, y: 13, port_id: 0}, start_addr: 32'hf4000000, end_addr: 32'hf8000000},// L2_13_sam_idx
'{idx: '{x: 0, y: 12, port_id: 0}, start_addr: 32'hf0000000, end_addr: 32'hf4000000},// L2_12_sam_idx
'{idx: '{x: 0, y: 11, port_id: 0}, start_addr: 32'hec000000, end_addr: 32'hf0000000},// L2_11_sam_idx
'{idx: '{x: 0, y: 10, port_id: 0}, start_addr: 32'he8000000, end_addr: 32'hec000000},// L2_10_sam_idx
'{idx: '{x: 0, y: 9, port_id: 0}, start_addr: 32'he4000000, end_addr: 32'he8000000},// L2_9_sam_idx
'{idx: '{x: 0, y: 8, port_id: 0}, start_addr: 32'he0000000, end_addr: 32'he4000000},// L2_8_sam_idx
'{idx: '{x: 0, y: 7, port_id: 0}, start_addr: 32'hdc000000, end_addr: 32'he0000000},// L2_7_sam_idx
'{idx: '{x: 0, y: 6, port_id: 0}, start_addr: 32'hd8000000, end_addr: 32'hdc000000},// L2_6_sam_idx
'{idx: '{x: 0, y: 5, port_id: 0}, start_addr: 32'hd4000000, end_addr: 32'hd8000000},// L2_5_sam_idx
'{idx: '{x: 0, y: 4, port_id: 0}, start_addr: 32'hd0000000, end_addr: 32'hd4000000},// L2_4_sam_idx
'{idx: '{x: 0, y: 3, port_id: 0}, start_addr: 32'hcc000000, end_addr: 32'hd0000000},// L2_3_sam_idx
'{idx: '{x: 0, y: 2, port_id: 0}, start_addr: 32'hc8000000, end_addr: 32'hcc000000},// L2_2_sam_idx
'{idx: '{x: 0, y: 1, port_id: 0}, start_addr: 32'hc4000000, end_addr: 32'hc8000000},// L2_1_sam_idx
'{idx: '{x: 0, y: 0, port_id: 0}, start_addr: 32'hc0000000, end_addr: 32'hc4000000},// L2_0_sam_idx
'{idx: '{x: 16, y: 15, port_id: 0}, start_addr: 32'h0ff00000, end_addr: 32'h10000000},// magia_tile_x15_y15_sam_idx
'{idx: '{x: 15, y: 15, port_id: 0}, start_addr: 32'h0fe00000, end_addr: 32'h0ff00000},// magia_tile_x14_y15_sam_idx
'{idx: '{x: 14, y: 15, port_id: 0}, start_addr: 32'h0fd00000, end_addr: 32'h0fe00000},// magia_tile_x13_y15_sam_idx
'{idx: '{x: 13, y: 15, port_id: 0}, start_addr: 32'h0fc00000, end_addr: 32'h0fd00000},// magia_tile_x12_y15_sam_idx
'{idx: '{x: 12, y: 15, port_id: 0}, start_addr: 32'h0fb00000, end_addr: 32'h0fc00000},// magia_tile_x11_y15_sam_idx
'{idx: '{x: 11, y: 15, port_id: 0}, start_addr: 32'h0fa00000, end_addr: 32'h0fb00000},// magia_tile_x10_y15_sam_idx
'{idx: '{x: 10, y: 15, port_id: 0}, start_addr: 32'h0f900000, end_addr: 32'h0fa00000},// magia_tile_x9_y15_sam_idx
'{idx: '{x: 9, y: 15, port_id: 0}, start_addr: 32'h0f800000, end_addr: 32'h0f900000},// magia_tile_x8_y15_sam_idx
'{idx: '{x: 8, y: 15, port_id: 0}, start_addr: 32'h0f700000, end_addr: 32'h0f800000},// magia_tile_x7_y15_sam_idx
'{idx: '{x: 7, y: 15, port_id: 0}, start_addr: 32'h0f600000, end_addr: 32'h0f700000},// magia_tile_x6_y15_sam_idx
'{idx: '{x: 6, y: 15, port_id: 0}, start_addr: 32'h0f500000, end_addr: 32'h0f600000},// magia_tile_x5_y15_sam_idx
'{idx: '{x: 5, y: 15, port_id: 0}, start_addr: 32'h0f400000, end_addr: 32'h0f500000},// magia_tile_x4_y15_sam_idx
'{idx: '{x: 4, y: 15, port_id: 0}, start_addr: 32'h0f300000, end_addr: 32'h0f400000},// magia_tile_x3_y15_sam_idx
'{idx: '{x: 3, y: 15, port_id: 0}, start_addr: 32'h0f200000, end_addr: 32'h0f300000},// magia_tile_x2_y15_sam_idx
'{idx: '{x: 2, y: 15, port_id: 0}, start_addr: 32'h0f100000, end_addr: 32'h0f200000},// magia_tile_x1_y15_sam_idx
'{idx: '{x: 1, y: 15, port_id: 0}, start_addr: 32'h0f000000, end_addr: 32'h0f100000},// magia_tile_x0_y15_sam_idx
'{idx: '{x: 16, y: 14, port_id: 0}, start_addr: 32'h0ef00000, end_addr: 32'h0f000000},// magia_tile_x15_y14_sam_idx
'{idx: '{x: 15, y: 14, port_id: 0}, start_addr: 32'h0ee00000, end_addr: 32'h0ef00000},// magia_tile_x14_y14_sam_idx
'{idx: '{x: 14, y: 14, port_id: 0}, start_addr: 32'h0ed00000, end_addr: 32'h0ee00000},// magia_tile_x13_y14_sam_idx
'{idx: '{x: 13, y: 14, port_id: 0}, start_addr: 32'h0ec00000, end_addr: 32'h0ed00000},// magia_tile_x12_y14_sam_idx
'{idx: '{x: 12, y: 14, port_id: 0}, start_addr: 32'h0eb00000, end_addr: 32'h0ec00000},// magia_tile_x11_y14_sam_idx
'{idx: '{x: 11, y: 14, port_id: 0}, start_addr: 32'h0ea00000, end_addr: 32'h0eb00000},// magia_tile_x10_y14_sam_idx
'{idx: '{x: 10, y: 14, port_id: 0}, start_addr: 32'h0e900000, end_addr: 32'h0ea00000},// magia_tile_x9_y14_sam_idx
'{idx: '{x: 9, y: 14, port_id: 0}, start_addr: 32'h0e800000, end_addr: 32'h0e900000},// magia_tile_x8_y14_sam_idx
'{idx: '{x: 8, y: 14, port_id: 0}, start_addr: 32'h0e700000, end_addr: 32'h0e800000},// magia_tile_x7_y14_sam_idx
'{idx: '{x: 7, y: 14, port_id: 0}, start_addr: 32'h0e600000, end_addr: 32'h0e700000},// magia_tile_x6_y14_sam_idx
'{idx: '{x: 6, y: 14, port_id: 0}, start_addr: 32'h0e500000, end_addr: 32'h0e600000},// magia_tile_x5_y14_sam_idx
'{idx: '{x: 5, y: 14, port_id: 0}, start_addr: 32'h0e400000, end_addr: 32'h0e500000},// magia_tile_x4_y14_sam_idx
'{idx: '{x: 4, y: 14, port_id: 0}, start_addr: 32'h0e300000, end_addr: 32'h0e400000},// magia_tile_x3_y14_sam_idx
'{idx: '{x: 3, y: 14, port_id: 0}, start_addr: 32'h0e200000, end_addr: 32'h0e300000},// magia_tile_x2_y14_sam_idx
'{idx: '{x: 2, y: 14, port_id: 0}, start_addr: 32'h0e100000, end_addr: 32'h0e200000},// magia_tile_x1_y14_sam_idx
'{idx: '{x: 1, y: 14, port_id: 0}, start_addr: 32'h0e000000, end_addr: 32'h0e100000},// magia_tile_x0_y14_sam_idx
'{idx: '{x: 16, y: 13, port_id: 0}, start_addr: 32'h0df00000, end_addr: 32'h0e000000},// magia_tile_x15_y13_sam_idx
'{idx: '{x: 15, y: 13, port_id: 0}, start_addr: 32'h0de00000, end_addr: 32'h0df00000},// magia_tile_x14_y13_sam_idx
'{idx: '{x: 14, y: 13, port_id: 0}, start_addr: 32'h0dd00000, end_addr: 32'h0de00000},// magia_tile_x13_y13_sam_idx
'{idx: '{x: 13, y: 13, port_id: 0}, start_addr: 32'h0dc00000, end_addr: 32'h0dd00000},// magia_tile_x12_y13_sam_idx
'{idx: '{x: 12, y: 13, port_id: 0}, start_addr: 32'h0db00000, end_addr: 32'h0dc00000},// magia_tile_x11_y13_sam_idx
'{idx: '{x: 11, y: 13, port_id: 0}, start_addr: 32'h0da00000, end_addr: 32'h0db00000},// magia_tile_x10_y13_sam_idx
'{idx: '{x: 10, y: 13, port_id: 0}, start_addr: 32'h0d900000, end_addr: 32'h0da00000},// magia_tile_x9_y13_sam_idx
'{idx: '{x: 9, y: 13, port_id: 0}, start_addr: 32'h0d800000, end_addr: 32'h0d900000},// magia_tile_x8_y13_sam_idx
'{idx: '{x: 8, y: 13, port_id: 0}, start_addr: 32'h0d700000, end_addr: 32'h0d800000},// magia_tile_x7_y13_sam_idx
'{idx: '{x: 7, y: 13, port_id: 0}, start_addr: 32'h0d600000, end_addr: 32'h0d700000},// magia_tile_x6_y13_sam_idx
'{idx: '{x: 6, y: 13, port_id: 0}, start_addr: 32'h0d500000, end_addr: 32'h0d600000},// magia_tile_x5_y13_sam_idx
'{idx: '{x: 5, y: 13, port_id: 0}, start_addr: 32'h0d400000, end_addr: 32'h0d500000},// magia_tile_x4_y13_sam_idx
'{idx: '{x: 4, y: 13, port_id: 0}, start_addr: 32'h0d300000, end_addr: 32'h0d400000},// magia_tile_x3_y13_sam_idx
'{idx: '{x: 3, y: 13, port_id: 0}, start_addr: 32'h0d200000, end_addr: 32'h0d300000},// magia_tile_x2_y13_sam_idx
'{idx: '{x: 2, y: 13, port_id: 0}, start_addr: 32'h0d100000, end_addr: 32'h0d200000},// magia_tile_x1_y13_sam_idx
'{idx: '{x: 1, y: 13, port_id: 0}, start_addr: 32'h0d000000, end_addr: 32'h0d100000},// magia_tile_x0_y13_sam_idx
'{idx: '{x: 16, y: 12, port_id: 0}, start_addr: 32'h0cf00000, end_addr: 32'h0d000000},// magia_tile_x15_y12_sam_idx
'{idx: '{x: 15, y: 12, port_id: 0}, start_addr: 32'h0ce00000, end_addr: 32'h0cf00000},// magia_tile_x14_y12_sam_idx
'{idx: '{x: 14, y: 12, port_id: 0}, start_addr: 32'h0cd00000, end_addr: 32'h0ce00000},// magia_tile_x13_y12_sam_idx
'{idx: '{x: 13, y: 12, port_id: 0}, start_addr: 32'h0cc00000, end_addr: 32'h0cd00000},// magia_tile_x12_y12_sam_idx
'{idx: '{x: 12, y: 12, port_id: 0}, start_addr: 32'h0cb00000, end_addr: 32'h0cc00000},// magia_tile_x11_y12_sam_idx
'{idx: '{x: 11, y: 12, port_id: 0}, start_addr: 32'h0ca00000, end_addr: 32'h0cb00000},// magia_tile_x10_y12_sam_idx
'{idx: '{x: 10, y: 12, port_id: 0}, start_addr: 32'h0c900000, end_addr: 32'h0ca00000},// magia_tile_x9_y12_sam_idx
'{idx: '{x: 9, y: 12, port_id: 0}, start_addr: 32'h0c800000, end_addr: 32'h0c900000},// magia_tile_x8_y12_sam_idx
'{idx: '{x: 8, y: 12, port_id: 0}, start_addr: 32'h0c700000, end_addr: 32'h0c800000},// magia_tile_x7_y12_sam_idx
'{idx: '{x: 7, y: 12, port_id: 0}, start_addr: 32'h0c600000, end_addr: 32'h0c700000},// magia_tile_x6_y12_sam_idx
'{idx: '{x: 6, y: 12, port_id: 0}, start_addr: 32'h0c500000, end_addr: 32'h0c600000},// magia_tile_x5_y12_sam_idx
'{idx: '{x: 5, y: 12, port_id: 0}, start_addr: 32'h0c400000, end_addr: 32'h0c500000},// magia_tile_x4_y12_sam_idx
'{idx: '{x: 4, y: 12, port_id: 0}, start_addr: 32'h0c300000, end_addr: 32'h0c400000},// magia_tile_x3_y12_sam_idx
'{idx: '{x: 3, y: 12, port_id: 0}, start_addr: 32'h0c200000, end_addr: 32'h0c300000},// magia_tile_x2_y12_sam_idx
'{idx: '{x: 2, y: 12, port_id: 0}, start_addr: 32'h0c100000, end_addr: 32'h0c200000},// magia_tile_x1_y12_sam_idx
'{idx: '{x: 1, y: 12, port_id: 0}, start_addr: 32'h0c000000, end_addr: 32'h0c100000},// magia_tile_x0_y12_sam_idx
'{idx: '{x: 16, y: 11, port_id: 0}, start_addr: 32'h0bf00000, end_addr: 32'h0c000000},// magia_tile_x15_y11_sam_idx
'{idx: '{x: 15, y: 11, port_id: 0}, start_addr: 32'h0be00000, end_addr: 32'h0bf00000},// magia_tile_x14_y11_sam_idx
'{idx: '{x: 14, y: 11, port_id: 0}, start_addr: 32'h0bd00000, end_addr: 32'h0be00000},// magia_tile_x13_y11_sam_idx
'{idx: '{x: 13, y: 11, port_id: 0}, start_addr: 32'h0bc00000, end_addr: 32'h0bd00000},// magia_tile_x12_y11_sam_idx
'{idx: '{x: 12, y: 11, port_id: 0}, start_addr: 32'h0bb00000, end_addr: 32'h0bc00000},// magia_tile_x11_y11_sam_idx
'{idx: '{x: 11, y: 11, port_id: 0}, start_addr: 32'h0ba00000, end_addr: 32'h0bb00000},// magia_tile_x10_y11_sam_idx
'{idx: '{x: 10, y: 11, port_id: 0}, start_addr: 32'h0b900000, end_addr: 32'h0ba00000},// magia_tile_x9_y11_sam_idx
'{idx: '{x: 9, y: 11, port_id: 0}, start_addr: 32'h0b800000, end_addr: 32'h0b900000},// magia_tile_x8_y11_sam_idx
'{idx: '{x: 8, y: 11, port_id: 0}, start_addr: 32'h0b700000, end_addr: 32'h0b800000},// magia_tile_x7_y11_sam_idx
'{idx: '{x: 7, y: 11, port_id: 0}, start_addr: 32'h0b600000, end_addr: 32'h0b700000},// magia_tile_x6_y11_sam_idx
'{idx: '{x: 6, y: 11, port_id: 0}, start_addr: 32'h0b500000, end_addr: 32'h0b600000},// magia_tile_x5_y11_sam_idx
'{idx: '{x: 5, y: 11, port_id: 0}, start_addr: 32'h0b400000, end_addr: 32'h0b500000},// magia_tile_x4_y11_sam_idx
'{idx: '{x: 4, y: 11, port_id: 0}, start_addr: 32'h0b300000, end_addr: 32'h0b400000},// magia_tile_x3_y11_sam_idx
'{idx: '{x: 3, y: 11, port_id: 0}, start_addr: 32'h0b200000, end_addr: 32'h0b300000},// magia_tile_x2_y11_sam_idx
'{idx: '{x: 2, y: 11, port_id: 0}, start_addr: 32'h0b100000, end_addr: 32'h0b200000},// magia_tile_x1_y11_sam_idx
'{idx: '{x: 1, y: 11, port_id: 0}, start_addr: 32'h0b000000, end_addr: 32'h0b100000},// magia_tile_x0_y11_sam_idx
'{idx: '{x: 16, y: 10, port_id: 0}, start_addr: 32'h0af00000, end_addr: 32'h0b000000},// magia_tile_x15_y10_sam_idx
'{idx: '{x: 15, y: 10, port_id: 0}, start_addr: 32'h0ae00000, end_addr: 32'h0af00000},// magia_tile_x14_y10_sam_idx
'{idx: '{x: 14, y: 10, port_id: 0}, start_addr: 32'h0ad00000, end_addr: 32'h0ae00000},// magia_tile_x13_y10_sam_idx
'{idx: '{x: 13, y: 10, port_id: 0}, start_addr: 32'h0ac00000, end_addr: 32'h0ad00000},// magia_tile_x12_y10_sam_idx
'{idx: '{x: 12, y: 10, port_id: 0}, start_addr: 32'h0ab00000, end_addr: 32'h0ac00000},// magia_tile_x11_y10_sam_idx
'{idx: '{x: 11, y: 10, port_id: 0}, start_addr: 32'h0aa00000, end_addr: 32'h0ab00000},// magia_tile_x10_y10_sam_idx
'{idx: '{x: 10, y: 10, port_id: 0}, start_addr: 32'h0a900000, end_addr: 32'h0aa00000},// magia_tile_x9_y10_sam_idx
'{idx: '{x: 9, y: 10, port_id: 0}, start_addr: 32'h0a800000, end_addr: 32'h0a900000},// magia_tile_x8_y10_sam_idx
'{idx: '{x: 8, y: 10, port_id: 0}, start_addr: 32'h0a700000, end_addr: 32'h0a800000},// magia_tile_x7_y10_sam_idx
'{idx: '{x: 7, y: 10, port_id: 0}, start_addr: 32'h0a600000, end_addr: 32'h0a700000},// magia_tile_x6_y10_sam_idx
'{idx: '{x: 6, y: 10, port_id: 0}, start_addr: 32'h0a500000, end_addr: 32'h0a600000},// magia_tile_x5_y10_sam_idx
'{idx: '{x: 5, y: 10, port_id: 0}, start_addr: 32'h0a400000, end_addr: 32'h0a500000},// magia_tile_x4_y10_sam_idx
'{idx: '{x: 4, y: 10, port_id: 0}, start_addr: 32'h0a300000, end_addr: 32'h0a400000},// magia_tile_x3_y10_sam_idx
'{idx: '{x: 3, y: 10, port_id: 0}, start_addr: 32'h0a200000, end_addr: 32'h0a300000},// magia_tile_x2_y10_sam_idx
'{idx: '{x: 2, y: 10, port_id: 0}, start_addr: 32'h0a100000, end_addr: 32'h0a200000},// magia_tile_x1_y10_sam_idx
'{idx: '{x: 1, y: 10, port_id: 0}, start_addr: 32'h0a000000, end_addr: 32'h0a100000},// magia_tile_x0_y10_sam_idx
'{idx: '{x: 16, y: 9, port_id: 0}, start_addr: 32'h09f00000, end_addr: 32'h0a000000},// magia_tile_x15_y9_sam_idx
'{idx: '{x: 15, y: 9, port_id: 0}, start_addr: 32'h09e00000, end_addr: 32'h09f00000},// magia_tile_x14_y9_sam_idx
'{idx: '{x: 14, y: 9, port_id: 0}, start_addr: 32'h09d00000, end_addr: 32'h09e00000},// magia_tile_x13_y9_sam_idx
'{idx: '{x: 13, y: 9, port_id: 0}, start_addr: 32'h09c00000, end_addr: 32'h09d00000},// magia_tile_x12_y9_sam_idx
'{idx: '{x: 12, y: 9, port_id: 0}, start_addr: 32'h09b00000, end_addr: 32'h09c00000},// magia_tile_x11_y9_sam_idx
'{idx: '{x: 11, y: 9, port_id: 0}, start_addr: 32'h09a00000, end_addr: 32'h09b00000},// magia_tile_x10_y9_sam_idx
'{idx: '{x: 10, y: 9, port_id: 0}, start_addr: 32'h09900000, end_addr: 32'h09a00000},// magia_tile_x9_y9_sam_idx
'{idx: '{x: 9, y: 9, port_id: 0}, start_addr: 32'h09800000, end_addr: 32'h09900000},// magia_tile_x8_y9_sam_idx
'{idx: '{x: 8, y: 9, port_id: 0}, start_addr: 32'h09700000, end_addr: 32'h09800000},// magia_tile_x7_y9_sam_idx
'{idx: '{x: 7, y: 9, port_id: 0}, start_addr: 32'h09600000, end_addr: 32'h09700000},// magia_tile_x6_y9_sam_idx
'{idx: '{x: 6, y: 9, port_id: 0}, start_addr: 32'h09500000, end_addr: 32'h09600000},// magia_tile_x5_y9_sam_idx
'{idx: '{x: 5, y: 9, port_id: 0}, start_addr: 32'h09400000, end_addr: 32'h09500000},// magia_tile_x4_y9_sam_idx
'{idx: '{x: 4, y: 9, port_id: 0}, start_addr: 32'h09300000, end_addr: 32'h09400000},// magia_tile_x3_y9_sam_idx
'{idx: '{x: 3, y: 9, port_id: 0}, start_addr: 32'h09200000, end_addr: 32'h09300000},// magia_tile_x2_y9_sam_idx
'{idx: '{x: 2, y: 9, port_id: 0}, start_addr: 32'h09100000, end_addr: 32'h09200000},// magia_tile_x1_y9_sam_idx
'{idx: '{x: 1, y: 9, port_id: 0}, start_addr: 32'h09000000, end_addr: 32'h09100000},// magia_tile_x0_y9_sam_idx
'{idx: '{x: 16, y: 8, port_id: 0}, start_addr: 32'h08f00000, end_addr: 32'h09000000},// magia_tile_x15_y8_sam_idx
'{idx: '{x: 15, y: 8, port_id: 0}, start_addr: 32'h08e00000, end_addr: 32'h08f00000},// magia_tile_x14_y8_sam_idx
'{idx: '{x: 14, y: 8, port_id: 0}, start_addr: 32'h08d00000, end_addr: 32'h08e00000},// magia_tile_x13_y8_sam_idx
'{idx: '{x: 13, y: 8, port_id: 0}, start_addr: 32'h08c00000, end_addr: 32'h08d00000},// magia_tile_x12_y8_sam_idx
'{idx: '{x: 12, y: 8, port_id: 0}, start_addr: 32'h08b00000, end_addr: 32'h08c00000},// magia_tile_x11_y8_sam_idx
'{idx: '{x: 11, y: 8, port_id: 0}, start_addr: 32'h08a00000, end_addr: 32'h08b00000},// magia_tile_x10_y8_sam_idx
'{idx: '{x: 10, y: 8, port_id: 0}, start_addr: 32'h08900000, end_addr: 32'h08a00000},// magia_tile_x9_y8_sam_idx
'{idx: '{x: 9, y: 8, port_id: 0}, start_addr: 32'h08800000, end_addr: 32'h08900000},// magia_tile_x8_y8_sam_idx
'{idx: '{x: 8, y: 8, port_id: 0}, start_addr: 32'h08700000, end_addr: 32'h08800000},// magia_tile_x7_y8_sam_idx
'{idx: '{x: 7, y: 8, port_id: 0}, start_addr: 32'h08600000, end_addr: 32'h08700000},// magia_tile_x6_y8_sam_idx
'{idx: '{x: 6, y: 8, port_id: 0}, start_addr: 32'h08500000, end_addr: 32'h08600000},// magia_tile_x5_y8_sam_idx
'{idx: '{x: 5, y: 8, port_id: 0}, start_addr: 32'h08400000, end_addr: 32'h08500000},// magia_tile_x4_y8_sam_idx
'{idx: '{x: 4, y: 8, port_id: 0}, start_addr: 32'h08300000, end_addr: 32'h08400000},// magia_tile_x3_y8_sam_idx
'{idx: '{x: 3, y: 8, port_id: 0}, start_addr: 32'h08200000, end_addr: 32'h08300000},// magia_tile_x2_y8_sam_idx
'{idx: '{x: 2, y: 8, port_id: 0}, start_addr: 32'h08100000, end_addr: 32'h08200000},// magia_tile_x1_y8_sam_idx
'{idx: '{x: 1, y: 8, port_id: 0}, start_addr: 32'h08000000, end_addr: 32'h08100000},// magia_tile_x0_y8_sam_idx
'{idx: '{x: 16, y: 7, port_id: 0}, start_addr: 32'h07f00000, end_addr: 32'h08000000},// magia_tile_x15_y7_sam_idx
'{idx: '{x: 15, y: 7, port_id: 0}, start_addr: 32'h07e00000, end_addr: 32'h07f00000},// magia_tile_x14_y7_sam_idx
'{idx: '{x: 14, y: 7, port_id: 0}, start_addr: 32'h07d00000, end_addr: 32'h07e00000},// magia_tile_x13_y7_sam_idx
'{idx: '{x: 13, y: 7, port_id: 0}, start_addr: 32'h07c00000, end_addr: 32'h07d00000},// magia_tile_x12_y7_sam_idx
'{idx: '{x: 12, y: 7, port_id: 0}, start_addr: 32'h07b00000, end_addr: 32'h07c00000},// magia_tile_x11_y7_sam_idx
'{idx: '{x: 11, y: 7, port_id: 0}, start_addr: 32'h07a00000, end_addr: 32'h07b00000},// magia_tile_x10_y7_sam_idx
'{idx: '{x: 10, y: 7, port_id: 0}, start_addr: 32'h07900000, end_addr: 32'h07a00000},// magia_tile_x9_y7_sam_idx
'{idx: '{x: 9, y: 7, port_id: 0}, start_addr: 32'h07800000, end_addr: 32'h07900000},// magia_tile_x8_y7_sam_idx
'{idx: '{x: 8, y: 7, port_id: 0}, start_addr: 32'h07700000, end_addr: 32'h07800000},// magia_tile_x7_y7_sam_idx
'{idx: '{x: 7, y: 7, port_id: 0}, start_addr: 32'h07600000, end_addr: 32'h07700000},// magia_tile_x6_y7_sam_idx
'{idx: '{x: 6, y: 7, port_id: 0}, start_addr: 32'h07500000, end_addr: 32'h07600000},// magia_tile_x5_y7_sam_idx
'{idx: '{x: 5, y: 7, port_id: 0}, start_addr: 32'h07400000, end_addr: 32'h07500000},// magia_tile_x4_y7_sam_idx
'{idx: '{x: 4, y: 7, port_id: 0}, start_addr: 32'h07300000, end_addr: 32'h07400000},// magia_tile_x3_y7_sam_idx
'{idx: '{x: 3, y: 7, port_id: 0}, start_addr: 32'h07200000, end_addr: 32'h07300000},// magia_tile_x2_y7_sam_idx
'{idx: '{x: 2, y: 7, port_id: 0}, start_addr: 32'h07100000, end_addr: 32'h07200000},// magia_tile_x1_y7_sam_idx
'{idx: '{x: 1, y: 7, port_id: 0}, start_addr: 32'h07000000, end_addr: 32'h07100000},// magia_tile_x0_y7_sam_idx
'{idx: '{x: 16, y: 6, port_id: 0}, start_addr: 32'h06f00000, end_addr: 32'h07000000},// magia_tile_x15_y6_sam_idx
'{idx: '{x: 15, y: 6, port_id: 0}, start_addr: 32'h06e00000, end_addr: 32'h06f00000},// magia_tile_x14_y6_sam_idx
'{idx: '{x: 14, y: 6, port_id: 0}, start_addr: 32'h06d00000, end_addr: 32'h06e00000},// magia_tile_x13_y6_sam_idx
'{idx: '{x: 13, y: 6, port_id: 0}, start_addr: 32'h06c00000, end_addr: 32'h06d00000},// magia_tile_x12_y6_sam_idx
'{idx: '{x: 12, y: 6, port_id: 0}, start_addr: 32'h06b00000, end_addr: 32'h06c00000},// magia_tile_x11_y6_sam_idx
'{idx: '{x: 11, y: 6, port_id: 0}, start_addr: 32'h06a00000, end_addr: 32'h06b00000},// magia_tile_x10_y6_sam_idx
'{idx: '{x: 10, y: 6, port_id: 0}, start_addr: 32'h06900000, end_addr: 32'h06a00000},// magia_tile_x9_y6_sam_idx
'{idx: '{x: 9, y: 6, port_id: 0}, start_addr: 32'h06800000, end_addr: 32'h06900000},// magia_tile_x8_y6_sam_idx
'{idx: '{x: 8, y: 6, port_id: 0}, start_addr: 32'h06700000, end_addr: 32'h06800000},// magia_tile_x7_y6_sam_idx
'{idx: '{x: 7, y: 6, port_id: 0}, start_addr: 32'h06600000, end_addr: 32'h06700000},// magia_tile_x6_y6_sam_idx
'{idx: '{x: 6, y: 6, port_id: 0}, start_addr: 32'h06500000, end_addr: 32'h06600000},// magia_tile_x5_y6_sam_idx
'{idx: '{x: 5, y: 6, port_id: 0}, start_addr: 32'h06400000, end_addr: 32'h06500000},// magia_tile_x4_y6_sam_idx
'{idx: '{x: 4, y: 6, port_id: 0}, start_addr: 32'h06300000, end_addr: 32'h06400000},// magia_tile_x3_y6_sam_idx
'{idx: '{x: 3, y: 6, port_id: 0}, start_addr: 32'h06200000, end_addr: 32'h06300000},// magia_tile_x2_y6_sam_idx
'{idx: '{x: 2, y: 6, port_id: 0}, start_addr: 32'h06100000, end_addr: 32'h06200000},// magia_tile_x1_y6_sam_idx
'{idx: '{x: 1, y: 6, port_id: 0}, start_addr: 32'h06000000, end_addr: 32'h06100000},// magia_tile_x0_y6_sam_idx
'{idx: '{x: 16, y: 5, port_id: 0}, start_addr: 32'h05f00000, end_addr: 32'h06000000},// magia_tile_x15_y5_sam_idx
'{idx: '{x: 15, y: 5, port_id: 0}, start_addr: 32'h05e00000, end_addr: 32'h05f00000},// magia_tile_x14_y5_sam_idx
'{idx: '{x: 14, y: 5, port_id: 0}, start_addr: 32'h05d00000, end_addr: 32'h05e00000},// magia_tile_x13_y5_sam_idx
'{idx: '{x: 13, y: 5, port_id: 0}, start_addr: 32'h05c00000, end_addr: 32'h05d00000},// magia_tile_x12_y5_sam_idx
'{idx: '{x: 12, y: 5, port_id: 0}, start_addr: 32'h05b00000, end_addr: 32'h05c00000},// magia_tile_x11_y5_sam_idx
'{idx: '{x: 11, y: 5, port_id: 0}, start_addr: 32'h05a00000, end_addr: 32'h05b00000},// magia_tile_x10_y5_sam_idx
'{idx: '{x: 10, y: 5, port_id: 0}, start_addr: 32'h05900000, end_addr: 32'h05a00000},// magia_tile_x9_y5_sam_idx
'{idx: '{x: 9, y: 5, port_id: 0}, start_addr: 32'h05800000, end_addr: 32'h05900000},// magia_tile_x8_y5_sam_idx
'{idx: '{x: 8, y: 5, port_id: 0}, start_addr: 32'h05700000, end_addr: 32'h05800000},// magia_tile_x7_y5_sam_idx
'{idx: '{x: 7, y: 5, port_id: 0}, start_addr: 32'h05600000, end_addr: 32'h05700000},// magia_tile_x6_y5_sam_idx
'{idx: '{x: 6, y: 5, port_id: 0}, start_addr: 32'h05500000, end_addr: 32'h05600000},// magia_tile_x5_y5_sam_idx
'{idx: '{x: 5, y: 5, port_id: 0}, start_addr: 32'h05400000, end_addr: 32'h05500000},// magia_tile_x4_y5_sam_idx
'{idx: '{x: 4, y: 5, port_id: 0}, start_addr: 32'h05300000, end_addr: 32'h05400000},// magia_tile_x3_y5_sam_idx
'{idx: '{x: 3, y: 5, port_id: 0}, start_addr: 32'h05200000, end_addr: 32'h05300000},// magia_tile_x2_y5_sam_idx
'{idx: '{x: 2, y: 5, port_id: 0}, start_addr: 32'h05100000, end_addr: 32'h05200000},// magia_tile_x1_y5_sam_idx
'{idx: '{x: 1, y: 5, port_id: 0}, start_addr: 32'h05000000, end_addr: 32'h05100000},// magia_tile_x0_y5_sam_idx
'{idx: '{x: 16, y: 4, port_id: 0}, start_addr: 32'h04f00000, end_addr: 32'h05000000},// magia_tile_x15_y4_sam_idx
'{idx: '{x: 15, y: 4, port_id: 0}, start_addr: 32'h04e00000, end_addr: 32'h04f00000},// magia_tile_x14_y4_sam_idx
'{idx: '{x: 14, y: 4, port_id: 0}, start_addr: 32'h04d00000, end_addr: 32'h04e00000},// magia_tile_x13_y4_sam_idx
'{idx: '{x: 13, y: 4, port_id: 0}, start_addr: 32'h04c00000, end_addr: 32'h04d00000},// magia_tile_x12_y4_sam_idx
'{idx: '{x: 12, y: 4, port_id: 0}, start_addr: 32'h04b00000, end_addr: 32'h04c00000},// magia_tile_x11_y4_sam_idx
'{idx: '{x: 11, y: 4, port_id: 0}, start_addr: 32'h04a00000, end_addr: 32'h04b00000},// magia_tile_x10_y4_sam_idx
'{idx: '{x: 10, y: 4, port_id: 0}, start_addr: 32'h04900000, end_addr: 32'h04a00000},// magia_tile_x9_y4_sam_idx
'{idx: '{x: 9, y: 4, port_id: 0}, start_addr: 32'h04800000, end_addr: 32'h04900000},// magia_tile_x8_y4_sam_idx
'{idx: '{x: 8, y: 4, port_id: 0}, start_addr: 32'h04700000, end_addr: 32'h04800000},// magia_tile_x7_y4_sam_idx
'{idx: '{x: 7, y: 4, port_id: 0}, start_addr: 32'h04600000, end_addr: 32'h04700000},// magia_tile_x6_y4_sam_idx
'{idx: '{x: 6, y: 4, port_id: 0}, start_addr: 32'h04500000, end_addr: 32'h04600000},// magia_tile_x5_y4_sam_idx
'{idx: '{x: 5, y: 4, port_id: 0}, start_addr: 32'h04400000, end_addr: 32'h04500000},// magia_tile_x4_y4_sam_idx
'{idx: '{x: 4, y: 4, port_id: 0}, start_addr: 32'h04300000, end_addr: 32'h04400000},// magia_tile_x3_y4_sam_idx
'{idx: '{x: 3, y: 4, port_id: 0}, start_addr: 32'h04200000, end_addr: 32'h04300000},// magia_tile_x2_y4_sam_idx
'{idx: '{x: 2, y: 4, port_id: 0}, start_addr: 32'h04100000, end_addr: 32'h04200000},// magia_tile_x1_y4_sam_idx
'{idx: '{x: 1, y: 4, port_id: 0}, start_addr: 32'h04000000, end_addr: 32'h04100000},// magia_tile_x0_y4_sam_idx
'{idx: '{x: 16, y: 3, port_id: 0}, start_addr: 32'h03f00000, end_addr: 32'h04000000},// magia_tile_x15_y3_sam_idx
'{idx: '{x: 15, y: 3, port_id: 0}, start_addr: 32'h03e00000, end_addr: 32'h03f00000},// magia_tile_x14_y3_sam_idx
'{idx: '{x: 14, y: 3, port_id: 0}, start_addr: 32'h03d00000, end_addr: 32'h03e00000},// magia_tile_x13_y3_sam_idx
'{idx: '{x: 13, y: 3, port_id: 0}, start_addr: 32'h03c00000, end_addr: 32'h03d00000},// magia_tile_x12_y3_sam_idx
'{idx: '{x: 12, y: 3, port_id: 0}, start_addr: 32'h03b00000, end_addr: 32'h03c00000},// magia_tile_x11_y3_sam_idx
'{idx: '{x: 11, y: 3, port_id: 0}, start_addr: 32'h03a00000, end_addr: 32'h03b00000},// magia_tile_x10_y3_sam_idx
'{idx: '{x: 10, y: 3, port_id: 0}, start_addr: 32'h03900000, end_addr: 32'h03a00000},// magia_tile_x9_y3_sam_idx
'{idx: '{x: 9, y: 3, port_id: 0}, start_addr: 32'h03800000, end_addr: 32'h03900000},// magia_tile_x8_y3_sam_idx
'{idx: '{x: 8, y: 3, port_id: 0}, start_addr: 32'h03700000, end_addr: 32'h03800000},// magia_tile_x7_y3_sam_idx
'{idx: '{x: 7, y: 3, port_id: 0}, start_addr: 32'h03600000, end_addr: 32'h03700000},// magia_tile_x6_y3_sam_idx
'{idx: '{x: 6, y: 3, port_id: 0}, start_addr: 32'h03500000, end_addr: 32'h03600000},// magia_tile_x5_y3_sam_idx
'{idx: '{x: 5, y: 3, port_id: 0}, start_addr: 32'h03400000, end_addr: 32'h03500000},// magia_tile_x4_y3_sam_idx
'{idx: '{x: 4, y: 3, port_id: 0}, start_addr: 32'h03300000, end_addr: 32'h03400000},// magia_tile_x3_y3_sam_idx
'{idx: '{x: 3, y: 3, port_id: 0}, start_addr: 32'h03200000, end_addr: 32'h03300000},// magia_tile_x2_y3_sam_idx
'{idx: '{x: 2, y: 3, port_id: 0}, start_addr: 32'h03100000, end_addr: 32'h03200000},// magia_tile_x1_y3_sam_idx
'{idx: '{x: 1, y: 3, port_id: 0}, start_addr: 32'h03000000, end_addr: 32'h03100000},// magia_tile_x0_y3_sam_idx
'{idx: '{x: 16, y: 2, port_id: 0}, start_addr: 32'h02f00000, end_addr: 32'h03000000},// magia_tile_x15_y2_sam_idx
'{idx: '{x: 15, y: 2, port_id: 0}, start_addr: 32'h02e00000, end_addr: 32'h02f00000},// magia_tile_x14_y2_sam_idx
'{idx: '{x: 14, y: 2, port_id: 0}, start_addr: 32'h02d00000, end_addr: 32'h02e00000},// magia_tile_x13_y2_sam_idx
'{idx: '{x: 13, y: 2, port_id: 0}, start_addr: 32'h02c00000, end_addr: 32'h02d00000},// magia_tile_x12_y2_sam_idx
'{idx: '{x: 12, y: 2, port_id: 0}, start_addr: 32'h02b00000, end_addr: 32'h02c00000},// magia_tile_x11_y2_sam_idx
'{idx: '{x: 11, y: 2, port_id: 0}, start_addr: 32'h02a00000, end_addr: 32'h02b00000},// magia_tile_x10_y2_sam_idx
'{idx: '{x: 10, y: 2, port_id: 0}, start_addr: 32'h02900000, end_addr: 32'h02a00000},// magia_tile_x9_y2_sam_idx
'{idx: '{x: 9, y: 2, port_id: 0}, start_addr: 32'h02800000, end_addr: 32'h02900000},// magia_tile_x8_y2_sam_idx
'{idx: '{x: 8, y: 2, port_id: 0}, start_addr: 32'h02700000, end_addr: 32'h02800000},// magia_tile_x7_y2_sam_idx
'{idx: '{x: 7, y: 2, port_id: 0}, start_addr: 32'h02600000, end_addr: 32'h02700000},// magia_tile_x6_y2_sam_idx
'{idx: '{x: 6, y: 2, port_id: 0}, start_addr: 32'h02500000, end_addr: 32'h02600000},// magia_tile_x5_y2_sam_idx
'{idx: '{x: 5, y: 2, port_id: 0}, start_addr: 32'h02400000, end_addr: 32'h02500000},// magia_tile_x4_y2_sam_idx
'{idx: '{x: 4, y: 2, port_id: 0}, start_addr: 32'h02300000, end_addr: 32'h02400000},// magia_tile_x3_y2_sam_idx
'{idx: '{x: 3, y: 2, port_id: 0}, start_addr: 32'h02200000, end_addr: 32'h02300000},// magia_tile_x2_y2_sam_idx
'{idx: '{x: 2, y: 2, port_id: 0}, start_addr: 32'h02100000, end_addr: 32'h02200000},// magia_tile_x1_y2_sam_idx
'{idx: '{x: 1, y: 2, port_id: 0}, start_addr: 32'h02000000, end_addr: 32'h02100000},// magia_tile_x0_y2_sam_idx
'{idx: '{x: 16, y: 1, port_id: 0}, start_addr: 32'h01f00000, end_addr: 32'h02000000},// magia_tile_x15_y1_sam_idx
'{idx: '{x: 15, y: 1, port_id: 0}, start_addr: 32'h01e00000, end_addr: 32'h01f00000},// magia_tile_x14_y1_sam_idx
'{idx: '{x: 14, y: 1, port_id: 0}, start_addr: 32'h01d00000, end_addr: 32'h01e00000},// magia_tile_x13_y1_sam_idx
'{idx: '{x: 13, y: 1, port_id: 0}, start_addr: 32'h01c00000, end_addr: 32'h01d00000},// magia_tile_x12_y1_sam_idx
'{idx: '{x: 12, y: 1, port_id: 0}, start_addr: 32'h01b00000, end_addr: 32'h01c00000},// magia_tile_x11_y1_sam_idx
'{idx: '{x: 11, y: 1, port_id: 0}, start_addr: 32'h01a00000, end_addr: 32'h01b00000},// magia_tile_x10_y1_sam_idx
'{idx: '{x: 10, y: 1, port_id: 0}, start_addr: 32'h01900000, end_addr: 32'h01a00000},// magia_tile_x9_y1_sam_idx
'{idx: '{x: 9, y: 1, port_id: 0}, start_addr: 32'h01800000, end_addr: 32'h01900000},// magia_tile_x8_y1_sam_idx
'{idx: '{x: 8, y: 1, port_id: 0}, start_addr: 32'h01700000, end_addr: 32'h01800000},// magia_tile_x7_y1_sam_idx
'{idx: '{x: 7, y: 1, port_id: 0}, start_addr: 32'h01600000, end_addr: 32'h01700000},// magia_tile_x6_y1_sam_idx
'{idx: '{x: 6, y: 1, port_id: 0}, start_addr: 32'h01500000, end_addr: 32'h01600000},// magia_tile_x5_y1_sam_idx
'{idx: '{x: 5, y: 1, port_id: 0}, start_addr: 32'h01400000, end_addr: 32'h01500000},// magia_tile_x4_y1_sam_idx
'{idx: '{x: 4, y: 1, port_id: 0}, start_addr: 32'h01300000, end_addr: 32'h01400000},// magia_tile_x3_y1_sam_idx
'{idx: '{x: 3, y: 1, port_id: 0}, start_addr: 32'h01200000, end_addr: 32'h01300000},// magia_tile_x2_y1_sam_idx
'{idx: '{x: 2, y: 1, port_id: 0}, start_addr: 32'h01100000, end_addr: 32'h01200000},// magia_tile_x1_y1_sam_idx
'{idx: '{x: 1, y: 1, port_id: 0}, start_addr: 32'h01000000, end_addr: 32'h01100000},// magia_tile_x0_y1_sam_idx
'{idx: '{x: 16, y: 0, port_id: 0}, start_addr: 32'h00f00000, end_addr: 32'h01000000},// magia_tile_x15_y0_sam_idx
'{idx: '{x: 15, y: 0, port_id: 0}, start_addr: 32'h00e00000, end_addr: 32'h00f00000},// magia_tile_x14_y0_sam_idx
'{idx: '{x: 14, y: 0, port_id: 0}, start_addr: 32'h00d00000, end_addr: 32'h00e00000},// magia_tile_x13_y0_sam_idx
'{idx: '{x: 13, y: 0, port_id: 0}, start_addr: 32'h00c00000, end_addr: 32'h00d00000},// magia_tile_x12_y0_sam_idx
'{idx: '{x: 12, y: 0, port_id: 0}, start_addr: 32'h00b00000, end_addr: 32'h00c00000},// magia_tile_x11_y0_sam_idx
'{idx: '{x: 11, y: 0, port_id: 0}, start_addr: 32'h00a00000, end_addr: 32'h00b00000},// magia_tile_x10_y0_sam_idx
'{idx: '{x: 10, y: 0, port_id: 0}, start_addr: 32'h00900000, end_addr: 32'h00a00000},// magia_tile_x9_y0_sam_idx
'{idx: '{x: 9, y: 0, port_id: 0}, start_addr: 32'h00800000, end_addr: 32'h00900000},// magia_tile_x8_y0_sam_idx
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
    XYAddrOffsetY: 37,
    IdAddrOffset: 0,
    NumSamRules: 272,
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

module floo_axi_mesh_16x16_noc
  import floo_pkg::*;
  import floo_axi_mesh_16x16_noc_pkg::*;
(
  input logic clk_i,
  input logic rst_ni,
  input logic test_enable_i,
  input axi_data_slv_req_t             [15:0][15:0] magia_tile_data_slv_req_i,
  output axi_data_slv_rsp_t             [15:0][15:0] magia_tile_data_slv_rsp_o,
  output axi_data_mst_req_t             [15:0][15:0] magia_tile_data_mst_req_o,
  input axi_data_mst_rsp_t             [15:0][15:0] magia_tile_data_mst_rsp_i,
  output axi_data_mst_req_t             [15:0] L2_data_mst_req_o,
  input axi_data_mst_rsp_t             [15:0] L2_data_mst_rsp_i

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

floo_req_t router_0_7_to_router_0_8_req;
floo_rsp_t router_0_8_to_router_0_7_rsp;

floo_req_t router_0_7_to_router_1_7_req;
floo_rsp_t router_1_7_to_router_0_7_rsp;

floo_req_t router_0_7_to_magia_tile_ni_0_7_req;
floo_rsp_t magia_tile_ni_0_7_to_router_0_7_rsp;

floo_req_t router_0_7_to_L2_ni_7_req;
floo_rsp_t L2_ni_7_to_router_0_7_rsp;

floo_req_t router_0_8_to_router_0_7_req;
floo_rsp_t router_0_7_to_router_0_8_rsp;

floo_req_t router_0_8_to_router_0_9_req;
floo_rsp_t router_0_9_to_router_0_8_rsp;

floo_req_t router_0_8_to_router_1_8_req;
floo_rsp_t router_1_8_to_router_0_8_rsp;

floo_req_t router_0_8_to_magia_tile_ni_0_8_req;
floo_rsp_t magia_tile_ni_0_8_to_router_0_8_rsp;

floo_req_t router_0_8_to_L2_ni_8_req;
floo_rsp_t L2_ni_8_to_router_0_8_rsp;

floo_req_t router_0_9_to_router_0_8_req;
floo_rsp_t router_0_8_to_router_0_9_rsp;

floo_req_t router_0_9_to_router_0_10_req;
floo_rsp_t router_0_10_to_router_0_9_rsp;

floo_req_t router_0_9_to_router_1_9_req;
floo_rsp_t router_1_9_to_router_0_9_rsp;

floo_req_t router_0_9_to_magia_tile_ni_0_9_req;
floo_rsp_t magia_tile_ni_0_9_to_router_0_9_rsp;

floo_req_t router_0_9_to_L2_ni_9_req;
floo_rsp_t L2_ni_9_to_router_0_9_rsp;

floo_req_t router_0_10_to_router_0_9_req;
floo_rsp_t router_0_9_to_router_0_10_rsp;

floo_req_t router_0_10_to_router_0_11_req;
floo_rsp_t router_0_11_to_router_0_10_rsp;

floo_req_t router_0_10_to_router_1_10_req;
floo_rsp_t router_1_10_to_router_0_10_rsp;

floo_req_t router_0_10_to_magia_tile_ni_0_10_req;
floo_rsp_t magia_tile_ni_0_10_to_router_0_10_rsp;

floo_req_t router_0_10_to_L2_ni_10_req;
floo_rsp_t L2_ni_10_to_router_0_10_rsp;

floo_req_t router_0_11_to_router_0_10_req;
floo_rsp_t router_0_10_to_router_0_11_rsp;

floo_req_t router_0_11_to_router_0_12_req;
floo_rsp_t router_0_12_to_router_0_11_rsp;

floo_req_t router_0_11_to_router_1_11_req;
floo_rsp_t router_1_11_to_router_0_11_rsp;

floo_req_t router_0_11_to_magia_tile_ni_0_11_req;
floo_rsp_t magia_tile_ni_0_11_to_router_0_11_rsp;

floo_req_t router_0_11_to_L2_ni_11_req;
floo_rsp_t L2_ni_11_to_router_0_11_rsp;

floo_req_t router_0_12_to_router_0_11_req;
floo_rsp_t router_0_11_to_router_0_12_rsp;

floo_req_t router_0_12_to_router_0_13_req;
floo_rsp_t router_0_13_to_router_0_12_rsp;

floo_req_t router_0_12_to_router_1_12_req;
floo_rsp_t router_1_12_to_router_0_12_rsp;

floo_req_t router_0_12_to_magia_tile_ni_0_12_req;
floo_rsp_t magia_tile_ni_0_12_to_router_0_12_rsp;

floo_req_t router_0_12_to_L2_ni_12_req;
floo_rsp_t L2_ni_12_to_router_0_12_rsp;

floo_req_t router_0_13_to_router_0_12_req;
floo_rsp_t router_0_12_to_router_0_13_rsp;

floo_req_t router_0_13_to_router_0_14_req;
floo_rsp_t router_0_14_to_router_0_13_rsp;

floo_req_t router_0_13_to_router_1_13_req;
floo_rsp_t router_1_13_to_router_0_13_rsp;

floo_req_t router_0_13_to_magia_tile_ni_0_13_req;
floo_rsp_t magia_tile_ni_0_13_to_router_0_13_rsp;

floo_req_t router_0_13_to_L2_ni_13_req;
floo_rsp_t L2_ni_13_to_router_0_13_rsp;

floo_req_t router_0_14_to_router_0_13_req;
floo_rsp_t router_0_13_to_router_0_14_rsp;

floo_req_t router_0_14_to_router_0_15_req;
floo_rsp_t router_0_15_to_router_0_14_rsp;

floo_req_t router_0_14_to_router_1_14_req;
floo_rsp_t router_1_14_to_router_0_14_rsp;

floo_req_t router_0_14_to_magia_tile_ni_0_14_req;
floo_rsp_t magia_tile_ni_0_14_to_router_0_14_rsp;

floo_req_t router_0_14_to_L2_ni_14_req;
floo_rsp_t L2_ni_14_to_router_0_14_rsp;

floo_req_t router_0_15_to_router_0_14_req;
floo_rsp_t router_0_14_to_router_0_15_rsp;

floo_req_t router_0_15_to_router_1_15_req;
floo_rsp_t router_1_15_to_router_0_15_rsp;

floo_req_t router_0_15_to_magia_tile_ni_0_15_req;
floo_rsp_t magia_tile_ni_0_15_to_router_0_15_rsp;

floo_req_t router_0_15_to_L2_ni_15_req;
floo_rsp_t L2_ni_15_to_router_0_15_rsp;

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

floo_req_t router_1_7_to_router_1_8_req;
floo_rsp_t router_1_8_to_router_1_7_rsp;

floo_req_t router_1_7_to_router_2_7_req;
floo_rsp_t router_2_7_to_router_1_7_rsp;

floo_req_t router_1_7_to_magia_tile_ni_1_7_req;
floo_rsp_t magia_tile_ni_1_7_to_router_1_7_rsp;

floo_req_t router_1_8_to_router_0_8_req;
floo_rsp_t router_0_8_to_router_1_8_rsp;

floo_req_t router_1_8_to_router_1_7_req;
floo_rsp_t router_1_7_to_router_1_8_rsp;

floo_req_t router_1_8_to_router_1_9_req;
floo_rsp_t router_1_9_to_router_1_8_rsp;

floo_req_t router_1_8_to_router_2_8_req;
floo_rsp_t router_2_8_to_router_1_8_rsp;

floo_req_t router_1_8_to_magia_tile_ni_1_8_req;
floo_rsp_t magia_tile_ni_1_8_to_router_1_8_rsp;

floo_req_t router_1_9_to_router_0_9_req;
floo_rsp_t router_0_9_to_router_1_9_rsp;

floo_req_t router_1_9_to_router_1_8_req;
floo_rsp_t router_1_8_to_router_1_9_rsp;

floo_req_t router_1_9_to_router_1_10_req;
floo_rsp_t router_1_10_to_router_1_9_rsp;

floo_req_t router_1_9_to_router_2_9_req;
floo_rsp_t router_2_9_to_router_1_9_rsp;

floo_req_t router_1_9_to_magia_tile_ni_1_9_req;
floo_rsp_t magia_tile_ni_1_9_to_router_1_9_rsp;

floo_req_t router_1_10_to_router_0_10_req;
floo_rsp_t router_0_10_to_router_1_10_rsp;

floo_req_t router_1_10_to_router_1_9_req;
floo_rsp_t router_1_9_to_router_1_10_rsp;

floo_req_t router_1_10_to_router_1_11_req;
floo_rsp_t router_1_11_to_router_1_10_rsp;

floo_req_t router_1_10_to_router_2_10_req;
floo_rsp_t router_2_10_to_router_1_10_rsp;

floo_req_t router_1_10_to_magia_tile_ni_1_10_req;
floo_rsp_t magia_tile_ni_1_10_to_router_1_10_rsp;

floo_req_t router_1_11_to_router_0_11_req;
floo_rsp_t router_0_11_to_router_1_11_rsp;

floo_req_t router_1_11_to_router_1_10_req;
floo_rsp_t router_1_10_to_router_1_11_rsp;

floo_req_t router_1_11_to_router_1_12_req;
floo_rsp_t router_1_12_to_router_1_11_rsp;

floo_req_t router_1_11_to_router_2_11_req;
floo_rsp_t router_2_11_to_router_1_11_rsp;

floo_req_t router_1_11_to_magia_tile_ni_1_11_req;
floo_rsp_t magia_tile_ni_1_11_to_router_1_11_rsp;

floo_req_t router_1_12_to_router_0_12_req;
floo_rsp_t router_0_12_to_router_1_12_rsp;

floo_req_t router_1_12_to_router_1_11_req;
floo_rsp_t router_1_11_to_router_1_12_rsp;

floo_req_t router_1_12_to_router_1_13_req;
floo_rsp_t router_1_13_to_router_1_12_rsp;

floo_req_t router_1_12_to_router_2_12_req;
floo_rsp_t router_2_12_to_router_1_12_rsp;

floo_req_t router_1_12_to_magia_tile_ni_1_12_req;
floo_rsp_t magia_tile_ni_1_12_to_router_1_12_rsp;

floo_req_t router_1_13_to_router_0_13_req;
floo_rsp_t router_0_13_to_router_1_13_rsp;

floo_req_t router_1_13_to_router_1_12_req;
floo_rsp_t router_1_12_to_router_1_13_rsp;

floo_req_t router_1_13_to_router_1_14_req;
floo_rsp_t router_1_14_to_router_1_13_rsp;

floo_req_t router_1_13_to_router_2_13_req;
floo_rsp_t router_2_13_to_router_1_13_rsp;

floo_req_t router_1_13_to_magia_tile_ni_1_13_req;
floo_rsp_t magia_tile_ni_1_13_to_router_1_13_rsp;

floo_req_t router_1_14_to_router_0_14_req;
floo_rsp_t router_0_14_to_router_1_14_rsp;

floo_req_t router_1_14_to_router_1_13_req;
floo_rsp_t router_1_13_to_router_1_14_rsp;

floo_req_t router_1_14_to_router_1_15_req;
floo_rsp_t router_1_15_to_router_1_14_rsp;

floo_req_t router_1_14_to_router_2_14_req;
floo_rsp_t router_2_14_to_router_1_14_rsp;

floo_req_t router_1_14_to_magia_tile_ni_1_14_req;
floo_rsp_t magia_tile_ni_1_14_to_router_1_14_rsp;

floo_req_t router_1_15_to_router_0_15_req;
floo_rsp_t router_0_15_to_router_1_15_rsp;

floo_req_t router_1_15_to_router_1_14_req;
floo_rsp_t router_1_14_to_router_1_15_rsp;

floo_req_t router_1_15_to_router_2_15_req;
floo_rsp_t router_2_15_to_router_1_15_rsp;

floo_req_t router_1_15_to_magia_tile_ni_1_15_req;
floo_rsp_t magia_tile_ni_1_15_to_router_1_15_rsp;

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

floo_req_t router_2_7_to_router_2_8_req;
floo_rsp_t router_2_8_to_router_2_7_rsp;

floo_req_t router_2_7_to_router_3_7_req;
floo_rsp_t router_3_7_to_router_2_7_rsp;

floo_req_t router_2_7_to_magia_tile_ni_2_7_req;
floo_rsp_t magia_tile_ni_2_7_to_router_2_7_rsp;

floo_req_t router_2_8_to_router_1_8_req;
floo_rsp_t router_1_8_to_router_2_8_rsp;

floo_req_t router_2_8_to_router_2_7_req;
floo_rsp_t router_2_7_to_router_2_8_rsp;

floo_req_t router_2_8_to_router_2_9_req;
floo_rsp_t router_2_9_to_router_2_8_rsp;

floo_req_t router_2_8_to_router_3_8_req;
floo_rsp_t router_3_8_to_router_2_8_rsp;

floo_req_t router_2_8_to_magia_tile_ni_2_8_req;
floo_rsp_t magia_tile_ni_2_8_to_router_2_8_rsp;

floo_req_t router_2_9_to_router_1_9_req;
floo_rsp_t router_1_9_to_router_2_9_rsp;

floo_req_t router_2_9_to_router_2_8_req;
floo_rsp_t router_2_8_to_router_2_9_rsp;

floo_req_t router_2_9_to_router_2_10_req;
floo_rsp_t router_2_10_to_router_2_9_rsp;

floo_req_t router_2_9_to_router_3_9_req;
floo_rsp_t router_3_9_to_router_2_9_rsp;

floo_req_t router_2_9_to_magia_tile_ni_2_9_req;
floo_rsp_t magia_tile_ni_2_9_to_router_2_9_rsp;

floo_req_t router_2_10_to_router_1_10_req;
floo_rsp_t router_1_10_to_router_2_10_rsp;

floo_req_t router_2_10_to_router_2_9_req;
floo_rsp_t router_2_9_to_router_2_10_rsp;

floo_req_t router_2_10_to_router_2_11_req;
floo_rsp_t router_2_11_to_router_2_10_rsp;

floo_req_t router_2_10_to_router_3_10_req;
floo_rsp_t router_3_10_to_router_2_10_rsp;

floo_req_t router_2_10_to_magia_tile_ni_2_10_req;
floo_rsp_t magia_tile_ni_2_10_to_router_2_10_rsp;

floo_req_t router_2_11_to_router_1_11_req;
floo_rsp_t router_1_11_to_router_2_11_rsp;

floo_req_t router_2_11_to_router_2_10_req;
floo_rsp_t router_2_10_to_router_2_11_rsp;

floo_req_t router_2_11_to_router_2_12_req;
floo_rsp_t router_2_12_to_router_2_11_rsp;

floo_req_t router_2_11_to_router_3_11_req;
floo_rsp_t router_3_11_to_router_2_11_rsp;

floo_req_t router_2_11_to_magia_tile_ni_2_11_req;
floo_rsp_t magia_tile_ni_2_11_to_router_2_11_rsp;

floo_req_t router_2_12_to_router_1_12_req;
floo_rsp_t router_1_12_to_router_2_12_rsp;

floo_req_t router_2_12_to_router_2_11_req;
floo_rsp_t router_2_11_to_router_2_12_rsp;

floo_req_t router_2_12_to_router_2_13_req;
floo_rsp_t router_2_13_to_router_2_12_rsp;

floo_req_t router_2_12_to_router_3_12_req;
floo_rsp_t router_3_12_to_router_2_12_rsp;

floo_req_t router_2_12_to_magia_tile_ni_2_12_req;
floo_rsp_t magia_tile_ni_2_12_to_router_2_12_rsp;

floo_req_t router_2_13_to_router_1_13_req;
floo_rsp_t router_1_13_to_router_2_13_rsp;

floo_req_t router_2_13_to_router_2_12_req;
floo_rsp_t router_2_12_to_router_2_13_rsp;

floo_req_t router_2_13_to_router_2_14_req;
floo_rsp_t router_2_14_to_router_2_13_rsp;

floo_req_t router_2_13_to_router_3_13_req;
floo_rsp_t router_3_13_to_router_2_13_rsp;

floo_req_t router_2_13_to_magia_tile_ni_2_13_req;
floo_rsp_t magia_tile_ni_2_13_to_router_2_13_rsp;

floo_req_t router_2_14_to_router_1_14_req;
floo_rsp_t router_1_14_to_router_2_14_rsp;

floo_req_t router_2_14_to_router_2_13_req;
floo_rsp_t router_2_13_to_router_2_14_rsp;

floo_req_t router_2_14_to_router_2_15_req;
floo_rsp_t router_2_15_to_router_2_14_rsp;

floo_req_t router_2_14_to_router_3_14_req;
floo_rsp_t router_3_14_to_router_2_14_rsp;

floo_req_t router_2_14_to_magia_tile_ni_2_14_req;
floo_rsp_t magia_tile_ni_2_14_to_router_2_14_rsp;

floo_req_t router_2_15_to_router_1_15_req;
floo_rsp_t router_1_15_to_router_2_15_rsp;

floo_req_t router_2_15_to_router_2_14_req;
floo_rsp_t router_2_14_to_router_2_15_rsp;

floo_req_t router_2_15_to_router_3_15_req;
floo_rsp_t router_3_15_to_router_2_15_rsp;

floo_req_t router_2_15_to_magia_tile_ni_2_15_req;
floo_rsp_t magia_tile_ni_2_15_to_router_2_15_rsp;

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

floo_req_t router_3_7_to_router_3_8_req;
floo_rsp_t router_3_8_to_router_3_7_rsp;

floo_req_t router_3_7_to_router_4_7_req;
floo_rsp_t router_4_7_to_router_3_7_rsp;

floo_req_t router_3_7_to_magia_tile_ni_3_7_req;
floo_rsp_t magia_tile_ni_3_7_to_router_3_7_rsp;

floo_req_t router_3_8_to_router_2_8_req;
floo_rsp_t router_2_8_to_router_3_8_rsp;

floo_req_t router_3_8_to_router_3_7_req;
floo_rsp_t router_3_7_to_router_3_8_rsp;

floo_req_t router_3_8_to_router_3_9_req;
floo_rsp_t router_3_9_to_router_3_8_rsp;

floo_req_t router_3_8_to_router_4_8_req;
floo_rsp_t router_4_8_to_router_3_8_rsp;

floo_req_t router_3_8_to_magia_tile_ni_3_8_req;
floo_rsp_t magia_tile_ni_3_8_to_router_3_8_rsp;

floo_req_t router_3_9_to_router_2_9_req;
floo_rsp_t router_2_9_to_router_3_9_rsp;

floo_req_t router_3_9_to_router_3_8_req;
floo_rsp_t router_3_8_to_router_3_9_rsp;

floo_req_t router_3_9_to_router_3_10_req;
floo_rsp_t router_3_10_to_router_3_9_rsp;

floo_req_t router_3_9_to_router_4_9_req;
floo_rsp_t router_4_9_to_router_3_9_rsp;

floo_req_t router_3_9_to_magia_tile_ni_3_9_req;
floo_rsp_t magia_tile_ni_3_9_to_router_3_9_rsp;

floo_req_t router_3_10_to_router_2_10_req;
floo_rsp_t router_2_10_to_router_3_10_rsp;

floo_req_t router_3_10_to_router_3_9_req;
floo_rsp_t router_3_9_to_router_3_10_rsp;

floo_req_t router_3_10_to_router_3_11_req;
floo_rsp_t router_3_11_to_router_3_10_rsp;

floo_req_t router_3_10_to_router_4_10_req;
floo_rsp_t router_4_10_to_router_3_10_rsp;

floo_req_t router_3_10_to_magia_tile_ni_3_10_req;
floo_rsp_t magia_tile_ni_3_10_to_router_3_10_rsp;

floo_req_t router_3_11_to_router_2_11_req;
floo_rsp_t router_2_11_to_router_3_11_rsp;

floo_req_t router_3_11_to_router_3_10_req;
floo_rsp_t router_3_10_to_router_3_11_rsp;

floo_req_t router_3_11_to_router_3_12_req;
floo_rsp_t router_3_12_to_router_3_11_rsp;

floo_req_t router_3_11_to_router_4_11_req;
floo_rsp_t router_4_11_to_router_3_11_rsp;

floo_req_t router_3_11_to_magia_tile_ni_3_11_req;
floo_rsp_t magia_tile_ni_3_11_to_router_3_11_rsp;

floo_req_t router_3_12_to_router_2_12_req;
floo_rsp_t router_2_12_to_router_3_12_rsp;

floo_req_t router_3_12_to_router_3_11_req;
floo_rsp_t router_3_11_to_router_3_12_rsp;

floo_req_t router_3_12_to_router_3_13_req;
floo_rsp_t router_3_13_to_router_3_12_rsp;

floo_req_t router_3_12_to_router_4_12_req;
floo_rsp_t router_4_12_to_router_3_12_rsp;

floo_req_t router_3_12_to_magia_tile_ni_3_12_req;
floo_rsp_t magia_tile_ni_3_12_to_router_3_12_rsp;

floo_req_t router_3_13_to_router_2_13_req;
floo_rsp_t router_2_13_to_router_3_13_rsp;

floo_req_t router_3_13_to_router_3_12_req;
floo_rsp_t router_3_12_to_router_3_13_rsp;

floo_req_t router_3_13_to_router_3_14_req;
floo_rsp_t router_3_14_to_router_3_13_rsp;

floo_req_t router_3_13_to_router_4_13_req;
floo_rsp_t router_4_13_to_router_3_13_rsp;

floo_req_t router_3_13_to_magia_tile_ni_3_13_req;
floo_rsp_t magia_tile_ni_3_13_to_router_3_13_rsp;

floo_req_t router_3_14_to_router_2_14_req;
floo_rsp_t router_2_14_to_router_3_14_rsp;

floo_req_t router_3_14_to_router_3_13_req;
floo_rsp_t router_3_13_to_router_3_14_rsp;

floo_req_t router_3_14_to_router_3_15_req;
floo_rsp_t router_3_15_to_router_3_14_rsp;

floo_req_t router_3_14_to_router_4_14_req;
floo_rsp_t router_4_14_to_router_3_14_rsp;

floo_req_t router_3_14_to_magia_tile_ni_3_14_req;
floo_rsp_t magia_tile_ni_3_14_to_router_3_14_rsp;

floo_req_t router_3_15_to_router_2_15_req;
floo_rsp_t router_2_15_to_router_3_15_rsp;

floo_req_t router_3_15_to_router_3_14_req;
floo_rsp_t router_3_14_to_router_3_15_rsp;

floo_req_t router_3_15_to_router_4_15_req;
floo_rsp_t router_4_15_to_router_3_15_rsp;

floo_req_t router_3_15_to_magia_tile_ni_3_15_req;
floo_rsp_t magia_tile_ni_3_15_to_router_3_15_rsp;

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

floo_req_t router_4_7_to_router_4_8_req;
floo_rsp_t router_4_8_to_router_4_7_rsp;

floo_req_t router_4_7_to_router_5_7_req;
floo_rsp_t router_5_7_to_router_4_7_rsp;

floo_req_t router_4_7_to_magia_tile_ni_4_7_req;
floo_rsp_t magia_tile_ni_4_7_to_router_4_7_rsp;

floo_req_t router_4_8_to_router_3_8_req;
floo_rsp_t router_3_8_to_router_4_8_rsp;

floo_req_t router_4_8_to_router_4_7_req;
floo_rsp_t router_4_7_to_router_4_8_rsp;

floo_req_t router_4_8_to_router_4_9_req;
floo_rsp_t router_4_9_to_router_4_8_rsp;

floo_req_t router_4_8_to_router_5_8_req;
floo_rsp_t router_5_8_to_router_4_8_rsp;

floo_req_t router_4_8_to_magia_tile_ni_4_8_req;
floo_rsp_t magia_tile_ni_4_8_to_router_4_8_rsp;

floo_req_t router_4_9_to_router_3_9_req;
floo_rsp_t router_3_9_to_router_4_9_rsp;

floo_req_t router_4_9_to_router_4_8_req;
floo_rsp_t router_4_8_to_router_4_9_rsp;

floo_req_t router_4_9_to_router_4_10_req;
floo_rsp_t router_4_10_to_router_4_9_rsp;

floo_req_t router_4_9_to_router_5_9_req;
floo_rsp_t router_5_9_to_router_4_9_rsp;

floo_req_t router_4_9_to_magia_tile_ni_4_9_req;
floo_rsp_t magia_tile_ni_4_9_to_router_4_9_rsp;

floo_req_t router_4_10_to_router_3_10_req;
floo_rsp_t router_3_10_to_router_4_10_rsp;

floo_req_t router_4_10_to_router_4_9_req;
floo_rsp_t router_4_9_to_router_4_10_rsp;

floo_req_t router_4_10_to_router_4_11_req;
floo_rsp_t router_4_11_to_router_4_10_rsp;

floo_req_t router_4_10_to_router_5_10_req;
floo_rsp_t router_5_10_to_router_4_10_rsp;

floo_req_t router_4_10_to_magia_tile_ni_4_10_req;
floo_rsp_t magia_tile_ni_4_10_to_router_4_10_rsp;

floo_req_t router_4_11_to_router_3_11_req;
floo_rsp_t router_3_11_to_router_4_11_rsp;

floo_req_t router_4_11_to_router_4_10_req;
floo_rsp_t router_4_10_to_router_4_11_rsp;

floo_req_t router_4_11_to_router_4_12_req;
floo_rsp_t router_4_12_to_router_4_11_rsp;

floo_req_t router_4_11_to_router_5_11_req;
floo_rsp_t router_5_11_to_router_4_11_rsp;

floo_req_t router_4_11_to_magia_tile_ni_4_11_req;
floo_rsp_t magia_tile_ni_4_11_to_router_4_11_rsp;

floo_req_t router_4_12_to_router_3_12_req;
floo_rsp_t router_3_12_to_router_4_12_rsp;

floo_req_t router_4_12_to_router_4_11_req;
floo_rsp_t router_4_11_to_router_4_12_rsp;

floo_req_t router_4_12_to_router_4_13_req;
floo_rsp_t router_4_13_to_router_4_12_rsp;

floo_req_t router_4_12_to_router_5_12_req;
floo_rsp_t router_5_12_to_router_4_12_rsp;

floo_req_t router_4_12_to_magia_tile_ni_4_12_req;
floo_rsp_t magia_tile_ni_4_12_to_router_4_12_rsp;

floo_req_t router_4_13_to_router_3_13_req;
floo_rsp_t router_3_13_to_router_4_13_rsp;

floo_req_t router_4_13_to_router_4_12_req;
floo_rsp_t router_4_12_to_router_4_13_rsp;

floo_req_t router_4_13_to_router_4_14_req;
floo_rsp_t router_4_14_to_router_4_13_rsp;

floo_req_t router_4_13_to_router_5_13_req;
floo_rsp_t router_5_13_to_router_4_13_rsp;

floo_req_t router_4_13_to_magia_tile_ni_4_13_req;
floo_rsp_t magia_tile_ni_4_13_to_router_4_13_rsp;

floo_req_t router_4_14_to_router_3_14_req;
floo_rsp_t router_3_14_to_router_4_14_rsp;

floo_req_t router_4_14_to_router_4_13_req;
floo_rsp_t router_4_13_to_router_4_14_rsp;

floo_req_t router_4_14_to_router_4_15_req;
floo_rsp_t router_4_15_to_router_4_14_rsp;

floo_req_t router_4_14_to_router_5_14_req;
floo_rsp_t router_5_14_to_router_4_14_rsp;

floo_req_t router_4_14_to_magia_tile_ni_4_14_req;
floo_rsp_t magia_tile_ni_4_14_to_router_4_14_rsp;

floo_req_t router_4_15_to_router_3_15_req;
floo_rsp_t router_3_15_to_router_4_15_rsp;

floo_req_t router_4_15_to_router_4_14_req;
floo_rsp_t router_4_14_to_router_4_15_rsp;

floo_req_t router_4_15_to_router_5_15_req;
floo_rsp_t router_5_15_to_router_4_15_rsp;

floo_req_t router_4_15_to_magia_tile_ni_4_15_req;
floo_rsp_t magia_tile_ni_4_15_to_router_4_15_rsp;

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

floo_req_t router_5_7_to_router_5_8_req;
floo_rsp_t router_5_8_to_router_5_7_rsp;

floo_req_t router_5_7_to_router_6_7_req;
floo_rsp_t router_6_7_to_router_5_7_rsp;

floo_req_t router_5_7_to_magia_tile_ni_5_7_req;
floo_rsp_t magia_tile_ni_5_7_to_router_5_7_rsp;

floo_req_t router_5_8_to_router_4_8_req;
floo_rsp_t router_4_8_to_router_5_8_rsp;

floo_req_t router_5_8_to_router_5_7_req;
floo_rsp_t router_5_7_to_router_5_8_rsp;

floo_req_t router_5_8_to_router_5_9_req;
floo_rsp_t router_5_9_to_router_5_8_rsp;

floo_req_t router_5_8_to_router_6_8_req;
floo_rsp_t router_6_8_to_router_5_8_rsp;

floo_req_t router_5_8_to_magia_tile_ni_5_8_req;
floo_rsp_t magia_tile_ni_5_8_to_router_5_8_rsp;

floo_req_t router_5_9_to_router_4_9_req;
floo_rsp_t router_4_9_to_router_5_9_rsp;

floo_req_t router_5_9_to_router_5_8_req;
floo_rsp_t router_5_8_to_router_5_9_rsp;

floo_req_t router_5_9_to_router_5_10_req;
floo_rsp_t router_5_10_to_router_5_9_rsp;

floo_req_t router_5_9_to_router_6_9_req;
floo_rsp_t router_6_9_to_router_5_9_rsp;

floo_req_t router_5_9_to_magia_tile_ni_5_9_req;
floo_rsp_t magia_tile_ni_5_9_to_router_5_9_rsp;

floo_req_t router_5_10_to_router_4_10_req;
floo_rsp_t router_4_10_to_router_5_10_rsp;

floo_req_t router_5_10_to_router_5_9_req;
floo_rsp_t router_5_9_to_router_5_10_rsp;

floo_req_t router_5_10_to_router_5_11_req;
floo_rsp_t router_5_11_to_router_5_10_rsp;

floo_req_t router_5_10_to_router_6_10_req;
floo_rsp_t router_6_10_to_router_5_10_rsp;

floo_req_t router_5_10_to_magia_tile_ni_5_10_req;
floo_rsp_t magia_tile_ni_5_10_to_router_5_10_rsp;

floo_req_t router_5_11_to_router_4_11_req;
floo_rsp_t router_4_11_to_router_5_11_rsp;

floo_req_t router_5_11_to_router_5_10_req;
floo_rsp_t router_5_10_to_router_5_11_rsp;

floo_req_t router_5_11_to_router_5_12_req;
floo_rsp_t router_5_12_to_router_5_11_rsp;

floo_req_t router_5_11_to_router_6_11_req;
floo_rsp_t router_6_11_to_router_5_11_rsp;

floo_req_t router_5_11_to_magia_tile_ni_5_11_req;
floo_rsp_t magia_tile_ni_5_11_to_router_5_11_rsp;

floo_req_t router_5_12_to_router_4_12_req;
floo_rsp_t router_4_12_to_router_5_12_rsp;

floo_req_t router_5_12_to_router_5_11_req;
floo_rsp_t router_5_11_to_router_5_12_rsp;

floo_req_t router_5_12_to_router_5_13_req;
floo_rsp_t router_5_13_to_router_5_12_rsp;

floo_req_t router_5_12_to_router_6_12_req;
floo_rsp_t router_6_12_to_router_5_12_rsp;

floo_req_t router_5_12_to_magia_tile_ni_5_12_req;
floo_rsp_t magia_tile_ni_5_12_to_router_5_12_rsp;

floo_req_t router_5_13_to_router_4_13_req;
floo_rsp_t router_4_13_to_router_5_13_rsp;

floo_req_t router_5_13_to_router_5_12_req;
floo_rsp_t router_5_12_to_router_5_13_rsp;

floo_req_t router_5_13_to_router_5_14_req;
floo_rsp_t router_5_14_to_router_5_13_rsp;

floo_req_t router_5_13_to_router_6_13_req;
floo_rsp_t router_6_13_to_router_5_13_rsp;

floo_req_t router_5_13_to_magia_tile_ni_5_13_req;
floo_rsp_t magia_tile_ni_5_13_to_router_5_13_rsp;

floo_req_t router_5_14_to_router_4_14_req;
floo_rsp_t router_4_14_to_router_5_14_rsp;

floo_req_t router_5_14_to_router_5_13_req;
floo_rsp_t router_5_13_to_router_5_14_rsp;

floo_req_t router_5_14_to_router_5_15_req;
floo_rsp_t router_5_15_to_router_5_14_rsp;

floo_req_t router_5_14_to_router_6_14_req;
floo_rsp_t router_6_14_to_router_5_14_rsp;

floo_req_t router_5_14_to_magia_tile_ni_5_14_req;
floo_rsp_t magia_tile_ni_5_14_to_router_5_14_rsp;

floo_req_t router_5_15_to_router_4_15_req;
floo_rsp_t router_4_15_to_router_5_15_rsp;

floo_req_t router_5_15_to_router_5_14_req;
floo_rsp_t router_5_14_to_router_5_15_rsp;

floo_req_t router_5_15_to_router_6_15_req;
floo_rsp_t router_6_15_to_router_5_15_rsp;

floo_req_t router_5_15_to_magia_tile_ni_5_15_req;
floo_rsp_t magia_tile_ni_5_15_to_router_5_15_rsp;

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

floo_req_t router_6_7_to_router_6_8_req;
floo_rsp_t router_6_8_to_router_6_7_rsp;

floo_req_t router_6_7_to_router_7_7_req;
floo_rsp_t router_7_7_to_router_6_7_rsp;

floo_req_t router_6_7_to_magia_tile_ni_6_7_req;
floo_rsp_t magia_tile_ni_6_7_to_router_6_7_rsp;

floo_req_t router_6_8_to_router_5_8_req;
floo_rsp_t router_5_8_to_router_6_8_rsp;

floo_req_t router_6_8_to_router_6_7_req;
floo_rsp_t router_6_7_to_router_6_8_rsp;

floo_req_t router_6_8_to_router_6_9_req;
floo_rsp_t router_6_9_to_router_6_8_rsp;

floo_req_t router_6_8_to_router_7_8_req;
floo_rsp_t router_7_8_to_router_6_8_rsp;

floo_req_t router_6_8_to_magia_tile_ni_6_8_req;
floo_rsp_t magia_tile_ni_6_8_to_router_6_8_rsp;

floo_req_t router_6_9_to_router_5_9_req;
floo_rsp_t router_5_9_to_router_6_9_rsp;

floo_req_t router_6_9_to_router_6_8_req;
floo_rsp_t router_6_8_to_router_6_9_rsp;

floo_req_t router_6_9_to_router_6_10_req;
floo_rsp_t router_6_10_to_router_6_9_rsp;

floo_req_t router_6_9_to_router_7_9_req;
floo_rsp_t router_7_9_to_router_6_9_rsp;

floo_req_t router_6_9_to_magia_tile_ni_6_9_req;
floo_rsp_t magia_tile_ni_6_9_to_router_6_9_rsp;

floo_req_t router_6_10_to_router_5_10_req;
floo_rsp_t router_5_10_to_router_6_10_rsp;

floo_req_t router_6_10_to_router_6_9_req;
floo_rsp_t router_6_9_to_router_6_10_rsp;

floo_req_t router_6_10_to_router_6_11_req;
floo_rsp_t router_6_11_to_router_6_10_rsp;

floo_req_t router_6_10_to_router_7_10_req;
floo_rsp_t router_7_10_to_router_6_10_rsp;

floo_req_t router_6_10_to_magia_tile_ni_6_10_req;
floo_rsp_t magia_tile_ni_6_10_to_router_6_10_rsp;

floo_req_t router_6_11_to_router_5_11_req;
floo_rsp_t router_5_11_to_router_6_11_rsp;

floo_req_t router_6_11_to_router_6_10_req;
floo_rsp_t router_6_10_to_router_6_11_rsp;

floo_req_t router_6_11_to_router_6_12_req;
floo_rsp_t router_6_12_to_router_6_11_rsp;

floo_req_t router_6_11_to_router_7_11_req;
floo_rsp_t router_7_11_to_router_6_11_rsp;

floo_req_t router_6_11_to_magia_tile_ni_6_11_req;
floo_rsp_t magia_tile_ni_6_11_to_router_6_11_rsp;

floo_req_t router_6_12_to_router_5_12_req;
floo_rsp_t router_5_12_to_router_6_12_rsp;

floo_req_t router_6_12_to_router_6_11_req;
floo_rsp_t router_6_11_to_router_6_12_rsp;

floo_req_t router_6_12_to_router_6_13_req;
floo_rsp_t router_6_13_to_router_6_12_rsp;

floo_req_t router_6_12_to_router_7_12_req;
floo_rsp_t router_7_12_to_router_6_12_rsp;

floo_req_t router_6_12_to_magia_tile_ni_6_12_req;
floo_rsp_t magia_tile_ni_6_12_to_router_6_12_rsp;

floo_req_t router_6_13_to_router_5_13_req;
floo_rsp_t router_5_13_to_router_6_13_rsp;

floo_req_t router_6_13_to_router_6_12_req;
floo_rsp_t router_6_12_to_router_6_13_rsp;

floo_req_t router_6_13_to_router_6_14_req;
floo_rsp_t router_6_14_to_router_6_13_rsp;

floo_req_t router_6_13_to_router_7_13_req;
floo_rsp_t router_7_13_to_router_6_13_rsp;

floo_req_t router_6_13_to_magia_tile_ni_6_13_req;
floo_rsp_t magia_tile_ni_6_13_to_router_6_13_rsp;

floo_req_t router_6_14_to_router_5_14_req;
floo_rsp_t router_5_14_to_router_6_14_rsp;

floo_req_t router_6_14_to_router_6_13_req;
floo_rsp_t router_6_13_to_router_6_14_rsp;

floo_req_t router_6_14_to_router_6_15_req;
floo_rsp_t router_6_15_to_router_6_14_rsp;

floo_req_t router_6_14_to_router_7_14_req;
floo_rsp_t router_7_14_to_router_6_14_rsp;

floo_req_t router_6_14_to_magia_tile_ni_6_14_req;
floo_rsp_t magia_tile_ni_6_14_to_router_6_14_rsp;

floo_req_t router_6_15_to_router_5_15_req;
floo_rsp_t router_5_15_to_router_6_15_rsp;

floo_req_t router_6_15_to_router_6_14_req;
floo_rsp_t router_6_14_to_router_6_15_rsp;

floo_req_t router_6_15_to_router_7_15_req;
floo_rsp_t router_7_15_to_router_6_15_rsp;

floo_req_t router_6_15_to_magia_tile_ni_6_15_req;
floo_rsp_t magia_tile_ni_6_15_to_router_6_15_rsp;

floo_req_t router_7_0_to_router_6_0_req;
floo_rsp_t router_6_0_to_router_7_0_rsp;

floo_req_t router_7_0_to_router_7_1_req;
floo_rsp_t router_7_1_to_router_7_0_rsp;

floo_req_t router_7_0_to_router_8_0_req;
floo_rsp_t router_8_0_to_router_7_0_rsp;

floo_req_t router_7_0_to_magia_tile_ni_7_0_req;
floo_rsp_t magia_tile_ni_7_0_to_router_7_0_rsp;

floo_req_t router_7_1_to_router_6_1_req;
floo_rsp_t router_6_1_to_router_7_1_rsp;

floo_req_t router_7_1_to_router_7_0_req;
floo_rsp_t router_7_0_to_router_7_1_rsp;

floo_req_t router_7_1_to_router_7_2_req;
floo_rsp_t router_7_2_to_router_7_1_rsp;

floo_req_t router_7_1_to_router_8_1_req;
floo_rsp_t router_8_1_to_router_7_1_rsp;

floo_req_t router_7_1_to_magia_tile_ni_7_1_req;
floo_rsp_t magia_tile_ni_7_1_to_router_7_1_rsp;

floo_req_t router_7_2_to_router_6_2_req;
floo_rsp_t router_6_2_to_router_7_2_rsp;

floo_req_t router_7_2_to_router_7_1_req;
floo_rsp_t router_7_1_to_router_7_2_rsp;

floo_req_t router_7_2_to_router_7_3_req;
floo_rsp_t router_7_3_to_router_7_2_rsp;

floo_req_t router_7_2_to_router_8_2_req;
floo_rsp_t router_8_2_to_router_7_2_rsp;

floo_req_t router_7_2_to_magia_tile_ni_7_2_req;
floo_rsp_t magia_tile_ni_7_2_to_router_7_2_rsp;

floo_req_t router_7_3_to_router_6_3_req;
floo_rsp_t router_6_3_to_router_7_3_rsp;

floo_req_t router_7_3_to_router_7_2_req;
floo_rsp_t router_7_2_to_router_7_3_rsp;

floo_req_t router_7_3_to_router_7_4_req;
floo_rsp_t router_7_4_to_router_7_3_rsp;

floo_req_t router_7_3_to_router_8_3_req;
floo_rsp_t router_8_3_to_router_7_3_rsp;

floo_req_t router_7_3_to_magia_tile_ni_7_3_req;
floo_rsp_t magia_tile_ni_7_3_to_router_7_3_rsp;

floo_req_t router_7_4_to_router_6_4_req;
floo_rsp_t router_6_4_to_router_7_4_rsp;

floo_req_t router_7_4_to_router_7_3_req;
floo_rsp_t router_7_3_to_router_7_4_rsp;

floo_req_t router_7_4_to_router_7_5_req;
floo_rsp_t router_7_5_to_router_7_4_rsp;

floo_req_t router_7_4_to_router_8_4_req;
floo_rsp_t router_8_4_to_router_7_4_rsp;

floo_req_t router_7_4_to_magia_tile_ni_7_4_req;
floo_rsp_t magia_tile_ni_7_4_to_router_7_4_rsp;

floo_req_t router_7_5_to_router_6_5_req;
floo_rsp_t router_6_5_to_router_7_5_rsp;

floo_req_t router_7_5_to_router_7_4_req;
floo_rsp_t router_7_4_to_router_7_5_rsp;

floo_req_t router_7_5_to_router_7_6_req;
floo_rsp_t router_7_6_to_router_7_5_rsp;

floo_req_t router_7_5_to_router_8_5_req;
floo_rsp_t router_8_5_to_router_7_5_rsp;

floo_req_t router_7_5_to_magia_tile_ni_7_5_req;
floo_rsp_t magia_tile_ni_7_5_to_router_7_5_rsp;

floo_req_t router_7_6_to_router_6_6_req;
floo_rsp_t router_6_6_to_router_7_6_rsp;

floo_req_t router_7_6_to_router_7_5_req;
floo_rsp_t router_7_5_to_router_7_6_rsp;

floo_req_t router_7_6_to_router_7_7_req;
floo_rsp_t router_7_7_to_router_7_6_rsp;

floo_req_t router_7_6_to_router_8_6_req;
floo_rsp_t router_8_6_to_router_7_6_rsp;

floo_req_t router_7_6_to_magia_tile_ni_7_6_req;
floo_rsp_t magia_tile_ni_7_6_to_router_7_6_rsp;

floo_req_t router_7_7_to_router_6_7_req;
floo_rsp_t router_6_7_to_router_7_7_rsp;

floo_req_t router_7_7_to_router_7_6_req;
floo_rsp_t router_7_6_to_router_7_7_rsp;

floo_req_t router_7_7_to_router_7_8_req;
floo_rsp_t router_7_8_to_router_7_7_rsp;

floo_req_t router_7_7_to_router_8_7_req;
floo_rsp_t router_8_7_to_router_7_7_rsp;

floo_req_t router_7_7_to_magia_tile_ni_7_7_req;
floo_rsp_t magia_tile_ni_7_7_to_router_7_7_rsp;

floo_req_t router_7_8_to_router_6_8_req;
floo_rsp_t router_6_8_to_router_7_8_rsp;

floo_req_t router_7_8_to_router_7_7_req;
floo_rsp_t router_7_7_to_router_7_8_rsp;

floo_req_t router_7_8_to_router_7_9_req;
floo_rsp_t router_7_9_to_router_7_8_rsp;

floo_req_t router_7_8_to_router_8_8_req;
floo_rsp_t router_8_8_to_router_7_8_rsp;

floo_req_t router_7_8_to_magia_tile_ni_7_8_req;
floo_rsp_t magia_tile_ni_7_8_to_router_7_8_rsp;

floo_req_t router_7_9_to_router_6_9_req;
floo_rsp_t router_6_9_to_router_7_9_rsp;

floo_req_t router_7_9_to_router_7_8_req;
floo_rsp_t router_7_8_to_router_7_9_rsp;

floo_req_t router_7_9_to_router_7_10_req;
floo_rsp_t router_7_10_to_router_7_9_rsp;

floo_req_t router_7_9_to_router_8_9_req;
floo_rsp_t router_8_9_to_router_7_9_rsp;

floo_req_t router_7_9_to_magia_tile_ni_7_9_req;
floo_rsp_t magia_tile_ni_7_9_to_router_7_9_rsp;

floo_req_t router_7_10_to_router_6_10_req;
floo_rsp_t router_6_10_to_router_7_10_rsp;

floo_req_t router_7_10_to_router_7_9_req;
floo_rsp_t router_7_9_to_router_7_10_rsp;

floo_req_t router_7_10_to_router_7_11_req;
floo_rsp_t router_7_11_to_router_7_10_rsp;

floo_req_t router_7_10_to_router_8_10_req;
floo_rsp_t router_8_10_to_router_7_10_rsp;

floo_req_t router_7_10_to_magia_tile_ni_7_10_req;
floo_rsp_t magia_tile_ni_7_10_to_router_7_10_rsp;

floo_req_t router_7_11_to_router_6_11_req;
floo_rsp_t router_6_11_to_router_7_11_rsp;

floo_req_t router_7_11_to_router_7_10_req;
floo_rsp_t router_7_10_to_router_7_11_rsp;

floo_req_t router_7_11_to_router_7_12_req;
floo_rsp_t router_7_12_to_router_7_11_rsp;

floo_req_t router_7_11_to_router_8_11_req;
floo_rsp_t router_8_11_to_router_7_11_rsp;

floo_req_t router_7_11_to_magia_tile_ni_7_11_req;
floo_rsp_t magia_tile_ni_7_11_to_router_7_11_rsp;

floo_req_t router_7_12_to_router_6_12_req;
floo_rsp_t router_6_12_to_router_7_12_rsp;

floo_req_t router_7_12_to_router_7_11_req;
floo_rsp_t router_7_11_to_router_7_12_rsp;

floo_req_t router_7_12_to_router_7_13_req;
floo_rsp_t router_7_13_to_router_7_12_rsp;

floo_req_t router_7_12_to_router_8_12_req;
floo_rsp_t router_8_12_to_router_7_12_rsp;

floo_req_t router_7_12_to_magia_tile_ni_7_12_req;
floo_rsp_t magia_tile_ni_7_12_to_router_7_12_rsp;

floo_req_t router_7_13_to_router_6_13_req;
floo_rsp_t router_6_13_to_router_7_13_rsp;

floo_req_t router_7_13_to_router_7_12_req;
floo_rsp_t router_7_12_to_router_7_13_rsp;

floo_req_t router_7_13_to_router_7_14_req;
floo_rsp_t router_7_14_to_router_7_13_rsp;

floo_req_t router_7_13_to_router_8_13_req;
floo_rsp_t router_8_13_to_router_7_13_rsp;

floo_req_t router_7_13_to_magia_tile_ni_7_13_req;
floo_rsp_t magia_tile_ni_7_13_to_router_7_13_rsp;

floo_req_t router_7_14_to_router_6_14_req;
floo_rsp_t router_6_14_to_router_7_14_rsp;

floo_req_t router_7_14_to_router_7_13_req;
floo_rsp_t router_7_13_to_router_7_14_rsp;

floo_req_t router_7_14_to_router_7_15_req;
floo_rsp_t router_7_15_to_router_7_14_rsp;

floo_req_t router_7_14_to_router_8_14_req;
floo_rsp_t router_8_14_to_router_7_14_rsp;

floo_req_t router_7_14_to_magia_tile_ni_7_14_req;
floo_rsp_t magia_tile_ni_7_14_to_router_7_14_rsp;

floo_req_t router_7_15_to_router_6_15_req;
floo_rsp_t router_6_15_to_router_7_15_rsp;

floo_req_t router_7_15_to_router_7_14_req;
floo_rsp_t router_7_14_to_router_7_15_rsp;

floo_req_t router_7_15_to_router_8_15_req;
floo_rsp_t router_8_15_to_router_7_15_rsp;

floo_req_t router_7_15_to_magia_tile_ni_7_15_req;
floo_rsp_t magia_tile_ni_7_15_to_router_7_15_rsp;

floo_req_t router_8_0_to_router_7_0_req;
floo_rsp_t router_7_0_to_router_8_0_rsp;

floo_req_t router_8_0_to_router_8_1_req;
floo_rsp_t router_8_1_to_router_8_0_rsp;

floo_req_t router_8_0_to_router_9_0_req;
floo_rsp_t router_9_0_to_router_8_0_rsp;

floo_req_t router_8_0_to_magia_tile_ni_8_0_req;
floo_rsp_t magia_tile_ni_8_0_to_router_8_0_rsp;

floo_req_t router_8_1_to_router_7_1_req;
floo_rsp_t router_7_1_to_router_8_1_rsp;

floo_req_t router_8_1_to_router_8_0_req;
floo_rsp_t router_8_0_to_router_8_1_rsp;

floo_req_t router_8_1_to_router_8_2_req;
floo_rsp_t router_8_2_to_router_8_1_rsp;

floo_req_t router_8_1_to_router_9_1_req;
floo_rsp_t router_9_1_to_router_8_1_rsp;

floo_req_t router_8_1_to_magia_tile_ni_8_1_req;
floo_rsp_t magia_tile_ni_8_1_to_router_8_1_rsp;

floo_req_t router_8_2_to_router_7_2_req;
floo_rsp_t router_7_2_to_router_8_2_rsp;

floo_req_t router_8_2_to_router_8_1_req;
floo_rsp_t router_8_1_to_router_8_2_rsp;

floo_req_t router_8_2_to_router_8_3_req;
floo_rsp_t router_8_3_to_router_8_2_rsp;

floo_req_t router_8_2_to_router_9_2_req;
floo_rsp_t router_9_2_to_router_8_2_rsp;

floo_req_t router_8_2_to_magia_tile_ni_8_2_req;
floo_rsp_t magia_tile_ni_8_2_to_router_8_2_rsp;

floo_req_t router_8_3_to_router_7_3_req;
floo_rsp_t router_7_3_to_router_8_3_rsp;

floo_req_t router_8_3_to_router_8_2_req;
floo_rsp_t router_8_2_to_router_8_3_rsp;

floo_req_t router_8_3_to_router_8_4_req;
floo_rsp_t router_8_4_to_router_8_3_rsp;

floo_req_t router_8_3_to_router_9_3_req;
floo_rsp_t router_9_3_to_router_8_3_rsp;

floo_req_t router_8_3_to_magia_tile_ni_8_3_req;
floo_rsp_t magia_tile_ni_8_3_to_router_8_3_rsp;

floo_req_t router_8_4_to_router_7_4_req;
floo_rsp_t router_7_4_to_router_8_4_rsp;

floo_req_t router_8_4_to_router_8_3_req;
floo_rsp_t router_8_3_to_router_8_4_rsp;

floo_req_t router_8_4_to_router_8_5_req;
floo_rsp_t router_8_5_to_router_8_4_rsp;

floo_req_t router_8_4_to_router_9_4_req;
floo_rsp_t router_9_4_to_router_8_4_rsp;

floo_req_t router_8_4_to_magia_tile_ni_8_4_req;
floo_rsp_t magia_tile_ni_8_4_to_router_8_4_rsp;

floo_req_t router_8_5_to_router_7_5_req;
floo_rsp_t router_7_5_to_router_8_5_rsp;

floo_req_t router_8_5_to_router_8_4_req;
floo_rsp_t router_8_4_to_router_8_5_rsp;

floo_req_t router_8_5_to_router_8_6_req;
floo_rsp_t router_8_6_to_router_8_5_rsp;

floo_req_t router_8_5_to_router_9_5_req;
floo_rsp_t router_9_5_to_router_8_5_rsp;

floo_req_t router_8_5_to_magia_tile_ni_8_5_req;
floo_rsp_t magia_tile_ni_8_5_to_router_8_5_rsp;

floo_req_t router_8_6_to_router_7_6_req;
floo_rsp_t router_7_6_to_router_8_6_rsp;

floo_req_t router_8_6_to_router_8_5_req;
floo_rsp_t router_8_5_to_router_8_6_rsp;

floo_req_t router_8_6_to_router_8_7_req;
floo_rsp_t router_8_7_to_router_8_6_rsp;

floo_req_t router_8_6_to_router_9_6_req;
floo_rsp_t router_9_6_to_router_8_6_rsp;

floo_req_t router_8_6_to_magia_tile_ni_8_6_req;
floo_rsp_t magia_tile_ni_8_6_to_router_8_6_rsp;

floo_req_t router_8_7_to_router_7_7_req;
floo_rsp_t router_7_7_to_router_8_7_rsp;

floo_req_t router_8_7_to_router_8_6_req;
floo_rsp_t router_8_6_to_router_8_7_rsp;

floo_req_t router_8_7_to_router_8_8_req;
floo_rsp_t router_8_8_to_router_8_7_rsp;

floo_req_t router_8_7_to_router_9_7_req;
floo_rsp_t router_9_7_to_router_8_7_rsp;

floo_req_t router_8_7_to_magia_tile_ni_8_7_req;
floo_rsp_t magia_tile_ni_8_7_to_router_8_7_rsp;

floo_req_t router_8_8_to_router_7_8_req;
floo_rsp_t router_7_8_to_router_8_8_rsp;

floo_req_t router_8_8_to_router_8_7_req;
floo_rsp_t router_8_7_to_router_8_8_rsp;

floo_req_t router_8_8_to_router_8_9_req;
floo_rsp_t router_8_9_to_router_8_8_rsp;

floo_req_t router_8_8_to_router_9_8_req;
floo_rsp_t router_9_8_to_router_8_8_rsp;

floo_req_t router_8_8_to_magia_tile_ni_8_8_req;
floo_rsp_t magia_tile_ni_8_8_to_router_8_8_rsp;

floo_req_t router_8_9_to_router_7_9_req;
floo_rsp_t router_7_9_to_router_8_9_rsp;

floo_req_t router_8_9_to_router_8_8_req;
floo_rsp_t router_8_8_to_router_8_9_rsp;

floo_req_t router_8_9_to_router_8_10_req;
floo_rsp_t router_8_10_to_router_8_9_rsp;

floo_req_t router_8_9_to_router_9_9_req;
floo_rsp_t router_9_9_to_router_8_9_rsp;

floo_req_t router_8_9_to_magia_tile_ni_8_9_req;
floo_rsp_t magia_tile_ni_8_9_to_router_8_9_rsp;

floo_req_t router_8_10_to_router_7_10_req;
floo_rsp_t router_7_10_to_router_8_10_rsp;

floo_req_t router_8_10_to_router_8_9_req;
floo_rsp_t router_8_9_to_router_8_10_rsp;

floo_req_t router_8_10_to_router_8_11_req;
floo_rsp_t router_8_11_to_router_8_10_rsp;

floo_req_t router_8_10_to_router_9_10_req;
floo_rsp_t router_9_10_to_router_8_10_rsp;

floo_req_t router_8_10_to_magia_tile_ni_8_10_req;
floo_rsp_t magia_tile_ni_8_10_to_router_8_10_rsp;

floo_req_t router_8_11_to_router_7_11_req;
floo_rsp_t router_7_11_to_router_8_11_rsp;

floo_req_t router_8_11_to_router_8_10_req;
floo_rsp_t router_8_10_to_router_8_11_rsp;

floo_req_t router_8_11_to_router_8_12_req;
floo_rsp_t router_8_12_to_router_8_11_rsp;

floo_req_t router_8_11_to_router_9_11_req;
floo_rsp_t router_9_11_to_router_8_11_rsp;

floo_req_t router_8_11_to_magia_tile_ni_8_11_req;
floo_rsp_t magia_tile_ni_8_11_to_router_8_11_rsp;

floo_req_t router_8_12_to_router_7_12_req;
floo_rsp_t router_7_12_to_router_8_12_rsp;

floo_req_t router_8_12_to_router_8_11_req;
floo_rsp_t router_8_11_to_router_8_12_rsp;

floo_req_t router_8_12_to_router_8_13_req;
floo_rsp_t router_8_13_to_router_8_12_rsp;

floo_req_t router_8_12_to_router_9_12_req;
floo_rsp_t router_9_12_to_router_8_12_rsp;

floo_req_t router_8_12_to_magia_tile_ni_8_12_req;
floo_rsp_t magia_tile_ni_8_12_to_router_8_12_rsp;

floo_req_t router_8_13_to_router_7_13_req;
floo_rsp_t router_7_13_to_router_8_13_rsp;

floo_req_t router_8_13_to_router_8_12_req;
floo_rsp_t router_8_12_to_router_8_13_rsp;

floo_req_t router_8_13_to_router_8_14_req;
floo_rsp_t router_8_14_to_router_8_13_rsp;

floo_req_t router_8_13_to_router_9_13_req;
floo_rsp_t router_9_13_to_router_8_13_rsp;

floo_req_t router_8_13_to_magia_tile_ni_8_13_req;
floo_rsp_t magia_tile_ni_8_13_to_router_8_13_rsp;

floo_req_t router_8_14_to_router_7_14_req;
floo_rsp_t router_7_14_to_router_8_14_rsp;

floo_req_t router_8_14_to_router_8_13_req;
floo_rsp_t router_8_13_to_router_8_14_rsp;

floo_req_t router_8_14_to_router_8_15_req;
floo_rsp_t router_8_15_to_router_8_14_rsp;

floo_req_t router_8_14_to_router_9_14_req;
floo_rsp_t router_9_14_to_router_8_14_rsp;

floo_req_t router_8_14_to_magia_tile_ni_8_14_req;
floo_rsp_t magia_tile_ni_8_14_to_router_8_14_rsp;

floo_req_t router_8_15_to_router_7_15_req;
floo_rsp_t router_7_15_to_router_8_15_rsp;

floo_req_t router_8_15_to_router_8_14_req;
floo_rsp_t router_8_14_to_router_8_15_rsp;

floo_req_t router_8_15_to_router_9_15_req;
floo_rsp_t router_9_15_to_router_8_15_rsp;

floo_req_t router_8_15_to_magia_tile_ni_8_15_req;
floo_rsp_t magia_tile_ni_8_15_to_router_8_15_rsp;

floo_req_t router_9_0_to_router_8_0_req;
floo_rsp_t router_8_0_to_router_9_0_rsp;

floo_req_t router_9_0_to_router_9_1_req;
floo_rsp_t router_9_1_to_router_9_0_rsp;

floo_req_t router_9_0_to_router_10_0_req;
floo_rsp_t router_10_0_to_router_9_0_rsp;

floo_req_t router_9_0_to_magia_tile_ni_9_0_req;
floo_rsp_t magia_tile_ni_9_0_to_router_9_0_rsp;

floo_req_t router_9_1_to_router_8_1_req;
floo_rsp_t router_8_1_to_router_9_1_rsp;

floo_req_t router_9_1_to_router_9_0_req;
floo_rsp_t router_9_0_to_router_9_1_rsp;

floo_req_t router_9_1_to_router_9_2_req;
floo_rsp_t router_9_2_to_router_9_1_rsp;

floo_req_t router_9_1_to_router_10_1_req;
floo_rsp_t router_10_1_to_router_9_1_rsp;

floo_req_t router_9_1_to_magia_tile_ni_9_1_req;
floo_rsp_t magia_tile_ni_9_1_to_router_9_1_rsp;

floo_req_t router_9_2_to_router_8_2_req;
floo_rsp_t router_8_2_to_router_9_2_rsp;

floo_req_t router_9_2_to_router_9_1_req;
floo_rsp_t router_9_1_to_router_9_2_rsp;

floo_req_t router_9_2_to_router_9_3_req;
floo_rsp_t router_9_3_to_router_9_2_rsp;

floo_req_t router_9_2_to_router_10_2_req;
floo_rsp_t router_10_2_to_router_9_2_rsp;

floo_req_t router_9_2_to_magia_tile_ni_9_2_req;
floo_rsp_t magia_tile_ni_9_2_to_router_9_2_rsp;

floo_req_t router_9_3_to_router_8_3_req;
floo_rsp_t router_8_3_to_router_9_3_rsp;

floo_req_t router_9_3_to_router_9_2_req;
floo_rsp_t router_9_2_to_router_9_3_rsp;

floo_req_t router_9_3_to_router_9_4_req;
floo_rsp_t router_9_4_to_router_9_3_rsp;

floo_req_t router_9_3_to_router_10_3_req;
floo_rsp_t router_10_3_to_router_9_3_rsp;

floo_req_t router_9_3_to_magia_tile_ni_9_3_req;
floo_rsp_t magia_tile_ni_9_3_to_router_9_3_rsp;

floo_req_t router_9_4_to_router_8_4_req;
floo_rsp_t router_8_4_to_router_9_4_rsp;

floo_req_t router_9_4_to_router_9_3_req;
floo_rsp_t router_9_3_to_router_9_4_rsp;

floo_req_t router_9_4_to_router_9_5_req;
floo_rsp_t router_9_5_to_router_9_4_rsp;

floo_req_t router_9_4_to_router_10_4_req;
floo_rsp_t router_10_4_to_router_9_4_rsp;

floo_req_t router_9_4_to_magia_tile_ni_9_4_req;
floo_rsp_t magia_tile_ni_9_4_to_router_9_4_rsp;

floo_req_t router_9_5_to_router_8_5_req;
floo_rsp_t router_8_5_to_router_9_5_rsp;

floo_req_t router_9_5_to_router_9_4_req;
floo_rsp_t router_9_4_to_router_9_5_rsp;

floo_req_t router_9_5_to_router_9_6_req;
floo_rsp_t router_9_6_to_router_9_5_rsp;

floo_req_t router_9_5_to_router_10_5_req;
floo_rsp_t router_10_5_to_router_9_5_rsp;

floo_req_t router_9_5_to_magia_tile_ni_9_5_req;
floo_rsp_t magia_tile_ni_9_5_to_router_9_5_rsp;

floo_req_t router_9_6_to_router_8_6_req;
floo_rsp_t router_8_6_to_router_9_6_rsp;

floo_req_t router_9_6_to_router_9_5_req;
floo_rsp_t router_9_5_to_router_9_6_rsp;

floo_req_t router_9_6_to_router_9_7_req;
floo_rsp_t router_9_7_to_router_9_6_rsp;

floo_req_t router_9_6_to_router_10_6_req;
floo_rsp_t router_10_6_to_router_9_6_rsp;

floo_req_t router_9_6_to_magia_tile_ni_9_6_req;
floo_rsp_t magia_tile_ni_9_6_to_router_9_6_rsp;

floo_req_t router_9_7_to_router_8_7_req;
floo_rsp_t router_8_7_to_router_9_7_rsp;

floo_req_t router_9_7_to_router_9_6_req;
floo_rsp_t router_9_6_to_router_9_7_rsp;

floo_req_t router_9_7_to_router_9_8_req;
floo_rsp_t router_9_8_to_router_9_7_rsp;

floo_req_t router_9_7_to_router_10_7_req;
floo_rsp_t router_10_7_to_router_9_7_rsp;

floo_req_t router_9_7_to_magia_tile_ni_9_7_req;
floo_rsp_t magia_tile_ni_9_7_to_router_9_7_rsp;

floo_req_t router_9_8_to_router_8_8_req;
floo_rsp_t router_8_8_to_router_9_8_rsp;

floo_req_t router_9_8_to_router_9_7_req;
floo_rsp_t router_9_7_to_router_9_8_rsp;

floo_req_t router_9_8_to_router_9_9_req;
floo_rsp_t router_9_9_to_router_9_8_rsp;

floo_req_t router_9_8_to_router_10_8_req;
floo_rsp_t router_10_8_to_router_9_8_rsp;

floo_req_t router_9_8_to_magia_tile_ni_9_8_req;
floo_rsp_t magia_tile_ni_9_8_to_router_9_8_rsp;

floo_req_t router_9_9_to_router_8_9_req;
floo_rsp_t router_8_9_to_router_9_9_rsp;

floo_req_t router_9_9_to_router_9_8_req;
floo_rsp_t router_9_8_to_router_9_9_rsp;

floo_req_t router_9_9_to_router_9_10_req;
floo_rsp_t router_9_10_to_router_9_9_rsp;

floo_req_t router_9_9_to_router_10_9_req;
floo_rsp_t router_10_9_to_router_9_9_rsp;

floo_req_t router_9_9_to_magia_tile_ni_9_9_req;
floo_rsp_t magia_tile_ni_9_9_to_router_9_9_rsp;

floo_req_t router_9_10_to_router_8_10_req;
floo_rsp_t router_8_10_to_router_9_10_rsp;

floo_req_t router_9_10_to_router_9_9_req;
floo_rsp_t router_9_9_to_router_9_10_rsp;

floo_req_t router_9_10_to_router_9_11_req;
floo_rsp_t router_9_11_to_router_9_10_rsp;

floo_req_t router_9_10_to_router_10_10_req;
floo_rsp_t router_10_10_to_router_9_10_rsp;

floo_req_t router_9_10_to_magia_tile_ni_9_10_req;
floo_rsp_t magia_tile_ni_9_10_to_router_9_10_rsp;

floo_req_t router_9_11_to_router_8_11_req;
floo_rsp_t router_8_11_to_router_9_11_rsp;

floo_req_t router_9_11_to_router_9_10_req;
floo_rsp_t router_9_10_to_router_9_11_rsp;

floo_req_t router_9_11_to_router_9_12_req;
floo_rsp_t router_9_12_to_router_9_11_rsp;

floo_req_t router_9_11_to_router_10_11_req;
floo_rsp_t router_10_11_to_router_9_11_rsp;

floo_req_t router_9_11_to_magia_tile_ni_9_11_req;
floo_rsp_t magia_tile_ni_9_11_to_router_9_11_rsp;

floo_req_t router_9_12_to_router_8_12_req;
floo_rsp_t router_8_12_to_router_9_12_rsp;

floo_req_t router_9_12_to_router_9_11_req;
floo_rsp_t router_9_11_to_router_9_12_rsp;

floo_req_t router_9_12_to_router_9_13_req;
floo_rsp_t router_9_13_to_router_9_12_rsp;

floo_req_t router_9_12_to_router_10_12_req;
floo_rsp_t router_10_12_to_router_9_12_rsp;

floo_req_t router_9_12_to_magia_tile_ni_9_12_req;
floo_rsp_t magia_tile_ni_9_12_to_router_9_12_rsp;

floo_req_t router_9_13_to_router_8_13_req;
floo_rsp_t router_8_13_to_router_9_13_rsp;

floo_req_t router_9_13_to_router_9_12_req;
floo_rsp_t router_9_12_to_router_9_13_rsp;

floo_req_t router_9_13_to_router_9_14_req;
floo_rsp_t router_9_14_to_router_9_13_rsp;

floo_req_t router_9_13_to_router_10_13_req;
floo_rsp_t router_10_13_to_router_9_13_rsp;

floo_req_t router_9_13_to_magia_tile_ni_9_13_req;
floo_rsp_t magia_tile_ni_9_13_to_router_9_13_rsp;

floo_req_t router_9_14_to_router_8_14_req;
floo_rsp_t router_8_14_to_router_9_14_rsp;

floo_req_t router_9_14_to_router_9_13_req;
floo_rsp_t router_9_13_to_router_9_14_rsp;

floo_req_t router_9_14_to_router_9_15_req;
floo_rsp_t router_9_15_to_router_9_14_rsp;

floo_req_t router_9_14_to_router_10_14_req;
floo_rsp_t router_10_14_to_router_9_14_rsp;

floo_req_t router_9_14_to_magia_tile_ni_9_14_req;
floo_rsp_t magia_tile_ni_9_14_to_router_9_14_rsp;

floo_req_t router_9_15_to_router_8_15_req;
floo_rsp_t router_8_15_to_router_9_15_rsp;

floo_req_t router_9_15_to_router_9_14_req;
floo_rsp_t router_9_14_to_router_9_15_rsp;

floo_req_t router_9_15_to_router_10_15_req;
floo_rsp_t router_10_15_to_router_9_15_rsp;

floo_req_t router_9_15_to_magia_tile_ni_9_15_req;
floo_rsp_t magia_tile_ni_9_15_to_router_9_15_rsp;

floo_req_t router_10_0_to_router_9_0_req;
floo_rsp_t router_9_0_to_router_10_0_rsp;

floo_req_t router_10_0_to_router_10_1_req;
floo_rsp_t router_10_1_to_router_10_0_rsp;

floo_req_t router_10_0_to_router_11_0_req;
floo_rsp_t router_11_0_to_router_10_0_rsp;

floo_req_t router_10_0_to_magia_tile_ni_10_0_req;
floo_rsp_t magia_tile_ni_10_0_to_router_10_0_rsp;

floo_req_t router_10_1_to_router_9_1_req;
floo_rsp_t router_9_1_to_router_10_1_rsp;

floo_req_t router_10_1_to_router_10_0_req;
floo_rsp_t router_10_0_to_router_10_1_rsp;

floo_req_t router_10_1_to_router_10_2_req;
floo_rsp_t router_10_2_to_router_10_1_rsp;

floo_req_t router_10_1_to_router_11_1_req;
floo_rsp_t router_11_1_to_router_10_1_rsp;

floo_req_t router_10_1_to_magia_tile_ni_10_1_req;
floo_rsp_t magia_tile_ni_10_1_to_router_10_1_rsp;

floo_req_t router_10_2_to_router_9_2_req;
floo_rsp_t router_9_2_to_router_10_2_rsp;

floo_req_t router_10_2_to_router_10_1_req;
floo_rsp_t router_10_1_to_router_10_2_rsp;

floo_req_t router_10_2_to_router_10_3_req;
floo_rsp_t router_10_3_to_router_10_2_rsp;

floo_req_t router_10_2_to_router_11_2_req;
floo_rsp_t router_11_2_to_router_10_2_rsp;

floo_req_t router_10_2_to_magia_tile_ni_10_2_req;
floo_rsp_t magia_tile_ni_10_2_to_router_10_2_rsp;

floo_req_t router_10_3_to_router_9_3_req;
floo_rsp_t router_9_3_to_router_10_3_rsp;

floo_req_t router_10_3_to_router_10_2_req;
floo_rsp_t router_10_2_to_router_10_3_rsp;

floo_req_t router_10_3_to_router_10_4_req;
floo_rsp_t router_10_4_to_router_10_3_rsp;

floo_req_t router_10_3_to_router_11_3_req;
floo_rsp_t router_11_3_to_router_10_3_rsp;

floo_req_t router_10_3_to_magia_tile_ni_10_3_req;
floo_rsp_t magia_tile_ni_10_3_to_router_10_3_rsp;

floo_req_t router_10_4_to_router_9_4_req;
floo_rsp_t router_9_4_to_router_10_4_rsp;

floo_req_t router_10_4_to_router_10_3_req;
floo_rsp_t router_10_3_to_router_10_4_rsp;

floo_req_t router_10_4_to_router_10_5_req;
floo_rsp_t router_10_5_to_router_10_4_rsp;

floo_req_t router_10_4_to_router_11_4_req;
floo_rsp_t router_11_4_to_router_10_4_rsp;

floo_req_t router_10_4_to_magia_tile_ni_10_4_req;
floo_rsp_t magia_tile_ni_10_4_to_router_10_4_rsp;

floo_req_t router_10_5_to_router_9_5_req;
floo_rsp_t router_9_5_to_router_10_5_rsp;

floo_req_t router_10_5_to_router_10_4_req;
floo_rsp_t router_10_4_to_router_10_5_rsp;

floo_req_t router_10_5_to_router_10_6_req;
floo_rsp_t router_10_6_to_router_10_5_rsp;

floo_req_t router_10_5_to_router_11_5_req;
floo_rsp_t router_11_5_to_router_10_5_rsp;

floo_req_t router_10_5_to_magia_tile_ni_10_5_req;
floo_rsp_t magia_tile_ni_10_5_to_router_10_5_rsp;

floo_req_t router_10_6_to_router_9_6_req;
floo_rsp_t router_9_6_to_router_10_6_rsp;

floo_req_t router_10_6_to_router_10_5_req;
floo_rsp_t router_10_5_to_router_10_6_rsp;

floo_req_t router_10_6_to_router_10_7_req;
floo_rsp_t router_10_7_to_router_10_6_rsp;

floo_req_t router_10_6_to_router_11_6_req;
floo_rsp_t router_11_6_to_router_10_6_rsp;

floo_req_t router_10_6_to_magia_tile_ni_10_6_req;
floo_rsp_t magia_tile_ni_10_6_to_router_10_6_rsp;

floo_req_t router_10_7_to_router_9_7_req;
floo_rsp_t router_9_7_to_router_10_7_rsp;

floo_req_t router_10_7_to_router_10_6_req;
floo_rsp_t router_10_6_to_router_10_7_rsp;

floo_req_t router_10_7_to_router_10_8_req;
floo_rsp_t router_10_8_to_router_10_7_rsp;

floo_req_t router_10_7_to_router_11_7_req;
floo_rsp_t router_11_7_to_router_10_7_rsp;

floo_req_t router_10_7_to_magia_tile_ni_10_7_req;
floo_rsp_t magia_tile_ni_10_7_to_router_10_7_rsp;

floo_req_t router_10_8_to_router_9_8_req;
floo_rsp_t router_9_8_to_router_10_8_rsp;

floo_req_t router_10_8_to_router_10_7_req;
floo_rsp_t router_10_7_to_router_10_8_rsp;

floo_req_t router_10_8_to_router_10_9_req;
floo_rsp_t router_10_9_to_router_10_8_rsp;

floo_req_t router_10_8_to_router_11_8_req;
floo_rsp_t router_11_8_to_router_10_8_rsp;

floo_req_t router_10_8_to_magia_tile_ni_10_8_req;
floo_rsp_t magia_tile_ni_10_8_to_router_10_8_rsp;

floo_req_t router_10_9_to_router_9_9_req;
floo_rsp_t router_9_9_to_router_10_9_rsp;

floo_req_t router_10_9_to_router_10_8_req;
floo_rsp_t router_10_8_to_router_10_9_rsp;

floo_req_t router_10_9_to_router_10_10_req;
floo_rsp_t router_10_10_to_router_10_9_rsp;

floo_req_t router_10_9_to_router_11_9_req;
floo_rsp_t router_11_9_to_router_10_9_rsp;

floo_req_t router_10_9_to_magia_tile_ni_10_9_req;
floo_rsp_t magia_tile_ni_10_9_to_router_10_9_rsp;

floo_req_t router_10_10_to_router_9_10_req;
floo_rsp_t router_9_10_to_router_10_10_rsp;

floo_req_t router_10_10_to_router_10_9_req;
floo_rsp_t router_10_9_to_router_10_10_rsp;

floo_req_t router_10_10_to_router_10_11_req;
floo_rsp_t router_10_11_to_router_10_10_rsp;

floo_req_t router_10_10_to_router_11_10_req;
floo_rsp_t router_11_10_to_router_10_10_rsp;

floo_req_t router_10_10_to_magia_tile_ni_10_10_req;
floo_rsp_t magia_tile_ni_10_10_to_router_10_10_rsp;

floo_req_t router_10_11_to_router_9_11_req;
floo_rsp_t router_9_11_to_router_10_11_rsp;

floo_req_t router_10_11_to_router_10_10_req;
floo_rsp_t router_10_10_to_router_10_11_rsp;

floo_req_t router_10_11_to_router_10_12_req;
floo_rsp_t router_10_12_to_router_10_11_rsp;

floo_req_t router_10_11_to_router_11_11_req;
floo_rsp_t router_11_11_to_router_10_11_rsp;

floo_req_t router_10_11_to_magia_tile_ni_10_11_req;
floo_rsp_t magia_tile_ni_10_11_to_router_10_11_rsp;

floo_req_t router_10_12_to_router_9_12_req;
floo_rsp_t router_9_12_to_router_10_12_rsp;

floo_req_t router_10_12_to_router_10_11_req;
floo_rsp_t router_10_11_to_router_10_12_rsp;

floo_req_t router_10_12_to_router_10_13_req;
floo_rsp_t router_10_13_to_router_10_12_rsp;

floo_req_t router_10_12_to_router_11_12_req;
floo_rsp_t router_11_12_to_router_10_12_rsp;

floo_req_t router_10_12_to_magia_tile_ni_10_12_req;
floo_rsp_t magia_tile_ni_10_12_to_router_10_12_rsp;

floo_req_t router_10_13_to_router_9_13_req;
floo_rsp_t router_9_13_to_router_10_13_rsp;

floo_req_t router_10_13_to_router_10_12_req;
floo_rsp_t router_10_12_to_router_10_13_rsp;

floo_req_t router_10_13_to_router_10_14_req;
floo_rsp_t router_10_14_to_router_10_13_rsp;

floo_req_t router_10_13_to_router_11_13_req;
floo_rsp_t router_11_13_to_router_10_13_rsp;

floo_req_t router_10_13_to_magia_tile_ni_10_13_req;
floo_rsp_t magia_tile_ni_10_13_to_router_10_13_rsp;

floo_req_t router_10_14_to_router_9_14_req;
floo_rsp_t router_9_14_to_router_10_14_rsp;

floo_req_t router_10_14_to_router_10_13_req;
floo_rsp_t router_10_13_to_router_10_14_rsp;

floo_req_t router_10_14_to_router_10_15_req;
floo_rsp_t router_10_15_to_router_10_14_rsp;

floo_req_t router_10_14_to_router_11_14_req;
floo_rsp_t router_11_14_to_router_10_14_rsp;

floo_req_t router_10_14_to_magia_tile_ni_10_14_req;
floo_rsp_t magia_tile_ni_10_14_to_router_10_14_rsp;

floo_req_t router_10_15_to_router_9_15_req;
floo_rsp_t router_9_15_to_router_10_15_rsp;

floo_req_t router_10_15_to_router_10_14_req;
floo_rsp_t router_10_14_to_router_10_15_rsp;

floo_req_t router_10_15_to_router_11_15_req;
floo_rsp_t router_11_15_to_router_10_15_rsp;

floo_req_t router_10_15_to_magia_tile_ni_10_15_req;
floo_rsp_t magia_tile_ni_10_15_to_router_10_15_rsp;

floo_req_t router_11_0_to_router_10_0_req;
floo_rsp_t router_10_0_to_router_11_0_rsp;

floo_req_t router_11_0_to_router_11_1_req;
floo_rsp_t router_11_1_to_router_11_0_rsp;

floo_req_t router_11_0_to_router_12_0_req;
floo_rsp_t router_12_0_to_router_11_0_rsp;

floo_req_t router_11_0_to_magia_tile_ni_11_0_req;
floo_rsp_t magia_tile_ni_11_0_to_router_11_0_rsp;

floo_req_t router_11_1_to_router_10_1_req;
floo_rsp_t router_10_1_to_router_11_1_rsp;

floo_req_t router_11_1_to_router_11_0_req;
floo_rsp_t router_11_0_to_router_11_1_rsp;

floo_req_t router_11_1_to_router_11_2_req;
floo_rsp_t router_11_2_to_router_11_1_rsp;

floo_req_t router_11_1_to_router_12_1_req;
floo_rsp_t router_12_1_to_router_11_1_rsp;

floo_req_t router_11_1_to_magia_tile_ni_11_1_req;
floo_rsp_t magia_tile_ni_11_1_to_router_11_1_rsp;

floo_req_t router_11_2_to_router_10_2_req;
floo_rsp_t router_10_2_to_router_11_2_rsp;

floo_req_t router_11_2_to_router_11_1_req;
floo_rsp_t router_11_1_to_router_11_2_rsp;

floo_req_t router_11_2_to_router_11_3_req;
floo_rsp_t router_11_3_to_router_11_2_rsp;

floo_req_t router_11_2_to_router_12_2_req;
floo_rsp_t router_12_2_to_router_11_2_rsp;

floo_req_t router_11_2_to_magia_tile_ni_11_2_req;
floo_rsp_t magia_tile_ni_11_2_to_router_11_2_rsp;

floo_req_t router_11_3_to_router_10_3_req;
floo_rsp_t router_10_3_to_router_11_3_rsp;

floo_req_t router_11_3_to_router_11_2_req;
floo_rsp_t router_11_2_to_router_11_3_rsp;

floo_req_t router_11_3_to_router_11_4_req;
floo_rsp_t router_11_4_to_router_11_3_rsp;

floo_req_t router_11_3_to_router_12_3_req;
floo_rsp_t router_12_3_to_router_11_3_rsp;

floo_req_t router_11_3_to_magia_tile_ni_11_3_req;
floo_rsp_t magia_tile_ni_11_3_to_router_11_3_rsp;

floo_req_t router_11_4_to_router_10_4_req;
floo_rsp_t router_10_4_to_router_11_4_rsp;

floo_req_t router_11_4_to_router_11_3_req;
floo_rsp_t router_11_3_to_router_11_4_rsp;

floo_req_t router_11_4_to_router_11_5_req;
floo_rsp_t router_11_5_to_router_11_4_rsp;

floo_req_t router_11_4_to_router_12_4_req;
floo_rsp_t router_12_4_to_router_11_4_rsp;

floo_req_t router_11_4_to_magia_tile_ni_11_4_req;
floo_rsp_t magia_tile_ni_11_4_to_router_11_4_rsp;

floo_req_t router_11_5_to_router_10_5_req;
floo_rsp_t router_10_5_to_router_11_5_rsp;

floo_req_t router_11_5_to_router_11_4_req;
floo_rsp_t router_11_4_to_router_11_5_rsp;

floo_req_t router_11_5_to_router_11_6_req;
floo_rsp_t router_11_6_to_router_11_5_rsp;

floo_req_t router_11_5_to_router_12_5_req;
floo_rsp_t router_12_5_to_router_11_5_rsp;

floo_req_t router_11_5_to_magia_tile_ni_11_5_req;
floo_rsp_t magia_tile_ni_11_5_to_router_11_5_rsp;

floo_req_t router_11_6_to_router_10_6_req;
floo_rsp_t router_10_6_to_router_11_6_rsp;

floo_req_t router_11_6_to_router_11_5_req;
floo_rsp_t router_11_5_to_router_11_6_rsp;

floo_req_t router_11_6_to_router_11_7_req;
floo_rsp_t router_11_7_to_router_11_6_rsp;

floo_req_t router_11_6_to_router_12_6_req;
floo_rsp_t router_12_6_to_router_11_6_rsp;

floo_req_t router_11_6_to_magia_tile_ni_11_6_req;
floo_rsp_t magia_tile_ni_11_6_to_router_11_6_rsp;

floo_req_t router_11_7_to_router_10_7_req;
floo_rsp_t router_10_7_to_router_11_7_rsp;

floo_req_t router_11_7_to_router_11_6_req;
floo_rsp_t router_11_6_to_router_11_7_rsp;

floo_req_t router_11_7_to_router_11_8_req;
floo_rsp_t router_11_8_to_router_11_7_rsp;

floo_req_t router_11_7_to_router_12_7_req;
floo_rsp_t router_12_7_to_router_11_7_rsp;

floo_req_t router_11_7_to_magia_tile_ni_11_7_req;
floo_rsp_t magia_tile_ni_11_7_to_router_11_7_rsp;

floo_req_t router_11_8_to_router_10_8_req;
floo_rsp_t router_10_8_to_router_11_8_rsp;

floo_req_t router_11_8_to_router_11_7_req;
floo_rsp_t router_11_7_to_router_11_8_rsp;

floo_req_t router_11_8_to_router_11_9_req;
floo_rsp_t router_11_9_to_router_11_8_rsp;

floo_req_t router_11_8_to_router_12_8_req;
floo_rsp_t router_12_8_to_router_11_8_rsp;

floo_req_t router_11_8_to_magia_tile_ni_11_8_req;
floo_rsp_t magia_tile_ni_11_8_to_router_11_8_rsp;

floo_req_t router_11_9_to_router_10_9_req;
floo_rsp_t router_10_9_to_router_11_9_rsp;

floo_req_t router_11_9_to_router_11_8_req;
floo_rsp_t router_11_8_to_router_11_9_rsp;

floo_req_t router_11_9_to_router_11_10_req;
floo_rsp_t router_11_10_to_router_11_9_rsp;

floo_req_t router_11_9_to_router_12_9_req;
floo_rsp_t router_12_9_to_router_11_9_rsp;

floo_req_t router_11_9_to_magia_tile_ni_11_9_req;
floo_rsp_t magia_tile_ni_11_9_to_router_11_9_rsp;

floo_req_t router_11_10_to_router_10_10_req;
floo_rsp_t router_10_10_to_router_11_10_rsp;

floo_req_t router_11_10_to_router_11_9_req;
floo_rsp_t router_11_9_to_router_11_10_rsp;

floo_req_t router_11_10_to_router_11_11_req;
floo_rsp_t router_11_11_to_router_11_10_rsp;

floo_req_t router_11_10_to_router_12_10_req;
floo_rsp_t router_12_10_to_router_11_10_rsp;

floo_req_t router_11_10_to_magia_tile_ni_11_10_req;
floo_rsp_t magia_tile_ni_11_10_to_router_11_10_rsp;

floo_req_t router_11_11_to_router_10_11_req;
floo_rsp_t router_10_11_to_router_11_11_rsp;

floo_req_t router_11_11_to_router_11_10_req;
floo_rsp_t router_11_10_to_router_11_11_rsp;

floo_req_t router_11_11_to_router_11_12_req;
floo_rsp_t router_11_12_to_router_11_11_rsp;

floo_req_t router_11_11_to_router_12_11_req;
floo_rsp_t router_12_11_to_router_11_11_rsp;

floo_req_t router_11_11_to_magia_tile_ni_11_11_req;
floo_rsp_t magia_tile_ni_11_11_to_router_11_11_rsp;

floo_req_t router_11_12_to_router_10_12_req;
floo_rsp_t router_10_12_to_router_11_12_rsp;

floo_req_t router_11_12_to_router_11_11_req;
floo_rsp_t router_11_11_to_router_11_12_rsp;

floo_req_t router_11_12_to_router_11_13_req;
floo_rsp_t router_11_13_to_router_11_12_rsp;

floo_req_t router_11_12_to_router_12_12_req;
floo_rsp_t router_12_12_to_router_11_12_rsp;

floo_req_t router_11_12_to_magia_tile_ni_11_12_req;
floo_rsp_t magia_tile_ni_11_12_to_router_11_12_rsp;

floo_req_t router_11_13_to_router_10_13_req;
floo_rsp_t router_10_13_to_router_11_13_rsp;

floo_req_t router_11_13_to_router_11_12_req;
floo_rsp_t router_11_12_to_router_11_13_rsp;

floo_req_t router_11_13_to_router_11_14_req;
floo_rsp_t router_11_14_to_router_11_13_rsp;

floo_req_t router_11_13_to_router_12_13_req;
floo_rsp_t router_12_13_to_router_11_13_rsp;

floo_req_t router_11_13_to_magia_tile_ni_11_13_req;
floo_rsp_t magia_tile_ni_11_13_to_router_11_13_rsp;

floo_req_t router_11_14_to_router_10_14_req;
floo_rsp_t router_10_14_to_router_11_14_rsp;

floo_req_t router_11_14_to_router_11_13_req;
floo_rsp_t router_11_13_to_router_11_14_rsp;

floo_req_t router_11_14_to_router_11_15_req;
floo_rsp_t router_11_15_to_router_11_14_rsp;

floo_req_t router_11_14_to_router_12_14_req;
floo_rsp_t router_12_14_to_router_11_14_rsp;

floo_req_t router_11_14_to_magia_tile_ni_11_14_req;
floo_rsp_t magia_tile_ni_11_14_to_router_11_14_rsp;

floo_req_t router_11_15_to_router_10_15_req;
floo_rsp_t router_10_15_to_router_11_15_rsp;

floo_req_t router_11_15_to_router_11_14_req;
floo_rsp_t router_11_14_to_router_11_15_rsp;

floo_req_t router_11_15_to_router_12_15_req;
floo_rsp_t router_12_15_to_router_11_15_rsp;

floo_req_t router_11_15_to_magia_tile_ni_11_15_req;
floo_rsp_t magia_tile_ni_11_15_to_router_11_15_rsp;

floo_req_t router_12_0_to_router_11_0_req;
floo_rsp_t router_11_0_to_router_12_0_rsp;

floo_req_t router_12_0_to_router_12_1_req;
floo_rsp_t router_12_1_to_router_12_0_rsp;

floo_req_t router_12_0_to_router_13_0_req;
floo_rsp_t router_13_0_to_router_12_0_rsp;

floo_req_t router_12_0_to_magia_tile_ni_12_0_req;
floo_rsp_t magia_tile_ni_12_0_to_router_12_0_rsp;

floo_req_t router_12_1_to_router_11_1_req;
floo_rsp_t router_11_1_to_router_12_1_rsp;

floo_req_t router_12_1_to_router_12_0_req;
floo_rsp_t router_12_0_to_router_12_1_rsp;

floo_req_t router_12_1_to_router_12_2_req;
floo_rsp_t router_12_2_to_router_12_1_rsp;

floo_req_t router_12_1_to_router_13_1_req;
floo_rsp_t router_13_1_to_router_12_1_rsp;

floo_req_t router_12_1_to_magia_tile_ni_12_1_req;
floo_rsp_t magia_tile_ni_12_1_to_router_12_1_rsp;

floo_req_t router_12_2_to_router_11_2_req;
floo_rsp_t router_11_2_to_router_12_2_rsp;

floo_req_t router_12_2_to_router_12_1_req;
floo_rsp_t router_12_1_to_router_12_2_rsp;

floo_req_t router_12_2_to_router_12_3_req;
floo_rsp_t router_12_3_to_router_12_2_rsp;

floo_req_t router_12_2_to_router_13_2_req;
floo_rsp_t router_13_2_to_router_12_2_rsp;

floo_req_t router_12_2_to_magia_tile_ni_12_2_req;
floo_rsp_t magia_tile_ni_12_2_to_router_12_2_rsp;

floo_req_t router_12_3_to_router_11_3_req;
floo_rsp_t router_11_3_to_router_12_3_rsp;

floo_req_t router_12_3_to_router_12_2_req;
floo_rsp_t router_12_2_to_router_12_3_rsp;

floo_req_t router_12_3_to_router_12_4_req;
floo_rsp_t router_12_4_to_router_12_3_rsp;

floo_req_t router_12_3_to_router_13_3_req;
floo_rsp_t router_13_3_to_router_12_3_rsp;

floo_req_t router_12_3_to_magia_tile_ni_12_3_req;
floo_rsp_t magia_tile_ni_12_3_to_router_12_3_rsp;

floo_req_t router_12_4_to_router_11_4_req;
floo_rsp_t router_11_4_to_router_12_4_rsp;

floo_req_t router_12_4_to_router_12_3_req;
floo_rsp_t router_12_3_to_router_12_4_rsp;

floo_req_t router_12_4_to_router_12_5_req;
floo_rsp_t router_12_5_to_router_12_4_rsp;

floo_req_t router_12_4_to_router_13_4_req;
floo_rsp_t router_13_4_to_router_12_4_rsp;

floo_req_t router_12_4_to_magia_tile_ni_12_4_req;
floo_rsp_t magia_tile_ni_12_4_to_router_12_4_rsp;

floo_req_t router_12_5_to_router_11_5_req;
floo_rsp_t router_11_5_to_router_12_5_rsp;

floo_req_t router_12_5_to_router_12_4_req;
floo_rsp_t router_12_4_to_router_12_5_rsp;

floo_req_t router_12_5_to_router_12_6_req;
floo_rsp_t router_12_6_to_router_12_5_rsp;

floo_req_t router_12_5_to_router_13_5_req;
floo_rsp_t router_13_5_to_router_12_5_rsp;

floo_req_t router_12_5_to_magia_tile_ni_12_5_req;
floo_rsp_t magia_tile_ni_12_5_to_router_12_5_rsp;

floo_req_t router_12_6_to_router_11_6_req;
floo_rsp_t router_11_6_to_router_12_6_rsp;

floo_req_t router_12_6_to_router_12_5_req;
floo_rsp_t router_12_5_to_router_12_6_rsp;

floo_req_t router_12_6_to_router_12_7_req;
floo_rsp_t router_12_7_to_router_12_6_rsp;

floo_req_t router_12_6_to_router_13_6_req;
floo_rsp_t router_13_6_to_router_12_6_rsp;

floo_req_t router_12_6_to_magia_tile_ni_12_6_req;
floo_rsp_t magia_tile_ni_12_6_to_router_12_6_rsp;

floo_req_t router_12_7_to_router_11_7_req;
floo_rsp_t router_11_7_to_router_12_7_rsp;

floo_req_t router_12_7_to_router_12_6_req;
floo_rsp_t router_12_6_to_router_12_7_rsp;

floo_req_t router_12_7_to_router_12_8_req;
floo_rsp_t router_12_8_to_router_12_7_rsp;

floo_req_t router_12_7_to_router_13_7_req;
floo_rsp_t router_13_7_to_router_12_7_rsp;

floo_req_t router_12_7_to_magia_tile_ni_12_7_req;
floo_rsp_t magia_tile_ni_12_7_to_router_12_7_rsp;

floo_req_t router_12_8_to_router_11_8_req;
floo_rsp_t router_11_8_to_router_12_8_rsp;

floo_req_t router_12_8_to_router_12_7_req;
floo_rsp_t router_12_7_to_router_12_8_rsp;

floo_req_t router_12_8_to_router_12_9_req;
floo_rsp_t router_12_9_to_router_12_8_rsp;

floo_req_t router_12_8_to_router_13_8_req;
floo_rsp_t router_13_8_to_router_12_8_rsp;

floo_req_t router_12_8_to_magia_tile_ni_12_8_req;
floo_rsp_t magia_tile_ni_12_8_to_router_12_8_rsp;

floo_req_t router_12_9_to_router_11_9_req;
floo_rsp_t router_11_9_to_router_12_9_rsp;

floo_req_t router_12_9_to_router_12_8_req;
floo_rsp_t router_12_8_to_router_12_9_rsp;

floo_req_t router_12_9_to_router_12_10_req;
floo_rsp_t router_12_10_to_router_12_9_rsp;

floo_req_t router_12_9_to_router_13_9_req;
floo_rsp_t router_13_9_to_router_12_9_rsp;

floo_req_t router_12_9_to_magia_tile_ni_12_9_req;
floo_rsp_t magia_tile_ni_12_9_to_router_12_9_rsp;

floo_req_t router_12_10_to_router_11_10_req;
floo_rsp_t router_11_10_to_router_12_10_rsp;

floo_req_t router_12_10_to_router_12_9_req;
floo_rsp_t router_12_9_to_router_12_10_rsp;

floo_req_t router_12_10_to_router_12_11_req;
floo_rsp_t router_12_11_to_router_12_10_rsp;

floo_req_t router_12_10_to_router_13_10_req;
floo_rsp_t router_13_10_to_router_12_10_rsp;

floo_req_t router_12_10_to_magia_tile_ni_12_10_req;
floo_rsp_t magia_tile_ni_12_10_to_router_12_10_rsp;

floo_req_t router_12_11_to_router_11_11_req;
floo_rsp_t router_11_11_to_router_12_11_rsp;

floo_req_t router_12_11_to_router_12_10_req;
floo_rsp_t router_12_10_to_router_12_11_rsp;

floo_req_t router_12_11_to_router_12_12_req;
floo_rsp_t router_12_12_to_router_12_11_rsp;

floo_req_t router_12_11_to_router_13_11_req;
floo_rsp_t router_13_11_to_router_12_11_rsp;

floo_req_t router_12_11_to_magia_tile_ni_12_11_req;
floo_rsp_t magia_tile_ni_12_11_to_router_12_11_rsp;

floo_req_t router_12_12_to_router_11_12_req;
floo_rsp_t router_11_12_to_router_12_12_rsp;

floo_req_t router_12_12_to_router_12_11_req;
floo_rsp_t router_12_11_to_router_12_12_rsp;

floo_req_t router_12_12_to_router_12_13_req;
floo_rsp_t router_12_13_to_router_12_12_rsp;

floo_req_t router_12_12_to_router_13_12_req;
floo_rsp_t router_13_12_to_router_12_12_rsp;

floo_req_t router_12_12_to_magia_tile_ni_12_12_req;
floo_rsp_t magia_tile_ni_12_12_to_router_12_12_rsp;

floo_req_t router_12_13_to_router_11_13_req;
floo_rsp_t router_11_13_to_router_12_13_rsp;

floo_req_t router_12_13_to_router_12_12_req;
floo_rsp_t router_12_12_to_router_12_13_rsp;

floo_req_t router_12_13_to_router_12_14_req;
floo_rsp_t router_12_14_to_router_12_13_rsp;

floo_req_t router_12_13_to_router_13_13_req;
floo_rsp_t router_13_13_to_router_12_13_rsp;

floo_req_t router_12_13_to_magia_tile_ni_12_13_req;
floo_rsp_t magia_tile_ni_12_13_to_router_12_13_rsp;

floo_req_t router_12_14_to_router_11_14_req;
floo_rsp_t router_11_14_to_router_12_14_rsp;

floo_req_t router_12_14_to_router_12_13_req;
floo_rsp_t router_12_13_to_router_12_14_rsp;

floo_req_t router_12_14_to_router_12_15_req;
floo_rsp_t router_12_15_to_router_12_14_rsp;

floo_req_t router_12_14_to_router_13_14_req;
floo_rsp_t router_13_14_to_router_12_14_rsp;

floo_req_t router_12_14_to_magia_tile_ni_12_14_req;
floo_rsp_t magia_tile_ni_12_14_to_router_12_14_rsp;

floo_req_t router_12_15_to_router_11_15_req;
floo_rsp_t router_11_15_to_router_12_15_rsp;

floo_req_t router_12_15_to_router_12_14_req;
floo_rsp_t router_12_14_to_router_12_15_rsp;

floo_req_t router_12_15_to_router_13_15_req;
floo_rsp_t router_13_15_to_router_12_15_rsp;

floo_req_t router_12_15_to_magia_tile_ni_12_15_req;
floo_rsp_t magia_tile_ni_12_15_to_router_12_15_rsp;

floo_req_t router_13_0_to_router_12_0_req;
floo_rsp_t router_12_0_to_router_13_0_rsp;

floo_req_t router_13_0_to_router_13_1_req;
floo_rsp_t router_13_1_to_router_13_0_rsp;

floo_req_t router_13_0_to_router_14_0_req;
floo_rsp_t router_14_0_to_router_13_0_rsp;

floo_req_t router_13_0_to_magia_tile_ni_13_0_req;
floo_rsp_t magia_tile_ni_13_0_to_router_13_0_rsp;

floo_req_t router_13_1_to_router_12_1_req;
floo_rsp_t router_12_1_to_router_13_1_rsp;

floo_req_t router_13_1_to_router_13_0_req;
floo_rsp_t router_13_0_to_router_13_1_rsp;

floo_req_t router_13_1_to_router_13_2_req;
floo_rsp_t router_13_2_to_router_13_1_rsp;

floo_req_t router_13_1_to_router_14_1_req;
floo_rsp_t router_14_1_to_router_13_1_rsp;

floo_req_t router_13_1_to_magia_tile_ni_13_1_req;
floo_rsp_t magia_tile_ni_13_1_to_router_13_1_rsp;

floo_req_t router_13_2_to_router_12_2_req;
floo_rsp_t router_12_2_to_router_13_2_rsp;

floo_req_t router_13_2_to_router_13_1_req;
floo_rsp_t router_13_1_to_router_13_2_rsp;

floo_req_t router_13_2_to_router_13_3_req;
floo_rsp_t router_13_3_to_router_13_2_rsp;

floo_req_t router_13_2_to_router_14_2_req;
floo_rsp_t router_14_2_to_router_13_2_rsp;

floo_req_t router_13_2_to_magia_tile_ni_13_2_req;
floo_rsp_t magia_tile_ni_13_2_to_router_13_2_rsp;

floo_req_t router_13_3_to_router_12_3_req;
floo_rsp_t router_12_3_to_router_13_3_rsp;

floo_req_t router_13_3_to_router_13_2_req;
floo_rsp_t router_13_2_to_router_13_3_rsp;

floo_req_t router_13_3_to_router_13_4_req;
floo_rsp_t router_13_4_to_router_13_3_rsp;

floo_req_t router_13_3_to_router_14_3_req;
floo_rsp_t router_14_3_to_router_13_3_rsp;

floo_req_t router_13_3_to_magia_tile_ni_13_3_req;
floo_rsp_t magia_tile_ni_13_3_to_router_13_3_rsp;

floo_req_t router_13_4_to_router_12_4_req;
floo_rsp_t router_12_4_to_router_13_4_rsp;

floo_req_t router_13_4_to_router_13_3_req;
floo_rsp_t router_13_3_to_router_13_4_rsp;

floo_req_t router_13_4_to_router_13_5_req;
floo_rsp_t router_13_5_to_router_13_4_rsp;

floo_req_t router_13_4_to_router_14_4_req;
floo_rsp_t router_14_4_to_router_13_4_rsp;

floo_req_t router_13_4_to_magia_tile_ni_13_4_req;
floo_rsp_t magia_tile_ni_13_4_to_router_13_4_rsp;

floo_req_t router_13_5_to_router_12_5_req;
floo_rsp_t router_12_5_to_router_13_5_rsp;

floo_req_t router_13_5_to_router_13_4_req;
floo_rsp_t router_13_4_to_router_13_5_rsp;

floo_req_t router_13_5_to_router_13_6_req;
floo_rsp_t router_13_6_to_router_13_5_rsp;

floo_req_t router_13_5_to_router_14_5_req;
floo_rsp_t router_14_5_to_router_13_5_rsp;

floo_req_t router_13_5_to_magia_tile_ni_13_5_req;
floo_rsp_t magia_tile_ni_13_5_to_router_13_5_rsp;

floo_req_t router_13_6_to_router_12_6_req;
floo_rsp_t router_12_6_to_router_13_6_rsp;

floo_req_t router_13_6_to_router_13_5_req;
floo_rsp_t router_13_5_to_router_13_6_rsp;

floo_req_t router_13_6_to_router_13_7_req;
floo_rsp_t router_13_7_to_router_13_6_rsp;

floo_req_t router_13_6_to_router_14_6_req;
floo_rsp_t router_14_6_to_router_13_6_rsp;

floo_req_t router_13_6_to_magia_tile_ni_13_6_req;
floo_rsp_t magia_tile_ni_13_6_to_router_13_6_rsp;

floo_req_t router_13_7_to_router_12_7_req;
floo_rsp_t router_12_7_to_router_13_7_rsp;

floo_req_t router_13_7_to_router_13_6_req;
floo_rsp_t router_13_6_to_router_13_7_rsp;

floo_req_t router_13_7_to_router_13_8_req;
floo_rsp_t router_13_8_to_router_13_7_rsp;

floo_req_t router_13_7_to_router_14_7_req;
floo_rsp_t router_14_7_to_router_13_7_rsp;

floo_req_t router_13_7_to_magia_tile_ni_13_7_req;
floo_rsp_t magia_tile_ni_13_7_to_router_13_7_rsp;

floo_req_t router_13_8_to_router_12_8_req;
floo_rsp_t router_12_8_to_router_13_8_rsp;

floo_req_t router_13_8_to_router_13_7_req;
floo_rsp_t router_13_7_to_router_13_8_rsp;

floo_req_t router_13_8_to_router_13_9_req;
floo_rsp_t router_13_9_to_router_13_8_rsp;

floo_req_t router_13_8_to_router_14_8_req;
floo_rsp_t router_14_8_to_router_13_8_rsp;

floo_req_t router_13_8_to_magia_tile_ni_13_8_req;
floo_rsp_t magia_tile_ni_13_8_to_router_13_8_rsp;

floo_req_t router_13_9_to_router_12_9_req;
floo_rsp_t router_12_9_to_router_13_9_rsp;

floo_req_t router_13_9_to_router_13_8_req;
floo_rsp_t router_13_8_to_router_13_9_rsp;

floo_req_t router_13_9_to_router_13_10_req;
floo_rsp_t router_13_10_to_router_13_9_rsp;

floo_req_t router_13_9_to_router_14_9_req;
floo_rsp_t router_14_9_to_router_13_9_rsp;

floo_req_t router_13_9_to_magia_tile_ni_13_9_req;
floo_rsp_t magia_tile_ni_13_9_to_router_13_9_rsp;

floo_req_t router_13_10_to_router_12_10_req;
floo_rsp_t router_12_10_to_router_13_10_rsp;

floo_req_t router_13_10_to_router_13_9_req;
floo_rsp_t router_13_9_to_router_13_10_rsp;

floo_req_t router_13_10_to_router_13_11_req;
floo_rsp_t router_13_11_to_router_13_10_rsp;

floo_req_t router_13_10_to_router_14_10_req;
floo_rsp_t router_14_10_to_router_13_10_rsp;

floo_req_t router_13_10_to_magia_tile_ni_13_10_req;
floo_rsp_t magia_tile_ni_13_10_to_router_13_10_rsp;

floo_req_t router_13_11_to_router_12_11_req;
floo_rsp_t router_12_11_to_router_13_11_rsp;

floo_req_t router_13_11_to_router_13_10_req;
floo_rsp_t router_13_10_to_router_13_11_rsp;

floo_req_t router_13_11_to_router_13_12_req;
floo_rsp_t router_13_12_to_router_13_11_rsp;

floo_req_t router_13_11_to_router_14_11_req;
floo_rsp_t router_14_11_to_router_13_11_rsp;

floo_req_t router_13_11_to_magia_tile_ni_13_11_req;
floo_rsp_t magia_tile_ni_13_11_to_router_13_11_rsp;

floo_req_t router_13_12_to_router_12_12_req;
floo_rsp_t router_12_12_to_router_13_12_rsp;

floo_req_t router_13_12_to_router_13_11_req;
floo_rsp_t router_13_11_to_router_13_12_rsp;

floo_req_t router_13_12_to_router_13_13_req;
floo_rsp_t router_13_13_to_router_13_12_rsp;

floo_req_t router_13_12_to_router_14_12_req;
floo_rsp_t router_14_12_to_router_13_12_rsp;

floo_req_t router_13_12_to_magia_tile_ni_13_12_req;
floo_rsp_t magia_tile_ni_13_12_to_router_13_12_rsp;

floo_req_t router_13_13_to_router_12_13_req;
floo_rsp_t router_12_13_to_router_13_13_rsp;

floo_req_t router_13_13_to_router_13_12_req;
floo_rsp_t router_13_12_to_router_13_13_rsp;

floo_req_t router_13_13_to_router_13_14_req;
floo_rsp_t router_13_14_to_router_13_13_rsp;

floo_req_t router_13_13_to_router_14_13_req;
floo_rsp_t router_14_13_to_router_13_13_rsp;

floo_req_t router_13_13_to_magia_tile_ni_13_13_req;
floo_rsp_t magia_tile_ni_13_13_to_router_13_13_rsp;

floo_req_t router_13_14_to_router_12_14_req;
floo_rsp_t router_12_14_to_router_13_14_rsp;

floo_req_t router_13_14_to_router_13_13_req;
floo_rsp_t router_13_13_to_router_13_14_rsp;

floo_req_t router_13_14_to_router_13_15_req;
floo_rsp_t router_13_15_to_router_13_14_rsp;

floo_req_t router_13_14_to_router_14_14_req;
floo_rsp_t router_14_14_to_router_13_14_rsp;

floo_req_t router_13_14_to_magia_tile_ni_13_14_req;
floo_rsp_t magia_tile_ni_13_14_to_router_13_14_rsp;

floo_req_t router_13_15_to_router_12_15_req;
floo_rsp_t router_12_15_to_router_13_15_rsp;

floo_req_t router_13_15_to_router_13_14_req;
floo_rsp_t router_13_14_to_router_13_15_rsp;

floo_req_t router_13_15_to_router_14_15_req;
floo_rsp_t router_14_15_to_router_13_15_rsp;

floo_req_t router_13_15_to_magia_tile_ni_13_15_req;
floo_rsp_t magia_tile_ni_13_15_to_router_13_15_rsp;

floo_req_t router_14_0_to_router_13_0_req;
floo_rsp_t router_13_0_to_router_14_0_rsp;

floo_req_t router_14_0_to_router_14_1_req;
floo_rsp_t router_14_1_to_router_14_0_rsp;

floo_req_t router_14_0_to_router_15_0_req;
floo_rsp_t router_15_0_to_router_14_0_rsp;

floo_req_t router_14_0_to_magia_tile_ni_14_0_req;
floo_rsp_t magia_tile_ni_14_0_to_router_14_0_rsp;

floo_req_t router_14_1_to_router_13_1_req;
floo_rsp_t router_13_1_to_router_14_1_rsp;

floo_req_t router_14_1_to_router_14_0_req;
floo_rsp_t router_14_0_to_router_14_1_rsp;

floo_req_t router_14_1_to_router_14_2_req;
floo_rsp_t router_14_2_to_router_14_1_rsp;

floo_req_t router_14_1_to_router_15_1_req;
floo_rsp_t router_15_1_to_router_14_1_rsp;

floo_req_t router_14_1_to_magia_tile_ni_14_1_req;
floo_rsp_t magia_tile_ni_14_1_to_router_14_1_rsp;

floo_req_t router_14_2_to_router_13_2_req;
floo_rsp_t router_13_2_to_router_14_2_rsp;

floo_req_t router_14_2_to_router_14_1_req;
floo_rsp_t router_14_1_to_router_14_2_rsp;

floo_req_t router_14_2_to_router_14_3_req;
floo_rsp_t router_14_3_to_router_14_2_rsp;

floo_req_t router_14_2_to_router_15_2_req;
floo_rsp_t router_15_2_to_router_14_2_rsp;

floo_req_t router_14_2_to_magia_tile_ni_14_2_req;
floo_rsp_t magia_tile_ni_14_2_to_router_14_2_rsp;

floo_req_t router_14_3_to_router_13_3_req;
floo_rsp_t router_13_3_to_router_14_3_rsp;

floo_req_t router_14_3_to_router_14_2_req;
floo_rsp_t router_14_2_to_router_14_3_rsp;

floo_req_t router_14_3_to_router_14_4_req;
floo_rsp_t router_14_4_to_router_14_3_rsp;

floo_req_t router_14_3_to_router_15_3_req;
floo_rsp_t router_15_3_to_router_14_3_rsp;

floo_req_t router_14_3_to_magia_tile_ni_14_3_req;
floo_rsp_t magia_tile_ni_14_3_to_router_14_3_rsp;

floo_req_t router_14_4_to_router_13_4_req;
floo_rsp_t router_13_4_to_router_14_4_rsp;

floo_req_t router_14_4_to_router_14_3_req;
floo_rsp_t router_14_3_to_router_14_4_rsp;

floo_req_t router_14_4_to_router_14_5_req;
floo_rsp_t router_14_5_to_router_14_4_rsp;

floo_req_t router_14_4_to_router_15_4_req;
floo_rsp_t router_15_4_to_router_14_4_rsp;

floo_req_t router_14_4_to_magia_tile_ni_14_4_req;
floo_rsp_t magia_tile_ni_14_4_to_router_14_4_rsp;

floo_req_t router_14_5_to_router_13_5_req;
floo_rsp_t router_13_5_to_router_14_5_rsp;

floo_req_t router_14_5_to_router_14_4_req;
floo_rsp_t router_14_4_to_router_14_5_rsp;

floo_req_t router_14_5_to_router_14_6_req;
floo_rsp_t router_14_6_to_router_14_5_rsp;

floo_req_t router_14_5_to_router_15_5_req;
floo_rsp_t router_15_5_to_router_14_5_rsp;

floo_req_t router_14_5_to_magia_tile_ni_14_5_req;
floo_rsp_t magia_tile_ni_14_5_to_router_14_5_rsp;

floo_req_t router_14_6_to_router_13_6_req;
floo_rsp_t router_13_6_to_router_14_6_rsp;

floo_req_t router_14_6_to_router_14_5_req;
floo_rsp_t router_14_5_to_router_14_6_rsp;

floo_req_t router_14_6_to_router_14_7_req;
floo_rsp_t router_14_7_to_router_14_6_rsp;

floo_req_t router_14_6_to_router_15_6_req;
floo_rsp_t router_15_6_to_router_14_6_rsp;

floo_req_t router_14_6_to_magia_tile_ni_14_6_req;
floo_rsp_t magia_tile_ni_14_6_to_router_14_6_rsp;

floo_req_t router_14_7_to_router_13_7_req;
floo_rsp_t router_13_7_to_router_14_7_rsp;

floo_req_t router_14_7_to_router_14_6_req;
floo_rsp_t router_14_6_to_router_14_7_rsp;

floo_req_t router_14_7_to_router_14_8_req;
floo_rsp_t router_14_8_to_router_14_7_rsp;

floo_req_t router_14_7_to_router_15_7_req;
floo_rsp_t router_15_7_to_router_14_7_rsp;

floo_req_t router_14_7_to_magia_tile_ni_14_7_req;
floo_rsp_t magia_tile_ni_14_7_to_router_14_7_rsp;

floo_req_t router_14_8_to_router_13_8_req;
floo_rsp_t router_13_8_to_router_14_8_rsp;

floo_req_t router_14_8_to_router_14_7_req;
floo_rsp_t router_14_7_to_router_14_8_rsp;

floo_req_t router_14_8_to_router_14_9_req;
floo_rsp_t router_14_9_to_router_14_8_rsp;

floo_req_t router_14_8_to_router_15_8_req;
floo_rsp_t router_15_8_to_router_14_8_rsp;

floo_req_t router_14_8_to_magia_tile_ni_14_8_req;
floo_rsp_t magia_tile_ni_14_8_to_router_14_8_rsp;

floo_req_t router_14_9_to_router_13_9_req;
floo_rsp_t router_13_9_to_router_14_9_rsp;

floo_req_t router_14_9_to_router_14_8_req;
floo_rsp_t router_14_8_to_router_14_9_rsp;

floo_req_t router_14_9_to_router_14_10_req;
floo_rsp_t router_14_10_to_router_14_9_rsp;

floo_req_t router_14_9_to_router_15_9_req;
floo_rsp_t router_15_9_to_router_14_9_rsp;

floo_req_t router_14_9_to_magia_tile_ni_14_9_req;
floo_rsp_t magia_tile_ni_14_9_to_router_14_9_rsp;

floo_req_t router_14_10_to_router_13_10_req;
floo_rsp_t router_13_10_to_router_14_10_rsp;

floo_req_t router_14_10_to_router_14_9_req;
floo_rsp_t router_14_9_to_router_14_10_rsp;

floo_req_t router_14_10_to_router_14_11_req;
floo_rsp_t router_14_11_to_router_14_10_rsp;

floo_req_t router_14_10_to_router_15_10_req;
floo_rsp_t router_15_10_to_router_14_10_rsp;

floo_req_t router_14_10_to_magia_tile_ni_14_10_req;
floo_rsp_t magia_tile_ni_14_10_to_router_14_10_rsp;

floo_req_t router_14_11_to_router_13_11_req;
floo_rsp_t router_13_11_to_router_14_11_rsp;

floo_req_t router_14_11_to_router_14_10_req;
floo_rsp_t router_14_10_to_router_14_11_rsp;

floo_req_t router_14_11_to_router_14_12_req;
floo_rsp_t router_14_12_to_router_14_11_rsp;

floo_req_t router_14_11_to_router_15_11_req;
floo_rsp_t router_15_11_to_router_14_11_rsp;

floo_req_t router_14_11_to_magia_tile_ni_14_11_req;
floo_rsp_t magia_tile_ni_14_11_to_router_14_11_rsp;

floo_req_t router_14_12_to_router_13_12_req;
floo_rsp_t router_13_12_to_router_14_12_rsp;

floo_req_t router_14_12_to_router_14_11_req;
floo_rsp_t router_14_11_to_router_14_12_rsp;

floo_req_t router_14_12_to_router_14_13_req;
floo_rsp_t router_14_13_to_router_14_12_rsp;

floo_req_t router_14_12_to_router_15_12_req;
floo_rsp_t router_15_12_to_router_14_12_rsp;

floo_req_t router_14_12_to_magia_tile_ni_14_12_req;
floo_rsp_t magia_tile_ni_14_12_to_router_14_12_rsp;

floo_req_t router_14_13_to_router_13_13_req;
floo_rsp_t router_13_13_to_router_14_13_rsp;

floo_req_t router_14_13_to_router_14_12_req;
floo_rsp_t router_14_12_to_router_14_13_rsp;

floo_req_t router_14_13_to_router_14_14_req;
floo_rsp_t router_14_14_to_router_14_13_rsp;

floo_req_t router_14_13_to_router_15_13_req;
floo_rsp_t router_15_13_to_router_14_13_rsp;

floo_req_t router_14_13_to_magia_tile_ni_14_13_req;
floo_rsp_t magia_tile_ni_14_13_to_router_14_13_rsp;

floo_req_t router_14_14_to_router_13_14_req;
floo_rsp_t router_13_14_to_router_14_14_rsp;

floo_req_t router_14_14_to_router_14_13_req;
floo_rsp_t router_14_13_to_router_14_14_rsp;

floo_req_t router_14_14_to_router_14_15_req;
floo_rsp_t router_14_15_to_router_14_14_rsp;

floo_req_t router_14_14_to_router_15_14_req;
floo_rsp_t router_15_14_to_router_14_14_rsp;

floo_req_t router_14_14_to_magia_tile_ni_14_14_req;
floo_rsp_t magia_tile_ni_14_14_to_router_14_14_rsp;

floo_req_t router_14_15_to_router_13_15_req;
floo_rsp_t router_13_15_to_router_14_15_rsp;

floo_req_t router_14_15_to_router_14_14_req;
floo_rsp_t router_14_14_to_router_14_15_rsp;

floo_req_t router_14_15_to_router_15_15_req;
floo_rsp_t router_15_15_to_router_14_15_rsp;

floo_req_t router_14_15_to_magia_tile_ni_14_15_req;
floo_rsp_t magia_tile_ni_14_15_to_router_14_15_rsp;

floo_req_t router_15_0_to_router_14_0_req;
floo_rsp_t router_14_0_to_router_15_0_rsp;

floo_req_t router_15_0_to_router_15_1_req;
floo_rsp_t router_15_1_to_router_15_0_rsp;

floo_req_t router_15_0_to_magia_tile_ni_15_0_req;
floo_rsp_t magia_tile_ni_15_0_to_router_15_0_rsp;

floo_req_t router_15_1_to_router_14_1_req;
floo_rsp_t router_14_1_to_router_15_1_rsp;

floo_req_t router_15_1_to_router_15_0_req;
floo_rsp_t router_15_0_to_router_15_1_rsp;

floo_req_t router_15_1_to_router_15_2_req;
floo_rsp_t router_15_2_to_router_15_1_rsp;

floo_req_t router_15_1_to_magia_tile_ni_15_1_req;
floo_rsp_t magia_tile_ni_15_1_to_router_15_1_rsp;

floo_req_t router_15_2_to_router_14_2_req;
floo_rsp_t router_14_2_to_router_15_2_rsp;

floo_req_t router_15_2_to_router_15_1_req;
floo_rsp_t router_15_1_to_router_15_2_rsp;

floo_req_t router_15_2_to_router_15_3_req;
floo_rsp_t router_15_3_to_router_15_2_rsp;

floo_req_t router_15_2_to_magia_tile_ni_15_2_req;
floo_rsp_t magia_tile_ni_15_2_to_router_15_2_rsp;

floo_req_t router_15_3_to_router_14_3_req;
floo_rsp_t router_14_3_to_router_15_3_rsp;

floo_req_t router_15_3_to_router_15_2_req;
floo_rsp_t router_15_2_to_router_15_3_rsp;

floo_req_t router_15_3_to_router_15_4_req;
floo_rsp_t router_15_4_to_router_15_3_rsp;

floo_req_t router_15_3_to_magia_tile_ni_15_3_req;
floo_rsp_t magia_tile_ni_15_3_to_router_15_3_rsp;

floo_req_t router_15_4_to_router_14_4_req;
floo_rsp_t router_14_4_to_router_15_4_rsp;

floo_req_t router_15_4_to_router_15_3_req;
floo_rsp_t router_15_3_to_router_15_4_rsp;

floo_req_t router_15_4_to_router_15_5_req;
floo_rsp_t router_15_5_to_router_15_4_rsp;

floo_req_t router_15_4_to_magia_tile_ni_15_4_req;
floo_rsp_t magia_tile_ni_15_4_to_router_15_4_rsp;

floo_req_t router_15_5_to_router_14_5_req;
floo_rsp_t router_14_5_to_router_15_5_rsp;

floo_req_t router_15_5_to_router_15_4_req;
floo_rsp_t router_15_4_to_router_15_5_rsp;

floo_req_t router_15_5_to_router_15_6_req;
floo_rsp_t router_15_6_to_router_15_5_rsp;

floo_req_t router_15_5_to_magia_tile_ni_15_5_req;
floo_rsp_t magia_tile_ni_15_5_to_router_15_5_rsp;

floo_req_t router_15_6_to_router_14_6_req;
floo_rsp_t router_14_6_to_router_15_6_rsp;

floo_req_t router_15_6_to_router_15_5_req;
floo_rsp_t router_15_5_to_router_15_6_rsp;

floo_req_t router_15_6_to_router_15_7_req;
floo_rsp_t router_15_7_to_router_15_6_rsp;

floo_req_t router_15_6_to_magia_tile_ni_15_6_req;
floo_rsp_t magia_tile_ni_15_6_to_router_15_6_rsp;

floo_req_t router_15_7_to_router_14_7_req;
floo_rsp_t router_14_7_to_router_15_7_rsp;

floo_req_t router_15_7_to_router_15_6_req;
floo_rsp_t router_15_6_to_router_15_7_rsp;

floo_req_t router_15_7_to_router_15_8_req;
floo_rsp_t router_15_8_to_router_15_7_rsp;

floo_req_t router_15_7_to_magia_tile_ni_15_7_req;
floo_rsp_t magia_tile_ni_15_7_to_router_15_7_rsp;

floo_req_t router_15_8_to_router_14_8_req;
floo_rsp_t router_14_8_to_router_15_8_rsp;

floo_req_t router_15_8_to_router_15_7_req;
floo_rsp_t router_15_7_to_router_15_8_rsp;

floo_req_t router_15_8_to_router_15_9_req;
floo_rsp_t router_15_9_to_router_15_8_rsp;

floo_req_t router_15_8_to_magia_tile_ni_15_8_req;
floo_rsp_t magia_tile_ni_15_8_to_router_15_8_rsp;

floo_req_t router_15_9_to_router_14_9_req;
floo_rsp_t router_14_9_to_router_15_9_rsp;

floo_req_t router_15_9_to_router_15_8_req;
floo_rsp_t router_15_8_to_router_15_9_rsp;

floo_req_t router_15_9_to_router_15_10_req;
floo_rsp_t router_15_10_to_router_15_9_rsp;

floo_req_t router_15_9_to_magia_tile_ni_15_9_req;
floo_rsp_t magia_tile_ni_15_9_to_router_15_9_rsp;

floo_req_t router_15_10_to_router_14_10_req;
floo_rsp_t router_14_10_to_router_15_10_rsp;

floo_req_t router_15_10_to_router_15_9_req;
floo_rsp_t router_15_9_to_router_15_10_rsp;

floo_req_t router_15_10_to_router_15_11_req;
floo_rsp_t router_15_11_to_router_15_10_rsp;

floo_req_t router_15_10_to_magia_tile_ni_15_10_req;
floo_rsp_t magia_tile_ni_15_10_to_router_15_10_rsp;

floo_req_t router_15_11_to_router_14_11_req;
floo_rsp_t router_14_11_to_router_15_11_rsp;

floo_req_t router_15_11_to_router_15_10_req;
floo_rsp_t router_15_10_to_router_15_11_rsp;

floo_req_t router_15_11_to_router_15_12_req;
floo_rsp_t router_15_12_to_router_15_11_rsp;

floo_req_t router_15_11_to_magia_tile_ni_15_11_req;
floo_rsp_t magia_tile_ni_15_11_to_router_15_11_rsp;

floo_req_t router_15_12_to_router_14_12_req;
floo_rsp_t router_14_12_to_router_15_12_rsp;

floo_req_t router_15_12_to_router_15_11_req;
floo_rsp_t router_15_11_to_router_15_12_rsp;

floo_req_t router_15_12_to_router_15_13_req;
floo_rsp_t router_15_13_to_router_15_12_rsp;

floo_req_t router_15_12_to_magia_tile_ni_15_12_req;
floo_rsp_t magia_tile_ni_15_12_to_router_15_12_rsp;

floo_req_t router_15_13_to_router_14_13_req;
floo_rsp_t router_14_13_to_router_15_13_rsp;

floo_req_t router_15_13_to_router_15_12_req;
floo_rsp_t router_15_12_to_router_15_13_rsp;

floo_req_t router_15_13_to_router_15_14_req;
floo_rsp_t router_15_14_to_router_15_13_rsp;

floo_req_t router_15_13_to_magia_tile_ni_15_13_req;
floo_rsp_t magia_tile_ni_15_13_to_router_15_13_rsp;

floo_req_t router_15_14_to_router_14_14_req;
floo_rsp_t router_14_14_to_router_15_14_rsp;

floo_req_t router_15_14_to_router_15_13_req;
floo_rsp_t router_15_13_to_router_15_14_rsp;

floo_req_t router_15_14_to_router_15_15_req;
floo_rsp_t router_15_15_to_router_15_14_rsp;

floo_req_t router_15_14_to_magia_tile_ni_15_14_req;
floo_rsp_t magia_tile_ni_15_14_to_router_15_14_rsp;

floo_req_t router_15_15_to_router_14_15_req;
floo_rsp_t router_14_15_to_router_15_15_rsp;

floo_req_t router_15_15_to_router_15_14_req;
floo_rsp_t router_15_14_to_router_15_15_rsp;

floo_req_t router_15_15_to_magia_tile_ni_15_15_req;
floo_rsp_t magia_tile_ni_15_15_to_router_15_15_rsp;

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

floo_req_t magia_tile_ni_0_8_to_router_0_8_req;
floo_rsp_t router_0_8_to_magia_tile_ni_0_8_rsp;

floo_req_t magia_tile_ni_0_9_to_router_0_9_req;
floo_rsp_t router_0_9_to_magia_tile_ni_0_9_rsp;

floo_req_t magia_tile_ni_0_10_to_router_0_10_req;
floo_rsp_t router_0_10_to_magia_tile_ni_0_10_rsp;

floo_req_t magia_tile_ni_0_11_to_router_0_11_req;
floo_rsp_t router_0_11_to_magia_tile_ni_0_11_rsp;

floo_req_t magia_tile_ni_0_12_to_router_0_12_req;
floo_rsp_t router_0_12_to_magia_tile_ni_0_12_rsp;

floo_req_t magia_tile_ni_0_13_to_router_0_13_req;
floo_rsp_t router_0_13_to_magia_tile_ni_0_13_rsp;

floo_req_t magia_tile_ni_0_14_to_router_0_14_req;
floo_rsp_t router_0_14_to_magia_tile_ni_0_14_rsp;

floo_req_t magia_tile_ni_0_15_to_router_0_15_req;
floo_rsp_t router_0_15_to_magia_tile_ni_0_15_rsp;

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

floo_req_t magia_tile_ni_1_8_to_router_1_8_req;
floo_rsp_t router_1_8_to_magia_tile_ni_1_8_rsp;

floo_req_t magia_tile_ni_1_9_to_router_1_9_req;
floo_rsp_t router_1_9_to_magia_tile_ni_1_9_rsp;

floo_req_t magia_tile_ni_1_10_to_router_1_10_req;
floo_rsp_t router_1_10_to_magia_tile_ni_1_10_rsp;

floo_req_t magia_tile_ni_1_11_to_router_1_11_req;
floo_rsp_t router_1_11_to_magia_tile_ni_1_11_rsp;

floo_req_t magia_tile_ni_1_12_to_router_1_12_req;
floo_rsp_t router_1_12_to_magia_tile_ni_1_12_rsp;

floo_req_t magia_tile_ni_1_13_to_router_1_13_req;
floo_rsp_t router_1_13_to_magia_tile_ni_1_13_rsp;

floo_req_t magia_tile_ni_1_14_to_router_1_14_req;
floo_rsp_t router_1_14_to_magia_tile_ni_1_14_rsp;

floo_req_t magia_tile_ni_1_15_to_router_1_15_req;
floo_rsp_t router_1_15_to_magia_tile_ni_1_15_rsp;

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

floo_req_t magia_tile_ni_2_8_to_router_2_8_req;
floo_rsp_t router_2_8_to_magia_tile_ni_2_8_rsp;

floo_req_t magia_tile_ni_2_9_to_router_2_9_req;
floo_rsp_t router_2_9_to_magia_tile_ni_2_9_rsp;

floo_req_t magia_tile_ni_2_10_to_router_2_10_req;
floo_rsp_t router_2_10_to_magia_tile_ni_2_10_rsp;

floo_req_t magia_tile_ni_2_11_to_router_2_11_req;
floo_rsp_t router_2_11_to_magia_tile_ni_2_11_rsp;

floo_req_t magia_tile_ni_2_12_to_router_2_12_req;
floo_rsp_t router_2_12_to_magia_tile_ni_2_12_rsp;

floo_req_t magia_tile_ni_2_13_to_router_2_13_req;
floo_rsp_t router_2_13_to_magia_tile_ni_2_13_rsp;

floo_req_t magia_tile_ni_2_14_to_router_2_14_req;
floo_rsp_t router_2_14_to_magia_tile_ni_2_14_rsp;

floo_req_t magia_tile_ni_2_15_to_router_2_15_req;
floo_rsp_t router_2_15_to_magia_tile_ni_2_15_rsp;

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

floo_req_t magia_tile_ni_3_8_to_router_3_8_req;
floo_rsp_t router_3_8_to_magia_tile_ni_3_8_rsp;

floo_req_t magia_tile_ni_3_9_to_router_3_9_req;
floo_rsp_t router_3_9_to_magia_tile_ni_3_9_rsp;

floo_req_t magia_tile_ni_3_10_to_router_3_10_req;
floo_rsp_t router_3_10_to_magia_tile_ni_3_10_rsp;

floo_req_t magia_tile_ni_3_11_to_router_3_11_req;
floo_rsp_t router_3_11_to_magia_tile_ni_3_11_rsp;

floo_req_t magia_tile_ni_3_12_to_router_3_12_req;
floo_rsp_t router_3_12_to_magia_tile_ni_3_12_rsp;

floo_req_t magia_tile_ni_3_13_to_router_3_13_req;
floo_rsp_t router_3_13_to_magia_tile_ni_3_13_rsp;

floo_req_t magia_tile_ni_3_14_to_router_3_14_req;
floo_rsp_t router_3_14_to_magia_tile_ni_3_14_rsp;

floo_req_t magia_tile_ni_3_15_to_router_3_15_req;
floo_rsp_t router_3_15_to_magia_tile_ni_3_15_rsp;

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

floo_req_t magia_tile_ni_4_8_to_router_4_8_req;
floo_rsp_t router_4_8_to_magia_tile_ni_4_8_rsp;

floo_req_t magia_tile_ni_4_9_to_router_4_9_req;
floo_rsp_t router_4_9_to_magia_tile_ni_4_9_rsp;

floo_req_t magia_tile_ni_4_10_to_router_4_10_req;
floo_rsp_t router_4_10_to_magia_tile_ni_4_10_rsp;

floo_req_t magia_tile_ni_4_11_to_router_4_11_req;
floo_rsp_t router_4_11_to_magia_tile_ni_4_11_rsp;

floo_req_t magia_tile_ni_4_12_to_router_4_12_req;
floo_rsp_t router_4_12_to_magia_tile_ni_4_12_rsp;

floo_req_t magia_tile_ni_4_13_to_router_4_13_req;
floo_rsp_t router_4_13_to_magia_tile_ni_4_13_rsp;

floo_req_t magia_tile_ni_4_14_to_router_4_14_req;
floo_rsp_t router_4_14_to_magia_tile_ni_4_14_rsp;

floo_req_t magia_tile_ni_4_15_to_router_4_15_req;
floo_rsp_t router_4_15_to_magia_tile_ni_4_15_rsp;

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

floo_req_t magia_tile_ni_5_8_to_router_5_8_req;
floo_rsp_t router_5_8_to_magia_tile_ni_5_8_rsp;

floo_req_t magia_tile_ni_5_9_to_router_5_9_req;
floo_rsp_t router_5_9_to_magia_tile_ni_5_9_rsp;

floo_req_t magia_tile_ni_5_10_to_router_5_10_req;
floo_rsp_t router_5_10_to_magia_tile_ni_5_10_rsp;

floo_req_t magia_tile_ni_5_11_to_router_5_11_req;
floo_rsp_t router_5_11_to_magia_tile_ni_5_11_rsp;

floo_req_t magia_tile_ni_5_12_to_router_5_12_req;
floo_rsp_t router_5_12_to_magia_tile_ni_5_12_rsp;

floo_req_t magia_tile_ni_5_13_to_router_5_13_req;
floo_rsp_t router_5_13_to_magia_tile_ni_5_13_rsp;

floo_req_t magia_tile_ni_5_14_to_router_5_14_req;
floo_rsp_t router_5_14_to_magia_tile_ni_5_14_rsp;

floo_req_t magia_tile_ni_5_15_to_router_5_15_req;
floo_rsp_t router_5_15_to_magia_tile_ni_5_15_rsp;

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

floo_req_t magia_tile_ni_6_8_to_router_6_8_req;
floo_rsp_t router_6_8_to_magia_tile_ni_6_8_rsp;

floo_req_t magia_tile_ni_6_9_to_router_6_9_req;
floo_rsp_t router_6_9_to_magia_tile_ni_6_9_rsp;

floo_req_t magia_tile_ni_6_10_to_router_6_10_req;
floo_rsp_t router_6_10_to_magia_tile_ni_6_10_rsp;

floo_req_t magia_tile_ni_6_11_to_router_6_11_req;
floo_rsp_t router_6_11_to_magia_tile_ni_6_11_rsp;

floo_req_t magia_tile_ni_6_12_to_router_6_12_req;
floo_rsp_t router_6_12_to_magia_tile_ni_6_12_rsp;

floo_req_t magia_tile_ni_6_13_to_router_6_13_req;
floo_rsp_t router_6_13_to_magia_tile_ni_6_13_rsp;

floo_req_t magia_tile_ni_6_14_to_router_6_14_req;
floo_rsp_t router_6_14_to_magia_tile_ni_6_14_rsp;

floo_req_t magia_tile_ni_6_15_to_router_6_15_req;
floo_rsp_t router_6_15_to_magia_tile_ni_6_15_rsp;

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

floo_req_t magia_tile_ni_7_8_to_router_7_8_req;
floo_rsp_t router_7_8_to_magia_tile_ni_7_8_rsp;

floo_req_t magia_tile_ni_7_9_to_router_7_9_req;
floo_rsp_t router_7_9_to_magia_tile_ni_7_9_rsp;

floo_req_t magia_tile_ni_7_10_to_router_7_10_req;
floo_rsp_t router_7_10_to_magia_tile_ni_7_10_rsp;

floo_req_t magia_tile_ni_7_11_to_router_7_11_req;
floo_rsp_t router_7_11_to_magia_tile_ni_7_11_rsp;

floo_req_t magia_tile_ni_7_12_to_router_7_12_req;
floo_rsp_t router_7_12_to_magia_tile_ni_7_12_rsp;

floo_req_t magia_tile_ni_7_13_to_router_7_13_req;
floo_rsp_t router_7_13_to_magia_tile_ni_7_13_rsp;

floo_req_t magia_tile_ni_7_14_to_router_7_14_req;
floo_rsp_t router_7_14_to_magia_tile_ni_7_14_rsp;

floo_req_t magia_tile_ni_7_15_to_router_7_15_req;
floo_rsp_t router_7_15_to_magia_tile_ni_7_15_rsp;

floo_req_t magia_tile_ni_8_0_to_router_8_0_req;
floo_rsp_t router_8_0_to_magia_tile_ni_8_0_rsp;

floo_req_t magia_tile_ni_8_1_to_router_8_1_req;
floo_rsp_t router_8_1_to_magia_tile_ni_8_1_rsp;

floo_req_t magia_tile_ni_8_2_to_router_8_2_req;
floo_rsp_t router_8_2_to_magia_tile_ni_8_2_rsp;

floo_req_t magia_tile_ni_8_3_to_router_8_3_req;
floo_rsp_t router_8_3_to_magia_tile_ni_8_3_rsp;

floo_req_t magia_tile_ni_8_4_to_router_8_4_req;
floo_rsp_t router_8_4_to_magia_tile_ni_8_4_rsp;

floo_req_t magia_tile_ni_8_5_to_router_8_5_req;
floo_rsp_t router_8_5_to_magia_tile_ni_8_5_rsp;

floo_req_t magia_tile_ni_8_6_to_router_8_6_req;
floo_rsp_t router_8_6_to_magia_tile_ni_8_6_rsp;

floo_req_t magia_tile_ni_8_7_to_router_8_7_req;
floo_rsp_t router_8_7_to_magia_tile_ni_8_7_rsp;

floo_req_t magia_tile_ni_8_8_to_router_8_8_req;
floo_rsp_t router_8_8_to_magia_tile_ni_8_8_rsp;

floo_req_t magia_tile_ni_8_9_to_router_8_9_req;
floo_rsp_t router_8_9_to_magia_tile_ni_8_9_rsp;

floo_req_t magia_tile_ni_8_10_to_router_8_10_req;
floo_rsp_t router_8_10_to_magia_tile_ni_8_10_rsp;

floo_req_t magia_tile_ni_8_11_to_router_8_11_req;
floo_rsp_t router_8_11_to_magia_tile_ni_8_11_rsp;

floo_req_t magia_tile_ni_8_12_to_router_8_12_req;
floo_rsp_t router_8_12_to_magia_tile_ni_8_12_rsp;

floo_req_t magia_tile_ni_8_13_to_router_8_13_req;
floo_rsp_t router_8_13_to_magia_tile_ni_8_13_rsp;

floo_req_t magia_tile_ni_8_14_to_router_8_14_req;
floo_rsp_t router_8_14_to_magia_tile_ni_8_14_rsp;

floo_req_t magia_tile_ni_8_15_to_router_8_15_req;
floo_rsp_t router_8_15_to_magia_tile_ni_8_15_rsp;

floo_req_t magia_tile_ni_9_0_to_router_9_0_req;
floo_rsp_t router_9_0_to_magia_tile_ni_9_0_rsp;

floo_req_t magia_tile_ni_9_1_to_router_9_1_req;
floo_rsp_t router_9_1_to_magia_tile_ni_9_1_rsp;

floo_req_t magia_tile_ni_9_2_to_router_9_2_req;
floo_rsp_t router_9_2_to_magia_tile_ni_9_2_rsp;

floo_req_t magia_tile_ni_9_3_to_router_9_3_req;
floo_rsp_t router_9_3_to_magia_tile_ni_9_3_rsp;

floo_req_t magia_tile_ni_9_4_to_router_9_4_req;
floo_rsp_t router_9_4_to_magia_tile_ni_9_4_rsp;

floo_req_t magia_tile_ni_9_5_to_router_9_5_req;
floo_rsp_t router_9_5_to_magia_tile_ni_9_5_rsp;

floo_req_t magia_tile_ni_9_6_to_router_9_6_req;
floo_rsp_t router_9_6_to_magia_tile_ni_9_6_rsp;

floo_req_t magia_tile_ni_9_7_to_router_9_7_req;
floo_rsp_t router_9_7_to_magia_tile_ni_9_7_rsp;

floo_req_t magia_tile_ni_9_8_to_router_9_8_req;
floo_rsp_t router_9_8_to_magia_tile_ni_9_8_rsp;

floo_req_t magia_tile_ni_9_9_to_router_9_9_req;
floo_rsp_t router_9_9_to_magia_tile_ni_9_9_rsp;

floo_req_t magia_tile_ni_9_10_to_router_9_10_req;
floo_rsp_t router_9_10_to_magia_tile_ni_9_10_rsp;

floo_req_t magia_tile_ni_9_11_to_router_9_11_req;
floo_rsp_t router_9_11_to_magia_tile_ni_9_11_rsp;

floo_req_t magia_tile_ni_9_12_to_router_9_12_req;
floo_rsp_t router_9_12_to_magia_tile_ni_9_12_rsp;

floo_req_t magia_tile_ni_9_13_to_router_9_13_req;
floo_rsp_t router_9_13_to_magia_tile_ni_9_13_rsp;

floo_req_t magia_tile_ni_9_14_to_router_9_14_req;
floo_rsp_t router_9_14_to_magia_tile_ni_9_14_rsp;

floo_req_t magia_tile_ni_9_15_to_router_9_15_req;
floo_rsp_t router_9_15_to_magia_tile_ni_9_15_rsp;

floo_req_t magia_tile_ni_10_0_to_router_10_0_req;
floo_rsp_t router_10_0_to_magia_tile_ni_10_0_rsp;

floo_req_t magia_tile_ni_10_1_to_router_10_1_req;
floo_rsp_t router_10_1_to_magia_tile_ni_10_1_rsp;

floo_req_t magia_tile_ni_10_2_to_router_10_2_req;
floo_rsp_t router_10_2_to_magia_tile_ni_10_2_rsp;

floo_req_t magia_tile_ni_10_3_to_router_10_3_req;
floo_rsp_t router_10_3_to_magia_tile_ni_10_3_rsp;

floo_req_t magia_tile_ni_10_4_to_router_10_4_req;
floo_rsp_t router_10_4_to_magia_tile_ni_10_4_rsp;

floo_req_t magia_tile_ni_10_5_to_router_10_5_req;
floo_rsp_t router_10_5_to_magia_tile_ni_10_5_rsp;

floo_req_t magia_tile_ni_10_6_to_router_10_6_req;
floo_rsp_t router_10_6_to_magia_tile_ni_10_6_rsp;

floo_req_t magia_tile_ni_10_7_to_router_10_7_req;
floo_rsp_t router_10_7_to_magia_tile_ni_10_7_rsp;

floo_req_t magia_tile_ni_10_8_to_router_10_8_req;
floo_rsp_t router_10_8_to_magia_tile_ni_10_8_rsp;

floo_req_t magia_tile_ni_10_9_to_router_10_9_req;
floo_rsp_t router_10_9_to_magia_tile_ni_10_9_rsp;

floo_req_t magia_tile_ni_10_10_to_router_10_10_req;
floo_rsp_t router_10_10_to_magia_tile_ni_10_10_rsp;

floo_req_t magia_tile_ni_10_11_to_router_10_11_req;
floo_rsp_t router_10_11_to_magia_tile_ni_10_11_rsp;

floo_req_t magia_tile_ni_10_12_to_router_10_12_req;
floo_rsp_t router_10_12_to_magia_tile_ni_10_12_rsp;

floo_req_t magia_tile_ni_10_13_to_router_10_13_req;
floo_rsp_t router_10_13_to_magia_tile_ni_10_13_rsp;

floo_req_t magia_tile_ni_10_14_to_router_10_14_req;
floo_rsp_t router_10_14_to_magia_tile_ni_10_14_rsp;

floo_req_t magia_tile_ni_10_15_to_router_10_15_req;
floo_rsp_t router_10_15_to_magia_tile_ni_10_15_rsp;

floo_req_t magia_tile_ni_11_0_to_router_11_0_req;
floo_rsp_t router_11_0_to_magia_tile_ni_11_0_rsp;

floo_req_t magia_tile_ni_11_1_to_router_11_1_req;
floo_rsp_t router_11_1_to_magia_tile_ni_11_1_rsp;

floo_req_t magia_tile_ni_11_2_to_router_11_2_req;
floo_rsp_t router_11_2_to_magia_tile_ni_11_2_rsp;

floo_req_t magia_tile_ni_11_3_to_router_11_3_req;
floo_rsp_t router_11_3_to_magia_tile_ni_11_3_rsp;

floo_req_t magia_tile_ni_11_4_to_router_11_4_req;
floo_rsp_t router_11_4_to_magia_tile_ni_11_4_rsp;

floo_req_t magia_tile_ni_11_5_to_router_11_5_req;
floo_rsp_t router_11_5_to_magia_tile_ni_11_5_rsp;

floo_req_t magia_tile_ni_11_6_to_router_11_6_req;
floo_rsp_t router_11_6_to_magia_tile_ni_11_6_rsp;

floo_req_t magia_tile_ni_11_7_to_router_11_7_req;
floo_rsp_t router_11_7_to_magia_tile_ni_11_7_rsp;

floo_req_t magia_tile_ni_11_8_to_router_11_8_req;
floo_rsp_t router_11_8_to_magia_tile_ni_11_8_rsp;

floo_req_t magia_tile_ni_11_9_to_router_11_9_req;
floo_rsp_t router_11_9_to_magia_tile_ni_11_9_rsp;

floo_req_t magia_tile_ni_11_10_to_router_11_10_req;
floo_rsp_t router_11_10_to_magia_tile_ni_11_10_rsp;

floo_req_t magia_tile_ni_11_11_to_router_11_11_req;
floo_rsp_t router_11_11_to_magia_tile_ni_11_11_rsp;

floo_req_t magia_tile_ni_11_12_to_router_11_12_req;
floo_rsp_t router_11_12_to_magia_tile_ni_11_12_rsp;

floo_req_t magia_tile_ni_11_13_to_router_11_13_req;
floo_rsp_t router_11_13_to_magia_tile_ni_11_13_rsp;

floo_req_t magia_tile_ni_11_14_to_router_11_14_req;
floo_rsp_t router_11_14_to_magia_tile_ni_11_14_rsp;

floo_req_t magia_tile_ni_11_15_to_router_11_15_req;
floo_rsp_t router_11_15_to_magia_tile_ni_11_15_rsp;

floo_req_t magia_tile_ni_12_0_to_router_12_0_req;
floo_rsp_t router_12_0_to_magia_tile_ni_12_0_rsp;

floo_req_t magia_tile_ni_12_1_to_router_12_1_req;
floo_rsp_t router_12_1_to_magia_tile_ni_12_1_rsp;

floo_req_t magia_tile_ni_12_2_to_router_12_2_req;
floo_rsp_t router_12_2_to_magia_tile_ni_12_2_rsp;

floo_req_t magia_tile_ni_12_3_to_router_12_3_req;
floo_rsp_t router_12_3_to_magia_tile_ni_12_3_rsp;

floo_req_t magia_tile_ni_12_4_to_router_12_4_req;
floo_rsp_t router_12_4_to_magia_tile_ni_12_4_rsp;

floo_req_t magia_tile_ni_12_5_to_router_12_5_req;
floo_rsp_t router_12_5_to_magia_tile_ni_12_5_rsp;

floo_req_t magia_tile_ni_12_6_to_router_12_6_req;
floo_rsp_t router_12_6_to_magia_tile_ni_12_6_rsp;

floo_req_t magia_tile_ni_12_7_to_router_12_7_req;
floo_rsp_t router_12_7_to_magia_tile_ni_12_7_rsp;

floo_req_t magia_tile_ni_12_8_to_router_12_8_req;
floo_rsp_t router_12_8_to_magia_tile_ni_12_8_rsp;

floo_req_t magia_tile_ni_12_9_to_router_12_9_req;
floo_rsp_t router_12_9_to_magia_tile_ni_12_9_rsp;

floo_req_t magia_tile_ni_12_10_to_router_12_10_req;
floo_rsp_t router_12_10_to_magia_tile_ni_12_10_rsp;

floo_req_t magia_tile_ni_12_11_to_router_12_11_req;
floo_rsp_t router_12_11_to_magia_tile_ni_12_11_rsp;

floo_req_t magia_tile_ni_12_12_to_router_12_12_req;
floo_rsp_t router_12_12_to_magia_tile_ni_12_12_rsp;

floo_req_t magia_tile_ni_12_13_to_router_12_13_req;
floo_rsp_t router_12_13_to_magia_tile_ni_12_13_rsp;

floo_req_t magia_tile_ni_12_14_to_router_12_14_req;
floo_rsp_t router_12_14_to_magia_tile_ni_12_14_rsp;

floo_req_t magia_tile_ni_12_15_to_router_12_15_req;
floo_rsp_t router_12_15_to_magia_tile_ni_12_15_rsp;

floo_req_t magia_tile_ni_13_0_to_router_13_0_req;
floo_rsp_t router_13_0_to_magia_tile_ni_13_0_rsp;

floo_req_t magia_tile_ni_13_1_to_router_13_1_req;
floo_rsp_t router_13_1_to_magia_tile_ni_13_1_rsp;

floo_req_t magia_tile_ni_13_2_to_router_13_2_req;
floo_rsp_t router_13_2_to_magia_tile_ni_13_2_rsp;

floo_req_t magia_tile_ni_13_3_to_router_13_3_req;
floo_rsp_t router_13_3_to_magia_tile_ni_13_3_rsp;

floo_req_t magia_tile_ni_13_4_to_router_13_4_req;
floo_rsp_t router_13_4_to_magia_tile_ni_13_4_rsp;

floo_req_t magia_tile_ni_13_5_to_router_13_5_req;
floo_rsp_t router_13_5_to_magia_tile_ni_13_5_rsp;

floo_req_t magia_tile_ni_13_6_to_router_13_6_req;
floo_rsp_t router_13_6_to_magia_tile_ni_13_6_rsp;

floo_req_t magia_tile_ni_13_7_to_router_13_7_req;
floo_rsp_t router_13_7_to_magia_tile_ni_13_7_rsp;

floo_req_t magia_tile_ni_13_8_to_router_13_8_req;
floo_rsp_t router_13_8_to_magia_tile_ni_13_8_rsp;

floo_req_t magia_tile_ni_13_9_to_router_13_9_req;
floo_rsp_t router_13_9_to_magia_tile_ni_13_9_rsp;

floo_req_t magia_tile_ni_13_10_to_router_13_10_req;
floo_rsp_t router_13_10_to_magia_tile_ni_13_10_rsp;

floo_req_t magia_tile_ni_13_11_to_router_13_11_req;
floo_rsp_t router_13_11_to_magia_tile_ni_13_11_rsp;

floo_req_t magia_tile_ni_13_12_to_router_13_12_req;
floo_rsp_t router_13_12_to_magia_tile_ni_13_12_rsp;

floo_req_t magia_tile_ni_13_13_to_router_13_13_req;
floo_rsp_t router_13_13_to_magia_tile_ni_13_13_rsp;

floo_req_t magia_tile_ni_13_14_to_router_13_14_req;
floo_rsp_t router_13_14_to_magia_tile_ni_13_14_rsp;

floo_req_t magia_tile_ni_13_15_to_router_13_15_req;
floo_rsp_t router_13_15_to_magia_tile_ni_13_15_rsp;

floo_req_t magia_tile_ni_14_0_to_router_14_0_req;
floo_rsp_t router_14_0_to_magia_tile_ni_14_0_rsp;

floo_req_t magia_tile_ni_14_1_to_router_14_1_req;
floo_rsp_t router_14_1_to_magia_tile_ni_14_1_rsp;

floo_req_t magia_tile_ni_14_2_to_router_14_2_req;
floo_rsp_t router_14_2_to_magia_tile_ni_14_2_rsp;

floo_req_t magia_tile_ni_14_3_to_router_14_3_req;
floo_rsp_t router_14_3_to_magia_tile_ni_14_3_rsp;

floo_req_t magia_tile_ni_14_4_to_router_14_4_req;
floo_rsp_t router_14_4_to_magia_tile_ni_14_4_rsp;

floo_req_t magia_tile_ni_14_5_to_router_14_5_req;
floo_rsp_t router_14_5_to_magia_tile_ni_14_5_rsp;

floo_req_t magia_tile_ni_14_6_to_router_14_6_req;
floo_rsp_t router_14_6_to_magia_tile_ni_14_6_rsp;

floo_req_t magia_tile_ni_14_7_to_router_14_7_req;
floo_rsp_t router_14_7_to_magia_tile_ni_14_7_rsp;

floo_req_t magia_tile_ni_14_8_to_router_14_8_req;
floo_rsp_t router_14_8_to_magia_tile_ni_14_8_rsp;

floo_req_t magia_tile_ni_14_9_to_router_14_9_req;
floo_rsp_t router_14_9_to_magia_tile_ni_14_9_rsp;

floo_req_t magia_tile_ni_14_10_to_router_14_10_req;
floo_rsp_t router_14_10_to_magia_tile_ni_14_10_rsp;

floo_req_t magia_tile_ni_14_11_to_router_14_11_req;
floo_rsp_t router_14_11_to_magia_tile_ni_14_11_rsp;

floo_req_t magia_tile_ni_14_12_to_router_14_12_req;
floo_rsp_t router_14_12_to_magia_tile_ni_14_12_rsp;

floo_req_t magia_tile_ni_14_13_to_router_14_13_req;
floo_rsp_t router_14_13_to_magia_tile_ni_14_13_rsp;

floo_req_t magia_tile_ni_14_14_to_router_14_14_req;
floo_rsp_t router_14_14_to_magia_tile_ni_14_14_rsp;

floo_req_t magia_tile_ni_14_15_to_router_14_15_req;
floo_rsp_t router_14_15_to_magia_tile_ni_14_15_rsp;

floo_req_t magia_tile_ni_15_0_to_router_15_0_req;
floo_rsp_t router_15_0_to_magia_tile_ni_15_0_rsp;

floo_req_t magia_tile_ni_15_1_to_router_15_1_req;
floo_rsp_t router_15_1_to_magia_tile_ni_15_1_rsp;

floo_req_t magia_tile_ni_15_2_to_router_15_2_req;
floo_rsp_t router_15_2_to_magia_tile_ni_15_2_rsp;

floo_req_t magia_tile_ni_15_3_to_router_15_3_req;
floo_rsp_t router_15_3_to_magia_tile_ni_15_3_rsp;

floo_req_t magia_tile_ni_15_4_to_router_15_4_req;
floo_rsp_t router_15_4_to_magia_tile_ni_15_4_rsp;

floo_req_t magia_tile_ni_15_5_to_router_15_5_req;
floo_rsp_t router_15_5_to_magia_tile_ni_15_5_rsp;

floo_req_t magia_tile_ni_15_6_to_router_15_6_req;
floo_rsp_t router_15_6_to_magia_tile_ni_15_6_rsp;

floo_req_t magia_tile_ni_15_7_to_router_15_7_req;
floo_rsp_t router_15_7_to_magia_tile_ni_15_7_rsp;

floo_req_t magia_tile_ni_15_8_to_router_15_8_req;
floo_rsp_t router_15_8_to_magia_tile_ni_15_8_rsp;

floo_req_t magia_tile_ni_15_9_to_router_15_9_req;
floo_rsp_t router_15_9_to_magia_tile_ni_15_9_rsp;

floo_req_t magia_tile_ni_15_10_to_router_15_10_req;
floo_rsp_t router_15_10_to_magia_tile_ni_15_10_rsp;

floo_req_t magia_tile_ni_15_11_to_router_15_11_req;
floo_rsp_t router_15_11_to_magia_tile_ni_15_11_rsp;

floo_req_t magia_tile_ni_15_12_to_router_15_12_req;
floo_rsp_t router_15_12_to_magia_tile_ni_15_12_rsp;

floo_req_t magia_tile_ni_15_13_to_router_15_13_req;
floo_rsp_t router_15_13_to_magia_tile_ni_15_13_rsp;

floo_req_t magia_tile_ni_15_14_to_router_15_14_req;
floo_rsp_t router_15_14_to_magia_tile_ni_15_14_rsp;

floo_req_t magia_tile_ni_15_15_to_router_15_15_req;
floo_rsp_t router_15_15_to_magia_tile_ni_15_15_rsp;

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

floo_req_t L2_ni_8_to_router_0_8_req;
floo_rsp_t router_0_8_to_L2_ni_8_rsp;

floo_req_t L2_ni_9_to_router_0_9_req;
floo_rsp_t router_0_9_to_L2_ni_9_rsp;

floo_req_t L2_ni_10_to_router_0_10_req;
floo_rsp_t router_0_10_to_L2_ni_10_rsp;

floo_req_t L2_ni_11_to_router_0_11_req;
floo_rsp_t router_0_11_to_L2_ni_11_rsp;

floo_req_t L2_ni_12_to_router_0_12_req;
floo_rsp_t router_0_12_to_L2_ni_12_rsp;

floo_req_t L2_ni_13_to_router_0_13_req;
floo_rsp_t router_0_13_to_L2_ni_13_rsp;

floo_req_t L2_ni_14_to_router_0_14_req;
floo_rsp_t router_0_14_to_L2_ni_14_rsp;

floo_req_t L2_ni_15_to_router_0_15_req;
floo_rsp_t router_0_15_to_L2_ni_15_rsp;



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
) magia_tile_ni_0_8 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[0][8] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[0][8] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[0][8] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[0][8] ),
  .id_i             ( '{x: 1, y: 8, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_0_8_to_router_0_8_req   ),
  .floo_rsp_i       ( router_0_8_to_magia_tile_ni_0_8_rsp   ),
  .floo_req_i       ( router_0_8_to_magia_tile_ni_0_8_req   ),
  .floo_rsp_o       ( magia_tile_ni_0_8_to_router_0_8_rsp   )
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
) magia_tile_ni_0_9 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[0][9] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[0][9] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[0][9] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[0][9] ),
  .id_i             ( '{x: 1, y: 9, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_0_9_to_router_0_9_req   ),
  .floo_rsp_i       ( router_0_9_to_magia_tile_ni_0_9_rsp   ),
  .floo_req_i       ( router_0_9_to_magia_tile_ni_0_9_req   ),
  .floo_rsp_o       ( magia_tile_ni_0_9_to_router_0_9_rsp   )
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
) magia_tile_ni_0_10 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[0][10] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[0][10] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[0][10] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[0][10] ),
  .id_i             ( '{x: 1, y: 10, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_0_10_to_router_0_10_req   ),
  .floo_rsp_i       ( router_0_10_to_magia_tile_ni_0_10_rsp   ),
  .floo_req_i       ( router_0_10_to_magia_tile_ni_0_10_req   ),
  .floo_rsp_o       ( magia_tile_ni_0_10_to_router_0_10_rsp   )
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
) magia_tile_ni_0_11 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[0][11] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[0][11] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[0][11] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[0][11] ),
  .id_i             ( '{x: 1, y: 11, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_0_11_to_router_0_11_req   ),
  .floo_rsp_i       ( router_0_11_to_magia_tile_ni_0_11_rsp   ),
  .floo_req_i       ( router_0_11_to_magia_tile_ni_0_11_req   ),
  .floo_rsp_o       ( magia_tile_ni_0_11_to_router_0_11_rsp   )
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
) magia_tile_ni_0_12 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[0][12] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[0][12] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[0][12] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[0][12] ),
  .id_i             ( '{x: 1, y: 12, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_0_12_to_router_0_12_req   ),
  .floo_rsp_i       ( router_0_12_to_magia_tile_ni_0_12_rsp   ),
  .floo_req_i       ( router_0_12_to_magia_tile_ni_0_12_req   ),
  .floo_rsp_o       ( magia_tile_ni_0_12_to_router_0_12_rsp   )
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
) magia_tile_ni_0_13 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[0][13] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[0][13] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[0][13] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[0][13] ),
  .id_i             ( '{x: 1, y: 13, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_0_13_to_router_0_13_req   ),
  .floo_rsp_i       ( router_0_13_to_magia_tile_ni_0_13_rsp   ),
  .floo_req_i       ( router_0_13_to_magia_tile_ni_0_13_req   ),
  .floo_rsp_o       ( magia_tile_ni_0_13_to_router_0_13_rsp   )
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
) magia_tile_ni_0_14 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[0][14] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[0][14] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[0][14] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[0][14] ),
  .id_i             ( '{x: 1, y: 14, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_0_14_to_router_0_14_req   ),
  .floo_rsp_i       ( router_0_14_to_magia_tile_ni_0_14_rsp   ),
  .floo_req_i       ( router_0_14_to_magia_tile_ni_0_14_req   ),
  .floo_rsp_o       ( magia_tile_ni_0_14_to_router_0_14_rsp   )
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
) magia_tile_ni_0_15 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[0][15] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[0][15] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[0][15] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[0][15] ),
  .id_i             ( '{x: 1, y: 15, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_0_15_to_router_0_15_req   ),
  .floo_rsp_i       ( router_0_15_to_magia_tile_ni_0_15_rsp   ),
  .floo_req_i       ( router_0_15_to_magia_tile_ni_0_15_req   ),
  .floo_rsp_o       ( magia_tile_ni_0_15_to_router_0_15_rsp   )
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
) magia_tile_ni_1_8 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[1][8] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[1][8] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[1][8] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[1][8] ),
  .id_i             ( '{x: 2, y: 8, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_1_8_to_router_1_8_req   ),
  .floo_rsp_i       ( router_1_8_to_magia_tile_ni_1_8_rsp   ),
  .floo_req_i       ( router_1_8_to_magia_tile_ni_1_8_req   ),
  .floo_rsp_o       ( magia_tile_ni_1_8_to_router_1_8_rsp   )
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
) magia_tile_ni_1_9 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[1][9] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[1][9] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[1][9] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[1][9] ),
  .id_i             ( '{x: 2, y: 9, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_1_9_to_router_1_9_req   ),
  .floo_rsp_i       ( router_1_9_to_magia_tile_ni_1_9_rsp   ),
  .floo_req_i       ( router_1_9_to_magia_tile_ni_1_9_req   ),
  .floo_rsp_o       ( magia_tile_ni_1_9_to_router_1_9_rsp   )
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
) magia_tile_ni_1_10 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[1][10] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[1][10] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[1][10] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[1][10] ),
  .id_i             ( '{x: 2, y: 10, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_1_10_to_router_1_10_req   ),
  .floo_rsp_i       ( router_1_10_to_magia_tile_ni_1_10_rsp   ),
  .floo_req_i       ( router_1_10_to_magia_tile_ni_1_10_req   ),
  .floo_rsp_o       ( magia_tile_ni_1_10_to_router_1_10_rsp   )
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
) magia_tile_ni_1_11 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[1][11] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[1][11] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[1][11] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[1][11] ),
  .id_i             ( '{x: 2, y: 11, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_1_11_to_router_1_11_req   ),
  .floo_rsp_i       ( router_1_11_to_magia_tile_ni_1_11_rsp   ),
  .floo_req_i       ( router_1_11_to_magia_tile_ni_1_11_req   ),
  .floo_rsp_o       ( magia_tile_ni_1_11_to_router_1_11_rsp   )
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
) magia_tile_ni_1_12 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[1][12] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[1][12] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[1][12] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[1][12] ),
  .id_i             ( '{x: 2, y: 12, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_1_12_to_router_1_12_req   ),
  .floo_rsp_i       ( router_1_12_to_magia_tile_ni_1_12_rsp   ),
  .floo_req_i       ( router_1_12_to_magia_tile_ni_1_12_req   ),
  .floo_rsp_o       ( magia_tile_ni_1_12_to_router_1_12_rsp   )
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
) magia_tile_ni_1_13 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[1][13] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[1][13] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[1][13] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[1][13] ),
  .id_i             ( '{x: 2, y: 13, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_1_13_to_router_1_13_req   ),
  .floo_rsp_i       ( router_1_13_to_magia_tile_ni_1_13_rsp   ),
  .floo_req_i       ( router_1_13_to_magia_tile_ni_1_13_req   ),
  .floo_rsp_o       ( magia_tile_ni_1_13_to_router_1_13_rsp   )
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
) magia_tile_ni_1_14 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[1][14] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[1][14] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[1][14] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[1][14] ),
  .id_i             ( '{x: 2, y: 14, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_1_14_to_router_1_14_req   ),
  .floo_rsp_i       ( router_1_14_to_magia_tile_ni_1_14_rsp   ),
  .floo_req_i       ( router_1_14_to_magia_tile_ni_1_14_req   ),
  .floo_rsp_o       ( magia_tile_ni_1_14_to_router_1_14_rsp   )
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
) magia_tile_ni_1_15 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[1][15] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[1][15] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[1][15] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[1][15] ),
  .id_i             ( '{x: 2, y: 15, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_1_15_to_router_1_15_req   ),
  .floo_rsp_i       ( router_1_15_to_magia_tile_ni_1_15_rsp   ),
  .floo_req_i       ( router_1_15_to_magia_tile_ni_1_15_req   ),
  .floo_rsp_o       ( magia_tile_ni_1_15_to_router_1_15_rsp   )
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
) magia_tile_ni_2_8 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[2][8] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[2][8] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[2][8] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[2][8] ),
  .id_i             ( '{x: 3, y: 8, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_2_8_to_router_2_8_req   ),
  .floo_rsp_i       ( router_2_8_to_magia_tile_ni_2_8_rsp   ),
  .floo_req_i       ( router_2_8_to_magia_tile_ni_2_8_req   ),
  .floo_rsp_o       ( magia_tile_ni_2_8_to_router_2_8_rsp   )
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
) magia_tile_ni_2_9 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[2][9] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[2][9] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[2][9] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[2][9] ),
  .id_i             ( '{x: 3, y: 9, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_2_9_to_router_2_9_req   ),
  .floo_rsp_i       ( router_2_9_to_magia_tile_ni_2_9_rsp   ),
  .floo_req_i       ( router_2_9_to_magia_tile_ni_2_9_req   ),
  .floo_rsp_o       ( magia_tile_ni_2_9_to_router_2_9_rsp   )
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
) magia_tile_ni_2_10 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[2][10] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[2][10] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[2][10] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[2][10] ),
  .id_i             ( '{x: 3, y: 10, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_2_10_to_router_2_10_req   ),
  .floo_rsp_i       ( router_2_10_to_magia_tile_ni_2_10_rsp   ),
  .floo_req_i       ( router_2_10_to_magia_tile_ni_2_10_req   ),
  .floo_rsp_o       ( magia_tile_ni_2_10_to_router_2_10_rsp   )
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
) magia_tile_ni_2_11 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[2][11] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[2][11] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[2][11] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[2][11] ),
  .id_i             ( '{x: 3, y: 11, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_2_11_to_router_2_11_req   ),
  .floo_rsp_i       ( router_2_11_to_magia_tile_ni_2_11_rsp   ),
  .floo_req_i       ( router_2_11_to_magia_tile_ni_2_11_req   ),
  .floo_rsp_o       ( magia_tile_ni_2_11_to_router_2_11_rsp   )
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
) magia_tile_ni_2_12 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[2][12] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[2][12] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[2][12] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[2][12] ),
  .id_i             ( '{x: 3, y: 12, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_2_12_to_router_2_12_req   ),
  .floo_rsp_i       ( router_2_12_to_magia_tile_ni_2_12_rsp   ),
  .floo_req_i       ( router_2_12_to_magia_tile_ni_2_12_req   ),
  .floo_rsp_o       ( magia_tile_ni_2_12_to_router_2_12_rsp   )
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
) magia_tile_ni_2_13 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[2][13] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[2][13] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[2][13] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[2][13] ),
  .id_i             ( '{x: 3, y: 13, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_2_13_to_router_2_13_req   ),
  .floo_rsp_i       ( router_2_13_to_magia_tile_ni_2_13_rsp   ),
  .floo_req_i       ( router_2_13_to_magia_tile_ni_2_13_req   ),
  .floo_rsp_o       ( magia_tile_ni_2_13_to_router_2_13_rsp   )
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
) magia_tile_ni_2_14 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[2][14] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[2][14] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[2][14] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[2][14] ),
  .id_i             ( '{x: 3, y: 14, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_2_14_to_router_2_14_req   ),
  .floo_rsp_i       ( router_2_14_to_magia_tile_ni_2_14_rsp   ),
  .floo_req_i       ( router_2_14_to_magia_tile_ni_2_14_req   ),
  .floo_rsp_o       ( magia_tile_ni_2_14_to_router_2_14_rsp   )
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
) magia_tile_ni_2_15 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[2][15] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[2][15] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[2][15] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[2][15] ),
  .id_i             ( '{x: 3, y: 15, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_2_15_to_router_2_15_req   ),
  .floo_rsp_i       ( router_2_15_to_magia_tile_ni_2_15_rsp   ),
  .floo_req_i       ( router_2_15_to_magia_tile_ni_2_15_req   ),
  .floo_rsp_o       ( magia_tile_ni_2_15_to_router_2_15_rsp   )
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
) magia_tile_ni_3_8 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[3][8] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[3][8] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[3][8] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[3][8] ),
  .id_i             ( '{x: 4, y: 8, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_3_8_to_router_3_8_req   ),
  .floo_rsp_i       ( router_3_8_to_magia_tile_ni_3_8_rsp   ),
  .floo_req_i       ( router_3_8_to_magia_tile_ni_3_8_req   ),
  .floo_rsp_o       ( magia_tile_ni_3_8_to_router_3_8_rsp   )
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
) magia_tile_ni_3_9 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[3][9] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[3][9] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[3][9] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[3][9] ),
  .id_i             ( '{x: 4, y: 9, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_3_9_to_router_3_9_req   ),
  .floo_rsp_i       ( router_3_9_to_magia_tile_ni_3_9_rsp   ),
  .floo_req_i       ( router_3_9_to_magia_tile_ni_3_9_req   ),
  .floo_rsp_o       ( magia_tile_ni_3_9_to_router_3_9_rsp   )
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
) magia_tile_ni_3_10 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[3][10] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[3][10] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[3][10] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[3][10] ),
  .id_i             ( '{x: 4, y: 10, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_3_10_to_router_3_10_req   ),
  .floo_rsp_i       ( router_3_10_to_magia_tile_ni_3_10_rsp   ),
  .floo_req_i       ( router_3_10_to_magia_tile_ni_3_10_req   ),
  .floo_rsp_o       ( magia_tile_ni_3_10_to_router_3_10_rsp   )
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
) magia_tile_ni_3_11 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[3][11] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[3][11] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[3][11] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[3][11] ),
  .id_i             ( '{x: 4, y: 11, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_3_11_to_router_3_11_req   ),
  .floo_rsp_i       ( router_3_11_to_magia_tile_ni_3_11_rsp   ),
  .floo_req_i       ( router_3_11_to_magia_tile_ni_3_11_req   ),
  .floo_rsp_o       ( magia_tile_ni_3_11_to_router_3_11_rsp   )
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
) magia_tile_ni_3_12 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[3][12] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[3][12] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[3][12] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[3][12] ),
  .id_i             ( '{x: 4, y: 12, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_3_12_to_router_3_12_req   ),
  .floo_rsp_i       ( router_3_12_to_magia_tile_ni_3_12_rsp   ),
  .floo_req_i       ( router_3_12_to_magia_tile_ni_3_12_req   ),
  .floo_rsp_o       ( magia_tile_ni_3_12_to_router_3_12_rsp   )
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
) magia_tile_ni_3_13 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[3][13] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[3][13] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[3][13] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[3][13] ),
  .id_i             ( '{x: 4, y: 13, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_3_13_to_router_3_13_req   ),
  .floo_rsp_i       ( router_3_13_to_magia_tile_ni_3_13_rsp   ),
  .floo_req_i       ( router_3_13_to_magia_tile_ni_3_13_req   ),
  .floo_rsp_o       ( magia_tile_ni_3_13_to_router_3_13_rsp   )
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
) magia_tile_ni_3_14 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[3][14] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[3][14] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[3][14] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[3][14] ),
  .id_i             ( '{x: 4, y: 14, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_3_14_to_router_3_14_req   ),
  .floo_rsp_i       ( router_3_14_to_magia_tile_ni_3_14_rsp   ),
  .floo_req_i       ( router_3_14_to_magia_tile_ni_3_14_req   ),
  .floo_rsp_o       ( magia_tile_ni_3_14_to_router_3_14_rsp   )
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
) magia_tile_ni_3_15 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[3][15] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[3][15] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[3][15] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[3][15] ),
  .id_i             ( '{x: 4, y: 15, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_3_15_to_router_3_15_req   ),
  .floo_rsp_i       ( router_3_15_to_magia_tile_ni_3_15_rsp   ),
  .floo_req_i       ( router_3_15_to_magia_tile_ni_3_15_req   ),
  .floo_rsp_o       ( magia_tile_ni_3_15_to_router_3_15_rsp   )
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
) magia_tile_ni_4_8 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[4][8] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[4][8] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[4][8] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[4][8] ),
  .id_i             ( '{x: 5, y: 8, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_4_8_to_router_4_8_req   ),
  .floo_rsp_i       ( router_4_8_to_magia_tile_ni_4_8_rsp   ),
  .floo_req_i       ( router_4_8_to_magia_tile_ni_4_8_req   ),
  .floo_rsp_o       ( magia_tile_ni_4_8_to_router_4_8_rsp   )
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
) magia_tile_ni_4_9 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[4][9] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[4][9] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[4][9] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[4][9] ),
  .id_i             ( '{x: 5, y: 9, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_4_9_to_router_4_9_req   ),
  .floo_rsp_i       ( router_4_9_to_magia_tile_ni_4_9_rsp   ),
  .floo_req_i       ( router_4_9_to_magia_tile_ni_4_9_req   ),
  .floo_rsp_o       ( magia_tile_ni_4_9_to_router_4_9_rsp   )
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
) magia_tile_ni_4_10 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[4][10] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[4][10] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[4][10] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[4][10] ),
  .id_i             ( '{x: 5, y: 10, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_4_10_to_router_4_10_req   ),
  .floo_rsp_i       ( router_4_10_to_magia_tile_ni_4_10_rsp   ),
  .floo_req_i       ( router_4_10_to_magia_tile_ni_4_10_req   ),
  .floo_rsp_o       ( magia_tile_ni_4_10_to_router_4_10_rsp   )
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
) magia_tile_ni_4_11 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[4][11] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[4][11] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[4][11] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[4][11] ),
  .id_i             ( '{x: 5, y: 11, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_4_11_to_router_4_11_req   ),
  .floo_rsp_i       ( router_4_11_to_magia_tile_ni_4_11_rsp   ),
  .floo_req_i       ( router_4_11_to_magia_tile_ni_4_11_req   ),
  .floo_rsp_o       ( magia_tile_ni_4_11_to_router_4_11_rsp   )
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
) magia_tile_ni_4_12 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[4][12] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[4][12] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[4][12] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[4][12] ),
  .id_i             ( '{x: 5, y: 12, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_4_12_to_router_4_12_req   ),
  .floo_rsp_i       ( router_4_12_to_magia_tile_ni_4_12_rsp   ),
  .floo_req_i       ( router_4_12_to_magia_tile_ni_4_12_req   ),
  .floo_rsp_o       ( magia_tile_ni_4_12_to_router_4_12_rsp   )
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
) magia_tile_ni_4_13 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[4][13] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[4][13] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[4][13] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[4][13] ),
  .id_i             ( '{x: 5, y: 13, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_4_13_to_router_4_13_req   ),
  .floo_rsp_i       ( router_4_13_to_magia_tile_ni_4_13_rsp   ),
  .floo_req_i       ( router_4_13_to_magia_tile_ni_4_13_req   ),
  .floo_rsp_o       ( magia_tile_ni_4_13_to_router_4_13_rsp   )
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
) magia_tile_ni_4_14 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[4][14] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[4][14] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[4][14] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[4][14] ),
  .id_i             ( '{x: 5, y: 14, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_4_14_to_router_4_14_req   ),
  .floo_rsp_i       ( router_4_14_to_magia_tile_ni_4_14_rsp   ),
  .floo_req_i       ( router_4_14_to_magia_tile_ni_4_14_req   ),
  .floo_rsp_o       ( magia_tile_ni_4_14_to_router_4_14_rsp   )
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
) magia_tile_ni_4_15 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[4][15] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[4][15] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[4][15] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[4][15] ),
  .id_i             ( '{x: 5, y: 15, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_4_15_to_router_4_15_req   ),
  .floo_rsp_i       ( router_4_15_to_magia_tile_ni_4_15_rsp   ),
  .floo_req_i       ( router_4_15_to_magia_tile_ni_4_15_req   ),
  .floo_rsp_o       ( magia_tile_ni_4_15_to_router_4_15_rsp   )
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
) magia_tile_ni_5_8 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[5][8] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[5][8] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[5][8] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[5][8] ),
  .id_i             ( '{x: 6, y: 8, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_5_8_to_router_5_8_req   ),
  .floo_rsp_i       ( router_5_8_to_magia_tile_ni_5_8_rsp   ),
  .floo_req_i       ( router_5_8_to_magia_tile_ni_5_8_req   ),
  .floo_rsp_o       ( magia_tile_ni_5_8_to_router_5_8_rsp   )
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
) magia_tile_ni_5_9 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[5][9] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[5][9] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[5][9] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[5][9] ),
  .id_i             ( '{x: 6, y: 9, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_5_9_to_router_5_9_req   ),
  .floo_rsp_i       ( router_5_9_to_magia_tile_ni_5_9_rsp   ),
  .floo_req_i       ( router_5_9_to_magia_tile_ni_5_9_req   ),
  .floo_rsp_o       ( magia_tile_ni_5_9_to_router_5_9_rsp   )
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
) magia_tile_ni_5_10 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[5][10] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[5][10] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[5][10] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[5][10] ),
  .id_i             ( '{x: 6, y: 10, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_5_10_to_router_5_10_req   ),
  .floo_rsp_i       ( router_5_10_to_magia_tile_ni_5_10_rsp   ),
  .floo_req_i       ( router_5_10_to_magia_tile_ni_5_10_req   ),
  .floo_rsp_o       ( magia_tile_ni_5_10_to_router_5_10_rsp   )
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
) magia_tile_ni_5_11 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[5][11] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[5][11] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[5][11] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[5][11] ),
  .id_i             ( '{x: 6, y: 11, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_5_11_to_router_5_11_req   ),
  .floo_rsp_i       ( router_5_11_to_magia_tile_ni_5_11_rsp   ),
  .floo_req_i       ( router_5_11_to_magia_tile_ni_5_11_req   ),
  .floo_rsp_o       ( magia_tile_ni_5_11_to_router_5_11_rsp   )
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
) magia_tile_ni_5_12 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[5][12] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[5][12] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[5][12] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[5][12] ),
  .id_i             ( '{x: 6, y: 12, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_5_12_to_router_5_12_req   ),
  .floo_rsp_i       ( router_5_12_to_magia_tile_ni_5_12_rsp   ),
  .floo_req_i       ( router_5_12_to_magia_tile_ni_5_12_req   ),
  .floo_rsp_o       ( magia_tile_ni_5_12_to_router_5_12_rsp   )
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
) magia_tile_ni_5_13 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[5][13] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[5][13] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[5][13] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[5][13] ),
  .id_i             ( '{x: 6, y: 13, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_5_13_to_router_5_13_req   ),
  .floo_rsp_i       ( router_5_13_to_magia_tile_ni_5_13_rsp   ),
  .floo_req_i       ( router_5_13_to_magia_tile_ni_5_13_req   ),
  .floo_rsp_o       ( magia_tile_ni_5_13_to_router_5_13_rsp   )
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
) magia_tile_ni_5_14 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[5][14] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[5][14] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[5][14] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[5][14] ),
  .id_i             ( '{x: 6, y: 14, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_5_14_to_router_5_14_req   ),
  .floo_rsp_i       ( router_5_14_to_magia_tile_ni_5_14_rsp   ),
  .floo_req_i       ( router_5_14_to_magia_tile_ni_5_14_req   ),
  .floo_rsp_o       ( magia_tile_ni_5_14_to_router_5_14_rsp   )
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
) magia_tile_ni_5_15 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[5][15] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[5][15] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[5][15] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[5][15] ),
  .id_i             ( '{x: 6, y: 15, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_5_15_to_router_5_15_req   ),
  .floo_rsp_i       ( router_5_15_to_magia_tile_ni_5_15_rsp   ),
  .floo_req_i       ( router_5_15_to_magia_tile_ni_5_15_req   ),
  .floo_rsp_o       ( magia_tile_ni_5_15_to_router_5_15_rsp   )
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
) magia_tile_ni_6_8 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[6][8] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[6][8] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[6][8] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[6][8] ),
  .id_i             ( '{x: 7, y: 8, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_6_8_to_router_6_8_req   ),
  .floo_rsp_i       ( router_6_8_to_magia_tile_ni_6_8_rsp   ),
  .floo_req_i       ( router_6_8_to_magia_tile_ni_6_8_req   ),
  .floo_rsp_o       ( magia_tile_ni_6_8_to_router_6_8_rsp   )
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
) magia_tile_ni_6_9 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[6][9] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[6][9] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[6][9] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[6][9] ),
  .id_i             ( '{x: 7, y: 9, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_6_9_to_router_6_9_req   ),
  .floo_rsp_i       ( router_6_9_to_magia_tile_ni_6_9_rsp   ),
  .floo_req_i       ( router_6_9_to_magia_tile_ni_6_9_req   ),
  .floo_rsp_o       ( magia_tile_ni_6_9_to_router_6_9_rsp   )
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
) magia_tile_ni_6_10 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[6][10] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[6][10] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[6][10] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[6][10] ),
  .id_i             ( '{x: 7, y: 10, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_6_10_to_router_6_10_req   ),
  .floo_rsp_i       ( router_6_10_to_magia_tile_ni_6_10_rsp   ),
  .floo_req_i       ( router_6_10_to_magia_tile_ni_6_10_req   ),
  .floo_rsp_o       ( magia_tile_ni_6_10_to_router_6_10_rsp   )
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
) magia_tile_ni_6_11 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[6][11] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[6][11] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[6][11] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[6][11] ),
  .id_i             ( '{x: 7, y: 11, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_6_11_to_router_6_11_req   ),
  .floo_rsp_i       ( router_6_11_to_magia_tile_ni_6_11_rsp   ),
  .floo_req_i       ( router_6_11_to_magia_tile_ni_6_11_req   ),
  .floo_rsp_o       ( magia_tile_ni_6_11_to_router_6_11_rsp   )
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
) magia_tile_ni_6_12 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[6][12] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[6][12] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[6][12] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[6][12] ),
  .id_i             ( '{x: 7, y: 12, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_6_12_to_router_6_12_req   ),
  .floo_rsp_i       ( router_6_12_to_magia_tile_ni_6_12_rsp   ),
  .floo_req_i       ( router_6_12_to_magia_tile_ni_6_12_req   ),
  .floo_rsp_o       ( magia_tile_ni_6_12_to_router_6_12_rsp   )
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
) magia_tile_ni_6_13 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[6][13] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[6][13] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[6][13] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[6][13] ),
  .id_i             ( '{x: 7, y: 13, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_6_13_to_router_6_13_req   ),
  .floo_rsp_i       ( router_6_13_to_magia_tile_ni_6_13_rsp   ),
  .floo_req_i       ( router_6_13_to_magia_tile_ni_6_13_req   ),
  .floo_rsp_o       ( magia_tile_ni_6_13_to_router_6_13_rsp   )
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
) magia_tile_ni_6_14 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[6][14] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[6][14] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[6][14] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[6][14] ),
  .id_i             ( '{x: 7, y: 14, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_6_14_to_router_6_14_req   ),
  .floo_rsp_i       ( router_6_14_to_magia_tile_ni_6_14_rsp   ),
  .floo_req_i       ( router_6_14_to_magia_tile_ni_6_14_req   ),
  .floo_rsp_o       ( magia_tile_ni_6_14_to_router_6_14_rsp   )
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
) magia_tile_ni_6_15 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[6][15] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[6][15] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[6][15] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[6][15] ),
  .id_i             ( '{x: 7, y: 15, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_6_15_to_router_6_15_req   ),
  .floo_rsp_i       ( router_6_15_to_magia_tile_ni_6_15_rsp   ),
  .floo_req_i       ( router_6_15_to_magia_tile_ni_6_15_req   ),
  .floo_rsp_o       ( magia_tile_ni_6_15_to_router_6_15_rsp   )
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
) magia_tile_ni_7_8 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[7][8] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[7][8] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[7][8] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[7][8] ),
  .id_i             ( '{x: 8, y: 8, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_7_8_to_router_7_8_req   ),
  .floo_rsp_i       ( router_7_8_to_magia_tile_ni_7_8_rsp   ),
  .floo_req_i       ( router_7_8_to_magia_tile_ni_7_8_req   ),
  .floo_rsp_o       ( magia_tile_ni_7_8_to_router_7_8_rsp   )
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
) magia_tile_ni_7_9 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[7][9] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[7][9] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[7][9] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[7][9] ),
  .id_i             ( '{x: 8, y: 9, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_7_9_to_router_7_9_req   ),
  .floo_rsp_i       ( router_7_9_to_magia_tile_ni_7_9_rsp   ),
  .floo_req_i       ( router_7_9_to_magia_tile_ni_7_9_req   ),
  .floo_rsp_o       ( magia_tile_ni_7_9_to_router_7_9_rsp   )
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
) magia_tile_ni_7_10 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[7][10] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[7][10] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[7][10] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[7][10] ),
  .id_i             ( '{x: 8, y: 10, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_7_10_to_router_7_10_req   ),
  .floo_rsp_i       ( router_7_10_to_magia_tile_ni_7_10_rsp   ),
  .floo_req_i       ( router_7_10_to_magia_tile_ni_7_10_req   ),
  .floo_rsp_o       ( magia_tile_ni_7_10_to_router_7_10_rsp   )
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
) magia_tile_ni_7_11 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[7][11] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[7][11] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[7][11] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[7][11] ),
  .id_i             ( '{x: 8, y: 11, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_7_11_to_router_7_11_req   ),
  .floo_rsp_i       ( router_7_11_to_magia_tile_ni_7_11_rsp   ),
  .floo_req_i       ( router_7_11_to_magia_tile_ni_7_11_req   ),
  .floo_rsp_o       ( magia_tile_ni_7_11_to_router_7_11_rsp   )
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
) magia_tile_ni_7_12 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[7][12] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[7][12] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[7][12] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[7][12] ),
  .id_i             ( '{x: 8, y: 12, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_7_12_to_router_7_12_req   ),
  .floo_rsp_i       ( router_7_12_to_magia_tile_ni_7_12_rsp   ),
  .floo_req_i       ( router_7_12_to_magia_tile_ni_7_12_req   ),
  .floo_rsp_o       ( magia_tile_ni_7_12_to_router_7_12_rsp   )
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
) magia_tile_ni_7_13 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[7][13] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[7][13] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[7][13] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[7][13] ),
  .id_i             ( '{x: 8, y: 13, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_7_13_to_router_7_13_req   ),
  .floo_rsp_i       ( router_7_13_to_magia_tile_ni_7_13_rsp   ),
  .floo_req_i       ( router_7_13_to_magia_tile_ni_7_13_req   ),
  .floo_rsp_o       ( magia_tile_ni_7_13_to_router_7_13_rsp   )
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
) magia_tile_ni_7_14 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[7][14] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[7][14] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[7][14] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[7][14] ),
  .id_i             ( '{x: 8, y: 14, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_7_14_to_router_7_14_req   ),
  .floo_rsp_i       ( router_7_14_to_magia_tile_ni_7_14_rsp   ),
  .floo_req_i       ( router_7_14_to_magia_tile_ni_7_14_req   ),
  .floo_rsp_o       ( magia_tile_ni_7_14_to_router_7_14_rsp   )
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
) magia_tile_ni_7_15 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[7][15] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[7][15] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[7][15] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[7][15] ),
  .id_i             ( '{x: 8, y: 15, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_7_15_to_router_7_15_req   ),
  .floo_rsp_i       ( router_7_15_to_magia_tile_ni_7_15_rsp   ),
  .floo_req_i       ( router_7_15_to_magia_tile_ni_7_15_req   ),
  .floo_rsp_o       ( magia_tile_ni_7_15_to_router_7_15_rsp   )
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
) magia_tile_ni_8_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[8][0] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[8][0] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[8][0] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[8][0] ),
  .id_i             ( '{x: 9, y: 0, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_8_0_to_router_8_0_req   ),
  .floo_rsp_i       ( router_8_0_to_magia_tile_ni_8_0_rsp   ),
  .floo_req_i       ( router_8_0_to_magia_tile_ni_8_0_req   ),
  .floo_rsp_o       ( magia_tile_ni_8_0_to_router_8_0_rsp   )
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
) magia_tile_ni_8_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[8][1] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[8][1] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[8][1] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[8][1] ),
  .id_i             ( '{x: 9, y: 1, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_8_1_to_router_8_1_req   ),
  .floo_rsp_i       ( router_8_1_to_magia_tile_ni_8_1_rsp   ),
  .floo_req_i       ( router_8_1_to_magia_tile_ni_8_1_req   ),
  .floo_rsp_o       ( magia_tile_ni_8_1_to_router_8_1_rsp   )
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
) magia_tile_ni_8_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[8][2] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[8][2] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[8][2] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[8][2] ),
  .id_i             ( '{x: 9, y: 2, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_8_2_to_router_8_2_req   ),
  .floo_rsp_i       ( router_8_2_to_magia_tile_ni_8_2_rsp   ),
  .floo_req_i       ( router_8_2_to_magia_tile_ni_8_2_req   ),
  .floo_rsp_o       ( magia_tile_ni_8_2_to_router_8_2_rsp   )
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
) magia_tile_ni_8_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[8][3] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[8][3] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[8][3] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[8][3] ),
  .id_i             ( '{x: 9, y: 3, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_8_3_to_router_8_3_req   ),
  .floo_rsp_i       ( router_8_3_to_magia_tile_ni_8_3_rsp   ),
  .floo_req_i       ( router_8_3_to_magia_tile_ni_8_3_req   ),
  .floo_rsp_o       ( magia_tile_ni_8_3_to_router_8_3_rsp   )
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
) magia_tile_ni_8_4 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[8][4] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[8][4] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[8][4] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[8][4] ),
  .id_i             ( '{x: 9, y: 4, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_8_4_to_router_8_4_req   ),
  .floo_rsp_i       ( router_8_4_to_magia_tile_ni_8_4_rsp   ),
  .floo_req_i       ( router_8_4_to_magia_tile_ni_8_4_req   ),
  .floo_rsp_o       ( magia_tile_ni_8_4_to_router_8_4_rsp   )
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
) magia_tile_ni_8_5 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[8][5] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[8][5] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[8][5] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[8][5] ),
  .id_i             ( '{x: 9, y: 5, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_8_5_to_router_8_5_req   ),
  .floo_rsp_i       ( router_8_5_to_magia_tile_ni_8_5_rsp   ),
  .floo_req_i       ( router_8_5_to_magia_tile_ni_8_5_req   ),
  .floo_rsp_o       ( magia_tile_ni_8_5_to_router_8_5_rsp   )
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
) magia_tile_ni_8_6 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[8][6] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[8][6] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[8][6] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[8][6] ),
  .id_i             ( '{x: 9, y: 6, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_8_6_to_router_8_6_req   ),
  .floo_rsp_i       ( router_8_6_to_magia_tile_ni_8_6_rsp   ),
  .floo_req_i       ( router_8_6_to_magia_tile_ni_8_6_req   ),
  .floo_rsp_o       ( magia_tile_ni_8_6_to_router_8_6_rsp   )
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
) magia_tile_ni_8_7 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[8][7] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[8][7] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[8][7] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[8][7] ),
  .id_i             ( '{x: 9, y: 7, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_8_7_to_router_8_7_req   ),
  .floo_rsp_i       ( router_8_7_to_magia_tile_ni_8_7_rsp   ),
  .floo_req_i       ( router_8_7_to_magia_tile_ni_8_7_req   ),
  .floo_rsp_o       ( magia_tile_ni_8_7_to_router_8_7_rsp   )
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
) magia_tile_ni_8_8 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[8][8] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[8][8] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[8][8] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[8][8] ),
  .id_i             ( '{x: 9, y: 8, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_8_8_to_router_8_8_req   ),
  .floo_rsp_i       ( router_8_8_to_magia_tile_ni_8_8_rsp   ),
  .floo_req_i       ( router_8_8_to_magia_tile_ni_8_8_req   ),
  .floo_rsp_o       ( magia_tile_ni_8_8_to_router_8_8_rsp   )
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
) magia_tile_ni_8_9 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[8][9] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[8][9] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[8][9] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[8][9] ),
  .id_i             ( '{x: 9, y: 9, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_8_9_to_router_8_9_req   ),
  .floo_rsp_i       ( router_8_9_to_magia_tile_ni_8_9_rsp   ),
  .floo_req_i       ( router_8_9_to_magia_tile_ni_8_9_req   ),
  .floo_rsp_o       ( magia_tile_ni_8_9_to_router_8_9_rsp   )
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
) magia_tile_ni_8_10 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[8][10] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[8][10] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[8][10] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[8][10] ),
  .id_i             ( '{x: 9, y: 10, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_8_10_to_router_8_10_req   ),
  .floo_rsp_i       ( router_8_10_to_magia_tile_ni_8_10_rsp   ),
  .floo_req_i       ( router_8_10_to_magia_tile_ni_8_10_req   ),
  .floo_rsp_o       ( magia_tile_ni_8_10_to_router_8_10_rsp   )
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
) magia_tile_ni_8_11 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[8][11] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[8][11] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[8][11] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[8][11] ),
  .id_i             ( '{x: 9, y: 11, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_8_11_to_router_8_11_req   ),
  .floo_rsp_i       ( router_8_11_to_magia_tile_ni_8_11_rsp   ),
  .floo_req_i       ( router_8_11_to_magia_tile_ni_8_11_req   ),
  .floo_rsp_o       ( magia_tile_ni_8_11_to_router_8_11_rsp   )
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
) magia_tile_ni_8_12 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[8][12] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[8][12] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[8][12] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[8][12] ),
  .id_i             ( '{x: 9, y: 12, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_8_12_to_router_8_12_req   ),
  .floo_rsp_i       ( router_8_12_to_magia_tile_ni_8_12_rsp   ),
  .floo_req_i       ( router_8_12_to_magia_tile_ni_8_12_req   ),
  .floo_rsp_o       ( magia_tile_ni_8_12_to_router_8_12_rsp   )
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
) magia_tile_ni_8_13 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[8][13] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[8][13] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[8][13] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[8][13] ),
  .id_i             ( '{x: 9, y: 13, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_8_13_to_router_8_13_req   ),
  .floo_rsp_i       ( router_8_13_to_magia_tile_ni_8_13_rsp   ),
  .floo_req_i       ( router_8_13_to_magia_tile_ni_8_13_req   ),
  .floo_rsp_o       ( magia_tile_ni_8_13_to_router_8_13_rsp   )
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
) magia_tile_ni_8_14 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[8][14] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[8][14] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[8][14] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[8][14] ),
  .id_i             ( '{x: 9, y: 14, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_8_14_to_router_8_14_req   ),
  .floo_rsp_i       ( router_8_14_to_magia_tile_ni_8_14_rsp   ),
  .floo_req_i       ( router_8_14_to_magia_tile_ni_8_14_req   ),
  .floo_rsp_o       ( magia_tile_ni_8_14_to_router_8_14_rsp   )
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
) magia_tile_ni_8_15 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[8][15] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[8][15] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[8][15] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[8][15] ),
  .id_i             ( '{x: 9, y: 15, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_8_15_to_router_8_15_req   ),
  .floo_rsp_i       ( router_8_15_to_magia_tile_ni_8_15_rsp   ),
  .floo_req_i       ( router_8_15_to_magia_tile_ni_8_15_req   ),
  .floo_rsp_o       ( magia_tile_ni_8_15_to_router_8_15_rsp   )
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
) magia_tile_ni_9_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[9][0] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[9][0] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[9][0] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[9][0] ),
  .id_i             ( '{x: 10, y: 0, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_9_0_to_router_9_0_req   ),
  .floo_rsp_i       ( router_9_0_to_magia_tile_ni_9_0_rsp   ),
  .floo_req_i       ( router_9_0_to_magia_tile_ni_9_0_req   ),
  .floo_rsp_o       ( magia_tile_ni_9_0_to_router_9_0_rsp   )
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
) magia_tile_ni_9_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[9][1] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[9][1] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[9][1] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[9][1] ),
  .id_i             ( '{x: 10, y: 1, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_9_1_to_router_9_1_req   ),
  .floo_rsp_i       ( router_9_1_to_magia_tile_ni_9_1_rsp   ),
  .floo_req_i       ( router_9_1_to_magia_tile_ni_9_1_req   ),
  .floo_rsp_o       ( magia_tile_ni_9_1_to_router_9_1_rsp   )
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
) magia_tile_ni_9_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[9][2] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[9][2] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[9][2] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[9][2] ),
  .id_i             ( '{x: 10, y: 2, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_9_2_to_router_9_2_req   ),
  .floo_rsp_i       ( router_9_2_to_magia_tile_ni_9_2_rsp   ),
  .floo_req_i       ( router_9_2_to_magia_tile_ni_9_2_req   ),
  .floo_rsp_o       ( magia_tile_ni_9_2_to_router_9_2_rsp   )
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
) magia_tile_ni_9_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[9][3] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[9][3] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[9][3] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[9][3] ),
  .id_i             ( '{x: 10, y: 3, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_9_3_to_router_9_3_req   ),
  .floo_rsp_i       ( router_9_3_to_magia_tile_ni_9_3_rsp   ),
  .floo_req_i       ( router_9_3_to_magia_tile_ni_9_3_req   ),
  .floo_rsp_o       ( magia_tile_ni_9_3_to_router_9_3_rsp   )
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
) magia_tile_ni_9_4 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[9][4] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[9][4] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[9][4] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[9][4] ),
  .id_i             ( '{x: 10, y: 4, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_9_4_to_router_9_4_req   ),
  .floo_rsp_i       ( router_9_4_to_magia_tile_ni_9_4_rsp   ),
  .floo_req_i       ( router_9_4_to_magia_tile_ni_9_4_req   ),
  .floo_rsp_o       ( magia_tile_ni_9_4_to_router_9_4_rsp   )
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
) magia_tile_ni_9_5 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[9][5] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[9][5] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[9][5] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[9][5] ),
  .id_i             ( '{x: 10, y: 5, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_9_5_to_router_9_5_req   ),
  .floo_rsp_i       ( router_9_5_to_magia_tile_ni_9_5_rsp   ),
  .floo_req_i       ( router_9_5_to_magia_tile_ni_9_5_req   ),
  .floo_rsp_o       ( magia_tile_ni_9_5_to_router_9_5_rsp   )
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
) magia_tile_ni_9_6 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[9][6] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[9][6] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[9][6] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[9][6] ),
  .id_i             ( '{x: 10, y: 6, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_9_6_to_router_9_6_req   ),
  .floo_rsp_i       ( router_9_6_to_magia_tile_ni_9_6_rsp   ),
  .floo_req_i       ( router_9_6_to_magia_tile_ni_9_6_req   ),
  .floo_rsp_o       ( magia_tile_ni_9_6_to_router_9_6_rsp   )
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
) magia_tile_ni_9_7 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[9][7] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[9][7] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[9][7] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[9][7] ),
  .id_i             ( '{x: 10, y: 7, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_9_7_to_router_9_7_req   ),
  .floo_rsp_i       ( router_9_7_to_magia_tile_ni_9_7_rsp   ),
  .floo_req_i       ( router_9_7_to_magia_tile_ni_9_7_req   ),
  .floo_rsp_o       ( magia_tile_ni_9_7_to_router_9_7_rsp   )
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
) magia_tile_ni_9_8 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[9][8] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[9][8] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[9][8] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[9][8] ),
  .id_i             ( '{x: 10, y: 8, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_9_8_to_router_9_8_req   ),
  .floo_rsp_i       ( router_9_8_to_magia_tile_ni_9_8_rsp   ),
  .floo_req_i       ( router_9_8_to_magia_tile_ni_9_8_req   ),
  .floo_rsp_o       ( magia_tile_ni_9_8_to_router_9_8_rsp   )
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
) magia_tile_ni_9_9 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[9][9] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[9][9] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[9][9] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[9][9] ),
  .id_i             ( '{x: 10, y: 9, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_9_9_to_router_9_9_req   ),
  .floo_rsp_i       ( router_9_9_to_magia_tile_ni_9_9_rsp   ),
  .floo_req_i       ( router_9_9_to_magia_tile_ni_9_9_req   ),
  .floo_rsp_o       ( magia_tile_ni_9_9_to_router_9_9_rsp   )
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
) magia_tile_ni_9_10 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[9][10] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[9][10] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[9][10] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[9][10] ),
  .id_i             ( '{x: 10, y: 10, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_9_10_to_router_9_10_req   ),
  .floo_rsp_i       ( router_9_10_to_magia_tile_ni_9_10_rsp   ),
  .floo_req_i       ( router_9_10_to_magia_tile_ni_9_10_req   ),
  .floo_rsp_o       ( magia_tile_ni_9_10_to_router_9_10_rsp   )
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
) magia_tile_ni_9_11 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[9][11] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[9][11] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[9][11] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[9][11] ),
  .id_i             ( '{x: 10, y: 11, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_9_11_to_router_9_11_req   ),
  .floo_rsp_i       ( router_9_11_to_magia_tile_ni_9_11_rsp   ),
  .floo_req_i       ( router_9_11_to_magia_tile_ni_9_11_req   ),
  .floo_rsp_o       ( magia_tile_ni_9_11_to_router_9_11_rsp   )
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
) magia_tile_ni_9_12 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[9][12] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[9][12] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[9][12] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[9][12] ),
  .id_i             ( '{x: 10, y: 12, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_9_12_to_router_9_12_req   ),
  .floo_rsp_i       ( router_9_12_to_magia_tile_ni_9_12_rsp   ),
  .floo_req_i       ( router_9_12_to_magia_tile_ni_9_12_req   ),
  .floo_rsp_o       ( magia_tile_ni_9_12_to_router_9_12_rsp   )
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
) magia_tile_ni_9_13 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[9][13] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[9][13] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[9][13] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[9][13] ),
  .id_i             ( '{x: 10, y: 13, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_9_13_to_router_9_13_req   ),
  .floo_rsp_i       ( router_9_13_to_magia_tile_ni_9_13_rsp   ),
  .floo_req_i       ( router_9_13_to_magia_tile_ni_9_13_req   ),
  .floo_rsp_o       ( magia_tile_ni_9_13_to_router_9_13_rsp   )
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
) magia_tile_ni_9_14 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[9][14] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[9][14] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[9][14] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[9][14] ),
  .id_i             ( '{x: 10, y: 14, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_9_14_to_router_9_14_req   ),
  .floo_rsp_i       ( router_9_14_to_magia_tile_ni_9_14_rsp   ),
  .floo_req_i       ( router_9_14_to_magia_tile_ni_9_14_req   ),
  .floo_rsp_o       ( magia_tile_ni_9_14_to_router_9_14_rsp   )
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
) magia_tile_ni_9_15 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[9][15] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[9][15] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[9][15] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[9][15] ),
  .id_i             ( '{x: 10, y: 15, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_9_15_to_router_9_15_req   ),
  .floo_rsp_i       ( router_9_15_to_magia_tile_ni_9_15_rsp   ),
  .floo_req_i       ( router_9_15_to_magia_tile_ni_9_15_req   ),
  .floo_rsp_o       ( magia_tile_ni_9_15_to_router_9_15_rsp   )
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
) magia_tile_ni_10_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[10][0] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[10][0] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[10][0] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[10][0] ),
  .id_i             ( '{x: 11, y: 0, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_10_0_to_router_10_0_req   ),
  .floo_rsp_i       ( router_10_0_to_magia_tile_ni_10_0_rsp   ),
  .floo_req_i       ( router_10_0_to_magia_tile_ni_10_0_req   ),
  .floo_rsp_o       ( magia_tile_ni_10_0_to_router_10_0_rsp   )
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
) magia_tile_ni_10_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[10][1] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[10][1] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[10][1] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[10][1] ),
  .id_i             ( '{x: 11, y: 1, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_10_1_to_router_10_1_req   ),
  .floo_rsp_i       ( router_10_1_to_magia_tile_ni_10_1_rsp   ),
  .floo_req_i       ( router_10_1_to_magia_tile_ni_10_1_req   ),
  .floo_rsp_o       ( magia_tile_ni_10_1_to_router_10_1_rsp   )
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
) magia_tile_ni_10_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[10][2] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[10][2] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[10][2] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[10][2] ),
  .id_i             ( '{x: 11, y: 2, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_10_2_to_router_10_2_req   ),
  .floo_rsp_i       ( router_10_2_to_magia_tile_ni_10_2_rsp   ),
  .floo_req_i       ( router_10_2_to_magia_tile_ni_10_2_req   ),
  .floo_rsp_o       ( magia_tile_ni_10_2_to_router_10_2_rsp   )
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
) magia_tile_ni_10_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[10][3] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[10][3] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[10][3] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[10][3] ),
  .id_i             ( '{x: 11, y: 3, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_10_3_to_router_10_3_req   ),
  .floo_rsp_i       ( router_10_3_to_magia_tile_ni_10_3_rsp   ),
  .floo_req_i       ( router_10_3_to_magia_tile_ni_10_3_req   ),
  .floo_rsp_o       ( magia_tile_ni_10_3_to_router_10_3_rsp   )
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
) magia_tile_ni_10_4 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[10][4] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[10][4] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[10][4] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[10][4] ),
  .id_i             ( '{x: 11, y: 4, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_10_4_to_router_10_4_req   ),
  .floo_rsp_i       ( router_10_4_to_magia_tile_ni_10_4_rsp   ),
  .floo_req_i       ( router_10_4_to_magia_tile_ni_10_4_req   ),
  .floo_rsp_o       ( magia_tile_ni_10_4_to_router_10_4_rsp   )
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
) magia_tile_ni_10_5 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[10][5] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[10][5] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[10][5] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[10][5] ),
  .id_i             ( '{x: 11, y: 5, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_10_5_to_router_10_5_req   ),
  .floo_rsp_i       ( router_10_5_to_magia_tile_ni_10_5_rsp   ),
  .floo_req_i       ( router_10_5_to_magia_tile_ni_10_5_req   ),
  .floo_rsp_o       ( magia_tile_ni_10_5_to_router_10_5_rsp   )
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
) magia_tile_ni_10_6 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[10][6] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[10][6] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[10][6] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[10][6] ),
  .id_i             ( '{x: 11, y: 6, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_10_6_to_router_10_6_req   ),
  .floo_rsp_i       ( router_10_6_to_magia_tile_ni_10_6_rsp   ),
  .floo_req_i       ( router_10_6_to_magia_tile_ni_10_6_req   ),
  .floo_rsp_o       ( magia_tile_ni_10_6_to_router_10_6_rsp   )
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
) magia_tile_ni_10_7 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[10][7] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[10][7] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[10][7] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[10][7] ),
  .id_i             ( '{x: 11, y: 7, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_10_7_to_router_10_7_req   ),
  .floo_rsp_i       ( router_10_7_to_magia_tile_ni_10_7_rsp   ),
  .floo_req_i       ( router_10_7_to_magia_tile_ni_10_7_req   ),
  .floo_rsp_o       ( magia_tile_ni_10_7_to_router_10_7_rsp   )
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
) magia_tile_ni_10_8 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[10][8] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[10][8] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[10][8] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[10][8] ),
  .id_i             ( '{x: 11, y: 8, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_10_8_to_router_10_8_req   ),
  .floo_rsp_i       ( router_10_8_to_magia_tile_ni_10_8_rsp   ),
  .floo_req_i       ( router_10_8_to_magia_tile_ni_10_8_req   ),
  .floo_rsp_o       ( magia_tile_ni_10_8_to_router_10_8_rsp   )
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
) magia_tile_ni_10_9 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[10][9] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[10][9] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[10][9] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[10][9] ),
  .id_i             ( '{x: 11, y: 9, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_10_9_to_router_10_9_req   ),
  .floo_rsp_i       ( router_10_9_to_magia_tile_ni_10_9_rsp   ),
  .floo_req_i       ( router_10_9_to_magia_tile_ni_10_9_req   ),
  .floo_rsp_o       ( magia_tile_ni_10_9_to_router_10_9_rsp   )
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
) magia_tile_ni_10_10 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[10][10] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[10][10] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[10][10] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[10][10] ),
  .id_i             ( '{x: 11, y: 10, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_10_10_to_router_10_10_req   ),
  .floo_rsp_i       ( router_10_10_to_magia_tile_ni_10_10_rsp   ),
  .floo_req_i       ( router_10_10_to_magia_tile_ni_10_10_req   ),
  .floo_rsp_o       ( magia_tile_ni_10_10_to_router_10_10_rsp   )
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
) magia_tile_ni_10_11 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[10][11] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[10][11] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[10][11] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[10][11] ),
  .id_i             ( '{x: 11, y: 11, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_10_11_to_router_10_11_req   ),
  .floo_rsp_i       ( router_10_11_to_magia_tile_ni_10_11_rsp   ),
  .floo_req_i       ( router_10_11_to_magia_tile_ni_10_11_req   ),
  .floo_rsp_o       ( magia_tile_ni_10_11_to_router_10_11_rsp   )
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
) magia_tile_ni_10_12 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[10][12] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[10][12] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[10][12] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[10][12] ),
  .id_i             ( '{x: 11, y: 12, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_10_12_to_router_10_12_req   ),
  .floo_rsp_i       ( router_10_12_to_magia_tile_ni_10_12_rsp   ),
  .floo_req_i       ( router_10_12_to_magia_tile_ni_10_12_req   ),
  .floo_rsp_o       ( magia_tile_ni_10_12_to_router_10_12_rsp   )
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
) magia_tile_ni_10_13 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[10][13] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[10][13] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[10][13] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[10][13] ),
  .id_i             ( '{x: 11, y: 13, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_10_13_to_router_10_13_req   ),
  .floo_rsp_i       ( router_10_13_to_magia_tile_ni_10_13_rsp   ),
  .floo_req_i       ( router_10_13_to_magia_tile_ni_10_13_req   ),
  .floo_rsp_o       ( magia_tile_ni_10_13_to_router_10_13_rsp   )
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
) magia_tile_ni_10_14 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[10][14] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[10][14] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[10][14] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[10][14] ),
  .id_i             ( '{x: 11, y: 14, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_10_14_to_router_10_14_req   ),
  .floo_rsp_i       ( router_10_14_to_magia_tile_ni_10_14_rsp   ),
  .floo_req_i       ( router_10_14_to_magia_tile_ni_10_14_req   ),
  .floo_rsp_o       ( magia_tile_ni_10_14_to_router_10_14_rsp   )
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
) magia_tile_ni_10_15 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[10][15] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[10][15] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[10][15] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[10][15] ),
  .id_i             ( '{x: 11, y: 15, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_10_15_to_router_10_15_req   ),
  .floo_rsp_i       ( router_10_15_to_magia_tile_ni_10_15_rsp   ),
  .floo_req_i       ( router_10_15_to_magia_tile_ni_10_15_req   ),
  .floo_rsp_o       ( magia_tile_ni_10_15_to_router_10_15_rsp   )
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
) magia_tile_ni_11_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[11][0] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[11][0] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[11][0] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[11][0] ),
  .id_i             ( '{x: 12, y: 0, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_11_0_to_router_11_0_req   ),
  .floo_rsp_i       ( router_11_0_to_magia_tile_ni_11_0_rsp   ),
  .floo_req_i       ( router_11_0_to_magia_tile_ni_11_0_req   ),
  .floo_rsp_o       ( magia_tile_ni_11_0_to_router_11_0_rsp   )
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
) magia_tile_ni_11_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[11][1] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[11][1] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[11][1] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[11][1] ),
  .id_i             ( '{x: 12, y: 1, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_11_1_to_router_11_1_req   ),
  .floo_rsp_i       ( router_11_1_to_magia_tile_ni_11_1_rsp   ),
  .floo_req_i       ( router_11_1_to_magia_tile_ni_11_1_req   ),
  .floo_rsp_o       ( magia_tile_ni_11_1_to_router_11_1_rsp   )
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
) magia_tile_ni_11_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[11][2] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[11][2] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[11][2] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[11][2] ),
  .id_i             ( '{x: 12, y: 2, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_11_2_to_router_11_2_req   ),
  .floo_rsp_i       ( router_11_2_to_magia_tile_ni_11_2_rsp   ),
  .floo_req_i       ( router_11_2_to_magia_tile_ni_11_2_req   ),
  .floo_rsp_o       ( magia_tile_ni_11_2_to_router_11_2_rsp   )
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
) magia_tile_ni_11_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[11][3] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[11][3] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[11][3] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[11][3] ),
  .id_i             ( '{x: 12, y: 3, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_11_3_to_router_11_3_req   ),
  .floo_rsp_i       ( router_11_3_to_magia_tile_ni_11_3_rsp   ),
  .floo_req_i       ( router_11_3_to_magia_tile_ni_11_3_req   ),
  .floo_rsp_o       ( magia_tile_ni_11_3_to_router_11_3_rsp   )
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
) magia_tile_ni_11_4 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[11][4] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[11][4] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[11][4] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[11][4] ),
  .id_i             ( '{x: 12, y: 4, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_11_4_to_router_11_4_req   ),
  .floo_rsp_i       ( router_11_4_to_magia_tile_ni_11_4_rsp   ),
  .floo_req_i       ( router_11_4_to_magia_tile_ni_11_4_req   ),
  .floo_rsp_o       ( magia_tile_ni_11_4_to_router_11_4_rsp   )
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
) magia_tile_ni_11_5 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[11][5] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[11][5] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[11][5] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[11][5] ),
  .id_i             ( '{x: 12, y: 5, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_11_5_to_router_11_5_req   ),
  .floo_rsp_i       ( router_11_5_to_magia_tile_ni_11_5_rsp   ),
  .floo_req_i       ( router_11_5_to_magia_tile_ni_11_5_req   ),
  .floo_rsp_o       ( magia_tile_ni_11_5_to_router_11_5_rsp   )
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
) magia_tile_ni_11_6 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[11][6] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[11][6] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[11][6] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[11][6] ),
  .id_i             ( '{x: 12, y: 6, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_11_6_to_router_11_6_req   ),
  .floo_rsp_i       ( router_11_6_to_magia_tile_ni_11_6_rsp   ),
  .floo_req_i       ( router_11_6_to_magia_tile_ni_11_6_req   ),
  .floo_rsp_o       ( magia_tile_ni_11_6_to_router_11_6_rsp   )
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
) magia_tile_ni_11_7 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[11][7] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[11][7] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[11][7] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[11][7] ),
  .id_i             ( '{x: 12, y: 7, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_11_7_to_router_11_7_req   ),
  .floo_rsp_i       ( router_11_7_to_magia_tile_ni_11_7_rsp   ),
  .floo_req_i       ( router_11_7_to_magia_tile_ni_11_7_req   ),
  .floo_rsp_o       ( magia_tile_ni_11_7_to_router_11_7_rsp   )
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
) magia_tile_ni_11_8 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[11][8] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[11][8] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[11][8] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[11][8] ),
  .id_i             ( '{x: 12, y: 8, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_11_8_to_router_11_8_req   ),
  .floo_rsp_i       ( router_11_8_to_magia_tile_ni_11_8_rsp   ),
  .floo_req_i       ( router_11_8_to_magia_tile_ni_11_8_req   ),
  .floo_rsp_o       ( magia_tile_ni_11_8_to_router_11_8_rsp   )
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
) magia_tile_ni_11_9 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[11][9] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[11][9] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[11][9] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[11][9] ),
  .id_i             ( '{x: 12, y: 9, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_11_9_to_router_11_9_req   ),
  .floo_rsp_i       ( router_11_9_to_magia_tile_ni_11_9_rsp   ),
  .floo_req_i       ( router_11_9_to_magia_tile_ni_11_9_req   ),
  .floo_rsp_o       ( magia_tile_ni_11_9_to_router_11_9_rsp   )
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
) magia_tile_ni_11_10 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[11][10] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[11][10] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[11][10] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[11][10] ),
  .id_i             ( '{x: 12, y: 10, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_11_10_to_router_11_10_req   ),
  .floo_rsp_i       ( router_11_10_to_magia_tile_ni_11_10_rsp   ),
  .floo_req_i       ( router_11_10_to_magia_tile_ni_11_10_req   ),
  .floo_rsp_o       ( magia_tile_ni_11_10_to_router_11_10_rsp   )
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
) magia_tile_ni_11_11 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[11][11] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[11][11] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[11][11] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[11][11] ),
  .id_i             ( '{x: 12, y: 11, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_11_11_to_router_11_11_req   ),
  .floo_rsp_i       ( router_11_11_to_magia_tile_ni_11_11_rsp   ),
  .floo_req_i       ( router_11_11_to_magia_tile_ni_11_11_req   ),
  .floo_rsp_o       ( magia_tile_ni_11_11_to_router_11_11_rsp   )
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
) magia_tile_ni_11_12 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[11][12] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[11][12] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[11][12] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[11][12] ),
  .id_i             ( '{x: 12, y: 12, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_11_12_to_router_11_12_req   ),
  .floo_rsp_i       ( router_11_12_to_magia_tile_ni_11_12_rsp   ),
  .floo_req_i       ( router_11_12_to_magia_tile_ni_11_12_req   ),
  .floo_rsp_o       ( magia_tile_ni_11_12_to_router_11_12_rsp   )
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
) magia_tile_ni_11_13 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[11][13] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[11][13] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[11][13] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[11][13] ),
  .id_i             ( '{x: 12, y: 13, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_11_13_to_router_11_13_req   ),
  .floo_rsp_i       ( router_11_13_to_magia_tile_ni_11_13_rsp   ),
  .floo_req_i       ( router_11_13_to_magia_tile_ni_11_13_req   ),
  .floo_rsp_o       ( magia_tile_ni_11_13_to_router_11_13_rsp   )
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
) magia_tile_ni_11_14 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[11][14] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[11][14] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[11][14] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[11][14] ),
  .id_i             ( '{x: 12, y: 14, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_11_14_to_router_11_14_req   ),
  .floo_rsp_i       ( router_11_14_to_magia_tile_ni_11_14_rsp   ),
  .floo_req_i       ( router_11_14_to_magia_tile_ni_11_14_req   ),
  .floo_rsp_o       ( magia_tile_ni_11_14_to_router_11_14_rsp   )
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
) magia_tile_ni_11_15 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[11][15] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[11][15] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[11][15] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[11][15] ),
  .id_i             ( '{x: 12, y: 15, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_11_15_to_router_11_15_req   ),
  .floo_rsp_i       ( router_11_15_to_magia_tile_ni_11_15_rsp   ),
  .floo_req_i       ( router_11_15_to_magia_tile_ni_11_15_req   ),
  .floo_rsp_o       ( magia_tile_ni_11_15_to_router_11_15_rsp   )
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
) magia_tile_ni_12_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[12][0] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[12][0] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[12][0] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[12][0] ),
  .id_i             ( '{x: 13, y: 0, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_12_0_to_router_12_0_req   ),
  .floo_rsp_i       ( router_12_0_to_magia_tile_ni_12_0_rsp   ),
  .floo_req_i       ( router_12_0_to_magia_tile_ni_12_0_req   ),
  .floo_rsp_o       ( magia_tile_ni_12_0_to_router_12_0_rsp   )
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
) magia_tile_ni_12_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[12][1] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[12][1] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[12][1] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[12][1] ),
  .id_i             ( '{x: 13, y: 1, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_12_1_to_router_12_1_req   ),
  .floo_rsp_i       ( router_12_1_to_magia_tile_ni_12_1_rsp   ),
  .floo_req_i       ( router_12_1_to_magia_tile_ni_12_1_req   ),
  .floo_rsp_o       ( magia_tile_ni_12_1_to_router_12_1_rsp   )
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
) magia_tile_ni_12_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[12][2] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[12][2] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[12][2] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[12][2] ),
  .id_i             ( '{x: 13, y: 2, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_12_2_to_router_12_2_req   ),
  .floo_rsp_i       ( router_12_2_to_magia_tile_ni_12_2_rsp   ),
  .floo_req_i       ( router_12_2_to_magia_tile_ni_12_2_req   ),
  .floo_rsp_o       ( magia_tile_ni_12_2_to_router_12_2_rsp   )
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
) magia_tile_ni_12_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[12][3] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[12][3] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[12][3] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[12][3] ),
  .id_i             ( '{x: 13, y: 3, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_12_3_to_router_12_3_req   ),
  .floo_rsp_i       ( router_12_3_to_magia_tile_ni_12_3_rsp   ),
  .floo_req_i       ( router_12_3_to_magia_tile_ni_12_3_req   ),
  .floo_rsp_o       ( magia_tile_ni_12_3_to_router_12_3_rsp   )
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
) magia_tile_ni_12_4 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[12][4] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[12][4] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[12][4] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[12][4] ),
  .id_i             ( '{x: 13, y: 4, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_12_4_to_router_12_4_req   ),
  .floo_rsp_i       ( router_12_4_to_magia_tile_ni_12_4_rsp   ),
  .floo_req_i       ( router_12_4_to_magia_tile_ni_12_4_req   ),
  .floo_rsp_o       ( magia_tile_ni_12_4_to_router_12_4_rsp   )
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
) magia_tile_ni_12_5 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[12][5] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[12][5] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[12][5] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[12][5] ),
  .id_i             ( '{x: 13, y: 5, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_12_5_to_router_12_5_req   ),
  .floo_rsp_i       ( router_12_5_to_magia_tile_ni_12_5_rsp   ),
  .floo_req_i       ( router_12_5_to_magia_tile_ni_12_5_req   ),
  .floo_rsp_o       ( magia_tile_ni_12_5_to_router_12_5_rsp   )
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
) magia_tile_ni_12_6 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[12][6] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[12][6] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[12][6] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[12][6] ),
  .id_i             ( '{x: 13, y: 6, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_12_6_to_router_12_6_req   ),
  .floo_rsp_i       ( router_12_6_to_magia_tile_ni_12_6_rsp   ),
  .floo_req_i       ( router_12_6_to_magia_tile_ni_12_6_req   ),
  .floo_rsp_o       ( magia_tile_ni_12_6_to_router_12_6_rsp   )
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
) magia_tile_ni_12_7 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[12][7] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[12][7] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[12][7] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[12][7] ),
  .id_i             ( '{x: 13, y: 7, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_12_7_to_router_12_7_req   ),
  .floo_rsp_i       ( router_12_7_to_magia_tile_ni_12_7_rsp   ),
  .floo_req_i       ( router_12_7_to_magia_tile_ni_12_7_req   ),
  .floo_rsp_o       ( magia_tile_ni_12_7_to_router_12_7_rsp   )
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
) magia_tile_ni_12_8 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[12][8] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[12][8] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[12][8] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[12][8] ),
  .id_i             ( '{x: 13, y: 8, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_12_8_to_router_12_8_req   ),
  .floo_rsp_i       ( router_12_8_to_magia_tile_ni_12_8_rsp   ),
  .floo_req_i       ( router_12_8_to_magia_tile_ni_12_8_req   ),
  .floo_rsp_o       ( magia_tile_ni_12_8_to_router_12_8_rsp   )
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
) magia_tile_ni_12_9 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[12][9] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[12][9] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[12][9] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[12][9] ),
  .id_i             ( '{x: 13, y: 9, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_12_9_to_router_12_9_req   ),
  .floo_rsp_i       ( router_12_9_to_magia_tile_ni_12_9_rsp   ),
  .floo_req_i       ( router_12_9_to_magia_tile_ni_12_9_req   ),
  .floo_rsp_o       ( magia_tile_ni_12_9_to_router_12_9_rsp   )
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
) magia_tile_ni_12_10 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[12][10] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[12][10] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[12][10] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[12][10] ),
  .id_i             ( '{x: 13, y: 10, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_12_10_to_router_12_10_req   ),
  .floo_rsp_i       ( router_12_10_to_magia_tile_ni_12_10_rsp   ),
  .floo_req_i       ( router_12_10_to_magia_tile_ni_12_10_req   ),
  .floo_rsp_o       ( magia_tile_ni_12_10_to_router_12_10_rsp   )
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
) magia_tile_ni_12_11 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[12][11] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[12][11] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[12][11] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[12][11] ),
  .id_i             ( '{x: 13, y: 11, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_12_11_to_router_12_11_req   ),
  .floo_rsp_i       ( router_12_11_to_magia_tile_ni_12_11_rsp   ),
  .floo_req_i       ( router_12_11_to_magia_tile_ni_12_11_req   ),
  .floo_rsp_o       ( magia_tile_ni_12_11_to_router_12_11_rsp   )
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
) magia_tile_ni_12_12 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[12][12] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[12][12] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[12][12] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[12][12] ),
  .id_i             ( '{x: 13, y: 12, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_12_12_to_router_12_12_req   ),
  .floo_rsp_i       ( router_12_12_to_magia_tile_ni_12_12_rsp   ),
  .floo_req_i       ( router_12_12_to_magia_tile_ni_12_12_req   ),
  .floo_rsp_o       ( magia_tile_ni_12_12_to_router_12_12_rsp   )
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
) magia_tile_ni_12_13 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[12][13] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[12][13] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[12][13] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[12][13] ),
  .id_i             ( '{x: 13, y: 13, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_12_13_to_router_12_13_req   ),
  .floo_rsp_i       ( router_12_13_to_magia_tile_ni_12_13_rsp   ),
  .floo_req_i       ( router_12_13_to_magia_tile_ni_12_13_req   ),
  .floo_rsp_o       ( magia_tile_ni_12_13_to_router_12_13_rsp   )
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
) magia_tile_ni_12_14 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[12][14] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[12][14] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[12][14] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[12][14] ),
  .id_i             ( '{x: 13, y: 14, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_12_14_to_router_12_14_req   ),
  .floo_rsp_i       ( router_12_14_to_magia_tile_ni_12_14_rsp   ),
  .floo_req_i       ( router_12_14_to_magia_tile_ni_12_14_req   ),
  .floo_rsp_o       ( magia_tile_ni_12_14_to_router_12_14_rsp   )
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
) magia_tile_ni_12_15 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[12][15] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[12][15] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[12][15] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[12][15] ),
  .id_i             ( '{x: 13, y: 15, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_12_15_to_router_12_15_req   ),
  .floo_rsp_i       ( router_12_15_to_magia_tile_ni_12_15_rsp   ),
  .floo_req_i       ( router_12_15_to_magia_tile_ni_12_15_req   ),
  .floo_rsp_o       ( magia_tile_ni_12_15_to_router_12_15_rsp   )
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
) magia_tile_ni_13_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[13][0] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[13][0] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[13][0] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[13][0] ),
  .id_i             ( '{x: 14, y: 0, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_13_0_to_router_13_0_req   ),
  .floo_rsp_i       ( router_13_0_to_magia_tile_ni_13_0_rsp   ),
  .floo_req_i       ( router_13_0_to_magia_tile_ni_13_0_req   ),
  .floo_rsp_o       ( magia_tile_ni_13_0_to_router_13_0_rsp   )
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
) magia_tile_ni_13_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[13][1] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[13][1] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[13][1] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[13][1] ),
  .id_i             ( '{x: 14, y: 1, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_13_1_to_router_13_1_req   ),
  .floo_rsp_i       ( router_13_1_to_magia_tile_ni_13_1_rsp   ),
  .floo_req_i       ( router_13_1_to_magia_tile_ni_13_1_req   ),
  .floo_rsp_o       ( magia_tile_ni_13_1_to_router_13_1_rsp   )
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
) magia_tile_ni_13_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[13][2] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[13][2] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[13][2] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[13][2] ),
  .id_i             ( '{x: 14, y: 2, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_13_2_to_router_13_2_req   ),
  .floo_rsp_i       ( router_13_2_to_magia_tile_ni_13_2_rsp   ),
  .floo_req_i       ( router_13_2_to_magia_tile_ni_13_2_req   ),
  .floo_rsp_o       ( magia_tile_ni_13_2_to_router_13_2_rsp   )
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
) magia_tile_ni_13_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[13][3] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[13][3] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[13][3] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[13][3] ),
  .id_i             ( '{x: 14, y: 3, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_13_3_to_router_13_3_req   ),
  .floo_rsp_i       ( router_13_3_to_magia_tile_ni_13_3_rsp   ),
  .floo_req_i       ( router_13_3_to_magia_tile_ni_13_3_req   ),
  .floo_rsp_o       ( magia_tile_ni_13_3_to_router_13_3_rsp   )
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
) magia_tile_ni_13_4 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[13][4] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[13][4] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[13][4] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[13][4] ),
  .id_i             ( '{x: 14, y: 4, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_13_4_to_router_13_4_req   ),
  .floo_rsp_i       ( router_13_4_to_magia_tile_ni_13_4_rsp   ),
  .floo_req_i       ( router_13_4_to_magia_tile_ni_13_4_req   ),
  .floo_rsp_o       ( magia_tile_ni_13_4_to_router_13_4_rsp   )
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
) magia_tile_ni_13_5 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[13][5] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[13][5] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[13][5] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[13][5] ),
  .id_i             ( '{x: 14, y: 5, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_13_5_to_router_13_5_req   ),
  .floo_rsp_i       ( router_13_5_to_magia_tile_ni_13_5_rsp   ),
  .floo_req_i       ( router_13_5_to_magia_tile_ni_13_5_req   ),
  .floo_rsp_o       ( magia_tile_ni_13_5_to_router_13_5_rsp   )
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
) magia_tile_ni_13_6 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[13][6] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[13][6] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[13][6] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[13][6] ),
  .id_i             ( '{x: 14, y: 6, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_13_6_to_router_13_6_req   ),
  .floo_rsp_i       ( router_13_6_to_magia_tile_ni_13_6_rsp   ),
  .floo_req_i       ( router_13_6_to_magia_tile_ni_13_6_req   ),
  .floo_rsp_o       ( magia_tile_ni_13_6_to_router_13_6_rsp   )
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
) magia_tile_ni_13_7 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[13][7] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[13][7] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[13][7] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[13][7] ),
  .id_i             ( '{x: 14, y: 7, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_13_7_to_router_13_7_req   ),
  .floo_rsp_i       ( router_13_7_to_magia_tile_ni_13_7_rsp   ),
  .floo_req_i       ( router_13_7_to_magia_tile_ni_13_7_req   ),
  .floo_rsp_o       ( magia_tile_ni_13_7_to_router_13_7_rsp   )
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
) magia_tile_ni_13_8 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[13][8] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[13][8] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[13][8] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[13][8] ),
  .id_i             ( '{x: 14, y: 8, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_13_8_to_router_13_8_req   ),
  .floo_rsp_i       ( router_13_8_to_magia_tile_ni_13_8_rsp   ),
  .floo_req_i       ( router_13_8_to_magia_tile_ni_13_8_req   ),
  .floo_rsp_o       ( magia_tile_ni_13_8_to_router_13_8_rsp   )
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
) magia_tile_ni_13_9 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[13][9] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[13][9] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[13][9] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[13][9] ),
  .id_i             ( '{x: 14, y: 9, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_13_9_to_router_13_9_req   ),
  .floo_rsp_i       ( router_13_9_to_magia_tile_ni_13_9_rsp   ),
  .floo_req_i       ( router_13_9_to_magia_tile_ni_13_9_req   ),
  .floo_rsp_o       ( magia_tile_ni_13_9_to_router_13_9_rsp   )
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
) magia_tile_ni_13_10 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[13][10] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[13][10] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[13][10] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[13][10] ),
  .id_i             ( '{x: 14, y: 10, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_13_10_to_router_13_10_req   ),
  .floo_rsp_i       ( router_13_10_to_magia_tile_ni_13_10_rsp   ),
  .floo_req_i       ( router_13_10_to_magia_tile_ni_13_10_req   ),
  .floo_rsp_o       ( magia_tile_ni_13_10_to_router_13_10_rsp   )
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
) magia_tile_ni_13_11 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[13][11] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[13][11] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[13][11] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[13][11] ),
  .id_i             ( '{x: 14, y: 11, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_13_11_to_router_13_11_req   ),
  .floo_rsp_i       ( router_13_11_to_magia_tile_ni_13_11_rsp   ),
  .floo_req_i       ( router_13_11_to_magia_tile_ni_13_11_req   ),
  .floo_rsp_o       ( magia_tile_ni_13_11_to_router_13_11_rsp   )
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
) magia_tile_ni_13_12 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[13][12] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[13][12] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[13][12] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[13][12] ),
  .id_i             ( '{x: 14, y: 12, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_13_12_to_router_13_12_req   ),
  .floo_rsp_i       ( router_13_12_to_magia_tile_ni_13_12_rsp   ),
  .floo_req_i       ( router_13_12_to_magia_tile_ni_13_12_req   ),
  .floo_rsp_o       ( magia_tile_ni_13_12_to_router_13_12_rsp   )
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
) magia_tile_ni_13_13 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[13][13] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[13][13] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[13][13] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[13][13] ),
  .id_i             ( '{x: 14, y: 13, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_13_13_to_router_13_13_req   ),
  .floo_rsp_i       ( router_13_13_to_magia_tile_ni_13_13_rsp   ),
  .floo_req_i       ( router_13_13_to_magia_tile_ni_13_13_req   ),
  .floo_rsp_o       ( magia_tile_ni_13_13_to_router_13_13_rsp   )
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
) magia_tile_ni_13_14 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[13][14] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[13][14] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[13][14] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[13][14] ),
  .id_i             ( '{x: 14, y: 14, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_13_14_to_router_13_14_req   ),
  .floo_rsp_i       ( router_13_14_to_magia_tile_ni_13_14_rsp   ),
  .floo_req_i       ( router_13_14_to_magia_tile_ni_13_14_req   ),
  .floo_rsp_o       ( magia_tile_ni_13_14_to_router_13_14_rsp   )
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
) magia_tile_ni_13_15 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[13][15] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[13][15] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[13][15] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[13][15] ),
  .id_i             ( '{x: 14, y: 15, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_13_15_to_router_13_15_req   ),
  .floo_rsp_i       ( router_13_15_to_magia_tile_ni_13_15_rsp   ),
  .floo_req_i       ( router_13_15_to_magia_tile_ni_13_15_req   ),
  .floo_rsp_o       ( magia_tile_ni_13_15_to_router_13_15_rsp   )
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
) magia_tile_ni_14_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[14][0] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[14][0] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[14][0] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[14][0] ),
  .id_i             ( '{x: 15, y: 0, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_14_0_to_router_14_0_req   ),
  .floo_rsp_i       ( router_14_0_to_magia_tile_ni_14_0_rsp   ),
  .floo_req_i       ( router_14_0_to_magia_tile_ni_14_0_req   ),
  .floo_rsp_o       ( magia_tile_ni_14_0_to_router_14_0_rsp   )
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
) magia_tile_ni_14_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[14][1] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[14][1] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[14][1] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[14][1] ),
  .id_i             ( '{x: 15, y: 1, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_14_1_to_router_14_1_req   ),
  .floo_rsp_i       ( router_14_1_to_magia_tile_ni_14_1_rsp   ),
  .floo_req_i       ( router_14_1_to_magia_tile_ni_14_1_req   ),
  .floo_rsp_o       ( magia_tile_ni_14_1_to_router_14_1_rsp   )
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
) magia_tile_ni_14_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[14][2] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[14][2] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[14][2] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[14][2] ),
  .id_i             ( '{x: 15, y: 2, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_14_2_to_router_14_2_req   ),
  .floo_rsp_i       ( router_14_2_to_magia_tile_ni_14_2_rsp   ),
  .floo_req_i       ( router_14_2_to_magia_tile_ni_14_2_req   ),
  .floo_rsp_o       ( magia_tile_ni_14_2_to_router_14_2_rsp   )
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
) magia_tile_ni_14_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[14][3] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[14][3] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[14][3] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[14][3] ),
  .id_i             ( '{x: 15, y: 3, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_14_3_to_router_14_3_req   ),
  .floo_rsp_i       ( router_14_3_to_magia_tile_ni_14_3_rsp   ),
  .floo_req_i       ( router_14_3_to_magia_tile_ni_14_3_req   ),
  .floo_rsp_o       ( magia_tile_ni_14_3_to_router_14_3_rsp   )
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
) magia_tile_ni_14_4 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[14][4] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[14][4] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[14][4] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[14][4] ),
  .id_i             ( '{x: 15, y: 4, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_14_4_to_router_14_4_req   ),
  .floo_rsp_i       ( router_14_4_to_magia_tile_ni_14_4_rsp   ),
  .floo_req_i       ( router_14_4_to_magia_tile_ni_14_4_req   ),
  .floo_rsp_o       ( magia_tile_ni_14_4_to_router_14_4_rsp   )
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
) magia_tile_ni_14_5 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[14][5] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[14][5] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[14][5] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[14][5] ),
  .id_i             ( '{x: 15, y: 5, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_14_5_to_router_14_5_req   ),
  .floo_rsp_i       ( router_14_5_to_magia_tile_ni_14_5_rsp   ),
  .floo_req_i       ( router_14_5_to_magia_tile_ni_14_5_req   ),
  .floo_rsp_o       ( magia_tile_ni_14_5_to_router_14_5_rsp   )
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
) magia_tile_ni_14_6 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[14][6] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[14][6] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[14][6] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[14][6] ),
  .id_i             ( '{x: 15, y: 6, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_14_6_to_router_14_6_req   ),
  .floo_rsp_i       ( router_14_6_to_magia_tile_ni_14_6_rsp   ),
  .floo_req_i       ( router_14_6_to_magia_tile_ni_14_6_req   ),
  .floo_rsp_o       ( magia_tile_ni_14_6_to_router_14_6_rsp   )
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
) magia_tile_ni_14_7 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[14][7] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[14][7] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[14][7] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[14][7] ),
  .id_i             ( '{x: 15, y: 7, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_14_7_to_router_14_7_req   ),
  .floo_rsp_i       ( router_14_7_to_magia_tile_ni_14_7_rsp   ),
  .floo_req_i       ( router_14_7_to_magia_tile_ni_14_7_req   ),
  .floo_rsp_o       ( magia_tile_ni_14_7_to_router_14_7_rsp   )
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
) magia_tile_ni_14_8 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[14][8] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[14][8] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[14][8] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[14][8] ),
  .id_i             ( '{x: 15, y: 8, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_14_8_to_router_14_8_req   ),
  .floo_rsp_i       ( router_14_8_to_magia_tile_ni_14_8_rsp   ),
  .floo_req_i       ( router_14_8_to_magia_tile_ni_14_8_req   ),
  .floo_rsp_o       ( magia_tile_ni_14_8_to_router_14_8_rsp   )
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
) magia_tile_ni_14_9 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[14][9] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[14][9] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[14][9] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[14][9] ),
  .id_i             ( '{x: 15, y: 9, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_14_9_to_router_14_9_req   ),
  .floo_rsp_i       ( router_14_9_to_magia_tile_ni_14_9_rsp   ),
  .floo_req_i       ( router_14_9_to_magia_tile_ni_14_9_req   ),
  .floo_rsp_o       ( magia_tile_ni_14_9_to_router_14_9_rsp   )
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
) magia_tile_ni_14_10 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[14][10] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[14][10] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[14][10] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[14][10] ),
  .id_i             ( '{x: 15, y: 10, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_14_10_to_router_14_10_req   ),
  .floo_rsp_i       ( router_14_10_to_magia_tile_ni_14_10_rsp   ),
  .floo_req_i       ( router_14_10_to_magia_tile_ni_14_10_req   ),
  .floo_rsp_o       ( magia_tile_ni_14_10_to_router_14_10_rsp   )
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
) magia_tile_ni_14_11 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[14][11] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[14][11] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[14][11] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[14][11] ),
  .id_i             ( '{x: 15, y: 11, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_14_11_to_router_14_11_req   ),
  .floo_rsp_i       ( router_14_11_to_magia_tile_ni_14_11_rsp   ),
  .floo_req_i       ( router_14_11_to_magia_tile_ni_14_11_req   ),
  .floo_rsp_o       ( magia_tile_ni_14_11_to_router_14_11_rsp   )
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
) magia_tile_ni_14_12 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[14][12] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[14][12] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[14][12] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[14][12] ),
  .id_i             ( '{x: 15, y: 12, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_14_12_to_router_14_12_req   ),
  .floo_rsp_i       ( router_14_12_to_magia_tile_ni_14_12_rsp   ),
  .floo_req_i       ( router_14_12_to_magia_tile_ni_14_12_req   ),
  .floo_rsp_o       ( magia_tile_ni_14_12_to_router_14_12_rsp   )
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
) magia_tile_ni_14_13 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[14][13] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[14][13] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[14][13] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[14][13] ),
  .id_i             ( '{x: 15, y: 13, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_14_13_to_router_14_13_req   ),
  .floo_rsp_i       ( router_14_13_to_magia_tile_ni_14_13_rsp   ),
  .floo_req_i       ( router_14_13_to_magia_tile_ni_14_13_req   ),
  .floo_rsp_o       ( magia_tile_ni_14_13_to_router_14_13_rsp   )
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
) magia_tile_ni_14_14 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[14][14] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[14][14] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[14][14] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[14][14] ),
  .id_i             ( '{x: 15, y: 14, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_14_14_to_router_14_14_req   ),
  .floo_rsp_i       ( router_14_14_to_magia_tile_ni_14_14_rsp   ),
  .floo_req_i       ( router_14_14_to_magia_tile_ni_14_14_req   ),
  .floo_rsp_o       ( magia_tile_ni_14_14_to_router_14_14_rsp   )
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
) magia_tile_ni_14_15 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[14][15] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[14][15] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[14][15] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[14][15] ),
  .id_i             ( '{x: 15, y: 15, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_14_15_to_router_14_15_req   ),
  .floo_rsp_i       ( router_14_15_to_magia_tile_ni_14_15_rsp   ),
  .floo_req_i       ( router_14_15_to_magia_tile_ni_14_15_req   ),
  .floo_rsp_o       ( magia_tile_ni_14_15_to_router_14_15_rsp   )
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
) magia_tile_ni_15_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[15][0] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[15][0] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[15][0] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[15][0] ),
  .id_i             ( '{x: 16, y: 0, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_15_0_to_router_15_0_req   ),
  .floo_rsp_i       ( router_15_0_to_magia_tile_ni_15_0_rsp   ),
  .floo_req_i       ( router_15_0_to_magia_tile_ni_15_0_req   ),
  .floo_rsp_o       ( magia_tile_ni_15_0_to_router_15_0_rsp   )
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
) magia_tile_ni_15_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[15][1] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[15][1] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[15][1] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[15][1] ),
  .id_i             ( '{x: 16, y: 1, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_15_1_to_router_15_1_req   ),
  .floo_rsp_i       ( router_15_1_to_magia_tile_ni_15_1_rsp   ),
  .floo_req_i       ( router_15_1_to_magia_tile_ni_15_1_req   ),
  .floo_rsp_o       ( magia_tile_ni_15_1_to_router_15_1_rsp   )
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
) magia_tile_ni_15_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[15][2] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[15][2] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[15][2] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[15][2] ),
  .id_i             ( '{x: 16, y: 2, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_15_2_to_router_15_2_req   ),
  .floo_rsp_i       ( router_15_2_to_magia_tile_ni_15_2_rsp   ),
  .floo_req_i       ( router_15_2_to_magia_tile_ni_15_2_req   ),
  .floo_rsp_o       ( magia_tile_ni_15_2_to_router_15_2_rsp   )
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
) magia_tile_ni_15_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[15][3] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[15][3] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[15][3] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[15][3] ),
  .id_i             ( '{x: 16, y: 3, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_15_3_to_router_15_3_req   ),
  .floo_rsp_i       ( router_15_3_to_magia_tile_ni_15_3_rsp   ),
  .floo_req_i       ( router_15_3_to_magia_tile_ni_15_3_req   ),
  .floo_rsp_o       ( magia_tile_ni_15_3_to_router_15_3_rsp   )
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
) magia_tile_ni_15_4 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[15][4] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[15][4] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[15][4] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[15][4] ),
  .id_i             ( '{x: 16, y: 4, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_15_4_to_router_15_4_req   ),
  .floo_rsp_i       ( router_15_4_to_magia_tile_ni_15_4_rsp   ),
  .floo_req_i       ( router_15_4_to_magia_tile_ni_15_4_req   ),
  .floo_rsp_o       ( magia_tile_ni_15_4_to_router_15_4_rsp   )
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
) magia_tile_ni_15_5 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[15][5] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[15][5] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[15][5] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[15][5] ),
  .id_i             ( '{x: 16, y: 5, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_15_5_to_router_15_5_req   ),
  .floo_rsp_i       ( router_15_5_to_magia_tile_ni_15_5_rsp   ),
  .floo_req_i       ( router_15_5_to_magia_tile_ni_15_5_req   ),
  .floo_rsp_o       ( magia_tile_ni_15_5_to_router_15_5_rsp   )
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
) magia_tile_ni_15_6 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[15][6] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[15][6] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[15][6] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[15][6] ),
  .id_i             ( '{x: 16, y: 6, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_15_6_to_router_15_6_req   ),
  .floo_rsp_i       ( router_15_6_to_magia_tile_ni_15_6_rsp   ),
  .floo_req_i       ( router_15_6_to_magia_tile_ni_15_6_req   ),
  .floo_rsp_o       ( magia_tile_ni_15_6_to_router_15_6_rsp   )
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
) magia_tile_ni_15_7 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[15][7] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[15][7] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[15][7] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[15][7] ),
  .id_i             ( '{x: 16, y: 7, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_15_7_to_router_15_7_req   ),
  .floo_rsp_i       ( router_15_7_to_magia_tile_ni_15_7_rsp   ),
  .floo_req_i       ( router_15_7_to_magia_tile_ni_15_7_req   ),
  .floo_rsp_o       ( magia_tile_ni_15_7_to_router_15_7_rsp   )
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
) magia_tile_ni_15_8 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[15][8] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[15][8] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[15][8] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[15][8] ),
  .id_i             ( '{x: 16, y: 8, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_15_8_to_router_15_8_req   ),
  .floo_rsp_i       ( router_15_8_to_magia_tile_ni_15_8_rsp   ),
  .floo_req_i       ( router_15_8_to_magia_tile_ni_15_8_req   ),
  .floo_rsp_o       ( magia_tile_ni_15_8_to_router_15_8_rsp   )
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
) magia_tile_ni_15_9 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[15][9] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[15][9] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[15][9] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[15][9] ),
  .id_i             ( '{x: 16, y: 9, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_15_9_to_router_15_9_req   ),
  .floo_rsp_i       ( router_15_9_to_magia_tile_ni_15_9_rsp   ),
  .floo_req_i       ( router_15_9_to_magia_tile_ni_15_9_req   ),
  .floo_rsp_o       ( magia_tile_ni_15_9_to_router_15_9_rsp   )
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
) magia_tile_ni_15_10 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[15][10] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[15][10] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[15][10] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[15][10] ),
  .id_i             ( '{x: 16, y: 10, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_15_10_to_router_15_10_req   ),
  .floo_rsp_i       ( router_15_10_to_magia_tile_ni_15_10_rsp   ),
  .floo_req_i       ( router_15_10_to_magia_tile_ni_15_10_req   ),
  .floo_rsp_o       ( magia_tile_ni_15_10_to_router_15_10_rsp   )
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
) magia_tile_ni_15_11 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[15][11] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[15][11] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[15][11] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[15][11] ),
  .id_i             ( '{x: 16, y: 11, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_15_11_to_router_15_11_req   ),
  .floo_rsp_i       ( router_15_11_to_magia_tile_ni_15_11_rsp   ),
  .floo_req_i       ( router_15_11_to_magia_tile_ni_15_11_req   ),
  .floo_rsp_o       ( magia_tile_ni_15_11_to_router_15_11_rsp   )
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
) magia_tile_ni_15_12 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[15][12] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[15][12] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[15][12] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[15][12] ),
  .id_i             ( '{x: 16, y: 12, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_15_12_to_router_15_12_req   ),
  .floo_rsp_i       ( router_15_12_to_magia_tile_ni_15_12_rsp   ),
  .floo_req_i       ( router_15_12_to_magia_tile_ni_15_12_req   ),
  .floo_rsp_o       ( magia_tile_ni_15_12_to_router_15_12_rsp   )
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
) magia_tile_ni_15_13 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[15][13] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[15][13] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[15][13] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[15][13] ),
  .id_i             ( '{x: 16, y: 13, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_15_13_to_router_15_13_req   ),
  .floo_rsp_i       ( router_15_13_to_magia_tile_ni_15_13_rsp   ),
  .floo_req_i       ( router_15_13_to_magia_tile_ni_15_13_req   ),
  .floo_rsp_o       ( magia_tile_ni_15_13_to_router_15_13_rsp   )
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
) magia_tile_ni_15_14 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[15][14] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[15][14] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[15][14] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[15][14] ),
  .id_i             ( '{x: 16, y: 14, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_15_14_to_router_15_14_req   ),
  .floo_rsp_i       ( router_15_14_to_magia_tile_ni_15_14_rsp   ),
  .floo_req_i       ( router_15_14_to_magia_tile_ni_15_14_req   ),
  .floo_rsp_o       ( magia_tile_ni_15_14_to_router_15_14_rsp   )
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
) magia_tile_ni_15_15 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( magia_tile_data_slv_req_i[15][15] ),
  .axi_in_rsp_o  ( magia_tile_data_slv_rsp_o[15][15] ),
  .axi_out_req_o ( magia_tile_data_mst_req_o[15][15] ),
  .axi_out_rsp_i ( magia_tile_data_mst_rsp_i[15][15] ),
  .id_i             ( '{x: 16, y: 15, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( magia_tile_ni_15_15_to_router_15_15_req   ),
  .floo_rsp_i       ( router_15_15_to_magia_tile_ni_15_15_rsp   ),
  .floo_req_i       ( router_15_15_to_magia_tile_ni_15_15_req   ),
  .floo_rsp_o       ( magia_tile_ni_15_15_to_router_15_15_rsp   )
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
) L2_ni_8 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( '0 ),
  .axi_in_rsp_o  (    ),
  .axi_out_req_o ( L2_data_mst_req_o[8] ),
  .axi_out_rsp_i ( L2_data_mst_rsp_i[8] ),
  .id_i             ( '{x: 0, y: 8, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( L2_ni_8_to_router_0_8_req   ),
  .floo_rsp_i       ( router_0_8_to_L2_ni_8_rsp   ),
  .floo_req_i       ( router_0_8_to_L2_ni_8_req   ),
  .floo_rsp_o       ( L2_ni_8_to_router_0_8_rsp   )
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
) L2_ni_9 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( '0 ),
  .axi_in_rsp_o  (    ),
  .axi_out_req_o ( L2_data_mst_req_o[9] ),
  .axi_out_rsp_i ( L2_data_mst_rsp_i[9] ),
  .id_i             ( '{x: 0, y: 9, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( L2_ni_9_to_router_0_9_req   ),
  .floo_rsp_i       ( router_0_9_to_L2_ni_9_rsp   ),
  .floo_req_i       ( router_0_9_to_L2_ni_9_req   ),
  .floo_rsp_o       ( L2_ni_9_to_router_0_9_rsp   )
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
) L2_ni_10 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( '0 ),
  .axi_in_rsp_o  (    ),
  .axi_out_req_o ( L2_data_mst_req_o[10] ),
  .axi_out_rsp_i ( L2_data_mst_rsp_i[10] ),
  .id_i             ( '{x: 0, y: 10, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( L2_ni_10_to_router_0_10_req   ),
  .floo_rsp_i       ( router_0_10_to_L2_ni_10_rsp   ),
  .floo_req_i       ( router_0_10_to_L2_ni_10_req   ),
  .floo_rsp_o       ( L2_ni_10_to_router_0_10_rsp   )
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
) L2_ni_11 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( '0 ),
  .axi_in_rsp_o  (    ),
  .axi_out_req_o ( L2_data_mst_req_o[11] ),
  .axi_out_rsp_i ( L2_data_mst_rsp_i[11] ),
  .id_i             ( '{x: 0, y: 11, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( L2_ni_11_to_router_0_11_req   ),
  .floo_rsp_i       ( router_0_11_to_L2_ni_11_rsp   ),
  .floo_req_i       ( router_0_11_to_L2_ni_11_req   ),
  .floo_rsp_o       ( L2_ni_11_to_router_0_11_rsp   )
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
) L2_ni_12 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( '0 ),
  .axi_in_rsp_o  (    ),
  .axi_out_req_o ( L2_data_mst_req_o[12] ),
  .axi_out_rsp_i ( L2_data_mst_rsp_i[12] ),
  .id_i             ( '{x: 0, y: 12, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( L2_ni_12_to_router_0_12_req   ),
  .floo_rsp_i       ( router_0_12_to_L2_ni_12_rsp   ),
  .floo_req_i       ( router_0_12_to_L2_ni_12_req   ),
  .floo_rsp_o       ( L2_ni_12_to_router_0_12_rsp   )
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
) L2_ni_13 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( '0 ),
  .axi_in_rsp_o  (    ),
  .axi_out_req_o ( L2_data_mst_req_o[13] ),
  .axi_out_rsp_i ( L2_data_mst_rsp_i[13] ),
  .id_i             ( '{x: 0, y: 13, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( L2_ni_13_to_router_0_13_req   ),
  .floo_rsp_i       ( router_0_13_to_L2_ni_13_rsp   ),
  .floo_req_i       ( router_0_13_to_L2_ni_13_req   ),
  .floo_rsp_o       ( L2_ni_13_to_router_0_13_rsp   )
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
) L2_ni_14 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( '0 ),
  .axi_in_rsp_o  (    ),
  .axi_out_req_o ( L2_data_mst_req_o[14] ),
  .axi_out_rsp_i ( L2_data_mst_rsp_i[14] ),
  .id_i             ( '{x: 0, y: 14, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( L2_ni_14_to_router_0_14_req   ),
  .floo_rsp_i       ( router_0_14_to_L2_ni_14_rsp   ),
  .floo_req_i       ( router_0_14_to_L2_ni_14_req   ),
  .floo_rsp_o       ( L2_ni_14_to_router_0_14_rsp   )
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
) L2_ni_15 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .sram_cfg_i ( '0 ),
  .axi_in_req_i  ( '0 ),
  .axi_in_rsp_o  (    ),
  .axi_out_req_o ( L2_data_mst_req_o[15] ),
  .axi_out_rsp_i ( L2_data_mst_rsp_i[15] ),
  .id_i             ( '{x: 0, y: 15, port_id: 0}    ),
  .route_table_i    ( '0                          ),
  .floo_req_o       ( L2_ni_15_to_router_0_15_req   ),
  .floo_rsp_i       ( router_0_15_to_L2_ni_15_rsp   ),
  .floo_req_i       ( router_0_15_to_L2_ni_15_req   ),
  .floo_rsp_o       ( L2_ni_15_to_router_0_15_rsp   )
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

    assign router_0_7_req_in[0] = router_0_8_to_router_0_7_req;
    assign router_0_7_req_in[1] = router_1_7_to_router_0_7_req;
    assign router_0_7_req_in[2] = router_0_6_to_router_0_7_req;
    assign router_0_7_req_in[3] = L2_ni_7_to_router_0_7_req;
    assign router_0_7_req_in[4] = magia_tile_ni_0_7_to_router_0_7_req;

    assign router_0_7_to_router_0_8_rsp = router_0_7_rsp_out[0];
    assign router_0_7_to_router_1_7_rsp = router_0_7_rsp_out[1];
    assign router_0_7_to_router_0_6_rsp = router_0_7_rsp_out[2];
    assign router_0_7_to_L2_ni_7_rsp = router_0_7_rsp_out[3];
    assign router_0_7_to_magia_tile_ni_0_7_rsp = router_0_7_rsp_out[4];

    assign router_0_7_to_router_0_8_req = router_0_7_req_out[0];
    assign router_0_7_to_router_1_7_req = router_0_7_req_out[1];
    assign router_0_7_to_router_0_6_req = router_0_7_req_out[2];
    assign router_0_7_to_L2_ni_7_req = router_0_7_req_out[3];
    assign router_0_7_to_magia_tile_ni_0_7_req = router_0_7_req_out[4];

    assign router_0_7_rsp_in[0] = router_0_8_to_router_0_7_rsp;
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


floo_req_t [4:0] router_0_8_req_in;
floo_rsp_t [4:0] router_0_8_rsp_out;
floo_req_t [4:0] router_0_8_req_out;
floo_rsp_t [4:0] router_0_8_rsp_in;

    assign router_0_8_req_in[0] = router_0_9_to_router_0_8_req;
    assign router_0_8_req_in[1] = router_1_8_to_router_0_8_req;
    assign router_0_8_req_in[2] = router_0_7_to_router_0_8_req;
    assign router_0_8_req_in[3] = L2_ni_8_to_router_0_8_req;
    assign router_0_8_req_in[4] = magia_tile_ni_0_8_to_router_0_8_req;

    assign router_0_8_to_router_0_9_rsp = router_0_8_rsp_out[0];
    assign router_0_8_to_router_1_8_rsp = router_0_8_rsp_out[1];
    assign router_0_8_to_router_0_7_rsp = router_0_8_rsp_out[2];
    assign router_0_8_to_L2_ni_8_rsp = router_0_8_rsp_out[3];
    assign router_0_8_to_magia_tile_ni_0_8_rsp = router_0_8_rsp_out[4];

    assign router_0_8_to_router_0_9_req = router_0_8_req_out[0];
    assign router_0_8_to_router_1_8_req = router_0_8_req_out[1];
    assign router_0_8_to_router_0_7_req = router_0_8_req_out[2];
    assign router_0_8_to_L2_ni_8_req = router_0_8_req_out[3];
    assign router_0_8_to_magia_tile_ni_0_8_req = router_0_8_req_out[4];

    assign router_0_8_rsp_in[0] = router_0_9_to_router_0_8_rsp;
    assign router_0_8_rsp_in[1] = router_1_8_to_router_0_8_rsp;
    assign router_0_8_rsp_in[2] = router_0_7_to_router_0_8_rsp;
    assign router_0_8_rsp_in[3] = L2_ni_8_to_router_0_8_rsp;
    assign router_0_8_rsp_in[4] = magia_tile_ni_0_8_to_router_0_8_rsp;

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
) router_0_8 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 1, y: 8, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_0_8_req_in),
  .floo_rsp_o (router_0_8_rsp_out),
  .floo_req_o (router_0_8_req_out),
  .floo_rsp_i (router_0_8_rsp_in)
);


floo_req_t [4:0] router_0_9_req_in;
floo_rsp_t [4:0] router_0_9_rsp_out;
floo_req_t [4:0] router_0_9_req_out;
floo_rsp_t [4:0] router_0_9_rsp_in;

    assign router_0_9_req_in[0] = router_0_10_to_router_0_9_req;
    assign router_0_9_req_in[1] = router_1_9_to_router_0_9_req;
    assign router_0_9_req_in[2] = router_0_8_to_router_0_9_req;
    assign router_0_9_req_in[3] = L2_ni_9_to_router_0_9_req;
    assign router_0_9_req_in[4] = magia_tile_ni_0_9_to_router_0_9_req;

    assign router_0_9_to_router_0_10_rsp = router_0_9_rsp_out[0];
    assign router_0_9_to_router_1_9_rsp = router_0_9_rsp_out[1];
    assign router_0_9_to_router_0_8_rsp = router_0_9_rsp_out[2];
    assign router_0_9_to_L2_ni_9_rsp = router_0_9_rsp_out[3];
    assign router_0_9_to_magia_tile_ni_0_9_rsp = router_0_9_rsp_out[4];

    assign router_0_9_to_router_0_10_req = router_0_9_req_out[0];
    assign router_0_9_to_router_1_9_req = router_0_9_req_out[1];
    assign router_0_9_to_router_0_8_req = router_0_9_req_out[2];
    assign router_0_9_to_L2_ni_9_req = router_0_9_req_out[3];
    assign router_0_9_to_magia_tile_ni_0_9_req = router_0_9_req_out[4];

    assign router_0_9_rsp_in[0] = router_0_10_to_router_0_9_rsp;
    assign router_0_9_rsp_in[1] = router_1_9_to_router_0_9_rsp;
    assign router_0_9_rsp_in[2] = router_0_8_to_router_0_9_rsp;
    assign router_0_9_rsp_in[3] = L2_ni_9_to_router_0_9_rsp;
    assign router_0_9_rsp_in[4] = magia_tile_ni_0_9_to_router_0_9_rsp;

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
) router_0_9 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 1, y: 9, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_0_9_req_in),
  .floo_rsp_o (router_0_9_rsp_out),
  .floo_req_o (router_0_9_req_out),
  .floo_rsp_i (router_0_9_rsp_in)
);


floo_req_t [4:0] router_0_10_req_in;
floo_rsp_t [4:0] router_0_10_rsp_out;
floo_req_t [4:0] router_0_10_req_out;
floo_rsp_t [4:0] router_0_10_rsp_in;

    assign router_0_10_req_in[0] = router_0_11_to_router_0_10_req;
    assign router_0_10_req_in[1] = router_1_10_to_router_0_10_req;
    assign router_0_10_req_in[2] = router_0_9_to_router_0_10_req;
    assign router_0_10_req_in[3] = L2_ni_10_to_router_0_10_req;
    assign router_0_10_req_in[4] = magia_tile_ni_0_10_to_router_0_10_req;

    assign router_0_10_to_router_0_11_rsp = router_0_10_rsp_out[0];
    assign router_0_10_to_router_1_10_rsp = router_0_10_rsp_out[1];
    assign router_0_10_to_router_0_9_rsp = router_0_10_rsp_out[2];
    assign router_0_10_to_L2_ni_10_rsp = router_0_10_rsp_out[3];
    assign router_0_10_to_magia_tile_ni_0_10_rsp = router_0_10_rsp_out[4];

    assign router_0_10_to_router_0_11_req = router_0_10_req_out[0];
    assign router_0_10_to_router_1_10_req = router_0_10_req_out[1];
    assign router_0_10_to_router_0_9_req = router_0_10_req_out[2];
    assign router_0_10_to_L2_ni_10_req = router_0_10_req_out[3];
    assign router_0_10_to_magia_tile_ni_0_10_req = router_0_10_req_out[4];

    assign router_0_10_rsp_in[0] = router_0_11_to_router_0_10_rsp;
    assign router_0_10_rsp_in[1] = router_1_10_to_router_0_10_rsp;
    assign router_0_10_rsp_in[2] = router_0_9_to_router_0_10_rsp;
    assign router_0_10_rsp_in[3] = L2_ni_10_to_router_0_10_rsp;
    assign router_0_10_rsp_in[4] = magia_tile_ni_0_10_to_router_0_10_rsp;

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
) router_0_10 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 1, y: 10, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_0_10_req_in),
  .floo_rsp_o (router_0_10_rsp_out),
  .floo_req_o (router_0_10_req_out),
  .floo_rsp_i (router_0_10_rsp_in)
);


floo_req_t [4:0] router_0_11_req_in;
floo_rsp_t [4:0] router_0_11_rsp_out;
floo_req_t [4:0] router_0_11_req_out;
floo_rsp_t [4:0] router_0_11_rsp_in;

    assign router_0_11_req_in[0] = router_0_12_to_router_0_11_req;
    assign router_0_11_req_in[1] = router_1_11_to_router_0_11_req;
    assign router_0_11_req_in[2] = router_0_10_to_router_0_11_req;
    assign router_0_11_req_in[3] = L2_ni_11_to_router_0_11_req;
    assign router_0_11_req_in[4] = magia_tile_ni_0_11_to_router_0_11_req;

    assign router_0_11_to_router_0_12_rsp = router_0_11_rsp_out[0];
    assign router_0_11_to_router_1_11_rsp = router_0_11_rsp_out[1];
    assign router_0_11_to_router_0_10_rsp = router_0_11_rsp_out[2];
    assign router_0_11_to_L2_ni_11_rsp = router_0_11_rsp_out[3];
    assign router_0_11_to_magia_tile_ni_0_11_rsp = router_0_11_rsp_out[4];

    assign router_0_11_to_router_0_12_req = router_0_11_req_out[0];
    assign router_0_11_to_router_1_11_req = router_0_11_req_out[1];
    assign router_0_11_to_router_0_10_req = router_0_11_req_out[2];
    assign router_0_11_to_L2_ni_11_req = router_0_11_req_out[3];
    assign router_0_11_to_magia_tile_ni_0_11_req = router_0_11_req_out[4];

    assign router_0_11_rsp_in[0] = router_0_12_to_router_0_11_rsp;
    assign router_0_11_rsp_in[1] = router_1_11_to_router_0_11_rsp;
    assign router_0_11_rsp_in[2] = router_0_10_to_router_0_11_rsp;
    assign router_0_11_rsp_in[3] = L2_ni_11_to_router_0_11_rsp;
    assign router_0_11_rsp_in[4] = magia_tile_ni_0_11_to_router_0_11_rsp;

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
) router_0_11 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 1, y: 11, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_0_11_req_in),
  .floo_rsp_o (router_0_11_rsp_out),
  .floo_req_o (router_0_11_req_out),
  .floo_rsp_i (router_0_11_rsp_in)
);


floo_req_t [4:0] router_0_12_req_in;
floo_rsp_t [4:0] router_0_12_rsp_out;
floo_req_t [4:0] router_0_12_req_out;
floo_rsp_t [4:0] router_0_12_rsp_in;

    assign router_0_12_req_in[0] = router_0_13_to_router_0_12_req;
    assign router_0_12_req_in[1] = router_1_12_to_router_0_12_req;
    assign router_0_12_req_in[2] = router_0_11_to_router_0_12_req;
    assign router_0_12_req_in[3] = L2_ni_12_to_router_0_12_req;
    assign router_0_12_req_in[4] = magia_tile_ni_0_12_to_router_0_12_req;

    assign router_0_12_to_router_0_13_rsp = router_0_12_rsp_out[0];
    assign router_0_12_to_router_1_12_rsp = router_0_12_rsp_out[1];
    assign router_0_12_to_router_0_11_rsp = router_0_12_rsp_out[2];
    assign router_0_12_to_L2_ni_12_rsp = router_0_12_rsp_out[3];
    assign router_0_12_to_magia_tile_ni_0_12_rsp = router_0_12_rsp_out[4];

    assign router_0_12_to_router_0_13_req = router_0_12_req_out[0];
    assign router_0_12_to_router_1_12_req = router_0_12_req_out[1];
    assign router_0_12_to_router_0_11_req = router_0_12_req_out[2];
    assign router_0_12_to_L2_ni_12_req = router_0_12_req_out[3];
    assign router_0_12_to_magia_tile_ni_0_12_req = router_0_12_req_out[4];

    assign router_0_12_rsp_in[0] = router_0_13_to_router_0_12_rsp;
    assign router_0_12_rsp_in[1] = router_1_12_to_router_0_12_rsp;
    assign router_0_12_rsp_in[2] = router_0_11_to_router_0_12_rsp;
    assign router_0_12_rsp_in[3] = L2_ni_12_to_router_0_12_rsp;
    assign router_0_12_rsp_in[4] = magia_tile_ni_0_12_to_router_0_12_rsp;

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
) router_0_12 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 1, y: 12, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_0_12_req_in),
  .floo_rsp_o (router_0_12_rsp_out),
  .floo_req_o (router_0_12_req_out),
  .floo_rsp_i (router_0_12_rsp_in)
);


floo_req_t [4:0] router_0_13_req_in;
floo_rsp_t [4:0] router_0_13_rsp_out;
floo_req_t [4:0] router_0_13_req_out;
floo_rsp_t [4:0] router_0_13_rsp_in;

    assign router_0_13_req_in[0] = router_0_14_to_router_0_13_req;
    assign router_0_13_req_in[1] = router_1_13_to_router_0_13_req;
    assign router_0_13_req_in[2] = router_0_12_to_router_0_13_req;
    assign router_0_13_req_in[3] = L2_ni_13_to_router_0_13_req;
    assign router_0_13_req_in[4] = magia_tile_ni_0_13_to_router_0_13_req;

    assign router_0_13_to_router_0_14_rsp = router_0_13_rsp_out[0];
    assign router_0_13_to_router_1_13_rsp = router_0_13_rsp_out[1];
    assign router_0_13_to_router_0_12_rsp = router_0_13_rsp_out[2];
    assign router_0_13_to_L2_ni_13_rsp = router_0_13_rsp_out[3];
    assign router_0_13_to_magia_tile_ni_0_13_rsp = router_0_13_rsp_out[4];

    assign router_0_13_to_router_0_14_req = router_0_13_req_out[0];
    assign router_0_13_to_router_1_13_req = router_0_13_req_out[1];
    assign router_0_13_to_router_0_12_req = router_0_13_req_out[2];
    assign router_0_13_to_L2_ni_13_req = router_0_13_req_out[3];
    assign router_0_13_to_magia_tile_ni_0_13_req = router_0_13_req_out[4];

    assign router_0_13_rsp_in[0] = router_0_14_to_router_0_13_rsp;
    assign router_0_13_rsp_in[1] = router_1_13_to_router_0_13_rsp;
    assign router_0_13_rsp_in[2] = router_0_12_to_router_0_13_rsp;
    assign router_0_13_rsp_in[3] = L2_ni_13_to_router_0_13_rsp;
    assign router_0_13_rsp_in[4] = magia_tile_ni_0_13_to_router_0_13_rsp;

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
) router_0_13 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 1, y: 13, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_0_13_req_in),
  .floo_rsp_o (router_0_13_rsp_out),
  .floo_req_o (router_0_13_req_out),
  .floo_rsp_i (router_0_13_rsp_in)
);


floo_req_t [4:0] router_0_14_req_in;
floo_rsp_t [4:0] router_0_14_rsp_out;
floo_req_t [4:0] router_0_14_req_out;
floo_rsp_t [4:0] router_0_14_rsp_in;

    assign router_0_14_req_in[0] = router_0_15_to_router_0_14_req;
    assign router_0_14_req_in[1] = router_1_14_to_router_0_14_req;
    assign router_0_14_req_in[2] = router_0_13_to_router_0_14_req;
    assign router_0_14_req_in[3] = L2_ni_14_to_router_0_14_req;
    assign router_0_14_req_in[4] = magia_tile_ni_0_14_to_router_0_14_req;

    assign router_0_14_to_router_0_15_rsp = router_0_14_rsp_out[0];
    assign router_0_14_to_router_1_14_rsp = router_0_14_rsp_out[1];
    assign router_0_14_to_router_0_13_rsp = router_0_14_rsp_out[2];
    assign router_0_14_to_L2_ni_14_rsp = router_0_14_rsp_out[3];
    assign router_0_14_to_magia_tile_ni_0_14_rsp = router_0_14_rsp_out[4];

    assign router_0_14_to_router_0_15_req = router_0_14_req_out[0];
    assign router_0_14_to_router_1_14_req = router_0_14_req_out[1];
    assign router_0_14_to_router_0_13_req = router_0_14_req_out[2];
    assign router_0_14_to_L2_ni_14_req = router_0_14_req_out[3];
    assign router_0_14_to_magia_tile_ni_0_14_req = router_0_14_req_out[4];

    assign router_0_14_rsp_in[0] = router_0_15_to_router_0_14_rsp;
    assign router_0_14_rsp_in[1] = router_1_14_to_router_0_14_rsp;
    assign router_0_14_rsp_in[2] = router_0_13_to_router_0_14_rsp;
    assign router_0_14_rsp_in[3] = L2_ni_14_to_router_0_14_rsp;
    assign router_0_14_rsp_in[4] = magia_tile_ni_0_14_to_router_0_14_rsp;

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
) router_0_14 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 1, y: 14, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_0_14_req_in),
  .floo_rsp_o (router_0_14_rsp_out),
  .floo_req_o (router_0_14_req_out),
  .floo_rsp_i (router_0_14_rsp_in)
);


floo_req_t [4:0] router_0_15_req_in;
floo_rsp_t [4:0] router_0_15_rsp_out;
floo_req_t [4:0] router_0_15_req_out;
floo_rsp_t [4:0] router_0_15_rsp_in;

    assign router_0_15_req_in[0] = '0;
    assign router_0_15_req_in[1] = router_1_15_to_router_0_15_req;
    assign router_0_15_req_in[2] = router_0_14_to_router_0_15_req;
    assign router_0_15_req_in[3] = L2_ni_15_to_router_0_15_req;
    assign router_0_15_req_in[4] = magia_tile_ni_0_15_to_router_0_15_req;

    assign router_0_15_to_router_1_15_rsp = router_0_15_rsp_out[1];
    assign router_0_15_to_router_0_14_rsp = router_0_15_rsp_out[2];
    assign router_0_15_to_L2_ni_15_rsp = router_0_15_rsp_out[3];
    assign router_0_15_to_magia_tile_ni_0_15_rsp = router_0_15_rsp_out[4];

    assign router_0_15_to_router_1_15_req = router_0_15_req_out[1];
    assign router_0_15_to_router_0_14_req = router_0_15_req_out[2];
    assign router_0_15_to_L2_ni_15_req = router_0_15_req_out[3];
    assign router_0_15_to_magia_tile_ni_0_15_req = router_0_15_req_out[4];

    assign router_0_15_rsp_in[0] = '0;
    assign router_0_15_rsp_in[1] = router_1_15_to_router_0_15_rsp;
    assign router_0_15_rsp_in[2] = router_0_14_to_router_0_15_rsp;
    assign router_0_15_rsp_in[3] = L2_ni_15_to_router_0_15_rsp;
    assign router_0_15_rsp_in[4] = magia_tile_ni_0_15_to_router_0_15_rsp;

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
) router_0_15 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 1, y: 15, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_0_15_req_in),
  .floo_rsp_o (router_0_15_rsp_out),
  .floo_req_o (router_0_15_req_out),
  .floo_rsp_i (router_0_15_rsp_in)
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

    assign router_1_7_req_in[0] = router_1_8_to_router_1_7_req;
    assign router_1_7_req_in[1] = router_2_7_to_router_1_7_req;
    assign router_1_7_req_in[2] = router_1_6_to_router_1_7_req;
    assign router_1_7_req_in[3] = router_0_7_to_router_1_7_req;
    assign router_1_7_req_in[4] = magia_tile_ni_1_7_to_router_1_7_req;

    assign router_1_7_to_router_1_8_rsp = router_1_7_rsp_out[0];
    assign router_1_7_to_router_2_7_rsp = router_1_7_rsp_out[1];
    assign router_1_7_to_router_1_6_rsp = router_1_7_rsp_out[2];
    assign router_1_7_to_router_0_7_rsp = router_1_7_rsp_out[3];
    assign router_1_7_to_magia_tile_ni_1_7_rsp = router_1_7_rsp_out[4];

    assign router_1_7_to_router_1_8_req = router_1_7_req_out[0];
    assign router_1_7_to_router_2_7_req = router_1_7_req_out[1];
    assign router_1_7_to_router_1_6_req = router_1_7_req_out[2];
    assign router_1_7_to_router_0_7_req = router_1_7_req_out[3];
    assign router_1_7_to_magia_tile_ni_1_7_req = router_1_7_req_out[4];

    assign router_1_7_rsp_in[0] = router_1_8_to_router_1_7_rsp;
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


floo_req_t [4:0] router_1_8_req_in;
floo_rsp_t [4:0] router_1_8_rsp_out;
floo_req_t [4:0] router_1_8_req_out;
floo_rsp_t [4:0] router_1_8_rsp_in;

    assign router_1_8_req_in[0] = router_1_9_to_router_1_8_req;
    assign router_1_8_req_in[1] = router_2_8_to_router_1_8_req;
    assign router_1_8_req_in[2] = router_1_7_to_router_1_8_req;
    assign router_1_8_req_in[3] = router_0_8_to_router_1_8_req;
    assign router_1_8_req_in[4] = magia_tile_ni_1_8_to_router_1_8_req;

    assign router_1_8_to_router_1_9_rsp = router_1_8_rsp_out[0];
    assign router_1_8_to_router_2_8_rsp = router_1_8_rsp_out[1];
    assign router_1_8_to_router_1_7_rsp = router_1_8_rsp_out[2];
    assign router_1_8_to_router_0_8_rsp = router_1_8_rsp_out[3];
    assign router_1_8_to_magia_tile_ni_1_8_rsp = router_1_8_rsp_out[4];

    assign router_1_8_to_router_1_9_req = router_1_8_req_out[0];
    assign router_1_8_to_router_2_8_req = router_1_8_req_out[1];
    assign router_1_8_to_router_1_7_req = router_1_8_req_out[2];
    assign router_1_8_to_router_0_8_req = router_1_8_req_out[3];
    assign router_1_8_to_magia_tile_ni_1_8_req = router_1_8_req_out[4];

    assign router_1_8_rsp_in[0] = router_1_9_to_router_1_8_rsp;
    assign router_1_8_rsp_in[1] = router_2_8_to_router_1_8_rsp;
    assign router_1_8_rsp_in[2] = router_1_7_to_router_1_8_rsp;
    assign router_1_8_rsp_in[3] = router_0_8_to_router_1_8_rsp;
    assign router_1_8_rsp_in[4] = magia_tile_ni_1_8_to_router_1_8_rsp;

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
) router_1_8 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 2, y: 8, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_1_8_req_in),
  .floo_rsp_o (router_1_8_rsp_out),
  .floo_req_o (router_1_8_req_out),
  .floo_rsp_i (router_1_8_rsp_in)
);


floo_req_t [4:0] router_1_9_req_in;
floo_rsp_t [4:0] router_1_9_rsp_out;
floo_req_t [4:0] router_1_9_req_out;
floo_rsp_t [4:0] router_1_9_rsp_in;

    assign router_1_9_req_in[0] = router_1_10_to_router_1_9_req;
    assign router_1_9_req_in[1] = router_2_9_to_router_1_9_req;
    assign router_1_9_req_in[2] = router_1_8_to_router_1_9_req;
    assign router_1_9_req_in[3] = router_0_9_to_router_1_9_req;
    assign router_1_9_req_in[4] = magia_tile_ni_1_9_to_router_1_9_req;

    assign router_1_9_to_router_1_10_rsp = router_1_9_rsp_out[0];
    assign router_1_9_to_router_2_9_rsp = router_1_9_rsp_out[1];
    assign router_1_9_to_router_1_8_rsp = router_1_9_rsp_out[2];
    assign router_1_9_to_router_0_9_rsp = router_1_9_rsp_out[3];
    assign router_1_9_to_magia_tile_ni_1_9_rsp = router_1_9_rsp_out[4];

    assign router_1_9_to_router_1_10_req = router_1_9_req_out[0];
    assign router_1_9_to_router_2_9_req = router_1_9_req_out[1];
    assign router_1_9_to_router_1_8_req = router_1_9_req_out[2];
    assign router_1_9_to_router_0_9_req = router_1_9_req_out[3];
    assign router_1_9_to_magia_tile_ni_1_9_req = router_1_9_req_out[4];

    assign router_1_9_rsp_in[0] = router_1_10_to_router_1_9_rsp;
    assign router_1_9_rsp_in[1] = router_2_9_to_router_1_9_rsp;
    assign router_1_9_rsp_in[2] = router_1_8_to_router_1_9_rsp;
    assign router_1_9_rsp_in[3] = router_0_9_to_router_1_9_rsp;
    assign router_1_9_rsp_in[4] = magia_tile_ni_1_9_to_router_1_9_rsp;

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
) router_1_9 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 2, y: 9, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_1_9_req_in),
  .floo_rsp_o (router_1_9_rsp_out),
  .floo_req_o (router_1_9_req_out),
  .floo_rsp_i (router_1_9_rsp_in)
);


floo_req_t [4:0] router_1_10_req_in;
floo_rsp_t [4:0] router_1_10_rsp_out;
floo_req_t [4:0] router_1_10_req_out;
floo_rsp_t [4:0] router_1_10_rsp_in;

    assign router_1_10_req_in[0] = router_1_11_to_router_1_10_req;
    assign router_1_10_req_in[1] = router_2_10_to_router_1_10_req;
    assign router_1_10_req_in[2] = router_1_9_to_router_1_10_req;
    assign router_1_10_req_in[3] = router_0_10_to_router_1_10_req;
    assign router_1_10_req_in[4] = magia_tile_ni_1_10_to_router_1_10_req;

    assign router_1_10_to_router_1_11_rsp = router_1_10_rsp_out[0];
    assign router_1_10_to_router_2_10_rsp = router_1_10_rsp_out[1];
    assign router_1_10_to_router_1_9_rsp = router_1_10_rsp_out[2];
    assign router_1_10_to_router_0_10_rsp = router_1_10_rsp_out[3];
    assign router_1_10_to_magia_tile_ni_1_10_rsp = router_1_10_rsp_out[4];

    assign router_1_10_to_router_1_11_req = router_1_10_req_out[0];
    assign router_1_10_to_router_2_10_req = router_1_10_req_out[1];
    assign router_1_10_to_router_1_9_req = router_1_10_req_out[2];
    assign router_1_10_to_router_0_10_req = router_1_10_req_out[3];
    assign router_1_10_to_magia_tile_ni_1_10_req = router_1_10_req_out[4];

    assign router_1_10_rsp_in[0] = router_1_11_to_router_1_10_rsp;
    assign router_1_10_rsp_in[1] = router_2_10_to_router_1_10_rsp;
    assign router_1_10_rsp_in[2] = router_1_9_to_router_1_10_rsp;
    assign router_1_10_rsp_in[3] = router_0_10_to_router_1_10_rsp;
    assign router_1_10_rsp_in[4] = magia_tile_ni_1_10_to_router_1_10_rsp;

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
) router_1_10 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 2, y: 10, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_1_10_req_in),
  .floo_rsp_o (router_1_10_rsp_out),
  .floo_req_o (router_1_10_req_out),
  .floo_rsp_i (router_1_10_rsp_in)
);


floo_req_t [4:0] router_1_11_req_in;
floo_rsp_t [4:0] router_1_11_rsp_out;
floo_req_t [4:0] router_1_11_req_out;
floo_rsp_t [4:0] router_1_11_rsp_in;

    assign router_1_11_req_in[0] = router_1_12_to_router_1_11_req;
    assign router_1_11_req_in[1] = router_2_11_to_router_1_11_req;
    assign router_1_11_req_in[2] = router_1_10_to_router_1_11_req;
    assign router_1_11_req_in[3] = router_0_11_to_router_1_11_req;
    assign router_1_11_req_in[4] = magia_tile_ni_1_11_to_router_1_11_req;

    assign router_1_11_to_router_1_12_rsp = router_1_11_rsp_out[0];
    assign router_1_11_to_router_2_11_rsp = router_1_11_rsp_out[1];
    assign router_1_11_to_router_1_10_rsp = router_1_11_rsp_out[2];
    assign router_1_11_to_router_0_11_rsp = router_1_11_rsp_out[3];
    assign router_1_11_to_magia_tile_ni_1_11_rsp = router_1_11_rsp_out[4];

    assign router_1_11_to_router_1_12_req = router_1_11_req_out[0];
    assign router_1_11_to_router_2_11_req = router_1_11_req_out[1];
    assign router_1_11_to_router_1_10_req = router_1_11_req_out[2];
    assign router_1_11_to_router_0_11_req = router_1_11_req_out[3];
    assign router_1_11_to_magia_tile_ni_1_11_req = router_1_11_req_out[4];

    assign router_1_11_rsp_in[0] = router_1_12_to_router_1_11_rsp;
    assign router_1_11_rsp_in[1] = router_2_11_to_router_1_11_rsp;
    assign router_1_11_rsp_in[2] = router_1_10_to_router_1_11_rsp;
    assign router_1_11_rsp_in[3] = router_0_11_to_router_1_11_rsp;
    assign router_1_11_rsp_in[4] = magia_tile_ni_1_11_to_router_1_11_rsp;

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
) router_1_11 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 2, y: 11, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_1_11_req_in),
  .floo_rsp_o (router_1_11_rsp_out),
  .floo_req_o (router_1_11_req_out),
  .floo_rsp_i (router_1_11_rsp_in)
);


floo_req_t [4:0] router_1_12_req_in;
floo_rsp_t [4:0] router_1_12_rsp_out;
floo_req_t [4:0] router_1_12_req_out;
floo_rsp_t [4:0] router_1_12_rsp_in;

    assign router_1_12_req_in[0] = router_1_13_to_router_1_12_req;
    assign router_1_12_req_in[1] = router_2_12_to_router_1_12_req;
    assign router_1_12_req_in[2] = router_1_11_to_router_1_12_req;
    assign router_1_12_req_in[3] = router_0_12_to_router_1_12_req;
    assign router_1_12_req_in[4] = magia_tile_ni_1_12_to_router_1_12_req;

    assign router_1_12_to_router_1_13_rsp = router_1_12_rsp_out[0];
    assign router_1_12_to_router_2_12_rsp = router_1_12_rsp_out[1];
    assign router_1_12_to_router_1_11_rsp = router_1_12_rsp_out[2];
    assign router_1_12_to_router_0_12_rsp = router_1_12_rsp_out[3];
    assign router_1_12_to_magia_tile_ni_1_12_rsp = router_1_12_rsp_out[4];

    assign router_1_12_to_router_1_13_req = router_1_12_req_out[0];
    assign router_1_12_to_router_2_12_req = router_1_12_req_out[1];
    assign router_1_12_to_router_1_11_req = router_1_12_req_out[2];
    assign router_1_12_to_router_0_12_req = router_1_12_req_out[3];
    assign router_1_12_to_magia_tile_ni_1_12_req = router_1_12_req_out[4];

    assign router_1_12_rsp_in[0] = router_1_13_to_router_1_12_rsp;
    assign router_1_12_rsp_in[1] = router_2_12_to_router_1_12_rsp;
    assign router_1_12_rsp_in[2] = router_1_11_to_router_1_12_rsp;
    assign router_1_12_rsp_in[3] = router_0_12_to_router_1_12_rsp;
    assign router_1_12_rsp_in[4] = magia_tile_ni_1_12_to_router_1_12_rsp;

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
) router_1_12 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 2, y: 12, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_1_12_req_in),
  .floo_rsp_o (router_1_12_rsp_out),
  .floo_req_o (router_1_12_req_out),
  .floo_rsp_i (router_1_12_rsp_in)
);


floo_req_t [4:0] router_1_13_req_in;
floo_rsp_t [4:0] router_1_13_rsp_out;
floo_req_t [4:0] router_1_13_req_out;
floo_rsp_t [4:0] router_1_13_rsp_in;

    assign router_1_13_req_in[0] = router_1_14_to_router_1_13_req;
    assign router_1_13_req_in[1] = router_2_13_to_router_1_13_req;
    assign router_1_13_req_in[2] = router_1_12_to_router_1_13_req;
    assign router_1_13_req_in[3] = router_0_13_to_router_1_13_req;
    assign router_1_13_req_in[4] = magia_tile_ni_1_13_to_router_1_13_req;

    assign router_1_13_to_router_1_14_rsp = router_1_13_rsp_out[0];
    assign router_1_13_to_router_2_13_rsp = router_1_13_rsp_out[1];
    assign router_1_13_to_router_1_12_rsp = router_1_13_rsp_out[2];
    assign router_1_13_to_router_0_13_rsp = router_1_13_rsp_out[3];
    assign router_1_13_to_magia_tile_ni_1_13_rsp = router_1_13_rsp_out[4];

    assign router_1_13_to_router_1_14_req = router_1_13_req_out[0];
    assign router_1_13_to_router_2_13_req = router_1_13_req_out[1];
    assign router_1_13_to_router_1_12_req = router_1_13_req_out[2];
    assign router_1_13_to_router_0_13_req = router_1_13_req_out[3];
    assign router_1_13_to_magia_tile_ni_1_13_req = router_1_13_req_out[4];

    assign router_1_13_rsp_in[0] = router_1_14_to_router_1_13_rsp;
    assign router_1_13_rsp_in[1] = router_2_13_to_router_1_13_rsp;
    assign router_1_13_rsp_in[2] = router_1_12_to_router_1_13_rsp;
    assign router_1_13_rsp_in[3] = router_0_13_to_router_1_13_rsp;
    assign router_1_13_rsp_in[4] = magia_tile_ni_1_13_to_router_1_13_rsp;

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
) router_1_13 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 2, y: 13, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_1_13_req_in),
  .floo_rsp_o (router_1_13_rsp_out),
  .floo_req_o (router_1_13_req_out),
  .floo_rsp_i (router_1_13_rsp_in)
);


floo_req_t [4:0] router_1_14_req_in;
floo_rsp_t [4:0] router_1_14_rsp_out;
floo_req_t [4:0] router_1_14_req_out;
floo_rsp_t [4:0] router_1_14_rsp_in;

    assign router_1_14_req_in[0] = router_1_15_to_router_1_14_req;
    assign router_1_14_req_in[1] = router_2_14_to_router_1_14_req;
    assign router_1_14_req_in[2] = router_1_13_to_router_1_14_req;
    assign router_1_14_req_in[3] = router_0_14_to_router_1_14_req;
    assign router_1_14_req_in[4] = magia_tile_ni_1_14_to_router_1_14_req;

    assign router_1_14_to_router_1_15_rsp = router_1_14_rsp_out[0];
    assign router_1_14_to_router_2_14_rsp = router_1_14_rsp_out[1];
    assign router_1_14_to_router_1_13_rsp = router_1_14_rsp_out[2];
    assign router_1_14_to_router_0_14_rsp = router_1_14_rsp_out[3];
    assign router_1_14_to_magia_tile_ni_1_14_rsp = router_1_14_rsp_out[4];

    assign router_1_14_to_router_1_15_req = router_1_14_req_out[0];
    assign router_1_14_to_router_2_14_req = router_1_14_req_out[1];
    assign router_1_14_to_router_1_13_req = router_1_14_req_out[2];
    assign router_1_14_to_router_0_14_req = router_1_14_req_out[3];
    assign router_1_14_to_magia_tile_ni_1_14_req = router_1_14_req_out[4];

    assign router_1_14_rsp_in[0] = router_1_15_to_router_1_14_rsp;
    assign router_1_14_rsp_in[1] = router_2_14_to_router_1_14_rsp;
    assign router_1_14_rsp_in[2] = router_1_13_to_router_1_14_rsp;
    assign router_1_14_rsp_in[3] = router_0_14_to_router_1_14_rsp;
    assign router_1_14_rsp_in[4] = magia_tile_ni_1_14_to_router_1_14_rsp;

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
) router_1_14 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 2, y: 14, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_1_14_req_in),
  .floo_rsp_o (router_1_14_rsp_out),
  .floo_req_o (router_1_14_req_out),
  .floo_rsp_i (router_1_14_rsp_in)
);


floo_req_t [4:0] router_1_15_req_in;
floo_rsp_t [4:0] router_1_15_rsp_out;
floo_req_t [4:0] router_1_15_req_out;
floo_rsp_t [4:0] router_1_15_rsp_in;

    assign router_1_15_req_in[0] = '0;
    assign router_1_15_req_in[1] = router_2_15_to_router_1_15_req;
    assign router_1_15_req_in[2] = router_1_14_to_router_1_15_req;
    assign router_1_15_req_in[3] = router_0_15_to_router_1_15_req;
    assign router_1_15_req_in[4] = magia_tile_ni_1_15_to_router_1_15_req;

    assign router_1_15_to_router_2_15_rsp = router_1_15_rsp_out[1];
    assign router_1_15_to_router_1_14_rsp = router_1_15_rsp_out[2];
    assign router_1_15_to_router_0_15_rsp = router_1_15_rsp_out[3];
    assign router_1_15_to_magia_tile_ni_1_15_rsp = router_1_15_rsp_out[4];

    assign router_1_15_to_router_2_15_req = router_1_15_req_out[1];
    assign router_1_15_to_router_1_14_req = router_1_15_req_out[2];
    assign router_1_15_to_router_0_15_req = router_1_15_req_out[3];
    assign router_1_15_to_magia_tile_ni_1_15_req = router_1_15_req_out[4];

    assign router_1_15_rsp_in[0] = '0;
    assign router_1_15_rsp_in[1] = router_2_15_to_router_1_15_rsp;
    assign router_1_15_rsp_in[2] = router_1_14_to_router_1_15_rsp;
    assign router_1_15_rsp_in[3] = router_0_15_to_router_1_15_rsp;
    assign router_1_15_rsp_in[4] = magia_tile_ni_1_15_to_router_1_15_rsp;

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
) router_1_15 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 2, y: 15, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_1_15_req_in),
  .floo_rsp_o (router_1_15_rsp_out),
  .floo_req_o (router_1_15_req_out),
  .floo_rsp_i (router_1_15_rsp_in)
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

    assign router_2_7_req_in[0] = router_2_8_to_router_2_7_req;
    assign router_2_7_req_in[1] = router_3_7_to_router_2_7_req;
    assign router_2_7_req_in[2] = router_2_6_to_router_2_7_req;
    assign router_2_7_req_in[3] = router_1_7_to_router_2_7_req;
    assign router_2_7_req_in[4] = magia_tile_ni_2_7_to_router_2_7_req;

    assign router_2_7_to_router_2_8_rsp = router_2_7_rsp_out[0];
    assign router_2_7_to_router_3_7_rsp = router_2_7_rsp_out[1];
    assign router_2_7_to_router_2_6_rsp = router_2_7_rsp_out[2];
    assign router_2_7_to_router_1_7_rsp = router_2_7_rsp_out[3];
    assign router_2_7_to_magia_tile_ni_2_7_rsp = router_2_7_rsp_out[4];

    assign router_2_7_to_router_2_8_req = router_2_7_req_out[0];
    assign router_2_7_to_router_3_7_req = router_2_7_req_out[1];
    assign router_2_7_to_router_2_6_req = router_2_7_req_out[2];
    assign router_2_7_to_router_1_7_req = router_2_7_req_out[3];
    assign router_2_7_to_magia_tile_ni_2_7_req = router_2_7_req_out[4];

    assign router_2_7_rsp_in[0] = router_2_8_to_router_2_7_rsp;
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


floo_req_t [4:0] router_2_8_req_in;
floo_rsp_t [4:0] router_2_8_rsp_out;
floo_req_t [4:0] router_2_8_req_out;
floo_rsp_t [4:0] router_2_8_rsp_in;

    assign router_2_8_req_in[0] = router_2_9_to_router_2_8_req;
    assign router_2_8_req_in[1] = router_3_8_to_router_2_8_req;
    assign router_2_8_req_in[2] = router_2_7_to_router_2_8_req;
    assign router_2_8_req_in[3] = router_1_8_to_router_2_8_req;
    assign router_2_8_req_in[4] = magia_tile_ni_2_8_to_router_2_8_req;

    assign router_2_8_to_router_2_9_rsp = router_2_8_rsp_out[0];
    assign router_2_8_to_router_3_8_rsp = router_2_8_rsp_out[1];
    assign router_2_8_to_router_2_7_rsp = router_2_8_rsp_out[2];
    assign router_2_8_to_router_1_8_rsp = router_2_8_rsp_out[3];
    assign router_2_8_to_magia_tile_ni_2_8_rsp = router_2_8_rsp_out[4];

    assign router_2_8_to_router_2_9_req = router_2_8_req_out[0];
    assign router_2_8_to_router_3_8_req = router_2_8_req_out[1];
    assign router_2_8_to_router_2_7_req = router_2_8_req_out[2];
    assign router_2_8_to_router_1_8_req = router_2_8_req_out[3];
    assign router_2_8_to_magia_tile_ni_2_8_req = router_2_8_req_out[4];

    assign router_2_8_rsp_in[0] = router_2_9_to_router_2_8_rsp;
    assign router_2_8_rsp_in[1] = router_3_8_to_router_2_8_rsp;
    assign router_2_8_rsp_in[2] = router_2_7_to_router_2_8_rsp;
    assign router_2_8_rsp_in[3] = router_1_8_to_router_2_8_rsp;
    assign router_2_8_rsp_in[4] = magia_tile_ni_2_8_to_router_2_8_rsp;

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
) router_2_8 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 3, y: 8, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_2_8_req_in),
  .floo_rsp_o (router_2_8_rsp_out),
  .floo_req_o (router_2_8_req_out),
  .floo_rsp_i (router_2_8_rsp_in)
);


floo_req_t [4:0] router_2_9_req_in;
floo_rsp_t [4:0] router_2_9_rsp_out;
floo_req_t [4:0] router_2_9_req_out;
floo_rsp_t [4:0] router_2_9_rsp_in;

    assign router_2_9_req_in[0] = router_2_10_to_router_2_9_req;
    assign router_2_9_req_in[1] = router_3_9_to_router_2_9_req;
    assign router_2_9_req_in[2] = router_2_8_to_router_2_9_req;
    assign router_2_9_req_in[3] = router_1_9_to_router_2_9_req;
    assign router_2_9_req_in[4] = magia_tile_ni_2_9_to_router_2_9_req;

    assign router_2_9_to_router_2_10_rsp = router_2_9_rsp_out[0];
    assign router_2_9_to_router_3_9_rsp = router_2_9_rsp_out[1];
    assign router_2_9_to_router_2_8_rsp = router_2_9_rsp_out[2];
    assign router_2_9_to_router_1_9_rsp = router_2_9_rsp_out[3];
    assign router_2_9_to_magia_tile_ni_2_9_rsp = router_2_9_rsp_out[4];

    assign router_2_9_to_router_2_10_req = router_2_9_req_out[0];
    assign router_2_9_to_router_3_9_req = router_2_9_req_out[1];
    assign router_2_9_to_router_2_8_req = router_2_9_req_out[2];
    assign router_2_9_to_router_1_9_req = router_2_9_req_out[3];
    assign router_2_9_to_magia_tile_ni_2_9_req = router_2_9_req_out[4];

    assign router_2_9_rsp_in[0] = router_2_10_to_router_2_9_rsp;
    assign router_2_9_rsp_in[1] = router_3_9_to_router_2_9_rsp;
    assign router_2_9_rsp_in[2] = router_2_8_to_router_2_9_rsp;
    assign router_2_9_rsp_in[3] = router_1_9_to_router_2_9_rsp;
    assign router_2_9_rsp_in[4] = magia_tile_ni_2_9_to_router_2_9_rsp;

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
) router_2_9 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 3, y: 9, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_2_9_req_in),
  .floo_rsp_o (router_2_9_rsp_out),
  .floo_req_o (router_2_9_req_out),
  .floo_rsp_i (router_2_9_rsp_in)
);


floo_req_t [4:0] router_2_10_req_in;
floo_rsp_t [4:0] router_2_10_rsp_out;
floo_req_t [4:0] router_2_10_req_out;
floo_rsp_t [4:0] router_2_10_rsp_in;

    assign router_2_10_req_in[0] = router_2_11_to_router_2_10_req;
    assign router_2_10_req_in[1] = router_3_10_to_router_2_10_req;
    assign router_2_10_req_in[2] = router_2_9_to_router_2_10_req;
    assign router_2_10_req_in[3] = router_1_10_to_router_2_10_req;
    assign router_2_10_req_in[4] = magia_tile_ni_2_10_to_router_2_10_req;

    assign router_2_10_to_router_2_11_rsp = router_2_10_rsp_out[0];
    assign router_2_10_to_router_3_10_rsp = router_2_10_rsp_out[1];
    assign router_2_10_to_router_2_9_rsp = router_2_10_rsp_out[2];
    assign router_2_10_to_router_1_10_rsp = router_2_10_rsp_out[3];
    assign router_2_10_to_magia_tile_ni_2_10_rsp = router_2_10_rsp_out[4];

    assign router_2_10_to_router_2_11_req = router_2_10_req_out[0];
    assign router_2_10_to_router_3_10_req = router_2_10_req_out[1];
    assign router_2_10_to_router_2_9_req = router_2_10_req_out[2];
    assign router_2_10_to_router_1_10_req = router_2_10_req_out[3];
    assign router_2_10_to_magia_tile_ni_2_10_req = router_2_10_req_out[4];

    assign router_2_10_rsp_in[0] = router_2_11_to_router_2_10_rsp;
    assign router_2_10_rsp_in[1] = router_3_10_to_router_2_10_rsp;
    assign router_2_10_rsp_in[2] = router_2_9_to_router_2_10_rsp;
    assign router_2_10_rsp_in[3] = router_1_10_to_router_2_10_rsp;
    assign router_2_10_rsp_in[4] = magia_tile_ni_2_10_to_router_2_10_rsp;

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
) router_2_10 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 3, y: 10, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_2_10_req_in),
  .floo_rsp_o (router_2_10_rsp_out),
  .floo_req_o (router_2_10_req_out),
  .floo_rsp_i (router_2_10_rsp_in)
);


floo_req_t [4:0] router_2_11_req_in;
floo_rsp_t [4:0] router_2_11_rsp_out;
floo_req_t [4:0] router_2_11_req_out;
floo_rsp_t [4:0] router_2_11_rsp_in;

    assign router_2_11_req_in[0] = router_2_12_to_router_2_11_req;
    assign router_2_11_req_in[1] = router_3_11_to_router_2_11_req;
    assign router_2_11_req_in[2] = router_2_10_to_router_2_11_req;
    assign router_2_11_req_in[3] = router_1_11_to_router_2_11_req;
    assign router_2_11_req_in[4] = magia_tile_ni_2_11_to_router_2_11_req;

    assign router_2_11_to_router_2_12_rsp = router_2_11_rsp_out[0];
    assign router_2_11_to_router_3_11_rsp = router_2_11_rsp_out[1];
    assign router_2_11_to_router_2_10_rsp = router_2_11_rsp_out[2];
    assign router_2_11_to_router_1_11_rsp = router_2_11_rsp_out[3];
    assign router_2_11_to_magia_tile_ni_2_11_rsp = router_2_11_rsp_out[4];

    assign router_2_11_to_router_2_12_req = router_2_11_req_out[0];
    assign router_2_11_to_router_3_11_req = router_2_11_req_out[1];
    assign router_2_11_to_router_2_10_req = router_2_11_req_out[2];
    assign router_2_11_to_router_1_11_req = router_2_11_req_out[3];
    assign router_2_11_to_magia_tile_ni_2_11_req = router_2_11_req_out[4];

    assign router_2_11_rsp_in[0] = router_2_12_to_router_2_11_rsp;
    assign router_2_11_rsp_in[1] = router_3_11_to_router_2_11_rsp;
    assign router_2_11_rsp_in[2] = router_2_10_to_router_2_11_rsp;
    assign router_2_11_rsp_in[3] = router_1_11_to_router_2_11_rsp;
    assign router_2_11_rsp_in[4] = magia_tile_ni_2_11_to_router_2_11_rsp;

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
) router_2_11 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 3, y: 11, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_2_11_req_in),
  .floo_rsp_o (router_2_11_rsp_out),
  .floo_req_o (router_2_11_req_out),
  .floo_rsp_i (router_2_11_rsp_in)
);


floo_req_t [4:0] router_2_12_req_in;
floo_rsp_t [4:0] router_2_12_rsp_out;
floo_req_t [4:0] router_2_12_req_out;
floo_rsp_t [4:0] router_2_12_rsp_in;

    assign router_2_12_req_in[0] = router_2_13_to_router_2_12_req;
    assign router_2_12_req_in[1] = router_3_12_to_router_2_12_req;
    assign router_2_12_req_in[2] = router_2_11_to_router_2_12_req;
    assign router_2_12_req_in[3] = router_1_12_to_router_2_12_req;
    assign router_2_12_req_in[4] = magia_tile_ni_2_12_to_router_2_12_req;

    assign router_2_12_to_router_2_13_rsp = router_2_12_rsp_out[0];
    assign router_2_12_to_router_3_12_rsp = router_2_12_rsp_out[1];
    assign router_2_12_to_router_2_11_rsp = router_2_12_rsp_out[2];
    assign router_2_12_to_router_1_12_rsp = router_2_12_rsp_out[3];
    assign router_2_12_to_magia_tile_ni_2_12_rsp = router_2_12_rsp_out[4];

    assign router_2_12_to_router_2_13_req = router_2_12_req_out[0];
    assign router_2_12_to_router_3_12_req = router_2_12_req_out[1];
    assign router_2_12_to_router_2_11_req = router_2_12_req_out[2];
    assign router_2_12_to_router_1_12_req = router_2_12_req_out[3];
    assign router_2_12_to_magia_tile_ni_2_12_req = router_2_12_req_out[4];

    assign router_2_12_rsp_in[0] = router_2_13_to_router_2_12_rsp;
    assign router_2_12_rsp_in[1] = router_3_12_to_router_2_12_rsp;
    assign router_2_12_rsp_in[2] = router_2_11_to_router_2_12_rsp;
    assign router_2_12_rsp_in[3] = router_1_12_to_router_2_12_rsp;
    assign router_2_12_rsp_in[4] = magia_tile_ni_2_12_to_router_2_12_rsp;

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
) router_2_12 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 3, y: 12, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_2_12_req_in),
  .floo_rsp_o (router_2_12_rsp_out),
  .floo_req_o (router_2_12_req_out),
  .floo_rsp_i (router_2_12_rsp_in)
);


floo_req_t [4:0] router_2_13_req_in;
floo_rsp_t [4:0] router_2_13_rsp_out;
floo_req_t [4:0] router_2_13_req_out;
floo_rsp_t [4:0] router_2_13_rsp_in;

    assign router_2_13_req_in[0] = router_2_14_to_router_2_13_req;
    assign router_2_13_req_in[1] = router_3_13_to_router_2_13_req;
    assign router_2_13_req_in[2] = router_2_12_to_router_2_13_req;
    assign router_2_13_req_in[3] = router_1_13_to_router_2_13_req;
    assign router_2_13_req_in[4] = magia_tile_ni_2_13_to_router_2_13_req;

    assign router_2_13_to_router_2_14_rsp = router_2_13_rsp_out[0];
    assign router_2_13_to_router_3_13_rsp = router_2_13_rsp_out[1];
    assign router_2_13_to_router_2_12_rsp = router_2_13_rsp_out[2];
    assign router_2_13_to_router_1_13_rsp = router_2_13_rsp_out[3];
    assign router_2_13_to_magia_tile_ni_2_13_rsp = router_2_13_rsp_out[4];

    assign router_2_13_to_router_2_14_req = router_2_13_req_out[0];
    assign router_2_13_to_router_3_13_req = router_2_13_req_out[1];
    assign router_2_13_to_router_2_12_req = router_2_13_req_out[2];
    assign router_2_13_to_router_1_13_req = router_2_13_req_out[3];
    assign router_2_13_to_magia_tile_ni_2_13_req = router_2_13_req_out[4];

    assign router_2_13_rsp_in[0] = router_2_14_to_router_2_13_rsp;
    assign router_2_13_rsp_in[1] = router_3_13_to_router_2_13_rsp;
    assign router_2_13_rsp_in[2] = router_2_12_to_router_2_13_rsp;
    assign router_2_13_rsp_in[3] = router_1_13_to_router_2_13_rsp;
    assign router_2_13_rsp_in[4] = magia_tile_ni_2_13_to_router_2_13_rsp;

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
) router_2_13 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 3, y: 13, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_2_13_req_in),
  .floo_rsp_o (router_2_13_rsp_out),
  .floo_req_o (router_2_13_req_out),
  .floo_rsp_i (router_2_13_rsp_in)
);


floo_req_t [4:0] router_2_14_req_in;
floo_rsp_t [4:0] router_2_14_rsp_out;
floo_req_t [4:0] router_2_14_req_out;
floo_rsp_t [4:0] router_2_14_rsp_in;

    assign router_2_14_req_in[0] = router_2_15_to_router_2_14_req;
    assign router_2_14_req_in[1] = router_3_14_to_router_2_14_req;
    assign router_2_14_req_in[2] = router_2_13_to_router_2_14_req;
    assign router_2_14_req_in[3] = router_1_14_to_router_2_14_req;
    assign router_2_14_req_in[4] = magia_tile_ni_2_14_to_router_2_14_req;

    assign router_2_14_to_router_2_15_rsp = router_2_14_rsp_out[0];
    assign router_2_14_to_router_3_14_rsp = router_2_14_rsp_out[1];
    assign router_2_14_to_router_2_13_rsp = router_2_14_rsp_out[2];
    assign router_2_14_to_router_1_14_rsp = router_2_14_rsp_out[3];
    assign router_2_14_to_magia_tile_ni_2_14_rsp = router_2_14_rsp_out[4];

    assign router_2_14_to_router_2_15_req = router_2_14_req_out[0];
    assign router_2_14_to_router_3_14_req = router_2_14_req_out[1];
    assign router_2_14_to_router_2_13_req = router_2_14_req_out[2];
    assign router_2_14_to_router_1_14_req = router_2_14_req_out[3];
    assign router_2_14_to_magia_tile_ni_2_14_req = router_2_14_req_out[4];

    assign router_2_14_rsp_in[0] = router_2_15_to_router_2_14_rsp;
    assign router_2_14_rsp_in[1] = router_3_14_to_router_2_14_rsp;
    assign router_2_14_rsp_in[2] = router_2_13_to_router_2_14_rsp;
    assign router_2_14_rsp_in[3] = router_1_14_to_router_2_14_rsp;
    assign router_2_14_rsp_in[4] = magia_tile_ni_2_14_to_router_2_14_rsp;

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
) router_2_14 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 3, y: 14, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_2_14_req_in),
  .floo_rsp_o (router_2_14_rsp_out),
  .floo_req_o (router_2_14_req_out),
  .floo_rsp_i (router_2_14_rsp_in)
);


floo_req_t [4:0] router_2_15_req_in;
floo_rsp_t [4:0] router_2_15_rsp_out;
floo_req_t [4:0] router_2_15_req_out;
floo_rsp_t [4:0] router_2_15_rsp_in;

    assign router_2_15_req_in[0] = '0;
    assign router_2_15_req_in[1] = router_3_15_to_router_2_15_req;
    assign router_2_15_req_in[2] = router_2_14_to_router_2_15_req;
    assign router_2_15_req_in[3] = router_1_15_to_router_2_15_req;
    assign router_2_15_req_in[4] = magia_tile_ni_2_15_to_router_2_15_req;

    assign router_2_15_to_router_3_15_rsp = router_2_15_rsp_out[1];
    assign router_2_15_to_router_2_14_rsp = router_2_15_rsp_out[2];
    assign router_2_15_to_router_1_15_rsp = router_2_15_rsp_out[3];
    assign router_2_15_to_magia_tile_ni_2_15_rsp = router_2_15_rsp_out[4];

    assign router_2_15_to_router_3_15_req = router_2_15_req_out[1];
    assign router_2_15_to_router_2_14_req = router_2_15_req_out[2];
    assign router_2_15_to_router_1_15_req = router_2_15_req_out[3];
    assign router_2_15_to_magia_tile_ni_2_15_req = router_2_15_req_out[4];

    assign router_2_15_rsp_in[0] = '0;
    assign router_2_15_rsp_in[1] = router_3_15_to_router_2_15_rsp;
    assign router_2_15_rsp_in[2] = router_2_14_to_router_2_15_rsp;
    assign router_2_15_rsp_in[3] = router_1_15_to_router_2_15_rsp;
    assign router_2_15_rsp_in[4] = magia_tile_ni_2_15_to_router_2_15_rsp;

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
) router_2_15 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 3, y: 15, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_2_15_req_in),
  .floo_rsp_o (router_2_15_rsp_out),
  .floo_req_o (router_2_15_req_out),
  .floo_rsp_i (router_2_15_rsp_in)
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

    assign router_3_7_req_in[0] = router_3_8_to_router_3_7_req;
    assign router_3_7_req_in[1] = router_4_7_to_router_3_7_req;
    assign router_3_7_req_in[2] = router_3_6_to_router_3_7_req;
    assign router_3_7_req_in[3] = router_2_7_to_router_3_7_req;
    assign router_3_7_req_in[4] = magia_tile_ni_3_7_to_router_3_7_req;

    assign router_3_7_to_router_3_8_rsp = router_3_7_rsp_out[0];
    assign router_3_7_to_router_4_7_rsp = router_3_7_rsp_out[1];
    assign router_3_7_to_router_3_6_rsp = router_3_7_rsp_out[2];
    assign router_3_7_to_router_2_7_rsp = router_3_7_rsp_out[3];
    assign router_3_7_to_magia_tile_ni_3_7_rsp = router_3_7_rsp_out[4];

    assign router_3_7_to_router_3_8_req = router_3_7_req_out[0];
    assign router_3_7_to_router_4_7_req = router_3_7_req_out[1];
    assign router_3_7_to_router_3_6_req = router_3_7_req_out[2];
    assign router_3_7_to_router_2_7_req = router_3_7_req_out[3];
    assign router_3_7_to_magia_tile_ni_3_7_req = router_3_7_req_out[4];

    assign router_3_7_rsp_in[0] = router_3_8_to_router_3_7_rsp;
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


floo_req_t [4:0] router_3_8_req_in;
floo_rsp_t [4:0] router_3_8_rsp_out;
floo_req_t [4:0] router_3_8_req_out;
floo_rsp_t [4:0] router_3_8_rsp_in;

    assign router_3_8_req_in[0] = router_3_9_to_router_3_8_req;
    assign router_3_8_req_in[1] = router_4_8_to_router_3_8_req;
    assign router_3_8_req_in[2] = router_3_7_to_router_3_8_req;
    assign router_3_8_req_in[3] = router_2_8_to_router_3_8_req;
    assign router_3_8_req_in[4] = magia_tile_ni_3_8_to_router_3_8_req;

    assign router_3_8_to_router_3_9_rsp = router_3_8_rsp_out[0];
    assign router_3_8_to_router_4_8_rsp = router_3_8_rsp_out[1];
    assign router_3_8_to_router_3_7_rsp = router_3_8_rsp_out[2];
    assign router_3_8_to_router_2_8_rsp = router_3_8_rsp_out[3];
    assign router_3_8_to_magia_tile_ni_3_8_rsp = router_3_8_rsp_out[4];

    assign router_3_8_to_router_3_9_req = router_3_8_req_out[0];
    assign router_3_8_to_router_4_8_req = router_3_8_req_out[1];
    assign router_3_8_to_router_3_7_req = router_3_8_req_out[2];
    assign router_3_8_to_router_2_8_req = router_3_8_req_out[3];
    assign router_3_8_to_magia_tile_ni_3_8_req = router_3_8_req_out[4];

    assign router_3_8_rsp_in[0] = router_3_9_to_router_3_8_rsp;
    assign router_3_8_rsp_in[1] = router_4_8_to_router_3_8_rsp;
    assign router_3_8_rsp_in[2] = router_3_7_to_router_3_8_rsp;
    assign router_3_8_rsp_in[3] = router_2_8_to_router_3_8_rsp;
    assign router_3_8_rsp_in[4] = magia_tile_ni_3_8_to_router_3_8_rsp;

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
) router_3_8 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 4, y: 8, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_3_8_req_in),
  .floo_rsp_o (router_3_8_rsp_out),
  .floo_req_o (router_3_8_req_out),
  .floo_rsp_i (router_3_8_rsp_in)
);


floo_req_t [4:0] router_3_9_req_in;
floo_rsp_t [4:0] router_3_9_rsp_out;
floo_req_t [4:0] router_3_9_req_out;
floo_rsp_t [4:0] router_3_9_rsp_in;

    assign router_3_9_req_in[0] = router_3_10_to_router_3_9_req;
    assign router_3_9_req_in[1] = router_4_9_to_router_3_9_req;
    assign router_3_9_req_in[2] = router_3_8_to_router_3_9_req;
    assign router_3_9_req_in[3] = router_2_9_to_router_3_9_req;
    assign router_3_9_req_in[4] = magia_tile_ni_3_9_to_router_3_9_req;

    assign router_3_9_to_router_3_10_rsp = router_3_9_rsp_out[0];
    assign router_3_9_to_router_4_9_rsp = router_3_9_rsp_out[1];
    assign router_3_9_to_router_3_8_rsp = router_3_9_rsp_out[2];
    assign router_3_9_to_router_2_9_rsp = router_3_9_rsp_out[3];
    assign router_3_9_to_magia_tile_ni_3_9_rsp = router_3_9_rsp_out[4];

    assign router_3_9_to_router_3_10_req = router_3_9_req_out[0];
    assign router_3_9_to_router_4_9_req = router_3_9_req_out[1];
    assign router_3_9_to_router_3_8_req = router_3_9_req_out[2];
    assign router_3_9_to_router_2_9_req = router_3_9_req_out[3];
    assign router_3_9_to_magia_tile_ni_3_9_req = router_3_9_req_out[4];

    assign router_3_9_rsp_in[0] = router_3_10_to_router_3_9_rsp;
    assign router_3_9_rsp_in[1] = router_4_9_to_router_3_9_rsp;
    assign router_3_9_rsp_in[2] = router_3_8_to_router_3_9_rsp;
    assign router_3_9_rsp_in[3] = router_2_9_to_router_3_9_rsp;
    assign router_3_9_rsp_in[4] = magia_tile_ni_3_9_to_router_3_9_rsp;

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
) router_3_9 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 4, y: 9, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_3_9_req_in),
  .floo_rsp_o (router_3_9_rsp_out),
  .floo_req_o (router_3_9_req_out),
  .floo_rsp_i (router_3_9_rsp_in)
);


floo_req_t [4:0] router_3_10_req_in;
floo_rsp_t [4:0] router_3_10_rsp_out;
floo_req_t [4:0] router_3_10_req_out;
floo_rsp_t [4:0] router_3_10_rsp_in;

    assign router_3_10_req_in[0] = router_3_11_to_router_3_10_req;
    assign router_3_10_req_in[1] = router_4_10_to_router_3_10_req;
    assign router_3_10_req_in[2] = router_3_9_to_router_3_10_req;
    assign router_3_10_req_in[3] = router_2_10_to_router_3_10_req;
    assign router_3_10_req_in[4] = magia_tile_ni_3_10_to_router_3_10_req;

    assign router_3_10_to_router_3_11_rsp = router_3_10_rsp_out[0];
    assign router_3_10_to_router_4_10_rsp = router_3_10_rsp_out[1];
    assign router_3_10_to_router_3_9_rsp = router_3_10_rsp_out[2];
    assign router_3_10_to_router_2_10_rsp = router_3_10_rsp_out[3];
    assign router_3_10_to_magia_tile_ni_3_10_rsp = router_3_10_rsp_out[4];

    assign router_3_10_to_router_3_11_req = router_3_10_req_out[0];
    assign router_3_10_to_router_4_10_req = router_3_10_req_out[1];
    assign router_3_10_to_router_3_9_req = router_3_10_req_out[2];
    assign router_3_10_to_router_2_10_req = router_3_10_req_out[3];
    assign router_3_10_to_magia_tile_ni_3_10_req = router_3_10_req_out[4];

    assign router_3_10_rsp_in[0] = router_3_11_to_router_3_10_rsp;
    assign router_3_10_rsp_in[1] = router_4_10_to_router_3_10_rsp;
    assign router_3_10_rsp_in[2] = router_3_9_to_router_3_10_rsp;
    assign router_3_10_rsp_in[3] = router_2_10_to_router_3_10_rsp;
    assign router_3_10_rsp_in[4] = magia_tile_ni_3_10_to_router_3_10_rsp;

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
) router_3_10 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 4, y: 10, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_3_10_req_in),
  .floo_rsp_o (router_3_10_rsp_out),
  .floo_req_o (router_3_10_req_out),
  .floo_rsp_i (router_3_10_rsp_in)
);


floo_req_t [4:0] router_3_11_req_in;
floo_rsp_t [4:0] router_3_11_rsp_out;
floo_req_t [4:0] router_3_11_req_out;
floo_rsp_t [4:0] router_3_11_rsp_in;

    assign router_3_11_req_in[0] = router_3_12_to_router_3_11_req;
    assign router_3_11_req_in[1] = router_4_11_to_router_3_11_req;
    assign router_3_11_req_in[2] = router_3_10_to_router_3_11_req;
    assign router_3_11_req_in[3] = router_2_11_to_router_3_11_req;
    assign router_3_11_req_in[4] = magia_tile_ni_3_11_to_router_3_11_req;

    assign router_3_11_to_router_3_12_rsp = router_3_11_rsp_out[0];
    assign router_3_11_to_router_4_11_rsp = router_3_11_rsp_out[1];
    assign router_3_11_to_router_3_10_rsp = router_3_11_rsp_out[2];
    assign router_3_11_to_router_2_11_rsp = router_3_11_rsp_out[3];
    assign router_3_11_to_magia_tile_ni_3_11_rsp = router_3_11_rsp_out[4];

    assign router_3_11_to_router_3_12_req = router_3_11_req_out[0];
    assign router_3_11_to_router_4_11_req = router_3_11_req_out[1];
    assign router_3_11_to_router_3_10_req = router_3_11_req_out[2];
    assign router_3_11_to_router_2_11_req = router_3_11_req_out[3];
    assign router_3_11_to_magia_tile_ni_3_11_req = router_3_11_req_out[4];

    assign router_3_11_rsp_in[0] = router_3_12_to_router_3_11_rsp;
    assign router_3_11_rsp_in[1] = router_4_11_to_router_3_11_rsp;
    assign router_3_11_rsp_in[2] = router_3_10_to_router_3_11_rsp;
    assign router_3_11_rsp_in[3] = router_2_11_to_router_3_11_rsp;
    assign router_3_11_rsp_in[4] = magia_tile_ni_3_11_to_router_3_11_rsp;

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
) router_3_11 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 4, y: 11, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_3_11_req_in),
  .floo_rsp_o (router_3_11_rsp_out),
  .floo_req_o (router_3_11_req_out),
  .floo_rsp_i (router_3_11_rsp_in)
);


floo_req_t [4:0] router_3_12_req_in;
floo_rsp_t [4:0] router_3_12_rsp_out;
floo_req_t [4:0] router_3_12_req_out;
floo_rsp_t [4:0] router_3_12_rsp_in;

    assign router_3_12_req_in[0] = router_3_13_to_router_3_12_req;
    assign router_3_12_req_in[1] = router_4_12_to_router_3_12_req;
    assign router_3_12_req_in[2] = router_3_11_to_router_3_12_req;
    assign router_3_12_req_in[3] = router_2_12_to_router_3_12_req;
    assign router_3_12_req_in[4] = magia_tile_ni_3_12_to_router_3_12_req;

    assign router_3_12_to_router_3_13_rsp = router_3_12_rsp_out[0];
    assign router_3_12_to_router_4_12_rsp = router_3_12_rsp_out[1];
    assign router_3_12_to_router_3_11_rsp = router_3_12_rsp_out[2];
    assign router_3_12_to_router_2_12_rsp = router_3_12_rsp_out[3];
    assign router_3_12_to_magia_tile_ni_3_12_rsp = router_3_12_rsp_out[4];

    assign router_3_12_to_router_3_13_req = router_3_12_req_out[0];
    assign router_3_12_to_router_4_12_req = router_3_12_req_out[1];
    assign router_3_12_to_router_3_11_req = router_3_12_req_out[2];
    assign router_3_12_to_router_2_12_req = router_3_12_req_out[3];
    assign router_3_12_to_magia_tile_ni_3_12_req = router_3_12_req_out[4];

    assign router_3_12_rsp_in[0] = router_3_13_to_router_3_12_rsp;
    assign router_3_12_rsp_in[1] = router_4_12_to_router_3_12_rsp;
    assign router_3_12_rsp_in[2] = router_3_11_to_router_3_12_rsp;
    assign router_3_12_rsp_in[3] = router_2_12_to_router_3_12_rsp;
    assign router_3_12_rsp_in[4] = magia_tile_ni_3_12_to_router_3_12_rsp;

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
) router_3_12 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 4, y: 12, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_3_12_req_in),
  .floo_rsp_o (router_3_12_rsp_out),
  .floo_req_o (router_3_12_req_out),
  .floo_rsp_i (router_3_12_rsp_in)
);


floo_req_t [4:0] router_3_13_req_in;
floo_rsp_t [4:0] router_3_13_rsp_out;
floo_req_t [4:0] router_3_13_req_out;
floo_rsp_t [4:0] router_3_13_rsp_in;

    assign router_3_13_req_in[0] = router_3_14_to_router_3_13_req;
    assign router_3_13_req_in[1] = router_4_13_to_router_3_13_req;
    assign router_3_13_req_in[2] = router_3_12_to_router_3_13_req;
    assign router_3_13_req_in[3] = router_2_13_to_router_3_13_req;
    assign router_3_13_req_in[4] = magia_tile_ni_3_13_to_router_3_13_req;

    assign router_3_13_to_router_3_14_rsp = router_3_13_rsp_out[0];
    assign router_3_13_to_router_4_13_rsp = router_3_13_rsp_out[1];
    assign router_3_13_to_router_3_12_rsp = router_3_13_rsp_out[2];
    assign router_3_13_to_router_2_13_rsp = router_3_13_rsp_out[3];
    assign router_3_13_to_magia_tile_ni_3_13_rsp = router_3_13_rsp_out[4];

    assign router_3_13_to_router_3_14_req = router_3_13_req_out[0];
    assign router_3_13_to_router_4_13_req = router_3_13_req_out[1];
    assign router_3_13_to_router_3_12_req = router_3_13_req_out[2];
    assign router_3_13_to_router_2_13_req = router_3_13_req_out[3];
    assign router_3_13_to_magia_tile_ni_3_13_req = router_3_13_req_out[4];

    assign router_3_13_rsp_in[0] = router_3_14_to_router_3_13_rsp;
    assign router_3_13_rsp_in[1] = router_4_13_to_router_3_13_rsp;
    assign router_3_13_rsp_in[2] = router_3_12_to_router_3_13_rsp;
    assign router_3_13_rsp_in[3] = router_2_13_to_router_3_13_rsp;
    assign router_3_13_rsp_in[4] = magia_tile_ni_3_13_to_router_3_13_rsp;

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
) router_3_13 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 4, y: 13, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_3_13_req_in),
  .floo_rsp_o (router_3_13_rsp_out),
  .floo_req_o (router_3_13_req_out),
  .floo_rsp_i (router_3_13_rsp_in)
);


floo_req_t [4:0] router_3_14_req_in;
floo_rsp_t [4:0] router_3_14_rsp_out;
floo_req_t [4:0] router_3_14_req_out;
floo_rsp_t [4:0] router_3_14_rsp_in;

    assign router_3_14_req_in[0] = router_3_15_to_router_3_14_req;
    assign router_3_14_req_in[1] = router_4_14_to_router_3_14_req;
    assign router_3_14_req_in[2] = router_3_13_to_router_3_14_req;
    assign router_3_14_req_in[3] = router_2_14_to_router_3_14_req;
    assign router_3_14_req_in[4] = magia_tile_ni_3_14_to_router_3_14_req;

    assign router_3_14_to_router_3_15_rsp = router_3_14_rsp_out[0];
    assign router_3_14_to_router_4_14_rsp = router_3_14_rsp_out[1];
    assign router_3_14_to_router_3_13_rsp = router_3_14_rsp_out[2];
    assign router_3_14_to_router_2_14_rsp = router_3_14_rsp_out[3];
    assign router_3_14_to_magia_tile_ni_3_14_rsp = router_3_14_rsp_out[4];

    assign router_3_14_to_router_3_15_req = router_3_14_req_out[0];
    assign router_3_14_to_router_4_14_req = router_3_14_req_out[1];
    assign router_3_14_to_router_3_13_req = router_3_14_req_out[2];
    assign router_3_14_to_router_2_14_req = router_3_14_req_out[3];
    assign router_3_14_to_magia_tile_ni_3_14_req = router_3_14_req_out[4];

    assign router_3_14_rsp_in[0] = router_3_15_to_router_3_14_rsp;
    assign router_3_14_rsp_in[1] = router_4_14_to_router_3_14_rsp;
    assign router_3_14_rsp_in[2] = router_3_13_to_router_3_14_rsp;
    assign router_3_14_rsp_in[3] = router_2_14_to_router_3_14_rsp;
    assign router_3_14_rsp_in[4] = magia_tile_ni_3_14_to_router_3_14_rsp;

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
) router_3_14 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 4, y: 14, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_3_14_req_in),
  .floo_rsp_o (router_3_14_rsp_out),
  .floo_req_o (router_3_14_req_out),
  .floo_rsp_i (router_3_14_rsp_in)
);


floo_req_t [4:0] router_3_15_req_in;
floo_rsp_t [4:0] router_3_15_rsp_out;
floo_req_t [4:0] router_3_15_req_out;
floo_rsp_t [4:0] router_3_15_rsp_in;

    assign router_3_15_req_in[0] = '0;
    assign router_3_15_req_in[1] = router_4_15_to_router_3_15_req;
    assign router_3_15_req_in[2] = router_3_14_to_router_3_15_req;
    assign router_3_15_req_in[3] = router_2_15_to_router_3_15_req;
    assign router_3_15_req_in[4] = magia_tile_ni_3_15_to_router_3_15_req;

    assign router_3_15_to_router_4_15_rsp = router_3_15_rsp_out[1];
    assign router_3_15_to_router_3_14_rsp = router_3_15_rsp_out[2];
    assign router_3_15_to_router_2_15_rsp = router_3_15_rsp_out[3];
    assign router_3_15_to_magia_tile_ni_3_15_rsp = router_3_15_rsp_out[4];

    assign router_3_15_to_router_4_15_req = router_3_15_req_out[1];
    assign router_3_15_to_router_3_14_req = router_3_15_req_out[2];
    assign router_3_15_to_router_2_15_req = router_3_15_req_out[3];
    assign router_3_15_to_magia_tile_ni_3_15_req = router_3_15_req_out[4];

    assign router_3_15_rsp_in[0] = '0;
    assign router_3_15_rsp_in[1] = router_4_15_to_router_3_15_rsp;
    assign router_3_15_rsp_in[2] = router_3_14_to_router_3_15_rsp;
    assign router_3_15_rsp_in[3] = router_2_15_to_router_3_15_rsp;
    assign router_3_15_rsp_in[4] = magia_tile_ni_3_15_to_router_3_15_rsp;

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
) router_3_15 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 4, y: 15, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_3_15_req_in),
  .floo_rsp_o (router_3_15_rsp_out),
  .floo_req_o (router_3_15_req_out),
  .floo_rsp_i (router_3_15_rsp_in)
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

    assign router_4_7_req_in[0] = router_4_8_to_router_4_7_req;
    assign router_4_7_req_in[1] = router_5_7_to_router_4_7_req;
    assign router_4_7_req_in[2] = router_4_6_to_router_4_7_req;
    assign router_4_7_req_in[3] = router_3_7_to_router_4_7_req;
    assign router_4_7_req_in[4] = magia_tile_ni_4_7_to_router_4_7_req;

    assign router_4_7_to_router_4_8_rsp = router_4_7_rsp_out[0];
    assign router_4_7_to_router_5_7_rsp = router_4_7_rsp_out[1];
    assign router_4_7_to_router_4_6_rsp = router_4_7_rsp_out[2];
    assign router_4_7_to_router_3_7_rsp = router_4_7_rsp_out[3];
    assign router_4_7_to_magia_tile_ni_4_7_rsp = router_4_7_rsp_out[4];

    assign router_4_7_to_router_4_8_req = router_4_7_req_out[0];
    assign router_4_7_to_router_5_7_req = router_4_7_req_out[1];
    assign router_4_7_to_router_4_6_req = router_4_7_req_out[2];
    assign router_4_7_to_router_3_7_req = router_4_7_req_out[3];
    assign router_4_7_to_magia_tile_ni_4_7_req = router_4_7_req_out[4];

    assign router_4_7_rsp_in[0] = router_4_8_to_router_4_7_rsp;
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


floo_req_t [4:0] router_4_8_req_in;
floo_rsp_t [4:0] router_4_8_rsp_out;
floo_req_t [4:0] router_4_8_req_out;
floo_rsp_t [4:0] router_4_8_rsp_in;

    assign router_4_8_req_in[0] = router_4_9_to_router_4_8_req;
    assign router_4_8_req_in[1] = router_5_8_to_router_4_8_req;
    assign router_4_8_req_in[2] = router_4_7_to_router_4_8_req;
    assign router_4_8_req_in[3] = router_3_8_to_router_4_8_req;
    assign router_4_8_req_in[4] = magia_tile_ni_4_8_to_router_4_8_req;

    assign router_4_8_to_router_4_9_rsp = router_4_8_rsp_out[0];
    assign router_4_8_to_router_5_8_rsp = router_4_8_rsp_out[1];
    assign router_4_8_to_router_4_7_rsp = router_4_8_rsp_out[2];
    assign router_4_8_to_router_3_8_rsp = router_4_8_rsp_out[3];
    assign router_4_8_to_magia_tile_ni_4_8_rsp = router_4_8_rsp_out[4];

    assign router_4_8_to_router_4_9_req = router_4_8_req_out[0];
    assign router_4_8_to_router_5_8_req = router_4_8_req_out[1];
    assign router_4_8_to_router_4_7_req = router_4_8_req_out[2];
    assign router_4_8_to_router_3_8_req = router_4_8_req_out[3];
    assign router_4_8_to_magia_tile_ni_4_8_req = router_4_8_req_out[4];

    assign router_4_8_rsp_in[0] = router_4_9_to_router_4_8_rsp;
    assign router_4_8_rsp_in[1] = router_5_8_to_router_4_8_rsp;
    assign router_4_8_rsp_in[2] = router_4_7_to_router_4_8_rsp;
    assign router_4_8_rsp_in[3] = router_3_8_to_router_4_8_rsp;
    assign router_4_8_rsp_in[4] = magia_tile_ni_4_8_to_router_4_8_rsp;

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
) router_4_8 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 5, y: 8, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_4_8_req_in),
  .floo_rsp_o (router_4_8_rsp_out),
  .floo_req_o (router_4_8_req_out),
  .floo_rsp_i (router_4_8_rsp_in)
);


floo_req_t [4:0] router_4_9_req_in;
floo_rsp_t [4:0] router_4_9_rsp_out;
floo_req_t [4:0] router_4_9_req_out;
floo_rsp_t [4:0] router_4_9_rsp_in;

    assign router_4_9_req_in[0] = router_4_10_to_router_4_9_req;
    assign router_4_9_req_in[1] = router_5_9_to_router_4_9_req;
    assign router_4_9_req_in[2] = router_4_8_to_router_4_9_req;
    assign router_4_9_req_in[3] = router_3_9_to_router_4_9_req;
    assign router_4_9_req_in[4] = magia_tile_ni_4_9_to_router_4_9_req;

    assign router_4_9_to_router_4_10_rsp = router_4_9_rsp_out[0];
    assign router_4_9_to_router_5_9_rsp = router_4_9_rsp_out[1];
    assign router_4_9_to_router_4_8_rsp = router_4_9_rsp_out[2];
    assign router_4_9_to_router_3_9_rsp = router_4_9_rsp_out[3];
    assign router_4_9_to_magia_tile_ni_4_9_rsp = router_4_9_rsp_out[4];

    assign router_4_9_to_router_4_10_req = router_4_9_req_out[0];
    assign router_4_9_to_router_5_9_req = router_4_9_req_out[1];
    assign router_4_9_to_router_4_8_req = router_4_9_req_out[2];
    assign router_4_9_to_router_3_9_req = router_4_9_req_out[3];
    assign router_4_9_to_magia_tile_ni_4_9_req = router_4_9_req_out[4];

    assign router_4_9_rsp_in[0] = router_4_10_to_router_4_9_rsp;
    assign router_4_9_rsp_in[1] = router_5_9_to_router_4_9_rsp;
    assign router_4_9_rsp_in[2] = router_4_8_to_router_4_9_rsp;
    assign router_4_9_rsp_in[3] = router_3_9_to_router_4_9_rsp;
    assign router_4_9_rsp_in[4] = magia_tile_ni_4_9_to_router_4_9_rsp;

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
) router_4_9 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 5, y: 9, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_4_9_req_in),
  .floo_rsp_o (router_4_9_rsp_out),
  .floo_req_o (router_4_9_req_out),
  .floo_rsp_i (router_4_9_rsp_in)
);


floo_req_t [4:0] router_4_10_req_in;
floo_rsp_t [4:0] router_4_10_rsp_out;
floo_req_t [4:0] router_4_10_req_out;
floo_rsp_t [4:0] router_4_10_rsp_in;

    assign router_4_10_req_in[0] = router_4_11_to_router_4_10_req;
    assign router_4_10_req_in[1] = router_5_10_to_router_4_10_req;
    assign router_4_10_req_in[2] = router_4_9_to_router_4_10_req;
    assign router_4_10_req_in[3] = router_3_10_to_router_4_10_req;
    assign router_4_10_req_in[4] = magia_tile_ni_4_10_to_router_4_10_req;

    assign router_4_10_to_router_4_11_rsp = router_4_10_rsp_out[0];
    assign router_4_10_to_router_5_10_rsp = router_4_10_rsp_out[1];
    assign router_4_10_to_router_4_9_rsp = router_4_10_rsp_out[2];
    assign router_4_10_to_router_3_10_rsp = router_4_10_rsp_out[3];
    assign router_4_10_to_magia_tile_ni_4_10_rsp = router_4_10_rsp_out[4];

    assign router_4_10_to_router_4_11_req = router_4_10_req_out[0];
    assign router_4_10_to_router_5_10_req = router_4_10_req_out[1];
    assign router_4_10_to_router_4_9_req = router_4_10_req_out[2];
    assign router_4_10_to_router_3_10_req = router_4_10_req_out[3];
    assign router_4_10_to_magia_tile_ni_4_10_req = router_4_10_req_out[4];

    assign router_4_10_rsp_in[0] = router_4_11_to_router_4_10_rsp;
    assign router_4_10_rsp_in[1] = router_5_10_to_router_4_10_rsp;
    assign router_4_10_rsp_in[2] = router_4_9_to_router_4_10_rsp;
    assign router_4_10_rsp_in[3] = router_3_10_to_router_4_10_rsp;
    assign router_4_10_rsp_in[4] = magia_tile_ni_4_10_to_router_4_10_rsp;

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
) router_4_10 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 5, y: 10, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_4_10_req_in),
  .floo_rsp_o (router_4_10_rsp_out),
  .floo_req_o (router_4_10_req_out),
  .floo_rsp_i (router_4_10_rsp_in)
);


floo_req_t [4:0] router_4_11_req_in;
floo_rsp_t [4:0] router_4_11_rsp_out;
floo_req_t [4:0] router_4_11_req_out;
floo_rsp_t [4:0] router_4_11_rsp_in;

    assign router_4_11_req_in[0] = router_4_12_to_router_4_11_req;
    assign router_4_11_req_in[1] = router_5_11_to_router_4_11_req;
    assign router_4_11_req_in[2] = router_4_10_to_router_4_11_req;
    assign router_4_11_req_in[3] = router_3_11_to_router_4_11_req;
    assign router_4_11_req_in[4] = magia_tile_ni_4_11_to_router_4_11_req;

    assign router_4_11_to_router_4_12_rsp = router_4_11_rsp_out[0];
    assign router_4_11_to_router_5_11_rsp = router_4_11_rsp_out[1];
    assign router_4_11_to_router_4_10_rsp = router_4_11_rsp_out[2];
    assign router_4_11_to_router_3_11_rsp = router_4_11_rsp_out[3];
    assign router_4_11_to_magia_tile_ni_4_11_rsp = router_4_11_rsp_out[4];

    assign router_4_11_to_router_4_12_req = router_4_11_req_out[0];
    assign router_4_11_to_router_5_11_req = router_4_11_req_out[1];
    assign router_4_11_to_router_4_10_req = router_4_11_req_out[2];
    assign router_4_11_to_router_3_11_req = router_4_11_req_out[3];
    assign router_4_11_to_magia_tile_ni_4_11_req = router_4_11_req_out[4];

    assign router_4_11_rsp_in[0] = router_4_12_to_router_4_11_rsp;
    assign router_4_11_rsp_in[1] = router_5_11_to_router_4_11_rsp;
    assign router_4_11_rsp_in[2] = router_4_10_to_router_4_11_rsp;
    assign router_4_11_rsp_in[3] = router_3_11_to_router_4_11_rsp;
    assign router_4_11_rsp_in[4] = magia_tile_ni_4_11_to_router_4_11_rsp;

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
) router_4_11 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 5, y: 11, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_4_11_req_in),
  .floo_rsp_o (router_4_11_rsp_out),
  .floo_req_o (router_4_11_req_out),
  .floo_rsp_i (router_4_11_rsp_in)
);


floo_req_t [4:0] router_4_12_req_in;
floo_rsp_t [4:0] router_4_12_rsp_out;
floo_req_t [4:0] router_4_12_req_out;
floo_rsp_t [4:0] router_4_12_rsp_in;

    assign router_4_12_req_in[0] = router_4_13_to_router_4_12_req;
    assign router_4_12_req_in[1] = router_5_12_to_router_4_12_req;
    assign router_4_12_req_in[2] = router_4_11_to_router_4_12_req;
    assign router_4_12_req_in[3] = router_3_12_to_router_4_12_req;
    assign router_4_12_req_in[4] = magia_tile_ni_4_12_to_router_4_12_req;

    assign router_4_12_to_router_4_13_rsp = router_4_12_rsp_out[0];
    assign router_4_12_to_router_5_12_rsp = router_4_12_rsp_out[1];
    assign router_4_12_to_router_4_11_rsp = router_4_12_rsp_out[2];
    assign router_4_12_to_router_3_12_rsp = router_4_12_rsp_out[3];
    assign router_4_12_to_magia_tile_ni_4_12_rsp = router_4_12_rsp_out[4];

    assign router_4_12_to_router_4_13_req = router_4_12_req_out[0];
    assign router_4_12_to_router_5_12_req = router_4_12_req_out[1];
    assign router_4_12_to_router_4_11_req = router_4_12_req_out[2];
    assign router_4_12_to_router_3_12_req = router_4_12_req_out[3];
    assign router_4_12_to_magia_tile_ni_4_12_req = router_4_12_req_out[4];

    assign router_4_12_rsp_in[0] = router_4_13_to_router_4_12_rsp;
    assign router_4_12_rsp_in[1] = router_5_12_to_router_4_12_rsp;
    assign router_4_12_rsp_in[2] = router_4_11_to_router_4_12_rsp;
    assign router_4_12_rsp_in[3] = router_3_12_to_router_4_12_rsp;
    assign router_4_12_rsp_in[4] = magia_tile_ni_4_12_to_router_4_12_rsp;

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
) router_4_12 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 5, y: 12, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_4_12_req_in),
  .floo_rsp_o (router_4_12_rsp_out),
  .floo_req_o (router_4_12_req_out),
  .floo_rsp_i (router_4_12_rsp_in)
);


floo_req_t [4:0] router_4_13_req_in;
floo_rsp_t [4:0] router_4_13_rsp_out;
floo_req_t [4:0] router_4_13_req_out;
floo_rsp_t [4:0] router_4_13_rsp_in;

    assign router_4_13_req_in[0] = router_4_14_to_router_4_13_req;
    assign router_4_13_req_in[1] = router_5_13_to_router_4_13_req;
    assign router_4_13_req_in[2] = router_4_12_to_router_4_13_req;
    assign router_4_13_req_in[3] = router_3_13_to_router_4_13_req;
    assign router_4_13_req_in[4] = magia_tile_ni_4_13_to_router_4_13_req;

    assign router_4_13_to_router_4_14_rsp = router_4_13_rsp_out[0];
    assign router_4_13_to_router_5_13_rsp = router_4_13_rsp_out[1];
    assign router_4_13_to_router_4_12_rsp = router_4_13_rsp_out[2];
    assign router_4_13_to_router_3_13_rsp = router_4_13_rsp_out[3];
    assign router_4_13_to_magia_tile_ni_4_13_rsp = router_4_13_rsp_out[4];

    assign router_4_13_to_router_4_14_req = router_4_13_req_out[0];
    assign router_4_13_to_router_5_13_req = router_4_13_req_out[1];
    assign router_4_13_to_router_4_12_req = router_4_13_req_out[2];
    assign router_4_13_to_router_3_13_req = router_4_13_req_out[3];
    assign router_4_13_to_magia_tile_ni_4_13_req = router_4_13_req_out[4];

    assign router_4_13_rsp_in[0] = router_4_14_to_router_4_13_rsp;
    assign router_4_13_rsp_in[1] = router_5_13_to_router_4_13_rsp;
    assign router_4_13_rsp_in[2] = router_4_12_to_router_4_13_rsp;
    assign router_4_13_rsp_in[3] = router_3_13_to_router_4_13_rsp;
    assign router_4_13_rsp_in[4] = magia_tile_ni_4_13_to_router_4_13_rsp;

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
) router_4_13 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 5, y: 13, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_4_13_req_in),
  .floo_rsp_o (router_4_13_rsp_out),
  .floo_req_o (router_4_13_req_out),
  .floo_rsp_i (router_4_13_rsp_in)
);


floo_req_t [4:0] router_4_14_req_in;
floo_rsp_t [4:0] router_4_14_rsp_out;
floo_req_t [4:0] router_4_14_req_out;
floo_rsp_t [4:0] router_4_14_rsp_in;

    assign router_4_14_req_in[0] = router_4_15_to_router_4_14_req;
    assign router_4_14_req_in[1] = router_5_14_to_router_4_14_req;
    assign router_4_14_req_in[2] = router_4_13_to_router_4_14_req;
    assign router_4_14_req_in[3] = router_3_14_to_router_4_14_req;
    assign router_4_14_req_in[4] = magia_tile_ni_4_14_to_router_4_14_req;

    assign router_4_14_to_router_4_15_rsp = router_4_14_rsp_out[0];
    assign router_4_14_to_router_5_14_rsp = router_4_14_rsp_out[1];
    assign router_4_14_to_router_4_13_rsp = router_4_14_rsp_out[2];
    assign router_4_14_to_router_3_14_rsp = router_4_14_rsp_out[3];
    assign router_4_14_to_magia_tile_ni_4_14_rsp = router_4_14_rsp_out[4];

    assign router_4_14_to_router_4_15_req = router_4_14_req_out[0];
    assign router_4_14_to_router_5_14_req = router_4_14_req_out[1];
    assign router_4_14_to_router_4_13_req = router_4_14_req_out[2];
    assign router_4_14_to_router_3_14_req = router_4_14_req_out[3];
    assign router_4_14_to_magia_tile_ni_4_14_req = router_4_14_req_out[4];

    assign router_4_14_rsp_in[0] = router_4_15_to_router_4_14_rsp;
    assign router_4_14_rsp_in[1] = router_5_14_to_router_4_14_rsp;
    assign router_4_14_rsp_in[2] = router_4_13_to_router_4_14_rsp;
    assign router_4_14_rsp_in[3] = router_3_14_to_router_4_14_rsp;
    assign router_4_14_rsp_in[4] = magia_tile_ni_4_14_to_router_4_14_rsp;

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
) router_4_14 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 5, y: 14, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_4_14_req_in),
  .floo_rsp_o (router_4_14_rsp_out),
  .floo_req_o (router_4_14_req_out),
  .floo_rsp_i (router_4_14_rsp_in)
);


floo_req_t [4:0] router_4_15_req_in;
floo_rsp_t [4:0] router_4_15_rsp_out;
floo_req_t [4:0] router_4_15_req_out;
floo_rsp_t [4:0] router_4_15_rsp_in;

    assign router_4_15_req_in[0] = '0;
    assign router_4_15_req_in[1] = router_5_15_to_router_4_15_req;
    assign router_4_15_req_in[2] = router_4_14_to_router_4_15_req;
    assign router_4_15_req_in[3] = router_3_15_to_router_4_15_req;
    assign router_4_15_req_in[4] = magia_tile_ni_4_15_to_router_4_15_req;

    assign router_4_15_to_router_5_15_rsp = router_4_15_rsp_out[1];
    assign router_4_15_to_router_4_14_rsp = router_4_15_rsp_out[2];
    assign router_4_15_to_router_3_15_rsp = router_4_15_rsp_out[3];
    assign router_4_15_to_magia_tile_ni_4_15_rsp = router_4_15_rsp_out[4];

    assign router_4_15_to_router_5_15_req = router_4_15_req_out[1];
    assign router_4_15_to_router_4_14_req = router_4_15_req_out[2];
    assign router_4_15_to_router_3_15_req = router_4_15_req_out[3];
    assign router_4_15_to_magia_tile_ni_4_15_req = router_4_15_req_out[4];

    assign router_4_15_rsp_in[0] = '0;
    assign router_4_15_rsp_in[1] = router_5_15_to_router_4_15_rsp;
    assign router_4_15_rsp_in[2] = router_4_14_to_router_4_15_rsp;
    assign router_4_15_rsp_in[3] = router_3_15_to_router_4_15_rsp;
    assign router_4_15_rsp_in[4] = magia_tile_ni_4_15_to_router_4_15_rsp;

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
) router_4_15 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 5, y: 15, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_4_15_req_in),
  .floo_rsp_o (router_4_15_rsp_out),
  .floo_req_o (router_4_15_req_out),
  .floo_rsp_i (router_4_15_rsp_in)
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

    assign router_5_7_req_in[0] = router_5_8_to_router_5_7_req;
    assign router_5_7_req_in[1] = router_6_7_to_router_5_7_req;
    assign router_5_7_req_in[2] = router_5_6_to_router_5_7_req;
    assign router_5_7_req_in[3] = router_4_7_to_router_5_7_req;
    assign router_5_7_req_in[4] = magia_tile_ni_5_7_to_router_5_7_req;

    assign router_5_7_to_router_5_8_rsp = router_5_7_rsp_out[0];
    assign router_5_7_to_router_6_7_rsp = router_5_7_rsp_out[1];
    assign router_5_7_to_router_5_6_rsp = router_5_7_rsp_out[2];
    assign router_5_7_to_router_4_7_rsp = router_5_7_rsp_out[3];
    assign router_5_7_to_magia_tile_ni_5_7_rsp = router_5_7_rsp_out[4];

    assign router_5_7_to_router_5_8_req = router_5_7_req_out[0];
    assign router_5_7_to_router_6_7_req = router_5_7_req_out[1];
    assign router_5_7_to_router_5_6_req = router_5_7_req_out[2];
    assign router_5_7_to_router_4_7_req = router_5_7_req_out[3];
    assign router_5_7_to_magia_tile_ni_5_7_req = router_5_7_req_out[4];

    assign router_5_7_rsp_in[0] = router_5_8_to_router_5_7_rsp;
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


floo_req_t [4:0] router_5_8_req_in;
floo_rsp_t [4:0] router_5_8_rsp_out;
floo_req_t [4:0] router_5_8_req_out;
floo_rsp_t [4:0] router_5_8_rsp_in;

    assign router_5_8_req_in[0] = router_5_9_to_router_5_8_req;
    assign router_5_8_req_in[1] = router_6_8_to_router_5_8_req;
    assign router_5_8_req_in[2] = router_5_7_to_router_5_8_req;
    assign router_5_8_req_in[3] = router_4_8_to_router_5_8_req;
    assign router_5_8_req_in[4] = magia_tile_ni_5_8_to_router_5_8_req;

    assign router_5_8_to_router_5_9_rsp = router_5_8_rsp_out[0];
    assign router_5_8_to_router_6_8_rsp = router_5_8_rsp_out[1];
    assign router_5_8_to_router_5_7_rsp = router_5_8_rsp_out[2];
    assign router_5_8_to_router_4_8_rsp = router_5_8_rsp_out[3];
    assign router_5_8_to_magia_tile_ni_5_8_rsp = router_5_8_rsp_out[4];

    assign router_5_8_to_router_5_9_req = router_5_8_req_out[0];
    assign router_5_8_to_router_6_8_req = router_5_8_req_out[1];
    assign router_5_8_to_router_5_7_req = router_5_8_req_out[2];
    assign router_5_8_to_router_4_8_req = router_5_8_req_out[3];
    assign router_5_8_to_magia_tile_ni_5_8_req = router_5_8_req_out[4];

    assign router_5_8_rsp_in[0] = router_5_9_to_router_5_8_rsp;
    assign router_5_8_rsp_in[1] = router_6_8_to_router_5_8_rsp;
    assign router_5_8_rsp_in[2] = router_5_7_to_router_5_8_rsp;
    assign router_5_8_rsp_in[3] = router_4_8_to_router_5_8_rsp;
    assign router_5_8_rsp_in[4] = magia_tile_ni_5_8_to_router_5_8_rsp;

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
) router_5_8 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 6, y: 8, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_5_8_req_in),
  .floo_rsp_o (router_5_8_rsp_out),
  .floo_req_o (router_5_8_req_out),
  .floo_rsp_i (router_5_8_rsp_in)
);


floo_req_t [4:0] router_5_9_req_in;
floo_rsp_t [4:0] router_5_9_rsp_out;
floo_req_t [4:0] router_5_9_req_out;
floo_rsp_t [4:0] router_5_9_rsp_in;

    assign router_5_9_req_in[0] = router_5_10_to_router_5_9_req;
    assign router_5_9_req_in[1] = router_6_9_to_router_5_9_req;
    assign router_5_9_req_in[2] = router_5_8_to_router_5_9_req;
    assign router_5_9_req_in[3] = router_4_9_to_router_5_9_req;
    assign router_5_9_req_in[4] = magia_tile_ni_5_9_to_router_5_9_req;

    assign router_5_9_to_router_5_10_rsp = router_5_9_rsp_out[0];
    assign router_5_9_to_router_6_9_rsp = router_5_9_rsp_out[1];
    assign router_5_9_to_router_5_8_rsp = router_5_9_rsp_out[2];
    assign router_5_9_to_router_4_9_rsp = router_5_9_rsp_out[3];
    assign router_5_9_to_magia_tile_ni_5_9_rsp = router_5_9_rsp_out[4];

    assign router_5_9_to_router_5_10_req = router_5_9_req_out[0];
    assign router_5_9_to_router_6_9_req = router_5_9_req_out[1];
    assign router_5_9_to_router_5_8_req = router_5_9_req_out[2];
    assign router_5_9_to_router_4_9_req = router_5_9_req_out[3];
    assign router_5_9_to_magia_tile_ni_5_9_req = router_5_9_req_out[4];

    assign router_5_9_rsp_in[0] = router_5_10_to_router_5_9_rsp;
    assign router_5_9_rsp_in[1] = router_6_9_to_router_5_9_rsp;
    assign router_5_9_rsp_in[2] = router_5_8_to_router_5_9_rsp;
    assign router_5_9_rsp_in[3] = router_4_9_to_router_5_9_rsp;
    assign router_5_9_rsp_in[4] = magia_tile_ni_5_9_to_router_5_9_rsp;

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
) router_5_9 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 6, y: 9, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_5_9_req_in),
  .floo_rsp_o (router_5_9_rsp_out),
  .floo_req_o (router_5_9_req_out),
  .floo_rsp_i (router_5_9_rsp_in)
);


floo_req_t [4:0] router_5_10_req_in;
floo_rsp_t [4:0] router_5_10_rsp_out;
floo_req_t [4:0] router_5_10_req_out;
floo_rsp_t [4:0] router_5_10_rsp_in;

    assign router_5_10_req_in[0] = router_5_11_to_router_5_10_req;
    assign router_5_10_req_in[1] = router_6_10_to_router_5_10_req;
    assign router_5_10_req_in[2] = router_5_9_to_router_5_10_req;
    assign router_5_10_req_in[3] = router_4_10_to_router_5_10_req;
    assign router_5_10_req_in[4] = magia_tile_ni_5_10_to_router_5_10_req;

    assign router_5_10_to_router_5_11_rsp = router_5_10_rsp_out[0];
    assign router_5_10_to_router_6_10_rsp = router_5_10_rsp_out[1];
    assign router_5_10_to_router_5_9_rsp = router_5_10_rsp_out[2];
    assign router_5_10_to_router_4_10_rsp = router_5_10_rsp_out[3];
    assign router_5_10_to_magia_tile_ni_5_10_rsp = router_5_10_rsp_out[4];

    assign router_5_10_to_router_5_11_req = router_5_10_req_out[0];
    assign router_5_10_to_router_6_10_req = router_5_10_req_out[1];
    assign router_5_10_to_router_5_9_req = router_5_10_req_out[2];
    assign router_5_10_to_router_4_10_req = router_5_10_req_out[3];
    assign router_5_10_to_magia_tile_ni_5_10_req = router_5_10_req_out[4];

    assign router_5_10_rsp_in[0] = router_5_11_to_router_5_10_rsp;
    assign router_5_10_rsp_in[1] = router_6_10_to_router_5_10_rsp;
    assign router_5_10_rsp_in[2] = router_5_9_to_router_5_10_rsp;
    assign router_5_10_rsp_in[3] = router_4_10_to_router_5_10_rsp;
    assign router_5_10_rsp_in[4] = magia_tile_ni_5_10_to_router_5_10_rsp;

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
) router_5_10 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 6, y: 10, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_5_10_req_in),
  .floo_rsp_o (router_5_10_rsp_out),
  .floo_req_o (router_5_10_req_out),
  .floo_rsp_i (router_5_10_rsp_in)
);


floo_req_t [4:0] router_5_11_req_in;
floo_rsp_t [4:0] router_5_11_rsp_out;
floo_req_t [4:0] router_5_11_req_out;
floo_rsp_t [4:0] router_5_11_rsp_in;

    assign router_5_11_req_in[0] = router_5_12_to_router_5_11_req;
    assign router_5_11_req_in[1] = router_6_11_to_router_5_11_req;
    assign router_5_11_req_in[2] = router_5_10_to_router_5_11_req;
    assign router_5_11_req_in[3] = router_4_11_to_router_5_11_req;
    assign router_5_11_req_in[4] = magia_tile_ni_5_11_to_router_5_11_req;

    assign router_5_11_to_router_5_12_rsp = router_5_11_rsp_out[0];
    assign router_5_11_to_router_6_11_rsp = router_5_11_rsp_out[1];
    assign router_5_11_to_router_5_10_rsp = router_5_11_rsp_out[2];
    assign router_5_11_to_router_4_11_rsp = router_5_11_rsp_out[3];
    assign router_5_11_to_magia_tile_ni_5_11_rsp = router_5_11_rsp_out[4];

    assign router_5_11_to_router_5_12_req = router_5_11_req_out[0];
    assign router_5_11_to_router_6_11_req = router_5_11_req_out[1];
    assign router_5_11_to_router_5_10_req = router_5_11_req_out[2];
    assign router_5_11_to_router_4_11_req = router_5_11_req_out[3];
    assign router_5_11_to_magia_tile_ni_5_11_req = router_5_11_req_out[4];

    assign router_5_11_rsp_in[0] = router_5_12_to_router_5_11_rsp;
    assign router_5_11_rsp_in[1] = router_6_11_to_router_5_11_rsp;
    assign router_5_11_rsp_in[2] = router_5_10_to_router_5_11_rsp;
    assign router_5_11_rsp_in[3] = router_4_11_to_router_5_11_rsp;
    assign router_5_11_rsp_in[4] = magia_tile_ni_5_11_to_router_5_11_rsp;

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
) router_5_11 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 6, y: 11, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_5_11_req_in),
  .floo_rsp_o (router_5_11_rsp_out),
  .floo_req_o (router_5_11_req_out),
  .floo_rsp_i (router_5_11_rsp_in)
);


floo_req_t [4:0] router_5_12_req_in;
floo_rsp_t [4:0] router_5_12_rsp_out;
floo_req_t [4:0] router_5_12_req_out;
floo_rsp_t [4:0] router_5_12_rsp_in;

    assign router_5_12_req_in[0] = router_5_13_to_router_5_12_req;
    assign router_5_12_req_in[1] = router_6_12_to_router_5_12_req;
    assign router_5_12_req_in[2] = router_5_11_to_router_5_12_req;
    assign router_5_12_req_in[3] = router_4_12_to_router_5_12_req;
    assign router_5_12_req_in[4] = magia_tile_ni_5_12_to_router_5_12_req;

    assign router_5_12_to_router_5_13_rsp = router_5_12_rsp_out[0];
    assign router_5_12_to_router_6_12_rsp = router_5_12_rsp_out[1];
    assign router_5_12_to_router_5_11_rsp = router_5_12_rsp_out[2];
    assign router_5_12_to_router_4_12_rsp = router_5_12_rsp_out[3];
    assign router_5_12_to_magia_tile_ni_5_12_rsp = router_5_12_rsp_out[4];

    assign router_5_12_to_router_5_13_req = router_5_12_req_out[0];
    assign router_5_12_to_router_6_12_req = router_5_12_req_out[1];
    assign router_5_12_to_router_5_11_req = router_5_12_req_out[2];
    assign router_5_12_to_router_4_12_req = router_5_12_req_out[3];
    assign router_5_12_to_magia_tile_ni_5_12_req = router_5_12_req_out[4];

    assign router_5_12_rsp_in[0] = router_5_13_to_router_5_12_rsp;
    assign router_5_12_rsp_in[1] = router_6_12_to_router_5_12_rsp;
    assign router_5_12_rsp_in[2] = router_5_11_to_router_5_12_rsp;
    assign router_5_12_rsp_in[3] = router_4_12_to_router_5_12_rsp;
    assign router_5_12_rsp_in[4] = magia_tile_ni_5_12_to_router_5_12_rsp;

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
) router_5_12 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 6, y: 12, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_5_12_req_in),
  .floo_rsp_o (router_5_12_rsp_out),
  .floo_req_o (router_5_12_req_out),
  .floo_rsp_i (router_5_12_rsp_in)
);


floo_req_t [4:0] router_5_13_req_in;
floo_rsp_t [4:0] router_5_13_rsp_out;
floo_req_t [4:0] router_5_13_req_out;
floo_rsp_t [4:0] router_5_13_rsp_in;

    assign router_5_13_req_in[0] = router_5_14_to_router_5_13_req;
    assign router_5_13_req_in[1] = router_6_13_to_router_5_13_req;
    assign router_5_13_req_in[2] = router_5_12_to_router_5_13_req;
    assign router_5_13_req_in[3] = router_4_13_to_router_5_13_req;
    assign router_5_13_req_in[4] = magia_tile_ni_5_13_to_router_5_13_req;

    assign router_5_13_to_router_5_14_rsp = router_5_13_rsp_out[0];
    assign router_5_13_to_router_6_13_rsp = router_5_13_rsp_out[1];
    assign router_5_13_to_router_5_12_rsp = router_5_13_rsp_out[2];
    assign router_5_13_to_router_4_13_rsp = router_5_13_rsp_out[3];
    assign router_5_13_to_magia_tile_ni_5_13_rsp = router_5_13_rsp_out[4];

    assign router_5_13_to_router_5_14_req = router_5_13_req_out[0];
    assign router_5_13_to_router_6_13_req = router_5_13_req_out[1];
    assign router_5_13_to_router_5_12_req = router_5_13_req_out[2];
    assign router_5_13_to_router_4_13_req = router_5_13_req_out[3];
    assign router_5_13_to_magia_tile_ni_5_13_req = router_5_13_req_out[4];

    assign router_5_13_rsp_in[0] = router_5_14_to_router_5_13_rsp;
    assign router_5_13_rsp_in[1] = router_6_13_to_router_5_13_rsp;
    assign router_5_13_rsp_in[2] = router_5_12_to_router_5_13_rsp;
    assign router_5_13_rsp_in[3] = router_4_13_to_router_5_13_rsp;
    assign router_5_13_rsp_in[4] = magia_tile_ni_5_13_to_router_5_13_rsp;

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
) router_5_13 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 6, y: 13, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_5_13_req_in),
  .floo_rsp_o (router_5_13_rsp_out),
  .floo_req_o (router_5_13_req_out),
  .floo_rsp_i (router_5_13_rsp_in)
);


floo_req_t [4:0] router_5_14_req_in;
floo_rsp_t [4:0] router_5_14_rsp_out;
floo_req_t [4:0] router_5_14_req_out;
floo_rsp_t [4:0] router_5_14_rsp_in;

    assign router_5_14_req_in[0] = router_5_15_to_router_5_14_req;
    assign router_5_14_req_in[1] = router_6_14_to_router_5_14_req;
    assign router_5_14_req_in[2] = router_5_13_to_router_5_14_req;
    assign router_5_14_req_in[3] = router_4_14_to_router_5_14_req;
    assign router_5_14_req_in[4] = magia_tile_ni_5_14_to_router_5_14_req;

    assign router_5_14_to_router_5_15_rsp = router_5_14_rsp_out[0];
    assign router_5_14_to_router_6_14_rsp = router_5_14_rsp_out[1];
    assign router_5_14_to_router_5_13_rsp = router_5_14_rsp_out[2];
    assign router_5_14_to_router_4_14_rsp = router_5_14_rsp_out[3];
    assign router_5_14_to_magia_tile_ni_5_14_rsp = router_5_14_rsp_out[4];

    assign router_5_14_to_router_5_15_req = router_5_14_req_out[0];
    assign router_5_14_to_router_6_14_req = router_5_14_req_out[1];
    assign router_5_14_to_router_5_13_req = router_5_14_req_out[2];
    assign router_5_14_to_router_4_14_req = router_5_14_req_out[3];
    assign router_5_14_to_magia_tile_ni_5_14_req = router_5_14_req_out[4];

    assign router_5_14_rsp_in[0] = router_5_15_to_router_5_14_rsp;
    assign router_5_14_rsp_in[1] = router_6_14_to_router_5_14_rsp;
    assign router_5_14_rsp_in[2] = router_5_13_to_router_5_14_rsp;
    assign router_5_14_rsp_in[3] = router_4_14_to_router_5_14_rsp;
    assign router_5_14_rsp_in[4] = magia_tile_ni_5_14_to_router_5_14_rsp;

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
) router_5_14 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 6, y: 14, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_5_14_req_in),
  .floo_rsp_o (router_5_14_rsp_out),
  .floo_req_o (router_5_14_req_out),
  .floo_rsp_i (router_5_14_rsp_in)
);


floo_req_t [4:0] router_5_15_req_in;
floo_rsp_t [4:0] router_5_15_rsp_out;
floo_req_t [4:0] router_5_15_req_out;
floo_rsp_t [4:0] router_5_15_rsp_in;

    assign router_5_15_req_in[0] = '0;
    assign router_5_15_req_in[1] = router_6_15_to_router_5_15_req;
    assign router_5_15_req_in[2] = router_5_14_to_router_5_15_req;
    assign router_5_15_req_in[3] = router_4_15_to_router_5_15_req;
    assign router_5_15_req_in[4] = magia_tile_ni_5_15_to_router_5_15_req;

    assign router_5_15_to_router_6_15_rsp = router_5_15_rsp_out[1];
    assign router_5_15_to_router_5_14_rsp = router_5_15_rsp_out[2];
    assign router_5_15_to_router_4_15_rsp = router_5_15_rsp_out[3];
    assign router_5_15_to_magia_tile_ni_5_15_rsp = router_5_15_rsp_out[4];

    assign router_5_15_to_router_6_15_req = router_5_15_req_out[1];
    assign router_5_15_to_router_5_14_req = router_5_15_req_out[2];
    assign router_5_15_to_router_4_15_req = router_5_15_req_out[3];
    assign router_5_15_to_magia_tile_ni_5_15_req = router_5_15_req_out[4];

    assign router_5_15_rsp_in[0] = '0;
    assign router_5_15_rsp_in[1] = router_6_15_to_router_5_15_rsp;
    assign router_5_15_rsp_in[2] = router_5_14_to_router_5_15_rsp;
    assign router_5_15_rsp_in[3] = router_4_15_to_router_5_15_rsp;
    assign router_5_15_rsp_in[4] = magia_tile_ni_5_15_to_router_5_15_rsp;

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
) router_5_15 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 6, y: 15, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_5_15_req_in),
  .floo_rsp_o (router_5_15_rsp_out),
  .floo_req_o (router_5_15_req_out),
  .floo_rsp_i (router_5_15_rsp_in)
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

    assign router_6_7_req_in[0] = router_6_8_to_router_6_7_req;
    assign router_6_7_req_in[1] = router_7_7_to_router_6_7_req;
    assign router_6_7_req_in[2] = router_6_6_to_router_6_7_req;
    assign router_6_7_req_in[3] = router_5_7_to_router_6_7_req;
    assign router_6_7_req_in[4] = magia_tile_ni_6_7_to_router_6_7_req;

    assign router_6_7_to_router_6_8_rsp = router_6_7_rsp_out[0];
    assign router_6_7_to_router_7_7_rsp = router_6_7_rsp_out[1];
    assign router_6_7_to_router_6_6_rsp = router_6_7_rsp_out[2];
    assign router_6_7_to_router_5_7_rsp = router_6_7_rsp_out[3];
    assign router_6_7_to_magia_tile_ni_6_7_rsp = router_6_7_rsp_out[4];

    assign router_6_7_to_router_6_8_req = router_6_7_req_out[0];
    assign router_6_7_to_router_7_7_req = router_6_7_req_out[1];
    assign router_6_7_to_router_6_6_req = router_6_7_req_out[2];
    assign router_6_7_to_router_5_7_req = router_6_7_req_out[3];
    assign router_6_7_to_magia_tile_ni_6_7_req = router_6_7_req_out[4];

    assign router_6_7_rsp_in[0] = router_6_8_to_router_6_7_rsp;
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


floo_req_t [4:0] router_6_8_req_in;
floo_rsp_t [4:0] router_6_8_rsp_out;
floo_req_t [4:0] router_6_8_req_out;
floo_rsp_t [4:0] router_6_8_rsp_in;

    assign router_6_8_req_in[0] = router_6_9_to_router_6_8_req;
    assign router_6_8_req_in[1] = router_7_8_to_router_6_8_req;
    assign router_6_8_req_in[2] = router_6_7_to_router_6_8_req;
    assign router_6_8_req_in[3] = router_5_8_to_router_6_8_req;
    assign router_6_8_req_in[4] = magia_tile_ni_6_8_to_router_6_8_req;

    assign router_6_8_to_router_6_9_rsp = router_6_8_rsp_out[0];
    assign router_6_8_to_router_7_8_rsp = router_6_8_rsp_out[1];
    assign router_6_8_to_router_6_7_rsp = router_6_8_rsp_out[2];
    assign router_6_8_to_router_5_8_rsp = router_6_8_rsp_out[3];
    assign router_6_8_to_magia_tile_ni_6_8_rsp = router_6_8_rsp_out[4];

    assign router_6_8_to_router_6_9_req = router_6_8_req_out[0];
    assign router_6_8_to_router_7_8_req = router_6_8_req_out[1];
    assign router_6_8_to_router_6_7_req = router_6_8_req_out[2];
    assign router_6_8_to_router_5_8_req = router_6_8_req_out[3];
    assign router_6_8_to_magia_tile_ni_6_8_req = router_6_8_req_out[4];

    assign router_6_8_rsp_in[0] = router_6_9_to_router_6_8_rsp;
    assign router_6_8_rsp_in[1] = router_7_8_to_router_6_8_rsp;
    assign router_6_8_rsp_in[2] = router_6_7_to_router_6_8_rsp;
    assign router_6_8_rsp_in[3] = router_5_8_to_router_6_8_rsp;
    assign router_6_8_rsp_in[4] = magia_tile_ni_6_8_to_router_6_8_rsp;

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
) router_6_8 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 7, y: 8, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_6_8_req_in),
  .floo_rsp_o (router_6_8_rsp_out),
  .floo_req_o (router_6_8_req_out),
  .floo_rsp_i (router_6_8_rsp_in)
);


floo_req_t [4:0] router_6_9_req_in;
floo_rsp_t [4:0] router_6_9_rsp_out;
floo_req_t [4:0] router_6_9_req_out;
floo_rsp_t [4:0] router_6_9_rsp_in;

    assign router_6_9_req_in[0] = router_6_10_to_router_6_9_req;
    assign router_6_9_req_in[1] = router_7_9_to_router_6_9_req;
    assign router_6_9_req_in[2] = router_6_8_to_router_6_9_req;
    assign router_6_9_req_in[3] = router_5_9_to_router_6_9_req;
    assign router_6_9_req_in[4] = magia_tile_ni_6_9_to_router_6_9_req;

    assign router_6_9_to_router_6_10_rsp = router_6_9_rsp_out[0];
    assign router_6_9_to_router_7_9_rsp = router_6_9_rsp_out[1];
    assign router_6_9_to_router_6_8_rsp = router_6_9_rsp_out[2];
    assign router_6_9_to_router_5_9_rsp = router_6_9_rsp_out[3];
    assign router_6_9_to_magia_tile_ni_6_9_rsp = router_6_9_rsp_out[4];

    assign router_6_9_to_router_6_10_req = router_6_9_req_out[0];
    assign router_6_9_to_router_7_9_req = router_6_9_req_out[1];
    assign router_6_9_to_router_6_8_req = router_6_9_req_out[2];
    assign router_6_9_to_router_5_9_req = router_6_9_req_out[3];
    assign router_6_9_to_magia_tile_ni_6_9_req = router_6_9_req_out[4];

    assign router_6_9_rsp_in[0] = router_6_10_to_router_6_9_rsp;
    assign router_6_9_rsp_in[1] = router_7_9_to_router_6_9_rsp;
    assign router_6_9_rsp_in[2] = router_6_8_to_router_6_9_rsp;
    assign router_6_9_rsp_in[3] = router_5_9_to_router_6_9_rsp;
    assign router_6_9_rsp_in[4] = magia_tile_ni_6_9_to_router_6_9_rsp;

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
) router_6_9 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 7, y: 9, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_6_9_req_in),
  .floo_rsp_o (router_6_9_rsp_out),
  .floo_req_o (router_6_9_req_out),
  .floo_rsp_i (router_6_9_rsp_in)
);


floo_req_t [4:0] router_6_10_req_in;
floo_rsp_t [4:0] router_6_10_rsp_out;
floo_req_t [4:0] router_6_10_req_out;
floo_rsp_t [4:0] router_6_10_rsp_in;

    assign router_6_10_req_in[0] = router_6_11_to_router_6_10_req;
    assign router_6_10_req_in[1] = router_7_10_to_router_6_10_req;
    assign router_6_10_req_in[2] = router_6_9_to_router_6_10_req;
    assign router_6_10_req_in[3] = router_5_10_to_router_6_10_req;
    assign router_6_10_req_in[4] = magia_tile_ni_6_10_to_router_6_10_req;

    assign router_6_10_to_router_6_11_rsp = router_6_10_rsp_out[0];
    assign router_6_10_to_router_7_10_rsp = router_6_10_rsp_out[1];
    assign router_6_10_to_router_6_9_rsp = router_6_10_rsp_out[2];
    assign router_6_10_to_router_5_10_rsp = router_6_10_rsp_out[3];
    assign router_6_10_to_magia_tile_ni_6_10_rsp = router_6_10_rsp_out[4];

    assign router_6_10_to_router_6_11_req = router_6_10_req_out[0];
    assign router_6_10_to_router_7_10_req = router_6_10_req_out[1];
    assign router_6_10_to_router_6_9_req = router_6_10_req_out[2];
    assign router_6_10_to_router_5_10_req = router_6_10_req_out[3];
    assign router_6_10_to_magia_tile_ni_6_10_req = router_6_10_req_out[4];

    assign router_6_10_rsp_in[0] = router_6_11_to_router_6_10_rsp;
    assign router_6_10_rsp_in[1] = router_7_10_to_router_6_10_rsp;
    assign router_6_10_rsp_in[2] = router_6_9_to_router_6_10_rsp;
    assign router_6_10_rsp_in[3] = router_5_10_to_router_6_10_rsp;
    assign router_6_10_rsp_in[4] = magia_tile_ni_6_10_to_router_6_10_rsp;

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
) router_6_10 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 7, y: 10, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_6_10_req_in),
  .floo_rsp_o (router_6_10_rsp_out),
  .floo_req_o (router_6_10_req_out),
  .floo_rsp_i (router_6_10_rsp_in)
);


floo_req_t [4:0] router_6_11_req_in;
floo_rsp_t [4:0] router_6_11_rsp_out;
floo_req_t [4:0] router_6_11_req_out;
floo_rsp_t [4:0] router_6_11_rsp_in;

    assign router_6_11_req_in[0] = router_6_12_to_router_6_11_req;
    assign router_6_11_req_in[1] = router_7_11_to_router_6_11_req;
    assign router_6_11_req_in[2] = router_6_10_to_router_6_11_req;
    assign router_6_11_req_in[3] = router_5_11_to_router_6_11_req;
    assign router_6_11_req_in[4] = magia_tile_ni_6_11_to_router_6_11_req;

    assign router_6_11_to_router_6_12_rsp = router_6_11_rsp_out[0];
    assign router_6_11_to_router_7_11_rsp = router_6_11_rsp_out[1];
    assign router_6_11_to_router_6_10_rsp = router_6_11_rsp_out[2];
    assign router_6_11_to_router_5_11_rsp = router_6_11_rsp_out[3];
    assign router_6_11_to_magia_tile_ni_6_11_rsp = router_6_11_rsp_out[4];

    assign router_6_11_to_router_6_12_req = router_6_11_req_out[0];
    assign router_6_11_to_router_7_11_req = router_6_11_req_out[1];
    assign router_6_11_to_router_6_10_req = router_6_11_req_out[2];
    assign router_6_11_to_router_5_11_req = router_6_11_req_out[3];
    assign router_6_11_to_magia_tile_ni_6_11_req = router_6_11_req_out[4];

    assign router_6_11_rsp_in[0] = router_6_12_to_router_6_11_rsp;
    assign router_6_11_rsp_in[1] = router_7_11_to_router_6_11_rsp;
    assign router_6_11_rsp_in[2] = router_6_10_to_router_6_11_rsp;
    assign router_6_11_rsp_in[3] = router_5_11_to_router_6_11_rsp;
    assign router_6_11_rsp_in[4] = magia_tile_ni_6_11_to_router_6_11_rsp;

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
) router_6_11 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 7, y: 11, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_6_11_req_in),
  .floo_rsp_o (router_6_11_rsp_out),
  .floo_req_o (router_6_11_req_out),
  .floo_rsp_i (router_6_11_rsp_in)
);


floo_req_t [4:0] router_6_12_req_in;
floo_rsp_t [4:0] router_6_12_rsp_out;
floo_req_t [4:0] router_6_12_req_out;
floo_rsp_t [4:0] router_6_12_rsp_in;

    assign router_6_12_req_in[0] = router_6_13_to_router_6_12_req;
    assign router_6_12_req_in[1] = router_7_12_to_router_6_12_req;
    assign router_6_12_req_in[2] = router_6_11_to_router_6_12_req;
    assign router_6_12_req_in[3] = router_5_12_to_router_6_12_req;
    assign router_6_12_req_in[4] = magia_tile_ni_6_12_to_router_6_12_req;

    assign router_6_12_to_router_6_13_rsp = router_6_12_rsp_out[0];
    assign router_6_12_to_router_7_12_rsp = router_6_12_rsp_out[1];
    assign router_6_12_to_router_6_11_rsp = router_6_12_rsp_out[2];
    assign router_6_12_to_router_5_12_rsp = router_6_12_rsp_out[3];
    assign router_6_12_to_magia_tile_ni_6_12_rsp = router_6_12_rsp_out[4];

    assign router_6_12_to_router_6_13_req = router_6_12_req_out[0];
    assign router_6_12_to_router_7_12_req = router_6_12_req_out[1];
    assign router_6_12_to_router_6_11_req = router_6_12_req_out[2];
    assign router_6_12_to_router_5_12_req = router_6_12_req_out[3];
    assign router_6_12_to_magia_tile_ni_6_12_req = router_6_12_req_out[4];

    assign router_6_12_rsp_in[0] = router_6_13_to_router_6_12_rsp;
    assign router_6_12_rsp_in[1] = router_7_12_to_router_6_12_rsp;
    assign router_6_12_rsp_in[2] = router_6_11_to_router_6_12_rsp;
    assign router_6_12_rsp_in[3] = router_5_12_to_router_6_12_rsp;
    assign router_6_12_rsp_in[4] = magia_tile_ni_6_12_to_router_6_12_rsp;

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
) router_6_12 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 7, y: 12, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_6_12_req_in),
  .floo_rsp_o (router_6_12_rsp_out),
  .floo_req_o (router_6_12_req_out),
  .floo_rsp_i (router_6_12_rsp_in)
);


floo_req_t [4:0] router_6_13_req_in;
floo_rsp_t [4:0] router_6_13_rsp_out;
floo_req_t [4:0] router_6_13_req_out;
floo_rsp_t [4:0] router_6_13_rsp_in;

    assign router_6_13_req_in[0] = router_6_14_to_router_6_13_req;
    assign router_6_13_req_in[1] = router_7_13_to_router_6_13_req;
    assign router_6_13_req_in[2] = router_6_12_to_router_6_13_req;
    assign router_6_13_req_in[3] = router_5_13_to_router_6_13_req;
    assign router_6_13_req_in[4] = magia_tile_ni_6_13_to_router_6_13_req;

    assign router_6_13_to_router_6_14_rsp = router_6_13_rsp_out[0];
    assign router_6_13_to_router_7_13_rsp = router_6_13_rsp_out[1];
    assign router_6_13_to_router_6_12_rsp = router_6_13_rsp_out[2];
    assign router_6_13_to_router_5_13_rsp = router_6_13_rsp_out[3];
    assign router_6_13_to_magia_tile_ni_6_13_rsp = router_6_13_rsp_out[4];

    assign router_6_13_to_router_6_14_req = router_6_13_req_out[0];
    assign router_6_13_to_router_7_13_req = router_6_13_req_out[1];
    assign router_6_13_to_router_6_12_req = router_6_13_req_out[2];
    assign router_6_13_to_router_5_13_req = router_6_13_req_out[3];
    assign router_6_13_to_magia_tile_ni_6_13_req = router_6_13_req_out[4];

    assign router_6_13_rsp_in[0] = router_6_14_to_router_6_13_rsp;
    assign router_6_13_rsp_in[1] = router_7_13_to_router_6_13_rsp;
    assign router_6_13_rsp_in[2] = router_6_12_to_router_6_13_rsp;
    assign router_6_13_rsp_in[3] = router_5_13_to_router_6_13_rsp;
    assign router_6_13_rsp_in[4] = magia_tile_ni_6_13_to_router_6_13_rsp;

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
) router_6_13 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 7, y: 13, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_6_13_req_in),
  .floo_rsp_o (router_6_13_rsp_out),
  .floo_req_o (router_6_13_req_out),
  .floo_rsp_i (router_6_13_rsp_in)
);


floo_req_t [4:0] router_6_14_req_in;
floo_rsp_t [4:0] router_6_14_rsp_out;
floo_req_t [4:0] router_6_14_req_out;
floo_rsp_t [4:0] router_6_14_rsp_in;

    assign router_6_14_req_in[0] = router_6_15_to_router_6_14_req;
    assign router_6_14_req_in[1] = router_7_14_to_router_6_14_req;
    assign router_6_14_req_in[2] = router_6_13_to_router_6_14_req;
    assign router_6_14_req_in[3] = router_5_14_to_router_6_14_req;
    assign router_6_14_req_in[4] = magia_tile_ni_6_14_to_router_6_14_req;

    assign router_6_14_to_router_6_15_rsp = router_6_14_rsp_out[0];
    assign router_6_14_to_router_7_14_rsp = router_6_14_rsp_out[1];
    assign router_6_14_to_router_6_13_rsp = router_6_14_rsp_out[2];
    assign router_6_14_to_router_5_14_rsp = router_6_14_rsp_out[3];
    assign router_6_14_to_magia_tile_ni_6_14_rsp = router_6_14_rsp_out[4];

    assign router_6_14_to_router_6_15_req = router_6_14_req_out[0];
    assign router_6_14_to_router_7_14_req = router_6_14_req_out[1];
    assign router_6_14_to_router_6_13_req = router_6_14_req_out[2];
    assign router_6_14_to_router_5_14_req = router_6_14_req_out[3];
    assign router_6_14_to_magia_tile_ni_6_14_req = router_6_14_req_out[4];

    assign router_6_14_rsp_in[0] = router_6_15_to_router_6_14_rsp;
    assign router_6_14_rsp_in[1] = router_7_14_to_router_6_14_rsp;
    assign router_6_14_rsp_in[2] = router_6_13_to_router_6_14_rsp;
    assign router_6_14_rsp_in[3] = router_5_14_to_router_6_14_rsp;
    assign router_6_14_rsp_in[4] = magia_tile_ni_6_14_to_router_6_14_rsp;

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
) router_6_14 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 7, y: 14, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_6_14_req_in),
  .floo_rsp_o (router_6_14_rsp_out),
  .floo_req_o (router_6_14_req_out),
  .floo_rsp_i (router_6_14_rsp_in)
);


floo_req_t [4:0] router_6_15_req_in;
floo_rsp_t [4:0] router_6_15_rsp_out;
floo_req_t [4:0] router_6_15_req_out;
floo_rsp_t [4:0] router_6_15_rsp_in;

    assign router_6_15_req_in[0] = '0;
    assign router_6_15_req_in[1] = router_7_15_to_router_6_15_req;
    assign router_6_15_req_in[2] = router_6_14_to_router_6_15_req;
    assign router_6_15_req_in[3] = router_5_15_to_router_6_15_req;
    assign router_6_15_req_in[4] = magia_tile_ni_6_15_to_router_6_15_req;

    assign router_6_15_to_router_7_15_rsp = router_6_15_rsp_out[1];
    assign router_6_15_to_router_6_14_rsp = router_6_15_rsp_out[2];
    assign router_6_15_to_router_5_15_rsp = router_6_15_rsp_out[3];
    assign router_6_15_to_magia_tile_ni_6_15_rsp = router_6_15_rsp_out[4];

    assign router_6_15_to_router_7_15_req = router_6_15_req_out[1];
    assign router_6_15_to_router_6_14_req = router_6_15_req_out[2];
    assign router_6_15_to_router_5_15_req = router_6_15_req_out[3];
    assign router_6_15_to_magia_tile_ni_6_15_req = router_6_15_req_out[4];

    assign router_6_15_rsp_in[0] = '0;
    assign router_6_15_rsp_in[1] = router_7_15_to_router_6_15_rsp;
    assign router_6_15_rsp_in[2] = router_6_14_to_router_6_15_rsp;
    assign router_6_15_rsp_in[3] = router_5_15_to_router_6_15_rsp;
    assign router_6_15_rsp_in[4] = magia_tile_ni_6_15_to_router_6_15_rsp;

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
) router_6_15 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 7, y: 15, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_6_15_req_in),
  .floo_rsp_o (router_6_15_rsp_out),
  .floo_req_o (router_6_15_req_out),
  .floo_rsp_i (router_6_15_rsp_in)
);


floo_req_t [4:0] router_7_0_req_in;
floo_rsp_t [4:0] router_7_0_rsp_out;
floo_req_t [4:0] router_7_0_req_out;
floo_rsp_t [4:0] router_7_0_rsp_in;

    assign router_7_0_req_in[0] = router_7_1_to_router_7_0_req;
    assign router_7_0_req_in[1] = router_8_0_to_router_7_0_req;
    assign router_7_0_req_in[2] = '0;
    assign router_7_0_req_in[3] = router_6_0_to_router_7_0_req;
    assign router_7_0_req_in[4] = magia_tile_ni_7_0_to_router_7_0_req;

    assign router_7_0_to_router_7_1_rsp = router_7_0_rsp_out[0];
    assign router_7_0_to_router_8_0_rsp = router_7_0_rsp_out[1];
    assign router_7_0_to_router_6_0_rsp = router_7_0_rsp_out[3];
    assign router_7_0_to_magia_tile_ni_7_0_rsp = router_7_0_rsp_out[4];

    assign router_7_0_to_router_7_1_req = router_7_0_req_out[0];
    assign router_7_0_to_router_8_0_req = router_7_0_req_out[1];
    assign router_7_0_to_router_6_0_req = router_7_0_req_out[3];
    assign router_7_0_to_magia_tile_ni_7_0_req = router_7_0_req_out[4];

    assign router_7_0_rsp_in[0] = router_7_1_to_router_7_0_rsp;
    assign router_7_0_rsp_in[1] = router_8_0_to_router_7_0_rsp;
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
    assign router_7_1_req_in[1] = router_8_1_to_router_7_1_req;
    assign router_7_1_req_in[2] = router_7_0_to_router_7_1_req;
    assign router_7_1_req_in[3] = router_6_1_to_router_7_1_req;
    assign router_7_1_req_in[4] = magia_tile_ni_7_1_to_router_7_1_req;

    assign router_7_1_to_router_7_2_rsp = router_7_1_rsp_out[0];
    assign router_7_1_to_router_8_1_rsp = router_7_1_rsp_out[1];
    assign router_7_1_to_router_7_0_rsp = router_7_1_rsp_out[2];
    assign router_7_1_to_router_6_1_rsp = router_7_1_rsp_out[3];
    assign router_7_1_to_magia_tile_ni_7_1_rsp = router_7_1_rsp_out[4];

    assign router_7_1_to_router_7_2_req = router_7_1_req_out[0];
    assign router_7_1_to_router_8_1_req = router_7_1_req_out[1];
    assign router_7_1_to_router_7_0_req = router_7_1_req_out[2];
    assign router_7_1_to_router_6_1_req = router_7_1_req_out[3];
    assign router_7_1_to_magia_tile_ni_7_1_req = router_7_1_req_out[4];

    assign router_7_1_rsp_in[0] = router_7_2_to_router_7_1_rsp;
    assign router_7_1_rsp_in[1] = router_8_1_to_router_7_1_rsp;
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
    assign router_7_2_req_in[1] = router_8_2_to_router_7_2_req;
    assign router_7_2_req_in[2] = router_7_1_to_router_7_2_req;
    assign router_7_2_req_in[3] = router_6_2_to_router_7_2_req;
    assign router_7_2_req_in[4] = magia_tile_ni_7_2_to_router_7_2_req;

    assign router_7_2_to_router_7_3_rsp = router_7_2_rsp_out[0];
    assign router_7_2_to_router_8_2_rsp = router_7_2_rsp_out[1];
    assign router_7_2_to_router_7_1_rsp = router_7_2_rsp_out[2];
    assign router_7_2_to_router_6_2_rsp = router_7_2_rsp_out[3];
    assign router_7_2_to_magia_tile_ni_7_2_rsp = router_7_2_rsp_out[4];

    assign router_7_2_to_router_7_3_req = router_7_2_req_out[0];
    assign router_7_2_to_router_8_2_req = router_7_2_req_out[1];
    assign router_7_2_to_router_7_1_req = router_7_2_req_out[2];
    assign router_7_2_to_router_6_2_req = router_7_2_req_out[3];
    assign router_7_2_to_magia_tile_ni_7_2_req = router_7_2_req_out[4];

    assign router_7_2_rsp_in[0] = router_7_3_to_router_7_2_rsp;
    assign router_7_2_rsp_in[1] = router_8_2_to_router_7_2_rsp;
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
    assign router_7_3_req_in[1] = router_8_3_to_router_7_3_req;
    assign router_7_3_req_in[2] = router_7_2_to_router_7_3_req;
    assign router_7_3_req_in[3] = router_6_3_to_router_7_3_req;
    assign router_7_3_req_in[4] = magia_tile_ni_7_3_to_router_7_3_req;

    assign router_7_3_to_router_7_4_rsp = router_7_3_rsp_out[0];
    assign router_7_3_to_router_8_3_rsp = router_7_3_rsp_out[1];
    assign router_7_3_to_router_7_2_rsp = router_7_3_rsp_out[2];
    assign router_7_3_to_router_6_3_rsp = router_7_3_rsp_out[3];
    assign router_7_3_to_magia_tile_ni_7_3_rsp = router_7_3_rsp_out[4];

    assign router_7_3_to_router_7_4_req = router_7_3_req_out[0];
    assign router_7_3_to_router_8_3_req = router_7_3_req_out[1];
    assign router_7_3_to_router_7_2_req = router_7_3_req_out[2];
    assign router_7_3_to_router_6_3_req = router_7_3_req_out[3];
    assign router_7_3_to_magia_tile_ni_7_3_req = router_7_3_req_out[4];

    assign router_7_3_rsp_in[0] = router_7_4_to_router_7_3_rsp;
    assign router_7_3_rsp_in[1] = router_8_3_to_router_7_3_rsp;
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
    assign router_7_4_req_in[1] = router_8_4_to_router_7_4_req;
    assign router_7_4_req_in[2] = router_7_3_to_router_7_4_req;
    assign router_7_4_req_in[3] = router_6_4_to_router_7_4_req;
    assign router_7_4_req_in[4] = magia_tile_ni_7_4_to_router_7_4_req;

    assign router_7_4_to_router_7_5_rsp = router_7_4_rsp_out[0];
    assign router_7_4_to_router_8_4_rsp = router_7_4_rsp_out[1];
    assign router_7_4_to_router_7_3_rsp = router_7_4_rsp_out[2];
    assign router_7_4_to_router_6_4_rsp = router_7_4_rsp_out[3];
    assign router_7_4_to_magia_tile_ni_7_4_rsp = router_7_4_rsp_out[4];

    assign router_7_4_to_router_7_5_req = router_7_4_req_out[0];
    assign router_7_4_to_router_8_4_req = router_7_4_req_out[1];
    assign router_7_4_to_router_7_3_req = router_7_4_req_out[2];
    assign router_7_4_to_router_6_4_req = router_7_4_req_out[3];
    assign router_7_4_to_magia_tile_ni_7_4_req = router_7_4_req_out[4];

    assign router_7_4_rsp_in[0] = router_7_5_to_router_7_4_rsp;
    assign router_7_4_rsp_in[1] = router_8_4_to_router_7_4_rsp;
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
    assign router_7_5_req_in[1] = router_8_5_to_router_7_5_req;
    assign router_7_5_req_in[2] = router_7_4_to_router_7_5_req;
    assign router_7_5_req_in[3] = router_6_5_to_router_7_5_req;
    assign router_7_5_req_in[4] = magia_tile_ni_7_5_to_router_7_5_req;

    assign router_7_5_to_router_7_6_rsp = router_7_5_rsp_out[0];
    assign router_7_5_to_router_8_5_rsp = router_7_5_rsp_out[1];
    assign router_7_5_to_router_7_4_rsp = router_7_5_rsp_out[2];
    assign router_7_5_to_router_6_5_rsp = router_7_5_rsp_out[3];
    assign router_7_5_to_magia_tile_ni_7_5_rsp = router_7_5_rsp_out[4];

    assign router_7_5_to_router_7_6_req = router_7_5_req_out[0];
    assign router_7_5_to_router_8_5_req = router_7_5_req_out[1];
    assign router_7_5_to_router_7_4_req = router_7_5_req_out[2];
    assign router_7_5_to_router_6_5_req = router_7_5_req_out[3];
    assign router_7_5_to_magia_tile_ni_7_5_req = router_7_5_req_out[4];

    assign router_7_5_rsp_in[0] = router_7_6_to_router_7_5_rsp;
    assign router_7_5_rsp_in[1] = router_8_5_to_router_7_5_rsp;
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
    assign router_7_6_req_in[1] = router_8_6_to_router_7_6_req;
    assign router_7_6_req_in[2] = router_7_5_to_router_7_6_req;
    assign router_7_6_req_in[3] = router_6_6_to_router_7_6_req;
    assign router_7_6_req_in[4] = magia_tile_ni_7_6_to_router_7_6_req;

    assign router_7_6_to_router_7_7_rsp = router_7_6_rsp_out[0];
    assign router_7_6_to_router_8_6_rsp = router_7_6_rsp_out[1];
    assign router_7_6_to_router_7_5_rsp = router_7_6_rsp_out[2];
    assign router_7_6_to_router_6_6_rsp = router_7_6_rsp_out[3];
    assign router_7_6_to_magia_tile_ni_7_6_rsp = router_7_6_rsp_out[4];

    assign router_7_6_to_router_7_7_req = router_7_6_req_out[0];
    assign router_7_6_to_router_8_6_req = router_7_6_req_out[1];
    assign router_7_6_to_router_7_5_req = router_7_6_req_out[2];
    assign router_7_6_to_router_6_6_req = router_7_6_req_out[3];
    assign router_7_6_to_magia_tile_ni_7_6_req = router_7_6_req_out[4];

    assign router_7_6_rsp_in[0] = router_7_7_to_router_7_6_rsp;
    assign router_7_6_rsp_in[1] = router_8_6_to_router_7_6_rsp;
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

    assign router_7_7_req_in[0] = router_7_8_to_router_7_7_req;
    assign router_7_7_req_in[1] = router_8_7_to_router_7_7_req;
    assign router_7_7_req_in[2] = router_7_6_to_router_7_7_req;
    assign router_7_7_req_in[3] = router_6_7_to_router_7_7_req;
    assign router_7_7_req_in[4] = magia_tile_ni_7_7_to_router_7_7_req;

    assign router_7_7_to_router_7_8_rsp = router_7_7_rsp_out[0];
    assign router_7_7_to_router_8_7_rsp = router_7_7_rsp_out[1];
    assign router_7_7_to_router_7_6_rsp = router_7_7_rsp_out[2];
    assign router_7_7_to_router_6_7_rsp = router_7_7_rsp_out[3];
    assign router_7_7_to_magia_tile_ni_7_7_rsp = router_7_7_rsp_out[4];

    assign router_7_7_to_router_7_8_req = router_7_7_req_out[0];
    assign router_7_7_to_router_8_7_req = router_7_7_req_out[1];
    assign router_7_7_to_router_7_6_req = router_7_7_req_out[2];
    assign router_7_7_to_router_6_7_req = router_7_7_req_out[3];
    assign router_7_7_to_magia_tile_ni_7_7_req = router_7_7_req_out[4];

    assign router_7_7_rsp_in[0] = router_7_8_to_router_7_7_rsp;
    assign router_7_7_rsp_in[1] = router_8_7_to_router_7_7_rsp;
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


floo_req_t [4:0] router_7_8_req_in;
floo_rsp_t [4:0] router_7_8_rsp_out;
floo_req_t [4:0] router_7_8_req_out;
floo_rsp_t [4:0] router_7_8_rsp_in;

    assign router_7_8_req_in[0] = router_7_9_to_router_7_8_req;
    assign router_7_8_req_in[1] = router_8_8_to_router_7_8_req;
    assign router_7_8_req_in[2] = router_7_7_to_router_7_8_req;
    assign router_7_8_req_in[3] = router_6_8_to_router_7_8_req;
    assign router_7_8_req_in[4] = magia_tile_ni_7_8_to_router_7_8_req;

    assign router_7_8_to_router_7_9_rsp = router_7_8_rsp_out[0];
    assign router_7_8_to_router_8_8_rsp = router_7_8_rsp_out[1];
    assign router_7_8_to_router_7_7_rsp = router_7_8_rsp_out[2];
    assign router_7_8_to_router_6_8_rsp = router_7_8_rsp_out[3];
    assign router_7_8_to_magia_tile_ni_7_8_rsp = router_7_8_rsp_out[4];

    assign router_7_8_to_router_7_9_req = router_7_8_req_out[0];
    assign router_7_8_to_router_8_8_req = router_7_8_req_out[1];
    assign router_7_8_to_router_7_7_req = router_7_8_req_out[2];
    assign router_7_8_to_router_6_8_req = router_7_8_req_out[3];
    assign router_7_8_to_magia_tile_ni_7_8_req = router_7_8_req_out[4];

    assign router_7_8_rsp_in[0] = router_7_9_to_router_7_8_rsp;
    assign router_7_8_rsp_in[1] = router_8_8_to_router_7_8_rsp;
    assign router_7_8_rsp_in[2] = router_7_7_to_router_7_8_rsp;
    assign router_7_8_rsp_in[3] = router_6_8_to_router_7_8_rsp;
    assign router_7_8_rsp_in[4] = magia_tile_ni_7_8_to_router_7_8_rsp;

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
) router_7_8 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 8, y: 8, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_7_8_req_in),
  .floo_rsp_o (router_7_8_rsp_out),
  .floo_req_o (router_7_8_req_out),
  .floo_rsp_i (router_7_8_rsp_in)
);


floo_req_t [4:0] router_7_9_req_in;
floo_rsp_t [4:0] router_7_9_rsp_out;
floo_req_t [4:0] router_7_9_req_out;
floo_rsp_t [4:0] router_7_9_rsp_in;

    assign router_7_9_req_in[0] = router_7_10_to_router_7_9_req;
    assign router_7_9_req_in[1] = router_8_9_to_router_7_9_req;
    assign router_7_9_req_in[2] = router_7_8_to_router_7_9_req;
    assign router_7_9_req_in[3] = router_6_9_to_router_7_9_req;
    assign router_7_9_req_in[4] = magia_tile_ni_7_9_to_router_7_9_req;

    assign router_7_9_to_router_7_10_rsp = router_7_9_rsp_out[0];
    assign router_7_9_to_router_8_9_rsp = router_7_9_rsp_out[1];
    assign router_7_9_to_router_7_8_rsp = router_7_9_rsp_out[2];
    assign router_7_9_to_router_6_9_rsp = router_7_9_rsp_out[3];
    assign router_7_9_to_magia_tile_ni_7_9_rsp = router_7_9_rsp_out[4];

    assign router_7_9_to_router_7_10_req = router_7_9_req_out[0];
    assign router_7_9_to_router_8_9_req = router_7_9_req_out[1];
    assign router_7_9_to_router_7_8_req = router_7_9_req_out[2];
    assign router_7_9_to_router_6_9_req = router_7_9_req_out[3];
    assign router_7_9_to_magia_tile_ni_7_9_req = router_7_9_req_out[4];

    assign router_7_9_rsp_in[0] = router_7_10_to_router_7_9_rsp;
    assign router_7_9_rsp_in[1] = router_8_9_to_router_7_9_rsp;
    assign router_7_9_rsp_in[2] = router_7_8_to_router_7_9_rsp;
    assign router_7_9_rsp_in[3] = router_6_9_to_router_7_9_rsp;
    assign router_7_9_rsp_in[4] = magia_tile_ni_7_9_to_router_7_9_rsp;

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
) router_7_9 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 8, y: 9, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_7_9_req_in),
  .floo_rsp_o (router_7_9_rsp_out),
  .floo_req_o (router_7_9_req_out),
  .floo_rsp_i (router_7_9_rsp_in)
);


floo_req_t [4:0] router_7_10_req_in;
floo_rsp_t [4:0] router_7_10_rsp_out;
floo_req_t [4:0] router_7_10_req_out;
floo_rsp_t [4:0] router_7_10_rsp_in;

    assign router_7_10_req_in[0] = router_7_11_to_router_7_10_req;
    assign router_7_10_req_in[1] = router_8_10_to_router_7_10_req;
    assign router_7_10_req_in[2] = router_7_9_to_router_7_10_req;
    assign router_7_10_req_in[3] = router_6_10_to_router_7_10_req;
    assign router_7_10_req_in[4] = magia_tile_ni_7_10_to_router_7_10_req;

    assign router_7_10_to_router_7_11_rsp = router_7_10_rsp_out[0];
    assign router_7_10_to_router_8_10_rsp = router_7_10_rsp_out[1];
    assign router_7_10_to_router_7_9_rsp = router_7_10_rsp_out[2];
    assign router_7_10_to_router_6_10_rsp = router_7_10_rsp_out[3];
    assign router_7_10_to_magia_tile_ni_7_10_rsp = router_7_10_rsp_out[4];

    assign router_7_10_to_router_7_11_req = router_7_10_req_out[0];
    assign router_7_10_to_router_8_10_req = router_7_10_req_out[1];
    assign router_7_10_to_router_7_9_req = router_7_10_req_out[2];
    assign router_7_10_to_router_6_10_req = router_7_10_req_out[3];
    assign router_7_10_to_magia_tile_ni_7_10_req = router_7_10_req_out[4];

    assign router_7_10_rsp_in[0] = router_7_11_to_router_7_10_rsp;
    assign router_7_10_rsp_in[1] = router_8_10_to_router_7_10_rsp;
    assign router_7_10_rsp_in[2] = router_7_9_to_router_7_10_rsp;
    assign router_7_10_rsp_in[3] = router_6_10_to_router_7_10_rsp;
    assign router_7_10_rsp_in[4] = magia_tile_ni_7_10_to_router_7_10_rsp;

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
) router_7_10 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 8, y: 10, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_7_10_req_in),
  .floo_rsp_o (router_7_10_rsp_out),
  .floo_req_o (router_7_10_req_out),
  .floo_rsp_i (router_7_10_rsp_in)
);


floo_req_t [4:0] router_7_11_req_in;
floo_rsp_t [4:0] router_7_11_rsp_out;
floo_req_t [4:0] router_7_11_req_out;
floo_rsp_t [4:0] router_7_11_rsp_in;

    assign router_7_11_req_in[0] = router_7_12_to_router_7_11_req;
    assign router_7_11_req_in[1] = router_8_11_to_router_7_11_req;
    assign router_7_11_req_in[2] = router_7_10_to_router_7_11_req;
    assign router_7_11_req_in[3] = router_6_11_to_router_7_11_req;
    assign router_7_11_req_in[4] = magia_tile_ni_7_11_to_router_7_11_req;

    assign router_7_11_to_router_7_12_rsp = router_7_11_rsp_out[0];
    assign router_7_11_to_router_8_11_rsp = router_7_11_rsp_out[1];
    assign router_7_11_to_router_7_10_rsp = router_7_11_rsp_out[2];
    assign router_7_11_to_router_6_11_rsp = router_7_11_rsp_out[3];
    assign router_7_11_to_magia_tile_ni_7_11_rsp = router_7_11_rsp_out[4];

    assign router_7_11_to_router_7_12_req = router_7_11_req_out[0];
    assign router_7_11_to_router_8_11_req = router_7_11_req_out[1];
    assign router_7_11_to_router_7_10_req = router_7_11_req_out[2];
    assign router_7_11_to_router_6_11_req = router_7_11_req_out[3];
    assign router_7_11_to_magia_tile_ni_7_11_req = router_7_11_req_out[4];

    assign router_7_11_rsp_in[0] = router_7_12_to_router_7_11_rsp;
    assign router_7_11_rsp_in[1] = router_8_11_to_router_7_11_rsp;
    assign router_7_11_rsp_in[2] = router_7_10_to_router_7_11_rsp;
    assign router_7_11_rsp_in[3] = router_6_11_to_router_7_11_rsp;
    assign router_7_11_rsp_in[4] = magia_tile_ni_7_11_to_router_7_11_rsp;

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
) router_7_11 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 8, y: 11, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_7_11_req_in),
  .floo_rsp_o (router_7_11_rsp_out),
  .floo_req_o (router_7_11_req_out),
  .floo_rsp_i (router_7_11_rsp_in)
);


floo_req_t [4:0] router_7_12_req_in;
floo_rsp_t [4:0] router_7_12_rsp_out;
floo_req_t [4:0] router_7_12_req_out;
floo_rsp_t [4:0] router_7_12_rsp_in;

    assign router_7_12_req_in[0] = router_7_13_to_router_7_12_req;
    assign router_7_12_req_in[1] = router_8_12_to_router_7_12_req;
    assign router_7_12_req_in[2] = router_7_11_to_router_7_12_req;
    assign router_7_12_req_in[3] = router_6_12_to_router_7_12_req;
    assign router_7_12_req_in[4] = magia_tile_ni_7_12_to_router_7_12_req;

    assign router_7_12_to_router_7_13_rsp = router_7_12_rsp_out[0];
    assign router_7_12_to_router_8_12_rsp = router_7_12_rsp_out[1];
    assign router_7_12_to_router_7_11_rsp = router_7_12_rsp_out[2];
    assign router_7_12_to_router_6_12_rsp = router_7_12_rsp_out[3];
    assign router_7_12_to_magia_tile_ni_7_12_rsp = router_7_12_rsp_out[4];

    assign router_7_12_to_router_7_13_req = router_7_12_req_out[0];
    assign router_7_12_to_router_8_12_req = router_7_12_req_out[1];
    assign router_7_12_to_router_7_11_req = router_7_12_req_out[2];
    assign router_7_12_to_router_6_12_req = router_7_12_req_out[3];
    assign router_7_12_to_magia_tile_ni_7_12_req = router_7_12_req_out[4];

    assign router_7_12_rsp_in[0] = router_7_13_to_router_7_12_rsp;
    assign router_7_12_rsp_in[1] = router_8_12_to_router_7_12_rsp;
    assign router_7_12_rsp_in[2] = router_7_11_to_router_7_12_rsp;
    assign router_7_12_rsp_in[3] = router_6_12_to_router_7_12_rsp;
    assign router_7_12_rsp_in[4] = magia_tile_ni_7_12_to_router_7_12_rsp;

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
) router_7_12 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 8, y: 12, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_7_12_req_in),
  .floo_rsp_o (router_7_12_rsp_out),
  .floo_req_o (router_7_12_req_out),
  .floo_rsp_i (router_7_12_rsp_in)
);


floo_req_t [4:0] router_7_13_req_in;
floo_rsp_t [4:0] router_7_13_rsp_out;
floo_req_t [4:0] router_7_13_req_out;
floo_rsp_t [4:0] router_7_13_rsp_in;

    assign router_7_13_req_in[0] = router_7_14_to_router_7_13_req;
    assign router_7_13_req_in[1] = router_8_13_to_router_7_13_req;
    assign router_7_13_req_in[2] = router_7_12_to_router_7_13_req;
    assign router_7_13_req_in[3] = router_6_13_to_router_7_13_req;
    assign router_7_13_req_in[4] = magia_tile_ni_7_13_to_router_7_13_req;

    assign router_7_13_to_router_7_14_rsp = router_7_13_rsp_out[0];
    assign router_7_13_to_router_8_13_rsp = router_7_13_rsp_out[1];
    assign router_7_13_to_router_7_12_rsp = router_7_13_rsp_out[2];
    assign router_7_13_to_router_6_13_rsp = router_7_13_rsp_out[3];
    assign router_7_13_to_magia_tile_ni_7_13_rsp = router_7_13_rsp_out[4];

    assign router_7_13_to_router_7_14_req = router_7_13_req_out[0];
    assign router_7_13_to_router_8_13_req = router_7_13_req_out[1];
    assign router_7_13_to_router_7_12_req = router_7_13_req_out[2];
    assign router_7_13_to_router_6_13_req = router_7_13_req_out[3];
    assign router_7_13_to_magia_tile_ni_7_13_req = router_7_13_req_out[4];

    assign router_7_13_rsp_in[0] = router_7_14_to_router_7_13_rsp;
    assign router_7_13_rsp_in[1] = router_8_13_to_router_7_13_rsp;
    assign router_7_13_rsp_in[2] = router_7_12_to_router_7_13_rsp;
    assign router_7_13_rsp_in[3] = router_6_13_to_router_7_13_rsp;
    assign router_7_13_rsp_in[4] = magia_tile_ni_7_13_to_router_7_13_rsp;

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
) router_7_13 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 8, y: 13, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_7_13_req_in),
  .floo_rsp_o (router_7_13_rsp_out),
  .floo_req_o (router_7_13_req_out),
  .floo_rsp_i (router_7_13_rsp_in)
);


floo_req_t [4:0] router_7_14_req_in;
floo_rsp_t [4:0] router_7_14_rsp_out;
floo_req_t [4:0] router_7_14_req_out;
floo_rsp_t [4:0] router_7_14_rsp_in;

    assign router_7_14_req_in[0] = router_7_15_to_router_7_14_req;
    assign router_7_14_req_in[1] = router_8_14_to_router_7_14_req;
    assign router_7_14_req_in[2] = router_7_13_to_router_7_14_req;
    assign router_7_14_req_in[3] = router_6_14_to_router_7_14_req;
    assign router_7_14_req_in[4] = magia_tile_ni_7_14_to_router_7_14_req;

    assign router_7_14_to_router_7_15_rsp = router_7_14_rsp_out[0];
    assign router_7_14_to_router_8_14_rsp = router_7_14_rsp_out[1];
    assign router_7_14_to_router_7_13_rsp = router_7_14_rsp_out[2];
    assign router_7_14_to_router_6_14_rsp = router_7_14_rsp_out[3];
    assign router_7_14_to_magia_tile_ni_7_14_rsp = router_7_14_rsp_out[4];

    assign router_7_14_to_router_7_15_req = router_7_14_req_out[0];
    assign router_7_14_to_router_8_14_req = router_7_14_req_out[1];
    assign router_7_14_to_router_7_13_req = router_7_14_req_out[2];
    assign router_7_14_to_router_6_14_req = router_7_14_req_out[3];
    assign router_7_14_to_magia_tile_ni_7_14_req = router_7_14_req_out[4];

    assign router_7_14_rsp_in[0] = router_7_15_to_router_7_14_rsp;
    assign router_7_14_rsp_in[1] = router_8_14_to_router_7_14_rsp;
    assign router_7_14_rsp_in[2] = router_7_13_to_router_7_14_rsp;
    assign router_7_14_rsp_in[3] = router_6_14_to_router_7_14_rsp;
    assign router_7_14_rsp_in[4] = magia_tile_ni_7_14_to_router_7_14_rsp;

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
) router_7_14 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 8, y: 14, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_7_14_req_in),
  .floo_rsp_o (router_7_14_rsp_out),
  .floo_req_o (router_7_14_req_out),
  .floo_rsp_i (router_7_14_rsp_in)
);


floo_req_t [4:0] router_7_15_req_in;
floo_rsp_t [4:0] router_7_15_rsp_out;
floo_req_t [4:0] router_7_15_req_out;
floo_rsp_t [4:0] router_7_15_rsp_in;

    assign router_7_15_req_in[0] = '0;
    assign router_7_15_req_in[1] = router_8_15_to_router_7_15_req;
    assign router_7_15_req_in[2] = router_7_14_to_router_7_15_req;
    assign router_7_15_req_in[3] = router_6_15_to_router_7_15_req;
    assign router_7_15_req_in[4] = magia_tile_ni_7_15_to_router_7_15_req;

    assign router_7_15_to_router_8_15_rsp = router_7_15_rsp_out[1];
    assign router_7_15_to_router_7_14_rsp = router_7_15_rsp_out[2];
    assign router_7_15_to_router_6_15_rsp = router_7_15_rsp_out[3];
    assign router_7_15_to_magia_tile_ni_7_15_rsp = router_7_15_rsp_out[4];

    assign router_7_15_to_router_8_15_req = router_7_15_req_out[1];
    assign router_7_15_to_router_7_14_req = router_7_15_req_out[2];
    assign router_7_15_to_router_6_15_req = router_7_15_req_out[3];
    assign router_7_15_to_magia_tile_ni_7_15_req = router_7_15_req_out[4];

    assign router_7_15_rsp_in[0] = '0;
    assign router_7_15_rsp_in[1] = router_8_15_to_router_7_15_rsp;
    assign router_7_15_rsp_in[2] = router_7_14_to_router_7_15_rsp;
    assign router_7_15_rsp_in[3] = router_6_15_to_router_7_15_rsp;
    assign router_7_15_rsp_in[4] = magia_tile_ni_7_15_to_router_7_15_rsp;

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
) router_7_15 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 8, y: 15, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_7_15_req_in),
  .floo_rsp_o (router_7_15_rsp_out),
  .floo_req_o (router_7_15_req_out),
  .floo_rsp_i (router_7_15_rsp_in)
);


floo_req_t [4:0] router_8_0_req_in;
floo_rsp_t [4:0] router_8_0_rsp_out;
floo_req_t [4:0] router_8_0_req_out;
floo_rsp_t [4:0] router_8_0_rsp_in;

    assign router_8_0_req_in[0] = router_8_1_to_router_8_0_req;
    assign router_8_0_req_in[1] = router_9_0_to_router_8_0_req;
    assign router_8_0_req_in[2] = '0;
    assign router_8_0_req_in[3] = router_7_0_to_router_8_0_req;
    assign router_8_0_req_in[4] = magia_tile_ni_8_0_to_router_8_0_req;

    assign router_8_0_to_router_8_1_rsp = router_8_0_rsp_out[0];
    assign router_8_0_to_router_9_0_rsp = router_8_0_rsp_out[1];
    assign router_8_0_to_router_7_0_rsp = router_8_0_rsp_out[3];
    assign router_8_0_to_magia_tile_ni_8_0_rsp = router_8_0_rsp_out[4];

    assign router_8_0_to_router_8_1_req = router_8_0_req_out[0];
    assign router_8_0_to_router_9_0_req = router_8_0_req_out[1];
    assign router_8_0_to_router_7_0_req = router_8_0_req_out[3];
    assign router_8_0_to_magia_tile_ni_8_0_req = router_8_0_req_out[4];

    assign router_8_0_rsp_in[0] = router_8_1_to_router_8_0_rsp;
    assign router_8_0_rsp_in[1] = router_9_0_to_router_8_0_rsp;
    assign router_8_0_rsp_in[2] = '0;
    assign router_8_0_rsp_in[3] = router_7_0_to_router_8_0_rsp;
    assign router_8_0_rsp_in[4] = magia_tile_ni_8_0_to_router_8_0_rsp;

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
) router_8_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 9, y: 0, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_8_0_req_in),
  .floo_rsp_o (router_8_0_rsp_out),
  .floo_req_o (router_8_0_req_out),
  .floo_rsp_i (router_8_0_rsp_in)
);


floo_req_t [4:0] router_8_1_req_in;
floo_rsp_t [4:0] router_8_1_rsp_out;
floo_req_t [4:0] router_8_1_req_out;
floo_rsp_t [4:0] router_8_1_rsp_in;

    assign router_8_1_req_in[0] = router_8_2_to_router_8_1_req;
    assign router_8_1_req_in[1] = router_9_1_to_router_8_1_req;
    assign router_8_1_req_in[2] = router_8_0_to_router_8_1_req;
    assign router_8_1_req_in[3] = router_7_1_to_router_8_1_req;
    assign router_8_1_req_in[4] = magia_tile_ni_8_1_to_router_8_1_req;

    assign router_8_1_to_router_8_2_rsp = router_8_1_rsp_out[0];
    assign router_8_1_to_router_9_1_rsp = router_8_1_rsp_out[1];
    assign router_8_1_to_router_8_0_rsp = router_8_1_rsp_out[2];
    assign router_8_1_to_router_7_1_rsp = router_8_1_rsp_out[3];
    assign router_8_1_to_magia_tile_ni_8_1_rsp = router_8_1_rsp_out[4];

    assign router_8_1_to_router_8_2_req = router_8_1_req_out[0];
    assign router_8_1_to_router_9_1_req = router_8_1_req_out[1];
    assign router_8_1_to_router_8_0_req = router_8_1_req_out[2];
    assign router_8_1_to_router_7_1_req = router_8_1_req_out[3];
    assign router_8_1_to_magia_tile_ni_8_1_req = router_8_1_req_out[4];

    assign router_8_1_rsp_in[0] = router_8_2_to_router_8_1_rsp;
    assign router_8_1_rsp_in[1] = router_9_1_to_router_8_1_rsp;
    assign router_8_1_rsp_in[2] = router_8_0_to_router_8_1_rsp;
    assign router_8_1_rsp_in[3] = router_7_1_to_router_8_1_rsp;
    assign router_8_1_rsp_in[4] = magia_tile_ni_8_1_to_router_8_1_rsp;

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
) router_8_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 9, y: 1, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_8_1_req_in),
  .floo_rsp_o (router_8_1_rsp_out),
  .floo_req_o (router_8_1_req_out),
  .floo_rsp_i (router_8_1_rsp_in)
);


floo_req_t [4:0] router_8_2_req_in;
floo_rsp_t [4:0] router_8_2_rsp_out;
floo_req_t [4:0] router_8_2_req_out;
floo_rsp_t [4:0] router_8_2_rsp_in;

    assign router_8_2_req_in[0] = router_8_3_to_router_8_2_req;
    assign router_8_2_req_in[1] = router_9_2_to_router_8_2_req;
    assign router_8_2_req_in[2] = router_8_1_to_router_8_2_req;
    assign router_8_2_req_in[3] = router_7_2_to_router_8_2_req;
    assign router_8_2_req_in[4] = magia_tile_ni_8_2_to_router_8_2_req;

    assign router_8_2_to_router_8_3_rsp = router_8_2_rsp_out[0];
    assign router_8_2_to_router_9_2_rsp = router_8_2_rsp_out[1];
    assign router_8_2_to_router_8_1_rsp = router_8_2_rsp_out[2];
    assign router_8_2_to_router_7_2_rsp = router_8_2_rsp_out[3];
    assign router_8_2_to_magia_tile_ni_8_2_rsp = router_8_2_rsp_out[4];

    assign router_8_2_to_router_8_3_req = router_8_2_req_out[0];
    assign router_8_2_to_router_9_2_req = router_8_2_req_out[1];
    assign router_8_2_to_router_8_1_req = router_8_2_req_out[2];
    assign router_8_2_to_router_7_2_req = router_8_2_req_out[3];
    assign router_8_2_to_magia_tile_ni_8_2_req = router_8_2_req_out[4];

    assign router_8_2_rsp_in[0] = router_8_3_to_router_8_2_rsp;
    assign router_8_2_rsp_in[1] = router_9_2_to_router_8_2_rsp;
    assign router_8_2_rsp_in[2] = router_8_1_to_router_8_2_rsp;
    assign router_8_2_rsp_in[3] = router_7_2_to_router_8_2_rsp;
    assign router_8_2_rsp_in[4] = magia_tile_ni_8_2_to_router_8_2_rsp;

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
) router_8_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 9, y: 2, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_8_2_req_in),
  .floo_rsp_o (router_8_2_rsp_out),
  .floo_req_o (router_8_2_req_out),
  .floo_rsp_i (router_8_2_rsp_in)
);


floo_req_t [4:0] router_8_3_req_in;
floo_rsp_t [4:0] router_8_3_rsp_out;
floo_req_t [4:0] router_8_3_req_out;
floo_rsp_t [4:0] router_8_3_rsp_in;

    assign router_8_3_req_in[0] = router_8_4_to_router_8_3_req;
    assign router_8_3_req_in[1] = router_9_3_to_router_8_3_req;
    assign router_8_3_req_in[2] = router_8_2_to_router_8_3_req;
    assign router_8_3_req_in[3] = router_7_3_to_router_8_3_req;
    assign router_8_3_req_in[4] = magia_tile_ni_8_3_to_router_8_3_req;

    assign router_8_3_to_router_8_4_rsp = router_8_3_rsp_out[0];
    assign router_8_3_to_router_9_3_rsp = router_8_3_rsp_out[1];
    assign router_8_3_to_router_8_2_rsp = router_8_3_rsp_out[2];
    assign router_8_3_to_router_7_3_rsp = router_8_3_rsp_out[3];
    assign router_8_3_to_magia_tile_ni_8_3_rsp = router_8_3_rsp_out[4];

    assign router_8_3_to_router_8_4_req = router_8_3_req_out[0];
    assign router_8_3_to_router_9_3_req = router_8_3_req_out[1];
    assign router_8_3_to_router_8_2_req = router_8_3_req_out[2];
    assign router_8_3_to_router_7_3_req = router_8_3_req_out[3];
    assign router_8_3_to_magia_tile_ni_8_3_req = router_8_3_req_out[4];

    assign router_8_3_rsp_in[0] = router_8_4_to_router_8_3_rsp;
    assign router_8_3_rsp_in[1] = router_9_3_to_router_8_3_rsp;
    assign router_8_3_rsp_in[2] = router_8_2_to_router_8_3_rsp;
    assign router_8_3_rsp_in[3] = router_7_3_to_router_8_3_rsp;
    assign router_8_3_rsp_in[4] = magia_tile_ni_8_3_to_router_8_3_rsp;

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
) router_8_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 9, y: 3, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_8_3_req_in),
  .floo_rsp_o (router_8_3_rsp_out),
  .floo_req_o (router_8_3_req_out),
  .floo_rsp_i (router_8_3_rsp_in)
);


floo_req_t [4:0] router_8_4_req_in;
floo_rsp_t [4:0] router_8_4_rsp_out;
floo_req_t [4:0] router_8_4_req_out;
floo_rsp_t [4:0] router_8_4_rsp_in;

    assign router_8_4_req_in[0] = router_8_5_to_router_8_4_req;
    assign router_8_4_req_in[1] = router_9_4_to_router_8_4_req;
    assign router_8_4_req_in[2] = router_8_3_to_router_8_4_req;
    assign router_8_4_req_in[3] = router_7_4_to_router_8_4_req;
    assign router_8_4_req_in[4] = magia_tile_ni_8_4_to_router_8_4_req;

    assign router_8_4_to_router_8_5_rsp = router_8_4_rsp_out[0];
    assign router_8_4_to_router_9_4_rsp = router_8_4_rsp_out[1];
    assign router_8_4_to_router_8_3_rsp = router_8_4_rsp_out[2];
    assign router_8_4_to_router_7_4_rsp = router_8_4_rsp_out[3];
    assign router_8_4_to_magia_tile_ni_8_4_rsp = router_8_4_rsp_out[4];

    assign router_8_4_to_router_8_5_req = router_8_4_req_out[0];
    assign router_8_4_to_router_9_4_req = router_8_4_req_out[1];
    assign router_8_4_to_router_8_3_req = router_8_4_req_out[2];
    assign router_8_4_to_router_7_4_req = router_8_4_req_out[3];
    assign router_8_4_to_magia_tile_ni_8_4_req = router_8_4_req_out[4];

    assign router_8_4_rsp_in[0] = router_8_5_to_router_8_4_rsp;
    assign router_8_4_rsp_in[1] = router_9_4_to_router_8_4_rsp;
    assign router_8_4_rsp_in[2] = router_8_3_to_router_8_4_rsp;
    assign router_8_4_rsp_in[3] = router_7_4_to_router_8_4_rsp;
    assign router_8_4_rsp_in[4] = magia_tile_ni_8_4_to_router_8_4_rsp;

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
) router_8_4 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 9, y: 4, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_8_4_req_in),
  .floo_rsp_o (router_8_4_rsp_out),
  .floo_req_o (router_8_4_req_out),
  .floo_rsp_i (router_8_4_rsp_in)
);


floo_req_t [4:0] router_8_5_req_in;
floo_rsp_t [4:0] router_8_5_rsp_out;
floo_req_t [4:0] router_8_5_req_out;
floo_rsp_t [4:0] router_8_5_rsp_in;

    assign router_8_5_req_in[0] = router_8_6_to_router_8_5_req;
    assign router_8_5_req_in[1] = router_9_5_to_router_8_5_req;
    assign router_8_5_req_in[2] = router_8_4_to_router_8_5_req;
    assign router_8_5_req_in[3] = router_7_5_to_router_8_5_req;
    assign router_8_5_req_in[4] = magia_tile_ni_8_5_to_router_8_5_req;

    assign router_8_5_to_router_8_6_rsp = router_8_5_rsp_out[0];
    assign router_8_5_to_router_9_5_rsp = router_8_5_rsp_out[1];
    assign router_8_5_to_router_8_4_rsp = router_8_5_rsp_out[2];
    assign router_8_5_to_router_7_5_rsp = router_8_5_rsp_out[3];
    assign router_8_5_to_magia_tile_ni_8_5_rsp = router_8_5_rsp_out[4];

    assign router_8_5_to_router_8_6_req = router_8_5_req_out[0];
    assign router_8_5_to_router_9_5_req = router_8_5_req_out[1];
    assign router_8_5_to_router_8_4_req = router_8_5_req_out[2];
    assign router_8_5_to_router_7_5_req = router_8_5_req_out[3];
    assign router_8_5_to_magia_tile_ni_8_5_req = router_8_5_req_out[4];

    assign router_8_5_rsp_in[0] = router_8_6_to_router_8_5_rsp;
    assign router_8_5_rsp_in[1] = router_9_5_to_router_8_5_rsp;
    assign router_8_5_rsp_in[2] = router_8_4_to_router_8_5_rsp;
    assign router_8_5_rsp_in[3] = router_7_5_to_router_8_5_rsp;
    assign router_8_5_rsp_in[4] = magia_tile_ni_8_5_to_router_8_5_rsp;

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
) router_8_5 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 9, y: 5, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_8_5_req_in),
  .floo_rsp_o (router_8_5_rsp_out),
  .floo_req_o (router_8_5_req_out),
  .floo_rsp_i (router_8_5_rsp_in)
);


floo_req_t [4:0] router_8_6_req_in;
floo_rsp_t [4:0] router_8_6_rsp_out;
floo_req_t [4:0] router_8_6_req_out;
floo_rsp_t [4:0] router_8_6_rsp_in;

    assign router_8_6_req_in[0] = router_8_7_to_router_8_6_req;
    assign router_8_6_req_in[1] = router_9_6_to_router_8_6_req;
    assign router_8_6_req_in[2] = router_8_5_to_router_8_6_req;
    assign router_8_6_req_in[3] = router_7_6_to_router_8_6_req;
    assign router_8_6_req_in[4] = magia_tile_ni_8_6_to_router_8_6_req;

    assign router_8_6_to_router_8_7_rsp = router_8_6_rsp_out[0];
    assign router_8_6_to_router_9_6_rsp = router_8_6_rsp_out[1];
    assign router_8_6_to_router_8_5_rsp = router_8_6_rsp_out[2];
    assign router_8_6_to_router_7_6_rsp = router_8_6_rsp_out[3];
    assign router_8_6_to_magia_tile_ni_8_6_rsp = router_8_6_rsp_out[4];

    assign router_8_6_to_router_8_7_req = router_8_6_req_out[0];
    assign router_8_6_to_router_9_6_req = router_8_6_req_out[1];
    assign router_8_6_to_router_8_5_req = router_8_6_req_out[2];
    assign router_8_6_to_router_7_6_req = router_8_6_req_out[3];
    assign router_8_6_to_magia_tile_ni_8_6_req = router_8_6_req_out[4];

    assign router_8_6_rsp_in[0] = router_8_7_to_router_8_6_rsp;
    assign router_8_6_rsp_in[1] = router_9_6_to_router_8_6_rsp;
    assign router_8_6_rsp_in[2] = router_8_5_to_router_8_6_rsp;
    assign router_8_6_rsp_in[3] = router_7_6_to_router_8_6_rsp;
    assign router_8_6_rsp_in[4] = magia_tile_ni_8_6_to_router_8_6_rsp;

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
) router_8_6 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 9, y: 6, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_8_6_req_in),
  .floo_rsp_o (router_8_6_rsp_out),
  .floo_req_o (router_8_6_req_out),
  .floo_rsp_i (router_8_6_rsp_in)
);


floo_req_t [4:0] router_8_7_req_in;
floo_rsp_t [4:0] router_8_7_rsp_out;
floo_req_t [4:0] router_8_7_req_out;
floo_rsp_t [4:0] router_8_7_rsp_in;

    assign router_8_7_req_in[0] = router_8_8_to_router_8_7_req;
    assign router_8_7_req_in[1] = router_9_7_to_router_8_7_req;
    assign router_8_7_req_in[2] = router_8_6_to_router_8_7_req;
    assign router_8_7_req_in[3] = router_7_7_to_router_8_7_req;
    assign router_8_7_req_in[4] = magia_tile_ni_8_7_to_router_8_7_req;

    assign router_8_7_to_router_8_8_rsp = router_8_7_rsp_out[0];
    assign router_8_7_to_router_9_7_rsp = router_8_7_rsp_out[1];
    assign router_8_7_to_router_8_6_rsp = router_8_7_rsp_out[2];
    assign router_8_7_to_router_7_7_rsp = router_8_7_rsp_out[3];
    assign router_8_7_to_magia_tile_ni_8_7_rsp = router_8_7_rsp_out[4];

    assign router_8_7_to_router_8_8_req = router_8_7_req_out[0];
    assign router_8_7_to_router_9_7_req = router_8_7_req_out[1];
    assign router_8_7_to_router_8_6_req = router_8_7_req_out[2];
    assign router_8_7_to_router_7_7_req = router_8_7_req_out[3];
    assign router_8_7_to_magia_tile_ni_8_7_req = router_8_7_req_out[4];

    assign router_8_7_rsp_in[0] = router_8_8_to_router_8_7_rsp;
    assign router_8_7_rsp_in[1] = router_9_7_to_router_8_7_rsp;
    assign router_8_7_rsp_in[2] = router_8_6_to_router_8_7_rsp;
    assign router_8_7_rsp_in[3] = router_7_7_to_router_8_7_rsp;
    assign router_8_7_rsp_in[4] = magia_tile_ni_8_7_to_router_8_7_rsp;

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
) router_8_7 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 9, y: 7, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_8_7_req_in),
  .floo_rsp_o (router_8_7_rsp_out),
  .floo_req_o (router_8_7_req_out),
  .floo_rsp_i (router_8_7_rsp_in)
);


floo_req_t [4:0] router_8_8_req_in;
floo_rsp_t [4:0] router_8_8_rsp_out;
floo_req_t [4:0] router_8_8_req_out;
floo_rsp_t [4:0] router_8_8_rsp_in;

    assign router_8_8_req_in[0] = router_8_9_to_router_8_8_req;
    assign router_8_8_req_in[1] = router_9_8_to_router_8_8_req;
    assign router_8_8_req_in[2] = router_8_7_to_router_8_8_req;
    assign router_8_8_req_in[3] = router_7_8_to_router_8_8_req;
    assign router_8_8_req_in[4] = magia_tile_ni_8_8_to_router_8_8_req;

    assign router_8_8_to_router_8_9_rsp = router_8_8_rsp_out[0];
    assign router_8_8_to_router_9_8_rsp = router_8_8_rsp_out[1];
    assign router_8_8_to_router_8_7_rsp = router_8_8_rsp_out[2];
    assign router_8_8_to_router_7_8_rsp = router_8_8_rsp_out[3];
    assign router_8_8_to_magia_tile_ni_8_8_rsp = router_8_8_rsp_out[4];

    assign router_8_8_to_router_8_9_req = router_8_8_req_out[0];
    assign router_8_8_to_router_9_8_req = router_8_8_req_out[1];
    assign router_8_8_to_router_8_7_req = router_8_8_req_out[2];
    assign router_8_8_to_router_7_8_req = router_8_8_req_out[3];
    assign router_8_8_to_magia_tile_ni_8_8_req = router_8_8_req_out[4];

    assign router_8_8_rsp_in[0] = router_8_9_to_router_8_8_rsp;
    assign router_8_8_rsp_in[1] = router_9_8_to_router_8_8_rsp;
    assign router_8_8_rsp_in[2] = router_8_7_to_router_8_8_rsp;
    assign router_8_8_rsp_in[3] = router_7_8_to_router_8_8_rsp;
    assign router_8_8_rsp_in[4] = magia_tile_ni_8_8_to_router_8_8_rsp;

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
) router_8_8 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 9, y: 8, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_8_8_req_in),
  .floo_rsp_o (router_8_8_rsp_out),
  .floo_req_o (router_8_8_req_out),
  .floo_rsp_i (router_8_8_rsp_in)
);


floo_req_t [4:0] router_8_9_req_in;
floo_rsp_t [4:0] router_8_9_rsp_out;
floo_req_t [4:0] router_8_9_req_out;
floo_rsp_t [4:0] router_8_9_rsp_in;

    assign router_8_9_req_in[0] = router_8_10_to_router_8_9_req;
    assign router_8_9_req_in[1] = router_9_9_to_router_8_9_req;
    assign router_8_9_req_in[2] = router_8_8_to_router_8_9_req;
    assign router_8_9_req_in[3] = router_7_9_to_router_8_9_req;
    assign router_8_9_req_in[4] = magia_tile_ni_8_9_to_router_8_9_req;

    assign router_8_9_to_router_8_10_rsp = router_8_9_rsp_out[0];
    assign router_8_9_to_router_9_9_rsp = router_8_9_rsp_out[1];
    assign router_8_9_to_router_8_8_rsp = router_8_9_rsp_out[2];
    assign router_8_9_to_router_7_9_rsp = router_8_9_rsp_out[3];
    assign router_8_9_to_magia_tile_ni_8_9_rsp = router_8_9_rsp_out[4];

    assign router_8_9_to_router_8_10_req = router_8_9_req_out[0];
    assign router_8_9_to_router_9_9_req = router_8_9_req_out[1];
    assign router_8_9_to_router_8_8_req = router_8_9_req_out[2];
    assign router_8_9_to_router_7_9_req = router_8_9_req_out[3];
    assign router_8_9_to_magia_tile_ni_8_9_req = router_8_9_req_out[4];

    assign router_8_9_rsp_in[0] = router_8_10_to_router_8_9_rsp;
    assign router_8_9_rsp_in[1] = router_9_9_to_router_8_9_rsp;
    assign router_8_9_rsp_in[2] = router_8_8_to_router_8_9_rsp;
    assign router_8_9_rsp_in[3] = router_7_9_to_router_8_9_rsp;
    assign router_8_9_rsp_in[4] = magia_tile_ni_8_9_to_router_8_9_rsp;

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
) router_8_9 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 9, y: 9, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_8_9_req_in),
  .floo_rsp_o (router_8_9_rsp_out),
  .floo_req_o (router_8_9_req_out),
  .floo_rsp_i (router_8_9_rsp_in)
);


floo_req_t [4:0] router_8_10_req_in;
floo_rsp_t [4:0] router_8_10_rsp_out;
floo_req_t [4:0] router_8_10_req_out;
floo_rsp_t [4:0] router_8_10_rsp_in;

    assign router_8_10_req_in[0] = router_8_11_to_router_8_10_req;
    assign router_8_10_req_in[1] = router_9_10_to_router_8_10_req;
    assign router_8_10_req_in[2] = router_8_9_to_router_8_10_req;
    assign router_8_10_req_in[3] = router_7_10_to_router_8_10_req;
    assign router_8_10_req_in[4] = magia_tile_ni_8_10_to_router_8_10_req;

    assign router_8_10_to_router_8_11_rsp = router_8_10_rsp_out[0];
    assign router_8_10_to_router_9_10_rsp = router_8_10_rsp_out[1];
    assign router_8_10_to_router_8_9_rsp = router_8_10_rsp_out[2];
    assign router_8_10_to_router_7_10_rsp = router_8_10_rsp_out[3];
    assign router_8_10_to_magia_tile_ni_8_10_rsp = router_8_10_rsp_out[4];

    assign router_8_10_to_router_8_11_req = router_8_10_req_out[0];
    assign router_8_10_to_router_9_10_req = router_8_10_req_out[1];
    assign router_8_10_to_router_8_9_req = router_8_10_req_out[2];
    assign router_8_10_to_router_7_10_req = router_8_10_req_out[3];
    assign router_8_10_to_magia_tile_ni_8_10_req = router_8_10_req_out[4];

    assign router_8_10_rsp_in[0] = router_8_11_to_router_8_10_rsp;
    assign router_8_10_rsp_in[1] = router_9_10_to_router_8_10_rsp;
    assign router_8_10_rsp_in[2] = router_8_9_to_router_8_10_rsp;
    assign router_8_10_rsp_in[3] = router_7_10_to_router_8_10_rsp;
    assign router_8_10_rsp_in[4] = magia_tile_ni_8_10_to_router_8_10_rsp;

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
) router_8_10 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 9, y: 10, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_8_10_req_in),
  .floo_rsp_o (router_8_10_rsp_out),
  .floo_req_o (router_8_10_req_out),
  .floo_rsp_i (router_8_10_rsp_in)
);


floo_req_t [4:0] router_8_11_req_in;
floo_rsp_t [4:0] router_8_11_rsp_out;
floo_req_t [4:0] router_8_11_req_out;
floo_rsp_t [4:0] router_8_11_rsp_in;

    assign router_8_11_req_in[0] = router_8_12_to_router_8_11_req;
    assign router_8_11_req_in[1] = router_9_11_to_router_8_11_req;
    assign router_8_11_req_in[2] = router_8_10_to_router_8_11_req;
    assign router_8_11_req_in[3] = router_7_11_to_router_8_11_req;
    assign router_8_11_req_in[4] = magia_tile_ni_8_11_to_router_8_11_req;

    assign router_8_11_to_router_8_12_rsp = router_8_11_rsp_out[0];
    assign router_8_11_to_router_9_11_rsp = router_8_11_rsp_out[1];
    assign router_8_11_to_router_8_10_rsp = router_8_11_rsp_out[2];
    assign router_8_11_to_router_7_11_rsp = router_8_11_rsp_out[3];
    assign router_8_11_to_magia_tile_ni_8_11_rsp = router_8_11_rsp_out[4];

    assign router_8_11_to_router_8_12_req = router_8_11_req_out[0];
    assign router_8_11_to_router_9_11_req = router_8_11_req_out[1];
    assign router_8_11_to_router_8_10_req = router_8_11_req_out[2];
    assign router_8_11_to_router_7_11_req = router_8_11_req_out[3];
    assign router_8_11_to_magia_tile_ni_8_11_req = router_8_11_req_out[4];

    assign router_8_11_rsp_in[0] = router_8_12_to_router_8_11_rsp;
    assign router_8_11_rsp_in[1] = router_9_11_to_router_8_11_rsp;
    assign router_8_11_rsp_in[2] = router_8_10_to_router_8_11_rsp;
    assign router_8_11_rsp_in[3] = router_7_11_to_router_8_11_rsp;
    assign router_8_11_rsp_in[4] = magia_tile_ni_8_11_to_router_8_11_rsp;

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
) router_8_11 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 9, y: 11, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_8_11_req_in),
  .floo_rsp_o (router_8_11_rsp_out),
  .floo_req_o (router_8_11_req_out),
  .floo_rsp_i (router_8_11_rsp_in)
);


floo_req_t [4:0] router_8_12_req_in;
floo_rsp_t [4:0] router_8_12_rsp_out;
floo_req_t [4:0] router_8_12_req_out;
floo_rsp_t [4:0] router_8_12_rsp_in;

    assign router_8_12_req_in[0] = router_8_13_to_router_8_12_req;
    assign router_8_12_req_in[1] = router_9_12_to_router_8_12_req;
    assign router_8_12_req_in[2] = router_8_11_to_router_8_12_req;
    assign router_8_12_req_in[3] = router_7_12_to_router_8_12_req;
    assign router_8_12_req_in[4] = magia_tile_ni_8_12_to_router_8_12_req;

    assign router_8_12_to_router_8_13_rsp = router_8_12_rsp_out[0];
    assign router_8_12_to_router_9_12_rsp = router_8_12_rsp_out[1];
    assign router_8_12_to_router_8_11_rsp = router_8_12_rsp_out[2];
    assign router_8_12_to_router_7_12_rsp = router_8_12_rsp_out[3];
    assign router_8_12_to_magia_tile_ni_8_12_rsp = router_8_12_rsp_out[4];

    assign router_8_12_to_router_8_13_req = router_8_12_req_out[0];
    assign router_8_12_to_router_9_12_req = router_8_12_req_out[1];
    assign router_8_12_to_router_8_11_req = router_8_12_req_out[2];
    assign router_8_12_to_router_7_12_req = router_8_12_req_out[3];
    assign router_8_12_to_magia_tile_ni_8_12_req = router_8_12_req_out[4];

    assign router_8_12_rsp_in[0] = router_8_13_to_router_8_12_rsp;
    assign router_8_12_rsp_in[1] = router_9_12_to_router_8_12_rsp;
    assign router_8_12_rsp_in[2] = router_8_11_to_router_8_12_rsp;
    assign router_8_12_rsp_in[3] = router_7_12_to_router_8_12_rsp;
    assign router_8_12_rsp_in[4] = magia_tile_ni_8_12_to_router_8_12_rsp;

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
) router_8_12 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 9, y: 12, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_8_12_req_in),
  .floo_rsp_o (router_8_12_rsp_out),
  .floo_req_o (router_8_12_req_out),
  .floo_rsp_i (router_8_12_rsp_in)
);


floo_req_t [4:0] router_8_13_req_in;
floo_rsp_t [4:0] router_8_13_rsp_out;
floo_req_t [4:0] router_8_13_req_out;
floo_rsp_t [4:0] router_8_13_rsp_in;

    assign router_8_13_req_in[0] = router_8_14_to_router_8_13_req;
    assign router_8_13_req_in[1] = router_9_13_to_router_8_13_req;
    assign router_8_13_req_in[2] = router_8_12_to_router_8_13_req;
    assign router_8_13_req_in[3] = router_7_13_to_router_8_13_req;
    assign router_8_13_req_in[4] = magia_tile_ni_8_13_to_router_8_13_req;

    assign router_8_13_to_router_8_14_rsp = router_8_13_rsp_out[0];
    assign router_8_13_to_router_9_13_rsp = router_8_13_rsp_out[1];
    assign router_8_13_to_router_8_12_rsp = router_8_13_rsp_out[2];
    assign router_8_13_to_router_7_13_rsp = router_8_13_rsp_out[3];
    assign router_8_13_to_magia_tile_ni_8_13_rsp = router_8_13_rsp_out[4];

    assign router_8_13_to_router_8_14_req = router_8_13_req_out[0];
    assign router_8_13_to_router_9_13_req = router_8_13_req_out[1];
    assign router_8_13_to_router_8_12_req = router_8_13_req_out[2];
    assign router_8_13_to_router_7_13_req = router_8_13_req_out[3];
    assign router_8_13_to_magia_tile_ni_8_13_req = router_8_13_req_out[4];

    assign router_8_13_rsp_in[0] = router_8_14_to_router_8_13_rsp;
    assign router_8_13_rsp_in[1] = router_9_13_to_router_8_13_rsp;
    assign router_8_13_rsp_in[2] = router_8_12_to_router_8_13_rsp;
    assign router_8_13_rsp_in[3] = router_7_13_to_router_8_13_rsp;
    assign router_8_13_rsp_in[4] = magia_tile_ni_8_13_to_router_8_13_rsp;

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
) router_8_13 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 9, y: 13, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_8_13_req_in),
  .floo_rsp_o (router_8_13_rsp_out),
  .floo_req_o (router_8_13_req_out),
  .floo_rsp_i (router_8_13_rsp_in)
);


floo_req_t [4:0] router_8_14_req_in;
floo_rsp_t [4:0] router_8_14_rsp_out;
floo_req_t [4:0] router_8_14_req_out;
floo_rsp_t [4:0] router_8_14_rsp_in;

    assign router_8_14_req_in[0] = router_8_15_to_router_8_14_req;
    assign router_8_14_req_in[1] = router_9_14_to_router_8_14_req;
    assign router_8_14_req_in[2] = router_8_13_to_router_8_14_req;
    assign router_8_14_req_in[3] = router_7_14_to_router_8_14_req;
    assign router_8_14_req_in[4] = magia_tile_ni_8_14_to_router_8_14_req;

    assign router_8_14_to_router_8_15_rsp = router_8_14_rsp_out[0];
    assign router_8_14_to_router_9_14_rsp = router_8_14_rsp_out[1];
    assign router_8_14_to_router_8_13_rsp = router_8_14_rsp_out[2];
    assign router_8_14_to_router_7_14_rsp = router_8_14_rsp_out[3];
    assign router_8_14_to_magia_tile_ni_8_14_rsp = router_8_14_rsp_out[4];

    assign router_8_14_to_router_8_15_req = router_8_14_req_out[0];
    assign router_8_14_to_router_9_14_req = router_8_14_req_out[1];
    assign router_8_14_to_router_8_13_req = router_8_14_req_out[2];
    assign router_8_14_to_router_7_14_req = router_8_14_req_out[3];
    assign router_8_14_to_magia_tile_ni_8_14_req = router_8_14_req_out[4];

    assign router_8_14_rsp_in[0] = router_8_15_to_router_8_14_rsp;
    assign router_8_14_rsp_in[1] = router_9_14_to_router_8_14_rsp;
    assign router_8_14_rsp_in[2] = router_8_13_to_router_8_14_rsp;
    assign router_8_14_rsp_in[3] = router_7_14_to_router_8_14_rsp;
    assign router_8_14_rsp_in[4] = magia_tile_ni_8_14_to_router_8_14_rsp;

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
) router_8_14 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 9, y: 14, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_8_14_req_in),
  .floo_rsp_o (router_8_14_rsp_out),
  .floo_req_o (router_8_14_req_out),
  .floo_rsp_i (router_8_14_rsp_in)
);


floo_req_t [4:0] router_8_15_req_in;
floo_rsp_t [4:0] router_8_15_rsp_out;
floo_req_t [4:0] router_8_15_req_out;
floo_rsp_t [4:0] router_8_15_rsp_in;

    assign router_8_15_req_in[0] = '0;
    assign router_8_15_req_in[1] = router_9_15_to_router_8_15_req;
    assign router_8_15_req_in[2] = router_8_14_to_router_8_15_req;
    assign router_8_15_req_in[3] = router_7_15_to_router_8_15_req;
    assign router_8_15_req_in[4] = magia_tile_ni_8_15_to_router_8_15_req;

    assign router_8_15_to_router_9_15_rsp = router_8_15_rsp_out[1];
    assign router_8_15_to_router_8_14_rsp = router_8_15_rsp_out[2];
    assign router_8_15_to_router_7_15_rsp = router_8_15_rsp_out[3];
    assign router_8_15_to_magia_tile_ni_8_15_rsp = router_8_15_rsp_out[4];

    assign router_8_15_to_router_9_15_req = router_8_15_req_out[1];
    assign router_8_15_to_router_8_14_req = router_8_15_req_out[2];
    assign router_8_15_to_router_7_15_req = router_8_15_req_out[3];
    assign router_8_15_to_magia_tile_ni_8_15_req = router_8_15_req_out[4];

    assign router_8_15_rsp_in[0] = '0;
    assign router_8_15_rsp_in[1] = router_9_15_to_router_8_15_rsp;
    assign router_8_15_rsp_in[2] = router_8_14_to_router_8_15_rsp;
    assign router_8_15_rsp_in[3] = router_7_15_to_router_8_15_rsp;
    assign router_8_15_rsp_in[4] = magia_tile_ni_8_15_to_router_8_15_rsp;

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
) router_8_15 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 9, y: 15, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_8_15_req_in),
  .floo_rsp_o (router_8_15_rsp_out),
  .floo_req_o (router_8_15_req_out),
  .floo_rsp_i (router_8_15_rsp_in)
);


floo_req_t [4:0] router_9_0_req_in;
floo_rsp_t [4:0] router_9_0_rsp_out;
floo_req_t [4:0] router_9_0_req_out;
floo_rsp_t [4:0] router_9_0_rsp_in;

    assign router_9_0_req_in[0] = router_9_1_to_router_9_0_req;
    assign router_9_0_req_in[1] = router_10_0_to_router_9_0_req;
    assign router_9_0_req_in[2] = '0;
    assign router_9_0_req_in[3] = router_8_0_to_router_9_0_req;
    assign router_9_0_req_in[4] = magia_tile_ni_9_0_to_router_9_0_req;

    assign router_9_0_to_router_9_1_rsp = router_9_0_rsp_out[0];
    assign router_9_0_to_router_10_0_rsp = router_9_0_rsp_out[1];
    assign router_9_0_to_router_8_0_rsp = router_9_0_rsp_out[3];
    assign router_9_0_to_magia_tile_ni_9_0_rsp = router_9_0_rsp_out[4];

    assign router_9_0_to_router_9_1_req = router_9_0_req_out[0];
    assign router_9_0_to_router_10_0_req = router_9_0_req_out[1];
    assign router_9_0_to_router_8_0_req = router_9_0_req_out[3];
    assign router_9_0_to_magia_tile_ni_9_0_req = router_9_0_req_out[4];

    assign router_9_0_rsp_in[0] = router_9_1_to_router_9_0_rsp;
    assign router_9_0_rsp_in[1] = router_10_0_to_router_9_0_rsp;
    assign router_9_0_rsp_in[2] = '0;
    assign router_9_0_rsp_in[3] = router_8_0_to_router_9_0_rsp;
    assign router_9_0_rsp_in[4] = magia_tile_ni_9_0_to_router_9_0_rsp;

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
) router_9_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 10, y: 0, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_9_0_req_in),
  .floo_rsp_o (router_9_0_rsp_out),
  .floo_req_o (router_9_0_req_out),
  .floo_rsp_i (router_9_0_rsp_in)
);


floo_req_t [4:0] router_9_1_req_in;
floo_rsp_t [4:0] router_9_1_rsp_out;
floo_req_t [4:0] router_9_1_req_out;
floo_rsp_t [4:0] router_9_1_rsp_in;

    assign router_9_1_req_in[0] = router_9_2_to_router_9_1_req;
    assign router_9_1_req_in[1] = router_10_1_to_router_9_1_req;
    assign router_9_1_req_in[2] = router_9_0_to_router_9_1_req;
    assign router_9_1_req_in[3] = router_8_1_to_router_9_1_req;
    assign router_9_1_req_in[4] = magia_tile_ni_9_1_to_router_9_1_req;

    assign router_9_1_to_router_9_2_rsp = router_9_1_rsp_out[0];
    assign router_9_1_to_router_10_1_rsp = router_9_1_rsp_out[1];
    assign router_9_1_to_router_9_0_rsp = router_9_1_rsp_out[2];
    assign router_9_1_to_router_8_1_rsp = router_9_1_rsp_out[3];
    assign router_9_1_to_magia_tile_ni_9_1_rsp = router_9_1_rsp_out[4];

    assign router_9_1_to_router_9_2_req = router_9_1_req_out[0];
    assign router_9_1_to_router_10_1_req = router_9_1_req_out[1];
    assign router_9_1_to_router_9_0_req = router_9_1_req_out[2];
    assign router_9_1_to_router_8_1_req = router_9_1_req_out[3];
    assign router_9_1_to_magia_tile_ni_9_1_req = router_9_1_req_out[4];

    assign router_9_1_rsp_in[0] = router_9_2_to_router_9_1_rsp;
    assign router_9_1_rsp_in[1] = router_10_1_to_router_9_1_rsp;
    assign router_9_1_rsp_in[2] = router_9_0_to_router_9_1_rsp;
    assign router_9_1_rsp_in[3] = router_8_1_to_router_9_1_rsp;
    assign router_9_1_rsp_in[4] = magia_tile_ni_9_1_to_router_9_1_rsp;

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
) router_9_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 10, y: 1, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_9_1_req_in),
  .floo_rsp_o (router_9_1_rsp_out),
  .floo_req_o (router_9_1_req_out),
  .floo_rsp_i (router_9_1_rsp_in)
);


floo_req_t [4:0] router_9_2_req_in;
floo_rsp_t [4:0] router_9_2_rsp_out;
floo_req_t [4:0] router_9_2_req_out;
floo_rsp_t [4:0] router_9_2_rsp_in;

    assign router_9_2_req_in[0] = router_9_3_to_router_9_2_req;
    assign router_9_2_req_in[1] = router_10_2_to_router_9_2_req;
    assign router_9_2_req_in[2] = router_9_1_to_router_9_2_req;
    assign router_9_2_req_in[3] = router_8_2_to_router_9_2_req;
    assign router_9_2_req_in[4] = magia_tile_ni_9_2_to_router_9_2_req;

    assign router_9_2_to_router_9_3_rsp = router_9_2_rsp_out[0];
    assign router_9_2_to_router_10_2_rsp = router_9_2_rsp_out[1];
    assign router_9_2_to_router_9_1_rsp = router_9_2_rsp_out[2];
    assign router_9_2_to_router_8_2_rsp = router_9_2_rsp_out[3];
    assign router_9_2_to_magia_tile_ni_9_2_rsp = router_9_2_rsp_out[4];

    assign router_9_2_to_router_9_3_req = router_9_2_req_out[0];
    assign router_9_2_to_router_10_2_req = router_9_2_req_out[1];
    assign router_9_2_to_router_9_1_req = router_9_2_req_out[2];
    assign router_9_2_to_router_8_2_req = router_9_2_req_out[3];
    assign router_9_2_to_magia_tile_ni_9_2_req = router_9_2_req_out[4];

    assign router_9_2_rsp_in[0] = router_9_3_to_router_9_2_rsp;
    assign router_9_2_rsp_in[1] = router_10_2_to_router_9_2_rsp;
    assign router_9_2_rsp_in[2] = router_9_1_to_router_9_2_rsp;
    assign router_9_2_rsp_in[3] = router_8_2_to_router_9_2_rsp;
    assign router_9_2_rsp_in[4] = magia_tile_ni_9_2_to_router_9_2_rsp;

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
) router_9_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 10, y: 2, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_9_2_req_in),
  .floo_rsp_o (router_9_2_rsp_out),
  .floo_req_o (router_9_2_req_out),
  .floo_rsp_i (router_9_2_rsp_in)
);


floo_req_t [4:0] router_9_3_req_in;
floo_rsp_t [4:0] router_9_3_rsp_out;
floo_req_t [4:0] router_9_3_req_out;
floo_rsp_t [4:0] router_9_3_rsp_in;

    assign router_9_3_req_in[0] = router_9_4_to_router_9_3_req;
    assign router_9_3_req_in[1] = router_10_3_to_router_9_3_req;
    assign router_9_3_req_in[2] = router_9_2_to_router_9_3_req;
    assign router_9_3_req_in[3] = router_8_3_to_router_9_3_req;
    assign router_9_3_req_in[4] = magia_tile_ni_9_3_to_router_9_3_req;

    assign router_9_3_to_router_9_4_rsp = router_9_3_rsp_out[0];
    assign router_9_3_to_router_10_3_rsp = router_9_3_rsp_out[1];
    assign router_9_3_to_router_9_2_rsp = router_9_3_rsp_out[2];
    assign router_9_3_to_router_8_3_rsp = router_9_3_rsp_out[3];
    assign router_9_3_to_magia_tile_ni_9_3_rsp = router_9_3_rsp_out[4];

    assign router_9_3_to_router_9_4_req = router_9_3_req_out[0];
    assign router_9_3_to_router_10_3_req = router_9_3_req_out[1];
    assign router_9_3_to_router_9_2_req = router_9_3_req_out[2];
    assign router_9_3_to_router_8_3_req = router_9_3_req_out[3];
    assign router_9_3_to_magia_tile_ni_9_3_req = router_9_3_req_out[4];

    assign router_9_3_rsp_in[0] = router_9_4_to_router_9_3_rsp;
    assign router_9_3_rsp_in[1] = router_10_3_to_router_9_3_rsp;
    assign router_9_3_rsp_in[2] = router_9_2_to_router_9_3_rsp;
    assign router_9_3_rsp_in[3] = router_8_3_to_router_9_3_rsp;
    assign router_9_3_rsp_in[4] = magia_tile_ni_9_3_to_router_9_3_rsp;

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
) router_9_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 10, y: 3, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_9_3_req_in),
  .floo_rsp_o (router_9_3_rsp_out),
  .floo_req_o (router_9_3_req_out),
  .floo_rsp_i (router_9_3_rsp_in)
);


floo_req_t [4:0] router_9_4_req_in;
floo_rsp_t [4:0] router_9_4_rsp_out;
floo_req_t [4:0] router_9_4_req_out;
floo_rsp_t [4:0] router_9_4_rsp_in;

    assign router_9_4_req_in[0] = router_9_5_to_router_9_4_req;
    assign router_9_4_req_in[1] = router_10_4_to_router_9_4_req;
    assign router_9_4_req_in[2] = router_9_3_to_router_9_4_req;
    assign router_9_4_req_in[3] = router_8_4_to_router_9_4_req;
    assign router_9_4_req_in[4] = magia_tile_ni_9_4_to_router_9_4_req;

    assign router_9_4_to_router_9_5_rsp = router_9_4_rsp_out[0];
    assign router_9_4_to_router_10_4_rsp = router_9_4_rsp_out[1];
    assign router_9_4_to_router_9_3_rsp = router_9_4_rsp_out[2];
    assign router_9_4_to_router_8_4_rsp = router_9_4_rsp_out[3];
    assign router_9_4_to_magia_tile_ni_9_4_rsp = router_9_4_rsp_out[4];

    assign router_9_4_to_router_9_5_req = router_9_4_req_out[0];
    assign router_9_4_to_router_10_4_req = router_9_4_req_out[1];
    assign router_9_4_to_router_9_3_req = router_9_4_req_out[2];
    assign router_9_4_to_router_8_4_req = router_9_4_req_out[3];
    assign router_9_4_to_magia_tile_ni_9_4_req = router_9_4_req_out[4];

    assign router_9_4_rsp_in[0] = router_9_5_to_router_9_4_rsp;
    assign router_9_4_rsp_in[1] = router_10_4_to_router_9_4_rsp;
    assign router_9_4_rsp_in[2] = router_9_3_to_router_9_4_rsp;
    assign router_9_4_rsp_in[3] = router_8_4_to_router_9_4_rsp;
    assign router_9_4_rsp_in[4] = magia_tile_ni_9_4_to_router_9_4_rsp;

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
) router_9_4 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 10, y: 4, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_9_4_req_in),
  .floo_rsp_o (router_9_4_rsp_out),
  .floo_req_o (router_9_4_req_out),
  .floo_rsp_i (router_9_4_rsp_in)
);


floo_req_t [4:0] router_9_5_req_in;
floo_rsp_t [4:0] router_9_5_rsp_out;
floo_req_t [4:0] router_9_5_req_out;
floo_rsp_t [4:0] router_9_5_rsp_in;

    assign router_9_5_req_in[0] = router_9_6_to_router_9_5_req;
    assign router_9_5_req_in[1] = router_10_5_to_router_9_5_req;
    assign router_9_5_req_in[2] = router_9_4_to_router_9_5_req;
    assign router_9_5_req_in[3] = router_8_5_to_router_9_5_req;
    assign router_9_5_req_in[4] = magia_tile_ni_9_5_to_router_9_5_req;

    assign router_9_5_to_router_9_6_rsp = router_9_5_rsp_out[0];
    assign router_9_5_to_router_10_5_rsp = router_9_5_rsp_out[1];
    assign router_9_5_to_router_9_4_rsp = router_9_5_rsp_out[2];
    assign router_9_5_to_router_8_5_rsp = router_9_5_rsp_out[3];
    assign router_9_5_to_magia_tile_ni_9_5_rsp = router_9_5_rsp_out[4];

    assign router_9_5_to_router_9_6_req = router_9_5_req_out[0];
    assign router_9_5_to_router_10_5_req = router_9_5_req_out[1];
    assign router_9_5_to_router_9_4_req = router_9_5_req_out[2];
    assign router_9_5_to_router_8_5_req = router_9_5_req_out[3];
    assign router_9_5_to_magia_tile_ni_9_5_req = router_9_5_req_out[4];

    assign router_9_5_rsp_in[0] = router_9_6_to_router_9_5_rsp;
    assign router_9_5_rsp_in[1] = router_10_5_to_router_9_5_rsp;
    assign router_9_5_rsp_in[2] = router_9_4_to_router_9_5_rsp;
    assign router_9_5_rsp_in[3] = router_8_5_to_router_9_5_rsp;
    assign router_9_5_rsp_in[4] = magia_tile_ni_9_5_to_router_9_5_rsp;

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
) router_9_5 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 10, y: 5, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_9_5_req_in),
  .floo_rsp_o (router_9_5_rsp_out),
  .floo_req_o (router_9_5_req_out),
  .floo_rsp_i (router_9_5_rsp_in)
);


floo_req_t [4:0] router_9_6_req_in;
floo_rsp_t [4:0] router_9_6_rsp_out;
floo_req_t [4:0] router_9_6_req_out;
floo_rsp_t [4:0] router_9_6_rsp_in;

    assign router_9_6_req_in[0] = router_9_7_to_router_9_6_req;
    assign router_9_6_req_in[1] = router_10_6_to_router_9_6_req;
    assign router_9_6_req_in[2] = router_9_5_to_router_9_6_req;
    assign router_9_6_req_in[3] = router_8_6_to_router_9_6_req;
    assign router_9_6_req_in[4] = magia_tile_ni_9_6_to_router_9_6_req;

    assign router_9_6_to_router_9_7_rsp = router_9_6_rsp_out[0];
    assign router_9_6_to_router_10_6_rsp = router_9_6_rsp_out[1];
    assign router_9_6_to_router_9_5_rsp = router_9_6_rsp_out[2];
    assign router_9_6_to_router_8_6_rsp = router_9_6_rsp_out[3];
    assign router_9_6_to_magia_tile_ni_9_6_rsp = router_9_6_rsp_out[4];

    assign router_9_6_to_router_9_7_req = router_9_6_req_out[0];
    assign router_9_6_to_router_10_6_req = router_9_6_req_out[1];
    assign router_9_6_to_router_9_5_req = router_9_6_req_out[2];
    assign router_9_6_to_router_8_6_req = router_9_6_req_out[3];
    assign router_9_6_to_magia_tile_ni_9_6_req = router_9_6_req_out[4];

    assign router_9_6_rsp_in[0] = router_9_7_to_router_9_6_rsp;
    assign router_9_6_rsp_in[1] = router_10_6_to_router_9_6_rsp;
    assign router_9_6_rsp_in[2] = router_9_5_to_router_9_6_rsp;
    assign router_9_6_rsp_in[3] = router_8_6_to_router_9_6_rsp;
    assign router_9_6_rsp_in[4] = magia_tile_ni_9_6_to_router_9_6_rsp;

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
) router_9_6 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 10, y: 6, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_9_6_req_in),
  .floo_rsp_o (router_9_6_rsp_out),
  .floo_req_o (router_9_6_req_out),
  .floo_rsp_i (router_9_6_rsp_in)
);


floo_req_t [4:0] router_9_7_req_in;
floo_rsp_t [4:0] router_9_7_rsp_out;
floo_req_t [4:0] router_9_7_req_out;
floo_rsp_t [4:0] router_9_7_rsp_in;

    assign router_9_7_req_in[0] = router_9_8_to_router_9_7_req;
    assign router_9_7_req_in[1] = router_10_7_to_router_9_7_req;
    assign router_9_7_req_in[2] = router_9_6_to_router_9_7_req;
    assign router_9_7_req_in[3] = router_8_7_to_router_9_7_req;
    assign router_9_7_req_in[4] = magia_tile_ni_9_7_to_router_9_7_req;

    assign router_9_7_to_router_9_8_rsp = router_9_7_rsp_out[0];
    assign router_9_7_to_router_10_7_rsp = router_9_7_rsp_out[1];
    assign router_9_7_to_router_9_6_rsp = router_9_7_rsp_out[2];
    assign router_9_7_to_router_8_7_rsp = router_9_7_rsp_out[3];
    assign router_9_7_to_magia_tile_ni_9_7_rsp = router_9_7_rsp_out[4];

    assign router_9_7_to_router_9_8_req = router_9_7_req_out[0];
    assign router_9_7_to_router_10_7_req = router_9_7_req_out[1];
    assign router_9_7_to_router_9_6_req = router_9_7_req_out[2];
    assign router_9_7_to_router_8_7_req = router_9_7_req_out[3];
    assign router_9_7_to_magia_tile_ni_9_7_req = router_9_7_req_out[4];

    assign router_9_7_rsp_in[0] = router_9_8_to_router_9_7_rsp;
    assign router_9_7_rsp_in[1] = router_10_7_to_router_9_7_rsp;
    assign router_9_7_rsp_in[2] = router_9_6_to_router_9_7_rsp;
    assign router_9_7_rsp_in[3] = router_8_7_to_router_9_7_rsp;
    assign router_9_7_rsp_in[4] = magia_tile_ni_9_7_to_router_9_7_rsp;

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
) router_9_7 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 10, y: 7, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_9_7_req_in),
  .floo_rsp_o (router_9_7_rsp_out),
  .floo_req_o (router_9_7_req_out),
  .floo_rsp_i (router_9_7_rsp_in)
);


floo_req_t [4:0] router_9_8_req_in;
floo_rsp_t [4:0] router_9_8_rsp_out;
floo_req_t [4:0] router_9_8_req_out;
floo_rsp_t [4:0] router_9_8_rsp_in;

    assign router_9_8_req_in[0] = router_9_9_to_router_9_8_req;
    assign router_9_8_req_in[1] = router_10_8_to_router_9_8_req;
    assign router_9_8_req_in[2] = router_9_7_to_router_9_8_req;
    assign router_9_8_req_in[3] = router_8_8_to_router_9_8_req;
    assign router_9_8_req_in[4] = magia_tile_ni_9_8_to_router_9_8_req;

    assign router_9_8_to_router_9_9_rsp = router_9_8_rsp_out[0];
    assign router_9_8_to_router_10_8_rsp = router_9_8_rsp_out[1];
    assign router_9_8_to_router_9_7_rsp = router_9_8_rsp_out[2];
    assign router_9_8_to_router_8_8_rsp = router_9_8_rsp_out[3];
    assign router_9_8_to_magia_tile_ni_9_8_rsp = router_9_8_rsp_out[4];

    assign router_9_8_to_router_9_9_req = router_9_8_req_out[0];
    assign router_9_8_to_router_10_8_req = router_9_8_req_out[1];
    assign router_9_8_to_router_9_7_req = router_9_8_req_out[2];
    assign router_9_8_to_router_8_8_req = router_9_8_req_out[3];
    assign router_9_8_to_magia_tile_ni_9_8_req = router_9_8_req_out[4];

    assign router_9_8_rsp_in[0] = router_9_9_to_router_9_8_rsp;
    assign router_9_8_rsp_in[1] = router_10_8_to_router_9_8_rsp;
    assign router_9_8_rsp_in[2] = router_9_7_to_router_9_8_rsp;
    assign router_9_8_rsp_in[3] = router_8_8_to_router_9_8_rsp;
    assign router_9_8_rsp_in[4] = magia_tile_ni_9_8_to_router_9_8_rsp;

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
) router_9_8 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 10, y: 8, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_9_8_req_in),
  .floo_rsp_o (router_9_8_rsp_out),
  .floo_req_o (router_9_8_req_out),
  .floo_rsp_i (router_9_8_rsp_in)
);


floo_req_t [4:0] router_9_9_req_in;
floo_rsp_t [4:0] router_9_9_rsp_out;
floo_req_t [4:0] router_9_9_req_out;
floo_rsp_t [4:0] router_9_9_rsp_in;

    assign router_9_9_req_in[0] = router_9_10_to_router_9_9_req;
    assign router_9_9_req_in[1] = router_10_9_to_router_9_9_req;
    assign router_9_9_req_in[2] = router_9_8_to_router_9_9_req;
    assign router_9_9_req_in[3] = router_8_9_to_router_9_9_req;
    assign router_9_9_req_in[4] = magia_tile_ni_9_9_to_router_9_9_req;

    assign router_9_9_to_router_9_10_rsp = router_9_9_rsp_out[0];
    assign router_9_9_to_router_10_9_rsp = router_9_9_rsp_out[1];
    assign router_9_9_to_router_9_8_rsp = router_9_9_rsp_out[2];
    assign router_9_9_to_router_8_9_rsp = router_9_9_rsp_out[3];
    assign router_9_9_to_magia_tile_ni_9_9_rsp = router_9_9_rsp_out[4];

    assign router_9_9_to_router_9_10_req = router_9_9_req_out[0];
    assign router_9_9_to_router_10_9_req = router_9_9_req_out[1];
    assign router_9_9_to_router_9_8_req = router_9_9_req_out[2];
    assign router_9_9_to_router_8_9_req = router_9_9_req_out[3];
    assign router_9_9_to_magia_tile_ni_9_9_req = router_9_9_req_out[4];

    assign router_9_9_rsp_in[0] = router_9_10_to_router_9_9_rsp;
    assign router_9_9_rsp_in[1] = router_10_9_to_router_9_9_rsp;
    assign router_9_9_rsp_in[2] = router_9_8_to_router_9_9_rsp;
    assign router_9_9_rsp_in[3] = router_8_9_to_router_9_9_rsp;
    assign router_9_9_rsp_in[4] = magia_tile_ni_9_9_to_router_9_9_rsp;

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
) router_9_9 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 10, y: 9, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_9_9_req_in),
  .floo_rsp_o (router_9_9_rsp_out),
  .floo_req_o (router_9_9_req_out),
  .floo_rsp_i (router_9_9_rsp_in)
);


floo_req_t [4:0] router_9_10_req_in;
floo_rsp_t [4:0] router_9_10_rsp_out;
floo_req_t [4:0] router_9_10_req_out;
floo_rsp_t [4:0] router_9_10_rsp_in;

    assign router_9_10_req_in[0] = router_9_11_to_router_9_10_req;
    assign router_9_10_req_in[1] = router_10_10_to_router_9_10_req;
    assign router_9_10_req_in[2] = router_9_9_to_router_9_10_req;
    assign router_9_10_req_in[3] = router_8_10_to_router_9_10_req;
    assign router_9_10_req_in[4] = magia_tile_ni_9_10_to_router_9_10_req;

    assign router_9_10_to_router_9_11_rsp = router_9_10_rsp_out[0];
    assign router_9_10_to_router_10_10_rsp = router_9_10_rsp_out[1];
    assign router_9_10_to_router_9_9_rsp = router_9_10_rsp_out[2];
    assign router_9_10_to_router_8_10_rsp = router_9_10_rsp_out[3];
    assign router_9_10_to_magia_tile_ni_9_10_rsp = router_9_10_rsp_out[4];

    assign router_9_10_to_router_9_11_req = router_9_10_req_out[0];
    assign router_9_10_to_router_10_10_req = router_9_10_req_out[1];
    assign router_9_10_to_router_9_9_req = router_9_10_req_out[2];
    assign router_9_10_to_router_8_10_req = router_9_10_req_out[3];
    assign router_9_10_to_magia_tile_ni_9_10_req = router_9_10_req_out[4];

    assign router_9_10_rsp_in[0] = router_9_11_to_router_9_10_rsp;
    assign router_9_10_rsp_in[1] = router_10_10_to_router_9_10_rsp;
    assign router_9_10_rsp_in[2] = router_9_9_to_router_9_10_rsp;
    assign router_9_10_rsp_in[3] = router_8_10_to_router_9_10_rsp;
    assign router_9_10_rsp_in[4] = magia_tile_ni_9_10_to_router_9_10_rsp;

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
) router_9_10 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 10, y: 10, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_9_10_req_in),
  .floo_rsp_o (router_9_10_rsp_out),
  .floo_req_o (router_9_10_req_out),
  .floo_rsp_i (router_9_10_rsp_in)
);


floo_req_t [4:0] router_9_11_req_in;
floo_rsp_t [4:0] router_9_11_rsp_out;
floo_req_t [4:0] router_9_11_req_out;
floo_rsp_t [4:0] router_9_11_rsp_in;

    assign router_9_11_req_in[0] = router_9_12_to_router_9_11_req;
    assign router_9_11_req_in[1] = router_10_11_to_router_9_11_req;
    assign router_9_11_req_in[2] = router_9_10_to_router_9_11_req;
    assign router_9_11_req_in[3] = router_8_11_to_router_9_11_req;
    assign router_9_11_req_in[4] = magia_tile_ni_9_11_to_router_9_11_req;

    assign router_9_11_to_router_9_12_rsp = router_9_11_rsp_out[0];
    assign router_9_11_to_router_10_11_rsp = router_9_11_rsp_out[1];
    assign router_9_11_to_router_9_10_rsp = router_9_11_rsp_out[2];
    assign router_9_11_to_router_8_11_rsp = router_9_11_rsp_out[3];
    assign router_9_11_to_magia_tile_ni_9_11_rsp = router_9_11_rsp_out[4];

    assign router_9_11_to_router_9_12_req = router_9_11_req_out[0];
    assign router_9_11_to_router_10_11_req = router_9_11_req_out[1];
    assign router_9_11_to_router_9_10_req = router_9_11_req_out[2];
    assign router_9_11_to_router_8_11_req = router_9_11_req_out[3];
    assign router_9_11_to_magia_tile_ni_9_11_req = router_9_11_req_out[4];

    assign router_9_11_rsp_in[0] = router_9_12_to_router_9_11_rsp;
    assign router_9_11_rsp_in[1] = router_10_11_to_router_9_11_rsp;
    assign router_9_11_rsp_in[2] = router_9_10_to_router_9_11_rsp;
    assign router_9_11_rsp_in[3] = router_8_11_to_router_9_11_rsp;
    assign router_9_11_rsp_in[4] = magia_tile_ni_9_11_to_router_9_11_rsp;

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
) router_9_11 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 10, y: 11, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_9_11_req_in),
  .floo_rsp_o (router_9_11_rsp_out),
  .floo_req_o (router_9_11_req_out),
  .floo_rsp_i (router_9_11_rsp_in)
);


floo_req_t [4:0] router_9_12_req_in;
floo_rsp_t [4:0] router_9_12_rsp_out;
floo_req_t [4:0] router_9_12_req_out;
floo_rsp_t [4:0] router_9_12_rsp_in;

    assign router_9_12_req_in[0] = router_9_13_to_router_9_12_req;
    assign router_9_12_req_in[1] = router_10_12_to_router_9_12_req;
    assign router_9_12_req_in[2] = router_9_11_to_router_9_12_req;
    assign router_9_12_req_in[3] = router_8_12_to_router_9_12_req;
    assign router_9_12_req_in[4] = magia_tile_ni_9_12_to_router_9_12_req;

    assign router_9_12_to_router_9_13_rsp = router_9_12_rsp_out[0];
    assign router_9_12_to_router_10_12_rsp = router_9_12_rsp_out[1];
    assign router_9_12_to_router_9_11_rsp = router_9_12_rsp_out[2];
    assign router_9_12_to_router_8_12_rsp = router_9_12_rsp_out[3];
    assign router_9_12_to_magia_tile_ni_9_12_rsp = router_9_12_rsp_out[4];

    assign router_9_12_to_router_9_13_req = router_9_12_req_out[0];
    assign router_9_12_to_router_10_12_req = router_9_12_req_out[1];
    assign router_9_12_to_router_9_11_req = router_9_12_req_out[2];
    assign router_9_12_to_router_8_12_req = router_9_12_req_out[3];
    assign router_9_12_to_magia_tile_ni_9_12_req = router_9_12_req_out[4];

    assign router_9_12_rsp_in[0] = router_9_13_to_router_9_12_rsp;
    assign router_9_12_rsp_in[1] = router_10_12_to_router_9_12_rsp;
    assign router_9_12_rsp_in[2] = router_9_11_to_router_9_12_rsp;
    assign router_9_12_rsp_in[3] = router_8_12_to_router_9_12_rsp;
    assign router_9_12_rsp_in[4] = magia_tile_ni_9_12_to_router_9_12_rsp;

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
) router_9_12 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 10, y: 12, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_9_12_req_in),
  .floo_rsp_o (router_9_12_rsp_out),
  .floo_req_o (router_9_12_req_out),
  .floo_rsp_i (router_9_12_rsp_in)
);


floo_req_t [4:0] router_9_13_req_in;
floo_rsp_t [4:0] router_9_13_rsp_out;
floo_req_t [4:0] router_9_13_req_out;
floo_rsp_t [4:0] router_9_13_rsp_in;

    assign router_9_13_req_in[0] = router_9_14_to_router_9_13_req;
    assign router_9_13_req_in[1] = router_10_13_to_router_9_13_req;
    assign router_9_13_req_in[2] = router_9_12_to_router_9_13_req;
    assign router_9_13_req_in[3] = router_8_13_to_router_9_13_req;
    assign router_9_13_req_in[4] = magia_tile_ni_9_13_to_router_9_13_req;

    assign router_9_13_to_router_9_14_rsp = router_9_13_rsp_out[0];
    assign router_9_13_to_router_10_13_rsp = router_9_13_rsp_out[1];
    assign router_9_13_to_router_9_12_rsp = router_9_13_rsp_out[2];
    assign router_9_13_to_router_8_13_rsp = router_9_13_rsp_out[3];
    assign router_9_13_to_magia_tile_ni_9_13_rsp = router_9_13_rsp_out[4];

    assign router_9_13_to_router_9_14_req = router_9_13_req_out[0];
    assign router_9_13_to_router_10_13_req = router_9_13_req_out[1];
    assign router_9_13_to_router_9_12_req = router_9_13_req_out[2];
    assign router_9_13_to_router_8_13_req = router_9_13_req_out[3];
    assign router_9_13_to_magia_tile_ni_9_13_req = router_9_13_req_out[4];

    assign router_9_13_rsp_in[0] = router_9_14_to_router_9_13_rsp;
    assign router_9_13_rsp_in[1] = router_10_13_to_router_9_13_rsp;
    assign router_9_13_rsp_in[2] = router_9_12_to_router_9_13_rsp;
    assign router_9_13_rsp_in[3] = router_8_13_to_router_9_13_rsp;
    assign router_9_13_rsp_in[4] = magia_tile_ni_9_13_to_router_9_13_rsp;

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
) router_9_13 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 10, y: 13, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_9_13_req_in),
  .floo_rsp_o (router_9_13_rsp_out),
  .floo_req_o (router_9_13_req_out),
  .floo_rsp_i (router_9_13_rsp_in)
);


floo_req_t [4:0] router_9_14_req_in;
floo_rsp_t [4:0] router_9_14_rsp_out;
floo_req_t [4:0] router_9_14_req_out;
floo_rsp_t [4:0] router_9_14_rsp_in;

    assign router_9_14_req_in[0] = router_9_15_to_router_9_14_req;
    assign router_9_14_req_in[1] = router_10_14_to_router_9_14_req;
    assign router_9_14_req_in[2] = router_9_13_to_router_9_14_req;
    assign router_9_14_req_in[3] = router_8_14_to_router_9_14_req;
    assign router_9_14_req_in[4] = magia_tile_ni_9_14_to_router_9_14_req;

    assign router_9_14_to_router_9_15_rsp = router_9_14_rsp_out[0];
    assign router_9_14_to_router_10_14_rsp = router_9_14_rsp_out[1];
    assign router_9_14_to_router_9_13_rsp = router_9_14_rsp_out[2];
    assign router_9_14_to_router_8_14_rsp = router_9_14_rsp_out[3];
    assign router_9_14_to_magia_tile_ni_9_14_rsp = router_9_14_rsp_out[4];

    assign router_9_14_to_router_9_15_req = router_9_14_req_out[0];
    assign router_9_14_to_router_10_14_req = router_9_14_req_out[1];
    assign router_9_14_to_router_9_13_req = router_9_14_req_out[2];
    assign router_9_14_to_router_8_14_req = router_9_14_req_out[3];
    assign router_9_14_to_magia_tile_ni_9_14_req = router_9_14_req_out[4];

    assign router_9_14_rsp_in[0] = router_9_15_to_router_9_14_rsp;
    assign router_9_14_rsp_in[1] = router_10_14_to_router_9_14_rsp;
    assign router_9_14_rsp_in[2] = router_9_13_to_router_9_14_rsp;
    assign router_9_14_rsp_in[3] = router_8_14_to_router_9_14_rsp;
    assign router_9_14_rsp_in[4] = magia_tile_ni_9_14_to_router_9_14_rsp;

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
) router_9_14 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 10, y: 14, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_9_14_req_in),
  .floo_rsp_o (router_9_14_rsp_out),
  .floo_req_o (router_9_14_req_out),
  .floo_rsp_i (router_9_14_rsp_in)
);


floo_req_t [4:0] router_9_15_req_in;
floo_rsp_t [4:0] router_9_15_rsp_out;
floo_req_t [4:0] router_9_15_req_out;
floo_rsp_t [4:0] router_9_15_rsp_in;

    assign router_9_15_req_in[0] = '0;
    assign router_9_15_req_in[1] = router_10_15_to_router_9_15_req;
    assign router_9_15_req_in[2] = router_9_14_to_router_9_15_req;
    assign router_9_15_req_in[3] = router_8_15_to_router_9_15_req;
    assign router_9_15_req_in[4] = magia_tile_ni_9_15_to_router_9_15_req;

    assign router_9_15_to_router_10_15_rsp = router_9_15_rsp_out[1];
    assign router_9_15_to_router_9_14_rsp = router_9_15_rsp_out[2];
    assign router_9_15_to_router_8_15_rsp = router_9_15_rsp_out[3];
    assign router_9_15_to_magia_tile_ni_9_15_rsp = router_9_15_rsp_out[4];

    assign router_9_15_to_router_10_15_req = router_9_15_req_out[1];
    assign router_9_15_to_router_9_14_req = router_9_15_req_out[2];
    assign router_9_15_to_router_8_15_req = router_9_15_req_out[3];
    assign router_9_15_to_magia_tile_ni_9_15_req = router_9_15_req_out[4];

    assign router_9_15_rsp_in[0] = '0;
    assign router_9_15_rsp_in[1] = router_10_15_to_router_9_15_rsp;
    assign router_9_15_rsp_in[2] = router_9_14_to_router_9_15_rsp;
    assign router_9_15_rsp_in[3] = router_8_15_to_router_9_15_rsp;
    assign router_9_15_rsp_in[4] = magia_tile_ni_9_15_to_router_9_15_rsp;

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
) router_9_15 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 10, y: 15, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_9_15_req_in),
  .floo_rsp_o (router_9_15_rsp_out),
  .floo_req_o (router_9_15_req_out),
  .floo_rsp_i (router_9_15_rsp_in)
);


floo_req_t [4:0] router_10_0_req_in;
floo_rsp_t [4:0] router_10_0_rsp_out;
floo_req_t [4:0] router_10_0_req_out;
floo_rsp_t [4:0] router_10_0_rsp_in;

    assign router_10_0_req_in[0] = router_10_1_to_router_10_0_req;
    assign router_10_0_req_in[1] = router_11_0_to_router_10_0_req;
    assign router_10_0_req_in[2] = '0;
    assign router_10_0_req_in[3] = router_9_0_to_router_10_0_req;
    assign router_10_0_req_in[4] = magia_tile_ni_10_0_to_router_10_0_req;

    assign router_10_0_to_router_10_1_rsp = router_10_0_rsp_out[0];
    assign router_10_0_to_router_11_0_rsp = router_10_0_rsp_out[1];
    assign router_10_0_to_router_9_0_rsp = router_10_0_rsp_out[3];
    assign router_10_0_to_magia_tile_ni_10_0_rsp = router_10_0_rsp_out[4];

    assign router_10_0_to_router_10_1_req = router_10_0_req_out[0];
    assign router_10_0_to_router_11_0_req = router_10_0_req_out[1];
    assign router_10_0_to_router_9_0_req = router_10_0_req_out[3];
    assign router_10_0_to_magia_tile_ni_10_0_req = router_10_0_req_out[4];

    assign router_10_0_rsp_in[0] = router_10_1_to_router_10_0_rsp;
    assign router_10_0_rsp_in[1] = router_11_0_to_router_10_0_rsp;
    assign router_10_0_rsp_in[2] = '0;
    assign router_10_0_rsp_in[3] = router_9_0_to_router_10_0_rsp;
    assign router_10_0_rsp_in[4] = magia_tile_ni_10_0_to_router_10_0_rsp;

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
) router_10_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 11, y: 0, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_10_0_req_in),
  .floo_rsp_o (router_10_0_rsp_out),
  .floo_req_o (router_10_0_req_out),
  .floo_rsp_i (router_10_0_rsp_in)
);


floo_req_t [4:0] router_10_1_req_in;
floo_rsp_t [4:0] router_10_1_rsp_out;
floo_req_t [4:0] router_10_1_req_out;
floo_rsp_t [4:0] router_10_1_rsp_in;

    assign router_10_1_req_in[0] = router_10_2_to_router_10_1_req;
    assign router_10_1_req_in[1] = router_11_1_to_router_10_1_req;
    assign router_10_1_req_in[2] = router_10_0_to_router_10_1_req;
    assign router_10_1_req_in[3] = router_9_1_to_router_10_1_req;
    assign router_10_1_req_in[4] = magia_tile_ni_10_1_to_router_10_1_req;

    assign router_10_1_to_router_10_2_rsp = router_10_1_rsp_out[0];
    assign router_10_1_to_router_11_1_rsp = router_10_1_rsp_out[1];
    assign router_10_1_to_router_10_0_rsp = router_10_1_rsp_out[2];
    assign router_10_1_to_router_9_1_rsp = router_10_1_rsp_out[3];
    assign router_10_1_to_magia_tile_ni_10_1_rsp = router_10_1_rsp_out[4];

    assign router_10_1_to_router_10_2_req = router_10_1_req_out[0];
    assign router_10_1_to_router_11_1_req = router_10_1_req_out[1];
    assign router_10_1_to_router_10_0_req = router_10_1_req_out[2];
    assign router_10_1_to_router_9_1_req = router_10_1_req_out[3];
    assign router_10_1_to_magia_tile_ni_10_1_req = router_10_1_req_out[4];

    assign router_10_1_rsp_in[0] = router_10_2_to_router_10_1_rsp;
    assign router_10_1_rsp_in[1] = router_11_1_to_router_10_1_rsp;
    assign router_10_1_rsp_in[2] = router_10_0_to_router_10_1_rsp;
    assign router_10_1_rsp_in[3] = router_9_1_to_router_10_1_rsp;
    assign router_10_1_rsp_in[4] = magia_tile_ni_10_1_to_router_10_1_rsp;

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
) router_10_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 11, y: 1, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_10_1_req_in),
  .floo_rsp_o (router_10_1_rsp_out),
  .floo_req_o (router_10_1_req_out),
  .floo_rsp_i (router_10_1_rsp_in)
);


floo_req_t [4:0] router_10_2_req_in;
floo_rsp_t [4:0] router_10_2_rsp_out;
floo_req_t [4:0] router_10_2_req_out;
floo_rsp_t [4:0] router_10_2_rsp_in;

    assign router_10_2_req_in[0] = router_10_3_to_router_10_2_req;
    assign router_10_2_req_in[1] = router_11_2_to_router_10_2_req;
    assign router_10_2_req_in[2] = router_10_1_to_router_10_2_req;
    assign router_10_2_req_in[3] = router_9_2_to_router_10_2_req;
    assign router_10_2_req_in[4] = magia_tile_ni_10_2_to_router_10_2_req;

    assign router_10_2_to_router_10_3_rsp = router_10_2_rsp_out[0];
    assign router_10_2_to_router_11_2_rsp = router_10_2_rsp_out[1];
    assign router_10_2_to_router_10_1_rsp = router_10_2_rsp_out[2];
    assign router_10_2_to_router_9_2_rsp = router_10_2_rsp_out[3];
    assign router_10_2_to_magia_tile_ni_10_2_rsp = router_10_2_rsp_out[4];

    assign router_10_2_to_router_10_3_req = router_10_2_req_out[0];
    assign router_10_2_to_router_11_2_req = router_10_2_req_out[1];
    assign router_10_2_to_router_10_1_req = router_10_2_req_out[2];
    assign router_10_2_to_router_9_2_req = router_10_2_req_out[3];
    assign router_10_2_to_magia_tile_ni_10_2_req = router_10_2_req_out[4];

    assign router_10_2_rsp_in[0] = router_10_3_to_router_10_2_rsp;
    assign router_10_2_rsp_in[1] = router_11_2_to_router_10_2_rsp;
    assign router_10_2_rsp_in[2] = router_10_1_to_router_10_2_rsp;
    assign router_10_2_rsp_in[3] = router_9_2_to_router_10_2_rsp;
    assign router_10_2_rsp_in[4] = magia_tile_ni_10_2_to_router_10_2_rsp;

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
) router_10_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 11, y: 2, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_10_2_req_in),
  .floo_rsp_o (router_10_2_rsp_out),
  .floo_req_o (router_10_2_req_out),
  .floo_rsp_i (router_10_2_rsp_in)
);


floo_req_t [4:0] router_10_3_req_in;
floo_rsp_t [4:0] router_10_3_rsp_out;
floo_req_t [4:0] router_10_3_req_out;
floo_rsp_t [4:0] router_10_3_rsp_in;

    assign router_10_3_req_in[0] = router_10_4_to_router_10_3_req;
    assign router_10_3_req_in[1] = router_11_3_to_router_10_3_req;
    assign router_10_3_req_in[2] = router_10_2_to_router_10_3_req;
    assign router_10_3_req_in[3] = router_9_3_to_router_10_3_req;
    assign router_10_3_req_in[4] = magia_tile_ni_10_3_to_router_10_3_req;

    assign router_10_3_to_router_10_4_rsp = router_10_3_rsp_out[0];
    assign router_10_3_to_router_11_3_rsp = router_10_3_rsp_out[1];
    assign router_10_3_to_router_10_2_rsp = router_10_3_rsp_out[2];
    assign router_10_3_to_router_9_3_rsp = router_10_3_rsp_out[3];
    assign router_10_3_to_magia_tile_ni_10_3_rsp = router_10_3_rsp_out[4];

    assign router_10_3_to_router_10_4_req = router_10_3_req_out[0];
    assign router_10_3_to_router_11_3_req = router_10_3_req_out[1];
    assign router_10_3_to_router_10_2_req = router_10_3_req_out[2];
    assign router_10_3_to_router_9_3_req = router_10_3_req_out[3];
    assign router_10_3_to_magia_tile_ni_10_3_req = router_10_3_req_out[4];

    assign router_10_3_rsp_in[0] = router_10_4_to_router_10_3_rsp;
    assign router_10_3_rsp_in[1] = router_11_3_to_router_10_3_rsp;
    assign router_10_3_rsp_in[2] = router_10_2_to_router_10_3_rsp;
    assign router_10_3_rsp_in[3] = router_9_3_to_router_10_3_rsp;
    assign router_10_3_rsp_in[4] = magia_tile_ni_10_3_to_router_10_3_rsp;

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
) router_10_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 11, y: 3, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_10_3_req_in),
  .floo_rsp_o (router_10_3_rsp_out),
  .floo_req_o (router_10_3_req_out),
  .floo_rsp_i (router_10_3_rsp_in)
);


floo_req_t [4:0] router_10_4_req_in;
floo_rsp_t [4:0] router_10_4_rsp_out;
floo_req_t [4:0] router_10_4_req_out;
floo_rsp_t [4:0] router_10_4_rsp_in;

    assign router_10_4_req_in[0] = router_10_5_to_router_10_4_req;
    assign router_10_4_req_in[1] = router_11_4_to_router_10_4_req;
    assign router_10_4_req_in[2] = router_10_3_to_router_10_4_req;
    assign router_10_4_req_in[3] = router_9_4_to_router_10_4_req;
    assign router_10_4_req_in[4] = magia_tile_ni_10_4_to_router_10_4_req;

    assign router_10_4_to_router_10_5_rsp = router_10_4_rsp_out[0];
    assign router_10_4_to_router_11_4_rsp = router_10_4_rsp_out[1];
    assign router_10_4_to_router_10_3_rsp = router_10_4_rsp_out[2];
    assign router_10_4_to_router_9_4_rsp = router_10_4_rsp_out[3];
    assign router_10_4_to_magia_tile_ni_10_4_rsp = router_10_4_rsp_out[4];

    assign router_10_4_to_router_10_5_req = router_10_4_req_out[0];
    assign router_10_4_to_router_11_4_req = router_10_4_req_out[1];
    assign router_10_4_to_router_10_3_req = router_10_4_req_out[2];
    assign router_10_4_to_router_9_4_req = router_10_4_req_out[3];
    assign router_10_4_to_magia_tile_ni_10_4_req = router_10_4_req_out[4];

    assign router_10_4_rsp_in[0] = router_10_5_to_router_10_4_rsp;
    assign router_10_4_rsp_in[1] = router_11_4_to_router_10_4_rsp;
    assign router_10_4_rsp_in[2] = router_10_3_to_router_10_4_rsp;
    assign router_10_4_rsp_in[3] = router_9_4_to_router_10_4_rsp;
    assign router_10_4_rsp_in[4] = magia_tile_ni_10_4_to_router_10_4_rsp;

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
) router_10_4 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 11, y: 4, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_10_4_req_in),
  .floo_rsp_o (router_10_4_rsp_out),
  .floo_req_o (router_10_4_req_out),
  .floo_rsp_i (router_10_4_rsp_in)
);


floo_req_t [4:0] router_10_5_req_in;
floo_rsp_t [4:0] router_10_5_rsp_out;
floo_req_t [4:0] router_10_5_req_out;
floo_rsp_t [4:0] router_10_5_rsp_in;

    assign router_10_5_req_in[0] = router_10_6_to_router_10_5_req;
    assign router_10_5_req_in[1] = router_11_5_to_router_10_5_req;
    assign router_10_5_req_in[2] = router_10_4_to_router_10_5_req;
    assign router_10_5_req_in[3] = router_9_5_to_router_10_5_req;
    assign router_10_5_req_in[4] = magia_tile_ni_10_5_to_router_10_5_req;

    assign router_10_5_to_router_10_6_rsp = router_10_5_rsp_out[0];
    assign router_10_5_to_router_11_5_rsp = router_10_5_rsp_out[1];
    assign router_10_5_to_router_10_4_rsp = router_10_5_rsp_out[2];
    assign router_10_5_to_router_9_5_rsp = router_10_5_rsp_out[3];
    assign router_10_5_to_magia_tile_ni_10_5_rsp = router_10_5_rsp_out[4];

    assign router_10_5_to_router_10_6_req = router_10_5_req_out[0];
    assign router_10_5_to_router_11_5_req = router_10_5_req_out[1];
    assign router_10_5_to_router_10_4_req = router_10_5_req_out[2];
    assign router_10_5_to_router_9_5_req = router_10_5_req_out[3];
    assign router_10_5_to_magia_tile_ni_10_5_req = router_10_5_req_out[4];

    assign router_10_5_rsp_in[0] = router_10_6_to_router_10_5_rsp;
    assign router_10_5_rsp_in[1] = router_11_5_to_router_10_5_rsp;
    assign router_10_5_rsp_in[2] = router_10_4_to_router_10_5_rsp;
    assign router_10_5_rsp_in[3] = router_9_5_to_router_10_5_rsp;
    assign router_10_5_rsp_in[4] = magia_tile_ni_10_5_to_router_10_5_rsp;

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
) router_10_5 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 11, y: 5, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_10_5_req_in),
  .floo_rsp_o (router_10_5_rsp_out),
  .floo_req_o (router_10_5_req_out),
  .floo_rsp_i (router_10_5_rsp_in)
);


floo_req_t [4:0] router_10_6_req_in;
floo_rsp_t [4:0] router_10_6_rsp_out;
floo_req_t [4:0] router_10_6_req_out;
floo_rsp_t [4:0] router_10_6_rsp_in;

    assign router_10_6_req_in[0] = router_10_7_to_router_10_6_req;
    assign router_10_6_req_in[1] = router_11_6_to_router_10_6_req;
    assign router_10_6_req_in[2] = router_10_5_to_router_10_6_req;
    assign router_10_6_req_in[3] = router_9_6_to_router_10_6_req;
    assign router_10_6_req_in[4] = magia_tile_ni_10_6_to_router_10_6_req;

    assign router_10_6_to_router_10_7_rsp = router_10_6_rsp_out[0];
    assign router_10_6_to_router_11_6_rsp = router_10_6_rsp_out[1];
    assign router_10_6_to_router_10_5_rsp = router_10_6_rsp_out[2];
    assign router_10_6_to_router_9_6_rsp = router_10_6_rsp_out[3];
    assign router_10_6_to_magia_tile_ni_10_6_rsp = router_10_6_rsp_out[4];

    assign router_10_6_to_router_10_7_req = router_10_6_req_out[0];
    assign router_10_6_to_router_11_6_req = router_10_6_req_out[1];
    assign router_10_6_to_router_10_5_req = router_10_6_req_out[2];
    assign router_10_6_to_router_9_6_req = router_10_6_req_out[3];
    assign router_10_6_to_magia_tile_ni_10_6_req = router_10_6_req_out[4];

    assign router_10_6_rsp_in[0] = router_10_7_to_router_10_6_rsp;
    assign router_10_6_rsp_in[1] = router_11_6_to_router_10_6_rsp;
    assign router_10_6_rsp_in[2] = router_10_5_to_router_10_6_rsp;
    assign router_10_6_rsp_in[3] = router_9_6_to_router_10_6_rsp;
    assign router_10_6_rsp_in[4] = magia_tile_ni_10_6_to_router_10_6_rsp;

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
) router_10_6 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 11, y: 6, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_10_6_req_in),
  .floo_rsp_o (router_10_6_rsp_out),
  .floo_req_o (router_10_6_req_out),
  .floo_rsp_i (router_10_6_rsp_in)
);


floo_req_t [4:0] router_10_7_req_in;
floo_rsp_t [4:0] router_10_7_rsp_out;
floo_req_t [4:0] router_10_7_req_out;
floo_rsp_t [4:0] router_10_7_rsp_in;

    assign router_10_7_req_in[0] = router_10_8_to_router_10_7_req;
    assign router_10_7_req_in[1] = router_11_7_to_router_10_7_req;
    assign router_10_7_req_in[2] = router_10_6_to_router_10_7_req;
    assign router_10_7_req_in[3] = router_9_7_to_router_10_7_req;
    assign router_10_7_req_in[4] = magia_tile_ni_10_7_to_router_10_7_req;

    assign router_10_7_to_router_10_8_rsp = router_10_7_rsp_out[0];
    assign router_10_7_to_router_11_7_rsp = router_10_7_rsp_out[1];
    assign router_10_7_to_router_10_6_rsp = router_10_7_rsp_out[2];
    assign router_10_7_to_router_9_7_rsp = router_10_7_rsp_out[3];
    assign router_10_7_to_magia_tile_ni_10_7_rsp = router_10_7_rsp_out[4];

    assign router_10_7_to_router_10_8_req = router_10_7_req_out[0];
    assign router_10_7_to_router_11_7_req = router_10_7_req_out[1];
    assign router_10_7_to_router_10_6_req = router_10_7_req_out[2];
    assign router_10_7_to_router_9_7_req = router_10_7_req_out[3];
    assign router_10_7_to_magia_tile_ni_10_7_req = router_10_7_req_out[4];

    assign router_10_7_rsp_in[0] = router_10_8_to_router_10_7_rsp;
    assign router_10_7_rsp_in[1] = router_11_7_to_router_10_7_rsp;
    assign router_10_7_rsp_in[2] = router_10_6_to_router_10_7_rsp;
    assign router_10_7_rsp_in[3] = router_9_7_to_router_10_7_rsp;
    assign router_10_7_rsp_in[4] = magia_tile_ni_10_7_to_router_10_7_rsp;

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
) router_10_7 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 11, y: 7, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_10_7_req_in),
  .floo_rsp_o (router_10_7_rsp_out),
  .floo_req_o (router_10_7_req_out),
  .floo_rsp_i (router_10_7_rsp_in)
);


floo_req_t [4:0] router_10_8_req_in;
floo_rsp_t [4:0] router_10_8_rsp_out;
floo_req_t [4:0] router_10_8_req_out;
floo_rsp_t [4:0] router_10_8_rsp_in;

    assign router_10_8_req_in[0] = router_10_9_to_router_10_8_req;
    assign router_10_8_req_in[1] = router_11_8_to_router_10_8_req;
    assign router_10_8_req_in[2] = router_10_7_to_router_10_8_req;
    assign router_10_8_req_in[3] = router_9_8_to_router_10_8_req;
    assign router_10_8_req_in[4] = magia_tile_ni_10_8_to_router_10_8_req;

    assign router_10_8_to_router_10_9_rsp = router_10_8_rsp_out[0];
    assign router_10_8_to_router_11_8_rsp = router_10_8_rsp_out[1];
    assign router_10_8_to_router_10_7_rsp = router_10_8_rsp_out[2];
    assign router_10_8_to_router_9_8_rsp = router_10_8_rsp_out[3];
    assign router_10_8_to_magia_tile_ni_10_8_rsp = router_10_8_rsp_out[4];

    assign router_10_8_to_router_10_9_req = router_10_8_req_out[0];
    assign router_10_8_to_router_11_8_req = router_10_8_req_out[1];
    assign router_10_8_to_router_10_7_req = router_10_8_req_out[2];
    assign router_10_8_to_router_9_8_req = router_10_8_req_out[3];
    assign router_10_8_to_magia_tile_ni_10_8_req = router_10_8_req_out[4];

    assign router_10_8_rsp_in[0] = router_10_9_to_router_10_8_rsp;
    assign router_10_8_rsp_in[1] = router_11_8_to_router_10_8_rsp;
    assign router_10_8_rsp_in[2] = router_10_7_to_router_10_8_rsp;
    assign router_10_8_rsp_in[3] = router_9_8_to_router_10_8_rsp;
    assign router_10_8_rsp_in[4] = magia_tile_ni_10_8_to_router_10_8_rsp;

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
) router_10_8 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 11, y: 8, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_10_8_req_in),
  .floo_rsp_o (router_10_8_rsp_out),
  .floo_req_o (router_10_8_req_out),
  .floo_rsp_i (router_10_8_rsp_in)
);


floo_req_t [4:0] router_10_9_req_in;
floo_rsp_t [4:0] router_10_9_rsp_out;
floo_req_t [4:0] router_10_9_req_out;
floo_rsp_t [4:0] router_10_9_rsp_in;

    assign router_10_9_req_in[0] = router_10_10_to_router_10_9_req;
    assign router_10_9_req_in[1] = router_11_9_to_router_10_9_req;
    assign router_10_9_req_in[2] = router_10_8_to_router_10_9_req;
    assign router_10_9_req_in[3] = router_9_9_to_router_10_9_req;
    assign router_10_9_req_in[4] = magia_tile_ni_10_9_to_router_10_9_req;

    assign router_10_9_to_router_10_10_rsp = router_10_9_rsp_out[0];
    assign router_10_9_to_router_11_9_rsp = router_10_9_rsp_out[1];
    assign router_10_9_to_router_10_8_rsp = router_10_9_rsp_out[2];
    assign router_10_9_to_router_9_9_rsp = router_10_9_rsp_out[3];
    assign router_10_9_to_magia_tile_ni_10_9_rsp = router_10_9_rsp_out[4];

    assign router_10_9_to_router_10_10_req = router_10_9_req_out[0];
    assign router_10_9_to_router_11_9_req = router_10_9_req_out[1];
    assign router_10_9_to_router_10_8_req = router_10_9_req_out[2];
    assign router_10_9_to_router_9_9_req = router_10_9_req_out[3];
    assign router_10_9_to_magia_tile_ni_10_9_req = router_10_9_req_out[4];

    assign router_10_9_rsp_in[0] = router_10_10_to_router_10_9_rsp;
    assign router_10_9_rsp_in[1] = router_11_9_to_router_10_9_rsp;
    assign router_10_9_rsp_in[2] = router_10_8_to_router_10_9_rsp;
    assign router_10_9_rsp_in[3] = router_9_9_to_router_10_9_rsp;
    assign router_10_9_rsp_in[4] = magia_tile_ni_10_9_to_router_10_9_rsp;

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
) router_10_9 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 11, y: 9, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_10_9_req_in),
  .floo_rsp_o (router_10_9_rsp_out),
  .floo_req_o (router_10_9_req_out),
  .floo_rsp_i (router_10_9_rsp_in)
);


floo_req_t [4:0] router_10_10_req_in;
floo_rsp_t [4:0] router_10_10_rsp_out;
floo_req_t [4:0] router_10_10_req_out;
floo_rsp_t [4:0] router_10_10_rsp_in;

    assign router_10_10_req_in[0] = router_10_11_to_router_10_10_req;
    assign router_10_10_req_in[1] = router_11_10_to_router_10_10_req;
    assign router_10_10_req_in[2] = router_10_9_to_router_10_10_req;
    assign router_10_10_req_in[3] = router_9_10_to_router_10_10_req;
    assign router_10_10_req_in[4] = magia_tile_ni_10_10_to_router_10_10_req;

    assign router_10_10_to_router_10_11_rsp = router_10_10_rsp_out[0];
    assign router_10_10_to_router_11_10_rsp = router_10_10_rsp_out[1];
    assign router_10_10_to_router_10_9_rsp = router_10_10_rsp_out[2];
    assign router_10_10_to_router_9_10_rsp = router_10_10_rsp_out[3];
    assign router_10_10_to_magia_tile_ni_10_10_rsp = router_10_10_rsp_out[4];

    assign router_10_10_to_router_10_11_req = router_10_10_req_out[0];
    assign router_10_10_to_router_11_10_req = router_10_10_req_out[1];
    assign router_10_10_to_router_10_9_req = router_10_10_req_out[2];
    assign router_10_10_to_router_9_10_req = router_10_10_req_out[3];
    assign router_10_10_to_magia_tile_ni_10_10_req = router_10_10_req_out[4];

    assign router_10_10_rsp_in[0] = router_10_11_to_router_10_10_rsp;
    assign router_10_10_rsp_in[1] = router_11_10_to_router_10_10_rsp;
    assign router_10_10_rsp_in[2] = router_10_9_to_router_10_10_rsp;
    assign router_10_10_rsp_in[3] = router_9_10_to_router_10_10_rsp;
    assign router_10_10_rsp_in[4] = magia_tile_ni_10_10_to_router_10_10_rsp;

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
) router_10_10 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 11, y: 10, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_10_10_req_in),
  .floo_rsp_o (router_10_10_rsp_out),
  .floo_req_o (router_10_10_req_out),
  .floo_rsp_i (router_10_10_rsp_in)
);


floo_req_t [4:0] router_10_11_req_in;
floo_rsp_t [4:0] router_10_11_rsp_out;
floo_req_t [4:0] router_10_11_req_out;
floo_rsp_t [4:0] router_10_11_rsp_in;

    assign router_10_11_req_in[0] = router_10_12_to_router_10_11_req;
    assign router_10_11_req_in[1] = router_11_11_to_router_10_11_req;
    assign router_10_11_req_in[2] = router_10_10_to_router_10_11_req;
    assign router_10_11_req_in[3] = router_9_11_to_router_10_11_req;
    assign router_10_11_req_in[4] = magia_tile_ni_10_11_to_router_10_11_req;

    assign router_10_11_to_router_10_12_rsp = router_10_11_rsp_out[0];
    assign router_10_11_to_router_11_11_rsp = router_10_11_rsp_out[1];
    assign router_10_11_to_router_10_10_rsp = router_10_11_rsp_out[2];
    assign router_10_11_to_router_9_11_rsp = router_10_11_rsp_out[3];
    assign router_10_11_to_magia_tile_ni_10_11_rsp = router_10_11_rsp_out[4];

    assign router_10_11_to_router_10_12_req = router_10_11_req_out[0];
    assign router_10_11_to_router_11_11_req = router_10_11_req_out[1];
    assign router_10_11_to_router_10_10_req = router_10_11_req_out[2];
    assign router_10_11_to_router_9_11_req = router_10_11_req_out[3];
    assign router_10_11_to_magia_tile_ni_10_11_req = router_10_11_req_out[4];

    assign router_10_11_rsp_in[0] = router_10_12_to_router_10_11_rsp;
    assign router_10_11_rsp_in[1] = router_11_11_to_router_10_11_rsp;
    assign router_10_11_rsp_in[2] = router_10_10_to_router_10_11_rsp;
    assign router_10_11_rsp_in[3] = router_9_11_to_router_10_11_rsp;
    assign router_10_11_rsp_in[4] = magia_tile_ni_10_11_to_router_10_11_rsp;

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
) router_10_11 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 11, y: 11, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_10_11_req_in),
  .floo_rsp_o (router_10_11_rsp_out),
  .floo_req_o (router_10_11_req_out),
  .floo_rsp_i (router_10_11_rsp_in)
);


floo_req_t [4:0] router_10_12_req_in;
floo_rsp_t [4:0] router_10_12_rsp_out;
floo_req_t [4:0] router_10_12_req_out;
floo_rsp_t [4:0] router_10_12_rsp_in;

    assign router_10_12_req_in[0] = router_10_13_to_router_10_12_req;
    assign router_10_12_req_in[1] = router_11_12_to_router_10_12_req;
    assign router_10_12_req_in[2] = router_10_11_to_router_10_12_req;
    assign router_10_12_req_in[3] = router_9_12_to_router_10_12_req;
    assign router_10_12_req_in[4] = magia_tile_ni_10_12_to_router_10_12_req;

    assign router_10_12_to_router_10_13_rsp = router_10_12_rsp_out[0];
    assign router_10_12_to_router_11_12_rsp = router_10_12_rsp_out[1];
    assign router_10_12_to_router_10_11_rsp = router_10_12_rsp_out[2];
    assign router_10_12_to_router_9_12_rsp = router_10_12_rsp_out[3];
    assign router_10_12_to_magia_tile_ni_10_12_rsp = router_10_12_rsp_out[4];

    assign router_10_12_to_router_10_13_req = router_10_12_req_out[0];
    assign router_10_12_to_router_11_12_req = router_10_12_req_out[1];
    assign router_10_12_to_router_10_11_req = router_10_12_req_out[2];
    assign router_10_12_to_router_9_12_req = router_10_12_req_out[3];
    assign router_10_12_to_magia_tile_ni_10_12_req = router_10_12_req_out[4];

    assign router_10_12_rsp_in[0] = router_10_13_to_router_10_12_rsp;
    assign router_10_12_rsp_in[1] = router_11_12_to_router_10_12_rsp;
    assign router_10_12_rsp_in[2] = router_10_11_to_router_10_12_rsp;
    assign router_10_12_rsp_in[3] = router_9_12_to_router_10_12_rsp;
    assign router_10_12_rsp_in[4] = magia_tile_ni_10_12_to_router_10_12_rsp;

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
) router_10_12 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 11, y: 12, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_10_12_req_in),
  .floo_rsp_o (router_10_12_rsp_out),
  .floo_req_o (router_10_12_req_out),
  .floo_rsp_i (router_10_12_rsp_in)
);


floo_req_t [4:0] router_10_13_req_in;
floo_rsp_t [4:0] router_10_13_rsp_out;
floo_req_t [4:0] router_10_13_req_out;
floo_rsp_t [4:0] router_10_13_rsp_in;

    assign router_10_13_req_in[0] = router_10_14_to_router_10_13_req;
    assign router_10_13_req_in[1] = router_11_13_to_router_10_13_req;
    assign router_10_13_req_in[2] = router_10_12_to_router_10_13_req;
    assign router_10_13_req_in[3] = router_9_13_to_router_10_13_req;
    assign router_10_13_req_in[4] = magia_tile_ni_10_13_to_router_10_13_req;

    assign router_10_13_to_router_10_14_rsp = router_10_13_rsp_out[0];
    assign router_10_13_to_router_11_13_rsp = router_10_13_rsp_out[1];
    assign router_10_13_to_router_10_12_rsp = router_10_13_rsp_out[2];
    assign router_10_13_to_router_9_13_rsp = router_10_13_rsp_out[3];
    assign router_10_13_to_magia_tile_ni_10_13_rsp = router_10_13_rsp_out[4];

    assign router_10_13_to_router_10_14_req = router_10_13_req_out[0];
    assign router_10_13_to_router_11_13_req = router_10_13_req_out[1];
    assign router_10_13_to_router_10_12_req = router_10_13_req_out[2];
    assign router_10_13_to_router_9_13_req = router_10_13_req_out[3];
    assign router_10_13_to_magia_tile_ni_10_13_req = router_10_13_req_out[4];

    assign router_10_13_rsp_in[0] = router_10_14_to_router_10_13_rsp;
    assign router_10_13_rsp_in[1] = router_11_13_to_router_10_13_rsp;
    assign router_10_13_rsp_in[2] = router_10_12_to_router_10_13_rsp;
    assign router_10_13_rsp_in[3] = router_9_13_to_router_10_13_rsp;
    assign router_10_13_rsp_in[4] = magia_tile_ni_10_13_to_router_10_13_rsp;

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
) router_10_13 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 11, y: 13, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_10_13_req_in),
  .floo_rsp_o (router_10_13_rsp_out),
  .floo_req_o (router_10_13_req_out),
  .floo_rsp_i (router_10_13_rsp_in)
);


floo_req_t [4:0] router_10_14_req_in;
floo_rsp_t [4:0] router_10_14_rsp_out;
floo_req_t [4:0] router_10_14_req_out;
floo_rsp_t [4:0] router_10_14_rsp_in;

    assign router_10_14_req_in[0] = router_10_15_to_router_10_14_req;
    assign router_10_14_req_in[1] = router_11_14_to_router_10_14_req;
    assign router_10_14_req_in[2] = router_10_13_to_router_10_14_req;
    assign router_10_14_req_in[3] = router_9_14_to_router_10_14_req;
    assign router_10_14_req_in[4] = magia_tile_ni_10_14_to_router_10_14_req;

    assign router_10_14_to_router_10_15_rsp = router_10_14_rsp_out[0];
    assign router_10_14_to_router_11_14_rsp = router_10_14_rsp_out[1];
    assign router_10_14_to_router_10_13_rsp = router_10_14_rsp_out[2];
    assign router_10_14_to_router_9_14_rsp = router_10_14_rsp_out[3];
    assign router_10_14_to_magia_tile_ni_10_14_rsp = router_10_14_rsp_out[4];

    assign router_10_14_to_router_10_15_req = router_10_14_req_out[0];
    assign router_10_14_to_router_11_14_req = router_10_14_req_out[1];
    assign router_10_14_to_router_10_13_req = router_10_14_req_out[2];
    assign router_10_14_to_router_9_14_req = router_10_14_req_out[3];
    assign router_10_14_to_magia_tile_ni_10_14_req = router_10_14_req_out[4];

    assign router_10_14_rsp_in[0] = router_10_15_to_router_10_14_rsp;
    assign router_10_14_rsp_in[1] = router_11_14_to_router_10_14_rsp;
    assign router_10_14_rsp_in[2] = router_10_13_to_router_10_14_rsp;
    assign router_10_14_rsp_in[3] = router_9_14_to_router_10_14_rsp;
    assign router_10_14_rsp_in[4] = magia_tile_ni_10_14_to_router_10_14_rsp;

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
) router_10_14 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 11, y: 14, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_10_14_req_in),
  .floo_rsp_o (router_10_14_rsp_out),
  .floo_req_o (router_10_14_req_out),
  .floo_rsp_i (router_10_14_rsp_in)
);


floo_req_t [4:0] router_10_15_req_in;
floo_rsp_t [4:0] router_10_15_rsp_out;
floo_req_t [4:0] router_10_15_req_out;
floo_rsp_t [4:0] router_10_15_rsp_in;

    assign router_10_15_req_in[0] = '0;
    assign router_10_15_req_in[1] = router_11_15_to_router_10_15_req;
    assign router_10_15_req_in[2] = router_10_14_to_router_10_15_req;
    assign router_10_15_req_in[3] = router_9_15_to_router_10_15_req;
    assign router_10_15_req_in[4] = magia_tile_ni_10_15_to_router_10_15_req;

    assign router_10_15_to_router_11_15_rsp = router_10_15_rsp_out[1];
    assign router_10_15_to_router_10_14_rsp = router_10_15_rsp_out[2];
    assign router_10_15_to_router_9_15_rsp = router_10_15_rsp_out[3];
    assign router_10_15_to_magia_tile_ni_10_15_rsp = router_10_15_rsp_out[4];

    assign router_10_15_to_router_11_15_req = router_10_15_req_out[1];
    assign router_10_15_to_router_10_14_req = router_10_15_req_out[2];
    assign router_10_15_to_router_9_15_req = router_10_15_req_out[3];
    assign router_10_15_to_magia_tile_ni_10_15_req = router_10_15_req_out[4];

    assign router_10_15_rsp_in[0] = '0;
    assign router_10_15_rsp_in[1] = router_11_15_to_router_10_15_rsp;
    assign router_10_15_rsp_in[2] = router_10_14_to_router_10_15_rsp;
    assign router_10_15_rsp_in[3] = router_9_15_to_router_10_15_rsp;
    assign router_10_15_rsp_in[4] = magia_tile_ni_10_15_to_router_10_15_rsp;

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
) router_10_15 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 11, y: 15, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_10_15_req_in),
  .floo_rsp_o (router_10_15_rsp_out),
  .floo_req_o (router_10_15_req_out),
  .floo_rsp_i (router_10_15_rsp_in)
);


floo_req_t [4:0] router_11_0_req_in;
floo_rsp_t [4:0] router_11_0_rsp_out;
floo_req_t [4:0] router_11_0_req_out;
floo_rsp_t [4:0] router_11_0_rsp_in;

    assign router_11_0_req_in[0] = router_11_1_to_router_11_0_req;
    assign router_11_0_req_in[1] = router_12_0_to_router_11_0_req;
    assign router_11_0_req_in[2] = '0;
    assign router_11_0_req_in[3] = router_10_0_to_router_11_0_req;
    assign router_11_0_req_in[4] = magia_tile_ni_11_0_to_router_11_0_req;

    assign router_11_0_to_router_11_1_rsp = router_11_0_rsp_out[0];
    assign router_11_0_to_router_12_0_rsp = router_11_0_rsp_out[1];
    assign router_11_0_to_router_10_0_rsp = router_11_0_rsp_out[3];
    assign router_11_0_to_magia_tile_ni_11_0_rsp = router_11_0_rsp_out[4];

    assign router_11_0_to_router_11_1_req = router_11_0_req_out[0];
    assign router_11_0_to_router_12_0_req = router_11_0_req_out[1];
    assign router_11_0_to_router_10_0_req = router_11_0_req_out[3];
    assign router_11_0_to_magia_tile_ni_11_0_req = router_11_0_req_out[4];

    assign router_11_0_rsp_in[0] = router_11_1_to_router_11_0_rsp;
    assign router_11_0_rsp_in[1] = router_12_0_to_router_11_0_rsp;
    assign router_11_0_rsp_in[2] = '0;
    assign router_11_0_rsp_in[3] = router_10_0_to_router_11_0_rsp;
    assign router_11_0_rsp_in[4] = magia_tile_ni_11_0_to_router_11_0_rsp;

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
) router_11_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 12, y: 0, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_11_0_req_in),
  .floo_rsp_o (router_11_0_rsp_out),
  .floo_req_o (router_11_0_req_out),
  .floo_rsp_i (router_11_0_rsp_in)
);


floo_req_t [4:0] router_11_1_req_in;
floo_rsp_t [4:0] router_11_1_rsp_out;
floo_req_t [4:0] router_11_1_req_out;
floo_rsp_t [4:0] router_11_1_rsp_in;

    assign router_11_1_req_in[0] = router_11_2_to_router_11_1_req;
    assign router_11_1_req_in[1] = router_12_1_to_router_11_1_req;
    assign router_11_1_req_in[2] = router_11_0_to_router_11_1_req;
    assign router_11_1_req_in[3] = router_10_1_to_router_11_1_req;
    assign router_11_1_req_in[4] = magia_tile_ni_11_1_to_router_11_1_req;

    assign router_11_1_to_router_11_2_rsp = router_11_1_rsp_out[0];
    assign router_11_1_to_router_12_1_rsp = router_11_1_rsp_out[1];
    assign router_11_1_to_router_11_0_rsp = router_11_1_rsp_out[2];
    assign router_11_1_to_router_10_1_rsp = router_11_1_rsp_out[3];
    assign router_11_1_to_magia_tile_ni_11_1_rsp = router_11_1_rsp_out[4];

    assign router_11_1_to_router_11_2_req = router_11_1_req_out[0];
    assign router_11_1_to_router_12_1_req = router_11_1_req_out[1];
    assign router_11_1_to_router_11_0_req = router_11_1_req_out[2];
    assign router_11_1_to_router_10_1_req = router_11_1_req_out[3];
    assign router_11_1_to_magia_tile_ni_11_1_req = router_11_1_req_out[4];

    assign router_11_1_rsp_in[0] = router_11_2_to_router_11_1_rsp;
    assign router_11_1_rsp_in[1] = router_12_1_to_router_11_1_rsp;
    assign router_11_1_rsp_in[2] = router_11_0_to_router_11_1_rsp;
    assign router_11_1_rsp_in[3] = router_10_1_to_router_11_1_rsp;
    assign router_11_1_rsp_in[4] = magia_tile_ni_11_1_to_router_11_1_rsp;

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
) router_11_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 12, y: 1, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_11_1_req_in),
  .floo_rsp_o (router_11_1_rsp_out),
  .floo_req_o (router_11_1_req_out),
  .floo_rsp_i (router_11_1_rsp_in)
);


floo_req_t [4:0] router_11_2_req_in;
floo_rsp_t [4:0] router_11_2_rsp_out;
floo_req_t [4:0] router_11_2_req_out;
floo_rsp_t [4:0] router_11_2_rsp_in;

    assign router_11_2_req_in[0] = router_11_3_to_router_11_2_req;
    assign router_11_2_req_in[1] = router_12_2_to_router_11_2_req;
    assign router_11_2_req_in[2] = router_11_1_to_router_11_2_req;
    assign router_11_2_req_in[3] = router_10_2_to_router_11_2_req;
    assign router_11_2_req_in[4] = magia_tile_ni_11_2_to_router_11_2_req;

    assign router_11_2_to_router_11_3_rsp = router_11_2_rsp_out[0];
    assign router_11_2_to_router_12_2_rsp = router_11_2_rsp_out[1];
    assign router_11_2_to_router_11_1_rsp = router_11_2_rsp_out[2];
    assign router_11_2_to_router_10_2_rsp = router_11_2_rsp_out[3];
    assign router_11_2_to_magia_tile_ni_11_2_rsp = router_11_2_rsp_out[4];

    assign router_11_2_to_router_11_3_req = router_11_2_req_out[0];
    assign router_11_2_to_router_12_2_req = router_11_2_req_out[1];
    assign router_11_2_to_router_11_1_req = router_11_2_req_out[2];
    assign router_11_2_to_router_10_2_req = router_11_2_req_out[3];
    assign router_11_2_to_magia_tile_ni_11_2_req = router_11_2_req_out[4];

    assign router_11_2_rsp_in[0] = router_11_3_to_router_11_2_rsp;
    assign router_11_2_rsp_in[1] = router_12_2_to_router_11_2_rsp;
    assign router_11_2_rsp_in[2] = router_11_1_to_router_11_2_rsp;
    assign router_11_2_rsp_in[3] = router_10_2_to_router_11_2_rsp;
    assign router_11_2_rsp_in[4] = magia_tile_ni_11_2_to_router_11_2_rsp;

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
) router_11_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 12, y: 2, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_11_2_req_in),
  .floo_rsp_o (router_11_2_rsp_out),
  .floo_req_o (router_11_2_req_out),
  .floo_rsp_i (router_11_2_rsp_in)
);


floo_req_t [4:0] router_11_3_req_in;
floo_rsp_t [4:0] router_11_3_rsp_out;
floo_req_t [4:0] router_11_3_req_out;
floo_rsp_t [4:0] router_11_3_rsp_in;

    assign router_11_3_req_in[0] = router_11_4_to_router_11_3_req;
    assign router_11_3_req_in[1] = router_12_3_to_router_11_3_req;
    assign router_11_3_req_in[2] = router_11_2_to_router_11_3_req;
    assign router_11_3_req_in[3] = router_10_3_to_router_11_3_req;
    assign router_11_3_req_in[4] = magia_tile_ni_11_3_to_router_11_3_req;

    assign router_11_3_to_router_11_4_rsp = router_11_3_rsp_out[0];
    assign router_11_3_to_router_12_3_rsp = router_11_3_rsp_out[1];
    assign router_11_3_to_router_11_2_rsp = router_11_3_rsp_out[2];
    assign router_11_3_to_router_10_3_rsp = router_11_3_rsp_out[3];
    assign router_11_3_to_magia_tile_ni_11_3_rsp = router_11_3_rsp_out[4];

    assign router_11_3_to_router_11_4_req = router_11_3_req_out[0];
    assign router_11_3_to_router_12_3_req = router_11_3_req_out[1];
    assign router_11_3_to_router_11_2_req = router_11_3_req_out[2];
    assign router_11_3_to_router_10_3_req = router_11_3_req_out[3];
    assign router_11_3_to_magia_tile_ni_11_3_req = router_11_3_req_out[4];

    assign router_11_3_rsp_in[0] = router_11_4_to_router_11_3_rsp;
    assign router_11_3_rsp_in[1] = router_12_3_to_router_11_3_rsp;
    assign router_11_3_rsp_in[2] = router_11_2_to_router_11_3_rsp;
    assign router_11_3_rsp_in[3] = router_10_3_to_router_11_3_rsp;
    assign router_11_3_rsp_in[4] = magia_tile_ni_11_3_to_router_11_3_rsp;

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
) router_11_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 12, y: 3, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_11_3_req_in),
  .floo_rsp_o (router_11_3_rsp_out),
  .floo_req_o (router_11_3_req_out),
  .floo_rsp_i (router_11_3_rsp_in)
);


floo_req_t [4:0] router_11_4_req_in;
floo_rsp_t [4:0] router_11_4_rsp_out;
floo_req_t [4:0] router_11_4_req_out;
floo_rsp_t [4:0] router_11_4_rsp_in;

    assign router_11_4_req_in[0] = router_11_5_to_router_11_4_req;
    assign router_11_4_req_in[1] = router_12_4_to_router_11_4_req;
    assign router_11_4_req_in[2] = router_11_3_to_router_11_4_req;
    assign router_11_4_req_in[3] = router_10_4_to_router_11_4_req;
    assign router_11_4_req_in[4] = magia_tile_ni_11_4_to_router_11_4_req;

    assign router_11_4_to_router_11_5_rsp = router_11_4_rsp_out[0];
    assign router_11_4_to_router_12_4_rsp = router_11_4_rsp_out[1];
    assign router_11_4_to_router_11_3_rsp = router_11_4_rsp_out[2];
    assign router_11_4_to_router_10_4_rsp = router_11_4_rsp_out[3];
    assign router_11_4_to_magia_tile_ni_11_4_rsp = router_11_4_rsp_out[4];

    assign router_11_4_to_router_11_5_req = router_11_4_req_out[0];
    assign router_11_4_to_router_12_4_req = router_11_4_req_out[1];
    assign router_11_4_to_router_11_3_req = router_11_4_req_out[2];
    assign router_11_4_to_router_10_4_req = router_11_4_req_out[3];
    assign router_11_4_to_magia_tile_ni_11_4_req = router_11_4_req_out[4];

    assign router_11_4_rsp_in[0] = router_11_5_to_router_11_4_rsp;
    assign router_11_4_rsp_in[1] = router_12_4_to_router_11_4_rsp;
    assign router_11_4_rsp_in[2] = router_11_3_to_router_11_4_rsp;
    assign router_11_4_rsp_in[3] = router_10_4_to_router_11_4_rsp;
    assign router_11_4_rsp_in[4] = magia_tile_ni_11_4_to_router_11_4_rsp;

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
) router_11_4 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 12, y: 4, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_11_4_req_in),
  .floo_rsp_o (router_11_4_rsp_out),
  .floo_req_o (router_11_4_req_out),
  .floo_rsp_i (router_11_4_rsp_in)
);


floo_req_t [4:0] router_11_5_req_in;
floo_rsp_t [4:0] router_11_5_rsp_out;
floo_req_t [4:0] router_11_5_req_out;
floo_rsp_t [4:0] router_11_5_rsp_in;

    assign router_11_5_req_in[0] = router_11_6_to_router_11_5_req;
    assign router_11_5_req_in[1] = router_12_5_to_router_11_5_req;
    assign router_11_5_req_in[2] = router_11_4_to_router_11_5_req;
    assign router_11_5_req_in[3] = router_10_5_to_router_11_5_req;
    assign router_11_5_req_in[4] = magia_tile_ni_11_5_to_router_11_5_req;

    assign router_11_5_to_router_11_6_rsp = router_11_5_rsp_out[0];
    assign router_11_5_to_router_12_5_rsp = router_11_5_rsp_out[1];
    assign router_11_5_to_router_11_4_rsp = router_11_5_rsp_out[2];
    assign router_11_5_to_router_10_5_rsp = router_11_5_rsp_out[3];
    assign router_11_5_to_magia_tile_ni_11_5_rsp = router_11_5_rsp_out[4];

    assign router_11_5_to_router_11_6_req = router_11_5_req_out[0];
    assign router_11_5_to_router_12_5_req = router_11_5_req_out[1];
    assign router_11_5_to_router_11_4_req = router_11_5_req_out[2];
    assign router_11_5_to_router_10_5_req = router_11_5_req_out[3];
    assign router_11_5_to_magia_tile_ni_11_5_req = router_11_5_req_out[4];

    assign router_11_5_rsp_in[0] = router_11_6_to_router_11_5_rsp;
    assign router_11_5_rsp_in[1] = router_12_5_to_router_11_5_rsp;
    assign router_11_5_rsp_in[2] = router_11_4_to_router_11_5_rsp;
    assign router_11_5_rsp_in[3] = router_10_5_to_router_11_5_rsp;
    assign router_11_5_rsp_in[4] = magia_tile_ni_11_5_to_router_11_5_rsp;

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
) router_11_5 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 12, y: 5, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_11_5_req_in),
  .floo_rsp_o (router_11_5_rsp_out),
  .floo_req_o (router_11_5_req_out),
  .floo_rsp_i (router_11_5_rsp_in)
);


floo_req_t [4:0] router_11_6_req_in;
floo_rsp_t [4:0] router_11_6_rsp_out;
floo_req_t [4:0] router_11_6_req_out;
floo_rsp_t [4:0] router_11_6_rsp_in;

    assign router_11_6_req_in[0] = router_11_7_to_router_11_6_req;
    assign router_11_6_req_in[1] = router_12_6_to_router_11_6_req;
    assign router_11_6_req_in[2] = router_11_5_to_router_11_6_req;
    assign router_11_6_req_in[3] = router_10_6_to_router_11_6_req;
    assign router_11_6_req_in[4] = magia_tile_ni_11_6_to_router_11_6_req;

    assign router_11_6_to_router_11_7_rsp = router_11_6_rsp_out[0];
    assign router_11_6_to_router_12_6_rsp = router_11_6_rsp_out[1];
    assign router_11_6_to_router_11_5_rsp = router_11_6_rsp_out[2];
    assign router_11_6_to_router_10_6_rsp = router_11_6_rsp_out[3];
    assign router_11_6_to_magia_tile_ni_11_6_rsp = router_11_6_rsp_out[4];

    assign router_11_6_to_router_11_7_req = router_11_6_req_out[0];
    assign router_11_6_to_router_12_6_req = router_11_6_req_out[1];
    assign router_11_6_to_router_11_5_req = router_11_6_req_out[2];
    assign router_11_6_to_router_10_6_req = router_11_6_req_out[3];
    assign router_11_6_to_magia_tile_ni_11_6_req = router_11_6_req_out[4];

    assign router_11_6_rsp_in[0] = router_11_7_to_router_11_6_rsp;
    assign router_11_6_rsp_in[1] = router_12_6_to_router_11_6_rsp;
    assign router_11_6_rsp_in[2] = router_11_5_to_router_11_6_rsp;
    assign router_11_6_rsp_in[3] = router_10_6_to_router_11_6_rsp;
    assign router_11_6_rsp_in[4] = magia_tile_ni_11_6_to_router_11_6_rsp;

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
) router_11_6 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 12, y: 6, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_11_6_req_in),
  .floo_rsp_o (router_11_6_rsp_out),
  .floo_req_o (router_11_6_req_out),
  .floo_rsp_i (router_11_6_rsp_in)
);


floo_req_t [4:0] router_11_7_req_in;
floo_rsp_t [4:0] router_11_7_rsp_out;
floo_req_t [4:0] router_11_7_req_out;
floo_rsp_t [4:0] router_11_7_rsp_in;

    assign router_11_7_req_in[0] = router_11_8_to_router_11_7_req;
    assign router_11_7_req_in[1] = router_12_7_to_router_11_7_req;
    assign router_11_7_req_in[2] = router_11_6_to_router_11_7_req;
    assign router_11_7_req_in[3] = router_10_7_to_router_11_7_req;
    assign router_11_7_req_in[4] = magia_tile_ni_11_7_to_router_11_7_req;

    assign router_11_7_to_router_11_8_rsp = router_11_7_rsp_out[0];
    assign router_11_7_to_router_12_7_rsp = router_11_7_rsp_out[1];
    assign router_11_7_to_router_11_6_rsp = router_11_7_rsp_out[2];
    assign router_11_7_to_router_10_7_rsp = router_11_7_rsp_out[3];
    assign router_11_7_to_magia_tile_ni_11_7_rsp = router_11_7_rsp_out[4];

    assign router_11_7_to_router_11_8_req = router_11_7_req_out[0];
    assign router_11_7_to_router_12_7_req = router_11_7_req_out[1];
    assign router_11_7_to_router_11_6_req = router_11_7_req_out[2];
    assign router_11_7_to_router_10_7_req = router_11_7_req_out[3];
    assign router_11_7_to_magia_tile_ni_11_7_req = router_11_7_req_out[4];

    assign router_11_7_rsp_in[0] = router_11_8_to_router_11_7_rsp;
    assign router_11_7_rsp_in[1] = router_12_7_to_router_11_7_rsp;
    assign router_11_7_rsp_in[2] = router_11_6_to_router_11_7_rsp;
    assign router_11_7_rsp_in[3] = router_10_7_to_router_11_7_rsp;
    assign router_11_7_rsp_in[4] = magia_tile_ni_11_7_to_router_11_7_rsp;

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
) router_11_7 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 12, y: 7, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_11_7_req_in),
  .floo_rsp_o (router_11_7_rsp_out),
  .floo_req_o (router_11_7_req_out),
  .floo_rsp_i (router_11_7_rsp_in)
);


floo_req_t [4:0] router_11_8_req_in;
floo_rsp_t [4:0] router_11_8_rsp_out;
floo_req_t [4:0] router_11_8_req_out;
floo_rsp_t [4:0] router_11_8_rsp_in;

    assign router_11_8_req_in[0] = router_11_9_to_router_11_8_req;
    assign router_11_8_req_in[1] = router_12_8_to_router_11_8_req;
    assign router_11_8_req_in[2] = router_11_7_to_router_11_8_req;
    assign router_11_8_req_in[3] = router_10_8_to_router_11_8_req;
    assign router_11_8_req_in[4] = magia_tile_ni_11_8_to_router_11_8_req;

    assign router_11_8_to_router_11_9_rsp = router_11_8_rsp_out[0];
    assign router_11_8_to_router_12_8_rsp = router_11_8_rsp_out[1];
    assign router_11_8_to_router_11_7_rsp = router_11_8_rsp_out[2];
    assign router_11_8_to_router_10_8_rsp = router_11_8_rsp_out[3];
    assign router_11_8_to_magia_tile_ni_11_8_rsp = router_11_8_rsp_out[4];

    assign router_11_8_to_router_11_9_req = router_11_8_req_out[0];
    assign router_11_8_to_router_12_8_req = router_11_8_req_out[1];
    assign router_11_8_to_router_11_7_req = router_11_8_req_out[2];
    assign router_11_8_to_router_10_8_req = router_11_8_req_out[3];
    assign router_11_8_to_magia_tile_ni_11_8_req = router_11_8_req_out[4];

    assign router_11_8_rsp_in[0] = router_11_9_to_router_11_8_rsp;
    assign router_11_8_rsp_in[1] = router_12_8_to_router_11_8_rsp;
    assign router_11_8_rsp_in[2] = router_11_7_to_router_11_8_rsp;
    assign router_11_8_rsp_in[3] = router_10_8_to_router_11_8_rsp;
    assign router_11_8_rsp_in[4] = magia_tile_ni_11_8_to_router_11_8_rsp;

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
) router_11_8 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 12, y: 8, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_11_8_req_in),
  .floo_rsp_o (router_11_8_rsp_out),
  .floo_req_o (router_11_8_req_out),
  .floo_rsp_i (router_11_8_rsp_in)
);


floo_req_t [4:0] router_11_9_req_in;
floo_rsp_t [4:0] router_11_9_rsp_out;
floo_req_t [4:0] router_11_9_req_out;
floo_rsp_t [4:0] router_11_9_rsp_in;

    assign router_11_9_req_in[0] = router_11_10_to_router_11_9_req;
    assign router_11_9_req_in[1] = router_12_9_to_router_11_9_req;
    assign router_11_9_req_in[2] = router_11_8_to_router_11_9_req;
    assign router_11_9_req_in[3] = router_10_9_to_router_11_9_req;
    assign router_11_9_req_in[4] = magia_tile_ni_11_9_to_router_11_9_req;

    assign router_11_9_to_router_11_10_rsp = router_11_9_rsp_out[0];
    assign router_11_9_to_router_12_9_rsp = router_11_9_rsp_out[1];
    assign router_11_9_to_router_11_8_rsp = router_11_9_rsp_out[2];
    assign router_11_9_to_router_10_9_rsp = router_11_9_rsp_out[3];
    assign router_11_9_to_magia_tile_ni_11_9_rsp = router_11_9_rsp_out[4];

    assign router_11_9_to_router_11_10_req = router_11_9_req_out[0];
    assign router_11_9_to_router_12_9_req = router_11_9_req_out[1];
    assign router_11_9_to_router_11_8_req = router_11_9_req_out[2];
    assign router_11_9_to_router_10_9_req = router_11_9_req_out[3];
    assign router_11_9_to_magia_tile_ni_11_9_req = router_11_9_req_out[4];

    assign router_11_9_rsp_in[0] = router_11_10_to_router_11_9_rsp;
    assign router_11_9_rsp_in[1] = router_12_9_to_router_11_9_rsp;
    assign router_11_9_rsp_in[2] = router_11_8_to_router_11_9_rsp;
    assign router_11_9_rsp_in[3] = router_10_9_to_router_11_9_rsp;
    assign router_11_9_rsp_in[4] = magia_tile_ni_11_9_to_router_11_9_rsp;

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
) router_11_9 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 12, y: 9, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_11_9_req_in),
  .floo_rsp_o (router_11_9_rsp_out),
  .floo_req_o (router_11_9_req_out),
  .floo_rsp_i (router_11_9_rsp_in)
);


floo_req_t [4:0] router_11_10_req_in;
floo_rsp_t [4:0] router_11_10_rsp_out;
floo_req_t [4:0] router_11_10_req_out;
floo_rsp_t [4:0] router_11_10_rsp_in;

    assign router_11_10_req_in[0] = router_11_11_to_router_11_10_req;
    assign router_11_10_req_in[1] = router_12_10_to_router_11_10_req;
    assign router_11_10_req_in[2] = router_11_9_to_router_11_10_req;
    assign router_11_10_req_in[3] = router_10_10_to_router_11_10_req;
    assign router_11_10_req_in[4] = magia_tile_ni_11_10_to_router_11_10_req;

    assign router_11_10_to_router_11_11_rsp = router_11_10_rsp_out[0];
    assign router_11_10_to_router_12_10_rsp = router_11_10_rsp_out[1];
    assign router_11_10_to_router_11_9_rsp = router_11_10_rsp_out[2];
    assign router_11_10_to_router_10_10_rsp = router_11_10_rsp_out[3];
    assign router_11_10_to_magia_tile_ni_11_10_rsp = router_11_10_rsp_out[4];

    assign router_11_10_to_router_11_11_req = router_11_10_req_out[0];
    assign router_11_10_to_router_12_10_req = router_11_10_req_out[1];
    assign router_11_10_to_router_11_9_req = router_11_10_req_out[2];
    assign router_11_10_to_router_10_10_req = router_11_10_req_out[3];
    assign router_11_10_to_magia_tile_ni_11_10_req = router_11_10_req_out[4];

    assign router_11_10_rsp_in[0] = router_11_11_to_router_11_10_rsp;
    assign router_11_10_rsp_in[1] = router_12_10_to_router_11_10_rsp;
    assign router_11_10_rsp_in[2] = router_11_9_to_router_11_10_rsp;
    assign router_11_10_rsp_in[3] = router_10_10_to_router_11_10_rsp;
    assign router_11_10_rsp_in[4] = magia_tile_ni_11_10_to_router_11_10_rsp;

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
) router_11_10 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 12, y: 10, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_11_10_req_in),
  .floo_rsp_o (router_11_10_rsp_out),
  .floo_req_o (router_11_10_req_out),
  .floo_rsp_i (router_11_10_rsp_in)
);


floo_req_t [4:0] router_11_11_req_in;
floo_rsp_t [4:0] router_11_11_rsp_out;
floo_req_t [4:0] router_11_11_req_out;
floo_rsp_t [4:0] router_11_11_rsp_in;

    assign router_11_11_req_in[0] = router_11_12_to_router_11_11_req;
    assign router_11_11_req_in[1] = router_12_11_to_router_11_11_req;
    assign router_11_11_req_in[2] = router_11_10_to_router_11_11_req;
    assign router_11_11_req_in[3] = router_10_11_to_router_11_11_req;
    assign router_11_11_req_in[4] = magia_tile_ni_11_11_to_router_11_11_req;

    assign router_11_11_to_router_11_12_rsp = router_11_11_rsp_out[0];
    assign router_11_11_to_router_12_11_rsp = router_11_11_rsp_out[1];
    assign router_11_11_to_router_11_10_rsp = router_11_11_rsp_out[2];
    assign router_11_11_to_router_10_11_rsp = router_11_11_rsp_out[3];
    assign router_11_11_to_magia_tile_ni_11_11_rsp = router_11_11_rsp_out[4];

    assign router_11_11_to_router_11_12_req = router_11_11_req_out[0];
    assign router_11_11_to_router_12_11_req = router_11_11_req_out[1];
    assign router_11_11_to_router_11_10_req = router_11_11_req_out[2];
    assign router_11_11_to_router_10_11_req = router_11_11_req_out[3];
    assign router_11_11_to_magia_tile_ni_11_11_req = router_11_11_req_out[4];

    assign router_11_11_rsp_in[0] = router_11_12_to_router_11_11_rsp;
    assign router_11_11_rsp_in[1] = router_12_11_to_router_11_11_rsp;
    assign router_11_11_rsp_in[2] = router_11_10_to_router_11_11_rsp;
    assign router_11_11_rsp_in[3] = router_10_11_to_router_11_11_rsp;
    assign router_11_11_rsp_in[4] = magia_tile_ni_11_11_to_router_11_11_rsp;

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
) router_11_11 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 12, y: 11, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_11_11_req_in),
  .floo_rsp_o (router_11_11_rsp_out),
  .floo_req_o (router_11_11_req_out),
  .floo_rsp_i (router_11_11_rsp_in)
);


floo_req_t [4:0] router_11_12_req_in;
floo_rsp_t [4:0] router_11_12_rsp_out;
floo_req_t [4:0] router_11_12_req_out;
floo_rsp_t [4:0] router_11_12_rsp_in;

    assign router_11_12_req_in[0] = router_11_13_to_router_11_12_req;
    assign router_11_12_req_in[1] = router_12_12_to_router_11_12_req;
    assign router_11_12_req_in[2] = router_11_11_to_router_11_12_req;
    assign router_11_12_req_in[3] = router_10_12_to_router_11_12_req;
    assign router_11_12_req_in[4] = magia_tile_ni_11_12_to_router_11_12_req;

    assign router_11_12_to_router_11_13_rsp = router_11_12_rsp_out[0];
    assign router_11_12_to_router_12_12_rsp = router_11_12_rsp_out[1];
    assign router_11_12_to_router_11_11_rsp = router_11_12_rsp_out[2];
    assign router_11_12_to_router_10_12_rsp = router_11_12_rsp_out[3];
    assign router_11_12_to_magia_tile_ni_11_12_rsp = router_11_12_rsp_out[4];

    assign router_11_12_to_router_11_13_req = router_11_12_req_out[0];
    assign router_11_12_to_router_12_12_req = router_11_12_req_out[1];
    assign router_11_12_to_router_11_11_req = router_11_12_req_out[2];
    assign router_11_12_to_router_10_12_req = router_11_12_req_out[3];
    assign router_11_12_to_magia_tile_ni_11_12_req = router_11_12_req_out[4];

    assign router_11_12_rsp_in[0] = router_11_13_to_router_11_12_rsp;
    assign router_11_12_rsp_in[1] = router_12_12_to_router_11_12_rsp;
    assign router_11_12_rsp_in[2] = router_11_11_to_router_11_12_rsp;
    assign router_11_12_rsp_in[3] = router_10_12_to_router_11_12_rsp;
    assign router_11_12_rsp_in[4] = magia_tile_ni_11_12_to_router_11_12_rsp;

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
) router_11_12 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 12, y: 12, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_11_12_req_in),
  .floo_rsp_o (router_11_12_rsp_out),
  .floo_req_o (router_11_12_req_out),
  .floo_rsp_i (router_11_12_rsp_in)
);


floo_req_t [4:0] router_11_13_req_in;
floo_rsp_t [4:0] router_11_13_rsp_out;
floo_req_t [4:0] router_11_13_req_out;
floo_rsp_t [4:0] router_11_13_rsp_in;

    assign router_11_13_req_in[0] = router_11_14_to_router_11_13_req;
    assign router_11_13_req_in[1] = router_12_13_to_router_11_13_req;
    assign router_11_13_req_in[2] = router_11_12_to_router_11_13_req;
    assign router_11_13_req_in[3] = router_10_13_to_router_11_13_req;
    assign router_11_13_req_in[4] = magia_tile_ni_11_13_to_router_11_13_req;

    assign router_11_13_to_router_11_14_rsp = router_11_13_rsp_out[0];
    assign router_11_13_to_router_12_13_rsp = router_11_13_rsp_out[1];
    assign router_11_13_to_router_11_12_rsp = router_11_13_rsp_out[2];
    assign router_11_13_to_router_10_13_rsp = router_11_13_rsp_out[3];
    assign router_11_13_to_magia_tile_ni_11_13_rsp = router_11_13_rsp_out[4];

    assign router_11_13_to_router_11_14_req = router_11_13_req_out[0];
    assign router_11_13_to_router_12_13_req = router_11_13_req_out[1];
    assign router_11_13_to_router_11_12_req = router_11_13_req_out[2];
    assign router_11_13_to_router_10_13_req = router_11_13_req_out[3];
    assign router_11_13_to_magia_tile_ni_11_13_req = router_11_13_req_out[4];

    assign router_11_13_rsp_in[0] = router_11_14_to_router_11_13_rsp;
    assign router_11_13_rsp_in[1] = router_12_13_to_router_11_13_rsp;
    assign router_11_13_rsp_in[2] = router_11_12_to_router_11_13_rsp;
    assign router_11_13_rsp_in[3] = router_10_13_to_router_11_13_rsp;
    assign router_11_13_rsp_in[4] = magia_tile_ni_11_13_to_router_11_13_rsp;

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
) router_11_13 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 12, y: 13, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_11_13_req_in),
  .floo_rsp_o (router_11_13_rsp_out),
  .floo_req_o (router_11_13_req_out),
  .floo_rsp_i (router_11_13_rsp_in)
);


floo_req_t [4:0] router_11_14_req_in;
floo_rsp_t [4:0] router_11_14_rsp_out;
floo_req_t [4:0] router_11_14_req_out;
floo_rsp_t [4:0] router_11_14_rsp_in;

    assign router_11_14_req_in[0] = router_11_15_to_router_11_14_req;
    assign router_11_14_req_in[1] = router_12_14_to_router_11_14_req;
    assign router_11_14_req_in[2] = router_11_13_to_router_11_14_req;
    assign router_11_14_req_in[3] = router_10_14_to_router_11_14_req;
    assign router_11_14_req_in[4] = magia_tile_ni_11_14_to_router_11_14_req;

    assign router_11_14_to_router_11_15_rsp = router_11_14_rsp_out[0];
    assign router_11_14_to_router_12_14_rsp = router_11_14_rsp_out[1];
    assign router_11_14_to_router_11_13_rsp = router_11_14_rsp_out[2];
    assign router_11_14_to_router_10_14_rsp = router_11_14_rsp_out[3];
    assign router_11_14_to_magia_tile_ni_11_14_rsp = router_11_14_rsp_out[4];

    assign router_11_14_to_router_11_15_req = router_11_14_req_out[0];
    assign router_11_14_to_router_12_14_req = router_11_14_req_out[1];
    assign router_11_14_to_router_11_13_req = router_11_14_req_out[2];
    assign router_11_14_to_router_10_14_req = router_11_14_req_out[3];
    assign router_11_14_to_magia_tile_ni_11_14_req = router_11_14_req_out[4];

    assign router_11_14_rsp_in[0] = router_11_15_to_router_11_14_rsp;
    assign router_11_14_rsp_in[1] = router_12_14_to_router_11_14_rsp;
    assign router_11_14_rsp_in[2] = router_11_13_to_router_11_14_rsp;
    assign router_11_14_rsp_in[3] = router_10_14_to_router_11_14_rsp;
    assign router_11_14_rsp_in[4] = magia_tile_ni_11_14_to_router_11_14_rsp;

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
) router_11_14 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 12, y: 14, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_11_14_req_in),
  .floo_rsp_o (router_11_14_rsp_out),
  .floo_req_o (router_11_14_req_out),
  .floo_rsp_i (router_11_14_rsp_in)
);


floo_req_t [4:0] router_11_15_req_in;
floo_rsp_t [4:0] router_11_15_rsp_out;
floo_req_t [4:0] router_11_15_req_out;
floo_rsp_t [4:0] router_11_15_rsp_in;

    assign router_11_15_req_in[0] = '0;
    assign router_11_15_req_in[1] = router_12_15_to_router_11_15_req;
    assign router_11_15_req_in[2] = router_11_14_to_router_11_15_req;
    assign router_11_15_req_in[3] = router_10_15_to_router_11_15_req;
    assign router_11_15_req_in[4] = magia_tile_ni_11_15_to_router_11_15_req;

    assign router_11_15_to_router_12_15_rsp = router_11_15_rsp_out[1];
    assign router_11_15_to_router_11_14_rsp = router_11_15_rsp_out[2];
    assign router_11_15_to_router_10_15_rsp = router_11_15_rsp_out[3];
    assign router_11_15_to_magia_tile_ni_11_15_rsp = router_11_15_rsp_out[4];

    assign router_11_15_to_router_12_15_req = router_11_15_req_out[1];
    assign router_11_15_to_router_11_14_req = router_11_15_req_out[2];
    assign router_11_15_to_router_10_15_req = router_11_15_req_out[3];
    assign router_11_15_to_magia_tile_ni_11_15_req = router_11_15_req_out[4];

    assign router_11_15_rsp_in[0] = '0;
    assign router_11_15_rsp_in[1] = router_12_15_to_router_11_15_rsp;
    assign router_11_15_rsp_in[2] = router_11_14_to_router_11_15_rsp;
    assign router_11_15_rsp_in[3] = router_10_15_to_router_11_15_rsp;
    assign router_11_15_rsp_in[4] = magia_tile_ni_11_15_to_router_11_15_rsp;

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
) router_11_15 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 12, y: 15, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_11_15_req_in),
  .floo_rsp_o (router_11_15_rsp_out),
  .floo_req_o (router_11_15_req_out),
  .floo_rsp_i (router_11_15_rsp_in)
);


floo_req_t [4:0] router_12_0_req_in;
floo_rsp_t [4:0] router_12_0_rsp_out;
floo_req_t [4:0] router_12_0_req_out;
floo_rsp_t [4:0] router_12_0_rsp_in;

    assign router_12_0_req_in[0] = router_12_1_to_router_12_0_req;
    assign router_12_0_req_in[1] = router_13_0_to_router_12_0_req;
    assign router_12_0_req_in[2] = '0;
    assign router_12_0_req_in[3] = router_11_0_to_router_12_0_req;
    assign router_12_0_req_in[4] = magia_tile_ni_12_0_to_router_12_0_req;

    assign router_12_0_to_router_12_1_rsp = router_12_0_rsp_out[0];
    assign router_12_0_to_router_13_0_rsp = router_12_0_rsp_out[1];
    assign router_12_0_to_router_11_0_rsp = router_12_0_rsp_out[3];
    assign router_12_0_to_magia_tile_ni_12_0_rsp = router_12_0_rsp_out[4];

    assign router_12_0_to_router_12_1_req = router_12_0_req_out[0];
    assign router_12_0_to_router_13_0_req = router_12_0_req_out[1];
    assign router_12_0_to_router_11_0_req = router_12_0_req_out[3];
    assign router_12_0_to_magia_tile_ni_12_0_req = router_12_0_req_out[4];

    assign router_12_0_rsp_in[0] = router_12_1_to_router_12_0_rsp;
    assign router_12_0_rsp_in[1] = router_13_0_to_router_12_0_rsp;
    assign router_12_0_rsp_in[2] = '0;
    assign router_12_0_rsp_in[3] = router_11_0_to_router_12_0_rsp;
    assign router_12_0_rsp_in[4] = magia_tile_ni_12_0_to_router_12_0_rsp;

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
) router_12_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 13, y: 0, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_12_0_req_in),
  .floo_rsp_o (router_12_0_rsp_out),
  .floo_req_o (router_12_0_req_out),
  .floo_rsp_i (router_12_0_rsp_in)
);


floo_req_t [4:0] router_12_1_req_in;
floo_rsp_t [4:0] router_12_1_rsp_out;
floo_req_t [4:0] router_12_1_req_out;
floo_rsp_t [4:0] router_12_1_rsp_in;

    assign router_12_1_req_in[0] = router_12_2_to_router_12_1_req;
    assign router_12_1_req_in[1] = router_13_1_to_router_12_1_req;
    assign router_12_1_req_in[2] = router_12_0_to_router_12_1_req;
    assign router_12_1_req_in[3] = router_11_1_to_router_12_1_req;
    assign router_12_1_req_in[4] = magia_tile_ni_12_1_to_router_12_1_req;

    assign router_12_1_to_router_12_2_rsp = router_12_1_rsp_out[0];
    assign router_12_1_to_router_13_1_rsp = router_12_1_rsp_out[1];
    assign router_12_1_to_router_12_0_rsp = router_12_1_rsp_out[2];
    assign router_12_1_to_router_11_1_rsp = router_12_1_rsp_out[3];
    assign router_12_1_to_magia_tile_ni_12_1_rsp = router_12_1_rsp_out[4];

    assign router_12_1_to_router_12_2_req = router_12_1_req_out[0];
    assign router_12_1_to_router_13_1_req = router_12_1_req_out[1];
    assign router_12_1_to_router_12_0_req = router_12_1_req_out[2];
    assign router_12_1_to_router_11_1_req = router_12_1_req_out[3];
    assign router_12_1_to_magia_tile_ni_12_1_req = router_12_1_req_out[4];

    assign router_12_1_rsp_in[0] = router_12_2_to_router_12_1_rsp;
    assign router_12_1_rsp_in[1] = router_13_1_to_router_12_1_rsp;
    assign router_12_1_rsp_in[2] = router_12_0_to_router_12_1_rsp;
    assign router_12_1_rsp_in[3] = router_11_1_to_router_12_1_rsp;
    assign router_12_1_rsp_in[4] = magia_tile_ni_12_1_to_router_12_1_rsp;

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
) router_12_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 13, y: 1, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_12_1_req_in),
  .floo_rsp_o (router_12_1_rsp_out),
  .floo_req_o (router_12_1_req_out),
  .floo_rsp_i (router_12_1_rsp_in)
);


floo_req_t [4:0] router_12_2_req_in;
floo_rsp_t [4:0] router_12_2_rsp_out;
floo_req_t [4:0] router_12_2_req_out;
floo_rsp_t [4:0] router_12_2_rsp_in;

    assign router_12_2_req_in[0] = router_12_3_to_router_12_2_req;
    assign router_12_2_req_in[1] = router_13_2_to_router_12_2_req;
    assign router_12_2_req_in[2] = router_12_1_to_router_12_2_req;
    assign router_12_2_req_in[3] = router_11_2_to_router_12_2_req;
    assign router_12_2_req_in[4] = magia_tile_ni_12_2_to_router_12_2_req;

    assign router_12_2_to_router_12_3_rsp = router_12_2_rsp_out[0];
    assign router_12_2_to_router_13_2_rsp = router_12_2_rsp_out[1];
    assign router_12_2_to_router_12_1_rsp = router_12_2_rsp_out[2];
    assign router_12_2_to_router_11_2_rsp = router_12_2_rsp_out[3];
    assign router_12_2_to_magia_tile_ni_12_2_rsp = router_12_2_rsp_out[4];

    assign router_12_2_to_router_12_3_req = router_12_2_req_out[0];
    assign router_12_2_to_router_13_2_req = router_12_2_req_out[1];
    assign router_12_2_to_router_12_1_req = router_12_2_req_out[2];
    assign router_12_2_to_router_11_2_req = router_12_2_req_out[3];
    assign router_12_2_to_magia_tile_ni_12_2_req = router_12_2_req_out[4];

    assign router_12_2_rsp_in[0] = router_12_3_to_router_12_2_rsp;
    assign router_12_2_rsp_in[1] = router_13_2_to_router_12_2_rsp;
    assign router_12_2_rsp_in[2] = router_12_1_to_router_12_2_rsp;
    assign router_12_2_rsp_in[3] = router_11_2_to_router_12_2_rsp;
    assign router_12_2_rsp_in[4] = magia_tile_ni_12_2_to_router_12_2_rsp;

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
) router_12_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 13, y: 2, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_12_2_req_in),
  .floo_rsp_o (router_12_2_rsp_out),
  .floo_req_o (router_12_2_req_out),
  .floo_rsp_i (router_12_2_rsp_in)
);


floo_req_t [4:0] router_12_3_req_in;
floo_rsp_t [4:0] router_12_3_rsp_out;
floo_req_t [4:0] router_12_3_req_out;
floo_rsp_t [4:0] router_12_3_rsp_in;

    assign router_12_3_req_in[0] = router_12_4_to_router_12_3_req;
    assign router_12_3_req_in[1] = router_13_3_to_router_12_3_req;
    assign router_12_3_req_in[2] = router_12_2_to_router_12_3_req;
    assign router_12_3_req_in[3] = router_11_3_to_router_12_3_req;
    assign router_12_3_req_in[4] = magia_tile_ni_12_3_to_router_12_3_req;

    assign router_12_3_to_router_12_4_rsp = router_12_3_rsp_out[0];
    assign router_12_3_to_router_13_3_rsp = router_12_3_rsp_out[1];
    assign router_12_3_to_router_12_2_rsp = router_12_3_rsp_out[2];
    assign router_12_3_to_router_11_3_rsp = router_12_3_rsp_out[3];
    assign router_12_3_to_magia_tile_ni_12_3_rsp = router_12_3_rsp_out[4];

    assign router_12_3_to_router_12_4_req = router_12_3_req_out[0];
    assign router_12_3_to_router_13_3_req = router_12_3_req_out[1];
    assign router_12_3_to_router_12_2_req = router_12_3_req_out[2];
    assign router_12_3_to_router_11_3_req = router_12_3_req_out[3];
    assign router_12_3_to_magia_tile_ni_12_3_req = router_12_3_req_out[4];

    assign router_12_3_rsp_in[0] = router_12_4_to_router_12_3_rsp;
    assign router_12_3_rsp_in[1] = router_13_3_to_router_12_3_rsp;
    assign router_12_3_rsp_in[2] = router_12_2_to_router_12_3_rsp;
    assign router_12_3_rsp_in[3] = router_11_3_to_router_12_3_rsp;
    assign router_12_3_rsp_in[4] = magia_tile_ni_12_3_to_router_12_3_rsp;

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
) router_12_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 13, y: 3, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_12_3_req_in),
  .floo_rsp_o (router_12_3_rsp_out),
  .floo_req_o (router_12_3_req_out),
  .floo_rsp_i (router_12_3_rsp_in)
);


floo_req_t [4:0] router_12_4_req_in;
floo_rsp_t [4:0] router_12_4_rsp_out;
floo_req_t [4:0] router_12_4_req_out;
floo_rsp_t [4:0] router_12_4_rsp_in;

    assign router_12_4_req_in[0] = router_12_5_to_router_12_4_req;
    assign router_12_4_req_in[1] = router_13_4_to_router_12_4_req;
    assign router_12_4_req_in[2] = router_12_3_to_router_12_4_req;
    assign router_12_4_req_in[3] = router_11_4_to_router_12_4_req;
    assign router_12_4_req_in[4] = magia_tile_ni_12_4_to_router_12_4_req;

    assign router_12_4_to_router_12_5_rsp = router_12_4_rsp_out[0];
    assign router_12_4_to_router_13_4_rsp = router_12_4_rsp_out[1];
    assign router_12_4_to_router_12_3_rsp = router_12_4_rsp_out[2];
    assign router_12_4_to_router_11_4_rsp = router_12_4_rsp_out[3];
    assign router_12_4_to_magia_tile_ni_12_4_rsp = router_12_4_rsp_out[4];

    assign router_12_4_to_router_12_5_req = router_12_4_req_out[0];
    assign router_12_4_to_router_13_4_req = router_12_4_req_out[1];
    assign router_12_4_to_router_12_3_req = router_12_4_req_out[2];
    assign router_12_4_to_router_11_4_req = router_12_4_req_out[3];
    assign router_12_4_to_magia_tile_ni_12_4_req = router_12_4_req_out[4];

    assign router_12_4_rsp_in[0] = router_12_5_to_router_12_4_rsp;
    assign router_12_4_rsp_in[1] = router_13_4_to_router_12_4_rsp;
    assign router_12_4_rsp_in[2] = router_12_3_to_router_12_4_rsp;
    assign router_12_4_rsp_in[3] = router_11_4_to_router_12_4_rsp;
    assign router_12_4_rsp_in[4] = magia_tile_ni_12_4_to_router_12_4_rsp;

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
) router_12_4 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 13, y: 4, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_12_4_req_in),
  .floo_rsp_o (router_12_4_rsp_out),
  .floo_req_o (router_12_4_req_out),
  .floo_rsp_i (router_12_4_rsp_in)
);


floo_req_t [4:0] router_12_5_req_in;
floo_rsp_t [4:0] router_12_5_rsp_out;
floo_req_t [4:0] router_12_5_req_out;
floo_rsp_t [4:0] router_12_5_rsp_in;

    assign router_12_5_req_in[0] = router_12_6_to_router_12_5_req;
    assign router_12_5_req_in[1] = router_13_5_to_router_12_5_req;
    assign router_12_5_req_in[2] = router_12_4_to_router_12_5_req;
    assign router_12_5_req_in[3] = router_11_5_to_router_12_5_req;
    assign router_12_5_req_in[4] = magia_tile_ni_12_5_to_router_12_5_req;

    assign router_12_5_to_router_12_6_rsp = router_12_5_rsp_out[0];
    assign router_12_5_to_router_13_5_rsp = router_12_5_rsp_out[1];
    assign router_12_5_to_router_12_4_rsp = router_12_5_rsp_out[2];
    assign router_12_5_to_router_11_5_rsp = router_12_5_rsp_out[3];
    assign router_12_5_to_magia_tile_ni_12_5_rsp = router_12_5_rsp_out[4];

    assign router_12_5_to_router_12_6_req = router_12_5_req_out[0];
    assign router_12_5_to_router_13_5_req = router_12_5_req_out[1];
    assign router_12_5_to_router_12_4_req = router_12_5_req_out[2];
    assign router_12_5_to_router_11_5_req = router_12_5_req_out[3];
    assign router_12_5_to_magia_tile_ni_12_5_req = router_12_5_req_out[4];

    assign router_12_5_rsp_in[0] = router_12_6_to_router_12_5_rsp;
    assign router_12_5_rsp_in[1] = router_13_5_to_router_12_5_rsp;
    assign router_12_5_rsp_in[2] = router_12_4_to_router_12_5_rsp;
    assign router_12_5_rsp_in[3] = router_11_5_to_router_12_5_rsp;
    assign router_12_5_rsp_in[4] = magia_tile_ni_12_5_to_router_12_5_rsp;

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
) router_12_5 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 13, y: 5, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_12_5_req_in),
  .floo_rsp_o (router_12_5_rsp_out),
  .floo_req_o (router_12_5_req_out),
  .floo_rsp_i (router_12_5_rsp_in)
);


floo_req_t [4:0] router_12_6_req_in;
floo_rsp_t [4:0] router_12_6_rsp_out;
floo_req_t [4:0] router_12_6_req_out;
floo_rsp_t [4:0] router_12_6_rsp_in;

    assign router_12_6_req_in[0] = router_12_7_to_router_12_6_req;
    assign router_12_6_req_in[1] = router_13_6_to_router_12_6_req;
    assign router_12_6_req_in[2] = router_12_5_to_router_12_6_req;
    assign router_12_6_req_in[3] = router_11_6_to_router_12_6_req;
    assign router_12_6_req_in[4] = magia_tile_ni_12_6_to_router_12_6_req;

    assign router_12_6_to_router_12_7_rsp = router_12_6_rsp_out[0];
    assign router_12_6_to_router_13_6_rsp = router_12_6_rsp_out[1];
    assign router_12_6_to_router_12_5_rsp = router_12_6_rsp_out[2];
    assign router_12_6_to_router_11_6_rsp = router_12_6_rsp_out[3];
    assign router_12_6_to_magia_tile_ni_12_6_rsp = router_12_6_rsp_out[4];

    assign router_12_6_to_router_12_7_req = router_12_6_req_out[0];
    assign router_12_6_to_router_13_6_req = router_12_6_req_out[1];
    assign router_12_6_to_router_12_5_req = router_12_6_req_out[2];
    assign router_12_6_to_router_11_6_req = router_12_6_req_out[3];
    assign router_12_6_to_magia_tile_ni_12_6_req = router_12_6_req_out[4];

    assign router_12_6_rsp_in[0] = router_12_7_to_router_12_6_rsp;
    assign router_12_6_rsp_in[1] = router_13_6_to_router_12_6_rsp;
    assign router_12_6_rsp_in[2] = router_12_5_to_router_12_6_rsp;
    assign router_12_6_rsp_in[3] = router_11_6_to_router_12_6_rsp;
    assign router_12_6_rsp_in[4] = magia_tile_ni_12_6_to_router_12_6_rsp;

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
) router_12_6 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 13, y: 6, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_12_6_req_in),
  .floo_rsp_o (router_12_6_rsp_out),
  .floo_req_o (router_12_6_req_out),
  .floo_rsp_i (router_12_6_rsp_in)
);


floo_req_t [4:0] router_12_7_req_in;
floo_rsp_t [4:0] router_12_7_rsp_out;
floo_req_t [4:0] router_12_7_req_out;
floo_rsp_t [4:0] router_12_7_rsp_in;

    assign router_12_7_req_in[0] = router_12_8_to_router_12_7_req;
    assign router_12_7_req_in[1] = router_13_7_to_router_12_7_req;
    assign router_12_7_req_in[2] = router_12_6_to_router_12_7_req;
    assign router_12_7_req_in[3] = router_11_7_to_router_12_7_req;
    assign router_12_7_req_in[4] = magia_tile_ni_12_7_to_router_12_7_req;

    assign router_12_7_to_router_12_8_rsp = router_12_7_rsp_out[0];
    assign router_12_7_to_router_13_7_rsp = router_12_7_rsp_out[1];
    assign router_12_7_to_router_12_6_rsp = router_12_7_rsp_out[2];
    assign router_12_7_to_router_11_7_rsp = router_12_7_rsp_out[3];
    assign router_12_7_to_magia_tile_ni_12_7_rsp = router_12_7_rsp_out[4];

    assign router_12_7_to_router_12_8_req = router_12_7_req_out[0];
    assign router_12_7_to_router_13_7_req = router_12_7_req_out[1];
    assign router_12_7_to_router_12_6_req = router_12_7_req_out[2];
    assign router_12_7_to_router_11_7_req = router_12_7_req_out[3];
    assign router_12_7_to_magia_tile_ni_12_7_req = router_12_7_req_out[4];

    assign router_12_7_rsp_in[0] = router_12_8_to_router_12_7_rsp;
    assign router_12_7_rsp_in[1] = router_13_7_to_router_12_7_rsp;
    assign router_12_7_rsp_in[2] = router_12_6_to_router_12_7_rsp;
    assign router_12_7_rsp_in[3] = router_11_7_to_router_12_7_rsp;
    assign router_12_7_rsp_in[4] = magia_tile_ni_12_7_to_router_12_7_rsp;

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
) router_12_7 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 13, y: 7, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_12_7_req_in),
  .floo_rsp_o (router_12_7_rsp_out),
  .floo_req_o (router_12_7_req_out),
  .floo_rsp_i (router_12_7_rsp_in)
);


floo_req_t [4:0] router_12_8_req_in;
floo_rsp_t [4:0] router_12_8_rsp_out;
floo_req_t [4:0] router_12_8_req_out;
floo_rsp_t [4:0] router_12_8_rsp_in;

    assign router_12_8_req_in[0] = router_12_9_to_router_12_8_req;
    assign router_12_8_req_in[1] = router_13_8_to_router_12_8_req;
    assign router_12_8_req_in[2] = router_12_7_to_router_12_8_req;
    assign router_12_8_req_in[3] = router_11_8_to_router_12_8_req;
    assign router_12_8_req_in[4] = magia_tile_ni_12_8_to_router_12_8_req;

    assign router_12_8_to_router_12_9_rsp = router_12_8_rsp_out[0];
    assign router_12_8_to_router_13_8_rsp = router_12_8_rsp_out[1];
    assign router_12_8_to_router_12_7_rsp = router_12_8_rsp_out[2];
    assign router_12_8_to_router_11_8_rsp = router_12_8_rsp_out[3];
    assign router_12_8_to_magia_tile_ni_12_8_rsp = router_12_8_rsp_out[4];

    assign router_12_8_to_router_12_9_req = router_12_8_req_out[0];
    assign router_12_8_to_router_13_8_req = router_12_8_req_out[1];
    assign router_12_8_to_router_12_7_req = router_12_8_req_out[2];
    assign router_12_8_to_router_11_8_req = router_12_8_req_out[3];
    assign router_12_8_to_magia_tile_ni_12_8_req = router_12_8_req_out[4];

    assign router_12_8_rsp_in[0] = router_12_9_to_router_12_8_rsp;
    assign router_12_8_rsp_in[1] = router_13_8_to_router_12_8_rsp;
    assign router_12_8_rsp_in[2] = router_12_7_to_router_12_8_rsp;
    assign router_12_8_rsp_in[3] = router_11_8_to_router_12_8_rsp;
    assign router_12_8_rsp_in[4] = magia_tile_ni_12_8_to_router_12_8_rsp;

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
) router_12_8 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 13, y: 8, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_12_8_req_in),
  .floo_rsp_o (router_12_8_rsp_out),
  .floo_req_o (router_12_8_req_out),
  .floo_rsp_i (router_12_8_rsp_in)
);


floo_req_t [4:0] router_12_9_req_in;
floo_rsp_t [4:0] router_12_9_rsp_out;
floo_req_t [4:0] router_12_9_req_out;
floo_rsp_t [4:0] router_12_9_rsp_in;

    assign router_12_9_req_in[0] = router_12_10_to_router_12_9_req;
    assign router_12_9_req_in[1] = router_13_9_to_router_12_9_req;
    assign router_12_9_req_in[2] = router_12_8_to_router_12_9_req;
    assign router_12_9_req_in[3] = router_11_9_to_router_12_9_req;
    assign router_12_9_req_in[4] = magia_tile_ni_12_9_to_router_12_9_req;

    assign router_12_9_to_router_12_10_rsp = router_12_9_rsp_out[0];
    assign router_12_9_to_router_13_9_rsp = router_12_9_rsp_out[1];
    assign router_12_9_to_router_12_8_rsp = router_12_9_rsp_out[2];
    assign router_12_9_to_router_11_9_rsp = router_12_9_rsp_out[3];
    assign router_12_9_to_magia_tile_ni_12_9_rsp = router_12_9_rsp_out[4];

    assign router_12_9_to_router_12_10_req = router_12_9_req_out[0];
    assign router_12_9_to_router_13_9_req = router_12_9_req_out[1];
    assign router_12_9_to_router_12_8_req = router_12_9_req_out[2];
    assign router_12_9_to_router_11_9_req = router_12_9_req_out[3];
    assign router_12_9_to_magia_tile_ni_12_9_req = router_12_9_req_out[4];

    assign router_12_9_rsp_in[0] = router_12_10_to_router_12_9_rsp;
    assign router_12_9_rsp_in[1] = router_13_9_to_router_12_9_rsp;
    assign router_12_9_rsp_in[2] = router_12_8_to_router_12_9_rsp;
    assign router_12_9_rsp_in[3] = router_11_9_to_router_12_9_rsp;
    assign router_12_9_rsp_in[4] = magia_tile_ni_12_9_to_router_12_9_rsp;

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
) router_12_9 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 13, y: 9, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_12_9_req_in),
  .floo_rsp_o (router_12_9_rsp_out),
  .floo_req_o (router_12_9_req_out),
  .floo_rsp_i (router_12_9_rsp_in)
);


floo_req_t [4:0] router_12_10_req_in;
floo_rsp_t [4:0] router_12_10_rsp_out;
floo_req_t [4:0] router_12_10_req_out;
floo_rsp_t [4:0] router_12_10_rsp_in;

    assign router_12_10_req_in[0] = router_12_11_to_router_12_10_req;
    assign router_12_10_req_in[1] = router_13_10_to_router_12_10_req;
    assign router_12_10_req_in[2] = router_12_9_to_router_12_10_req;
    assign router_12_10_req_in[3] = router_11_10_to_router_12_10_req;
    assign router_12_10_req_in[4] = magia_tile_ni_12_10_to_router_12_10_req;

    assign router_12_10_to_router_12_11_rsp = router_12_10_rsp_out[0];
    assign router_12_10_to_router_13_10_rsp = router_12_10_rsp_out[1];
    assign router_12_10_to_router_12_9_rsp = router_12_10_rsp_out[2];
    assign router_12_10_to_router_11_10_rsp = router_12_10_rsp_out[3];
    assign router_12_10_to_magia_tile_ni_12_10_rsp = router_12_10_rsp_out[4];

    assign router_12_10_to_router_12_11_req = router_12_10_req_out[0];
    assign router_12_10_to_router_13_10_req = router_12_10_req_out[1];
    assign router_12_10_to_router_12_9_req = router_12_10_req_out[2];
    assign router_12_10_to_router_11_10_req = router_12_10_req_out[3];
    assign router_12_10_to_magia_tile_ni_12_10_req = router_12_10_req_out[4];

    assign router_12_10_rsp_in[0] = router_12_11_to_router_12_10_rsp;
    assign router_12_10_rsp_in[1] = router_13_10_to_router_12_10_rsp;
    assign router_12_10_rsp_in[2] = router_12_9_to_router_12_10_rsp;
    assign router_12_10_rsp_in[3] = router_11_10_to_router_12_10_rsp;
    assign router_12_10_rsp_in[4] = magia_tile_ni_12_10_to_router_12_10_rsp;

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
) router_12_10 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 13, y: 10, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_12_10_req_in),
  .floo_rsp_o (router_12_10_rsp_out),
  .floo_req_o (router_12_10_req_out),
  .floo_rsp_i (router_12_10_rsp_in)
);


floo_req_t [4:0] router_12_11_req_in;
floo_rsp_t [4:0] router_12_11_rsp_out;
floo_req_t [4:0] router_12_11_req_out;
floo_rsp_t [4:0] router_12_11_rsp_in;

    assign router_12_11_req_in[0] = router_12_12_to_router_12_11_req;
    assign router_12_11_req_in[1] = router_13_11_to_router_12_11_req;
    assign router_12_11_req_in[2] = router_12_10_to_router_12_11_req;
    assign router_12_11_req_in[3] = router_11_11_to_router_12_11_req;
    assign router_12_11_req_in[4] = magia_tile_ni_12_11_to_router_12_11_req;

    assign router_12_11_to_router_12_12_rsp = router_12_11_rsp_out[0];
    assign router_12_11_to_router_13_11_rsp = router_12_11_rsp_out[1];
    assign router_12_11_to_router_12_10_rsp = router_12_11_rsp_out[2];
    assign router_12_11_to_router_11_11_rsp = router_12_11_rsp_out[3];
    assign router_12_11_to_magia_tile_ni_12_11_rsp = router_12_11_rsp_out[4];

    assign router_12_11_to_router_12_12_req = router_12_11_req_out[0];
    assign router_12_11_to_router_13_11_req = router_12_11_req_out[1];
    assign router_12_11_to_router_12_10_req = router_12_11_req_out[2];
    assign router_12_11_to_router_11_11_req = router_12_11_req_out[3];
    assign router_12_11_to_magia_tile_ni_12_11_req = router_12_11_req_out[4];

    assign router_12_11_rsp_in[0] = router_12_12_to_router_12_11_rsp;
    assign router_12_11_rsp_in[1] = router_13_11_to_router_12_11_rsp;
    assign router_12_11_rsp_in[2] = router_12_10_to_router_12_11_rsp;
    assign router_12_11_rsp_in[3] = router_11_11_to_router_12_11_rsp;
    assign router_12_11_rsp_in[4] = magia_tile_ni_12_11_to_router_12_11_rsp;

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
) router_12_11 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 13, y: 11, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_12_11_req_in),
  .floo_rsp_o (router_12_11_rsp_out),
  .floo_req_o (router_12_11_req_out),
  .floo_rsp_i (router_12_11_rsp_in)
);


floo_req_t [4:0] router_12_12_req_in;
floo_rsp_t [4:0] router_12_12_rsp_out;
floo_req_t [4:0] router_12_12_req_out;
floo_rsp_t [4:0] router_12_12_rsp_in;

    assign router_12_12_req_in[0] = router_12_13_to_router_12_12_req;
    assign router_12_12_req_in[1] = router_13_12_to_router_12_12_req;
    assign router_12_12_req_in[2] = router_12_11_to_router_12_12_req;
    assign router_12_12_req_in[3] = router_11_12_to_router_12_12_req;
    assign router_12_12_req_in[4] = magia_tile_ni_12_12_to_router_12_12_req;

    assign router_12_12_to_router_12_13_rsp = router_12_12_rsp_out[0];
    assign router_12_12_to_router_13_12_rsp = router_12_12_rsp_out[1];
    assign router_12_12_to_router_12_11_rsp = router_12_12_rsp_out[2];
    assign router_12_12_to_router_11_12_rsp = router_12_12_rsp_out[3];
    assign router_12_12_to_magia_tile_ni_12_12_rsp = router_12_12_rsp_out[4];

    assign router_12_12_to_router_12_13_req = router_12_12_req_out[0];
    assign router_12_12_to_router_13_12_req = router_12_12_req_out[1];
    assign router_12_12_to_router_12_11_req = router_12_12_req_out[2];
    assign router_12_12_to_router_11_12_req = router_12_12_req_out[3];
    assign router_12_12_to_magia_tile_ni_12_12_req = router_12_12_req_out[4];

    assign router_12_12_rsp_in[0] = router_12_13_to_router_12_12_rsp;
    assign router_12_12_rsp_in[1] = router_13_12_to_router_12_12_rsp;
    assign router_12_12_rsp_in[2] = router_12_11_to_router_12_12_rsp;
    assign router_12_12_rsp_in[3] = router_11_12_to_router_12_12_rsp;
    assign router_12_12_rsp_in[4] = magia_tile_ni_12_12_to_router_12_12_rsp;

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
) router_12_12 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 13, y: 12, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_12_12_req_in),
  .floo_rsp_o (router_12_12_rsp_out),
  .floo_req_o (router_12_12_req_out),
  .floo_rsp_i (router_12_12_rsp_in)
);


floo_req_t [4:0] router_12_13_req_in;
floo_rsp_t [4:0] router_12_13_rsp_out;
floo_req_t [4:0] router_12_13_req_out;
floo_rsp_t [4:0] router_12_13_rsp_in;

    assign router_12_13_req_in[0] = router_12_14_to_router_12_13_req;
    assign router_12_13_req_in[1] = router_13_13_to_router_12_13_req;
    assign router_12_13_req_in[2] = router_12_12_to_router_12_13_req;
    assign router_12_13_req_in[3] = router_11_13_to_router_12_13_req;
    assign router_12_13_req_in[4] = magia_tile_ni_12_13_to_router_12_13_req;

    assign router_12_13_to_router_12_14_rsp = router_12_13_rsp_out[0];
    assign router_12_13_to_router_13_13_rsp = router_12_13_rsp_out[1];
    assign router_12_13_to_router_12_12_rsp = router_12_13_rsp_out[2];
    assign router_12_13_to_router_11_13_rsp = router_12_13_rsp_out[3];
    assign router_12_13_to_magia_tile_ni_12_13_rsp = router_12_13_rsp_out[4];

    assign router_12_13_to_router_12_14_req = router_12_13_req_out[0];
    assign router_12_13_to_router_13_13_req = router_12_13_req_out[1];
    assign router_12_13_to_router_12_12_req = router_12_13_req_out[2];
    assign router_12_13_to_router_11_13_req = router_12_13_req_out[3];
    assign router_12_13_to_magia_tile_ni_12_13_req = router_12_13_req_out[4];

    assign router_12_13_rsp_in[0] = router_12_14_to_router_12_13_rsp;
    assign router_12_13_rsp_in[1] = router_13_13_to_router_12_13_rsp;
    assign router_12_13_rsp_in[2] = router_12_12_to_router_12_13_rsp;
    assign router_12_13_rsp_in[3] = router_11_13_to_router_12_13_rsp;
    assign router_12_13_rsp_in[4] = magia_tile_ni_12_13_to_router_12_13_rsp;

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
) router_12_13 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 13, y: 13, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_12_13_req_in),
  .floo_rsp_o (router_12_13_rsp_out),
  .floo_req_o (router_12_13_req_out),
  .floo_rsp_i (router_12_13_rsp_in)
);


floo_req_t [4:0] router_12_14_req_in;
floo_rsp_t [4:0] router_12_14_rsp_out;
floo_req_t [4:0] router_12_14_req_out;
floo_rsp_t [4:0] router_12_14_rsp_in;

    assign router_12_14_req_in[0] = router_12_15_to_router_12_14_req;
    assign router_12_14_req_in[1] = router_13_14_to_router_12_14_req;
    assign router_12_14_req_in[2] = router_12_13_to_router_12_14_req;
    assign router_12_14_req_in[3] = router_11_14_to_router_12_14_req;
    assign router_12_14_req_in[4] = magia_tile_ni_12_14_to_router_12_14_req;

    assign router_12_14_to_router_12_15_rsp = router_12_14_rsp_out[0];
    assign router_12_14_to_router_13_14_rsp = router_12_14_rsp_out[1];
    assign router_12_14_to_router_12_13_rsp = router_12_14_rsp_out[2];
    assign router_12_14_to_router_11_14_rsp = router_12_14_rsp_out[3];
    assign router_12_14_to_magia_tile_ni_12_14_rsp = router_12_14_rsp_out[4];

    assign router_12_14_to_router_12_15_req = router_12_14_req_out[0];
    assign router_12_14_to_router_13_14_req = router_12_14_req_out[1];
    assign router_12_14_to_router_12_13_req = router_12_14_req_out[2];
    assign router_12_14_to_router_11_14_req = router_12_14_req_out[3];
    assign router_12_14_to_magia_tile_ni_12_14_req = router_12_14_req_out[4];

    assign router_12_14_rsp_in[0] = router_12_15_to_router_12_14_rsp;
    assign router_12_14_rsp_in[1] = router_13_14_to_router_12_14_rsp;
    assign router_12_14_rsp_in[2] = router_12_13_to_router_12_14_rsp;
    assign router_12_14_rsp_in[3] = router_11_14_to_router_12_14_rsp;
    assign router_12_14_rsp_in[4] = magia_tile_ni_12_14_to_router_12_14_rsp;

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
) router_12_14 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 13, y: 14, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_12_14_req_in),
  .floo_rsp_o (router_12_14_rsp_out),
  .floo_req_o (router_12_14_req_out),
  .floo_rsp_i (router_12_14_rsp_in)
);


floo_req_t [4:0] router_12_15_req_in;
floo_rsp_t [4:0] router_12_15_rsp_out;
floo_req_t [4:0] router_12_15_req_out;
floo_rsp_t [4:0] router_12_15_rsp_in;

    assign router_12_15_req_in[0] = '0;
    assign router_12_15_req_in[1] = router_13_15_to_router_12_15_req;
    assign router_12_15_req_in[2] = router_12_14_to_router_12_15_req;
    assign router_12_15_req_in[3] = router_11_15_to_router_12_15_req;
    assign router_12_15_req_in[4] = magia_tile_ni_12_15_to_router_12_15_req;

    assign router_12_15_to_router_13_15_rsp = router_12_15_rsp_out[1];
    assign router_12_15_to_router_12_14_rsp = router_12_15_rsp_out[2];
    assign router_12_15_to_router_11_15_rsp = router_12_15_rsp_out[3];
    assign router_12_15_to_magia_tile_ni_12_15_rsp = router_12_15_rsp_out[4];

    assign router_12_15_to_router_13_15_req = router_12_15_req_out[1];
    assign router_12_15_to_router_12_14_req = router_12_15_req_out[2];
    assign router_12_15_to_router_11_15_req = router_12_15_req_out[3];
    assign router_12_15_to_magia_tile_ni_12_15_req = router_12_15_req_out[4];

    assign router_12_15_rsp_in[0] = '0;
    assign router_12_15_rsp_in[1] = router_13_15_to_router_12_15_rsp;
    assign router_12_15_rsp_in[2] = router_12_14_to_router_12_15_rsp;
    assign router_12_15_rsp_in[3] = router_11_15_to_router_12_15_rsp;
    assign router_12_15_rsp_in[4] = magia_tile_ni_12_15_to_router_12_15_rsp;

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
) router_12_15 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 13, y: 15, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_12_15_req_in),
  .floo_rsp_o (router_12_15_rsp_out),
  .floo_req_o (router_12_15_req_out),
  .floo_rsp_i (router_12_15_rsp_in)
);


floo_req_t [4:0] router_13_0_req_in;
floo_rsp_t [4:0] router_13_0_rsp_out;
floo_req_t [4:0] router_13_0_req_out;
floo_rsp_t [4:0] router_13_0_rsp_in;

    assign router_13_0_req_in[0] = router_13_1_to_router_13_0_req;
    assign router_13_0_req_in[1] = router_14_0_to_router_13_0_req;
    assign router_13_0_req_in[2] = '0;
    assign router_13_0_req_in[3] = router_12_0_to_router_13_0_req;
    assign router_13_0_req_in[4] = magia_tile_ni_13_0_to_router_13_0_req;

    assign router_13_0_to_router_13_1_rsp = router_13_0_rsp_out[0];
    assign router_13_0_to_router_14_0_rsp = router_13_0_rsp_out[1];
    assign router_13_0_to_router_12_0_rsp = router_13_0_rsp_out[3];
    assign router_13_0_to_magia_tile_ni_13_0_rsp = router_13_0_rsp_out[4];

    assign router_13_0_to_router_13_1_req = router_13_0_req_out[0];
    assign router_13_0_to_router_14_0_req = router_13_0_req_out[1];
    assign router_13_0_to_router_12_0_req = router_13_0_req_out[3];
    assign router_13_0_to_magia_tile_ni_13_0_req = router_13_0_req_out[4];

    assign router_13_0_rsp_in[0] = router_13_1_to_router_13_0_rsp;
    assign router_13_0_rsp_in[1] = router_14_0_to_router_13_0_rsp;
    assign router_13_0_rsp_in[2] = '0;
    assign router_13_0_rsp_in[3] = router_12_0_to_router_13_0_rsp;
    assign router_13_0_rsp_in[4] = magia_tile_ni_13_0_to_router_13_0_rsp;

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
) router_13_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 14, y: 0, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_13_0_req_in),
  .floo_rsp_o (router_13_0_rsp_out),
  .floo_req_o (router_13_0_req_out),
  .floo_rsp_i (router_13_0_rsp_in)
);


floo_req_t [4:0] router_13_1_req_in;
floo_rsp_t [4:0] router_13_1_rsp_out;
floo_req_t [4:0] router_13_1_req_out;
floo_rsp_t [4:0] router_13_1_rsp_in;

    assign router_13_1_req_in[0] = router_13_2_to_router_13_1_req;
    assign router_13_1_req_in[1] = router_14_1_to_router_13_1_req;
    assign router_13_1_req_in[2] = router_13_0_to_router_13_1_req;
    assign router_13_1_req_in[3] = router_12_1_to_router_13_1_req;
    assign router_13_1_req_in[4] = magia_tile_ni_13_1_to_router_13_1_req;

    assign router_13_1_to_router_13_2_rsp = router_13_1_rsp_out[0];
    assign router_13_1_to_router_14_1_rsp = router_13_1_rsp_out[1];
    assign router_13_1_to_router_13_0_rsp = router_13_1_rsp_out[2];
    assign router_13_1_to_router_12_1_rsp = router_13_1_rsp_out[3];
    assign router_13_1_to_magia_tile_ni_13_1_rsp = router_13_1_rsp_out[4];

    assign router_13_1_to_router_13_2_req = router_13_1_req_out[0];
    assign router_13_1_to_router_14_1_req = router_13_1_req_out[1];
    assign router_13_1_to_router_13_0_req = router_13_1_req_out[2];
    assign router_13_1_to_router_12_1_req = router_13_1_req_out[3];
    assign router_13_1_to_magia_tile_ni_13_1_req = router_13_1_req_out[4];

    assign router_13_1_rsp_in[0] = router_13_2_to_router_13_1_rsp;
    assign router_13_1_rsp_in[1] = router_14_1_to_router_13_1_rsp;
    assign router_13_1_rsp_in[2] = router_13_0_to_router_13_1_rsp;
    assign router_13_1_rsp_in[3] = router_12_1_to_router_13_1_rsp;
    assign router_13_1_rsp_in[4] = magia_tile_ni_13_1_to_router_13_1_rsp;

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
) router_13_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 14, y: 1, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_13_1_req_in),
  .floo_rsp_o (router_13_1_rsp_out),
  .floo_req_o (router_13_1_req_out),
  .floo_rsp_i (router_13_1_rsp_in)
);


floo_req_t [4:0] router_13_2_req_in;
floo_rsp_t [4:0] router_13_2_rsp_out;
floo_req_t [4:0] router_13_2_req_out;
floo_rsp_t [4:0] router_13_2_rsp_in;

    assign router_13_2_req_in[0] = router_13_3_to_router_13_2_req;
    assign router_13_2_req_in[1] = router_14_2_to_router_13_2_req;
    assign router_13_2_req_in[2] = router_13_1_to_router_13_2_req;
    assign router_13_2_req_in[3] = router_12_2_to_router_13_2_req;
    assign router_13_2_req_in[4] = magia_tile_ni_13_2_to_router_13_2_req;

    assign router_13_2_to_router_13_3_rsp = router_13_2_rsp_out[0];
    assign router_13_2_to_router_14_2_rsp = router_13_2_rsp_out[1];
    assign router_13_2_to_router_13_1_rsp = router_13_2_rsp_out[2];
    assign router_13_2_to_router_12_2_rsp = router_13_2_rsp_out[3];
    assign router_13_2_to_magia_tile_ni_13_2_rsp = router_13_2_rsp_out[4];

    assign router_13_2_to_router_13_3_req = router_13_2_req_out[0];
    assign router_13_2_to_router_14_2_req = router_13_2_req_out[1];
    assign router_13_2_to_router_13_1_req = router_13_2_req_out[2];
    assign router_13_2_to_router_12_2_req = router_13_2_req_out[3];
    assign router_13_2_to_magia_tile_ni_13_2_req = router_13_2_req_out[4];

    assign router_13_2_rsp_in[0] = router_13_3_to_router_13_2_rsp;
    assign router_13_2_rsp_in[1] = router_14_2_to_router_13_2_rsp;
    assign router_13_2_rsp_in[2] = router_13_1_to_router_13_2_rsp;
    assign router_13_2_rsp_in[3] = router_12_2_to_router_13_2_rsp;
    assign router_13_2_rsp_in[4] = magia_tile_ni_13_2_to_router_13_2_rsp;

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
) router_13_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 14, y: 2, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_13_2_req_in),
  .floo_rsp_o (router_13_2_rsp_out),
  .floo_req_o (router_13_2_req_out),
  .floo_rsp_i (router_13_2_rsp_in)
);


floo_req_t [4:0] router_13_3_req_in;
floo_rsp_t [4:0] router_13_3_rsp_out;
floo_req_t [4:0] router_13_3_req_out;
floo_rsp_t [4:0] router_13_3_rsp_in;

    assign router_13_3_req_in[0] = router_13_4_to_router_13_3_req;
    assign router_13_3_req_in[1] = router_14_3_to_router_13_3_req;
    assign router_13_3_req_in[2] = router_13_2_to_router_13_3_req;
    assign router_13_3_req_in[3] = router_12_3_to_router_13_3_req;
    assign router_13_3_req_in[4] = magia_tile_ni_13_3_to_router_13_3_req;

    assign router_13_3_to_router_13_4_rsp = router_13_3_rsp_out[0];
    assign router_13_3_to_router_14_3_rsp = router_13_3_rsp_out[1];
    assign router_13_3_to_router_13_2_rsp = router_13_3_rsp_out[2];
    assign router_13_3_to_router_12_3_rsp = router_13_3_rsp_out[3];
    assign router_13_3_to_magia_tile_ni_13_3_rsp = router_13_3_rsp_out[4];

    assign router_13_3_to_router_13_4_req = router_13_3_req_out[0];
    assign router_13_3_to_router_14_3_req = router_13_3_req_out[1];
    assign router_13_3_to_router_13_2_req = router_13_3_req_out[2];
    assign router_13_3_to_router_12_3_req = router_13_3_req_out[3];
    assign router_13_3_to_magia_tile_ni_13_3_req = router_13_3_req_out[4];

    assign router_13_3_rsp_in[0] = router_13_4_to_router_13_3_rsp;
    assign router_13_3_rsp_in[1] = router_14_3_to_router_13_3_rsp;
    assign router_13_3_rsp_in[2] = router_13_2_to_router_13_3_rsp;
    assign router_13_3_rsp_in[3] = router_12_3_to_router_13_3_rsp;
    assign router_13_3_rsp_in[4] = magia_tile_ni_13_3_to_router_13_3_rsp;

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
) router_13_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 14, y: 3, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_13_3_req_in),
  .floo_rsp_o (router_13_3_rsp_out),
  .floo_req_o (router_13_3_req_out),
  .floo_rsp_i (router_13_3_rsp_in)
);


floo_req_t [4:0] router_13_4_req_in;
floo_rsp_t [4:0] router_13_4_rsp_out;
floo_req_t [4:0] router_13_4_req_out;
floo_rsp_t [4:0] router_13_4_rsp_in;

    assign router_13_4_req_in[0] = router_13_5_to_router_13_4_req;
    assign router_13_4_req_in[1] = router_14_4_to_router_13_4_req;
    assign router_13_4_req_in[2] = router_13_3_to_router_13_4_req;
    assign router_13_4_req_in[3] = router_12_4_to_router_13_4_req;
    assign router_13_4_req_in[4] = magia_tile_ni_13_4_to_router_13_4_req;

    assign router_13_4_to_router_13_5_rsp = router_13_4_rsp_out[0];
    assign router_13_4_to_router_14_4_rsp = router_13_4_rsp_out[1];
    assign router_13_4_to_router_13_3_rsp = router_13_4_rsp_out[2];
    assign router_13_4_to_router_12_4_rsp = router_13_4_rsp_out[3];
    assign router_13_4_to_magia_tile_ni_13_4_rsp = router_13_4_rsp_out[4];

    assign router_13_4_to_router_13_5_req = router_13_4_req_out[0];
    assign router_13_4_to_router_14_4_req = router_13_4_req_out[1];
    assign router_13_4_to_router_13_3_req = router_13_4_req_out[2];
    assign router_13_4_to_router_12_4_req = router_13_4_req_out[3];
    assign router_13_4_to_magia_tile_ni_13_4_req = router_13_4_req_out[4];

    assign router_13_4_rsp_in[0] = router_13_5_to_router_13_4_rsp;
    assign router_13_4_rsp_in[1] = router_14_4_to_router_13_4_rsp;
    assign router_13_4_rsp_in[2] = router_13_3_to_router_13_4_rsp;
    assign router_13_4_rsp_in[3] = router_12_4_to_router_13_4_rsp;
    assign router_13_4_rsp_in[4] = magia_tile_ni_13_4_to_router_13_4_rsp;

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
) router_13_4 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 14, y: 4, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_13_4_req_in),
  .floo_rsp_o (router_13_4_rsp_out),
  .floo_req_o (router_13_4_req_out),
  .floo_rsp_i (router_13_4_rsp_in)
);


floo_req_t [4:0] router_13_5_req_in;
floo_rsp_t [4:0] router_13_5_rsp_out;
floo_req_t [4:0] router_13_5_req_out;
floo_rsp_t [4:0] router_13_5_rsp_in;

    assign router_13_5_req_in[0] = router_13_6_to_router_13_5_req;
    assign router_13_5_req_in[1] = router_14_5_to_router_13_5_req;
    assign router_13_5_req_in[2] = router_13_4_to_router_13_5_req;
    assign router_13_5_req_in[3] = router_12_5_to_router_13_5_req;
    assign router_13_5_req_in[4] = magia_tile_ni_13_5_to_router_13_5_req;

    assign router_13_5_to_router_13_6_rsp = router_13_5_rsp_out[0];
    assign router_13_5_to_router_14_5_rsp = router_13_5_rsp_out[1];
    assign router_13_5_to_router_13_4_rsp = router_13_5_rsp_out[2];
    assign router_13_5_to_router_12_5_rsp = router_13_5_rsp_out[3];
    assign router_13_5_to_magia_tile_ni_13_5_rsp = router_13_5_rsp_out[4];

    assign router_13_5_to_router_13_6_req = router_13_5_req_out[0];
    assign router_13_5_to_router_14_5_req = router_13_5_req_out[1];
    assign router_13_5_to_router_13_4_req = router_13_5_req_out[2];
    assign router_13_5_to_router_12_5_req = router_13_5_req_out[3];
    assign router_13_5_to_magia_tile_ni_13_5_req = router_13_5_req_out[4];

    assign router_13_5_rsp_in[0] = router_13_6_to_router_13_5_rsp;
    assign router_13_5_rsp_in[1] = router_14_5_to_router_13_5_rsp;
    assign router_13_5_rsp_in[2] = router_13_4_to_router_13_5_rsp;
    assign router_13_5_rsp_in[3] = router_12_5_to_router_13_5_rsp;
    assign router_13_5_rsp_in[4] = magia_tile_ni_13_5_to_router_13_5_rsp;

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
) router_13_5 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 14, y: 5, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_13_5_req_in),
  .floo_rsp_o (router_13_5_rsp_out),
  .floo_req_o (router_13_5_req_out),
  .floo_rsp_i (router_13_5_rsp_in)
);


floo_req_t [4:0] router_13_6_req_in;
floo_rsp_t [4:0] router_13_6_rsp_out;
floo_req_t [4:0] router_13_6_req_out;
floo_rsp_t [4:0] router_13_6_rsp_in;

    assign router_13_6_req_in[0] = router_13_7_to_router_13_6_req;
    assign router_13_6_req_in[1] = router_14_6_to_router_13_6_req;
    assign router_13_6_req_in[2] = router_13_5_to_router_13_6_req;
    assign router_13_6_req_in[3] = router_12_6_to_router_13_6_req;
    assign router_13_6_req_in[4] = magia_tile_ni_13_6_to_router_13_6_req;

    assign router_13_6_to_router_13_7_rsp = router_13_6_rsp_out[0];
    assign router_13_6_to_router_14_6_rsp = router_13_6_rsp_out[1];
    assign router_13_6_to_router_13_5_rsp = router_13_6_rsp_out[2];
    assign router_13_6_to_router_12_6_rsp = router_13_6_rsp_out[3];
    assign router_13_6_to_magia_tile_ni_13_6_rsp = router_13_6_rsp_out[4];

    assign router_13_6_to_router_13_7_req = router_13_6_req_out[0];
    assign router_13_6_to_router_14_6_req = router_13_6_req_out[1];
    assign router_13_6_to_router_13_5_req = router_13_6_req_out[2];
    assign router_13_6_to_router_12_6_req = router_13_6_req_out[3];
    assign router_13_6_to_magia_tile_ni_13_6_req = router_13_6_req_out[4];

    assign router_13_6_rsp_in[0] = router_13_7_to_router_13_6_rsp;
    assign router_13_6_rsp_in[1] = router_14_6_to_router_13_6_rsp;
    assign router_13_6_rsp_in[2] = router_13_5_to_router_13_6_rsp;
    assign router_13_6_rsp_in[3] = router_12_6_to_router_13_6_rsp;
    assign router_13_6_rsp_in[4] = magia_tile_ni_13_6_to_router_13_6_rsp;

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
) router_13_6 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 14, y: 6, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_13_6_req_in),
  .floo_rsp_o (router_13_6_rsp_out),
  .floo_req_o (router_13_6_req_out),
  .floo_rsp_i (router_13_6_rsp_in)
);


floo_req_t [4:0] router_13_7_req_in;
floo_rsp_t [4:0] router_13_7_rsp_out;
floo_req_t [4:0] router_13_7_req_out;
floo_rsp_t [4:0] router_13_7_rsp_in;

    assign router_13_7_req_in[0] = router_13_8_to_router_13_7_req;
    assign router_13_7_req_in[1] = router_14_7_to_router_13_7_req;
    assign router_13_7_req_in[2] = router_13_6_to_router_13_7_req;
    assign router_13_7_req_in[3] = router_12_7_to_router_13_7_req;
    assign router_13_7_req_in[4] = magia_tile_ni_13_7_to_router_13_7_req;

    assign router_13_7_to_router_13_8_rsp = router_13_7_rsp_out[0];
    assign router_13_7_to_router_14_7_rsp = router_13_7_rsp_out[1];
    assign router_13_7_to_router_13_6_rsp = router_13_7_rsp_out[2];
    assign router_13_7_to_router_12_7_rsp = router_13_7_rsp_out[3];
    assign router_13_7_to_magia_tile_ni_13_7_rsp = router_13_7_rsp_out[4];

    assign router_13_7_to_router_13_8_req = router_13_7_req_out[0];
    assign router_13_7_to_router_14_7_req = router_13_7_req_out[1];
    assign router_13_7_to_router_13_6_req = router_13_7_req_out[2];
    assign router_13_7_to_router_12_7_req = router_13_7_req_out[3];
    assign router_13_7_to_magia_tile_ni_13_7_req = router_13_7_req_out[4];

    assign router_13_7_rsp_in[0] = router_13_8_to_router_13_7_rsp;
    assign router_13_7_rsp_in[1] = router_14_7_to_router_13_7_rsp;
    assign router_13_7_rsp_in[2] = router_13_6_to_router_13_7_rsp;
    assign router_13_7_rsp_in[3] = router_12_7_to_router_13_7_rsp;
    assign router_13_7_rsp_in[4] = magia_tile_ni_13_7_to_router_13_7_rsp;

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
) router_13_7 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 14, y: 7, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_13_7_req_in),
  .floo_rsp_o (router_13_7_rsp_out),
  .floo_req_o (router_13_7_req_out),
  .floo_rsp_i (router_13_7_rsp_in)
);


floo_req_t [4:0] router_13_8_req_in;
floo_rsp_t [4:0] router_13_8_rsp_out;
floo_req_t [4:0] router_13_8_req_out;
floo_rsp_t [4:0] router_13_8_rsp_in;

    assign router_13_8_req_in[0] = router_13_9_to_router_13_8_req;
    assign router_13_8_req_in[1] = router_14_8_to_router_13_8_req;
    assign router_13_8_req_in[2] = router_13_7_to_router_13_8_req;
    assign router_13_8_req_in[3] = router_12_8_to_router_13_8_req;
    assign router_13_8_req_in[4] = magia_tile_ni_13_8_to_router_13_8_req;

    assign router_13_8_to_router_13_9_rsp = router_13_8_rsp_out[0];
    assign router_13_8_to_router_14_8_rsp = router_13_8_rsp_out[1];
    assign router_13_8_to_router_13_7_rsp = router_13_8_rsp_out[2];
    assign router_13_8_to_router_12_8_rsp = router_13_8_rsp_out[3];
    assign router_13_8_to_magia_tile_ni_13_8_rsp = router_13_8_rsp_out[4];

    assign router_13_8_to_router_13_9_req = router_13_8_req_out[0];
    assign router_13_8_to_router_14_8_req = router_13_8_req_out[1];
    assign router_13_8_to_router_13_7_req = router_13_8_req_out[2];
    assign router_13_8_to_router_12_8_req = router_13_8_req_out[3];
    assign router_13_8_to_magia_tile_ni_13_8_req = router_13_8_req_out[4];

    assign router_13_8_rsp_in[0] = router_13_9_to_router_13_8_rsp;
    assign router_13_8_rsp_in[1] = router_14_8_to_router_13_8_rsp;
    assign router_13_8_rsp_in[2] = router_13_7_to_router_13_8_rsp;
    assign router_13_8_rsp_in[3] = router_12_8_to_router_13_8_rsp;
    assign router_13_8_rsp_in[4] = magia_tile_ni_13_8_to_router_13_8_rsp;

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
) router_13_8 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 14, y: 8, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_13_8_req_in),
  .floo_rsp_o (router_13_8_rsp_out),
  .floo_req_o (router_13_8_req_out),
  .floo_rsp_i (router_13_8_rsp_in)
);


floo_req_t [4:0] router_13_9_req_in;
floo_rsp_t [4:0] router_13_9_rsp_out;
floo_req_t [4:0] router_13_9_req_out;
floo_rsp_t [4:0] router_13_9_rsp_in;

    assign router_13_9_req_in[0] = router_13_10_to_router_13_9_req;
    assign router_13_9_req_in[1] = router_14_9_to_router_13_9_req;
    assign router_13_9_req_in[2] = router_13_8_to_router_13_9_req;
    assign router_13_9_req_in[3] = router_12_9_to_router_13_9_req;
    assign router_13_9_req_in[4] = magia_tile_ni_13_9_to_router_13_9_req;

    assign router_13_9_to_router_13_10_rsp = router_13_9_rsp_out[0];
    assign router_13_9_to_router_14_9_rsp = router_13_9_rsp_out[1];
    assign router_13_9_to_router_13_8_rsp = router_13_9_rsp_out[2];
    assign router_13_9_to_router_12_9_rsp = router_13_9_rsp_out[3];
    assign router_13_9_to_magia_tile_ni_13_9_rsp = router_13_9_rsp_out[4];

    assign router_13_9_to_router_13_10_req = router_13_9_req_out[0];
    assign router_13_9_to_router_14_9_req = router_13_9_req_out[1];
    assign router_13_9_to_router_13_8_req = router_13_9_req_out[2];
    assign router_13_9_to_router_12_9_req = router_13_9_req_out[3];
    assign router_13_9_to_magia_tile_ni_13_9_req = router_13_9_req_out[4];

    assign router_13_9_rsp_in[0] = router_13_10_to_router_13_9_rsp;
    assign router_13_9_rsp_in[1] = router_14_9_to_router_13_9_rsp;
    assign router_13_9_rsp_in[2] = router_13_8_to_router_13_9_rsp;
    assign router_13_9_rsp_in[3] = router_12_9_to_router_13_9_rsp;
    assign router_13_9_rsp_in[4] = magia_tile_ni_13_9_to_router_13_9_rsp;

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
) router_13_9 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 14, y: 9, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_13_9_req_in),
  .floo_rsp_o (router_13_9_rsp_out),
  .floo_req_o (router_13_9_req_out),
  .floo_rsp_i (router_13_9_rsp_in)
);


floo_req_t [4:0] router_13_10_req_in;
floo_rsp_t [4:0] router_13_10_rsp_out;
floo_req_t [4:0] router_13_10_req_out;
floo_rsp_t [4:0] router_13_10_rsp_in;

    assign router_13_10_req_in[0] = router_13_11_to_router_13_10_req;
    assign router_13_10_req_in[1] = router_14_10_to_router_13_10_req;
    assign router_13_10_req_in[2] = router_13_9_to_router_13_10_req;
    assign router_13_10_req_in[3] = router_12_10_to_router_13_10_req;
    assign router_13_10_req_in[4] = magia_tile_ni_13_10_to_router_13_10_req;

    assign router_13_10_to_router_13_11_rsp = router_13_10_rsp_out[0];
    assign router_13_10_to_router_14_10_rsp = router_13_10_rsp_out[1];
    assign router_13_10_to_router_13_9_rsp = router_13_10_rsp_out[2];
    assign router_13_10_to_router_12_10_rsp = router_13_10_rsp_out[3];
    assign router_13_10_to_magia_tile_ni_13_10_rsp = router_13_10_rsp_out[4];

    assign router_13_10_to_router_13_11_req = router_13_10_req_out[0];
    assign router_13_10_to_router_14_10_req = router_13_10_req_out[1];
    assign router_13_10_to_router_13_9_req = router_13_10_req_out[2];
    assign router_13_10_to_router_12_10_req = router_13_10_req_out[3];
    assign router_13_10_to_magia_tile_ni_13_10_req = router_13_10_req_out[4];

    assign router_13_10_rsp_in[0] = router_13_11_to_router_13_10_rsp;
    assign router_13_10_rsp_in[1] = router_14_10_to_router_13_10_rsp;
    assign router_13_10_rsp_in[2] = router_13_9_to_router_13_10_rsp;
    assign router_13_10_rsp_in[3] = router_12_10_to_router_13_10_rsp;
    assign router_13_10_rsp_in[4] = magia_tile_ni_13_10_to_router_13_10_rsp;

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
) router_13_10 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 14, y: 10, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_13_10_req_in),
  .floo_rsp_o (router_13_10_rsp_out),
  .floo_req_o (router_13_10_req_out),
  .floo_rsp_i (router_13_10_rsp_in)
);


floo_req_t [4:0] router_13_11_req_in;
floo_rsp_t [4:0] router_13_11_rsp_out;
floo_req_t [4:0] router_13_11_req_out;
floo_rsp_t [4:0] router_13_11_rsp_in;

    assign router_13_11_req_in[0] = router_13_12_to_router_13_11_req;
    assign router_13_11_req_in[1] = router_14_11_to_router_13_11_req;
    assign router_13_11_req_in[2] = router_13_10_to_router_13_11_req;
    assign router_13_11_req_in[3] = router_12_11_to_router_13_11_req;
    assign router_13_11_req_in[4] = magia_tile_ni_13_11_to_router_13_11_req;

    assign router_13_11_to_router_13_12_rsp = router_13_11_rsp_out[0];
    assign router_13_11_to_router_14_11_rsp = router_13_11_rsp_out[1];
    assign router_13_11_to_router_13_10_rsp = router_13_11_rsp_out[2];
    assign router_13_11_to_router_12_11_rsp = router_13_11_rsp_out[3];
    assign router_13_11_to_magia_tile_ni_13_11_rsp = router_13_11_rsp_out[4];

    assign router_13_11_to_router_13_12_req = router_13_11_req_out[0];
    assign router_13_11_to_router_14_11_req = router_13_11_req_out[1];
    assign router_13_11_to_router_13_10_req = router_13_11_req_out[2];
    assign router_13_11_to_router_12_11_req = router_13_11_req_out[3];
    assign router_13_11_to_magia_tile_ni_13_11_req = router_13_11_req_out[4];

    assign router_13_11_rsp_in[0] = router_13_12_to_router_13_11_rsp;
    assign router_13_11_rsp_in[1] = router_14_11_to_router_13_11_rsp;
    assign router_13_11_rsp_in[2] = router_13_10_to_router_13_11_rsp;
    assign router_13_11_rsp_in[3] = router_12_11_to_router_13_11_rsp;
    assign router_13_11_rsp_in[4] = magia_tile_ni_13_11_to_router_13_11_rsp;

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
) router_13_11 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 14, y: 11, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_13_11_req_in),
  .floo_rsp_o (router_13_11_rsp_out),
  .floo_req_o (router_13_11_req_out),
  .floo_rsp_i (router_13_11_rsp_in)
);


floo_req_t [4:0] router_13_12_req_in;
floo_rsp_t [4:0] router_13_12_rsp_out;
floo_req_t [4:0] router_13_12_req_out;
floo_rsp_t [4:0] router_13_12_rsp_in;

    assign router_13_12_req_in[0] = router_13_13_to_router_13_12_req;
    assign router_13_12_req_in[1] = router_14_12_to_router_13_12_req;
    assign router_13_12_req_in[2] = router_13_11_to_router_13_12_req;
    assign router_13_12_req_in[3] = router_12_12_to_router_13_12_req;
    assign router_13_12_req_in[4] = magia_tile_ni_13_12_to_router_13_12_req;

    assign router_13_12_to_router_13_13_rsp = router_13_12_rsp_out[0];
    assign router_13_12_to_router_14_12_rsp = router_13_12_rsp_out[1];
    assign router_13_12_to_router_13_11_rsp = router_13_12_rsp_out[2];
    assign router_13_12_to_router_12_12_rsp = router_13_12_rsp_out[3];
    assign router_13_12_to_magia_tile_ni_13_12_rsp = router_13_12_rsp_out[4];

    assign router_13_12_to_router_13_13_req = router_13_12_req_out[0];
    assign router_13_12_to_router_14_12_req = router_13_12_req_out[1];
    assign router_13_12_to_router_13_11_req = router_13_12_req_out[2];
    assign router_13_12_to_router_12_12_req = router_13_12_req_out[3];
    assign router_13_12_to_magia_tile_ni_13_12_req = router_13_12_req_out[4];

    assign router_13_12_rsp_in[0] = router_13_13_to_router_13_12_rsp;
    assign router_13_12_rsp_in[1] = router_14_12_to_router_13_12_rsp;
    assign router_13_12_rsp_in[2] = router_13_11_to_router_13_12_rsp;
    assign router_13_12_rsp_in[3] = router_12_12_to_router_13_12_rsp;
    assign router_13_12_rsp_in[4] = magia_tile_ni_13_12_to_router_13_12_rsp;

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
) router_13_12 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 14, y: 12, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_13_12_req_in),
  .floo_rsp_o (router_13_12_rsp_out),
  .floo_req_o (router_13_12_req_out),
  .floo_rsp_i (router_13_12_rsp_in)
);


floo_req_t [4:0] router_13_13_req_in;
floo_rsp_t [4:0] router_13_13_rsp_out;
floo_req_t [4:0] router_13_13_req_out;
floo_rsp_t [4:0] router_13_13_rsp_in;

    assign router_13_13_req_in[0] = router_13_14_to_router_13_13_req;
    assign router_13_13_req_in[1] = router_14_13_to_router_13_13_req;
    assign router_13_13_req_in[2] = router_13_12_to_router_13_13_req;
    assign router_13_13_req_in[3] = router_12_13_to_router_13_13_req;
    assign router_13_13_req_in[4] = magia_tile_ni_13_13_to_router_13_13_req;

    assign router_13_13_to_router_13_14_rsp = router_13_13_rsp_out[0];
    assign router_13_13_to_router_14_13_rsp = router_13_13_rsp_out[1];
    assign router_13_13_to_router_13_12_rsp = router_13_13_rsp_out[2];
    assign router_13_13_to_router_12_13_rsp = router_13_13_rsp_out[3];
    assign router_13_13_to_magia_tile_ni_13_13_rsp = router_13_13_rsp_out[4];

    assign router_13_13_to_router_13_14_req = router_13_13_req_out[0];
    assign router_13_13_to_router_14_13_req = router_13_13_req_out[1];
    assign router_13_13_to_router_13_12_req = router_13_13_req_out[2];
    assign router_13_13_to_router_12_13_req = router_13_13_req_out[3];
    assign router_13_13_to_magia_tile_ni_13_13_req = router_13_13_req_out[4];

    assign router_13_13_rsp_in[0] = router_13_14_to_router_13_13_rsp;
    assign router_13_13_rsp_in[1] = router_14_13_to_router_13_13_rsp;
    assign router_13_13_rsp_in[2] = router_13_12_to_router_13_13_rsp;
    assign router_13_13_rsp_in[3] = router_12_13_to_router_13_13_rsp;
    assign router_13_13_rsp_in[4] = magia_tile_ni_13_13_to_router_13_13_rsp;

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
) router_13_13 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 14, y: 13, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_13_13_req_in),
  .floo_rsp_o (router_13_13_rsp_out),
  .floo_req_o (router_13_13_req_out),
  .floo_rsp_i (router_13_13_rsp_in)
);


floo_req_t [4:0] router_13_14_req_in;
floo_rsp_t [4:0] router_13_14_rsp_out;
floo_req_t [4:0] router_13_14_req_out;
floo_rsp_t [4:0] router_13_14_rsp_in;

    assign router_13_14_req_in[0] = router_13_15_to_router_13_14_req;
    assign router_13_14_req_in[1] = router_14_14_to_router_13_14_req;
    assign router_13_14_req_in[2] = router_13_13_to_router_13_14_req;
    assign router_13_14_req_in[3] = router_12_14_to_router_13_14_req;
    assign router_13_14_req_in[4] = magia_tile_ni_13_14_to_router_13_14_req;

    assign router_13_14_to_router_13_15_rsp = router_13_14_rsp_out[0];
    assign router_13_14_to_router_14_14_rsp = router_13_14_rsp_out[1];
    assign router_13_14_to_router_13_13_rsp = router_13_14_rsp_out[2];
    assign router_13_14_to_router_12_14_rsp = router_13_14_rsp_out[3];
    assign router_13_14_to_magia_tile_ni_13_14_rsp = router_13_14_rsp_out[4];

    assign router_13_14_to_router_13_15_req = router_13_14_req_out[0];
    assign router_13_14_to_router_14_14_req = router_13_14_req_out[1];
    assign router_13_14_to_router_13_13_req = router_13_14_req_out[2];
    assign router_13_14_to_router_12_14_req = router_13_14_req_out[3];
    assign router_13_14_to_magia_tile_ni_13_14_req = router_13_14_req_out[4];

    assign router_13_14_rsp_in[0] = router_13_15_to_router_13_14_rsp;
    assign router_13_14_rsp_in[1] = router_14_14_to_router_13_14_rsp;
    assign router_13_14_rsp_in[2] = router_13_13_to_router_13_14_rsp;
    assign router_13_14_rsp_in[3] = router_12_14_to_router_13_14_rsp;
    assign router_13_14_rsp_in[4] = magia_tile_ni_13_14_to_router_13_14_rsp;

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
) router_13_14 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 14, y: 14, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_13_14_req_in),
  .floo_rsp_o (router_13_14_rsp_out),
  .floo_req_o (router_13_14_req_out),
  .floo_rsp_i (router_13_14_rsp_in)
);


floo_req_t [4:0] router_13_15_req_in;
floo_rsp_t [4:0] router_13_15_rsp_out;
floo_req_t [4:0] router_13_15_req_out;
floo_rsp_t [4:0] router_13_15_rsp_in;

    assign router_13_15_req_in[0] = '0;
    assign router_13_15_req_in[1] = router_14_15_to_router_13_15_req;
    assign router_13_15_req_in[2] = router_13_14_to_router_13_15_req;
    assign router_13_15_req_in[3] = router_12_15_to_router_13_15_req;
    assign router_13_15_req_in[4] = magia_tile_ni_13_15_to_router_13_15_req;

    assign router_13_15_to_router_14_15_rsp = router_13_15_rsp_out[1];
    assign router_13_15_to_router_13_14_rsp = router_13_15_rsp_out[2];
    assign router_13_15_to_router_12_15_rsp = router_13_15_rsp_out[3];
    assign router_13_15_to_magia_tile_ni_13_15_rsp = router_13_15_rsp_out[4];

    assign router_13_15_to_router_14_15_req = router_13_15_req_out[1];
    assign router_13_15_to_router_13_14_req = router_13_15_req_out[2];
    assign router_13_15_to_router_12_15_req = router_13_15_req_out[3];
    assign router_13_15_to_magia_tile_ni_13_15_req = router_13_15_req_out[4];

    assign router_13_15_rsp_in[0] = '0;
    assign router_13_15_rsp_in[1] = router_14_15_to_router_13_15_rsp;
    assign router_13_15_rsp_in[2] = router_13_14_to_router_13_15_rsp;
    assign router_13_15_rsp_in[3] = router_12_15_to_router_13_15_rsp;
    assign router_13_15_rsp_in[4] = magia_tile_ni_13_15_to_router_13_15_rsp;

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
) router_13_15 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 14, y: 15, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_13_15_req_in),
  .floo_rsp_o (router_13_15_rsp_out),
  .floo_req_o (router_13_15_req_out),
  .floo_rsp_i (router_13_15_rsp_in)
);


floo_req_t [4:0] router_14_0_req_in;
floo_rsp_t [4:0] router_14_0_rsp_out;
floo_req_t [4:0] router_14_0_req_out;
floo_rsp_t [4:0] router_14_0_rsp_in;

    assign router_14_0_req_in[0] = router_14_1_to_router_14_0_req;
    assign router_14_0_req_in[1] = router_15_0_to_router_14_0_req;
    assign router_14_0_req_in[2] = '0;
    assign router_14_0_req_in[3] = router_13_0_to_router_14_0_req;
    assign router_14_0_req_in[4] = magia_tile_ni_14_0_to_router_14_0_req;

    assign router_14_0_to_router_14_1_rsp = router_14_0_rsp_out[0];
    assign router_14_0_to_router_15_0_rsp = router_14_0_rsp_out[1];
    assign router_14_0_to_router_13_0_rsp = router_14_0_rsp_out[3];
    assign router_14_0_to_magia_tile_ni_14_0_rsp = router_14_0_rsp_out[4];

    assign router_14_0_to_router_14_1_req = router_14_0_req_out[0];
    assign router_14_0_to_router_15_0_req = router_14_0_req_out[1];
    assign router_14_0_to_router_13_0_req = router_14_0_req_out[3];
    assign router_14_0_to_magia_tile_ni_14_0_req = router_14_0_req_out[4];

    assign router_14_0_rsp_in[0] = router_14_1_to_router_14_0_rsp;
    assign router_14_0_rsp_in[1] = router_15_0_to_router_14_0_rsp;
    assign router_14_0_rsp_in[2] = '0;
    assign router_14_0_rsp_in[3] = router_13_0_to_router_14_0_rsp;
    assign router_14_0_rsp_in[4] = magia_tile_ni_14_0_to_router_14_0_rsp;

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
) router_14_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 15, y: 0, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_14_0_req_in),
  .floo_rsp_o (router_14_0_rsp_out),
  .floo_req_o (router_14_0_req_out),
  .floo_rsp_i (router_14_0_rsp_in)
);


floo_req_t [4:0] router_14_1_req_in;
floo_rsp_t [4:0] router_14_1_rsp_out;
floo_req_t [4:0] router_14_1_req_out;
floo_rsp_t [4:0] router_14_1_rsp_in;

    assign router_14_1_req_in[0] = router_14_2_to_router_14_1_req;
    assign router_14_1_req_in[1] = router_15_1_to_router_14_1_req;
    assign router_14_1_req_in[2] = router_14_0_to_router_14_1_req;
    assign router_14_1_req_in[3] = router_13_1_to_router_14_1_req;
    assign router_14_1_req_in[4] = magia_tile_ni_14_1_to_router_14_1_req;

    assign router_14_1_to_router_14_2_rsp = router_14_1_rsp_out[0];
    assign router_14_1_to_router_15_1_rsp = router_14_1_rsp_out[1];
    assign router_14_1_to_router_14_0_rsp = router_14_1_rsp_out[2];
    assign router_14_1_to_router_13_1_rsp = router_14_1_rsp_out[3];
    assign router_14_1_to_magia_tile_ni_14_1_rsp = router_14_1_rsp_out[4];

    assign router_14_1_to_router_14_2_req = router_14_1_req_out[0];
    assign router_14_1_to_router_15_1_req = router_14_1_req_out[1];
    assign router_14_1_to_router_14_0_req = router_14_1_req_out[2];
    assign router_14_1_to_router_13_1_req = router_14_1_req_out[3];
    assign router_14_1_to_magia_tile_ni_14_1_req = router_14_1_req_out[4];

    assign router_14_1_rsp_in[0] = router_14_2_to_router_14_1_rsp;
    assign router_14_1_rsp_in[1] = router_15_1_to_router_14_1_rsp;
    assign router_14_1_rsp_in[2] = router_14_0_to_router_14_1_rsp;
    assign router_14_1_rsp_in[3] = router_13_1_to_router_14_1_rsp;
    assign router_14_1_rsp_in[4] = magia_tile_ni_14_1_to_router_14_1_rsp;

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
) router_14_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 15, y: 1, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_14_1_req_in),
  .floo_rsp_o (router_14_1_rsp_out),
  .floo_req_o (router_14_1_req_out),
  .floo_rsp_i (router_14_1_rsp_in)
);


floo_req_t [4:0] router_14_2_req_in;
floo_rsp_t [4:0] router_14_2_rsp_out;
floo_req_t [4:0] router_14_2_req_out;
floo_rsp_t [4:0] router_14_2_rsp_in;

    assign router_14_2_req_in[0] = router_14_3_to_router_14_2_req;
    assign router_14_2_req_in[1] = router_15_2_to_router_14_2_req;
    assign router_14_2_req_in[2] = router_14_1_to_router_14_2_req;
    assign router_14_2_req_in[3] = router_13_2_to_router_14_2_req;
    assign router_14_2_req_in[4] = magia_tile_ni_14_2_to_router_14_2_req;

    assign router_14_2_to_router_14_3_rsp = router_14_2_rsp_out[0];
    assign router_14_2_to_router_15_2_rsp = router_14_2_rsp_out[1];
    assign router_14_2_to_router_14_1_rsp = router_14_2_rsp_out[2];
    assign router_14_2_to_router_13_2_rsp = router_14_2_rsp_out[3];
    assign router_14_2_to_magia_tile_ni_14_2_rsp = router_14_2_rsp_out[4];

    assign router_14_2_to_router_14_3_req = router_14_2_req_out[0];
    assign router_14_2_to_router_15_2_req = router_14_2_req_out[1];
    assign router_14_2_to_router_14_1_req = router_14_2_req_out[2];
    assign router_14_2_to_router_13_2_req = router_14_2_req_out[3];
    assign router_14_2_to_magia_tile_ni_14_2_req = router_14_2_req_out[4];

    assign router_14_2_rsp_in[0] = router_14_3_to_router_14_2_rsp;
    assign router_14_2_rsp_in[1] = router_15_2_to_router_14_2_rsp;
    assign router_14_2_rsp_in[2] = router_14_1_to_router_14_2_rsp;
    assign router_14_2_rsp_in[3] = router_13_2_to_router_14_2_rsp;
    assign router_14_2_rsp_in[4] = magia_tile_ni_14_2_to_router_14_2_rsp;

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
) router_14_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 15, y: 2, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_14_2_req_in),
  .floo_rsp_o (router_14_2_rsp_out),
  .floo_req_o (router_14_2_req_out),
  .floo_rsp_i (router_14_2_rsp_in)
);


floo_req_t [4:0] router_14_3_req_in;
floo_rsp_t [4:0] router_14_3_rsp_out;
floo_req_t [4:0] router_14_3_req_out;
floo_rsp_t [4:0] router_14_3_rsp_in;

    assign router_14_3_req_in[0] = router_14_4_to_router_14_3_req;
    assign router_14_3_req_in[1] = router_15_3_to_router_14_3_req;
    assign router_14_3_req_in[2] = router_14_2_to_router_14_3_req;
    assign router_14_3_req_in[3] = router_13_3_to_router_14_3_req;
    assign router_14_3_req_in[4] = magia_tile_ni_14_3_to_router_14_3_req;

    assign router_14_3_to_router_14_4_rsp = router_14_3_rsp_out[0];
    assign router_14_3_to_router_15_3_rsp = router_14_3_rsp_out[1];
    assign router_14_3_to_router_14_2_rsp = router_14_3_rsp_out[2];
    assign router_14_3_to_router_13_3_rsp = router_14_3_rsp_out[3];
    assign router_14_3_to_magia_tile_ni_14_3_rsp = router_14_3_rsp_out[4];

    assign router_14_3_to_router_14_4_req = router_14_3_req_out[0];
    assign router_14_3_to_router_15_3_req = router_14_3_req_out[1];
    assign router_14_3_to_router_14_2_req = router_14_3_req_out[2];
    assign router_14_3_to_router_13_3_req = router_14_3_req_out[3];
    assign router_14_3_to_magia_tile_ni_14_3_req = router_14_3_req_out[4];

    assign router_14_3_rsp_in[0] = router_14_4_to_router_14_3_rsp;
    assign router_14_3_rsp_in[1] = router_15_3_to_router_14_3_rsp;
    assign router_14_3_rsp_in[2] = router_14_2_to_router_14_3_rsp;
    assign router_14_3_rsp_in[3] = router_13_3_to_router_14_3_rsp;
    assign router_14_3_rsp_in[4] = magia_tile_ni_14_3_to_router_14_3_rsp;

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
) router_14_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 15, y: 3, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_14_3_req_in),
  .floo_rsp_o (router_14_3_rsp_out),
  .floo_req_o (router_14_3_req_out),
  .floo_rsp_i (router_14_3_rsp_in)
);


floo_req_t [4:0] router_14_4_req_in;
floo_rsp_t [4:0] router_14_4_rsp_out;
floo_req_t [4:0] router_14_4_req_out;
floo_rsp_t [4:0] router_14_4_rsp_in;

    assign router_14_4_req_in[0] = router_14_5_to_router_14_4_req;
    assign router_14_4_req_in[1] = router_15_4_to_router_14_4_req;
    assign router_14_4_req_in[2] = router_14_3_to_router_14_4_req;
    assign router_14_4_req_in[3] = router_13_4_to_router_14_4_req;
    assign router_14_4_req_in[4] = magia_tile_ni_14_4_to_router_14_4_req;

    assign router_14_4_to_router_14_5_rsp = router_14_4_rsp_out[0];
    assign router_14_4_to_router_15_4_rsp = router_14_4_rsp_out[1];
    assign router_14_4_to_router_14_3_rsp = router_14_4_rsp_out[2];
    assign router_14_4_to_router_13_4_rsp = router_14_4_rsp_out[3];
    assign router_14_4_to_magia_tile_ni_14_4_rsp = router_14_4_rsp_out[4];

    assign router_14_4_to_router_14_5_req = router_14_4_req_out[0];
    assign router_14_4_to_router_15_4_req = router_14_4_req_out[1];
    assign router_14_4_to_router_14_3_req = router_14_4_req_out[2];
    assign router_14_4_to_router_13_4_req = router_14_4_req_out[3];
    assign router_14_4_to_magia_tile_ni_14_4_req = router_14_4_req_out[4];

    assign router_14_4_rsp_in[0] = router_14_5_to_router_14_4_rsp;
    assign router_14_4_rsp_in[1] = router_15_4_to_router_14_4_rsp;
    assign router_14_4_rsp_in[2] = router_14_3_to_router_14_4_rsp;
    assign router_14_4_rsp_in[3] = router_13_4_to_router_14_4_rsp;
    assign router_14_4_rsp_in[4] = magia_tile_ni_14_4_to_router_14_4_rsp;

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
) router_14_4 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 15, y: 4, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_14_4_req_in),
  .floo_rsp_o (router_14_4_rsp_out),
  .floo_req_o (router_14_4_req_out),
  .floo_rsp_i (router_14_4_rsp_in)
);


floo_req_t [4:0] router_14_5_req_in;
floo_rsp_t [4:0] router_14_5_rsp_out;
floo_req_t [4:0] router_14_5_req_out;
floo_rsp_t [4:0] router_14_5_rsp_in;

    assign router_14_5_req_in[0] = router_14_6_to_router_14_5_req;
    assign router_14_5_req_in[1] = router_15_5_to_router_14_5_req;
    assign router_14_5_req_in[2] = router_14_4_to_router_14_5_req;
    assign router_14_5_req_in[3] = router_13_5_to_router_14_5_req;
    assign router_14_5_req_in[4] = magia_tile_ni_14_5_to_router_14_5_req;

    assign router_14_5_to_router_14_6_rsp = router_14_5_rsp_out[0];
    assign router_14_5_to_router_15_5_rsp = router_14_5_rsp_out[1];
    assign router_14_5_to_router_14_4_rsp = router_14_5_rsp_out[2];
    assign router_14_5_to_router_13_5_rsp = router_14_5_rsp_out[3];
    assign router_14_5_to_magia_tile_ni_14_5_rsp = router_14_5_rsp_out[4];

    assign router_14_5_to_router_14_6_req = router_14_5_req_out[0];
    assign router_14_5_to_router_15_5_req = router_14_5_req_out[1];
    assign router_14_5_to_router_14_4_req = router_14_5_req_out[2];
    assign router_14_5_to_router_13_5_req = router_14_5_req_out[3];
    assign router_14_5_to_magia_tile_ni_14_5_req = router_14_5_req_out[4];

    assign router_14_5_rsp_in[0] = router_14_6_to_router_14_5_rsp;
    assign router_14_5_rsp_in[1] = router_15_5_to_router_14_5_rsp;
    assign router_14_5_rsp_in[2] = router_14_4_to_router_14_5_rsp;
    assign router_14_5_rsp_in[3] = router_13_5_to_router_14_5_rsp;
    assign router_14_5_rsp_in[4] = magia_tile_ni_14_5_to_router_14_5_rsp;

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
) router_14_5 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 15, y: 5, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_14_5_req_in),
  .floo_rsp_o (router_14_5_rsp_out),
  .floo_req_o (router_14_5_req_out),
  .floo_rsp_i (router_14_5_rsp_in)
);


floo_req_t [4:0] router_14_6_req_in;
floo_rsp_t [4:0] router_14_6_rsp_out;
floo_req_t [4:0] router_14_6_req_out;
floo_rsp_t [4:0] router_14_6_rsp_in;

    assign router_14_6_req_in[0] = router_14_7_to_router_14_6_req;
    assign router_14_6_req_in[1] = router_15_6_to_router_14_6_req;
    assign router_14_6_req_in[2] = router_14_5_to_router_14_6_req;
    assign router_14_6_req_in[3] = router_13_6_to_router_14_6_req;
    assign router_14_6_req_in[4] = magia_tile_ni_14_6_to_router_14_6_req;

    assign router_14_6_to_router_14_7_rsp = router_14_6_rsp_out[0];
    assign router_14_6_to_router_15_6_rsp = router_14_6_rsp_out[1];
    assign router_14_6_to_router_14_5_rsp = router_14_6_rsp_out[2];
    assign router_14_6_to_router_13_6_rsp = router_14_6_rsp_out[3];
    assign router_14_6_to_magia_tile_ni_14_6_rsp = router_14_6_rsp_out[4];

    assign router_14_6_to_router_14_7_req = router_14_6_req_out[0];
    assign router_14_6_to_router_15_6_req = router_14_6_req_out[1];
    assign router_14_6_to_router_14_5_req = router_14_6_req_out[2];
    assign router_14_6_to_router_13_6_req = router_14_6_req_out[3];
    assign router_14_6_to_magia_tile_ni_14_6_req = router_14_6_req_out[4];

    assign router_14_6_rsp_in[0] = router_14_7_to_router_14_6_rsp;
    assign router_14_6_rsp_in[1] = router_15_6_to_router_14_6_rsp;
    assign router_14_6_rsp_in[2] = router_14_5_to_router_14_6_rsp;
    assign router_14_6_rsp_in[3] = router_13_6_to_router_14_6_rsp;
    assign router_14_6_rsp_in[4] = magia_tile_ni_14_6_to_router_14_6_rsp;

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
) router_14_6 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 15, y: 6, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_14_6_req_in),
  .floo_rsp_o (router_14_6_rsp_out),
  .floo_req_o (router_14_6_req_out),
  .floo_rsp_i (router_14_6_rsp_in)
);


floo_req_t [4:0] router_14_7_req_in;
floo_rsp_t [4:0] router_14_7_rsp_out;
floo_req_t [4:0] router_14_7_req_out;
floo_rsp_t [4:0] router_14_7_rsp_in;

    assign router_14_7_req_in[0] = router_14_8_to_router_14_7_req;
    assign router_14_7_req_in[1] = router_15_7_to_router_14_7_req;
    assign router_14_7_req_in[2] = router_14_6_to_router_14_7_req;
    assign router_14_7_req_in[3] = router_13_7_to_router_14_7_req;
    assign router_14_7_req_in[4] = magia_tile_ni_14_7_to_router_14_7_req;

    assign router_14_7_to_router_14_8_rsp = router_14_7_rsp_out[0];
    assign router_14_7_to_router_15_7_rsp = router_14_7_rsp_out[1];
    assign router_14_7_to_router_14_6_rsp = router_14_7_rsp_out[2];
    assign router_14_7_to_router_13_7_rsp = router_14_7_rsp_out[3];
    assign router_14_7_to_magia_tile_ni_14_7_rsp = router_14_7_rsp_out[4];

    assign router_14_7_to_router_14_8_req = router_14_7_req_out[0];
    assign router_14_7_to_router_15_7_req = router_14_7_req_out[1];
    assign router_14_7_to_router_14_6_req = router_14_7_req_out[2];
    assign router_14_7_to_router_13_7_req = router_14_7_req_out[3];
    assign router_14_7_to_magia_tile_ni_14_7_req = router_14_7_req_out[4];

    assign router_14_7_rsp_in[0] = router_14_8_to_router_14_7_rsp;
    assign router_14_7_rsp_in[1] = router_15_7_to_router_14_7_rsp;
    assign router_14_7_rsp_in[2] = router_14_6_to_router_14_7_rsp;
    assign router_14_7_rsp_in[3] = router_13_7_to_router_14_7_rsp;
    assign router_14_7_rsp_in[4] = magia_tile_ni_14_7_to_router_14_7_rsp;

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
) router_14_7 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 15, y: 7, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_14_7_req_in),
  .floo_rsp_o (router_14_7_rsp_out),
  .floo_req_o (router_14_7_req_out),
  .floo_rsp_i (router_14_7_rsp_in)
);


floo_req_t [4:0] router_14_8_req_in;
floo_rsp_t [4:0] router_14_8_rsp_out;
floo_req_t [4:0] router_14_8_req_out;
floo_rsp_t [4:0] router_14_8_rsp_in;

    assign router_14_8_req_in[0] = router_14_9_to_router_14_8_req;
    assign router_14_8_req_in[1] = router_15_8_to_router_14_8_req;
    assign router_14_8_req_in[2] = router_14_7_to_router_14_8_req;
    assign router_14_8_req_in[3] = router_13_8_to_router_14_8_req;
    assign router_14_8_req_in[4] = magia_tile_ni_14_8_to_router_14_8_req;

    assign router_14_8_to_router_14_9_rsp = router_14_8_rsp_out[0];
    assign router_14_8_to_router_15_8_rsp = router_14_8_rsp_out[1];
    assign router_14_8_to_router_14_7_rsp = router_14_8_rsp_out[2];
    assign router_14_8_to_router_13_8_rsp = router_14_8_rsp_out[3];
    assign router_14_8_to_magia_tile_ni_14_8_rsp = router_14_8_rsp_out[4];

    assign router_14_8_to_router_14_9_req = router_14_8_req_out[0];
    assign router_14_8_to_router_15_8_req = router_14_8_req_out[1];
    assign router_14_8_to_router_14_7_req = router_14_8_req_out[2];
    assign router_14_8_to_router_13_8_req = router_14_8_req_out[3];
    assign router_14_8_to_magia_tile_ni_14_8_req = router_14_8_req_out[4];

    assign router_14_8_rsp_in[0] = router_14_9_to_router_14_8_rsp;
    assign router_14_8_rsp_in[1] = router_15_8_to_router_14_8_rsp;
    assign router_14_8_rsp_in[2] = router_14_7_to_router_14_8_rsp;
    assign router_14_8_rsp_in[3] = router_13_8_to_router_14_8_rsp;
    assign router_14_8_rsp_in[4] = magia_tile_ni_14_8_to_router_14_8_rsp;

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
) router_14_8 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 15, y: 8, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_14_8_req_in),
  .floo_rsp_o (router_14_8_rsp_out),
  .floo_req_o (router_14_8_req_out),
  .floo_rsp_i (router_14_8_rsp_in)
);


floo_req_t [4:0] router_14_9_req_in;
floo_rsp_t [4:0] router_14_9_rsp_out;
floo_req_t [4:0] router_14_9_req_out;
floo_rsp_t [4:0] router_14_9_rsp_in;

    assign router_14_9_req_in[0] = router_14_10_to_router_14_9_req;
    assign router_14_9_req_in[1] = router_15_9_to_router_14_9_req;
    assign router_14_9_req_in[2] = router_14_8_to_router_14_9_req;
    assign router_14_9_req_in[3] = router_13_9_to_router_14_9_req;
    assign router_14_9_req_in[4] = magia_tile_ni_14_9_to_router_14_9_req;

    assign router_14_9_to_router_14_10_rsp = router_14_9_rsp_out[0];
    assign router_14_9_to_router_15_9_rsp = router_14_9_rsp_out[1];
    assign router_14_9_to_router_14_8_rsp = router_14_9_rsp_out[2];
    assign router_14_9_to_router_13_9_rsp = router_14_9_rsp_out[3];
    assign router_14_9_to_magia_tile_ni_14_9_rsp = router_14_9_rsp_out[4];

    assign router_14_9_to_router_14_10_req = router_14_9_req_out[0];
    assign router_14_9_to_router_15_9_req = router_14_9_req_out[1];
    assign router_14_9_to_router_14_8_req = router_14_9_req_out[2];
    assign router_14_9_to_router_13_9_req = router_14_9_req_out[3];
    assign router_14_9_to_magia_tile_ni_14_9_req = router_14_9_req_out[4];

    assign router_14_9_rsp_in[0] = router_14_10_to_router_14_9_rsp;
    assign router_14_9_rsp_in[1] = router_15_9_to_router_14_9_rsp;
    assign router_14_9_rsp_in[2] = router_14_8_to_router_14_9_rsp;
    assign router_14_9_rsp_in[3] = router_13_9_to_router_14_9_rsp;
    assign router_14_9_rsp_in[4] = magia_tile_ni_14_9_to_router_14_9_rsp;

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
) router_14_9 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 15, y: 9, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_14_9_req_in),
  .floo_rsp_o (router_14_9_rsp_out),
  .floo_req_o (router_14_9_req_out),
  .floo_rsp_i (router_14_9_rsp_in)
);


floo_req_t [4:0] router_14_10_req_in;
floo_rsp_t [4:0] router_14_10_rsp_out;
floo_req_t [4:0] router_14_10_req_out;
floo_rsp_t [4:0] router_14_10_rsp_in;

    assign router_14_10_req_in[0] = router_14_11_to_router_14_10_req;
    assign router_14_10_req_in[1] = router_15_10_to_router_14_10_req;
    assign router_14_10_req_in[2] = router_14_9_to_router_14_10_req;
    assign router_14_10_req_in[3] = router_13_10_to_router_14_10_req;
    assign router_14_10_req_in[4] = magia_tile_ni_14_10_to_router_14_10_req;

    assign router_14_10_to_router_14_11_rsp = router_14_10_rsp_out[0];
    assign router_14_10_to_router_15_10_rsp = router_14_10_rsp_out[1];
    assign router_14_10_to_router_14_9_rsp = router_14_10_rsp_out[2];
    assign router_14_10_to_router_13_10_rsp = router_14_10_rsp_out[3];
    assign router_14_10_to_magia_tile_ni_14_10_rsp = router_14_10_rsp_out[4];

    assign router_14_10_to_router_14_11_req = router_14_10_req_out[0];
    assign router_14_10_to_router_15_10_req = router_14_10_req_out[1];
    assign router_14_10_to_router_14_9_req = router_14_10_req_out[2];
    assign router_14_10_to_router_13_10_req = router_14_10_req_out[3];
    assign router_14_10_to_magia_tile_ni_14_10_req = router_14_10_req_out[4];

    assign router_14_10_rsp_in[0] = router_14_11_to_router_14_10_rsp;
    assign router_14_10_rsp_in[1] = router_15_10_to_router_14_10_rsp;
    assign router_14_10_rsp_in[2] = router_14_9_to_router_14_10_rsp;
    assign router_14_10_rsp_in[3] = router_13_10_to_router_14_10_rsp;
    assign router_14_10_rsp_in[4] = magia_tile_ni_14_10_to_router_14_10_rsp;

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
) router_14_10 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 15, y: 10, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_14_10_req_in),
  .floo_rsp_o (router_14_10_rsp_out),
  .floo_req_o (router_14_10_req_out),
  .floo_rsp_i (router_14_10_rsp_in)
);


floo_req_t [4:0] router_14_11_req_in;
floo_rsp_t [4:0] router_14_11_rsp_out;
floo_req_t [4:0] router_14_11_req_out;
floo_rsp_t [4:0] router_14_11_rsp_in;

    assign router_14_11_req_in[0] = router_14_12_to_router_14_11_req;
    assign router_14_11_req_in[1] = router_15_11_to_router_14_11_req;
    assign router_14_11_req_in[2] = router_14_10_to_router_14_11_req;
    assign router_14_11_req_in[3] = router_13_11_to_router_14_11_req;
    assign router_14_11_req_in[4] = magia_tile_ni_14_11_to_router_14_11_req;

    assign router_14_11_to_router_14_12_rsp = router_14_11_rsp_out[0];
    assign router_14_11_to_router_15_11_rsp = router_14_11_rsp_out[1];
    assign router_14_11_to_router_14_10_rsp = router_14_11_rsp_out[2];
    assign router_14_11_to_router_13_11_rsp = router_14_11_rsp_out[3];
    assign router_14_11_to_magia_tile_ni_14_11_rsp = router_14_11_rsp_out[4];

    assign router_14_11_to_router_14_12_req = router_14_11_req_out[0];
    assign router_14_11_to_router_15_11_req = router_14_11_req_out[1];
    assign router_14_11_to_router_14_10_req = router_14_11_req_out[2];
    assign router_14_11_to_router_13_11_req = router_14_11_req_out[3];
    assign router_14_11_to_magia_tile_ni_14_11_req = router_14_11_req_out[4];

    assign router_14_11_rsp_in[0] = router_14_12_to_router_14_11_rsp;
    assign router_14_11_rsp_in[1] = router_15_11_to_router_14_11_rsp;
    assign router_14_11_rsp_in[2] = router_14_10_to_router_14_11_rsp;
    assign router_14_11_rsp_in[3] = router_13_11_to_router_14_11_rsp;
    assign router_14_11_rsp_in[4] = magia_tile_ni_14_11_to_router_14_11_rsp;

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
) router_14_11 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 15, y: 11, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_14_11_req_in),
  .floo_rsp_o (router_14_11_rsp_out),
  .floo_req_o (router_14_11_req_out),
  .floo_rsp_i (router_14_11_rsp_in)
);


floo_req_t [4:0] router_14_12_req_in;
floo_rsp_t [4:0] router_14_12_rsp_out;
floo_req_t [4:0] router_14_12_req_out;
floo_rsp_t [4:0] router_14_12_rsp_in;

    assign router_14_12_req_in[0] = router_14_13_to_router_14_12_req;
    assign router_14_12_req_in[1] = router_15_12_to_router_14_12_req;
    assign router_14_12_req_in[2] = router_14_11_to_router_14_12_req;
    assign router_14_12_req_in[3] = router_13_12_to_router_14_12_req;
    assign router_14_12_req_in[4] = magia_tile_ni_14_12_to_router_14_12_req;

    assign router_14_12_to_router_14_13_rsp = router_14_12_rsp_out[0];
    assign router_14_12_to_router_15_12_rsp = router_14_12_rsp_out[1];
    assign router_14_12_to_router_14_11_rsp = router_14_12_rsp_out[2];
    assign router_14_12_to_router_13_12_rsp = router_14_12_rsp_out[3];
    assign router_14_12_to_magia_tile_ni_14_12_rsp = router_14_12_rsp_out[4];

    assign router_14_12_to_router_14_13_req = router_14_12_req_out[0];
    assign router_14_12_to_router_15_12_req = router_14_12_req_out[1];
    assign router_14_12_to_router_14_11_req = router_14_12_req_out[2];
    assign router_14_12_to_router_13_12_req = router_14_12_req_out[3];
    assign router_14_12_to_magia_tile_ni_14_12_req = router_14_12_req_out[4];

    assign router_14_12_rsp_in[0] = router_14_13_to_router_14_12_rsp;
    assign router_14_12_rsp_in[1] = router_15_12_to_router_14_12_rsp;
    assign router_14_12_rsp_in[2] = router_14_11_to_router_14_12_rsp;
    assign router_14_12_rsp_in[3] = router_13_12_to_router_14_12_rsp;
    assign router_14_12_rsp_in[4] = magia_tile_ni_14_12_to_router_14_12_rsp;

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
) router_14_12 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 15, y: 12, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_14_12_req_in),
  .floo_rsp_o (router_14_12_rsp_out),
  .floo_req_o (router_14_12_req_out),
  .floo_rsp_i (router_14_12_rsp_in)
);


floo_req_t [4:0] router_14_13_req_in;
floo_rsp_t [4:0] router_14_13_rsp_out;
floo_req_t [4:0] router_14_13_req_out;
floo_rsp_t [4:0] router_14_13_rsp_in;

    assign router_14_13_req_in[0] = router_14_14_to_router_14_13_req;
    assign router_14_13_req_in[1] = router_15_13_to_router_14_13_req;
    assign router_14_13_req_in[2] = router_14_12_to_router_14_13_req;
    assign router_14_13_req_in[3] = router_13_13_to_router_14_13_req;
    assign router_14_13_req_in[4] = magia_tile_ni_14_13_to_router_14_13_req;

    assign router_14_13_to_router_14_14_rsp = router_14_13_rsp_out[0];
    assign router_14_13_to_router_15_13_rsp = router_14_13_rsp_out[1];
    assign router_14_13_to_router_14_12_rsp = router_14_13_rsp_out[2];
    assign router_14_13_to_router_13_13_rsp = router_14_13_rsp_out[3];
    assign router_14_13_to_magia_tile_ni_14_13_rsp = router_14_13_rsp_out[4];

    assign router_14_13_to_router_14_14_req = router_14_13_req_out[0];
    assign router_14_13_to_router_15_13_req = router_14_13_req_out[1];
    assign router_14_13_to_router_14_12_req = router_14_13_req_out[2];
    assign router_14_13_to_router_13_13_req = router_14_13_req_out[3];
    assign router_14_13_to_magia_tile_ni_14_13_req = router_14_13_req_out[4];

    assign router_14_13_rsp_in[0] = router_14_14_to_router_14_13_rsp;
    assign router_14_13_rsp_in[1] = router_15_13_to_router_14_13_rsp;
    assign router_14_13_rsp_in[2] = router_14_12_to_router_14_13_rsp;
    assign router_14_13_rsp_in[3] = router_13_13_to_router_14_13_rsp;
    assign router_14_13_rsp_in[4] = magia_tile_ni_14_13_to_router_14_13_rsp;

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
) router_14_13 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 15, y: 13, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_14_13_req_in),
  .floo_rsp_o (router_14_13_rsp_out),
  .floo_req_o (router_14_13_req_out),
  .floo_rsp_i (router_14_13_rsp_in)
);


floo_req_t [4:0] router_14_14_req_in;
floo_rsp_t [4:0] router_14_14_rsp_out;
floo_req_t [4:0] router_14_14_req_out;
floo_rsp_t [4:0] router_14_14_rsp_in;

    assign router_14_14_req_in[0] = router_14_15_to_router_14_14_req;
    assign router_14_14_req_in[1] = router_15_14_to_router_14_14_req;
    assign router_14_14_req_in[2] = router_14_13_to_router_14_14_req;
    assign router_14_14_req_in[3] = router_13_14_to_router_14_14_req;
    assign router_14_14_req_in[4] = magia_tile_ni_14_14_to_router_14_14_req;

    assign router_14_14_to_router_14_15_rsp = router_14_14_rsp_out[0];
    assign router_14_14_to_router_15_14_rsp = router_14_14_rsp_out[1];
    assign router_14_14_to_router_14_13_rsp = router_14_14_rsp_out[2];
    assign router_14_14_to_router_13_14_rsp = router_14_14_rsp_out[3];
    assign router_14_14_to_magia_tile_ni_14_14_rsp = router_14_14_rsp_out[4];

    assign router_14_14_to_router_14_15_req = router_14_14_req_out[0];
    assign router_14_14_to_router_15_14_req = router_14_14_req_out[1];
    assign router_14_14_to_router_14_13_req = router_14_14_req_out[2];
    assign router_14_14_to_router_13_14_req = router_14_14_req_out[3];
    assign router_14_14_to_magia_tile_ni_14_14_req = router_14_14_req_out[4];

    assign router_14_14_rsp_in[0] = router_14_15_to_router_14_14_rsp;
    assign router_14_14_rsp_in[1] = router_15_14_to_router_14_14_rsp;
    assign router_14_14_rsp_in[2] = router_14_13_to_router_14_14_rsp;
    assign router_14_14_rsp_in[3] = router_13_14_to_router_14_14_rsp;
    assign router_14_14_rsp_in[4] = magia_tile_ni_14_14_to_router_14_14_rsp;

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
) router_14_14 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 15, y: 14, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_14_14_req_in),
  .floo_rsp_o (router_14_14_rsp_out),
  .floo_req_o (router_14_14_req_out),
  .floo_rsp_i (router_14_14_rsp_in)
);


floo_req_t [4:0] router_14_15_req_in;
floo_rsp_t [4:0] router_14_15_rsp_out;
floo_req_t [4:0] router_14_15_req_out;
floo_rsp_t [4:0] router_14_15_rsp_in;

    assign router_14_15_req_in[0] = '0;
    assign router_14_15_req_in[1] = router_15_15_to_router_14_15_req;
    assign router_14_15_req_in[2] = router_14_14_to_router_14_15_req;
    assign router_14_15_req_in[3] = router_13_15_to_router_14_15_req;
    assign router_14_15_req_in[4] = magia_tile_ni_14_15_to_router_14_15_req;

    assign router_14_15_to_router_15_15_rsp = router_14_15_rsp_out[1];
    assign router_14_15_to_router_14_14_rsp = router_14_15_rsp_out[2];
    assign router_14_15_to_router_13_15_rsp = router_14_15_rsp_out[3];
    assign router_14_15_to_magia_tile_ni_14_15_rsp = router_14_15_rsp_out[4];

    assign router_14_15_to_router_15_15_req = router_14_15_req_out[1];
    assign router_14_15_to_router_14_14_req = router_14_15_req_out[2];
    assign router_14_15_to_router_13_15_req = router_14_15_req_out[3];
    assign router_14_15_to_magia_tile_ni_14_15_req = router_14_15_req_out[4];

    assign router_14_15_rsp_in[0] = '0;
    assign router_14_15_rsp_in[1] = router_15_15_to_router_14_15_rsp;
    assign router_14_15_rsp_in[2] = router_14_14_to_router_14_15_rsp;
    assign router_14_15_rsp_in[3] = router_13_15_to_router_14_15_rsp;
    assign router_14_15_rsp_in[4] = magia_tile_ni_14_15_to_router_14_15_rsp;

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
) router_14_15 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 15, y: 15, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_14_15_req_in),
  .floo_rsp_o (router_14_15_rsp_out),
  .floo_req_o (router_14_15_req_out),
  .floo_rsp_i (router_14_15_rsp_in)
);


floo_req_t [4:0] router_15_0_req_in;
floo_rsp_t [4:0] router_15_0_rsp_out;
floo_req_t [4:0] router_15_0_req_out;
floo_rsp_t [4:0] router_15_0_rsp_in;

    assign router_15_0_req_in[0] = router_15_1_to_router_15_0_req;
    assign router_15_0_req_in[1] = '0;
    assign router_15_0_req_in[2] = '0;
    assign router_15_0_req_in[3] = router_14_0_to_router_15_0_req;
    assign router_15_0_req_in[4] = magia_tile_ni_15_0_to_router_15_0_req;

    assign router_15_0_to_router_15_1_rsp = router_15_0_rsp_out[0];
    assign router_15_0_to_router_14_0_rsp = router_15_0_rsp_out[3];
    assign router_15_0_to_magia_tile_ni_15_0_rsp = router_15_0_rsp_out[4];

    assign router_15_0_to_router_15_1_req = router_15_0_req_out[0];
    assign router_15_0_to_router_14_0_req = router_15_0_req_out[3];
    assign router_15_0_to_magia_tile_ni_15_0_req = router_15_0_req_out[4];

    assign router_15_0_rsp_in[0] = router_15_1_to_router_15_0_rsp;
    assign router_15_0_rsp_in[1] = '0;
    assign router_15_0_rsp_in[2] = '0;
    assign router_15_0_rsp_in[3] = router_14_0_to_router_15_0_rsp;
    assign router_15_0_rsp_in[4] = magia_tile_ni_15_0_to_router_15_0_rsp;

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
) router_15_0 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 16, y: 0, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_15_0_req_in),
  .floo_rsp_o (router_15_0_rsp_out),
  .floo_req_o (router_15_0_req_out),
  .floo_rsp_i (router_15_0_rsp_in)
);


floo_req_t [4:0] router_15_1_req_in;
floo_rsp_t [4:0] router_15_1_rsp_out;
floo_req_t [4:0] router_15_1_req_out;
floo_rsp_t [4:0] router_15_1_rsp_in;

    assign router_15_1_req_in[0] = router_15_2_to_router_15_1_req;
    assign router_15_1_req_in[1] = '0;
    assign router_15_1_req_in[2] = router_15_0_to_router_15_1_req;
    assign router_15_1_req_in[3] = router_14_1_to_router_15_1_req;
    assign router_15_1_req_in[4] = magia_tile_ni_15_1_to_router_15_1_req;

    assign router_15_1_to_router_15_2_rsp = router_15_1_rsp_out[0];
    assign router_15_1_to_router_15_0_rsp = router_15_1_rsp_out[2];
    assign router_15_1_to_router_14_1_rsp = router_15_1_rsp_out[3];
    assign router_15_1_to_magia_tile_ni_15_1_rsp = router_15_1_rsp_out[4];

    assign router_15_1_to_router_15_2_req = router_15_1_req_out[0];
    assign router_15_1_to_router_15_0_req = router_15_1_req_out[2];
    assign router_15_1_to_router_14_1_req = router_15_1_req_out[3];
    assign router_15_1_to_magia_tile_ni_15_1_req = router_15_1_req_out[4];

    assign router_15_1_rsp_in[0] = router_15_2_to_router_15_1_rsp;
    assign router_15_1_rsp_in[1] = '0;
    assign router_15_1_rsp_in[2] = router_15_0_to_router_15_1_rsp;
    assign router_15_1_rsp_in[3] = router_14_1_to_router_15_1_rsp;
    assign router_15_1_rsp_in[4] = magia_tile_ni_15_1_to_router_15_1_rsp;

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
) router_15_1 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 16, y: 1, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_15_1_req_in),
  .floo_rsp_o (router_15_1_rsp_out),
  .floo_req_o (router_15_1_req_out),
  .floo_rsp_i (router_15_1_rsp_in)
);


floo_req_t [4:0] router_15_2_req_in;
floo_rsp_t [4:0] router_15_2_rsp_out;
floo_req_t [4:0] router_15_2_req_out;
floo_rsp_t [4:0] router_15_2_rsp_in;

    assign router_15_2_req_in[0] = router_15_3_to_router_15_2_req;
    assign router_15_2_req_in[1] = '0;
    assign router_15_2_req_in[2] = router_15_1_to_router_15_2_req;
    assign router_15_2_req_in[3] = router_14_2_to_router_15_2_req;
    assign router_15_2_req_in[4] = magia_tile_ni_15_2_to_router_15_2_req;

    assign router_15_2_to_router_15_3_rsp = router_15_2_rsp_out[0];
    assign router_15_2_to_router_15_1_rsp = router_15_2_rsp_out[2];
    assign router_15_2_to_router_14_2_rsp = router_15_2_rsp_out[3];
    assign router_15_2_to_magia_tile_ni_15_2_rsp = router_15_2_rsp_out[4];

    assign router_15_2_to_router_15_3_req = router_15_2_req_out[0];
    assign router_15_2_to_router_15_1_req = router_15_2_req_out[2];
    assign router_15_2_to_router_14_2_req = router_15_2_req_out[3];
    assign router_15_2_to_magia_tile_ni_15_2_req = router_15_2_req_out[4];

    assign router_15_2_rsp_in[0] = router_15_3_to_router_15_2_rsp;
    assign router_15_2_rsp_in[1] = '0;
    assign router_15_2_rsp_in[2] = router_15_1_to_router_15_2_rsp;
    assign router_15_2_rsp_in[3] = router_14_2_to_router_15_2_rsp;
    assign router_15_2_rsp_in[4] = magia_tile_ni_15_2_to_router_15_2_rsp;

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
) router_15_2 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 16, y: 2, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_15_2_req_in),
  .floo_rsp_o (router_15_2_rsp_out),
  .floo_req_o (router_15_2_req_out),
  .floo_rsp_i (router_15_2_rsp_in)
);


floo_req_t [4:0] router_15_3_req_in;
floo_rsp_t [4:0] router_15_3_rsp_out;
floo_req_t [4:0] router_15_3_req_out;
floo_rsp_t [4:0] router_15_3_rsp_in;

    assign router_15_3_req_in[0] = router_15_4_to_router_15_3_req;
    assign router_15_3_req_in[1] = '0;
    assign router_15_3_req_in[2] = router_15_2_to_router_15_3_req;
    assign router_15_3_req_in[3] = router_14_3_to_router_15_3_req;
    assign router_15_3_req_in[4] = magia_tile_ni_15_3_to_router_15_3_req;

    assign router_15_3_to_router_15_4_rsp = router_15_3_rsp_out[0];
    assign router_15_3_to_router_15_2_rsp = router_15_3_rsp_out[2];
    assign router_15_3_to_router_14_3_rsp = router_15_3_rsp_out[3];
    assign router_15_3_to_magia_tile_ni_15_3_rsp = router_15_3_rsp_out[4];

    assign router_15_3_to_router_15_4_req = router_15_3_req_out[0];
    assign router_15_3_to_router_15_2_req = router_15_3_req_out[2];
    assign router_15_3_to_router_14_3_req = router_15_3_req_out[3];
    assign router_15_3_to_magia_tile_ni_15_3_req = router_15_3_req_out[4];

    assign router_15_3_rsp_in[0] = router_15_4_to_router_15_3_rsp;
    assign router_15_3_rsp_in[1] = '0;
    assign router_15_3_rsp_in[2] = router_15_2_to_router_15_3_rsp;
    assign router_15_3_rsp_in[3] = router_14_3_to_router_15_3_rsp;
    assign router_15_3_rsp_in[4] = magia_tile_ni_15_3_to_router_15_3_rsp;

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
) router_15_3 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 16, y: 3, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_15_3_req_in),
  .floo_rsp_o (router_15_3_rsp_out),
  .floo_req_o (router_15_3_req_out),
  .floo_rsp_i (router_15_3_rsp_in)
);


floo_req_t [4:0] router_15_4_req_in;
floo_rsp_t [4:0] router_15_4_rsp_out;
floo_req_t [4:0] router_15_4_req_out;
floo_rsp_t [4:0] router_15_4_rsp_in;

    assign router_15_4_req_in[0] = router_15_5_to_router_15_4_req;
    assign router_15_4_req_in[1] = '0;
    assign router_15_4_req_in[2] = router_15_3_to_router_15_4_req;
    assign router_15_4_req_in[3] = router_14_4_to_router_15_4_req;
    assign router_15_4_req_in[4] = magia_tile_ni_15_4_to_router_15_4_req;

    assign router_15_4_to_router_15_5_rsp = router_15_4_rsp_out[0];
    assign router_15_4_to_router_15_3_rsp = router_15_4_rsp_out[2];
    assign router_15_4_to_router_14_4_rsp = router_15_4_rsp_out[3];
    assign router_15_4_to_magia_tile_ni_15_4_rsp = router_15_4_rsp_out[4];

    assign router_15_4_to_router_15_5_req = router_15_4_req_out[0];
    assign router_15_4_to_router_15_3_req = router_15_4_req_out[2];
    assign router_15_4_to_router_14_4_req = router_15_4_req_out[3];
    assign router_15_4_to_magia_tile_ni_15_4_req = router_15_4_req_out[4];

    assign router_15_4_rsp_in[0] = router_15_5_to_router_15_4_rsp;
    assign router_15_4_rsp_in[1] = '0;
    assign router_15_4_rsp_in[2] = router_15_3_to_router_15_4_rsp;
    assign router_15_4_rsp_in[3] = router_14_4_to_router_15_4_rsp;
    assign router_15_4_rsp_in[4] = magia_tile_ni_15_4_to_router_15_4_rsp;

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
) router_15_4 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 16, y: 4, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_15_4_req_in),
  .floo_rsp_o (router_15_4_rsp_out),
  .floo_req_o (router_15_4_req_out),
  .floo_rsp_i (router_15_4_rsp_in)
);


floo_req_t [4:0] router_15_5_req_in;
floo_rsp_t [4:0] router_15_5_rsp_out;
floo_req_t [4:0] router_15_5_req_out;
floo_rsp_t [4:0] router_15_5_rsp_in;

    assign router_15_5_req_in[0] = router_15_6_to_router_15_5_req;
    assign router_15_5_req_in[1] = '0;
    assign router_15_5_req_in[2] = router_15_4_to_router_15_5_req;
    assign router_15_5_req_in[3] = router_14_5_to_router_15_5_req;
    assign router_15_5_req_in[4] = magia_tile_ni_15_5_to_router_15_5_req;

    assign router_15_5_to_router_15_6_rsp = router_15_5_rsp_out[0];
    assign router_15_5_to_router_15_4_rsp = router_15_5_rsp_out[2];
    assign router_15_5_to_router_14_5_rsp = router_15_5_rsp_out[3];
    assign router_15_5_to_magia_tile_ni_15_5_rsp = router_15_5_rsp_out[4];

    assign router_15_5_to_router_15_6_req = router_15_5_req_out[0];
    assign router_15_5_to_router_15_4_req = router_15_5_req_out[2];
    assign router_15_5_to_router_14_5_req = router_15_5_req_out[3];
    assign router_15_5_to_magia_tile_ni_15_5_req = router_15_5_req_out[4];

    assign router_15_5_rsp_in[0] = router_15_6_to_router_15_5_rsp;
    assign router_15_5_rsp_in[1] = '0;
    assign router_15_5_rsp_in[2] = router_15_4_to_router_15_5_rsp;
    assign router_15_5_rsp_in[3] = router_14_5_to_router_15_5_rsp;
    assign router_15_5_rsp_in[4] = magia_tile_ni_15_5_to_router_15_5_rsp;

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
) router_15_5 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 16, y: 5, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_15_5_req_in),
  .floo_rsp_o (router_15_5_rsp_out),
  .floo_req_o (router_15_5_req_out),
  .floo_rsp_i (router_15_5_rsp_in)
);


floo_req_t [4:0] router_15_6_req_in;
floo_rsp_t [4:0] router_15_6_rsp_out;
floo_req_t [4:0] router_15_6_req_out;
floo_rsp_t [4:0] router_15_6_rsp_in;

    assign router_15_6_req_in[0] = router_15_7_to_router_15_6_req;
    assign router_15_6_req_in[1] = '0;
    assign router_15_6_req_in[2] = router_15_5_to_router_15_6_req;
    assign router_15_6_req_in[3] = router_14_6_to_router_15_6_req;
    assign router_15_6_req_in[4] = magia_tile_ni_15_6_to_router_15_6_req;

    assign router_15_6_to_router_15_7_rsp = router_15_6_rsp_out[0];
    assign router_15_6_to_router_15_5_rsp = router_15_6_rsp_out[2];
    assign router_15_6_to_router_14_6_rsp = router_15_6_rsp_out[3];
    assign router_15_6_to_magia_tile_ni_15_6_rsp = router_15_6_rsp_out[4];

    assign router_15_6_to_router_15_7_req = router_15_6_req_out[0];
    assign router_15_6_to_router_15_5_req = router_15_6_req_out[2];
    assign router_15_6_to_router_14_6_req = router_15_6_req_out[3];
    assign router_15_6_to_magia_tile_ni_15_6_req = router_15_6_req_out[4];

    assign router_15_6_rsp_in[0] = router_15_7_to_router_15_6_rsp;
    assign router_15_6_rsp_in[1] = '0;
    assign router_15_6_rsp_in[2] = router_15_5_to_router_15_6_rsp;
    assign router_15_6_rsp_in[3] = router_14_6_to_router_15_6_rsp;
    assign router_15_6_rsp_in[4] = magia_tile_ni_15_6_to_router_15_6_rsp;

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
) router_15_6 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 16, y: 6, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_15_6_req_in),
  .floo_rsp_o (router_15_6_rsp_out),
  .floo_req_o (router_15_6_req_out),
  .floo_rsp_i (router_15_6_rsp_in)
);


floo_req_t [4:0] router_15_7_req_in;
floo_rsp_t [4:0] router_15_7_rsp_out;
floo_req_t [4:0] router_15_7_req_out;
floo_rsp_t [4:0] router_15_7_rsp_in;

    assign router_15_7_req_in[0] = router_15_8_to_router_15_7_req;
    assign router_15_7_req_in[1] = '0;
    assign router_15_7_req_in[2] = router_15_6_to_router_15_7_req;
    assign router_15_7_req_in[3] = router_14_7_to_router_15_7_req;
    assign router_15_7_req_in[4] = magia_tile_ni_15_7_to_router_15_7_req;

    assign router_15_7_to_router_15_8_rsp = router_15_7_rsp_out[0];
    assign router_15_7_to_router_15_6_rsp = router_15_7_rsp_out[2];
    assign router_15_7_to_router_14_7_rsp = router_15_7_rsp_out[3];
    assign router_15_7_to_magia_tile_ni_15_7_rsp = router_15_7_rsp_out[4];

    assign router_15_7_to_router_15_8_req = router_15_7_req_out[0];
    assign router_15_7_to_router_15_6_req = router_15_7_req_out[2];
    assign router_15_7_to_router_14_7_req = router_15_7_req_out[3];
    assign router_15_7_to_magia_tile_ni_15_7_req = router_15_7_req_out[4];

    assign router_15_7_rsp_in[0] = router_15_8_to_router_15_7_rsp;
    assign router_15_7_rsp_in[1] = '0;
    assign router_15_7_rsp_in[2] = router_15_6_to_router_15_7_rsp;
    assign router_15_7_rsp_in[3] = router_14_7_to_router_15_7_rsp;
    assign router_15_7_rsp_in[4] = magia_tile_ni_15_7_to_router_15_7_rsp;

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
) router_15_7 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 16, y: 7, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_15_7_req_in),
  .floo_rsp_o (router_15_7_rsp_out),
  .floo_req_o (router_15_7_req_out),
  .floo_rsp_i (router_15_7_rsp_in)
);


floo_req_t [4:0] router_15_8_req_in;
floo_rsp_t [4:0] router_15_8_rsp_out;
floo_req_t [4:0] router_15_8_req_out;
floo_rsp_t [4:0] router_15_8_rsp_in;

    assign router_15_8_req_in[0] = router_15_9_to_router_15_8_req;
    assign router_15_8_req_in[1] = '0;
    assign router_15_8_req_in[2] = router_15_7_to_router_15_8_req;
    assign router_15_8_req_in[3] = router_14_8_to_router_15_8_req;
    assign router_15_8_req_in[4] = magia_tile_ni_15_8_to_router_15_8_req;

    assign router_15_8_to_router_15_9_rsp = router_15_8_rsp_out[0];
    assign router_15_8_to_router_15_7_rsp = router_15_8_rsp_out[2];
    assign router_15_8_to_router_14_8_rsp = router_15_8_rsp_out[3];
    assign router_15_8_to_magia_tile_ni_15_8_rsp = router_15_8_rsp_out[4];

    assign router_15_8_to_router_15_9_req = router_15_8_req_out[0];
    assign router_15_8_to_router_15_7_req = router_15_8_req_out[2];
    assign router_15_8_to_router_14_8_req = router_15_8_req_out[3];
    assign router_15_8_to_magia_tile_ni_15_8_req = router_15_8_req_out[4];

    assign router_15_8_rsp_in[0] = router_15_9_to_router_15_8_rsp;
    assign router_15_8_rsp_in[1] = '0;
    assign router_15_8_rsp_in[2] = router_15_7_to_router_15_8_rsp;
    assign router_15_8_rsp_in[3] = router_14_8_to_router_15_8_rsp;
    assign router_15_8_rsp_in[4] = magia_tile_ni_15_8_to_router_15_8_rsp;

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
) router_15_8 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 16, y: 8, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_15_8_req_in),
  .floo_rsp_o (router_15_8_rsp_out),
  .floo_req_o (router_15_8_req_out),
  .floo_rsp_i (router_15_8_rsp_in)
);


floo_req_t [4:0] router_15_9_req_in;
floo_rsp_t [4:0] router_15_9_rsp_out;
floo_req_t [4:0] router_15_9_req_out;
floo_rsp_t [4:0] router_15_9_rsp_in;

    assign router_15_9_req_in[0] = router_15_10_to_router_15_9_req;
    assign router_15_9_req_in[1] = '0;
    assign router_15_9_req_in[2] = router_15_8_to_router_15_9_req;
    assign router_15_9_req_in[3] = router_14_9_to_router_15_9_req;
    assign router_15_9_req_in[4] = magia_tile_ni_15_9_to_router_15_9_req;

    assign router_15_9_to_router_15_10_rsp = router_15_9_rsp_out[0];
    assign router_15_9_to_router_15_8_rsp = router_15_9_rsp_out[2];
    assign router_15_9_to_router_14_9_rsp = router_15_9_rsp_out[3];
    assign router_15_9_to_magia_tile_ni_15_9_rsp = router_15_9_rsp_out[4];

    assign router_15_9_to_router_15_10_req = router_15_9_req_out[0];
    assign router_15_9_to_router_15_8_req = router_15_9_req_out[2];
    assign router_15_9_to_router_14_9_req = router_15_9_req_out[3];
    assign router_15_9_to_magia_tile_ni_15_9_req = router_15_9_req_out[4];

    assign router_15_9_rsp_in[0] = router_15_10_to_router_15_9_rsp;
    assign router_15_9_rsp_in[1] = '0;
    assign router_15_9_rsp_in[2] = router_15_8_to_router_15_9_rsp;
    assign router_15_9_rsp_in[3] = router_14_9_to_router_15_9_rsp;
    assign router_15_9_rsp_in[4] = magia_tile_ni_15_9_to_router_15_9_rsp;

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
) router_15_9 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 16, y: 9, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_15_9_req_in),
  .floo_rsp_o (router_15_9_rsp_out),
  .floo_req_o (router_15_9_req_out),
  .floo_rsp_i (router_15_9_rsp_in)
);


floo_req_t [4:0] router_15_10_req_in;
floo_rsp_t [4:0] router_15_10_rsp_out;
floo_req_t [4:0] router_15_10_req_out;
floo_rsp_t [4:0] router_15_10_rsp_in;

    assign router_15_10_req_in[0] = router_15_11_to_router_15_10_req;
    assign router_15_10_req_in[1] = '0;
    assign router_15_10_req_in[2] = router_15_9_to_router_15_10_req;
    assign router_15_10_req_in[3] = router_14_10_to_router_15_10_req;
    assign router_15_10_req_in[4] = magia_tile_ni_15_10_to_router_15_10_req;

    assign router_15_10_to_router_15_11_rsp = router_15_10_rsp_out[0];
    assign router_15_10_to_router_15_9_rsp = router_15_10_rsp_out[2];
    assign router_15_10_to_router_14_10_rsp = router_15_10_rsp_out[3];
    assign router_15_10_to_magia_tile_ni_15_10_rsp = router_15_10_rsp_out[4];

    assign router_15_10_to_router_15_11_req = router_15_10_req_out[0];
    assign router_15_10_to_router_15_9_req = router_15_10_req_out[2];
    assign router_15_10_to_router_14_10_req = router_15_10_req_out[3];
    assign router_15_10_to_magia_tile_ni_15_10_req = router_15_10_req_out[4];

    assign router_15_10_rsp_in[0] = router_15_11_to_router_15_10_rsp;
    assign router_15_10_rsp_in[1] = '0;
    assign router_15_10_rsp_in[2] = router_15_9_to_router_15_10_rsp;
    assign router_15_10_rsp_in[3] = router_14_10_to_router_15_10_rsp;
    assign router_15_10_rsp_in[4] = magia_tile_ni_15_10_to_router_15_10_rsp;

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
) router_15_10 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 16, y: 10, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_15_10_req_in),
  .floo_rsp_o (router_15_10_rsp_out),
  .floo_req_o (router_15_10_req_out),
  .floo_rsp_i (router_15_10_rsp_in)
);


floo_req_t [4:0] router_15_11_req_in;
floo_rsp_t [4:0] router_15_11_rsp_out;
floo_req_t [4:0] router_15_11_req_out;
floo_rsp_t [4:0] router_15_11_rsp_in;

    assign router_15_11_req_in[0] = router_15_12_to_router_15_11_req;
    assign router_15_11_req_in[1] = '0;
    assign router_15_11_req_in[2] = router_15_10_to_router_15_11_req;
    assign router_15_11_req_in[3] = router_14_11_to_router_15_11_req;
    assign router_15_11_req_in[4] = magia_tile_ni_15_11_to_router_15_11_req;

    assign router_15_11_to_router_15_12_rsp = router_15_11_rsp_out[0];
    assign router_15_11_to_router_15_10_rsp = router_15_11_rsp_out[2];
    assign router_15_11_to_router_14_11_rsp = router_15_11_rsp_out[3];
    assign router_15_11_to_magia_tile_ni_15_11_rsp = router_15_11_rsp_out[4];

    assign router_15_11_to_router_15_12_req = router_15_11_req_out[0];
    assign router_15_11_to_router_15_10_req = router_15_11_req_out[2];
    assign router_15_11_to_router_14_11_req = router_15_11_req_out[3];
    assign router_15_11_to_magia_tile_ni_15_11_req = router_15_11_req_out[4];

    assign router_15_11_rsp_in[0] = router_15_12_to_router_15_11_rsp;
    assign router_15_11_rsp_in[1] = '0;
    assign router_15_11_rsp_in[2] = router_15_10_to_router_15_11_rsp;
    assign router_15_11_rsp_in[3] = router_14_11_to_router_15_11_rsp;
    assign router_15_11_rsp_in[4] = magia_tile_ni_15_11_to_router_15_11_rsp;

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
) router_15_11 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 16, y: 11, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_15_11_req_in),
  .floo_rsp_o (router_15_11_rsp_out),
  .floo_req_o (router_15_11_req_out),
  .floo_rsp_i (router_15_11_rsp_in)
);


floo_req_t [4:0] router_15_12_req_in;
floo_rsp_t [4:0] router_15_12_rsp_out;
floo_req_t [4:0] router_15_12_req_out;
floo_rsp_t [4:0] router_15_12_rsp_in;

    assign router_15_12_req_in[0] = router_15_13_to_router_15_12_req;
    assign router_15_12_req_in[1] = '0;
    assign router_15_12_req_in[2] = router_15_11_to_router_15_12_req;
    assign router_15_12_req_in[3] = router_14_12_to_router_15_12_req;
    assign router_15_12_req_in[4] = magia_tile_ni_15_12_to_router_15_12_req;

    assign router_15_12_to_router_15_13_rsp = router_15_12_rsp_out[0];
    assign router_15_12_to_router_15_11_rsp = router_15_12_rsp_out[2];
    assign router_15_12_to_router_14_12_rsp = router_15_12_rsp_out[3];
    assign router_15_12_to_magia_tile_ni_15_12_rsp = router_15_12_rsp_out[4];

    assign router_15_12_to_router_15_13_req = router_15_12_req_out[0];
    assign router_15_12_to_router_15_11_req = router_15_12_req_out[2];
    assign router_15_12_to_router_14_12_req = router_15_12_req_out[3];
    assign router_15_12_to_magia_tile_ni_15_12_req = router_15_12_req_out[4];

    assign router_15_12_rsp_in[0] = router_15_13_to_router_15_12_rsp;
    assign router_15_12_rsp_in[1] = '0;
    assign router_15_12_rsp_in[2] = router_15_11_to_router_15_12_rsp;
    assign router_15_12_rsp_in[3] = router_14_12_to_router_15_12_rsp;
    assign router_15_12_rsp_in[4] = magia_tile_ni_15_12_to_router_15_12_rsp;

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
) router_15_12 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 16, y: 12, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_15_12_req_in),
  .floo_rsp_o (router_15_12_rsp_out),
  .floo_req_o (router_15_12_req_out),
  .floo_rsp_i (router_15_12_rsp_in)
);


floo_req_t [4:0] router_15_13_req_in;
floo_rsp_t [4:0] router_15_13_rsp_out;
floo_req_t [4:0] router_15_13_req_out;
floo_rsp_t [4:0] router_15_13_rsp_in;

    assign router_15_13_req_in[0] = router_15_14_to_router_15_13_req;
    assign router_15_13_req_in[1] = '0;
    assign router_15_13_req_in[2] = router_15_12_to_router_15_13_req;
    assign router_15_13_req_in[3] = router_14_13_to_router_15_13_req;
    assign router_15_13_req_in[4] = magia_tile_ni_15_13_to_router_15_13_req;

    assign router_15_13_to_router_15_14_rsp = router_15_13_rsp_out[0];
    assign router_15_13_to_router_15_12_rsp = router_15_13_rsp_out[2];
    assign router_15_13_to_router_14_13_rsp = router_15_13_rsp_out[3];
    assign router_15_13_to_magia_tile_ni_15_13_rsp = router_15_13_rsp_out[4];

    assign router_15_13_to_router_15_14_req = router_15_13_req_out[0];
    assign router_15_13_to_router_15_12_req = router_15_13_req_out[2];
    assign router_15_13_to_router_14_13_req = router_15_13_req_out[3];
    assign router_15_13_to_magia_tile_ni_15_13_req = router_15_13_req_out[4];

    assign router_15_13_rsp_in[0] = router_15_14_to_router_15_13_rsp;
    assign router_15_13_rsp_in[1] = '0;
    assign router_15_13_rsp_in[2] = router_15_12_to_router_15_13_rsp;
    assign router_15_13_rsp_in[3] = router_14_13_to_router_15_13_rsp;
    assign router_15_13_rsp_in[4] = magia_tile_ni_15_13_to_router_15_13_rsp;

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
) router_15_13 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 16, y: 13, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_15_13_req_in),
  .floo_rsp_o (router_15_13_rsp_out),
  .floo_req_o (router_15_13_req_out),
  .floo_rsp_i (router_15_13_rsp_in)
);


floo_req_t [4:0] router_15_14_req_in;
floo_rsp_t [4:0] router_15_14_rsp_out;
floo_req_t [4:0] router_15_14_req_out;
floo_rsp_t [4:0] router_15_14_rsp_in;

    assign router_15_14_req_in[0] = router_15_15_to_router_15_14_req;
    assign router_15_14_req_in[1] = '0;
    assign router_15_14_req_in[2] = router_15_13_to_router_15_14_req;
    assign router_15_14_req_in[3] = router_14_14_to_router_15_14_req;
    assign router_15_14_req_in[4] = magia_tile_ni_15_14_to_router_15_14_req;

    assign router_15_14_to_router_15_15_rsp = router_15_14_rsp_out[0];
    assign router_15_14_to_router_15_13_rsp = router_15_14_rsp_out[2];
    assign router_15_14_to_router_14_14_rsp = router_15_14_rsp_out[3];
    assign router_15_14_to_magia_tile_ni_15_14_rsp = router_15_14_rsp_out[4];

    assign router_15_14_to_router_15_15_req = router_15_14_req_out[0];
    assign router_15_14_to_router_15_13_req = router_15_14_req_out[2];
    assign router_15_14_to_router_14_14_req = router_15_14_req_out[3];
    assign router_15_14_to_magia_tile_ni_15_14_req = router_15_14_req_out[4];

    assign router_15_14_rsp_in[0] = router_15_15_to_router_15_14_rsp;
    assign router_15_14_rsp_in[1] = '0;
    assign router_15_14_rsp_in[2] = router_15_13_to_router_15_14_rsp;
    assign router_15_14_rsp_in[3] = router_14_14_to_router_15_14_rsp;
    assign router_15_14_rsp_in[4] = magia_tile_ni_15_14_to_router_15_14_rsp;

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
) router_15_14 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 16, y: 14, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_15_14_req_in),
  .floo_rsp_o (router_15_14_rsp_out),
  .floo_req_o (router_15_14_req_out),
  .floo_rsp_i (router_15_14_rsp_in)
);


floo_req_t [4:0] router_15_15_req_in;
floo_rsp_t [4:0] router_15_15_rsp_out;
floo_req_t [4:0] router_15_15_req_out;
floo_rsp_t [4:0] router_15_15_rsp_in;

    assign router_15_15_req_in[0] = '0;
    assign router_15_15_req_in[1] = '0;
    assign router_15_15_req_in[2] = router_15_14_to_router_15_15_req;
    assign router_15_15_req_in[3] = router_14_15_to_router_15_15_req;
    assign router_15_15_req_in[4] = magia_tile_ni_15_15_to_router_15_15_req;

    assign router_15_15_to_router_15_14_rsp = router_15_15_rsp_out[2];
    assign router_15_15_to_router_14_15_rsp = router_15_15_rsp_out[3];
    assign router_15_15_to_magia_tile_ni_15_15_rsp = router_15_15_rsp_out[4];

    assign router_15_15_to_router_15_14_req = router_15_15_req_out[2];
    assign router_15_15_to_router_14_15_req = router_15_15_req_out[3];
    assign router_15_15_to_magia_tile_ni_15_15_req = router_15_15_req_out[4];

    assign router_15_15_rsp_in[0] = '0;
    assign router_15_15_rsp_in[1] = '0;
    assign router_15_15_rsp_in[2] = router_15_14_to_router_15_15_rsp;
    assign router_15_15_rsp_in[3] = router_14_15_to_router_15_15_rsp;
    assign router_15_15_rsp_in[4] = magia_tile_ni_15_15_to_router_15_15_rsp;

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
) router_15_15 (
  .clk_i,
  .rst_ni,
  .test_enable_i,
  .id_i ('{x: 16, y: 15, port_id: 0}),
  .id_route_map_i ('0),
  .floo_req_i (router_15_15_req_in),
  .floo_rsp_o (router_15_15_rsp_out),
  .floo_req_o (router_15_15_req_out),
  .floo_rsp_i (router_15_15_rsp_in)
);



endmodule
