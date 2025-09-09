/*
 * Copyright (C) 2023-2024 ETH Zurich and University of Bologna
 *
 * Licensed under the Solderpad Hardware License, Version 0.51 
 * (the "License"); you may not use this file except in compliance 
 * with the License. You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * SPDX-License-Identifier: SHL-0.51
 *
 * Authors: Victor Isachi <victor.isachi@unibo.it>
 * 
 * Aliases for interfaces used by MAGIA
 */

`ifndef MAGIA_MESH_ALIAS_
`define MAGIA_MESH_ALIAS_

`define AXI_ALIAS(__src_name, __dst_name, __src_req, __dst_req, __src_rsp, __dst_rsp) \
  typedef __src_req              __dst_req;                                           \
  typedef __src_rsp              __dst_rsp;                                           \
  typedef __src_name``_aw_chan_t __dst_name``_aw_chan_t;                              \
  typedef __src_name``_w_chan_t  __dst_name``_w_chan_t;                               \
  typedef __src_name``_b_chan_t  __dst_name``_b_chan_t;                               \
  typedef __src_name``_ar_chan_t __dst_name``_ar_chan_t;                              \
  typedef __src_name``_r_chan_t  __dst_name``_r_chan_t;

`endif /*MAGIA_MESH_ALIAS_*/