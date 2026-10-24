.global _start
N: .word 12
Numbers: .short 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13
Primes: .space 24

_start:
// your code starts here
	LDR V1, N // V1 = n
	LDR V2, =Numbers // V2 = &Numbers
	LDR V3, =Primes // V3 = &Primes

	MOV V5, #0 // V5 = index of numbers, num
	MOV V6, V3 // V6 = &Primes, pri as addr
	MOV V7, #1 // V7 = recently found prime, prime

loop:
	SUB V5, V7, #1

first_non_zero:
	CMP V5, V1
	BGE cont // goto cont if num >= n

	PUSH {V5}
	ADD V5, V2, V5, LSL #1
	LDRH V7, [V5] // V7 = mem[V2 + V5 * 4] = numbers[num]
	POP {V5}

	CMP V7, #0
	BNE cont // goto cont if numbers[num] != 0
	ADD V5, V5, #1
	B first_non_zero

cont: 
	CMP V5, V1
	BGE done // goto done if num >= n 
		
	PUSH {V5}
	ADD V5, V2, V5, LSL #1
	LDRH V7, [V5] // V7 = numbers[num]
	POP {V5}

	STRH V7, [V6], #2 // mem[V6] = V7; V6 += 4 bytes
	MOV V8, #0

mark_off_divisible_elements:
	CMP V5, V1
	BGE loop // goto loop if num >= n
	PUSH {V5}
	ADD V5, V2, V5, LSL #1
	STRH V8, [V5]
	POP {V5}

	ADD V5, V5, V7
	B mark_off_divisible_elements

done:
	B done


