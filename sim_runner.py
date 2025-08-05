import atexit
import json
import sys
from enum import IntEnum
from pathlib import Path
from time import sleep

from riscv_assembler.convert import AssemblyConverter

from simulation import Simulation

BUILTIN_PROGRAMS = {
    "multiply": "SystemVerilog/InstructionMemory/multiply_words_unconditional",
    "fibonacci": "TODO",
    "simple_sort": "TODO",
}
DATA_ADDR_WIDTH = 8

DATA_PATH = Path("SystemVerilog") / Path("DataMemory") / "data.mem"
PROG_PATH = Path("SystemVerilog") / Path("InstructionMemory") / "program.mem"
PC_PATH = Path("SystemVerilog") / Path("ProgramCounter") / "pc.txt"
RF_PATH = Path("SystemVerilog") / Path("RegisterFile") / "reg.mem"

simulation = Simulation()


class Mode(IntEnum):
    BATCH = 1
    ITERATIVE = 2
    PROMPTED = 3


def main():
    while True:
        print(
            "\nEnter mode of execution:\n"
            "1. Batch: Run an entire program\n"
            "2. Iterative: Run an entire program line by line\n"
            "3. Prompted: Manually enter instructions\n"
        )

        valid_inputs = {str(Mode.BATCH), str(Mode.ITERATIVE), str(Mode.PROMPTED)}
        first_prompt = "Enter 1-3: "
        err_msg = "Invalid input (1-3 only): "

        selection = int(get_input(valid_inputs, first_prompt, err_msg))

        match (selection):
            case Mode.BATCH:
                batch_exec()
            case Mode.ITERATIVE:
                iterative_exec()
            case Mode.PROMPTED:
                prompted_exec()

        print("\nWould you like to run another program?")

        selection = get_input(
            valid_inputs={"yes", "no"},
            first_prompt="Enter yes or no: ",
            err_prompt="Invalid input (yes or no only): ",
        )

        if selection == "no":
            break
        else:
            print("\n")


def batch_exec():
    """Executes a program in it's entirety"""
    clear_sim_files()
    prog_name = load_program()

    if prog_name not in BUILTIN_PROGRAMS:
        set_init_state()

    print("Initializing register and memory state...")

    simulation.start()

    pc = read_pc()

    while more_lines(pc / 4):
        run_iteration()
        pc = read_pc()

    simulation.kill()

    print("Program complete")


def iterative_exec():
    """Executes a program line by line"""
    clear_sim_files()
    prog_name = load_program()

    if prog_name not in BUILTIN_PROGRAMS:
        set_init_state()

    print("Initializing register and memory state...")

    simulation.start()

    pc = read_pc()

    while more_lines(pc / 4):
        print("\nEnter the number of instructions you would like to execute:")
        iterations = input()

        while not iterations.isdigit():
            iterations = input("Please enter a valid integer: ")

        for i in range(int(iterations)):
            if not more_lines(pc / 4):
                break
            else:
                run_iteration()
                pc = read_pc()

    simulation.kill()

    print("Program complete")


def prompted_exec():
    """Executes instructions from STDIN"""
    assembler = AssemblyConverter()

    clear_sim_files()

    set_init_state()

    print("Initializing register and memory state...")

    simulation.start()

    while True:
        instruction = input("\nEnter intruction (or exit): \n")

        if instruction.lower() == "exit":
            break

        try:
            instruction = assembler.convert(instruction)[0]
        except Exception:
            print("Invalid instruction")
            continue

        add_instruction(instruction)

        run_iteration()

    simulation.kill()

    print("\nProgram ended")


def add_instruction(instruction):
    """
    Adds assembled instruction to program.mem

    Arguments:
        instruction -- str (assembled instruction)
    """
    with open(PROG_PATH, "a") as prog_file:
        prog_file.write(f"{instruction}\n")


def run_iteration():
    """Runs a single instruction"""
    set_control(1)
    sleep(0.1)


def more_lines(line_num):
    """
    Returns whether or not the current line
    inside of program.mem number is valid
    """
    if line_num == "x":
        return False
    else:
        line_num = int(line_num)

    with open(PROG_PATH) as prog_file:
        lines = prog_file.readlines()
    return line_num < len(lines)


def clear_pc():
    """Sets pc.txt to 0"""
    with open(PC_PATH, "w") as pc_file:
        pc_file.write("0")


def read_pc():
    """Read program counter and return it's position"""
    with open(PC_PATH, "r") as pc_file:
        val = pc_file.read().strip()
        if val == "x":
            return float("inf")
        elif not val.isdigit():
            print("Error: PC must be digit or x")
            sys.exit(1)
        return int(val)


def clear_data():
    """Sets data.mem entries to 0"""

    with open(DATA_PATH, "w") as data_file:
        for _ in range(2**DATA_ADDR_WIDTH):
            data_file.write("0\n")


def binary(num):
    """Returns a 32-bit two's complement binary representation of num."""
    MIN = -(2**31)
    MAX = 2**31 - 1

    try:
        val = int(num)
        if val < MIN or val > MAX:
            print(f"Error: {val} is out of 32-bit signed integer bounds.")
            return None
        if val < 0:
            val = (1 << 32) + val  # two's complement
        return format(val, "032b")
    except (ValueError, TypeError):
        print("Error: invalid input. Expected an integer or integer string.")
        return None


def clear_reg():
    """Sets reg.mem entries to 0"""
    with open(RF_PATH, "w") as reg_file:
        for _ in range(32):
            reg_file.write("0\n")


def set_control(control):
    """Sets control.txt to 0, 1, or 2"""
    if not isinstance(control, int) or control > 2 or control < 0:
        print("Control must only be set to 2, 1, or 0", flush=True)
        sys.exit(1)

    with open("control.txt", "w") as control_file:
        control_file.write(str(control))


def create_program_file(program=None):
    """
    Creates the program.mem file that the processor reads from

    Arguments:
        program: file | None -- selected user program
    """
    with open(PROG_PATH, "w") as prog_file:
        if program:
            prog_file.write(program.read())


def clear_program_file():
    """Clears program.mem file"""
    with open(PROG_PATH, "w"):
        pass


def set_init_state():
    """
    Prompt user for initial state of program and store in
    register file (reg.mem) and data file (data.mem)
    """
    reg_msg = (
        "\nWould you like to edit the initial register state "
        "(otherwise, all registers will be initialized to 0)?"
    )

    edit_state(reg_msg, "register", 32)

    data_msg = (
        "\nWould you like to edit data memory "
        "(otherwise, all words in memory will be initialized to 0)?"
    )

    edit_state(data_msg, "word", 2**DATA_ADDR_WIDTH)


def edit_state(msg, type, addr_range):
    """Prompts user to edit data or register state"""
    if type not in {"word", "register"}:
        print("Error: Can only modify words and registers (edit_state)")
        sys.exit(1)

    print(msg)

    edit = get_input(
        valid_inputs={"yes", "no"},
        first_prompt="Enter yes or no: ",
        err_prompt="Invalid input (yes or no only): ",
    )

    if edit == "yes":
        while True:
            print(f"\nWhich {type} would you like to modify?")

            lowest_idx = 1 if type == "register" else 0

            valid_ints = {str(i) for i in range(lowest_idx, addr_range)}

            index = get_input(
                valid_inputs=valid_ints,
                first_prompt=f"Enter {lowest_idx}-{addr_range - 1}: ",
                err_prompt=f"Invalid input (0-{addr_range - 1} only): ",
            )

            print_index = f"x{index}" if type == "register" else index

            val = input(f"Enter value for {type} {print_index}: ")
            while True:
                try:
                    val = int(val)
                    break
                except ValueError:
                    val = input("Value must be an integer: ")

            if type == "register":
                set_file_line(RF_PATH, index, val)
            elif type == "word":
                set_file_line(DATA_PATH, index, val)

            more_word_edits = get_input(
                valid_inputs={"yes", "no"},
                first_prompt="Continue editing (yes or no): ",
                err_prompt="Invalid input (yes or no only): ",
            )

            if more_word_edits == "no":
                break


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


def load_program():
    """
    Prompts user for program and loads into program.mem

    Return:
        string -- name of program
    """
    clear_sim_files()

    print("\nOptions:\n" "1. Run saved program\n" "2. Run new programs")
    valid_inputs = {"1", "2"}
    first_prompt = "\nEnter 1 or 2: "
    err_msg = "Invalid input (1 or 2 only): "

    selection = get_input(valid_inputs, first_prompt, err_msg)

    if Path("programs.json").exists():
        with open("programs.json", "r") as prog_file:
            programs = json.load(prog_file)
        existing_progs = programs.keys()
    else:
        existing_progs = {}

    # if using saved program, display options and prompt
    if selection == "1":
        print("\nPlease enter one of the following program names (case sensitive): ")

        print("\nBUILT-IN PROGRAMS:")
        for b in BUILTIN_PROGRAMS.keys():
            print(b)

        print("\nSAVED PROGRAMS:")
        for p in existing_progs:
            print(p)

        err_prompt = "Input does not match any saved programs\n" "Enter program: "

        prog_name = get_input(
            valid_inputs=existing_progs | BUILTIN_PROGRAMS.keys(),
            first_prompt="\nEnter program: ",
            err_prompt=err_prompt,
        )

        if prog_name not in BUILTIN_PROGRAMS:
            selected_prog_path = programs[prog_name]
        else:
            selected_prog_path = handle_builtin(prog_name)
    else:
        # if using a new program, store name and path in programs.json before running
        while True:
            selected_prog_path = Path(input("Enter path to program: "))
            if selected_prog_path.is_file():
                break
            else:
                print(f"File not found: {selected_prog_path}")

        while True:
            prog_name = input("Enter name for program: ")
            if prog_name in existing_progs | BUILTIN_PROGRAMS.keys():
                print("\nError: Name matches an existing program")
            else:
                break

        with open("programs.json", "w") as progs_json:
            json.dump(programs, progs_json, indent=4)

    # copy desired program to program.mem file
    with open(selected_prog_path, "r") as prog_file:
        create_program_file(prog_file)

    return prog_name


def handle_builtin(prog):
    """
    Prints out info for builtin program

    Arguments:
        prog -- builtin function name (str)

    Returns:
        Path -- path to program's code
    """
    if prog not in BUILTIN_PROGRAMS:
        print(f"Error: {prog} is not a builtin program")
        sys.exit(1)

    match (prog):
        case "multiply":
            multiply_txt_path = Path(BUILTIN_PROGRAMS["multiply"] + ".txt")

            with open(multiply_txt_path, "r") as mult_file:
                lines = "\n".join(mult_file.readlines())

            msg = (
                "============================ MULTIPLY ============================\n"
                f"{lines}\n\n"
                "==================================================================\n"
                "This program multiplies the first two words in memory "
                "and stores the result in x3\n"
                "To use, edit mem[0] and mem[1]"
            )

            print(msg)

            mem0 = input("\nEnter value for mem[0]: ")
            while True:
                try:
                    mem0 = int(mem0)
                    break
                except ValueError:
                    mem0 = input("Value must be an integer: ")

            mem1 = input("\nEnter value for mem[1]: ")
            while True:
                try:
                    mem1 = int(mem1)
                    break
                except ValueError:
                    mem1 = input("Value must be an integer: ")

            set_file_line(DATA_PATH, 0, mem0)
            set_file_line(DATA_PATH, 1, mem1)

            return Path(BUILTIN_PROGRAMS["multiply"] + ".mem")

        case "fibonacci":
            print("fibonacci not implemented")
        case "simple_sort":
            print("simple_sort not implemented")


def clear_sim_files():
    """
    Sets register state (reg.mem), data memory (data.mem),
    pc (pc.txt), and control (control.txt) to 0
    """
    set_control(0)
    clear_reg()
    clear_pc()
    clear_data()
    clear_program_file()


def get_input(valid_inputs, first_prompt, err_prompt):
    """
    Gets user inputs

    Arguments:
        valid_inputs -- valid user entries (set or list of lowercase strings)
        first_prompt, err_prompt (str)
    """
    selection = input(first_prompt)
    while selection.lower() not in valid_inputs:
        selection = input(err_prompt)

    return selection


if __name__ == "__main__":
    atexit.register(simulation.kill)
    main()
