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
 * MAGIA Tile Verification IP
 */

module magia_tile_vip
  import magia_tile_pkg::*;
  import magia_pkg::*;
  import magia_tile_tb_pkg::*;
#(
  // Timing
  parameter time         CLK_PERIOD = 5ns,
  parameter int unsigned RST_CYCLES = 5,
  parameter real         T_APPL     = 0.1,
  parameter real         T_TEST     = 0.9
)(
  output logic                              clk,
  output logic                              rst_n,
  output logic                              test_mode,
  output logic                              tile_enable,

  input  magia_pkg::axi_default_req_t       data_out_req,
  output magia_pkg::axi_default_rsp_t       data_out_rsp,

  output magia_tile_pkg::axi_xbar_slv_req_t data_in_req,
  input  magia_tile_pkg::axi_xbar_slv_rsp_t data_in_rsp,

  fractal_sync_if.slv_port                  ht_fsync_if_o[1],
  fractal_sync_if.slv_port                  hn_fsync_if_o[1],
  fractal_sync_if.slv_port                  vt_fsync_if_o[1],
  fractal_sync_if.slv_port                  vn_fsync_if_o[1],
  
  output logic                              scan_cg_en,

  output logic[31:0]                        boot_addr,
  output logic[31:0]                        mtvec_addr,
  output logic[31:0]                        dm_halt_addr,
  output logic[31:0]                        dm_exception_addr,
  output logic[31:0]                        mhartid,
  output logic[ 3:0]                        mimpid_patch,

  input  logic[63:0]                        mcycle,
  output logic[63:0]                        time_var,

  output logic[magia_pkg::N_IRQ-1:0]        irq,

  output logic                              debug_req,
  input  logic                              debug_havereset,
  input  logic                              debug_running,
  input  logic                              debug_halted,
  input  logic                              debug_pc_valid,
  input  logic[31:0]                        debug_pc,

  output logic                              fetch_enable,
  input  logic                              core_sleep,
  output logic                              wu_wfe
);

/*******************************************************/
/**            Hardwired Signals Beginning            **/
/*******************************************************/

  assign test_mode               = 1'b0;
  assign tile_enable             = 1'b1;
  assign data_in_req             = '0;
  assign scan_cg_en              = 1'b0;
  assign mtvec_addr              = '0;
  assign dm_halt_addr            = '0;
  assign dm_exception_addr       = '0;
  assign mhartid                 = '0;
  assign mimpid_patch            = '0;
  assign debug_req               = 1'b0;
  assign wu_wfe                  = 1'b0;
  assign ht_fsync_if_o[0].wake   = 1'b0;
  assign ht_fsync_if_o[0].lvl    = '0;
  assign ht_fsync_if_o[0].id_rsp = '0;
  assign ht_fsync_if_o[0].error  = 1'b0;
  assign hn_fsync_if_o[0].wake   = 1'b0;
  assign hn_fsync_if_o[0].lvl    = '0;
  assign hn_fsync_if_o[0].id_rsp = '0;
  assign hn_fsync_if_o[0].error  = 1'b0;
  assign vt_fsync_if_o[0].wake   = 1'b0;
  assign vt_fsync_if_o[0].lvl    = '0;
  assign vt_fsync_if_o[0].id_rsp = '0;
  assign vt_fsync_if_o[0].error  = 1'b0;
  assign vn_fsync_if_o[0].wake   = 1'b0;
  assign vn_fsync_if_o[0].lvl    = '0;
  assign vn_fsync_if_o[0].id_rsp = '0;
  assign vn_fsync_if_o[0].error  = 1'b0;

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
    while ({i_l2_mem.mem[32'hCC03_0001], i_l2_mem.mem[32'hCC03_0000]} == 0)
      #10000;
    exit_code = {i_l2_mem.mem[32'hCC03_0001], i_l2_mem.mem[32'hCC03_0000]};
  endtask: wait_for_eoc

/*******************************************************/
/**                 TB Subroutines End                **/
/*******************************************************/
/**                  L2 MEM Beginning                 **/
/*******************************************************/

  axi_sim_mem #(
    .AddrWidth          ( magia_pkg::ADDR_W            ),
    .DataWidth          ( magia_pkg::DATA_W            ),
    .IdWidth            ( magia_pkg::AXI_NOC_ID_W      ),
    .UserWidth          ( magia_pkg::AXI_NOC_U_W       ),
    .axi_req_t          ( magia_pkg::axi_default_req_t ),
    .axi_rsp_t          ( magia_pkg::axi_default_rsp_t ),
    .WarnUninitialized  ( 1                            ),
    .ClearErrOnAccess   ( 1                            ),
    .ApplDelay          ( CLK_PERIOD * T_APPL          ),
    .AcqDelay           ( CLK_PERIOD * T_TEST          )
  ) i_l2_mem (
    .clk_i              ( clk          ),
    .rst_ni             ( rst_n        ),
    .axi_req_i          ( data_out_req ),
    .axi_rsp_o          ( data_out_rsp ),
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
/**                 Printing Beginning                **/
/*******************************************************/

int errors = -1;
bit stdio_ready  = 0;
bit stderr_ready = 0;
always @(posedge clk) begin: print_monitor
  if ((data_out_req.aw.addr == 32'hFFFF0000) && (data_out_req.aw_valid)) stderr_ready = 1'b1;
  if ((data_out_req.aw.addr == 32'hFFFF0004) && (data_out_req.aw_valid)) stdio_ready  = 1'b1;
  if ((data_out_req.w_valid) && stderr_ready) begin
    // NOTE: This is stupid! But unless we keep track of the outstanding AXI writes (which would require some logic) this should work,
    //       unless other modules (not related to the print function) transfer bytes (instead of words) to the L2
    if (data_out_req.w.data < 256 && data_out_req.w.data > 0) begin
      errors       = data_out_req.w.data;
      stderr_ready = 1'b0;
    end
  end
  if ((data_out_req.w_valid) && stdio_ready) begin
    // NOTE: This is stupid! But unless we keep track of the outstanding AXI writes (which would require some logic) this should work,
    //       unless other modules (not related to the print function) transfer bytes (instead of words) to the L2
    if (data_out_req.w.data < 256 && data_out_req.w.data > 0) begin
      $write("%c", data_out_req.w.data);
      stdio_ready = 1'b0;
    end
  end
end

/*******************************************************/
/**                    Printing End                   **/
/*******************************************************/
/**                  Timer Beginning                  **/
/*******************************************************/

initial time_var = 0;

always @(negedge clk) begin: timer
  time_var = time_var + CLK_PERIOD;
end

/*******************************************************/
/**                     Timer End                     **/
/*******************************************************/
/**           Instruction Monitor Beginning           **/
/*******************************************************/

  bit[31:0] curr_instr; 
  assign curr_instr = i_magia_tile.i_cv32e40x_core.core_i.if_stage_i.if_id_pipe_o.instr.bus_resp.rdata;
  always @(curr_instr) begin: instr_reporter
    if (curr_instr == 32'h50500013) $display("[TB] detected sentinel instruction at time %0dns", time_var);
  end

/*******************************************************/
/**              Instruction Monitor End              **/
/*******************************************************/

endmodule: magia_tile_vip
