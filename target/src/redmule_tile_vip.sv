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
 * RedMulE Tile Verification IP
 */

module redmule_tile_vip
  import redmule_tile_pkg::*;
  import redmule_tile_tb_pkg::*;
#(
  // Timing
  parameter time         CLK_PERIOD = 5ns,
  parameter int unsigned RST_CYCLES = 5,
  parameter real         T_APPL     = 0.1,
  parameter real         T_TEST     = 0.9
)(
  output logic                                     clk,
  output logic                                     rst_n,
  output logic                                     test_mode,
  output logic                                     tile_enable,

  input  redmule_tile_pkg::core_axi_data_req_t     core_data_req,
  output redmule_tile_pkg::core_axi_data_rsp_t     core_data_rsp,

  input  redmule_tile_pkg::core_axi_instr_req_t    core_instr_req,
  output redmule_tile_pkg::core_axi_instr_rsp_t    core_instr_rsp,

  output logic                                     scan_cg_en,

  output logic [31:0]                              boot_addr, //TODO: manage signal
  output logic [31:0]                              mtvec_addr,
  output logic [31:0]                              dm_halt_addr,
  output logic [31:0]                              dm_exception_addr,
  output logic [31:0]                              mhartid,
  output logic [ 3:0]                              mimpid_patch,

  input  logic [63:0]                              mcycle,
  output logic [63:0]                              time_var,

  output logic [redmule_tile_pkg::N_IRQ-1:0]       irq, //TODO: manage signal

  input  logic                                     fencei_flush_req,
  output logic                                     fencei_flush_ack,

  output logic                                     debug_req,
  input  logic                                     debug_havereset,
  input  logic                                     debug_running,
  input  logic                                     debug_halted,
  input  logic                                     debug_pc_valid,
  input  logic [31:0]                              debug_pc,

  output logic                                     fetch_enable,  //TODO: manage signal
  input  logic                                     core_sleep,
  output logic                                     wu_wfe,

  input  logic                                     busy,
  input  logic [redmule_tile_pkg::N_CORE-1:0][1:0] evt
);

/*******************************************************/
/**                   DPI Beginning                   **/
/*******************************************************/

//TODO

/*******************************************************/
/**                      DPI End                      **/
/*******************************************************/
/**            Hardwired Signals Beginning            **/
/*******************************************************/

  assign test_mode         = 1'b0;
  assign tile_enable       = 1'b1;
  assign scan_cg_en        = 1'b0;
  assign mtvec_addr        = '0;
  assign dm_halt_addr      = '0;
  assign dm_exception_addr = '0;
  assign mhartid           = '0;
  assign mimpid_patch      = '0;
  assign time_var          = '0;
  assign fencei_flush_ack  = 1'b0;
  assign debug_req         = 1'b0;
  assign wu_wfe            = 1'b0;

/*******************************************************/
/**               Hardwired Signals End               **/
/*******************************************************/
/**             Clock and Reset Beginning             **/
/*******************************************************/

  clk_rst_gen #(
    .ClkPeriod    ( CLK_PERIOD ),
    .RstClkCycles ( RST_CYCLES )
  ) i_clk_rst_sys (
    .clk_o  ( clk   ),
    .rst_no ( rst_n )
  );

/*******************************************************/
/**                Clock and Reset End                **/
/*******************************************************/
/**              TB Subroutines Beginning             **/
/*******************************************************/

  // Preload instruction cache subroutine
  task automatic inst_preload(input string image);
    $readmemh(image, i_instr_cache.mem);
  endtask: inst_preload

  // Preload data subroutine
  task automatic data_preload(input string image);
    $readmemh(image, i_l2_mem.mem);
  endtask: data_preload

  task wait_for_reset;
    @(posedge rst_n);
    @(posedge clk);
  endtask: wait_for_reset

  task automatic init(input bit[31:0] entry_addr);
    irq          = '0;
    fetch_enable = 1'b0;
    boot_addr    = entry_addr;
    #1000;
  endtask: init

  task automatic elf_run;
    fetch_enable = 1'b1;
    #1000;
  endtask: elf_run

  task automatic wait_for_eoc(output bit[31:0] exit_code);
    while (i_l2_mem.mem[32'h2C03_0000] == 0)
      #10000;
    exit_code = i_l2_mem.mem[32'h2C03_0000];
  endtask: wait_for_eoc

/*******************************************************/
/**                 TB Subroutines End                **/
/*******************************************************/
/**                    I$ Beginning                   **/
/*******************************************************/

  axi_sim_mem #(
    .AddrWidth          ( redmule_tile_pkg::ADDR_W               ),
    .DataWidth          ( redmule_tile_pkg::DATA_W               ),
    .IdWidth            ( 1                                      ),
    .UserWidth          ( 1                                      ),
    .axi_req_t          ( redmule_tile_pkg::core_axi_instr_req_t ),
    .axi_rsp_t          ( redmule_tile_pkg::core_axi_instr_rsp_t ),
    .WarnUninitialized  ( 1                                      ),
    .ClearErrOnAccess   ( 1                                      ),
    .ApplDelay          ( CLK_PERIOD * T_APPL                    ),
    .AcqDelay           ( CLK_PERIOD * T_TEST                    )
  ) i_instr_cache (
    .clk_i              ( clk            ),
    .rst_ni             ( rst_n          ),
    .axi_req_i          ( core_instr_req ),
    .axi_rsp_o          ( core_instr_rsp ),
    .mon_w_valid_o      (                ),
    .mon_w_addr_o       (                ),
    .mon_w_data_o       (                ),
    .mon_w_id_o         (                ),
    .mon_w_user_o       (                ),
    .mon_w_beat_count_o (                ),
    .mon_w_last_o       (                ),
    .mon_r_valid_o      (                ),
    .mon_r_addr_o       (                ),
    .mon_r_data_o       (                ),
    .mon_r_id_o         (                ),
    .mon_r_user_o       (                ),
    .mon_r_beat_count_o (                ),
    .mon_r_last_o       (                )
  );

/*******************************************************/
/**                       I$ End                      **/
/*******************************************************/
/**                  L2 MEM Beginning                 **/
/*******************************************************/

  axi_sim_mem #(
    .AddrWidth          ( redmule_tile_pkg::ADDR_W              ),
    .DataWidth          ( redmule_tile_pkg::DATA_W              ),
    .IdWidth            ( 1                                     ),
    .UserWidth          ( 1                                     ),
    .axi_req_t          ( redmule_tile_pkg::core_axi_data_req_t ),
    .axi_rsp_t          ( redmule_tile_pkg::core_axi_data_rsp_t ),
    .WarnUninitialized  ( 1                                     ),
    .ClearErrOnAccess   ( 1                                     ),
    .ApplDelay          ( CLK_PERIOD * T_APPL                   ),
    .AcqDelay           ( CLK_PERIOD * T_TEST                   )
  ) i_l2_mem (
    .clk_i              ( clk           ),
    .rst_ni             ( rst_n         ),
    .axi_req_i          ( core_data_req ),
    .axi_rsp_o          ( core_data_rsp ),
    .mon_w_valid_o      (               ),
    .mon_w_addr_o       (               ),
    .mon_w_data_o       (               ),
    .mon_w_id_o         (               ),
    .mon_w_user_o       (               ),
    .mon_w_beat_count_o (               ),
    .mon_w_last_o       (               ),
    .mon_r_valid_o      (               ),
    .mon_r_addr_o       (               ),
    .mon_r_data_o       (               ),
    .mon_r_id_o         (               ),
    .mon_r_user_o       (               ),
    .mon_r_beat_count_o (               ),
    .mon_r_last_o       (               )
  );

/*******************************************************/
/**                     L2 MEM End                    **/
/*******************************************************/

endmodule: redmule_tile_vip
