// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Convert TCDM to OBI protocol by cascading conversion modules.

module tcdm2obi
  import magia_tile_pkg::*;
#(
  parameter int unsigned AddrWidth = 32,
  parameter int unsigned DataWidth = 32,
  parameter int unsigned MaxTrans = 4,
  parameter type tcdm_req_t = logic,
  parameter type tcdm_rsp_t = logic,
  parameter type obi_req_t  = logic,
  parameter type obi_rsp_t  = logic,
  parameter type reqrsp_req_t = logic,
  parameter type reqrsp_rsp_t = logic
) (
  input  logic      clk_i,
  input  logic      rst_ni,
  input  logic      testmode_i,
  input  tcdm_req_t tcdm_req_i,
  output tcdm_rsp_t tcdm_rsp_o,
  output obi_req_t  obi_req_o,
  input  obi_rsp_t  obi_rsp_i
);

  // Intermediate reqrsp signals
  reqrsp_req_t reqrsp_req;
  reqrsp_rsp_t reqrsp_rsp;
  
  // Step 1: TCDM → reqrsp
  tcdm2reqrsp #(
    .AddrWidth     ( AddrWidth     ),
    .DataWidth     ( DataWidth     ),
    .tcdm_req_t    ( tcdm_req_t    ),
    .tcdm_rsp_t    ( tcdm_rsp_t    ),
    .reqrsp_req_t  ( reqrsp_req_t  ),
    .reqrsp_rsp_t  ( reqrsp_rsp_t  )
  ) i_tcdm2reqresp (
    .tcdm_req_i    ( tcdm_req_i    ),
    .tcdm_rsp_o    ( tcdm_rsp_o    ),
    .reqrsp_req_o  ( reqrsp_req    ),
    .reqrsp_rsp_i  ( reqrsp_rsp    )
  );
  
  // Step 2: reqrsp → OBI
  reqrsp2obi #(
    .ObiCfg        ( magia_tile_pkg::obi_amo_cfg           ),
    .MaxTrans      ( MaxTrans                              ),
    .AddrWidth     ( AddrWidth                             ),
    .DataWidth     ( DataWidth                             ),
    .reqrsp_req_t  ( reqrsp_req_t                          ),
    .reqrsp_rsp_t  ( reqrsp_rsp_t                          ),
    .obi_req_t     ( obi_req_t                             ),
    .obi_rsp_t     ( obi_rsp_t                             ),
    .obi_a_chan_t  ( magia_tile_pkg::core_data_obi_a_chan_t ),
    .obi_r_chan_t  ( magia_tile_pkg::core_data_obi_r_chan_t )
  ) i_reqrsp2obi (
    .clk_i         ( clk_i         ),
    .rst_ni        ( rst_ni        ),
    .testmode_i    ( testmode_i    ),
    .reqrsp_req_i  ( reqrsp_req    ),
    .reqrsp_rsp_o  ( reqrsp_rsp    ),
    .obi_req_o     ( obi_req_o     ),
    .obi_rsp_i     ( obi_rsp_i     )
  );

endmodule
