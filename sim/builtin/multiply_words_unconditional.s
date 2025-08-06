lw x1, 0(x0)        # load operand 1
lw x2, 4(x0)        # load operand 2

FOR:
beq x2, x4, END     # branch to end if finished
add x3, x3, x1      # add to sum
addi x4, x4, 1      # iterate counter
beq x0, x0, FOR     # jump to start of for loop

END:
