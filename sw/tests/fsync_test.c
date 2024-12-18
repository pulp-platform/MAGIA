#include "redmule_tile_utils.h"
#include "redmule_mesh_utils.h"
#include "fsync_isa_utils.h"

#define VERBOSE (1000)

#define NUM_LEVELS (2)
#define STALLING
#define SYNC_SETTLE (NUM_HARTS*500)

/// Only measure via 1 method (cycles xor time) otherwise the 2 methods interfere with each other
/// Note SW performance measures add overhead
#define PERF_MEASURE
// #define P_CYCLES
#define P_TIME

int main(void) {
  uint32_t levels[NUM_HARTS];

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

  for (int i = 0; i < NUM_LEVELS; i++){
    h_pprintf("Fractal Sync at level "); pprintf(ds(i)); n_pprintf("...");

#ifndef STALLING
    irq_en(1<<IRQ_FSYNC_DONE);
#endif
    
    levels[get_hartid()] = (uint32_t)(i+1);
#if VERBOSE > 10
    h_pprintf("levels: 0x"); n_pprintf(hs(levels[get_hartid()]));
#endif

#ifdef PERF_MEASURE
#ifdef P_CYCLES
    start_cycle[get_hartid()] = get_cycle();
#endif
#ifdef P_TIME
    start_time[get_hartid()]  = get_time();
#endif
#endif

    fsync(levels[get_hartid()]);
    sentinel_instr();   // Indicate occurred synchronization

#ifndef STALLING
    asm volatile("wfi" ::: "memory");
    h_pprintf("Detected IRQ...\n");
#endif

#ifdef PERF_MEASURE
#ifdef P_CYCLES
    end_cycle[get_hartid()] = get_cycle();
#endif
#ifdef P_TIME
    end_time[get_hartid()]  = get_time();
#endif
#endif

    h_pprintf("Synchronized...\n");

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
  }

#ifdef PERF_MEASURE
#ifdef P_CYCLES
  ccount_dis();
#endif
#endif

  h_pprintf("Fractal Sync test finished...\n");

  mmio8(TEST_END_ADDR + get_hartid()) = DEFAULT_EXIT_CODE - get_hartid();

  return 0;
}