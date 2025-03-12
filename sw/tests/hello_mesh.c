#include "magia_tile_utils.h"
#include "magia_utils.h"

int main(void) {
  h_pprintf("Hello World! it is hartid "); pprintf(ds(get_hartid())); pprintln;

  mmio16(TEST_END_ADDR + get_hartid()*2) = DEFAULT_EXIT_CODE - get_hartid();

  return 0;
}