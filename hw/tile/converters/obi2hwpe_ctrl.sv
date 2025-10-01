module obi2hwpe_ctrl
  import magia_tile_pkg::*;
(
  //OBI side
  input  core_obi_data_req_t obi_req_i,
  output core_obi_data_rsp_t obi_rsp_o,

  //HWPE-ctrl (RedMulE) side
  output redmule_ctrl_req_t  ctrl_req_o,
  input  redmule_ctrl_rsp_t  ctrl_rsp_i
);

  // ------------------------
  // Address channel mapping
  // ------------------------
  assign ctrl_req_o.req    = obi_req_i.req;
  assign obi_rsp_o.gnt     = ctrl_rsp_i.gnt;  // handshake 1:1

  assign ctrl_req_o.add    = obi_req_i.a.addr;
  assign ctrl_req_o.data   = obi_req_i.a.wdata;
  assign ctrl_req_o.be     = obi_req_i.a.be;
  assign ctrl_req_o.wen    = ~obi_req_i.a.we; // inversione semantica
  assign ctrl_req_o.id     = '0; // OBI doesn't have ID in this config

  // ------------------------
  // Response channel mapping  
  // ------------------------
  assign obi_rsp_o.rvalid   = ctrl_rsp_i.r_valid;

  assign obi_rsp_o.r.rdata  = ctrl_rsp_i.r_data;
  assign obi_rsp_o.r.err    = 1'b0; // RedMulE ctrl no errors


endmodule

