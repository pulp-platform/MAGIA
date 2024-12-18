#include "redmule_mesh_utils.h"

#define MEM_OFFSET (0x1000)

#define SETTLE_CYCLE (MESH_X_TILES*500)

int main() {
  uint32_t error[NUM_HARTS];
  uint32_t total_errors;

  // Write the tiles ID to different L1 memory locations in other tiles
  for(int i = 0; i < NUM_HARTS; i++) {
    if(get_hartid() != i) {
      *(volatile int*) (L1_BASE + i*L1_TILE_OFFSET + MEM_OFFSET + get_hartid()*4) = (int) get_hartid();
    }
  }

  // Read back the values
  for (int i = 0; i < NUM_HARTS; i++) {
    if(get_hartid() != i) {
      if (*(volatile int *) (L1_BASE + i*L1_TILE_OFFSET + MEM_OFFSET + get_hartid()*4) != get_hartid()) {
        h_pprintf("Read wrong value, expected "); pprintf(ds(get_hartid())); pprintln;
        error[get_hartid()]++;
      }
    }
  }

  wait_nop(SETTLE_CYCLE);

  if (get_hartid() == 0) {
    for (int i = 0; i < NUM_HARTS; i++)
      if (error[i]) total_errors++;
    if (total_errors) { h_pprintf("TEST FAILED!!"); pprintln; }
    else              { h_pprintf("TEST PASSED!!"); pprintln; }
  } else wait_nop(SETTLE_CYCLE);

  if (total_errors) mmio8(TEST_END_ADDR + get_hartid()) = FAIL_EXIT_CODE;
  else              mmio8(TEST_END_ADDR + get_hartid()) = PASS_EXIT_CODE;         

  return 0;
}