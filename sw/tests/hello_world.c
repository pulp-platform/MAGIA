#include "redmule_tile_utils.h"

#define TEST_ID (1)

int main(void) {
  printf("Hello World! it is test %0x\n", TEST_ID*16);

  mmio16(TEST_END_ADDR) = DEFAULT_EXIT_CODE;

  return 0;
}