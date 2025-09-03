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
 * MAGIA Fixture
 */

module magia_fixture;

  import magia_tile_pkg::*;
  import magia_pkg::*;
  import magia_tile_tb_pkg::*;
  import magia_tb_pkg::*;
  import magia_noc_pkg::*;

/*******************************************************/
/**        Internal Signal Definitions Beginning      **/
/*******************************************************/

  logic                                                clk;
  logic                                                rst_n;
  logic                                                test_mode;
  logic                                                tile_enable;

  logic                                                scan_cg_en;

  logic[31:0]                                          boot_addr;
  logic[31:0]                                          mtvec_addr;
  logic[31:0]                                          dm_halt_addr;
  logic[31:0]                                          dm_exception_addr;
  logic[ 3:0]                                          mimpid_patch;

  logic[63:0]                                          mcycle[magia_tb_pkg::N_TILES];
  logic[63:0]                                          time_var;

  logic[magia_pkg::N_IRQ-1:0]                          irq[magia_tb_pkg::N_TILES];

  logic                                                debug_req;
  logic                                                debug_havereset[magia_tb_pkg::N_TILES];
  logic                                                debug_running[magia_tb_pkg::N_TILES];
  logic                                                debug_halted[magia_tb_pkg::N_TILES];
  logic                                                debug_pc_valid[magia_tb_pkg::N_TILES];
  logic[31:0]                                          debug_pc[magia_tb_pkg::N_TILES];

  logic                                                fetch_enable;
  logic                                                core_sleep[magia_tb_pkg::N_TILES];

  logic                                                wu_wfe;

  floo_req_t [magia_pkg::N_TILES_Y-1:0]               l2_noc_req_o;
  floo_rsp_t [magia_pkg::N_TILES_Y-1:0]               l2_noc_rsp_i;
  floo_req_t [magia_pkg::N_TILES_Y-1:0]               l2_noc_req_i;
  floo_rsp_t [magia_pkg::N_TILES_Y-1:0]               l2_noc_rsp_o;

/*******************************************************/
/**           Internal Signal Definitions End         **/
/*******************************************************/
/**               DUT (MAGIA) Beginning               **/
/*******************************************************/

  magia #(
    .N_TILES_Y         ( magia_tb_pkg::N_TILES_Y         ),
    .N_TILES_X         ( magia_tb_pkg::N_TILES_X         ),
    .N_TILES           ( magia_tb_pkg::N_TILES           ),
    .N_MEM_BANKS       ( magia_tb_pkg::N_MEM_BANKS       ),
    .N_WORDS_BANK      ( magia_tb_pkg::N_WORDS_BANK      ),
    .TILE_FSYNC_AGGR_W ( magia_tb_pkg::TILE_FSYNC_AGGR_W ),
    .TILE_FSYNC_LVL_W  ( magia_tb_pkg::TILE_FSYNC_LVL_W  ),
    .TILE_FSYNC_ID_W   ( magia_tb_pkg::TILE_FSYNC_ID_W   )
  ) i_magia (
    .clk_i               ( clk               ),
    .rst_ni              ( rst_n             ),
    .test_mode_i         ( test_mode         ),
    .tile_enable_i       ( tile_enable       ),

    .scan_cg_en_i        ( scan_cg_en        ),

    .boot_addr_i         ( boot_addr         ),
    .mtvec_addr_i        ( mtvec_addr        ),
    .dm_halt_addr_i      ( dm_halt_addr      ),
    .dm_exception_addr_i ( dm_exception_addr ),
    .mimpid_patch_i      ( mimpid_patch      ),

    .mcycle_o            ( mcycle            ),
    .time_i              ( time_var          ),

    .irq_i               ( irq               ),

    .debug_req_i         ( debug_req         ),
    .debug_havereset_o   ( debug_havereset   ),
    .debug_running_o     ( debug_running     ),
    .debug_halted_o      ( debug_halted      ),
    .debug_pc_valid_o    ( debug_pc_valid    ),
    .debug_pc_o          ( debug_pc          ),

    .fetch_enable_i      ( fetch_enable      ),
    .core_sleep_o        ( core_sleep        ),

    .wu_wfe_i            ( wu_wfe            ),

    .l2_noc_req_i        ( l2_noc_req_o      ),
    .l2_noc_rsp_o        ( l2_noc_rsp_i      ),
    .l2_noc_req_o        ( l2_noc_req_i      ),
    .l2_noc_rsp_i        ( l2_noc_rsp_o      )
  );

/*******************************************************/
/**                  DUT (MAGIA) End                  **/
/*******************************************************/
/**                   VIP Beginning                   **/
/*******************************************************/

  magia_vip vip (.*);

/*******************************************************/
/**                      VIP End                      **/
/*******************************************************/

endmodule: magia_fixture
