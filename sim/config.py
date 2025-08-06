from simulation import Simulation
from programs import Multiply, Fibonacci, QuickSort
from constants import BUILTIN_FOLDER_PATH

mult_desc = (
    "This program multiplies the first two words in memory\n\n"
    "and stores the result in x3\n\n"
    "To use, edit mem[0] and mem[1]\n"
)

fib_desc = (
    "This program calculates the nth Fibonacci number using memoization\n\n"
    "and stores the result in x10\n"
)

sort_desc = (
    "This program uses quicksort to sort an array in memory\n"
)

BUILTIN_PROGRAMS = {
    "multiply": Multiply("multiply", mult_desc, BUILTIN_FOLDER_PATH / "multiply_words_unconditional.s"),
    "fibonacci": Fibonacci("fibonacci", fib_desc, BUILTIN_FOLDER_PATH / "memoized_fibonacci.s"),
    "quick_sort": QuickSort("quicksort", sort_desc, BUILTIN_FOLDER_PATH / "quicksort.s")
}

simulation = Simulation()
