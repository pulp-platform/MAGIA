#!/usr/bin/env python3
# Copyright 2024 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE for details.
# SPDX-License-Identifier: SHL-0.51
#
# Generate SystemVerilog bootrom module from binary file

import argparse
import sys

def generate_bootrom_sv(bin_file, output_file):
    """Generate SystemVerilog bootrom module from binary file."""
    
    # Read binary file
    with open(bin_file, 'rb') as f:
        data = f.read()
    
    # Pad to 32-bit word boundary
    if len(data) % 4 != 0:
        padding = 4 - (len(data) % 4)
        data = data + b'\x00' * padding
    
    num_bytes = len(data)
    num_words = num_bytes // 4
    
    # Convert bytes to 32-bit words (little-endian, in address order)
    words = []
    for i in range(0, num_bytes, 4):
        word = int.from_bytes(data[i:i+4], byteorder='little')
        words.append(word)
    
    # Generate SystemVerilog module (like spatz_cluster)
    sv_content = f'''// Copyright 2024 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51
//
// Auto-generated bootrom for Spatz core complex
// Generated from: {bin_file}
// Size: {num_bytes} bytes ({num_words} words)

module spatz_bootrom #(
  parameter int unsigned DataWidth = 32,
  parameter int unsigned AddrWidth = 32
) (
  input  logic                  clk_i,
  input  logic                  req_i,
  input  logic [AddrWidth-1:0]  addr_i,
  output logic [DataWidth-1:0]  rdata_o
);
  localparam int RomSize = {num_words};
  localparam int AddrBits = RomSize > 1 ? $clog2(RomSize) : 1;

  const logic [RomSize-1:0][DataWidth-1:0] mem = {{
'''
    
    # Add ROM content in REVERSE order (high index first)
    # This is because packed arrays fill from high to low index
    for i in range(num_words - 1, -1, -1):
        sv_content += f"    32'h{words[i]:08x}"
        if i > 0:
            sv_content += ","
        sv_content += "\n"
    
    sv_content += '''  };

  // Combinatorial read - no flop to avoid 1-cycle delay
  logic [AddrBits-1:0] addr_idx;
  assign addr_idx = addr_i[AddrBits-1+2:2];
  
  // Return data immediately based on address
  assign rdata_o = (addr_idx < RomSize) ? mem[addr_idx] : '0;
endmodule
'''
    
    # Write output file
    with open(output_file, 'w') as f:
        f.write(sv_content)
    
    print(f"Generated {output_file}: {num_words} words ({num_bytes} bytes)")

def main():
    parser = argparse.ArgumentParser(description='Generate SystemVerilog bootrom from binary')
    parser.add_argument('binary', help='Input binary file')
    parser.add_argument('-o', '--output', required=True, help='Output SystemVerilog file')
    
    args = parser.parse_args()
    
    try:
        generate_bootrom_sv(args.binary, args.output)
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == '__main__':
    main()
