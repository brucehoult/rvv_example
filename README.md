Simple RISC-V Vector example
============================

This is an example of writing the same vector processing function in C
and in assembly language for RISC-V Vector extension v1.0, and comparing
the results.

By default the generated program is run in qemu, but another emulator such
as Spike could also be used, or run on real RVV-capable hardware if you have
it.

### Getting the toolchain

I'm using the "embedded" toolchain which uses the Newlib C library and statically
links all needed libraries into the main program. This is more convenient for
running on emulators or downloading to a microcontroller-style boars, but will
also work on a native RISC-V Linux system.

Your favourite software repository might have a recent enough RISC-V toolchain,
but maybe not as the B and V extensions are still quite new as I write this.

Check out the latest version from https://github.com/riscv-collab/riscv-gnu-toolchain

Support for B and V extensions are already included in master branch.

Follow the instructions there, or copy what I use:

    # first install any neccessary packages for your OS, then....
    git clone https://github.com/riscv-collab/riscv-gnu-toolchain.git --recursive
    cd riscv-gnu-toolchain
    ./configure 
    make
    make build-qemu

Notes:

The instructions say you don't need recursive, but I find it more convenient
to get everything at one time so the build itself is faster.

Unusually, there is no "make install" step, so you need write permissions for the installation
location, or run "make" with sudo (ugh)

As always, add --prefix=<path> to ./configure if you don't want the RISC-V toolchain in /usr/local

By default you will get libraries for rv64gc only. If you want a good set of libraries so you
can experiment with rv32i, rv64i or other reduced configurations then add "--enable-multilib"
to the ./configure.

### Compiling and running the example

Just type "make"

Expected output:

    $ make
    riscv64-unknown-elf-gcc -O main.c vec.S -o main -march=rv64gcv_zba -lm
    qemu-riscv64 -cpu rv64,v=true,zba=true,vlen=128 ./main
    3.741657 3.741657
    8.774964 8.774964
    13.928389 13.928389
    19.104973 19.104973
    24.289915 24.289915
    29.478806 29.478806

You can trace the qemu execution by adding "-singlestep -d nochain,cpu" to the qemu command line.
Cross-reference instruction addresses with the output from "riscv64-unknown-elf-objdump -d main".
