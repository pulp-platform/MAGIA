// Copyright 2024 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// XBAR_PERIPH_BUS interface definition
// Compatible with PULP platform event_unit_flex

interface XBAR_PERIPH_BUS #(
  parameter int unsigned ID_WIDTH = 6
);
  
  // Request signals
  logic                req;     // Request valid
  logic [31:0]         add;     // Address (note: 'add' not 'addr')
  logic                wen;     // Write enable (0=write, 1=read - opposite of OBI!)
  logic [31:0]         wdata;   // Write data
  logic [3:0]          be;      // Byte enable
  logic [ID_WIDTH-1:0] id;      // Transaction ID
  
  // Response signals  
  logic                gnt;     // Grant (ready to accept)
  logic                r_valid; // Read data valid
  logic [31:0]         r_rdata; // Read data
  logic [ID_WIDTH-1:0] r_id;    // Response ID
  logic                r_opc;   // Response opcode (0=OK, 1=ERROR)

  // Slave modport (for peripherals)
  modport Slave (
    input  req, add, wen, wdata, be, id,
    output gnt, r_valid, r_rdata, r_id, r_opc
  );
  
  // Master modport (for initiators)  
  modport Master (
    output req, add, wen, wdata, be, id,
    input  gnt, r_valid, r_rdata, r_id, r_opc
  );

endinterface