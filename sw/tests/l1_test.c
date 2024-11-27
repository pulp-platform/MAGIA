#include "redmule_tile_utils.h"

// #define FULL_L1

#define DIAGONAL_L1

#define STEP (1)

#define ALIVE_CYCLE (8192)

// Defining the actual number of words per bank
// to be checked in order to avoid overwriting the stack
#define ACTIVE_WORDS (((STACK_START+L1_SIZE-L1_BASE+1)/4)/32)

int main(void) {
  uint8_t exit_code;

#ifdef FULL_L1
  uint32_t expected_result = (NUM_L1_BANKS*ACTIVE_WORDS/STEP)*(NUM_L1_BANKS*ACTIVE_WORDS/STEP + 1)/2;
#endif
#ifndef FULL_L1
#ifdef DIAGONAL_L1
  uint32_t expected_result = (ACTIVE_WORDS)*(ACTIVE_WORDS + 1)/2;
#endif
#endif
#ifndef FULL_L1
#ifndef DIAGONAL_L1
  uint32_t expected_result = 0x3;
#endif
#endif
  
  mmio32(L2_BASE) = 0x1;

  printf("Checked L2 single write...\n");

  mmio32(L1_BASE) = mmio32(L2_BASE);

  printf("Checked L2 single read...\n");

#ifdef FULL_L1
  printf("Checking entire L1 read and write...\n");

  uint32_t expected_stored_num = 1;
  for (uint32_t i = 1; i < NUM_L1_BANKS*ACTIVE_WORDS; i += STEP){
    uint32_t read_mem = mmio32(L1_BASE + 0x4*i);
    if (read_mem != 0)
      printf("!MEMORY OVERWRITE! iteration %d - address 0x%8x - value %0d...\n", i, L1_BASE + 0x4*i, read_mem);
    mmio32(L1_BASE + 0x4*i) = mmio32(L1_BASE + 0x4*(i-1)) + 1;
    if (!(i%ALIVE_CYCLE)) printf("Transactions happening phase I...\n");
    expected_stored_num++;
    if (expected_stored_num != mmio32(L1_BASE + 0x4*i))
      printf("interation %d: expected_stored_num [%d] =/= stored_num [%d]...\n", i, expected_stored_num, mmio32(L1_BASE + 0x4*i));
  }
    
  printf("expected_stored_num: %d...\n", expected_stored_num);
  uint32_t expected_sum = expected_stored_num;
  for (uint32_t i = NUM_L1_BANKS*ACTIVE_WORDS-1; i > 0; i -= STEP){
    mmio32(L1_BASE + 0x4*(i-1)) += mmio32(L1_BASE + 0x4*i);
    if (!(i%ALIVE_CYCLE)) printf("Transactions happening phase II...\n");
    expected_sum += i;
    if (expected_sum != mmio32(L1_BASE + 0x4*(i-1)))
      printf("interation %d: expected_sum [%d] =/= stored_sum [%d]...\n", i, expected_sum, mmio32(L1_BASE + 0x4*(i-1)));
  }
#endif
#ifndef FULL_L1
#ifdef DIAGONAL_L1
  printf("Checking diagonal L1 read and write...\n");

  int expected_stored_num = 1;
  for (int i = 1; i < ACTIVE_WORDS; i++){
    mmio32(L1_BASE + 0x4*(i%NUM_L1_BANKS + i*NUM_L1_BANKS)) = mmio32(L1_BASE + 0x4*((i-1)%NUM_L1_BANKS + (i-1)*NUM_L1_BANKS)) + 1;
    expected_stored_num++;
    if (expected_stored_num != mmio32(L1_BASE + 0x4*(i%NUM_L1_BANKS + i*NUM_L1_BANKS)))
      printf("interation %d: expected_stored_num [%d] =/= stored_num [%d]...\n", i, expected_stored_num, mmio32(L1_BASE + 0x4*(i%NUM_L1_BANKS + i*NUM_L1_BANKS)));
  }

  printf("expected_stored_num: %d...\n", expected_stored_num);
  int expected_sum = expected_stored_num;
  for (int i = ACTIVE_WORDS-1; i > 0; i--){
    mmio32(L1_BASE + 0x4*((i-1)%NUM_L1_BANKS + (i-1)*NUM_L1_BANKS)) += mmio32(L1_BASE + 0x4*(i%NUM_L1_BANKS + i*NUM_L1_BANKS));
    expected_sum += i;
    if (expected_sum != mmio32(L1_BASE + 0x4*((i-1)%NUM_L1_BANKS + (i-1)*NUM_L1_BANKS)))
      printf("interation %d: expected_sum [%d] =/= stored_sum [%d]...\n", i, expected_sum, mmio32(L1_BASE + 0x4*((i-1)%NUM_L1_BANKS + (i-1)*NUM_L1_BANKS)));
  }
#endif
#endif
#ifndef FULL_L1
#ifndef DIAGONAL_L1
  printf("Checking single L1 read and write...\n");

  mmio32(L1_BASE + 0x4) = mmio32(L1_BASE) + 1;
  mmio32(L1_BASE) += mmio32(L1_BASE + 0x4);
#endif
#endif

  printf("Verifying results...\n");

  mmio32(L2_BASE) = mmio32(L1_BASE);
  if (mmio32(L2_BASE) == expected_result)
    exit_code = PASS_EXIT_CODE;
  else {
    exit_code = FAIL_EXIT_CODE;
    printf("FAIL: expected %0d, detected %0d...\n", expected_result, mmio32(L2_BASE));
  }

  mmio8(TEST_END_ADDR) = exit_code;

  return 0;
}