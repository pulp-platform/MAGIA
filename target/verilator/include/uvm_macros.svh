// Copyright 2026 ETH Zurich and University of Bologna
// SPDX-License-Identifier: Apache-2.0
//
// Minimal stand-in for UVM's uvm_macros.svh, for the Verilator flow only.
//
// cv32e40p's tracer (bhv/cv32e40p_tracer.sv) pulls in UVM purely to report
// messages: it includes "uvm_macros.svh", imports uvm_pkg, and calls `uvm_info
// and `uvm_fatal. Nothing else in it touches UVM -- the actual trace output
// goes through $fopen/$fwrite. Verilator has no UVM, so that include alone
// breaks the build whenever CV32E40P_TRACE_EXECUTION is on.
//
// This header supplies just enough to compile: the verbosity enum the tracer
// names (UVM_DEBUG), report functions wrapping $info/$warning/$error/$fatal,
// and macros with UVM's signatures. It is reachable only via the +incdir+ that
// the flow's makefile appends to the Verilator file list, so the QuestaSim flow
// keeps using the real UVM from $UVM_HOME.

`ifndef MAGIA_VERILATOR_UVM_MACROS_SVH
`define MAGIA_VERILATOR_UVM_MACROS_SVH

// Message verbosity cutoff, compared against the level passed to `uvm_info.
// UVM_MEDIUM is what uvm_pkg itself defaults to, so out of the box we print
// exactly what a default UVM run prints -- in particular the tracer's UVM_DEBUG
// messages stay off. Both sides of the comparison are elaboration-time
// constants, so the suppressed call sites fold away and cost nothing at run
// time. Override from the file list with +define+UVM_VERBOSITY=500 to get them.
`ifndef UVM_VERBOSITY
`define UVM_VERBOSITY 200
`endif

package uvm_pkg;

  typedef enum int {
    UVM_NONE   = 0,
    UVM_LOW    = 100,
    UVM_MEDIUM = 200,
    UVM_HIGH   = 300,
    UVM_FULL   = 400,
    UVM_DEBUG  = 500
  } uvm_verbosity;

  // Format matches UVM's report server closely enough that existing log-scraping
  // keeps working. The file/line come from the call site, passed in by the
  // macros; $info's own location would point back into this header.
  function automatic void uvm_report_info(string id, string message, string fname, int lineno);
    $info("UVM_INFO %s(%0d) @ %0t: [%s] %s", fname, lineno, $time, id, message);
  endfunction

  function automatic void uvm_report_warning(string id, string message, string fname, int lineno);
    $warning("UVM_WARNING %s(%0d) @ %0t: [%s] %s", fname, lineno, $time, id, message);
  endfunction

  function automatic void uvm_report_error(string id, string message, string fname, int lineno);
    $error("UVM_ERROR %s(%0d) @ %0t: [%s] %s", fname, lineno, $time, id, message);
  endfunction

  function automatic void uvm_report_fatal(string id, string message, string fname, int lineno);
    $fatal(1, "UVM_FATAL %s(%0d) @ %0t: [%s] %s", fname, lineno, $time, id, message);
  endfunction

endpackage : uvm_pkg

// begin/end (rather than a bare call) mirrors the real macros: call sites write
// them both with and without a trailing semicolon, and both must parse.
// uvm_pkg:: is spelled out so the macros also work where it was not imported.

`define uvm_info(ID, MSG, VERBOSITY) \
  begin \
    if ((VERBOSITY) <= `UVM_VERBOSITY) \
      uvm_pkg::uvm_report_info(ID, MSG, `__FILE__, `__LINE__); \
  end

`define uvm_warning(ID, MSG) \
  begin \
    uvm_pkg::uvm_report_warning(ID, MSG, `__FILE__, `__LINE__); \
  end

`define uvm_error(ID, MSG) \
  begin \
    uvm_pkg::uvm_report_error(ID, MSG, `__FILE__, `__LINE__); \
  end

`define uvm_fatal(ID, MSG) \
  begin \
    uvm_pkg::uvm_report_fatal(ID, MSG, `__FILE__, `__LINE__); \
  end

`endif  // MAGIA_VERILATOR_UVM_MACROS_SVH
