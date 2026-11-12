/*
 * Copyright (C) 2026 ETH Zurich, University of Bologna and Fondazione Chips-IT
 *
 * Licensed under the Solderpad Hardware License, Version 0.51
 * (the "License"); you may not use this file except in compliance
 * with the License. You may obtain a copy of the License at
 *
 *     http://solderpad.org/licenses/SHL-0.51
 *
 * Unless required by applicable law or agreed to in writing, software, hardware
 * and materials distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * SPDX-License-Identifier: SHL-0.51
 *
 * Authors: Davide Pala, Fondazione Chips-IT
 *          Luca Balboni, Fondazione Chips-IT
 *
 * CV32E40PX with the Spatz vector unit on its eXtension Interface, booted and dispatched like a one-core cluster
 */

`include "tcdm_interface/typedef.svh"

module cv32e40px_spatz_wrapper
  import cv32e40px_core_v_xif_pkg::*;
  import magia_tile_pkg::*;
#(
  // HCI types are supplied by magia_isle
  parameter type          hci_req_t   = magia_tile_pkg::core_hci_data_req_t,
  parameter type          hci_rsp_t   = magia_tile_pkg::core_hci_data_rsp_t,
  // Scalar L1 port first, then the VLSU ports, each split into 32-bit HCI ports
  localparam int unsigned NumHciPorts = magia_tile_pkg::gen_spatz_hci_ports()
)(
  input  logic clk_i,
  input  logic rst_ni,
  input  logic test_mode_i,

  input  logic [31:0] hart_id_i,

  // From the Spatz CSR (obi_slave_ctrl_cluster)
  input  logic [31:0] boot_addr_i,
  input  logic        fetch_enable_i,
  input  logic        start_i,  // Machine external interrupt: wakes the dispatcher from WFI

  // TCDM ranges of the scalar data port; everything else goes to the OBI crossbar
  input  magia_tile_pkg::obi_xbar_rule_t [magia_tile_pkg::NUM_TCDM_RULES-1:0] tcdm_rules_i,

  output magia_tile_pkg::core_obi_data_req_t obi_data_req_o,
  input  magia_tile_pkg::core_obi_data_rsp_t obi_data_rsp_i,

  output hci_req_t [NumHciPorts-1:0] hci_req_o,
  input  hci_rsp_t [NumHciPorts-1:0] hci_rsp_i,

  output magia_tile_pkg::core_instr_req_t instr_req_o,
  input  magia_tile_pkg::core_instr_rsp_t instr_rsp_i
);

/*******************************************************/
/**              Configuration Beginning              **/
/*******************************************************/

  localparam int unsigned NumVlsuPorts = spatz_pkg::N_FU;
  localparam int unsigned VlsuDataW    = spatz_pkg::ELEN;

  localparam int unsigned DataDemuxNumSlv  = 2;
  localparam int unsigned DataDemuxTcdmIdx = 0;  // Must match idx of tcdm_rules_i
  localparam int unsigned DataDemuxObiIdx  = 1;

  // Major opcodes of the vector loads and stores, the only offloaded memory accesses
  localparam logic [6:0] OpcodeLoadFp  = 7'b0000111;
  localparam logic [6:0] OpcodeStoreFp = 7'b0100111;
  localparam logic [6:0] OpcodeOpV     = 7'b1010111;

  localparam logic [2:0] Funct3OpFvv  = 3'b001;
  localparam logic [5:0] Funct6Unary0 = 6'b010000;  // VWFUNARY0 under OPFVV: vfmv.f.s

  localparam int unsigned VlsuCntW = 4;  // Outstanding TCDM requests per VLSU port, above the converters' FIFO depth

  // Offload channels between the XIF and Spatz' accelerator port
  typedef struct packed {
    logic [X_ID_WIDTH-1:0] id;
    logic [31:0]           data_op;
    logic [31:0]           data_arga;
    logic [31:0]           data_argb;
    logic [31:0]           data_argc;
  } acc_issue_req_t;

  typedef struct packed {
    logic accept;
    logic writeback;
    logic loadstore;
    logic exception;
    logic isfloat;
  } acc_issue_rsp_t;

  typedef struct packed {
    logic [X_ID_WIDTH-1:0] id;
    logic [4:0]            rd;
    logic                  error;
    logic [31:0]           data;
    logic                  we;
  } acc_rsp_t;

  // VLSU ports, as wide as a vector element
  typedef logic [VlsuDataW-1:0]   vlsu_data_t;
  typedef logic [VlsuDataW/8-1:0] vlsu_strb_t;

  `TCDM_TYPEDEF_ALL(vlsu, magia_tile_pkg::spatz_tcdm64_addr_t, vlsu_data_t, vlsu_strb_t, logic)

`ifndef SYNTHESIS
  if (VlsuDataW != 32 && VlsuDataW != 64) begin: gen_err_vlsu_data_w
    $fatal(1, "cv32e40px_spatz_wrapper: spatz_pkg::ELEN=%0d, only 32 and 64 are supported", VlsuDataW);
  end
`endif

/*******************************************************/
/**                 Configuration End                 **/
/*******************************************************/
/**                   Core Beginning                  **/
/*******************************************************/

  magia_tile_pkg::core_data_req_t core_data_req;
  magia_tile_pkg::core_data_rsp_t core_data_rsp;

  logic               x_compressed_valid;
  x_compressed_req_t  x_compressed_req;
  logic               x_issue_valid;
  logic               x_issue_ready;
  x_issue_req_t       x_issue_req;
  x_issue_resp_t      x_issue_resp;
  logic               x_result_valid;
  logic               x_result_ready;
  x_result_t          x_result;

  logic unused_xif;
  logic core_sleep;

  // Spatz takes no compressed, commit or memory transaction: it has its own VLSU
  assign unused_xif = ^{x_compressed_valid, x_compressed_req};

  magia_cv32e40px_wrap #(
    .COREV_X_IF       ( 1'b1 ),
    .COREV_PULP       ( 1'b0 ),
    .COREV_CLUSTER    ( 1'b0 ),
    .FPU              ( 1'b1 ),
    .FPU_ADDMUL_LAT   ( 1    ),  // Match C_LAT_FP32 in the fpnew wrapper
    .FPU_OTHERS_LAT   ( 1    ),  // Match C_LAT_NONCOMP in the fpnew wrapper
    .ZFINX            ( 1'b0 ),  // Vector instructions take scalar FP operands from the F registers
    .NUM_MHPMCOUNTERS ( 1    )
  ) i_core (
    .clk_i                ( clk_i                         ),
    .rst_ni               ( rst_ni                        ),

    .pulp_clock_en_i      ( 1'b1                          ),
    .scan_cg_en_i         ( test_mode_i                   ),
    .boot_addr_i          ( boot_addr_i                   ),
    .mtvec_addr_i         ( boot_addr_i                   ),  // SW can move mtvec with csrw
    .dm_halt_addr_i       ( magia_tile_pkg::DM_HALT_ADDR  ),
    .hart_id_i            ( hart_id_i                     ),
    .dm_exception_addr_i  ( magia_tile_pkg::DM_HALT_ADDR + 32'h000C ),

    .instr_req_o          ( instr_req_o.req               ),
    .instr_gnt_i          ( instr_rsp_i.gnt               ),
    .instr_rvalid_i       ( instr_rsp_i.rvalid            ),
    .instr_addr_o         ( instr_req_o.addr              ),
    .instr_rdata_i        ( instr_rsp_i.rdata             ),

    .data_req_o           ( core_data_req.req             ),
    .data_gnt_i           ( core_data_rsp.gnt             ),
    .data_rvalid_i        ( core_data_rsp.rvalid          ),
    .data_we_o            ( core_data_req.we              ),
    .data_be_o            ( core_data_req.be              ),
    .data_addr_o          ( core_data_req.addr            ),
    .data_wdata_o         ( core_data_req.wdata           ),
    .data_rdata_i         ( core_data_rsp.rdata           ),

    .irq_i                ( {20'h0, start_i, 11'h0}       ),
    .irq_ack_o            (                               ),
    .irq_id_o             (                               ),

    .debug_req_i          ( 1'b0                          ),
    .debug_havereset_o    (                               ),
    .debug_running_o      (                               ),
    .debug_halted_o       (                               ),

    .fetch_enable_i       ( fetch_enable_i                ),
    .core_sleep_o         ( core_sleep                    ),

    .x_compressed_valid_o ( x_compressed_valid            ),
    .x_compressed_ready_i ( 1'b1                          ),
    .x_compressed_req_o   ( x_compressed_req              ),
    .x_compressed_resp_i  ( '0                            ),  // Never accepted: an illegal instruction
    .x_issue_valid_o      ( x_issue_valid                 ),
    .x_issue_ready_i      ( x_issue_ready                 ),
    .x_issue_req_o        ( x_issue_req                   ),
    .x_issue_resp_i       ( x_issue_resp                  ),
    .x_commit_valid_o     (                               ),
    .x_commit_o           (                               ),
    .x_mem_valid_i        ( 1'b0                          ),
    .x_mem_ready_o        (                               ),
    .x_mem_req_i          ( '0                            ),
    .x_mem_resp_o         (                               ),
    .x_mem_result_valid_o (                               ),
    .x_mem_result_o       (                               ),
    .x_result_valid_i     ( x_result_valid                ),
    .x_result_ready_o     ( x_result_ready                ),
    .x_result_i           ( x_result                      )
  );

  assign instr_req_o.memtype = 2'b00;
  assign instr_req_o.prot    = 3'b000;
  assign instr_req_o.dbg     = 1'b0;

/*******************************************************/
/**                     Core End                      **/
/*******************************************************/
/**                   Spatz Beginning                 **/
/*******************************************************/

  logic           acc_issue_valid;
  logic           acc_issue_ready;
  acc_issue_req_t acc_issue_req;
  acc_issue_rsp_t acc_issue_rsp;
  logic           acc_rsp_valid;
  logic           acc_rsp_ready;
  acc_rsp_t       acc_rsp;

  logic core_pipe_free;

  // Offload only once ID could advance and no load or FP op is in flight, else rs can be stale
  assign core_pipe_free = ~i_core.i_cv32e40px_top.core_i.lsu_busy &
                          ~i_core.i_cv32e40px_top.core_i.apu_busy_o &
                          i_core.i_cv32e40px_top.core_i.id_stage_i.ex_ready_i &
                          ~i_core.i_cv32e40px_top.core_i.id_stage_i.load_stall &
                          ~i_core.i_cv32e40px_top.core_i.id_stage_i.apu_stall &
                          ~i_core.i_cv32e40px_top.core_i.id_stage_i.csr_apu_stall &
                          ~i_core.i_cv32e40px_top.core_i.id_stage_i.misaligned_stall &
                          ~i_core.i_cv32e40px_top.core_i.id_stage_i.jr_stall;

  logic writes_freg;  // vfmv.f.s: XIF results always land in the integer register file

  assign writes_freg = (x_issue_req.instr[6:0] == OpcodeOpV) & (x_issue_req.instr[14:12] == Funct3OpFvv) &
                       (x_issue_req.instr[31:26] == Funct6Unary0);

  // vfmv.f.s never reaches Spatz and is refused: the core raises an illegal instruction
  assign acc_issue_valid = x_issue_valid & core_pipe_free & ~writes_freg;
  assign x_issue_ready   = (acc_issue_ready | writes_freg) & core_pipe_free;

  always_comb begin
    acc_issue_req           = '0;
    acc_issue_req.id        = x_issue_req.id;
    acc_issue_req.data_op   = x_issue_req.instr;
    acc_issue_req.data_arga = x_issue_req.rs[0];
    acc_issue_req.data_argb = x_issue_req.rs[1];
    acc_issue_req.data_argc = x_issue_req.rs[2];
  end

  always_comb begin
    x_issue_resp           = '0;
    x_issue_resp.accept    = acc_issue_rsp.accept & ~writes_freg;
    x_issue_resp.writeback = acc_issue_rsp.writeback & ~writes_freg;
    x_issue_resp.loadstore = acc_issue_rsp.loadstore;
    x_issue_resp.exc       = acc_issue_rsp.exception;
  end

  // Results wait while the core sleeps in WFI: its clock is gated and would drop them
  assign x_result_valid = acc_rsp_valid & ~core_sleep;
  assign acc_rsp_ready  = x_result_ready & ~core_sleep;

  always_comb begin
    x_result      = '0;
    x_result.id   = acc_rsp.id;
    x_result.data = acc_rsp.data;
    x_result.rd   = acc_rsp.rd;
    x_result.we   = acc_rsp.we;
    x_result.err  = acc_rsp.error;
  end

  vlsu_req_chan_t [NumVlsuPorts-1:0] vlsu_req;
  logic           [NumVlsuPorts-1:0] vlsu_req_valid;
  logic           [NumVlsuPorts-1:0] vlsu_req_ready;
  vlsu_rsp_chan_t [NumVlsuPorts-1:0] vlsu_rsp;
  logic           [NumVlsuPorts-1:0] vlsu_rsp_valid;

  fpnew_pkg::roundmode_e frm;
  fpnew_pkg::status_t    unused_fpu_status;

  // The core has no port for its frm CSR; the vector FP flags are not merged into its fflags
  assign frm = fpnew_pkg::roundmode_e'(i_core.i_cv32e40px_top.core_i.frm_csr);

  spatz #(
    .NrMemPorts          ( NumVlsuPorts                    ),
    .NumOutstandingLoads ( magia_tile_pkg::SPATZ_NUM_SPATZ_OUTSTANDING_LOADS ),
    .FPUImplementation   ( magia_tile_pkg::SPATZ_FPUImplementation ),
    .RegisterRsp         ( 1'b1                            ),
    .dreq_t              ( logic                           ),  // No FP LSU: the core loads its F registers
    .drsp_t              ( logic                           ),
    .spatz_mem_req_t     ( vlsu_req_chan_t                 ),
    .spatz_mem_rsp_t     ( vlsu_rsp_chan_t                 ),
    .spatz_issue_req_t   ( acc_issue_req_t                 ),
    .spatz_issue_rsp_t   ( acc_issue_rsp_t                 ),
    .spatz_rsp_t         ( acc_rsp_t                       )
  ) i_spatz (
    .clk_i                    ( clk_i             ),
    .rst_ni                   ( rst_ni            ),
    .testmode_i               ( test_mode_i       ),
    .hart_id_i                ( hart_id_i         ),

    .issue_valid_i            ( acc_issue_valid   ),
    .issue_ready_o            ( acc_issue_ready   ),
    .issue_req_i              ( acc_issue_req     ),
    .issue_rsp_o              ( acc_issue_rsp     ),
    .rsp_valid_o              ( acc_rsp_valid     ),
    .rsp_ready_i              ( acc_rsp_ready     ),
    .rsp_o                    ( acc_rsp           ),

    .spatz_mem_req_o          ( vlsu_req          ),
    .spatz_mem_req_valid_o    ( vlsu_req_valid    ),
    .spatz_mem_req_ready_i    ( vlsu_req_ready    ),
    .spatz_mem_rsp_i          ( vlsu_rsp          ),
    .spatz_mem_rsp_valid_i    ( vlsu_rsp_valid    ),
    .spatz_mem_finished_o     (                   ),
    .spatz_mem_str_finished_o (                   ),

    .fp_lsu_mem_req_o         (                   ),
    .fp_lsu_mem_rsp_i         ( '0                ),
    .fpu_rnd_mode_i           ( frm               ),
    .fpu_fmt_mode_i           ( '0                ),
    .fpu_status_o             ( unused_fpu_status )
  );

/*******************************************************/
/**                     Spatz End                     **/
/*******************************************************/
/**             Memory Ordering Beginning             **/
/*******************************************************/

  // The XIF has no fence: scalar accesses wait until no vector access is in flight
  logic [2**X_ID_WIDTH-1:0] vmem_pending_d, vmem_pending_q;  // Vector loads/stores without result, by XIF id
  logic                     vmem_issue;
  logic                     vlsu_busy;
  logic                     vmem_busy;

  assign vmem_issue = x_issue_valid & x_issue_ready & x_issue_resp.accept &
                      ((x_issue_req.instr[6:0] == OpcodeLoadFp) | (x_issue_req.instr[6:0] == OpcodeStoreFp));

  always_comb begin
    vmem_pending_d = vmem_pending_q;
    if (x_result_valid & x_result_ready) begin
      vmem_pending_d[x_result.id] = 1'b0;
    end
    if (vmem_issue) begin
      vmem_pending_d[x_issue_req.id] = 1'b1;
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      vmem_pending_q <= '0;
    end else begin
      vmem_pending_q <= vmem_pending_d;
    end
  end

  assign vmem_busy = (vmem_pending_q != '0) | vlsu_busy;

  magia_tile_pkg::core_data_req_t core_data_req_ordered;
  magia_tile_pkg::core_data_rsp_t core_data_rsp_ordered;

  // The demux grants while idle, so the grant is held back together with the request
  always_comb begin
    core_data_req_ordered     = core_data_req;
    core_data_req_ordered.req = core_data_req.req & ~vmem_busy;
    core_data_rsp             = core_data_rsp_ordered;
    core_data_rsp.gnt         = core_data_rsp_ordered.gnt & ~vmem_busy;
  end

/*******************************************************/
/**               Memory Ordering End                 **/
/*******************************************************/
/**               Scalar Data Beginning               **/
/*******************************************************/

  magia_tile_pkg::core_data_req_t [DataDemuxNumSlv-1:0] data_demux_req;
  magia_tile_pkg::core_data_rsp_t [DataDemuxNumSlv-1:0] data_demux_rsp;

  core_data_demux #(
    .NumSlv     ( DataDemuxNumSlv                 ),
    .NumRules   ( magia_tile_pkg::NUM_TCDM_RULES  ),
    .DefaultSlv ( DataDemuxObiIdx                 ),
    .req_t      ( magia_tile_pkg::core_data_req_t ),
    .rsp_t      ( magia_tile_pkg::core_data_rsp_t )
  ) i_data_demux (
    .clk_i              ( clk_i                 ),
    .rst_ni             ( rst_ni                ),
    .clk_en_i           ( 1'b1                  ),  // The core gates only its own clock, never with requests in flight
    .core_data_req_i    ( core_data_req_ordered ),
    .core_data_atomic_i ( 1'b0                  ),
    .core_data_rsp_o    ( core_data_rsp_ordered ),
    .addr_map_i         ( tcdm_rules_i          ),
    .slv_data_req_o     ( data_demux_req        ),
    .slv_data_rsp_i     ( data_demux_rsp        )
  );

  data2obi_req i_data2obi_req (
    .data_req_i ( data_demux_req[DataDemuxObiIdx] ),
    .obi_req_o  ( obi_data_req_o                  )
  );

  obi2data_rsp i_obi2data_rsp (
    .obi_rsp_i  ( obi_data_rsp_i                  ),
    .data_rsp_o ( data_demux_rsp[DataDemuxObiIdx] )
  );

  magia_tile_pkg::core_obi_data_req_t tcdm_obi_req;
  magia_tile_pkg::core_obi_data_rsp_t tcdm_obi_rsp;

  data2obi_req i_tcdm_data2obi_req (
    .data_req_i ( data_demux_req[DataDemuxTcdmIdx] ),
    .obi_req_o  ( tcdm_obi_req                     )
  );

  obi2data_rsp i_tcdm_obi2data_rsp (
    .obi_rsp_i  ( tcdm_obi_rsp                     ),
    .data_rsp_o ( data_demux_rsp[DataDemuxTcdmIdx] )
  );

  obi2hci_req #(
    .obi_req_t ( magia_tile_pkg::core_obi_data_req_t ),
    .hci_req_t ( hci_req_t                           )
  ) i_tcdm_obi2hci_req (
    .obi_req_i ( tcdm_obi_req ),
    .hci_req_o ( hci_req_o[0] )
  );

  hci2obi_rsp #(
    .hci_rsp_t ( hci_rsp_t                           ),
    .obi_rsp_t ( magia_tile_pkg::core_obi_data_rsp_t )
  ) i_tcdm_hci2obi_rsp (
    .hci_rsp_i ( hci_rsp_i[0] ),
    .obi_rsp_o ( tcdm_obi_rsp )
  );

/*******************************************************/
/**                 Scalar Data End                   **/
/*******************************************************/
/**                 VLSU Ports Beginning              **/
/*******************************************************/

  logic [NumVlsuPorts-1:0] vlsu_port_busy;

  assign vlsu_busy = |vlsu_port_busy;

  for (genvar i = 0; i < NumVlsuPorts; i++) begin: gen_vlsu_port
    vlsu_req_t vlsu_tcdm_req;
    vlsu_rsp_t vlsu_tcdm_rsp;

    logic [VlsuCntW-1:0] outstanding_d, outstanding_q;  // Accepted requests still without response

    assign outstanding_d = outstanding_q + VlsuCntW'(vlsu_req_valid[i] & vlsu_req_ready[i])
                                         - VlsuCntW'(vlsu_rsp_valid[i]);

    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        outstanding_q <= '0;
      end else begin
        outstanding_q <= outstanding_d;
      end
    end

    assign vlsu_port_busy[i] = vlsu_req_valid[i] | (outstanding_q != '0);

    assign vlsu_tcdm_req.q       = vlsu_req[i];
    assign vlsu_tcdm_req.q_valid = vlsu_req_valid[i];
    assign vlsu_req_ready[i]     = vlsu_tcdm_rsp.q_ready;
    assign vlsu_rsp[i]           = vlsu_tcdm_rsp.p;
    assign vlsu_rsp_valid[i]     = vlsu_tcdm_rsp.p_valid;

    if (VlsuDataW == 64) begin: gen_dual_hci32
      tcdm64_to_dual_hci32 #(
        .tcdm64_req_t ( vlsu_req_t ),
        .tcdm64_rsp_t ( vlsu_rsp_t ),
        .hci_req_t    ( hci_req_t  ),
        .hci_rsp_t    ( hci_rsp_t  )
      ) i_tcdm64_to_dual_hci32 (
        .clk_i        ( clk_i                ),
        .rst_ni       ( rst_ni               ),
        .tcdm_req_i   ( vlsu_tcdm_req        ),
        .tcdm_rsp_o   ( vlsu_tcdm_rsp        ),
        .hci_req_lo_o ( hci_req_o[1 + 2*i]   ),
        .hci_rsp_lo_i ( hci_rsp_i[1 + 2*i]   ),
        .hci_req_hi_o ( hci_req_o[2 + 2*i]   ),
        .hci_rsp_hi_i ( hci_rsp_i[2 + 2*i]   )
      );
    end else begin: gen_hci32
      tcdm2hci #(
        .tcdm_req_t ( vlsu_req_t ),
        .tcdm_rsp_t ( vlsu_rsp_t ),
        .hci_req_t  ( hci_req_t  ),
        .hci_rsp_t  ( hci_rsp_t  )
      ) i_tcdm2hci (
        .clk_i      ( clk_i            ),
        .rst_ni     ( rst_ni           ),
        .tcdm_req_i ( vlsu_tcdm_req    ),
        .tcdm_rsp_o ( vlsu_tcdm_rsp    ),
        .hci_req_o  ( hci_req_o[1 + i] ),
        .hci_rsp_i  ( hci_rsp_i[1 + i] )
      );
    end
  end

/*******************************************************/
/**                  VLSU Ports End                   **/
/*******************************************************/

endmodule: cv32e40px_spatz_wrapper
