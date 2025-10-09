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
 * Authors: Luca Balboni <luca.balboni10@studio.unibo.it>
 *          Based on fractal_sync_xif_inst_decoder by Victor Isachi
 *
 * OBI Slave Fractal Sync Memory-Mapped Controller
 * Replaces XIF interface with memory-mapped register access
 */

module obi_slave_fsync 
  import magia_tile_pkg::*;
  import magia_pkg::*;
#(
  parameter logic [ADDR_W-1:0] BASE_ADDR    = 32'h0000_0700,  // Base address for FSYNC registers
  parameter int unsigned       AGGR_W       = magia_tile_pkg::FSYNC_AGGR_W,
  parameter int unsigned       ID_W         = magia_tile_pkg::FSYNC_ID_W,
  parameter int unsigned       NBR_AGGR_W   = magia_tile_pkg::FSYNC_NBR_AGGR_W,
  parameter int unsigned       NBR_ID_W     = magia_tile_pkg::FSYNC_NBR_ID_W,
  parameter type obi_req_t     = magia_tile_pkg::core_obi_data_req_t,
  parameter type obi_rsp_t     = magia_tile_pkg::core_obi_data_rsp_t
)(
  input  logic                 clk_i,
  input  logic                 rst_ni,
  input  logic                 clear_i,

  input  obi_req_t             obi_req_i,
  output obi_rsp_t             obi_rsp_o,

  fractal_sync_if.mst_port     ht_fsync_if_o,
  fractal_sync_if.mst_port     hn_fsync_if_o,
  fractal_sync_if.mst_port     vt_fsync_if_o,
  fractal_sync_if.mst_port     vn_fsync_if_o,

  output logic                 done_o,
  output logic                 error_o
);

/*******************************************************/
/**       Internal Signal Definitions Beginning       **/
/*******************************************************/

  logic clk_sync_en, clk_reg_en;
  logic clk_sync_g, clk_reg_g;
  
  logic sync_trigger;
  logic done;
  logic addr_match;

  logic[DATA_W-1:0] aggr_reg, id_reg, status_reg, control_reg;
  
  typedef enum logic[1:0] {
    IDLE,
    SYNC,
    WAIT,
    DONE
  } sync_state_e;

  sync_state_e c_sync_state, n_sync_state;

  // Memory Map:
  // BASE_ADDR + 0x00: AGGR_REG (write-only)
  // BASE_ADDR + 0x04: ID_REG (write-only)  
  // BASE_ADDR + 0x08: CONTROL_REG (write-only, writing triggers sync)
  // BASE_ADDR + 0x0C: STATUS_REG (read-only)
  localparam logic [ADDR_W-1:0] AGGR_REG_OFFSET    = 4'h0;
  localparam logic [ADDR_W-1:0] ID_REG_OFFSET      = 4'h4;
  localparam logic [ADDR_W-1:0] CONTROL_REG_OFFSET = 4'h8;
  localparam logic [ADDR_W-1:0] STATUS_REG_OFFSET  = 4'hC;

/*******************************************************/
/**          Internal Signal Definitions End          **/
/*******************************************************/
/**            Hardwired Signals Beginning            **/
/*******************************************************/

  assign addr_match = (obi_req_i.a.addr >= BASE_ADDR) && 
                      (obi_req_i.a.addr < BASE_ADDR + 32'h100);

  assign done_o  = done;
  assign error_o = ht_fsync_if_o.error | hn_fsync_if_o.error | 
                   vt_fsync_if_o.error | vn_fsync_if_o.error;

  // Status register: bit 0 = done, bit 1 = error, bit 2 = busy  
  // For polling: when busy=0, operation is complete
  assign status_reg = {29'b0, (c_sync_state == SYNC || c_sync_state == WAIT), error_o, done};

/*******************************************************/
/**               Hardwired Signals End               **/
/*******************************************************/
/**               Clock gating Beginning              **/
/*******************************************************/

  tc_clk_gating i_reg_clock_gating (
    .clk_i                   ,
    .en_i      ( clk_reg_en ),
    .test_en_i ( '0         ),
    .clk_o     ( clk_reg_g  )
  );

  tc_clk_gating i_sync_clock_gating (
    .clk_i                    ,
    .en_i      ( clk_sync_en ),
    .test_en_i ( '0          ),
    .clk_o     ( clk_sync_g  )
  );

/*******************************************************/
/**                  Clock gating End                 **/
/*******************************************************/
/**            OBI Interface Logic Beginning          **/
/*******************************************************/

  always_comb begin: obi_interface
    obi_rsp_o = '0;
    sync_trigger = 1'b0;
    clk_reg_en = 1'b0;

    if (obi_req_i.req && addr_match) begin
      obi_rsp_o.gnt = 1'b1;
      obi_rsp_o.rvalid = 1'b1;
      clk_reg_en = 1'b1;  // Enable clock for OBI register access
      
      if (obi_req_i.a.we) begin
        // Write operation
        case (obi_req_i.a.addr - BASE_ADDR)
          CONTROL_REG_OFFSET: begin
            sync_trigger = 1'b1;  // Writing to control register triggers sync
          end
          default: begin
            // Writes to AGGR_REG and ID_REG are handled in register logic
          end
        endcase
      end else begin
        // Read operation
        case (obi_req_i.a.addr - BASE_ADDR)
          STATUS_REG_OFFSET: begin
            obi_rsp_o.r.rdata = status_reg;
          end
          default: begin
            obi_rsp_o.r.rdata = 32'h0;  // Return 0 for write-only registers
          end
        endcase
      end
    end
  end

/*******************************************************/
/**               OBI Interface Logic End             **/
/*******************************************************/
/**               Register Logic Beginning            **/
/*******************************************************/

  always_ff @(posedge clk_reg_g, negedge rst_ni) begin: configuration_registers
    if (~rst_ni) begin
      aggr_reg <= '0;
      id_reg   <= '0;
    end else begin
      if (clear_i) begin
        aggr_reg <= '0;
        id_reg   <= '0;
      end else if (obi_req_i.req && addr_match && obi_req_i.a.we) begin
        case (obi_req_i.a.addr - BASE_ADDR)
          AGGR_REG_OFFSET: begin
            aggr_reg <= obi_req_i.a.wdata;
          end
          ID_REG_OFFSET: begin
            id_reg <= obi_req_i.a.wdata;
          end
        endcase
      end
    end
  end

/*******************************************************/
/**                  Register Logic End               **/
/*******************************************************/
/**           Synchronization FSM Beginning           **/
/*******************************************************/

  always_comb begin: sync_logic
    n_sync_state         = c_sync_state;
    clk_sync_en          = 1'b1;
    done                 = 1'b0;
    ht_fsync_if_o.sync   = 1'b0;
    ht_fsync_if_o.aggr   = '0;
    ht_fsync_if_o.id_req = '0;
    hn_fsync_if_o.sync   = 1'b0;
    hn_fsync_if_o.aggr   = '0;
    hn_fsync_if_o.id_req = '0;
    vt_fsync_if_o.sync   = 1'b0;
    vt_fsync_if_o.aggr   = '0;
    vt_fsync_if_o.id_req = '0;
    vn_fsync_if_o.sync   = 1'b0;
    vn_fsync_if_o.aggr   = '0;
    vn_fsync_if_o.id_req = '0;

    case (c_sync_state)
      IDLE: begin
        if (sync_trigger) begin
          n_sync_state = SYNC;
        end else begin
          clk_sync_en = 1'b0;
        end
      end
      
      SYNC: begin
        n_sync_state = WAIT;
        if (aggr_reg != 1) begin // Tree (level > 1) request
          case (id_reg[0])
            1'b0: begin                                           // Horizontal tree node request
              ht_fsync_if_o.sync   = 1'b1; 
              ht_fsync_if_o.aggr   = aggr_reg[AGGR_W-1:0];
              ht_fsync_if_o.id_req = id_reg[ID_W-1:0];
            end  
            1'b1: begin                                           // Vertical tree node request
              vt_fsync_if_o.sync   = 1'b1; 
              vt_fsync_if_o.aggr   = aggr_reg[AGGR_W-1:0];
              vt_fsync_if_o.id_req = id_reg[ID_W-1:0];
            end
          endcase
        end else begin                                            // Neighbor (level = 1) request
          case (id_reg[1:0])
            2'b00: begin                                          // Horizontal tree node request
              ht_fsync_if_o.sync   = 1'b1; 
              ht_fsync_if_o.aggr   = aggr_reg[AGGR_W-1:0];
              ht_fsync_if_o.id_req = id_reg[ID_W-1:0];
            end  
            2'b01: begin                                          // Vertical tree node request
              vt_fsync_if_o.sync   = 1'b1; 
              vt_fsync_if_o.aggr   = aggr_reg[AGGR_W-1:0];
              vt_fsync_if_o.id_req = id_reg[ID_W-1:0];
            end
            2'b10: begin                                          // Horizontal neighbor node request
              hn_fsync_if_o.sync   = 1'b1; 
              hn_fsync_if_o.aggr   = aggr_reg[NBR_AGGR_W-1:0];
              hn_fsync_if_o.id_req = id_reg[NBR_ID_W-1:0];
            end  
            2'b11: begin                                          // Vertical neighbor node request
              vn_fsync_if_o.sync   = 1'b1; 
              vn_fsync_if_o.aggr   = aggr_reg[NBR_AGGR_W-1:0];
              vn_fsync_if_o.id_req = id_reg[NBR_ID_W-1:0];
            end
          endcase
        end
      end
      
      WAIT: begin
        if (ht_fsync_if_o.wake | hn_fsync_if_o.wake | vt_fsync_if_o.wake | vn_fsync_if_o.wake) begin
          n_sync_state = DONE;
        end else begin
          n_sync_state = WAIT;
        end
      end
      
      DONE: begin
        n_sync_state = IDLE;
        done         = 1'b1;
      end
    endcase
  end

  always_ff @(posedge clk_sync_g, negedge rst_ni) begin: sync_state
    if (~rst_ni)   c_sync_state <= IDLE;
    else begin
      if (clear_i) c_sync_state <= IDLE;
      else         c_sync_state <= n_sync_state;
    end
  end

/*******************************************************/
/**              Synchronization FSM End              **/
/*******************************************************/

endmodule: obi_slave_fsync