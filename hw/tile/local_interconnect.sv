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
 * MAGIA Tile Local Interconnect
 */

`include "hci_helpers.svh"

module local_interconnect
  import hci_package::*;
  import magia_tile_pkg::*;
  import magia_pkg::*;
#(
  parameter int unsigned N_HWPE                           = magia_tile_pkg::N_HWPE,
  parameter int unsigned N_DMA                            = magia_tile_pkg::N_DMA,
  parameter int unsigned N_CORE                           = magia_tile_pkg::N_CORE,
  parameter int unsigned N_MEM                            = magia_pkg::N_MEM_BANKS,
  parameter int unsigned EXPFIFO                          = magia_tile_pkg::EXPFIFO,
  parameter int unsigned FILTER_WRITE_R_VALID[0:N_HWPE-1] = '{default: 0},
  parameter int unsigned MEM_DATA_W                       = 0,
  parameter int unsigned MEM_ADDR_W                       = 0,
  parameter int unsigned MEM_BYTE_W                       = 0,
  parameter int unsigned MEM_USER_W                       = 0,
  parameter int unsigned MEM_ID_W                         = 0,
  parameter hci_size_parameter_t `HCI_SIZE_PARAM(hwpe)    = '0,
  parameter hci_size_parameter_t `HCI_SIZE_PARAM(dma)     = '0,
  parameter hci_size_parameter_t `HCI_SIZE_PARAM(core)    = '0,
  parameter hci_size_parameter_t `HCI_SIZE_PARAM(mem)     = '0
) (
  input logic                                clk_i,
  input logic                                rst_ni,

  input logic                                clear_i,
  input hci_package::hci_interconnect_ctrl_t ctrl_i,
  
  hci_core_intf.target                       hwpe[N_HWPE],
  hci_core_intf.target                       dma [N_DMA],
  hci_core_intf.target                       core[N_CORE],
  hci_core_intf.initiator                    mem [N_MEM]
);

/*******************************************************/
/**   Parameter and Interface Definitions Beginning   **/
/*******************************************************/

  localparam hci_size_parameter_t `HCI_SIZE_PARAM(hwpe_mem) = '{
    DW:  MEM_DATA_W,
    AW:  MEM_ADDR_W,
    BW:  MEM_BYTE_W,
    UW:  MEM_USER_W,
    IW:  MEM_ID_W,
    EW:  hci_package::DEFAULT_EW,
    EHW: hci_package::DEFAULT_EHW
  };
  `HCI_INTF_ARRAY(hwpe_mem, clk_i, 0:N_HWPE*N_MEM-1);

  localparam hci_size_parameter_t `HCI_SIZE_PARAM(hwpe_mem_muxed) = '{
    DW:  MEM_DATA_W,
    AW:  MEM_ADDR_W,
    BW:  MEM_BYTE_W,
    UW:  MEM_USER_W,
    IW:  MEM_ID_W,
    EW:  hci_package::DEFAULT_EW,
    EHW: hci_package::DEFAULT_EHW
  };
  `HCI_INTF_ARRAY(hwpe_mem_muxed, clk_i, 0:N_MEM-1);

  localparam hci_size_parameter_t `HCI_SIZE_PARAM(dma_mem) = '{
    DW:  MEM_DATA_W,
    AW:  MEM_ADDR_W,
    BW:  MEM_BYTE_W,
    UW:  MEM_USER_W,
    IW:  MEM_ID_W,
    EW:  hci_package::DEFAULT_EW,
    EHW: hci_package::DEFAULT_EHW
  };
  `HCI_INTF_ARRAY(dma_mem, clk_i, 0:N_DMA*N_MEM-1);

  localparam hci_size_parameter_t `HCI_SIZE_PARAM(dma_mem_muxed) = '{
    DW:  MEM_DATA_W,
    AW:  MEM_ADDR_W,
    BW:  MEM_BYTE_W,
    UW:  MEM_USER_W,
    IW:  MEM_ID_W,
    EW:  hci_package::DEFAULT_EW,
    EHW: hci_package::DEFAULT_EHW
  };
  `HCI_INTF_ARRAY(dma_mem_muxed, clk_i, 0:N_MEM-1);

  localparam hci_size_parameter_t `HCI_SIZE_PARAM(hwpe_dma_mem_muxed) = '{
    DW:  MEM_DATA_W,
    AW:  MEM_ADDR_W,
    BW:  MEM_BYTE_W,
    UW:  MEM_USER_W,
    IW:  MEM_ID_W,
    EW:  hci_package::DEFAULT_EW,
    EHW: hci_package::DEFAULT_EHW
  };
  `HCI_INTF_ARRAY(hwpe_dma_mem_muxed, clk_i, 0:N_MEM-1);

  localparam hci_size_parameter_t `HCI_SIZE_PARAM(core_mem) = '{
    DW:  MEM_DATA_W,
    AW:  MEM_ADDR_W,
    BW:  MEM_BYTE_W,
    UW:  MEM_USER_W,
    IW:  MEM_ID_W,
    EW:  hci_package::DEFAULT_EW,
    EHW: hci_package::DEFAULT_EHW
  };
  `HCI_INTF_ARRAY(core_mem, clk_i, 0:N_CORE*N_MEM-1);

  localparam hci_size_parameter_t `HCI_SIZE_PARAM(core_mem_muxed) = '{
    DW:  MEM_DATA_W,
    AW:  MEM_ADDR_W,
    BW:  MEM_BYTE_W,
    UW:  MEM_USER_W,
    IW:  MEM_ID_W,
    EW:  hci_package::DEFAULT_EW,
    EHW: hci_package::DEFAULT_EHW
  };
  `HCI_INTF_ARRAY(core_mem_muxed, clk_i, 0:N_MEM-1);

/*******************************************************/
/**      Parameter and Interface Definitions End      **/
/*******************************************************/
/**       HWPE Routing and Arbitration Beginning      **/
/*******************************************************/

  for(genvar i = 0; i < N_HWPE; i++) begin : gen_hwpe_req2mem
    hci_router #(
      .FIFO_DEPTH           ( EXPFIFO                   ),
      .NB_OUT_CHAN          ( N_MEM                     ),
      .FILTER_WRITE_R_VALID ( FILTER_WRITE_R_VALID[i]   ),
      .`HCI_SIZE_PARAM(in)  ( `HCI_SIZE_PARAM(hwpe)     ),
      .`HCI_SIZE_PARAM(out) ( `HCI_SIZE_PARAM(hwpe_mem) )
    ) i_hwpe_router (
      .clk_i   ( clk_i                           ),
      .rst_ni  ( rst_ni                          ),
      .clear_i ( clear_i                         ),
      .in      ( hwpe[i]                         ),
      .out     ( hwpe_mem[i*N_MEM:(i+1)*N_MEM-1] )
    );
  end

  hci_arbiter_tree #(
    .NB_REQUESTS          ( N_HWPE                          ),
    .NB_CHAN              ( N_MEM                           ),
    .`HCI_SIZE_PARAM(out) ( `HCI_SIZE_PARAM(hwpe_mem_muxed) )
  ) i_hwpe_wide_port_arbiter_tree (
    .clk_i   ( clk_i          ),
    .rst_ni  ( rst_ni         ),
    .clear_i ( clear_i        ),
    .ctrl_i  ( ctrl_i         ),
    .in      ( hwpe_mem       ),
    .out     ( hwpe_mem_muxed )
  );

/*******************************************************/
/**          HWPE Routing and Arbitration End         **/
/*******************************************************/
/**       DMA Routing and Arbitration Beginning       **/
/*******************************************************/

  for(genvar i = 0; i < N_DMA; i++) begin : gen_dma_req2mem
    hci_router #(
      .FIFO_DEPTH           ( EXPFIFO                  ),
      .NB_OUT_CHAN          ( N_MEM                    ),
      .FILTER_WRITE_R_VALID ( FILTER_WRITE_R_VALID[i]  ),
      .`HCI_SIZE_PARAM(in)  ( `HCI_SIZE_PARAM(dma)     ),
      .`HCI_SIZE_PARAM(out) ( `HCI_SIZE_PARAM(dma_mem) )
    ) i_dma_router (
      .clk_i   ( clk_i                          ),
      .rst_ni  ( rst_ni                         ),
      .clear_i ( clear_i                        ),
      .in      ( dma[i]                         ),
      .out     ( dma_mem[i*N_MEM:(i+1)*N_MEM-1] )
    );
  end

  hci_arbiter_tree #(
    .NB_REQUESTS          ( N_DMA                          ),
    .NB_CHAN              ( N_MEM                          ),
    .`HCI_SIZE_PARAM(out) ( `HCI_SIZE_PARAM(dma_mem_muxed) )
  ) i_dma_wide_port_arbiter_tree (
    .clk_i   ( clk_i         ),
    .rst_ni  ( rst_ni        ),
    .clear_i ( clear_i       ),
    .ctrl_i  ( ctrl_i        ),
    .in      ( dma_mem       ),
    .out     ( dma_mem_muxed )
  );

/*******************************************************/
/**          DMA Routing and Arbitration End          **/
/*******************************************************/
/**         HWPE and DMA Arbitration Beginning        **/
/*******************************************************/

  hci_arbiter #(
    .NB_CHAN ( N_MEM )
  ) i_hwpe_vs_dma_arbiter (
    .clk_i   ( clk_i              ),
    .rst_ni  ( rst_ni             ),
    .clear_i ( clear_i            ),
    .ctrl_i  ( ctrl_i             ),
    .in_high ( hwpe_mem_muxed     ),
    .in_low  ( dma_mem_muxed      ),
    .out     ( hwpe_dma_mem_muxed )
  );

/*******************************************************/
/**            HWPE and DMA Arbitration End           **/
/*******************************************************/
/**      Core Routing and Arbitration Beginning       **/
/*******************************************************/

  for(genvar i = 0; i < N_CORE; i++) begin : gen_core_req2mem
    hci_router #(
      .FIFO_DEPTH           ( EXPFIFO                   ),
      .NB_OUT_CHAN          ( N_MEM                     ),
      .FILTER_WRITE_R_VALID ( FILTER_WRITE_R_VALID[i]   ),
      .`HCI_SIZE_PARAM(in)  ( `HCI_SIZE_PARAM(core)     ),
      .`HCI_SIZE_PARAM(out) ( `HCI_SIZE_PARAM(core_mem) )
    ) i_core_router (
      .clk_i   ( clk_i                           ),
      .rst_ni  ( rst_ni                          ),
      .clear_i ( clear_i                         ),
      .in      ( core[i]                         ),
      .out     ( core_mem[i*N_MEM:(i+1)*N_MEM-1] )
    );
  end

  hci_arbiter_tree #(
    .NB_REQUESTS          ( N_CORE                          ),
    .NB_CHAN              ( N_MEM                           ),
    .`HCI_SIZE_PARAM(out) ( `HCI_SIZE_PARAM(core_mem_muxed) )
  ) i_core_wide_port_arbiter_tree (
    .clk_i   ( clk_i          ),
    .rst_ni  ( rst_ni         ),
    .clear_i ( clear_i        ),
    .ctrl_i  ( ctrl_i         ),
    .in      ( core_mem       ),
    .out     ( core_mem_muxed )
  );

/*******************************************************/
/**          Core Routing and Arbitration End         **/
/*******************************************************/
/**      HWPE/DMA and Core Arbitration Beginning      **/
/*******************************************************/

  hci_arbiter #(
    .NB_CHAN ( N_MEM )
  ) i_wide_vs_narrow_arbiter (
    .clk_i   ( clk_i              ),
    .rst_ni  ( rst_ni             ),
    .clear_i ( clear_i            ),
    .ctrl_i  ( ctrl_i             ),
    .in_high ( hwpe_dma_mem_muxed ),
    .in_low  ( core_mem_muxed     ),
    .out     ( mem                )
  );

/*******************************************************/
/**         HWPE/DMA and Core Arbitration End         **/
/*******************************************************/

endmodule: local_interconnect
