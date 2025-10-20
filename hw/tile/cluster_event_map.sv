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
 * Authors: Luca Balboni <luca.balboni10@studio.unibo.it>
 *          

 * Simple cluster event mapping module for MAGIA project
 * This module maps various event types to the final cluster event outputs
*/

module cluster_event_map #(
  parameter int unsigned NB_CORES = 1
)(
  // Input events from various sources
  input  logic [NB_CORES-1:0] [7:0] sw_events_i,         // Software events
  input  logic [NB_CORES-1:0]       barrier_events_i,    // Barrier events (reduced)
  input  logic [NB_CORES-1:0]       mutex_events_i,      // Mutex events (reduced)
  input  logic [NB_CORES-1:0]       dispatch_events_i,   // Dispatch events
  input  logic                      periph_fifo_event_i, // Peripheral FIFO event

  // Hardware events from accelerators, DMA, timers, etc.
  input  logic [NB_CORES-1:0] [3:0] acc_events_i,        // Accelerator events (4 bits per core)
  input  logic [NB_CORES-1:0] [1:0] dma_events_i,        // DMA events (2 bits per core)
  input  logic [NB_CORES-1:0] [1:0] timer_events_i,      // Timer events (2 bits per core)
  input  logic [NB_CORES-1:0][31:0] cluster_events_i,    // Custom cluster events (32 bits per core)

  // Output: mapped events for each core
  output logic [NB_CORES-1:0][31:0] events_mapped_o
);

  // Simple event mapping for each core
  for (genvar i = 0; i < NB_CORES; i++) begin : gen_event_mapping
    assign events_mapped_o[i] = {
      cluster_events_i[i][31:16],           // [31:16] Custom cluster events (upper 16 bits)
      4'b0,                                 // [15:12] Reserved
      acc_events_i[i],                      // [11:8]  Accelerator events
      2'b0,                                 // [7:6]   Reserved
      timer_events_i[i],                    // [5:4]   Timer events
      dma_events_i[i],                      // [3:2]   DMA events
      dispatch_events_i[i],                 // [1]     Dispatch event
      barrier_events_i[i] | mutex_events_i[i] | periph_fifo_event_i  // [0] Combined sync/periph events
    };
  end

endmodule : cluster_event_map