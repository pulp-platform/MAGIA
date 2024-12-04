#include "redmule_tile_utils.h"
#include "redmule_mesh_utils.h"

#define VERBOSE (100)

#define NUM_HARTS (4)

#define SYNC_SETTLE (10000)

#define TILE_OFFSET (0x10000000)
#define SYNCH_BASE  (L1_BASE + 0x00012048)

#define NUM_ITER     (1000)
#define INITIAL_VAL  (1234)
#define AMO_TILES    (NUM_HARTS)
#define EXPECTED_VAL (INITIAL_VAL + NUM_ITER*AMO_TILES)

int main(void) {
  uint32_t current_count[NUM_HARTS];
  h_pprintf("Starting AMO test...\n");
  mmio32(SYNCH_BASE + get_hartid()*TILE_OFFSET) = INITIAL_VAL;
  for (int i = 0; i < NUM_ITER; i++){
    for (int i = 0; i < get_hartid(); i++) asm volatile("addi x0, x0, 0" ::);
    for (int i = 0; i < AMO_TILES; i++){
      asm volatile("addi t0, %0, 0" ::"r"((uint32_t)(SYNCH_BASE + ((get_hartid()+i)%NUM_HARTS)*TILE_OFFSET)));
      asm volatile("li t1, 1" ::);
      asm volatile("amoadd.w t2, t1, (t0)" ::);
    }
    current_count[get_hartid()] = mmio32(SYNCH_BASE + get_hartid()*TILE_OFFSET);
#if VERBOSE > 100
  h_pprintf("current_count: "); pprintf(ds(current_count[get_hartid()])); pprintln;
#endif
  }

  for (int i = 0; i < SYNC_SETTLE; i++) asm volatile("addi x0, x0, 0" ::);

  h_pprintf("Verifying results...\n");
  uint32_t exit_code[NUM_HARTS];
  if(mmio32(SYNCH_BASE + get_hartid()*TILE_OFFSET) != EXPECTED_VAL){
    exit_code[get_hartid()] = FAIL_EXIT_CODE;
    h_pprintf("Test FAILED\n");
  }else{
    exit_code[get_hartid()] = PASS_EXIT_CODE;
    h_pprintf("Test PASSED\n");
  }

#if VERBOSE > 10
  h_pprintf("Final Synch Value: "); pprintf(ds(mmio32(SYNCH_BASE + get_hartid()*TILE_OFFSET))); 
    pprintf(" - Expected: ");       pprintf(ds(EXPECTED_VAL)); pprintln;
#endif
  
  mmio8(TEST_END_ADDR + get_hartid()) = exit_code[get_hartid()] - get_hartid();

  return 0;
}