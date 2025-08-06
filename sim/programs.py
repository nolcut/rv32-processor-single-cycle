from pathlib import Path
from abc import ABC, abstractmethod
from riscv_assembler.convert import AssemblyConverter
from constants import PROG_PATH, DATA_PATH, RF_PATH, Registers, get_int, binary


class BuiltinProgram(ABC):
    """Built in program logic"""

    def __init__(self, name, description, path):
        self.name = name
        self.description = description
        self.path = path

    @abstractmethod
    def get_data(self):
        pass

    @abstractmethod
    def get_registers(self):
        pass

    def print_prog(self):
        """Prints program code and description"""

        with open(self.path, "r") as prog_file:
            lines = "\n".join(prog_file.readlines())

        msg = (
            f"============================ {self.name.upper()} ============================\n"
            f"{lines}\n\n"
        )

        msg += f"{'=' * (58 + len(self.name))}\n"

        msg += f"{self.description}\n"

        print(msg)

    def load(self):
        """Prints program, prompts user for data/registers, and returns program name as a Path object"""

        self.print_prog()

        self.get_data()

        self.get_registers()
        
        return self.path
    

class Multiply(BuiltinProgram):
    """Multiply program"""
    def get_data(self):
        mem0_prompt = "Enter value for mem[0]: "
        mem0_err = "\nERROR: Value must be an integer\n"

        mem0 = get_int(mem0_prompt, mem0_err)
        
        mem1_prompt = "Enter value for mem[1]: "
        mem1_err = "\nERROR: Value must be an integer\n"

        while True:
            mem1 = get_int(mem1_prompt, mem1_err)

            if mem1 < 0:
                print("\nERROR: Operand 2 must be a positive\n")
            else:
                break

        set_file_line(DATA_PATH, 0, mem0)
        set_file_line(DATA_PATH, 1, mem1)

    def get_registers(self):
        pass


class Fibonacci(BuiltinProgram):
    """Memoized fibonacci program"""
    def get_data(self):
        pass

    def get_registers(self):
        """Get n and store in a0"""
        prompt = "Enter value for n: "
        err_msg = "\nERROR: Value must be an integer\n"

        while True:
            n = get_int(prompt, err_msg)

            if n < 0:
                print("\nERROR: n must be a positive\n")
            else:
                break

        set_file_line(RF_PATH, Registers.a0, n)


class QuickSort(BuiltinProgram):
    """Quicksort program"""
    def load(self):
        """Prints program, prompts user for data/registers, and returns program name as a Path object"""

        self.print_prog()

        arr_size = self.get_registers()

        self.get_data(arr_size)
        
        return self.path

    def get_data(self, arr_size):
            print("\nEnter your array entries: ")
            arr = []
            for i in range(arr_size):
                prompt = f"mem[{i}]: "
                err_msg = f"\nERROR: Value for mem[{i}] must be an integer\n"

                arr_entry = get_int(prompt, err_msg)

                set_file_line(DATA_PATH, i, arr_entry)

    def get_registers(self):
        """Get the size of the array and store in a0"""
        prompt = "Enter the size of the array to sort: "
        err_msg = "\nERROR: Value must be an integer\n"
        
        arr_size = get_int(prompt, err_msg)

        set_file_line(RF_PATH, Registers.a2, arr_size - 1)

        return arr_size


def set_file_line(file, index, val):
    """
    Sets entry inside of file at index (0 indexed) equal to val

    Arguments:
        file -- Path object representing file to write to
        index -- int
        val -- int
    """
    with open(file, "r") as f:
        lines = f.readlines()

    lines[int(index)] = binary(val) + "\n"

    with open(file, "w") as f:
        f.writelines(lines)


def create_program_file(program=None):
    """
    Creates the program.mem file that the processor reads from

    Arguments:
        program: str | None -- selected user program
    """

    with open(program, "r") as prog_file:
        code = prog_file.readlines()

    if program.suffix.lower() == ".s": 
        assembler = AssemblyConverter()
        
        code = "".join(code)

        code = assembler.convert(code)

    with open(PROG_PATH, "w") as prog_file:
        if program:
            prog_file.write("\n".join(code))

