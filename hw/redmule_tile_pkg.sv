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
  `include "register_interface/typedef.svh"
  `include "idma/typedef.svh"

  `include "hci/assign.svh"

  `include "include/alias.svh"
  
  // Global constants
  localparam int unsigned ADDR_W                   = 32;                              // System-wide address Width
  localparam int unsigned DATA_W                   = 32;                              // System-wide data Width
  localparam int unsigned INSTR_W                  = 32;                              // System-wide instruction Width
  localparam int unsigned BYTE_W                   = 8;                               // System-wide byte Width
  localparam int unsigned STRB_W                   = DATA_W/BYTE_W;                   // System-wide strobe Width
  localparam int unsigned N_MEM_BANKS              = 32;                              // Number of TCDM banks (1 extra bank for missaligned accesses)
  localparam int unsigned N_WORDS_BANK             = 4096;                            // Number of words per TCDM bank
  localparam int unsigned N_IRQ                    = 32;                              // Number of IRQs
  localparam int unsigned IRQ_ID_W                 = $clog2(N_IRQ);                   // IRQ ID Width
  localparam int unsigned ID_W_OFFSET              = 4;                               // Offset to be added to ID Width
  localparam int unsigned ID_W                     = 4;                               // Default ID Width
  localparam int unsigned USR_W                    = 1;                               // Default User Width

  // Address map
  localparam logic[ADDR_W-1:0] L1_ADDR_START       = 32'h1000_0000;
  localparam logic[ADDR_W-1:0] L1_ADDR_END         = 32'h2000_0000;
  localparam logic[ADDR_W-1:0] L2_ADDR_START       = 32'h2000_0000;
  localparam logic[ADDR_W-1:0] L2_ADDR_END         = 32'h3000_0000;
  
  // Parameters used by the HCI
  parameter int unsigned N_HWPE                    = 1;                               // Number of HWPEs attached to the port
  parameter int unsigned N_CORE                    = 1;                               // Number of Core ports
  parameter int unsigned N_DMA                     = 1;                               // Number of DMA ports
  parameter int unsigned N_EXT                     = 0;                               // Number of External ports - LEAVE TO 0 UNLESS YOU KNOW WHAT YOU ARE DOING
  parameter int unsigned AWC                       = ADDR_W;                          // Address width core   (slave ports)
  localparam int unsigned AWM                      = $clog2(N_WORDS_BANK);            // Address width memory (master ports)
  parameter int unsigned DW_LIC                    = DATA_W * N_MEM_BANKS;            // Data Width for Log Interconnect
  parameter int unsigned BW_LIC                    = BYTE_W;                          // Byte Width for Log Interconnect
  parameter int unsigned UW_LIC                    = USR_W;                           // User Width for Log Interconnect
  parameter int unsigned TS_BIT                    = 21;                              // TEST_SET_BIT (for Log Interconnect)
  parameter int unsigned IW                        = N_HWPE + N_CORE + N_DMA + N_EXT; // ID Width HCI
  parameter int unsigned EXPFIFO                   = 0;                               // FIFO Depth for HWPE Interconnect
  parameter int unsigned DWH                       = DATA_W * N_MEM_BANKS;            // Data Width for HWPE Interconnect
  parameter int unsigned AWH                       = ADDR_W;                          // Address Width for HWPE Interconnect
  parameter int unsigned BWH                       = BYTE_W;                          // Byte Width for HWPE Interconnect
  parameter int unsigned WWH                       = DWH;                             // Word Width for HWPE Interconnect
  parameter int unsigned OWH                       = AWH;                             // Offset Width for HWPE Interconnect
  parameter int unsigned UWH                       = USR_W;                           // User Width for HWPE Interconnect
  parameter int unsigned SEL_LIC                   = 1;                               // Log interconnect type selector
  localparam int unsigned SW_LIC                   = DW_LIC/BW_LIC;                   // Strobe Width for HWPE Interconnect
  localparam int unsigned WORDS_DATA               = DW_LIC/WWH;                      // Number of words per data

  // Parameters used by the core
  parameter bit          X_EXT_EN                  = 1;                               // Enable eXtension Interface (X) support, see eXtension Interface        
  parameter int unsigned X_NUM_RS                  = 3;                               // Number of register file read ports that can be used by the eXtension interface
  parameter int unsigned X_ID_W                    = IW + ID_W_OFFSET;                // Identification width for the eXtension interface
  parameter int unsigned X_MEM_W                   = 32;                              // Memory access width for loads/stores via the eXtension interface
  parameter int unsigned X_RFR_W                   = 32;                              // Register file read access width for the eXtension interface
  parameter int unsigned X_RFW_W                   = 32;                              // Register file write access width for the eXtension interface
  parameter bit[31:0]    X_MISA                    = 32'h0;                           // MISA extensions implemented on the eXtension interface, see Machine ISA (misa). X_MISA can only be used to set a subset of the following: {P, V, F, M}
  parameter bit[1 :0]    X_ECS_XS                  = 2'b0;                            // Default value for mstatus.XS if X_EXT = 1, see Machine Status (mstatus)
  parameter bit[31:0]    DM_REGION_START           = 32'hF0000000;                    // Start address of Debug Module region, see Debug & Trigger
  parameter bit[31:0]    DM_REGION_END             = 32'hF0003FFF;                    // End address of Debug Module region, see Debug & Trigger
  parameter bit          CLIC_EN                   = 1'b0;                            // Specifies whether Smclic, Smclicshv and Smclicconfig are supported
  parameter int unsigned CLIC_ID_W                 = 1;                               // Width of clic_irq_id_i and clic_irq_id_o. The maximum number of supported interrupts in CLIC mode is 2^CLIC_ID_WIDTH. Trap vector table alignment is restricted as described in Machine Trap Vector Table Base Address (mtvt)

  // Parameters used by RedMulE
  parameter int unsigned REDMULE_DW                = DW_LIC;                          // RedMulE Data Width
  parameter int unsigned REDMULE_ID_W              = IW + ID_W_OFFSET;                // RedMulE ID Width
  parameter int unsigned REDMULE_UW                = USR_W;                           // RedMulE User Width
  
  // Parameters used by OBI
  parameter int unsigned AUSER_WIDTH               = 1;                               // Width of the auser signal (see OBI documentation): not used by the CV32E40X
  parameter int unsigned WUSER_WIDTH               = 1;                               // Width of the wuser signal (see OBI documentation): not used by the CV32E40X
  parameter int unsigned ACHK_WIDTH                = 1;                               // Width of the achk  signal (see OBI documentation): not used by the CV32E40X
  parameter int unsigned RUSER_WIDTH               = 1;                               // Width of the ruser signal (see OBI documentation): not used by the CV32E40X
  parameter int unsigned RCHK_WIDTH                = 1;                               // Width of the rchk  signal (see OBI documentation): not used by the CV32E40X
  parameter int unsigned AID_WIDTH                 = 1;                               // Width of the aid   signal (address channel identifier, see OBI documentation)
  parameter int unsigned RID_WIDTH                 = 1;                               // Width of the rid   signal (response channel identifier, see OBI documentation)
  parameter int unsigned MID_WIDTH                 = 1;                               // Width of the mid   signal (manager identifier, see OBI documentation)
  parameter int unsigned N_SBR                     = 2;                               // Number of slaves (HCI, AXI XBAR)
  parameter int unsigned N_MGR                     = 1;                               // Number of masters (Core)
  parameter int unsigned N_MAX_TRAN                = 1;                               // Number of maximum outstanding transactions
  parameter int unsigned N_ADDR_RULE               = 2;                               // Number of address rules
  localparam int unsigned N_BIT_SBR                = $clog2(N_SBR);                   // Number of bits required to identify each slave

  // Parameters used by AXI
  parameter int unsigned AXI_DATA_ID_W             = 2;                               // Width of the AXI Data ID (2 bits: Core, iDMA. I$)
  parameter int unsigned AXI_INSTR_ID_W            = 1;                               // Width of the AXI Instruction ID (0 bits: direct Core - I$ connection)
  parameter int unsigned AXI_DATA_U_W              = USR_W;                           // Width of the AXI Data User
  parameter int unsigned AXI_INSTR_U_W             = USR_W;                           // Width of the AXI Instruction User

  // Parameters used by the iDMA
  localparam int unsigned iDMA_NumDims             = 2;                               // iDMA Number of dimensions
  localparam int unsigned NumDim                   = iDMA_NumDims;                    // Needed by the iDMA typedef (wtf?)
  parameter int unsigned iDMA_DataWidth            = DATA_W;                          // iDMA Data Width
  parameter int unsigned iDMA_AddrWidth            = ADDR_W;                          // iDMA Address Width
  parameter int unsigned iDMA_UserWidth            = USR_W;                           // iDMA AXI User Width
  parameter int unsigned iDMA_StrbWidth            = iDMA_DataWidth/8;                // iDMA AXI Strobe Width
  parameter int unsigned iDMA_AxiIdWidth           = ID_W;                            // iDMA AXI ID Width
  parameter int unsigned iDMA_NumAxInFlight        = 2;                               // iDMA Number of transaction that can be in-flight concurrently
  parameter int unsigned iDMA_BufferDepth          = 3;                               // iDMA depth of the internal reorder buffer: '2' - minimal possible configuration; '3' - efficiently handle misaligned transfers (recommended)
  parameter int unsigned iDMA_TFLenWidth           = 32;                              // iDMA With of a transfer: max transfer size is `2**TFLenWidth` bytes
  parameter int unsigned iDMA_MemSysDepth          = 0;                               // iDMA depth of the memory system the backend is attached to
  parameter int unsigned iDMA_CombinedShifter      = 0;                               // iDMA Should both data shifts be done before the dataflow element? If this is enabled, then the data inserted into the dataflow element will no longer be word aligned, but only a single shifter is needed
  parameter int unsigned iDMA_RAWCouplingAvail     = 0;                               // iDMA Should the `R`-`AW` coupling hardware be present? (recommended)
  parameter int unsigned iDMA_MaskInvalidData      = 1;                               // iDMA Mask invalid data on the manager interface
  parameter int unsigned iDMA_HardwareLegalizer    = 1;                               // iDMA Should hardware legalization be present? (recommended) If not, software legalization is required to ensure the transfers are AXI4-conformal
  parameter int unsigned iDMA_RejectZeroTransfers  = 1;                               // iDMA Reject zero-length transfers
  parameter int unsigned iDMA_PrintFifoInfo        = 0;                               // iDMA Print the info of the FIFO configuration
  parameter int unsigned iDMA_NumRegs              = 1;                               // iDMA Number of configuration register ports
  parameter int unsigned iDMA_NumStreams           = 1;                               // iDMA Number of streams (max 16)
  parameter int unsigned iDMA_JobFifoDepth         = 2,                               // iDMA Stream FIFO depth
  parameter int unsigned iDMA_IdCounterWidth       = 32;                              // iDMA Width of the transfer id (max 32-bit)
  parameter int unsigned iDMA_RepWidth             = 32;                              // iDMA Width of the reps field
  localparam logic[iDMA_NumDims-1:0][31:0] 
                         iDMA_RepWidths            = '{default: 32'd32};              // iDMA Width of the counters holding the number of repetitions
  parameter int unsigned iDMA_StrideWidth          = 32;                              // iDMA Width of the stride field

  // Parameters used by the iDMA instruction decoder
  parameter int unsigned DMA_INSTR_W               = INSTR_W;                         // iDMA Decoder instruction width
  parameter int unsigned DMA_DATA_W                = DATA_W;                          // iDMA Decoder data width
  parameter int unsigned DMA_ADDR_W                = ADDR_W;                          // iDMA Decoder address width
  parameter int unsigned DMA_N_RF_PORTS            = X_NUM_RS;                        // iDMA Decoder number of register file read ports
  parameter int unsigned DMA_OPCODE_W              = 7;                               // iDMA Decoder OPCODE field width
  parameter int unsigned DMA_FUNC3_W               = 3;                               // iDMA Decoder FUNC3 field width
  parameter int unsigned DMA_ND_EN_W               = 1;                               // iDMA Decoder ND_EN field width
  parameter int unsigned DMA_DST_MAX_LOG_LEN_W     = 3;                               // iDMA Decoder DST_MAX_LOG_LEN field width
  parameter int unsigned DMA_SRC_MAX_LOG_LEN_W     = 3;                               // iDMA Decoder SRC_MAX_LOG_LEN field width
  parameter int unsigned DMA_DST_REDUCE_LEN_W      = 1;                               // iDMA Decoder DST_REDUCE_LEN field width
  parameter int unsigned DMA_SRC_REDUCE_LEN_W      = 1;                               // iDMA Decoder SRC_REDUCE_LEN field width
  parameter int unsigned DMA_DECOUPLE_R_W_W        = 1;                               // iDMA Decoder DECOUPLE_R_W field width
  parameter int unsigned DMA_DECOUPLE_R_AW_W       = 1;                               // iDMA Decoder DECOUPLE_R_AW field width
  parameter int unsigned DMA_DIRECTION_W           = 1;                               // iDMA Decoder DIRECTION field width
  parameter int unsigned DMA_OPCODE_OFF            = 0;                               // iDMA Decoder OPCODE field offset
  parameter int unsigned DMA_FUNC3_OFF             = 12;                              // iDMA Decoder FUNC3 field offset
  parameter int unsigned DMA_ND_EN_OFF             = 15;                              // iDMA Decoder ND_EN field offset
  parameter int unsigned DMA_DST_MAX_LOG_LEN_OFF   = 16;                              // iDMA Decoder DST_MAX_LOG_LEN field offset
  parameter int unsigned DMA_SRC_MAX_LOG_LEN_OFF   = 19;                              // iDMA Decoder SRC_MAX_LOG_LEN field offset
  parameter int unsigned DMA_DST_REDUCE_LEN_OFF    = 22;                              // iDMA Decoder DST_REDUCE_LEN field offset
  parameter int unsigned DMA_SRC_REDUCE_LEN_OFF    = 23;                              // iDMA Decoder SRC_REDUCE_LEN field offset
  parameter int unsigned DMA_DECOUPLE_R_W_OFF      = 24;                              // iDMA Decoder DECOUPLE_R_W field offset
  parameter int unsigned DMA_DECOUPLE_R_AW_OFF     = 25;                              // iDMA Decoder DECOUPLE_R_AW field offset
  parameter int unsigned DMA_DIRECTION_OFF         = 26;                              // iDMA Decoder DIRECTION field offset
  parameter int unsigned DMA_N_CFG_REG             = 13;                              // iDMA Decoder number of configuration registers of the iDMA forntend: CONF, DST_ADDR_LOW, DST_ADDR_HIGH, SRC_ADDR_LOW, SRC_ADDR_HIGH, LENGTH_LOW, LENGTH_HIGH, DST_STRIDE_2_LOW, DST_STRIDE_2_HIGH, SRC_STRIDE_2_LOW, SRC_STRIDE_2_HIGH, REPS_2_LOW, REPS_2_HIGH
  parameter int unsigned DMA_CONF_IDX              = 0;                               // iDMA Decoder CONF cofiguration register index 
  parameter int unsigned DMA_CONF_DIRECTION_IDX    = 11;                              // iDMA Decoder DIRECTION bit index within CONF
  parameter int unsigned DMA_DST_ADDR_LOW_IDX      = 1;                               // iDMA Decoder DST_ADDR_LOW cofiguration register index 
  parameter int unsigned DMA_DST_ADDR_HIGH_IDX     = 2;                               // iDMA Decoder DST_ADDR_HIGH cofiguration register index 
  parameter int unsigned DMA_SRC_ADDR_LOW_IDX      = 3;                               // iDMA Decoder SRC_ADDR_LOW cofiguration register index 
  parameter int unsigned DMA_SRC_ADDR_HIGH_IDX     = 4;                               // iDMA Decoder SRC_ADDR_HIGH cofiguration register index 
  parameter int unsigned DMA_LENGTH_LOW_IDX        = 5;                               // iDMA Decoder LENGTH_LOW cofiguration register index 
  parameter int unsigned DMA_LENGTH_HIGH_IDX       = 6;                               // iDMA Decoder LENGTH_HIGH cofiguration register index 
  parameter int unsigned DMA_DST_STRIDE_2_LOW_IDX  = 7;                               // iDMA Decoder DST_STRIDE_2_LOW cofiguration register index 
  parameter int unsigned DMA_DST_STRIDE_2_HIGH_IDX = 8;                               // iDMA Decoder DST_STRIDE_2_HIGH cofiguration register index 
  parameter int unsigned DMA_SRC_STRIDE_2_LOW_IDX  = 9;                               // iDMA Decoder SRC_STRIDE_2_LOW cofiguration register index 
  parameter int unsigned DMA_SRC_STRIDE_2_HIGH_IDX = 10;                              // iDMA Decoder SRC_STRIDE_2_HIGH configuration register index
  parameter int unsigned DMA_REPS_2_LOW_IDX        = 11;                              // iDMA Decoder REPS_2_LOW configuration register index
  parameter int unsigned DMA_REPS_2_HIGH_IDX       = 12;                              // iDMA Decoder REPS_2_HIGH configuration register index
  parameter logic[DMA_OPCODE_W-1:0] CONF_OPCODE    = 7'b101_1011;                     // iDMA Decoder CONF instruction OPCODE
  parameter logic[ DMA_FUNC3_W-1:0] CONF_FUNC3     = 3'b000;                          // iDMA Decoder CONF instruction FUNC3
  parameter logic[DMA_OPCODE_W-1:0] SET_OPCODE     = 7'b111_1011;                     // iDMA Decoder SET (DST_ADDR, SRC_ADDR, LENGTH, DST_STRIDE_2, SRC_STRIDE_2, REPS_2, START) instruction OPCODE
  parameter logic[ DMA_FUNC3_W-1:0] SET_DA_FUNC3   = 3'b000;                          // iDMA Decoder DST_ADDR instruction FUNC3
  parameter logic[ DMA_FUNC3_W-1:0] SET_SA_FUNC3   = 3'b001;                          // iDMA Decoder SRC_ADDR instruction FUNC3
  parameter logic[ DMA_FUNC3_W-1:0] SET_L_FUNC3    = 3'b010;                          // iDMA Decoder LENGTH instruction FUNC3
  parameter logic[ DMA_FUNC3_W-1:0] SET_DS_FUNC3   = 3'b011;                          // iDMA Decoder DST_STRIDE_2 instruction FUNC3
  parameter logic[ DMA_FUNC3_W-1:0] SET_SS_FUNC3   = 3'b100;                          // iDMA Decoder SRC_STRIDE_2 instruction FUNC3
  parameter logic[ DMA_FUNC3_W-1:0] SET_R_FUNC3    = 3'b101;                          // iDMA Decoder REPS_2 instruction FUNC3
  parameter logic[ DMA_FUNC3_W-1:0] SET_S_FUNC3    = 3'b111;                          // iDMA Decoder START instruction FUNC3

  // Parameters of the AXI XBAR
  parameter int unsigned AxiXbarNoSlvPorts         = 2;                               // Number of Slave Ports (iDMA, Core) /*TODO: add i$*/
  localparam int unsigned AxiXbarSlvAxiIDWidth     = AXI_DATA_ID_W;                   // Number of bits to indentify each Slave Port
  parameter int unsigned AxiXbarMaxWTrans          = 8;                               // Maximum number of outstanding transactions per write
  parameter bit          AxiXbarFallThrough        = 1'b0;                            // Enabled -> MUX is purely combinational
  parameter bit          AxiXbarSpillAw            = 1'b0;                            // Enabled -> Spill register on write master ports, +1 cycle of latency on read channels
  parameter bit          AxiXbarSpillW             = 1'b0;                            // Enabled -> Spill register on write master ports, +1 cycle of latency on read channels
  parameter bit          AxiXbarSpillB             = 1'b0;                            // Enabled -> Spill register on write master ports, +1 cycle of latency on read channels
  parameter bit          AxiXbarSpillAr            = 1'b0;                            // Enabled -> Spill register on read master ports, +1 cycle of latency on write channels
  parameter bit          AxiXbarSpillR             = 1'b0;                            // Enabled -> Spill register on read master ports, +1 cycle of latency on write channels 
  
  // Parameters used by the Xif Instruction Demuxer
  parameter int unsigned N_COPROC                  = 2;                               // RedMulE and iDMA
  parameter int unsigned N_REDMULE_OPCODE          = 2;                               // Number of opcodes in the programming model of RedMulE
  parameter int unsigned N_IDMA_OPCODE             = 2;                               // Number of opcodes in the programming model of the iDMA decoder
  parameter int unsigned N_OPCODE                  = 2;                               // Number of opcodes = max{RedMulE_opcode, iDMA_opcode}
  typedef enum{
    XIF_REDMULE_IDX = 0,
    XIF_IDMA_IDX    = 1
  } xif_inst_demux_idx_e;
  parameter int unsigned DEFAULT_IDX               = XIF_REDMULE_IDX;                 // RedMulE will handle the instructions by default 
  
  typedef struct packed {
    int unsigned      idx;
    logic[ADDR_W-1:0] start_addr;
    logic[ADDR_W-1:0] end_addr;
  } obi_xbar_rule_t;

  typedef struct packed {
    logic              req;
    logic[INSTR_W-1:0] addr;
    logic[1        :0] memtype;
    logic[2        :0] prot;
    logic              dbg;
  } core_instr_req_t;

  typedef struct packed {
    logic              gnt;
    logic              rvalid;
    logic[INSTR_W-1:0] rdata;
    logic              err;
  } core_instr_rsp_t;

  typedef struct packed {
    logic             req;
    logic[ADDR_W-1:0] addr;
    logic[5       :0] atop;
    logic[3       :0] be;
    logic[1       :0] memtype;
    logic[2       :0] prot;
    logic             dbg;
    logic[DATA_W-1:0] wdata;
    logic             we;
  } core_data_req_t;

  typedef struct packed {
    logic             gnt;
    logic             rvalid;
    logic[DATA_W-1:0] rdata;
    logic             err;
    logic             exokay;
  } core_data_rsp_t;

  typedef enum {
    L1SPM_IDX = 1,
    L2_IDX    = 0
  } mem_array_idx_e;

  typedef enum {
    AXI_IDMA_IDX = 1,
    AXI_CORE_IDX = 0
  } axi_xbar_idx_e;

  typedef struct packed {
    logic[N_OPCODE-1:0][DMA_OPCODE_W-1:0] opcode_list;
  } xif_inst_rule_t;

  typedef logic[iDMA_AddrWidth-1:0] idma_addr_t;

  `HWPE_CTRL_TYPEDEF_REQ_T(redmule_ctrl_req_t, logic[AWC-1:0], logic[DW_LIC-1:0], logic[SW_LIC-1:0], logic[IW-1:0])
  `HWPE_CTRL_TYPEDEF_RSP_T(redmule_ctrl_rsp_t, logic[DW_LIC-1:0], logic[IW-1:0])
  
  `HCI_TYPEDEF_REQ_T(redmule_data_req_t, logic[AWC-1:0], logic[DW_LIC-1:0], logic[SW_LIC-1:0], logic signed[WORDS_DATA-1:0][AWH:0], logic[UWH-1:0])
  `HCI_TYPEDEF_RSP_T(redmule_data_rsp_t, logic[DW_LIC-1:0], logic[UWH-1:0])

  `OBI_TYPEDEF_ALL_A_OPTIONAL(core_data_obi_a_optional_t, AUSER_WIDTH, WUSER_WIDTH, MID_WIDTH, ACHK_WIDTH)
  `OBI_TYPEDEF_ALL_R_OPTIONAL(core_data_obi_r_optional_t, RUSER_WIDTH, RCHK_WIDTH)
  `OBI_TYPEDEF_A_CHAN_T(core_data_obi_a_chan_t, ADDR_W, DATA_W, AID_WIDTH, core_data_obi_a_optional_t)
  `OBI_TYPEDEF_R_CHAN_T(core_data_obi_r_chan_t, DATA_W, RID_WIDTH, core_data_obi_r_optional_t)
  `OBI_TYPEDEF_DEFAULT_REQ_T(core_obi_data_req_t, core_data_obi_a_chan_t)
  `OBI_TYPEDEF_RSP_T(core_obi_data_rsp_t, core_data_obi_r_chan_t)

  `OBI_TYPEDEF_ALL_A_OPTIONAL(core_instr_obi_a_optional_t, AUSER_WIDTH, WUSER_WIDTH, MID_WIDTH, ACHK_WIDTH)
  `OBI_TYPEDEF_ALL_R_OPTIONAL(core_instr_obi_r_optional_t, RUSER_WIDTH, RCHK_WIDTH)
  `OBI_TYPEDEF_A_CHAN_T(core_instr_obi_a_chan_t, ADDR_W, DATA_W, AID_WIDTH, core_instr_obi_a_optional_t)
  `OBI_TYPEDEF_R_CHAN_T(core_instr_obi_r_chan_t, DATA_W, RID_WIDTH, core_instr_obi_r_optional_t)
  `OBI_TYPEDEF_DEFAULT_REQ_T(core_obi_instr_req_t, core_instr_obi_a_chan_t)
  `OBI_TYPEDEF_RSP_T(core_obi_instr_rsp_t, core_instr_obi_r_chan_t)

  `HCI_TYPEDEF_REQ_T(core_hci_data_req_t, logic[AWC-1:0], logic[DW_LIC-1:0], logic[SW_LIC-1:0], logic signed[WORDS_DATA-1:0][AWH:0], logic[UWH-1:0])
  `HCI_TYPEDEF_RSP_T(core_hci_data_rsp_t, logic[DW_LIC-1:0], logic[UWH-1:0])

  `AXI_TYPEDEF_ALL_CT(core_axi_data, core_axi_data_req_t, core_axi_data_rsp_t, logic[ADDR_W-1:0], logic[AXI_DATA_ID_W-1:0], logic[DATA_W-1:0], logic[STRB_W-1:0], logic[AXI_DATA_U_W-1:0])
  `AXI_TYPEDEF_ALL_CT(core_axi_instr, core_axi_instr_req_t, core_axi_instr_rsp_t, logic[ADDR_W-1:0], logic[AXI_INSTR_ID_W-1:0], logic[DATA_W-1:0], logic[STRB_W-1:0], logic[AXI_INSTR_U_W-1:0])

  `REG_BUS_TYPEDEF_ALL(idma_fe_reg, logic[ADDR_W-1:0], logic[DATA_W-1:0], logic[STRB_W-1:0])

  `IDMA_TYPEDEF_FULL_REQ_T(idma_be_req_t, logic[iDMA_AxiIdWidth-1:0], idma_addr_t, logic[iDMA_TFLenWidth-1:0])
  `IDMA_TYPEDEF_FULL_RSP_T(idma_be_rsp_t, idma_addr_t)
  `IDMA_TYPEDEF_FULL_ND_REQ_T(idma_nd_req_t, idma_be_req_t, logic[iDMA_RepWidth-1:0], logic[iDMA_StrideWidth-1:0])

  `AXI_TYPEDEF_ALL_CT(idma_axi, idma_axi_req_t, idma_axi_rsp_t, logic[iDMA_AddrWidth-1:0], logic[iDMA_AxiIdWidth-1:0], logic[iDMA_DataWidth-1:0], logic[iDMA_StrbWidth-1:0], logic[iDMA_UserWidth-1:0])
  `OBI_TYPEDEF_ALL(idma_obi, obi_pkg::obi_default_cfg(.AddrWidth(iDMA_AddrWidth), .DataWidth(iDMA_DataWidth), .IdWidth(iDMA_AxiIdWidth), .OptionalCfg(obi_pkg::ObiMinimalOptionalConfig)))

  typedef struct packed {
    struct packed {
      idma_axi_ar_chan_t ar_chan;
    } axi;
    struct packed {
      idma_obi_a_chan_t a_chan;
    } obi;
  } idma_read_meta_channel_t;
  
  typedef struct packed {
    struct packed {
      idma_axi_aw_chan_t aw_chan;
    } axi;
    struct packed {
      idma_obi_a_chan_t a_chan;
    } obi;
  } idma_write_meta_channel_t;

  `AXI_ALIAS(core_axi_data, axi_xbar_slv, core_axi_data_req_t, axi_xbar_slv_req_t, core_axi_data_rsp_t, axi_xbar_slv_rsp_t)

  `HCI_TYPEDEF_REQ_T(idma_hci_req_t, logic[AWC-1:0], logic[DW_LIC-1:0], logic[SW_LIC-1:0], logic signed[WORDS_DATA-1:0][AWH:0], logic[UWH-1:0])
  `HCI_TYPEDEF_RSP_T(idma_hci_rsp_t, logic[DW_LIC-1:0], logic[UWH-1:0])

endpackage: redmule_tile_pkg