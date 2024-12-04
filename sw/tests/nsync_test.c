#include "redmule_tile_utils.h"
#include "redmule_mesh_utils.h"

#define VERBOSE (10)

#define NUM_HARTS (4)

#define TILE_OFFSET (0x10000000)
#define SYNCH_BASE  (L1_BASE + 0x00012048)

#define NAIVE

#define XY

int main(void) {
  uint32_t sync_count[NUM_HARTS];
  h_pprintf("Starting NoC Synch test...\n");

#ifdef NAIVE
  h_pprintf("Running naive algorithm...\n");
  mmio32(SYNCH_BASE + get_hartid()*TILE_OFFSET) = 0;
  if (get_hartid() == 0) {
    do {
#if VERBOSE > 10
      sync_count[get_hartid()] = mmio32(SYNCH_BASE + get_hartid()*TILE_OFFSET);
      h_pprintf("current sync_count: "); pprintf(ds(sync_count[get_hartid()])); pprintln;
#endif
    } while (mmio32(SYNCH_BASE) != (NUM_HARTS-1));
    for (int i = 1; i < NUM_HARTS; i++) amo_increment(SYNCH_BASE + i*TILE_OFFSET);
  } else {
    amo_increment(SYNCH_BASE);
    do {
#if VERBOSE > 10
      sync_count[get_hartid()] = mmio32(SYNCH_BASE + get_hartid()*TILE_OFFSET);
      h_pprintf("current sync_count: "); pprintf(ds(sync_count[get_hartid()])); pprintln;
#endif
    } while (mmio32(SYNCH_BASE + get_hartid()*TILE_OFFSET) != 1);
  }
  sync_count[get_hartid()] = mmio32(SYNCH_BASE + get_hartid()*TILE_OFFSET);
  h_pprintf("sync_count: "); pprintf(ds(sync_count[get_hartid()])); pprintln;
#endif

#ifdef XY
  h_pprintf("Running XY algorithm...\n");
  mmio32(SYNCH_BASE + get_hartid()*TILE_OFFSET) = 0;
  if ((get_hartid() == 0) || (get_hartid() == 2)){
    amo_increment(SYNCH_BASE + (get_hartid()+1)*TILE_OFFSET);
    do {
#if VERBOSE > 10
      sync_count[get_hartid()] = mmio32(SYNCH_BASE + get_hartid()*TILE_OFFSET);
      h_pprintf("current sync_count: "); pprintf(ds(sync_count[get_hartid()])); pprintln;
#endif
    } while (mmio32(SYNCH_BASE + get_hartid()*TILE_OFFSET) != 1);
  } else {
    do {
#if VERBOSE > 10
      sync_count[get_hartid()] = mmio32(SYNCH_BASE + get_hartid()*TILE_OFFSET);
      h_pprintf("current sync_count: "); pprintf(ds(sync_count[get_hartid()])); pprintln;
#endif
    } while (mmio32(SYNCH_BASE + get_hartid()*TILE_OFFSET) != 1);
    if (get_hartid() == 1) {
      amo_increment(SYNCH_BASE + (get_hartid()+2)*TILE_OFFSET);
      do {
#if VERBOSE > 10
        sync_count[get_hartid()] = mmio32(SYNCH_BASE + get_hartid()*TILE_OFFSET);
        h_pprintf("current sync_count: "); pprintf(ds(sync_count[get_hartid()])); pprintln;
#endif
      } while (mmio32(SYNCH_BASE + get_hartid()*TILE_OFFSET) != 2);
    } else {
      do {
#if VERBOSE > 10
        sync_count[get_hartid()] = mmio32(SYNCH_BASE + get_hartid()*TILE_OFFSET);
        h_pprintf("current sync_count: "); pprintf(ds(sync_count[get_hartid()])); pprintln;
#endif
      } while (mmio32(SYNCH_BASE + get_hartid()*TILE_OFFSET) != 2);
      amo_increment(SYNCH_BASE + (get_hartid()-2)*TILE_OFFSET);
    }
    amo_increment(SYNCH_BASE + (get_hartid()-1)*TILE_OFFSET);
  }
  sync_count[get_hartid()] = mmio32(SYNCH_BASE + get_hartid()*TILE_OFFSET);
  h_pprintf("sync_count: "); pprintf(ds(sync_count[get_hartid()])); pprintln;
#endif

  h_pprintf("NoC Synch test finished...\n");

  mmio8(TEST_END_ADDR + get_hartid()) = DEFAULT_EXIT_CODE - get_hartid();

  return 0;
}