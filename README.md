## Basic RISC-V implementation

To simulate, you will need Icarus Verilog (or some other SystemVerilog simulation tool). Navigate to the src directory and type in the commands:
```
>> iverilog -g2012 -o beaver32rv_test **/*.sv
>> vvp beaver32rv_test
```
Currently, the processor loads a program that multiplies the first two words in memory and stores the result in x3.
To change the inputs, edit the mem[0] and mem[1] assignments in the DataMemory.sv module. To load a different program, edit readmemb$() in InstructionMemory.sv with the path to your (binary) program

<img width="1021" alt="Screenshot 2025-04-29 at 4 19 48 PM" src="https://github.com/user-attachments/assets/bb11cfa4-34c3-4145-983c-7ade312f42ff" />

Instructions tested (still need to fully validate):
* add, sub, or, and xor
* addi
* lw, lh, sb, sw, sh, sb
* beq, bne, blt, bge
* jal, jalr
* sll, srl, sra
* lui, auipc

## Schematic
<img width="889" alt="image" src="https://github.com/user-attachments/assets/edb188a3-5ece-433f-84dc-b92e8d8d6121" />



## Installing Icarus
**Brew install:** brew install icarus-verilog  
**Apt install:** sudo apt install iverilog   
Or [see here](https://steveicarus.github.io/iverilog/usage/installation.html)    

## To-do
* [ ] 5-stage pipeline
* [ ] Caching
* [ ] Branch prediction (starting with always takes)
* [ ] ECALL/EBREAK

## Background
RISC-V is an open source instruction set architecture born out of Berkeley’s Parallel Computing Laboratory. As the name implies, it is a RISC (reduced instruction set computer) ISA, meaning that it only includes "simple" instructions. When programming a RISC processor, complex operations are implemented in software by combining sets of smaller instructions. This is directly opposed to CISC (complex instruction set computer) ISAs, which opt to implement more complex functionality directly in hardware. For example, Vax—which is now antiquated—included POLY, a floating point operation that evaluated the value of a polynomial. Although these complex instructions simplify the process of writing code in assembly and are more efficient in niche cases, they increase the complexity of hardware and typically make up a small fraction of total run time. To address this issue, David Patterson founded the RISC project at UC Berkeley in 1980. What his group found is that architectures with simpler instructions tended to outperform the more complex existing architectures in general purpose computing contexts. Now, over 99% of microprocessors use RISC, with the notable exception being Intel’s x86. RISC-V is a relatively recent advent, having been created in 2010. The project was founded with the goal of developing an accessible, modular opensource ISA. To achieve this modularity, all full RISC-V implementations must use the base instruction set, and additional instruction subsets for multiplication, floating point operations, atomic operations, etc can be implemented on top of it.


