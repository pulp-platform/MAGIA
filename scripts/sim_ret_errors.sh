#!/usr/bin/env bash

# Copyright 2025 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE.SHL for details.
# SPDX-License-Identifier: SHL-0.51

# Author: Alessandro Nadalini <alessandro.nadalini3@unibo.it>

LOGFILE="$1"

if [[ ! -f "$LOGFILE" ]]; then
  echo "Error: File not found!"
  exit 2
fi

# Extract the number from the last occurrence of "Errors: N"
errors=$(grep -oP 'Errors:\s*\K[0-9]+' "$LOGFILE" | tail -n 1)

if [[ -z "$errors" ]]; then
  echo "No 'Errors:' pattern found in log file."
  exit 3
fi

# Exit with 1 if errors > 0, else 0
if [[ "$errors" -gt 0 ]]; then
  exit 1
else
  exit 0
fi
