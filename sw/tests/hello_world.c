#include <stdio.h>
#include "tinyprintf.h"

int test_id = 0;
int *test_end_addr = 0x2C030000;

int main(void) {
  printf("Hello World!, it's test %d\n", test_id);

  *test_end_addr = 0xFFFFFFFF;

  return 0;
}