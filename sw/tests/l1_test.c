#include "redmule_tile_utils.h"

int main(void) {
  uint8_t exit_code;
  
  mmio32(L2_BASE + 0x4) = 0x1;
  mmio32(L2_BASE + 0x8) = 0x2;

  mmio32(L1_BASE + 0x4) = mmio32(L2_BASE + 0x4);
  mmio32(L1_BASE + 0x8) = mmio32(L2_BASE + 0x8);
  mmio32(L1_BASE + 0xC) = mmio32(L1_BASE + 0x4) + mmio32(L1_BASE + 0x8);

  mmio32(L2_BASE + 0xC) = mmio32(L1_BASE + 0xC);
  if (mmio32(L2_BASE + 0xC) == 0x3)
    exit_code = PASS_EXIT_CODE;
  else
    exit_code = FAIL_EXIT_CODE;

  mmio32(TEST_END_ADDR) = exit_code;

  return 0;
}