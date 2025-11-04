/*
 * Copyright (C) 2023-2024 ETH Zurich and University of Bologna
 *
 * Licensed under the Solderpad Hardware License, Version 0.51 
 * (the "License"); you may not use this fendmodule : idma_obi_ctrl_decoderle except in compliance 
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
  *          Based on idma_ctrl by Victor Isachi
 * 
 * OBI to iDMA Bridge - Memory-mapped control interface for iDMA
 *
 */

module idma_obi_ctrl_decoder
  import magia_tile_pkg::*;
  import magia_pkg::*;
 #(
  parameter type obi_req_t = magia_tile_pkg::core_obi_data_req_t,
  parameter type obi_rsp_t = magia_tile_pkg::core_obi_data_rsp_t,
  parameter type idma_fe_reg_req_t = magia_tile_pkg::idma_fe_reg_req_t,
  parameter type idma_fe_reg_rsp_t = magia_tile_pkg::idma_fe_reg_rsp_t
)(
  // OBI Slave Interface (CPU access)
  input  obi_req_t     obi_req_i,
  output obi_rsp_t     obi_rsp_o,

  // iDMA Register Frontend Interface  
  output idma_fe_reg_req_t idma_axi2obi_req_o,
  input  idma_fe_reg_rsp_t idma_axi2obi_rsp_i,
  
  output idma_fe_reg_req_t idma_obi2axi_req_o, 
  input  idma_fe_reg_rsp_t idma_obi2axi_rsp_i
);

/*******************************************************/
/**       Internal Signal Definitions Beginning       **/
/*******************************************************/

  // Address decode parameters - use parametric base address and size
  localparam logic [magia_pkg::ADDR_W-1:0] IDMA_BASE_ADDR = magia_tile_pkg::IDMA_CTRL_ADDR_START;
  localparam logic [magia_pkg::ADDR_W-1:0] IDMA_SIZE      = magia_tile_pkg::IDMA_CTRL_SIZE;
  localparam logic [magia_pkg::ADDR_W-1:0] IDMA_END_ADDR  = magia_tile_pkg::IDMA_CTRL_ADDR_END;
  
  localparam int unsigned ADDR_WIDTH = 32;
  localparam int unsigned DIRECTION_OFFSET = 12'h200;  // +0x200 for direction change
  
    // Register offset definitions based on official reg32_3d spec
  localparam logic [11:0] IDMA_CONFIG_OFFSET = 12'h0;
 
  localparam logic [11:0] IDMA_STATUS_0_OFFSET = 12'h4;
  localparam logic [11:0] IDMA_STATUS_1_OFFSET = 12'h8;
  localparam logic [11:0] IDMA_STATUS_2_OFFSET = 12'hc;
  localparam logic [11:0] IDMA_STATUS_3_OFFSET = 12'h10;
  
  localparam logic [11:0] IDMA_NEXT_ID_0_OFFSET = 12'h44;
  localparam logic [11:0] IDMA_NEXT_ID_1_OFFSET = 12'h48;
  
  localparam logic [11:0] IDMA_DONE_ID_0_OFFSET = 12'h84;
 
  localparam logic [11:0] IDMA_DST_ADDR_LOW_OFFSET = 12'hd0;
  localparam logic [11:0] IDMA_SRC_ADDR_LOW_OFFSET = 12'hd8;
  localparam logic [11:0] IDMA_LENGTH_LOW_OFFSET = 12'he0;
  localparam logic [11:0] IDMA_DST_STRIDE_2_LOW_OFFSET = 12'he8;
  localparam logic [11:0] IDMA_SRC_STRIDE_2_LOW_OFFSET = 12'hf0;
  localparam logic [11:0] IDMA_REPS_2_LOW_OFFSET = 12'hf8;
  localparam logic [11:0] IDMA_DST_STRIDE_3_LOW_OFFSET = 12'h100;
  localparam logic [11:0] IDMA_SRC_STRIDE_3_LOW_OFFSET = 12'h108;
  localparam logic [11:0] IDMA_REPS_3_LOW_OFFSET = 12'h110;

  logic direction; // Direction of the iDMA channel: 0 -> AXI2OBI; 1 -> OBI2AXI  
  logic [11:0] reg_offset;
  logic is_valid_access;
  logic is_address_in_range;
  
  idma_fe_reg_req_t selected_idma_req;
  idma_fe_reg_rsp_t selected_idma_rsp;

/*******************************************************/
/**          Internal Signal Definitions End          **/
/*******************************************************/
/**            Address Decoding Beginning             **/
/*******************************************************/

  // Address range validation - check if address is within iDMA control space
  assign is_address_in_range = (obi_req_i.a.addr >= IDMA_BASE_ADDR) && 
                               (obi_req_i.a.addr <= IDMA_END_ADDR);

  // Address decoding - check if address is in OBI2AXI range (+0x200 offset)
  assign direction = (obi_req_i.a.addr >= (IDMA_BASE_ADDR + DIRECTION_OFFSET)) ? 1'b1 : 1'b0;
  assign reg_offset = direction ? 
                      (obi_req_i.a.addr[11:0] - IDMA_BASE_ADDR[11:0] - DIRECTION_OFFSET[11:0]) : 
                      (obi_req_i.a.addr[11:0] - IDMA_BASE_ADDR[11:0]);
  
  // Validate access: must be in address range AND at known register offset
  assign is_valid_access = is_address_in_range && (
                          (reg_offset == IDMA_CONFIG_OFFSET) ||
                          // Status registers (multireg 0x4-0x40, step 4)
                          ((reg_offset >= 12'h4) && (reg_offset <= 12'h40) && ((reg_offset & 12'h3) == 12'h0)) ||
                          // Next ID registers (multireg 0x44-0x80, step 4)
                          ((reg_offset >= 12'h44) && (reg_offset <= 12'h80) && ((reg_offset & 12'h3) == 12'h0)) ||
                          // Done ID registers (multireg 0x84-0xc0, step 4)
                          ((reg_offset >= 12'h84) && (reg_offset <= 12'hc0) && ((reg_offset & 12'h3) == 12'h0)) ||
                          // Configuration registers at specific skipto addresses
                          (reg_offset == IDMA_DST_ADDR_LOW_OFFSET) ||
                          (reg_offset == IDMA_SRC_ADDR_LOW_OFFSET) ||
                          (reg_offset == IDMA_LENGTH_LOW_OFFSET) ||
                          (reg_offset == IDMA_DST_STRIDE_2_LOW_OFFSET) ||
                          (reg_offset == IDMA_SRC_STRIDE_2_LOW_OFFSET) ||
                          (reg_offset == IDMA_REPS_2_LOW_OFFSET) ||
                          (reg_offset == IDMA_DST_STRIDE_3_LOW_OFFSET) ||
                          (reg_offset == IDMA_SRC_STRIDE_3_LOW_OFFSET) ||
                          (reg_offset == IDMA_REPS_3_LOW_OFFSET)
                          );

/*******************************************************/
/**               Address Decoding End                **/
/*******************************************************/
/**            Channel Selection Beginning            **/
/*******************************************************/

  // Channel demultiplexer
  always_comb begin: channel_demux
    // Default assignments
    idma_axi2obi_req_o = '0;
    idma_obi2axi_req_o = '0;
    selected_idma_rsp = '0;
    
    if (is_valid_access && obi_req_i.req) begin
      if (direction) begin  // OBI2AXI channel (L1->L2)
        idma_obi2axi_req_o = selected_idma_req;
        selected_idma_rsp = idma_obi2axi_rsp_i;
      end else begin        // AXI2OBI channel (L2->L1)
        idma_axi2obi_req_o = selected_idma_req;
        selected_idma_rsp = idma_axi2obi_rsp_i;
      end
    end
  end

/*******************************************************/
/**               Channel Selection End               **/
/*******************************************************/
/**            OBI Protocol Handling Beginning       **/
/*******************************************************/

  // Convert OBI transaction to iDMA register access
  always_comb begin: obi_to_idma_reg
    selected_idma_req.addr = {20'h0, reg_offset}; // Use only offset for iDMA frontend
    selected_idma_req.write = obi_req_i.a.we;
    selected_idma_req.wdata = obi_req_i.a.wdata;
    selected_idma_req.wstrb = obi_req_i.a.be;
    selected_idma_req.valid = obi_req_i.req && is_valid_access;
  end

  // OBI response - purely combinatorial like XIF interface
  always_comb begin: idma_reg_to_obi
    // Grant immediately for valid requests (OBI protocol requirement)
    obi_rsp_o.gnt = obi_req_i.req && is_valid_access;
    
    // Response valid when iDMA is ready to respond (both read and write)
    obi_rsp_o.rvalid = selected_idma_rsp.ready && is_valid_access;
    
    // Read data directly from iDMA response (writes return 0)
    obi_rsp_o.r.rdata = selected_idma_rsp.rdata;
    obi_rsp_o.r.r_optional = '0;
    obi_rsp_o.r.err = selected_idma_rsp.error || !is_valid_access;
    obi_rsp_o.r.rid = '0;
  end

/*******************************************************/
/**              OBI Protocol Handling End           **/
/*******************************************************/
/**            Debug Display Statements              **/
/*******************************************************/


endmodule: idma_obi_ctrl_decoder