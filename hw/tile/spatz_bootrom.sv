// Copyright (C) 2026 ETH Zurich, University of Bologna and Fondazione Chips-IT.
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
    32'h70c28293,
    32'h000012b7
  };

  // Sequential read with registered address
  logic [AddrBits-1:0] addr_q;

  always_ff @(posedge clk_i) begin
    if (req_i) begin
      addr_q <= addr_i[AddrBits-1+2:2];
    end
  end
  
  // Return data based on registered address
  assign rdata_o = (addr_q < RomSize) ? mem[addr_q] : '0;
endmodule
