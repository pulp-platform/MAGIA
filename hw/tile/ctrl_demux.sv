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
 * Author: Luca Balboni <luca.balboni@chips.it>
 *
 * MAGIA control demux: splits the control port of the OBI crossbar towards the enabled control units
 */

module ctrl_demux
  import magia_tile_pkg::*;
#(
  parameter magia_tile_pkg::magia_tile_cfg_t TileCfg       = magia_tile_pkg::MagiaTileDefaultCfg,
  localparam magia_tile_pkg::ctrl_map_t      CtrlMap       = magia_tile_pkg::gen_ctrl_map(TileCfg)
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
  localparam int unsigned                 ErrIdx    = CtrlMap.num_units;  // Default port, after the units
  localparam int unsigned                 SelW      = magia_tile_pkg::gen_idx_width(CtrlMap.num_units + 1);

  magia_tile_pkg::obi_xbar_rule_t[CtrlMap.num_units-1:0] ctrl_rule;
  magia_tile_pkg::core_obi_data_req_t[CtrlMap.num_units:0] demux_req;
  // Each element comes from a different unit: split it, or Verilator sees a false combinational loop
  magia_tile_pkg::core_obi_data_rsp_t[CtrlMap.num_units:0] demux_rsp /* verilator split_var */;

  for (genvar i = 0; i < CtrlMap.num_units; i++) begin: gen_ctrl_rule
    assign ctrl_rule[i] = CtrlRules[i];
  end

  obi_demux_addr #(
    .SbrPortObiCfg ( magia_tile_pkg::obi_amo_cfg ),
    .NumMgrPorts   ( CtrlMap.num_units + 1       ),
    .NumMaxTrans   ( magia_tile_pkg::N_MAX_TRAN  ),
    .NumAddrRules  ( CtrlMap.num_units           )
  ) i_ctrl_demux (
    .clk_i            ( clk_i          ),
    .rst_ni           ( rst_ni         ),
    .sbr_ports_req_i  ( obi_req_i      ),
    .sbr_ports_rsp_o  ( obi_rsp_o      ),
    .mgr_ports_req_o  ( demux_req      ),
    .mgr_ports_rsp_i  ( demux_rsp      ),
    .addr_map_i       ( ctrl_rule      ),
    .en_default_idx_i ( 1'b1           ),
    .default_idx_i    ( SelW'(ErrIdx)  )
  );

  assign unit_req_o                       = demux_req[CtrlMap.num_units-1:0];
  assign demux_rsp[CtrlMap.num_units-1:0] = unit_rsp_i;

  // Disabled units and holes in the control window get an error response
  obi_err_sbr #(
    .ObiCfg    ( magia_tile_pkg::obi_amo_cfg         ),
    .obi_req_t ( magia_tile_pkg::core_obi_data_req_t ),
    .obi_rsp_t ( magia_tile_pkg::core_obi_data_rsp_t )
  ) i_obi_err_sbr (
    .clk_i      ( clk_i             ),
    .rst_ni     ( rst_ni            ),
    .testmode_i ( 1'b0              ),
    .obi_req_i  ( demux_req[ErrIdx] ),
    .obi_rsp_o  ( demux_rsp[ErrIdx] )
  );

`ifndef SYNTHESIS
  assert property (@(posedge clk_i) disable iff (!rst_ni) !demux_req[ErrIdx].req)
    else $fatal(1, "ctrl_demux: OBI access to unmapped control address 0x%08x (unit disabled?)",
                demux_req[ErrIdx].a.addr);
`endif

endmodule: ctrl_demux
