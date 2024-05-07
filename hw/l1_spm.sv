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
 * L1 SPM
 */

module l1_spm #(
  parameter int unsigned N_BANK    = 16    ,  // Number of memory banks
  parameter int unsigned N_WORDS   = 256   ,  // Number of words in a bank
  parameter int unsigned DATA_W    = 32    ,  // Data width
  parameter int unsigned ID_W      = 1     ,  // ID width
  parameter              SIM_INIT  = "ones"   // Simulation initialization value
) (
  input logic        clk_i                 ,
  input logic        rst_ni                ,
  hci_mem_intf.slave tcdm_slave[0:N_BANK-1]   // Memory interface
);

  for (genvar i = 0; i < N_BANK; i++) begin: gen_tcdm_bank
    logic[ID_W-1:0] resp_id_d, resp_id_q;

    assign resp_id_d          = tcdm_slave[i].id;
    assign tcdm_slave[i].r_id = resp_id_q;

    always_ff @ (posedge clk_i, negedge rst_ni) begin:  resp_id_register
      if (~rst_ni) resp_id_q <= '0;
      else         resp_id_q <= resp_id_d;
    end

    tc_sram #(
      .NumWords    ( N_WORDS  ),
      .DataWidth   ( DATA_W   ),
      .ByteWidth   ( 8        ),
      .NumPorts    ( 1        ),
      .Latency     ( 1        ),
      .SimInit     ( SIM_INIT ),
      .PrintSimCfg ( 0        ),
      .ImplKey     ( "none"   )
    ) i_tcdm_bank (
      .clk_i   ( clk_i                                    ),
      .rst_ni  ( rst_ni                                   ),

      .req_i   ( tcdm_slave[i].req                        ),
      .we_i    ( ~tcdm_slave[i].wen                       ),
      .addr_i  ( tcdm_slave[i].add[$clog2(N_WORDS)+2-1:2] ),
      .wdata_i ( tcdm_slave[i].data                       ),
      .be_i    ( tcdm_slave[i].be                         ),

      .rdata_o ( tcdm_slave[i].r_data                     )
    );

    assign tcdm_slave[i].gnt = 1'b1;
  end

endmodule: l1_spm