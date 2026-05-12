/*
 * Copyright (C) 2026 ETH Zurich, University of Bologna and Chips-IT
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
 * Authors: Alessandro Nadalini <alessandro.nadalini3@unibo.it>
 * 
 * MAGIA Tile Instruction cache wrapper (inspired by the previous pulp_icache_wrap)
 */

 module magia_tile_icache_wrap #(
    /// Number of request (fetch) ports
    parameter int NumFetchPorts = -1,
    /// L0 Cache Line Count
    parameter int L0_LINE_COUNT = -1,
    /// Cache Line Width
    /// For optimal performance, use >= 32*NumFetchPorts to allow execution of 32-bit instructions
    /// for each core before requiring another L0-L1 fetch.
    parameter int LINE_WIDTH = -1,
    /// The number of cache lines per set. Power of two; >= 2.
    parameter int LINE_COUNT = -1,
    /// The set associativity of the cache. Power of 2; >= 1.
    parameter int WAY_COUNT = -1,
    /// Fetch interface address width (must be >= 1)
    parameter int FetchAddrWidth = -1,
    /// Fetch interface data width. Power of 2; >= 8.
    parameter int FetchDataWidth = -1,
    /// Fill interface address wifth (must be >= 1)
    parameter int AxiAddrWidth = -1,
    /// Fill interface data width. Power of 2; >= 8.
    parameter int AxiDataWidth = -1,
    /// Configuration input types for memory cuts used in implementation.
    parameter type sram_cfg_data_t  = logic,
    parameter type sram_cfg_tag_t   = logic,
    /// AXI request and response structures
    parameter type axi_req_t = logic,
    parameter type axi_rsp_t = logic   
 ) (
    input   logic                                                       clk_i,
    input   logic                                                       rst_ni,

    // Processor interface
    input   logic [NumFetchPorts-1:0]                                   fetch_req_i,
    input   logic [NumFetchPorts-1:0][FetchAddrWidth-1:0]               fetch_addr_i,
    output  logic [NumFetchPorts-1:0]                                   fetch_gnt_o,
    output  logic [NumFetchPorts-1:0]                                   fetch_rvalid_o,
    output  logic [NumFetchPorts-1:0][FetchDataWidth-1:0]               fetch_rdata_o,
    output  logic [NumFetchPorts-1:0]                                   fetch_rerror_o,

    input   logic                                                       enable_prefetching_i,
    output  snitch_icache_pkg::icache_l0_events_t [NumFetchPorts-1:0]   icache_l0_events_o,
    output  snitch_icache_pkg::icache_l1_events_t                       icache_l1_events_o,
    input   logic [NumFetchPorts-1:0]                                   flush_valid_i,
    output  logic [NumFetchPorts-1:0]                                   flush_ready_o,

    // SRAM configs
    input   sram_cfg_data_t                                             sram_cfg_data_i,
    input   sram_cfg_tag_t                                              sram_cfg_tag_i,

    // AXI interface
    output  axi_req_t                                                   axi_req_o,
    input   axi_rsp_t                                                   axi_rsp_i
 );

    logic [NumFetchPorts-1:0] fetch_valid, fetch_ready, fetch_rerror;
    logic [NumFetchPorts-1:0][FetchAddrWidth-1:0] fetch_addr;
    logic [NumFetchPorts-1:0][FetchDataWidth-1:0] fetch_rdata;

    for (genvar i = 0; i < NumFetchPorts; i++) begin : gen_request_cut
        logic gnt;

        assign fetch_gnt_o[i] = gnt & fetch_req_i[i];

        spill_register #(
            .T      ( logic [FetchAddrWidth-1:0]    ),
            .Bypass ( 1'b0                          )
        ) i_spill_reg (
            .clk_i      ( clk_i             ),
            .rst_ni     ( rst_ni            ),
            .valid_i    ( fetch_req_i   [i] ),
            .ready_o    ( gnt               ),
            .data_i     ( fetch_addr_i  [i] ),
            .valid_o    ( fetch_valid   [i] ),
            .ready_i    ( fetch_ready   [i] ),
            .data_o     ( fetch_addr    [i] )
        );

        assign fetch_rdata_o    [i] = fetch_rdata   [i];
        assign fetch_rerror_o   [i] = fetch_rerror  [i];
        assign fetch_rvalid_o   [i] = fetch_ready   [i] & fetch_valid [i];
    end

    snitch_icache #(
        .NR_FETCH_PORTS         ( NumFetchPorts     ),
        .L0_LINE_COUNT          ( L0_LINE_COUNT     ),
        .LINE_WIDTH             ( LINE_WIDTH        ),
        .LINE_COUNT             ( LINE_COUNT        ),
        .WAY_COUNT              ( WAY_COUNT         ),
        .FETCH_AW               ( FetchAddrWidth    ),
        .FETCH_DW               ( FetchDataWidth    ),
        .FILL_AW                ( AxiAddrWidth      ),
        .FILL_DW                ( AxiDataWidth      ),
        .FETCH_PRIORITY         ( 1                 ),
        .MERGE_FETCHES          ( 1                 ),
        .L1_TAG_SCM             ( 1                 ),
        .SERIAL_LOOKUP          ( 1                 ),
        .NUM_AXI_OUTSTANDING    ( 4                 ), // wouldn-t be better to expose this parameter?
        .EARLY_LATCH            ( 0                 ),
        .ISO_CROSSING           ( 0                 ),
        .sram_cfg_data_t        ( sram_cfg_data_t   ),
        .sram_cfg_tag_t         ( sram_cfg_tag_t    ),
        .axi_req_t              ( axi_req_t         ),
        .axi_rsp_t              ( axi_rsp_t         )
    ) i_snitch_icache (
        .clk_i                  ( clk_i                 ),
        .clk_d2_i               ( clk_i                 ),
        .rst_ni                 ( rst_ni                ),
        
        .enable_prefetching_i   ( enable_prefetching_i  ),
        .icache_l0_events_o     ( icache_l0_events_o    ),
        .icache_l1_events_o     ( icache_l1_events_o    ),
        .flush_valid_i          ( flush_valid_i         ),
        .flush_ready_o          ( flush_ready_o         ),
        
        .inst_addr_i            ( fetch_addr            ),
        .inst_data_o            ( fetch_rdata           ),
        .inst_cacheable_i       ( {NumFetchPorts{1'b1}} ),
        .inst_valid_i           ( fetch_valid           ),
        .inst_ready_o           ( fetch_ready           ),
        .inst_error_o           ( fetch_rerror          ),
        
        .sram_cfg_data_i        ( sram_cfg_data_i       ),
        .sram_cfg_tag_i         ( sram_cfg_tag_i        ),

        .axi_req_o              ( axi_req_o             ),
        .axi_rsp_i              ( axi_rsp_i             )
    );
    
 endmodule