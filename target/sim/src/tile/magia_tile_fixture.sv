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
 * MAGIA Tile Fixture
 */

module magia_tile_fixture;

  import magia_tile_pkg::*;
  import magia_pkg::*;
  import magia_tile_tb_pkg::*;
  import floo_axi_mesh_1x2_noc_pkg::*;

/*******************************************************/
/**        Internal Signal Definitions Beginning      **/
/*******************************************************/

  logic                              clk;
  logic                              rst_n;
  logic                              test_mode;
  logic                              tile_enable;

  floo_req_t                         noc_south_req_i;
  floo_rsp_t                         noc_south_rsp_o;
  floo_req_t                         noc_south_req_o;
  floo_rsp_t                         noc_south_rsp_i;

  floo_req_t                         noc_east_req_i;
  floo_rsp_t                         noc_east_rsp_o;
  floo_req_t                         noc_east_req_o;
  floo_rsp_t                         noc_east_rsp_i;

  floo_req_t                         noc_north_req_i;
  floo_rsp_t                         noc_north_rsp_o;
  floo_req_t                         noc_north_req_o;
  floo_rsp_t                         noc_north_rsp_i;

  floo_req_t                         noc_west_req_i;
  floo_rsp_t                         noc_west_rsp_o;
  floo_req_t                         noc_west_req_o;
  floo_rsp_t                         noc_west_rsp_i;

  fractal_sync_if                    ht_fsync_if_o[1]();
  fractal_sync_if                    hn_fsync_if_o[1]();
  fractal_sync_if                    vt_fsync_if_o[1]();
  fractal_sync_if                    vn_fsync_if_o[1]();
  
  logic                              scan_cg_en;

  logic[31:0]                        boot_addr;
  logic[31:0]                        mtvec_addr;
  logic[31:0]                        dm_halt_addr;
  logic[31:0]                        dm_exception_addr;
  logic[31:0]                        mhartid;
  logic[ 3:0]                        mimpid_patch;

  logic[63:0]                        mcycle;
  logic[63:0]                        time_var;

  logic[magia_pkg::N_IRQ-1:0]        irq;

  logic                              debug_req;
  logic                              debug_havereset;
  logic                              debug_running;
  logic                              debug_halted;
  logic                              debug_pc_valid;
  logic[31:0]                        debug_pc;

  logic                              fetch_enable;
  logic                              core_sleep;
  logic                              wu_wfe;

/*******************************************************/
/**           Internal Signal Definitions End         **/
/*******************************************************/
/**                   DUT Beginning                   **/
/*******************************************************/

  magia_tile #(
    .N_MEM_BANKS  ( magia_tile_tb_pkg::N_MEM_BANKS  ),
    .N_WORDS_BANK ( magia_tile_tb_pkg::N_WORDS_BANK ),

    .CORE_ISA     (                                 ),
    .CORE_A       (                                 ),
    .CORE_B       (                                 ),
    .CORE_M       (                                 ),
    .ERROR_CAP    (                                 )
  ) i_magia_tile (
    .clk_i               ( clk               ),
    .rst_ni              ( rst_n             ),
    .test_mode_i         ( test_mode         ),
    .tile_enable_i       ( tile_enable       ),

    .noc_south_req_i     ( noc_south_req_i   ),
    .noc_south_rsp_o     ( noc_south_rsp_o   ),
    .noc_south_req_o     ( noc_south_req_o   ),
    .noc_south_rsp_i     ( noc_south_rsp_i   ),

    .noc_east_req_i      ( noc_east_req_i    ),
    .noc_east_rsp_o      ( noc_east_rsp_o    ),
    .noc_east_req_o      ( noc_east_req_o    ),
    .noc_east_rsp_i      ( noc_east_rsp_i    ),

    .noc_north_req_i     ( noc_north_req_i   ),
    .noc_north_rsp_o     ( noc_north_rsp_o   ),
    .noc_north_req_o     ( noc_north_req_o   ),
    .noc_north_rsp_i     ( noc_north_rsp_i   ),

    .noc_west_req_i      ( noc_west_req_i    ),
    .noc_west_rsp_o      ( noc_west_rsp_o    ),
    .noc_west_req_o      ( noc_west_req_o    ),
    .noc_west_rsp_i      ( noc_west_rsp_i    ),

    .x_id_i              ( 0                 ),
    .y_id_i              ( 0                 ),

    .ht_fsync_if_o       ( ht_fsync_if_o[0]  ),
    .hn_fsync_if_o       ( hn_fsync_if_o[0]  ),
    .vt_fsync_if_o       ( vt_fsync_if_o[0]  ),
    .vn_fsync_if_o       ( vn_fsync_if_o[0]  ),
    
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

    .debug_req_i         ( debug_req         ),
    .debug_havereset_o   ( debug_havereset   ),
    .debug_running_o     ( debug_running     ),
    .debug_halted_o      ( debug_halted      ),
    .debug_pc_valid_o    ( debug_pc_valid    ),
    .debug_pc_o          ( debug_pc          ),

    .fetch_enable_i      ( fetch_enable      ),
    .core_sleep_o        ( core_sleep        ),
    .wu_wfe_i            ( wu_wfe            )
  );
  `ifdef CORE_TRACES
    localparam string core_trace_file_name = "log_file_0";
    defparam i_magia_tile.i_cv32e40x_core.rvfi_i.tracer_i.LOGFILE_PATH_PLUSARG = core_trace_file_name;
  `endif

/*******************************************************/
/**                      DUT End                      **/
/*******************************************************/
/**                   VIP Beginning                   **/
/*******************************************************/

  magia_tile_vip vip (.*);

/*******************************************************/
/**                      VIP End                      **/
/*******************************************************/

endmodule: magia_tile_fixture
