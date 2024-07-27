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
 * RedMulE Mesh Verification IP
 */

module redmule_mesh_vip
  import redmule_tile_pkg::*;
  import redmule_mesh_pkg::*;
  import redmule_tile_tb_pkg::*;
  import redmule_mesh_tb_pkg::*;
#(
  // Timing
  parameter time         CLK_PERIOD = 5ns,
  parameter int unsigned RST_CYCLES = 5,
  parameter real         T_APPL     = 0.1,
  parameter real         T_TEST     = 0.9
)(
  output logic                                                                 clk,
  output logic                                                                 rst_n,
  output logic                                                                 test_mode,
  output logic                                                                 tile_enable,

  input  redmule_mesh_pkg::axi_default_req_t[redmule_mesh_tb_pkg::N_TILES-1:0] data_out_req,
  output redmule_mesh_pkg::axi_default_rsp_t[redmule_mesh_tb_pkg::N_TILES-1:0] data_out_rsp,

  output logic                                                                 scan_cg_en,

  output logic[31:0]                                                           boot_addr, //TODO: manage signal
  output logic[31:0]                                                           mtvec_addr,
  output logic[31:0]                                                           dm_halt_addr,
  output logic[31:0]                                                           dm_exception_addr,
  output logic[31:0][redmule_mesh_tb_pkg::N_TILES-1:0]                         mhartid,
  output logic[ 3:0]                                                           mimpid_patch,

  input  logic[63:0]                                                           mcycle,
  output logic[63:0]                                                           time_var,

  output logic[redmule_tile_pkg::N_IRQ-1:0]                                    irq, //TODO: manage signal

  input  logic                                                                 fencei_flush_req,
  output logic                                                                 fencei_flush_ack,

  output logic                                                                 debug_req,
  input  logic                                                                 debug_havereset,
  input  logic                                                                 debug_running,
  input  logic                                                                 debug_halted,
  input  logic                                                                 debug_pc_valid,
  input  logic[31:0]                                                           debug_pc,

  output logic                                                                 fetch_enable,  //TODO: manage signal
  input  logic                                                                 core_sleep,
  output logic                                                                 wu_wfe
);

/*******************************************************/
/**                   DPI Beginning                   **/
/*******************************************************/

//TODO

/*******************************************************/
/**                      DPI End                      **/
/*******************************************************/
/**       Internal Signal Definitions Beginning       **/
/*******************************************************/

  redmule_mesh_pkg::axi_default_req_t data_mst_req;
  redmule_mesh_pkg::axi_default_rsp_t data_mst_rsp;

/*******************************************************/
/**          Internal Signal Definitions End          **/
/*******************************************************/
/**            Hardwired Signals Beginning            **/
/*******************************************************/

  assign test_mode         = 1'b0;
  assign tile_enable       = 1'b1;
  assign scan_cg_en        = 1'b0;
  assign mtvec_addr        = '0;
  assign dm_halt_addr      = '0;
  assign dm_exception_addr = '0;
  for (genvar i = 0; i < redmule_mesh_tb_pkg::N_TILES; i++) begin: gen_mhartid
    assign mhartid           = i;
  end
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
    $readmemh(image, i_l2_mem.mem);
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
/**                  L2 MEM Beginning                 **/
/*******************************************************/

  axi_sim_mem #(
    .AddrWidth          ( redmule_tile_pkg::ADDR_W            ),
    .DataWidth          ( redmule_tile_pkg::DATA_W            ),
    .IdWidth            ( redmule_mesh_pkg::AXI_NOC_ID_W      ),
    .UserWidth          ( redmule_mesh_pkg::AXI_NOC_U_W       ),
    .axi_req_t          ( redmule_mesh_pkg::axi_default_req_t ),
    .axi_rsp_t          ( redmule_mesh_pkg::axi_default_rsp_t ),
    .WarnUninitialized  ( 1                                   ),
    .ClearErrOnAccess   ( 1                                   ),
    .ApplDelay          ( CLK_PERIOD * T_APPL                 ),
    .AcqDelay           ( CLK_PERIOD * T_TEST                 )
  ) i_l2_mem (
    .clk_i              ( clk          ),
    .rst_ni             ( rst_n        ),
    .axi_req_i          ( data_mst_req ),
    .axi_rsp_o          ( data_mst_rsp ),
    .mon_w_valid_o      (              ),
    .mon_w_addr_o       (              ),
    .mon_w_data_o       (              ),
    .mon_w_id_o         (              ),
    .mon_w_user_o       (              ),
    .mon_w_beat_count_o (              ),
    .mon_w_last_o       (              ),
    .mon_r_valid_o      (              ),
    .mon_r_addr_o       (              ),
    .mon_r_data_o       (              ),
    .mon_r_id_o         (              ),
    .mon_r_user_o       (              ),
    .mon_r_beat_count_o (              ),
    .mon_r_last_o       (              )
  );

/*******************************************************/
/**                     L2 MEM End                    **/
/*******************************************************/
/**          Tiles - L2 (AXI XBAR) Beginning          **/
/*******************************************************/

  axi_mux #(
    .SlvAxiIDWidth ( redmule_tile_pkg::AxiXbarSlvAxiIDWidth   ),
    .slv_aw_chan_t ( redmule_tile_pkg::axi_xbar_slv_aw_chan_t ),
    .mst_aw_chan_t ( redmule_mesh_pkg::axi_xbar_mst_aw_chan_t ),
    .w_chan_t      ( redmule_mesh_pkg::axi_xbar_mst_w_chan_t  ),
    .slv_b_chan_t  ( redmule_tile_pkg::axi_xbar_slv_b_chan_t  ),
    .mst_b_chan_t  ( redmule_mesh_pkg::axi_xbar_mst_b_chan_t  ),
    .slv_ar_chan_t ( redmule_tile_pkg::axi_xbar_slv_ar_chan_t ),
    .mst_ar_chan_t ( redmule_mesh_pkg::axi_xbar_mst_ar_chan_t ),
    .slv_r_chan_t  ( redmule_tile_pkg::axi_xbar_slv_r_chan_t  ),
    .mst_r_chan_t  ( redmule_mesh_pkg::axi_xbar_mst_r_chan_t  ),
    .slv_req_t     ( redmule_tile_pkg::axi_xbar_slv_req_t     ),
    .slv_resp_t    ( redmule_tile_pkg::axi_xbar_slv_rsp_t     ),
    .mst_req_t     ( redmule_mesh_pkg::axi_xbar_mst_req_t     ),
    .mst_resp_t    ( redmule_mesh_pkg::axi_xbar_mst_rsp_t     ),
    .NoSlvPorts    ( redmule_mesh_tb_pkg::N_TILES             ),
    .MaxWTrans     ( redmule_tile_pkg::AxiXbarMaxWTrans       ),
    .FallThrough   ( redmule_tile_pkg::AxiXbarFallThrough     ),
    .SpillAw       ( redmule_tile_pkg::AxiXbarSpillAw         ),
    .SpillW        ( redmule_tile_pkg::AxiXbarSpillW          ),
    .SpillB        ( redmule_tile_pkg::AxiXbarSpillB          ),
    .SpillAr       ( redmule_tile_pkg::AxiXbarSpillAr         ),
    .SpillR        ( redmule_tile_pkg::AxiXbarSpillR          )
  ) i_axi_xbar (
    .clk_i       ( clk                   ),
    .rst_ni      ( rst_n                 ),
    .test_i      ( 1'b0                  ),
    .slv_reqs_i  ( data_out_req          ),
    .slv_resps_o ( data_out_rsp          ),
    .mst_req_o   ( data_mst_req          ),
    .mst_resp_i  ( data_mst_rsp          )   
  );

/*******************************************************/
/**             Tiles - L2 (AXI XBAR) End             **/
/*******************************************************/
/**                 Printing Beginning                **/
/*******************************************************/

int errors = -1;
bit stdio_ready  = 0;
bit stderr_ready = 0;
always @(posedge clk) begin: print_monitor
  if ((data_mst_req.aw.addr == 32'h2FFF0000) && (data_mst_req.aw_valid)) stderr_ready = 1'b1;
  if ((data_mst_req.aw.addr == 32'h2FFF0004) && (data_mst_req.aw_valid)) stdio_ready  = 1'b1;
  if ((data_mst_req.w_valid) && stderr_ready) begin
    // NOTE: This is stupid! But unless we keep track of the outstanding AXI writes (which would require some logic) this should work,
    //       unless other modules (not related to the print function) transfer bytes (instead of words) to the L2
    if (data_mst_req.w.data < 256 && data_mst_req.w.data > 0) begin
      errors       = data_mst_req.w.data;
      stderr_ready = 1'b0;
    end
  end
  if ((data_mst_req.w_valid) && stdio_ready) begin
    // NOTE: This is stupid! But unless we keep track of the outstanding AXI writes (which would require some logic) this should work,
    //       unless other modules (not related to the print function) transfer bytes (instead of words) to the L2
    if (data_mst_req.w.data < 256 && data_mst_req.w.data > 0) begin
      $write("%c", data_mst_req.w.data);
      stdio_ready = 1'b0;
    end
  end
end

/*******************************************************/
/**                    Printing End                   **/
/*******************************************************/

endmodule: redmule_mesh_vip
