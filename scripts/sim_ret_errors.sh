#!/usr/bin/env bash

# Usage: ./check_errors.sh <logfile>

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <logfile>"
  exit 2
fi

logfile="$1"
if [[ ! -f "$logfile" ]]; then
  echo "File not found: $logfile"
  exit 2
fi

# Be tolerant on spacing and the trailing word (error / errors / error(s))
# Filter candidate lines, then parse counts robustly.
mapfile -t lines < <(grep -E "Finished[[:space:]]+test[[:space:]]+with[[:space:]]+[0-9]+" "$logfile" || true)

if [[ ${#lines[@]} -eq 0 ]]; then
  echo "No matching lines found in $logfile"
  exit 2
fi

exit_code=0
total=0
nonzero=0

for line in "${lines[@]}"; do
  # Extract the number immediately following "... Finished test with "
  # No look-aheads; just capture the first group of digits after the phrase.
  num=$(sed -nE 's/.*Finished[[:space:]]+test[[:space:]]+with[[:space:]]+([0-9]+).*/\1/p' <<< "$line")

  if [[ -z "$num" ]]; then
    echo "Could not parse error count in line: $line"
    exit 2
  fi

  #echo "Found $num error(s) in line: $line"

  (( total += num ))
  if (( num != 0 )); then
    exit_code=1
    (( nonzero++ ))
  fi
done

if (( exit_code == 0 )); then
  echo "Test passed! Total errors: $total"
else
  echo "Test failed: Total errors: $total"
fi

exit $exit_code
