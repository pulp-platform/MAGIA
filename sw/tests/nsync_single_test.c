#include "redmule_tile_utils.h"
#include "redmule_mesh_utils.h"

#define VERBOSE (10)

/// Only measure via 1 method (cycles xor time) otherwise the 2 methods interfere with each other
/// Note SW performance measures add overhead
#define PERF_MEASURE
// #define P_CYCLES
#define P_TIME

int main(void) {
  uint32_t sync_count[NUM_HARTS];
  mmio32(SYNC_BASE + get_hartid()*L1_TILE_OFFSET) = 0;
  h_pprintf("Starting NoC Synch test...\n");

#ifdef PERF_MEASURE
#ifdef P_CYCLES
  uint32_t start_cycle[NUM_HARTS];
  uint32_t end_cycle[NUM_HARTS];
  ccount_en();
#endif
#ifdef P_TIME
  uint32_t start_time[NUM_HARTS];
  uint32_t end_time[NUM_HARTS];
#endif
#endif

  h_pprintf("Running sigle source-sink algorithm...\n");

#ifdef PERF_MEASURE
#ifdef P_CYCLES
    start_cycle[get_hartid()] = get_cycle();
#endif
#ifdef P_TIME
    start_time[get_hartid()]  = get_time();
#endif
#endif

  if (get_hartid() % 2) {
    amo_increment(SYNC_BASE + (get_hartid()-1)*L1_TILE_OFFSET);
    do {
#if VERBOSE > 10
      sync_count[get_hartid()] = mmio32(SYNC_BASE + get_hartid()*L1_TILE_OFFSET);
      h_pprintf("current sync_count: "); pprintf(ds(sync_count[get_hartid()])); pprintln;
#endif
    } while (mmio32(SYNC_BASE + get_hartid()*L1_TILE_OFFSET) != 1);
  } else {
    do {
#if VERBOSE > 10
      sync_count[get_hartid()] = mmio32(SYNC_BASE + get_hartid()*L1_TILE_OFFSET);
      h_pprintf("current sync_count: "); pprintf(ds(sync_count[get_hartid()])); pprintln;
#endif
    } while (mmio32(SYNC_BASE + get_hartid()*L1_TILE_OFFSET) != 1);
    amo_increment(SYNC_BASE + (get_hartid()+1)*L1_TILE_OFFSET);
  }
  sentinel_instr(); // Indicate occurred synchronization

#ifdef PERF_MEASURE
#ifdef P_CYCLES
    end_cycle[get_hartid()] = get_cycle();
#endif
#ifdef P_TIME
    end_time[get_hartid()]  = get_time();
#endif
#endif

  sync_count[get_hartid()] = mmio32(SYNC_BASE + get_hartid()*L1_TILE_OFFSET);
  h_pprintf("sync_count: "); pprintf(ds(sync_count[get_hartid()])); pprintln;

#ifdef PERF_MEASURE
#ifdef P_CYCLES
    if (start_cycle[get_hartid()] && end_cycle[get_hartid()]){
      h_pprintf("PERFORMANCE COUNTER: "); pprintf(ds(end_cycle[get_hartid()] - start_cycle[get_hartid()])); pprintf(" cycles (");
      pprintf(ds(start_cycle[get_hartid()])); pprintf(" - "); pprintf(ds(end_cycle[get_hartid()])); n_pprintf(")cycle");
    }
    else
      h_pprintf("PERFORMANCE COUNTER: ERROR cycle counter overlow...\n");
#endif
#ifdef P_TIME
    if (start_time[get_hartid()] && end_time[get_hartid()]){
      h_pprintf("PERFORMANCE COUNTER: "); pprintf(ds(end_time[get_hartid()] - start_time[get_hartid()])); pprintf("ns (");
      pprintf(ds(start_time[get_hartid()])); pprintf(" - "); pprintf(ds(end_time[get_hartid()])); n_pprintf(")ns");
    }
    else
      h_pprintf("PERFORMANCE COUNTER: ERROR time counter overlow...\n");
#endif
#endif

#ifdef PERF_MEASURE
#ifdef P_CYCLES
  ccount_dis();
#endif
#endif

  h_pprintf("NoC Synch test finished...\n");

  mmio8(TEST_END_ADDR + get_hartid()) = DEFAULT_EXIT_CODE - get_hartid();

  return 0;
}