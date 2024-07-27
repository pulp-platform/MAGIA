#include "redmule_tile_utils.h"
#include "redmule_mesh_utils.h"

int main(void) {
  printf("Hello World! it is hartid 0x%0x\n", get_hartid());

  mmio32(TEST_END_ADDR + get_hartid()) = DEFAULT_EXIT_CODE - get_hartid();

  return 0;
}