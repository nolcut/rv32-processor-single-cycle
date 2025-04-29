## Basic RISC-V implementation

To simulate, you will need Icarus Verilog. Navigate to the src directory and type in the commands:
```
>> iverilog -g2012 -o beaver32rv_test **/*.sv
>> vvp beaver32rv_test
```
Currently, the processor loads a program that multiplies the first two words stored in data memory and stores the result in x3.
To change the inputs, edit the mem[0] and mem[1] assignments in the DataMemory.sv module

Instructions tested:
* add
* sub
* or
* and
* xor
* lw
* sw
* beq
* bne
* blt 
* bge
* sll
* srl
* sra
* addi


## Installing Icarus
**Brew install:** brew install icarus-verilog  
**Apt install:** sudo apt install iverilog   
Or [see here](https://steveicarus.github.io/iverilog/usage/installation.html)    