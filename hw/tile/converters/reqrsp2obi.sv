// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

/// Convert reqrsp to OBI protocol by cascading reqrsp_to_axi and axi_to_obi.

`include "axi/typedef.svh"

module reqrsp2obi #(
  /// Number of same transactions which can be in-flight simultaneously
  parameter int unsigned MaxTrans = 4,
  /// OBI configuration
  parameter obi_pkg::obi_cfg_t ObiCfg = obi_pkg::ObiDefaultConfig,
  /// Address width
  parameter int unsigned AddrWidth = ObiCfg.AddrWidth,
  /// Data width
  parameter int unsigned DataWidth = ObiCfg.DataWidth,
  /// The request struct of the OBI port
  parameter type obi_req_t = logic,
  /// The response struct of the OBI port
  parameter type obi_rsp_t = logic,
  /// The A struct of the OBI port
  parameter type obi_a_chan_t = logic,
  /// The R struct of the OBI port
  parameter type obi_r_chan_t = logic,
  /// Reqrsp request type
  parameter type reqrsp_req_t = logic,
  /// Reqrsp response type
  parameter type reqrsp_rsp_t = logic
) (
  input  logic        clk_i,
  input  logic        rst_ni,

  input  reqrsp_req_t reqrsp_req_i,
  output reqrsp_rsp_t reqrsp_rsp_o,

  output obi_req_t    obi_req_o,
  input  obi_rsp_t    obi_rsp_i
);

  // Local typedefs for AXI channels (minimal widths for internal conversion)
  typedef logic [AddrWidth-1:0] addr_t;
  typedef logic [DataWidth-1:0] data_t;
  typedef logic [DataWidth/8-1:0] strb_t;
  typedef logic id_t;    
  typedef logic user_t;  

  // AXI channel types
  `AXI_TYPEDEF_AW_CHAN_T(axi_aw_chan_int_t, addr_t, id_t, user_t)
  `AXI_TYPEDEF_W_CHAN_T(axi_w_chan_int_t, data_t, strb_t, user_t)
  `AXI_TYPEDEF_B_CHAN_T(axi_b_chan_int_t, id_t, user_t)
  `AXI_TYPEDEF_AR_CHAN_T(axi_ar_chan_int_t, addr_t, id_t, user_t)
  `AXI_TYPEDEF_R_CHAN_T(axi_r_chan_int_t, data_t, id_t, user_t)
  `AXI_TYPEDEF_REQ_T(axi_req_int_t, axi_aw_chan_int_t, axi_w_chan_int_t, axi_ar_chan_int_t)
  `AXI_TYPEDEF_RESP_T(axi_rsp_int_t, axi_b_chan_int_t, axi_r_chan_int_t)

  // Intermediate AXI signals
  axi_req_int_t axi_req;
  axi_rsp_int_t axi_rsp;

  // Intermediate OBI signals
  obi_req_t obi_req_int;
  obi_rsp_t obi_rsp_int;

  // Reqrsp to AXI conversion
  reqrsp_to_axi #(
    .MaxTrans      ( MaxTrans         ),
    .ID            ( 0                ),
    .DataWidth     ( DataWidth        ),
    .UserWidth     ( 1                ),
    .reqrsp_req_t  ( reqrsp_req_t     ),
    .reqrsp_rsp_t  ( reqrsp_rsp_t     ),
    .axi_req_t     ( axi_req_int_t    ),
    .axi_rsp_t     ( axi_rsp_int_t    )
  ) i_reqrsp_to_axi (
    .clk_i         ( clk_i          ),
    .rst_ni        ( rst_ni         ),
    .user_i        ( '0             ),
    .reqrsp_req_i  ( reqrsp_req_i   ),
    .reqrsp_rsp_o  ( reqrsp_rsp_o   ),
    .axi_req_o     ( axi_req        ),
    .axi_rsp_i     ( axi_rsp        )
  );

  // AXI to OBI conversion
  axi_to_obi #(
    .ObiCfg        ( ObiCfg           ),
    .obi_req_t     ( obi_req_t        ),
    .obi_rsp_t     ( obi_rsp_t        ),
    .obi_a_chan_t  ( obi_a_chan_t     ),
    .obi_r_chan_t  ( obi_r_chan_t     ),
    .AxiAddrWidth  ( AddrWidth        ),
    .AxiDataWidth  ( DataWidth        ),
    .AxiIdWidth    ( 1                ),
    .AxiUserWidth  ( 1                ),
    .MaxTrans      ( MaxTrans         ),
    .axi_req_t     ( axi_req_int_t    ),
    .axi_rsp_t     ( axi_rsp_int_t    )
  ) i_axi_to_obi (
    .clk_i              ( clk_i          ),
    .rst_ni             ( rst_ni         ),
    .testmode_i         ( 1'b0           ),
    .axi_req_i          ( axi_req        ),
    .axi_rsp_o          ( axi_rsp        ),
    .obi_req_o          ( obi_req_int    ),
    .obi_rsp_i          ( obi_rsp_int    ),
    // User assignment signals - tie off to default values
    .req_aw_id_o        (                ),
    .req_aw_user_o      (                ),
    .req_w_user_o       (                ),
    .req_write_aid_i    ( '0             ),
    .req_write_auser_i  ( '0             ),
    .req_write_wuser_i  ( '0             ),
    .req_ar_id_o        (                ),
    .req_ar_user_o      (                ),
    .req_read_aid_i     ( '0             ),
    .req_read_auser_i   ( '0             ),
    .rsp_write_aw_user_o(                ),
    .rsp_write_w_user_o (                ),
    .rsp_write_bank_strb_o(              ),
    .rsp_write_rid_o    (                ),
    .rsp_write_ruser_o  (                ),
    .rsp_write_last_o   (                ),
    .rsp_write_hs_o     (                ),
    .rsp_b_user_i       ( '0             ),
    .rsp_read_ar_user_o (                ),
    .rsp_read_size_enable_o(             ),
    .rsp_read_rid_o     (                ),
    .rsp_read_ruser_o   (                ),
    .rsp_r_user_i       ( '0             )
  );

  /*******************************************************************/
  /*               Initialize OBI Optional Fields                    */
  /*******************************************************************/

  // Pass through core signals
  assign obi_req_o.req       = obi_req_int.req;
  assign obi_req_o.a.addr    = obi_req_int.a.addr;
  assign obi_req_o.a.we      = obi_req_int.a.we;
  assign obi_req_o.a.be      = obi_req_int.a.be;
  assign obi_req_o.a.wdata   = obi_req_int.a.wdata;
  assign obi_req_o.a.aid     = obi_req_int.a.aid;

  // Initialize optional request fields to avoid X propagation
  assign obi_req_o.a.a_optional.auser   = 'b0;
  assign obi_req_o.a.a_optional.wuser   = 'b0;
  assign obi_req_o.a.a_optional.atop    = obi_req_int.a.a_optional.atop; 
  assign obi_req_o.a.a_optional.memtype = 2'b00;  
  assign obi_req_o.a.a_optional.mid     = 'b0;
  assign obi_req_o.a.a_optional.prot    = 3'b000; 
  assign obi_req_o.a.a_optional.dbg     = 1'b0;
  assign obi_req_o.a.a_optional.achk    = 'b0;

  // Pass through response signals
  assign obi_rsp_int.gnt     = obi_rsp_i.gnt;
  assign obi_rsp_int.rvalid  = obi_rsp_i.rvalid;
  assign obi_rsp_int.r.rid   = obi_rsp_i.r.rid;
  assign obi_rsp_int.r.rdata = obi_rsp_i.r.rdata;
  assign obi_rsp_int.r.err   = obi_rsp_i.r.err;

  assign obi_rsp_int.r.r_optional.ruser  = 'b0;
  assign obi_rsp_int.r.r_optional.exokay = 1'b0;
  assign obi_rsp_int.r.r_optional.rchk   = 'b0;

endmodule

