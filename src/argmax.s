.globl argmax

.text
# =================================================================
# FUNCTION: Maximum Element First Index Finder
#
# Scans an integer array to find its maximum value and returns the
# position of its first occurrence. In cases where multiple elements
# share the maximum value, returns the smallest index.
#
# Arguments:
#   a0 (int *): Pointer to the first element of the array
#   a1 (int):  Number of elements in the array
#
# Returns:
#   a0 (int):  Position of the first maximum element (0-based index)
#
# Preconditions:
#   - Array must contain at least one element
#
# Error Cases:
#   - Terminates program with exit code 36 if array length < 1
# =================================================================
argmax:
    li t6, 1
    blt a1, t6, handle_error

    lw t0, 0(a0)

    li t1, 0 # store current max
    li t2, 0 # store current index
    li t4, 0 # store max index
loop_start:
    beqz a1, end
    lw t3, 0(a0) # load current value
    blt t3 t1 skip

    # new max
    addi t1 t3 0
    addi t4 t2 0

skip:
    addi a1 a1 -1
    addi t2 t2 1
    addi a0 a0 4
    j loop_start

end:
    addi a0 t4 0
    ret

handle_error:
    li a0, 36
    j exit
