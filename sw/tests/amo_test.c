#include "redmule_tile_utils.h"
#include "redmule_mesh_utils.h"

#define VERBOSE (100)

#define SYNC_SETTLE (NUM_HARTS*500)

#define NUM_ITER     (1000)
#define INITIAL_VAL  (1234)
#define AMO_TILES    (NUM_HARTS)
#define EXPECTED_VAL (INITIAL_VAL + NUM_ITER*AMO_TILES)

int main(void) {
  uint32_t current_count[NUM_HARTS];
  h_pprintf("Starting AMO test...\n");
  mmio32(SYNC_BASE + get_hartid()*L1_TILE_OFFSET) = INITIAL_VAL;
  wait_nop(SYNC_SETTLE);
  for (int i = 0; i < NUM_ITER; i++){
    wait_nop(get_hartid());
    for (int i = 0; i < AMO_TILES; i++){
      asm volatile("addi t0, %0, 0" ::"r"((uint32_t)(SYNC_BASE + ((get_hartid()+i)%NUM_HARTS)*L1_TILE_OFFSET)));
      asm volatile("li t1, 1" ::);
      asm volatile("amoadd.w t2, t1, (t0)" ::);
    }
    current_count[get_hartid()] = mmio32(SYNC_BASE + get_hartid()*L1_TILE_OFFSET);
#if VERBOSE > 100
  h_pprintf("current_count: "); pprintf(ds(current_count[get_hartid()])); pprintln;
#endif
  }

  wait_nop(SYNC_SETTLE);

  h_pprintf("Verifying results...\n");
  uint32_t exit_code[NUM_HARTS];
  if(mmio32(SYNC_BASE + get_hartid()*L1_TILE_OFFSET) != EXPECTED_VAL){
    exit_code[get_hartid()] = FAIL_EXIT_CODE;
    h_pprintf("Test FAILED\n");
  }else{
    exit_code[get_hartid()] = PASS_EXIT_CODE;
    h_pprintf("Test PASSED\n");
  }

#if VERBOSE > 10
  h_pprintf("Final Synch Value: "); pprintf(ds(mmio32(SYNC_BASE + get_hartid()*L1_TILE_OFFSET))); 
    pprintf(" - Expected: ");       pprintf(ds(EXPECTED_VAL)); pprintln;
#endif
  
  mmio8(TEST_END_ADDR + get_hartid()) = exit_code[get_hartid()] - get_hartid();

  return 0;
}