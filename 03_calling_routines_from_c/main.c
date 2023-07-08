#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// to_upper() function/routine is written in RISC-V assembly and compiled into
// an object file (check the Makefile for the details)
// this declaration is not strictly necessary but gcc will give warnings about
// implicit function declarations
void to_upper(char* in, char* out);

int main(int argc, char** argv) {
    if (argc > 1) {
        // allocate memory for the output so the assembly code doesn't need to
        // worry about it
        char* out = malloc(strlen(argv[1]) + 1);

        // calling the "function" works as usual
        to_upper(argv[1], out);

        printf("%s\n", out);
        free(out);
    }
    return 0;
}
