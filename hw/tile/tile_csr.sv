/*
 * Tile CSR wrapper — single OBI port, GVSoC-compatible register map.
 * Internally demuxes to obi_slave_ctrl_spatz and obi_slave_ctrl_cluster.
 *
 * Register map (offsets from BaseAddr):
 *   0x00–0x18  Spatz registers   (handled by obi_slave_ctrl_spatz)
 *   0x40–0x44  PULP/Cluster regs (handled by obi_slave_ctrl_cluster)
 */
module tile_csr
  import magia_tile_pkg::*;
#(
   parameter logic [31:0] BaseAddr   = 32'h00001700,
   parameter int unsigned BOOT_ADDR  = 32'hCC000000
)  (
  input  logic                                        clk_i,
  input  logic                                        rst_ni,

  // Single OBI slave interface
  input  core_obi_data_req_t                          obi_req_i,
  output core_obi_data_rsp_t                          obi_rsp_o,

  // Spatz Control outputs
  output logic                                        spatz_clk_en_o,
  output logic                                        spatz_start_o,
  output logic                                        spatz_done_o,

  // Cluster Control outputs
  output logic [magia_tile_pkg::N_CLUSTER_CORES-1:0]  cluster_clk_en_o,
  output logic [31:0]                                 cluster_boot_addr_o  [magia_tile_pkg::N_CLUSTER_CORES-1:0],
  output logic [magia_tile_pkg::N_CLUSTER_CORES-1:0]  cluster_fetch_en_o,
  output logic                                        cluster_done_o
);

  // ============================================
  // Internal OBI signals for sub-modules
  // ============================================
  core_obi_data_rsp_t spatz_obi_rsp;
  core_obi_data_rsp_t cluster_obi_rsp;

  // Both sub-modules receive the same OBI request.
  // Each checks addr_valid against its own BaseAddr/range,
  // so only one will grant at a time.

  // ============================================
  // Spatz control registers (offset 0x00–0x18)
  // ============================================
  obi_slave_ctrl_spatz #(
    .BaseAddr  ( BaseAddr )
  ) i_spatz_ctrl (
    .clk_i     ( clk_i          ),
    .rst_ni    ( rst_ni         ),
    .obi_req_i ( obi_req_i      ),
    .obi_rsp_o ( spatz_obi_rsp  ),
    .clk_en_o  ( spatz_clk_en_o ),
    .start_o   ( spatz_start_o  ),
    .done_o    ( spatz_done_o   )
  );

  // ============================================
  // Cluster control registers (offset 0x40–0x44)
  // ============================================
  obi_slave_ctrl_cluster #(
    .BaseAddr   ( BaseAddr + 32'h40 ),
    .BOOT_ADDR  ( BOOT_ADDR         )
  ) i_cluster_ctrl (
    .clk_i       ( clk_i              ),
    .rst_ni      ( rst_ni             ),
    .obi_req_i   ( obi_req_i          ),
    .obi_rsp_o   ( cluster_obi_rsp    ),
    .clk_en_o    ( cluster_clk_en_o   ),
    .boot_addr_o ( cluster_boot_addr_o),
    .fetch_en_o  ( cluster_fetch_en_o ),
    .done_o      ( cluster_done_o     )
  );

  // ============================================
  // OBI response mux
  // ============================================
  // Non-overlapping address ranges guarantee at most one
  // sub-module grants/responds at a time.
  assign obi_rsp_o.gnt    = spatz_obi_rsp.gnt    | cluster_obi_rsp.gnt;
  assign obi_rsp_o.rvalid = spatz_obi_rsp.rvalid  | cluster_obi_rsp.rvalid;
  assign obi_rsp_o.r.rdata      = spatz_obi_rsp.rvalid ? spatz_obi_rsp.r.rdata : cluster_obi_rsp.r.rdata;
  assign obi_rsp_o.r.rid        = '0;
  assign obi_rsp_o.r.err        = spatz_obi_rsp.r.err | cluster_obi_rsp.r.err;
  assign obi_rsp_o.r.r_optional = '0;

endmodule