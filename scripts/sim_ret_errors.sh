#!/usr/bin/env bash

# Copyright 2025 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE.SHL for details.
# SPDX-License-Identifier: SHL-0.51

# Author: Alessandro Nadalini <alessandro.nadalini3@unibo.it>

set -u

if [ $# -lt 1 ]; then
  echo "Usage: $0 <logfile>" >&2
  exit 2
fi

logfile=$1
if [ ! -f "$logfile" ]; then
  echo "File not found: $logfile" >&2
  exit 2
fi

total=0
matched=0

# Try to collect per-test lines first ("Finished test with N error(s)")
finished_nums=$(
  grep -Eio 'Finished[[:space:]]+test[[:space:]]+with[[:space:]]+[0-9]+[[:space:]]+error(s)?' "$logfile" 2>/dev/null \
  | grep -Eo '[0-9]+' 2>/dev/null
)

if [ -n "${finished_nums:-}" ]; then
  matched=1
  # Sum N over all matches
  while IFS= read -r n; do
    [ -n "$n" ] && total=$(( total + n ))
  done <<< "$finished_nums"
else
  # Fallback: use "Errors: N" summary lines
  summary_nums=$(
    grep -Eio 'Errors:[[:space:]]*[0-9]+' "$logfile" 2>/dev/null \
    | grep -Eo '[0-9]+' 2>/dev/null
  )
  if [ -n "${summary_nums:-}" ]; then
    matched=1
    while IFS= read -r n; do
      [ -n "$n" ] && total=$(( total + n ))
    done <<< "$summary_nums"
  fi
fi

# Ignore any "SIMULATION FINISHED WITH EXIT CODE: ..."

if [ "$matched" -eq 0 ]; then
  echo "No recognizable error counters found; cannot determine result." >&2
  exit 2
fi

if [ "$total" -eq 0 ]; then
  echo "Test passed! Total errors: $total"
  exit 0
else
  echo "Test failed: Total errors: $total"
  exit 1
fi
