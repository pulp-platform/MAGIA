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
 * TCDM to HCI Protocol Converter (Direct - No Atomics)
 */

module tcdm2hci #(
  parameter type tcdm_req_t = logic,
  parameter type tcdm_rsp_t = logic,
  parameter type hci_req_t  = logic,
  parameter type hci_rsp_t  = logic
)(
  input  logic       clk_i,
  input  logic       rst_ni,
  
  // TCDM side (Spatz vector ports)
  input  tcdm_req_t  tcdm_req_i,
  output tcdm_rsp_t  tcdm_rsp_o,
  
  // HCI side (L1 SPM interconnect)
  output hci_req_t   hci_req_o,
  input  hci_rsp_t   hci_rsp_i
);

  /*******************************************************************/
  /*                     TCDM → HCI Request Mapping                  */
  /*******************************************************************/
  
  // Map request channel
  assign hci_req_o.req   = tcdm_req_i.q_valid;          
  assign hci_req_o.add   = tcdm_req_i.q.addr;           
  assign hci_req_o.wen   = ~tcdm_req_i.q.write;         
  assign hci_req_o.data  = tcdm_req_i.q.data;           
  assign hci_req_o.be    = tcdm_req_i.q.strb;         
  assign hci_req_o.boffs = '0;                         
  assign hci_req_o.lrdy  = 1'b1;                       
  assign hci_req_o.user  = tcdm_req_i.q.user;           
  
  /*******************************************************************/
  /*                     HCI → TCDM Response Mapping                 */
  /*******************************************************************/
  
  // Map response channel
  assign tcdm_rsp_o.q_ready = hci_rsp_i.gnt;            
  assign tcdm_rsp_o.p_valid = hci_rsp_i.r_valid;       
  assign tcdm_rsp_o.p.data  = hci_rsp_i.r_data;        

endmodule : tcdm2hci
