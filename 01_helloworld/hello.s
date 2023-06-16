.global _start

_start:
	# write(1, helloworld, 13)
	li a7, 64            # syscall number = 64 = write
	li a0, 1             # fd = 1 (stdout)
	la a1, helloworld    # buf = address of the label helloworld
	li a2, 13            # count = 13 (length of the string to write)
	ecall

	# exit(0)
	li a7, 93            # syscall number = 93 = exit
	li a0, 0             # exitcode = 0
	ecall

.data
helloworld:
	.ascii "Hello world!\n"
