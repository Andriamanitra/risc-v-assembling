.globl to_upper      # make the routine visible to the linker

to_upper:            # void to_upper(char* in, char* out)
  li t1, 'a'
  li t2, 'z'
  j loop

next:
  addi a0, a0, 1     # increment input address
  addi a1, a1, 1     # increment output address

loop:
  lb t0, 0(a0)       # load a single byte from the address given as first argument

  blt t0, t1, skip   # skip uppercasing if t0 < 'a'
  blt t2, t0, skip   # skip uppercasing if 'z' < t0

  xori t0, t0, 32    # uppercase the alphabetic byte at t0

skip:
  sb t0, 0(a1)       # store byte to the address given as second argument
  bnez t0, next      # keep iterating unless the byte was NULL
  ret                # return from the routine
