# Day 01 of learning: Hello world!

Today's goal was to get an operating system running on real RISC-V hardware (StarFive VisionFive 2) and compile an assembly language hello-world on it.

To begin with I skimmed the [documentation for the board](https://doc-en.rvspace.org/VisionFive2/PDF/VisionFive2_QSG.pdf) and installed the 5V fan that came with the starter kit on the board. Installing the fan turned out to be surprisingly difficult due to the spring-loaded attachment mechanism but after 15 minutes of struggling I had it attached.

![StarFive VisionFive 2 in operation](https://github.com/Andriamanitra/risc-v-assembling/assets/10672443/83c615a4-8280-44dc-8829-9e08506ce36d)

Next up it was time to flash an operating system to the 16 GB eMMC module that came with the kit. I decided to go with [Ubuntu operating system](https://wiki.ubuntu.com/RISC-V/StarFive%20VisionFive%202) because they had a pre-installed server image readily available. I'm considering trying out different operating systems like Debian (images provided by Starfive) or Arch Linux later.
StarFive instructions said to use [BalenaEtcher](https://etcher.balena.io/) but I found out you could just as well use `dd` on the command line (as long as you're careful to not wipe the wrong drive!). In the end I used [SUSE Studio imagewriter](https://software.opensuse.org/package/imagewriter) because it was readily available from the package repositories for my operating system (OpenSUSE Tumbleweed) and it had a simple GUI to use for the job. To connect the eMMC module to my computer I used the eMMC-to-microSD adapter from the starter kit connected to a USB microSD reader (which I already had laying around). After getting everything connected the flashing process was easy, just a couple of clicks and then few minutes of waiting for the process to complete.

With an operating system ready to go all that was left to do was snap the eMMC module into its place on the bottom of the board, and connect the board to ethernet and a power supply. The board booted right up and after a while I could see its IP address in my router's admin panel. I used SSH to connect to it (`ssh ubuntu@192.168.xxx.yyy`) and after typing in the default password `ubuntu` I was immediately prompted to set a new password. Everything was working as expected. I proceeded to install a few essential packages like `gcc` and `stow` (for setting up my [dotfiles](https://github.com/Andriamanitra/dotfiles)). Unfortunately my preferred text editor, [micro](https://github.com/zyedidia/micro), was not installable from `apt` for RISC-V, but it was easy enough to cross-compile it on my main machine with a simple command `GOARCH=riscv64 make build`, and then just copy the executable over to the VisionFive 2 using `scp`. I think I will have to cross-compile a lot of software as we get further along...

![neofetch](https://github.com/Andriamanitra/risc-v-assembling/assets/10672443/131205b8-9b55-439c-b929-3cc6d9a45ba3)

It was time to start writing some RISC-V assembly. I'm quite new to assembly (not just RISC-V but in general) so I looked up a number of resources (linked below). I followed a hello world tutorial from a blog post and looked up each of the instructions used in their code to make sure I understood each step. The tutorial was using `ADDI a0, x0, 1` (add immediate) to set the value of register `a0` to 1. `x0` (also known as `zero`) is a special register in RISC-V that **always** has the value zero, so the instruction is essentially doing `a0 := 0 + 1`. In my version of the hello world I opted to use the pseudo-instruction `LI` (load immediate) in place of `ADDI`. Pseudo-instructions in RISC-V are just syntactic sugar to make writing common operations more convenient. They get translated to base instructions by the assembler. My final RISC-V hello-world source code is in the file `hello.s`.

The steps to get a simple assembly program running are:
1. Create a text file with the assembly code. The file extension is typically `.s`, or `.S` if it is intended to be used with a C pre-processor.
1. Compile the program to an object file with GNU assembler (`as`): `as -o filename.o filename.s`.
1. Link the object file with GNU linker (`ld`): `ld -o executable filename.o`
1. Run the executable: `./executable`
1. To disassemble the executable you can do: `objdump --disassemble executable`
**IMPORTANT**: Above instructions are for compiling and running the program on real RISC-V hardware. If you're using a computer with a different architecture you should use `riscv64-linux-gnu-as` and `riscv64-linux-gnu-ld`, and an emulator like [QEMU](https://www.qemu.org/docs/master/system/target-riscv.html) or [TinyEMU](https://bellard.org/tinyemu/) to run the executable.

A `Makefile` which does steps 1-4 when you do `make run` is included in this directory.

Disassembling the hello-world executable:
```console
$ objdump --disassemble hello

hello:     file format elf64-littleriscv


Disassembly of section .text:

00000000000100e8 <_start>:
   100e8:	04000893          	li	a7,64
   100ec:	00100513          	li	a0,1
   100f0:	00001597          	auipc	a1,0x1
   100f4:	01c58593          	add	a1,a1,28 # 1110c <__DATA_BEGIN__>
   100f8:	00d00613          	li	a2,13
   100fc:	00000073          	ecall
   10100:	05d00893          	li	a7,93
   10104:	00000513          	li	a0,0
   10108:	00000073          	ecall
```

Curiously the `li` pseudo-instruction is shown as just `li`, but `la` got translated into `auipc` (add upper immediate to program counter) and `add`. As I understand it RISC-V uses relative memory offsets like this instead of absolute memory addresses so it's possible to move pieces of code around without messing up all the memory references.

The resulting `hello` executable file is 1.3K in size, which is a lot more than the instructions and data alone would take, but significantly less than what the same code written in C and compiled with GCC would take (without any tricks). I assume the space is taken up by the ELF header, but I would like to investigate further to understand exactly what is going on. This post is already getting longer than planned though, so that investigation will have to wait for another day.


## Notes

* Comments start with `#` in RISC-V (unlike many other assembly languages which use `;` for comments)
* `.global` directive marks a symbol as global, which is necessary for `ld` to find it
* the `ld` linker uses `_start` label for the entry point by default, although it can be overridden with a command line option
* `.data` segment contains global and static variables. It has a fixed size but the data in it can change.
* `.ascii` directive places characters in the current location. `.string` (or its alias `.asciz`) would also work here (they add a terminating NULL byte `'\0'` to the string).
* `man syscall` tells about the calling convention (which registers are used for args, return values) in different architectures
* `man syscalls` lists all the system calls (each syscall has its own `man` page for details)
* The registers have aliases that reflect their typical usage, for example `x0` = `zero`, `x1` = `ra`, `x10` = `a0`.
* Instructions learned:
    * `ADD <target register>, <register>, <register>` – adds the values from two registers together and stores the result in target register
    * `ADDI <target register>, <register>, <immediate value>` – adds immediate value to the value of a register and stores the result in target register
    * `LI <target register>, <immediate value>` – pseudo-instruction that is functionally equivalent to `ADDI <target register>, zero, <immediate value>`
    * `LA <target register>, <symbol>` – pseudo-instruction that loads value of a symbol (in this case memory address of a label) to a register
    * `AUIPC <target register>, <immediate value>` – sets target register's value to sum of current program counter and a 32-bit value with high 20 bits from the immediate value and zeroes for low 12 bits
    * `ECALL` – environment call (system call), uses values from registers `a0`-`a5` as parameters to a system call specified by number in register `a7`. The return value of the syscall will be stored in `a0`.


## Links

* [RISC-V on Github](https://github.com/riscv)

* [RISC-V on Wikipedia](https://en.wikipedia.org/wiki/RISC-V)

* [RISC-V Assembler Reference](https://michaeljclark.github.io/asm.html) by Michael J. Clark

* [RISC-V instruction set cheat sheet](https://blog.translusion.com/images/posts/RISC-V-cheatsheet-RV32I-4-3.pdf) by Erik Engheim

* [List of RISC-V linux syscalls](https://jborza.com/post/2021-05-11-riscv-linux-syscalls/) by Juraj Borza

* [RISC-V Assembly Language Hello World](https://smist08.wordpress.com/2019/09/07/risc-v-assembly-language-hello-world/) blog post by Stephen Smith
