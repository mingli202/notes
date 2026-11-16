.global _start

PB0 = 0x00000001
PB1 = 0x00000002
PB2 = 0x00000004
PB3 = 0x00000008

.data
HEX_CODES:
        .byte 0b00111111, 0b00000110, 0b01011011, 0b01001111 // 0, 1, 2, 3
        .byte 0b01100110, 0b01101101, 0b01111101, 0b00000111 // 4, 5, 6, 7
        .byte 0b01111111, 0b01101111, 0b01110111, 0b01111100 // 8, 9, A, b
        .byte 0b00111001, 0b01011110, 0b01111001, 0b01110001 // C, d, E, F

.align 2
HEX_ADDR:
        .word 0xFF200020, 0xFF200021, 0xFF200022, 0xFF200023, 0xFF200030, 0xFF200031

// MSG is a table where the lsb is the length of the message that follows right after
MSG:
        .word 0x0C0FFEE6, 0x00CAFE55, 0x000CAB54, 0x0000ACE3


.align 2

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

        MOV A2, #0b001111111
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
display_msg:
        PUSH {V1-V7, LR}
        MOV V1, A1 // the message e.g. 0x00C0FFEE
        MOV V2, A2 // the message length e.g. 6
        MOV V3, #0 // current index
        MOV V4, #0xF // current mask
        MOV V6, A3 // offset

        // clear the display first
        MOV A1, #0b00111111
        BL HEX_clear_ASM

loop_display_msg:
        CMP V3, V2
        BGE done_display_msg // done if index >= length
        
        ADD V7, V3, V6 // add the offset
        MOV A1, V7
        MOV A2, #6 // hardcode the display's length
        BL mod // mod the index
        MOV V7, A1 // put back the index
         
        MOV A1, #1
        LSL A1, A1, V7 // shift hex index by current index to light the right one 

        AND A2, V1, V4 // and to get byte
        LSL V5, V3, #2
        LSR A2, A2, V5 // shift it back to be 0x0000000{byte}

        BL HEX_write_ASM

        ADD V3, V3, #1 // increment count by 1
        LSL V4, V4, #4 // shift to the next byte
        B loop_display_msg

done_display_msg:
        POP {V1-V7, LR}
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
        LDR A2, =MSG
        LDR A1, [A2, A1]
        AND A2, A1, #0xF // get the last byte
        LSR A1, A1, #4 // remove the last byte
        BX LR

        
// check if the switches index is 0, 1, 2, or 4
// A1: switches to check
check_switches_index:
        CMP A1, #0
        BEQ check_switches_index_next;

        CMP A1, #1
        BEQ check_switches_index_next;

        CMP A1, #2
        BEQ check_switches_index_next;

        CMP A1, #4
        MOVEQ A1, #3
        MOVNE A1, #4

check_switches_index_next:
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

        
// draw the massage
// A1: message
// A2: message length
// A3: offset
// A4: rotation_count
draw:
        PUSH {V1, LR}
        MOV V1, A4
        BL display_msg       

        MOV A1, V1
        BL display_rotation_count
        POP {V1, PC}

// the main loop
poll:        
        BL PB_clear_edgecp_ASM

        PUSH {V1-V8, LR}
        MOV V1, #0 // message index

        MOV A1, V1
        BL get_message
        MOV V2, A1 // message
        MOV V3, A2 // length
        
        MOV V4, #0 // current offset
        MOV V5, #0 // rotation count
        MOV V6, #1 // direction
   
        MOV A1, V2
        MOV A2, V3
        MOV A3, V4
        MOV A4, V5
        BL draw

loop:
        BL read_slider_switches_ASM
        BL check_switches_index
        MOV V7, A1

        CMP V7, #3
        BGT invalid_config // go to invalid config and skip other input handling

        // draw message if new
        CMP V7, V1
        BEQ rotate

        MOV V1, V7
        MOV A1, V1
        BL get_message
        MOV V2, A1 // message
        MOV V3, A2 // length

        // reset offset but left justify it
        MOV V4, #6
        SUB V4, V4, V3

        // reset rotation count
        MOV V5, #0

        // clear any rotations
        BL PB_clear_edgecp_ASM

        
        MOV A1, V2
        MOV A2, V3
        MOV A3, V4
        MOV A4, V5
        BL draw
        
rotate:
        BL read_PB_edgecp_ASM
        MOV V8, A1 // V8 is the pressed buttons

        // clear what I just read
        LDR A2, =PUSH_BTN_ADDR
        STR V8, [A2, #0xC]

        TST V8, #PB3
        BEQ reverse_direction 

        ADD V4, V4, V6
        // cap offset between [0, 5]
        MOV A1, V4
        MOV A2, #6
        BL mod
        MOV V4, A1
        
        ADD V5, V5, #1

        MOV A1, V2
        MOV A2, V3
        MOV A3, V4
        MOV A4, V5
        BL draw


reverse_direction:
        TST V8, #PB2
        BEQ next
   
        RSB V6, V6, #0

next:
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
