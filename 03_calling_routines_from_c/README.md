# Day 03 of learning: Calling routines written in RISC-V assembly from C

After day 02 I took some time to read the book [Introduction to Assembly Programming with RISC-V](https://riscv-programming.org/book.html). The book provided a decent introduction to both assembly programming in general and especially RISC-V. Although some parts could have been explained more concisely or thoroughly I certainly feel less lost having read it. I haven't touched any code of my own since starting the book so I'm excited to get to put my newly acquired knowledge to good use. Today's goal is to write a routine in RISC-V, and link it with some C code. Being able to call assembly code from a higher level language should make testing things much easier.

The routine I'm implementing receives two pointers to C strings as its arguments. The first one points to the input, and the purpose of the routine is to store an uppercased version of that in the location pointed to by the second argument. This is the [MakeUpperCase problem on Codewars](https://www.codewars.com/kata/57a0556c7cb1f31ab3000ad7/riscv) ([my initial solution](https://www.codewars.com/kata/reviews/630197d9e3b9860001ae7f76/groups/64a8bb0c75915a000123ccff), which is little bit messier version of the code in `to_upper.s`).


## RISC-V calling convention

The key to writing RISC-V routines is understanding the calling convention. The function receives arguments in registers `a0`..`a7` (if there were more parameters than can fit in the `a{N}` registers, they would be stored on the stack, but I think it would be a bad idea to write routines that take more than 8 arguments...). The register `a0` (and occasionally `a1`, if the return value does not fit in one register, for example when returning a 64-bit integer on a 32-bit machine) is also used for return values.

RISC-V calling convention dictates that the `a{N}` and `t{N}` registers are **not persisted across calls** (caller-saved). If you call another routine, the contents of those registers may change. To persist data it can be stored either on the stack or in one of the saved registers (`s0`..`s11`) that are by convention persisted between calls. If a routine uses the `s{N}` registers, it is supposed to restore its contents back to what they were (callee-saved).

The `ret` pseudo-instruction returns from a function. Its meaning is the same as `jalr zero, ra, 0` (jump and link register). It sets the program counter to the address stored in `ra` (return address) and stores the following address in `zero` (which is hardwired to zero, so the value gets discarded). The `jal` (jump and link) pseudo-instruction can be used can be used to store the return address and call a function.

The function is made visible to C code by declaring its signature and linking the object (.o) file (produced by `as`). See the `Makefile` for the full compilation process.


## RISC-V registers

The register width depends on the base variant. On RV64 (such as the board I have) the registers are 64 bits wide, but RV128 (128 bits) and RV32 (32 bits) variants also exist.

| Register | Alias   | Description            | Persistent    |
|----------|---------|------------------------|---------------|
| x0       | zero    | hardwired zero         | IMMUTABLE     |
| x1       | ra      | Return Address         | no            |
| x2       | sp      | Stack Pointer          | yes           |
| x3       | gp      | Global Pointer         | DO NOT MODIFY |
| x4       | tp      | Thread Pointer         | DO NOT MODIFY |
| x5-x7    | t0-t2   | Temporary register     | no            |
| x8       | s0 / fp | Saved / Frame Pointer  | yes           |
| x9       | s1      | Saved register         | yes           |
| x10      | a0      | Arg 0 / return value 0 | no            |
| x11      | a1      | Arg 1 / return value 1 | no            |
| x12-x17  | a2-a7   | Arg 2-7                | no            |
| x18-x27  | s2-s11  | Saved register         | yes           |
| x28-x31  | t3-t6   | Temporary register     | no            |
| pc       | pc      | Program counter        | -             |

Note that on RV32E (variant meant for resource-constrained embedded applications) there are only 16 registers (`x0`-`x15`).


## Notes

* RISC-V registers are (by convention) either caller- or callee-saved

* Data types for data movement (store/load) instructions:
    * `B` - byte (8 bits)
    * `BU` - unsigned byte (8 bits)
    * `H` - halfword (16 bits)
    * `HU` - unsigned halfword (16 bits)
    * `W` - word (32 bits)
    * `WU` - unsigned word (32 bits)
    * `D` - double (64 bits)

* Instructions learned:
    * `SB|SH|SW|SD <register1>, <offset>(<register2>)` - store data from register1 to address calculated by adding offset to value of register2
    * `SB|SH|SW|SD <register>, <label>` - pseudo-instruction that stores data from register to address pointed to by label
    * `LB|LBU|LH|LHU|LW|LWU|LD <register1>, <offset>(<register2>)` - load data from address calculated by adding offset to value of register2
    * `LB|LBU|LH|LHU|LW|LWU|LD <register>, <label>` - pseudo-instruction that stores data from register to address pointed to by label
    * `RET` – pseudo-instruction to jump back to return address (`ra`)
    * `JAL <label>` - pseudo-instruction to set the return address (`ra`) and jump to a label
    * `JALR <target register>, <register>, <offset>` - stores PC+4 in target register, jumps to address calculated by adding offset to value of register
