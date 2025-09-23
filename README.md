# Castor32: A Basic RISC-V Processor

This repo contains a Harvard architecture RV32I processor written in SystemVerilog and a Python CLI for simulation

## Using
To simulate the core, run the sim_runner.py script directly from the sim directory, or use the provided Docker container.  
<br>
The simulator supports batch, iterative, and prompted execution and displays register, data, and control state
throughout program execution
<br>  
For the sake of readability, memory indexes in the display are word sized. Though, the processor does support byte and halfword addressing


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
    num1:   mem[0] -- first operand (int)
    num2:   mem[1] -- second operand (int)
Result:
    output: x3 -- multiplication result
</pre>

### Fibonacci
Calculates the nth number in the Fibonacci sequence and stores the result in a0
<pre>
Inputs:  
    n:      mem[0] -- Fibonacci number to calculate (int)
Result:  
    output: a0 (x10) -- nth Fibonacci number (int)
</pre>

### Quicksort
Sorts an array in memory    
<pre>
Inputs:
    size:       a2 (x12) -- size of array (int)
    arr:        mem[0:size] -- array
Result:
    sorted_arr: mem[0:size] -- sorted array
</pre>

### Binary search
Finds a value in an array in O( log(n) ) time
<pre>
Inputs:
    size:   a2 (x12) -- size of array (int)
    target: a3 (x13) -- target value (int)
    arr:    mem[0:size] -- array to search
Result:
    res:    a0 (x10) -- index of target or -1
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

## Acknowledgements

Thank you to Christophe Gyurgyik for allowing me to include his [assembly programs](https://github.com/cgyurgyik/riscv-assembly)
<br>  
The design of this processor was loosely based off the architecture featured in Hennesey and Patterson's Computer Orginization and Design
