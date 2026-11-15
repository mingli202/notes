.section .vectors, "ax"
B _start // reset vector
B SERVICE_UND // undefined instruction vector
B SERVICE_SVC // software interrupt vector
B SERVICE_ABT_INST // aborted prefetch vector
B SERVICE_ABT_DATA // aborted data vector
.word 0 // unused vector
B SERVICE_IRQ // IRQ interrupt vector
B SERVICE_FIQ // FIQ interrupt vector

.global _start

PB0 = 0x00000001
PB1 = 0x00000002
PB2 = 0x00000004
PB3 = 0x00000008

BLANK = 16

.data

.align 2
HEX_ADDR:
        .word 0xFF200031,  0xFF200030, 0xFF200023, 0xFF200022, 0xFF200021, 0xFF200020

HEX_CODES:
        .byte 0b00111111, 0b00000110, 0b01011011, 0b01001111 // 0, 1, 2, 3
        .byte 0b01100110, 0b01101101, 0b01111101, 0b00000111 // 4, 5, 6, 7
        .byte 0b01111111, 0b01101111, 0b01110111, 0b01111100 // 8, 9, A, b
        .byte 0b00111001, 0b01011110, 0b01111001, 0b01110001 // C, d, E, F
        .byte 0b00000000 // blank

COFFEE:
        .byte 6, 0xC, 0, 0xF, 0xF, 0xE, 0xE

CAFES:
        .byte 6, 0xC, 0xA, 0xF, 0xE, 5, BLANK

CABS:
        .byte 6, 0xC, 0xA, 0xB, 5, BLANK, BLANK

ACE:
        .byte 6, 0xA, 0xC, 0xE, BLANK, BLANK, BLANK

MSG_8:
        .byte 10, 7, 0, 0xA, 0xD, 5, 7, 0, 0, 1, 5

MSG_10:
        .byte 16, 0xC, 0xA, 0xF, 0xE, BLANK , 0xB, 0xE, 0xE, 0xF, BLANK, 0xC, 0, 0xF, 0xF, 0xE, 0xE

.align 2
// MSG_TABLE is a table where the lsb is the length of the message that follows right after
MSG_TABLE:
        .word COFFEE, CAFES, CABS, ACE, MSG_8, MSG_10



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
        LDRB A2, [A3, A2]
        BL HEX_write_raw

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

.equ PUSH_BTN_ADDR, 0xFF200050
// read_PB_data_ASM returns indices of the pressed pushbuttons
// returns A1 list of pressed pushbuttons
read_PB_data_ASM:
        LDR A2, =PUSH_BTN_ADDR
        LDR A1, [A2]
        BX LR

// PB_data_is_pressed_ASM
// A1: index of push button
// returns 0x00000001 if the button is pressed
PB_data_is_pressed_ASM:
        LDR A2, =PUSH_BTN_ADDR
        LDR A3, [A2] // push btn data
        TST A3, A1 // zero is 1 if bit A1 is not set
        MOVEQ A1, #0
        MOVNE A1, #1

        BX LR

// returns the indices of the pushbottons that have been pressed
// and then release (the edge bits from the pushbutton's Edgecapture register)
read_PB_edgecp_ASM:
        LDR A2, =PUSH_BTN_ADDR
        LDR A1, [A2, #0xC]

        BX LR

// receives a pushbutton index
// A1: index of pushbutton
// returns #1 if it has been pressed and released
PB_edgecp_is_pressed_ASM:
        LDR A2, =PUSH_BTN_ADDR
        LDR A3, [A2, #0xC] // edgecapture btn data
        TST A3, A1 // zero is 1 if bit A1 is not set
        MOVEQ A1, #0
        MOVNE A1, #1

        BX LR

// clears the pushbutton Edgecapture register
PB_clear_edgecp_ASM:
        LDR  A2, =PUSH_BTN_ADDR
        LDR  A1, [A2, #0xC]
        STR  A1, [A2, #0xC]     // write back what was read to clear it
        BX   LR

// receives pushbutton as indices
// enables interrupt function for the corresponding pushbuttons
// by setting the interrupt mask bits to '1'
// A1: index of push button
enable_PB_INT_ASM:
        LDR A2, =PUSH_BTN_ADDR
        LDR A3, [A2, #0x8] // value of interrupt mask

        ORR A3, A3, A1  // enable them
        STR A3, [A2, #0x8]
        BX LR


// receives pushbutton indices as an argument
// disables interrupt function by setting to '0'
disable_PB_INT_ASM:
        LDR A2, =PUSH_BTN_ADDR
        LDR A3, [A2, #0x8] // value of interrupt mask

        BIC A3, A3, A1  // disable them
        STR A3, [A2, #0x8]
        BX LR

// display A1 with length A2 and offset A3
// A1: message byte array
// A2: message length
// A3: starting index
display_msg:
        PUSH {V1-V4, LR}
        MOV V1, A1 // the message addr e.g. C -> O -> F -> F -> E -> E
        MOV V2, A2 // the message length e.g. 6
        MOV V3, #0 // current hex index
        MOV V4, A3 // offset, starting index

        // clear the display first
        MOV A1, #0b00111111
        BL HEX_clear_ASM

loop_display_msg:
        CMP V3, #6
        BGE done_display_msg // done if index >= 6 (all the displays)

        CMP V3, V2
        BGE done_display_msg // done if index >= length (for msgs smaller than 6)

        // ensure message index is within its length
        ADD A1, V4, V3 // offset + display_index
        MOV A2, V2 
        BL mod // A1 is within message bound

        // load the byte at offset
        LDRB A2, [V1, A1]

        // enable the right one
        MOV A1, #1
        LSL A1, A1, V3
        
        BL HEX_write_ASM

        ADD V3, V3, #1 // increment count by 1
        B loop_display_msg

done_display_msg:
        POP {V1-V4, LR}
        BX LR

// A1 mod A2
// assumes A2 > 0, should be since it's the length
mod:
        CMP A1, #0
        BLT mod_add

        CMP A1, A2
        BGE mod_sub

        BX LR

mod_add:
        ADD A1, A1, A2
        B mod

mod_sub:
        SUB A1, A1, A2
        B mod

// returns the message and length
// at A1
// returns A1: message, A2: length
get_message:
        LSL A1, A1, #2
        LDR A2, =MSG_TABLE
        LDR A1, [A2, A1] // A1 is the pointer to the message head
        LDRB A2, [A1], #1 // A2 is the length, A1 points to first char 
        BX LR

        
// check if the switches index is 0, 1, 2, 4, 8 or 10
// A1: switches to check
// returns A1: index of the message table
// -1 if invalid index
check_switches_index:
        CMP A1, #0
        BXEQ LR;

        MOV A2, #1 // one-hot mask
        MOV A3, #1 // index

check_switches_index_loop:
        CMP A2, #0x10
        BGT check_switches_index_invalid

        CMP A1, A2
        BEQ check_switches_index_done

        LSL A2, A2, #1 // next one-hot index
        ADD A3, A3, #1
        B  check_switches_index_loop
        
check_switches_index_invalid:
        MOV A1, #1
        RSB A1, A1, #0
        BX LR

check_switches_index_done:
        MOV A1, A3
        BX LR

// displays the number A1 as a binary on the leds
// caps the count at 1023 (2^10 - 1)
display_rotation_count:
        PUSH {LR}
        LDR A2, =1023

        CMP A1, A2
        MOVGT A1, A2
        
        BL write_LEDs_ASM
        POP {LR}
        BX LR

// the main loop
poll:
        PUSH {V1-V8, LR}
        MOV V1, #0 // message index

        MOV A1, V1
        BL get_message
        MOV V2, A1 // message
        MOV V3, A2 // length
        
        MOV V4, #0 // current offset
        MOV V5, #0 // rotation count
        MOV V6, #1 // direction
   
draw:
        MOV A1, V2
        MOV A2, V3
        MOV A3, V4
        BL display_msg       

        MOV A1, V5
        BL display_rotation_count

loop:
        BL read_slider_switches_ASM
        BL check_switches_index
        MOV V7, A1

        CMP V7, #5
        BHI invalid_config // go to invalid config and skip other input handling

        // draw message if new
        CMP V7, V1
        BEQ next

        MOV V1, V7
        MOV A1, V1
        BL get_message
        MOV V2, A1 // message
        MOV V3, A2 // length

        // reset offset
        MOV V4, #0

        // reset rotation count
        MOV V5, #0

        // clear any rotations
        BL PB_clear_edgecp_ASM

        B draw

next:
        LDR A1, =PB3
        BL PB_edgecp_is_pressed_ASM
        CMP A1, #1
        BEQ rotate

        LDR A1, =PB2
        BL PB_edgecp_is_pressed_ASM
        CMP A1, #1
        BEQ reverse_direction

        B loop

rotate:
        ADD V4, V4, V6

        // cap offset between [0, message_length]        
        MOV A1, V4 // offset
        MOV A2, V3 // message_length
        BL mod
        MOV V4, A1
        
        ADD V5, V5, #1
        BL PB_clear_edgecp_ASM
        B draw

reverse_direction:
        RSB V6, V6, #0
        BL PB_clear_edgecp_ASM
        B loop

invalid_config:
        MOV V1, V7
        MOV A1, #0b00111111
        BL HEX_clear_ASM

        // reset rotation count immediately and draw
        MOV V5, #0
        MOV A1, V5
        BL display_rotation_count

        // clear any pending rotations just to be sure
        BL PB_clear_edgecp_ASM
        
        B loop


_start:
        BL poll

stop:
        B stop
