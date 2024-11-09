.globl dot

.text
# =======================================================
# FUNCTION: Strided Dot Product Calculator
#
# Calculates sum(arr0[i * stride0] * arr1[i * stride1])
# where i ranges from 0 to (element_count - 1)
#
# Args:
#   a0 (int *): Pointer to first input array
#   a1 (int *): Pointer to second input array
#   a2 (int):   Number of elements to process
#   a3 (int):   Skip distance in first array
#   a4 (int):   Skip distance in second array
#
# Returns:
#   a0 (int):   Resulting dot product value
#
# Preconditions:
#   - Element count must be positive (>= 1)
#   - Both strides must be positive (>= 1)
#
# Error Handling:
#   - Exits with code 36 if element count < 1
#   - Exits with code 37 if any stride < 1
# =======================================================
dot:
    li t0, 1
    blt a2, t0, error_terminate  
    blt a3, t0, error_terminate   
    blt a4, t0, error_terminate  

    li t0, 0            
    li t1, 0 
    addi sp, sp, -4
    sw s0, 0(sp)
loop_start:
    bge     t1, a2, loop_end   # if i >= element_count, exit loop

    # Compute t2 = t1 * a3
    li t2, 0          # t2 = 0
    mv t6, t1         # t6 = t1
mulstride0:
    beqz t6, cal_arr0
    add t2, t2, a3    # t2 += a3
    addi t6, t6, -1   # t6 -= 1
    j mulstride0

cal_arr0:
    slli    t2, t2, 2          # t2 = t2 * 4 (byte offset)
    add     t2, a0, t2         # t2 = arr0_addr

    # Compute t3 = t1 * a4
    li t3, 0          # t3 = 0
    mv t6, t1         # t6 = t1
mulstride1:
    beqz t6, cal_arr1
    add t3, t3, a4    # t3 += a4
    addi t6, t6, -1   # t6 -= 1
    j mulstride1

cal_arr1:
    slli    t3, t3, 2          # t3 = t3 * 4 (byte offset)
    add     t3, a1, t3         # t3 = arr1_addr

    # Load values from arrays
    lw      t4, 0(t2)          # t4 = arr0_value
    lw      t5, 0(t3)          # t5 = arr1_value

    # Initialize result and sign
    li t6, 0          # t6 = result
    li s0, 0          # s0 = abs(t4)
    li t2, 0          # t2 = abs(t5)
    li t3, 0          # t3 = sign (0 = positive)

    # Get absolute value of t4
    bltz t4, t4_neg
t4_pos:
    mv s0, t4
    j t5_abs
t4_neg:
    neg s0, t4
    addi t3, t3, 1    # Flip sign
    j t5_abs

    # Get absolute value of t5
t5_abs:
    bltz t5, t5_neg
t5_pos:
    mv t2, t5
    j multiply
t5_neg:
    neg t2, t5
    xori t3, t3, 1    # Flip sign if only one negative
    j multiply

    # Multiply s0 and t2 via addition
multiply:
    beqz t2, adjust_sign
    add t6, t6, s0    # t6 += s0
    addi t2, t2, -1   # t2 -= 1
    j multiply

    # Adjust sign of the result
adjust_sign:
    beqz t3, add_to_sum
    neg t6, t6        # t6 = -t6

add_to_sum:
    # Add the result to sum
    add     t0, t0, t6         # sum += t6

    # Increment i and loop
    addi    t1, t1, 1          # i += 1
    j       loop_start

loop_end:
    mv a0, t0
    lw s0, 0(sp)
    addi sp, sp, 4
    jr ra

error_terminate:
    blt a2, t0, set_error_36
    li a0, 37
    j exit

set_error_36:
    li a0, 36
    j exit
