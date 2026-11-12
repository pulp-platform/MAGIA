/*
 * Copyright (C) 2026 ETH Zurich, University of Bologna and Fondazione Chips-IT
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
 * Author: Luca Balboni, Fondazione Chips-IT
 *
 * magia-sdk eventunit.h on the MAGIA Event Unit utils
 */
#ifndef SDK_SHIM_EVENTUNIT_H
#define SDK_SHIM_EVENTUNIT_H

#include "event_unit_utils.h"

#define POLLING EU_WAIT_MODE_POLLING
#define WFE     EU_WAIT_MODE_WFE

// The MAGIA versions take no IRQ enable: they only arm the event
#define eu_idma_init(enable_irq)  eu_idma_init()
#define eu_spatz_init(enable_irq) eu_spatz_init()
#define eu_idma_wait_a2o(mode)    eu_idma_wait_a2o_completion(mode)
#define eu_spatz_wait(mode)       eu_wait_events(EU_SPATZ_DONE_MASK, (mode), 0xFFFFFFFF)
#define eu_fsync_init(enable_irq) eu_fsync_init()
#define eu_fsync_wait(mode)       eu_fsync_wait_completion(mode)

#endif
