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
  `include "obi/typedef.svh"
  `include "axi/typedef.svh"

  `include "hci/assign.svh"

  // The following parameter is need to specify to the redmule_top module to include the Xif interface
  `define TARGET_REDMULE_COMPLEX

  // The following parameter is need to enable the Core trace generation
  `define CORE_TRACES
  
  // Global constants
  localparam int unsigned ADDR_W               = 32;                              // System-wide address Width
  localparam int unsigned DATA_W               = 32;                              // System-wide data Width
  localparam int unsigned INSTR_W              = 32;                              // System-wide instruction Width
  localparam int unsigned BYTE_W               = 8;                               // System-wide byte Width
  localparam int unsigned STRB_W               = DATA_W/BYTE_W;                   // System-wide strobe Width
  localparam int unsigned N_MEM_BANKS          = 16 + 1;                          // Number of TCDM banks (1 extra bank for missaligned accesses)
  localparam int unsigned N_WORDS_BANK         = 1024;                            // Number of words per TCDM bank
  localparam int unsigned N_IRQ                = 32;                              // Number of IRQs
  localparam int unsigned IRQ_ID_W             = $clog2(N_IRQ);                   // IRQ ID Width
  localparam int unsigned ID_W_OFFSET          = 4;                               // Offset to be added to ID Width
  localparam int unsigned ID_W                 = 4;                               // Default ID Width

  // Address map
  localparam logic [ADDR_W-1:0] L1_ADDR_START  = 32'h1000_0000;
  localparam logic [ADDR_W-1:0] L1_ADDR_END    = 32'h2000_0000;
  localparam logic [ADDR_W-1:0] L2_ADDR_START  = 32'h2000_0000;
  localparam logic [ADDR_W-1:0] L2_ADDR_END    = 32'h3000_0000;
  
  // Parameters used by the HCI
  parameter int unsigned N_HWPE                = 1;                               // Number of HWPEs attached to the port
  parameter int unsigned N_CORE                = 1;                               // Number of Core ports
  parameter int unsigned N_DMA                 = 0;                               // Number of DMA ports /*TODO: add DMA and update interconnect parameter*/
  parameter int unsigned N_EXT                 = 0;                               // Number of External ports - LEAVE TO 0 UNLESS YOU KNOW WHAT YOU ARE DOING
  parameter int unsigned AWC                   = ADDR_W;                          // Address width core   (slave ports)
  localparam int unsigned AWM                  = $clog2(N_WORDS_BANK);            // Address width memory (master ports)
  parameter int unsigned DW_LIC                = DATA_W * N_MEM_BANKS;            // Data Width for Log Interconnect
  parameter int unsigned BW_LIC                = BYTE_W;                          // Byte Width for Log Interconnect
  parameter int unsigned UW_LIC                = 0;                               // User Width for Log Interconnect
  parameter int unsigned TS_BIT                = 21;                              // TEST_SET_BIT (for Log Interconnect)
  parameter int unsigned IW                    = N_HWPE + N_CORE + N_DMA + N_EXT; // ID Width HCI
  parameter int unsigned EXPFIFO               = 0;                               // FIFO Depth for HWPE Interconnect
  parameter int unsigned DWH                   = DATA_W * (N_MEM_BANKS - 1);      // Data Width for HWPE Interconnect (ignore the extra bank for missaligned accesses)
  parameter int unsigned AWH                   = ADDR_W;                          // Address Width for HWPE Interconnect
  parameter int unsigned BWH                   = BYTE_W;                          // Byte Width for HWPE Interconnect
  parameter int unsigned WWH                   = DWH;                             // Word Width for HWPE Interconnect
  parameter int unsigned OWH                   = AWH;                             // Offset Width for HWPE Interconnect
  parameter int unsigned UWH                   = 1;                               // User Width for HWPE Interconnect
  parameter int unsigned SEL_LIC               = 0;                               // Log interconnect type selector
  localparam int unsigned SW_LIC               = DW_LIC/BW_LIC;                   // Strobe Width for HWPE Interconnect
  localparam int unsigned WORDS_DATA           = DW_LIC/WWH;                      // Number of words per data

  // Parameters used by the core
  parameter bit          X_EXT_EN              = 1;                               // Enable eXtension Interface (X) support, see eXtension Interface        
  parameter int unsigned X_NUM_RS              = 2;                               // Number of register file read ports that can be used by the eXtension interface
  parameter int unsigned X_ID_W                = IW + ID_W_OFFSET;                // Identification width for the eXtension interface
  parameter int unsigned X_MEM_W               = 32;                              // Memory access width for loads/stores via the eXtension interface
  parameter int unsigned X_RFR_W               = 32;                              // Register file read access width for the eXtension interface
  parameter int unsigned X_RFW_W               = 32;                              // Register file write access width for the eXtension interface
  parameter bit [31:0]   X_MISA                = 32'h0;                           // MISA extensions implemented on the eXtension interface, see Machine ISA (misa). X_MISA can only be used to set a subset of the following: {P, V, F, M}
  parameter bit [1 :0]   X_ECS_XS              = 2'b0;                            // Default value for mstatus.XS if X_EXT = 1, see Machine Status (mstatus)
  parameter bit [31:0]   DM_REGION_START       = 32'hF0000000;                    // Start address of Debug Module region, see Debug & Trigger
  parameter bit [31:0]   DM_REGION_END         = 32'hF0003FFF;                    // End address of Debug Module region, see Debug & Trigger
  parameter bit          CLIC_EN               = 1'b0;                            // Specifies whether Smclic, Smclicshv and Smclicconfig are supported
  parameter int unsigned CLIC_ID_W             = 0;                               // Width of clic_irq_id_i and clic_irq_id_o. The maximum number of supported interrupts in CLIC mode is 2^CLIC_ID_WIDTH. Trap vector table alignment is restricted as described in Machine Trap Vector Table Base Address (mtvt)

  // Parameters used by RedMulE
  parameter int unsigned REDMULE_DW            = DW_LIC;                          // RedMulE Data Width
  parameter int unsigned REDMULE_ID_W          = IW + ID_W_OFFSET;                // RedMulE ID Width
  parameter int unsigned REDMULE_UW            = 0;                               // RedMulE User Width
  
  // Parameters used by OBI
  parameter int unsigned AUSER_WIDTH           = 0;                               // Width of the auser signal (see OBI documentation): not used by the CV32E40X
  parameter int unsigned WUSER_WIDTH           = 0;                               // Width of the wuser signal (see OBI documentation): not used by the CV32E40X
  parameter int unsigned ACHK_WIDTH            = 0;                               // Width of the achk  signal (see OBI documentation): not used by the CV32E40X
  parameter int unsigned RUSER_WIDTH           = 0;                               // Width of the ruser signal (see OBI documentation): not used by the CV32E40X
  parameter int unsigned RCHK_WIDTH            = 0;                               // Width of the rchk  signal (see OBI documentation): not used by the CV32E40X
  parameter int unsigned AID_WIDTH             = 1;                               // Width of the aid   signal (address channel identifier, see OBI documentation)
  parameter int unsigned RID_WIDTH             = 1;                               // Width of the rid   signal (response channel identifier, see OBI documentation)
  parameter int unsigned MID_WIDTH             = 0;                               // Width of the mid   signal (manager identifier, see OBI documentation)
  parameter int unsigned N_SBR                 = 2;                               // Number of slaves (HCI, AXI XBAR)
  parameter int unsigned N_MGR                 = 1;                               // Number of masters (Core)
  parameter int unsigned N_MAX_TRAN            = 1;                               // Number of maximum outstanding transactions
  parameter int unsigned N_ADDR_RULE           = 2;                               // Number of address rules
  localparam int unsigned N_BIT_SBR            = $clog2(N_SBR);                   // Number of bits required to identify each slave

  // Parameters used by AXI
  parameter int unsigned AXI_DATA_ID_W         = 2;                               // Width of the AXI Data ID (2 bits: Core, iDMA. I$)
  parameter int unsigned AXI_INSTR_ID_W        = 1;                               // Width of the AXI Instruction ID (0 bits: direct Core - I$ connection)
  parameter int unsigned AXI_DATA_U_W          = 1;                               // Width of the AXI Data User
  parameter int unsigned AXI_INSTR_U_W         = 1;                               // Width of the AXI Instruction User

  typedef struct packed {
    int unsigned       idx;
    logic [ADDR_W-1:0] start_addr;
    logic [ADDR_W-1:0] end_addr;
  } obi_xbar_rule_t;

  typedef struct packed {
    logic               req;
    logic [INSTR_W-1:0] addr;
    logic [1        :0] memtype;
    logic [2        :0] prot;
    logic               dbg;
  } core_instr_req_t;

  typedef struct packed {
    logic               gnt;
    logic               rvalid;
    logic [INSTR_W-1:0] rdata;
    logic               err;
  } core_instr_rsp_t;

  `HWPE_CTRL_TYPEDEF_REQ_T(redmule_ctrl_req_t, logic [AWC-1:0], logic [DW_LIC-1:0], logic [SW_LIC-1:0], logic [IW-1:0])
  `HWPE_CTRL_TYPEDEF_RSP_T(redmule_ctrl_rsp_t, logic [DW_LIC-1:0], logic [IW-1:0])
  
  `HCI_TYPEDEF_REQ_T(redmule_data_req_t, logic [AWM-1:0], logic [DW_LIC-1:0], logic [SW_LIC-1:0], logic signed [WORDS_DATA-1:0][AWH:0], logic [UWH-1:0])
  `HCI_TYPEDEF_RSP_T(redmule_data_rsp_t, logic [DW_LIC-1:0], logic [UWH-1:0])

  `OBI_TYPEDEF_ALL_A_OPTIONAL(core_data_obi_a_optional_t, AUSER_WIDTH, WUSER_WIDTH, MID_WIDTH, ACHK_WIDTH)
  `OBI_TYPEDEF_ALL_R_OPTIONAL(core_data_obi_r_optional_t, RUSER_WIDTH, RCHK_WIDTH)
  `OBI_TYPEDEF_A_CHAN_T(core_data_obi_a_chan_t, ADDR_W, DATA_W, AID_WIDTH, core_data_obi_a_optional_t)
  `OBI_TYPEDEF_R_CHAN_T(core_data_obi_r_chan_t, DATA_W, RID_WIDTH, core_data_obi_r_optional_t)
  `OBI_TYPEDEF_DEFAULT_REQ_T(core_data_req_t, core_data_obi_a_chan_t)
  `OBI_TYPEDEF_RSP_T(core_data_rsp_t, core_data_obi_r_chan_t)

  `OBI_TYPEDEF_ALL_A_OPTIONAL(core_instr_obi_a_optional_t, AUSER_WIDTH, WUSER_WIDTH, MID_WIDTH, ACHK_WIDTH)
  `OBI_TYPEDEF_ALL_R_OPTIONAL(core_instr_obi_r_optional_t, RUSER_WIDTH, RCHK_WIDTH)
  `OBI_TYPEDEF_A_CHAN_T(core_instr_obi_a_chan_t, ADDR_W, DATA_W, AID_WIDTH, core_instr_obi_a_optional_t)
  `OBI_TYPEDEF_R_CHAN_T(core_instr_obi_r_chan_t, DATA_W, RID_WIDTH, core_instr_obi_r_optional_t)
  `OBI_TYPEDEF_DEFAULT_REQ_T(core_obi_instr_req_t, core_instr_obi_a_chan_t)
  `OBI_TYPEDEF_RSP_T(core_obi_instr_rsp_t, core_instr_obi_r_chan_t)

  `HCI_TYPEDEF_REQ_T(core_hci_data_req_t, logic [AWM-1:0], logic [DW_LIC-1:0], logic [SW_LIC-1:0], logic signed [WORDS_DATA-1:0][AWH:0], logic [UWH-1:0])
  `HCI_TYPEDEF_RSP_T(core_hci_data_rsp_t, logic [DW_LIC-1:0], logic [UWH-1:0])

  `AXI_TYPEDEF_ALL_CT(core_axi_data, core_axi_data_req_t, core_axi_data_rsp_t, logic[ADDR_W-1:0], logic[AXI_DATA_ID_W-1:0], logic[DATA_W-1:0], logic[STRB_W-1:0], logic[AXI_DATA_U_W-1:0])
  `AXI_TYPEDEF_ALL_CT(core_axi_instr, core_axi_instr_req_t, core_axi_instr_rsp_t, logic[ADDR_W-1:0], logic[AXI_INSTR_ID_W-1:0], logic[DATA_W-1:0], logic[STRB_W-1:0], logic[AXI_INSTR_U_W-1:0])

endpackage: redmule_tile_pkg