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
 * RedMulE Tile Testbench
 */

module redmule_tile_tb;

  string     inst;
  string     data;
  string     mem;
  bit [31:0] exit_code;

  redmule_tile_fixture fixture();

  initial begin
    
  `ifdef SEP_INSTR_DATA_MEM
    // Fetch plusargs or use safe (fail-fast) defaults
    if (!$value$plusargs("INST=%s", inst)) inst = "";
    if (!$value$plusargs("DATA=%s", data)) data = "";

    // Preload data (in the L1SPM) and instructions (dummy I$)
    fixture.vip.inst_preload(inst);
    fixture.vip.data_preload(data);
  `elsif SIN_INSTR_DATA_MEM
    // Fetch plusargs or use safe (fail-fast) defaults
    if (!$value$plusargs("MEM=%s" , mem))  mem  = "";

    // Preload data and instructions in common memory
    fixture.vip.preload(mem, entry);
  `else
    $fatal("UNRECOGNIZED MEMORY STRUCTURE");
  `endif

    // Wait for reset
    fixture.vip.wait_for_reset();

    // Preload in idle mode
    fixture.vip.init();
    fixture.vip.elf_run();
    fixture.vip.wait_for_eoc(exit_code);

    $display("SIMULATION FINISHED WITH EXIT CODE: %0d\n", exit_code);

    $finish;
  end

endmodule: redmule_tile_tb