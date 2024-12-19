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

 `include "axi/assign.svh"

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
  output logic                                 clk,
  output logic                                 rst_n,
  output logic                                 test_mode,
  output logic                                 tile_enable,

  input  redmule_mesh_pkg::axi_default_req_t[redmule_mesh_tb_pkg::N_TILES_X-1:0][redmule_mesh_tb_pkg::N_TILES_Y-1:0]   data_out_req,
  output redmule_mesh_pkg::axi_default_rsp_t[redmule_mesh_tb_pkg::N_TILES_X-1:0][redmule_mesh_tb_pkg::N_TILES_Y-1:0]   data_out_rsp,

  output redmule_mesh_tb_pkg::axi_l2_vip_req_t[redmule_mesh_tb_pkg::N_TILES_X-1:0][redmule_mesh_tb_pkg::N_TILES_Y-1:0] data_in_req,
  input  redmule_mesh_tb_pkg::axi_l2_vip_rsp_t[redmule_mesh_tb_pkg::N_TILES_X-1:0][redmule_mesh_tb_pkg::N_TILES_Y-1:0] data_in_rsp,

  fractal_if.slv_port                          sync_if[redmule_mesh_tb_pkg::N_TILES],

  output logic                                 scan_cg_en,

  output logic[31:0]                           boot_addr, //TODO: manage signal
  output logic[31:0]                           mtvec_addr,
  output logic[31:0]                           dm_halt_addr,
  output logic[31:0]                           dm_exception_addr,
  output logic[31:0]                           mhartid[redmule_mesh_tb_pkg::N_TILES],
  output logic[ 3:0]                           mimpid_patch,

  input  logic[63:0]                           mcycle[redmule_mesh_tb_pkg::N_TILES],
  output logic[63:0]                           time_var,

  output logic[redmule_mesh_pkg::N_IRQ-1:0]    irq, //TODO: manage signal

  input  logic                                 fencei_flush_req[redmule_mesh_tb_pkg::N_TILES],
  output logic                                 fencei_flush_ack,

  output logic                                 debug_req,
  input  logic                                 debug_havereset[redmule_mesh_tb_pkg::N_TILES],
  input  logic                                 debug_running[redmule_mesh_tb_pkg::N_TILES],
  input  logic                                 debug_halted[redmule_mesh_tb_pkg::N_TILES],
  input  logic                                 debug_pc_valid[redmule_mesh_tb_pkg::N_TILES],
  input  logic[31:0]                           debug_pc[redmule_mesh_tb_pkg::N_TILES],

  output logic                                 fetch_enable,  //TODO: manage signal
  input  logic                                 core_sleep[redmule_mesh_tb_pkg::N_TILES],
  output logic                                 wu_wfe
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

  redmule_mesh_tb_pkg::axi_l2_vip_req_t[redmule_mesh_tb_pkg::N_TILES_X-1:0][redmule_mesh_tb_pkg::N_TILES_Y-1:0] data_mst_req; // N_TILES + L2
  redmule_mesh_tb_pkg::axi_l2_vip_rsp_t[redmule_mesh_tb_pkg::N_TILES_X-1:0][redmule_mesh_tb_pkg::N_TILES_Y-1:0] data_mst_rsp; // N_TILES + L2

  redmule_mesh_tb_pkg::axi_l2_vip_req_t[redmule_mesh_tb_pkg::N_TILES_Y-1:0] l2_data_mst_req;
  redmule_mesh_tb_pkg::axi_l2_vip_rsp_t[redmule_mesh_tb_pkg::N_TILES_Y-1:0] l2_data_mst_rsp;

/*******************************************************/
/**          Internal Signal Definitions End          **/
/*******************************************************/
/**          Interface Assignments Beginning          **/
/*******************************************************/

  generate
    for(genvar i=0; i<redmule_mesh_tb_pkg::N_TILES_X; i++) begin
      for(genvar j=0; j<redmule_mesh_tb_pkg::N_TILES_Y;j++) begin
        `AXI_ASSIGN_REQ_STRUCT(data_in_req[i][j], data_mst_req[i][j])
        `AXI_ASSIGN_RESP_STRUCT(data_mst_rsp[i][j], data_in_rsp[i][j])
      end
    end
  endgenerate

/*******************************************************/
/**             Interface Assignments End             **/
/*******************************************************/

  assign test_mode         = 1'b0;
  assign tile_enable       = 1'b1;
  assign scan_cg_en        = 1'b0;
  assign mtvec_addr        = '0;
  assign dm_halt_addr      = '0;
  assign dm_exception_addr = '0;
  for (genvar i = 0; i < redmule_mesh_tb_pkg::N_TILES; i++) begin: gen_mhartid
    assign mhartid[i]      = i;
  end
  assign mimpid_patch      = '0;
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

  task automatic wait_for_eoc(output bit[redmule_mesh_tb_pkg::N_TILES*8-1:0] exit_code);
    bit eoc = 1'b0;
    while (!eoc) begin
      eoc = 1'b1;
      for (int i = 0; i < redmule_mesh_tb_pkg::N_TILES; i++)
        if (i_l2_mem.mem[32'hCC03_0000 + i]  == 0)
          eoc = 1'b0;
      #10000;
    end
    
    for (int i = 0; i < redmule_mesh_tb_pkg::N_TILES; i++)
      exit_code |= i_l2_mem.mem[32'hCC03_0000 + i] << i*8;
  endtask: wait_for_eoc

/*******************************************************/
/**                 TB Subroutines End                **/
/*******************************************************/
/**                  L2 MEM Beginning                 **/
/*******************************************************/

  axi_sim_mem #(
    .AddrWidth          ( redmule_mesh_pkg::ADDR_W              ),
    .DataWidth          ( redmule_mesh_pkg::DATA_W              ),
    .IdWidth            ( redmule_mesh_tb_pkg::L2_ID_W          ),
    .UserWidth          ( redmule_mesh_tb_pkg::L2_U_W           ),
    .NumPorts           ( redmule_mesh_tb_pkg::N_TILES_Y        ),
    .axi_req_t          ( redmule_mesh_tb_pkg::axi_l2_vip_req_t ),
    .axi_rsp_t          ( redmule_mesh_tb_pkg::axi_l2_vip_rsp_t ),
    .WarnUninitialized  ( 1                                     ),
    .ClearErrOnAccess   ( 1                                     ),
    .ApplDelay          ( CLK_PERIOD * T_APPL                   ),
    .AcqDelay           ( CLK_PERIOD * T_TEST                   )
  ) i_l2_mem (
    .clk_i              ( clk             ),
    .rst_ni             ( rst_n           ),
    .axi_req_i          ( l2_data_mst_req ),
    .axi_rsp_o          ( l2_data_mst_rsp ),
    .mon_w_valid_o      (                 ),
    .mon_w_addr_o       (                 ),
    .mon_w_data_o       (                 ),
    .mon_w_id_o         (                 ),
    .mon_w_user_o       (                 ),
    .mon_w_beat_count_o (                 ),
    .mon_w_last_o       (                 ),
    .mon_r_valid_o      (                 ),
    .mon_r_addr_o       (                 ),
    .mon_r_data_o       (                 ),
    .mon_r_id_o         (                 ),
    .mon_r_user_o       (                 ),
    .mon_r_beat_count_o (                 ),
    .mon_r_last_o       (                 )
  );

/*******************************************************/
/**                     L2 MEM End                    **/
/*******************************************************/
/**           Tiles - L2 (FlooNoC) Beginning          **/
/*******************************************************/

  if ((redmule_mesh_tb_pkg::N_TILES_X == 2) && (redmule_mesh_tb_pkg::N_TILES_Y == 2)) begin: gen_2x2_noc
    floo_axi_mesh_2x2_noc i_mesh_noc (
      .clk_i                        ( clk             ),
      .rst_ni                       ( rst_n           ),
      .test_enable_i                ( 1'b0            ),
      .redmule_tile_data_slv_req_i  ( data_out_req    ),
      .redmule_tile_data_slv_rsp_o  ( data_out_rsp    ),
      .redmule_tile_data_mst_req_o  ( data_mst_req    ),
      .redmule_tile_data_mst_rsp_i  ( data_mst_rsp    ),
      .L2_data_mst_req_o            ( l2_data_mst_req ),
      .L2_data_mst_rsp_i            ( l2_data_mst_rsp )
    );
  end else if ((redmule_mesh_tb_pkg::N_TILES_X == 4) && (redmule_mesh_tb_pkg::N_TILES_Y == 4)) begin: gen_4x4_noc
    floo_axi_mesh_4x4_noc i_mesh_noc (
      .clk_i                        ( clk             ),
      .rst_ni                       ( rst_n           ),
      .test_enable_i                ( 1'b0            ),
      .redmule_tile_data_slv_req_i  ( data_out_req    ),
      .redmule_tile_data_slv_rsp_o  ( data_out_rsp    ),
      .redmule_tile_data_mst_req_o  ( data_mst_req    ),
      .redmule_tile_data_mst_rsp_i  ( data_mst_rsp    ),
      .L2_data_mst_req_o            ( l2_data_mst_req ),
      .L2_data_mst_rsp_i            ( l2_data_mst_rsp )
    );
  end else if ((redmule_mesh_tb_pkg::N_TILES_X == 8) && (redmule_mesh_tb_pkg::N_TILES_Y == 8)) begin: gen_8x8_noc
    floo_axi_mesh_8x8_noc i_mesh_noc (
      .clk_i                        ( clk             ),
      .rst_ni                       ( rst_n           ),
      .test_enable_i                ( 1'b0            ),
      .redmule_tile_data_slv_req_i  ( data_out_req    ),
      .redmule_tile_data_slv_rsp_o  ( data_out_rsp    ),
      .redmule_tile_data_mst_req_o  ( data_mst_req    ),
      .redmule_tile_data_mst_rsp_i  ( data_mst_rsp    ),
      .L2_data_mst_req_o            ( l2_data_mst_req ),
      .L2_data_mst_rsp_i            ( l2_data_mst_rsp )
    );
  end else if ((redmule_mesh_tb_pkg::N_TILES_X == 16) && (redmule_mesh_tb_pkg::N_TILES_Y == 16)) begin: gen_16x16_noc
    floo_axi_mesh_16x16_noc i_mesh_noc (
      .clk_i                        ( clk             ),
      .rst_ni                       ( rst_n           ),
      .test_enable_i                ( 1'b0            ),
      .redmule_tile_data_slv_req_i  ( data_out_req    ),
      .redmule_tile_data_slv_rsp_o  ( data_out_rsp    ),
      .redmule_tile_data_mst_req_o  ( data_mst_req    ),
      .redmule_tile_data_mst_rsp_i  ( data_mst_rsp    ),
      .L2_data_mst_req_o            ( l2_data_mst_req ),
      .L2_data_mst_rsp_i            ( l2_data_mst_rsp )
    );
  end else if ((redmule_mesh_tb_pkg::N_TILES_X == 32) && (redmule_mesh_tb_pkg::N_TILES_Y == 32)) begin: gen_32x32_noc
    floo_axi_mesh_32x32_noc i_mesh_noc (
      .clk_i                        ( clk             ),
      .rst_ni                       ( rst_n           ),
      .test_enable_i                ( 1'b0            ),
      .redmule_tile_data_slv_req_i  ( data_out_req    ),
      .redmule_tile_data_slv_rsp_o  ( data_out_rsp    ),
      .redmule_tile_data_mst_req_o  ( data_mst_req    ),
      .redmule_tile_data_mst_rsp_i  ( data_mst_rsp    ),
      .L2_data_mst_req_o            ( l2_data_mst_req ),
      .L2_data_mst_rsp_i            ( l2_data_mst_rsp )
    );
  end else $fatal("Unsupported Mesh configuration");

/*******************************************************/
/**              Tiles - L2 (FlooNoC) End              */
/*******************************************************/
/**         Synchronization Network Beginning         **/
/*******************************************************/

  localparam int unsigned LEVELS = 2;
  localparam int unsigned CU_LVL_WIDTH = LEVELS + 1;
  localparam int unsigned TOP_LVL_WIDTH = 2;
  localparam int unsigned SYNC_PORTS = $clog2(redmule_mesh_tb_pkg::N_TILES);

  fractal_if #(.LVL_WIDTH(CU_LVL_WIDTH-1)) if_sync_net[SYNC_PORTS-1:0]();
  fractal_if #(.LVL_WIDTH(1)) if_top[1]();

  // LEVEL 0 - tiles
  for (genvar i = 0; i < 2**(LEVELS-1); i++) begin: gen_cu_sync
    fractal_sync #(
      .SLV_WIDTH  ( CU_LVL_WIDTH )
    ) i_cu_fractal_sync (
      .clk_i    ( clk                             ),
      .rstn_i   ( rst_n                           ),
      .slaves   ( '{sync_if[2*i], sync_if[2*i+1]} ),
      .masters  ( '{if_sync_net[i]}               )
    );
  end

  // LEVEL 1 - sync tree
  for (genvar i = 0; i < 2**(LEVELS-2); i++) begin: gen_top_sync
    fractal_sync #(
      .SLV_WIDTH ( TOP_LVL_WIDTH )
    ) i_top_fractal_sync (
      .clk_i    ( clk                                     ),
      .rstn_i   ( rst_n                                   ),
      .slaves   ( '{if_sync_net[2*i], if_sync_net[2*i+1]} ),
      .masters  ( if_top                                  )
    );
  end

  always begin
    if_top[0].wake  = 1'b0;
    if_top[0].error = 1'b0;
    @(negedge clk);
    if (if_top[0].sync) begin
      @(negedge clk);
      if_top[0].wake  = 1'b1;
      if_top[0].error = 1'b1;
      do
        @(negedge clk);
      while (!if_top[0].ack);
    end
  end

/*******************************************************/
/**            Synchronization Network End            **/
/*******************************************************/
/**                 Printing Beginning                **/
/*******************************************************/

  for (genvar i = 0; i < redmule_mesh_tb_pkg::N_TILES_X; i++) begin: gen_tile_print_x
    for (genvar j = 0; j < redmule_mesh_tb_pkg::N_TILES_Y; j++) begin: gen_tile_print_y
      int errors = -1;
      bit stdio_ready  = 0;
      bit stderr_ready = 0;
      typedef struct packed {
        bit[31:0] data;
        bit[31:0] id;
      } string_char_t;
      bit print_line[2**redmule_mesh_tb_pkg::L2_ID_W];
      string_char_t chars[$];
      bit[redmule_mesh_tb_pkg::L2_ID_W-1:0] write_id;
      always @(posedge clk) begin: print_monitor
        if ((gen_x_tile[i].gen_y_tile[j].dut.i_axi_xbar.mst_ports_req_o[0].aw.addr == 32'hFFFF0000) && (gen_x_tile[i].gen_y_tile[j].dut.i_axi_xbar.mst_ports_req_o[0].aw_valid))
          stderr_ready = 1'b1;
        if ((gen_x_tile[i].gen_y_tile[j].dut.i_axi_xbar.mst_ports_req_o[0].aw.addr == 32'hFFFF0004+((i*redmule_mesh_tb_pkg::N_TILES_Y+j)*4)) && (gen_x_tile[i].gen_y_tile[j].dut.i_axi_xbar.mst_ports_req_o[0].aw_valid)) begin
          stdio_ready  = 1'b1;
          write_id = gen_x_tile[i].gen_y_tile[j].dut.i_axi_xbar.mst_ports_req_o[0].aw.id;
        end
        if ((gen_x_tile[i].gen_y_tile[j].dut.i_axi_xbar.mst_ports_req_o[0].w_valid) && stderr_ready) begin
          errors       = gen_x_tile[i].gen_y_tile[j].dut.i_axi_xbar.mst_ports_req_o[0].w.data[7:0];
          stderr_ready = 1'b0;
        end
        if ((gen_x_tile[i].gen_y_tile[j].dut.i_axi_xbar.mst_ports_req_o[0].w_valid) && stdio_ready) begin
          if (gen_x_tile[i].gen_y_tile[j].dut.i_axi_xbar.mst_ports_req_o[0].w.data[7:0] == 10)  // ASCII code for new line (\n) is 10
            print_line[write_id] = 1'b1;
          chars.push_back('{gen_x_tile[i].gen_y_tile[j].dut.i_axi_xbar.mst_ports_req_o[0].w.data[7:0], write_id});
          stdio_ready = 1'b0;
        end
        for (int k = 0; k < 2**redmule_mesh_tb_pkg::L2_ID_W; k++) begin
          if (print_line[k] == 1'b1) begin
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

  bit[31:0] curr_instr[redmule_mesh_tb_pkg::N_TILES];
  for (genvar i = 0; i < redmule_mesh_tb_pkg::N_TILES_X; i++) begin: gen_tile_instr_monitor_x
    for (genvar j = 0; j < redmule_mesh_tb_pkg::N_TILES_Y; j++) begin: gen_tile_instr_monitor_y 
      assign curr_instr[i*redmule_mesh_tb_pkg::N_TILES_Y+j] = gen_x_tile[i].gen_y_tile[j].dut.i_cv32e40x_core.core_i.id_stage_i.id_ex_pipe_o.instr.bus_resp.rdata;
      always @(curr_instr[i*redmule_mesh_tb_pkg::N_TILES_Y+j]) begin: instr_reporter
        if (curr_instr[i*redmule_mesh_tb_pkg::N_TILES_Y+j] == 32'h50500013) 
          $display("[TB][mhartid %0d - Tile (%0d, %0d)] detected sentinel instruction at time %0dns",i*redmule_mesh_tb_pkg::N_TILES_Y+j , j, i, time_var);
        if (curr_instr[i*redmule_mesh_tb_pkg::N_TILES_Y+j] == 32'h0002A05B) 
          $display("[TB][mhartid %0d - Tile (%0d, %0d)] detected fsync instruction at time %0dns",i*redmule_mesh_tb_pkg::N_TILES_Y+j , j, i, time_var);
        if (curr_instr[i*redmule_mesh_tb_pkg::N_TILES_Y+j] == 32'h0062A3AF) 
          $display("[TB][mhartid %0d - Tile (%0d, %0d)] detected AMO (sync) instruction at time %0dns",i*redmule_mesh_tb_pkg::N_TILES_Y+j , j, i, time_var);
      end
    end
  end

/*******************************************************/
/**              Instruction Monitor End              **/
/*******************************************************/

endmodule: redmule_mesh_vip
