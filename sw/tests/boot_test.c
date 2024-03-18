#include <stdio.h>

int main(void) {
  volatile unsigned int *test_end_addr = (volatile unsigned int *) 0x2C030000;
  unsigned char exit_code = 0xAB;

  *test_end_addr = exit_code;

  return 0;
}