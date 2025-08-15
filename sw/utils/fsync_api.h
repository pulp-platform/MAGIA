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
 * MAGIA FractalSync common synchronization patterns API
 */

#ifndef FSYNC_API_H
#define FSYNC_API_H

  #include "fsync_isa_utils.h"
  #include "magia_tile_utils.h"
  #include "magia_utils.h"

  #define _FS_GLOBAL_AGGR (0xFFFFFFFF >> (1+__builtin_clz(NUM_HARTS)))
  #define _FS_GLOBAL_ID   (-1)
  #define _FS_HNBR_AGGR   (0x1)
  #define _FS_HNBR_ID     (0)
  #define _FS_VNBR_AGGR   (0x1)
  #define _FS_VNBR_ID     (1)

  // Lookup table indicating the number of levels
  static inline uint32_t lvl_lookup(){
    switch (NUM_HARTS){
      case 4:    return 2;
      case 16:   return 4;
      case 64:   return 6;
      case 256:  return 8;
      case 1024: return 10;
    }
  }

  // Lookup table indicating the one-hot encoding of the maximul level
  static inline uint32_t oh_max_lvl_lookup(){
    switch (NUM_HARTS){
      case 4:    return 0b0000000010;
      case 16:   return 0b0000001000;
      case 64:   return 0b0000100000;
      case 256:  return 0b0010000000;
      case 1024: return 0b1000000000;
    }
  }

  // Lookup table indicating the one-hot encoding of the level used by the row/column synchronization routines (one-hot encoding of the penultimate level)
  static inline uint32_t rc_lvl_lookup(){
    switch (NUM_HARTS){
      case 4:    return 0b000000001;
      case 16:   return 0b000000100;
      case 64:   return 0b000010000;
      case 256:  return 0b001000000;
      case 1024: return 0b100000000;
    }
  }

  // Lookup table indicating the aggregate pattern of row/colum synchronization
  static inline uint32_t rc_aggr_lookup(){
    switch (NUM_HARTS){
      case 4:    return 0b0000000;
      case 16:   return 0b0000001;
      case 64:   return 0b0000101;
      case 256:  return 0b0010101;
      case 1024: return 0b1010101;
    }
  }

  // Lookup table indicating the id of row synchronization
  uint32_t row_id_lookup(volatile uint32_t hartid_y){
    if (hartid_y < MESH_Y_TILES/2) return 2*hartid_y;
    else                           return 2*(hartid_y-MESH_Y_TILES/2);
  }

  // Lookup table indicating the id of column synchronization
  uint32_t col_id_lookup(volatile uint32_t hartid_x){
    if (hartid_x < MESH_X_TILES/2) return 2*hartid_x+1;
    else                           return 2*(hartid_x-MESH_X_TILES/2)+1;
  }

  static inline void fsync_hnbr(){
    fsync(_FS_HNBR_ID, _FS_HNBR_AGGR);
  }

  void fsync_h_tor_nbr(){
    uint32_t hartid   = get_hartid();
    uint32_t hartid_x = GET_X_ID(hartid);
    uint32_t hartid_y = GET_Y_ID(hartid);
    if ((hartid_x == 0) || (hartid_x == MESH_X_TILES-1)){
      uint32_t id        = row_id_lookup(hartid_y);
      uint32_t aggregate = rc_lvl_lookup();
      fsync(id, aggregate);
    } else {
      fsync(2, 1);
    }
  }

  static inline void fsync_vnbr(){
    fsync(_FS_VNBR_ID, _FS_VNBR_AGGR);
  }

  void fsync_v_tor_nbr(){
    uint32_t hartid   = get_hartid();
    uint32_t hartid_x = GET_X_ID(hartid);
    uint32_t hartid_y = GET_Y_ID(hartid);
    if ((hartid_y == 0) || (hartid_y == MESH_Y_TILES-1)){
      uint32_t id        = col_id_lookup(hartid_x);
      uint32_t aggregate = rc_lvl_lookup();
      fsync(id, aggregate);
    } else {
      fsync(3, 1);
    }
  }

  void fsync_rows(){
    uint32_t hartid   = get_hartid();
    uint32_t hartid_y = GET_Y_ID(hartid);
    uint32_t id        = row_id_lookup(hartid_y);
    uint32_t aggregate = rc_lvl_lookup() | rc_aggr_lookup();
    fsync(id, aggregate);
  }

  void fsync_cols(){
    uint32_t hartid   = get_hartid();
    uint32_t hartid_x = GET_X_ID(hartid);
    uint32_t id        = col_id_lookup(hartid_x);
    uint32_t aggregate = rc_lvl_lookup() | rc_aggr_lookup();
    fsync(id, aggregate);
  }

  static inline void fsync_global(){
    fsync(_FS_GLOBAL_ID, _FS_GLOBAL_AGGR);
  }

#endif /*FSYNC_API_H*/
