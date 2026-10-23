/*
 * Copyright (C) 2026 ETH Zurich, University of Bologna and Fondazione Chips-IT
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
 * Author: Luca Balboni <luca.balboni@chips.it>
 *
 * CV32E40PX core with its eXtension Interface tied off, plus the instruction tracer under CORE_TRACES
 */

module magia_cv32e40px_wrap #(
  parameter bit          COREV_PULP       = 1'b0,  // PULP ISA extensions (custom CSRs, hardware loops)
  parameter bit          COREV_CLUSTER    = 1'b0,  // PULP cluster interface (cv.elw)
  parameter bit          FPU              = 1'b0,
  parameter int unsigned FPU_ADDMUL_LAT   = 0,     // Cycles
  parameter int unsigned FPU_OTHERS_LAT   = 0,     // Cycles
  parameter bit          ZFINX            = 1'b0,
  parameter int unsigned NUM_MHPMCOUNTERS = 1
)(
  input  logic        clk_i,
  input  logic        rst_ni,

  input  logic        pulp_clock_en_i,  // Read only with COREV_CLUSTER
  input  logic        scan_cg_en_i,

  input  logic [31:0] boot_addr_i,
  input  logic [31:0] mtvec_addr_i,
  input  logic [31:0] dm_halt_addr_i,
  input  logic [31:0] hart_id_i,
  input  logic [31:0] dm_exception_addr_i,

  output logic        instr_req_o,
  input  logic        instr_gnt_i,
  input  logic        instr_rvalid_i,
  output logic [31:0] instr_addr_o,
  input  logic [31:0] instr_rdata_i,

  output logic        data_req_o,
  input  logic        data_gnt_i,
  input  logic        data_rvalid_i,
  output logic        data_we_o,
  output logic [ 3:0] data_be_o,
  output logic [31:0] data_addr_o,
  output logic [31:0] data_wdata_o,
  input  logic [31:0] data_rdata_i,

  input  logic [31:0] irq_i,
  output logic        irq_ack_o,
  output logic [ 4:0] irq_id_o,

  input  logic        debug_req_i,
  output logic        debug_havereset_o,
  output logic        debug_running_o,
  output logic        debug_halted_o,

  input  logic        fetch_enable_i,
  output logic        core_sleep_o
);

  cv32e40px_top #(
    .COREV_X_IF       ( 0                ),
    .COREV_PULP       ( COREV_PULP       ),
    .COREV_CLUSTER    ( COREV_CLUSTER    ),
    .FPU              ( FPU              ),
    .FPU_ADDMUL_LAT   ( FPU_ADDMUL_LAT   ),
    .FPU_OTHERS_LAT   ( FPU_OTHERS_LAT   ),
    .ZFINX            ( ZFINX            ),
    .NUM_MHPMCOUNTERS ( NUM_MHPMCOUNTERS )
  ) i_cv32e40px_top (
    .clk_i                ( clk_i               ),
    .rst_ni               ( rst_ni              ),

    .pulp_clock_en_i      ( pulp_clock_en_i     ),
    .scan_cg_en_i         ( scan_cg_en_i        ),

    .boot_addr_i          ( boot_addr_i         ),
    .mtvec_addr_i         ( mtvec_addr_i        ),
    .dm_halt_addr_i       ( dm_halt_addr_i      ),
    .hart_id_i            ( hart_id_i           ),
    .dm_exception_addr_i  ( dm_exception_addr_i ),

    .instr_req_o          ( instr_req_o         ),
    .instr_gnt_i          ( instr_gnt_i         ),
    .instr_rvalid_i       ( instr_rvalid_i      ),
    .instr_addr_o         ( instr_addr_o        ),
    .instr_rdata_i        ( instr_rdata_i       ),

    .data_req_o           ( data_req_o          ),
    .data_gnt_i           ( data_gnt_i          ),
    .data_rvalid_i        ( data_rvalid_i       ),
    .data_we_o            ( data_we_o           ),
    .data_be_o            ( data_be_o           ),
    .data_addr_o          ( data_addr_o         ),
    .data_wdata_o         ( data_wdata_o        ),
    .data_rdata_i         ( data_rdata_i        ),

    .x_compressed_valid_o (                     ),
    .x_compressed_ready_i ( 1'b0                ),
    .x_compressed_req_o   (                     ),
    .x_compressed_resp_i  ( '0                  ),
    .x_issue_valid_o      (                     ),
    .x_issue_ready_i      ( 1'b0                ),
    .x_issue_req_o        (                     ),
    .x_issue_resp_i       ( '0                  ),
    .x_commit_valid_o     (                     ),
    .x_commit_o           (                     ),
    .x_mem_valid_i        ( 1'b0                ),
    .x_mem_ready_o        (                     ),
    .x_mem_req_i          ( '0                  ),
    .x_mem_resp_o         (                     ),
    .x_mem_result_valid_o (                     ),
    .x_mem_result_o       (                     ),
    .x_result_valid_i     ( 1'b0                ),
    .x_result_ready_o     (                     ),
    .x_result_i           ( '0                  ),

    .irq_i                ( irq_i               ),
    .irq_ack_o            ( irq_ack_o           ),
    .irq_id_o             ( irq_id_o            ),

    .debug_req_i          ( debug_req_i         ),
    .debug_havereset_o    ( debug_havereset_o   ),
    .debug_running_o      ( debug_running_o     ),
    .debug_halted_o       ( debug_halted_o      ),

    .fetch_enable_i       ( fetch_enable_i      ),
    .core_sleep_o         ( core_sleep_o        )
  );

`ifdef CORE_TRACES
  // Writes trace_core_<hart_id>.log in the simulation directory
  cv32e40px_tracer #(
    .FPU   ( FPU   ),
    .ZFINX ( ZFINX )
  ) i_tracer (
    .clk_i                 ( i_cv32e40px_top.core_i.clk_i                                         ),
    .rst_n                 ( i_cv32e40px_top.core_i.rst_ni                                        ),

    .hart_id_i             ( i_cv32e40px_top.core_i.hart_id_i                                     ),

    .pc                    ( i_cv32e40px_top.core_i.id_stage_i.pc_id_i                            ),
    .instr                 ( i_cv32e40px_top.core_i.id_stage_i.instr                              ),
    .controller_state_i    ( i_cv32e40px_top.core_i.id_stage_i.controller_i.ctrl_fsm_cs           ),
    .compressed            ( i_cv32e40px_top.core_i.id_stage_i.is_compressed_i                    ),
    .id_valid              ( i_cv32e40px_top.core_i.id_stage_i.id_valid_o                         ),
    .is_decoding           ( i_cv32e40px_top.core_i.id_stage_i.is_decoding_o                      ),
    .is_illegal            ( i_cv32e40px_top.core_i.id_stage_i.illegal_insn_dec                   ),
    .trigger_match         ( i_cv32e40px_top.core_i.id_stage_i.trigger_match_i                    ),
    .rs1_value             ( i_cv32e40px_top.core_i.id_stage_i.operand_a_fw_id                    ),
    .rs2_value             ( i_cv32e40px_top.core_i.id_stage_i.operand_b_fw_id                    ),
    .rs3_value             ( i_cv32e40px_top.core_i.id_stage_i.alu_operand_c                      ),
    .rs2_value_vec         ( i_cv32e40px_top.core_i.id_stage_i.alu_operand_b                      ),

    .rs1_is_fp             ( i_cv32e40px_top.core_i.id_stage_i.regfile_fp_a                       ),
    .rs2_is_fp             ( i_cv32e40px_top.core_i.id_stage_i.regfile_fp_b                       ),
    .rs3_is_fp             ( i_cv32e40px_top.core_i.id_stage_i.regfile_fp_c                       ),
    .rd_is_fp              ( i_cv32e40px_top.core_i.id_stage_i.regfile_fp_d                       ),

    .ex_valid              ( i_cv32e40px_top.core_i.ex_valid                                      ),
    .ex_reg_addr           ( i_cv32e40px_top.core_i.regfile_alu_waddr_fw                          ),
    .ex_reg_we             ( i_cv32e40px_top.core_i.regfile_alu_we_fw                             ),
    .ex_reg_wdata          ( i_cv32e40px_top.core_i.regfile_alu_wdata_fw                          ),

    .ex_data_addr          ( i_cv32e40px_top.core_i.data_addr_o                                   ),
    .ex_data_req           ( i_cv32e40px_top.core_i.data_req_o                                    ),
    .ex_data_gnt           ( i_cv32e40px_top.core_i.data_gnt_i                                    ),
    .ex_data_we            ( i_cv32e40px_top.core_i.data_we_o                                     ),
    .ex_data_wdata         ( i_cv32e40px_top.core_i.data_wdata_o                                  ),
    .data_misaligned       ( i_cv32e40px_top.core_i.data_misaligned                               ),

    .ebrk_insn             ( i_cv32e40px_top.core_i.id_stage_i.ebrk_insn_dec                      ),
    .debug_mode            ( i_cv32e40px_top.core_i.debug_mode                                    ),
    .ebrk_force_debug_mode ( i_cv32e40px_top.core_i.id_stage_i.controller_i.ebrk_force_debug_mode ),

    .wb_bypass             ( i_cv32e40px_top.core_i.ex_stage_i.branch_in_ex_i                     ),

    .wb_valid              ( i_cv32e40px_top.core_i.wb_valid                                      ),
    .wb_reg_addr           ( i_cv32e40px_top.core_i.regfile_waddr_fw_wb_o                         ),
    .wb_reg_we             ( i_cv32e40px_top.core_i.regfile_we_wb                                 ),
    .wb_reg_wdata          ( i_cv32e40px_top.core_i.regfile_wdata                                 ),

    .imm_u_type            ( i_cv32e40px_top.core_i.id_stage_i.imm_u_type                         ),
    .imm_uj_type           ( i_cv32e40px_top.core_i.id_stage_i.imm_uj_type                        ),
    .imm_i_type            ( i_cv32e40px_top.core_i.id_stage_i.imm_i_type                         ),
    .imm_iz_type           ( i_cv32e40px_top.core_i.id_stage_i.imm_iz_type[11:0]                  ),
    .imm_z_type            ( i_cv32e40px_top.core_i.id_stage_i.imm_z_type                         ),
    .imm_s_type            ( i_cv32e40px_top.core_i.id_stage_i.imm_s_type                         ),
    .imm_sb_type           ( i_cv32e40px_top.core_i.id_stage_i.imm_sb_type                        ),
    .imm_s2_type           ( i_cv32e40px_top.core_i.id_stage_i.imm_s2_type                        ),
    .imm_s3_type           ( i_cv32e40px_top.core_i.id_stage_i.imm_s3_type                        ),
    .imm_vs_type           ( i_cv32e40px_top.core_i.id_stage_i.imm_vs_type                        ),
    .imm_vu_type           ( i_cv32e40px_top.core_i.id_stage_i.imm_vu_type                        ),
    .imm_shuffle_type      ( i_cv32e40px_top.core_i.id_stage_i.imm_shuffle_type                   ),
    .imm_clip_type         ( i_cv32e40px_top.core_i.id_stage_i.instr[11:7]                        ),
    .apu_en_i              ( i_cv32e40px_top.apu_req                                              ),
    .apu_singlecycle_i     ( i_cv32e40px_top.core_i.ex_stage_i.apu_singlecycle                    ),
    .apu_multicycle_i      ( i_cv32e40px_top.core_i.ex_stage_i.apu_multicycle                     ),
    .apu_rvalid_i          ( i_cv32e40px_top.core_i.ex_stage_i.apu_valid                          )
  );
`endif

endmodule: magia_cv32e40px_wrap
