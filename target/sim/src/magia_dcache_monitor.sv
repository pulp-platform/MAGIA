/*
 * Copyright (C) 2026 ETH Zurich, University of Bologna and Fondazione Chips-IT
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
 * Authors: Niccolò Giuliani <niccolo.giuliani@chips.it>
 *
 * Data cache monitors for the testbenches, which bind them: the tile RTL is unchanged, and without the data cache
 * they are never instantiated. Both snoop the writes to PERF_CTRL (offset 0x0C) on the data_cc control port: every
 * window between dcache_perf_start() and dcache_perf_stop() is printed when it ends, next to the PERF_* registers
 * the software reads, and the whole simulation is printed at the end.
 * - magia_dcache_monitor (on every data_cc_top): the data_cc event pulses, and how often the order rules between
 *   the narrow hit port and the miss engine stop something:
 *   - miss_hold: the miss engine has a TCDM request on a line with a conflicting hit not done yet (cycles, and
 *     episodes = rising edges);
 *   - refill_wait: a tag store refill waits for the refill writes to be done (cycles, episodes).
 * - magia_dcache_mux_monitor (on every magia_isle): the wait of each cached manager at the input of the cache
 *   obi_mux (req && !gnt). PERF_STALL counts only the wait at the data_cc port, after the mux.
 */

module magia_dcache_monitor #(
  parameter type cfg_req_t = logic,
  parameter type cfg_rsp_t = logic
) (
  input logic                 clk_i,
  input logic                 rst_ni,
  input data_cc_pkg::events_t events_i,
  input cfg_req_t             cfg_req_i,
  input cfg_rsp_t             cfg_rsp_i,
  // order rules of the narrow hit port (always 0 / 1 with the shared port)
  input logic                 miss_req_valid_i,
  input logic                 miss_hold_i,
  input logic                 refill_valid_i,
  input logic                 refill_allowed_i
);

  localparam int unsigned NumEvents   = $bits(data_cc_pkg::events_t);
  localparam int unsigned NumOrder    = 4;
  localparam logic [3:0]  RegPerfCtrl = 4'h3;

  // In the order of data_cc_pkg::events_t, MSB first
  localparam string EventName [NumEvents] = '{"hit_r", "hit_w", "miss_r", "miss_w",
                                              "refill", "writeback", "stall", "tcdm_stall", "prefetch"};
  localparam string OrderName [NumOrder]  = '{"miss_hold_cyc", "miss_hold_evt", "refill_wait_cyc",
                                              "refill_wait_evt"};

  logic [NumEvents-1:0] event_pulse;
  logic [NumOrder-1:0]  order_pulse;
  logic                 hold_active, hold_active_q, refill_wait, refill_wait_q;
  logic                 perf_write, perf_start, perf_stop, perf_en_q;
  longint unsigned      event_cnt     [NumEvents];
  longint unsigned      event_cnt_win [NumEvents];
  longint unsigned      order_cnt     [NumOrder];
  longint unsigned      order_cnt_win [NumOrder];
  longint unsigned      win_cyc;
  int unsigned          win_idx;

  assign event_pulse = events_i;
  assign hold_active = miss_req_valid_i && miss_hold_i;
  assign refill_wait = refill_valid_i && !refill_allowed_i;
  assign order_pulse = {hold_active, hold_active && !hold_active_q, refill_wait, refill_wait && !refill_wait_q};

  assign perf_write = cfg_req_i.req && cfg_rsp_i.gnt && cfg_req_i.a.we && (cfg_req_i.a.addr[5:2] == RegPerfCtrl);
  assign perf_start = perf_write && cfg_req_i.a.wdata[0] && !perf_en_q;
  assign perf_stop  = perf_write && !cfg_req_i.a.wdata[0] && perf_en_q;

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      hold_active_q <= 1'b0;
      refill_wait_q <= 1'b0;
      perf_en_q     <= 1'b0;
      win_cyc       <= 0;
      win_idx       <= 0;
      for (int unsigned e = 0; e < NumEvents; e++) begin
        event_cnt[e]     <= 0;
        event_cnt_win[e] <= 0;
      end
      for (int unsigned o = 0; o < NumOrder; o++) begin
        order_cnt[o]     <= 0;
        order_cnt_win[o] <= 0;
      end
    end else begin
      hold_active_q <= hold_active;
      refill_wait_q <= refill_wait;
      for (int unsigned e = 0; e < NumEvents; e++) begin
        if (event_pulse[NumEvents-1-e]) begin
          event_cnt[e] <= event_cnt[e] + 1;
        end
      end
      for (int unsigned o = 0; o < NumOrder; o++) begin
        if (order_pulse[NumOrder-1-o]) begin
          order_cnt[o] <= order_cnt[o] + 1;
        end
      end
      // Window counters: cleared when the window opens, counted while it is open, printed when it closes
      if (perf_start) begin
        perf_en_q <= 1'b1;
        win_cyc   <= 0;
        for (int unsigned e = 0; e < NumEvents; e++) begin
          event_cnt_win[e] <= 0;
        end
        for (int unsigned o = 0; o < NumOrder; o++) begin
          order_cnt_win[o] <= 0;
        end
      end else if (perf_en_q) begin
        win_cyc <= win_cyc + 1;
        for (int unsigned e = 0; e < NumEvents; e++) begin
          if (event_pulse[NumEvents-1-e]) begin
            event_cnt_win[e] <= event_cnt_win[e] + 1;
          end
        end
        for (int unsigned o = 0; o < NumOrder; o++) begin
          if (order_pulse[NumOrder-1-o]) begin
            order_cnt_win[o] <= order_cnt_win[o] + 1;
          end
        end
      end
      if (perf_stop) begin
        string line;
        perf_en_q <= 1'b0;
        win_idx   <= win_idx + 1;
        line      = "";
        for (int unsigned e = 0; e < NumEvents; e++) begin
          line = {line, $sformatf(" %s=%0d", EventName[e], event_cnt_win[e])};
        end
        for (int unsigned o = 0; o < NumOrder; o++) begin
          line = {line, $sformatf(" %s=%0d", OrderName[o], order_cnt_win[o])};
        end
        $display("[DCACHE_WIN] %m: win=%0d cycles=%0d%s", win_idx, win_cyc, line);
      end
    end
  end

  final begin
    string line;
    line = "";
    for (int unsigned e = 0; e < NumEvents; e++) begin
      line = {line, $sformatf(" %s=%0d", EventName[e], event_cnt[e])};
    end
    $display("[DCACHE] %m:%s", line);
    line = "";
    for (int unsigned o = 0; o < NumOrder; o++) begin
      line = {line, $sformatf(" %s=%0d", OrderName[o], order_cnt[o])};
    end
    $display("[DCACHE_ORDER] %m:%s", line);
  end

endmodule: magia_dcache_monitor

/*
 * MSHR and lookup monitor: while the performance counters are enabled (PERF_CTRL), it counts MSHR occupancy, the
 * lookup stalls and the parks, and prints them each time the counters are stopped (one window per
 * dcache_perf_start()/dcache_perf_stop()). Bound to data_cc_top by the tile testbench, the RTL is unchanged.
 */
module magia_dcache_mshr_monitor #(
  parameter int unsigned NumMshr = 1,
  parameter int unsigned NumSets = 64
) (
  input logic               clk_i,
  input logic               rst_ni,
  input logic               perf_en_i,
  // MSHR entries and miss units in use
  input logic [NumMshr-1:0] mshr_free_i,
  input logic [NumMshr-1:0] unit_idle_i,
  // lookup output register
  input logic               res_valid_i,
  input logic               res_ready_i,
  input logic [2:0]         res_kind_i,
  input logic               res_prefetch_i,
  input logic               alloc_ready_i,
  // S2
  input logic               s2_valid_i,
  input logic               s2_advance_i,
  input logic               s2_same_set_pending_i,
  input logic               s2_out_free_i,
  input logic [2:0]         s2_kind_i,
  input logic               s2_wake_i,
  input logic               s2_same_line_i,
  input logic [31:0]        s2_addr_i,
  input logic [$clog2(NumSets)-1:0] s2_set_i,
  // front-end, ROB, core port
  input logic               fe_valid_i,
  input logic               fe_ready_i,
  input logic               core_req_i,
  input logic               core_gnt_i,
  input logic               rob_alloc_valid_i,
  input logic               rob_alloc_ready_i,
  // AXI refills
  input logic               ar_valid_i,
  input logic               ar_ready_i,
  input logic               r_valid_i,
  input logic               r_ready_i,
  input logic               r_last_i
);

  localparam logic [2:0] LkMiss = 3'd1;
  localparam logic [2:0] LkPark = 3'd4;

  longint unsigned cycles, occ_sum, unit_sum, ar_out_sum;
  longint unsigned occ_hist [NumMshr+1];
  longint unsigned miss_blocked, pf_dropped_full, same_set_stall, out_stall, s2_adv, s2_blocked;
  longint unsigned park_same_line, park_other_line, wakes, wake_miss, fe_wait, core_stall, rob_full;
  longint unsigned ar_cnt, misses, sets_conflict;
  longint unsigned set_miss [NumSets];
  int unsigned     ar_out, ar_out_max, win;
  logic            perf_en_q;
  int unsigned     n_busy, n_units;

  always_comb begin
    n_busy  = 0;
    n_units = 0;
    for (int unsigned i = 0; i < NumMshr; i++) begin
      if (!mshr_free_i[i]) n_busy++;
      if (!unit_idle_i[i]) n_units++;
    end
  end

  task automatic clear();
    cycles = 0; occ_sum = 0; unit_sum = 0; ar_out_sum = 0; ar_out_max = 0;
    for (int unsigned k = 0; k <= NumMshr; k++) occ_hist[k] = 0;
    for (int unsigned s = 0; s < NumSets; s++) set_miss[s] = 0;
    miss_blocked = 0; pf_dropped_full = 0; same_set_stall = 0; out_stall = 0; s2_adv = 0; s2_blocked = 0;
    park_same_line = 0; park_other_line = 0; wakes = 0; wake_miss = 0; fe_wait = 0; core_stall = 0;
    rob_full = 0; ar_cnt = 0; misses = 0;
  endtask

  task automatic report();
    string hist;
    longint unsigned max_set, used_sets;
    hist = "";
    for (int unsigned k = 0; k <= NumMshr; k++) hist = {hist, $sformatf("%0s%0d", (k == 0) ? "" : "/", occ_hist[k])};
    max_set = 0; used_sets = 0;
    for (int unsigned s = 0; s < NumSets; s++) begin
      if (set_miss[s] > max_set) max_set = set_miss[s];
      if (set_miss[s] != 0) used_sets++;
    end
    $display("[DCACHE_MSHR] win=%0d cycles=%0d mshr=%0d occ_avg=%0.3f unit_avg=%0.3f occ_hist=%s miss_blocked=%0d pf_drop_full=%0d same_set_stall=%0d out_stall=%0d s2_adv=%0d s2_blocked=%0d park_line=%0d park_set=%0d wakes=%0d wake_miss=%0d fe_wait=%0d core_stall=%0d rob_full=%0d ar=%0d ar_out_avg=%0.3f ar_out_max=%0d misses=%0d sets_used=%0d max_set_miss=%0d",
             win, cycles, NumMshr, real'(occ_sum) / real'(cycles), real'(unit_sum) / real'(cycles), hist,
             miss_blocked, pf_dropped_full, same_set_stall, out_stall, s2_adv, s2_blocked,
             park_same_line, park_other_line, wakes, wake_miss, fe_wait, core_stall, rob_full,
             ar_cnt, real'(ar_out_sum) / real'(cycles), ar_out_max, misses, used_sets, max_set);
  endtask

  initial begin
    clear();
    win    = 0;
    ar_out = 0;
  end

  // Plain always: the counters are also cleared by the tasks
  always @(posedge clk_i) begin
    if (!rst_ni) begin
      perf_en_q <= 1'b0;
      ar_out    <= 0;
    end else begin
      perf_en_q <= perf_en_i;
      // AR in flight: issued minus last R beat
      ar_out <= ar_out + ((ar_valid_i && ar_ready_i) ? 1 : 0) - ((r_valid_i && r_ready_i && r_last_i) ? 1 : 0);
      if (perf_en_i && !perf_en_q) begin
        clear();
      end
      if (perf_en_i) begin
        cycles++;
        occ_sum  += n_busy;
        unit_sum += n_units;
        occ_hist[n_busy]++;
        ar_out_sum += ar_out;
        if (ar_out > ar_out_max) ar_out_max = ar_out;
        if (res_valid_i && res_kind_i == LkMiss && !res_prefetch_i && !alloc_ready_i) miss_blocked++;
        if (res_valid_i && res_kind_i == LkMiss &&  res_prefetch_i && !alloc_ready_i) pf_dropped_full++;
        if (s2_valid_i && s2_same_set_pending_i) same_set_stall++;
        if (s2_valid_i && !s2_out_free_i) out_stall++;
        if (s2_advance_i) s2_adv++;
        if (s2_valid_i && !s2_advance_i) s2_blocked++;
        if (s2_advance_i && s2_kind_i == LkPark && s2_same_line_i) park_same_line++;
        if (s2_advance_i && s2_kind_i == LkPark && !s2_same_line_i) park_other_line++;
        if (s2_advance_i && s2_wake_i) wakes++;
        if (s2_advance_i && s2_wake_i && s2_kind_i == LkMiss) wake_miss++;
        if (s2_advance_i && s2_kind_i == LkMiss) begin
          misses++;
          set_miss[s2_set_i]++;
        end
        if (fe_valid_i && !fe_ready_i) fe_wait++;
        if (core_req_i && !core_gnt_i) core_stall++;
        if (rob_alloc_valid_i && !rob_alloc_ready_i) rob_full++;
        if (ar_valid_i && ar_ready_i) ar_cnt++;
      end
      if (!perf_en_i && perf_en_q) begin
        report();
        win++;
      end
    end
  end

endmodule: magia_dcache_mshr_monitor

module magia_dcache_mux_monitor #(
  parameter int unsigned NumPorts  = 1,
  parameter type         req_t     = logic,
  parameter type         rsp_t     = logic,
  parameter type         cfg_req_t = logic,
  parameter type         cfg_rsp_t = logic
) (
  input logic                clk_i,
  input logic                rst_ni,
  input req_t [NumPorts-1:0] req_i,
  input rsp_t [NumPorts-1:0] rsp_i,
  input cfg_req_t            cfg_req_i,
  input cfg_rsp_t            cfg_rsp_i
);

  localparam logic [3:0] RegPerfCtrl = 4'h3;

  logic [NumPorts-1:0] wait_now;
  logic                multi_wait;
  logic                perf_write, perf_start, perf_stop, perf_en_q;
  longint unsigned     wait_cyc     [NumPorts];
  longint unsigned     wait_cyc_win [NumPorts];
  longint unsigned     gnt_cnt      [NumPorts];
  longint unsigned     gnt_cnt_win  [NumPorts];
  longint unsigned     multi_wait_cyc, multi_wait_cyc_win, win_cyc;
  int unsigned         win_idx;

  always_comb begin
    for (int unsigned p = 0; p < NumPorts; p++) begin
      wait_now[p] = req_i[p].req && !rsp_i[p].gnt;
    end
  end
  assign multi_wait = $countones(wait_now) > 1;

  assign perf_write = cfg_req_i.req && cfg_rsp_i.gnt && cfg_req_i.a.we && (cfg_req_i.a.addr[5:2] == RegPerfCtrl);
  assign perf_start = perf_write && cfg_req_i.a.wdata[0] && !perf_en_q;
  assign perf_stop  = perf_write && !cfg_req_i.a.wdata[0] && perf_en_q;

  // "p<port>=<grants>/<wait cycles>" for every port; port 0 is the control core, then the cluster cores
  function automatic string port_line(longint unsigned gnt [NumPorts], longint unsigned waits [NumPorts]);
    string line;
    line = "";
    for (int unsigned p = 0; p < NumPorts; p++) begin
      line = {line, $sformatf(" p%0d=%0d/%0d", p, gnt[p], waits[p])};
    end
    return line;
  endfunction

  function automatic longint unsigned total(longint unsigned cnt [NumPorts]);
    longint unsigned sum;
    sum = 0;
    for (int unsigned p = 0; p < NumPorts; p++) begin
      sum = sum + cnt[p];
    end
    return sum;
  endfunction

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      perf_en_q          <= 1'b0;
      multi_wait_cyc     <= 0;
      multi_wait_cyc_win <= 0;
      win_cyc            <= 0;
      win_idx            <= 0;
      for (int unsigned p = 0; p < NumPorts; p++) begin
        wait_cyc[p]     <= 0;
        wait_cyc_win[p] <= 0;
        gnt_cnt[p]      <= 0;
        gnt_cnt_win[p]  <= 0;
      end
    end else begin
      if (multi_wait) begin
        multi_wait_cyc <= multi_wait_cyc + 1;
      end
      for (int unsigned p = 0; p < NumPorts; p++) begin
        if (wait_now[p]) begin
          wait_cyc[p] <= wait_cyc[p] + 1;
        end
        if (req_i[p].req && rsp_i[p].gnt) begin
          gnt_cnt[p] <= gnt_cnt[p] + 1;
        end
      end
      // Window counters, as in magia_dcache_monitor
      if (perf_start) begin
        perf_en_q          <= 1'b1;
        win_cyc            <= 0;
        multi_wait_cyc_win <= 0;
        for (int unsigned p = 0; p < NumPorts; p++) begin
          wait_cyc_win[p] <= 0;
          gnt_cnt_win[p]  <= 0;
        end
      end else if (perf_en_q) begin
        win_cyc <= win_cyc + 1;
        if (multi_wait) begin
          multi_wait_cyc_win <= multi_wait_cyc_win + 1;
        end
        for (int unsigned p = 0; p < NumPorts; p++) begin
          if (wait_now[p]) begin
            wait_cyc_win[p] <= wait_cyc_win[p] + 1;
          end
          if (req_i[p].req && rsp_i[p].gnt) begin
            gnt_cnt_win[p] <= gnt_cnt_win[p] + 1;
          end
        end
      end
      if (perf_stop) begin
        perf_en_q <= 1'b0;
        win_idx   <= win_idx + 1;
        $display("[DCACHE_MUX_WIN] %m: win=%0d cycles=%0d gnt=%0d wait_cyc=%0d multi_wait_cyc=%0d | gnt/wait:%s",
                 win_idx, win_cyc, total(gnt_cnt_win), total(wait_cyc_win), multi_wait_cyc_win,
                 port_line(gnt_cnt_win, wait_cyc_win));
      end
    end
  end

  final begin
    $display("[DCACHE_MUX] %m: gnt=%0d wait_cyc=%0d multi_wait_cyc=%0d | gnt/wait:%s",
             total(gnt_cnt), total(wait_cyc), multi_wait_cyc, port_line(gnt_cnt, wait_cyc));
  end

endmodule: magia_dcache_mux_monitor
