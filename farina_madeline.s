.data 
	first : 	.space 256 //first number
	second : 	.space 256 //second number
	operator : 	.space 256
	int : 		.asciz "%d"
	string :	.asciz "%s"
	newline :	.asciz "\n"
	no_div_by_zero :.asciz "error, divison by zero"
	inv_op :	.asciz "invalid operator"
	
.global main
.text

main:
	//scans in the inputs
	ldr x0, = int
	ldr x1, = first
	bl scanf

	ldr x0, = int
	ldr x1, = second
	bl scanf

	ldr x0, = string
	ldr x1, = operator
	bl scanf

	bl switch 

	//prints result
	mov x1, x21
	ldr x0, = int
	bl printf
	
	//flushes
	ldr x0, = newline
	bl printf
 
exit:
	mov x0, #0 
	mov x8, #93
	svc #0

switch:
	ldr x23, = operator
	ldr x23, [x23, 0]

	//if operator is a +, goes to add function
	sub x24, x23, #43
	cbz x24, ADD

	sub x25, x23, #45
	cbz x25, SUB

	sub x26, x23, #42
	cbz x26, MUL

	sub x27, x23, #47
	cbz x27, ifzero
	//else if +,-,*,/ not used, print error
	b.gt invalid_operator

	br x30

ADD: 
	ldr x19, = first
	ldr x19, [x19, 0]
	ldr x20, = second
	ldr x20, [x20, 0]
	
	add x21, x20, x19
	br x30

SUB:
	ldr x19, = first
	ldr x19, [x19, 0]
	ldr x20, = second
	ldr x20, [x20, 0]
	
	sub x21, x19, x20
	br x30

MUL:
	ldr x19, = first
	ldr x19, [x19, 0]
	ldr x20, = second
	ldr x20, [x20, 0]
	
	mul x21, x20, x19
	br x30

ifzero:
	ldr x20, = second
	ldr x20, [x20, 0]
	
	//if second num is a 0, print error
	cbnz x20, DIV
	bl bad_div
	
	br x30

DIV:
	ldr x19, = first
	ldr x19, [x19, 0]
	ldr x20, = second
	ldr x20, [x20, 0]
	
	//have to use w
	sdiv w21, w19, w20
	br x30

bad_div:
	//prints error if user inputs 0 for second num
	ldr x0, = no_div_by_zero
	bl printf

	ldr x0, = newline
	bl printf
	
	b exit

invalid_operator:
	//prints error if user inputs invalid operator
	ldr x0, = inv_op
	bl printf

	ldr x0, = newline
	bl printf

	b exit
