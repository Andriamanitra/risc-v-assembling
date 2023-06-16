.global _start

_start:
    # number of iterations
    li s1, 32
    # initialize counter to 1
    li s0, 1

    li s2, 3  # fizz when divisible by this
    li s3, 5  # buzz when divisible by this

loop:
    # set value of t1 to 1 if fizzing
    remu t0, s0, s2
    sltiu t1, t0, 1

    # set value of t2 to 1 if buzzing
    remu t0, s0, s3
    sltiu t2, t0, 1

    # t3 = print start address offset
    # 0 if fizzing, 4 otherwise
    xori t0, t1, 1
    slli t3, t0, 2

    # a2 = number of characters to print
    # 8 if t1 && t2
    # 4 if t1 || t2
    # 0 otherwise
    and a2, t1, t2
    slli a2, a2, 1
    xor a2, a2, t1
    xor a2, a2, t2
    slli a2, a2, 2

    # if a2 is not zero, we are either fizzing or buzzing
    bnez a2, print
    # a2 is zero, print s0 ones
    mv a2, s0
    li t3, 8

print:
    li a7, 64
    li a0, 1
    la a1, fizzbuzzones
    add a1, a1, t3
    ecall

    # print a newline
    # (using another system call, which is little bit wasteful)
    li a7, 64
    li a0, 1
    la a1, newline
    li a2, 1
    ecall

    # increment counter
    addi s0, s0, 1

    # jump back to start of the loop while s0 <= s1
    ble s0, s1, loop

exit:
    li a7, 93
    li a0, 0
    ecall


.data
newline:
    .asciz "\n"
fizzbuzzones:
    .asciz "FizzBuzz11111111111111111111111111111111"
