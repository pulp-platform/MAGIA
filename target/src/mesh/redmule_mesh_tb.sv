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
 * RedMulE Mesh Testbench
 */

module redmule_mesh_tb;

  string                                  inst_hex;
  string                                  data_hex;
  bit[31:0]                               boot_addr;
  bit[redmule_mesh_tb_pkg::N_TILES*8-1:0] exit_code;

  redmule_mesh_fixture fixture();

  initial begin
    // Fetch plusargs or use safe (fail-fast) defaults
    if (!$value$plusargs("INST_HEX=%s" ,   inst_hex))  inst_hex  = "";
    if (!$value$plusargs("DATA_HEX=%s" ,   data_hex))  data_hex  = "";
    if (!$value$plusargs("BOOT_ADDR=%h",   boot_addr)) boot_addr = 0;

    // Preload data (dummy L2 MEM) and instructions (dummy I$)
    fixture.vip.inst_preload(inst_hex);
    fixture.vip.data_preload(data_hex);

    // Wait for reset
    fixture.vip.wait_for_reset();

    // Preload in idle mode
    fixture.vip.init(boot_addr);
    fixture.vip.elf_run();
    fixture.vip.wait_for_eoc(exit_code);

    $display("SIMULATION FINISHED WITH EXIT CODE: %0h\n", exit_code);

    $finish;
  end

endmodule: redmule_mesh_tb