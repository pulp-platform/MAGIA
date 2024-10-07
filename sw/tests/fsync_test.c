#include "redmule_tile_utils.h"
#include "redmule_mesh_utils.h"
#include "fsync_isa_utils.h"

#define NUM_HARTS (2)

#define NUM_LEVELS (1)

#define VERBOSE (100)

int main(void) {
  uint32_t levels[NUM_HARTS];

  for (int i = 0; i < NUM_LEVELS; i++){
    h_pprintf("Fractal Sync at level "); pprintf(ds(i)); n_pprintf("...");

    irq_en(1<<IRQ_FSYNC_DONE);
    
    levels[get_hartid()] = (uint32_t)(i+1);
#if VERBOSE > 10
    h_pprintf("levels: 0x"); n_pprintf(hs(levels[get_hartid()]));
#endif
    asm volatile("addi t0, %0, 0" ::"r"(levels[get_hartid()]));
    fsync();

    asm volatile("wfi" ::: "memory");
    h_pprintf("Detected IRQ...\n");
  }

  mmio32(TEST_END_ADDR + get_hartid()) = DEFAULT_EXIT_CODE - get_hartid();

  return 0;
}