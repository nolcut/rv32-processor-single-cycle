# Binary search
#
# bin_search(int[] arr, int l, int r, int x)
# int[] arr: memory address of 'arr'. Assumes each element is size 4.
# l: left boundary.
# r: right boundary.
# x: element being searched for.
# 
#
# Requires: r >= l. Returns -1 otherwise. 'arr' is in sequential order.
#           l >= 0.
#           r < length(arr).
#
# credit: Christophe Gyurgyik

# MAIN
addi sp, sp, 2044

jal BIN_SEARCH
jal EXIT

BIN_SEARCH:
addi sp, sp, -4
sw ra, 0(sp)

bne t0, a3, NOT_FOUND # if (arr[mid] == x) return mid.
add a0, x0, t2
jalr x0, ra, 0

NOT_FOUND:
blt a2, a1, INCORRECT_BOUNDS # if (r < l) return -1.

sub t0, a2, a1 # store r-l.
srai t1, t0, 1 # store (r-l)/2.
add t2, t1, a1 # store l + (r-l)/2.

slli t3, t2, 2 # mid * sizeof(int) # Get the 'mid' element in 'arr'.
add t3, t3, a0 # pointer to arr[mid].
lw t0, 0(t3)   # get value at arr[mid].

bne t0, a3, NOT_EQ # if (arr[mid] == x) return mid.
add a0, x0, t2
jalr x0, ra, 0

NOT_EQ:
bge a3, t0, GREATER_THAN # if (x > arr[mid]) return bin_search(arr, mid+1, r, x).
addi a2, t2, -1 # r = mid - 1 # bin_search(arr, l, mid-1, x);
jal BIN_SEARCH

GREATER_THAN:
addi a1, t2, 1 # l = mid + 1
jal BIN_SEARCH

RET:
lw ra, 0(sp)
addi sp, sp, 4
jalr x0, ra, 0

INCORRECT_BOUNDS:
addi a0, x0, -1
lw ra, 0(sp)
addi sp, sp, 4
jalr x0, ra, 0

EXIT:
