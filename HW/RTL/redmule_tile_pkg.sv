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
 * RedMulE Tile Package
 */

 package redmule_tile_pkg;

  // Parameters used by the HCI
  parameter int unsigned N_HWPE_TILE  = 1;                                                   // Number of HWPEs attached to the port
  parameter int unsigned N_CORE_TILE  = 1;                                                   // Number of Core ports
  parameter int unsigned N_DMA_TILE   = 0;                                                   // Number of DMA ports /*TODO: add DMA and update interconnect parameter*/
  parameter int unsigned N_EXT_TILE   = 0;                                                   // Number of External ports /*TODO: can this be 0? Will it not cause problems? Is the HCI Interconnect robust?*/
  parameter int unsigned AWC_TILE     = 32;                                                  // Address Width Core   (slave ports)
  parameter int unsigned AWM_TILE     = 32;                                                  // Address width memory (master ports)
  parameter int unsigned DW_LIC_TILE  = 32;                                                  // Data Width for Log Interconnect
  parameter int unsigned BW_LIC_TILE  = 8;                                                   // Byte Width for Log Interconnect
  parameter int unsigned UW_LIC_TILE  = 0;                                                   // User Width for Log Interconnect
  parameter int unsigned TS_BIT_TILE  = 21;                                                  // TEST_SET_BIT (for Log Interconnect)
  parameter int unsigned IW_TILE      = N_HWPE_TILE + N_CORE_TILE + N_DMA_TILE + N_EXT_TILE; // ID Width
  parameter int unsigned EXPFIFO_TILE = 0;                                                   // FIFO Depth for HWPE Interconnect
  parameter int unsigned DWH_TILE     = 32;                                                  // Data Width for HWPE Interconnect
  parameter int unsigned AWH_TILE     = 32;                                                  // Address Width for HWPE Interconnect
  parameter int unsigned BWH_TILE     = 8;                                                   // Byte Width for HWPE Interconnect
  parameter int unsigned WWH_TILE     = 32;                                                  // Word Width for HWPE Interconnect
  parameter int unsigned OWH_TILE     = AWH_TILE;                                            // Offset Width for HWPE Interconnect
  parameter int unsigned UWH_TILE     = 0;                                                   // User Width for HWPE Interconnect
  parameter int unsigned SEL_LIC_TILE = 0;                                                   // Log interconnect type selector

 endpackage: redmule_tile_pkg