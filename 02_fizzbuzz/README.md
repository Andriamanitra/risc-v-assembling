# Day 02 of learning: FizzBuzz

Today's goal was to write a fizzbuzz from scratch in RISC-V assembly. To solve FizzBuzz I would first have to learn how to loop, do conditional branching, and print numbers.

Major obstacle for today's task was printing numbers. I wanted to do the printing using plain system calls (without relying on C standard library), so it's not as simple as calling `printf()`. I would have to do my own conversion from plain numbers (bits) to the ascii character values representing that number. In assembly that is not an entirely trivial task for numbers larger than 9, so I decided I would just print the numbers using unary notation: 1 is "1", 2 is "11", 3 is "111", and so on. This allowed me to focus on learning the fundamentals first.

I figured I could store a string "FizzBuzz11111111111111" in the `.data` section, and then calculate a point in that string where the print would start, and number of characters that should be printed from that point onwards. After that it was just a lot of fiddling with bitwise operators to get the offsets correct. For getting the remainder RISC-V's M standard extension (for integer multiplication and division) has a `REMU` (remainder unsigned) instruction. Because it's from an extension it is some smaller RISC-V computers may not have this instruction available.


## Notes

* RISC-V ISA has a minimal base set of instructions, and a number of standard extensions that provide more instructions. Chip manufacturers can choose to not implement some of the extensions in order to save on costs and size of the chip. The VisionFive 2 board I have supports the "GC" collection of extensions, which includes all instructions needed for a general purpose operating system.

* RISC-V has different kinds of registers: `t0`-`t6` are temporary (not preserved across calls), `s0`-`s11` are preserved across calls.

* Instructions learned:
    * `REMU <target register>, <register>, <register>`: sets the target register's value to the remainder of the division between the two registers
    * `SLTIU <target register>, <register>, <immediate value>` (set less than immediate unsigned): sets the target register value to 1 if register's value is less than the immediate value (and 0 otherwise).
    * Bitwise logic: `XOR`, `AND`, `OR` and their immediate value versions `XORI`, `ANDI`, `ORI`. They all follow the pattern `<instruction> <target register>, <operand 1>, <operand 2>`.
    * Bit shifts: `SLL`/`SRL` (shift left/right logical), `SLLI`/`SRLI` (shift left/right logical immediate)
    * Branching based on comparison to zero pseudo-instructions:
    `BNEZ`, `BEQZ`, `BLTZ`, `BLEZ`, `BGTZ`, `BGEZ`. They all follow the pattern `<instruction> <register>, <label to jump to>`. NE = not equal, EQ = equal, LT = less than, GT = greater than, LE = less than or equal, GE = greater than or equal.
    * `MV <target register> <source register>`: pseudo-instruction that copies value from a register to another register.
