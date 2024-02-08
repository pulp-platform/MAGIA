/*
 * Copyright (C) 2023-2024 ETH Zurich and University of Bologna
 *
 * Licensed under the Solderpad Hardware License, Version 0.51 
 * (the "License"); you may not use this file except in compliance 
 * with the License. You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * SPDX-License-Identifier: SHL-0.51
 *
 * Authors: Victor Isachi <victor.isachi@unibo.it>
 * 
 * RedMulE Tile Package
 */

 package redmule_tile_pkg;

  `include "hci/typedef.svh"
  `include "hwpe-ctrl/typedef.svh"

  `define TARGET_REDMULE_COMPLEX
  
  // Global constants
  localparam int unsigned ADDR_W         = 32;                              // System-wide address Width
  localparam int unsigned DATA_W         = 32;                              // System-wide data Width
  localparam int unsigned INSTR_W        = 32;                              // System-wide instruction Width
  localparam int unsigned N_IRQ          = 32;                              // Number of IRQs
  localparam int unsigned IRQ_ID_W       = $clog2(N_IRQ);                   // IRQ ID Width
  
  // Parameters used by the HCI
  parameter int unsigned N_HWPE          = 1;                               // Number of HWPEs attached to the port
  parameter int unsigned N_CORE          = 1;                               // Number of Core ports
  parameter int unsigned N_DMA           = 0;                               // Number of DMA ports /*TODO: add DMA and update interconnect parameter*/
  parameter int unsigned N_EXT           = 0;                               // Number of External ports - LEAVE TO 0 UNLESS YOU KNOW WHAT YOU ARE DOING
  parameter int unsigned AWC             = ADDR_W;                          // Address width core   (slave ports)
  parameter int unsigned AWM             = ADDR_W;                          // Address width memory (master ports)
  parameter int unsigned DW_LIC          = DATA_W;                          // Data Width for Log Interconnect
  parameter int unsigned BW_LIC          = 8;                               // Byte Width for Log Interconnect
  parameter int unsigned UW_LIC          = 0;                               // User Width for Log Interconnect
  parameter int unsigned TS_BIT          = 21;                              // TEST_SET_BIT (for Log Interconnect)
  parameter int unsigned IW              = N_HWPE + N_CORE + N_DMA + N_EXT; // ID Width HCI
  parameter int unsigned EXPFIFO         = 0;                               // FIFO Depth for HWPE Interconnect
  parameter int unsigned DWH             = DATA_W;                          // Data Width for HWPE Interconnect
  parameter int unsigned AWH             = ADDR_W;                          // Address Width for HWPE Interconnect
  parameter int unsigned BWH             = 8;                               // Byte Width for HWPE Interconnect
  parameter int unsigned WWH             = DWH;                             // Word Width for HWPE Interconnect
  parameter int unsigned OWH             = AWH;                             // Offset Width for HWPE Interconnect
  parameter int unsigned UWH             = 0;                               // User Width for HWPE Interconnect
  parameter int unsigned SEL_LIC         = 0;                               // Log interconnect type selector
  localparam int unsigned STRB_W         = DW_LIC/BW_LIC;                   // Strobe Width for HWPE Interconnect
  localparam int unsigned WORDS_DATA     = DW_LIC/WWH;                      // Number of words per data

  // Parameters used by the core
  parameter bit          X_EXT_EN        = 1;                               // Enable eXtension Interface (X) support, see eXtension Interface        
  parameter int unsigned X_NUM_RS        = 2;                               // Number of register file read ports that can be used by the eXtension interface
  parameter int unsigned X_ID_W          = 4;                               // Identification width for the eXtension interface
  parameter int unsigned X_MEM_W         = 32;                              // Memory access width for loads/stores via the eXtension interface
  parameter int unsigned X_RFR_W         = 32;                              // Register file read access width for the eXtension interface
  parameter int unsigned X_RFW_W         = 32;                              // Register file write access width for the eXtension interface
  parameter bit [31:0]   X_MISA          = 32'h0;                           // MISA extensions implemented on the eXtension interface, see Machine ISA (misa). X_MISA can only be used to set a subset of the following: {P, V, F, M}
  parameter bit [1 :0]   X_ECS_XS        = 2'b0;                            // Default value for mstatus.XS if X_EXT = 1, see Machine Status (mstatus)
  parameter bit [31:0]   DM_REGION_START = 32'hF0000000;                    // Start address of Debug Module region, see Debug & Trigger
  parameter bit [31:0]   DM_REGION_END   = 32'hF0003FFF;                    // End address of Debug Module region, see Debug & Trigger
  parameter bit          CLIC_EN         = 1'b0;                            // Specifies whether Smclic, Smclicshv and Smclicconfig are supported
  parameter int unsigned CLIC_ID_W       = 0;                               // Width of clic_irq_id_i and clic_irq_id_o. The maximum number of supported interrupts in CLIC mode is 2^CLIC_ID_WIDTH. Trap vector table alignment is restricted as described in Machine Trap Vector Table Base Address (mtvt)

  // Parameters used by RedMulE
  parameter int unsigned REDMULE_ID_W    = 8;                               // RedMulE ID Width
  
  typedef struct packed {
    logic        req;
    logic [31:0] addr;
    logic [1 :0] memtype;
    logic [2 :0] prot;
    logic        dbg;
  } core_instr_req_t;

  typedef struct packed {
    logic        gnt;
    logic        rvalid;
    logic [31:0] rdata;
    logic        err;
  } core_instr_rsp_t;

  typedef struct packed {
    logic        req;
    logic [31:0] addr;
    logic [5 :0] atop;
    logic [3 :0] be;
    logic [1 :0] memtype;
    logic [2 :0] prot;
    logic        dbg;
    logic [31:0] wdata;
    logic        we;
  } core_data_req_t;

  typedef struct packed {
    logic        gnt;
    logic        rvalid;
    logic [31:0] rdata;
    logic        err;
    logic        exokay;
  } core_data_rsp_t;

  `HWPE_CTRL_TYPEDEF_REQ_T(redmule_ctrl_req_t, logic [AWC-1:0], logic [DW_LIC-1:0], logic [STRB_W-1:0], logic [IW-1:0])
  `HWPE_CTRL_TYPEDEF_RSP_T(redmule_ctrl_rsp_t, logic [DW_LIC-1:0], logic [IW-1:0])
  
  `HCI_TYPEDEF_REQ_T(redmule_data_req_t, logic [AWM-1:0], logic [DW_LIC-1:0], logic [STRB_W-1:0], logic signed [WORDS_DATA-1:0][AWH:0], logic [UWH-1:0])
  `HCI_TYPEDEF_RSP_T(redmule_data_rsp_t, logic [DW_LIC-1:0], logic [UWH-1:0])

 endpackage: redmule_tile_pkg