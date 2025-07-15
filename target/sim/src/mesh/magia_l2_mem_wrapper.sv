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
 * Authors: Alessandro Nadalini <alessandro.nadalini3@unibo.it>
 * 
 * MAGIA L2 memory wrapper
*/

module magia_l2_mem_wrapper
    `ifndef TARGET_STANDALONE_TILE
    import magia_noc_pkg::*;
    `else
    import floo_axi_mesh_1x2_noc_pkg::*;
    `endif
    import floo_pkg::*;
#(
   parameter int unsigned   NumPorts = 32,
   parameter time           ApplDelay = 0ps,
   parameter time           AcqDelay = 0ps
) (
   input    logic                       clk_i,
   input    logic                       rst_ni,
   input    floo_req_t [NumPorts-1:0]   noc_req_i,
   output   floo_rsp_t [NumPorts-1:0]   noc_rsp_o,
   output   floo_req_t [NumPorts-1:0]   noc_req_o,
   input    floo_rsp_t [NumPorts-1:0]   noc_rsp_i
);

    // AXI bus for L2 memory
    magia_pkg::axi_l2_req_t [NumPorts-1:0] l2_data_req;
    magia_pkg::axi_l2_rsp_t [NumPorts-1:0] l2_data_rsp;
    
    generate
        for(genvar i=0; i<NumPorts; i++) begin: gen_L2_ni
            floo_axi_chimney #(
                .AxiCfg         ( AxiCfg                                    ),
                .ChimneyCfg     ( set_ports(ChimneyDefaultCfg, 1'b1, 1'b0)  ),
                .RouteCfg       ( RouteCfg                                  ),
                .id_t           ( id_t                                      ),
                .rob_idx_t      ( rob_idx_t                                 ),
                .hdr_t          ( hdr_t                                     ),
                .sam_rule_t     ( sam_rule_t                                ),
                .Sam            ( Sam                                       ),
                .axi_in_req_t   ( axi_data_slv_req_t                        ),
                .axi_in_rsp_t   ( axi_data_slv_rsp_t                        ),
                .axi_out_req_t  ( axi_data_mst_req_t                        ),
                .axi_out_rsp_t  ( axi_data_mst_rsp_t                        ),
                .floo_req_t     ( floo_req_t                                ),
                .floo_rsp_t     ( floo_rsp_t                                )
            ) L2_ni (
                .clk_i          ( clk_i                     ),
                .rst_ni         ( rst_ni                    ),
                .test_enable_i  ( 1'b0                      ),
                .sram_cfg_i     ( '0                        ),
                .axi_in_req_i   ( '0                        ),
                .axi_in_rsp_o   (                           ),
                .axi_out_req_o  ( l2_data_req[i]            ),
                .axi_out_rsp_i  ( l2_data_rsp[i]            ),
                .id_i           ( '{x: 0, y: i, port_id: 0} ),
                .route_table_i  ( '0                        ),
                .floo_req_o     ( noc_req_o[i]              ),
                .floo_rsp_i     ( noc_rsp_i[i]              ),
                .floo_req_i     ( noc_req_i[i]              ),
                .floo_rsp_o     ( noc_rsp_o[i]              )
            );
        end
    endgenerate

    axi_sim_mem #(
    .AddrWidth          ( magia_pkg::ADDR_W         ),
    .DataWidth          ( magia_pkg::DATA_W         ),
    .IdWidth            ( magia_tb_pkg::L2_ID_W     ),
    .UserWidth          ( magia_tb_pkg::L2_U_W      ),
    .NumPorts           ( NumPorts                  ),
    .axi_req_t          ( magia_pkg::axi_l2_req_t   ),
    .axi_rsp_t          ( magia_pkg::axi_l2_rsp_t   ),
    .WarnUninitialized  ( 1                         ),
    .ClearErrOnAccess   ( 1                         ),
    .ApplDelay          ( ApplDelay                 ),
    .AcqDelay           ( AcqDelay                  )
  ) i_l2_mem (
    .clk_i              ( clk_i       ),
    .rst_ni             ( rst_ni      ),
    .axi_req_i          ( l2_data_req ),
    .axi_rsp_o          ( l2_data_rsp ),
    .mon_w_valid_o      (             ),
    .mon_w_addr_o       (             ),
    .mon_w_data_o       (             ),
    .mon_w_id_o         (             ),
    .mon_w_user_o       (             ),
    .mon_w_beat_count_o (             ),
    .mon_w_last_o       (             ),
    .mon_r_valid_o      (             ),
    .mon_r_addr_o       (             ),
    .mon_r_data_o       (             ),
    .mon_r_id_o         (             ),
    .mon_r_user_o       (             ),
    .mon_r_beat_count_o (             ),
    .mon_r_last_o       (             )
  );

endmodule