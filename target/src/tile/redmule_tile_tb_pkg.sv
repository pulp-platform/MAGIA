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
 * RedMulE Tile Testbench Package
 */

package redmule_tile_tb_pkg;

  parameter int unsigned N_MEM_BANKS  = redmule_mesh_pkg::N_MEM_BANKS;  // Number of TCDM banks (1 extra bank for missaligned accesses)
  parameter int unsigned N_WORDS_BANK = redmule_mesh_pkg::N_WORDS_BANK; // Number of words per TCDM bank

endpackage: redmule_tile_tb_pkg