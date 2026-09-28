/*
 * Copyright (C) 2026 ETH Zurich, University of Bologna and Fondazione Chips-IT
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * SPDX-License-Identifier: Apache-2.0
 *
 * Authors: Luca Balboni <luca.balboni@chips.it>
 *
 * MAGIA control demux: demuxes the single control port of the OBI crossbar towards
 * the control registers of each enabled unit
*/

module ctrl_demux
  import magia_tile_pkg::*;
#(
  parameter magia_tile_pkg::magia_tile_cfg_t TileCfg       = magia_tile_pkg::MagiaTileDefaultCfg,
  parameter magia_tile_pkg::ctrl_map_t       CtrlMap       = magia_tile_pkg::gen_ctrl_map(TileCfg)
)(
  input  logic                                                   clk_i,
  input  logic                                                   rst_ni,

  input  magia_tile_pkg::core_obi_data_req_t                     obi_req_i,
  output magia_tile_pkg::core_obi_data_rsp_t                     obi_rsp_o,

  // One port per enabled unit, indexed by CtrlMap
  output magia_tile_pkg::core_obi_data_req_t[CtrlMap.num_units-1:0] unit_req_o,
  input  magia_tile_pkg::core_obi_data_rsp_t[CtrlMap.num_units-1:0] unit_rsp_i
);

  localparam magia_tile_pkg::ctrl_rules_t CtrlRules = magia_tile_pkg::gen_ctrl_rules(TileCfg);

  magia_tile_pkg::obi_xbar_rule_t[CtrlMap.num_units-1:0] ctrl_rule;

  for (genvar i = 0; i < CtrlMap.num_units; i++) begin: gen_ctrl_rule
    assign ctrl_rule[i] = CtrlRules[i];
  end

  obi_demux_addr #(
    .SbrPortObiCfg      ( magia_tile_pkg::obi_amo_cfg         ),
    .sbr_port_obi_req_t ( magia_tile_pkg::core_obi_data_req_t ),
    .sbr_port_obi_rsp_t ( magia_tile_pkg::core_obi_data_rsp_t ),
    .NumMgrPorts        ( CtrlMap.num_units                    ),
    .NumMaxTrans        ( magia_tile_pkg::N_MAX_TRAN          ),
    .NumAddrRules       ( CtrlMap.num_units                    ),
    .addr_map_rule_t    ( magia_tile_pkg::obi_xbar_rule_t     )
  ) i_ctrl_demux (
    .clk_i            ( clk_i      ),
    .rst_ni           ( rst_ni     ),
    .sbr_ports_req_i  ( obi_req_i  ),
    .sbr_ports_rsp_o  ( obi_rsp_o  ),
    .mgr_ports_req_o  ( unit_req_o ),
    .mgr_ports_rsp_i  ( unit_rsp_i ),
    .addr_map_i       ( ctrl_rule   ),
    .en_default_idx_i ( 1'b0       ),
    .default_idx_i    ( '0         )
  );

endmodule: ctrl_demux
