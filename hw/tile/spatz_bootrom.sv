// Copyright 2024 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51
//
// Auto-generated bootrom for Spatz core complex
// Generated from: spatz_init.bin
// Size: 16 bytes (4 words)

module spatz_bootrom #(
  parameter int unsigned DataWidth = 32,
  parameter int unsigned AddrWidth = 32
) (
  input  logic                  clk_i,
  input  logic                  req_i,
  input  logic [AddrWidth-1:0]  addr_i,
  output logic [DataWidth-1:0]  rdata_o
);
  localparam int RomSize = 4;
  localparam int AddrBits = RomSize > 1 ? $clog2(RomSize) : 1;

  const logic [RomSize-1:0][DataWidth-1:0] mem = {
    32'h00030067,
    32'h0002a303,
    32'h70428293,
    32'h000012b7
  };

  // Combinatorial read - no flop to avoid 1-cycle delay
  logic [AddrBits-1:0] addr_idx;
  assign addr_idx = addr_i[AddrBits-1+2:2];
  
  // Return data immediately based on address
  assign rdata_o = (addr_idx < RomSize) ? mem[addr_idx] : '0;
endmodule
