.global _start

matrixA: .word 1, 2, 3, 4
lengthA: .word 4

matrixB: .word 2, 3, 5, 7, 11, 13, 17, 19
lengthB: .word 8

results: .space 8

sum:
	PUSH {V1-V8}
	MOV V1, A1 // V1 = addr of array
	MOV V2, A2 // V2 = len of array
	MOV V3, #0 // V3 = index of array
	MOV V4, #0 // V4 = partial sum of array

loop:
	CMP V3, V2 // check if i >= len
	BGE end
	LDR V5, [V1], #4 // R5 = [V1], then increment V1 by 4 bytes
	ADD V4, V4, V5 // V4 += V5
	Add V3, V3, #1
	B loop

end:
	MOV A1, V4 // return value
	POP {V1-V8} // pop everything else
	BX LR

_start:
	LDR A1, =matrixA
	LDR A2, lengthA
	BL sum
	LDR V1, =results
	STR A1, [V1]

	LDR A1, =matrixB
	LDR A2, lengthB
	BL sum
	STR A1, [V1, #4]

inf:
	B inf
