TITLE Low-Level I/O     (lowlevel.asm)

; Author: Andrew Swaim			swaima@oregonstate.edu
; CS271-400		Program 6A      3/18/2018
; Description: Get 10 integers from the user using a readVal procedure and getString macro to
;	prompt the user for each value, get the input as a string, convert the string to numeric
;	form while validating the input, and storing the value in an array. Then the array of inputs
;	is printed to the console using a writeVal procedure, which converts each numeric number
;	back into a string, printing the string using a displayString macro. The sum and average
;	of the inputs are then calculated and displayed using the writeVal/displayString procedure and
;	macro. All prompts and indentifying strings are also printed to the console using the
;	displayString macro.

INCLUDE Irvine32.inc

;Global Constants.
IO_LENGTH = 12
INPUTS_LENGTH = 10

;Macro to display a string.
displayString MACRO string

	push			edx
	mov				edx,string
	call			WriteString
	pop				edx
ENDM

;Macro to prompt for and get a string from the user.
getString MACRO string, inputArray

	push			edx
	push			ecx
	displayString	string
	mov				edx,inputArray
	mov				ecx,IO_LENGTH
	call			ReadString	;eax will contain the string length.
	pop				ecx
	pop				edx
ENDM

.data
;Strings.
program			BYTE	"PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures",0
author			BYTE	"Written by: Andrew Swaim",0
rules1			BYTE	"Please provide 10 unsigned decimal integers.",0
rules2			BYTE	"Each number needs to be small enough to fit inside a 32 bit register.",0
rules3			BYTE	"After you have finished inputting the raw numbers I will display a list",0
rules4			BYTE	"of the integers, their sum, and their average value.",0
prompt			BYTE	"Please enter an unsigned integer: ",0
error			BYTE	"ERROR: You did not enter an unsigned number or your number was too big.",0
reprompt		BYTE	"Please try again: ",0
inputResult		BYTE	"You entered the following numbers:",0
sumResult		BYTE	"The sum of these numbers is: ",0
avgResult		BYTE	"The average is: ",0
space			BYTE	", ",0
farewell		BYTE	"Thanks for playing!",0

;Program variables.
array			DWORD	INPUTS_LENGTH	DUP(?)
iostring		BYTE	IO_LENGTH		DUP(?)
sum				DWORD	?
avg				DWORD	?

.code
main PROC

;Display program and author name.
	displayString	OFFSET program
	call			Crlf
	displayString	OFFSET author
	call			Crlf
	call			Crlf
;User instructions.
	displayString	OFFSET rules1
	call			Crlf
	displayString	OFFSET rules2
	call			Crlf
	displayString	OFFSET rules3
	call			Crlf
	displayString	OFFSET rules4
	call			Crlf
	call			Crlf

;------------------------------------------------------------------------------

;Get 10 valid integers from the user and store the numeric values in an array.
	mov				ecx,INPUTS_LENGTH
	mov				edi,OFFSET array
getNum:
	push			OFFSET iostring		;+20
	push			OFFSET prompt		;+16
	push			OFFSET error		;+12
	push			OFFSET reprompt		;+8
	call			readVal
	mov				[edi],eax
	add				edi,4
	loop			getNum

;------------------------------------------------------------------------------

	call			Crlf
	displayString	OFFSET inputResult
	call			Crlf

;Pass each values in the array to writeVal to print them to the screen.
	mov				ecx,INPUTS_LENGTH
	mov				edi,OFFSET array
printNum:
	push			OFFSET iostring		;+12 - string to hold the converted number for printing.
	push			[edi]				;+8	- value in the array to printed.
	call			writeVal
;Check if the last number was printed, and if so end printing of the array.
	cmp				ecx,1
	je				finished
;Otherwise, follow up a printed value with a comma and space and loop again.
	displayString	OFFSET space
	add				edi,4
	loop			printNum
finished:

;------------------------------------------------------------------------------

	call			Crlf
	displayString	OFFSET sumResult

;Calculate the sum by looping through the array.
	mov				ecx,INPUTS_LENGTH
	mov				edi,OFFSET array
	mov				eax,0
calcSum:
	add				eax,[edi]
	add				edi,4
	loop			calcSum
;Store the sum.
	mov				sum,eax

;Print sum.
	push			OFFSET iostring
	push			sum
	call			writeVal

;------------------------------------------------------------------------------

	call			Crlf
	displayString	OFFSET avgResult

;Calculate the average by dividing the sum by the number of inputs.
	mov				eax,sum
	mov				ebx,INPUTS_LENGTH
	cdq
	div				ebx
	mov				avg,eax

;Print average (rounded down/remainder discarded).
	push			OFFSET iostring
	push			avg
	call			writeVal

;------------------------------------------------------------------------------

;Display a farewell message to end the program.
	call			Crlf
	call			Crlf
	displayString	OFFSET farewell
	call			Crlf

	exit	; exit to operating system
main ENDP

;------------------------------------------------------------------------------
readVal PROC
	LOCAL x:DWORD, tmp:BYTE
; Inovkes the getString macro to get a string of digits from the user, and then 
;	converts the digit string to a numeric value while validating the user's input.
;	Prints an error message and reprompts the user if the user enters a non-digit,
;	or if the number is too larger for 32-bit registers. Uses the formula from the 
;	lectures to convert the string to numeric. 
; Receives: iostring (reference), promptMsg (reference), errorMsg (reference),
;	repromptMsg (reference)
; Returns: converted numeric input is returned in eax
; Preconditions: none
; Postconditions: iostring holds the user input string, and eax holds the converted
;	numeric value. 
; Registers changed: eax, ebx, esi (ecx and edi are saved and restored)
;------------------------------------------------------------------------------

	;Save registers.
		push			ecx
		push			edi
	;Get an inital input string from the user.
		getString		[ebp+16],[ebp+20]	;address of prompt and user input string.

	setup:	
	;Setup for validation.
		cld
		mov				ecx,eax				;eax holds length of string after getString was called.
	;If ecx is greater than 10, number is too big.
		cmp				ecx,10
		ja				invalidDig
	;Setup array of inputs.
		mov				esi,[ebp+20]
		mov				edi,esi
		mov				x,0					;x will hold the string converted to a numeric.
	convertNumeric:
	;Get the first digit of the input.
		xor				eax,eax				;clear eax.
		lodsb								;get str[k] into al.
	;Check if its a number.
		sub				al,48				;convert ASCII to Int (str[k] - 48)
		cmp				al,0
		jb				invalidDig
		cmp				al,9
		ja				invalidDig
	;If validation passed.
		mov				tmp,al
		mov				eax,x			
		mov				ebx,10
		mul				ebx					;10 * x stored in eax.
	;Check if mul overflowed into edx; number is too big.
		cmp				edx,0
		jnz				invalidDig
		movzx			ebx,tmp
		add				eax,ebx				;10 * x + (str[k] - 48) stored in eax.
	;Check carry flag after addition; number is too big
		jc				invalidDig
		mov				x,eax				;x = 10 * x + (str[k] - 48).
		loop			convertNumeric

	;Restore registers, and return the output in eax.
		pop				edi
		pop				ecx
		mov				eax,x
		ret				16

	invalidDig:
	;Print error message and get a different user input. 
		displayString	[ebp+12]			;print error message.
		call			Crlf
		getString		[ebp+8],[ebp+20]	;Reprompt with different message and validate again.
		jmp				setup

readVal ENDP

;------------------------------------------------------------------------------
writeVal PROC
	LOCAL len:DWORD
; Converts a numeric value to a string of digits and invokes the displayString macro
;	to produce the output.
; Receives: iostring (reference), unsignedInt (value)
; Returns: none
; Preconditions: none
; Postconditions: the number is converted to a string and the string is printed to
;	the console.
; Registers changed: eax, ebx (ecx and edi are saved and restored)
;------------------------------------------------------------------------------

	;Save registers.
		push			ecx
		push			edi

	;Clear the iostring.
		xor				eax,eax
		mov				ecx,IO_LENGTH
		mov				edi,[ebp+12]
		cld
		rep				stosb

	;Preapre to get the length of the number to be printed.
		mov				len,0
		mov				eax,[ebp+8]
	getLength:
	;If eax is 0, number has been fully divided so end the loop.
		cmp				eax,0
		je				continue
	;Otherwise divide by 10 and increment the length counter.
		mov				ebx,10
		cdq
		div				ebx
		inc				len
		jmp				getLength

	continue:
		std									;set direction flag to reverse.
	;Check if length is 0, then number to print is 0.
		mov				ecx,len
		cmp				ecx,0
		je				zero
	;Otherwise add a zero/null character to the end of the string.
		mov				edi,[ebp+12]
		add				edi,len				;edi is pointing to end of string
		xor				eax,eax
		mov				al,0				
		stosb								;add null character to end of string.
	;Prepare to fill the rest of the string.
		mov				eax,[ebp+8]
	convertString:
	;Divide by 10
		mov				ebx,10
		cdq
		div				ebx
	;Convert remainder to ASCII and store in the string.
		add				edx,48
		push			eax					;save the rest of the numeric
		mov				eax,edx
		stosb
		pop				eax					;restore the rest of the numeric
		loop			convertString

	print:
		cld
		displayString	[ebp+12]

	;Restore registers.
		pop				edi
		pop				ecx
		ret				8

	zero:
	;Add a null character to the end of the string.
		mov				edi,[ebp+12]
		inc				edi
		xor				eax,eax
		mov				al,0				
		stosb
	;Add ASCII '0' to the string.
		xor				eax,eax
		mov				eax,48
		stosb
		jmp				print

writeVal ENDP


END main
