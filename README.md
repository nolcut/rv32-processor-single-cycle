## Castor32: A Basic RISC-V Processor

This repo contains a Harvard architecture RV32I processor written in SystemVerilog and a Python CLI for simulation

## Using
To simulate the core, run the sim_runner.py script directly or use the provided Docker container.  
<br>
The simulator supports batch, iterative, and prompted execution and displays register, data, and control state
throughout program execution


## Example output
<img width="600" height="723" alt="image" src="https://github.com/user-attachments/assets/d5da2821-93f9-4f88-9faa-1c4209958ea1" />

<img width="600" height="650" alt="image" src="https://github.com/user-attachments/assets/cf716936-b896-4b82-bb07-b34e7517e55f" />

## Schematic
![castor32-schematic](https://github.com/user-attachments/assets/6ed8bd3a-959c-42f0-bb4a-c64ee491fddd)


## Instructions tested:

- `add`, `sub`, `or`, `and`, `xor`  
- `addi`, `ori`, `andi`, `xori`  
- `lw`, `lh`, `lb`, `sw`, `sh`, `sb`  
- `beq`, `bne`, `blt`, `bge`  
- `jal`, `jalr`  
- `sll`, `srl`, `sra`, `slli`, `srli`, `srai`  
- `slt`, `sltu`, `slti`, `sltiu`  
- `lui`, `auipc`
  
## Built-in programs

### Multiply
Multiplies the first two words in memory and stores the result in x3    
<pre>
Inputs:
    num1: mem[0] -- first operand (int)
    num2: mem[1] -- second operand (int)
Result:
    output: x3 -- multiplication result
</pre>

### Fibonacci
Calculates the nth number in the Fibonacci sequence and stores the result in a0
<pre>
Inputs:  
    n: mem[0] -- Fibonacci number to calculate (int)
Result:  
    output: a0 (x10) -- nth Fibonacci number (int)
</pre>

### Quicksort
Sorts an array in memory    
<pre>
Inputs:
    size: a2 (x12) -- size of array (int)
    arr: mem[0:size] -- array
Result:
    sorted_arr: mem[0:size] -- sorted array
</pre>

## Adding programs

To run your own program, select "Run new program" and provide the path to your program (relative to the sim/programs folder).  
<br> 
At the moment, the processor supports binary .mem files and .s RISC-V
Assembly files


## Docker container
To simulate using the docker container, run:
```
>> docker pull nolcut/castor32
>> docker run -it nolcut/castor32
```
In order to run local programs, you need to mount your filesystem to the /sim/programs folder inside of the container using the -v flag  

For example, to make your current working directory accesible (using a Posix shell), run:
```
>> docker run -it -v $(pwd):/sim/programs nolcut/castor32
```

## Dependencies
When running the sim_runner.py script locally, these dependencies are required:
* `icarus-verilog` (system package)
* `riscv-assembler`

---

#### riscv-assembler
Install riscv-assembler from [this](https://github.com/nolcut/riscv-assembler.git) repo using the command:
```
>> pip install git+https://github.com/nolcut/riscv-assembler.git
```
This is not my package, but the main repo has some issues that cause crashes and is no longer being maintained

---

#### Icarus
Brew install:  
```
>> brew install icarus-verilog
```  
APT install:
```
>> sudo apt install iverilog
```  
Or [see here](https://steveicarus.github.io/iverilog/usage/installation.html)    

## To-do
* [ ] 5-stage pipeline
* [ ] Caching
* [ ] Branch prediction (starting with always takes)
* [ ] ECALL/EBREAK

## Background
RISC-V is an open source instruction set architecture born out of Berkeley’s Parallel Computing Laboratory. As the name implies, it is a RISC (reduced instruction set computer) ISA, meaning that it only includes "simple" instructions. When programming a RISC processor, complex operations are implemented in software by combining sets of smaller instructions. This is directly opposed to CISC (complex instruction set computer) ISAs, which opt to implement more complex functionality directly in hardware. For example, Vax—which is now antiquated—included POLY, a floating point operation that evaluated the value of a polynomial. Although these complex instructions simplify the process of writing code in assembly and are more efficient in niche cases, they increase the complexity of hardware and typically make up a small fraction of total run time. To address this issue, David Patterson founded the RISC project at UC Berkeley in 1980. What his group found is that architectures with simpler instructions tended to outperform the more complex existing architectures in general purpose computing contexts. Now, over 99% of microprocessors use RISC, with the notable exception being Intel’s x86. RISC-V is a relatively recent advent, having been created in 2010. The project was founded with the goal of developing an accessible, modular opensource ISA. To achieve this modularity, all full RISC-V implementations must use the base instruction set, and additional instruction subsets for multiplication, floating point operations, atomic operations, etc can be implemented on top of it.


## Acknowledgements

Thank you to Christophe Gyurgyik for allowing me to include his [assembly programs](https://github.com/cgyurgyik/riscv-assembly)
<br>  
The design of this processor was loosely based off the architecture featured in Hennesey and Patterson's Computer Orginization and Design
