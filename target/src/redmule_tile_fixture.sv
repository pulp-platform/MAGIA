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
 * RedMulE Tile Fixture
 */

module redmule_tile_fixture;

  import redmule_tile_pkg::*;
  import redmule_tile_tb_pkg::*;

/*******************************************************/
/**        Internal Signal Definitions Beginning      **/
/*******************************************************/

  logic                                     clk;
  logic                                     rst_n;
  logic                                     test_mode;
  logic                                     tile_enable;

  redmule_tile_pkg::axi_default_req_t       data_out_req;
  redmule_tile_pkg::axi_default_rsp_t       data_out_rsp;

  redmule_tile_pkg::core_axi_instr_req_t    core_instr_req;
  redmule_tile_pkg::core_axi_instr_rsp_t    core_instr_rsp;

  logic                                     scan_cg_en;

  logic [31:0]                              boot_addr;
  logic [31:0]                              mtvec_addr;
  logic [31:0]                              dm_halt_addr;
  logic [31:0]                              dm_exception_addr;
  logic [31:0]                              mhartid;
  logic [ 3:0]                              mimpid_patch;

  logic [63:0]                              mcycle;
  logic [63:0]                              time_var;

  logic [redmule_tile_pkg::N_IRQ-1:0]       irq;

  logic                                     fencei_flush_req;
  logic                                     fencei_flush_ack;

  logic                                     debug_req;
  logic                                     debug_havereset;
  logic                                     debug_running;
  logic                                     debug_halted;
  logic                                     debug_pc_valid;
  logic [31:0]                              debug_pc;

  logic                                     fetch_enable;
  logic                                     core_sleep;
  logic                                     wu_wfe;

  logic                                     busy;
  logic [redmule_tile_pkg::N_CORE-1:0][1:0] evt;

/*******************************************************/
/**           Internal Signal Definitions End         **/
/*******************************************************/
/**                   DUT Beginning                   **/
/*******************************************************/

  redmule_tile #(
    .N_MEM_BANKS  ( redmule_tile_tb_pkg::N_MEM_BANKS  ),
    .N_WORDS_BANK ( redmule_tile_tb_pkg::N_WORDS_BANK ),

    .CORE_ISA     (                                   ),
    .CORE_A       (                                   ),
    .CORE_B       (                                   ),
    .CORE_M       (                                   )
  ) dut (
    .clk_i               ( clk               ),
    .rst_ni              ( rst_n             ),
    .test_mode_i         ( test_mode         ),
    .tile_enable_i       ( tile_enable       ),

    .data_out_req_o      ( data_out_req      ),
    .data_out_rsp_i      ( data_out_rsp      ), 

    .core_instr_req_o    ( core_instr_req    ),
    .core_instr_rsp_i    ( core_instr_rsp    ),

    .scan_cg_en_i        ( scan_cg_en        ),

    .boot_addr_i         ( boot_addr         ),
    .mtvec_addr_i        ( mtvec_addr        ),
    .dm_halt_addr_i      ( dm_halt_addr      ),
    .dm_exception_addr_i ( dm_exception_addr ),
    .mhartid_i           ( mhartid           ),
    .mimpid_patch_i      ( mimpid_patch      ),

    .mcycle_o            ( mcycle            ),
    .time_i              ( time_var          ),

    .irq_i               ( irq               ),

    .fencei_flush_req_o  ( fencei_flush_req  ),
    .fencei_flush_ack_i  ( fencei_flush_ack  ),

    .debug_req_i         ( debug_req         ),
    .debug_havereset_o   ( debug_havereset   ),
    .debug_running_o     ( debug_running     ),
    .debug_halted_o      ( debug_halted      ),
    .debug_pc_valid_o    ( debug_pc_valid    ),
    .debug_pc_o          ( debug_pc          ),

    .fetch_enable_i      ( fetch_enable      ),
    .core_sleep_o        ( core_sleep        ),
    .wu_wfe_i            ( wu_wfe            ),

    .busy_o              ( busy              ),
    .evt_o               ( evt               )
  );

/*******************************************************/
/**                      DUT End                      **/
/*******************************************************/
/**                   VIP Beginning                   **/
/*******************************************************/

  redmule_tile_vip vip (.*);

/*******************************************************/
/**                      VIP End                      **/
/*******************************************************/

endmodule: redmule_tile_fixture
