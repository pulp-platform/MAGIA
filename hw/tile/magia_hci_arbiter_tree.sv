/*
 * Copyright (C) 2026 ETH Zurich, University of Bologna and Fondazione Chips-IT
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
 * Author: Luca Balboni, Fondazione Chips-IT
 *
 * Binary tree of hci_arbiter with the topology of hci_arbiter_tree and one control per node
 */

`include "hci_helpers.svh"

module magia_hci_arbiter_tree
  import hci_package::*;
#(
  parameter int unsigned         NumReq              = 5,  // The 4 DMA channels, then RedMulE if present
  parameter int unsigned         NumChan             = 16,
  parameter bit                  WaiveRq3Assert      = 1'b0,
  parameter bit                  WaiveRq4Assert      = 1'b0,
  parameter hci_size_parameter_t `HCI_SIZE_PARAM(out) = '0,
  localparam int unsigned        NumNodePort         = NumReq - 1
) (
  input logic                   clk_i,
  input logic                   rst_ni,
  input logic                   clear_i,

  // N0: request 0 vs 1, N1: 2 vs 3, N2: N0 vs N1, N3: N2 vs 4; the first named is the high side
  input hci_interconnect_ctrl_t ctrl_i [NumNodePort],

  hci_core_intf.target          in  [0:NumReq*NumChan-1],
  hci_core_intf.initiator       out [0:NumChan-1]
);

  // Must match the node names of HCI_ARB_TREE_* in magia_tile_utils.h
  if (NumReq != 4 && NumReq != 5) begin : gen_num_req_error
    $fatal(1, "magia_hci_arbiter_tree: NumReq must be 4 (DMA channels) or 5 (and RedMulE)");
  end

  // Outputs of N0, N1 and, with RedMulE, N2; re-arbitrated while not granted
  hci_core_intf #(
    .DW  ( `HCI_SIZE_GET_DW(out)  ),
    .AW  ( `HCI_SIZE_GET_AW(out)  ),
    .BW  ( `HCI_SIZE_GET_BW(out)  ),
    .UW  ( `HCI_SIZE_GET_UW(out)  ),
    .IW  ( `HCI_SIZE_GET_IW(out)  ),
    .EW  ( `HCI_SIZE_GET_EW(out)  ),
    .EHW ( `HCI_SIZE_GET_EHW(out) ),
    .FD  ( `HCI_SIZE_GET_FD(out)  )
`ifndef SYNTHESIS
    ,
    .WAIVE_RQ3_ASSERT ( WaiveRq3Assert ),
    .WAIVE_RQ4_ASSERT ( WaiveRq4Assert )
`endif
  ) node [0:(NumReq-2)*NumChan-1] (
    .clk ( clk_i )
  );

  // N0 and N1: the DMA channels in pairs
  for (genvar k = 0; k < 2; k++) begin : gen_dma_pair
    hci_arbiter #(
      .NB_CHAN ( NumChan )
    ) i_arbiter (
      .clk_i   ( clk_i                                  ),
      .rst_ni  ( rst_ni                                 ),
      .clear_i ( clear_i                                ),
      .ctrl_i  ( ctrl_i[k]                              ),
      .in_high ( in[2*k*NumChan     : (2*k+1)*NumChan-1] ),
      .in_low  ( in[(2*k+1)*NumChan : (2*k+2)*NumChan-1] ),
      .out     ( node[k*NumChan     : (k+1)*NumChan-1]   )
    );
  end

  if (NumReq == 5) begin : gen_redmule
    hci_arbiter #(
      .NB_CHAN ( NumChan )
    ) i_n2 (
      .clk_i   ( clk_i                         ),
      .rst_ni  ( rst_ni                        ),
      .clear_i ( clear_i                       ),
      .ctrl_i  ( ctrl_i[2]                     ),
      .in_high ( node[0         : NumChan-1]   ),
      .in_low  ( node[NumChan   : 2*NumChan-1] ),
      .out     ( node[2*NumChan : 3*NumChan-1] )
    );

    // RedMulE alone against all the DMA channels, as the odd request of hci_arbiter_tree
    hci_arbiter #(
      .NB_CHAN ( NumChan )
    ) i_n3 (
      .clk_i   ( clk_i                         ),
      .rst_ni  ( rst_ni                        ),
      .clear_i ( clear_i                       ),
      .ctrl_i  ( ctrl_i[3]                     ),
      .in_high ( node[2*NumChan : 3*NumChan-1] ),
      .in_low  ( in[4*NumChan   : 5*NumChan-1] ),
      .out     ( out                           )
    );
  end else begin : gen_no_redmule
    hci_arbiter #(
      .NB_CHAN ( NumChan )
    ) i_n2 (
      .clk_i   ( clk_i                       ),
      .rst_ni  ( rst_ni                      ),
      .clear_i ( clear_i                     ),
      .ctrl_i  ( ctrl_i[2]                   ),
      .in_high ( node[0       : NumChan-1]   ),
      .in_low  ( node[NumChan : 2*NumChan-1] ),
      .out     ( out                         )
    );
  end

endmodule : magia_hci_arbiter_tree
