addi x2, x0, 255
sb x2, 0(x0)
sb x2, 5(x0)
sb x2, 10(x0)
sb x2, 15(x0)
lb x3, 0(x0)
lb x4, 5(x0)
lb x5, 10(x0)
lb x6, 15(x0)
addi x1, x0, 1023
sh x1, 6(x0)
lh x7, 6(x0)