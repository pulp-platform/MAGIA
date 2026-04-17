# Copyright (C) 2022-2023 ETH Zurich and University of Bologna
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-License-Identifier: Apache-2.0

synth_targs += -t rtl
synth_targs += -t redmule_hwpe
synth_targs += -t asic
synth_targs += -t synopsys
synth_targs += -t spatz

synth_defs += -D REDMULE_HWPE_SYNTH
synth_defs += -D SYNTHESIS
synth_defs += -D TARGET_SPATZ
synth_defs += -D SPATZ_RVD=$(SPATZ_RVD)
synth_defs += -D SPATZ_VLEN=$(SPATZ_VLEN)
synth_defs += -D SPATZ_NRVREG=$(SPATZ_NRVREG)
synth_defs += -D SPATZ_NR_VRF_BANKS=$(SPATZ_NR_VRF_BANKS)
synth_defs += -D SPATZ_N_IPU=$(SPATZ_N_IPU)
synth_defs += -D SPATZ_N_FPU=$(SPATZ_N_FPU)
synth_defs += -D SPATZ_NR_PARALLEL_INSTR=$(SPATZ_NR_PARALLEL_INSTR)
synth_defs += -D SPATZ_XDIVSQRT=$(SPATZ_XDIVSQRT)
synth_defs += -D SPATZ_XDMA=$(SPATZ_XDMA)
synth_defs += -D SPATZ_RVF=$(SPATZ_RVF)
synth_defs += -D SPATZ_RVV=$(SPATZ_RVV)