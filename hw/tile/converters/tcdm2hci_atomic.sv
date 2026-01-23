/*
 * Copyright (C) 2024 ETH Zurich and University of Bologna
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
 * TCDM to HCI Converter with Atomic Operation Support
 * 
 * Conversion chain: TCDM (with AMO) → OBI (with atop) → OBI (resolved) → HCI
 * 
 */

module tcdm2hci_atomic
  import obi_pkg::*;
  import magia_tile_pkg::*;
#(
  parameter type tcdm_req_t = logic,
  parameter type tcdm_rsp_t = logic,
  parameter type obi_req_t  = logic,
  parameter type obi_rsp_t  = logic,
  parameter type hci_req_t  = logic,
  parameter type hci_rsp_t  = logic,
  
  // OBI channel types
  parameter type obi_a_chan_t = logic,
  parameter type obi_r_chan_t = logic,
  
  // OBI optional types for atomic resolver
  parameter type obi_a_optional_t = logic,
  parameter type obi_r_optional_t = logic,
  
  // OBI configuration for atomic resolver
  parameter obi_pkg::obi_cfg_t SbrPortObiCfg = obi_pkg::ObiDefaultConfig,
  parameter obi_pkg::obi_cfg_t MgrPortObiCfg = obi_pkg::ObiDefaultConfig,
  
  // Pipeline cut control
  parameter bit BypassCut = 1'b0
)(
  input  logic      clk_i,
  input  logic      rst_ni,
  
  // TCDM slave port (with atomic operations)
  input  tcdm_req_t tcdm_req_i,
  output tcdm_rsp_t tcdm_rsp_o,
  
  // HCI master port (atomic-free)
  output hci_req_t  hci_req_o,
  input  hci_rsp_t  hci_rsp_i
);

  // Internal OBI signals between converters
  obi_req_t obi_req;
  obi_rsp_t obi_rsp;
  
  // OBI signals after atomic resolution
  obi_req_t obi_resolved_req;
  obi_rsp_t obi_resolved_rsp;
  
  // OBI signals after post-atomic cut (pipeline stage)
  obi_req_t obi_cut_req;
  obi_rsp_t obi_cut_rsp;
  
  /*******************************************************************/
  /*  Stage 1: TCDM → OBI (with atomic operations preserved)        */
  /*******************************************************************/
  
  tcdm2obi #(
    .tcdm_req_t ( tcdm_req_t ),
    .tcdm_rsp_t ( tcdm_rsp_t ),
    .obi_req_t  ( obi_req_t  ),
    .obi_rsp_t  ( obi_rsp_t  )
  ) i_tcdm2obi (
    .clk_i      ( clk_i      ),
    .rst_ni     ( rst_ni     ),
    .tcdm_req_i ( tcdm_req_i ),
    .tcdm_rsp_o ( tcdm_rsp_o ),
    .obi_req_o  ( obi_req    ),
    .obi_rsp_i  ( obi_rsp    )
  );
  
  /*******************************************************************/
  /*  Stage 2: OBI Atomic Resolution (atop → RMW sequences)         */
  /*******************************************************************/
  
  obi_atop_resolver #(
    .SbrPortObiCfg             ( SbrPortObiCfg              ),
    .MgrPortObiCfg             ( MgrPortObiCfg              ),
    .sbr_port_obi_req_t        ( obi_req_t                  ),
    .sbr_port_obi_rsp_t        ( obi_rsp_t                  ),
    .mgr_port_obi_req_t        ( obi_req_t                  ),
    .mgr_port_obi_rsp_t        ( obi_rsp_t                  ),
    .mgr_port_obi_a_optional_t ( obi_a_optional_t           ),
    .mgr_port_obi_r_optional_t ( obi_r_optional_t           ),
    .LrScEnable                ( 1'b1                       ),
    .RegisterAmo               ( magia_tile_pkg::RegisterAmo)
  ) i_obi_atop_resolver (
    .clk_i          ( clk_i            ),
    .rst_ni         ( rst_ni           ),
    .testmode_i     ( 1'b0             ),
    .sbr_port_req_i ( obi_req          ),
    .sbr_port_rsp_o ( obi_rsp          ),
    .mgr_port_req_o ( obi_resolved_req ),
    .mgr_port_rsp_i ( obi_resolved_rsp )
  );
  
  /*******************************************************************/
  /*  Stage 3: OBI Cut (optional - controlled by BypassCut param)   */
  /*******************************************************************/
  
  generate
    if (BypassCut) begin : gen_bypass_cut
      assign obi_cut_req = obi_resolved_req;
      assign obi_resolved_rsp = obi_cut_rsp;
    end else begin : gen_enable_cut
      obi_cut #(
        .ObiCfg       ( MgrPortObiCfg ),
        .obi_a_chan_t ( obi_a_chan_t  ),
        .obi_r_chan_t ( obi_r_chan_t  ),
        .obi_req_t    ( obi_req_t     ),
        .obi_rsp_t    ( obi_rsp_t     )
      ) i_obi_cut_post_atomic (
        .clk_i           ( clk_i            ),
        .rst_ni          ( rst_ni           ),
        .sbr_port_req_i  ( obi_resolved_req ),
        .sbr_port_rsp_o  ( obi_resolved_rsp ),
        .mgr_port_req_o  ( obi_cut_req      ),
        .mgr_port_rsp_i  ( obi_cut_rsp      )
      );
    end
  endgenerate
  
  /*******************************************************************/
  /*  Stage 4: OBI → HCI conversion (request and response)          */
  /******************************************************************/
  
  // Convert OBI request to HCI request
  obi2hci_req #(
    .obi_req_t ( obi_req_t ),
    .hic_req_t ( hci_req_t )
  ) i_obi2hci_req (
    .obi_req_i ( obi_cut_req ),
    .hci_req_o ( hci_req_o   )
  );
  
  // Convert HCI response to OBI response
  hci2obi_rsp #(
    .hci_rsp_t ( hci_rsp_t ),
    .obi_rsp_t ( obi_rsp_t )
  ) i_hci2obi_rsp (
    .hci_rsp_i ( hci_rsp_i   ),
    .obi_rsp_o ( obi_cut_rsp )
  );

endmodule : tcdm2hci_atomic
