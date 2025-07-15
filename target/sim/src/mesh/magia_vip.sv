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
`ifdef PROFILE
  bit[31:0] curr_instr_ex[magia_tb_pkg::N_TILES];
  bit[31:0] curr_instr_id[magia_tb_pkg::N_TILES];
  for (genvar i = 0; i < magia_tb_pkg::N_TILES_Y; i++) begin: gen_tile_instr_monitor_y
    for (genvar j = 0; j < magia_tb_pkg::N_TILES_X; j++) begin: gen_tile_instr_monitor_x 
      assign curr_instr_ex[i*magia_tb_pkg::N_TILES_X+j] = i_magia.gen_y_tile[i].gen_x_tile[j].i_magia_tile.i_cv32e40x_core.core_i.id_stage_i.id_ex_pipe_o.instr.bus_resp.rdata;
      always @(curr_instr_ex[i*magia_tb_pkg::N_TILES_X+j]) begin: instr_ex_reporter
        if (curr_instr_ex[i*magia_tb_pkg::N_TILES_X+j] == 32'h50500013) 
          $display("[TB][mhartid %0d - Tile (%0d, %0d)] detected sentinel instruction in EX stage at time %0dns",i*magia_tb_pkg::N_TILES_X+j , i, j, time_var);
        if (curr_instr_ex[i*magia_tb_pkg::N_TILES_X+j] == 32'h0062A3AF) 
          $display("[TB][mhartid %0d - Tile (%0d, %0d)] detected AMO (sync) instruction at time %0dns",i*magia_tb_pkg::N_TILES_X+j , i, j, time_var);
      end
      assign curr_instr_id[i*magia_tb_pkg::N_TILES_X+j] = i_magia.gen_y_tile[i].gen_x_tile[j].i_magia_tile.i_cv32e40x_core.core_i.id_stage_i.if_id_pipe_i.instr.bus_resp.rdata;
      always @(curr_instr_id[i*magia_tb_pkg::N_TILES_X+j]) begin: instr_id_reporter
        if (curr_instr_id[i*magia_tb_pkg::N_TILES_X+j] == 32'h40400013) 
          $display("[TB][mhartid %0d - Tile (%0d, %0d)] detected sentinel instruction in ID stage at time %0dns",i*magia_tb_pkg::N_TILES_X+j , i, j, time_var);
        if (curr_instr_id[i*magia_tb_pkg::N_TILES_X+j] == 32'h0062A05B) 
          $display("[TB][mhartid %0d - Tile (%0d, %0d)] detected fsync instruction at time %0dns",i*magia_tb_pkg::N_TILES_X+j , i, j, time_var);
      end
    end
  end
`endif

/*******************************************************/
/**              Instruction Monitor End              **/
/*******************************************************/

endmodule: magia_vip
