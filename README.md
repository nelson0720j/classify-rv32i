# Assignment 2: Classify

## PARTA:

* relu
This loop iterates through an array, and for each element, if the element is greater or equal than zero, skip the step of setting the value to zero. Otherwise, set the value to zero.

* argmax
Find the index of the largest value in an array by iterating through each element. It loads each element and compares it with the current maximum value stored in t1. If the current element is greater, it updates t1 with this new maximum and t4 with the current index, stored in t2. The loop continues, moving to the next element and updating t2 for the index, until all elements are checked. At the end, t4 holds the index of the largest value, which is moved to a0 and returned.

* dot
In each iteration of the loop, the code calculates the effective address of the current elements in arr0 and arr1 using strides. For arr0, it determines the offset by repeatedly adding stride0 (from a3) to itself, t1 times, using t2 as a temporary register to accumulate the offset. It then multiplies this offset by 4 to get the correct byte offset, adds it to the base address in a0, and stores the computed address in t2. This points t2 to the current element of arr0. The same approach is used to calculate the address in arr1, with stride1 stored in a4, and the resulting address for arr1 is stored in t3.

Once the addresses are calculated, lw is used to load the elements from arr0 and arr1 into t4 and t5, respectively. The code then converts these values to their absolute values to handle potential negative numbers correctly. If t4 (element from arr0) is negative, it uses t4_neg to negate t4, storing the absolute value in s0 and setting t3 as a sign flag. Similarly, if t5 (element from arr1) is negative, it negates t5 into t2, using t3 to track whether the product should be positive or negative based on the combined signs.

With the absolute values prepared, the code performs manual multiplication using repeated addition. This is done by adding s0 (absolute value of t4) to t6 (product result) |t5| times. After obtaining the absolute value of the product, t3 is checked to see if the product’s sign should be negative; if so, it negates t6.

Finally, t6 (the signed product) is added to t0, which accumulates the sum of all products. The loop then increments t1 for the next element index, adjusts a0 and a1 for the strides, and iterates until all elements are processed. When the loop ends, t0 contains the final dot product, which is moved to a0 for the return value. The function concludes with ret, and if any inputs were invalid, it exits with an error code, ensuring the process terminates cleanly with the dot product or an error result.

* matmul
Increment outer loop counter, move s3 to point to the next row of A, then jump back to the beginning of the outer loop.

Finally, lw is used to restore the register's value from the stack.

## PARTB:
* read_matrix
Replace 'mul'
* write_matrix
Replace 'mul'
* classify
Replace 'mul'

## Check
* abs
Use bitwise operation to negate the value.
(t0 xor -1) + 1