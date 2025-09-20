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
 * MAGIA Verification IP
 */

 `include "axi/assign.svh"

module magia_vip
  import magia_tile_pkg::*;
  import magia_pkg::*;
  import magia_tile_tb_pkg::*;
  import magia_tb_pkg::*;
  import magia_noc_pkg::*;
#(
  // Timing
  parameter time         CLK_PERIOD = 5ns,
  parameter int unsigned RST_CYCLES = 5,
  parameter real         T_APPL     = 0.1,
  parameter real         T_TEST     = 0.9
)(
  output logic                                                clk,
  output logic                                                rst_n,
  output logic                                                test_mode,
  output logic                                                tile_enable,

  output logic                                                scan_cg_en,

  output logic[31:0]                                          boot_addr,
  output logic[31:0]                                          mtvec_addr,
  output logic[31:0]                                          dm_halt_addr,
  output logic[31:0]                                          dm_exception_addr,
  output logic[ 3:0]                                          mimpid_patch,

  input  logic[63:0]                                          mcycle[magia_tb_pkg::N_TILES],
  output logic[63:0]                                          time_var,

  output logic[magia_pkg::N_IRQ-1:0]                          irq[magia_tb_pkg::N_TILES],

  output logic                                                debug_req,
  input  logic                                                debug_havereset[magia_tb_pkg::N_TILES],
  input  logic                                                debug_running[magia_tb_pkg::N_TILES],
  input  logic                                                debug_halted[magia_tb_pkg::N_TILES],
  input  logic                                                debug_pc_valid[magia_tb_pkg::N_TILES],
  input  logic[31:0]                                          debug_pc[magia_tb_pkg::N_TILES],

  output logic                                                fetch_enable,
  input  logic                                                core_sleep[magia_tb_pkg::N_TILES],

  output logic                                                wu_wfe,

  input  floo_req_t [magia_pkg::N_TILES_Y-1:0]                l2_noc_req_i,
  output floo_rsp_t [magia_pkg::N_TILES_Y-1:0]                l2_noc_rsp_o,
  output floo_req_t [magia_pkg::N_TILES_Y-1:0]                l2_noc_req_o,
  input  floo_rsp_t [magia_pkg::N_TILES_Y-1:0]                l2_noc_rsp_i
);

/*******************************************************/
/**            Hardwired Signals Beginning            **/
/*******************************************************/

  assign test_mode         = 1'b0;
  assign tile_enable       = 1'b1;
  assign scan_cg_en        = 1'b0;
  assign mtvec_addr        = '0;
  assign dm_halt_addr      = '0;
  assign dm_exception_addr = '0;
  assign mimpid_patch      = '0;
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
    $readmemh(image, i_l2_mem.i_l2_mem.mem);
  endtask: inst_preload

  // Preload data subroutine
  task automatic data_preload(input string image);
    $readmemh(image, i_l2_mem.i_l2_mem.mem);
  endtask: data_preload

  task wait_for_reset;
    @(posedge rst_n);
    @(posedge clk);
  endtask: wait_for_reset

  task automatic init(input bit[31:0] entry_addr);
    for (int unsigned i = 0; i < magia_tb_pkg::N_TILES; i++)
      irq[i]     = '0;
    fetch_enable = 1'b0;
    boot_addr    = entry_addr;
    #1000;
  endtask: init

  task automatic elf_run;
    fetch_enable = 1'b1;
    #1000;
  endtask: elf_run

  task automatic wait_for_eoc(output bit[magia_tb_pkg::N_TILES*16-1:0] exit_code);
    bit eoc = 1'b0;
    while (!eoc) begin
      eoc = 1'b1;
      for (int i = 0; i < magia_tb_pkg::N_TILES; i++)
        if ({i_l2_mem.i_l2_mem.mem[32'hCC03_0000 + (2*i + 1)], i_l2_mem.i_l2_mem.mem[32'hCC03_0000 + 2*i]} == 0)
          eoc = 1'b0;
      #10000;
    end
    
    for (int i = 0; i < magia_tb_pkg::N_TILES; i++)
      exit_code |= {i_l2_mem.i_l2_mem.mem[32'hCC03_0000 + (2*i + 1)], i_l2_mem.i_l2_mem.mem[32'hCC03_0000 + 2*i]} << i*16;
  endtask: wait_for_eoc

/*******************************************************/
/**                 TB Subroutines End                **/
/*******************************************************/
/**                  L2 MEM Beginning                 **/
/*******************************************************/
  magia_l2_mem_wrapper #(
    .NumPorts   ( magia_tb_pkg::N_TILES_Y ),
    .ApplDelay  ( CLK_PERIOD * T_APPL     ),
    .AcqDelay   ( CLK_PERIOD * T_TEST     )
  ) i_l2_mem  (
    .clk_i      ( clk           ),
    .rst_ni     ( rst_n         ),
    .noc_req_i  ( l2_noc_req_i  ),
    .noc_rsp_o  ( l2_noc_rsp_o  ),
    .noc_req_o  ( l2_noc_req_o  ),
    .noc_rsp_i  ( l2_noc_rsp_i  )
  );

/*******************************************************/
/**                     L2 MEM End                    **/
/*******************************************************/
/**                 Printing Beginning                **/
/*******************************************************/

  for (genvar i = 0; i < magia_tb_pkg::N_TILES_Y; i++) begin: gen_tile_print_y
    for (genvar j = 0; j < magia_tb_pkg::N_TILES_X; j++) begin: gen_tile_print_x
      int errors = -1;
      bit stdio_ready  = 0;
      bit stderr_ready = 0;
      typedef struct packed {
        bit[31:0] data;
        bit[31:0] id;
      } string_char_t;
      bit print_line[2**magia_tb_pkg::L2_ID_W];
      string_char_t chars[$];
      bit[magia_tb_pkg::L2_ID_W-1:0] write_id;
      always @(posedge clk) begin: print_monitor
        if ((i_magia.gen_y_tile[i].gen_x_tile[j].i_magia_tile.i_axi_xbar.mst_ports_req_o[0].aw.addr == 32'hFFFF0000) && (i_magia.gen_y_tile[i].gen_x_tile[j].i_magia_tile.i_axi_xbar.mst_ports_req_o[0].aw_valid))
          stderr_ready = 1'b1;
        // NOTE: all print peripherals are assumed to be aliased
        if ((i_magia.gen_y_tile[i].gen_x_tile[j].i_magia_tile.i_axi_xbar.mst_ports_req_o[0].aw.addr == 32'hFFFF0004/*+((i*magia_tb_pkg::N_TILES_X+j)*4)*/) && (i_magia.gen_y_tile[i].gen_x_tile[j].i_magia_tile.i_axi_xbar.mst_ports_req_o[0].aw_valid)) begin
          stdio_ready  = 1'b1;
          write_id = i_magia.gen_y_tile[i].gen_x_tile[j].i_magia_tile.i_axi_xbar.mst_ports_req_o[0].aw.id;
        end
        if ((i_magia.gen_y_tile[i].gen_x_tile[j].i_magia_tile.i_axi_xbar.mst_ports_req_o[0].w_valid) && stderr_ready) begin
          errors       = i_magia.gen_y_tile[i].gen_x_tile[j].i_magia_tile.i_axi_xbar.mst_ports_req_o[0].w.data[7:0];
          stderr_ready = 1'b0;
        end
        if ((i_magia.gen_y_tile[i].gen_x_tile[j].i_magia_tile.i_axi_xbar.mst_ports_req_o[0].w_valid) && stdio_ready) begin
          if (i_magia.gen_y_tile[i].gen_x_tile[j].i_magia_tile.i_axi_xbar.mst_ports_req_o[0].w.data[7:0] == 10)  // ASCII code for new line (\n) is 10
            print_line[write_id] = 1'b1;
          chars.push_back('{i_magia.gen_y_tile[i].gen_x_tile[j].i_magia_tile.i_axi_xbar.mst_ports_req_o[0].w.data[7:0], write_id});
          stdio_ready = 1'b0;
        end
        for (int k = 0; k < 2**magia_tb_pkg::L2_ID_W; k++) begin
          if (print_line[k] == 1'b1) begin
            $write("[mhartid %0d] ", i*magia_tb_pkg::N_TILES_X+j);
            for (int j = 0; j < chars.size(); j++) begin
              if (chars[j].id == k) begin
                $write("%c", chars[j].data);
                chars.delete(j--);
              end
            end
            print_line[k] = 1'b0;
          end
        end
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

`ifdef PROFILE_DETAILED
  bit[31:0] curr_instr_ex[magia_tb_pkg::N_TILES];
  bit[31:0] curr_instr_id[magia_tb_pkg::N_TILES];
  time start_sync_ex[magia_tb_pkg::N_TILES];
  time end_sync_ex[magia_tb_pkg::N_TILES];
  time last_start_ex = 0, last_end_ex = 0, sync_time_ex;
  int unsigned completed_syncs_ex = 0;
  time start_sync_id[magia_tb_pkg::N_TILES];
  time end_sync_id[magia_tb_pkg::N_TILES];
  time last_start_id = 0, last_end_id = 0, sync_time_id;
  int unsigned completed_syncs_id = 0;
  for (genvar i = 0; i < magia_tb_pkg::N_TILES_Y; i++) begin: gen_tile_instr_monitor_y
    for (genvar j = 0; j < magia_tb_pkg::N_TILES_X; j++) begin: gen_tile_instr_monitor_x 
      assign curr_instr_ex[i*magia_tb_pkg::N_TILES_X+j] = i_magia.gen_y_tile[i].gen_x_tile[j].i_magia_tile.i_cv32e40x_core.core_i.id_stage_i.id_ex_pipe_o.instr.bus_resp.rdata;
      always @(curr_instr_ex[i*magia_tb_pkg::N_TILES_X+j]) begin: instr_ex_reporter
        if (curr_instr_ex[i*magia_tb_pkg::N_TILES_X+j] == 32'h50500013) 
          $display("[TB][mhartid %0d - Tile (%0d, %0d)] detected sentinel instruction in EX stage at time %0dns", i*magia_tb_pkg::N_TILES_X+j, i, j, time_var);
        if (curr_instr_ex[i*magia_tb_pkg::N_TILES_X+j] == 32'h0062A3AF) 
          $display("[TB][mhartid %0d - Tile (%0d, %0d)] detected AMO (sync) instruction at time %0dns", i*magia_tb_pkg::N_TILES_X+j, i, j, time_var);
        if (curr_instr_ex[i*magia_tb_pkg::N_TILES_X+j] == 32'h5AA00013) begin
          start_sync_ex[i*magia_tb_pkg::N_TILES_X+j] = $time;
          if (last_start_ex < start_sync_ex[i*magia_tb_pkg::N_TILES_X+j]) last_start_ex = start_sync_ex[i*magia_tb_pkg::N_TILES_X+j];
        end
        if (curr_instr_ex[i*magia_tb_pkg::N_TILES_X+j] == 32'h5FF00013) begin
          end_sync_ex[i*magia_tb_pkg::N_TILES_X+j] = $time;
          if (last_end_ex < end_sync_ex[i*magia_tb_pkg::N_TILES_X+j]) last_end_ex = end_sync_ex[i*magia_tb_pkg::N_TILES_X+j];
          completed_syncs_ex++;
        end
      end
      assign curr_instr_id[i*magia_tb_pkg::N_TILES_X+j] = i_magia.gen_y_tile[i].gen_x_tile[j].i_magia_tile.i_cv32e40x_core.core_i.id_stage_i.if_id_pipe_i.instr.bus_resp.rdata;
      always @(curr_instr_id[i*magia_tb_pkg::N_TILES_X+j]) begin: instr_id_reporter
        if (curr_instr_id[i*magia_tb_pkg::N_TILES_X+j] == 32'h40400013) 
          $display("[TB][mhartid %0d - Tile (%0d, %0d)] detected sentinel instruction in ID stage at time %0dns", i*magia_tb_pkg::N_TILES_X+j, i, j, time_var);
        if (curr_instr_id[i*magia_tb_pkg::N_TILES_X+j] == 32'h0062A05B) 
          $display("[TB][mhartid %0d - Tile (%0d, %0d)] detected fsync instruction at time %0dns", i*magia_tb_pkg::N_TILES_X+j, i, j, time_var);
        if (curr_instr_id[i*magia_tb_pkg::N_TILES_X+j] == 32'h5AA00013) begin
          start_sync_id[i*magia_tb_pkg::N_TILES_X+j] = $time;
          if (last_start_id < start_sync_id[i*magia_tb_pkg::N_TILES_X+j]) last_start_id = start_sync_id[i*magia_tb_pkg::N_TILES_X+j];
        end
        if (curr_instr_id[i*magia_tb_pkg::N_TILES_X+j] == 32'h5FF00013) begin
          end_sync_id[i*magia_tb_pkg::N_TILES_X+j] = $time;
          if (last_end_id < end_sync_id[i*magia_tb_pkg::N_TILES_X+j]) last_end_id = end_sync_id[i*magia_tb_pkg::N_TILES_X+j];
          completed_syncs_id++;
        end
      end
    end
  end
  always @(completed_syncs_ex) begin: ex_sync_time_reporter
    if (completed_syncs_ex == magia_tb_pkg::N_TILES) begin
      sync_time_ex = last_end_ex - last_start_ex;
      $display("[TB][SYNC PERF] detected completed synchronization in EX stage. Synchronization time %0tns (%0d clock cycles)", sync_time_ex, sync_time_ex/CLK_PERIOD);
      completed_syncs_ex = 0;
      last_start_ex = 0;
      last_end_ex = 0;
    end
  end
  always @(completed_syncs_id) begin: id_sync_time_reporter
    if (completed_syncs_id == magia_tb_pkg::N_TILES) begin
      sync_time_id = last_end_id - last_start_id;
      $display("[TB][SYNC PERF] detected completed synchronization in ID stage. Synchronization time %0tns (%0d clock cycles)", sync_time_id, sync_time_id/CLK_PERIOD);
      completed_syncs_id = 0;
      last_start_id = 0;
      last_end_id = 0;
    end
  end
`endif

`ifdef PROFILE_SYNC
  bit[31:0] curr_sync_instr_wb[magia_tb_pkg::N_TILES];
  time start_sync_sentinel[magia_tb_pkg::N_TILES][$];
  time end_sync_sentinel[magia_tb_pkg::N_TILES][$];
  int unsigned completed_sync_sentinels;
  int unsigned sync_iteration = 0;
  time global_sync_acc = 0;
  time row_sync_acc = 0;
  time col_sync_acc = 0;
  time hnbr_sync_acc = 0;
  time vnbr_sync_acc = 0;
  time hring_sync_acc = 0;
  time vring_sync_acc = 0;
  for (genvar i = 0; i < magia_tb_pkg::N_TILES_Y; i++) begin: gen_tile_sync_instr_monitor_y
    for (genvar j = 0; j < magia_tb_pkg::N_TILES_X; j++) begin: gen_tile_sync_instr_monitor_x 
      assign curr_sync_instr_wb[i*magia_tb_pkg::N_TILES_X+j] = i_magia.gen_y_tile[i].gen_x_tile[j].i_magia_tile.i_cv32e40x_core.core_i.wb_stage_i.ex_wb_pipe_i.instr_valid ?
      i_magia.gen_y_tile[i].gen_x_tile[j].i_magia_tile.i_cv32e40x_core.core_i.wb_stage_i.ex_wb_pipe_i.instr.bus_resp.rdata : '0;
      always @(curr_sync_instr_wb[i*magia_tb_pkg::N_TILES_X+j]) begin: sync_instr_wb_reporter
        if (curr_sync_instr_wb[i*magia_tb_pkg::N_TILES_X+j] == 32'h53B00013) begin
          start_sync_sentinel[i*magia_tb_pkg::N_TILES_X+j].push_back($time);
          $display("[TB][mhartid %0d - Tile (%0d, %0d)] detected sync sentinel start instruction in WB stage at time %0dns (%0dns)", 
          i*magia_tb_pkg::N_TILES_X+j, i, j, $time, time_var);
        end
        if (curr_sync_instr_wb[i*magia_tb_pkg::N_TILES_X+j] == 32'h53C00013) begin
          end_sync_sentinel[i*magia_tb_pkg::N_TILES_X+j].push_back($time);
          $display("[TB][mhartid %0d - Tile (%0d, %0d)] detected sync sentinel end instruction in WB stage at time %0dns (%0dns)", 
          i*magia_tb_pkg::N_TILES_X+j, i, j, $time, time_var);
        end
        if (curr_sync_instr_wb[i*magia_tb_pkg::N_TILES_X+j] == 32'h53D00013) begin
          $display("[TB][SYNC PERF][mhartid %0d - Tile (%0d, %0d)] Synchronization pattern sentinel accumulator states after %0d iterations:
          \tGLOBAL: %0tns (%0d clock cycles)
          \tROW:    %0tns (%0d clock cycles)
          \tCOLUMN: %0tns (%0d clock cycles)
          \tHNBR:   %0tns (%0d clock cycles)
          \tVNBR:   %0tns (%0d clock cycles)
          \tHRING:  %0tns (%0d clock cycles)
          \tVRING:  %0tns (%0d clock cycles)", 
          i*magia_tb_pkg::N_TILES_X+j, i, j, sync_iteration, global_sync_acc, global_sync_acc/CLK_PERIOD, row_sync_acc, row_sync_acc/CLK_PERIOD, col_sync_acc, col_sync_acc/CLK_PERIOD,
          hnbr_sync_acc, hnbr_sync_acc/CLK_PERIOD, vnbr_sync_acc, vnbr_sync_acc/CLK_PERIOD, hring_sync_acc, hring_sync_acc/CLK_PERIOD, vring_sync_acc, vring_sync_acc/CLK_PERIOD);
        end
      end
    end
  end
  always_comb begin: count_completed_sync_sentinels
    completed_sync_sentinels = 0;
    for (int unsigned i = 0; i < magia_tb_pkg::N_TILES; i++)
      if (end_sync_sentinel[i].size() > sync_iteration)
        completed_sync_sentinels++;
  end
  always @(completed_sync_sentinels) begin: ex_sync_time_reporter
    if (completed_sync_sentinels == magia_tb_pkg::N_TILES) begin
      localparam time sync_sentinel_overhead = CLK_PERIOD; // Overhead of the sentinel start/end pair
      localparam int unsigned n_pairs = magia_tb_pkg::N_TILES/2;

      automatic time global_last_start = 0;
      automatic time global_last_end = 0;
      automatic time global_sync_time = 0;

      automatic time row_last_start[magia_tb_pkg::N_TILES_Y] = '{default: 0};
      automatic time row_last_end[magia_tb_pkg::N_TILES_Y] = '{default: 0};
      automatic time row_sync_times[magia_tb_pkg::N_TILES_Y] = '{default: 0};
      automatic time row_sync_time = 0;

      automatic time col_last_start[magia_tb_pkg::N_TILES_X] = '{default: 0};
      automatic time col_last_end[magia_tb_pkg::N_TILES_X] = '{default: 0};
      automatic time col_sync_times[magia_tb_pkg::N_TILES_X] = '{default: 0};
      automatic time col_sync_time = 0;

      automatic time hnbr_last_start[n_pairs] = '{default: 0};
      automatic time hnbr_last_end[n_pairs] = '{default: 0};
      automatic time hnbr_sync_times[n_pairs] = '{default: 0};
      automatic time hnbr_sync_time = 0;

      automatic time vnbr_last_start[n_pairs] = '{default: 0};
      automatic time vnbr_last_end[n_pairs] = '{default: 0};
      automatic time vnbr_sync_times[n_pairs] = '{default: 0};
      automatic time vnbr_sync_time = 0;

      automatic time hring_last_start[n_pairs] = '{default: 0};
      automatic time hring_last_end[n_pairs] = '{default: 0};
      automatic time hring_sync_times[n_pairs] = '{default: 0};
      automatic time hring_sync_time = 0;

      automatic time vring_last_start[n_pairs] = '{default: 0};
      automatic time vring_last_end[n_pairs] = '{default: 0};
      automatic time vring_sync_times[n_pairs] = '{default: 0};
      automatic time vring_sync_time = 0;

      for (int unsigned i = 0; i < magia_tb_pkg::N_TILES; i++) begin
        if (global_last_start < start_sync_sentinel[i][sync_iteration]) global_last_start = start_sync_sentinel[i][sync_iteration];
        if (global_last_end < end_sync_sentinel[i][sync_iteration]) global_last_end = end_sync_sentinel[i][sync_iteration];
      end
      global_sync_time = global_last_end - global_last_start - sync_sentinel_overhead;
      global_sync_acc += global_sync_time;
      $display("[TB][SYNC PERF][GLOBAL] detected completed synchronization in EX stage. Synchronization time %0tns (%0d clock cycles)", global_sync_time, global_sync_time/CLK_PERIOD);
      
      for (int unsigned i = 0; i < magia_tb_pkg::N_TILES_Y; i++) begin
        for (int unsigned j = 0; j < magia_tb_pkg::N_TILES_X; j++) begin
          if (row_last_start[i] < start_sync_sentinel[i*magia_tb_pkg::N_TILES_X+j][sync_iteration]) row_last_start[i] = start_sync_sentinel[i*magia_tb_pkg::N_TILES_X+j][sync_iteration];
          if (row_last_end[i] < end_sync_sentinel[i*magia_tb_pkg::N_TILES_X+j][sync_iteration]) row_last_end[i] = end_sync_sentinel[i*magia_tb_pkg::N_TILES_X+j][sync_iteration];
        end
        row_sync_times[i] = row_last_end[i] - row_last_start[i] - sync_sentinel_overhead;
        if (row_sync_time < row_sync_times[i]) row_sync_time = row_sync_times[i];
      end
      row_sync_acc += row_sync_time;
      $display("[TB][SYNC PERF][ROW] detected completed synchronization in EX stage. Synchronization time %0tns (%0d clock cycles)", row_sync_time, row_sync_time/CLK_PERIOD);

      for (int unsigned i = 0; i < magia_tb_pkg::N_TILES_X; i++) begin
        for (int unsigned j = 0; j < magia_tb_pkg::N_TILES_Y; j++) begin
          if (col_last_start[i] < start_sync_sentinel[i+j*magia_tb_pkg::N_TILES_X][sync_iteration]) col_last_start[i] = start_sync_sentinel[i+j*magia_tb_pkg::N_TILES_X][sync_iteration];
          if (col_last_end[i] < end_sync_sentinel[i+j*magia_tb_pkg::N_TILES_X][sync_iteration]) col_last_end[i] = end_sync_sentinel[i+j*magia_tb_pkg::N_TILES_X][sync_iteration];
        end
        col_sync_times[i] = col_last_end[i] - col_last_start[i] - sync_sentinel_overhead;
        if (col_sync_time < col_sync_times[i]) col_sync_time = col_sync_times[i];
      end
      col_sync_acc += col_sync_time;
      $display("[TB][SYNC PERF][COLUMN] detected completed synchronization in EX stage. Synchronization time %0tns (%0d clock cycles)", col_sync_time, col_sync_time/CLK_PERIOD);
      
      for (int unsigned i = 0; i < n_pairs; i++) begin
        automatic int unsigned src_idx = 2*i+1;
        automatic int unsigned dst_idx = 2*i;
        hnbr_last_start[i] = start_sync_sentinel[dst_idx][sync_iteration] > start_sync_sentinel[src_idx][sync_iteration] ? start_sync_sentinel[dst_idx][sync_iteration] : start_sync_sentinel[src_idx][sync_iteration];
        hnbr_last_end[i] = end_sync_sentinel[dst_idx][sync_iteration] > end_sync_sentinel[src_idx][sync_iteration] ? end_sync_sentinel[dst_idx][sync_iteration] : end_sync_sentinel[src_idx][sync_iteration];
        hnbr_sync_times[i] = hnbr_last_end[i] - hnbr_last_start[i] - sync_sentinel_overhead;
        if (hnbr_sync_time < hnbr_sync_times[i]) hnbr_sync_time = hnbr_sync_times[i];
      end
      hnbr_sync_acc += hnbr_sync_time;
      $display("[TB][SYNC PERF][HNBR] detected completed synchronization in EX stage. Synchronization time %0tns (%0d clock cycles)", hnbr_sync_time, hnbr_sync_time/CLK_PERIOD);
      
      for (int unsigned i = 0; i < n_pairs; i++) begin
        automatic int unsigned src_idx = i%magia_tb_pkg::N_TILES_X + 2*(i/magia_tb_pkg::N_TILES_X)*magia_tb_pkg::N_TILES_X + magia_tb_pkg::N_TILES_X;
        automatic int unsigned dst_idx = i%magia_tb_pkg::N_TILES_X + 2*(i/magia_tb_pkg::N_TILES_X)*magia_tb_pkg::N_TILES_X;
        vnbr_last_start[i] = start_sync_sentinel[dst_idx][sync_iteration] > start_sync_sentinel[src_idx][sync_iteration] ? start_sync_sentinel[dst_idx][sync_iteration] : start_sync_sentinel[src_idx][sync_iteration];
        vnbr_last_end[i] = end_sync_sentinel[dst_idx][sync_iteration] > end_sync_sentinel[src_idx][sync_iteration] ? end_sync_sentinel[dst_idx][sync_iteration] : end_sync_sentinel[src_idx][sync_iteration];
        vnbr_sync_times[i] = vnbr_last_end[i] - vnbr_last_start[i] - sync_sentinel_overhead;
        if (vnbr_sync_time < vnbr_sync_times[i]) vnbr_sync_time = vnbr_sync_times[i];
      end
      vnbr_sync_acc += vnbr_sync_time;
      $display("[TB][SYNC PERF][VNBR] detected completed synchronization in EX stage. Synchronization time %0tns (%0d clock cycles)", vnbr_sync_time, vnbr_sync_time/CLK_PERIOD);

      for (int unsigned i = 0; i < n_pairs; i++) begin
        automatic int unsigned src_idx;
        automatic int unsigned dst_idx;
        if (i%(magia_tb_pkg::N_TILES_X/2)) begin
          src_idx = 2*i;
          dst_idx = 2*i-1;
        end else begin
          src_idx = 2*i;
          dst_idx = 2*i-1 + magia_tb_pkg::N_TILES_X;
        end
        hring_last_start[i] = start_sync_sentinel[dst_idx][sync_iteration] > start_sync_sentinel[src_idx][sync_iteration] ? start_sync_sentinel[dst_idx][sync_iteration] : start_sync_sentinel[src_idx][sync_iteration];
        hring_last_end[i] = end_sync_sentinel[dst_idx][sync_iteration] > end_sync_sentinel[src_idx][sync_iteration] ? end_sync_sentinel[dst_idx][sync_iteration] : end_sync_sentinel[src_idx][sync_iteration];
        hring_sync_times[i] = hring_last_end[i] - hring_last_start[i] - sync_sentinel_overhead;
        if (hring_sync_time < hring_sync_times[i]) hring_sync_time = hring_sync_times[i];
      end
      hring_sync_acc += hring_sync_time;
      $display("[TB][SYNC PERF][HRING] detected completed synchronization in EX stage. Synchronization time %0tns (%0d clock cycles)", hring_sync_time, hring_sync_time/CLK_PERIOD);

      for (int unsigned i = 0; i < n_pairs; i++) begin
        automatic int unsigned src_idx;
        automatic int unsigned dst_idx;
        if (i%(magia_tb_pkg::N_TILES_Y/2)) begin
          src_idx = i%magia_tb_pkg::N_TILES_X + 2*(i/magia_tb_pkg::N_TILES_X)*magia_tb_pkg::N_TILES_X;
          dst_idx = i%magia_tb_pkg::N_TILES_X + 2*(i/magia_tb_pkg::N_TILES_X)*magia_tb_pkg::N_TILES_X - magia_tb_pkg::N_TILES_X;
        end else begin
          src_idx = i%magia_tb_pkg::N_TILES_X + 2*(i/magia_tb_pkg::N_TILES_X)*magia_tb_pkg::N_TILES_X;
          dst_idx = i%magia_tb_pkg::N_TILES_X + 2*(i/magia_tb_pkg::N_TILES_X)*magia_tb_pkg::N_TILES_X - magia_tb_pkg::N_TILES_X + magia_tb_pkg::N_TILES;
        end
        vring_last_start[i] = start_sync_sentinel[dst_idx][sync_iteration] > start_sync_sentinel[src_idx][sync_iteration] ? start_sync_sentinel[dst_idx][sync_iteration] : start_sync_sentinel[src_idx][sync_iteration];
        vring_last_end[i] = end_sync_sentinel[dst_idx][sync_iteration] > end_sync_sentinel[src_idx][sync_iteration] ? end_sync_sentinel[dst_idx][sync_iteration] : end_sync_sentinel[src_idx][sync_iteration];
        vring_sync_times[i] = vring_last_end[i] - vring_last_start[i] - sync_sentinel_overhead;
        if (vring_sync_time < vring_sync_times[i]) vring_sync_time = vring_sync_times[i];
      end
      vring_sync_acc += vring_sync_time;
      $display("[TB][SYNC PERF][VRING] detected completed synchronization in EX stage. Synchronization time %0tns (%0d clock cycles)", vring_sync_time, vring_sync_time/CLK_PERIOD);

      sync_iteration++;
    end
  end
`endif

`ifdef PROFILE_SENTINEL
  localparam time sentinel_overhead = CLK_PERIOD; // Overhead of the sentinel start/end pair
  bit[31:0] curr_instr_wb_pper[magia_tb_pkg::N_TILES];
  time start_sentinel[magia_tb_pkg::N_TILES][$];
  time end_sentinel[magia_tb_pkg::N_TILES][$];
  time sentinel_latency[magia_tb_pkg::N_TILES];
  time start_cmi_sentinel[magia_tb_pkg::N_TILES][$];
  time end_cmi_sentinel[magia_tb_pkg::N_TILES][$];
  time latency_cmi_sentinel[magia_tb_pkg::N_TILES];
  time acc_cmi_sentinel[magia_tb_pkg::N_TILES] = '{default: 0};
  time max_cmi_sentinel = 0;
  time start_cmo_sentinel[magia_tb_pkg::N_TILES][$];
  time end_cmo_sentinel[magia_tb_pkg::N_TILES][$];
  time latency_cmo_sentinel[magia_tb_pkg::N_TILES];
  time acc_cmo_sentinel[magia_tb_pkg::N_TILES] = '{default: 0};
  time max_cmo_sentinel = 0;
  time start_cmp_sentinel[magia_tb_pkg::N_TILES][$];
  time end_cmp_sentinel[magia_tb_pkg::N_TILES][$];
  time latency_cmp_sentinel[magia_tb_pkg::N_TILES];
  time acc_cmp_sentinel[magia_tb_pkg::N_TILES] = '{default: 0};
  time max_cmp_sentinel = 0;
  time max_cmiop_sentinel = 0;
  for (genvar i = 0; i < magia_tb_pkg::N_TILES_Y; i++) begin: gen_tile_pper_instr_monitor_y
    for (genvar j = 0; j < magia_tb_pkg::N_TILES_X; j++) begin: gen_tile_pper_instr_monitor_x 
      assign curr_instr_wb_pper[i*magia_tb_pkg::N_TILES_X+j] = i_magia.gen_y_tile[i].gen_x_tile[j].i_magia_tile.i_cv32e40x_core.core_i.wb_stage_i.ex_wb_pipe_i.instr_valid ?
      i_magia.gen_y_tile[i].gen_x_tile[j].i_magia_tile.i_cv32e40x_core.core_i.wb_stage_i.ex_wb_pipe_i.instr.bus_resp.rdata : '0;
      always @(curr_instr_wb_pper[i*magia_tb_pkg::N_TILES_X+j]) begin: instr_pper_wb_reporter
        if (curr_instr_wb_pper[i*magia_tb_pkg::N_TILES_X+j] == 32'h5AA00013) begin
          start_sentinel[i*magia_tb_pkg::N_TILES_X+j].push_back($time);
          $display("[TB][mhartid %0d - Tile (%0d, %0d)] Detected sentinel start instruction in WB stage at time %0dns", 
          i*magia_tb_pkg::N_TILES_X+j, i, j, $time);
        end
        if (curr_instr_wb_pper[i*magia_tb_pkg::N_TILES_X+j] == 32'h50B00013) begin
          start_cmi_sentinel[i*magia_tb_pkg::N_TILES_X+j].push_back($time);
          $display("[TB][mhartid %0d - Tile (%0d, %0d)] Detected start input communication sentinel accumulator instruction in WB stage at time %0dns", 
          i*magia_tb_pkg::N_TILES_X+j, i, j, $time);
        end
        if (curr_instr_wb_pper[i*magia_tb_pkg::N_TILES_X+j] == 32'h51B00013) begin
          start_cmo_sentinel[i*magia_tb_pkg::N_TILES_X+j].push_back($time);
          $display("[TB][mhartid %0d - Tile (%0d, %0d)] Detected start output (result) communication sentinel accumulator instruction in WB stage at time %0dns", 
          i*magia_tb_pkg::N_TILES_X+j, i, j, $time);
        end
        if (curr_instr_wb_pper[i*magia_tb_pkg::N_TILES_X+j] == 32'h52B00013) begin
          start_cmp_sentinel[i*magia_tb_pkg::N_TILES_X+j].push_back($time);
          $display("[TB][mhartid %0d - Tile (%0d, %0d)] Detected start computation sentinel accumulator instruction in WB stage at time %0dns", 
          i*magia_tb_pkg::N_TILES_X+j, i, j, $time);
        end
        if (curr_instr_wb_pper[i*magia_tb_pkg::N_TILES_X+j] == 32'h5FF00013) begin
          end_sentinel[i*magia_tb_pkg::N_TILES_X+j].push_back($time);
          $display("[TB][mhartid %0d - Tile (%0d, %0d)] Detected sentinel end instruction in WB stage at time %0dns", 
          i*magia_tb_pkg::N_TILES_X+j, i, j, $time);

          if (start_sentinel[i*magia_tb_pkg::N_TILES_X+j].size() < 1) begin
            $error("[TB][mhartid %0d - Tile (%0d, %0d)] Detected sentinel end instruction without corresponding sentinel start instruction",
            i*magia_tb_pkg::N_TILES_X+j, i, j);
            end_sentinel[i*magia_tb_pkg::N_TILES_X+j].pop_back();
          end else begin
            sentinel_latency[i*magia_tb_pkg::N_TILES_X+j] = end_sentinel[i*magia_tb_pkg::N_TILES_X+j].pop_back() - start_sentinel[i*magia_tb_pkg::N_TILES_X+j].pop_back() - sentinel_overhead;
            $display("[TB][mhartid %0d - Tile (%0d, %0d)] Detected sentinel start-end pair with latency %0tns (%0d clock cycles)",
            i*magia_tb_pkg::N_TILES_X+j, i, j, sentinel_latency[i*magia_tb_pkg::N_TILES_X+j], sentinel_latency[i*magia_tb_pkg::N_TILES_X+j]/CLK_PERIOD);
          end
        end
        if (curr_instr_wb_pper[i*magia_tb_pkg::N_TILES_X+j] == 32'h50C00013) begin
          end_cmi_sentinel[i*magia_tb_pkg::N_TILES_X+j].push_back($time);
          $display("[TB][mhartid %0d - Tile (%0d, %0d)] Detected finish (record) input communication sentinel accumulator instruction in WB stage at time %0dns", 
          i*magia_tb_pkg::N_TILES_X+j, i, j, $time);

          if (start_cmi_sentinel[i*magia_tb_pkg::N_TILES_X+j].size() < 1) begin
            $error("[TB][mhartid %0d - Tile (%0d, %0d)] Detected finish (record) input communication sentinel accumulator instruction without corresponding start input communication sentinel accumulator instruction",
            i*magia_tb_pkg::N_TILES_X+j, i, j);
            end_cmi_sentinel[i*magia_tb_pkg::N_TILES_X+j].pop_back();
          end else begin
            latency_cmi_sentinel[i*magia_tb_pkg::N_TILES_X+j] = end_cmi_sentinel[i*magia_tb_pkg::N_TILES_X+j].pop_back() - start_cmi_sentinel[i*magia_tb_pkg::N_TILES_X+j].pop_back() - sentinel_overhead;
            acc_cmi_sentinel[i*magia_tb_pkg::N_TILES_X+j] += latency_cmi_sentinel[i*magia_tb_pkg::N_TILES_X+j];
            $display("[TB][mhartid %0d - Tile (%0d, %0d)] Detected input communication sentinel accumulator start-end pair with latency %0tns (%0d clock cycles) and accumulated latency %0tns (%0d clock cycles)",
            i*magia_tb_pkg::N_TILES_X+j, i, j, latency_cmi_sentinel[i*magia_tb_pkg::N_TILES_X+j], latency_cmi_sentinel[i*magia_tb_pkg::N_TILES_X+j]/CLK_PERIOD, acc_cmi_sentinel[i*magia_tb_pkg::N_TILES_X+j], acc_cmi_sentinel[i*magia_tb_pkg::N_TILES_X+j]/CLK_PERIOD);
          end
        end
        if (curr_instr_wb_pper[i*magia_tb_pkg::N_TILES_X+j] == 32'h51C00013) begin
          end_cmo_sentinel[i*magia_tb_pkg::N_TILES_X+j].push_back($time);
          $display("[TB][mhartid %0d - Tile (%0d, %0d)] Detected finish (record) output (result) communication sentinel accumulator instruction in WB stage at time %0dns", 
          i*magia_tb_pkg::N_TILES_X+j, i, j, $time);

          if (start_cmo_sentinel[i*magia_tb_pkg::N_TILES_X+j].size() < 1) begin
            $error("[TB][mhartid %0d - Tile (%0d, %0d)] Detected finish (record) output (result) communication sentinel accumulator instruction without corresponding start output (result) communication sentinel accumulator instruction",
            i*magia_tb_pkg::N_TILES_X+j, i, j);
            end_cmo_sentinel[i*magia_tb_pkg::N_TILES_X+j].pop_back();
          end else begin
            latency_cmo_sentinel[i*magia_tb_pkg::N_TILES_X+j] = end_cmo_sentinel[i*magia_tb_pkg::N_TILES_X+j].pop_back() - start_cmo_sentinel[i*magia_tb_pkg::N_TILES_X+j].pop_back() - sentinel_overhead;
            acc_cmo_sentinel[i*magia_tb_pkg::N_TILES_X+j] += latency_cmo_sentinel[i*magia_tb_pkg::N_TILES_X+j];
            $display("[TB][mhartid %0d - Tile (%0d, %0d)] Detected output (result) communication sentinel accumulator start-end pair with latency %0tns (%0d clock cycles) and accumulated latency %0tns (%0d clock cycles)",
            i*magia_tb_pkg::N_TILES_X+j, i, j, latency_cmo_sentinel[i*magia_tb_pkg::N_TILES_X+j], latency_cmo_sentinel[i*magia_tb_pkg::N_TILES_X+j]/CLK_PERIOD, acc_cmo_sentinel[i*magia_tb_pkg::N_TILES_X+j], acc_cmo_sentinel[i*magia_tb_pkg::N_TILES_X+j]/CLK_PERIOD);
          end
        end
        if (curr_instr_wb_pper[i*magia_tb_pkg::N_TILES_X+j] == 32'h52C00013) begin
          end_cmp_sentinel[i*magia_tb_pkg::N_TILES_X+j].push_back($time);
          $display("[TB][mhartid %0d - Tile (%0d, %0d)] Detected finish (record) computation sentinel accumulator instruction in WB stage at time %0dns", 
          i*magia_tb_pkg::N_TILES_X+j, i, j, $time);

          if (start_cmp_sentinel[i*magia_tb_pkg::N_TILES_X+j].size() < 1) begin
            $error("[TB][mhartid %0d - Tile (%0d, %0d)] Detected finish (record) computation sentinel accumulator instruction without corresponding start computation sentinel accumulator instruction",
            i*magia_tb_pkg::N_TILES_X+j, i, j);
            end_cmp_sentinel[i*magia_tb_pkg::N_TILES_X+j].pop_back();
          end else begin
            latency_cmp_sentinel[i*magia_tb_pkg::N_TILES_X+j] = end_cmp_sentinel[i*magia_tb_pkg::N_TILES_X+j].pop_back() - start_cmp_sentinel[i*magia_tb_pkg::N_TILES_X+j].pop_back() - sentinel_overhead;
            acc_cmp_sentinel[i*magia_tb_pkg::N_TILES_X+j] += latency_cmp_sentinel[i*magia_tb_pkg::N_TILES_X+j];
            $display("[TB][mhartid %0d - Tile (%0d, %0d)] Detected computation sentinel accumulator start-end pair with latency %0tns (%0d clock cycles) and accumulated latency %0tns (%0d clock cycles)",
            i*magia_tb_pkg::N_TILES_X+j, i, j, latency_cmp_sentinel[i*magia_tb_pkg::N_TILES_X+j], latency_cmp_sentinel[i*magia_tb_pkg::N_TILES_X+j]/CLK_PERIOD, acc_cmp_sentinel[i*magia_tb_pkg::N_TILES_X+j], acc_cmp_sentinel[i*magia_tb_pkg::N_TILES_X+j]/CLK_PERIOD);
          end
        end
        if (curr_instr_wb_pper[i*magia_tb_pkg::N_TILES_X+j] == 32'h50D00013) begin
          $display("[TB][PERF][mhartid %0d - Tile (%0d, %0d)] Input communication sentinel accumulator state: %0tns (%0d clock cycles)", 
          i*magia_tb_pkg::N_TILES_X+j, i, j, acc_cmi_sentinel[i*magia_tb_pkg::N_TILES_X+j], acc_cmi_sentinel[i*magia_tb_pkg::N_TILES_X+j]/CLK_PERIOD);
        end
        if (curr_instr_wb_pper[i*magia_tb_pkg::N_TILES_X+j] == 32'h51D00013) begin
          $display("[TB][PERF][mhartid %0d - Tile (%0d, %0d)] Output (result) communication sentinel accumulator state: %0tns (%0d clock cycles)", 
          i*magia_tb_pkg::N_TILES_X+j, i, j, acc_cmo_sentinel[i*magia_tb_pkg::N_TILES_X+j], acc_cmo_sentinel[i*magia_tb_pkg::N_TILES_X+j]/CLK_PERIOD);
        end
        if (curr_instr_wb_pper[i*magia_tb_pkg::N_TILES_X+j] == 32'h52D00013) begin
          $display("[TB][PERF][mhartid %0d - Tile (%0d, %0d)] Computation sentinel accumulator state: %0tns (%0d clock cycles)", 
          i*magia_tb_pkg::N_TILES_X+j, i, j, acc_cmp_sentinel[i*magia_tb_pkg::N_TILES_X+j], acc_cmp_sentinel[i*magia_tb_pkg::N_TILES_X+j]/CLK_PERIOD);
        end
        if (curr_instr_wb_pper[i*magia_tb_pkg::N_TILES_X+j] == 32'h5EE00013) begin
          for (int unsigned i = 0; i < magia_tb_pkg::N_TILES; i++) begin
            if (max_cmi_sentinel < acc_cmi_sentinel[i]) max_cmi_sentinel = acc_cmi_sentinel[i];
            if (max_cmo_sentinel < acc_cmo_sentinel[i]) max_cmo_sentinel = acc_cmo_sentinel[i];
            if (max_cmp_sentinel < acc_cmp_sentinel[i]) max_cmp_sentinel = acc_cmp_sentinel[i];
            if (max_cmiop_sentinel < (acc_cmi_sentinel[i]+acc_cmo_sentinel[i]+acc_cmp_sentinel[i])) max_cmiop_sentinel = (acc_cmi_sentinel[i]+acc_cmo_sentinel[i]+acc_cmp_sentinel[i]);
          end
          $display("[TB][PERF][mhartid %0d - Tile (%0d, %0d)] Global maximul performance overheads:
          \tInput communication:          %0tns (%0d clock cycles)
          \tOutpu (result) communication: %0tns (%0d clock cycles)
          \tComputation:                  %0tns (%0d clock cycles)
          \tTotal (CMI+CMO+CMP):          %0tns (%0d clock cycles)", 
          i*magia_tb_pkg::N_TILES_X+j, i, j, max_cmi_sentinel, max_cmi_sentinel/CLK_PERIOD, max_cmo_sentinel, max_cmo_sentinel/CLK_PERIOD, max_cmp_sentinel, max_cmp_sentinel/CLK_PERIOD, max_cmiop_sentinel, max_cmiop_sentinel/CLK_PERIOD);
        end
      end
    end
  end
`endif

/*******************************************************/
/**              Instruction Monitor End              **/
/*******************************************************/

endmodule: magia_vip
