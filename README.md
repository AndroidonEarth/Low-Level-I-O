# Low Level I/O
MASM Assembly program that implements low-level I/O procedures and macros, including a ReadVal and WriteVal procedure for unsigned integers, and getString and displayString macros, all of which are utilized in a small test program. Uses the Kip Irvine library for x86 processors.

## Objectives
1. Designing and implementing low-level I/O procedures.
2. Implementing and using a macro.

## Program Description
- Get 10 integers from the user using a readVal procedure and getString macro to prompt the user for each value, get the input as a string, convert the string to numeric form while validating the input, and storing the value in an array. 
- Then the array of inputs is printed to the console using a writeVal procedure, which converts each numeric number back into a string, printing the string using a displayString macro. 
- The sum and average of the inputs are then calculated and displayed using the writeVal/displayString procedure and macro. All prompts and indentifying strings are also printed to the console using the displayString macro.

## Sample Output
Designing low-level I/O procedures 
Written by: Andrew Swaim

Please provide 10 unsigned decimal integers.  
Each number needs to be small enough to fit inside a 32 bit register. 
After you have finished inputting the raw numbers I will display a list 
of the integers, their sum, and their average value.

Please enter an unsigned number: 156
Please enter an unsigned number: 51d6fd
ERROR: You did not enter an unsigned number or your number was too big. 
Please try again: 34
Please enter an unsigned number: 186
Please enter an unsigned number: 15616148561615630
ERROR: You did not enter an unsigned number or your number was too big. 
Please try again: 145
ERROR: You did not enter an unsigned number or your number was too big. 
Please try again: 345
Please enter an unsigned number: 5
Please enter an unsigned number: 23
Please enter an unsigned number: 51
Please enter an unsigned number: 0
Please enter an unsigned number: 56
Please enter an unsigned number: 11

You entered the following numbers: 
156, 34, 186, 345, 5, 23, 51, 0, 56, 11 
The sum of these numbers is: 867 
The average is: 86

Thanks for playing!
