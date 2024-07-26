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
 * OBI Single Master XBAR
 */

module obi_demux_addr #(
  parameter obi_pkg::obi_cfg_t SbrPortObiCfg      = obi_pkg::ObiDefaultConfig,  // The OBI configuration for the subordinate ports (input ports)
  parameter obi_pkg::obi_cfg_t MgrPortObiCfg      = SbrPortObiCfg,              // The OBI configuration for the manager ports (ouput ports)
  
  parameter type               sbr_port_obi_req_t = logic,                      // The request struct for the subordinate ports (input ports)
  parameter type               sbr_port_obi_rsp_t = logic,                      // The response struct for the subordinate ports (input ports)
  parameter type               mgr_port_obi_req_t = sbr_port_obi_req_t,         // The request struct for the manager ports (output ports)
  parameter type               mgr_port_obi_rsp_t = sbr_port_obi_rsp_t,         // The response struct for the manager ports (output ports)
 
  parameter int unsigned       NumMgrPorts        = 32'd0,                      // The number of manager ports (output ports)
  parameter int unsigned       NumMaxTrans        = 32'd0,                      // The maximum number of outstanding transactions
  
  parameter int unsigned       NumAddrRules       = 32'd0,                      // The number of address rules
  parameter type               addr_map_rule_t    = logic                       // The address map rule type
)(
  input  logic                               clk_i,
  input  logic                               rst_ni,

  input  sbr_port_obi_req_t                  sbr_ports_req_i,
  output sbr_port_obi_rsp_t                  sbr_ports_rsp_o,

  output mgr_port_obi_req_t[NumMgrPorts-1:0] mgr_ports_req_o,
  input  mgr_port_obi_rsp_t[NumMgrPorts-1:0] mgr_ports_rsp_i,

  input  addr_map_rule_t[NumAddrRules-1:0]   addr_map_i,
  input  logic                               en_default_idx_i,
  input  logic[$clog2(NumMgrPorts)-1:0]      default_idx_i
);

  logic[$clog2(NumMgrPorts)-1:0] sbr_port_select;
  
  addr_decode #(
    .NoIndices ( NumMgrPorts                        ),
    .NoRules   ( NumAddrRules                       ),
    .addr_t    ( logic[MgrPortObiCfg.AddrWidth-1:0] ),
    .rule_t    ( addr_map_rule_t                    )
  ) i_addr_decode (
    .addr_i          ( sbr_ports_req_i.a.addr ),
    .addr_map_i      ( addr_map_i             ),
    .idx_o           ( sbr_port_select        ),
    .dec_valid_o     (                        ),
    .dec_error_o     (                        ),
    .en_default_idx_i( en_default_idx_i       ),
    .default_idx_i   ( default_idx_i          )
  );

  obi_demux #(
    .ObiCfg      ( SbrPortObiCfg      ),
    .obi_req_t   ( sbr_port_obi_req_t ),
    .obi_rsp_t   ( sbr_port_obi_rsp_t ),
    .NumMgrPorts ( NumMgrPorts        ),
    .NumMaxTrans ( NumMaxTrans        )
  ) i_demux (
    .clk_i,
    .rst_ni,
    .sbr_port_select_i ( sbr_port_select ),
    .sbr_port_req_i    ( sbr_ports_req_i ),
    .sbr_port_rsp_o    ( sbr_ports_rsp_o ),
    .mgr_ports_req_o   ( mgr_ports_req_o ),
    .mgr_ports_rsp_i   ( mgr_ports_rsp_i )
  );
  
endmodule: obi_demux_addr