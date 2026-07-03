// Copyright 2026 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// AUTOMATICALLY GENERATED! DO NOT EDIT!

`include "axi/typedef.svh"
`include "floo_noc/typedef.svh"

package floo_axi_nw_mesh_16x16_noc_pkg;

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



  typedef enum logic[8:0] {
    MagiaTileX0Y0SamIdx = 0,
    MagiaTileX0Y1SamIdx = 1,
    MagiaTileX0Y2SamIdx = 2,
    MagiaTileX0Y3SamIdx = 3,
    MagiaTileX0Y4SamIdx = 4,
    MagiaTileX0Y5SamIdx = 5,
    MagiaTileX0Y6SamIdx = 6,
    MagiaTileX0Y7SamIdx = 7,
    MagiaTileX0Y8SamIdx = 8,
    MagiaTileX0Y9SamIdx = 9,
    MagiaTileX0Y10SamIdx = 10,
    MagiaTileX0Y11SamIdx = 11,
    MagiaTileX0Y12SamIdx = 12,
    MagiaTileX0Y13SamIdx = 13,
    MagiaTileX0Y14SamIdx = 14,
    MagiaTileX0Y15SamIdx = 15,
    MagiaTileX1Y0SamIdx = 16,
    MagiaTileX1Y1SamIdx = 17,
    MagiaTileX1Y2SamIdx = 18,
    MagiaTileX1Y3SamIdx = 19,
    MagiaTileX1Y4SamIdx = 20,
    MagiaTileX1Y5SamIdx = 21,
    MagiaTileX1Y6SamIdx = 22,
    MagiaTileX1Y7SamIdx = 23,
    MagiaTileX1Y8SamIdx = 24,
    MagiaTileX1Y9SamIdx = 25,
    MagiaTileX1Y10SamIdx = 26,
    MagiaTileX1Y11SamIdx = 27,
    MagiaTileX1Y12SamIdx = 28,
    MagiaTileX1Y13SamIdx = 29,
    MagiaTileX1Y14SamIdx = 30,
    MagiaTileX1Y15SamIdx = 31,
    MagiaTileX2Y0SamIdx = 32,
    MagiaTileX2Y1SamIdx = 33,
    MagiaTileX2Y2SamIdx = 34,
    MagiaTileX2Y3SamIdx = 35,
    MagiaTileX2Y4SamIdx = 36,
    MagiaTileX2Y5SamIdx = 37,
    MagiaTileX2Y6SamIdx = 38,
    MagiaTileX2Y7SamIdx = 39,
    MagiaTileX2Y8SamIdx = 40,
    MagiaTileX2Y9SamIdx = 41,
    MagiaTileX2Y10SamIdx = 42,
    MagiaTileX2Y11SamIdx = 43,
    MagiaTileX2Y12SamIdx = 44,
    MagiaTileX2Y13SamIdx = 45,
    MagiaTileX2Y14SamIdx = 46,
    MagiaTileX2Y15SamIdx = 47,
    MagiaTileX3Y0SamIdx = 48,
    MagiaTileX3Y1SamIdx = 49,
    MagiaTileX3Y2SamIdx = 50,
    MagiaTileX3Y3SamIdx = 51,
    MagiaTileX3Y4SamIdx = 52,
    MagiaTileX3Y5SamIdx = 53,
    MagiaTileX3Y6SamIdx = 54,
    MagiaTileX3Y7SamIdx = 55,
    MagiaTileX3Y8SamIdx = 56,
    MagiaTileX3Y9SamIdx = 57,
    MagiaTileX3Y10SamIdx = 58,
    MagiaTileX3Y11SamIdx = 59,
    MagiaTileX3Y12SamIdx = 60,
    MagiaTileX3Y13SamIdx = 61,
    MagiaTileX3Y14SamIdx = 62,
    MagiaTileX3Y15SamIdx = 63,
    MagiaTileX4Y0SamIdx = 64,
    MagiaTileX4Y1SamIdx = 65,
    MagiaTileX4Y2SamIdx = 66,
    MagiaTileX4Y3SamIdx = 67,
    MagiaTileX4Y4SamIdx = 68,
    MagiaTileX4Y5SamIdx = 69,
    MagiaTileX4Y6SamIdx = 70,
    MagiaTileX4Y7SamIdx = 71,
    MagiaTileX4Y8SamIdx = 72,
    MagiaTileX4Y9SamIdx = 73,
    MagiaTileX4Y10SamIdx = 74,
    MagiaTileX4Y11SamIdx = 75,
    MagiaTileX4Y12SamIdx = 76,
    MagiaTileX4Y13SamIdx = 77,
    MagiaTileX4Y14SamIdx = 78,
    MagiaTileX4Y15SamIdx = 79,
    MagiaTileX5Y0SamIdx = 80,
    MagiaTileX5Y1SamIdx = 81,
    MagiaTileX5Y2SamIdx = 82,
    MagiaTileX5Y3SamIdx = 83,
    MagiaTileX5Y4SamIdx = 84,
    MagiaTileX5Y5SamIdx = 85,
    MagiaTileX5Y6SamIdx = 86,
    MagiaTileX5Y7SamIdx = 87,
    MagiaTileX5Y8SamIdx = 88,
    MagiaTileX5Y9SamIdx = 89,
    MagiaTileX5Y10SamIdx = 90,
    MagiaTileX5Y11SamIdx = 91,
    MagiaTileX5Y12SamIdx = 92,
    MagiaTileX5Y13SamIdx = 93,
    MagiaTileX5Y14SamIdx = 94,
    MagiaTileX5Y15SamIdx = 95,
    MagiaTileX6Y0SamIdx = 96,
    MagiaTileX6Y1SamIdx = 97,
    MagiaTileX6Y2SamIdx = 98,
    MagiaTileX6Y3SamIdx = 99,
    MagiaTileX6Y4SamIdx = 100,
    MagiaTileX6Y5SamIdx = 101,
    MagiaTileX6Y6SamIdx = 102,
    MagiaTileX6Y7SamIdx = 103,
    MagiaTileX6Y8SamIdx = 104,
    MagiaTileX6Y9SamIdx = 105,
    MagiaTileX6Y10SamIdx = 106,
    MagiaTileX6Y11SamIdx = 107,
    MagiaTileX6Y12SamIdx = 108,
    MagiaTileX6Y13SamIdx = 109,
    MagiaTileX6Y14SamIdx = 110,
    MagiaTileX6Y15SamIdx = 111,
    MagiaTileX7Y0SamIdx = 112,
    MagiaTileX7Y1SamIdx = 113,
    MagiaTileX7Y2SamIdx = 114,
    MagiaTileX7Y3SamIdx = 115,
    MagiaTileX7Y4SamIdx = 116,
    MagiaTileX7Y5SamIdx = 117,
    MagiaTileX7Y6SamIdx = 118,
    MagiaTileX7Y7SamIdx = 119,
    MagiaTileX7Y8SamIdx = 120,
    MagiaTileX7Y9SamIdx = 121,
    MagiaTileX7Y10SamIdx = 122,
    MagiaTileX7Y11SamIdx = 123,
    MagiaTileX7Y12SamIdx = 124,
    MagiaTileX7Y13SamIdx = 125,
    MagiaTileX7Y14SamIdx = 126,
    MagiaTileX7Y15SamIdx = 127,
    MagiaTileX8Y0SamIdx = 128,
    MagiaTileX8Y1SamIdx = 129,
    MagiaTileX8Y2SamIdx = 130,
    MagiaTileX8Y3SamIdx = 131,
    MagiaTileX8Y4SamIdx = 132,
    MagiaTileX8Y5SamIdx = 133,
    MagiaTileX8Y6SamIdx = 134,
    MagiaTileX8Y7SamIdx = 135,
    MagiaTileX8Y8SamIdx = 136,
    MagiaTileX8Y9SamIdx = 137,
    MagiaTileX8Y10SamIdx = 138,
    MagiaTileX8Y11SamIdx = 139,
    MagiaTileX8Y12SamIdx = 140,
    MagiaTileX8Y13SamIdx = 141,
    MagiaTileX8Y14SamIdx = 142,
    MagiaTileX8Y15SamIdx = 143,
    MagiaTileX9Y0SamIdx = 144,
    MagiaTileX9Y1SamIdx = 145,
    MagiaTileX9Y2SamIdx = 146,
    MagiaTileX9Y3SamIdx = 147,
    MagiaTileX9Y4SamIdx = 148,
    MagiaTileX9Y5SamIdx = 149,
    MagiaTileX9Y6SamIdx = 150,
    MagiaTileX9Y7SamIdx = 151,
    MagiaTileX9Y8SamIdx = 152,
    MagiaTileX9Y9SamIdx = 153,
    MagiaTileX9Y10SamIdx = 154,
    MagiaTileX9Y11SamIdx = 155,
    MagiaTileX9Y12SamIdx = 156,
    MagiaTileX9Y13SamIdx = 157,
    MagiaTileX9Y14SamIdx = 158,
    MagiaTileX9Y15SamIdx = 159,
    MagiaTileX10Y0SamIdx = 160,
    MagiaTileX10Y1SamIdx = 161,
    MagiaTileX10Y2SamIdx = 162,
    MagiaTileX10Y3SamIdx = 163,
    MagiaTileX10Y4SamIdx = 164,
    MagiaTileX10Y5SamIdx = 165,
    MagiaTileX10Y6SamIdx = 166,
    MagiaTileX10Y7SamIdx = 167,
    MagiaTileX10Y8SamIdx = 168,
    MagiaTileX10Y9SamIdx = 169,
    MagiaTileX10Y10SamIdx = 170,
    MagiaTileX10Y11SamIdx = 171,
    MagiaTileX10Y12SamIdx = 172,
    MagiaTileX10Y13SamIdx = 173,
    MagiaTileX10Y14SamIdx = 174,
    MagiaTileX10Y15SamIdx = 175,
    MagiaTileX11Y0SamIdx = 176,
    MagiaTileX11Y1SamIdx = 177,
    MagiaTileX11Y2SamIdx = 178,
    MagiaTileX11Y3SamIdx = 179,
    MagiaTileX11Y4SamIdx = 180,
    MagiaTileX11Y5SamIdx = 181,
    MagiaTileX11Y6SamIdx = 182,
    MagiaTileX11Y7SamIdx = 183,
    MagiaTileX11Y8SamIdx = 184,
    MagiaTileX11Y9SamIdx = 185,
    MagiaTileX11Y10SamIdx = 186,
    MagiaTileX11Y11SamIdx = 187,
    MagiaTileX11Y12SamIdx = 188,
    MagiaTileX11Y13SamIdx = 189,
    MagiaTileX11Y14SamIdx = 190,
    MagiaTileX11Y15SamIdx = 191,
    MagiaTileX12Y0SamIdx = 192,
    MagiaTileX12Y1SamIdx = 193,
    MagiaTileX12Y2SamIdx = 194,
    MagiaTileX12Y3SamIdx = 195,
    MagiaTileX12Y4SamIdx = 196,
    MagiaTileX12Y5SamIdx = 197,
    MagiaTileX12Y6SamIdx = 198,
    MagiaTileX12Y7SamIdx = 199,
    MagiaTileX12Y8SamIdx = 200,
    MagiaTileX12Y9SamIdx = 201,
    MagiaTileX12Y10SamIdx = 202,
    MagiaTileX12Y11SamIdx = 203,
    MagiaTileX12Y12SamIdx = 204,
    MagiaTileX12Y13SamIdx = 205,
    MagiaTileX12Y14SamIdx = 206,
    MagiaTileX12Y15SamIdx = 207,
    MagiaTileX13Y0SamIdx = 208,
    MagiaTileX13Y1SamIdx = 209,
    MagiaTileX13Y2SamIdx = 210,
    MagiaTileX13Y3SamIdx = 211,
    MagiaTileX13Y4SamIdx = 212,
    MagiaTileX13Y5SamIdx = 213,
    MagiaTileX13Y6SamIdx = 214,
    MagiaTileX13Y7SamIdx = 215,
    MagiaTileX13Y8SamIdx = 216,
    MagiaTileX13Y9SamIdx = 217,
    MagiaTileX13Y10SamIdx = 218,
    MagiaTileX13Y11SamIdx = 219,
    MagiaTileX13Y12SamIdx = 220,
    MagiaTileX13Y13SamIdx = 221,
    MagiaTileX13Y14SamIdx = 222,
    MagiaTileX13Y15SamIdx = 223,
    MagiaTileX14Y0SamIdx = 224,
    MagiaTileX14Y1SamIdx = 225,
    MagiaTileX14Y2SamIdx = 226,
    MagiaTileX14Y3SamIdx = 227,
    MagiaTileX14Y4SamIdx = 228,
    MagiaTileX14Y5SamIdx = 229,
    MagiaTileX14Y6SamIdx = 230,
    MagiaTileX14Y7SamIdx = 231,
    MagiaTileX14Y8SamIdx = 232,
    MagiaTileX14Y9SamIdx = 233,
    MagiaTileX14Y10SamIdx = 234,
    MagiaTileX14Y11SamIdx = 235,
    MagiaTileX14Y12SamIdx = 236,
    MagiaTileX14Y13SamIdx = 237,
    MagiaTileX14Y14SamIdx = 238,
    MagiaTileX14Y15SamIdx = 239,
    MagiaTileX15Y0SamIdx = 240,
    MagiaTileX15Y1SamIdx = 241,
    MagiaTileX15Y2SamIdx = 242,
    MagiaTileX15Y3SamIdx = 243,
    MagiaTileX15Y4SamIdx = 244,
    MagiaTileX15Y5SamIdx = 245,
    MagiaTileX15Y6SamIdx = 246,
    MagiaTileX15Y7SamIdx = 247,
    MagiaTileX15Y8SamIdx = 248,
    MagiaTileX15Y9SamIdx = 249,
    MagiaTileX15Y10SamIdx = 250,
    MagiaTileX15Y11SamIdx = 251,
    MagiaTileX15Y12SamIdx = 252,
    MagiaTileX15Y13SamIdx = 253,
    MagiaTileX15Y14SamIdx = 254,
    MagiaTileX15Y15SamIdx = 255,
    L20SamIdx = 256,
    L21SamIdx = 257,
    L22SamIdx = 258,
    L23SamIdx = 259,
    L24SamIdx = 260,
    L25SamIdx = 261,
    L26SamIdx = 262,
    L27SamIdx = 263,
    L28SamIdx = 264,
    L29SamIdx = 265,
    L210SamIdx = 266,
    L211SamIdx = 267,
    L212SamIdx = 268,
    L213SamIdx = 269,
    L214SamIdx = 270,
    L215SamIdx = 271} sam_idx_e;



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


  typedef struct packed {
    id_t idx;
    id_t start_addr;
    id_t end_addr;
  } route_map_rule_t;

  localparam int unsigned SamNumRules = 272;

typedef struct packed {
    id_t idx;
    logic [31:0] start_addr;
    logic [31:0] end_addr;
} sam_rule_t;

localparam sam_rule_t[SamNumRules-1:0] Sam = '{
'{idx: '{x: 0, y: 15, port_id: 0}, start_addr: 32'hfc000000, end_addr: 32'hffffffff},// L2_15_sam_idx
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

    localparam int unsigned CollectiveSamNumRules = 272;

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
'{    idx: '{    id: '{x: 0, y: 15, port_id: 0},
    mask_x: '{    default: '0},
    mask_y: '{    default: '0}},
    start_addr: 32'hfc000000,
    end_addr: 32'h100000000},// L215
'{    idx: '{    id: '{x: 0, y: 14, port_id: 0},
    mask_x: '{    default: '0},
    mask_y: '{    default: '0}},
    start_addr: 32'hf8000000,
    end_addr: 32'hfc000000},// L214
'{    idx: '{    id: '{x: 0, y: 13, port_id: 0},
    mask_x: '{    default: '0},
    mask_y: '{    default: '0}},
    start_addr: 32'hf4000000,
    end_addr: 32'hf8000000},// L213
'{    idx: '{    id: '{x: 0, y: 12, port_id: 0},
    mask_x: '{    default: '0},
    mask_y: '{    default: '0}},
    start_addr: 32'hf0000000,
    end_addr: 32'hf4000000},// L212
'{    idx: '{    id: '{x: 0, y: 11, port_id: 0},
    mask_x: '{    default: '0},
    mask_y: '{    default: '0}},
    start_addr: 32'hec000000,
    end_addr: 32'hf0000000},// L211
'{    idx: '{    id: '{x: 0, y: 10, port_id: 0},
    mask_x: '{    default: '0},
    mask_y: '{    default: '0}},
    start_addr: 32'he8000000,
    end_addr: 32'hec000000},// L210
'{    idx: '{    id: '{x: 0, y: 9, port_id: 0},
    mask_x: '{    default: '0},
    mask_y: '{    default: '0}},
    start_addr: 32'he4000000,
    end_addr: 32'he8000000},// L29
'{    idx: '{    id: '{x: 0, y: 8, port_id: 0},
    mask_x: '{    default: '0},
    mask_y: '{    default: '0}},
    start_addr: 32'he0000000,
    end_addr: 32'he4000000},// L28
'{    idx: '{    id: '{x: 0, y: 7, port_id: 0},
    mask_x: '{    default: '0},
    mask_y: '{    default: '0}},
    start_addr: 32'hdc000000,
    end_addr: 32'he0000000},// L27
'{    idx: '{    id: '{x: 0, y: 6, port_id: 0},
    mask_x: '{    default: '0},
    mask_y: '{    default: '0}},
    start_addr: 32'hd8000000,
    end_addr: 32'hdc000000},// L26
'{    idx: '{    id: '{x: 0, y: 5, port_id: 0},
    mask_x: '{    default: '0},
    mask_y: '{    default: '0}},
    start_addr: 32'hd4000000,
    end_addr: 32'hd8000000},// L25
'{    idx: '{    id: '{x: 0, y: 4, port_id: 0},
    mask_x: '{    default: '0},
    mask_y: '{    default: '0}},
    start_addr: 32'hd0000000,
    end_addr: 32'hd4000000},// L24
'{    idx: '{    id: '{x: 0, y: 3, port_id: 0},
    mask_x: '{    default: '0},
    mask_y: '{    default: '0}},
    start_addr: 32'hcc000000,
    end_addr: 32'hd0000000},// L23
'{    idx: '{    id: '{x: 0, y: 2, port_id: 0},
    mask_x: '{    default: '0},
    mask_y: '{    default: '0}},
    start_addr: 32'hc8000000,
    end_addr: 32'hcc000000},// L22
'{    idx: '{    id: '{x: 0, y: 1, port_id: 0},
    mask_x: '{    default: '0},
    mask_y: '{    default: '0}},
    start_addr: 32'hc4000000,
    end_addr: 32'hc8000000},// L21
'{    idx: '{    id: '{x: 0, y: 0, port_id: 0},
    mask_x: '{    default: '0},
    mask_y: '{    default: '0}},
    start_addr: 32'hc0000000,
    end_addr: 32'hc4000000},// L20
'{    idx: '{    id: '{x: 31, y: 15, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0ff00000,
    end_addr: 32'h10000000},// MagiaTileX15Y15
'{    idx: '{    id: '{x: 31, y: 14, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0fe00000,
    end_addr: 32'h0ff00000},// MagiaTileX15Y14
'{    idx: '{    id: '{x: 31, y: 13, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0fd00000,
    end_addr: 32'h0fe00000},// MagiaTileX15Y13
'{    idx: '{    id: '{x: 31, y: 12, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0fc00000,
    end_addr: 32'h0fd00000},// MagiaTileX15Y12
'{    idx: '{    id: '{x: 31, y: 11, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0fb00000,
    end_addr: 32'h0fc00000},// MagiaTileX15Y11
'{    idx: '{    id: '{x: 31, y: 10, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0fa00000,
    end_addr: 32'h0fb00000},// MagiaTileX15Y10
'{    idx: '{    id: '{x: 31, y: 9, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0f900000,
    end_addr: 32'h0fa00000},// MagiaTileX15Y9
'{    idx: '{    id: '{x: 31, y: 8, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0f800000,
    end_addr: 32'h0f900000},// MagiaTileX15Y8
'{    idx: '{    id: '{x: 31, y: 7, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0f700000,
    end_addr: 32'h0f800000},// MagiaTileX15Y7
'{    idx: '{    id: '{x: 31, y: 6, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0f600000,
    end_addr: 32'h0f700000},// MagiaTileX15Y6
'{    idx: '{    id: '{x: 31, y: 5, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0f500000,
    end_addr: 32'h0f600000},// MagiaTileX15Y5
'{    idx: '{    id: '{x: 31, y: 4, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0f400000,
    end_addr: 32'h0f500000},// MagiaTileX15Y4
'{    idx: '{    id: '{x: 31, y: 3, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0f300000,
    end_addr: 32'h0f400000},// MagiaTileX15Y3
'{    idx: '{    id: '{x: 31, y: 2, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0f200000,
    end_addr: 32'h0f300000},// MagiaTileX15Y2
'{    idx: '{    id: '{x: 31, y: 1, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0f100000,
    end_addr: 32'h0f200000},// MagiaTileX15Y1
'{    idx: '{    id: '{x: 31, y: 0, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0f000000,
    end_addr: 32'h0f100000},// MagiaTileX15Y0
'{    idx: '{    id: '{x: 30, y: 15, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0ef00000,
    end_addr: 32'h0f000000},// MagiaTileX14Y15
'{    idx: '{    id: '{x: 30, y: 14, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0ee00000,
    end_addr: 32'h0ef00000},// MagiaTileX14Y14
'{    idx: '{    id: '{x: 30, y: 13, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0ed00000,
    end_addr: 32'h0ee00000},// MagiaTileX14Y13
'{    idx: '{    id: '{x: 30, y: 12, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0ec00000,
    end_addr: 32'h0ed00000},// MagiaTileX14Y12
'{    idx: '{    id: '{x: 30, y: 11, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0eb00000,
    end_addr: 32'h0ec00000},// MagiaTileX14Y11
'{    idx: '{    id: '{x: 30, y: 10, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0ea00000,
    end_addr: 32'h0eb00000},// MagiaTileX14Y10
'{    idx: '{    id: '{x: 30, y: 9, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0e900000,
    end_addr: 32'h0ea00000},// MagiaTileX14Y9
'{    idx: '{    id: '{x: 30, y: 8, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0e800000,
    end_addr: 32'h0e900000},// MagiaTileX14Y8
'{    idx: '{    id: '{x: 30, y: 7, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0e700000,
    end_addr: 32'h0e800000},// MagiaTileX14Y7
'{    idx: '{    id: '{x: 30, y: 6, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0e600000,
    end_addr: 32'h0e700000},// MagiaTileX14Y6
'{    idx: '{    id: '{x: 30, y: 5, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0e500000,
    end_addr: 32'h0e600000},// MagiaTileX14Y5
'{    idx: '{    id: '{x: 30, y: 4, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0e400000,
    end_addr: 32'h0e500000},// MagiaTileX14Y4
'{    idx: '{    id: '{x: 30, y: 3, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0e300000,
    end_addr: 32'h0e400000},// MagiaTileX14Y3
'{    idx: '{    id: '{x: 30, y: 2, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0e200000,
    end_addr: 32'h0e300000},// MagiaTileX14Y2
'{    idx: '{    id: '{x: 30, y: 1, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0e100000,
    end_addr: 32'h0e200000},// MagiaTileX14Y1
'{    idx: '{    id: '{x: 30, y: 0, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0e000000,
    end_addr: 32'h0e100000},// MagiaTileX14Y0
'{    idx: '{    id: '{x: 29, y: 15, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0df00000,
    end_addr: 32'h0e000000},// MagiaTileX13Y15
'{    idx: '{    id: '{x: 29, y: 14, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0de00000,
    end_addr: 32'h0df00000},// MagiaTileX13Y14
'{    idx: '{    id: '{x: 29, y: 13, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0dd00000,
    end_addr: 32'h0de00000},// MagiaTileX13Y13
'{    idx: '{    id: '{x: 29, y: 12, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0dc00000,
    end_addr: 32'h0dd00000},// MagiaTileX13Y12
'{    idx: '{    id: '{x: 29, y: 11, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0db00000,
    end_addr: 32'h0dc00000},// MagiaTileX13Y11
'{    idx: '{    id: '{x: 29, y: 10, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0da00000,
    end_addr: 32'h0db00000},// MagiaTileX13Y10
'{    idx: '{    id: '{x: 29, y: 9, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0d900000,
    end_addr: 32'h0da00000},// MagiaTileX13Y9
'{    idx: '{    id: '{x: 29, y: 8, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0d800000,
    end_addr: 32'h0d900000},// MagiaTileX13Y8
'{    idx: '{    id: '{x: 29, y: 7, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0d700000,
    end_addr: 32'h0d800000},// MagiaTileX13Y7
'{    idx: '{    id: '{x: 29, y: 6, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0d600000,
    end_addr: 32'h0d700000},// MagiaTileX13Y6
'{    idx: '{    id: '{x: 29, y: 5, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0d500000,
    end_addr: 32'h0d600000},// MagiaTileX13Y5
'{    idx: '{    id: '{x: 29, y: 4, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0d400000,
    end_addr: 32'h0d500000},// MagiaTileX13Y4
'{    idx: '{    id: '{x: 29, y: 3, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0d300000,
    end_addr: 32'h0d400000},// MagiaTileX13Y3
'{    idx: '{    id: '{x: 29, y: 2, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0d200000,
    end_addr: 32'h0d300000},// MagiaTileX13Y2
'{    idx: '{    id: '{x: 29, y: 1, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0d100000,
    end_addr: 32'h0d200000},// MagiaTileX13Y1
'{    idx: '{    id: '{x: 29, y: 0, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0d000000,
    end_addr: 32'h0d100000},// MagiaTileX13Y0
'{    idx: '{    id: '{x: 28, y: 15, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0cf00000,
    end_addr: 32'h0d000000},// MagiaTileX12Y15
'{    idx: '{    id: '{x: 28, y: 14, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0ce00000,
    end_addr: 32'h0cf00000},// MagiaTileX12Y14
'{    idx: '{    id: '{x: 28, y: 13, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0cd00000,
    end_addr: 32'h0ce00000},// MagiaTileX12Y13
'{    idx: '{    id: '{x: 28, y: 12, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0cc00000,
    end_addr: 32'h0cd00000},// MagiaTileX12Y12
'{    idx: '{    id: '{x: 28, y: 11, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0cb00000,
    end_addr: 32'h0cc00000},// MagiaTileX12Y11
'{    idx: '{    id: '{x: 28, y: 10, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0ca00000,
    end_addr: 32'h0cb00000},// MagiaTileX12Y10
'{    idx: '{    id: '{x: 28, y: 9, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0c900000,
    end_addr: 32'h0ca00000},// MagiaTileX12Y9
'{    idx: '{    id: '{x: 28, y: 8, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0c800000,
    end_addr: 32'h0c900000},// MagiaTileX12Y8
'{    idx: '{    id: '{x: 28, y: 7, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0c700000,
    end_addr: 32'h0c800000},// MagiaTileX12Y7
'{    idx: '{    id: '{x: 28, y: 6, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0c600000,
    end_addr: 32'h0c700000},// MagiaTileX12Y6
'{    idx: '{    id: '{x: 28, y: 5, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0c500000,
    end_addr: 32'h0c600000},// MagiaTileX12Y5
'{    idx: '{    id: '{x: 28, y: 4, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0c400000,
    end_addr: 32'h0c500000},// MagiaTileX12Y4
'{    idx: '{    id: '{x: 28, y: 3, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0c300000,
    end_addr: 32'h0c400000},// MagiaTileX12Y3
'{    idx: '{    id: '{x: 28, y: 2, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0c200000,
    end_addr: 32'h0c300000},// MagiaTileX12Y2
'{    idx: '{    id: '{x: 28, y: 1, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0c100000,
    end_addr: 32'h0c200000},// MagiaTileX12Y1
'{    idx: '{    id: '{x: 28, y: 0, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0c000000,
    end_addr: 32'h0c100000},// MagiaTileX12Y0
'{    idx: '{    id: '{x: 27, y: 15, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0bf00000,
    end_addr: 32'h0c000000},// MagiaTileX11Y15
'{    idx: '{    id: '{x: 27, y: 14, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0be00000,
    end_addr: 32'h0bf00000},// MagiaTileX11Y14
'{    idx: '{    id: '{x: 27, y: 13, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0bd00000,
    end_addr: 32'h0be00000},// MagiaTileX11Y13
'{    idx: '{    id: '{x: 27, y: 12, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0bc00000,
    end_addr: 32'h0bd00000},// MagiaTileX11Y12
'{    idx: '{    id: '{x: 27, y: 11, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0bb00000,
    end_addr: 32'h0bc00000},// MagiaTileX11Y11
'{    idx: '{    id: '{x: 27, y: 10, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0ba00000,
    end_addr: 32'h0bb00000},// MagiaTileX11Y10
'{    idx: '{    id: '{x: 27, y: 9, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0b900000,
    end_addr: 32'h0ba00000},// MagiaTileX11Y9
'{    idx: '{    id: '{x: 27, y: 8, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0b800000,
    end_addr: 32'h0b900000},// MagiaTileX11Y8
'{    idx: '{    id: '{x: 27, y: 7, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0b700000,
    end_addr: 32'h0b800000},// MagiaTileX11Y7
'{    idx: '{    id: '{x: 27, y: 6, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0b600000,
    end_addr: 32'h0b700000},// MagiaTileX11Y6
'{    idx: '{    id: '{x: 27, y: 5, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0b500000,
    end_addr: 32'h0b600000},// MagiaTileX11Y5
'{    idx: '{    id: '{x: 27, y: 4, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0b400000,
    end_addr: 32'h0b500000},// MagiaTileX11Y4
'{    idx: '{    id: '{x: 27, y: 3, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0b300000,
    end_addr: 32'h0b400000},// MagiaTileX11Y3
'{    idx: '{    id: '{x: 27, y: 2, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0b200000,
    end_addr: 32'h0b300000},// MagiaTileX11Y2
'{    idx: '{    id: '{x: 27, y: 1, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0b100000,
    end_addr: 32'h0b200000},// MagiaTileX11Y1
'{    idx: '{    id: '{x: 27, y: 0, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0b000000,
    end_addr: 32'h0b100000},// MagiaTileX11Y0
'{    idx: '{    id: '{x: 26, y: 15, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0af00000,
    end_addr: 32'h0b000000},// MagiaTileX10Y15
'{    idx: '{    id: '{x: 26, y: 14, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0ae00000,
    end_addr: 32'h0af00000},// MagiaTileX10Y14
'{    idx: '{    id: '{x: 26, y: 13, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0ad00000,
    end_addr: 32'h0ae00000},// MagiaTileX10Y13
'{    idx: '{    id: '{x: 26, y: 12, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0ac00000,
    end_addr: 32'h0ad00000},// MagiaTileX10Y12
'{    idx: '{    id: '{x: 26, y: 11, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0ab00000,
    end_addr: 32'h0ac00000},// MagiaTileX10Y11
'{    idx: '{    id: '{x: 26, y: 10, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0aa00000,
    end_addr: 32'h0ab00000},// MagiaTileX10Y10
'{    idx: '{    id: '{x: 26, y: 9, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0a900000,
    end_addr: 32'h0aa00000},// MagiaTileX10Y9
'{    idx: '{    id: '{x: 26, y: 8, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0a800000,
    end_addr: 32'h0a900000},// MagiaTileX10Y8
'{    idx: '{    id: '{x: 26, y: 7, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0a700000,
    end_addr: 32'h0a800000},// MagiaTileX10Y7
'{    idx: '{    id: '{x: 26, y: 6, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0a600000,
    end_addr: 32'h0a700000},// MagiaTileX10Y6
'{    idx: '{    id: '{x: 26, y: 5, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0a500000,
    end_addr: 32'h0a600000},// MagiaTileX10Y5
'{    idx: '{    id: '{x: 26, y: 4, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0a400000,
    end_addr: 32'h0a500000},// MagiaTileX10Y4
'{    idx: '{    id: '{x: 26, y: 3, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0a300000,
    end_addr: 32'h0a400000},// MagiaTileX10Y3
'{    idx: '{    id: '{x: 26, y: 2, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0a200000,
    end_addr: 32'h0a300000},// MagiaTileX10Y2
'{    idx: '{    id: '{x: 26, y: 1, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0a100000,
    end_addr: 32'h0a200000},// MagiaTileX10Y1
'{    idx: '{    id: '{x: 26, y: 0, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h0a000000,
    end_addr: 32'h0a100000},// MagiaTileX10Y0
'{    idx: '{    id: '{x: 25, y: 15, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h09f00000,
    end_addr: 32'h0a000000},// MagiaTileX9Y15
'{    idx: '{    id: '{x: 25, y: 14, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h09e00000,
    end_addr: 32'h09f00000},// MagiaTileX9Y14
'{    idx: '{    id: '{x: 25, y: 13, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h09d00000,
    end_addr: 32'h09e00000},// MagiaTileX9Y13
'{    idx: '{    id: '{x: 25, y: 12, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h09c00000,
    end_addr: 32'h09d00000},// MagiaTileX9Y12
'{    idx: '{    id: '{x: 25, y: 11, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h09b00000,
    end_addr: 32'h09c00000},// MagiaTileX9Y11
'{    idx: '{    id: '{x: 25, y: 10, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h09a00000,
    end_addr: 32'h09b00000},// MagiaTileX9Y10
'{    idx: '{    id: '{x: 25, y: 9, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h09900000,
    end_addr: 32'h09a00000},// MagiaTileX9Y9
'{    idx: '{    id: '{x: 25, y: 8, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h09800000,
    end_addr: 32'h09900000},// MagiaTileX9Y8
'{    idx: '{    id: '{x: 25, y: 7, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h09700000,
    end_addr: 32'h09800000},// MagiaTileX9Y7
'{    idx: '{    id: '{x: 25, y: 6, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h09600000,
    end_addr: 32'h09700000},// MagiaTileX9Y6
'{    idx: '{    id: '{x: 25, y: 5, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h09500000,
    end_addr: 32'h09600000},// MagiaTileX9Y5
'{    idx: '{    id: '{x: 25, y: 4, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h09400000,
    end_addr: 32'h09500000},// MagiaTileX9Y4
'{    idx: '{    id: '{x: 25, y: 3, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h09300000,
    end_addr: 32'h09400000},// MagiaTileX9Y3
'{    idx: '{    id: '{x: 25, y: 2, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h09200000,
    end_addr: 32'h09300000},// MagiaTileX9Y2
'{    idx: '{    id: '{x: 25, y: 1, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h09100000,
    end_addr: 32'h09200000},// MagiaTileX9Y1
'{    idx: '{    id: '{x: 25, y: 0, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h09000000,
    end_addr: 32'h09100000},// MagiaTileX9Y0
'{    idx: '{    id: '{x: 24, y: 15, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h08f00000,
    end_addr: 32'h09000000},// MagiaTileX8Y15
'{    idx: '{    id: '{x: 24, y: 14, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h08e00000,
    end_addr: 32'h08f00000},// MagiaTileX8Y14
'{    idx: '{    id: '{x: 24, y: 13, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h08d00000,
    end_addr: 32'h08e00000},// MagiaTileX8Y13
'{    idx: '{    id: '{x: 24, y: 12, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h08c00000,
    end_addr: 32'h08d00000},// MagiaTileX8Y12
'{    idx: '{    id: '{x: 24, y: 11, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h08b00000,
    end_addr: 32'h08c00000},// MagiaTileX8Y11
'{    idx: '{    id: '{x: 24, y: 10, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h08a00000,
    end_addr: 32'h08b00000},// MagiaTileX8Y10
'{    idx: '{    id: '{x: 24, y: 9, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h08900000,
    end_addr: 32'h08a00000},// MagiaTileX8Y9
'{    idx: '{    id: '{x: 24, y: 8, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h08800000,
    end_addr: 32'h08900000},// MagiaTileX8Y8
'{    idx: '{    id: '{x: 24, y: 7, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h08700000,
    end_addr: 32'h08800000},// MagiaTileX8Y7
'{    idx: '{    id: '{x: 24, y: 6, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h08600000,
    end_addr: 32'h08700000},// MagiaTileX8Y6
'{    idx: '{    id: '{x: 24, y: 5, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h08500000,
    end_addr: 32'h08600000},// MagiaTileX8Y5
'{    idx: '{    id: '{x: 24, y: 4, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h08400000,
    end_addr: 32'h08500000},// MagiaTileX8Y4
'{    idx: '{    id: '{x: 24, y: 3, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h08300000,
    end_addr: 32'h08400000},// MagiaTileX8Y3
'{    idx: '{    id: '{x: 24, y: 2, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h08200000,
    end_addr: 32'h08300000},// MagiaTileX8Y2
'{    idx: '{    id: '{x: 24, y: 1, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h08100000,
    end_addr: 32'h08200000},// MagiaTileX8Y1
'{    idx: '{    id: '{x: 24, y: 0, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h08000000,
    end_addr: 32'h08100000},// MagiaTileX8Y0
'{    idx: '{    id: '{x: 23, y: 15, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h07f00000,
    end_addr: 32'h08000000},// MagiaTileX7Y15
'{    idx: '{    id: '{x: 23, y: 14, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h07e00000,
    end_addr: 32'h07f00000},// MagiaTileX7Y14
'{    idx: '{    id: '{x: 23, y: 13, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h07d00000,
    end_addr: 32'h07e00000},// MagiaTileX7Y13
'{    idx: '{    id: '{x: 23, y: 12, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h07c00000,
    end_addr: 32'h07d00000},// MagiaTileX7Y12
'{    idx: '{    id: '{x: 23, y: 11, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h07b00000,
    end_addr: 32'h07c00000},// MagiaTileX7Y11
'{    idx: '{    id: '{x: 23, y: 10, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h07a00000,
    end_addr: 32'h07b00000},// MagiaTileX7Y10
'{    idx: '{    id: '{x: 23, y: 9, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h07900000,
    end_addr: 32'h07a00000},// MagiaTileX7Y9
'{    idx: '{    id: '{x: 23, y: 8, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h07800000,
    end_addr: 32'h07900000},// MagiaTileX7Y8
'{    idx: '{    id: '{x: 23, y: 7, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h07700000,
    end_addr: 32'h07800000},// MagiaTileX7Y7
'{    idx: '{    id: '{x: 23, y: 6, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h07600000,
    end_addr: 32'h07700000},// MagiaTileX7Y6
'{    idx: '{    id: '{x: 23, y: 5, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h07500000,
    end_addr: 32'h07600000},// MagiaTileX7Y5
'{    idx: '{    id: '{x: 23, y: 4, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h07400000,
    end_addr: 32'h07500000},// MagiaTileX7Y4
'{    idx: '{    id: '{x: 23, y: 3, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h07300000,
    end_addr: 32'h07400000},// MagiaTileX7Y3
'{    idx: '{    id: '{x: 23, y: 2, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h07200000,
    end_addr: 32'h07300000},// MagiaTileX7Y2
'{    idx: '{    id: '{x: 23, y: 1, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h07100000,
    end_addr: 32'h07200000},// MagiaTileX7Y1
'{    idx: '{    id: '{x: 23, y: 0, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h07000000,
    end_addr: 32'h07100000},// MagiaTileX7Y0
'{    idx: '{    id: '{x: 22, y: 15, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h06f00000,
    end_addr: 32'h07000000},// MagiaTileX6Y15
'{    idx: '{    id: '{x: 22, y: 14, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h06e00000,
    end_addr: 32'h06f00000},// MagiaTileX6Y14
'{    idx: '{    id: '{x: 22, y: 13, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h06d00000,
    end_addr: 32'h06e00000},// MagiaTileX6Y13
'{    idx: '{    id: '{x: 22, y: 12, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h06c00000,
    end_addr: 32'h06d00000},// MagiaTileX6Y12
'{    idx: '{    id: '{x: 22, y: 11, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h06b00000,
    end_addr: 32'h06c00000},// MagiaTileX6Y11
'{    idx: '{    id: '{x: 22, y: 10, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h06a00000,
    end_addr: 32'h06b00000},// MagiaTileX6Y10
'{    idx: '{    id: '{x: 22, y: 9, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h06900000,
    end_addr: 32'h06a00000},// MagiaTileX6Y9
'{    idx: '{    id: '{x: 22, y: 8, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h06800000,
    end_addr: 32'h06900000},// MagiaTileX6Y8
'{    idx: '{    id: '{x: 22, y: 7, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h06700000,
    end_addr: 32'h06800000},// MagiaTileX6Y7
'{    idx: '{    id: '{x: 22, y: 6, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h06600000,
    end_addr: 32'h06700000},// MagiaTileX6Y6
'{    idx: '{    id: '{x: 22, y: 5, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h06500000,
    end_addr: 32'h06600000},// MagiaTileX6Y5
'{    idx: '{    id: '{x: 22, y: 4, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h06400000,
    end_addr: 32'h06500000},// MagiaTileX6Y4
'{    idx: '{    id: '{x: 22, y: 3, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h06300000,
    end_addr: 32'h06400000},// MagiaTileX6Y3
'{    idx: '{    id: '{x: 22, y: 2, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h06200000,
    end_addr: 32'h06300000},// MagiaTileX6Y2
'{    idx: '{    id: '{x: 22, y: 1, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h06100000,
    end_addr: 32'h06200000},// MagiaTileX6Y1
'{    idx: '{    id: '{x: 22, y: 0, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h06000000,
    end_addr: 32'h06100000},// MagiaTileX6Y0
'{    idx: '{    id: '{x: 21, y: 15, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h05f00000,
    end_addr: 32'h06000000},// MagiaTileX5Y15
'{    idx: '{    id: '{x: 21, y: 14, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h05e00000,
    end_addr: 32'h05f00000},// MagiaTileX5Y14
'{    idx: '{    id: '{x: 21, y: 13, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h05d00000,
    end_addr: 32'h05e00000},// MagiaTileX5Y13
'{    idx: '{    id: '{x: 21, y: 12, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h05c00000,
    end_addr: 32'h05d00000},// MagiaTileX5Y12
'{    idx: '{    id: '{x: 21, y: 11, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h05b00000,
    end_addr: 32'h05c00000},// MagiaTileX5Y11
'{    idx: '{    id: '{x: 21, y: 10, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h05a00000,
    end_addr: 32'h05b00000},// MagiaTileX5Y10
'{    idx: '{    id: '{x: 21, y: 9, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h05900000,
    end_addr: 32'h05a00000},// MagiaTileX5Y9
'{    idx: '{    id: '{x: 21, y: 8, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h05800000,
    end_addr: 32'h05900000},// MagiaTileX5Y8
'{    idx: '{    id: '{x: 21, y: 7, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h05700000,
    end_addr: 32'h05800000},// MagiaTileX5Y7
'{    idx: '{    id: '{x: 21, y: 6, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h05600000,
    end_addr: 32'h05700000},// MagiaTileX5Y6
'{    idx: '{    id: '{x: 21, y: 5, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h05500000,
    end_addr: 32'h05600000},// MagiaTileX5Y5
'{    idx: '{    id: '{x: 21, y: 4, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h05400000,
    end_addr: 32'h05500000},// MagiaTileX5Y4
'{    idx: '{    id: '{x: 21, y: 3, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h05300000,
    end_addr: 32'h05400000},// MagiaTileX5Y3
'{    idx: '{    id: '{x: 21, y: 2, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h05200000,
    end_addr: 32'h05300000},// MagiaTileX5Y2
'{    idx: '{    id: '{x: 21, y: 1, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h05100000,
    end_addr: 32'h05200000},// MagiaTileX5Y1
'{    idx: '{    id: '{x: 21, y: 0, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h05000000,
    end_addr: 32'h05100000},// MagiaTileX5Y0
'{    idx: '{    id: '{x: 20, y: 15, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h04f00000,
    end_addr: 32'h05000000},// MagiaTileX4Y15
'{    idx: '{    id: '{x: 20, y: 14, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h04e00000,
    end_addr: 32'h04f00000},// MagiaTileX4Y14
'{    idx: '{    id: '{x: 20, y: 13, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h04d00000,
    end_addr: 32'h04e00000},// MagiaTileX4Y13
'{    idx: '{    id: '{x: 20, y: 12, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h04c00000,
    end_addr: 32'h04d00000},// MagiaTileX4Y12
'{    idx: '{    id: '{x: 20, y: 11, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h04b00000,
    end_addr: 32'h04c00000},// MagiaTileX4Y11
'{    idx: '{    id: '{x: 20, y: 10, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h04a00000,
    end_addr: 32'h04b00000},// MagiaTileX4Y10
'{    idx: '{    id: '{x: 20, y: 9, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h04900000,
    end_addr: 32'h04a00000},// MagiaTileX4Y9
'{    idx: '{    id: '{x: 20, y: 8, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h04800000,
    end_addr: 32'h04900000},// MagiaTileX4Y8
'{    idx: '{    id: '{x: 20, y: 7, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h04700000,
    end_addr: 32'h04800000},// MagiaTileX4Y7
'{    idx: '{    id: '{x: 20, y: 6, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h04600000,
    end_addr: 32'h04700000},// MagiaTileX4Y6
'{    idx: '{    id: '{x: 20, y: 5, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h04500000,
    end_addr: 32'h04600000},// MagiaTileX4Y5
'{    idx: '{    id: '{x: 20, y: 4, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h04400000,
    end_addr: 32'h04500000},// MagiaTileX4Y4
'{    idx: '{    id: '{x: 20, y: 3, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h04300000,
    end_addr: 32'h04400000},// MagiaTileX4Y3
'{    idx: '{    id: '{x: 20, y: 2, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h04200000,
    end_addr: 32'h04300000},// MagiaTileX4Y2
'{    idx: '{    id: '{x: 20, y: 1, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h04100000,
    end_addr: 32'h04200000},// MagiaTileX4Y1
'{    idx: '{    id: '{x: 20, y: 0, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h04000000,
    end_addr: 32'h04100000},// MagiaTileX4Y0
'{    idx: '{    id: '{x: 19, y: 15, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h03f00000,
    end_addr: 32'h04000000},// MagiaTileX3Y15
'{    idx: '{    id: '{x: 19, y: 14, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h03e00000,
    end_addr: 32'h03f00000},// MagiaTileX3Y14
'{    idx: '{    id: '{x: 19, y: 13, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h03d00000,
    end_addr: 32'h03e00000},// MagiaTileX3Y13
'{    idx: '{    id: '{x: 19, y: 12, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h03c00000,
    end_addr: 32'h03d00000},// MagiaTileX3Y12
'{    idx: '{    id: '{x: 19, y: 11, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h03b00000,
    end_addr: 32'h03c00000},// MagiaTileX3Y11
'{    idx: '{    id: '{x: 19, y: 10, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h03a00000,
    end_addr: 32'h03b00000},// MagiaTileX3Y10
'{    idx: '{    id: '{x: 19, y: 9, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h03900000,
    end_addr: 32'h03a00000},// MagiaTileX3Y9
'{    idx: '{    id: '{x: 19, y: 8, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h03800000,
    end_addr: 32'h03900000},// MagiaTileX3Y8
'{    idx: '{    id: '{x: 19, y: 7, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h03700000,
    end_addr: 32'h03800000},// MagiaTileX3Y7
'{    idx: '{    id: '{x: 19, y: 6, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h03600000,
    end_addr: 32'h03700000},// MagiaTileX3Y6
'{    idx: '{    id: '{x: 19, y: 5, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h03500000,
    end_addr: 32'h03600000},// MagiaTileX3Y5
'{    idx: '{    id: '{x: 19, y: 4, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h03400000,
    end_addr: 32'h03500000},// MagiaTileX3Y4
'{    idx: '{    id: '{x: 19, y: 3, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h03300000,
    end_addr: 32'h03400000},// MagiaTileX3Y3
'{    idx: '{    id: '{x: 19, y: 2, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h03200000,
    end_addr: 32'h03300000},// MagiaTileX3Y2
'{    idx: '{    id: '{x: 19, y: 1, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h03100000,
    end_addr: 32'h03200000},// MagiaTileX3Y1
'{    idx: '{    id: '{x: 19, y: 0, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h03000000,
    end_addr: 32'h03100000},// MagiaTileX3Y0
'{    idx: '{    id: '{x: 18, y: 15, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h02f00000,
    end_addr: 32'h03000000},// MagiaTileX2Y15
'{    idx: '{    id: '{x: 18, y: 14, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h02e00000,
    end_addr: 32'h02f00000},// MagiaTileX2Y14
'{    idx: '{    id: '{x: 18, y: 13, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h02d00000,
    end_addr: 32'h02e00000},// MagiaTileX2Y13
'{    idx: '{    id: '{x: 18, y: 12, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h02c00000,
    end_addr: 32'h02d00000},// MagiaTileX2Y12
'{    idx: '{    id: '{x: 18, y: 11, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h02b00000,
    end_addr: 32'h02c00000},// MagiaTileX2Y11
'{    idx: '{    id: '{x: 18, y: 10, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h02a00000,
    end_addr: 32'h02b00000},// MagiaTileX2Y10
'{    idx: '{    id: '{x: 18, y: 9, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h02900000,
    end_addr: 32'h02a00000},// MagiaTileX2Y9
'{    idx: '{    id: '{x: 18, y: 8, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h02800000,
    end_addr: 32'h02900000},// MagiaTileX2Y8
'{    idx: '{    id: '{x: 18, y: 7, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h02700000,
    end_addr: 32'h02800000},// MagiaTileX2Y7
'{    idx: '{    id: '{x: 18, y: 6, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h02600000,
    end_addr: 32'h02700000},// MagiaTileX2Y6
'{    idx: '{    id: '{x: 18, y: 5, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h02500000,
    end_addr: 32'h02600000},// MagiaTileX2Y5
'{    idx: '{    id: '{x: 18, y: 4, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h02400000,
    end_addr: 32'h02500000},// MagiaTileX2Y4
'{    idx: '{    id: '{x: 18, y: 3, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h02300000,
    end_addr: 32'h02400000},// MagiaTileX2Y3
'{    idx: '{    id: '{x: 18, y: 2, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h02200000,
    end_addr: 32'h02300000},// MagiaTileX2Y2
'{    idx: '{    id: '{x: 18, y: 1, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h02100000,
    end_addr: 32'h02200000},// MagiaTileX2Y1
'{    idx: '{    id: '{x: 18, y: 0, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h02000000,
    end_addr: 32'h02100000},// MagiaTileX2Y0
'{    idx: '{    id: '{x: 17, y: 15, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h01f00000,
    end_addr: 32'h02000000},// MagiaTileX1Y15
'{    idx: '{    id: '{x: 17, y: 14, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h01e00000,
    end_addr: 32'h01f00000},// MagiaTileX1Y14
'{    idx: '{    id: '{x: 17, y: 13, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h01d00000,
    end_addr: 32'h01e00000},// MagiaTileX1Y13
'{    idx: '{    id: '{x: 17, y: 12, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h01c00000,
    end_addr: 32'h01d00000},// MagiaTileX1Y12
'{    idx: '{    id: '{x: 17, y: 11, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h01b00000,
    end_addr: 32'h01c00000},// MagiaTileX1Y11
'{    idx: '{    id: '{x: 17, y: 10, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h01a00000,
    end_addr: 32'h01b00000},// MagiaTileX1Y10
'{    idx: '{    id: '{x: 17, y: 9, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h01900000,
    end_addr: 32'h01a00000},// MagiaTileX1Y9
'{    idx: '{    id: '{x: 17, y: 8, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h01800000,
    end_addr: 32'h01900000},// MagiaTileX1Y8
'{    idx: '{    id: '{x: 17, y: 7, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h01700000,
    end_addr: 32'h01800000},// MagiaTileX1Y7
'{    idx: '{    id: '{x: 17, y: 6, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h01600000,
    end_addr: 32'h01700000},// MagiaTileX1Y6
'{    idx: '{    id: '{x: 17, y: 5, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h01500000,
    end_addr: 32'h01600000},// MagiaTileX1Y5
'{    idx: '{    id: '{x: 17, y: 4, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h01400000,
    end_addr: 32'h01500000},// MagiaTileX1Y4
'{    idx: '{    id: '{x: 17, y: 3, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h01300000,
    end_addr: 32'h01400000},// MagiaTileX1Y3
'{    idx: '{    id: '{x: 17, y: 2, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h01200000,
    end_addr: 32'h01300000},// MagiaTileX1Y2
'{    idx: '{    id: '{x: 17, y: 1, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h01100000,
    end_addr: 32'h01200000},// MagiaTileX1Y1
'{    idx: '{    id: '{x: 17, y: 0, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h01000000,
    end_addr: 32'h01100000},// MagiaTileX1Y0
'{    idx: '{    id: '{x: 16, y: 15, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h00f00000,
    end_addr: 32'h01000000},// MagiaTileX0Y15
'{    idx: '{    id: '{x: 16, y: 14, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h00e00000,
    end_addr: 32'h00f00000},// MagiaTileX0Y14
'{    idx: '{    id: '{x: 16, y: 13, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h00d00000,
    end_addr: 32'h00e00000},// MagiaTileX0Y13
'{    idx: '{    id: '{x: 16, y: 12, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h00c00000,
    end_addr: 32'h00d00000},// MagiaTileX0Y12
'{    idx: '{    id: '{x: 16, y: 11, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h00b00000,
    end_addr: 32'h00c00000},// MagiaTileX0Y11
'{    idx: '{    id: '{x: 16, y: 10, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h00a00000,
    end_addr: 32'h00b00000},// MagiaTileX0Y10
'{    idx: '{    id: '{x: 16, y: 9, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h00900000,
    end_addr: 32'h00a00000},// MagiaTileX0Y9
'{    idx: '{    id: '{x: 16, y: 8, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h00800000,
    end_addr: 32'h00900000},// MagiaTileX0Y8
'{    idx: '{    id: '{x: 16, y: 7, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h00700000,
    end_addr: 32'h00800000},// MagiaTileX0Y7
'{    idx: '{    id: '{x: 16, y: 6, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h00600000,
    end_addr: 32'h00700000},// MagiaTileX0Y6
'{    idx: '{    id: '{x: 16, y: 5, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h00500000,
    end_addr: 32'h00600000},// MagiaTileX0Y5
'{    idx: '{    id: '{x: 16, y: 4, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h00400000,
    end_addr: 32'h00500000},// MagiaTileX0Y4
'{    idx: '{    id: '{x: 16, y: 3, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h00300000,
    end_addr: 32'h00400000},// MagiaTileX0Y3
'{    idx: '{    id: '{x: 16, y: 2, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h00200000,
    end_addr: 32'h00300000},// MagiaTileX0Y2
'{    idx: '{    id: '{x: 16, y: 1, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h00100000,
    end_addr: 32'h00200000},// MagiaTileX0Y1
'{    idx: '{    id: '{x: 16, y: 0, port_id: 0},
    mask_x: '{    offset: 24,
    len: 5,
    base_id: 16},
    mask_y: '{    offset: 20,
    len: 4,
    base_id: 0}},
    start_addr: 32'h00000000,
    end_addr: 32'h00100000} // MagiaTileX0Y0

};



  localparam route_cfg_t RouteCfg = '{    RouteAlgo: XYRouting,
    UseIdTable: 1'b1,
    XYAddrOffsetX: 32,
    XYAddrOffsetY: 37,
    IdAddrOffset: 0,
    NumSamRules: 272,
    NumRoutes: 0,
    CollectiveCfg: '{    OpCfg: '{    EnNarrowMulticast: 1'b1,
    EnWideMulticast: 1'b1,
    EnLsbAnd: 1'b1,
    EnFpAdd: 1'b0,
    EnFpMul: 1'b0,
    EnFpMin: 1'b0,
    EnFpMax: 1'b0,
    EnIntAdd: 1'b0,
    EnIntMul: 1'b0,
    EnIntMinS: 1'b0,
    EnIntMinU: 1'b0,
    EnIntMaxS: 1'b0,
    EnIntMaxU: 1'b0},
    NarrRedCfg: RedDefaultCfg,
    WideRedCfg: RedDefaultCfg}};

  

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
    InIdWidth: 4,
    OutIdWidth: 2,
    UserWidth: 1};
localparam axi_cfg_t AxiCfgW = '{    AddrWidth: 32,
    DataWidth: 256,
    InIdWidth: 2,
    OutIdWidth: 2,
    UserWidth: 1};
`FLOO_TYPEDEF_NW_CHAN_ALL(axi, req, rsp, wide,             axi_narrow_data_slv, axi_wide_data_slv, AxiCfgN, AxiCfgW, hdr_t)

`FLOO_TYPEDEF_NW_LINK_ALL(req, rsp, wide, req, rsp, wide)


endpackage
