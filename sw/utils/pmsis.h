/*
 * Copyright (C) 2026 Fondazione Chips-IT
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * SPDX-License-Identifier: Apache-2.0
 *
 * MAGIA's "pmsis.h" -- NOT the real PMSIS. PLAY's cluster-side kernel
 * sources (PLAY/source/<kernel>/arch, the "_pulp_open.c" files) #include
 * "pmsis.h" expecting
 * pulp-sdk's PMSIS API. Rather than vendor that whole runtime (device
 * open/close, OS kickoff, DMA, ...), this shim supplies just the handful of
 * symbols those kernel sources actually call -- pi_core_id(),
 * pi_cl_team_barrier(), pi_cl_team_critical_enter()/exit() -- backed by
 * cluster_utils.h's native, bare-metal reimplementation (ported from
 * pulp-sdk's pos/implem/pe.h, ARCHI/HAL-free). Anything from real PMSIS
 * beyond that set (pi_cluster_open, pi_evt_*, PI_L1, DMA, ...) is
 * deliberately absent: a PLAY kernel that needs it will fail to compile
 * here, which is the point -- silent stubs would be worse than a clear
 * "not implemented".
 */

#ifndef MAGIA_PMSIS_H
#define MAGIA_PMSIS_H

#include "cluster_utils.h"

/* PLAY's PI_L2/PI_L1-tagged test_data/data.h files expect these section-
 * placement attributes from real PMSIS. MAGIA has no separate L1/L2
 * "memory device" abstraction to place them with (see magia_tile_utils.h:
 * L1_BASE/L2_BASE are just plain address ranges in one flat space), so they
 * expand to nothing here -- tagged arrays land wherever the compiler's
 * default section placement puts them. */
#define PI_L1
#define PI_L2

#endif /* MAGIA_PMSIS_H */
