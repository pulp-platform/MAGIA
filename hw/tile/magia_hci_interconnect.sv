/*
 * Copyright (C) 2023-2026 ETH Zurich, University of Bologna and Fondazione Chips-IT
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
 *          Luca Balboni  <luca.balboni@chips.it>
 *
 * MAGIA HCI interconnect: accelerators on an arbiter tree, cores on the logarithmic interconnect
 */

`include "hci_helpers.svh"

module magia_hci_interconnect
  import hci_package::*;
#(
  parameter int unsigned         NumHwpe              = magia_tile_pkg::N_HWPE,
  parameter int unsigned         NumDma               = magia_tile_pkg::N_DMA,
  parameter int unsigned         NumCore              = magia_tile_pkg::N_CORE,
  parameter int unsigned         NumMem               = magia_pkg::N_MEM_BANKS,
  parameter int unsigned         RouterFifoDepth      = magia_tile_pkg::EXPFIFO,
  parameter bit                  WaiveRq3Assert       = 1'b0,
  parameter bit                  WaiveRq4Assert       = 1'b0,
  parameter hci_size_parameter_t `HCI_SIZE_PARAM(hwpe) = '0,
  parameter hci_size_parameter_t `HCI_SIZE_PARAM(dma)  = '0,
  parameter hci_size_parameter_t `HCI_SIZE_PARAM(core) = '0,
  parameter hci_size_parameter_t `HCI_SIZE_PARAM(mem)  = '0,
  // Interface arrays cannot be zero-sized
  localparam int unsigned        NumHwpePort          = (NumHwpe > 0) ? NumHwpe : 1
) (
  input logic                                clk_i,
  input logic                                rst_ni,

  input logic                                clear_i,
  input hci_package::hci_interconnect_ctrl_t ctrl_i,

  hci_core_intf.target                       hwpe[NumHwpePort],
  hci_core_intf.target                       dma [NumDma],
  hci_core_intf.target                       core[NumCore],
  hci_core_intf.initiator                    mem [NumMem]
);

/*******************************************************/
/**   Parameter and Interface Definitions Beginning   **/
/*******************************************************/

  localparam int unsigned NumWide = NumHwpe + NumDma;

  // Bank address width of the narrow LIC, in words
  localparam int unsigned LicBankAddrW = `HCI_SIZE_GET_AW(mem) -
                                         $clog2(`HCI_SIZE_GET_DW(mem) / `HCI_SIZE_GET_BW(mem));

  localparam hci_size_parameter_t `HCI_SIZE_PARAM(wide_mem) = `HCI_SIZE_PARAM(mem);

  // hci_log_interconnect keeps the core address width on its bank side
  localparam hci_size_parameter_t `HCI_SIZE_PARAM(lic_mem) = '{
    DW:  `HCI_SIZE_GET_DW(mem),
    AW:  `HCI_SIZE_GET_AW(core),
    BW:  `HCI_SIZE_GET_BW(mem),
    UW:  `HCI_SIZE_GET_UW(mem),
    IW:  `HCI_SIZE_GET_IW(mem),
    EW:  `HCI_SIZE_GET_EW(mem),
    EHW: `HCI_SIZE_GET_EHW(mem)
  };

  // The control core always sits on the narrow branch
  if (NumCore == 0) begin : gen_no_core_error
    $fatal(1, "magia_hci_interconnect: NumCore must be >= 1");
  end

  // LIC bank side: re-arbitrated while not granted, internal signals, not protocol ports
  hci_core_intf #(
    .DW  ( `HCI_SIZE_GET_DW(lic_mem)  ),
    .AW  ( `HCI_SIZE_GET_AW(lic_mem)  ),
    .BW  ( `HCI_SIZE_GET_BW(lic_mem)  ),
    .UW  ( `HCI_SIZE_GET_UW(lic_mem)  ),
    .IW  ( `HCI_SIZE_GET_IW(lic_mem)  ),
    .EW  ( `HCI_SIZE_GET_EW(lic_mem)  ),
    .EHW ( `HCI_SIZE_GET_EHW(lic_mem) )
`ifndef SYNTHESIS
    ,
    .WAIVE_RQ3_ASSERT ( WaiveRq3Assert ),
    .WAIVE_RQ4_ASSERT ( WaiveRq4Assert )
`endif
  ) lic_mem [0:NumMem-1] (
    .clk ( clk_i )
  );

  hci_core_intf #(
    .DW  ( `HCI_SIZE_GET_DW(mem)  ),
    .AW  ( `HCI_SIZE_GET_AW(mem)  ),
    .BW  ( `HCI_SIZE_GET_BW(mem)  ),
    .UW  ( `HCI_SIZE_GET_UW(mem)  ),
    .IW  ( `HCI_SIZE_GET_IW(mem)  ),
    .EW  ( `HCI_SIZE_GET_EW(mem)  ),
    .EHW ( `HCI_SIZE_GET_EHW(mem) )
`ifndef SYNTHESIS
    ,
    .WAIVE_RQ3_ASSERT ( WaiveRq3Assert ),
    .WAIVE_RQ4_ASSERT ( WaiveRq4Assert )
`endif
  ) core_mem_muxed [0:NumMem-1] (
    .clk ( clk_i )
  );

/*******************************************************/
/**      Parameter and Interface Definitions End      **/
/*******************************************************/
/**              Narrow Branch Beginning              **/
/*******************************************************/

  // Per-bank round-robin among the cores: hci_log_interconnect ignores ctrl_i
  hci_log_interconnect #(
    .N_CH0  ( NumCore                 ),
    .N_CH1  ( 0                       ),
    .N_MEM  ( NumMem                  ),
    .AWC    ( `HCI_SIZE_GET_AW(core)  ),
    .AWM    ( LicBankAddrW            ),
    .DW     ( `HCI_SIZE_GET_DW(core)  ),
    .BW     ( `HCI_SIZE_GET_BW(core)  ),
    .TS_BIT ( magia_tile_pkg::TS_BIT  ),
    .IW     ( NumCore                 ),
    .UW     ( `HCI_SIZE_GET_UW(core)  ),
    .EW     ( `HCI_SIZE_GET_EW(core)  )
  ) i_core_log_interconnect (
    .clk_i  ( clk_i   ),
    .rst_ni ( rst_ni  ),
    .ctrl_i ( '0      ),
    .cores  ( core    ),
    .mems   ( lic_mem )
  );

  // Left undriven by hci_log_interconnect: no error path, one outstanding request, no ECC
  for (genvar i = 0; i < NumCore; i++) begin : gen_core_rsp_tieoff
    assign core[i].r_id     = '0;
    assign core[i].r_opc    = 1'b0;
    assign core[i].egnt     = '1;
    assign core[i].r_evalid = '0;
  end

  // Truncates the LIC bank address to the mem address width
  for (genvar b = 0; b < NumMem; b++) begin : gen_lic_mem_bridge
    hci_core_assign i_lic_mem_assign (
      .tcdm_target    ( lic_mem[b]        ),
      .tcdm_initiator ( core_mem_muxed[b] )
    );
  end

/*******************************************************/
/**                 Narrow Branch End                 **/
/*******************************************************/
/**               Wide Branch Beginning               **/
/*******************************************************/

  // Without RedMulE no router drives the placeholder hwpe[0] port
  if (NumHwpe == 0) begin : gen_hwpe_port_unused
    assign hwpe[0].gnt      = 1'b0;
    assign hwpe[0].r_valid  = 1'b0;
    assign hwpe[0].r_data   = '0;
    assign hwpe[0].r_user   = '0;
    assign hwpe[0].r_id     = '0;
    assign hwpe[0].r_opc    = 1'b0;
    assign hwpe[0].egnt     = '1;
    assign hwpe[0].r_evalid = '0;
  end

  if (NumWide > 0) begin : gen_wide_branch
    hci_package::hci_interconnect_ctrl_t ctrl;  // Shared by every arbiter of the wide branch

    // An unprogrammed ctrl_i (denominator 0) falls back to the default ratio
    always_comb begin
      ctrl = ctrl_i;
      if (ctrl_i.priority_cnt_denominator == 8'd0) begin
        ctrl.priority_cnt_numerator   = 8'(magia_tile_pkg::HCI_QOS_NUM);
        ctrl.priority_cnt_denominator = 8'(magia_tile_pkg::HCI_QOS_DEN);
      end
    end

    `HCI_INTF_ARRAY(wide_mem, clk_i, 0:NumWide*NumMem-1);

    // Output of the wide arbiter tree, which re-arbitrates while not granted
    hci_core_intf #(
      .DW  ( `HCI_SIZE_GET_DW(mem)  ),
      .AW  ( `HCI_SIZE_GET_AW(mem)  ),
      .BW  ( `HCI_SIZE_GET_BW(mem)  ),
      .UW  ( `HCI_SIZE_GET_UW(mem)  ),
      .IW  ( `HCI_SIZE_GET_IW(mem)  ),
      .EW  ( `HCI_SIZE_GET_EW(mem)  ),
      .EHW ( `HCI_SIZE_GET_EHW(mem) )
`ifndef SYNTHESIS
      ,
      .WAIVE_RQ3_ASSERT ( WaiveRq3Assert ),
      .WAIVE_RQ4_ASSERT ( WaiveRq4Assert )
`endif
    ) wide_mem_muxed [0:NumMem-1] (
      .clk ( clk_i )
    );

    // DMA channels take the first NumDma groups of wide_mem, RedMulE the following ones
    for (genvar j = 0; j < NumDma; j++) begin : gen_dma_req2mem
      hci_router #(
        .FIFO_DEPTH            ( RouterFifoDepth           ),
        .NB_OUT_CHAN           ( NumMem                    ),
        .`HCI_SIZE_PARAM(in)   ( `HCI_SIZE_PARAM(dma)      ),
        .`HCI_SIZE_PARAM(out)  ( `HCI_SIZE_PARAM(wide_mem) )
      ) i_dma_router (
        .clk_i   ( clk_i                             ),
        .rst_ni  ( rst_ni                            ),
        .clear_i ( clear_i                           ),
        .in      ( dma[j]                            ),
        .out     ( wide_mem[j*NumMem:(j+1)*NumMem-1] )
      );
    end

    // Last leaf, so RedMulE alone faces the DMA pair at the tree root
    for (genvar i = 0; i < NumHwpe; i++) begin : gen_hwpe_req2mem
      hci_router #(
        .FIFO_DEPTH            ( RouterFifoDepth           ),
        .NB_OUT_CHAN           ( NumMem                    ),
        .`HCI_SIZE_PARAM(in)   ( `HCI_SIZE_PARAM(hwpe)     ),
        .`HCI_SIZE_PARAM(out)  ( `HCI_SIZE_PARAM(wide_mem) )
      ) i_hwpe_router (
        .clk_i   ( clk_i                                             ),
        .rst_ni  ( rst_ni                                            ),
        .clear_i ( clear_i                                           ),
        .in      ( hwpe[i]                                           ),
        .out     ( wide_mem[(NumDma+i)*NumMem:(NumDma+i+1)*NumMem-1] )
      );
    end

    hci_arbiter_tree #(
      .NB_REQUESTS          ( NumWide                   ),
      .NB_CHAN              ( NumMem                    ),
      .`HCI_SIZE_PARAM(out) ( `HCI_SIZE_PARAM(wide_mem) ),
      .WAIVE_RQ3_ASSERT     ( WaiveRq3Assert            ),
      .WAIVE_RQ4_ASSERT     ( WaiveRq4Assert            )
    ) i_wide_arbiter_tree (
      .clk_i   ( clk_i          ),
      .rst_ni  ( rst_ni         ),
      .clear_i ( clear_i        ),
      .ctrl_i  ( ctrl           ),
      .in      ( wide_mem       ),
      .out     ( wide_mem_muxed )
    );

    // Accelerators on in_high, the higher-priority side unless invert_prio is set
    hci_arbiter #(
      .NB_CHAN ( NumMem )
    ) i_wide_vs_narrow_arbiter (
      .clk_i   ( clk_i          ),
      .rst_ni  ( rst_ni         ),
      .clear_i ( clear_i        ),
      .ctrl_i  ( ctrl           ),
      .in_high ( wide_mem_muxed ),
      .in_low  ( core_mem_muxed ),
      .out     ( mem            )
    );
  end else begin : gen_no_wide_branch
    for (genvar b = 0; b < NumMem; b++) begin : gen_core_to_mem
      hci_core_assign i_core_mem_assign (
        .tcdm_target    ( core_mem_muxed[b] ),
        .tcdm_initiator ( mem[b]            )
      );
    end
  end

/*******************************************************/
/**                  Wide Branch End                  **/
/*******************************************************/

endmodule : magia_hci_interconnect
