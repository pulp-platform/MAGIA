#include "magia_tile_utils.h"
#include "magia_utils.h"
#include "cache_fill.h"

#define VERBOSE (10)

#define SYNC_NODE_X_ID     ((MESH_X_TILES-1)/2)
#define SYNC_NODE_Y_ID     ((MESH_Y_TILES-1)/2)
#define SYNC_NODE_ID       (GET_ID(SYNC_NODE_Y_ID, SYNC_NODE_X_ID))

#define CACHE_HEAT_CYCLES (3)

/// Only measure via 1 method (cycles xor time) otherwise the 2 methods interfere with each other
/// Note SW performance measures add overhead
// #define PERF_MEASURE
// #define P_CYCLES
// #define P_TIME

int main(void) {
  volatile uint32_t sync_count[NUM_HARTS];
  volatile uint32_t sync_en[NUM_HARTS];
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

  h_pprintf("Running XY algorithm...\n");

#ifdef PERF_MEASURE
#ifdef P_CYCLES
    start_cycle[get_hartid()] = get_cycle();
#endif
#ifdef P_TIME
    start_time[get_hartid()]  = get_time();
#endif
#endif

  // Filling up the cache
  fill_icache();
  
  // Execute synchronization multiple times to pre-heat the cache
  for (int i = 0; i < CACHE_HEAT_CYCLES; i++) {
    // Phase I - synchronize along X direction
    if (GET_X_ID(get_hartid()) != SYNC_NODE_X_ID){  // SRC
      // Wait for DST to be ready for synchronization
      do {
        sync_en[get_hartid()] = mmio32(SYNC_EN + (GET_ID(GET_Y_ID(get_hartid()), SYNC_NODE_X_ID))*L1_TILE_OFFSET);
#if VERBOSE > 100
        h_pprintf("current sync_en: "); pprintf(ds(sync_en[get_hartid()])); pprintln;
#endif
      } while (sync_en[get_hartid()] != 1);

      // Send synchronization request to DST
      amo_increment(SYNC_BASE + (GET_ID(GET_Y_ID(get_hartid()), SYNC_NODE_X_ID))*L1_TILE_OFFSET);

      // Wait for DST synchronization response
      do {
        sync_count[get_hartid()] = mmio32(SYNC_BASE + get_hartid()*L1_TILE_OFFSET);
#if VERBOSE > 100
        h_pprintf("current sync_count: "); pprintf(ds(sync_count[get_hartid()])); pprintln;
#endif
      } while (sync_count[get_hartid()] != 1);
    } else {  // DST
      // Enable synchronization requests
      mmio32(SYNC_EN + get_hartid()*L1_TILE_OFFSET) = 1;
      
      // Wait for all SRCs to request synchronization
      do {
        sync_count[get_hartid()] = mmio32(SYNC_BASE + get_hartid()*L1_TILE_OFFSET);
#if VERBOSE > 100
        h_pprintf("current sync_count: "); pprintf(ds(sync_count[get_hartid()])); pprintln;
#endif
      } while (sync_count[get_hartid()] < (MESH_X_TILES-1));

      // Disable further synchronization requests: handling current synchronization cycle
      mmio32(SYNC_EN + get_hartid()*L1_TILE_OFFSET) = 0;

      // Phase II - synchronize along Y direction
      if (get_hartid() != SYNC_NODE_ID) { // SRC
        // Wait for DST to be ready for synchronization
        do {
          sync_en[get_hartid()] = mmio32(SYNC_EN + SYNC_NODE_ID*L1_TILE_OFFSET);
#if VERBOSE > 100
          h_pprintf("current sync_en: "); pprintf(ds(sync_en[get_hartid()])); pprintln;
#endif
        } while (sync_en[get_hartid()] != 1);

        // Send synchronization request to DST
        amo_increment(SYNC_BASE + SYNC_NODE_ID*L1_TILE_OFFSET);

        // Wait for DST synchronization response
        do {
          sync_count[get_hartid()] = mmio32(SYNC_BASE + get_hartid()*L1_TILE_OFFSET);
#if VERBOSE > 100
          h_pprintf("current sync_count: "); pprintf(ds(sync_count[get_hartid()])); pprintln;
#endif
        } while (sync_count[get_hartid()] < MESH_X_TILES);
      } else {  // DST
        // Enable synchronization requests
        mmio32(SYNC_EN + get_hartid()*L1_TILE_OFFSET) = 1;
        
        // Wait for all SRCs to request synchronization
        do {
          sync_count[get_hartid()] = mmio32(SYNC_BASE + get_hartid()*L1_TILE_OFFSET);
#if VERBOSE > 100
          h_pprintf("current sync_count: "); pprintf(ds(sync_count[get_hartid()])); pprintln;
#endif
        } while (sync_count[get_hartid()] < (MESH_X_TILES+MESH_Y_TILES-2));

        // Disable further synchronization requests: handling current synchronization cycle
        mmio32(SYNC_EN + get_hartid()*L1_TILE_OFFSET) = 0;
        
        // Send synchronization response to all SRCs
        for (int i = 0; i < MESH_Y_TILES; i++) amo_increment(SYNC_BASE + (GET_ID(i, SYNC_NODE_X_ID))*L1_TILE_OFFSET);
      }

      // Send synchronization response to all SRCs
      for (int i = 0; i < MESH_X_TILES; i++) amo_increment(SYNC_BASE + (GET_ID(GET_Y_ID(get_hartid()), i))*L1_TILE_OFFSET);
    }
    sentinel_instr_ex(); // Indicate occurred synchronization
#if VERBOSE > 1
    sync_count[get_hartid()] = mmio32(SYNC_BASE + get_hartid()*L1_TILE_OFFSET);
    h_pprintf("sync_count: "); pprintf(ds(sync_count[get_hartid()])); pprintln;
#endif
    mmio32(SYNC_BASE + get_hartid()*L1_TILE_OFFSET) = 0; // Reset synchronization register
#if VERBOSE > 10
    sync_count[get_hartid()] = mmio32(SYNC_BASE + get_hartid()*L1_TILE_OFFSET);
    h_pprintf("reset sync_count: "); pprintf(ds(sync_count[get_hartid()])); pprintln;
#endif
  }

#ifdef PERF_MEASURE
#ifdef P_CYCLES
    end_cycle[get_hartid()] = get_cycle();
#endif
#ifdef P_TIME
    end_time[get_hartid()]  = get_time();
#endif
#endif

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

  mmio16(TEST_END_ADDR + get_hartid()*2) = DEFAULT_EXIT_CODE - get_hartid();

  return 0;
}