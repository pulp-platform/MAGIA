#define L1_BASE       (0x10000000)
#define L2_BASE       (0x20000000)
#define TEST_END_ADDR (0x2C030000)

#define DEFAULT_EXIT_CODE (0xAF)
#define PASS_EXIT_CODE    (0xA)
#define FAIL_EXIT_CODE    (0xF)

#define mmio32(x) (*(volatile uint32_t *)(x))
