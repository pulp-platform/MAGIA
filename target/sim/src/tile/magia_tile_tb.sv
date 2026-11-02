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
 * MAGIA Tile Testbench
 */

module magia_tile_tb;

  string    inst_hex;
  string    data_hex;
  bit[31:0] boot_addr;
  bit[31:0] exit_code;

  magia_tile_fixture fixture();

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
`ifndef VERILATOR
  // MSHR occupancy, lookup stalls and parks, one report per perf counter window
  bind data_cc_top magia_dcache_mshr_monitor #(
    .NumMshr ( NumMshr ),
    .NumSets ( NumSets )
  ) i_magia_dcache_mshr_monitor (
    .clk_i                 ( clk_i                                 ),
    .rst_ni                ( rst_ni                                ),
    .perf_en_i             ( i_cfg_regs.perf_enable_q              ),
    .mshr_free_i           ( i_mshr.free_mask                      ),
    .unit_idle_i           ( i_miss_engine.unit_idle               ),
    .res_valid_i           ( result_valid                          ),
    .res_ready_i           ( result_ready                          ),
    .res_kind_i            ( result.kind                           ),
    .res_prefetch_i        ( result.desc.prefetch                  ),
    .alloc_ready_i         ( mshr_alloc_ready                      ),
    .s2_valid_i            ( i_lookup.s2_valid                     ),
    .s2_advance_i          ( i_lookup.s2_advance                   ),
    .s2_same_set_pending_i ( i_lookup.same_set_pending             ),
    .s2_out_free_i         ( i_lookup.out_free                     ),
    .s2_kind_i             ( i_lookup.s2_result.kind               ),
    .s2_wake_i             ( i_lookup.wake_selected                ),
    .s2_same_line_i        ( same_line                             ),
    .s2_addr_i             ( i_lookup.s2_desc.addr                 ),
    .s2_set_i              ( i_lookup.s2_set                       ),
    .fe_valid_i            ( fe_desc_valid                         ),
    .fe_ready_i            ( fe_desc_ready                         ),
    .core_req_i            ( core_req_i.req                        ),
    .core_gnt_i            ( core_rsp_o.gnt                        ),
    .rob_alloc_valid_i     ( rob_alloc_valid                       ),
    .rob_alloc_ready_i     ( rob_alloc_ready                       ),
    .ar_valid_i            ( axi_req_o.ar_valid                    ),
    .ar_ready_i            ( axi_rsp_i.ar_ready                    ),
    .r_valid_i             ( axi_rsp_i.r_valid                     ),
    .r_ready_i             ( axi_req_o.r_ready                     ),
    .r_last_i              ( axi_rsp_i.r.last                      )
  );
`endif
`endif

  initial begin
    // Fetch plusargs or use safe (fail-fast) defaults
    if (!$value$plusargs("INST_HEX=%s" ,      inst_hex))      inst_hex      = "";
    if (!$value$plusargs("DATA_HEX=%s" ,      data_hex))      data_hex      = "";
    if (!$value$plusargs("BOOT_ADDR=%h",      boot_addr))     boot_addr     = 0;

    // Single-binary flow: the CV32 ELF embeds the optional Spatz/PULP
    // task binaries in dedicated sections (.spatz_binary / .pulp_binary)
    // of instrram, so only one stimulus pair is preloaded.
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

endmodule: magia_tile_tb