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
* add, sub, or, and, xor
* addi, ori, andi, xori
* lw, lh, lb, sb, sw, sh
* beq, bne, blt, bge
* jal, jalr
* sll, srl, sra
* slli, srli, srai
* slt, sltu, slti, sltiu
* lui, auipc

## Schematic
<img width="921" alt="image" src="https://github.com/user-attachments/assets/0536fc65-8854-4815-b3dd-5dddd63f59f2" />




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

## The datapath as a kitchen
Imagine you have a kitchen with 5 people, and much like a real kitchen, each of these people has a set of tasks that they can choose to do at any particular time. One person may choose to either fetch ingredients from the pantry, fridge, or freezer; another (the dishwasher) may decide which dish to wash; the line cooks must decide whether they should boil water, cut vegetables, stir-fry, etc. Of course, each of these people needs a reason to do a task--no sensible restaurant is going to make a dish that hasn’t even been ordered. Therefore, when people order food, the kitchen is informed with kitchen order tickets. These tickets “encode” which task each person needs to complete (though, unlike a computer, this decision is implicitly made by each person); for example, if a person orders a stir-fry, then one of the cooks must, of course, stir-fry the ingredients. In a similar sense, each part of the data path has a set of operations that they can perform. The ALU is an obvious example; if you want to add two numbers, regardless of whether it’s an arithmetic, immediate, branching, or memory access instruction, then you know for a fact that the ALU must choose to add the two inputs it receives. Similarly, every portion of the datapath must choose how to behave based on the type of instruction being executed. Each section is modular; the ALU does not need to “think” about what inputs it receives–-it simply is told to add, subtract, shift, etc. By tying these behaviors together, we get the intended effect of the instruction and are able to reuse the same datapath to perform all of our instructions (much like how a restaurant can make many dishes with the same kitchen). These behaviors are specified in the opcode, funct3, and funct7 portions of RISC-V instructions, and it is the decoder's job to signal to each portion of the datapath how they must behave. Here are some examples:

### R-Type
<img width="807" alt="image" src="https://github.com/user-attachments/assets/1b954a6f-16df-4ab1-893d-290ae83d4b34" />

### Load
<img width="862" alt="image" src="https://github.com/user-attachments/assets/d7e05cd7-9623-468e-8d31-9b6d358ef14d" />




