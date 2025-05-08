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
  
  aggregates[get_hartid()] = 0b1;
  ids[get_hartid()] = 0b00;

  h_pprintf("FractalSync aggregate: 0b"); pprintf(bs(aggregates[get_hartid()])); pprintf(", id: "); pprintf(ds(ids[get_hartid()])); n_pprintf("...");

  fsync(ids[get_hartid()], aggregates[get_hartid()]);

#ifndef STALLING
  asm volatile("wfi" ::: "memory");
  h_pprintf("Detected IRQ...\n");
#endif

  h_pprintf("FractalSync test finished...\n");

  mmio16(TEST_END_ADDR + get_hartid()*2) = DEFAULT_EXIT_CODE - get_hartid();

  return 0;
}