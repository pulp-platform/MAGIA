#include "magia_tile_utils.h"
#include "magia_utils.h"
#include "fsync_isa_utils.h"
#include "fsync_api.h"
#include "cache_fill.h"

#define VERBOSE (0)

#define STALLING


int main(void) {
  uint32_t aggregates[NUM_HARTS];
  uint32_t ids[NUM_HARTS];

#ifndef STALLING
  irq_en(1<<IRQ_FSYNC_DONE);
#endif

  /// Horizontal neighbor synch.
  aggregates[get_hartid()] = 0b1;
  ids[get_hartid()] = 0b00;

  // /// Vertical neighbor synch.
  // aggregates[get_hartid()] = 0b1;
  // ids[get_hartid()] = 0b01;

  // /// Horizontal 2x2 synch.
  // aggregates[get_hartid()] = 0b11;
  // ids[get_hartid()] = 0b00;

  // /// Vertical 2x2 synch.
  // aggregates[get_hartid()] = 0b11;
  // ids[get_hartid()] = 0b01;

  // /// Diagonal synch. 2x2 FractalSync network
  // switch (get_hartid()) {
  //   case 0:
  //     aggregates[get_hartid()] = 0b10;
  //     ids[get_hartid()] = 0b00;
  //     break;
  //   case 1:
  //     aggregates[get_hartid()] = 0b10;
  //     ids[get_hartid()] = 0b01;
  //     break;
  //   case 2:
  //     aggregates[get_hartid()] = 0b10;
  //     ids[get_hartid()] = 0b01;
  //     break;
  //   case 3:
  //     aggregates[get_hartid()] = 0b10;
  //     ids[get_hartid()] = 0b00;
  //     break;
  //   default: break;
  // }

  // /// Custom 4x4 synch.
  // switch (get_hartid()){
  //   case 0:  aggregates[get_hartid()] = 0b1111; ids[get_hartid()] = 7; break;
  //   case 1:  aggregates[get_hartid()] = 0b1111; ids[get_hartid()] = 7; break;
  //   case 2:  aggregates[get_hartid()] = 0b1111; ids[get_hartid()] = 7; break;
  //   case 3:  aggregates[get_hartid()] = 0b1111; ids[get_hartid()] = 7; break;
  //   case 4:  aggregates[get_hartid()] = 0b1111; ids[get_hartid()] = 7; break;
  //   case 5:  aggregates[get_hartid()] = 0b1111; ids[get_hartid()] = 7; break;
  //   case 6:  aggregates[get_hartid()] = 0b1111; ids[get_hartid()] = 7; break;
  //   case 7:  aggregates[get_hartid()] = 0b1111; ids[get_hartid()] = 7; break;
  //   case 8:  aggregates[get_hartid()] = 0b1111; ids[get_hartid()] = 7; break;
  //   case 9:  aggregates[get_hartid()] = 0b1111; ids[get_hartid()] = 7; break;
  //   case 10: aggregates[get_hartid()] = 0b1111; ids[get_hartid()] = 7; break;
  //   case 11: aggregates[get_hartid()] = 0b1111; ids[get_hartid()] = 7; break;
  //   case 12: aggregates[get_hartid()] = 0b1111; ids[get_hartid()] = 7; break;
  //   case 13: aggregates[get_hartid()] = 0b1111; ids[get_hartid()] = 7; break;
  //   case 14: aggregates[get_hartid()] = 0b1111; ids[get_hartid()] = 7; break;
  //   case 15: aggregates[get_hartid()] = 0b1111; ids[get_hartid()] = 7; break;
  // }

  // h_pprintf("FractalSync aggregate: 0b"); pprintf(bs(aggregates[get_hartid()])); pprintf(", id: "); pprintf(ds(ids[get_hartid()])); n_pprintf("...");
  printf("FractalSync aggregate: 0x%0x, id: %0d...\n", aggregates[get_hartid()], ids[get_hartid()]);

  fsync(ids[get_hartid()], aggregates[get_hartid()]);

#ifndef STALLING
  asm volatile("wfi" ::: "memory");
  // h_pprintf("Detected IRQ...\n");
  printf("Detected IRQ...\n");
#endif

  sentinel_instr_id();

  printf("[FractalSync] Horizontal neighbor test starting\n");
  fsync_h_nbr();
  printf("[FractalSync] Horizontal neighbor test ending\n");

  printf("[FractalSync] Horizontal ring neighbor test starting\n");
  fsync_h_tor_nbr();
  printf("[FractalSync] Horizontal ring neighbor test ending\n");

  printf("[FractalSync] Vertical neighbor test starting\n");
  fsync_v_nbr();
  printf("[FractalSync] Vertical neighbor test ending\n");

  printf("[FractalSync] Vertical ring neighbor test starting\n");
  fsync_h_tor_nbr();
  printf("[FractalSync] Vertical ring neighbor test ending\n");

  printf("[FractalSync] Row test starting\n");
  fsync_rows();
  printf("[FractalSync] Row test ending\n");

  printf("[FractalSync] Column test starting\n");
  fsync_cols();
  printf("[FractalSync] Column test ending\n");

  printf("[FractalSync] Global test starting\n");
  fsync_global();
  printf("[FractalSync] Global test ending\n");

  // h_pprintf("FractalSync test finished...\n");
  printf("FractalSync test finished...\n");

  mmio16(TEST_END_ADDR + get_hartid()*2) = DEFAULT_EXIT_CODE - get_hartid();

  return 0;
}