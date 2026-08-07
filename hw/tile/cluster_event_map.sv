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
 * Cluster event mapping module for MAGIA project.
 *
 *   - gen_cluster_map (NB_CORES > 1, the cluster's own private Event Unit)
 *   - gen_ctrl_core_map (NB_CORES == 1, the control core's Event Unit)
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

  // WARNING: A cluster configured with exactly 1 core (NB_CORES == 1) 
  // would be indistinguishable from the control core and
  // silently get the wrong mapping
  for (genvar i = 0; i < NB_CORES; i++) begin : gen_event_mapping
    if (NB_CORES == 1) begin : gen_ctrl_core_map
      assign events_mapped_o[i] = {
        cluster_events_i[i][31:16],           // [31:16] Custom cluster events (pass-through) -- carries irq_i[18:16] on the control core, see magia_tile.sv
        cluster_events_i[i][15:12],           // [15:12] Custom cluster events (pass-through)
        acc_events_i[i],                      // [11:8]  Accelerator events
        sw_events_i[i][1:0],                  // [7:6]   sw_events_i[1:0] (was Reserved; only id 0 can ever be real, NB_SW_EVT=1)
        timer_events_i[i],                    // [5:4]   Timer events
        dma_events_i[i],                      // [3:2]   DMA events
        dispatch_events_i[i],                 // [1]     Dispatch event
        barrier_events_i[i] | mutex_events_i[i] | periph_fifo_event_i // [0] Combined sync/periph events
      };
    end else begin : gen_cluster_map
      assign events_mapped_o[i] = {
        cluster_events_i[i][31:19],           // [31:19] Custom cluster events (unchanged position)
        dispatch_events_i[i],                 // [18]    PULP_DISPATCH_EVENT
        mutex_events_i[i],                    // [17]    PULP_MUTEX_EVENT
        barrier_events_i[i],                  // [16]    PULP_HW_BAR_EVENT
        cluster_events_i[i][15:12],           // [15:12] Custom cluster events (unchanged position)
        sw_events_i[i],                       // [11:4]  Software events, dedicated (acc/timer_events_i are tied to '0 for this Event Unit)
        dma_events_i[i],                      // [3:2]   DMA events (also tied to '0 for this Event Unit; kept wired for symmetry)
        2'b0                                  // [1:0]   Reserved
      };
    end
  end

endmodule : cluster_event_map