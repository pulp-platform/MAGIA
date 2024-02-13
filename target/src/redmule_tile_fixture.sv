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

//TODO

/*******************************************************/
/**           Internal Signal Definitions End         **/
/*******************************************************/
/**                   DUT Beginning                   **/
/*******************************************************/

redemule_tile #(
  .N_MEM_BANKS  (  ),
  .N_WORDS_BANK (  ),

  .CORE_ISA     (  ),
  .CORE_A       (  ),
  .CORE_B       (  ),
  .CORE_M       (  )
) dut (
  .clk_i               (  ),
  .rstn_i              (  ),
  .test_mode_i         (  ),
  .tile_enable_i       (  ),

  .scan_cg_en_i        (  ),

  .boot_addr_i         (  ),
  .mtvec_addr_i        (  ),
  .dm_halt_addr_i      (  ),
  .dm_exception_addr_i (  ),
  .mhartid_i           (  ),
  .mimpid_patch_i      (  ),

  .mcycle_o            (  ),
  .time_i              (  ),

  .irq_i               (  ),

  .fencei_flush_req_o  (  ),
  .fencei_flush_ack_i  (  ),

  .debug_req_i         (  ),
  .debug_havereset_o   (  ),
  .debug_running_o     (  ),
  .debug_halted_o      (  ),
  .debug_pc_valid_o    (  ),
  .debug_pc_o          (  ),

  .fetch_enable_i      (  ),
  .core_sleep_o        (  ),
  .wu_wfe_i            (  ),

  .busy_o              (  ),
  .evt_o               (  )
);

/*******************************************************/
/**                      DUT End                      **/
/*******************************************************/
/**                   VIP Beginning                   **/
/*******************************************************/

redmule_tile_vip #(

) vip (

);

/*******************************************************/
/**                      VIP End                      **/
/*******************************************************/

 endmodule: redmule_tile_fixture