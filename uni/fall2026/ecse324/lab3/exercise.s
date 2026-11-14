.global _start

HEX0 = 0x00000001
HEX1 = 0x00000002
HEX2 = 0x00000004
HEX3 = 0x00000008
HEX4 = 0x00000010
HEX5 = 0x00000020

.data
HEX_CODES:
        .byte 0b00111111, 0b00000110, 0b01011011, 0b01001111 // 0, 1, 2, 3
        .byte 0b01100110, 0b01101101, 0b01111101, 0b00000111 // 4, 5, 6, 7
        .byte 0b01111111, 0b01101111, 0b01110111, 0b01111100 // 8, 9, A, b
        .byte 0b00111001, 0b01011110, 0b01111001, 0b01110001 // C, d, 

.align 2
HEX_ADDR:
        .word 0xFF200020, 0xFF200021, 0xFF200022, 0xFF200023, 0xFF200030, 0xFF200031

.text
// Slider Switches Driver
// returns the state of slider switches in A1
// post- A1: slide switch state
.equ SW_ADDR, 0xFF200040
read_slider_switches_ASM:
        LDR A2, =SW_ADDR
        LDR A1, [A2]
        BX LR

// LEDs Driver
// writes the state of LEDs (On/Off) in A1 to the LEDs' control register
// pre-- A1: data to write to LED state
.equ LED_ADDR, 0xFF200000
write_LEDs_ASM:
        LDR A2, =LED_ADDR // load the address of the LEDs' state
        STR A1, [A2] // update LED state with the contents of A1
        BX LR

// HEX_CLEAR_ASM A1
// A1: displays to clear
HEX_clear_ASM:
        PUSH {LR}

        MOV A2, #0b00000000
        BL HEX_write_raw

        POP {LR}
        BX LR

// HEX_flood_ASM A1
// A1: displays to flood
HEX_flood_ASM:
        PUSH {LR}

        MOV A2, #0b011111111
        BL HEX_write_raw

        POP {LR}
        BX LR

// HEX_write_ASM A1 A2
// A1: displays to write
// A2: hex value to write
HEX_write_ASM:
        PUSH {LR}

        LDR A3, =HEX_CODES
        LDR A2, [A3, A2]

        POP {LR}
        BX LR


// HEX_write_raw A1 A2
// A1: displays to write
// A2: the raw bit to write into A1
HEX_write_raw:
        PUSH {V1-V4, LR}
        MOV V1, A1 //  V1 = selected HEX display indices
        LDR V2, =HEX_ADDR // hex address
        MOV V3, #0 // current index
        
loop_write_raw:
        CMP V1, #0
        BEQ done_write_raw

        CMP V3, #6
        BGE done_write_raw // end of iteration, prevents malformed A1 input

        LSRS V1, V1, #1 // logical shift right and update status register
        BCC next_write_raw // next iteration if carry is 0

        LSL V4, V3, #2
        LDR V4, [V2, V4] // v4 is the add of the display

        STRB A2, [V4] // store A2 into addr of V4

next_write_raw:
        ADD V3, V3, #1 // increase index
        B loop_write_raw

done_write_raw:
        POP {V1-V4, LR}
        BX LR


_start:
loop:
        BL read_slider_switches_ASM
        BL write_LEDs_ASM
        B loop

