#include "magia_tile_utils.h"
#include "magia_utils.h"
#include "fsync_isa_utils.h"
#include "cache_fill.h"

#define VERBOSE (0)

#define STALLING


int main(void) {
  uint32_t aggregates[NUM_HARTS];
  uint32_t ids[NUM_HARTS];

#ifndef STALLING
  irq_en(1<<IRQ_FSYNC_DONE);
#endif

  // /// Horizontal neighbor synch.
  // aggregates[get_hartid()] = 0b1;
  // ids[get_hartid()] = 0b00;

  // /// Vertical neighbor synch.
  // aggregates[get_hartid()] = 0b1;
  // ids[get_hartid()] = 0b01;

  // /// Horizontal 2x2 synch.
  // aggregates[get_hartid()] = 0b11;
  // ids[get_hartid()] = 0b00;

  // /// Vertical 2x2 synch.
  // aggregates[get_hartid()] = 0b11;
  // ids[get_hartid()] = 0b01;

  /// Diagonal synch.
  switch (get_hartid()) {
    case 0:
      aggregates[get_hartid()] = 0b10;
      ids[get_hartid()] = 0b00;
      break;
    case 1:
      aggregates[get_hartid()] = 0b10;
      ids[get_hartid()] = 0b01;
      break;
    case 2:
      aggregates[get_hartid()] = 0b10;
      ids[get_hartid()] = 0b01;
      break;
    case 3:
      aggregates[get_hartid()] = 0b10;
      ids[get_hartid()] = 0b00;
      break;
    default: break;
  }

  h_pprintf("FractalSync aggregate: 0b"); pprintf(bs(aggregates[get_hartid()])); pprintf(", id: "); pprintf(ds(ids[get_hartid()])); n_pprintf("...");

  fsync(ids[get_hartid()], aggregates[get_hartid()]);

#ifndef STALLING
  asm volatile("wfi" ::: "memory");
  h_pprintf("Detected IRQ...\n");
#endif

  sentinel_instr_id();  

  h_pprintf("FractalSync test finished...\n");

  mmio16(TEST_END_ADDR + get_hartid()*2) = DEFAULT_EXIT_CODE - get_hartid();

  return 0;
}