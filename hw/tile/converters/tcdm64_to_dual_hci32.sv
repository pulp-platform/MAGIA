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
 * TCDM 64-bit to Dual HCI 32-bit Protocol Converter
 *
 */

module tcdm64_to_dual_hci32 #(
  parameter type tcdm64_req_t = logic,  // 64-bit TCDM request type
  parameter type tcdm64_rsp_t = logic,  // 64-bit TCDM response type
  parameter type tcdm32_req_t = logic,  // 32-bit TCDM request type
  parameter type tcdm32_rsp_t = logic,  // 32-bit TCDM response type
  parameter type hci_req_t    = logic,  // 32-bit HCI request type
  parameter type hci_rsp_t    = logic   // 32-bit HCI response type
)(
  input  logic         clk_i,
  input  logic         rst_ni,
  
  // TCDM side (Spatz 64-bit vector port)
  input  tcdm64_req_t  tcdm_req_i,
  output tcdm64_rsp_t  tcdm_rsp_o,
  
  // HCI side (Two 32-bit L1 SPM interconnect ports)
  output hci_req_t   hci_req_lo_o,  // Lower 32-bit word (bits [31:0])
  input  hci_rsp_t   hci_rsp_lo_i,
  output hci_req_t   hci_req_hi_o,  // Upper 32-bit word (bits [63:32])
  input  hci_rsp_t   hci_rsp_hi_i
);

  // Internal TCDM32 signals
  tcdm32_req_t tcdm32_req_lo, tcdm32_req_hi;
  tcdm32_rsp_t tcdm32_rsp_lo, tcdm32_rsp_hi;

  /*******************************************************************/
  /*    Step 1: TCDM64 → 2× TCDM32 split (tcdm64_to_dual_tcdm32)    */
  /*******************************************************************/
  
  tcdm64_to_dual_tcdm32 #(
    .tcdm64_req_t ( tcdm64_req_t  ),
    .tcdm64_rsp_t ( tcdm64_rsp_t  ),
    .tcdm32_req_t ( tcdm32_req_t  ),
    .tcdm32_rsp_t ( tcdm32_rsp_t  )
  ) i_tcdm64_to_dual_tcdm32 (
    .clk_i          ( clk_i          ),
    .rst_ni         ( rst_ni         ),
    .tcdm_req_i     ( tcdm_req_i     ),
    .tcdm_rsp_o     ( tcdm_rsp_o     ),
    .tcdm_req_lo_o  ( tcdm32_req_lo  ),
    .tcdm_rsp_lo_i  ( tcdm32_rsp_lo  ),
    .tcdm_req_hi_o  ( tcdm32_req_hi  ),
    .tcdm_rsp_hi_i  ( tcdm32_rsp_hi  )
  );

  /*******************************************************************/
  /*           Step 2: TCDM32 → HCI32 (2× tcdm2hci)                 */
  /*******************************************************************/
  
  // Lower bank: TCDM32 → HCI32
  tcdm2hci #(
    .tcdm_req_t ( tcdm32_req_t ),
    .tcdm_rsp_t ( tcdm32_rsp_t ),
    .hci_req_t  ( hci_req_t    ),
    .hci_rsp_t  ( hci_rsp_t    )
  ) i_tcdm2hci_lo (
    .clk_i      ( clk_i          ),
    .rst_ni     ( rst_ni         ),
    .tcdm_req_i ( tcdm32_req_lo  ),
    .tcdm_rsp_o ( tcdm32_rsp_lo  ),
    .hci_req_o  ( hci_req_lo_o   ),
    .hci_rsp_i  ( hci_rsp_lo_i   )
  );

  // Upper bank: TCDM32 → HCI32
  tcdm2hci #(
    .tcdm_req_t ( tcdm32_req_t ),
    .tcdm_rsp_t ( tcdm32_rsp_t ),
    .hci_req_t  ( hci_req_t    ),
    .hci_rsp_t  ( hci_rsp_t    )
  ) i_tcdm2hci_hi (
    .clk_i      ( clk_i          ),
    .rst_ni     ( rst_ni         ),
    .tcdm_req_i ( tcdm32_req_hi  ),
    .tcdm_rsp_o ( tcdm32_rsp_hi  ),
    .hci_req_o  ( hci_req_hi_o   ),
    .hci_rsp_i  ( hci_rsp_hi_i   )
  );

endmodule : tcdm64_to_dual_hci32
