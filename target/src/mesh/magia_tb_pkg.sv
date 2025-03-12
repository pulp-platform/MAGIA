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
 * MAGIA Testbench Package
 */

package magia_tb_pkg;

  `include "axi/typedef.svh"

  parameter int unsigned N_MEM_BANKS  = magia_pkg::N_MEM_BANKS;  // Number of TCDM banks (1 extra bank for missaligned accesses)
  parameter int unsigned N_WORDS_BANK = magia_pkg::N_WORDS_BANK; // Number of words per TCDM bank
  parameter int unsigned N_TILES_X    = magia_pkg::N_TILES_X;    // Number of Tile columns
  parameter int unsigned N_TILES_Y    = magia_pkg::N_TILES_Y;    // Number of Tile rowns
  parameter int unsigned N_TILES      = magia_pkg::N_TILES;      // Number of Tiles in the Mesh

  parameter int unsigned L2_ID_W      = magia_pkg::L2_ID_W;
  parameter int unsigned L2_U_W       = magia_pkg::L2_U_W;

  parameter int unsigned FSYNC_LVL    = magia_pkg::FSYNC_LVL;
  parameter int unsigned TILE_FSYNC_W = magia_pkg::TILE_FSYNC_W; // Width of the FractalSync level of the Tile - FS network link

endpackage: magia_tb_pkg