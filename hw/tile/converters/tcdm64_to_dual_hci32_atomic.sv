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
 * TCDM 64-bit to Dual HCI 32-bit Protocol Converter with Atomic Support
 *
 */

module tcdm64_to_dual_hci32_atomic
  import obi_pkg::*;
#(
  parameter type tcdm64_req_t = logic,  // 64-bit TCDM request type (with AMO)
  parameter type tcdm64_rsp_t = logic,  // 64-bit TCDM response type
  parameter type tcdm32_req_t = logic,  // 32-bit TCDM request type (with AMO)
  parameter type tcdm32_rsp_t = logic,  // 32-bit TCDM response type
  parameter type obi32_req_t  = logic,  // 32-bit OBI request type
  parameter type obi32_rsp_t  = logic,  // 32-bit OBI response type
  parameter type obi32_a_chan_t = logic, // 32-bit OBI address channel type
  parameter type obi32_r_chan_t = logic, // 32-bit OBI response channel type
  parameter type hci_req_t    = logic,  // 32-bit HCI request type
  parameter type hci_rsp_t    = logic,  // 32-bit HCI response type
  
  // OBI optional types for atomic resolvers
  parameter type obi32_a_optional_t = logic,
  parameter type obi32_r_optional_t = logic,
  
  // OBI configuration for atomic resolvers
  parameter obi_pkg::obi_cfg_t SbrPortObiCfg = obi_pkg::ObiDefaultConfig,
  parameter obi_pkg::obi_cfg_t MgrPortObiCfg = obi_pkg::ObiDefaultConfig,
  parameter bit BypassCut = 1'b0
)(
  input  logic       clk_i,
  input  logic       rst_ni,
  
  // TCDM side (Snitch RV64 port with AMO)
  input  tcdm64_req_t  tcdm_req_i,
  output tcdm64_rsp_t  tcdm_rsp_o,
  
  // HCI side (Two 32-bit L1 SPM interconnect ports)
  output hci_req_t   hci_req_lo_o,  // Lower 32-bit word (bits [31:0])
  input  hci_rsp_t   hci_rsp_lo_i,
  output hci_req_t   hci_req_hi_o,  // Upper 32-bit word (bits [63:32])
  input  hci_rsp_t   hci_rsp_hi_i
);

  // Internal TCDM32 signals after tcdm64_to_dual_tcdm32
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
  /*      Step 2: TCDM32 → HCI32 with atomics (2× tcdm2hci_atomic)  */
  /*******************************************************************/
  
  // Lower bank: TCDM32 → HCI32 with atomic support
  tcdm2hci_atomic #(
    .tcdm_req_t       ( tcdm32_req_t        ),
    .tcdm_rsp_t       ( tcdm32_rsp_t        ),
    .obi_req_t        ( obi32_req_t         ),
    .obi_rsp_t        ( obi32_rsp_t         ),
    .obi_a_chan_t     ( obi32_a_chan_t      ),
    .obi_r_chan_t     ( obi32_r_chan_t      ),
    .hci_req_t        ( hci_req_t           ),
    .hci_rsp_t        ( hci_rsp_t           ),
    .obi_a_optional_t ( obi32_a_optional_t  ),
    .obi_r_optional_t ( obi32_r_optional_t  ),
    .SbrPortObiCfg    ( SbrPortObiCfg       ),
    .MgrPortObiCfg    ( MgrPortObiCfg       ),
    .BypassCut        ( BypassCut           )
  ) i_tcdm2hci_atomic_lo (
    .clk_i       ( clk_i           ),
    .rst_ni      ( rst_ni          ),
    .tcdm_req_i  ( tcdm32_req_lo   ),
    .tcdm_rsp_o  ( tcdm32_rsp_lo   ),
    .hci_req_o   ( hci_req_lo_o    ),
    .hci_rsp_i   ( hci_rsp_lo_i    )
  );
  
  // Upper bank: TCDM32 → HCI32 with atomic support
  tcdm2hci_atomic #(
    .tcdm_req_t       ( tcdm32_req_t        ),
    .tcdm_rsp_t       ( tcdm32_rsp_t        ),
    .obi_req_t        ( obi32_req_t         ),
    .obi_rsp_t        ( obi32_rsp_t         ),
    .obi_a_chan_t     ( obi32_a_chan_t      ),
    .obi_r_chan_t     ( obi32_r_chan_t      ),
    .hci_req_t        ( hci_req_t           ),
    .hci_rsp_t        ( hci_rsp_t           ),
    .obi_a_optional_t ( obi32_a_optional_t  ),
    .obi_r_optional_t ( obi32_r_optional_t  ),
    .SbrPortObiCfg    ( SbrPortObiCfg       ),
    .MgrPortObiCfg    ( MgrPortObiCfg       ),
    .BypassCut        ( BypassCut           )
  ) i_tcdm2hci_atomic_hi (
    .clk_i       ( clk_i           ),
    .rst_ni      ( rst_ni          ),
    .tcdm_req_i  ( tcdm32_req_hi   ),
    .tcdm_rsp_o  ( tcdm32_rsp_hi   ),
    .hci_req_o   ( hci_req_hi_o    ),
    .hci_rsp_i   ( hci_rsp_hi_i    )
  );

endmodule : tcdm64_to_dual_hci32_atomic
