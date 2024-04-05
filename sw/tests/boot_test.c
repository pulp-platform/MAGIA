#include "redmule_tile_utils.h"

int main(void) {
  mmio32(TEST_END_ADDR) = DEFAULT_EXIT_CODE;

  return 0;
}