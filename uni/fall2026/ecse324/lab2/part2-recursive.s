.global _start
N: .word 10 // input parameter n
P: .space 4 // Pell number result

_start:
	ldr A1, N // get the input parameter
	MOV A2, #0
	MOV A3, #1
	bl pell // go!
	str A1, P // save the result

stop:
	b stop

// Pell number calculation
// pre-- A1: Pell number index i to calculate, n >= 0
// post- A1: Pell number P = pell(n)
pell:
	// your code starts here
	PUSH {LR}

	CMP A1, #0
	BEQ pell_ret

	SUB A1, #1

	LSL A4, A3, #1 // V1 = 2 * b
	ADD A4, A4, A2 // V1 += a

	MOV A2, A3
	MOV A3, A4

	BL pell

pell_ret:
	MOV A1, A2
	POP {LR}
	BX LR
