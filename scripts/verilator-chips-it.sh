#!/usr/bin/env bash
# Copyright 2026 ETH Zurich, University of Bologna and Fondazione Chips-IT
# SPDX-License-Identifier: Apache-2.0
#
# Usage: from MAGIA ROOT source: ./scripts/verilator-chips-it.sh
# Then use make normally, for example:
#   make verilate core=CV32E40P/X mesh_dv=1
#   make verilate-run core=CV32E40P/X mesh_dv=1 test='name of test'
#
# PLEASE NOTE THAT !!!!!!!!!
# Requires the existing private lz4 installation in $HOME/opt/lz4.

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  echo 'Use: source .scripts/verilator-chips-it.sh' >&2
  exit 1
fi

if ! type module >/dev/null 2>&1; then
  source /usr/share/Modules/init/bash || return 1
fi

module load verilator/5.050 bender/ \
  corev-gcc/ spatz-llvm/|| return 1
source /opt/rh/gcc-toolset-13/enable || return 1

export CXX=g++ CC=gcc
export LZ4_PREFIX="${LZ4_PREFIX:-$HOME/opt/lz4}"
export VERILATOR_CFLAGS="${VERILATOR_CFLAGS:--std=gnu++20 -march=native -I$LZ4_PREFIX/include}"
case " ${LDFLAGS:-} " in
  *" -L$LZ4_PREFIX/lib "*) ;;
  *) export LDFLAGS="${LDFLAGS:+$LDFLAGS }-L$LZ4_PREFIX/lib" ;;
esac

echo 'CHIPS-IT environment ready. Use make normally.'
