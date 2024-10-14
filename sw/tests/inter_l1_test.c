#include "redmule_mesh_utils.h"

int main() {
    int32_t error = 0;

    // Write the tiles ID to different L1 memory locations in other tiles
    for(int i=0; i<4; i++) {
        if(get_hartid() != i) {
            *(volatile int*) (L1_BASE + i*L1_SIZE + 0x1000 + get_hartid()*4) = (int) get_hartid();
        }
    }

    // Read back the values
    for (int i=0; i<4; i++) {
        if(get_hartid() != i) {
            if (*(volatile int *) (L1_BASE + i*L1_SIZE + 0x1000 + get_hartid()*4) != get_hartid()) {
                h_pprintf("Read wrong value, expected "); pprintf(ds(get_hartid())); pprintln;
                error++;
            }
        }
    }

    
    if(error == 0) {
        if(get_hartid() == 0) {
            h_pprintf("TEST PASSED!!"); pprintln;
        }
        mmio8(TEST_END_ADDR + get_hartid()) = PASS_EXIT_CODE;
    } else {
        if (get_hartid() == 0) {
            h_pprintf("TEST FAILED!!"); pprintln;
        }
        mmio8(TEST_END_ADDR + get_hartid()) = FAIL_EXIT_CODE;
    }

    return 0;
}