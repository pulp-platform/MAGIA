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
  parameter time         ClkPeriodSys = 5ns,
  parameter int unsigned RstCycles    = 5,
  parameter real         TAppl        = 0.1,
  parameter real         TTest        = 0.9
)(
  output logic                                     clk,
  output logic                                     rst_n,
  output logic                                     test_mode,
  output logic                                     tile_enable,

  output logic                                     scan_cg_en,

  output logic [31:0]                              boot_addr,
  output logic [31:0]                              mtvec_addr,
  output logic [31:0]                              dm_halt_addr,
  output logic [31:0]                              dm_exception_addr,
  output logic [31:0]                              mhartid,
  output logic [ 3:0]                              mimpid_patch,

  input  logic [63:0]                              mcycle,
  output logic [63:0]                              time_var,

  output logic [redmule_tile_pkg::N_IRQ-1:0]       irq,

  input  logic                                     fencei_flush_req,
  output logic                                     fencei_flush_ack,

  output logic                                     debug_req,
  input  logic                                     debug_havereset,
  input  logic                                     debug_running,
  input  logic                                     debug_halted,
  input  logic                                     debug_pc_valid,
  input  logic                                     debug_pc,

  output logic                                     fetch_enable,
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

//TODO

/*******************************************************/
/**               Hardwired Signals End               **/
/*******************************************************/
/**             Clock and Reset Beginning             **/
/*******************************************************/

//TODO

/*******************************************************/
/**                Clock and Reset End                **/
/*******************************************************/
/**              TB Subroutines Beginning             **/
/*******************************************************/

  task automatic preload(input string image);
    //TODO
  endtask: preload

  task wait_for_reset;
    @(posedge rst_n);
    @(posedge clk);
  endtask: wait_for_reset

  task automatic init;
    //TODO
  endtask: init

  task automatic elf_run(input string binary);
    //TODO
  endtask: elf_run

  task automatic wait_for_eoc(output bit[31:0] exit_code);
    //TODO
  endtask: wait_for_eoc

/*******************************************************/
/**                 TB Subroutines End                **/
/*******************************************************/
/**                    I$ Beginning                   **/
/*******************************************************/

//TODO

/*******************************************************/
/**                       I$ End                      **/
/*******************************************************/

endmodule: redmule_tile_vip