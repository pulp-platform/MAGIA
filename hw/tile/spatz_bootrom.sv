// Copyright 2024 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51
//
// Auto-generated bootrom for Spatz core complex
// Generated from: spatz_init.bin

module spatz_bootrom #(
  parameter int unsigned DataWidth = 32,
  parameter int unsigned AddrWidth = 32
) (
  input  logic                  clk_i,
  input  logic                  req_i,
  input  logic [AddrWidth-1:0]  addr_i,
  output logic [DataWidth-1:0]  rdata_o
);
  localparam int RomSize = 35;
  localparam int AddrBits = RomSize > 1 ? $clog2(RomSize) : 1;

  const logic [RomSize-1:0][DataWidth-1:0] mem = {
    32'h00030067,
    32'h0002a303,
    32'h70428293,
    32'h000012b7,
    32'h00000f93,
    32'h00000f13,
    32'h00000e93,
    32'h00000e13,
    32'h00000d93,
    32'h00000d13,
    32'h00000c93,
    32'h00000c13,
    32'h00000b93,
    32'h00000b13,
    32'h00000a93,
    32'h00000a13,
    32'h00000993,
    32'h00000913,
    32'h00000893,
    32'h00000813,
    32'h00000793,
    32'h00000713,
    32'h00000693,
    32'h00000613,
    32'h00000593,
    32'h00000513,
    32'h00000493,
    32'h00000413,
    32'h00000393,
    32'h00000313,
    32'h00000293,
    32'h00000213,
    32'h00000193,
    32'h00000093,
    32'h00002137
  };

  // Combinatorial read - no flop to avoid 1-cycle delay
  logic [AddrBits-1:0] addr_idx;
  assign addr_idx = addr_i[AddrBits-1+2:2];
  
  // Return data immediately based on address
  assign rdata_o = (addr_idx < RomSize) ? mem[addr_idx] : '0;
endmodule
