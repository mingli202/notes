.global _start
N: .word 10 // input parameter n
P: .space 4 // Pell number result

_start:
	ldr A1, N // get the input parameter
	bl pell // go!
	str A1, P // save the result

stop:
	b stop

// Pell number calculation
// pre-- A1: Pell number index i to calculate, n >= 0
// post- A1: Pell number P = pell(n)
pell:
	// your code starts here
	PUSH {V1-V8}
	MOV V1, A1 // V1 = A1

	CMP V1, #1
	BEQ return_1

	CMP V1, #0
	BEQ return_0

	MOV V2, #0 // a
	MOV V3, #1 // b
	MOV V4, #0 // c = 2 * b + a

	SUB V1, #1

loop:
	CMP V1, #0
	BEQ cont

	MOV V4, V2 // c = a
	LSL V2, V3, #1 // a = b * 2
	ADD V4, V4, V2 // c = c + a = c + b * 2 = a + b * 2

	MOV V2, V3 // a = b
	MOV V3, V4 // b = c

	SUB V1, #1
	B loop


cont:
	MOV A1, V4

	pop {V1-V8}
	BX LR

return_1:
	MOV A1, #1
	BX LR

return_0:
	MOV A1, #0
	BX LR

