from constants import BUILTIN_FOLDER_PATH
from programs import BinarySearch, Fibonacci, Multiply, QuickSort
from simulation import Simulation

mult_desc = (
    "This program multiplies the first two words in memory\n\n"
    "and stores the result in x3\n\n"
    "To use, edit mem[0] and mem[1]\n"
)

fib_desc = (
    "This program calculates the nth Fibonacci number using memoization\n\n"
    "and stores the result in x10\n"
)

sort_desc = "This program uses quicksort to sort an array in memory\n"

bin_search_desc = (
    "This program finds an entry in an array in O(log(n)) time using binary search\n\n"
    "and stores the index of the value in x10\n"
)

BUILTIN_PROGRAMS = {
    "multiply": Multiply(
        "multiply", mult_desc, BUILTIN_FOLDER_PATH / "multiply_words_unconditional.s"
    ),
    "fibonacci": Fibonacci(
        "fibonacci", fib_desc, BUILTIN_FOLDER_PATH / "memoized_fibonacci.s"
    ),
    "quick_sort": QuickSort(
        "quicksort", sort_desc, BUILTIN_FOLDER_PATH / "quicksort.s"
    ),
    "bin_search": BinarySearch(
        "binary search", bin_search_desc, BUILTIN_FOLDER_PATH / "binary_search.s"
    ),
}

simulation = Simulation()
