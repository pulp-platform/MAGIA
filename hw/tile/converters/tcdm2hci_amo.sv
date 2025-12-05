// Copyright 2024 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51


// TCDM to HCI protocol converter with Atomic Memory Operations (AMO) support

module tcdm2hci_amo
  import magia_tile_pkg::*;
#(
  parameter int unsigned AddrWidth = 32,
  parameter int unsigned DataWidth = 32,
  parameter int unsigned MaxTrans  = 4,
  parameter type tcdm_req_t    = logic,
  parameter type tcdm_rsp_t    = logic,
  parameter type hci_req_t     = logic,
  parameter type hci_rsp_t     = logic,
  parameter type reqrsp_req_t  = logic,
  parameter type reqrsp_rsp_t  = logic,
  parameter type obi_req_t     = logic,
  parameter type obi_rsp_t     = logic
) (
  input  logic      clk_i,
  input  logic      rst_ni,
  input  logic      testmode_i,
  
  // TCDM side (master with AMO support)
  input  tcdm_req_t tcdm_req_i,
  output tcdm_rsp_t tcdm_rsp_o,
  
  // HCI side (slave, no AMO - operations resolved in chain)
  output hci_req_t  hci_req_o,
  input  hci_rsp_t  hci_rsp_i
);

  // Intermediate protocol signals
  reqrsp_req_t reqrsp_req;
  reqrsp_rsp_t reqrsp_rsp;
  
  obi_req_t obi_with_atop_req;
  obi_rsp_t obi_with_atop_rsp;
  
  obi_req_t obi_no_atop_req;
  obi_rsp_t obi_no_atop_rsp;
  
  // -------------------------
  // Step 1: TCDM → reqrsp
  // -------------------------
  // Converts TCDM protocol to reqrsp, preserving AMO field
  tcdm2reqrsp #(
    .AddrWidth     ( AddrWidth     ),
    .DataWidth     ( DataWidth     ),
    .tcdm_req_t    ( tcdm_req_t    ),
    .tcdm_rsp_t    ( tcdm_rsp_t    ),
    .reqrsp_req_t  ( reqrsp_req_t  ),
    .reqrsp_rsp_t  ( reqrsp_rsp_t  )
  ) i_tcdm2reqrsp (
    .tcdm_req_i    ( tcdm_req_i    ),
    .tcdm_rsp_o    ( tcdm_rsp_o    ),
    .reqrsp_req_o  ( reqrsp_req    ),
    .reqrsp_rsp_i  ( reqrsp_rsp    )
  );
  
  // -------------------------
  // Step 2: reqrsp → OBI (with atop)
  // -------------------------
  // Converts reqrsp to OBI protocol, AMO field becomes atop field
  reqrsp2obi #(
    .ObiCfg        ( magia_tile_pkg::obi_amo_cfg            ),
    .MaxTrans      ( MaxTrans                               ),
    .AddrWidth     ( AddrWidth                              ),
    .DataWidth     ( DataWidth                              ),
    .reqrsp_req_t  ( reqrsp_req_t                           ),
    .reqrsp_rsp_t  ( reqrsp_rsp_t                           ),
    .obi_req_t     ( obi_req_t                              ),
    .obi_rsp_t     ( obi_rsp_t                              ),
    .obi_a_chan_t  ( magia_tile_pkg::core_data_obi_a_chan_t ),
    .obi_r_chan_t  ( magia_tile_pkg::core_data_obi_r_chan_t )
  ) i_reqrsp2obi (
    .clk_i         ( clk_i             ),
    .rst_ni        ( rst_ni            ),
    .reqrsp_req_i  ( reqrsp_req        ),
    .reqrsp_rsp_o  ( reqrsp_rsp        ),
    .obi_req_o     ( obi_with_atop_req ),
    .obi_rsp_i     ( obi_with_atop_rsp )
  );
  
  // -------------------------
  // Step 3: OBI atop resolver
  // -------------------------
  // Decomposes atomic operations into Read-Modify-Write sequences
  // Input:  OBI with atop field (atomic operations)
  // Output: OBI without atop (simple reads/writes)
  obi_atop_resolver #(
    .SbrPortObiCfg             ( magia_tile_pkg::obi_amo_cfg                ),
    .MgrPortObiCfg             ( obi_pkg::ObiDefaultConfig                  ),
    .sbr_port_obi_req_t        ( obi_req_t                                  ),
    .sbr_port_obi_rsp_t        ( obi_rsp_t                                  ),
    .mgr_port_obi_req_t        ( obi_req_t                                  ),
    .mgr_port_obi_rsp_t        ( obi_rsp_t                                  ),
    .mgr_port_obi_a_optional_t ( magia_tile_pkg::core_data_obi_a_optional_t ),
    .mgr_port_obi_r_optional_t ( magia_tile_pkg::core_data_obi_r_optional_t ),
    .LrScEnable                ( 1'b1                                       ),
    .RegisterAmo               ( 1'b0                                       )
  ) i_obi_atop_resolver (
    .clk_i          ( clk_i            ),
    .rst_ni         ( rst_ni           ),
    .testmode_i     ( testmode_i       ),
    .sbr_port_req_i ( obi_with_atop_req ),
    .sbr_port_rsp_o ( obi_with_atop_rsp ),
    .mgr_port_req_o ( obi_no_atop_req   ),
    .mgr_port_rsp_i ( obi_no_atop_rsp   )
  );
  
  // -------------------------
  // Step 4: OBI → HCI
  // -------------------------
  // Final conversion from OBI (no atomics) to HCI protocol
  // Uses separate req/rsp converters for proper signal mapping
  obi2hci_req #(
    .obi_req_t ( obi_req_t ),
    .hic_req_t ( hci_req_t )
  ) i_obi2hci_req (
    .obi_req_i ( obi_no_atop_req ),
    .hci_req_o ( hci_req_o       )
  );
  
  hci2obi_rsp #(
    .hci_rsp_t ( hci_rsp_t ),
    .obi_rsp_t ( obi_rsp_t )
  ) i_hci2obi_rsp (
    .hci_rsp_i ( hci_rsp_i       ),
    .obi_rsp_o ( obi_no_atop_rsp )
  );

endmodule : tcdm2hci_amo
