/*
 * Copyright (C) 2023-2024 ETH Zurich and University of Bologna
 *
 * Licensed under the Solderpad Hardware License, Version 0.51 
 * (the "License"); you may not use this file except in compliance 
 * with the License. You may obtain a copy of the License at
 *
 *     http://solderpad.org/licenses/SHL-0.51
 *
 * Unless required by applicable law or agreed to in writing, software, hardware
 * and materials distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * SPDX-License-Identifier: SHL-0.51
 *
 * Authors: Victor Isachi <victor.isachi@unibo.it>
 * 
 * MAGIA Testbench
 */

module magia_tb;

  string                            inst_hex;
  string                            data_hex;
  bit[31:0]                         boot_addr;
  bit[magia_tb_pkg::N_TILES*16-1:0] exit_code;

  magia_fixture fixture();

  // Data cache monitors (events, order rules of the hit port, wait in the cache obi_mux), printed at the end of
  // every perf window and of the simulation; without the data cache there is no data_cc_top to bind to, and vopt
  // rejects the bind
`ifdef MAGIA_DCACHE
  bind data_cc_top magia_dcache_monitor #(
    .cfg_req_t ( cfg_req_t ),
    .cfg_rsp_t ( cfg_rsp_t )
  ) i_magia_dcache_monitor (
    .clk_i            ( clk_i               ),
    .rst_ni           ( rst_ni              ),
    .events_i         ( events_o            ),
    .cfg_req_i        ( cfg_req_i           ),
    .cfg_rsp_i        ( cfg_rsp_o           ),
    .miss_req_valid_i ( miss_data_req_valid ),
    .miss_hold_i      ( miss_hold           ),
    .refill_valid_i   ( refill_valid        ),
    .refill_allowed_i ( refill_allowed      )
  );
  bind magia_isle magia_dcache_mux_monitor #(
    .NumPorts  ( NumDcacheMuxPorts                    ),
    .req_t     ( magia_tile_pkg::core_obi_data_req_t ),
    .rsp_t     ( magia_tile_pkg::core_obi_data_rsp_t ),
    .cfg_req_t ( magia_tile_pkg::core_obi_data_req_t ),
    .cfg_rsp_t ( magia_tile_pkg::core_obi_data_rsp_t )
  ) i_magia_dcache_mux_monitor (
    .clk_i     ( sys_clk                  ),
    .rst_ni    ( rst_ni                   ),
    .req_i     ( dcache_mgr_req           ),
    .rsp_i     ( dcache_mgr_rsp           ),
    .cfg_req_i ( ctrl_req[CtrlMap.dcache] ),
    .cfg_rsp_i ( ctrl_rsp[CtrlMap.dcache] )
  );
`endif

`ifdef VERILATOR
  // When running under Verilator this testbench prints nothing until the first
  // tile output, so emit a heartbeat to tell a slow run from a stalled one.
  // $time is scaled to the module timeunit (1ns), hence the /1000 to get us.
  initial begin
    forever begin
      $display("[INFO] %0d us elapsed in simulation.", $time/1000);
      #10000;
    end
  end
`endif

  initial begin
    // Fetch plusargs or use safe (fail-fast) defaults
    if (!$value$plusargs("INST_HEX=%s" ,      inst_hex))      inst_hex      = "";
    if (!$value$plusargs("DATA_HEX=%s" ,      data_hex))      data_hex      = "";
    if (!$value$plusargs("BOOT_ADDR=%h",      boot_addr))     boot_addr     = 0;

    // Single-binary flow: the CV32 ELF (@ 0xCC000000) embeds the optional
    // Spatz/PULP task binaries in dedicated linker sections
    // (.spatz_binary / .pulp_binary), so only one stimulus pair is preloaded.
    fixture.vip.inst_preload(inst_hex);
    fixture.vip.data_preload(data_hex);

    // Wait for reset
    fixture.vip.wait_for_reset();

    // Preload in idle mode
    fixture.vip.init(boot_addr);
    fixture.vip.elf_run();
    fixture.vip.wait_for_eoc(exit_code);

    if(exit_code != 0)
      $fatal(1, "SIMULATION FINISHED WITH EXIT CODE: %0h\n", exit_code);
    else begin
      $display("SIMULATION FINISHED WITH EXIT CODE: %0h\n", exit_code);
      $finish(0);
    end
    
  end

endmodule: magia_tb
