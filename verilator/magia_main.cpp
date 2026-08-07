// Copyright 2026 ETH Zurich and University of Bologna
// SPDX-License-Identifier: Apache-2.0

// Simulation entry point for the hierarchical Verilator build, replacing the
// one Verilator generates with --main. It exists to own waveform dumping,
// which the testbench cannot do correctly for a --hierarchical model.
//
// A hier_block instance is a protect-library child model: it is constructed by
// the DPI call in the generated wrapper during the *first* evaluation of the
// parent, and only then does it register its trace callbacks in the shared
// VerilatedContext. The parent's own trace registration emits an initLib()
// lookup per instance, matched by scope name against those child callbacks, so
// a trace opened from the testbench's time-zero $dumpvars runs that lookup
// before any child exists and silently dumps the parent only. Hence: evaluate
// once, then connect and open.

#include "verilated.h"

#include "Vmagia_tb.h"

#if VM_TRACE
#include "verilated_fst_c.h"
#endif

#include <cstring>
#include <memory>

#if VM_TRACE
// Path from +FST=<path>, or nullptr when no waveform was requested.
static const char* fstPath(VerilatedContext* contextp) {
    const char* const arg = contextp->commandArgsPlusMatch("FST=");
    if (!arg || std::strncmp(arg, "+FST=", 5) != 0 || arg[5] == '\0') return nullptr;
    return arg + 5;
}
#endif

int main(int argc, char** argv, char**) {
    Verilated::debug(0);
    const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};
    contextp->threads(1);
    contextp->commandArgs(argc, argv);

#if VM_TRACE
    const char* const fst_path = fstPath(contextp.get());
    // Has to be decided before the model is constructed.
    if (fst_path) contextp->traceEverOn(true);
#endif

    // "TOP" is not cosmetic. The parent looks its hier_block children up by
    // scope name, building the key as model-name + "." + instance path, while
    // each child registers under the $sformatf("%m") of its wrapper. The empty
    // name Verilator's generated --main passes yields a leading-dot key that
    // matches nothing, the children's trace codes are never allocated, and the
    // first dump segfaults inside fstWriterEmitValueChange. Any non-empty name
    // works; "TOP" is Verilator's own convention and prefixes every dumped
    // signal path with a "TOP" scope.
    const std::unique_ptr<Vmagia_tb> topp{new Vmagia_tb{contextp.get(), "TOP"}};

    // Constructs every hier_block child and registers its trace callbacks.
    topp->eval();

#if VM_TRACE
    std::unique_ptr<VerilatedFstC> tracep;
    if (fst_path) {
        VL_PRINTF("[INFO] dumping waveform to %s\n", fst_path);
        tracep.reset(new VerilatedFstC);
        topp->trace(tracep.get(), 0);
        tracep->open(fst_path);
        tracep->dump(contextp->time());
    }
#endif

    while (VL_LIKELY(!contextp->gotFinish())) {
        if (!topp->eventsPending()) break;
        contextp->time(topp->nextTimeSlot());
        topp->eval();
#if VM_TRACE
        if (tracep) tracep->dump(contextp->time());
#endif
    }

    if (VL_LIKELY(!contextp->gotFinish())) {
        VL_DEBUG_IF(VL_PRINTF("+ Exiting without $finish; no events left\n"););
    }

    topp->final();
#if VM_TRACE
    // Flushes the FST hierarchy and value blocks; skipping it truncates the dump.
    if (tracep) tracep->close();
#endif
    contextp->statsPrintSummary();
    return 0;
}
