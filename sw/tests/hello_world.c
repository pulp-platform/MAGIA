#include <stdio.h>
#include "redmule_tile_utils.h"
#include "tinyprintf.h"

int main(void) {
  printf("Hello World!\n");

  mmio32(TEST_END_ADDR) = DEFAULT_EXIT_CODE;

  return 0;
}