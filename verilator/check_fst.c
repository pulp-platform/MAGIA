/* Copyright 2026 ETH Zurich and University of Bologna
 * SPDX-License-Identifier: Apache-2.0
 */

/* Check an FST's scope tree using Verilator's bundled GTKWave fstapi reader.
 * Do not replace this with tsunami for value or hierarchy validation: tsunami
 * is known to byte-swap wide values in this project.
 *
 * The point of the check is the tile interiors. A --hierarchical model whose
 * trace was opened before its magia_tile_hier children existed still produces
 * a large, perfectly readable FST -- it just has nothing below i_magia_tile.
 * Counting variables therefore proves nothing; matching scopes does. */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <gtkwave/fstapi.h>

enum { k_max_tiles = 64, k_path_size = 16384, k_scope_depth = 512 };

static int tiles_y = 4;
static int tiles_x = 4;

/* The instance name must end where we say it does, otherwise the tile's own
 * siblings i_magia_tile_router / i_magia_tile_ni would match it too. */
static int ends_instance(char c) { return c == '\0' || c == '.'; }

static int has_tile_scope(const char* path, int y, int x) {
    char expected[128];
    const int len = snprintf(expected, sizeof(expected),
                             "gen_y_tile[%d].gen_x_tile[%d].i_magia_tile", y, x);
    const char* const hit = strstr(path, expected);
    return hit != NULL && ends_instance(hit[len]);
}

/* True for the tile scope itself or anything below it. */
static int is_tile_scope(const char* path) {
    const char* const tile = strstr(path, "i_magia_tile");
    return tile != NULL && ends_instance(tile[12]);
}

static void append_name(char* path, size_t* path_len, const char* name) {
    const size_t name_len = strlen(name);
    const size_t separator = *path_len ? 1U : 0U;
    if (*path_len + separator + name_len >= k_path_size) {
        fprintf(stderr, "error: FST scope path exceeds %d bytes\n", k_path_size - 1);
        exit(2);
    }
    if (separator) path[(*path_len)++] = '.';
    memcpy(path + *path_len, name, name_len + 1U);
    *path_len += name_len;
}

static int parse_dim(const char* text, const char* what) {
    char* end;
    const long value = strtol(text, &end, 10);
    if (*end != '\0' || value < 1 || value > k_max_tiles) {
        fprintf(stderr, "error: %s must be 1..%d, got '%s'\n", what, k_max_tiles, text);
        exit(2);
    }
    return (int)value;
}

int main(int argc, char** argv) {
    void* reader;
    struct fstHier* item;
    char path[k_path_size] = {0};
    size_t path_len = 0;
    size_t stack[k_scope_depth];
    size_t depth = 0;
    static int found_tiles[k_max_tiles][k_max_tiles];
    int tile_count = 0;
    int expected_tiles;
    char parent_signal[k_path_size] = {0};
    char child_signal[k_path_size] = {0};

    if (argc != 2 && argc != 4) {
        fprintf(stderr, "usage: %s <trace.fst> [tiles_y tiles_x]\n", argv[0]);
        return 2;
    }
    if (argc == 4) {
        tiles_y = parse_dim(argv[2], "tiles_y");
        tiles_x = parse_dim(argv[3], "tiles_x");
    }
    expected_tiles = tiles_y * tiles_x;

    reader = fstReaderOpen(argv[1]);
    if (!reader) {
        fprintf(stderr, "error: cannot read FST '%s'\n", argv[1]);
        return 2;
    }

    while ((item = fstReaderIterateHier(reader)) != NULL) {
        if (item->htyp == FST_HT_SCOPE) {
            if (depth == k_scope_depth) {
                fprintf(stderr, "error: FST scope nesting exceeds %d\n", k_scope_depth);
                fstReaderClose(reader);
                return 2;
            }
            stack[depth++] = path_len;
            append_name(path, &path_len, item->u.scope.name);
        } else if (item->htyp == FST_HT_UPSCOPE) {
            if (depth == 0) {
                fprintf(stderr, "error: malformed FST hierarchy (extra upscope)\n");
                fstReaderClose(reader);
                return 2;
            }
            path_len = stack[--depth];
            path[path_len] = '\0';
        } else if (item->htyp == FST_HT_VAR) {
            /* Only a variable proves a scope carries data; an empty scope can
             * be emitted by the parent's prefix push alone. */
            if (!parent_signal[0] && strstr(path, "magia_tb") && !is_tile_scope(path)) {
                (void)snprintf(parent_signal, sizeof(parent_signal), "%s.%s", path,
                               item->u.var.name);
            }
            if (is_tile_scope(path)) {
                if (!child_signal[0]) {
                    (void)snprintf(child_signal, sizeof(child_signal), "%s.%s", path,
                                   item->u.var.name);
                }
                for (int y = 0; y < tiles_y; ++y) {
                    for (int x = 0; x < tiles_x; ++x) {
                        if (!found_tiles[y][x] && has_tile_scope(path, y, x)) {
                            found_tiles[y][x] = 1;
                            ++tile_count;
                        }
                    }
                }
            }
        }
    }

    printf("FST variables: %llu\n", (unsigned long long)fstReaderGetVarCount(reader));
    printf("Tile hierarchy scopes with signals: %d/%d\n", tile_count, expected_tiles);
    if (parent_signal[0]) printf("Representative parent signal: %s\n", parent_signal);
    if (child_signal[0]) printf("Representative child signal: %s\n", child_signal);
    for (int y = 0; y < tiles_y; ++y) {
        for (int x = 0; x < tiles_x; ++x) {
            if (!found_tiles[y][x]) printf("missing: gen_y_tile[%d].gen_x_tile[%d]\n", y, x);
        }
    }

    fstReaderClose(reader);
    if (!parent_signal[0] || !child_signal[0] || tile_count != expected_tiles) {
        fprintf(stderr,
                "error: expected parent signals plus internals of all %d tiles\n",
                expected_tiles);
        return 1;
    }
    return 0;
}
