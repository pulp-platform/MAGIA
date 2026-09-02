#!/usr/bin/env bash

# Copyright 2026 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE.SHL for details.
# SPDX-License-Identifier: SHL-0.51

# Verilator counterpart of sim_ret_errors.sh. QuestaSim prints an "Errors: N"
# summary; Verilator prints nothing of the sort, so the verdict comes from the
# testbench's own end-of-simulation line instead.
#
# The process exit code is not enough on its own: magia_main.cpp also returns 0
# when the model simply runs out of events without reaching $finish, which is
# what a hung or wedged simulation looks like. So a missing line is its own
# outcome rather than a pass.
#
#   0  simulation finished with exit code 0
#   1  simulation finished with a non-zero exit code, or Verilator errored out
#   2  log file not found
#   3  no end-of-simulation line at all (never reached $finish: hung, killed,
#      or the model died before the testbench could report)

LOGFILE="$1"

if [[ ! -f "$LOGFILE" ]]; then
  echo "Error: File not found!"
  exit 2
fi

# Last occurrence wins, matching sim_ret_errors.sh.
code=$(grep -oP 'SIMULATION FINISHED WITH EXIT CODE:\s*\K[0-9a-fA-F]+' "$LOGFILE" | tail -n 1)

if [[ -z "$code" ]]; then
  echo "No 'SIMULATION FINISHED WITH EXIT CODE' line found in log file."
  exit 3
fi

# The testbench prints the code with %0h.
if (( 16#$code != 0 )); then
  echo "Simulation finished with exit code 0x$code."
  exit 1
fi

# $fatal aborts before the success line, so reaching here with a Verilator error
# in the log means something else failed after end-of-simulation.
if grep -q '^%Error' "$LOGFILE"; then
  echo "Simulation reported exit code 0 but the log contains Verilator errors."
  exit 1
fi

exit 0
