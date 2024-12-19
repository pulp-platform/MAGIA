#include "redmule_tile_utils.h"

int main(void) {
  mmio16(TEST_END_ADDR) = DEFAULT_EXIT_CODE;

  return 0;
}