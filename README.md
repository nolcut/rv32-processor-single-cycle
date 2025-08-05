## Basic RISC-V implementation

This repo contains a Harvard architecture RV32I processor written in SystemVerilog and a Python CLI for simulation

## Using
To simulate the core, run the wrapper.py script or use the Docker container.
The simulator supports batch, iterative, and prompted execution and displays register, data, and control state
throughout program execution


## Example output
<img width="657" height="723" alt="image" src="https://github.com/user-attachments/assets/d5da2821-93f9-4f88-9faa-1c4209958ea1" />
<img width="1040" height="427" alt="image" src="https://github.com/user-attachments/assets/cf716936-b896-4b82-bb07-b34e7517e55f" />

## Schematic
<img width="1842" height="1272" alt="beaver32-schematic" src="https://github.com/user-attachments/assets/6ed8bd3a-959c-42f0-bb4a-c64ee491fddd" />  

## Instructions tested:
* add, sub, or, and, xor
* addi, ori, andi, xori
* lw, lh, lb, sb, sw, sh
* beq, bne, blt, bge
* jal, jalr
* sll, srl, sra
* slli, srli, srai
* slt, sltu, slti, sltiu
* lui, auipc
  
## Built-in programs

### Multiply
Multiplies the first two words in memory and stores the result in x3    
<pre>
Inputs:
    num1: mem[0] -- int to multiply
    num2: mem[1] -- int to multiply
Result:
    output: x3 -- multiplication result
</pre>
  
### Fibonacci (to-do)
Calculates the nth number in the Fibonacci sequence and stores the result in x1  
<pre>
Inputs:  
    n: mem[0] -- int denoting which Fibonacci number to calculate
Result:  
    output: x3 -- nth Fibonacci number
</pre>

### Simple sort (to-do)  
Sorts an array in memory    
Edit mem[0] to specify size of the array to sort.  
<pre>
Inputs:
    size: mem[0] -- size of array
    arr: mem[1:size + 1] -- array
Result:
    sorted_arr: mem[1:size + 1] -- sorted array
</pre>

To run your own programs, select "Run new program" and provide the path to the program. At the moment, the processor only supports binary encoded .mem files.


## Docker container
To simulate using the docker container, run:
```
>> docker pull nolcut/castor32
>> docker run -it nolcut/castor32
```
In order to run local programs, you need to mount your filesystem to the /rv32-script folder inside of the container using the -v flag  
For example, to mount your current working directory, run:
```
>> docker run -it -v $(pwd):/rv32-script nolcut/castor32
```

## Dependencies
When running the wrapper.py script locally, the dependencies are:
* icarus-verilog (system package)
* riscv-assembler (PyPI)

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
