/*
 * Copyright (C) 2023-2024 ETH Zurich and University of Bologna
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
 * Authors: Victor Isachi <victor.isachi@unibo.it>
 * 
 * MAGIA Test NoC/AMO-based synchornization utils
 */

#include "magia_tile_utils.h"
#include "magia_utils.h"
#include "amo_utils.h"
#include "nsync_utils.h"

int main(void) {
  uint32_t hartid = get_hartid();

  printf("Global NoC/AMO-based synchornization start...\n");
  nsync_global(hartid);
  printf("Global NoC/AMO-based synchornization end...\n");

  printf("Row NoC/AMO-based synchornization start...\n");
  nsync_row(hartid);
  printf("Row NoC/AMO-based synchornization end...\n");

  printf("Column NoC/AMO-based synchornization start...\n");
  nsync_col(hartid);
  printf("Column NoC/AMO-based synchornization end...\n");

  return 0;
}
