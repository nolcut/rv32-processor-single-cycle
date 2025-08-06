# A function that implements the quicksort algorithm.
# Running time complexity:  amortised O(nlogn), worst case: O(n^2)
# Running space complexity: O(nlogn), worst case: O(n)
#
# quicksort(int arr[], int start, int end)
# Requires: 'start' >= 0
#           'end' < length(arr)
#
# credit: Christophe Gyurgyik

# MAIN
addi sp, sp, 2047

addi a1, x0, 0 # start

jal QUICKSORT
jal EXIT

QUICKSORT:
addi sp, sp, -20
sw ra, 16(sp)
sw s3, 12(sp)
sw s2, 8(sp)
sw s1, 4(sp)
sw s0, 0(sp)

addi s0, a0, 0
addi s1, a1, 0
addi s2, a2, 0
blt a2, a1, START_GT_END

jal PARTITION

addi s3, a0, 0   # pi

addi a0, s0, 0
addi a1, s1, 0
addi a2, s3, -1
jal QUICKSORT    # quicksort(arr, start, pi - 1);

addi a0, s0, 0
addi a1, s3, 1
addi a2, s2, 0
jal QUICKSORT    # quicksort(arr, pi + 1, end);

START_GT_END:

lw s0, 0(sp)
lw s1, 4(sp)
lw s2, 8(sp)
lw s3, 12(sp)
lw ra, 16(sp)
addi sp, sp, 20
jalr x0, ra, 0

PARTITION:
addi sp, sp, -4
sw ra, 0(sp)

slli t0, a2, 2   # end * sizeof(int)
add t0, t0, a0  
lw t0, 0(t0)     # pivot = arr[end]
addi t1, a1, -1  # i = (start - 1)

addi t2, a1, 0   # j = start
LOOP:
beq t2, a2, LOOP_DONE   # while (j < end)

slli t3, t2, 2   # j * sizeof(int)
add a6, t3, a0   # (arr + j)
lw t3, 0(a6)     # arr[j]

addi t0, t0, 1   # pivot + 1
blt t0, t3, CURR_ELEMENT_GTE_PIVOT  # if (pivot <= arr[j])
addi t1, t1, 1   # i++

slli t5, t1, 2   # i * sizeof(int)
add a7, t5, a0   # (arr + i)
lw t5, 0(a7)     # arr[i]

sw t5, 0(a6)
sw t3, 0(a7)     # swap(&arr[i], &arr[j])

CURR_ELEMENT_GTE_PIVOT:
addi t2, t2, 1   # j++
beq x0, x0, LOOP
LOOP_DONE:

addi t5, t1, 1   # i + 1
addi a5, t5, 0   # Save for return value.
slli t5, t5, 2   # (i + 1) * sizeof(int)
add a7, t5, a0   # (arr + (i + 1))
lw t5, 0(a7)     # arr[i + 1]

slli t3, a2, 2   # end * sizeof(int)
add a6, t3, a0   # (arr + end)
lw t3, 0(a6)     # arr[end]

sw t5, 0(a6)
sw t3, 0(a7)     # swap(&arr[i + 1], &arr[end])

addi a0, a5, 0   # return i + 1

lw ra, 0(sp)
addi sp, sp, 4
jalr x0, ra, 0

EXIT:
