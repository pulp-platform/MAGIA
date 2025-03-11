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

/*******************************************************/
/**        Internal Signal Definitions Beginning      **/
/*******************************************************/

  logic                                                                                    clk;
  logic                                                                                    rst_n;
  logic                                                                                    test_mode;
  logic                                                                                    tile_enable;

  magia_pkg::axi_default_req_t[magia_tb_pkg::N_TILES_X-1:0][magia_tb_pkg::N_TILES_Y-1:0]   data_out_req;
  magia_pkg::axi_default_rsp_t[magia_tb_pkg::N_TILES_X-1:0][magia_tb_pkg::N_TILES_Y-1:0]   data_out_rsp;

  magia_tb_pkg::axi_l2_vip_req_t[magia_tb_pkg::N_TILES_X-1:0][magia_tb_pkg::N_TILES_Y-1:0] data_in_req;
  magia_tb_pkg::axi_l2_vip_rsp_t[magia_tb_pkg::N_TILES_X-1:0][magia_tb_pkg::N_TILES_Y-1:0] data_in_rsp;

  fractal_if #(.LVL_WIDTH(magia_tb_pkg::TILE_FSYNC_W))                                     sync_if[magia_tb_pkg::N_TILES]();
  
  logic                                                                                    scan_cg_en;

  logic[31:0]                                                                              boot_addr;
  logic[31:0]                                                                              mtvec_addr;
  logic[31:0]                                                                              dm_halt_addr;
  logic[31:0]                                                                              dm_exception_addr;
  logic[31:0]                                                                              mhartid[magia_tb_pkg::N_TILES];
  logic[ 3:0]                                                                              mimpid_patch;

  logic[63:0]                                                                              mcycle[magia_tb_pkg::N_TILES];
  logic[63:0]                                                                              time_var;

  logic[magia_pkg::N_IRQ-1:0]                                                              irq;

  logic                                                                                    fencei_flush_req[magia_tb_pkg::N_TILES];
  logic                                                                                    fencei_flush_ack;

  logic                                                                                    debug_req;
  logic                                                                                    debug_havereset[magia_tb_pkg::N_TILES];
  logic                                                                                    debug_running[magia_tb_pkg::N_TILES];
  logic                                                                                    debug_halted[magia_tb_pkg::N_TILES];
  logic                                                                                    debug_pc_valid[magia_tb_pkg::N_TILES];
  logic[31:0]                                                                              debug_pc[magia_tb_pkg::N_TILES];

  logic                                                                                    fetch_enable;
  logic                                                                                    core_sleep[magia_tb_pkg::N_TILES];
  logic                                                                                    wu_wfe;

/*******************************************************/
/**           Internal Signal Definitions End         **/
/*******************************************************/
/**                   DUT Beginning                   **/
/*******************************************************/

  for (genvar i = 0; i < magia_tb_pkg::N_TILES_X; i++) begin: gen_x_tile
    for (genvar j = 0; j < magia_tb_pkg::N_TILES_Y; j++) begin: gen_y_tile
      magia_tile #(
        .TILE_ID      ( i*magia_tb_pkg::N_TILES_Y+j     ),
        .N_MEM_BANKS  ( magia_tile_tb_pkg::N_MEM_BANKS  ),
        .N_WORDS_BANK ( magia_tile_tb_pkg::N_WORDS_BANK ),
  
        .CORE_ISA     (                                 ),
        .CORE_A       (                                 ),
        .CORE_B       (                                 ),
        .CORE_M       (                                 )
      ) dut (
        .clk_i               ( clk                                           ),
        .rst_ni              ( rst_n                                         ),
        .test_mode_i         ( test_mode                                     ),
        .tile_enable_i       ( tile_enable                                   ),
  
        .data_out_req_o      ( data_out_req[i][j]                            ),
        .data_out_rsp_i      ( data_out_rsp[i][j]                            ),
  
        .data_in_req_i       ( data_in_req[i][j]                             ),
        .data_in_rsp_o       ( data_in_rsp[i][j]                             ),
  
        .sync_if_o           ( sync_if[i*magia_tb_pkg::N_TILES_Y+j]          ),
        
        .scan_cg_en_i        ( scan_cg_en                                    ),
  
        .boot_addr_i         ( boot_addr                                     ),
        .mtvec_addr_i        ( mtvec_addr                                    ),
        .dm_halt_addr_i      ( dm_halt_addr                                  ),
        .dm_exception_addr_i ( dm_exception_addr                             ),
        .mhartid_i           ( mhartid[i*magia_tb_pkg::N_TILES_Y+j]          ),
        .mimpid_patch_i      ( mimpid_patch                                  ),
  
        .mcycle_o            ( mcycle[i*magia_tb_pkg::N_TILES_Y+j]           ),
        .time_i              ( time_var                                      ),
  
        .irq_i               ( irq                                           ),
  
        .fencei_flush_req_o  ( fencei_flush_req[i*magia_tb_pkg::N_TILES_Y+j] ),
        .fencei_flush_ack_i  ( fencei_flush_ack                              ),
  
        .debug_req_i         ( debug_req                                     ),
        .debug_havereset_o   ( debug_havereset[i*magia_tb_pkg::N_TILES_Y+j]  ),
        .debug_running_o     ( debug_running[i*magia_tb_pkg::N_TILES_Y+j]    ),
        .debug_halted_o      ( debug_halted[i*magia_tb_pkg::N_TILES_Y+j]     ),
        .debug_pc_valid_o    ( debug_pc_valid[i*magia_tb_pkg::N_TILES_Y+j]   ),
        .debug_pc_o          ( debug_pc[i*magia_tb_pkg::N_TILES_Y+j]         ),
  
        .fetch_enable_i      ( fetch_enable                                  ),
        .core_sleep_o        ( core_sleep[i*magia_tb_pkg::N_TILES_Y+j]       ),
        .wu_wfe_i            ( wu_wfe                                        )
      );
  `ifdef CORE_TRACES
      localparam string core_trace_file_name = $sformatf("%s%0d", "log_file_", i*magia_tb_pkg::N_TILES_Y+j);
      defparam dut.i_cv32e40x_core.rvfi_i.tracer_i.LOGFILE_PATH_PLUSARG = core_trace_file_name;
  `endif
    end
  end

/*******************************************************/
/**                      DUT End                      **/
/*******************************************************/
/**                   VIP Beginning                   **/
/*******************************************************/

  magia_vip vip (.*);

/*******************************************************/
/**                      VIP End                      **/
/*******************************************************/

endmodule: magia_fixture
