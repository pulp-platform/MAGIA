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
 *          Luca Balboni  <luca.balboni@chips.it>
 *
 * MAGIA Tile Local Interconnect - HCI two-branch architecture
 *
 *   - WIDE branch : every HWPE (RedMulE) and every DMA channel is "shallow"
 *                   routed towards Dw/32 adjacent banks by its own hci_router
 *                   (each with its own data width - RedMulE and DMA differ),
 *                   then a single hci_arbiter_tree arbitrates all wide
 *                   initiators against each other.
 *   - NARROW branch: every core-side 32-bit port goes through a full PULP
 *                   logarithmic interconnect (hci_log_interconnect -> XBAR_TCDM
 *                   from cluster_interconnect). The LIC'sarbitration is always 
 *                   fair RR and does NOT take a ctrl input.
 */

`include "hci_helpers.svh"

module magia_hci_interconnect
  import hci_package::*;
  import magia_tile_pkg::*;
  import magia_pkg::*;
#(
  parameter int unsigned N_HWPE                           = magia_tile_pkg::N_HWPE,
  parameter int unsigned N_DMA                            = magia_tile_pkg::N_DMA,
  parameter int unsigned N_CORE                           = magia_tile_pkg::N_CORE,
  parameter int unsigned N_MEM                            = magia_pkg::N_MEM_BANKS,
  parameter int unsigned EXPFIFO                          = magia_tile_pkg::EXPFIFO,
  // Clamped to >=1: SV interface arrays can't be zero-sized
  localparam int unsigned N_HWPE_PORT                     = (N_HWPE > 0) ? N_HWPE : 1,
  parameter int unsigned FILTER_WRITE_R_VALID[0:N_HWPE_PORT-1] = '{default: 0},
  parameter int unsigned MEM_DATA_W                       = 0,
  parameter int unsigned MEM_ADDR_W                       = 0,
  parameter int unsigned MEM_BYTE_W                       = 0,
  parameter int unsigned MEM_USER_W                       = 0,
  parameter int unsigned MEM_ID_W                         = 0,
  parameter bit          WAIVE_RQ3_ASSERT                 = 1'b0,
  parameter bit          WAIVE_RQ4_ASSERT                 = 1'b0,
  // Bit position used by the narrow LIC to alias the test-and-set region.
  parameter int unsigned LIC_TS_BIT                       = magia_tile_pkg::TS_BIT,
  // Default QoS window for the final WIDE-vs-NARROW arbiter
  parameter int unsigned FINAL_QOS_NUM                    = magia_tile_pkg::HCI_QOS_NUM,
  parameter int unsigned FINAL_QOS_DEN                    = magia_tile_pkg::HCI_QOS_DEN,
  parameter hci_size_parameter_t `HCI_SIZE_PARAM(hwpe)    = '0,
  parameter hci_size_parameter_t `HCI_SIZE_PARAM(dma)     = '0,
  parameter hci_size_parameter_t `HCI_SIZE_PARAM(core)    = '0,
  parameter hci_size_parameter_t `HCI_SIZE_PARAM(mem)     = '0
) (
  input logic                                clk_i,
  input logic                                rst_ni,

  input logic                                clear_i,
  input hci_package::hci_interconnect_ctrl_t ctrl_i,

  hci_core_intf.target                       hwpe[N_HWPE_PORT],
  hci_core_intf.target                       dma [N_DMA],
  hci_core_intf.target                       core[N_CORE],
  hci_core_intf.initiator                    mem [N_MEM]
);

/*******************************************************/
/**   Parameter and Interface Definitions Beginning   **/
/*******************************************************/

  localparam int unsigned N_WIDE = N_HWPE + N_DMA;

  // N_HWPE==0: tie off the unused dummy hwpe[0] (no router drives it).
  if (N_HWPE == 0) begin : gen_hwpe_port_unused
    assign hwpe[0].gnt      = 1'b0;
    assign hwpe[0].r_valid  = 1'b0;
    assign hwpe[0].r_data   = '0;
    assign hwpe[0].r_user   = '0;
    assign hwpe[0].r_id     = '0;
    assign hwpe[0].r_opc    = 1'b0;
    assign hwpe[0].egnt     = '1;
    assign hwpe[0].r_evalid = '0;
  end : gen_hwpe_port_unused

  // Common mem-side geometry, shared by every internal (muxed) interface array.
  localparam hci_size_parameter_t MEM_SIZE = '{
    DW:  MEM_DATA_W,
    AW:  MEM_ADDR_W,
    BW:  MEM_BYTE_W,
    UW:  MEM_USER_W,
    IW:  MEM_ID_W,
    EW:  hci_package::DEFAULT_EW,
    EHW: hci_package::DEFAULT_EHW
  };

  localparam hci_size_parameter_t `HCI_SIZE_PARAM(wide_mem)        = MEM_SIZE;
  localparam hci_size_parameter_t `HCI_SIZE_PARAM(wide_mem_muxed)  = MEM_SIZE;
  localparam hci_size_parameter_t `HCI_SIZE_PARAM(core_mem_muxed)  = MEM_SIZE;

  // Core-side address width, driven straight into the narrow LIC.
  localparam int unsigned LIC_AWC = `HCI_SIZE_GET_AW(core);
  // Per-bank word-address width for the narrow LIC (works in words, not bytes).
  localparam int unsigned LIC_AWM = MEM_ADDR_W - $clog2(MEM_DATA_W/MEM_BYTE_W);

  // lic_mem must be LIC_AWC wide (hci_log_interconnect's mem-side add width); bridged down to the per-bank geometry below.
  localparam hci_size_parameter_t `HCI_SIZE_PARAM(lic_mem) = '{
    DW:  MEM_DATA_W,
    AW:  LIC_AWC,
    BW:  MEM_BYTE_W,
    UW:  MEM_USER_W,
    IW:  MEM_ID_W,
    EW:  hci_package::DEFAULT_EW,
    EHW: hci_package::DEFAULT_EHW
  };

  // Core-side (narrow) branch always has at least the ctrl core attached.
`ifndef SYNTHESIS
  initial assert (N_CORE > 0)
    else $fatal(1, "magia_hci_interconnect: N_CORE must be >= 1");
`endif

  `HCI_INTF_ARRAY(lic_mem,        clk_i, 0:N_MEM-1);
  `HCI_INTF_ARRAY(core_mem_muxed, clk_i, 0:N_MEM-1);

  // Forces the wide-branch arbiter_tree to a fair 1:2 round-robin, independent of runtime ctrl_i.
  hci_package::hci_interconnect_ctrl_t ctrl_fair;
  always_comb begin
    ctrl_fair                           = ctrl_i;
    ctrl_fair.priority_cnt_numerator    = 8'd1;
    ctrl_fair.priority_cnt_denominator  = 8'd2;
  end

  // Final wide-vs-narrow control: uses ctrl_i if programmed (denominator!=0), else falls back to the fair FINAL_QOS_NUM/DEN default.
  hci_package::hci_interconnect_ctrl_t ctrl_final;
  always_comb begin
    ctrl_final = ctrl_i;
    if (ctrl_i.priority_cnt_denominator == 8'd0) begin
      ctrl_final.priority_cnt_numerator   = FINAL_QOS_NUM[7:0];
      ctrl_final.priority_cnt_denominator = FINAL_QOS_DEN[7:0];
    end
  end

/*******************************************************/
/**      Parameter and Interface Definitions End      **/
/*******************************************************/
/**   Narrow (core) branch: full logarithmic interco   **/
/*******************************************************/

  //LIC: full crossbar + per-bank round-robin; all core ports are class CH0, no narrow DMA/EXT (N_CH1=0), ctrl_i unused.
  hci_log_interconnect #(
    .N_CH0  ( N_CORE                 ),
    .N_CH1  ( 0                      ),
    .N_MEM  ( N_MEM                  ),
    .AWC    ( LIC_AWC                ),
    .AWM    ( LIC_AWM                ),
    .DW     ( `HCI_SIZE_GET_DW(core) ),
    .BW     ( `HCI_SIZE_GET_BW(core) ),
    .TS_BIT ( LIC_TS_BIT             ),
    .IW     ( N_CORE                 ),
    .UW     ( `HCI_SIZE_GET_UW(core) ),
    .EW     ( `HCI_SIZE_GET_EW(core) )
  ) i_core_log_interconnect (
    .clk_i  ( clk_i   ),
    .rst_ni ( rst_ni  ),
    .ctrl_i ( '0      ),
    .cores  ( core    ),
    .mems   ( lic_mem )
  );

  // hci_log_interconnect leaves r_id/r_opc/egnt/r_evalid floating; tie them off (no error path, single-outstanding, no ECC).
  for (genvar i = 0; i < N_CORE; i++) begin : gen_core_rsp_tieoff
    assign core[i].r_id     = '0;
    assign core[i].r_opc    = 1'b0;
    assign core[i].egnt     = '1;
    assign core[i].r_evalid = '0;
  end

  // Bridge the LIC-width mem side down to the tile's per-bank geometry.
  for (genvar b = 0; b < N_MEM; b++) begin : gen_lic_mem_bridge
    hci_core_assign i_lic_mem_assign (
      .tcdm_target    ( lic_mem[b]        ),
      .tcdm_initiator ( core_mem_muxed[b] )
    );
  end

/*******************************************************/
/**       Wide (HWPE + DMA) branch and final MUX      **/
/*******************************************************/

  if (N_WIDE > 0) begin : gen_wide_branch

    `HCI_INTF_ARRAY(wide_mem,       clk_i, 0:N_WIDE*N_MEM-1);
    `HCI_INTF_ARRAY(wide_mem_muxed, clk_i, 0:N_MEM-1);

    // DMA channels: entries [0 .. N_DMA-1] of the wide array.
    for (genvar j = 0; j < N_DMA; j++) begin : gen_dma_req2mem
      hci_router #(
        .FIFO_DEPTH           ( EXPFIFO                   ),
        .NB_OUT_CHAN          ( N_MEM                     ),
        .FILTER_WRITE_R_VALID ( 0                         ),
        .`HCI_SIZE_PARAM(in)  ( `HCI_SIZE_PARAM(dma)      ),
        .`HCI_SIZE_PARAM(out) ( `HCI_SIZE_PARAM(wide_mem) )
      ) i_dma_router (
        .clk_i   ( clk_i                           ),
        .rst_ni  ( rst_ni                          ),
        .clear_i ( clear_i                         ),
        .in      ( dma[j]                          ),
        .out     ( wide_mem[j*N_MEM:(j+1)*N_MEM-1] )
      );
    end

    // After DMA on purpose: hci_arbiter_tree bypasses the last leaf when N_WIDE is odd, giving RedMulE ~50% of the wide block vs the DMA channels' ~12.5% each.
    for (genvar i = 0; i < N_HWPE; i++) begin : gen_hwpe_req2mem
      hci_router #(
        .FIFO_DEPTH           ( EXPFIFO                   ),
        .NB_OUT_CHAN          ( N_MEM                     ),
        .FILTER_WRITE_R_VALID ( FILTER_WRITE_R_VALID[i]   ),
        .`HCI_SIZE_PARAM(in)  ( `HCI_SIZE_PARAM(hwpe)     ),
        .`HCI_SIZE_PARAM(out) ( `HCI_SIZE_PARAM(wide_mem) )
      ) i_hwpe_router (
        .clk_i   ( clk_i                                           ),
        .rst_ni  ( rst_ni                                          ),
        .clear_i ( clear_i                                         ),
        .in      ( hwpe[i]                                         ),
        .out     ( wide_mem[(N_DMA+i)*N_MEM:(N_DMA+i+1)*N_MEM-1]   )
      );
    end

    // Single arbiter tree over all wide initiators, forced fair 1:2; collapses to wiring when N_WIDE==1.
    hci_arbiter_tree #(
      .NB_REQUESTS         ( N_WIDE                          ),
      .NB_CHAN             ( N_MEM                           ),
      .WAIVE_RQ3_ASSERT    ( WAIVE_RQ3_ASSERT                ),
      .WAIVE_RQ4_ASSERT    ( WAIVE_RQ4_ASSERT                ),
      .`HCI_SIZE_PARAM(out)( `HCI_SIZE_PARAM(wide_mem_muxed) )
    ) i_wide_arbiter_tree (
      .clk_i   ( clk_i          ),
      .rst_ni  ( rst_ni         ),
      .clear_i ( clear_i        ),
      .ctrl_i  ( ctrl_fair      ),
      .in      ( wide_mem       ),
      .out     ( wide_mem_muxed )
    );

    // Final WIDE-vs-NARROW boundary (in_high=wide, in_low=narrow), driven by ctrl_final.
    hci_arbiter #(
      .NB_CHAN ( N_MEM )
    ) i_wide_vs_narrow_arbiter (
      .clk_i   ( clk_i          ),
      .rst_ni  ( rst_ni         ),
      .clear_i ( clear_i        ),
      .ctrl_i  ( ctrl_final     ),
      .in_high ( wide_mem_muxed ),
      .in_low  ( core_mem_muxed ),
      .out     ( mem            )
    );

  end : gen_wide_branch
  else begin : gen_no_wide_branch

    // No wide initiators: narrow branch drives the banks directly.
    for (genvar b = 0; b < N_MEM; b++) begin : gen_core_to_mem
      hci_core_assign i_core_mem_assign (
        .tcdm_target    ( core_mem_muxed[b] ),
        .tcdm_initiator ( mem[b]            )
      );
    end

  end : gen_no_wide_branch

endmodule: magia_hci_interconnect
