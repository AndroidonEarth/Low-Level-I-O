# Low Level I/O
MASM Assembly program that implements low-level I/O procedures and macros, including a ReadVal and WriteVal procedure for unsigned integers, and getString and displayString macros, all of which are utilized in a small test program. Uses the Kip Irvine library for x86 processors.

## Objectives
1. Designing and implementing low-level I/O procedures.
2. Implementing and using a macro.

## Program Description
- Get 10 integers from the user using a readVal procedure and getString macro to prompt the user for each value, get the input as a string, convert the string to numeric form while validating the input, and storing the value in an array. 
- Then the array of inputs is printed to the console using a writeVal procedure, which converts each numeric number back into a string, printing the string using a displayString macro. 
- The sum and average of the inputs are then calculated and displayed using the writeVal/displayString procedure and macro. All prompts and indentifying strings are also printed to the console using the displayString macro.
