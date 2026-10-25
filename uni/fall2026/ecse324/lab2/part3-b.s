.global _start
Stuff:		.byte 5, 7, 4, 3, 2, 1, 8, 6 // input array
			.space 0 // to align next word
N:			.word 8 // number of elements in Stuff
Sorted:		.space 8 // (optional) sorted output
			.space 0 // to align next word

_start:
	ldr A1, =Stuff // get the address of Stuff
	ldr A2, N // get the number of things in Stuff
	bl sort // go!
stop:
	b stop
// Sorting algorithm
// pre-- A1: Address of array of signed bytes to be sorted
// pre-- A2: Number of elements in array
// post- A1: Address of sorted array
sort:
	// your code starts here
	// bubble sort
	PUSH {V1-V8}
	MOV V1, #0 //  V1 is the number of sorted element at the end

loop:
	CMP V1, A2
	BEQ end

	MOV V2, #0 // V2 = inner loop index

bubble:
	SUB V6, A2, V1
	CMP V2, V6
	BGE after_bubble

	ADD V3, V2, #1
	
	LDRB V4, [A1, V2] // V4 = stuff[v2]
	LDRB V5, [A1, V3] // V5 = stuff[v2 + 1]

	CMP V4, V5
	BGT swap
after:
	ADD V2, V2, #1
	B bubble

after_bubble:
	ADD V1, V1, #1
	B loop

swap:
	STRB V4, [A1, V3]
	STRB V5, [A1, V2]
	B after

end:
	POP {V1-V8}
	BX LR
