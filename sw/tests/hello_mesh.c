#include "redmule_tile_utils.h"
#include "redmule_mesh_utils.h"

int main(void) {
  h_pprintf("Hello World! it is hartid "); pprintf(ds(get_hartid())); pprintln;

  mmio32(TEST_END_ADDR + get_hartid()) = DEFAULT_EXIT_CODE - get_hartid();

  return 0;
}