// Copyright 2026 ETH Zurich and University of Bologna
// SPDX-License-Identifier: Apache-2.0

// Verilator main of the mesh and tile models: owns +FST dumping, which a --hierarchical testbench cannot do
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

// Model class from verilator.mk: Vmagia_tb (mesh) or Vmagia_tile_tb (tile)
#ifndef MAGIA_TOP
#define MAGIA_TOP Vmagia_tb
#endif
#define MAGIA_STR_(x) #x
#define MAGIA_STR(x) MAGIA_STR_(x)
#include MAGIA_STR(MAGIA_TOP.h)

#if VM_TRACE
#include "verilated_fst_c.h"
#endif

#include <csignal>
#include <cstdlib>
#include <cstring>
#include <memory>

// Mirrors --threads from verilator.mk. It has to match: VerilatedContext sizes
// its pool to every core on the machine when nobody sets it.
#ifndef MAGIA_THREADS
#define MAGIA_THREADS 1
#endif

#if VM_TRACE
// Path from +FST=<path>, or nullptr when no waveform was requested.
static const char* fstPath(VerilatedContext* contextp) {
    const char* const arg = contextp->commandArgsPlusMatch("FST=");
    if (!arg || std::strncmp(arg, "+FST=", 5) != 0 || arg[5] == '\0') return nullptr;
    return arg + 5;
}
#endif

// SIGINT/SIGTERM stop at the next time slot so the FST gets closed; a second signal kills
static volatile std::sig_atomic_t g_stop = 0;

static void onStopSignal(int sig) {
    if (g_stop) {
        std::signal(sig, SIG_DFL);
        std::raise(sig);
    }
    g_stop = 1;
}

int main(int argc, char** argv, char**) {
    std::signal(SIGINT, onStopSignal);
    std::signal(SIGTERM, onStopSignal);
    Verilated::debug(0);
    const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};
    contextp->threads(MAGIA_THREADS);
    // Like Questa, $error reports and goes on; +verilator+error+limit+N still overrides it
    contextp->errorLimit(1000000);
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
    const std::unique_ptr<MAGIA_TOP> topp{new MAGIA_TOP{contextp.get(), "TOP"}};

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

    // +STOP_AT=<time> ends the run before that time slot, so a hang leaves a closed FST
    const char* const stop_arg = contextp->commandArgsPlusMatch("STOP_AT=");
    const uint64_t stop_at =
        (stop_arg && stop_arg[0]) ? std::strtoull(stop_arg + 9, nullptr, 0) : UINT64_MAX;

    while (VL_LIKELY(!contextp->gotFinish()) && !g_stop) {
        if (!topp->eventsPending()) break;
        if (topp->nextTimeSlot() >= stop_at) {
            g_stop = 1;
            break;
        }
        contextp->time(topp->nextTimeSlot());
        topp->eval();
#if VM_TRACE
        if (tracep) tracep->dump(contextp->time());
#endif
    }

    if (g_stop) {
        VL_PRINTF("[INFO] interrupted at time %llu\n",
                  static_cast<unsigned long long>(contextp->time()));
    } else if (VL_LIKELY(!contextp->gotFinish())) {
        VL_DEBUG_IF(VL_PRINTF("+ Exiting without $finish; no events left\n"););
    }

    topp->final();
#if VM_TRACE
    // Flushes the FST hierarchy and value blocks; skipping it truncates the dump.
    if (tracep) tracep->close();
#endif
    contextp->statsPrintSummary();
    return g_stop ? 1 : 0;
}
