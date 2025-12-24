// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// AUTOMATICALLY GENERATED! DO NOT EDIT!

`include "axi/typedef.svh"
`include "floo_noc/typedef.svh"

package floo_axi_mesh_32x32_noc_pkg;

  import floo_pkg::*;

  /////////////////////
  //   Address Map   //
  /////////////////////

  typedef enum logic[10:0] {
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
    MagiaTileX0Y16 = 16,
    MagiaTileX0Y17 = 17,
    MagiaTileX0Y18 = 18,
    MagiaTileX0Y19 = 19,
    MagiaTileX0Y20 = 20,
    MagiaTileX0Y21 = 21,
    MagiaTileX0Y22 = 22,
    MagiaTileX0Y23 = 23,
    MagiaTileX0Y24 = 24,
    MagiaTileX0Y25 = 25,
    MagiaTileX0Y26 = 26,
    MagiaTileX0Y27 = 27,
    MagiaTileX0Y28 = 28,
    MagiaTileX0Y29 = 29,
    MagiaTileX0Y30 = 30,
    MagiaTileX0Y31 = 31,
    MagiaTileX1Y0 = 32,
    MagiaTileX1Y1 = 33,
    MagiaTileX1Y2 = 34,
    MagiaTileX1Y3 = 35,
    MagiaTileX1Y4 = 36,
    MagiaTileX1Y5 = 37,
    MagiaTileX1Y6 = 38,
    MagiaTileX1Y7 = 39,
    MagiaTileX1Y8 = 40,
    MagiaTileX1Y9 = 41,
    MagiaTileX1Y10 = 42,
    MagiaTileX1Y11 = 43,
    MagiaTileX1Y12 = 44,
    MagiaTileX1Y13 = 45,
    MagiaTileX1Y14 = 46,
    MagiaTileX1Y15 = 47,
    MagiaTileX1Y16 = 48,
    MagiaTileX1Y17 = 49,
    MagiaTileX1Y18 = 50,
    MagiaTileX1Y19 = 51,
    MagiaTileX1Y20 = 52,
    MagiaTileX1Y21 = 53,
    MagiaTileX1Y22 = 54,
    MagiaTileX1Y23 = 55,
    MagiaTileX1Y24 = 56,
    MagiaTileX1Y25 = 57,
    MagiaTileX1Y26 = 58,
    MagiaTileX1Y27 = 59,
    MagiaTileX1Y28 = 60,
    MagiaTileX1Y29 = 61,
    MagiaTileX1Y30 = 62,
    MagiaTileX1Y31 = 63,
    MagiaTileX2Y0 = 64,
    MagiaTileX2Y1 = 65,
    MagiaTileX2Y2 = 66,
    MagiaTileX2Y3 = 67,
    MagiaTileX2Y4 = 68,
    MagiaTileX2Y5 = 69,
    MagiaTileX2Y6 = 70,
    MagiaTileX2Y7 = 71,
    MagiaTileX2Y8 = 72,
    MagiaTileX2Y9 = 73,
    MagiaTileX2Y10 = 74,
    MagiaTileX2Y11 = 75,
    MagiaTileX2Y12 = 76,
    MagiaTileX2Y13 = 77,
    MagiaTileX2Y14 = 78,
    MagiaTileX2Y15 = 79,
    MagiaTileX2Y16 = 80,
    MagiaTileX2Y17 = 81,
    MagiaTileX2Y18 = 82,
    MagiaTileX2Y19 = 83,
    MagiaTileX2Y20 = 84,
    MagiaTileX2Y21 = 85,
    MagiaTileX2Y22 = 86,
    MagiaTileX2Y23 = 87,
    MagiaTileX2Y24 = 88,
    MagiaTileX2Y25 = 89,
    MagiaTileX2Y26 = 90,
    MagiaTileX2Y27 = 91,
    MagiaTileX2Y28 = 92,
    MagiaTileX2Y29 = 93,
    MagiaTileX2Y30 = 94,
    MagiaTileX2Y31 = 95,
    MagiaTileX3Y0 = 96,
    MagiaTileX3Y1 = 97,
    MagiaTileX3Y2 = 98,
    MagiaTileX3Y3 = 99,
    MagiaTileX3Y4 = 100,
    MagiaTileX3Y5 = 101,
    MagiaTileX3Y6 = 102,
    MagiaTileX3Y7 = 103,
    MagiaTileX3Y8 = 104,
    MagiaTileX3Y9 = 105,
    MagiaTileX3Y10 = 106,
    MagiaTileX3Y11 = 107,
    MagiaTileX3Y12 = 108,
    MagiaTileX3Y13 = 109,
    MagiaTileX3Y14 = 110,
    MagiaTileX3Y15 = 111,
    MagiaTileX3Y16 = 112,
    MagiaTileX3Y17 = 113,
    MagiaTileX3Y18 = 114,
    MagiaTileX3Y19 = 115,
    MagiaTileX3Y20 = 116,
    MagiaTileX3Y21 = 117,
    MagiaTileX3Y22 = 118,
    MagiaTileX3Y23 = 119,
    MagiaTileX3Y24 = 120,
    MagiaTileX3Y25 = 121,
    MagiaTileX3Y26 = 122,
    MagiaTileX3Y27 = 123,
    MagiaTileX3Y28 = 124,
    MagiaTileX3Y29 = 125,
    MagiaTileX3Y30 = 126,
    MagiaTileX3Y31 = 127,
    MagiaTileX4Y0 = 128,
    MagiaTileX4Y1 = 129,
    MagiaTileX4Y2 = 130,
    MagiaTileX4Y3 = 131,
    MagiaTileX4Y4 = 132,
    MagiaTileX4Y5 = 133,
    MagiaTileX4Y6 = 134,
    MagiaTileX4Y7 = 135,
    MagiaTileX4Y8 = 136,
    MagiaTileX4Y9 = 137,
    MagiaTileX4Y10 = 138,
    MagiaTileX4Y11 = 139,
    MagiaTileX4Y12 = 140,
    MagiaTileX4Y13 = 141,
    MagiaTileX4Y14 = 142,
    MagiaTileX4Y15 = 143,
    MagiaTileX4Y16 = 144,
    MagiaTileX4Y17 = 145,
    MagiaTileX4Y18 = 146,
    MagiaTileX4Y19 = 147,
    MagiaTileX4Y20 = 148,
    MagiaTileX4Y21 = 149,
    MagiaTileX4Y22 = 150,
    MagiaTileX4Y23 = 151,
    MagiaTileX4Y24 = 152,
    MagiaTileX4Y25 = 153,
    MagiaTileX4Y26 = 154,
    MagiaTileX4Y27 = 155,
    MagiaTileX4Y28 = 156,
    MagiaTileX4Y29 = 157,
    MagiaTileX4Y30 = 158,
    MagiaTileX4Y31 = 159,
    MagiaTileX5Y0 = 160,
    MagiaTileX5Y1 = 161,
    MagiaTileX5Y2 = 162,
    MagiaTileX5Y3 = 163,
    MagiaTileX5Y4 = 164,
    MagiaTileX5Y5 = 165,
    MagiaTileX5Y6 = 166,
    MagiaTileX5Y7 = 167,
    MagiaTileX5Y8 = 168,
    MagiaTileX5Y9 = 169,
    MagiaTileX5Y10 = 170,
    MagiaTileX5Y11 = 171,
    MagiaTileX5Y12 = 172,
    MagiaTileX5Y13 = 173,
    MagiaTileX5Y14 = 174,
    MagiaTileX5Y15 = 175,
    MagiaTileX5Y16 = 176,
    MagiaTileX5Y17 = 177,
    MagiaTileX5Y18 = 178,
    MagiaTileX5Y19 = 179,
    MagiaTileX5Y20 = 180,
    MagiaTileX5Y21 = 181,
    MagiaTileX5Y22 = 182,
    MagiaTileX5Y23 = 183,
    MagiaTileX5Y24 = 184,
    MagiaTileX5Y25 = 185,
    MagiaTileX5Y26 = 186,
    MagiaTileX5Y27 = 187,
    MagiaTileX5Y28 = 188,
    MagiaTileX5Y29 = 189,
    MagiaTileX5Y30 = 190,
    MagiaTileX5Y31 = 191,
    MagiaTileX6Y0 = 192,
    MagiaTileX6Y1 = 193,
    MagiaTileX6Y2 = 194,
    MagiaTileX6Y3 = 195,
    MagiaTileX6Y4 = 196,
    MagiaTileX6Y5 = 197,
    MagiaTileX6Y6 = 198,
    MagiaTileX6Y7 = 199,
    MagiaTileX6Y8 = 200,
    MagiaTileX6Y9 = 201,
    MagiaTileX6Y10 = 202,
    MagiaTileX6Y11 = 203,
    MagiaTileX6Y12 = 204,
    MagiaTileX6Y13 = 205,
    MagiaTileX6Y14 = 206,
    MagiaTileX6Y15 = 207,
    MagiaTileX6Y16 = 208,
    MagiaTileX6Y17 = 209,
    MagiaTileX6Y18 = 210,
    MagiaTileX6Y19 = 211,
    MagiaTileX6Y20 = 212,
    MagiaTileX6Y21 = 213,
    MagiaTileX6Y22 = 214,
    MagiaTileX6Y23 = 215,
    MagiaTileX6Y24 = 216,
    MagiaTileX6Y25 = 217,
    MagiaTileX6Y26 = 218,
    MagiaTileX6Y27 = 219,
    MagiaTileX6Y28 = 220,
    MagiaTileX6Y29 = 221,
    MagiaTileX6Y30 = 222,
    MagiaTileX6Y31 = 223,
    MagiaTileX7Y0 = 224,
    MagiaTileX7Y1 = 225,
    MagiaTileX7Y2 = 226,
    MagiaTileX7Y3 = 227,
    MagiaTileX7Y4 = 228,
    MagiaTileX7Y5 = 229,
    MagiaTileX7Y6 = 230,
    MagiaTileX7Y7 = 231,
    MagiaTileX7Y8 = 232,
    MagiaTileX7Y9 = 233,
    MagiaTileX7Y10 = 234,
    MagiaTileX7Y11 = 235,
    MagiaTileX7Y12 = 236,
    MagiaTileX7Y13 = 237,
    MagiaTileX7Y14 = 238,
    MagiaTileX7Y15 = 239,
    MagiaTileX7Y16 = 240,
    MagiaTileX7Y17 = 241,
    MagiaTileX7Y18 = 242,
    MagiaTileX7Y19 = 243,
    MagiaTileX7Y20 = 244,
    MagiaTileX7Y21 = 245,
    MagiaTileX7Y22 = 246,
    MagiaTileX7Y23 = 247,
    MagiaTileX7Y24 = 248,
    MagiaTileX7Y25 = 249,
    MagiaTileX7Y26 = 250,
    MagiaTileX7Y27 = 251,
    MagiaTileX7Y28 = 252,
    MagiaTileX7Y29 = 253,
    MagiaTileX7Y30 = 254,
    MagiaTileX7Y31 = 255,
    MagiaTileX8Y0 = 256,
    MagiaTileX8Y1 = 257,
    MagiaTileX8Y2 = 258,
    MagiaTileX8Y3 = 259,
    MagiaTileX8Y4 = 260,
    MagiaTileX8Y5 = 261,
    MagiaTileX8Y6 = 262,
    MagiaTileX8Y7 = 263,
    MagiaTileX8Y8 = 264,
    MagiaTileX8Y9 = 265,
    MagiaTileX8Y10 = 266,
    MagiaTileX8Y11 = 267,
    MagiaTileX8Y12 = 268,
    MagiaTileX8Y13 = 269,
    MagiaTileX8Y14 = 270,
    MagiaTileX8Y15 = 271,
    MagiaTileX8Y16 = 272,
    MagiaTileX8Y17 = 273,
    MagiaTileX8Y18 = 274,
    MagiaTileX8Y19 = 275,
    MagiaTileX8Y20 = 276,
    MagiaTileX8Y21 = 277,
    MagiaTileX8Y22 = 278,
    MagiaTileX8Y23 = 279,
    MagiaTileX8Y24 = 280,
    MagiaTileX8Y25 = 281,
    MagiaTileX8Y26 = 282,
    MagiaTileX8Y27 = 283,
    MagiaTileX8Y28 = 284,
    MagiaTileX8Y29 = 285,
    MagiaTileX8Y30 = 286,
    MagiaTileX8Y31 = 287,
    MagiaTileX9Y0 = 288,
    MagiaTileX9Y1 = 289,
    MagiaTileX9Y2 = 290,
    MagiaTileX9Y3 = 291,
    MagiaTileX9Y4 = 292,
    MagiaTileX9Y5 = 293,
    MagiaTileX9Y6 = 294,
    MagiaTileX9Y7 = 295,
    MagiaTileX9Y8 = 296,
    MagiaTileX9Y9 = 297,
    MagiaTileX9Y10 = 298,
    MagiaTileX9Y11 = 299,
    MagiaTileX9Y12 = 300,
    MagiaTileX9Y13 = 301,
    MagiaTileX9Y14 = 302,
    MagiaTileX9Y15 = 303,
    MagiaTileX9Y16 = 304,
    MagiaTileX9Y17 = 305,
    MagiaTileX9Y18 = 306,
    MagiaTileX9Y19 = 307,
    MagiaTileX9Y20 = 308,
    MagiaTileX9Y21 = 309,
    MagiaTileX9Y22 = 310,
    MagiaTileX9Y23 = 311,
    MagiaTileX9Y24 = 312,
    MagiaTileX9Y25 = 313,
    MagiaTileX9Y26 = 314,
    MagiaTileX9Y27 = 315,
    MagiaTileX9Y28 = 316,
    MagiaTileX9Y29 = 317,
    MagiaTileX9Y30 = 318,
    MagiaTileX9Y31 = 319,
    MagiaTileX10Y0 = 320,
    MagiaTileX10Y1 = 321,
    MagiaTileX10Y2 = 322,
    MagiaTileX10Y3 = 323,
    MagiaTileX10Y4 = 324,
    MagiaTileX10Y5 = 325,
    MagiaTileX10Y6 = 326,
    MagiaTileX10Y7 = 327,
    MagiaTileX10Y8 = 328,
    MagiaTileX10Y9 = 329,
    MagiaTileX10Y10 = 330,
    MagiaTileX10Y11 = 331,
    MagiaTileX10Y12 = 332,
    MagiaTileX10Y13 = 333,
    MagiaTileX10Y14 = 334,
    MagiaTileX10Y15 = 335,
    MagiaTileX10Y16 = 336,
    MagiaTileX10Y17 = 337,
    MagiaTileX10Y18 = 338,
    MagiaTileX10Y19 = 339,
    MagiaTileX10Y20 = 340,
    MagiaTileX10Y21 = 341,
    MagiaTileX10Y22 = 342,
    MagiaTileX10Y23 = 343,
    MagiaTileX10Y24 = 344,
    MagiaTileX10Y25 = 345,
    MagiaTileX10Y26 = 346,
    MagiaTileX10Y27 = 347,
    MagiaTileX10Y28 = 348,
    MagiaTileX10Y29 = 349,
    MagiaTileX10Y30 = 350,
    MagiaTileX10Y31 = 351,
    MagiaTileX11Y0 = 352,
    MagiaTileX11Y1 = 353,
    MagiaTileX11Y2 = 354,
    MagiaTileX11Y3 = 355,
    MagiaTileX11Y4 = 356,
    MagiaTileX11Y5 = 357,
    MagiaTileX11Y6 = 358,
    MagiaTileX11Y7 = 359,
    MagiaTileX11Y8 = 360,
    MagiaTileX11Y9 = 361,
    MagiaTileX11Y10 = 362,
    MagiaTileX11Y11 = 363,
    MagiaTileX11Y12 = 364,
    MagiaTileX11Y13 = 365,
    MagiaTileX11Y14 = 366,
    MagiaTileX11Y15 = 367,
    MagiaTileX11Y16 = 368,
    MagiaTileX11Y17 = 369,
    MagiaTileX11Y18 = 370,
    MagiaTileX11Y19 = 371,
    MagiaTileX11Y20 = 372,
    MagiaTileX11Y21 = 373,
    MagiaTileX11Y22 = 374,
    MagiaTileX11Y23 = 375,
    MagiaTileX11Y24 = 376,
    MagiaTileX11Y25 = 377,
    MagiaTileX11Y26 = 378,
    MagiaTileX11Y27 = 379,
    MagiaTileX11Y28 = 380,
    MagiaTileX11Y29 = 381,
    MagiaTileX11Y30 = 382,
    MagiaTileX11Y31 = 383,
    MagiaTileX12Y0 = 384,
    MagiaTileX12Y1 = 385,
    MagiaTileX12Y2 = 386,
    MagiaTileX12Y3 = 387,
    MagiaTileX12Y4 = 388,
    MagiaTileX12Y5 = 389,
    MagiaTileX12Y6 = 390,
    MagiaTileX12Y7 = 391,
    MagiaTileX12Y8 = 392,
    MagiaTileX12Y9 = 393,
    MagiaTileX12Y10 = 394,
    MagiaTileX12Y11 = 395,
    MagiaTileX12Y12 = 396,
    MagiaTileX12Y13 = 397,
    MagiaTileX12Y14 = 398,
    MagiaTileX12Y15 = 399,
    MagiaTileX12Y16 = 400,
    MagiaTileX12Y17 = 401,
    MagiaTileX12Y18 = 402,
    MagiaTileX12Y19 = 403,
    MagiaTileX12Y20 = 404,
    MagiaTileX12Y21 = 405,
    MagiaTileX12Y22 = 406,
    MagiaTileX12Y23 = 407,
    MagiaTileX12Y24 = 408,
    MagiaTileX12Y25 = 409,
    MagiaTileX12Y26 = 410,
    MagiaTileX12Y27 = 411,
    MagiaTileX12Y28 = 412,
    MagiaTileX12Y29 = 413,
    MagiaTileX12Y30 = 414,
    MagiaTileX12Y31 = 415,
    MagiaTileX13Y0 = 416,
    MagiaTileX13Y1 = 417,
    MagiaTileX13Y2 = 418,
    MagiaTileX13Y3 = 419,
    MagiaTileX13Y4 = 420,
    MagiaTileX13Y5 = 421,
    MagiaTileX13Y6 = 422,
    MagiaTileX13Y7 = 423,
    MagiaTileX13Y8 = 424,
    MagiaTileX13Y9 = 425,
    MagiaTileX13Y10 = 426,
    MagiaTileX13Y11 = 427,
    MagiaTileX13Y12 = 428,
    MagiaTileX13Y13 = 429,
    MagiaTileX13Y14 = 430,
    MagiaTileX13Y15 = 431,
    MagiaTileX13Y16 = 432,
    MagiaTileX13Y17 = 433,
    MagiaTileX13Y18 = 434,
    MagiaTileX13Y19 = 435,
    MagiaTileX13Y20 = 436,
    MagiaTileX13Y21 = 437,
    MagiaTileX13Y22 = 438,
    MagiaTileX13Y23 = 439,
    MagiaTileX13Y24 = 440,
    MagiaTileX13Y25 = 441,
    MagiaTileX13Y26 = 442,
    MagiaTileX13Y27 = 443,
    MagiaTileX13Y28 = 444,
    MagiaTileX13Y29 = 445,
    MagiaTileX13Y30 = 446,
    MagiaTileX13Y31 = 447,
    MagiaTileX14Y0 = 448,
    MagiaTileX14Y1 = 449,
    MagiaTileX14Y2 = 450,
    MagiaTileX14Y3 = 451,
    MagiaTileX14Y4 = 452,
    MagiaTileX14Y5 = 453,
    MagiaTileX14Y6 = 454,
    MagiaTileX14Y7 = 455,
    MagiaTileX14Y8 = 456,
    MagiaTileX14Y9 = 457,
    MagiaTileX14Y10 = 458,
    MagiaTileX14Y11 = 459,
    MagiaTileX14Y12 = 460,
    MagiaTileX14Y13 = 461,
    MagiaTileX14Y14 = 462,
    MagiaTileX14Y15 = 463,
    MagiaTileX14Y16 = 464,
    MagiaTileX14Y17 = 465,
    MagiaTileX14Y18 = 466,
    MagiaTileX14Y19 = 467,
    MagiaTileX14Y20 = 468,
    MagiaTileX14Y21 = 469,
    MagiaTileX14Y22 = 470,
    MagiaTileX14Y23 = 471,
    MagiaTileX14Y24 = 472,
    MagiaTileX14Y25 = 473,
    MagiaTileX14Y26 = 474,
    MagiaTileX14Y27 = 475,
    MagiaTileX14Y28 = 476,
    MagiaTileX14Y29 = 477,
    MagiaTileX14Y30 = 478,
    MagiaTileX14Y31 = 479,
    MagiaTileX15Y0 = 480,
    MagiaTileX15Y1 = 481,
    MagiaTileX15Y2 = 482,
    MagiaTileX15Y3 = 483,
    MagiaTileX15Y4 = 484,
    MagiaTileX15Y5 = 485,
    MagiaTileX15Y6 = 486,
    MagiaTileX15Y7 = 487,
    MagiaTileX15Y8 = 488,
    MagiaTileX15Y9 = 489,
    MagiaTileX15Y10 = 490,
    MagiaTileX15Y11 = 491,
    MagiaTileX15Y12 = 492,
    MagiaTileX15Y13 = 493,
    MagiaTileX15Y14 = 494,
    MagiaTileX15Y15 = 495,
    MagiaTileX15Y16 = 496,
    MagiaTileX15Y17 = 497,
    MagiaTileX15Y18 = 498,
    MagiaTileX15Y19 = 499,
    MagiaTileX15Y20 = 500,
    MagiaTileX15Y21 = 501,
    MagiaTileX15Y22 = 502,
    MagiaTileX15Y23 = 503,
    MagiaTileX15Y24 = 504,
    MagiaTileX15Y25 = 505,
    MagiaTileX15Y26 = 506,
    MagiaTileX15Y27 = 507,
    MagiaTileX15Y28 = 508,
    MagiaTileX15Y29 = 509,
    MagiaTileX15Y30 = 510,
    MagiaTileX15Y31 = 511,
    MagiaTileX16Y0 = 512,
    MagiaTileX16Y1 = 513,
    MagiaTileX16Y2 = 514,
    MagiaTileX16Y3 = 515,
    MagiaTileX16Y4 = 516,
    MagiaTileX16Y5 = 517,
    MagiaTileX16Y6 = 518,
    MagiaTileX16Y7 = 519,
    MagiaTileX16Y8 = 520,
    MagiaTileX16Y9 = 521,
    MagiaTileX16Y10 = 522,
    MagiaTileX16Y11 = 523,
    MagiaTileX16Y12 = 524,
    MagiaTileX16Y13 = 525,
    MagiaTileX16Y14 = 526,
    MagiaTileX16Y15 = 527,
    MagiaTileX16Y16 = 528,
    MagiaTileX16Y17 = 529,
    MagiaTileX16Y18 = 530,
    MagiaTileX16Y19 = 531,
    MagiaTileX16Y20 = 532,
    MagiaTileX16Y21 = 533,
    MagiaTileX16Y22 = 534,
    MagiaTileX16Y23 = 535,
    MagiaTileX16Y24 = 536,
    MagiaTileX16Y25 = 537,
    MagiaTileX16Y26 = 538,
    MagiaTileX16Y27 = 539,
    MagiaTileX16Y28 = 540,
    MagiaTileX16Y29 = 541,
    MagiaTileX16Y30 = 542,
    MagiaTileX16Y31 = 543,
    MagiaTileX17Y0 = 544,
    MagiaTileX17Y1 = 545,
    MagiaTileX17Y2 = 546,
    MagiaTileX17Y3 = 547,
    MagiaTileX17Y4 = 548,
    MagiaTileX17Y5 = 549,
    MagiaTileX17Y6 = 550,
    MagiaTileX17Y7 = 551,
    MagiaTileX17Y8 = 552,
    MagiaTileX17Y9 = 553,
    MagiaTileX17Y10 = 554,
    MagiaTileX17Y11 = 555,
    MagiaTileX17Y12 = 556,
    MagiaTileX17Y13 = 557,
    MagiaTileX17Y14 = 558,
    MagiaTileX17Y15 = 559,
    MagiaTileX17Y16 = 560,
    MagiaTileX17Y17 = 561,
    MagiaTileX17Y18 = 562,
    MagiaTileX17Y19 = 563,
    MagiaTileX17Y20 = 564,
    MagiaTileX17Y21 = 565,
    MagiaTileX17Y22 = 566,
    MagiaTileX17Y23 = 567,
    MagiaTileX17Y24 = 568,
    MagiaTileX17Y25 = 569,
    MagiaTileX17Y26 = 570,
    MagiaTileX17Y27 = 571,
    MagiaTileX17Y28 = 572,
    MagiaTileX17Y29 = 573,
    MagiaTileX17Y30 = 574,
    MagiaTileX17Y31 = 575,
    MagiaTileX18Y0 = 576,
    MagiaTileX18Y1 = 577,
    MagiaTileX18Y2 = 578,
    MagiaTileX18Y3 = 579,
    MagiaTileX18Y4 = 580,
    MagiaTileX18Y5 = 581,
    MagiaTileX18Y6 = 582,
    MagiaTileX18Y7 = 583,
    MagiaTileX18Y8 = 584,
    MagiaTileX18Y9 = 585,
    MagiaTileX18Y10 = 586,
    MagiaTileX18Y11 = 587,
    MagiaTileX18Y12 = 588,
    MagiaTileX18Y13 = 589,
    MagiaTileX18Y14 = 590,
    MagiaTileX18Y15 = 591,
    MagiaTileX18Y16 = 592,
    MagiaTileX18Y17 = 593,
    MagiaTileX18Y18 = 594,
    MagiaTileX18Y19 = 595,
    MagiaTileX18Y20 = 596,
    MagiaTileX18Y21 = 597,
    MagiaTileX18Y22 = 598,
    MagiaTileX18Y23 = 599,
    MagiaTileX18Y24 = 600,
    MagiaTileX18Y25 = 601,
    MagiaTileX18Y26 = 602,
    MagiaTileX18Y27 = 603,
    MagiaTileX18Y28 = 604,
    MagiaTileX18Y29 = 605,
    MagiaTileX18Y30 = 606,
    MagiaTileX18Y31 = 607,
    MagiaTileX19Y0 = 608,
    MagiaTileX19Y1 = 609,
    MagiaTileX19Y2 = 610,
    MagiaTileX19Y3 = 611,
    MagiaTileX19Y4 = 612,
    MagiaTileX19Y5 = 613,
    MagiaTileX19Y6 = 614,
    MagiaTileX19Y7 = 615,
    MagiaTileX19Y8 = 616,
    MagiaTileX19Y9 = 617,
    MagiaTileX19Y10 = 618,
    MagiaTileX19Y11 = 619,
    MagiaTileX19Y12 = 620,
    MagiaTileX19Y13 = 621,
    MagiaTileX19Y14 = 622,
    MagiaTileX19Y15 = 623,
    MagiaTileX19Y16 = 624,
    MagiaTileX19Y17 = 625,
    MagiaTileX19Y18 = 626,
    MagiaTileX19Y19 = 627,
    MagiaTileX19Y20 = 628,
    MagiaTileX19Y21 = 629,
    MagiaTileX19Y22 = 630,
    MagiaTileX19Y23 = 631,
    MagiaTileX19Y24 = 632,
    MagiaTileX19Y25 = 633,
    MagiaTileX19Y26 = 634,
    MagiaTileX19Y27 = 635,
    MagiaTileX19Y28 = 636,
    MagiaTileX19Y29 = 637,
    MagiaTileX19Y30 = 638,
    MagiaTileX19Y31 = 639,
    MagiaTileX20Y0 = 640,
    MagiaTileX20Y1 = 641,
    MagiaTileX20Y2 = 642,
    MagiaTileX20Y3 = 643,
    MagiaTileX20Y4 = 644,
    MagiaTileX20Y5 = 645,
    MagiaTileX20Y6 = 646,
    MagiaTileX20Y7 = 647,
    MagiaTileX20Y8 = 648,
    MagiaTileX20Y9 = 649,
    MagiaTileX20Y10 = 650,
    MagiaTileX20Y11 = 651,
    MagiaTileX20Y12 = 652,
    MagiaTileX20Y13 = 653,
    MagiaTileX20Y14 = 654,
    MagiaTileX20Y15 = 655,
    MagiaTileX20Y16 = 656,
    MagiaTileX20Y17 = 657,
    MagiaTileX20Y18 = 658,
    MagiaTileX20Y19 = 659,
    MagiaTileX20Y20 = 660,
    MagiaTileX20Y21 = 661,
    MagiaTileX20Y22 = 662,
    MagiaTileX20Y23 = 663,
    MagiaTileX20Y24 = 664,
    MagiaTileX20Y25 = 665,
    MagiaTileX20Y26 = 666,
    MagiaTileX20Y27 = 667,
    MagiaTileX20Y28 = 668,
    MagiaTileX20Y29 = 669,
    MagiaTileX20Y30 = 670,
    MagiaTileX20Y31 = 671,
    MagiaTileX21Y0 = 672,
    MagiaTileX21Y1 = 673,
    MagiaTileX21Y2 = 674,
    MagiaTileX21Y3 = 675,
    MagiaTileX21Y4 = 676,
    MagiaTileX21Y5 = 677,
    MagiaTileX21Y6 = 678,
    MagiaTileX21Y7 = 679,
    MagiaTileX21Y8 = 680,
    MagiaTileX21Y9 = 681,
    MagiaTileX21Y10 = 682,
    MagiaTileX21Y11 = 683,
    MagiaTileX21Y12 = 684,
    MagiaTileX21Y13 = 685,
    MagiaTileX21Y14 = 686,
    MagiaTileX21Y15 = 687,
    MagiaTileX21Y16 = 688,
    MagiaTileX21Y17 = 689,
    MagiaTileX21Y18 = 690,
    MagiaTileX21Y19 = 691,
    MagiaTileX21Y20 = 692,
    MagiaTileX21Y21 = 693,
    MagiaTileX21Y22 = 694,
    MagiaTileX21Y23 = 695,
    MagiaTileX21Y24 = 696,
    MagiaTileX21Y25 = 697,
    MagiaTileX21Y26 = 698,
    MagiaTileX21Y27 = 699,
    MagiaTileX21Y28 = 700,
    MagiaTileX21Y29 = 701,
    MagiaTileX21Y30 = 702,
    MagiaTileX21Y31 = 703,
    MagiaTileX22Y0 = 704,
    MagiaTileX22Y1 = 705,
    MagiaTileX22Y2 = 706,
    MagiaTileX22Y3 = 707,
    MagiaTileX22Y4 = 708,
    MagiaTileX22Y5 = 709,
    MagiaTileX22Y6 = 710,
    MagiaTileX22Y7 = 711,
    MagiaTileX22Y8 = 712,
    MagiaTileX22Y9 = 713,
    MagiaTileX22Y10 = 714,
    MagiaTileX22Y11 = 715,
    MagiaTileX22Y12 = 716,
    MagiaTileX22Y13 = 717,
    MagiaTileX22Y14 = 718,
    MagiaTileX22Y15 = 719,
    MagiaTileX22Y16 = 720,
    MagiaTileX22Y17 = 721,
    MagiaTileX22Y18 = 722,
    MagiaTileX22Y19 = 723,
    MagiaTileX22Y20 = 724,
    MagiaTileX22Y21 = 725,
    MagiaTileX22Y22 = 726,
    MagiaTileX22Y23 = 727,
    MagiaTileX22Y24 = 728,
    MagiaTileX22Y25 = 729,
    MagiaTileX22Y26 = 730,
    MagiaTileX22Y27 = 731,
    MagiaTileX22Y28 = 732,
    MagiaTileX22Y29 = 733,
    MagiaTileX22Y30 = 734,
    MagiaTileX22Y31 = 735,
    MagiaTileX23Y0 = 736,
    MagiaTileX23Y1 = 737,
    MagiaTileX23Y2 = 738,
    MagiaTileX23Y3 = 739,
    MagiaTileX23Y4 = 740,
    MagiaTileX23Y5 = 741,
    MagiaTileX23Y6 = 742,
    MagiaTileX23Y7 = 743,
    MagiaTileX23Y8 = 744,
    MagiaTileX23Y9 = 745,
    MagiaTileX23Y10 = 746,
    MagiaTileX23Y11 = 747,
    MagiaTileX23Y12 = 748,
    MagiaTileX23Y13 = 749,
    MagiaTileX23Y14 = 750,
    MagiaTileX23Y15 = 751,
    MagiaTileX23Y16 = 752,
    MagiaTileX23Y17 = 753,
    MagiaTileX23Y18 = 754,
    MagiaTileX23Y19 = 755,
    MagiaTileX23Y20 = 756,
    MagiaTileX23Y21 = 757,
    MagiaTileX23Y22 = 758,
    MagiaTileX23Y23 = 759,
    MagiaTileX23Y24 = 760,
    MagiaTileX23Y25 = 761,
    MagiaTileX23Y26 = 762,
    MagiaTileX23Y27 = 763,
    MagiaTileX23Y28 = 764,
    MagiaTileX23Y29 = 765,
    MagiaTileX23Y30 = 766,
    MagiaTileX23Y31 = 767,
    MagiaTileX24Y0 = 768,
    MagiaTileX24Y1 = 769,
    MagiaTileX24Y2 = 770,
    MagiaTileX24Y3 = 771,
    MagiaTileX24Y4 = 772,
    MagiaTileX24Y5 = 773,
    MagiaTileX24Y6 = 774,
    MagiaTileX24Y7 = 775,
    MagiaTileX24Y8 = 776,
    MagiaTileX24Y9 = 777,
    MagiaTileX24Y10 = 778,
    MagiaTileX24Y11 = 779,
    MagiaTileX24Y12 = 780,
    MagiaTileX24Y13 = 781,
    MagiaTileX24Y14 = 782,
    MagiaTileX24Y15 = 783,
    MagiaTileX24Y16 = 784,
    MagiaTileX24Y17 = 785,
    MagiaTileX24Y18 = 786,
    MagiaTileX24Y19 = 787,
    MagiaTileX24Y20 = 788,
    MagiaTileX24Y21 = 789,
    MagiaTileX24Y22 = 790,
    MagiaTileX24Y23 = 791,
    MagiaTileX24Y24 = 792,
    MagiaTileX24Y25 = 793,
    MagiaTileX24Y26 = 794,
    MagiaTileX24Y27 = 795,
    MagiaTileX24Y28 = 796,
    MagiaTileX24Y29 = 797,
    MagiaTileX24Y30 = 798,
    MagiaTileX24Y31 = 799,
    MagiaTileX25Y0 = 800,
    MagiaTileX25Y1 = 801,
    MagiaTileX25Y2 = 802,
    MagiaTileX25Y3 = 803,
    MagiaTileX25Y4 = 804,
    MagiaTileX25Y5 = 805,
    MagiaTileX25Y6 = 806,
    MagiaTileX25Y7 = 807,
    MagiaTileX25Y8 = 808,
    MagiaTileX25Y9 = 809,
    MagiaTileX25Y10 = 810,
    MagiaTileX25Y11 = 811,
    MagiaTileX25Y12 = 812,
    MagiaTileX25Y13 = 813,
    MagiaTileX25Y14 = 814,
    MagiaTileX25Y15 = 815,
    MagiaTileX25Y16 = 816,
    MagiaTileX25Y17 = 817,
    MagiaTileX25Y18 = 818,
    MagiaTileX25Y19 = 819,
    MagiaTileX25Y20 = 820,
    MagiaTileX25Y21 = 821,
    MagiaTileX25Y22 = 822,
    MagiaTileX25Y23 = 823,
    MagiaTileX25Y24 = 824,
    MagiaTileX25Y25 = 825,
    MagiaTileX25Y26 = 826,
    MagiaTileX25Y27 = 827,
    MagiaTileX25Y28 = 828,
    MagiaTileX25Y29 = 829,
    MagiaTileX25Y30 = 830,
    MagiaTileX25Y31 = 831,
    MagiaTileX26Y0 = 832,
    MagiaTileX26Y1 = 833,
    MagiaTileX26Y2 = 834,
    MagiaTileX26Y3 = 835,
    MagiaTileX26Y4 = 836,
    MagiaTileX26Y5 = 837,
    MagiaTileX26Y6 = 838,
    MagiaTileX26Y7 = 839,
    MagiaTileX26Y8 = 840,
    MagiaTileX26Y9 = 841,
    MagiaTileX26Y10 = 842,
    MagiaTileX26Y11 = 843,
    MagiaTileX26Y12 = 844,
    MagiaTileX26Y13 = 845,
    MagiaTileX26Y14 = 846,
    MagiaTileX26Y15 = 847,
    MagiaTileX26Y16 = 848,
    MagiaTileX26Y17 = 849,
    MagiaTileX26Y18 = 850,
    MagiaTileX26Y19 = 851,
    MagiaTileX26Y20 = 852,
    MagiaTileX26Y21 = 853,
    MagiaTileX26Y22 = 854,
    MagiaTileX26Y23 = 855,
    MagiaTileX26Y24 = 856,
    MagiaTileX26Y25 = 857,
    MagiaTileX26Y26 = 858,
    MagiaTileX26Y27 = 859,
    MagiaTileX26Y28 = 860,
    MagiaTileX26Y29 = 861,
    MagiaTileX26Y30 = 862,
    MagiaTileX26Y31 = 863,
    MagiaTileX27Y0 = 864,
    MagiaTileX27Y1 = 865,
    MagiaTileX27Y2 = 866,
    MagiaTileX27Y3 = 867,
    MagiaTileX27Y4 = 868,
    MagiaTileX27Y5 = 869,
    MagiaTileX27Y6 = 870,
    MagiaTileX27Y7 = 871,
    MagiaTileX27Y8 = 872,
    MagiaTileX27Y9 = 873,
    MagiaTileX27Y10 = 874,
    MagiaTileX27Y11 = 875,
    MagiaTileX27Y12 = 876,
    MagiaTileX27Y13 = 877,
    MagiaTileX27Y14 = 878,
    MagiaTileX27Y15 = 879,
    MagiaTileX27Y16 = 880,
    MagiaTileX27Y17 = 881,
    MagiaTileX27Y18 = 882,
    MagiaTileX27Y19 = 883,
    MagiaTileX27Y20 = 884,
    MagiaTileX27Y21 = 885,
    MagiaTileX27Y22 = 886,
    MagiaTileX27Y23 = 887,
    MagiaTileX27Y24 = 888,
    MagiaTileX27Y25 = 889,
    MagiaTileX27Y26 = 890,
    MagiaTileX27Y27 = 891,
    MagiaTileX27Y28 = 892,
    MagiaTileX27Y29 = 893,
    MagiaTileX27Y30 = 894,
    MagiaTileX27Y31 = 895,
    MagiaTileX28Y0 = 896,
    MagiaTileX28Y1 = 897,
    MagiaTileX28Y2 = 898,
    MagiaTileX28Y3 = 899,
    MagiaTileX28Y4 = 900,
    MagiaTileX28Y5 = 901,
    MagiaTileX28Y6 = 902,
    MagiaTileX28Y7 = 903,
    MagiaTileX28Y8 = 904,
    MagiaTileX28Y9 = 905,
    MagiaTileX28Y10 = 906,
    MagiaTileX28Y11 = 907,
    MagiaTileX28Y12 = 908,
    MagiaTileX28Y13 = 909,
    MagiaTileX28Y14 = 910,
    MagiaTileX28Y15 = 911,
    MagiaTileX28Y16 = 912,
    MagiaTileX28Y17 = 913,
    MagiaTileX28Y18 = 914,
    MagiaTileX28Y19 = 915,
    MagiaTileX28Y20 = 916,
    MagiaTileX28Y21 = 917,
    MagiaTileX28Y22 = 918,
    MagiaTileX28Y23 = 919,
    MagiaTileX28Y24 = 920,
    MagiaTileX28Y25 = 921,
    MagiaTileX28Y26 = 922,
    MagiaTileX28Y27 = 923,
    MagiaTileX28Y28 = 924,
    MagiaTileX28Y29 = 925,
    MagiaTileX28Y30 = 926,
    MagiaTileX28Y31 = 927,
    MagiaTileX29Y0 = 928,
    MagiaTileX29Y1 = 929,
    MagiaTileX29Y2 = 930,
    MagiaTileX29Y3 = 931,
    MagiaTileX29Y4 = 932,
    MagiaTileX29Y5 = 933,
    MagiaTileX29Y6 = 934,
    MagiaTileX29Y7 = 935,
    MagiaTileX29Y8 = 936,
    MagiaTileX29Y9 = 937,
    MagiaTileX29Y10 = 938,
    MagiaTileX29Y11 = 939,
    MagiaTileX29Y12 = 940,
    MagiaTileX29Y13 = 941,
    MagiaTileX29Y14 = 942,
    MagiaTileX29Y15 = 943,
    MagiaTileX29Y16 = 944,
    MagiaTileX29Y17 = 945,
    MagiaTileX29Y18 = 946,
    MagiaTileX29Y19 = 947,
    MagiaTileX29Y20 = 948,
    MagiaTileX29Y21 = 949,
    MagiaTileX29Y22 = 950,
    MagiaTileX29Y23 = 951,
    MagiaTileX29Y24 = 952,
    MagiaTileX29Y25 = 953,
    MagiaTileX29Y26 = 954,
    MagiaTileX29Y27 = 955,
    MagiaTileX29Y28 = 956,
    MagiaTileX29Y29 = 957,
    MagiaTileX29Y30 = 958,
    MagiaTileX29Y31 = 959,
    MagiaTileX30Y0 = 960,
    MagiaTileX30Y1 = 961,
    MagiaTileX30Y2 = 962,
    MagiaTileX30Y3 = 963,
    MagiaTileX30Y4 = 964,
    MagiaTileX30Y5 = 965,
    MagiaTileX30Y6 = 966,
    MagiaTileX30Y7 = 967,
    MagiaTileX30Y8 = 968,
    MagiaTileX30Y9 = 969,
    MagiaTileX30Y10 = 970,
    MagiaTileX30Y11 = 971,
    MagiaTileX30Y12 = 972,
    MagiaTileX30Y13 = 973,
    MagiaTileX30Y14 = 974,
    MagiaTileX30Y15 = 975,
    MagiaTileX30Y16 = 976,
    MagiaTileX30Y17 = 977,
    MagiaTileX30Y18 = 978,
    MagiaTileX30Y19 = 979,
    MagiaTileX30Y20 = 980,
    MagiaTileX30Y21 = 981,
    MagiaTileX30Y22 = 982,
    MagiaTileX30Y23 = 983,
    MagiaTileX30Y24 = 984,
    MagiaTileX30Y25 = 985,
    MagiaTileX30Y26 = 986,
    MagiaTileX30Y27 = 987,
    MagiaTileX30Y28 = 988,
    MagiaTileX30Y29 = 989,
    MagiaTileX30Y30 = 990,
    MagiaTileX30Y31 = 991,
    MagiaTileX31Y0 = 992,
    MagiaTileX31Y1 = 993,
    MagiaTileX31Y2 = 994,
    MagiaTileX31Y3 = 995,
    MagiaTileX31Y4 = 996,
    MagiaTileX31Y5 = 997,
    MagiaTileX31Y6 = 998,
    MagiaTileX31Y7 = 999,
    MagiaTileX31Y8 = 1000,
    MagiaTileX31Y9 = 1001,
    MagiaTileX31Y10 = 1002,
    MagiaTileX31Y11 = 1003,
    MagiaTileX31Y12 = 1004,
    MagiaTileX31Y13 = 1005,
    MagiaTileX31Y14 = 1006,
    MagiaTileX31Y15 = 1007,
    MagiaTileX31Y16 = 1008,
    MagiaTileX31Y17 = 1009,
    MagiaTileX31Y18 = 1010,
    MagiaTileX31Y19 = 1011,
    MagiaTileX31Y20 = 1012,
    MagiaTileX31Y21 = 1013,
    MagiaTileX31Y22 = 1014,
    MagiaTileX31Y23 = 1015,
    MagiaTileX31Y24 = 1016,
    MagiaTileX31Y25 = 1017,
    MagiaTileX31Y26 = 1018,
    MagiaTileX31Y27 = 1019,
    MagiaTileX31Y28 = 1020,
    MagiaTileX31Y29 = 1021,
    MagiaTileX31Y30 = 1022,
    MagiaTileX31Y31 = 1023,
    L20 = 1024,
    L21 = 1025,
    L22 = 1026,
    L23 = 1027,
    L24 = 1028,
    L25 = 1029,
    L26 = 1030,
    L27 = 1031,
    L28 = 1032,
    L29 = 1033,
    L210 = 1034,
    L211 = 1035,
    L212 = 1036,
    L213 = 1037,
    L214 = 1038,
    L215 = 1039,
    L216 = 1040,
    L217 = 1041,
    L218 = 1042,
    L219 = 1043,
    L220 = 1044,
    L221 = 1045,
    L222 = 1046,
    L223 = 1047,
    L224 = 1048,
    L225 = 1049,
    L226 = 1050,
    L227 = 1051,
    L228 = 1052,
    L229 = 1053,
    L230 = 1054,
    L231 = 1055,
    NumEndpoints = 1056} ep_id_e;



  typedef logic[0:0] rob_idx_t;
typedef logic[0:0] port_id_t;
typedef logic[5:0] x_bits_t;
typedef logic[4:0] y_bits_t;
typedef struct packed {
    x_bits_t x;
    y_bits_t y;
    port_id_t port_id;
} id_t;

typedef logic route_t;


  localparam int unsigned SamNumRules = 1056;

typedef struct packed {
    id_t idx;
    logic [31:0] start_addr;
    logic [31:0] end_addr;
} sam_rule_t;

localparam sam_rule_t[SamNumRules-1:0] Sam = '{
'{idx: '{x: 0, y: 31, port_id: 0}, start_addr: 32'hfe000000, end_addr: 32'h100000000},// L2_31_sam_idx
'{idx: '{x: 0, y: 30, port_id: 0}, start_addr: 32'hfc000000, end_addr: 32'hfe000000},// L2_30_sam_idx
'{idx: '{x: 0, y: 29, port_id: 0}, start_addr: 32'hfa000000, end_addr: 32'hfc000000},// L2_29_sam_idx
'{idx: '{x: 0, y: 28, port_id: 0}, start_addr: 32'hf8000000, end_addr: 32'hfa000000},// L2_28_sam_idx
'{idx: '{x: 0, y: 27, port_id: 0}, start_addr: 32'hf6000000, end_addr: 32'hf8000000},// L2_27_sam_idx
'{idx: '{x: 0, y: 26, port_id: 0}, start_addr: 32'hf4000000, end_addr: 32'hf6000000},// L2_26_sam_idx
'{idx: '{x: 0, y: 25, port_id: 0}, start_addr: 32'hf2000000, end_addr: 32'hf4000000},// L2_25_sam_idx
'{idx: '{x: 0, y: 24, port_id: 0}, start_addr: 32'hf0000000, end_addr: 32'hf2000000},// L2_24_sam_idx
'{idx: '{x: 0, y: 23, port_id: 0}, start_addr: 32'hee000000, end_addr: 32'hf0000000},// L2_23_sam_idx
'{idx: '{x: 0, y: 22, port_id: 0}, start_addr: 32'hec000000, end_addr: 32'hee000000},// L2_22_sam_idx
'{idx: '{x: 0, y: 21, port_id: 0}, start_addr: 32'hea000000, end_addr: 32'hec000000},// L2_21_sam_idx
'{idx: '{x: 0, y: 20, port_id: 0}, start_addr: 32'he8000000, end_addr: 32'hea000000},// L2_20_sam_idx
'{idx: '{x: 0, y: 19, port_id: 0}, start_addr: 32'he6000000, end_addr: 32'he8000000},// L2_19_sam_idx
'{idx: '{x: 0, y: 18, port_id: 0}, start_addr: 32'he4000000, end_addr: 32'he6000000},// L2_18_sam_idx
'{idx: '{x: 0, y: 17, port_id: 0}, start_addr: 32'he2000000, end_addr: 32'he4000000},// L2_17_sam_idx
'{idx: '{x: 0, y: 16, port_id: 0}, start_addr: 32'he0000000, end_addr: 32'he2000000},// L2_16_sam_idx
'{idx: '{x: 0, y: 15, port_id: 0}, start_addr: 32'hde000000, end_addr: 32'he0000000},// L2_15_sam_idx
'{idx: '{x: 0, y: 14, port_id: 0}, start_addr: 32'hdc000000, end_addr: 32'hde000000},// L2_14_sam_idx
'{idx: '{x: 0, y: 13, port_id: 0}, start_addr: 32'hda000000, end_addr: 32'hdc000000},// L2_13_sam_idx
'{idx: '{x: 0, y: 12, port_id: 0}, start_addr: 32'hd8000000, end_addr: 32'hda000000},// L2_12_sam_idx
'{idx: '{x: 0, y: 11, port_id: 0}, start_addr: 32'hd6000000, end_addr: 32'hd8000000},// L2_11_sam_idx
'{idx: '{x: 0, y: 10, port_id: 0}, start_addr: 32'hd4000000, end_addr: 32'hd6000000},// L2_10_sam_idx
'{idx: '{x: 0, y: 9, port_id: 0}, start_addr: 32'hd2000000, end_addr: 32'hd4000000},// L2_9_sam_idx
'{idx: '{x: 0, y: 8, port_id: 0}, start_addr: 32'hd0000000, end_addr: 32'hd2000000},// L2_8_sam_idx
'{idx: '{x: 0, y: 7, port_id: 0}, start_addr: 32'hce000000, end_addr: 32'hd0000000},// L2_7_sam_idx
'{idx: '{x: 0, y: 6, port_id: 0}, start_addr: 32'hcc000000, end_addr: 32'hce000000},// L2_6_sam_idx
'{idx: '{x: 0, y: 5, port_id: 0}, start_addr: 32'hca000000, end_addr: 32'hcc000000},// L2_5_sam_idx
'{idx: '{x: 0, y: 4, port_id: 0}, start_addr: 32'hc8000000, end_addr: 32'hca000000},// L2_4_sam_idx
'{idx: '{x: 0, y: 3, port_id: 0}, start_addr: 32'hc6000000, end_addr: 32'hc8000000},// L2_3_sam_idx
'{idx: '{x: 0, y: 2, port_id: 0}, start_addr: 32'hc4000000, end_addr: 32'hc6000000},// L2_2_sam_idx
'{idx: '{x: 0, y: 1, port_id: 0}, start_addr: 32'hc2000000, end_addr: 32'hc4000000},// L2_1_sam_idx
'{idx: '{x: 0, y: 0, port_id: 0}, start_addr: 32'hc0000000, end_addr: 32'hc2000000},// L2_0_sam_idx
'{idx: '{x: 32, y: 31, port_id: 0}, start_addr: 32'h3ff00000, end_addr: 32'h40000000},// magia_tile_x31_y31_sam_idx
'{idx: '{x: 31, y: 31, port_id: 0}, start_addr: 32'h3fe00000, end_addr: 32'h3ff00000},// magia_tile_x30_y31_sam_idx
'{idx: '{x: 30, y: 31, port_id: 0}, start_addr: 32'h3fd00000, end_addr: 32'h3fe00000},// magia_tile_x29_y31_sam_idx
'{idx: '{x: 29, y: 31, port_id: 0}, start_addr: 32'h3fc00000, end_addr: 32'h3fd00000},// magia_tile_x28_y31_sam_idx
'{idx: '{x: 28, y: 31, port_id: 0}, start_addr: 32'h3fb00000, end_addr: 32'h3fc00000},// magia_tile_x27_y31_sam_idx
'{idx: '{x: 27, y: 31, port_id: 0}, start_addr: 32'h3fa00000, end_addr: 32'h3fb00000},// magia_tile_x26_y31_sam_idx
'{idx: '{x: 26, y: 31, port_id: 0}, start_addr: 32'h3f900000, end_addr: 32'h3fa00000},// magia_tile_x25_y31_sam_idx
'{idx: '{x: 25, y: 31, port_id: 0}, start_addr: 32'h3f800000, end_addr: 32'h3f900000},// magia_tile_x24_y31_sam_idx
'{idx: '{x: 24, y: 31, port_id: 0}, start_addr: 32'h3f700000, end_addr: 32'h3f800000},// magia_tile_x23_y31_sam_idx
'{idx: '{x: 23, y: 31, port_id: 0}, start_addr: 32'h3f600000, end_addr: 32'h3f700000},// magia_tile_x22_y31_sam_idx
'{idx: '{x: 22, y: 31, port_id: 0}, start_addr: 32'h3f500000, end_addr: 32'h3f600000},// magia_tile_x21_y31_sam_idx
'{idx: '{x: 21, y: 31, port_id: 0}, start_addr: 32'h3f400000, end_addr: 32'h3f500000},// magia_tile_x20_y31_sam_idx
'{idx: '{x: 20, y: 31, port_id: 0}, start_addr: 32'h3f300000, end_addr: 32'h3f400000},// magia_tile_x19_y31_sam_idx
'{idx: '{x: 19, y: 31, port_id: 0}, start_addr: 32'h3f200000, end_addr: 32'h3f300000},// magia_tile_x18_y31_sam_idx
'{idx: '{x: 18, y: 31, port_id: 0}, start_addr: 32'h3f100000, end_addr: 32'h3f200000},// magia_tile_x17_y31_sam_idx
'{idx: '{x: 17, y: 31, port_id: 0}, start_addr: 32'h3f000000, end_addr: 32'h3f100000},// magia_tile_x16_y31_sam_idx
'{idx: '{x: 16, y: 31, port_id: 0}, start_addr: 32'h3ef00000, end_addr: 32'h3f000000},// magia_tile_x15_y31_sam_idx
'{idx: '{x: 15, y: 31, port_id: 0}, start_addr: 32'h3ee00000, end_addr: 32'h3ef00000},// magia_tile_x14_y31_sam_idx
'{idx: '{x: 14, y: 31, port_id: 0}, start_addr: 32'h3ed00000, end_addr: 32'h3ee00000},// magia_tile_x13_y31_sam_idx
'{idx: '{x: 13, y: 31, port_id: 0}, start_addr: 32'h3ec00000, end_addr: 32'h3ed00000},// magia_tile_x12_y31_sam_idx
'{idx: '{x: 12, y: 31, port_id: 0}, start_addr: 32'h3eb00000, end_addr: 32'h3ec00000},// magia_tile_x11_y31_sam_idx
'{idx: '{x: 11, y: 31, port_id: 0}, start_addr: 32'h3ea00000, end_addr: 32'h3eb00000},// magia_tile_x10_y31_sam_idx
'{idx: '{x: 10, y: 31, port_id: 0}, start_addr: 32'h3e900000, end_addr: 32'h3ea00000},// magia_tile_x9_y31_sam_idx
'{idx: '{x: 9, y: 31, port_id: 0}, start_addr: 32'h3e800000, end_addr: 32'h3e900000},// magia_tile_x8_y31_sam_idx
'{idx: '{x: 8, y: 31, port_id: 0}, start_addr: 32'h3e700000, end_addr: 32'h3e800000},// magia_tile_x7_y31_sam_idx
'{idx: '{x: 7, y: 31, port_id: 0}, start_addr: 32'h3e600000, end_addr: 32'h3e700000},// magia_tile_x6_y31_sam_idx
'{idx: '{x: 6, y: 31, port_id: 0}, start_addr: 32'h3e500000, end_addr: 32'h3e600000},// magia_tile_x5_y31_sam_idx
'{idx: '{x: 5, y: 31, port_id: 0}, start_addr: 32'h3e400000, end_addr: 32'h3e500000},// magia_tile_x4_y31_sam_idx
'{idx: '{x: 4, y: 31, port_id: 0}, start_addr: 32'h3e300000, end_addr: 32'h3e400000},// magia_tile_x3_y31_sam_idx
'{idx: '{x: 3, y: 31, port_id: 0}, start_addr: 32'h3e200000, end_addr: 32'h3e300000},// magia_tile_x2_y31_sam_idx
'{idx: '{x: 2, y: 31, port_id: 0}, start_addr: 32'h3e100000, end_addr: 32'h3e200000},// magia_tile_x1_y31_sam_idx
'{idx: '{x: 1, y: 31, port_id: 0}, start_addr: 32'h3e000000, end_addr: 32'h3e100000},// magia_tile_x0_y31_sam_idx
'{idx: '{x: 32, y: 30, port_id: 0}, start_addr: 32'h3df00000, end_addr: 32'h3e000000},// magia_tile_x31_y30_sam_idx
'{idx: '{x: 31, y: 30, port_id: 0}, start_addr: 32'h3de00000, end_addr: 32'h3df00000},// magia_tile_x30_y30_sam_idx
'{idx: '{x: 30, y: 30, port_id: 0}, start_addr: 32'h3dd00000, end_addr: 32'h3de00000},// magia_tile_x29_y30_sam_idx
'{idx: '{x: 29, y: 30, port_id: 0}, start_addr: 32'h3dc00000, end_addr: 32'h3dd00000},// magia_tile_x28_y30_sam_idx
'{idx: '{x: 28, y: 30, port_id: 0}, start_addr: 32'h3db00000, end_addr: 32'h3dc00000},// magia_tile_x27_y30_sam_idx
'{idx: '{x: 27, y: 30, port_id: 0}, start_addr: 32'h3da00000, end_addr: 32'h3db00000},// magia_tile_x26_y30_sam_idx
'{idx: '{x: 26, y: 30, port_id: 0}, start_addr: 32'h3d900000, end_addr: 32'h3da00000},// magia_tile_x25_y30_sam_idx
'{idx: '{x: 25, y: 30, port_id: 0}, start_addr: 32'h3d800000, end_addr: 32'h3d900000},// magia_tile_x24_y30_sam_idx
'{idx: '{x: 24, y: 30, port_id: 0}, start_addr: 32'h3d700000, end_addr: 32'h3d800000},// magia_tile_x23_y30_sam_idx
'{idx: '{x: 23, y: 30, port_id: 0}, start_addr: 32'h3d600000, end_addr: 32'h3d700000},// magia_tile_x22_y30_sam_idx
'{idx: '{x: 22, y: 30, port_id: 0}, start_addr: 32'h3d500000, end_addr: 32'h3d600000},// magia_tile_x21_y30_sam_idx
'{idx: '{x: 21, y: 30, port_id: 0}, start_addr: 32'h3d400000, end_addr: 32'h3d500000},// magia_tile_x20_y30_sam_idx
'{idx: '{x: 20, y: 30, port_id: 0}, start_addr: 32'h3d300000, end_addr: 32'h3d400000},// magia_tile_x19_y30_sam_idx
'{idx: '{x: 19, y: 30, port_id: 0}, start_addr: 32'h3d200000, end_addr: 32'h3d300000},// magia_tile_x18_y30_sam_idx
'{idx: '{x: 18, y: 30, port_id: 0}, start_addr: 32'h3d100000, end_addr: 32'h3d200000},// magia_tile_x17_y30_sam_idx
'{idx: '{x: 17, y: 30, port_id: 0}, start_addr: 32'h3d000000, end_addr: 32'h3d100000},// magia_tile_x16_y30_sam_idx
'{idx: '{x: 16, y: 30, port_id: 0}, start_addr: 32'h3cf00000, end_addr: 32'h3d000000},// magia_tile_x15_y30_sam_idx
'{idx: '{x: 15, y: 30, port_id: 0}, start_addr: 32'h3ce00000, end_addr: 32'h3cf00000},// magia_tile_x14_y30_sam_idx
'{idx: '{x: 14, y: 30, port_id: 0}, start_addr: 32'h3cd00000, end_addr: 32'h3ce00000},// magia_tile_x13_y30_sam_idx
'{idx: '{x: 13, y: 30, port_id: 0}, start_addr: 32'h3cc00000, end_addr: 32'h3cd00000},// magia_tile_x12_y30_sam_idx
'{idx: '{x: 12, y: 30, port_id: 0}, start_addr: 32'h3cb00000, end_addr: 32'h3cc00000},// magia_tile_x11_y30_sam_idx
'{idx: '{x: 11, y: 30, port_id: 0}, start_addr: 32'h3ca00000, end_addr: 32'h3cb00000},// magia_tile_x10_y30_sam_idx
'{idx: '{x: 10, y: 30, port_id: 0}, start_addr: 32'h3c900000, end_addr: 32'h3ca00000},// magia_tile_x9_y30_sam_idx
'{idx: '{x: 9, y: 30, port_id: 0}, start_addr: 32'h3c800000, end_addr: 32'h3c900000},// magia_tile_x8_y30_sam_idx
'{idx: '{x: 8, y: 30, port_id: 0}, start_addr: 32'h3c700000, end_addr: 32'h3c800000},// magia_tile_x7_y30_sam_idx
'{idx: '{x: 7, y: 30, port_id: 0}, start_addr: 32'h3c600000, end_addr: 32'h3c700000},// magia_tile_x6_y30_sam_idx
'{idx: '{x: 6, y: 30, port_id: 0}, start_addr: 32'h3c500000, end_addr: 32'h3c600000},// magia_tile_x5_y30_sam_idx
'{idx: '{x: 5, y: 30, port_id: 0}, start_addr: 32'h3c400000, end_addr: 32'h3c500000},// magia_tile_x4_y30_sam_idx
'{idx: '{x: 4, y: 30, port_id: 0}, start_addr: 32'h3c300000, end_addr: 32'h3c400000},// magia_tile_x3_y30_sam_idx
'{idx: '{x: 3, y: 30, port_id: 0}, start_addr: 32'h3c200000, end_addr: 32'h3c300000},// magia_tile_x2_y30_sam_idx
'{idx: '{x: 2, y: 30, port_id: 0}, start_addr: 32'h3c100000, end_addr: 32'h3c200000},// magia_tile_x1_y30_sam_idx
'{idx: '{x: 1, y: 30, port_id: 0}, start_addr: 32'h3c000000, end_addr: 32'h3c100000},// magia_tile_x0_y30_sam_idx
'{idx: '{x: 32, y: 29, port_id: 0}, start_addr: 32'h3bf00000, end_addr: 32'h3c000000},// magia_tile_x31_y29_sam_idx
'{idx: '{x: 31, y: 29, port_id: 0}, start_addr: 32'h3be00000, end_addr: 32'h3bf00000},// magia_tile_x30_y29_sam_idx
'{idx: '{x: 30, y: 29, port_id: 0}, start_addr: 32'h3bd00000, end_addr: 32'h3be00000},// magia_tile_x29_y29_sam_idx
'{idx: '{x: 29, y: 29, port_id: 0}, start_addr: 32'h3bc00000, end_addr: 32'h3bd00000},// magia_tile_x28_y29_sam_idx
'{idx: '{x: 28, y: 29, port_id: 0}, start_addr: 32'h3bb00000, end_addr: 32'h3bc00000},// magia_tile_x27_y29_sam_idx
'{idx: '{x: 27, y: 29, port_id: 0}, start_addr: 32'h3ba00000, end_addr: 32'h3bb00000},// magia_tile_x26_y29_sam_idx
'{idx: '{x: 26, y: 29, port_id: 0}, start_addr: 32'h3b900000, end_addr: 32'h3ba00000},// magia_tile_x25_y29_sam_idx
'{idx: '{x: 25, y: 29, port_id: 0}, start_addr: 32'h3b800000, end_addr: 32'h3b900000},// magia_tile_x24_y29_sam_idx
'{idx: '{x: 24, y: 29, port_id: 0}, start_addr: 32'h3b700000, end_addr: 32'h3b800000},// magia_tile_x23_y29_sam_idx
'{idx: '{x: 23, y: 29, port_id: 0}, start_addr: 32'h3b600000, end_addr: 32'h3b700000},// magia_tile_x22_y29_sam_idx
'{idx: '{x: 22, y: 29, port_id: 0}, start_addr: 32'h3b500000, end_addr: 32'h3b600000},// magia_tile_x21_y29_sam_idx
'{idx: '{x: 21, y: 29, port_id: 0}, start_addr: 32'h3b400000, end_addr: 32'h3b500000},// magia_tile_x20_y29_sam_idx
'{idx: '{x: 20, y: 29, port_id: 0}, start_addr: 32'h3b300000, end_addr: 32'h3b400000},// magia_tile_x19_y29_sam_idx
'{idx: '{x: 19, y: 29, port_id: 0}, start_addr: 32'h3b200000, end_addr: 32'h3b300000},// magia_tile_x18_y29_sam_idx
'{idx: '{x: 18, y: 29, port_id: 0}, start_addr: 32'h3b100000, end_addr: 32'h3b200000},// magia_tile_x17_y29_sam_idx
'{idx: '{x: 17, y: 29, port_id: 0}, start_addr: 32'h3b000000, end_addr: 32'h3b100000},// magia_tile_x16_y29_sam_idx
'{idx: '{x: 16, y: 29, port_id: 0}, start_addr: 32'h3af00000, end_addr: 32'h3b000000},// magia_tile_x15_y29_sam_idx
'{idx: '{x: 15, y: 29, port_id: 0}, start_addr: 32'h3ae00000, end_addr: 32'h3af00000},// magia_tile_x14_y29_sam_idx
'{idx: '{x: 14, y: 29, port_id: 0}, start_addr: 32'h3ad00000, end_addr: 32'h3ae00000},// magia_tile_x13_y29_sam_idx
'{idx: '{x: 13, y: 29, port_id: 0}, start_addr: 32'h3ac00000, end_addr: 32'h3ad00000},// magia_tile_x12_y29_sam_idx
'{idx: '{x: 12, y: 29, port_id: 0}, start_addr: 32'h3ab00000, end_addr: 32'h3ac00000},// magia_tile_x11_y29_sam_idx
'{idx: '{x: 11, y: 29, port_id: 0}, start_addr: 32'h3aa00000, end_addr: 32'h3ab00000},// magia_tile_x10_y29_sam_idx
'{idx: '{x: 10, y: 29, port_id: 0}, start_addr: 32'h3a900000, end_addr: 32'h3aa00000},// magia_tile_x9_y29_sam_idx
'{idx: '{x: 9, y: 29, port_id: 0}, start_addr: 32'h3a800000, end_addr: 32'h3a900000},// magia_tile_x8_y29_sam_idx
'{idx: '{x: 8, y: 29, port_id: 0}, start_addr: 32'h3a700000, end_addr: 32'h3a800000},// magia_tile_x7_y29_sam_idx
'{idx: '{x: 7, y: 29, port_id: 0}, start_addr: 32'h3a600000, end_addr: 32'h3a700000},// magia_tile_x6_y29_sam_idx
'{idx: '{x: 6, y: 29, port_id: 0}, start_addr: 32'h3a500000, end_addr: 32'h3a600000},// magia_tile_x5_y29_sam_idx
'{idx: '{x: 5, y: 29, port_id: 0}, start_addr: 32'h3a400000, end_addr: 32'h3a500000},// magia_tile_x4_y29_sam_idx
'{idx: '{x: 4, y: 29, port_id: 0}, start_addr: 32'h3a300000, end_addr: 32'h3a400000},// magia_tile_x3_y29_sam_idx
'{idx: '{x: 3, y: 29, port_id: 0}, start_addr: 32'h3a200000, end_addr: 32'h3a300000},// magia_tile_x2_y29_sam_idx
'{idx: '{x: 2, y: 29, port_id: 0}, start_addr: 32'h3a100000, end_addr: 32'h3a200000},// magia_tile_x1_y29_sam_idx
'{idx: '{x: 1, y: 29, port_id: 0}, start_addr: 32'h3a000000, end_addr: 32'h3a100000},// magia_tile_x0_y29_sam_idx
'{idx: '{x: 32, y: 28, port_id: 0}, start_addr: 32'h39f00000, end_addr: 32'h3a000000},// magia_tile_x31_y28_sam_idx
'{idx: '{x: 31, y: 28, port_id: 0}, start_addr: 32'h39e00000, end_addr: 32'h39f00000},// magia_tile_x30_y28_sam_idx
'{idx: '{x: 30, y: 28, port_id: 0}, start_addr: 32'h39d00000, end_addr: 32'h39e00000},// magia_tile_x29_y28_sam_idx
'{idx: '{x: 29, y: 28, port_id: 0}, start_addr: 32'h39c00000, end_addr: 32'h39d00000},// magia_tile_x28_y28_sam_idx
'{idx: '{x: 28, y: 28, port_id: 0}, start_addr: 32'h39b00000, end_addr: 32'h39c00000},// magia_tile_x27_y28_sam_idx
'{idx: '{x: 27, y: 28, port_id: 0}, start_addr: 32'h39a00000, end_addr: 32'h39b00000},// magia_tile_x26_y28_sam_idx
'{idx: '{x: 26, y: 28, port_id: 0}, start_addr: 32'h39900000, end_addr: 32'h39a00000},// magia_tile_x25_y28_sam_idx
'{idx: '{x: 25, y: 28, port_id: 0}, start_addr: 32'h39800000, end_addr: 32'h39900000},// magia_tile_x24_y28_sam_idx
'{idx: '{x: 24, y: 28, port_id: 0}, start_addr: 32'h39700000, end_addr: 32'h39800000},// magia_tile_x23_y28_sam_idx
'{idx: '{x: 23, y: 28, port_id: 0}, start_addr: 32'h39600000, end_addr: 32'h39700000},// magia_tile_x22_y28_sam_idx
'{idx: '{x: 22, y: 28, port_id: 0}, start_addr: 32'h39500000, end_addr: 32'h39600000},// magia_tile_x21_y28_sam_idx
'{idx: '{x: 21, y: 28, port_id: 0}, start_addr: 32'h39400000, end_addr: 32'h39500000},// magia_tile_x20_y28_sam_idx
'{idx: '{x: 20, y: 28, port_id: 0}, start_addr: 32'h39300000, end_addr: 32'h39400000},// magia_tile_x19_y28_sam_idx
'{idx: '{x: 19, y: 28, port_id: 0}, start_addr: 32'h39200000, end_addr: 32'h39300000},// magia_tile_x18_y28_sam_idx
'{idx: '{x: 18, y: 28, port_id: 0}, start_addr: 32'h39100000, end_addr: 32'h39200000},// magia_tile_x17_y28_sam_idx
'{idx: '{x: 17, y: 28, port_id: 0}, start_addr: 32'h39000000, end_addr: 32'h39100000},// magia_tile_x16_y28_sam_idx
'{idx: '{x: 16, y: 28, port_id: 0}, start_addr: 32'h38f00000, end_addr: 32'h39000000},// magia_tile_x15_y28_sam_idx
'{idx: '{x: 15, y: 28, port_id: 0}, start_addr: 32'h38e00000, end_addr: 32'h38f00000},// magia_tile_x14_y28_sam_idx
'{idx: '{x: 14, y: 28, port_id: 0}, start_addr: 32'h38d00000, end_addr: 32'h38e00000},// magia_tile_x13_y28_sam_idx
'{idx: '{x: 13, y: 28, port_id: 0}, start_addr: 32'h38c00000, end_addr: 32'h38d00000},// magia_tile_x12_y28_sam_idx
'{idx: '{x: 12, y: 28, port_id: 0}, start_addr: 32'h38b00000, end_addr: 32'h38c00000},// magia_tile_x11_y28_sam_idx
'{idx: '{x: 11, y: 28, port_id: 0}, start_addr: 32'h38a00000, end_addr: 32'h38b00000},// magia_tile_x10_y28_sam_idx
'{idx: '{x: 10, y: 28, port_id: 0}, start_addr: 32'h38900000, end_addr: 32'h38a00000},// magia_tile_x9_y28_sam_idx
'{idx: '{x: 9, y: 28, port_id: 0}, start_addr: 32'h38800000, end_addr: 32'h38900000},// magia_tile_x8_y28_sam_idx
'{idx: '{x: 8, y: 28, port_id: 0}, start_addr: 32'h38700000, end_addr: 32'h38800000},// magia_tile_x7_y28_sam_idx
'{idx: '{x: 7, y: 28, port_id: 0}, start_addr: 32'h38600000, end_addr: 32'h38700000},// magia_tile_x6_y28_sam_idx
'{idx: '{x: 6, y: 28, port_id: 0}, start_addr: 32'h38500000, end_addr: 32'h38600000},// magia_tile_x5_y28_sam_idx
'{idx: '{x: 5, y: 28, port_id: 0}, start_addr: 32'h38400000, end_addr: 32'h38500000},// magia_tile_x4_y28_sam_idx
'{idx: '{x: 4, y: 28, port_id: 0}, start_addr: 32'h38300000, end_addr: 32'h38400000},// magia_tile_x3_y28_sam_idx
'{idx: '{x: 3, y: 28, port_id: 0}, start_addr: 32'h38200000, end_addr: 32'h38300000},// magia_tile_x2_y28_sam_idx
'{idx: '{x: 2, y: 28, port_id: 0}, start_addr: 32'h38100000, end_addr: 32'h38200000},// magia_tile_x1_y28_sam_idx
'{idx: '{x: 1, y: 28, port_id: 0}, start_addr: 32'h38000000, end_addr: 32'h38100000},// magia_tile_x0_y28_sam_idx
'{idx: '{x: 32, y: 27, port_id: 0}, start_addr: 32'h37f00000, end_addr: 32'h38000000},// magia_tile_x31_y27_sam_idx
'{idx: '{x: 31, y: 27, port_id: 0}, start_addr: 32'h37e00000, end_addr: 32'h37f00000},// magia_tile_x30_y27_sam_idx
'{idx: '{x: 30, y: 27, port_id: 0}, start_addr: 32'h37d00000, end_addr: 32'h37e00000},// magia_tile_x29_y27_sam_idx
'{idx: '{x: 29, y: 27, port_id: 0}, start_addr: 32'h37c00000, end_addr: 32'h37d00000},// magia_tile_x28_y27_sam_idx
'{idx: '{x: 28, y: 27, port_id: 0}, start_addr: 32'h37b00000, end_addr: 32'h37c00000},// magia_tile_x27_y27_sam_idx
'{idx: '{x: 27, y: 27, port_id: 0}, start_addr: 32'h37a00000, end_addr: 32'h37b00000},// magia_tile_x26_y27_sam_idx
'{idx: '{x: 26, y: 27, port_id: 0}, start_addr: 32'h37900000, end_addr: 32'h37a00000},// magia_tile_x25_y27_sam_idx
'{idx: '{x: 25, y: 27, port_id: 0}, start_addr: 32'h37800000, end_addr: 32'h37900000},// magia_tile_x24_y27_sam_idx
'{idx: '{x: 24, y: 27, port_id: 0}, start_addr: 32'h37700000, end_addr: 32'h37800000},// magia_tile_x23_y27_sam_idx
'{idx: '{x: 23, y: 27, port_id: 0}, start_addr: 32'h37600000, end_addr: 32'h37700000},// magia_tile_x22_y27_sam_idx
'{idx: '{x: 22, y: 27, port_id: 0}, start_addr: 32'h37500000, end_addr: 32'h37600000},// magia_tile_x21_y27_sam_idx
'{idx: '{x: 21, y: 27, port_id: 0}, start_addr: 32'h37400000, end_addr: 32'h37500000},// magia_tile_x20_y27_sam_idx
'{idx: '{x: 20, y: 27, port_id: 0}, start_addr: 32'h37300000, end_addr: 32'h37400000},// magia_tile_x19_y27_sam_idx
'{idx: '{x: 19, y: 27, port_id: 0}, start_addr: 32'h37200000, end_addr: 32'h37300000},// magia_tile_x18_y27_sam_idx
'{idx: '{x: 18, y: 27, port_id: 0}, start_addr: 32'h37100000, end_addr: 32'h37200000},// magia_tile_x17_y27_sam_idx
'{idx: '{x: 17, y: 27, port_id: 0}, start_addr: 32'h37000000, end_addr: 32'h37100000},// magia_tile_x16_y27_sam_idx
'{idx: '{x: 16, y: 27, port_id: 0}, start_addr: 32'h36f00000, end_addr: 32'h37000000},// magia_tile_x15_y27_sam_idx
'{idx: '{x: 15, y: 27, port_id: 0}, start_addr: 32'h36e00000, end_addr: 32'h36f00000},// magia_tile_x14_y27_sam_idx
'{idx: '{x: 14, y: 27, port_id: 0}, start_addr: 32'h36d00000, end_addr: 32'h36e00000},// magia_tile_x13_y27_sam_idx
'{idx: '{x: 13, y: 27, port_id: 0}, start_addr: 32'h36c00000, end_addr: 32'h36d00000},// magia_tile_x12_y27_sam_idx
'{idx: '{x: 12, y: 27, port_id: 0}, start_addr: 32'h36b00000, end_addr: 32'h36c00000},// magia_tile_x11_y27_sam_idx
'{idx: '{x: 11, y: 27, port_id: 0}, start_addr: 32'h36a00000, end_addr: 32'h36b00000},// magia_tile_x10_y27_sam_idx
'{idx: '{x: 10, y: 27, port_id: 0}, start_addr: 32'h36900000, end_addr: 32'h36a00000},// magia_tile_x9_y27_sam_idx
'{idx: '{x: 9, y: 27, port_id: 0}, start_addr: 32'h36800000, end_addr: 32'h36900000},// magia_tile_x8_y27_sam_idx
'{idx: '{x: 8, y: 27, port_id: 0}, start_addr: 32'h36700000, end_addr: 32'h36800000},// magia_tile_x7_y27_sam_idx
'{idx: '{x: 7, y: 27, port_id: 0}, start_addr: 32'h36600000, end_addr: 32'h36700000},// magia_tile_x6_y27_sam_idx
'{idx: '{x: 6, y: 27, port_id: 0}, start_addr: 32'h36500000, end_addr: 32'h36600000},// magia_tile_x5_y27_sam_idx
'{idx: '{x: 5, y: 27, port_id: 0}, start_addr: 32'h36400000, end_addr: 32'h36500000},// magia_tile_x4_y27_sam_idx
'{idx: '{x: 4, y: 27, port_id: 0}, start_addr: 32'h36300000, end_addr: 32'h36400000},// magia_tile_x3_y27_sam_idx
'{idx: '{x: 3, y: 27, port_id: 0}, start_addr: 32'h36200000, end_addr: 32'h36300000},// magia_tile_x2_y27_sam_idx
'{idx: '{x: 2, y: 27, port_id: 0}, start_addr: 32'h36100000, end_addr: 32'h36200000},// magia_tile_x1_y27_sam_idx
'{idx: '{x: 1, y: 27, port_id: 0}, start_addr: 32'h36000000, end_addr: 32'h36100000},// magia_tile_x0_y27_sam_idx
'{idx: '{x: 32, y: 26, port_id: 0}, start_addr: 32'h35f00000, end_addr: 32'h36000000},// magia_tile_x31_y26_sam_idx
'{idx: '{x: 31, y: 26, port_id: 0}, start_addr: 32'h35e00000, end_addr: 32'h35f00000},// magia_tile_x30_y26_sam_idx
'{idx: '{x: 30, y: 26, port_id: 0}, start_addr: 32'h35d00000, end_addr: 32'h35e00000},// magia_tile_x29_y26_sam_idx
'{idx: '{x: 29, y: 26, port_id: 0}, start_addr: 32'h35c00000, end_addr: 32'h35d00000},// magia_tile_x28_y26_sam_idx
'{idx: '{x: 28, y: 26, port_id: 0}, start_addr: 32'h35b00000, end_addr: 32'h35c00000},// magia_tile_x27_y26_sam_idx
'{idx: '{x: 27, y: 26, port_id: 0}, start_addr: 32'h35a00000, end_addr: 32'h35b00000},// magia_tile_x26_y26_sam_idx
'{idx: '{x: 26, y: 26, port_id: 0}, start_addr: 32'h35900000, end_addr: 32'h35a00000},// magia_tile_x25_y26_sam_idx
'{idx: '{x: 25, y: 26, port_id: 0}, start_addr: 32'h35800000, end_addr: 32'h35900000},// magia_tile_x24_y26_sam_idx
'{idx: '{x: 24, y: 26, port_id: 0}, start_addr: 32'h35700000, end_addr: 32'h35800000},// magia_tile_x23_y26_sam_idx
'{idx: '{x: 23, y: 26, port_id: 0}, start_addr: 32'h35600000, end_addr: 32'h35700000},// magia_tile_x22_y26_sam_idx
'{idx: '{x: 22, y: 26, port_id: 0}, start_addr: 32'h35500000, end_addr: 32'h35600000},// magia_tile_x21_y26_sam_idx
'{idx: '{x: 21, y: 26, port_id: 0}, start_addr: 32'h35400000, end_addr: 32'h35500000},// magia_tile_x20_y26_sam_idx
'{idx: '{x: 20, y: 26, port_id: 0}, start_addr: 32'h35300000, end_addr: 32'h35400000},// magia_tile_x19_y26_sam_idx
'{idx: '{x: 19, y: 26, port_id: 0}, start_addr: 32'h35200000, end_addr: 32'h35300000},// magia_tile_x18_y26_sam_idx
'{idx: '{x: 18, y: 26, port_id: 0}, start_addr: 32'h35100000, end_addr: 32'h35200000},// magia_tile_x17_y26_sam_idx
'{idx: '{x: 17, y: 26, port_id: 0}, start_addr: 32'h35000000, end_addr: 32'h35100000},// magia_tile_x16_y26_sam_idx
'{idx: '{x: 16, y: 26, port_id: 0}, start_addr: 32'h34f00000, end_addr: 32'h35000000},// magia_tile_x15_y26_sam_idx
'{idx: '{x: 15, y: 26, port_id: 0}, start_addr: 32'h34e00000, end_addr: 32'h34f00000},// magia_tile_x14_y26_sam_idx
'{idx: '{x: 14, y: 26, port_id: 0}, start_addr: 32'h34d00000, end_addr: 32'h34e00000},// magia_tile_x13_y26_sam_idx
'{idx: '{x: 13, y: 26, port_id: 0}, start_addr: 32'h34c00000, end_addr: 32'h34d00000},// magia_tile_x12_y26_sam_idx
'{idx: '{x: 12, y: 26, port_id: 0}, start_addr: 32'h34b00000, end_addr: 32'h34c00000},// magia_tile_x11_y26_sam_idx
'{idx: '{x: 11, y: 26, port_id: 0}, start_addr: 32'h34a00000, end_addr: 32'h34b00000},// magia_tile_x10_y26_sam_idx
'{idx: '{x: 10, y: 26, port_id: 0}, start_addr: 32'h34900000, end_addr: 32'h34a00000},// magia_tile_x9_y26_sam_idx
'{idx: '{x: 9, y: 26, port_id: 0}, start_addr: 32'h34800000, end_addr: 32'h34900000},// magia_tile_x8_y26_sam_idx
'{idx: '{x: 8, y: 26, port_id: 0}, start_addr: 32'h34700000, end_addr: 32'h34800000},// magia_tile_x7_y26_sam_idx
'{idx: '{x: 7, y: 26, port_id: 0}, start_addr: 32'h34600000, end_addr: 32'h34700000},// magia_tile_x6_y26_sam_idx
'{idx: '{x: 6, y: 26, port_id: 0}, start_addr: 32'h34500000, end_addr: 32'h34600000},// magia_tile_x5_y26_sam_idx
'{idx: '{x: 5, y: 26, port_id: 0}, start_addr: 32'h34400000, end_addr: 32'h34500000},// magia_tile_x4_y26_sam_idx
'{idx: '{x: 4, y: 26, port_id: 0}, start_addr: 32'h34300000, end_addr: 32'h34400000},// magia_tile_x3_y26_sam_idx
'{idx: '{x: 3, y: 26, port_id: 0}, start_addr: 32'h34200000, end_addr: 32'h34300000},// magia_tile_x2_y26_sam_idx
'{idx: '{x: 2, y: 26, port_id: 0}, start_addr: 32'h34100000, end_addr: 32'h34200000},// magia_tile_x1_y26_sam_idx
'{idx: '{x: 1, y: 26, port_id: 0}, start_addr: 32'h34000000, end_addr: 32'h34100000},// magia_tile_x0_y26_sam_idx
'{idx: '{x: 32, y: 25, port_id: 0}, start_addr: 32'h33f00000, end_addr: 32'h34000000},// magia_tile_x31_y25_sam_idx
'{idx: '{x: 31, y: 25, port_id: 0}, start_addr: 32'h33e00000, end_addr: 32'h33f00000},// magia_tile_x30_y25_sam_idx
'{idx: '{x: 30, y: 25, port_id: 0}, start_addr: 32'h33d00000, end_addr: 32'h33e00000},// magia_tile_x29_y25_sam_idx
'{idx: '{x: 29, y: 25, port_id: 0}, start_addr: 32'h33c00000, end_addr: 32'h33d00000},// magia_tile_x28_y25_sam_idx
'{idx: '{x: 28, y: 25, port_id: 0}, start_addr: 32'h33b00000, end_addr: 32'h33c00000},// magia_tile_x27_y25_sam_idx
'{idx: '{x: 27, y: 25, port_id: 0}, start_addr: 32'h33a00000, end_addr: 32'h33b00000},// magia_tile_x26_y25_sam_idx
'{idx: '{x: 26, y: 25, port_id: 0}, start_addr: 32'h33900000, end_addr: 32'h33a00000},// magia_tile_x25_y25_sam_idx
'{idx: '{x: 25, y: 25, port_id: 0}, start_addr: 32'h33800000, end_addr: 32'h33900000},// magia_tile_x24_y25_sam_idx
'{idx: '{x: 24, y: 25, port_id: 0}, start_addr: 32'h33700000, end_addr: 32'h33800000},// magia_tile_x23_y25_sam_idx
'{idx: '{x: 23, y: 25, port_id: 0}, start_addr: 32'h33600000, end_addr: 32'h33700000},// magia_tile_x22_y25_sam_idx
'{idx: '{x: 22, y: 25, port_id: 0}, start_addr: 32'h33500000, end_addr: 32'h33600000},// magia_tile_x21_y25_sam_idx
'{idx: '{x: 21, y: 25, port_id: 0}, start_addr: 32'h33400000, end_addr: 32'h33500000},// magia_tile_x20_y25_sam_idx
'{idx: '{x: 20, y: 25, port_id: 0}, start_addr: 32'h33300000, end_addr: 32'h33400000},// magia_tile_x19_y25_sam_idx
'{idx: '{x: 19, y: 25, port_id: 0}, start_addr: 32'h33200000, end_addr: 32'h33300000},// magia_tile_x18_y25_sam_idx
'{idx: '{x: 18, y: 25, port_id: 0}, start_addr: 32'h33100000, end_addr: 32'h33200000},// magia_tile_x17_y25_sam_idx
'{idx: '{x: 17, y: 25, port_id: 0}, start_addr: 32'h33000000, end_addr: 32'h33100000},// magia_tile_x16_y25_sam_idx
'{idx: '{x: 16, y: 25, port_id: 0}, start_addr: 32'h32f00000, end_addr: 32'h33000000},// magia_tile_x15_y25_sam_idx
'{idx: '{x: 15, y: 25, port_id: 0}, start_addr: 32'h32e00000, end_addr: 32'h32f00000},// magia_tile_x14_y25_sam_idx
'{idx: '{x: 14, y: 25, port_id: 0}, start_addr: 32'h32d00000, end_addr: 32'h32e00000},// magia_tile_x13_y25_sam_idx
'{idx: '{x: 13, y: 25, port_id: 0}, start_addr: 32'h32c00000, end_addr: 32'h32d00000},// magia_tile_x12_y25_sam_idx
'{idx: '{x: 12, y: 25, port_id: 0}, start_addr: 32'h32b00000, end_addr: 32'h32c00000},// magia_tile_x11_y25_sam_idx
'{idx: '{x: 11, y: 25, port_id: 0}, start_addr: 32'h32a00000, end_addr: 32'h32b00000},// magia_tile_x10_y25_sam_idx
'{idx: '{x: 10, y: 25, port_id: 0}, start_addr: 32'h32900000, end_addr: 32'h32a00000},// magia_tile_x9_y25_sam_idx
'{idx: '{x: 9, y: 25, port_id: 0}, start_addr: 32'h32800000, end_addr: 32'h32900000},// magia_tile_x8_y25_sam_idx
'{idx: '{x: 8, y: 25, port_id: 0}, start_addr: 32'h32700000, end_addr: 32'h32800000},// magia_tile_x7_y25_sam_idx
'{idx: '{x: 7, y: 25, port_id: 0}, start_addr: 32'h32600000, end_addr: 32'h32700000},// magia_tile_x6_y25_sam_idx
'{idx: '{x: 6, y: 25, port_id: 0}, start_addr: 32'h32500000, end_addr: 32'h32600000},// magia_tile_x5_y25_sam_idx
'{idx: '{x: 5, y: 25, port_id: 0}, start_addr: 32'h32400000, end_addr: 32'h32500000},// magia_tile_x4_y25_sam_idx
'{idx: '{x: 4, y: 25, port_id: 0}, start_addr: 32'h32300000, end_addr: 32'h32400000},// magia_tile_x3_y25_sam_idx
'{idx: '{x: 3, y: 25, port_id: 0}, start_addr: 32'h32200000, end_addr: 32'h32300000},// magia_tile_x2_y25_sam_idx
'{idx: '{x: 2, y: 25, port_id: 0}, start_addr: 32'h32100000, end_addr: 32'h32200000},// magia_tile_x1_y25_sam_idx
'{idx: '{x: 1, y: 25, port_id: 0}, start_addr: 32'h32000000, end_addr: 32'h32100000},// magia_tile_x0_y25_sam_idx
'{idx: '{x: 32, y: 24, port_id: 0}, start_addr: 32'h31f00000, end_addr: 32'h32000000},// magia_tile_x31_y24_sam_idx
'{idx: '{x: 31, y: 24, port_id: 0}, start_addr: 32'h31e00000, end_addr: 32'h31f00000},// magia_tile_x30_y24_sam_idx
'{idx: '{x: 30, y: 24, port_id: 0}, start_addr: 32'h31d00000, end_addr: 32'h31e00000},// magia_tile_x29_y24_sam_idx
'{idx: '{x: 29, y: 24, port_id: 0}, start_addr: 32'h31c00000, end_addr: 32'h31d00000},// magia_tile_x28_y24_sam_idx
'{idx: '{x: 28, y: 24, port_id: 0}, start_addr: 32'h31b00000, end_addr: 32'h31c00000},// magia_tile_x27_y24_sam_idx
'{idx: '{x: 27, y: 24, port_id: 0}, start_addr: 32'h31a00000, end_addr: 32'h31b00000},// magia_tile_x26_y24_sam_idx
'{idx: '{x: 26, y: 24, port_id: 0}, start_addr: 32'h31900000, end_addr: 32'h31a00000},// magia_tile_x25_y24_sam_idx
'{idx: '{x: 25, y: 24, port_id: 0}, start_addr: 32'h31800000, end_addr: 32'h31900000},// magia_tile_x24_y24_sam_idx
'{idx: '{x: 24, y: 24, port_id: 0}, start_addr: 32'h31700000, end_addr: 32'h31800000},// magia_tile_x23_y24_sam_idx
'{idx: '{x: 23, y: 24, port_id: 0}, start_addr: 32'h31600000, end_addr: 32'h31700000},// magia_tile_x22_y24_sam_idx
'{idx: '{x: 22, y: 24, port_id: 0}, start_addr: 32'h31500000, end_addr: 32'h31600000},// magia_tile_x21_y24_sam_idx
'{idx: '{x: 21, y: 24, port_id: 0}, start_addr: 32'h31400000, end_addr: 32'h31500000},// magia_tile_x20_y24_sam_idx
'{idx: '{x: 20, y: 24, port_id: 0}, start_addr: 32'h31300000, end_addr: 32'h31400000},// magia_tile_x19_y24_sam_idx
'{idx: '{x: 19, y: 24, port_id: 0}, start_addr: 32'h31200000, end_addr: 32'h31300000},// magia_tile_x18_y24_sam_idx
'{idx: '{x: 18, y: 24, port_id: 0}, start_addr: 32'h31100000, end_addr: 32'h31200000},// magia_tile_x17_y24_sam_idx
'{idx: '{x: 17, y: 24, port_id: 0}, start_addr: 32'h31000000, end_addr: 32'h31100000},// magia_tile_x16_y24_sam_idx
'{idx: '{x: 16, y: 24, port_id: 0}, start_addr: 32'h30f00000, end_addr: 32'h31000000},// magia_tile_x15_y24_sam_idx
'{idx: '{x: 15, y: 24, port_id: 0}, start_addr: 32'h30e00000, end_addr: 32'h30f00000},// magia_tile_x14_y24_sam_idx
'{idx: '{x: 14, y: 24, port_id: 0}, start_addr: 32'h30d00000, end_addr: 32'h30e00000},// magia_tile_x13_y24_sam_idx
'{idx: '{x: 13, y: 24, port_id: 0}, start_addr: 32'h30c00000, end_addr: 32'h30d00000},// magia_tile_x12_y24_sam_idx
'{idx: '{x: 12, y: 24, port_id: 0}, start_addr: 32'h30b00000, end_addr: 32'h30c00000},// magia_tile_x11_y24_sam_idx
'{idx: '{x: 11, y: 24, port_id: 0}, start_addr: 32'h30a00000, end_addr: 32'h30b00000},// magia_tile_x10_y24_sam_idx
'{idx: '{x: 10, y: 24, port_id: 0}, start_addr: 32'h30900000, end_addr: 32'h30a00000},// magia_tile_x9_y24_sam_idx
'{idx: '{x: 9, y: 24, port_id: 0}, start_addr: 32'h30800000, end_addr: 32'h30900000},// magia_tile_x8_y24_sam_idx
'{idx: '{x: 8, y: 24, port_id: 0}, start_addr: 32'h30700000, end_addr: 32'h30800000},// magia_tile_x7_y24_sam_idx
'{idx: '{x: 7, y: 24, port_id: 0}, start_addr: 32'h30600000, end_addr: 32'h30700000},// magia_tile_x6_y24_sam_idx
'{idx: '{x: 6, y: 24, port_id: 0}, start_addr: 32'h30500000, end_addr: 32'h30600000},// magia_tile_x5_y24_sam_idx
'{idx: '{x: 5, y: 24, port_id: 0}, start_addr: 32'h30400000, end_addr: 32'h30500000},// magia_tile_x4_y24_sam_idx
'{idx: '{x: 4, y: 24, port_id: 0}, start_addr: 32'h30300000, end_addr: 32'h30400000},// magia_tile_x3_y24_sam_idx
'{idx: '{x: 3, y: 24, port_id: 0}, start_addr: 32'h30200000, end_addr: 32'h30300000},// magia_tile_x2_y24_sam_idx
'{idx: '{x: 2, y: 24, port_id: 0}, start_addr: 32'h30100000, end_addr: 32'h30200000},// magia_tile_x1_y24_sam_idx
'{idx: '{x: 1, y: 24, port_id: 0}, start_addr: 32'h30000000, end_addr: 32'h30100000},// magia_tile_x0_y24_sam_idx
'{idx: '{x: 32, y: 23, port_id: 0}, start_addr: 32'h2ff00000, end_addr: 32'h30000000},// magia_tile_x31_y23_sam_idx
'{idx: '{x: 31, y: 23, port_id: 0}, start_addr: 32'h2fe00000, end_addr: 32'h2ff00000},// magia_tile_x30_y23_sam_idx
'{idx: '{x: 30, y: 23, port_id: 0}, start_addr: 32'h2fd00000, end_addr: 32'h2fe00000},// magia_tile_x29_y23_sam_idx
'{idx: '{x: 29, y: 23, port_id: 0}, start_addr: 32'h2fc00000, end_addr: 32'h2fd00000},// magia_tile_x28_y23_sam_idx
'{idx: '{x: 28, y: 23, port_id: 0}, start_addr: 32'h2fb00000, end_addr: 32'h2fc00000},// magia_tile_x27_y23_sam_idx
'{idx: '{x: 27, y: 23, port_id: 0}, start_addr: 32'h2fa00000, end_addr: 32'h2fb00000},// magia_tile_x26_y23_sam_idx
'{idx: '{x: 26, y: 23, port_id: 0}, start_addr: 32'h2f900000, end_addr: 32'h2fa00000},// magia_tile_x25_y23_sam_idx
'{idx: '{x: 25, y: 23, port_id: 0}, start_addr: 32'h2f800000, end_addr: 32'h2f900000},// magia_tile_x24_y23_sam_idx
'{idx: '{x: 24, y: 23, port_id: 0}, start_addr: 32'h2f700000, end_addr: 32'h2f800000},// magia_tile_x23_y23_sam_idx
'{idx: '{x: 23, y: 23, port_id: 0}, start_addr: 32'h2f600000, end_addr: 32'h2f700000},// magia_tile_x22_y23_sam_idx
'{idx: '{x: 22, y: 23, port_id: 0}, start_addr: 32'h2f500000, end_addr: 32'h2f600000},// magia_tile_x21_y23_sam_idx
'{idx: '{x: 21, y: 23, port_id: 0}, start_addr: 32'h2f400000, end_addr: 32'h2f500000},// magia_tile_x20_y23_sam_idx
'{idx: '{x: 20, y: 23, port_id: 0}, start_addr: 32'h2f300000, end_addr: 32'h2f400000},// magia_tile_x19_y23_sam_idx
'{idx: '{x: 19, y: 23, port_id: 0}, start_addr: 32'h2f200000, end_addr: 32'h2f300000},// magia_tile_x18_y23_sam_idx
'{idx: '{x: 18, y: 23, port_id: 0}, start_addr: 32'h2f100000, end_addr: 32'h2f200000},// magia_tile_x17_y23_sam_idx
'{idx: '{x: 17, y: 23, port_id: 0}, start_addr: 32'h2f000000, end_addr: 32'h2f100000},// magia_tile_x16_y23_sam_idx
'{idx: '{x: 16, y: 23, port_id: 0}, start_addr: 32'h2ef00000, end_addr: 32'h2f000000},// magia_tile_x15_y23_sam_idx
'{idx: '{x: 15, y: 23, port_id: 0}, start_addr: 32'h2ee00000, end_addr: 32'h2ef00000},// magia_tile_x14_y23_sam_idx
'{idx: '{x: 14, y: 23, port_id: 0}, start_addr: 32'h2ed00000, end_addr: 32'h2ee00000},// magia_tile_x13_y23_sam_idx
'{idx: '{x: 13, y: 23, port_id: 0}, start_addr: 32'h2ec00000, end_addr: 32'h2ed00000},// magia_tile_x12_y23_sam_idx
'{idx: '{x: 12, y: 23, port_id: 0}, start_addr: 32'h2eb00000, end_addr: 32'h2ec00000},// magia_tile_x11_y23_sam_idx
'{idx: '{x: 11, y: 23, port_id: 0}, start_addr: 32'h2ea00000, end_addr: 32'h2eb00000},// magia_tile_x10_y23_sam_idx
'{idx: '{x: 10, y: 23, port_id: 0}, start_addr: 32'h2e900000, end_addr: 32'h2ea00000},// magia_tile_x9_y23_sam_idx
'{idx: '{x: 9, y: 23, port_id: 0}, start_addr: 32'h2e800000, end_addr: 32'h2e900000},// magia_tile_x8_y23_sam_idx
'{idx: '{x: 8, y: 23, port_id: 0}, start_addr: 32'h2e700000, end_addr: 32'h2e800000},// magia_tile_x7_y23_sam_idx
'{idx: '{x: 7, y: 23, port_id: 0}, start_addr: 32'h2e600000, end_addr: 32'h2e700000},// magia_tile_x6_y23_sam_idx
'{idx: '{x: 6, y: 23, port_id: 0}, start_addr: 32'h2e500000, end_addr: 32'h2e600000},// magia_tile_x5_y23_sam_idx
'{idx: '{x: 5, y: 23, port_id: 0}, start_addr: 32'h2e400000, end_addr: 32'h2e500000},// magia_tile_x4_y23_sam_idx
'{idx: '{x: 4, y: 23, port_id: 0}, start_addr: 32'h2e300000, end_addr: 32'h2e400000},// magia_tile_x3_y23_sam_idx
'{idx: '{x: 3, y: 23, port_id: 0}, start_addr: 32'h2e200000, end_addr: 32'h2e300000},// magia_tile_x2_y23_sam_idx
'{idx: '{x: 2, y: 23, port_id: 0}, start_addr: 32'h2e100000, end_addr: 32'h2e200000},// magia_tile_x1_y23_sam_idx
'{idx: '{x: 1, y: 23, port_id: 0}, start_addr: 32'h2e000000, end_addr: 32'h2e100000},// magia_tile_x0_y23_sam_idx
'{idx: '{x: 32, y: 22, port_id: 0}, start_addr: 32'h2df00000, end_addr: 32'h2e000000},// magia_tile_x31_y22_sam_idx
'{idx: '{x: 31, y: 22, port_id: 0}, start_addr: 32'h2de00000, end_addr: 32'h2df00000},// magia_tile_x30_y22_sam_idx
'{idx: '{x: 30, y: 22, port_id: 0}, start_addr: 32'h2dd00000, end_addr: 32'h2de00000},// magia_tile_x29_y22_sam_idx
'{idx: '{x: 29, y: 22, port_id: 0}, start_addr: 32'h2dc00000, end_addr: 32'h2dd00000},// magia_tile_x28_y22_sam_idx
'{idx: '{x: 28, y: 22, port_id: 0}, start_addr: 32'h2db00000, end_addr: 32'h2dc00000},// magia_tile_x27_y22_sam_idx
'{idx: '{x: 27, y: 22, port_id: 0}, start_addr: 32'h2da00000, end_addr: 32'h2db00000},// magia_tile_x26_y22_sam_idx
'{idx: '{x: 26, y: 22, port_id: 0}, start_addr: 32'h2d900000, end_addr: 32'h2da00000},// magia_tile_x25_y22_sam_idx
'{idx: '{x: 25, y: 22, port_id: 0}, start_addr: 32'h2d800000, end_addr: 32'h2d900000},// magia_tile_x24_y22_sam_idx
'{idx: '{x: 24, y: 22, port_id: 0}, start_addr: 32'h2d700000, end_addr: 32'h2d800000},// magia_tile_x23_y22_sam_idx
'{idx: '{x: 23, y: 22, port_id: 0}, start_addr: 32'h2d600000, end_addr: 32'h2d700000},// magia_tile_x22_y22_sam_idx
'{idx: '{x: 22, y: 22, port_id: 0}, start_addr: 32'h2d500000, end_addr: 32'h2d600000},// magia_tile_x21_y22_sam_idx
'{idx: '{x: 21, y: 22, port_id: 0}, start_addr: 32'h2d400000, end_addr: 32'h2d500000},// magia_tile_x20_y22_sam_idx
'{idx: '{x: 20, y: 22, port_id: 0}, start_addr: 32'h2d300000, end_addr: 32'h2d400000},// magia_tile_x19_y22_sam_idx
'{idx: '{x: 19, y: 22, port_id: 0}, start_addr: 32'h2d200000, end_addr: 32'h2d300000},// magia_tile_x18_y22_sam_idx
'{idx: '{x: 18, y: 22, port_id: 0}, start_addr: 32'h2d100000, end_addr: 32'h2d200000},// magia_tile_x17_y22_sam_idx
'{idx: '{x: 17, y: 22, port_id: 0}, start_addr: 32'h2d000000, end_addr: 32'h2d100000},// magia_tile_x16_y22_sam_idx
'{idx: '{x: 16, y: 22, port_id: 0}, start_addr: 32'h2cf00000, end_addr: 32'h2d000000},// magia_tile_x15_y22_sam_idx
'{idx: '{x: 15, y: 22, port_id: 0}, start_addr: 32'h2ce00000, end_addr: 32'h2cf00000},// magia_tile_x14_y22_sam_idx
'{idx: '{x: 14, y: 22, port_id: 0}, start_addr: 32'h2cd00000, end_addr: 32'h2ce00000},// magia_tile_x13_y22_sam_idx
'{idx: '{x: 13, y: 22, port_id: 0}, start_addr: 32'h2cc00000, end_addr: 32'h2cd00000},// magia_tile_x12_y22_sam_idx
'{idx: '{x: 12, y: 22, port_id: 0}, start_addr: 32'h2cb00000, end_addr: 32'h2cc00000},// magia_tile_x11_y22_sam_idx
'{idx: '{x: 11, y: 22, port_id: 0}, start_addr: 32'h2ca00000, end_addr: 32'h2cb00000},// magia_tile_x10_y22_sam_idx
'{idx: '{x: 10, y: 22, port_id: 0}, start_addr: 32'h2c900000, end_addr: 32'h2ca00000},// magia_tile_x9_y22_sam_idx
'{idx: '{x: 9, y: 22, port_id: 0}, start_addr: 32'h2c800000, end_addr: 32'h2c900000},// magia_tile_x8_y22_sam_idx
'{idx: '{x: 8, y: 22, port_id: 0}, start_addr: 32'h2c700000, end_addr: 32'h2c800000},// magia_tile_x7_y22_sam_idx
'{idx: '{x: 7, y: 22, port_id: 0}, start_addr: 32'h2c600000, end_addr: 32'h2c700000},// magia_tile_x6_y22_sam_idx
'{idx: '{x: 6, y: 22, port_id: 0}, start_addr: 32'h2c500000, end_addr: 32'h2c600000},// magia_tile_x5_y22_sam_idx
'{idx: '{x: 5, y: 22, port_id: 0}, start_addr: 32'h2c400000, end_addr: 32'h2c500000},// magia_tile_x4_y22_sam_idx
'{idx: '{x: 4, y: 22, port_id: 0}, start_addr: 32'h2c300000, end_addr: 32'h2c400000},// magia_tile_x3_y22_sam_idx
'{idx: '{x: 3, y: 22, port_id: 0}, start_addr: 32'h2c200000, end_addr: 32'h2c300000},// magia_tile_x2_y22_sam_idx
'{idx: '{x: 2, y: 22, port_id: 0}, start_addr: 32'h2c100000, end_addr: 32'h2c200000},// magia_tile_x1_y22_sam_idx
'{idx: '{x: 1, y: 22, port_id: 0}, start_addr: 32'h2c000000, end_addr: 32'h2c100000},// magia_tile_x0_y22_sam_idx
'{idx: '{x: 32, y: 21, port_id: 0}, start_addr: 32'h2bf00000, end_addr: 32'h2c000000},// magia_tile_x31_y21_sam_idx
'{idx: '{x: 31, y: 21, port_id: 0}, start_addr: 32'h2be00000, end_addr: 32'h2bf00000},// magia_tile_x30_y21_sam_idx
'{idx: '{x: 30, y: 21, port_id: 0}, start_addr: 32'h2bd00000, end_addr: 32'h2be00000},// magia_tile_x29_y21_sam_idx
'{idx: '{x: 29, y: 21, port_id: 0}, start_addr: 32'h2bc00000, end_addr: 32'h2bd00000},// magia_tile_x28_y21_sam_idx
'{idx: '{x: 28, y: 21, port_id: 0}, start_addr: 32'h2bb00000, end_addr: 32'h2bc00000},// magia_tile_x27_y21_sam_idx
'{idx: '{x: 27, y: 21, port_id: 0}, start_addr: 32'h2ba00000, end_addr: 32'h2bb00000},// magia_tile_x26_y21_sam_idx
'{idx: '{x: 26, y: 21, port_id: 0}, start_addr: 32'h2b900000, end_addr: 32'h2ba00000},// magia_tile_x25_y21_sam_idx
'{idx: '{x: 25, y: 21, port_id: 0}, start_addr: 32'h2b800000, end_addr: 32'h2b900000},// magia_tile_x24_y21_sam_idx
'{idx: '{x: 24, y: 21, port_id: 0}, start_addr: 32'h2b700000, end_addr: 32'h2b800000},// magia_tile_x23_y21_sam_idx
'{idx: '{x: 23, y: 21, port_id: 0}, start_addr: 32'h2b600000, end_addr: 32'h2b700000},// magia_tile_x22_y21_sam_idx
'{idx: '{x: 22, y: 21, port_id: 0}, start_addr: 32'h2b500000, end_addr: 32'h2b600000},// magia_tile_x21_y21_sam_idx
'{idx: '{x: 21, y: 21, port_id: 0}, start_addr: 32'h2b400000, end_addr: 32'h2b500000},// magia_tile_x20_y21_sam_idx
'{idx: '{x: 20, y: 21, port_id: 0}, start_addr: 32'h2b300000, end_addr: 32'h2b400000},// magia_tile_x19_y21_sam_idx
'{idx: '{x: 19, y: 21, port_id: 0}, start_addr: 32'h2b200000, end_addr: 32'h2b300000},// magia_tile_x18_y21_sam_idx
'{idx: '{x: 18, y: 21, port_id: 0}, start_addr: 32'h2b100000, end_addr: 32'h2b200000},// magia_tile_x17_y21_sam_idx
'{idx: '{x: 17, y: 21, port_id: 0}, start_addr: 32'h2b000000, end_addr: 32'h2b100000},// magia_tile_x16_y21_sam_idx
'{idx: '{x: 16, y: 21, port_id: 0}, start_addr: 32'h2af00000, end_addr: 32'h2b000000},// magia_tile_x15_y21_sam_idx
'{idx: '{x: 15, y: 21, port_id: 0}, start_addr: 32'h2ae00000, end_addr: 32'h2af00000},// magia_tile_x14_y21_sam_idx
'{idx: '{x: 14, y: 21, port_id: 0}, start_addr: 32'h2ad00000, end_addr: 32'h2ae00000},// magia_tile_x13_y21_sam_idx
'{idx: '{x: 13, y: 21, port_id: 0}, start_addr: 32'h2ac00000, end_addr: 32'h2ad00000},// magia_tile_x12_y21_sam_idx
'{idx: '{x: 12, y: 21, port_id: 0}, start_addr: 32'h2ab00000, end_addr: 32'h2ac00000},// magia_tile_x11_y21_sam_idx
'{idx: '{x: 11, y: 21, port_id: 0}, start_addr: 32'h2aa00000, end_addr: 32'h2ab00000},// magia_tile_x10_y21_sam_idx
'{idx: '{x: 10, y: 21, port_id: 0}, start_addr: 32'h2a900000, end_addr: 32'h2aa00000},// magia_tile_x9_y21_sam_idx
'{idx: '{x: 9, y: 21, port_id: 0}, start_addr: 32'h2a800000, end_addr: 32'h2a900000},// magia_tile_x8_y21_sam_idx
'{idx: '{x: 8, y: 21, port_id: 0}, start_addr: 32'h2a700000, end_addr: 32'h2a800000},// magia_tile_x7_y21_sam_idx
'{idx: '{x: 7, y: 21, port_id: 0}, start_addr: 32'h2a600000, end_addr: 32'h2a700000},// magia_tile_x6_y21_sam_idx
'{idx: '{x: 6, y: 21, port_id: 0}, start_addr: 32'h2a500000, end_addr: 32'h2a600000},// magia_tile_x5_y21_sam_idx
'{idx: '{x: 5, y: 21, port_id: 0}, start_addr: 32'h2a400000, end_addr: 32'h2a500000},// magia_tile_x4_y21_sam_idx
'{idx: '{x: 4, y: 21, port_id: 0}, start_addr: 32'h2a300000, end_addr: 32'h2a400000},// magia_tile_x3_y21_sam_idx
'{idx: '{x: 3, y: 21, port_id: 0}, start_addr: 32'h2a200000, end_addr: 32'h2a300000},// magia_tile_x2_y21_sam_idx
'{idx: '{x: 2, y: 21, port_id: 0}, start_addr: 32'h2a100000, end_addr: 32'h2a200000},// magia_tile_x1_y21_sam_idx
'{idx: '{x: 1, y: 21, port_id: 0}, start_addr: 32'h2a000000, end_addr: 32'h2a100000},// magia_tile_x0_y21_sam_idx
'{idx: '{x: 32, y: 20, port_id: 0}, start_addr: 32'h29f00000, end_addr: 32'h2a000000},// magia_tile_x31_y20_sam_idx
'{idx: '{x: 31, y: 20, port_id: 0}, start_addr: 32'h29e00000, end_addr: 32'h29f00000},// magia_tile_x30_y20_sam_idx
'{idx: '{x: 30, y: 20, port_id: 0}, start_addr: 32'h29d00000, end_addr: 32'h29e00000},// magia_tile_x29_y20_sam_idx
'{idx: '{x: 29, y: 20, port_id: 0}, start_addr: 32'h29c00000, end_addr: 32'h29d00000},// magia_tile_x28_y20_sam_idx
'{idx: '{x: 28, y: 20, port_id: 0}, start_addr: 32'h29b00000, end_addr: 32'h29c00000},// magia_tile_x27_y20_sam_idx
'{idx: '{x: 27, y: 20, port_id: 0}, start_addr: 32'h29a00000, end_addr: 32'h29b00000},// magia_tile_x26_y20_sam_idx
'{idx: '{x: 26, y: 20, port_id: 0}, start_addr: 32'h29900000, end_addr: 32'h29a00000},// magia_tile_x25_y20_sam_idx
'{idx: '{x: 25, y: 20, port_id: 0}, start_addr: 32'h29800000, end_addr: 32'h29900000},// magia_tile_x24_y20_sam_idx
'{idx: '{x: 24, y: 20, port_id: 0}, start_addr: 32'h29700000, end_addr: 32'h29800000},// magia_tile_x23_y20_sam_idx
'{idx: '{x: 23, y: 20, port_id: 0}, start_addr: 32'h29600000, end_addr: 32'h29700000},// magia_tile_x22_y20_sam_idx
'{idx: '{x: 22, y: 20, port_id: 0}, start_addr: 32'h29500000, end_addr: 32'h29600000},// magia_tile_x21_y20_sam_idx
'{idx: '{x: 21, y: 20, port_id: 0}, start_addr: 32'h29400000, end_addr: 32'h29500000},// magia_tile_x20_y20_sam_idx
'{idx: '{x: 20, y: 20, port_id: 0}, start_addr: 32'h29300000, end_addr: 32'h29400000},// magia_tile_x19_y20_sam_idx
'{idx: '{x: 19, y: 20, port_id: 0}, start_addr: 32'h29200000, end_addr: 32'h29300000},// magia_tile_x18_y20_sam_idx
'{idx: '{x: 18, y: 20, port_id: 0}, start_addr: 32'h29100000, end_addr: 32'h29200000},// magia_tile_x17_y20_sam_idx
'{idx: '{x: 17, y: 20, port_id: 0}, start_addr: 32'h29000000, end_addr: 32'h29100000},// magia_tile_x16_y20_sam_idx
'{idx: '{x: 16, y: 20, port_id: 0}, start_addr: 32'h28f00000, end_addr: 32'h29000000},// magia_tile_x15_y20_sam_idx
'{idx: '{x: 15, y: 20, port_id: 0}, start_addr: 32'h28e00000, end_addr: 32'h28f00000},// magia_tile_x14_y20_sam_idx
'{idx: '{x: 14, y: 20, port_id: 0}, start_addr: 32'h28d00000, end_addr: 32'h28e00000},// magia_tile_x13_y20_sam_idx
'{idx: '{x: 13, y: 20, port_id: 0}, start_addr: 32'h28c00000, end_addr: 32'h28d00000},// magia_tile_x12_y20_sam_idx
'{idx: '{x: 12, y: 20, port_id: 0}, start_addr: 32'h28b00000, end_addr: 32'h28c00000},// magia_tile_x11_y20_sam_idx
'{idx: '{x: 11, y: 20, port_id: 0}, start_addr: 32'h28a00000, end_addr: 32'h28b00000},// magia_tile_x10_y20_sam_idx
'{idx: '{x: 10, y: 20, port_id: 0}, start_addr: 32'h28900000, end_addr: 32'h28a00000},// magia_tile_x9_y20_sam_idx
'{idx: '{x: 9, y: 20, port_id: 0}, start_addr: 32'h28800000, end_addr: 32'h28900000},// magia_tile_x8_y20_sam_idx
'{idx: '{x: 8, y: 20, port_id: 0}, start_addr: 32'h28700000, end_addr: 32'h28800000},// magia_tile_x7_y20_sam_idx
'{idx: '{x: 7, y: 20, port_id: 0}, start_addr: 32'h28600000, end_addr: 32'h28700000},// magia_tile_x6_y20_sam_idx
'{idx: '{x: 6, y: 20, port_id: 0}, start_addr: 32'h28500000, end_addr: 32'h28600000},// magia_tile_x5_y20_sam_idx
'{idx: '{x: 5, y: 20, port_id: 0}, start_addr: 32'h28400000, end_addr: 32'h28500000},// magia_tile_x4_y20_sam_idx
'{idx: '{x: 4, y: 20, port_id: 0}, start_addr: 32'h28300000, end_addr: 32'h28400000},// magia_tile_x3_y20_sam_idx
'{idx: '{x: 3, y: 20, port_id: 0}, start_addr: 32'h28200000, end_addr: 32'h28300000},// magia_tile_x2_y20_sam_idx
'{idx: '{x: 2, y: 20, port_id: 0}, start_addr: 32'h28100000, end_addr: 32'h28200000},// magia_tile_x1_y20_sam_idx
'{idx: '{x: 1, y: 20, port_id: 0}, start_addr: 32'h28000000, end_addr: 32'h28100000},// magia_tile_x0_y20_sam_idx
'{idx: '{x: 32, y: 19, port_id: 0}, start_addr: 32'h27f00000, end_addr: 32'h28000000},// magia_tile_x31_y19_sam_idx
'{idx: '{x: 31, y: 19, port_id: 0}, start_addr: 32'h27e00000, end_addr: 32'h27f00000},// magia_tile_x30_y19_sam_idx
'{idx: '{x: 30, y: 19, port_id: 0}, start_addr: 32'h27d00000, end_addr: 32'h27e00000},// magia_tile_x29_y19_sam_idx
'{idx: '{x: 29, y: 19, port_id: 0}, start_addr: 32'h27c00000, end_addr: 32'h27d00000},// magia_tile_x28_y19_sam_idx
'{idx: '{x: 28, y: 19, port_id: 0}, start_addr: 32'h27b00000, end_addr: 32'h27c00000},// magia_tile_x27_y19_sam_idx
'{idx: '{x: 27, y: 19, port_id: 0}, start_addr: 32'h27a00000, end_addr: 32'h27b00000},// magia_tile_x26_y19_sam_idx
'{idx: '{x: 26, y: 19, port_id: 0}, start_addr: 32'h27900000, end_addr: 32'h27a00000},// magia_tile_x25_y19_sam_idx
'{idx: '{x: 25, y: 19, port_id: 0}, start_addr: 32'h27800000, end_addr: 32'h27900000},// magia_tile_x24_y19_sam_idx
'{idx: '{x: 24, y: 19, port_id: 0}, start_addr: 32'h27700000, end_addr: 32'h27800000},// magia_tile_x23_y19_sam_idx
'{idx: '{x: 23, y: 19, port_id: 0}, start_addr: 32'h27600000, end_addr: 32'h27700000},// magia_tile_x22_y19_sam_idx
'{idx: '{x: 22, y: 19, port_id: 0}, start_addr: 32'h27500000, end_addr: 32'h27600000},// magia_tile_x21_y19_sam_idx
'{idx: '{x: 21, y: 19, port_id: 0}, start_addr: 32'h27400000, end_addr: 32'h27500000},// magia_tile_x20_y19_sam_idx
'{idx: '{x: 20, y: 19, port_id: 0}, start_addr: 32'h27300000, end_addr: 32'h27400000},// magia_tile_x19_y19_sam_idx
'{idx: '{x: 19, y: 19, port_id: 0}, start_addr: 32'h27200000, end_addr: 32'h27300000},// magia_tile_x18_y19_sam_idx
'{idx: '{x: 18, y: 19, port_id: 0}, start_addr: 32'h27100000, end_addr: 32'h27200000},// magia_tile_x17_y19_sam_idx
'{idx: '{x: 17, y: 19, port_id: 0}, start_addr: 32'h27000000, end_addr: 32'h27100000},// magia_tile_x16_y19_sam_idx
'{idx: '{x: 16, y: 19, port_id: 0}, start_addr: 32'h26f00000, end_addr: 32'h27000000},// magia_tile_x15_y19_sam_idx
'{idx: '{x: 15, y: 19, port_id: 0}, start_addr: 32'h26e00000, end_addr: 32'h26f00000},// magia_tile_x14_y19_sam_idx
'{idx: '{x: 14, y: 19, port_id: 0}, start_addr: 32'h26d00000, end_addr: 32'h26e00000},// magia_tile_x13_y19_sam_idx
'{idx: '{x: 13, y: 19, port_id: 0}, start_addr: 32'h26c00000, end_addr: 32'h26d00000},// magia_tile_x12_y19_sam_idx
'{idx: '{x: 12, y: 19, port_id: 0}, start_addr: 32'h26b00000, end_addr: 32'h26c00000},// magia_tile_x11_y19_sam_idx
'{idx: '{x: 11, y: 19, port_id: 0}, start_addr: 32'h26a00000, end_addr: 32'h26b00000},// magia_tile_x10_y19_sam_idx
'{idx: '{x: 10, y: 19, port_id: 0}, start_addr: 32'h26900000, end_addr: 32'h26a00000},// magia_tile_x9_y19_sam_idx
'{idx: '{x: 9, y: 19, port_id: 0}, start_addr: 32'h26800000, end_addr: 32'h26900000},// magia_tile_x8_y19_sam_idx
'{idx: '{x: 8, y: 19, port_id: 0}, start_addr: 32'h26700000, end_addr: 32'h26800000},// magia_tile_x7_y19_sam_idx
'{idx: '{x: 7, y: 19, port_id: 0}, start_addr: 32'h26600000, end_addr: 32'h26700000},// magia_tile_x6_y19_sam_idx
'{idx: '{x: 6, y: 19, port_id: 0}, start_addr: 32'h26500000, end_addr: 32'h26600000},// magia_tile_x5_y19_sam_idx
'{idx: '{x: 5, y: 19, port_id: 0}, start_addr: 32'h26400000, end_addr: 32'h26500000},// magia_tile_x4_y19_sam_idx
'{idx: '{x: 4, y: 19, port_id: 0}, start_addr: 32'h26300000, end_addr: 32'h26400000},// magia_tile_x3_y19_sam_idx
'{idx: '{x: 3, y: 19, port_id: 0}, start_addr: 32'h26200000, end_addr: 32'h26300000},// magia_tile_x2_y19_sam_idx
'{idx: '{x: 2, y: 19, port_id: 0}, start_addr: 32'h26100000, end_addr: 32'h26200000},// magia_tile_x1_y19_sam_idx
'{idx: '{x: 1, y: 19, port_id: 0}, start_addr: 32'h26000000, end_addr: 32'h26100000},// magia_tile_x0_y19_sam_idx
'{idx: '{x: 32, y: 18, port_id: 0}, start_addr: 32'h25f00000, end_addr: 32'h26000000},// magia_tile_x31_y18_sam_idx
'{idx: '{x: 31, y: 18, port_id: 0}, start_addr: 32'h25e00000, end_addr: 32'h25f00000},// magia_tile_x30_y18_sam_idx
'{idx: '{x: 30, y: 18, port_id: 0}, start_addr: 32'h25d00000, end_addr: 32'h25e00000},// magia_tile_x29_y18_sam_idx
'{idx: '{x: 29, y: 18, port_id: 0}, start_addr: 32'h25c00000, end_addr: 32'h25d00000},// magia_tile_x28_y18_sam_idx
'{idx: '{x: 28, y: 18, port_id: 0}, start_addr: 32'h25b00000, end_addr: 32'h25c00000},// magia_tile_x27_y18_sam_idx
'{idx: '{x: 27, y: 18, port_id: 0}, start_addr: 32'h25a00000, end_addr: 32'h25b00000},// magia_tile_x26_y18_sam_idx
'{idx: '{x: 26, y: 18, port_id: 0}, start_addr: 32'h25900000, end_addr: 32'h25a00000},// magia_tile_x25_y18_sam_idx
'{idx: '{x: 25, y: 18, port_id: 0}, start_addr: 32'h25800000, end_addr: 32'h25900000},// magia_tile_x24_y18_sam_idx
'{idx: '{x: 24, y: 18, port_id: 0}, start_addr: 32'h25700000, end_addr: 32'h25800000},// magia_tile_x23_y18_sam_idx
'{idx: '{x: 23, y: 18, port_id: 0}, start_addr: 32'h25600000, end_addr: 32'h25700000},// magia_tile_x22_y18_sam_idx
'{idx: '{x: 22, y: 18, port_id: 0}, start_addr: 32'h25500000, end_addr: 32'h25600000},// magia_tile_x21_y18_sam_idx
'{idx: '{x: 21, y: 18, port_id: 0}, start_addr: 32'h25400000, end_addr: 32'h25500000},// magia_tile_x20_y18_sam_idx
'{idx: '{x: 20, y: 18, port_id: 0}, start_addr: 32'h25300000, end_addr: 32'h25400000},// magia_tile_x19_y18_sam_idx
'{idx: '{x: 19, y: 18, port_id: 0}, start_addr: 32'h25200000, end_addr: 32'h25300000},// magia_tile_x18_y18_sam_idx
'{idx: '{x: 18, y: 18, port_id: 0}, start_addr: 32'h25100000, end_addr: 32'h25200000},// magia_tile_x17_y18_sam_idx
'{idx: '{x: 17, y: 18, port_id: 0}, start_addr: 32'h25000000, end_addr: 32'h25100000},// magia_tile_x16_y18_sam_idx
'{idx: '{x: 16, y: 18, port_id: 0}, start_addr: 32'h24f00000, end_addr: 32'h25000000},// magia_tile_x15_y18_sam_idx
'{idx: '{x: 15, y: 18, port_id: 0}, start_addr: 32'h24e00000, end_addr: 32'h24f00000},// magia_tile_x14_y18_sam_idx
'{idx: '{x: 14, y: 18, port_id: 0}, start_addr: 32'h24d00000, end_addr: 32'h24e00000},// magia_tile_x13_y18_sam_idx
'{idx: '{x: 13, y: 18, port_id: 0}, start_addr: 32'h24c00000, end_addr: 32'h24d00000},// magia_tile_x12_y18_sam_idx
'{idx: '{x: 12, y: 18, port_id: 0}, start_addr: 32'h24b00000, end_addr: 32'h24c00000},// magia_tile_x11_y18_sam_idx
'{idx: '{x: 11, y: 18, port_id: 0}, start_addr: 32'h24a00000, end_addr: 32'h24b00000},// magia_tile_x10_y18_sam_idx
'{idx: '{x: 10, y: 18, port_id: 0}, start_addr: 32'h24900000, end_addr: 32'h24a00000},// magia_tile_x9_y18_sam_idx
'{idx: '{x: 9, y: 18, port_id: 0}, start_addr: 32'h24800000, end_addr: 32'h24900000},// magia_tile_x8_y18_sam_idx
'{idx: '{x: 8, y: 18, port_id: 0}, start_addr: 32'h24700000, end_addr: 32'h24800000},// magia_tile_x7_y18_sam_idx
'{idx: '{x: 7, y: 18, port_id: 0}, start_addr: 32'h24600000, end_addr: 32'h24700000},// magia_tile_x6_y18_sam_idx
'{idx: '{x: 6, y: 18, port_id: 0}, start_addr: 32'h24500000, end_addr: 32'h24600000},// magia_tile_x5_y18_sam_idx
'{idx: '{x: 5, y: 18, port_id: 0}, start_addr: 32'h24400000, end_addr: 32'h24500000},// magia_tile_x4_y18_sam_idx
'{idx: '{x: 4, y: 18, port_id: 0}, start_addr: 32'h24300000, end_addr: 32'h24400000},// magia_tile_x3_y18_sam_idx
'{idx: '{x: 3, y: 18, port_id: 0}, start_addr: 32'h24200000, end_addr: 32'h24300000},// magia_tile_x2_y18_sam_idx
'{idx: '{x: 2, y: 18, port_id: 0}, start_addr: 32'h24100000, end_addr: 32'h24200000},// magia_tile_x1_y18_sam_idx
'{idx: '{x: 1, y: 18, port_id: 0}, start_addr: 32'h24000000, end_addr: 32'h24100000},// magia_tile_x0_y18_sam_idx
'{idx: '{x: 32, y: 17, port_id: 0}, start_addr: 32'h23f00000, end_addr: 32'h24000000},// magia_tile_x31_y17_sam_idx
'{idx: '{x: 31, y: 17, port_id: 0}, start_addr: 32'h23e00000, end_addr: 32'h23f00000},// magia_tile_x30_y17_sam_idx
'{idx: '{x: 30, y: 17, port_id: 0}, start_addr: 32'h23d00000, end_addr: 32'h23e00000},// magia_tile_x29_y17_sam_idx
'{idx: '{x: 29, y: 17, port_id: 0}, start_addr: 32'h23c00000, end_addr: 32'h23d00000},// magia_tile_x28_y17_sam_idx
'{idx: '{x: 28, y: 17, port_id: 0}, start_addr: 32'h23b00000, end_addr: 32'h23c00000},// magia_tile_x27_y17_sam_idx
'{idx: '{x: 27, y: 17, port_id: 0}, start_addr: 32'h23a00000, end_addr: 32'h23b00000},// magia_tile_x26_y17_sam_idx
'{idx: '{x: 26, y: 17, port_id: 0}, start_addr: 32'h23900000, end_addr: 32'h23a00000},// magia_tile_x25_y17_sam_idx
'{idx: '{x: 25, y: 17, port_id: 0}, start_addr: 32'h23800000, end_addr: 32'h23900000},// magia_tile_x24_y17_sam_idx
'{idx: '{x: 24, y: 17, port_id: 0}, start_addr: 32'h23700000, end_addr: 32'h23800000},// magia_tile_x23_y17_sam_idx
'{idx: '{x: 23, y: 17, port_id: 0}, start_addr: 32'h23600000, end_addr: 32'h23700000},// magia_tile_x22_y17_sam_idx
'{idx: '{x: 22, y: 17, port_id: 0}, start_addr: 32'h23500000, end_addr: 32'h23600000},// magia_tile_x21_y17_sam_idx
'{idx: '{x: 21, y: 17, port_id: 0}, start_addr: 32'h23400000, end_addr: 32'h23500000},// magia_tile_x20_y17_sam_idx
'{idx: '{x: 20, y: 17, port_id: 0}, start_addr: 32'h23300000, end_addr: 32'h23400000},// magia_tile_x19_y17_sam_idx
'{idx: '{x: 19, y: 17, port_id: 0}, start_addr: 32'h23200000, end_addr: 32'h23300000},// magia_tile_x18_y17_sam_idx
'{idx: '{x: 18, y: 17, port_id: 0}, start_addr: 32'h23100000, end_addr: 32'h23200000},// magia_tile_x17_y17_sam_idx
'{idx: '{x: 17, y: 17, port_id: 0}, start_addr: 32'h23000000, end_addr: 32'h23100000},// magia_tile_x16_y17_sam_idx
'{idx: '{x: 16, y: 17, port_id: 0}, start_addr: 32'h22f00000, end_addr: 32'h23000000},// magia_tile_x15_y17_sam_idx
'{idx: '{x: 15, y: 17, port_id: 0}, start_addr: 32'h22e00000, end_addr: 32'h22f00000},// magia_tile_x14_y17_sam_idx
'{idx: '{x: 14, y: 17, port_id: 0}, start_addr: 32'h22d00000, end_addr: 32'h22e00000},// magia_tile_x13_y17_sam_idx
'{idx: '{x: 13, y: 17, port_id: 0}, start_addr: 32'h22c00000, end_addr: 32'h22d00000},// magia_tile_x12_y17_sam_idx
'{idx: '{x: 12, y: 17, port_id: 0}, start_addr: 32'h22b00000, end_addr: 32'h22c00000},// magia_tile_x11_y17_sam_idx
'{idx: '{x: 11, y: 17, port_id: 0}, start_addr: 32'h22a00000, end_addr: 32'h22b00000},// magia_tile_x10_y17_sam_idx
'{idx: '{x: 10, y: 17, port_id: 0}, start_addr: 32'h22900000, end_addr: 32'h22a00000},// magia_tile_x9_y17_sam_idx
'{idx: '{x: 9, y: 17, port_id: 0}, start_addr: 32'h22800000, end_addr: 32'h22900000},// magia_tile_x8_y17_sam_idx
'{idx: '{x: 8, y: 17, port_id: 0}, start_addr: 32'h22700000, end_addr: 32'h22800000},// magia_tile_x7_y17_sam_idx
'{idx: '{x: 7, y: 17, port_id: 0}, start_addr: 32'h22600000, end_addr: 32'h22700000},// magia_tile_x6_y17_sam_idx
'{idx: '{x: 6, y: 17, port_id: 0}, start_addr: 32'h22500000, end_addr: 32'h22600000},// magia_tile_x5_y17_sam_idx
'{idx: '{x: 5, y: 17, port_id: 0}, start_addr: 32'h22400000, end_addr: 32'h22500000},// magia_tile_x4_y17_sam_idx
'{idx: '{x: 4, y: 17, port_id: 0}, start_addr: 32'h22300000, end_addr: 32'h22400000},// magia_tile_x3_y17_sam_idx
'{idx: '{x: 3, y: 17, port_id: 0}, start_addr: 32'h22200000, end_addr: 32'h22300000},// magia_tile_x2_y17_sam_idx
'{idx: '{x: 2, y: 17, port_id: 0}, start_addr: 32'h22100000, end_addr: 32'h22200000},// magia_tile_x1_y17_sam_idx
'{idx: '{x: 1, y: 17, port_id: 0}, start_addr: 32'h22000000, end_addr: 32'h22100000},// magia_tile_x0_y17_sam_idx
'{idx: '{x: 32, y: 16, port_id: 0}, start_addr: 32'h21f00000, end_addr: 32'h22000000},// magia_tile_x31_y16_sam_idx
'{idx: '{x: 31, y: 16, port_id: 0}, start_addr: 32'h21e00000, end_addr: 32'h21f00000},// magia_tile_x30_y16_sam_idx
'{idx: '{x: 30, y: 16, port_id: 0}, start_addr: 32'h21d00000, end_addr: 32'h21e00000},// magia_tile_x29_y16_sam_idx
'{idx: '{x: 29, y: 16, port_id: 0}, start_addr: 32'h21c00000, end_addr: 32'h21d00000},// magia_tile_x28_y16_sam_idx
'{idx: '{x: 28, y: 16, port_id: 0}, start_addr: 32'h21b00000, end_addr: 32'h21c00000},// magia_tile_x27_y16_sam_idx
'{idx: '{x: 27, y: 16, port_id: 0}, start_addr: 32'h21a00000, end_addr: 32'h21b00000},// magia_tile_x26_y16_sam_idx
'{idx: '{x: 26, y: 16, port_id: 0}, start_addr: 32'h21900000, end_addr: 32'h21a00000},// magia_tile_x25_y16_sam_idx
'{idx: '{x: 25, y: 16, port_id: 0}, start_addr: 32'h21800000, end_addr: 32'h21900000},// magia_tile_x24_y16_sam_idx
'{idx: '{x: 24, y: 16, port_id: 0}, start_addr: 32'h21700000, end_addr: 32'h21800000},// magia_tile_x23_y16_sam_idx
'{idx: '{x: 23, y: 16, port_id: 0}, start_addr: 32'h21600000, end_addr: 32'h21700000},// magia_tile_x22_y16_sam_idx
'{idx: '{x: 22, y: 16, port_id: 0}, start_addr: 32'h21500000, end_addr: 32'h21600000},// magia_tile_x21_y16_sam_idx
'{idx: '{x: 21, y: 16, port_id: 0}, start_addr: 32'h21400000, end_addr: 32'h21500000},// magia_tile_x20_y16_sam_idx
'{idx: '{x: 20, y: 16, port_id: 0}, start_addr: 32'h21300000, end_addr: 32'h21400000},// magia_tile_x19_y16_sam_idx
'{idx: '{x: 19, y: 16, port_id: 0}, start_addr: 32'h21200000, end_addr: 32'h21300000},// magia_tile_x18_y16_sam_idx
'{idx: '{x: 18, y: 16, port_id: 0}, start_addr: 32'h21100000, end_addr: 32'h21200000},// magia_tile_x17_y16_sam_idx
'{idx: '{x: 17, y: 16, port_id: 0}, start_addr: 32'h21000000, end_addr: 32'h21100000},// magia_tile_x16_y16_sam_idx
'{idx: '{x: 16, y: 16, port_id: 0}, start_addr: 32'h20f00000, end_addr: 32'h21000000},// magia_tile_x15_y16_sam_idx
'{idx: '{x: 15, y: 16, port_id: 0}, start_addr: 32'h20e00000, end_addr: 32'h20f00000},// magia_tile_x14_y16_sam_idx
'{idx: '{x: 14, y: 16, port_id: 0}, start_addr: 32'h20d00000, end_addr: 32'h20e00000},// magia_tile_x13_y16_sam_idx
'{idx: '{x: 13, y: 16, port_id: 0}, start_addr: 32'h20c00000, end_addr: 32'h20d00000},// magia_tile_x12_y16_sam_idx
'{idx: '{x: 12, y: 16, port_id: 0}, start_addr: 32'h20b00000, end_addr: 32'h20c00000},// magia_tile_x11_y16_sam_idx
'{idx: '{x: 11, y: 16, port_id: 0}, start_addr: 32'h20a00000, end_addr: 32'h20b00000},// magia_tile_x10_y16_sam_idx
'{idx: '{x: 10, y: 16, port_id: 0}, start_addr: 32'h20900000, end_addr: 32'h20a00000},// magia_tile_x9_y16_sam_idx
'{idx: '{x: 9, y: 16, port_id: 0}, start_addr: 32'h20800000, end_addr: 32'h20900000},// magia_tile_x8_y16_sam_idx
'{idx: '{x: 8, y: 16, port_id: 0}, start_addr: 32'h20700000, end_addr: 32'h20800000},// magia_tile_x7_y16_sam_idx
'{idx: '{x: 7, y: 16, port_id: 0}, start_addr: 32'h20600000, end_addr: 32'h20700000},// magia_tile_x6_y16_sam_idx
'{idx: '{x: 6, y: 16, port_id: 0}, start_addr: 32'h20500000, end_addr: 32'h20600000},// magia_tile_x5_y16_sam_idx
'{idx: '{x: 5, y: 16, port_id: 0}, start_addr: 32'h20400000, end_addr: 32'h20500000},// magia_tile_x4_y16_sam_idx
'{idx: '{x: 4, y: 16, port_id: 0}, start_addr: 32'h20300000, end_addr: 32'h20400000},// magia_tile_x3_y16_sam_idx
'{idx: '{x: 3, y: 16, port_id: 0}, start_addr: 32'h20200000, end_addr: 32'h20300000},// magia_tile_x2_y16_sam_idx
'{idx: '{x: 2, y: 16, port_id: 0}, start_addr: 32'h20100000, end_addr: 32'h20200000},// magia_tile_x1_y16_sam_idx
'{idx: '{x: 1, y: 16, port_id: 0}, start_addr: 32'h20000000, end_addr: 32'h20100000},// magia_tile_x0_y16_sam_idx
'{idx: '{x: 32, y: 15, port_id: 0}, start_addr: 32'h1ff00000, end_addr: 32'h20000000},// magia_tile_x31_y15_sam_idx
'{idx: '{x: 31, y: 15, port_id: 0}, start_addr: 32'h1fe00000, end_addr: 32'h1ff00000},// magia_tile_x30_y15_sam_idx
'{idx: '{x: 30, y: 15, port_id: 0}, start_addr: 32'h1fd00000, end_addr: 32'h1fe00000},// magia_tile_x29_y15_sam_idx
'{idx: '{x: 29, y: 15, port_id: 0}, start_addr: 32'h1fc00000, end_addr: 32'h1fd00000},// magia_tile_x28_y15_sam_idx
'{idx: '{x: 28, y: 15, port_id: 0}, start_addr: 32'h1fb00000, end_addr: 32'h1fc00000},// magia_tile_x27_y15_sam_idx
'{idx: '{x: 27, y: 15, port_id: 0}, start_addr: 32'h1fa00000, end_addr: 32'h1fb00000},// magia_tile_x26_y15_sam_idx
'{idx: '{x: 26, y: 15, port_id: 0}, start_addr: 32'h1f900000, end_addr: 32'h1fa00000},// magia_tile_x25_y15_sam_idx
'{idx: '{x: 25, y: 15, port_id: 0}, start_addr: 32'h1f800000, end_addr: 32'h1f900000},// magia_tile_x24_y15_sam_idx
'{idx: '{x: 24, y: 15, port_id: 0}, start_addr: 32'h1f700000, end_addr: 32'h1f800000},// magia_tile_x23_y15_sam_idx
'{idx: '{x: 23, y: 15, port_id: 0}, start_addr: 32'h1f600000, end_addr: 32'h1f700000},// magia_tile_x22_y15_sam_idx
'{idx: '{x: 22, y: 15, port_id: 0}, start_addr: 32'h1f500000, end_addr: 32'h1f600000},// magia_tile_x21_y15_sam_idx
'{idx: '{x: 21, y: 15, port_id: 0}, start_addr: 32'h1f400000, end_addr: 32'h1f500000},// magia_tile_x20_y15_sam_idx
'{idx: '{x: 20, y: 15, port_id: 0}, start_addr: 32'h1f300000, end_addr: 32'h1f400000},// magia_tile_x19_y15_sam_idx
'{idx: '{x: 19, y: 15, port_id: 0}, start_addr: 32'h1f200000, end_addr: 32'h1f300000},// magia_tile_x18_y15_sam_idx
'{idx: '{x: 18, y: 15, port_id: 0}, start_addr: 32'h1f100000, end_addr: 32'h1f200000},// magia_tile_x17_y15_sam_idx
'{idx: '{x: 17, y: 15, port_id: 0}, start_addr: 32'h1f000000, end_addr: 32'h1f100000},// magia_tile_x16_y15_sam_idx
'{idx: '{x: 16, y: 15, port_id: 0}, start_addr: 32'h1ef00000, end_addr: 32'h1f000000},// magia_tile_x15_y15_sam_idx
'{idx: '{x: 15, y: 15, port_id: 0}, start_addr: 32'h1ee00000, end_addr: 32'h1ef00000},// magia_tile_x14_y15_sam_idx
'{idx: '{x: 14, y: 15, port_id: 0}, start_addr: 32'h1ed00000, end_addr: 32'h1ee00000},// magia_tile_x13_y15_sam_idx
'{idx: '{x: 13, y: 15, port_id: 0}, start_addr: 32'h1ec00000, end_addr: 32'h1ed00000},// magia_tile_x12_y15_sam_idx
'{idx: '{x: 12, y: 15, port_id: 0}, start_addr: 32'h1eb00000, end_addr: 32'h1ec00000},// magia_tile_x11_y15_sam_idx
'{idx: '{x: 11, y: 15, port_id: 0}, start_addr: 32'h1ea00000, end_addr: 32'h1eb00000},// magia_tile_x10_y15_sam_idx
'{idx: '{x: 10, y: 15, port_id: 0}, start_addr: 32'h1e900000, end_addr: 32'h1ea00000},// magia_tile_x9_y15_sam_idx
'{idx: '{x: 9, y: 15, port_id: 0}, start_addr: 32'h1e800000, end_addr: 32'h1e900000},// magia_tile_x8_y15_sam_idx
'{idx: '{x: 8, y: 15, port_id: 0}, start_addr: 32'h1e700000, end_addr: 32'h1e800000},// magia_tile_x7_y15_sam_idx
'{idx: '{x: 7, y: 15, port_id: 0}, start_addr: 32'h1e600000, end_addr: 32'h1e700000},// magia_tile_x6_y15_sam_idx
'{idx: '{x: 6, y: 15, port_id: 0}, start_addr: 32'h1e500000, end_addr: 32'h1e600000},// magia_tile_x5_y15_sam_idx
'{idx: '{x: 5, y: 15, port_id: 0}, start_addr: 32'h1e400000, end_addr: 32'h1e500000},// magia_tile_x4_y15_sam_idx
'{idx: '{x: 4, y: 15, port_id: 0}, start_addr: 32'h1e300000, end_addr: 32'h1e400000},// magia_tile_x3_y15_sam_idx
'{idx: '{x: 3, y: 15, port_id: 0}, start_addr: 32'h1e200000, end_addr: 32'h1e300000},// magia_tile_x2_y15_sam_idx
'{idx: '{x: 2, y: 15, port_id: 0}, start_addr: 32'h1e100000, end_addr: 32'h1e200000},// magia_tile_x1_y15_sam_idx
'{idx: '{x: 1, y: 15, port_id: 0}, start_addr: 32'h1e000000, end_addr: 32'h1e100000},// magia_tile_x0_y15_sam_idx
'{idx: '{x: 32, y: 14, port_id: 0}, start_addr: 32'h1df00000, end_addr: 32'h1e000000},// magia_tile_x31_y14_sam_idx
'{idx: '{x: 31, y: 14, port_id: 0}, start_addr: 32'h1de00000, end_addr: 32'h1df00000},// magia_tile_x30_y14_sam_idx
'{idx: '{x: 30, y: 14, port_id: 0}, start_addr: 32'h1dd00000, end_addr: 32'h1de00000},// magia_tile_x29_y14_sam_idx
'{idx: '{x: 29, y: 14, port_id: 0}, start_addr: 32'h1dc00000, end_addr: 32'h1dd00000},// magia_tile_x28_y14_sam_idx
'{idx: '{x: 28, y: 14, port_id: 0}, start_addr: 32'h1db00000, end_addr: 32'h1dc00000},// magia_tile_x27_y14_sam_idx
'{idx: '{x: 27, y: 14, port_id: 0}, start_addr: 32'h1da00000, end_addr: 32'h1db00000},// magia_tile_x26_y14_sam_idx
'{idx: '{x: 26, y: 14, port_id: 0}, start_addr: 32'h1d900000, end_addr: 32'h1da00000},// magia_tile_x25_y14_sam_idx
'{idx: '{x: 25, y: 14, port_id: 0}, start_addr: 32'h1d800000, end_addr: 32'h1d900000},// magia_tile_x24_y14_sam_idx
'{idx: '{x: 24, y: 14, port_id: 0}, start_addr: 32'h1d700000, end_addr: 32'h1d800000},// magia_tile_x23_y14_sam_idx
'{idx: '{x: 23, y: 14, port_id: 0}, start_addr: 32'h1d600000, end_addr: 32'h1d700000},// magia_tile_x22_y14_sam_idx
'{idx: '{x: 22, y: 14, port_id: 0}, start_addr: 32'h1d500000, end_addr: 32'h1d600000},// magia_tile_x21_y14_sam_idx
'{idx: '{x: 21, y: 14, port_id: 0}, start_addr: 32'h1d400000, end_addr: 32'h1d500000},// magia_tile_x20_y14_sam_idx
'{idx: '{x: 20, y: 14, port_id: 0}, start_addr: 32'h1d300000, end_addr: 32'h1d400000},// magia_tile_x19_y14_sam_idx
'{idx: '{x: 19, y: 14, port_id: 0}, start_addr: 32'h1d200000, end_addr: 32'h1d300000},// magia_tile_x18_y14_sam_idx
'{idx: '{x: 18, y: 14, port_id: 0}, start_addr: 32'h1d100000, end_addr: 32'h1d200000},// magia_tile_x17_y14_sam_idx
'{idx: '{x: 17, y: 14, port_id: 0}, start_addr: 32'h1d000000, end_addr: 32'h1d100000},// magia_tile_x16_y14_sam_idx
'{idx: '{x: 16, y: 14, port_id: 0}, start_addr: 32'h1cf00000, end_addr: 32'h1d000000},// magia_tile_x15_y14_sam_idx
'{idx: '{x: 15, y: 14, port_id: 0}, start_addr: 32'h1ce00000, end_addr: 32'h1cf00000},// magia_tile_x14_y14_sam_idx
'{idx: '{x: 14, y: 14, port_id: 0}, start_addr: 32'h1cd00000, end_addr: 32'h1ce00000},// magia_tile_x13_y14_sam_idx
'{idx: '{x: 13, y: 14, port_id: 0}, start_addr: 32'h1cc00000, end_addr: 32'h1cd00000},// magia_tile_x12_y14_sam_idx
'{idx: '{x: 12, y: 14, port_id: 0}, start_addr: 32'h1cb00000, end_addr: 32'h1cc00000},// magia_tile_x11_y14_sam_idx
'{idx: '{x: 11, y: 14, port_id: 0}, start_addr: 32'h1ca00000, end_addr: 32'h1cb00000},// magia_tile_x10_y14_sam_idx
'{idx: '{x: 10, y: 14, port_id: 0}, start_addr: 32'h1c900000, end_addr: 32'h1ca00000},// magia_tile_x9_y14_sam_idx
'{idx: '{x: 9, y: 14, port_id: 0}, start_addr: 32'h1c800000, end_addr: 32'h1c900000},// magia_tile_x8_y14_sam_idx
'{idx: '{x: 8, y: 14, port_id: 0}, start_addr: 32'h1c700000, end_addr: 32'h1c800000},// magia_tile_x7_y14_sam_idx
'{idx: '{x: 7, y: 14, port_id: 0}, start_addr: 32'h1c600000, end_addr: 32'h1c700000},// magia_tile_x6_y14_sam_idx
'{idx: '{x: 6, y: 14, port_id: 0}, start_addr: 32'h1c500000, end_addr: 32'h1c600000},// magia_tile_x5_y14_sam_idx
'{idx: '{x: 5, y: 14, port_id: 0}, start_addr: 32'h1c400000, end_addr: 32'h1c500000},// magia_tile_x4_y14_sam_idx
'{idx: '{x: 4, y: 14, port_id: 0}, start_addr: 32'h1c300000, end_addr: 32'h1c400000},// magia_tile_x3_y14_sam_idx
'{idx: '{x: 3, y: 14, port_id: 0}, start_addr: 32'h1c200000, end_addr: 32'h1c300000},// magia_tile_x2_y14_sam_idx
'{idx: '{x: 2, y: 14, port_id: 0}, start_addr: 32'h1c100000, end_addr: 32'h1c200000},// magia_tile_x1_y14_sam_idx
'{idx: '{x: 1, y: 14, port_id: 0}, start_addr: 32'h1c000000, end_addr: 32'h1c100000},// magia_tile_x0_y14_sam_idx
'{idx: '{x: 32, y: 13, port_id: 0}, start_addr: 32'h1bf00000, end_addr: 32'h1c000000},// magia_tile_x31_y13_sam_idx
'{idx: '{x: 31, y: 13, port_id: 0}, start_addr: 32'h1be00000, end_addr: 32'h1bf00000},// magia_tile_x30_y13_sam_idx
'{idx: '{x: 30, y: 13, port_id: 0}, start_addr: 32'h1bd00000, end_addr: 32'h1be00000},// magia_tile_x29_y13_sam_idx
'{idx: '{x: 29, y: 13, port_id: 0}, start_addr: 32'h1bc00000, end_addr: 32'h1bd00000},// magia_tile_x28_y13_sam_idx
'{idx: '{x: 28, y: 13, port_id: 0}, start_addr: 32'h1bb00000, end_addr: 32'h1bc00000},// magia_tile_x27_y13_sam_idx
'{idx: '{x: 27, y: 13, port_id: 0}, start_addr: 32'h1ba00000, end_addr: 32'h1bb00000},// magia_tile_x26_y13_sam_idx
'{idx: '{x: 26, y: 13, port_id: 0}, start_addr: 32'h1b900000, end_addr: 32'h1ba00000},// magia_tile_x25_y13_sam_idx
'{idx: '{x: 25, y: 13, port_id: 0}, start_addr: 32'h1b800000, end_addr: 32'h1b900000},// magia_tile_x24_y13_sam_idx
'{idx: '{x: 24, y: 13, port_id: 0}, start_addr: 32'h1b700000, end_addr: 32'h1b800000},// magia_tile_x23_y13_sam_idx
'{idx: '{x: 23, y: 13, port_id: 0}, start_addr: 32'h1b600000, end_addr: 32'h1b700000},// magia_tile_x22_y13_sam_idx
'{idx: '{x: 22, y: 13, port_id: 0}, start_addr: 32'h1b500000, end_addr: 32'h1b600000},// magia_tile_x21_y13_sam_idx
'{idx: '{x: 21, y: 13, port_id: 0}, start_addr: 32'h1b400000, end_addr: 32'h1b500000},// magia_tile_x20_y13_sam_idx
'{idx: '{x: 20, y: 13, port_id: 0}, start_addr: 32'h1b300000, end_addr: 32'h1b400000},// magia_tile_x19_y13_sam_idx
'{idx: '{x: 19, y: 13, port_id: 0}, start_addr: 32'h1b200000, end_addr: 32'h1b300000},// magia_tile_x18_y13_sam_idx
'{idx: '{x: 18, y: 13, port_id: 0}, start_addr: 32'h1b100000, end_addr: 32'h1b200000},// magia_tile_x17_y13_sam_idx
'{idx: '{x: 17, y: 13, port_id: 0}, start_addr: 32'h1b000000, end_addr: 32'h1b100000},// magia_tile_x16_y13_sam_idx
'{idx: '{x: 16, y: 13, port_id: 0}, start_addr: 32'h1af00000, end_addr: 32'h1b000000},// magia_tile_x15_y13_sam_idx
'{idx: '{x: 15, y: 13, port_id: 0}, start_addr: 32'h1ae00000, end_addr: 32'h1af00000},// magia_tile_x14_y13_sam_idx
'{idx: '{x: 14, y: 13, port_id: 0}, start_addr: 32'h1ad00000, end_addr: 32'h1ae00000},// magia_tile_x13_y13_sam_idx
'{idx: '{x: 13, y: 13, port_id: 0}, start_addr: 32'h1ac00000, end_addr: 32'h1ad00000},// magia_tile_x12_y13_sam_idx
'{idx: '{x: 12, y: 13, port_id: 0}, start_addr: 32'h1ab00000, end_addr: 32'h1ac00000},// magia_tile_x11_y13_sam_idx
'{idx: '{x: 11, y: 13, port_id: 0}, start_addr: 32'h1aa00000, end_addr: 32'h1ab00000},// magia_tile_x10_y13_sam_idx
'{idx: '{x: 10, y: 13, port_id: 0}, start_addr: 32'h1a900000, end_addr: 32'h1aa00000},// magia_tile_x9_y13_sam_idx
'{idx: '{x: 9, y: 13, port_id: 0}, start_addr: 32'h1a800000, end_addr: 32'h1a900000},// magia_tile_x8_y13_sam_idx
'{idx: '{x: 8, y: 13, port_id: 0}, start_addr: 32'h1a700000, end_addr: 32'h1a800000},// magia_tile_x7_y13_sam_idx
'{idx: '{x: 7, y: 13, port_id: 0}, start_addr: 32'h1a600000, end_addr: 32'h1a700000},// magia_tile_x6_y13_sam_idx
'{idx: '{x: 6, y: 13, port_id: 0}, start_addr: 32'h1a500000, end_addr: 32'h1a600000},// magia_tile_x5_y13_sam_idx
'{idx: '{x: 5, y: 13, port_id: 0}, start_addr: 32'h1a400000, end_addr: 32'h1a500000},// magia_tile_x4_y13_sam_idx
'{idx: '{x: 4, y: 13, port_id: 0}, start_addr: 32'h1a300000, end_addr: 32'h1a400000},// magia_tile_x3_y13_sam_idx
'{idx: '{x: 3, y: 13, port_id: 0}, start_addr: 32'h1a200000, end_addr: 32'h1a300000},// magia_tile_x2_y13_sam_idx
'{idx: '{x: 2, y: 13, port_id: 0}, start_addr: 32'h1a100000, end_addr: 32'h1a200000},// magia_tile_x1_y13_sam_idx
'{idx: '{x: 1, y: 13, port_id: 0}, start_addr: 32'h1a000000, end_addr: 32'h1a100000},// magia_tile_x0_y13_sam_idx
'{idx: '{x: 32, y: 12, port_id: 0}, start_addr: 32'h19f00000, end_addr: 32'h1a000000},// magia_tile_x31_y12_sam_idx
'{idx: '{x: 31, y: 12, port_id: 0}, start_addr: 32'h19e00000, end_addr: 32'h19f00000},// magia_tile_x30_y12_sam_idx
'{idx: '{x: 30, y: 12, port_id: 0}, start_addr: 32'h19d00000, end_addr: 32'h19e00000},// magia_tile_x29_y12_sam_idx
'{idx: '{x: 29, y: 12, port_id: 0}, start_addr: 32'h19c00000, end_addr: 32'h19d00000},// magia_tile_x28_y12_sam_idx
'{idx: '{x: 28, y: 12, port_id: 0}, start_addr: 32'h19b00000, end_addr: 32'h19c00000},// magia_tile_x27_y12_sam_idx
'{idx: '{x: 27, y: 12, port_id: 0}, start_addr: 32'h19a00000, end_addr: 32'h19b00000},// magia_tile_x26_y12_sam_idx
'{idx: '{x: 26, y: 12, port_id: 0}, start_addr: 32'h19900000, end_addr: 32'h19a00000},// magia_tile_x25_y12_sam_idx
'{idx: '{x: 25, y: 12, port_id: 0}, start_addr: 32'h19800000, end_addr: 32'h19900000},// magia_tile_x24_y12_sam_idx
'{idx: '{x: 24, y: 12, port_id: 0}, start_addr: 32'h19700000, end_addr: 32'h19800000},// magia_tile_x23_y12_sam_idx
'{idx: '{x: 23, y: 12, port_id: 0}, start_addr: 32'h19600000, end_addr: 32'h19700000},// magia_tile_x22_y12_sam_idx
'{idx: '{x: 22, y: 12, port_id: 0}, start_addr: 32'h19500000, end_addr: 32'h19600000},// magia_tile_x21_y12_sam_idx
'{idx: '{x: 21, y: 12, port_id: 0}, start_addr: 32'h19400000, end_addr: 32'h19500000},// magia_tile_x20_y12_sam_idx
'{idx: '{x: 20, y: 12, port_id: 0}, start_addr: 32'h19300000, end_addr: 32'h19400000},// magia_tile_x19_y12_sam_idx
'{idx: '{x: 19, y: 12, port_id: 0}, start_addr: 32'h19200000, end_addr: 32'h19300000},// magia_tile_x18_y12_sam_idx
'{idx: '{x: 18, y: 12, port_id: 0}, start_addr: 32'h19100000, end_addr: 32'h19200000},// magia_tile_x17_y12_sam_idx
'{idx: '{x: 17, y: 12, port_id: 0}, start_addr: 32'h19000000, end_addr: 32'h19100000},// magia_tile_x16_y12_sam_idx
'{idx: '{x: 16, y: 12, port_id: 0}, start_addr: 32'h18f00000, end_addr: 32'h19000000},// magia_tile_x15_y12_sam_idx
'{idx: '{x: 15, y: 12, port_id: 0}, start_addr: 32'h18e00000, end_addr: 32'h18f00000},// magia_tile_x14_y12_sam_idx
'{idx: '{x: 14, y: 12, port_id: 0}, start_addr: 32'h18d00000, end_addr: 32'h18e00000},// magia_tile_x13_y12_sam_idx
'{idx: '{x: 13, y: 12, port_id: 0}, start_addr: 32'h18c00000, end_addr: 32'h18d00000},// magia_tile_x12_y12_sam_idx
'{idx: '{x: 12, y: 12, port_id: 0}, start_addr: 32'h18b00000, end_addr: 32'h18c00000},// magia_tile_x11_y12_sam_idx
'{idx: '{x: 11, y: 12, port_id: 0}, start_addr: 32'h18a00000, end_addr: 32'h18b00000},// magia_tile_x10_y12_sam_idx
'{idx: '{x: 10, y: 12, port_id: 0}, start_addr: 32'h18900000, end_addr: 32'h18a00000},// magia_tile_x9_y12_sam_idx
'{idx: '{x: 9, y: 12, port_id: 0}, start_addr: 32'h18800000, end_addr: 32'h18900000},// magia_tile_x8_y12_sam_idx
'{idx: '{x: 8, y: 12, port_id: 0}, start_addr: 32'h18700000, end_addr: 32'h18800000},// magia_tile_x7_y12_sam_idx
'{idx: '{x: 7, y: 12, port_id: 0}, start_addr: 32'h18600000, end_addr: 32'h18700000},// magia_tile_x6_y12_sam_idx
'{idx: '{x: 6, y: 12, port_id: 0}, start_addr: 32'h18500000, end_addr: 32'h18600000},// magia_tile_x5_y12_sam_idx
'{idx: '{x: 5, y: 12, port_id: 0}, start_addr: 32'h18400000, end_addr: 32'h18500000},// magia_tile_x4_y12_sam_idx
'{idx: '{x: 4, y: 12, port_id: 0}, start_addr: 32'h18300000, end_addr: 32'h18400000},// magia_tile_x3_y12_sam_idx
'{idx: '{x: 3, y: 12, port_id: 0}, start_addr: 32'h18200000, end_addr: 32'h18300000},// magia_tile_x2_y12_sam_idx
'{idx: '{x: 2, y: 12, port_id: 0}, start_addr: 32'h18100000, end_addr: 32'h18200000},// magia_tile_x1_y12_sam_idx
'{idx: '{x: 1, y: 12, port_id: 0}, start_addr: 32'h18000000, end_addr: 32'h18100000},// magia_tile_x0_y12_sam_idx
'{idx: '{x: 32, y: 11, port_id: 0}, start_addr: 32'h17f00000, end_addr: 32'h18000000},// magia_tile_x31_y11_sam_idx
'{idx: '{x: 31, y: 11, port_id: 0}, start_addr: 32'h17e00000, end_addr: 32'h17f00000},// magia_tile_x30_y11_sam_idx
'{idx: '{x: 30, y: 11, port_id: 0}, start_addr: 32'h17d00000, end_addr: 32'h17e00000},// magia_tile_x29_y11_sam_idx
'{idx: '{x: 29, y: 11, port_id: 0}, start_addr: 32'h17c00000, end_addr: 32'h17d00000},// magia_tile_x28_y11_sam_idx
'{idx: '{x: 28, y: 11, port_id: 0}, start_addr: 32'h17b00000, end_addr: 32'h17c00000},// magia_tile_x27_y11_sam_idx
'{idx: '{x: 27, y: 11, port_id: 0}, start_addr: 32'h17a00000, end_addr: 32'h17b00000},// magia_tile_x26_y11_sam_idx
'{idx: '{x: 26, y: 11, port_id: 0}, start_addr: 32'h17900000, end_addr: 32'h17a00000},// magia_tile_x25_y11_sam_idx
'{idx: '{x: 25, y: 11, port_id: 0}, start_addr: 32'h17800000, end_addr: 32'h17900000},// magia_tile_x24_y11_sam_idx
'{idx: '{x: 24, y: 11, port_id: 0}, start_addr: 32'h17700000, end_addr: 32'h17800000},// magia_tile_x23_y11_sam_idx
'{idx: '{x: 23, y: 11, port_id: 0}, start_addr: 32'h17600000, end_addr: 32'h17700000},// magia_tile_x22_y11_sam_idx
'{idx: '{x: 22, y: 11, port_id: 0}, start_addr: 32'h17500000, end_addr: 32'h17600000},// magia_tile_x21_y11_sam_idx
'{idx: '{x: 21, y: 11, port_id: 0}, start_addr: 32'h17400000, end_addr: 32'h17500000},// magia_tile_x20_y11_sam_idx
'{idx: '{x: 20, y: 11, port_id: 0}, start_addr: 32'h17300000, end_addr: 32'h17400000},// magia_tile_x19_y11_sam_idx
'{idx: '{x: 19, y: 11, port_id: 0}, start_addr: 32'h17200000, end_addr: 32'h17300000},// magia_tile_x18_y11_sam_idx
'{idx: '{x: 18, y: 11, port_id: 0}, start_addr: 32'h17100000, end_addr: 32'h17200000},// magia_tile_x17_y11_sam_idx
'{idx: '{x: 17, y: 11, port_id: 0}, start_addr: 32'h17000000, end_addr: 32'h17100000},// magia_tile_x16_y11_sam_idx
'{idx: '{x: 16, y: 11, port_id: 0}, start_addr: 32'h16f00000, end_addr: 32'h17000000},// magia_tile_x15_y11_sam_idx
'{idx: '{x: 15, y: 11, port_id: 0}, start_addr: 32'h16e00000, end_addr: 32'h16f00000},// magia_tile_x14_y11_sam_idx
'{idx: '{x: 14, y: 11, port_id: 0}, start_addr: 32'h16d00000, end_addr: 32'h16e00000},// magia_tile_x13_y11_sam_idx
'{idx: '{x: 13, y: 11, port_id: 0}, start_addr: 32'h16c00000, end_addr: 32'h16d00000},// magia_tile_x12_y11_sam_idx
'{idx: '{x: 12, y: 11, port_id: 0}, start_addr: 32'h16b00000, end_addr: 32'h16c00000},// magia_tile_x11_y11_sam_idx
'{idx: '{x: 11, y: 11, port_id: 0}, start_addr: 32'h16a00000, end_addr: 32'h16b00000},// magia_tile_x10_y11_sam_idx
'{idx: '{x: 10, y: 11, port_id: 0}, start_addr: 32'h16900000, end_addr: 32'h16a00000},// magia_tile_x9_y11_sam_idx
'{idx: '{x: 9, y: 11, port_id: 0}, start_addr: 32'h16800000, end_addr: 32'h16900000},// magia_tile_x8_y11_sam_idx
'{idx: '{x: 8, y: 11, port_id: 0}, start_addr: 32'h16700000, end_addr: 32'h16800000},// magia_tile_x7_y11_sam_idx
'{idx: '{x: 7, y: 11, port_id: 0}, start_addr: 32'h16600000, end_addr: 32'h16700000},// magia_tile_x6_y11_sam_idx
'{idx: '{x: 6, y: 11, port_id: 0}, start_addr: 32'h16500000, end_addr: 32'h16600000},// magia_tile_x5_y11_sam_idx
'{idx: '{x: 5, y: 11, port_id: 0}, start_addr: 32'h16400000, end_addr: 32'h16500000},// magia_tile_x4_y11_sam_idx
'{idx: '{x: 4, y: 11, port_id: 0}, start_addr: 32'h16300000, end_addr: 32'h16400000},// magia_tile_x3_y11_sam_idx
'{idx: '{x: 3, y: 11, port_id: 0}, start_addr: 32'h16200000, end_addr: 32'h16300000},// magia_tile_x2_y11_sam_idx
'{idx: '{x: 2, y: 11, port_id: 0}, start_addr: 32'h16100000, end_addr: 32'h16200000},// magia_tile_x1_y11_sam_idx
'{idx: '{x: 1, y: 11, port_id: 0}, start_addr: 32'h16000000, end_addr: 32'h16100000},// magia_tile_x0_y11_sam_idx
'{idx: '{x: 32, y: 10, port_id: 0}, start_addr: 32'h15f00000, end_addr: 32'h16000000},// magia_tile_x31_y10_sam_idx
'{idx: '{x: 31, y: 10, port_id: 0}, start_addr: 32'h15e00000, end_addr: 32'h15f00000},// magia_tile_x30_y10_sam_idx
'{idx: '{x: 30, y: 10, port_id: 0}, start_addr: 32'h15d00000, end_addr: 32'h15e00000},// magia_tile_x29_y10_sam_idx
'{idx: '{x: 29, y: 10, port_id: 0}, start_addr: 32'h15c00000, end_addr: 32'h15d00000},// magia_tile_x28_y10_sam_idx
'{idx: '{x: 28, y: 10, port_id: 0}, start_addr: 32'h15b00000, end_addr: 32'h15c00000},// magia_tile_x27_y10_sam_idx
'{idx: '{x: 27, y: 10, port_id: 0}, start_addr: 32'h15a00000, end_addr: 32'h15b00000},// magia_tile_x26_y10_sam_idx
'{idx: '{x: 26, y: 10, port_id: 0}, start_addr: 32'h15900000, end_addr: 32'h15a00000},// magia_tile_x25_y10_sam_idx
'{idx: '{x: 25, y: 10, port_id: 0}, start_addr: 32'h15800000, end_addr: 32'h15900000},// magia_tile_x24_y10_sam_idx
'{idx: '{x: 24, y: 10, port_id: 0}, start_addr: 32'h15700000, end_addr: 32'h15800000},// magia_tile_x23_y10_sam_idx
'{idx: '{x: 23, y: 10, port_id: 0}, start_addr: 32'h15600000, end_addr: 32'h15700000},// magia_tile_x22_y10_sam_idx
'{idx: '{x: 22, y: 10, port_id: 0}, start_addr: 32'h15500000, end_addr: 32'h15600000},// magia_tile_x21_y10_sam_idx
'{idx: '{x: 21, y: 10, port_id: 0}, start_addr: 32'h15400000, end_addr: 32'h15500000},// magia_tile_x20_y10_sam_idx
'{idx: '{x: 20, y: 10, port_id: 0}, start_addr: 32'h15300000, end_addr: 32'h15400000},// magia_tile_x19_y10_sam_idx
'{idx: '{x: 19, y: 10, port_id: 0}, start_addr: 32'h15200000, end_addr: 32'h15300000},// magia_tile_x18_y10_sam_idx
'{idx: '{x: 18, y: 10, port_id: 0}, start_addr: 32'h15100000, end_addr: 32'h15200000},// magia_tile_x17_y10_sam_idx
'{idx: '{x: 17, y: 10, port_id: 0}, start_addr: 32'h15000000, end_addr: 32'h15100000},// magia_tile_x16_y10_sam_idx
'{idx: '{x: 16, y: 10, port_id: 0}, start_addr: 32'h14f00000, end_addr: 32'h15000000},// magia_tile_x15_y10_sam_idx
'{idx: '{x: 15, y: 10, port_id: 0}, start_addr: 32'h14e00000, end_addr: 32'h14f00000},// magia_tile_x14_y10_sam_idx
'{idx: '{x: 14, y: 10, port_id: 0}, start_addr: 32'h14d00000, end_addr: 32'h14e00000},// magia_tile_x13_y10_sam_idx
'{idx: '{x: 13, y: 10, port_id: 0}, start_addr: 32'h14c00000, end_addr: 32'h14d00000},// magia_tile_x12_y10_sam_idx
'{idx: '{x: 12, y: 10, port_id: 0}, start_addr: 32'h14b00000, end_addr: 32'h14c00000},// magia_tile_x11_y10_sam_idx
'{idx: '{x: 11, y: 10, port_id: 0}, start_addr: 32'h14a00000, end_addr: 32'h14b00000},// magia_tile_x10_y10_sam_idx
'{idx: '{x: 10, y: 10, port_id: 0}, start_addr: 32'h14900000, end_addr: 32'h14a00000},// magia_tile_x9_y10_sam_idx
'{idx: '{x: 9, y: 10, port_id: 0}, start_addr: 32'h14800000, end_addr: 32'h14900000},// magia_tile_x8_y10_sam_idx
'{idx: '{x: 8, y: 10, port_id: 0}, start_addr: 32'h14700000, end_addr: 32'h14800000},// magia_tile_x7_y10_sam_idx
'{idx: '{x: 7, y: 10, port_id: 0}, start_addr: 32'h14600000, end_addr: 32'h14700000},// magia_tile_x6_y10_sam_idx
'{idx: '{x: 6, y: 10, port_id: 0}, start_addr: 32'h14500000, end_addr: 32'h14600000},// magia_tile_x5_y10_sam_idx
'{idx: '{x: 5, y: 10, port_id: 0}, start_addr: 32'h14400000, end_addr: 32'h14500000},// magia_tile_x4_y10_sam_idx
'{idx: '{x: 4, y: 10, port_id: 0}, start_addr: 32'h14300000, end_addr: 32'h14400000},// magia_tile_x3_y10_sam_idx
'{idx: '{x: 3, y: 10, port_id: 0}, start_addr: 32'h14200000, end_addr: 32'h14300000},// magia_tile_x2_y10_sam_idx
'{idx: '{x: 2, y: 10, port_id: 0}, start_addr: 32'h14100000, end_addr: 32'h14200000},// magia_tile_x1_y10_sam_idx
'{idx: '{x: 1, y: 10, port_id: 0}, start_addr: 32'h14000000, end_addr: 32'h14100000},// magia_tile_x0_y10_sam_idx
'{idx: '{x: 32, y: 9, port_id: 0}, start_addr: 32'h13f00000, end_addr: 32'h14000000},// magia_tile_x31_y9_sam_idx
'{idx: '{x: 31, y: 9, port_id: 0}, start_addr: 32'h13e00000, end_addr: 32'h13f00000},// magia_tile_x30_y9_sam_idx
'{idx: '{x: 30, y: 9, port_id: 0}, start_addr: 32'h13d00000, end_addr: 32'h13e00000},// magia_tile_x29_y9_sam_idx
'{idx: '{x: 29, y: 9, port_id: 0}, start_addr: 32'h13c00000, end_addr: 32'h13d00000},// magia_tile_x28_y9_sam_idx
'{idx: '{x: 28, y: 9, port_id: 0}, start_addr: 32'h13b00000, end_addr: 32'h13c00000},// magia_tile_x27_y9_sam_idx
'{idx: '{x: 27, y: 9, port_id: 0}, start_addr: 32'h13a00000, end_addr: 32'h13b00000},// magia_tile_x26_y9_sam_idx
'{idx: '{x: 26, y: 9, port_id: 0}, start_addr: 32'h13900000, end_addr: 32'h13a00000},// magia_tile_x25_y9_sam_idx
'{idx: '{x: 25, y: 9, port_id: 0}, start_addr: 32'h13800000, end_addr: 32'h13900000},// magia_tile_x24_y9_sam_idx
'{idx: '{x: 24, y: 9, port_id: 0}, start_addr: 32'h13700000, end_addr: 32'h13800000},// magia_tile_x23_y9_sam_idx
'{idx: '{x: 23, y: 9, port_id: 0}, start_addr: 32'h13600000, end_addr: 32'h13700000},// magia_tile_x22_y9_sam_idx
'{idx: '{x: 22, y: 9, port_id: 0}, start_addr: 32'h13500000, end_addr: 32'h13600000},// magia_tile_x21_y9_sam_idx
'{idx: '{x: 21, y: 9, port_id: 0}, start_addr: 32'h13400000, end_addr: 32'h13500000},// magia_tile_x20_y9_sam_idx
'{idx: '{x: 20, y: 9, port_id: 0}, start_addr: 32'h13300000, end_addr: 32'h13400000},// magia_tile_x19_y9_sam_idx
'{idx: '{x: 19, y: 9, port_id: 0}, start_addr: 32'h13200000, end_addr: 32'h13300000},// magia_tile_x18_y9_sam_idx
'{idx: '{x: 18, y: 9, port_id: 0}, start_addr: 32'h13100000, end_addr: 32'h13200000},// magia_tile_x17_y9_sam_idx
'{idx: '{x: 17, y: 9, port_id: 0}, start_addr: 32'h13000000, end_addr: 32'h13100000},// magia_tile_x16_y9_sam_idx
'{idx: '{x: 16, y: 9, port_id: 0}, start_addr: 32'h12f00000, end_addr: 32'h13000000},// magia_tile_x15_y9_sam_idx
'{idx: '{x: 15, y: 9, port_id: 0}, start_addr: 32'h12e00000, end_addr: 32'h12f00000},// magia_tile_x14_y9_sam_idx
'{idx: '{x: 14, y: 9, port_id: 0}, start_addr: 32'h12d00000, end_addr: 32'h12e00000},// magia_tile_x13_y9_sam_idx
'{idx: '{x: 13, y: 9, port_id: 0}, start_addr: 32'h12c00000, end_addr: 32'h12d00000},// magia_tile_x12_y9_sam_idx
'{idx: '{x: 12, y: 9, port_id: 0}, start_addr: 32'h12b00000, end_addr: 32'h12c00000},// magia_tile_x11_y9_sam_idx
'{idx: '{x: 11, y: 9, port_id: 0}, start_addr: 32'h12a00000, end_addr: 32'h12b00000},// magia_tile_x10_y9_sam_idx
'{idx: '{x: 10, y: 9, port_id: 0}, start_addr: 32'h12900000, end_addr: 32'h12a00000},// magia_tile_x9_y9_sam_idx
'{idx: '{x: 9, y: 9, port_id: 0}, start_addr: 32'h12800000, end_addr: 32'h12900000},// magia_tile_x8_y9_sam_idx
'{idx: '{x: 8, y: 9, port_id: 0}, start_addr: 32'h12700000, end_addr: 32'h12800000},// magia_tile_x7_y9_sam_idx
'{idx: '{x: 7, y: 9, port_id: 0}, start_addr: 32'h12600000, end_addr: 32'h12700000},// magia_tile_x6_y9_sam_idx
'{idx: '{x: 6, y: 9, port_id: 0}, start_addr: 32'h12500000, end_addr: 32'h12600000},// magia_tile_x5_y9_sam_idx
'{idx: '{x: 5, y: 9, port_id: 0}, start_addr: 32'h12400000, end_addr: 32'h12500000},// magia_tile_x4_y9_sam_idx
'{idx: '{x: 4, y: 9, port_id: 0}, start_addr: 32'h12300000, end_addr: 32'h12400000},// magia_tile_x3_y9_sam_idx
'{idx: '{x: 3, y: 9, port_id: 0}, start_addr: 32'h12200000, end_addr: 32'h12300000},// magia_tile_x2_y9_sam_idx
'{idx: '{x: 2, y: 9, port_id: 0}, start_addr: 32'h12100000, end_addr: 32'h12200000},// magia_tile_x1_y9_sam_idx
'{idx: '{x: 1, y: 9, port_id: 0}, start_addr: 32'h12000000, end_addr: 32'h12100000},// magia_tile_x0_y9_sam_idx
'{idx: '{x: 32, y: 8, port_id: 0}, start_addr: 32'h11f00000, end_addr: 32'h12000000},// magia_tile_x31_y8_sam_idx
'{idx: '{x: 31, y: 8, port_id: 0}, start_addr: 32'h11e00000, end_addr: 32'h11f00000},// magia_tile_x30_y8_sam_idx
'{idx: '{x: 30, y: 8, port_id: 0}, start_addr: 32'h11d00000, end_addr: 32'h11e00000},// magia_tile_x29_y8_sam_idx
'{idx: '{x: 29, y: 8, port_id: 0}, start_addr: 32'h11c00000, end_addr: 32'h11d00000},// magia_tile_x28_y8_sam_idx
'{idx: '{x: 28, y: 8, port_id: 0}, start_addr: 32'h11b00000, end_addr: 32'h11c00000},// magia_tile_x27_y8_sam_idx
'{idx: '{x: 27, y: 8, port_id: 0}, start_addr: 32'h11a00000, end_addr: 32'h11b00000},// magia_tile_x26_y8_sam_idx
'{idx: '{x: 26, y: 8, port_id: 0}, start_addr: 32'h11900000, end_addr: 32'h11a00000},// magia_tile_x25_y8_sam_idx
'{idx: '{x: 25, y: 8, port_id: 0}, start_addr: 32'h11800000, end_addr: 32'h11900000},// magia_tile_x24_y8_sam_idx
'{idx: '{x: 24, y: 8, port_id: 0}, start_addr: 32'h11700000, end_addr: 32'h11800000},// magia_tile_x23_y8_sam_idx
'{idx: '{x: 23, y: 8, port_id: 0}, start_addr: 32'h11600000, end_addr: 32'h11700000},// magia_tile_x22_y8_sam_idx
'{idx: '{x: 22, y: 8, port_id: 0}, start_addr: 32'h11500000, end_addr: 32'h11600000},// magia_tile_x21_y8_sam_idx
'{idx: '{x: 21, y: 8, port_id: 0}, start_addr: 32'h11400000, end_addr: 32'h11500000},// magia_tile_x20_y8_sam_idx
'{idx: '{x: 20, y: 8, port_id: 0}, start_addr: 32'h11300000, end_addr: 32'h11400000},// magia_tile_x19_y8_sam_idx
'{idx: '{x: 19, y: 8, port_id: 0}, start_addr: 32'h11200000, end_addr: 32'h11300000},// magia_tile_x18_y8_sam_idx
'{idx: '{x: 18, y: 8, port_id: 0}, start_addr: 32'h11100000, end_addr: 32'h11200000},// magia_tile_x17_y8_sam_idx
'{idx: '{x: 17, y: 8, port_id: 0}, start_addr: 32'h11000000, end_addr: 32'h11100000},// magia_tile_x16_y8_sam_idx
'{idx: '{x: 16, y: 8, port_id: 0}, start_addr: 32'h10f00000, end_addr: 32'h11000000},// magia_tile_x15_y8_sam_idx
'{idx: '{x: 15, y: 8, port_id: 0}, start_addr: 32'h10e00000, end_addr: 32'h10f00000},// magia_tile_x14_y8_sam_idx
'{idx: '{x: 14, y: 8, port_id: 0}, start_addr: 32'h10d00000, end_addr: 32'h10e00000},// magia_tile_x13_y8_sam_idx
'{idx: '{x: 13, y: 8, port_id: 0}, start_addr: 32'h10c00000, end_addr: 32'h10d00000},// magia_tile_x12_y8_sam_idx
'{idx: '{x: 12, y: 8, port_id: 0}, start_addr: 32'h10b00000, end_addr: 32'h10c00000},// magia_tile_x11_y8_sam_idx
'{idx: '{x: 11, y: 8, port_id: 0}, start_addr: 32'h10a00000, end_addr: 32'h10b00000},// magia_tile_x10_y8_sam_idx
'{idx: '{x: 10, y: 8, port_id: 0}, start_addr: 32'h10900000, end_addr: 32'h10a00000},// magia_tile_x9_y8_sam_idx
'{idx: '{x: 9, y: 8, port_id: 0}, start_addr: 32'h10800000, end_addr: 32'h10900000},// magia_tile_x8_y8_sam_idx
'{idx: '{x: 8, y: 8, port_id: 0}, start_addr: 32'h10700000, end_addr: 32'h10800000},// magia_tile_x7_y8_sam_idx
'{idx: '{x: 7, y: 8, port_id: 0}, start_addr: 32'h10600000, end_addr: 32'h10700000},// magia_tile_x6_y8_sam_idx
'{idx: '{x: 6, y: 8, port_id: 0}, start_addr: 32'h10500000, end_addr: 32'h10600000},// magia_tile_x5_y8_sam_idx
'{idx: '{x: 5, y: 8, port_id: 0}, start_addr: 32'h10400000, end_addr: 32'h10500000},// magia_tile_x4_y8_sam_idx
'{idx: '{x: 4, y: 8, port_id: 0}, start_addr: 32'h10300000, end_addr: 32'h10400000},// magia_tile_x3_y8_sam_idx
'{idx: '{x: 3, y: 8, port_id: 0}, start_addr: 32'h10200000, end_addr: 32'h10300000},// magia_tile_x2_y8_sam_idx
'{idx: '{x: 2, y: 8, port_id: 0}, start_addr: 32'h10100000, end_addr: 32'h10200000},// magia_tile_x1_y8_sam_idx
'{idx: '{x: 1, y: 8, port_id: 0}, start_addr: 32'h10000000, end_addr: 32'h10100000},// magia_tile_x0_y8_sam_idx
'{idx: '{x: 32, y: 7, port_id: 0}, start_addr: 32'h0ff00000, end_addr: 32'h10000000},// magia_tile_x31_y7_sam_idx
'{idx: '{x: 31, y: 7, port_id: 0}, start_addr: 32'h0fe00000, end_addr: 32'h0ff00000},// magia_tile_x30_y7_sam_idx
'{idx: '{x: 30, y: 7, port_id: 0}, start_addr: 32'h0fd00000, end_addr: 32'h0fe00000},// magia_tile_x29_y7_sam_idx
'{idx: '{x: 29, y: 7, port_id: 0}, start_addr: 32'h0fc00000, end_addr: 32'h0fd00000},// magia_tile_x28_y7_sam_idx
'{idx: '{x: 28, y: 7, port_id: 0}, start_addr: 32'h0fb00000, end_addr: 32'h0fc00000},// magia_tile_x27_y7_sam_idx
'{idx: '{x: 27, y: 7, port_id: 0}, start_addr: 32'h0fa00000, end_addr: 32'h0fb00000},// magia_tile_x26_y7_sam_idx
'{idx: '{x: 26, y: 7, port_id: 0}, start_addr: 32'h0f900000, end_addr: 32'h0fa00000},// magia_tile_x25_y7_sam_idx
'{idx: '{x: 25, y: 7, port_id: 0}, start_addr: 32'h0f800000, end_addr: 32'h0f900000},// magia_tile_x24_y7_sam_idx
'{idx: '{x: 24, y: 7, port_id: 0}, start_addr: 32'h0f700000, end_addr: 32'h0f800000},// magia_tile_x23_y7_sam_idx
'{idx: '{x: 23, y: 7, port_id: 0}, start_addr: 32'h0f600000, end_addr: 32'h0f700000},// magia_tile_x22_y7_sam_idx
'{idx: '{x: 22, y: 7, port_id: 0}, start_addr: 32'h0f500000, end_addr: 32'h0f600000},// magia_tile_x21_y7_sam_idx
'{idx: '{x: 21, y: 7, port_id: 0}, start_addr: 32'h0f400000, end_addr: 32'h0f500000},// magia_tile_x20_y7_sam_idx
'{idx: '{x: 20, y: 7, port_id: 0}, start_addr: 32'h0f300000, end_addr: 32'h0f400000},// magia_tile_x19_y7_sam_idx
'{idx: '{x: 19, y: 7, port_id: 0}, start_addr: 32'h0f200000, end_addr: 32'h0f300000},// magia_tile_x18_y7_sam_idx
'{idx: '{x: 18, y: 7, port_id: 0}, start_addr: 32'h0f100000, end_addr: 32'h0f200000},// magia_tile_x17_y7_sam_idx
'{idx: '{x: 17, y: 7, port_id: 0}, start_addr: 32'h0f000000, end_addr: 32'h0f100000},// magia_tile_x16_y7_sam_idx
'{idx: '{x: 16, y: 7, port_id: 0}, start_addr: 32'h0ef00000, end_addr: 32'h0f000000},// magia_tile_x15_y7_sam_idx
'{idx: '{x: 15, y: 7, port_id: 0}, start_addr: 32'h0ee00000, end_addr: 32'h0ef00000},// magia_tile_x14_y7_sam_idx
'{idx: '{x: 14, y: 7, port_id: 0}, start_addr: 32'h0ed00000, end_addr: 32'h0ee00000},// magia_tile_x13_y7_sam_idx
'{idx: '{x: 13, y: 7, port_id: 0}, start_addr: 32'h0ec00000, end_addr: 32'h0ed00000},// magia_tile_x12_y7_sam_idx
'{idx: '{x: 12, y: 7, port_id: 0}, start_addr: 32'h0eb00000, end_addr: 32'h0ec00000},// magia_tile_x11_y7_sam_idx
'{idx: '{x: 11, y: 7, port_id: 0}, start_addr: 32'h0ea00000, end_addr: 32'h0eb00000},// magia_tile_x10_y7_sam_idx
'{idx: '{x: 10, y: 7, port_id: 0}, start_addr: 32'h0e900000, end_addr: 32'h0ea00000},// magia_tile_x9_y7_sam_idx
'{idx: '{x: 9, y: 7, port_id: 0}, start_addr: 32'h0e800000, end_addr: 32'h0e900000},// magia_tile_x8_y7_sam_idx
'{idx: '{x: 8, y: 7, port_id: 0}, start_addr: 32'h0e700000, end_addr: 32'h0e800000},// magia_tile_x7_y7_sam_idx
'{idx: '{x: 7, y: 7, port_id: 0}, start_addr: 32'h0e600000, end_addr: 32'h0e700000},// magia_tile_x6_y7_sam_idx
'{idx: '{x: 6, y: 7, port_id: 0}, start_addr: 32'h0e500000, end_addr: 32'h0e600000},// magia_tile_x5_y7_sam_idx
'{idx: '{x: 5, y: 7, port_id: 0}, start_addr: 32'h0e400000, end_addr: 32'h0e500000},// magia_tile_x4_y7_sam_idx
'{idx: '{x: 4, y: 7, port_id: 0}, start_addr: 32'h0e300000, end_addr: 32'h0e400000},// magia_tile_x3_y7_sam_idx
'{idx: '{x: 3, y: 7, port_id: 0}, start_addr: 32'h0e200000, end_addr: 32'h0e300000},// magia_tile_x2_y7_sam_idx
'{idx: '{x: 2, y: 7, port_id: 0}, start_addr: 32'h0e100000, end_addr: 32'h0e200000},// magia_tile_x1_y7_sam_idx
'{idx: '{x: 1, y: 7, port_id: 0}, start_addr: 32'h0e000000, end_addr: 32'h0e100000},// magia_tile_x0_y7_sam_idx
'{idx: '{x: 32, y: 6, port_id: 0}, start_addr: 32'h0df00000, end_addr: 32'h0e000000},// magia_tile_x31_y6_sam_idx
'{idx: '{x: 31, y: 6, port_id: 0}, start_addr: 32'h0de00000, end_addr: 32'h0df00000},// magia_tile_x30_y6_sam_idx
'{idx: '{x: 30, y: 6, port_id: 0}, start_addr: 32'h0dd00000, end_addr: 32'h0de00000},// magia_tile_x29_y6_sam_idx
'{idx: '{x: 29, y: 6, port_id: 0}, start_addr: 32'h0dc00000, end_addr: 32'h0dd00000},// magia_tile_x28_y6_sam_idx
'{idx: '{x: 28, y: 6, port_id: 0}, start_addr: 32'h0db00000, end_addr: 32'h0dc00000},// magia_tile_x27_y6_sam_idx
'{idx: '{x: 27, y: 6, port_id: 0}, start_addr: 32'h0da00000, end_addr: 32'h0db00000},// magia_tile_x26_y6_sam_idx
'{idx: '{x: 26, y: 6, port_id: 0}, start_addr: 32'h0d900000, end_addr: 32'h0da00000},// magia_tile_x25_y6_sam_idx
'{idx: '{x: 25, y: 6, port_id: 0}, start_addr: 32'h0d800000, end_addr: 32'h0d900000},// magia_tile_x24_y6_sam_idx
'{idx: '{x: 24, y: 6, port_id: 0}, start_addr: 32'h0d700000, end_addr: 32'h0d800000},// magia_tile_x23_y6_sam_idx
'{idx: '{x: 23, y: 6, port_id: 0}, start_addr: 32'h0d600000, end_addr: 32'h0d700000},// magia_tile_x22_y6_sam_idx
'{idx: '{x: 22, y: 6, port_id: 0}, start_addr: 32'h0d500000, end_addr: 32'h0d600000},// magia_tile_x21_y6_sam_idx
'{idx: '{x: 21, y: 6, port_id: 0}, start_addr: 32'h0d400000, end_addr: 32'h0d500000},// magia_tile_x20_y6_sam_idx
'{idx: '{x: 20, y: 6, port_id: 0}, start_addr: 32'h0d300000, end_addr: 32'h0d400000},// magia_tile_x19_y6_sam_idx
'{idx: '{x: 19, y: 6, port_id: 0}, start_addr: 32'h0d200000, end_addr: 32'h0d300000},// magia_tile_x18_y6_sam_idx
'{idx: '{x: 18, y: 6, port_id: 0}, start_addr: 32'h0d100000, end_addr: 32'h0d200000},// magia_tile_x17_y6_sam_idx
'{idx: '{x: 17, y: 6, port_id: 0}, start_addr: 32'h0d000000, end_addr: 32'h0d100000},// magia_tile_x16_y6_sam_idx
'{idx: '{x: 16, y: 6, port_id: 0}, start_addr: 32'h0cf00000, end_addr: 32'h0d000000},// magia_tile_x15_y6_sam_idx
'{idx: '{x: 15, y: 6, port_id: 0}, start_addr: 32'h0ce00000, end_addr: 32'h0cf00000},// magia_tile_x14_y6_sam_idx
'{idx: '{x: 14, y: 6, port_id: 0}, start_addr: 32'h0cd00000, end_addr: 32'h0ce00000},// magia_tile_x13_y6_sam_idx
'{idx: '{x: 13, y: 6, port_id: 0}, start_addr: 32'h0cc00000, end_addr: 32'h0cd00000},// magia_tile_x12_y6_sam_idx
'{idx: '{x: 12, y: 6, port_id: 0}, start_addr: 32'h0cb00000, end_addr: 32'h0cc00000},// magia_tile_x11_y6_sam_idx
'{idx: '{x: 11, y: 6, port_id: 0}, start_addr: 32'h0ca00000, end_addr: 32'h0cb00000},// magia_tile_x10_y6_sam_idx
'{idx: '{x: 10, y: 6, port_id: 0}, start_addr: 32'h0c900000, end_addr: 32'h0ca00000},// magia_tile_x9_y6_sam_idx
'{idx: '{x: 9, y: 6, port_id: 0}, start_addr: 32'h0c800000, end_addr: 32'h0c900000},// magia_tile_x8_y6_sam_idx
'{idx: '{x: 8, y: 6, port_id: 0}, start_addr: 32'h0c700000, end_addr: 32'h0c800000},// magia_tile_x7_y6_sam_idx
'{idx: '{x: 7, y: 6, port_id: 0}, start_addr: 32'h0c600000, end_addr: 32'h0c700000},// magia_tile_x6_y6_sam_idx
'{idx: '{x: 6, y: 6, port_id: 0}, start_addr: 32'h0c500000, end_addr: 32'h0c600000},// magia_tile_x5_y6_sam_idx
'{idx: '{x: 5, y: 6, port_id: 0}, start_addr: 32'h0c400000, end_addr: 32'h0c500000},// magia_tile_x4_y6_sam_idx
'{idx: '{x: 4, y: 6, port_id: 0}, start_addr: 32'h0c300000, end_addr: 32'h0c400000},// magia_tile_x3_y6_sam_idx
'{idx: '{x: 3, y: 6, port_id: 0}, start_addr: 32'h0c200000, end_addr: 32'h0c300000},// magia_tile_x2_y6_sam_idx
'{idx: '{x: 2, y: 6, port_id: 0}, start_addr: 32'h0c100000, end_addr: 32'h0c200000},// magia_tile_x1_y6_sam_idx
'{idx: '{x: 1, y: 6, port_id: 0}, start_addr: 32'h0c000000, end_addr: 32'h0c100000},// magia_tile_x0_y6_sam_idx
'{idx: '{x: 32, y: 5, port_id: 0}, start_addr: 32'h0bf00000, end_addr: 32'h0c000000},// magia_tile_x31_y5_sam_idx
'{idx: '{x: 31, y: 5, port_id: 0}, start_addr: 32'h0be00000, end_addr: 32'h0bf00000},// magia_tile_x30_y5_sam_idx
'{idx: '{x: 30, y: 5, port_id: 0}, start_addr: 32'h0bd00000, end_addr: 32'h0be00000},// magia_tile_x29_y5_sam_idx
'{idx: '{x: 29, y: 5, port_id: 0}, start_addr: 32'h0bc00000, end_addr: 32'h0bd00000},// magia_tile_x28_y5_sam_idx
'{idx: '{x: 28, y: 5, port_id: 0}, start_addr: 32'h0bb00000, end_addr: 32'h0bc00000},// magia_tile_x27_y5_sam_idx
'{idx: '{x: 27, y: 5, port_id: 0}, start_addr: 32'h0ba00000, end_addr: 32'h0bb00000},// magia_tile_x26_y5_sam_idx
'{idx: '{x: 26, y: 5, port_id: 0}, start_addr: 32'h0b900000, end_addr: 32'h0ba00000},// magia_tile_x25_y5_sam_idx
'{idx: '{x: 25, y: 5, port_id: 0}, start_addr: 32'h0b800000, end_addr: 32'h0b900000},// magia_tile_x24_y5_sam_idx
'{idx: '{x: 24, y: 5, port_id: 0}, start_addr: 32'h0b700000, end_addr: 32'h0b800000},// magia_tile_x23_y5_sam_idx
'{idx: '{x: 23, y: 5, port_id: 0}, start_addr: 32'h0b600000, end_addr: 32'h0b700000},// magia_tile_x22_y5_sam_idx
'{idx: '{x: 22, y: 5, port_id: 0}, start_addr: 32'h0b500000, end_addr: 32'h0b600000},// magia_tile_x21_y5_sam_idx
'{idx: '{x: 21, y: 5, port_id: 0}, start_addr: 32'h0b400000, end_addr: 32'h0b500000},// magia_tile_x20_y5_sam_idx
'{idx: '{x: 20, y: 5, port_id: 0}, start_addr: 32'h0b300000, end_addr: 32'h0b400000},// magia_tile_x19_y5_sam_idx
'{idx: '{x: 19, y: 5, port_id: 0}, start_addr: 32'h0b200000, end_addr: 32'h0b300000},// magia_tile_x18_y5_sam_idx
'{idx: '{x: 18, y: 5, port_id: 0}, start_addr: 32'h0b100000, end_addr: 32'h0b200000},// magia_tile_x17_y5_sam_idx
'{idx: '{x: 17, y: 5, port_id: 0}, start_addr: 32'h0b000000, end_addr: 32'h0b100000},// magia_tile_x16_y5_sam_idx
'{idx: '{x: 16, y: 5, port_id: 0}, start_addr: 32'h0af00000, end_addr: 32'h0b000000},// magia_tile_x15_y5_sam_idx
'{idx: '{x: 15, y: 5, port_id: 0}, start_addr: 32'h0ae00000, end_addr: 32'h0af00000},// magia_tile_x14_y5_sam_idx
'{idx: '{x: 14, y: 5, port_id: 0}, start_addr: 32'h0ad00000, end_addr: 32'h0ae00000},// magia_tile_x13_y5_sam_idx
'{idx: '{x: 13, y: 5, port_id: 0}, start_addr: 32'h0ac00000, end_addr: 32'h0ad00000},// magia_tile_x12_y5_sam_idx
'{idx: '{x: 12, y: 5, port_id: 0}, start_addr: 32'h0ab00000, end_addr: 32'h0ac00000},// magia_tile_x11_y5_sam_idx
'{idx: '{x: 11, y: 5, port_id: 0}, start_addr: 32'h0aa00000, end_addr: 32'h0ab00000},// magia_tile_x10_y5_sam_idx
'{idx: '{x: 10, y: 5, port_id: 0}, start_addr: 32'h0a900000, end_addr: 32'h0aa00000},// magia_tile_x9_y5_sam_idx
'{idx: '{x: 9, y: 5, port_id: 0}, start_addr: 32'h0a800000, end_addr: 32'h0a900000},// magia_tile_x8_y5_sam_idx
'{idx: '{x: 8, y: 5, port_id: 0}, start_addr: 32'h0a700000, end_addr: 32'h0a800000},// magia_tile_x7_y5_sam_idx
'{idx: '{x: 7, y: 5, port_id: 0}, start_addr: 32'h0a600000, end_addr: 32'h0a700000},// magia_tile_x6_y5_sam_idx
'{idx: '{x: 6, y: 5, port_id: 0}, start_addr: 32'h0a500000, end_addr: 32'h0a600000},// magia_tile_x5_y5_sam_idx
'{idx: '{x: 5, y: 5, port_id: 0}, start_addr: 32'h0a400000, end_addr: 32'h0a500000},// magia_tile_x4_y5_sam_idx
'{idx: '{x: 4, y: 5, port_id: 0}, start_addr: 32'h0a300000, end_addr: 32'h0a400000},// magia_tile_x3_y5_sam_idx
'{idx: '{x: 3, y: 5, port_id: 0}, start_addr: 32'h0a200000, end_addr: 32'h0a300000},// magia_tile_x2_y5_sam_idx
'{idx: '{x: 2, y: 5, port_id: 0}, start_addr: 32'h0a100000, end_addr: 32'h0a200000},// magia_tile_x1_y5_sam_idx
'{idx: '{x: 1, y: 5, port_id: 0}, start_addr: 32'h0a000000, end_addr: 32'h0a100000},// magia_tile_x0_y5_sam_idx
'{idx: '{x: 32, y: 4, port_id: 0}, start_addr: 32'h09f00000, end_addr: 32'h0a000000},// magia_tile_x31_y4_sam_idx
'{idx: '{x: 31, y: 4, port_id: 0}, start_addr: 32'h09e00000, end_addr: 32'h09f00000},// magia_tile_x30_y4_sam_idx
'{idx: '{x: 30, y: 4, port_id: 0}, start_addr: 32'h09d00000, end_addr: 32'h09e00000},// magia_tile_x29_y4_sam_idx
'{idx: '{x: 29, y: 4, port_id: 0}, start_addr: 32'h09c00000, end_addr: 32'h09d00000},// magia_tile_x28_y4_sam_idx
'{idx: '{x: 28, y: 4, port_id: 0}, start_addr: 32'h09b00000, end_addr: 32'h09c00000},// magia_tile_x27_y4_sam_idx
'{idx: '{x: 27, y: 4, port_id: 0}, start_addr: 32'h09a00000, end_addr: 32'h09b00000},// magia_tile_x26_y4_sam_idx
'{idx: '{x: 26, y: 4, port_id: 0}, start_addr: 32'h09900000, end_addr: 32'h09a00000},// magia_tile_x25_y4_sam_idx
'{idx: '{x: 25, y: 4, port_id: 0}, start_addr: 32'h09800000, end_addr: 32'h09900000},// magia_tile_x24_y4_sam_idx
'{idx: '{x: 24, y: 4, port_id: 0}, start_addr: 32'h09700000, end_addr: 32'h09800000},// magia_tile_x23_y4_sam_idx
'{idx: '{x: 23, y: 4, port_id: 0}, start_addr: 32'h09600000, end_addr: 32'h09700000},// magia_tile_x22_y4_sam_idx
'{idx: '{x: 22, y: 4, port_id: 0}, start_addr: 32'h09500000, end_addr: 32'h09600000},// magia_tile_x21_y4_sam_idx
'{idx: '{x: 21, y: 4, port_id: 0}, start_addr: 32'h09400000, end_addr: 32'h09500000},// magia_tile_x20_y4_sam_idx
'{idx: '{x: 20, y: 4, port_id: 0}, start_addr: 32'h09300000, end_addr: 32'h09400000},// magia_tile_x19_y4_sam_idx
'{idx: '{x: 19, y: 4, port_id: 0}, start_addr: 32'h09200000, end_addr: 32'h09300000},// magia_tile_x18_y4_sam_idx
'{idx: '{x: 18, y: 4, port_id: 0}, start_addr: 32'h09100000, end_addr: 32'h09200000},// magia_tile_x17_y4_sam_idx
'{idx: '{x: 17, y: 4, port_id: 0}, start_addr: 32'h09000000, end_addr: 32'h09100000},// magia_tile_x16_y4_sam_idx
'{idx: '{x: 16, y: 4, port_id: 0}, start_addr: 32'h08f00000, end_addr: 32'h09000000},// magia_tile_x15_y4_sam_idx
'{idx: '{x: 15, y: 4, port_id: 0}, start_addr: 32'h08e00000, end_addr: 32'h08f00000},// magia_tile_x14_y4_sam_idx
'{idx: '{x: 14, y: 4, port_id: 0}, start_addr: 32'h08d00000, end_addr: 32'h08e00000},// magia_tile_x13_y4_sam_idx
'{idx: '{x: 13, y: 4, port_id: 0}, start_addr: 32'h08c00000, end_addr: 32'h08d00000},// magia_tile_x12_y4_sam_idx
'{idx: '{x: 12, y: 4, port_id: 0}, start_addr: 32'h08b00000, end_addr: 32'h08c00000},// magia_tile_x11_y4_sam_idx
'{idx: '{x: 11, y: 4, port_id: 0}, start_addr: 32'h08a00000, end_addr: 32'h08b00000},// magia_tile_x10_y4_sam_idx
'{idx: '{x: 10, y: 4, port_id: 0}, start_addr: 32'h08900000, end_addr: 32'h08a00000},// magia_tile_x9_y4_sam_idx
'{idx: '{x: 9, y: 4, port_id: 0}, start_addr: 32'h08800000, end_addr: 32'h08900000},// magia_tile_x8_y4_sam_idx
'{idx: '{x: 8, y: 4, port_id: 0}, start_addr: 32'h08700000, end_addr: 32'h08800000},// magia_tile_x7_y4_sam_idx
'{idx: '{x: 7, y: 4, port_id: 0}, start_addr: 32'h08600000, end_addr: 32'h08700000},// magia_tile_x6_y4_sam_idx
'{idx: '{x: 6, y: 4, port_id: 0}, start_addr: 32'h08500000, end_addr: 32'h08600000},// magia_tile_x5_y4_sam_idx
'{idx: '{x: 5, y: 4, port_id: 0}, start_addr: 32'h08400000, end_addr: 32'h08500000},// magia_tile_x4_y4_sam_idx
'{idx: '{x: 4, y: 4, port_id: 0}, start_addr: 32'h08300000, end_addr: 32'h08400000},// magia_tile_x3_y4_sam_idx
'{idx: '{x: 3, y: 4, port_id: 0}, start_addr: 32'h08200000, end_addr: 32'h08300000},// magia_tile_x2_y4_sam_idx
'{idx: '{x: 2, y: 4, port_id: 0}, start_addr: 32'h08100000, end_addr: 32'h08200000},// magia_tile_x1_y4_sam_idx
'{idx: '{x: 1, y: 4, port_id: 0}, start_addr: 32'h08000000, end_addr: 32'h08100000},// magia_tile_x0_y4_sam_idx
'{idx: '{x: 32, y: 3, port_id: 0}, start_addr: 32'h07f00000, end_addr: 32'h08000000},// magia_tile_x31_y3_sam_idx
'{idx: '{x: 31, y: 3, port_id: 0}, start_addr: 32'h07e00000, end_addr: 32'h07f00000},// magia_tile_x30_y3_sam_idx
'{idx: '{x: 30, y: 3, port_id: 0}, start_addr: 32'h07d00000, end_addr: 32'h07e00000},// magia_tile_x29_y3_sam_idx
'{idx: '{x: 29, y: 3, port_id: 0}, start_addr: 32'h07c00000, end_addr: 32'h07d00000},// magia_tile_x28_y3_sam_idx
'{idx: '{x: 28, y: 3, port_id: 0}, start_addr: 32'h07b00000, end_addr: 32'h07c00000},// magia_tile_x27_y3_sam_idx
'{idx: '{x: 27, y: 3, port_id: 0}, start_addr: 32'h07a00000, end_addr: 32'h07b00000},// magia_tile_x26_y3_sam_idx
'{idx: '{x: 26, y: 3, port_id: 0}, start_addr: 32'h07900000, end_addr: 32'h07a00000},// magia_tile_x25_y3_sam_idx
'{idx: '{x: 25, y: 3, port_id: 0}, start_addr: 32'h07800000, end_addr: 32'h07900000},// magia_tile_x24_y3_sam_idx
'{idx: '{x: 24, y: 3, port_id: 0}, start_addr: 32'h07700000, end_addr: 32'h07800000},// magia_tile_x23_y3_sam_idx
'{idx: '{x: 23, y: 3, port_id: 0}, start_addr: 32'h07600000, end_addr: 32'h07700000},// magia_tile_x22_y3_sam_idx
'{idx: '{x: 22, y: 3, port_id: 0}, start_addr: 32'h07500000, end_addr: 32'h07600000},// magia_tile_x21_y3_sam_idx
'{idx: '{x: 21, y: 3, port_id: 0}, start_addr: 32'h07400000, end_addr: 32'h07500000},// magia_tile_x20_y3_sam_idx
'{idx: '{x: 20, y: 3, port_id: 0}, start_addr: 32'h07300000, end_addr: 32'h07400000},// magia_tile_x19_y3_sam_idx
'{idx: '{x: 19, y: 3, port_id: 0}, start_addr: 32'h07200000, end_addr: 32'h07300000},// magia_tile_x18_y3_sam_idx
'{idx: '{x: 18, y: 3, port_id: 0}, start_addr: 32'h07100000, end_addr: 32'h07200000},// magia_tile_x17_y3_sam_idx
'{idx: '{x: 17, y: 3, port_id: 0}, start_addr: 32'h07000000, end_addr: 32'h07100000},// magia_tile_x16_y3_sam_idx
'{idx: '{x: 16, y: 3, port_id: 0}, start_addr: 32'h06f00000, end_addr: 32'h07000000},// magia_tile_x15_y3_sam_idx
'{idx: '{x: 15, y: 3, port_id: 0}, start_addr: 32'h06e00000, end_addr: 32'h06f00000},// magia_tile_x14_y3_sam_idx
'{idx: '{x: 14, y: 3, port_id: 0}, start_addr: 32'h06d00000, end_addr: 32'h06e00000},// magia_tile_x13_y3_sam_idx
'{idx: '{x: 13, y: 3, port_id: 0}, start_addr: 32'h06c00000, end_addr: 32'h06d00000},// magia_tile_x12_y3_sam_idx
'{idx: '{x: 12, y: 3, port_id: 0}, start_addr: 32'h06b00000, end_addr: 32'h06c00000},// magia_tile_x11_y3_sam_idx
'{idx: '{x: 11, y: 3, port_id: 0}, start_addr: 32'h06a00000, end_addr: 32'h06b00000},// magia_tile_x10_y3_sam_idx
'{idx: '{x: 10, y: 3, port_id: 0}, start_addr: 32'h06900000, end_addr: 32'h06a00000},// magia_tile_x9_y3_sam_idx
'{idx: '{x: 9, y: 3, port_id: 0}, start_addr: 32'h06800000, end_addr: 32'h06900000},// magia_tile_x8_y3_sam_idx
'{idx: '{x: 8, y: 3, port_id: 0}, start_addr: 32'h06700000, end_addr: 32'h06800000},// magia_tile_x7_y3_sam_idx
'{idx: '{x: 7, y: 3, port_id: 0}, start_addr: 32'h06600000, end_addr: 32'h06700000},// magia_tile_x6_y3_sam_idx
'{idx: '{x: 6, y: 3, port_id: 0}, start_addr: 32'h06500000, end_addr: 32'h06600000},// magia_tile_x5_y3_sam_idx
'{idx: '{x: 5, y: 3, port_id: 0}, start_addr: 32'h06400000, end_addr: 32'h06500000},// magia_tile_x4_y3_sam_idx
'{idx: '{x: 4, y: 3, port_id: 0}, start_addr: 32'h06300000, end_addr: 32'h06400000},// magia_tile_x3_y3_sam_idx
'{idx: '{x: 3, y: 3, port_id: 0}, start_addr: 32'h06200000, end_addr: 32'h06300000},// magia_tile_x2_y3_sam_idx
'{idx: '{x: 2, y: 3, port_id: 0}, start_addr: 32'h06100000, end_addr: 32'h06200000},// magia_tile_x1_y3_sam_idx
'{idx: '{x: 1, y: 3, port_id: 0}, start_addr: 32'h06000000, end_addr: 32'h06100000},// magia_tile_x0_y3_sam_idx
'{idx: '{x: 32, y: 2, port_id: 0}, start_addr: 32'h05f00000, end_addr: 32'h06000000},// magia_tile_x31_y2_sam_idx
'{idx: '{x: 31, y: 2, port_id: 0}, start_addr: 32'h05e00000, end_addr: 32'h05f00000},// magia_tile_x30_y2_sam_idx
'{idx: '{x: 30, y: 2, port_id: 0}, start_addr: 32'h05d00000, end_addr: 32'h05e00000},// magia_tile_x29_y2_sam_idx
'{idx: '{x: 29, y: 2, port_id: 0}, start_addr: 32'h05c00000, end_addr: 32'h05d00000},// magia_tile_x28_y2_sam_idx
'{idx: '{x: 28, y: 2, port_id: 0}, start_addr: 32'h05b00000, end_addr: 32'h05c00000},// magia_tile_x27_y2_sam_idx
'{idx: '{x: 27, y: 2, port_id: 0}, start_addr: 32'h05a00000, end_addr: 32'h05b00000},// magia_tile_x26_y2_sam_idx
'{idx: '{x: 26, y: 2, port_id: 0}, start_addr: 32'h05900000, end_addr: 32'h05a00000},// magia_tile_x25_y2_sam_idx
'{idx: '{x: 25, y: 2, port_id: 0}, start_addr: 32'h05800000, end_addr: 32'h05900000},// magia_tile_x24_y2_sam_idx
'{idx: '{x: 24, y: 2, port_id: 0}, start_addr: 32'h05700000, end_addr: 32'h05800000},// magia_tile_x23_y2_sam_idx
'{idx: '{x: 23, y: 2, port_id: 0}, start_addr: 32'h05600000, end_addr: 32'h05700000},// magia_tile_x22_y2_sam_idx
'{idx: '{x: 22, y: 2, port_id: 0}, start_addr: 32'h05500000, end_addr: 32'h05600000},// magia_tile_x21_y2_sam_idx
'{idx: '{x: 21, y: 2, port_id: 0}, start_addr: 32'h05400000, end_addr: 32'h05500000},// magia_tile_x20_y2_sam_idx
'{idx: '{x: 20, y: 2, port_id: 0}, start_addr: 32'h05300000, end_addr: 32'h05400000},// magia_tile_x19_y2_sam_idx
'{idx: '{x: 19, y: 2, port_id: 0}, start_addr: 32'h05200000, end_addr: 32'h05300000},// magia_tile_x18_y2_sam_idx
'{idx: '{x: 18, y: 2, port_id: 0}, start_addr: 32'h05100000, end_addr: 32'h05200000},// magia_tile_x17_y2_sam_idx
'{idx: '{x: 17, y: 2, port_id: 0}, start_addr: 32'h05000000, end_addr: 32'h05100000},// magia_tile_x16_y2_sam_idx
'{idx: '{x: 16, y: 2, port_id: 0}, start_addr: 32'h04f00000, end_addr: 32'h05000000},// magia_tile_x15_y2_sam_idx
'{idx: '{x: 15, y: 2, port_id: 0}, start_addr: 32'h04e00000, end_addr: 32'h04f00000},// magia_tile_x14_y2_sam_idx
'{idx: '{x: 14, y: 2, port_id: 0}, start_addr: 32'h04d00000, end_addr: 32'h04e00000},// magia_tile_x13_y2_sam_idx
'{idx: '{x: 13, y: 2, port_id: 0}, start_addr: 32'h04c00000, end_addr: 32'h04d00000},// magia_tile_x12_y2_sam_idx
'{idx: '{x: 12, y: 2, port_id: 0}, start_addr: 32'h04b00000, end_addr: 32'h04c00000},// magia_tile_x11_y2_sam_idx
'{idx: '{x: 11, y: 2, port_id: 0}, start_addr: 32'h04a00000, end_addr: 32'h04b00000},// magia_tile_x10_y2_sam_idx
'{idx: '{x: 10, y: 2, port_id: 0}, start_addr: 32'h04900000, end_addr: 32'h04a00000},// magia_tile_x9_y2_sam_idx
'{idx: '{x: 9, y: 2, port_id: 0}, start_addr: 32'h04800000, end_addr: 32'h04900000},// magia_tile_x8_y2_sam_idx
'{idx: '{x: 8, y: 2, port_id: 0}, start_addr: 32'h04700000, end_addr: 32'h04800000},// magia_tile_x7_y2_sam_idx
'{idx: '{x: 7, y: 2, port_id: 0}, start_addr: 32'h04600000, end_addr: 32'h04700000},// magia_tile_x6_y2_sam_idx
'{idx: '{x: 6, y: 2, port_id: 0}, start_addr: 32'h04500000, end_addr: 32'h04600000},// magia_tile_x5_y2_sam_idx
'{idx: '{x: 5, y: 2, port_id: 0}, start_addr: 32'h04400000, end_addr: 32'h04500000},// magia_tile_x4_y2_sam_idx
'{idx: '{x: 4, y: 2, port_id: 0}, start_addr: 32'h04300000, end_addr: 32'h04400000},// magia_tile_x3_y2_sam_idx
'{idx: '{x: 3, y: 2, port_id: 0}, start_addr: 32'h04200000, end_addr: 32'h04300000},// magia_tile_x2_y2_sam_idx
'{idx: '{x: 2, y: 2, port_id: 0}, start_addr: 32'h04100000, end_addr: 32'h04200000},// magia_tile_x1_y2_sam_idx
'{idx: '{x: 1, y: 2, port_id: 0}, start_addr: 32'h04000000, end_addr: 32'h04100000},// magia_tile_x0_y2_sam_idx
'{idx: '{x: 32, y: 1, port_id: 0}, start_addr: 32'h03f00000, end_addr: 32'h04000000},// magia_tile_x31_y1_sam_idx
'{idx: '{x: 31, y: 1, port_id: 0}, start_addr: 32'h03e00000, end_addr: 32'h03f00000},// magia_tile_x30_y1_sam_idx
'{idx: '{x: 30, y: 1, port_id: 0}, start_addr: 32'h03d00000, end_addr: 32'h03e00000},// magia_tile_x29_y1_sam_idx
'{idx: '{x: 29, y: 1, port_id: 0}, start_addr: 32'h03c00000, end_addr: 32'h03d00000},// magia_tile_x28_y1_sam_idx
'{idx: '{x: 28, y: 1, port_id: 0}, start_addr: 32'h03b00000, end_addr: 32'h03c00000},// magia_tile_x27_y1_sam_idx
'{idx: '{x: 27, y: 1, port_id: 0}, start_addr: 32'h03a00000, end_addr: 32'h03b00000},// magia_tile_x26_y1_sam_idx
'{idx: '{x: 26, y: 1, port_id: 0}, start_addr: 32'h03900000, end_addr: 32'h03a00000},// magia_tile_x25_y1_sam_idx
'{idx: '{x: 25, y: 1, port_id: 0}, start_addr: 32'h03800000, end_addr: 32'h03900000},// magia_tile_x24_y1_sam_idx
'{idx: '{x: 24, y: 1, port_id: 0}, start_addr: 32'h03700000, end_addr: 32'h03800000},// magia_tile_x23_y1_sam_idx
'{idx: '{x: 23, y: 1, port_id: 0}, start_addr: 32'h03600000, end_addr: 32'h03700000},// magia_tile_x22_y1_sam_idx
'{idx: '{x: 22, y: 1, port_id: 0}, start_addr: 32'h03500000, end_addr: 32'h03600000},// magia_tile_x21_y1_sam_idx
'{idx: '{x: 21, y: 1, port_id: 0}, start_addr: 32'h03400000, end_addr: 32'h03500000},// magia_tile_x20_y1_sam_idx
'{idx: '{x: 20, y: 1, port_id: 0}, start_addr: 32'h03300000, end_addr: 32'h03400000},// magia_tile_x19_y1_sam_idx
'{idx: '{x: 19, y: 1, port_id: 0}, start_addr: 32'h03200000, end_addr: 32'h03300000},// magia_tile_x18_y1_sam_idx
'{idx: '{x: 18, y: 1, port_id: 0}, start_addr: 32'h03100000, end_addr: 32'h03200000},// magia_tile_x17_y1_sam_idx
'{idx: '{x: 17, y: 1, port_id: 0}, start_addr: 32'h03000000, end_addr: 32'h03100000},// magia_tile_x16_y1_sam_idx
'{idx: '{x: 16, y: 1, port_id: 0}, start_addr: 32'h02f00000, end_addr: 32'h03000000},// magia_tile_x15_y1_sam_idx
'{idx: '{x: 15, y: 1, port_id: 0}, start_addr: 32'h02e00000, end_addr: 32'h02f00000},// magia_tile_x14_y1_sam_idx
'{idx: '{x: 14, y: 1, port_id: 0}, start_addr: 32'h02d00000, end_addr: 32'h02e00000},// magia_tile_x13_y1_sam_idx
'{idx: '{x: 13, y: 1, port_id: 0}, start_addr: 32'h02c00000, end_addr: 32'h02d00000},// magia_tile_x12_y1_sam_idx
'{idx: '{x: 12, y: 1, port_id: 0}, start_addr: 32'h02b00000, end_addr: 32'h02c00000},// magia_tile_x11_y1_sam_idx
'{idx: '{x: 11, y: 1, port_id: 0}, start_addr: 32'h02a00000, end_addr: 32'h02b00000},// magia_tile_x10_y1_sam_idx
'{idx: '{x: 10, y: 1, port_id: 0}, start_addr: 32'h02900000, end_addr: 32'h02a00000},// magia_tile_x9_y1_sam_idx
'{idx: '{x: 9, y: 1, port_id: 0}, start_addr: 32'h02800000, end_addr: 32'h02900000},// magia_tile_x8_y1_sam_idx
'{idx: '{x: 8, y: 1, port_id: 0}, start_addr: 32'h02700000, end_addr: 32'h02800000},// magia_tile_x7_y1_sam_idx
'{idx: '{x: 7, y: 1, port_id: 0}, start_addr: 32'h02600000, end_addr: 32'h02700000},// magia_tile_x6_y1_sam_idx
'{idx: '{x: 6, y: 1, port_id: 0}, start_addr: 32'h02500000, end_addr: 32'h02600000},// magia_tile_x5_y1_sam_idx
'{idx: '{x: 5, y: 1, port_id: 0}, start_addr: 32'h02400000, end_addr: 32'h02500000},// magia_tile_x4_y1_sam_idx
'{idx: '{x: 4, y: 1, port_id: 0}, start_addr: 32'h02300000, end_addr: 32'h02400000},// magia_tile_x3_y1_sam_idx
'{idx: '{x: 3, y: 1, port_id: 0}, start_addr: 32'h02200000, end_addr: 32'h02300000},// magia_tile_x2_y1_sam_idx
'{idx: '{x: 2, y: 1, port_id: 0}, start_addr: 32'h02100000, end_addr: 32'h02200000},// magia_tile_x1_y1_sam_idx
'{idx: '{x: 1, y: 1, port_id: 0}, start_addr: 32'h02000000, end_addr: 32'h02100000},// magia_tile_x0_y1_sam_idx
'{idx: '{x: 32, y: 0, port_id: 0}, start_addr: 32'h01f00000, end_addr: 32'h02000000},// magia_tile_x31_y0_sam_idx
'{idx: '{x: 31, y: 0, port_id: 0}, start_addr: 32'h01e00000, end_addr: 32'h01f00000},// magia_tile_x30_y0_sam_idx
'{idx: '{x: 30, y: 0, port_id: 0}, start_addr: 32'h01d00000, end_addr: 32'h01e00000},// magia_tile_x29_y0_sam_idx
'{idx: '{x: 29, y: 0, port_id: 0}, start_addr: 32'h01c00000, end_addr: 32'h01d00000},// magia_tile_x28_y0_sam_idx
'{idx: '{x: 28, y: 0, port_id: 0}, start_addr: 32'h01b00000, end_addr: 32'h01c00000},// magia_tile_x27_y0_sam_idx
'{idx: '{x: 27, y: 0, port_id: 0}, start_addr: 32'h01a00000, end_addr: 32'h01b00000},// magia_tile_x26_y0_sam_idx
'{idx: '{x: 26, y: 0, port_id: 0}, start_addr: 32'h01900000, end_addr: 32'h01a00000},// magia_tile_x25_y0_sam_idx
'{idx: '{x: 25, y: 0, port_id: 0}, start_addr: 32'h01800000, end_addr: 32'h01900000},// magia_tile_x24_y0_sam_idx
'{idx: '{x: 24, y: 0, port_id: 0}, start_addr: 32'h01700000, end_addr: 32'h01800000},// magia_tile_x23_y0_sam_idx
'{idx: '{x: 23, y: 0, port_id: 0}, start_addr: 32'h01600000, end_addr: 32'h01700000},// magia_tile_x22_y0_sam_idx
'{idx: '{x: 22, y: 0, port_id: 0}, start_addr: 32'h01500000, end_addr: 32'h01600000},// magia_tile_x21_y0_sam_idx
'{idx: '{x: 21, y: 0, port_id: 0}, start_addr: 32'h01400000, end_addr: 32'h01500000},// magia_tile_x20_y0_sam_idx
'{idx: '{x: 20, y: 0, port_id: 0}, start_addr: 32'h01300000, end_addr: 32'h01400000},// magia_tile_x19_y0_sam_idx
'{idx: '{x: 19, y: 0, port_id: 0}, start_addr: 32'h01200000, end_addr: 32'h01300000},// magia_tile_x18_y0_sam_idx
'{idx: '{x: 18, y: 0, port_id: 0}, start_addr: 32'h01100000, end_addr: 32'h01200000},// magia_tile_x17_y0_sam_idx
'{idx: '{x: 17, y: 0, port_id: 0}, start_addr: 32'h01000000, end_addr: 32'h01100000},// magia_tile_x16_y0_sam_idx
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
    XYAddrOffsetY: 38,
    IdAddrOffset: 0,
    NumSamRules: 1056,
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
