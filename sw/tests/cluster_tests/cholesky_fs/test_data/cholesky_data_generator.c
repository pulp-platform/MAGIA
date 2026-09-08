/*
 * Copyright (C) 2026 Copyright ETH Zurich, University of Bologna,
 * and Fondazione Chips-IT
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * SPDX-License-Identifier: Apache-2.0
 *
 * Authors: Victor Isachi <victor.isachi@unibo.it>
 *
 * MAGIA Cholesky Test Using PULP Cluster Input Data Generator
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>

static uint32_t float_to_hex(float x){
    union {
        float f;
        uint32_t u;
    } v;

    v.f = x;
    return v.u;
}

static void cholesky(float *a, float *l, int n){
    for (int i = 0; i < n * n; i++)
        l[i] = 0.0f;

    for (int i = 0; i < n; i++) {
        for (int j = 0; j <= i; j++) {

            float sum = a[i * n + j];

            for (int k = 0; k < j; k++)
                sum -= l[i * n + k] * l[j * n + k];

            if (i == j)
                l[i * n + j] = sqrtf(sum);
            else
                l[i * n + j] = sum / l[j * n + j];
        }
    }
}

static void print_float_matrix(FILE *f, const char *name, float *m, int n){
    fprintf(f, "extern float %s [M_SIZE*M_SIZE] = {\n", name);

    for (int i = 0; i < n; i++) {
        fprintf(f, "   ");

        for (int j = 0; j < n; j++) {
            int idx = i * n + j;

            fprintf(f, "% .9ef", m[idx]);

            if (idx != n * n - 1)
                fprintf(f, ", ");
        }

        fprintf(f, "\n");
    }

    fprintf(f, "};\n\n");
}

static void print_hex_matrix(FILE *f, const char *name, float *m, int n){
    fprintf(f, "extern uint32_t %s [M_SIZE*M_SIZE] = {\n", name);

    for (int i = 0; i < n; i++) {
        fprintf(f, "   ");

        for (int j = 0; j < n; j++) {
            int idx = i * n + j;

            fprintf(f, "0x%08x", float_to_hex(m[idx]));

            if (idx != n * n - 1)
                fprintf(f, ", ");
        }

        fprintf(f, "\n");
    }

    fprintf(f, "};\n\n");
}

int main(int argc, char **argv){
    if (argc != 2) {
        printf("Usage: %s <M_SIZE>\n", argv[0]);
        return 1;
    }

    int n = atoi(argv[1]);

    if (n <= 0) {
        printf("M_SIZE must be positive\n");
        return 1;
    }

    float *r = malloc(n * n * sizeof(float));
    float *a = malloc(n * n * sizeof(float));
    float *l = malloc(n * n * sizeof(float));

    srand(1);

    /*
     * Generate random R with values approximately in [-1, 1].
     */
    for (int i = 0; i < n * n; i++) {
        r[i] = 2.0f * rand() / RAND_MAX - 1.0f;
    }

    /*
     * A = R * R^T + n * I
     *
     * This guarantees that A is symmetric positive definite.
     */
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {

            float sum = 0.0f;

            for (int k = 0; k < n; k++)
                sum += r[i * n + k] * r[j * n + k];

            if (i == j)
                sum += n;

            a[i * n + j] = sum;
        }
    }

    /*
     * Compute A = L * L^T.
     */
    cholesky(a, l, n);

    /*
     * Open output file.
     */
    char filename[64];

    sprintf(filename, "spd_mat_%dx%d.h", n, n);

    FILE *f = fopen(filename, "w");

    if (f == NULL) {
        printf("Could not open output file\n");

        free(r);
        free(a);
        free(l);

        return 1;
    }

    /*
     * Header.
     */
    fprintf(f, "// Auto-generated SPD matrix A of size %dx%d\n", n, n);
    fprintf(f, "// RNG seed: 1\n\n");
    fprintf(f, "#ifndef _SPD_MAT_GEN_%dx%d_\n", n, n);
    fprintf(f, "#define _SPD_MAT_GEN_%dx%d_\n\n", n, n);
    fprintf(f, "#define M_SIZE (%d)\n\n", n);

    /*
     * Matrices.
     */
    print_float_matrix(f, "a_float", a, n);
    print_hex_matrix(f, "a_hex", a, n);

    print_float_matrix(f, "l_float", l, n);
    print_hex_matrix(f, "l_hex", l, n);

    /*
     * Footer.
     */
    fprintf(f, "#endif /*_SPD_MAT_GEN_%dx%d_*/\n", n, n);

    fclose(f);

    free(r);
    free(a);
    free(l);

    printf("Generated %s\n", filename);

    return 0;
}