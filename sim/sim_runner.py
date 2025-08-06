import atexit
import json
import sys
from pathlib import Path
from time import sleep

from config import BUILTIN_PROGRAMS, simulation
from constants import (CONTROL_PATH, DATA_ADDR_WIDTH, DATA_PATH,
                       INSTRUCTION_DELAY, PC_PATH, PROG_PATH,
                       PROGRAMS_FOLDER_PATH, RF_PATH, get_input)
from programs import create_program_file, set_file_line
from riscv_assembler.convert import AssemblyConverter


def main():
    print("=" * 50)
    print("CASTOR32".center(45))
    print("=" * 50 + "\n")

    while True:
        print(
            "Enter mode of execution:\n"
            "1. Batch: Run an entire program\n"
            "2. Iterative: Run an entire program line by line\n"
            "3. Prompted: Manually enter instructions\n"
        )

        valid_inputs = {"1", "2", "3"}
        first_prompt = "Enter 1-3: "
        err_msg = "Invalid input (1-3 only): "

        selection = int(get_input(valid_inputs, first_prompt, err_msg))

        match (selection):
            case 1:
                batch_exec()
            case 2:
                iterative_exec()
            case 3:
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
    sleep(INSTRUCTION_DELAY)


def more_lines(line_num):
    """
    Returns whether or not the current line
    inside of program.mem number is valid
    """
    if line_num == float("inf"):
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

    with open(CONTROL_PATH, "w") as control_file:
        control_file.write(str(control))


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
    else:
        programs = {}

    # if using saved program, display options and prompt
    if selection == "1":
        print("\nPlease enter one of the following program names (case sensitive): ")

        print("\nBUILT-IN PROGRAMS:")
        for b in BUILTIN_PROGRAMS.keys():
            print(b)

        print("\nSAVED PROGRAMS:")
        for p in programs.keys():
            print(p)

        err_prompt = "Input does not match any saved programs\n" "Enter program: "

        prog_name = get_input(
            valid_inputs=programs.keys() | BUILTIN_PROGRAMS.keys(),
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
            selected_prog_path = PROGRAMS_FOLDER_PATH / input("Enter path to program: ")

            if not selected_prog_path.is_file():
                print(f"\nFile not found: {selected_prog_path.name}\n")
                continue

            if selected_prog_path.suffix.lower() not in {".mem", ".s"}:
                print("\nFile must end with .mem or .s\n")
                continue

            break

        while True:
            prog_name = input("Enter name for program: ")
            if prog_name in programs.keys() | BUILTIN_PROGRAMS.keys():
                print("\nError: Name matches an existing program")
            else:
                break

        programs[prog_name] = str(selected_prog_path)

    with open("programs.json", "w") as prog_file:
        json.dump(programs, prog_file, indent=4)

    # copy desired program to program.mem file
    create_program_file(Path(selected_prog_path))

    return prog_name


def handle_builtin(prog):
    """
    Prints out info for builtin program

    Arguments:
        prog -- builtin function name (str)

    Returns:
        str -- path to program's code
    """
    if prog not in BUILTIN_PROGRAMS:
        print(f"Error: {prog} is not a builtin program")
        sys.exit(1)

    match (prog):
        case "multiply":
            return BUILTIN_PROGRAMS["multiply"].load()

        case "fibonacci":
            return BUILTIN_PROGRAMS["fibonacci"].load()

        case "quick_sort":
            return BUILTIN_PROGRAMS["quick_sort"].load()


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


if __name__ == "__main__":
    atexit.register(simulation.kill)
    main()
