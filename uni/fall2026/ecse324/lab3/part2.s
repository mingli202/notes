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

LOAD_ADDR = 0xFFFEC600
COUNTER_ADDR = 0xFFFEC604
CTRL_ADDR = 0xFFFEC608
INT_ST_ADDR = 0xFFFEC60C

PB0 = 0x00000001
PB1 = 0x00000002
PB2 = 0x00000004
PB3 = 0x00000008

BLANK = 16

INVALID_INDEX = 6


.data
PB_int_flag:
        .word 0x0

tim_int_flag:
        .word 0x0

// 1/16, 1/8, 1/4, 1/2, 1 seconds
// timer ticks for x * 200e6 - 1 before raising timer interrupt
speeds:
        .word 0xBEBC1FF, 0x5F5E0FF, 0x2FAF07F, 0x17D783F, 0xBEBC1F

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

INVALID:
        .byte 6, BLANK, BLANK, BLANK, BLANK, BLANK, BLANK

.align 2
// MSG_TABLE is a table where the lsb is the length of the message that follows right after
MSG_TABLE:
        .word COFFEE, CAFES, CABS, ACE, MSG_8, MSG_10, INVALID


// app state
msg_index: .word 0x0 // if index = 6 then it's invalid
msg: .word 0x0
msg_length: .word 0x0
current_offset: .word 0x0
direction: .word 1
is_paused: .word 0 // 0 is false
speed_index: .word 2 // speed
speed: .word 0x0 // the current speed

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
// #6 if invalid, the last one
check_switches_index:
        CMP A1, #0
        BXEQ LR;

        MOV A2, #1 // one-hot mask
        MOV A3, #1 // index

check_switches_index_loop:
        CMP A3, #INVALID_INDEX 
        BEQ check_switches_index_done

        CMP A1, A2
        BEQ check_switches_index_done

        LSL A2, A2, #1 // next one-hot index
        ADD A3, A3, #1
        B  check_switches_index_loop
        
check_switches_index_done:
        MOV A1, A3
        BX LR



// configures the private timer
// A1: initial count value (32bit value into load register)
// A2: configuration bits (15-8bit prescaler, 2 I, 1 A 0 E)
ARM_TIM_config_ASM:
        LDR A3, =LOAD_ADDR
        LDR A4, =CTRL_ADDR

        STR A1, [A3]
        STR A2, [A4]
    
        BX LR

// returns the F value
// from the A9 private timer interrupt status register
// returns strictly 0 or 1 without anything before it
ARM_TIM_read_INT_ASM:
        LDR A2, =INT_ST_ADDR
        LDR A1, [A2]

        TST A1, #1
        MOVEQ A1, #0
        MOVNE A1, #1

        BX LR

// clears the 'F' value by writing a #1 to it
ARM_TIM_clear_INT_ASM:
        LDR A1, =INT_ST_ADDR
        MOV A2, #1
        STR A2, [A1]

        BX LR

CONFIG_GIC:
        PUSH {LR}
        /* To configure the FPGA KEYS interrupt (ID 73):
        * 1. set the target to cpu0 in the ICDIPTRn register
        * 2. enable the interrupt in the ICDISERn register */
        /* CONFIG_INTERRUPT (int_ID (R0), CPU_target (R1)); */
        /* NOTE: you can configure different interrupts
        by passing their IDs to R0 and repeating the next 3 lines */
        MOV R0, #73 // KEY port (Interrupt ID = 73)
        MOV R1, #1 // this field is a bit-mask; bit 0 targets cpu0
        BL CONFIG_INTERRUPT

        MOV R0, #29 // private timer port (Interrupt ID = 29)
        MOV R1, #1 // this field is a bit-mask; bit 0 targets cpu0
        BL CONFIG_INTERRUPT

        /* configure the GIC CPU Interface */
        LDR R0, =0xFFFEC100 // base address of CPU Interface
        /* Set Interrupt Priority Mask Register (ICCPMR) */
        LDR R1, =0xFFFF // enable interrupts of all priorities levels
        STR R1, [R0, #0x04]
        /* Set the enable bit in the CPU Interface Control Register (ICCICR).
        * This allows interrupts to be forwarded to the CPU(s) */
        MOV R1, #1
        STR R1, [R0]
        /* Set the enable bit in the Distributor Control Register (ICDDCR).
        * This enables forwarding of interrupts to the CPU Interface(s) */
        LDR R0, =0xFFFED000
        STR R1, [R0]
        POP {PC}

/*
* Configure registers in the GIC for an individual Interrupt ID
* We configure only the Interrupt Set Enable Registers (ICDISERn) and
* Interrupt Processor Target Registers (ICDIPTRn). The default (reset)
* values are used for other registers in the GIC
* Arguments: R0 = Interrupt ID, N
* R1 = CPU target
*/
CONFIG_INTERRUPT:
        PUSH {R4-R5, LR}
        /* Configure Interrupt Set-Enable Registers (ICDISERn).
        * reg_offset = (integer_div(N / 32) * 4
        * value = 1 << (N mod 32) */
        LSR R4, R0, #3 // calculate reg_offset
        BIC R4, R4, #3 // R4 = reg_offset
        LDR R2, =0xFFFED100
        ADD R4, R2, R4 // R4 = address of ICDISER
        AND R2, R0, #0x1F // N mod 32
        MOV R5, #1 // enable
        LSL R2, R5, R2 // R2 = value
        /* Using the register address in R4 and the value in R2 set the
        * correct bit in the GIC register */
        LDR R3, [R4] // read current register value
        ORR R3, R3, R2 // set the enable bit
        STR R3, [R4] // store the new register value
        /* Configure Interrupt Processor Targets Register (ICDIPTRn)
        * reg_offset = integer_div(N / 4) * 4
        * index = N mod 4 */
        BIC R4, R0, #3 // R4 = reg_offset
        LDR R2, =0xFFFED800
        ADD R4, R2, R4 // R4 = word address of ICDIPTR
        AND R2, R0, #0x3 // N mod 4
        ADD R4, R2, R4 // R4 = byte address in ICDIPTR
        /* Using register address in R4 and the value in R2 write to
        * (only) the appropriate byte */
        STRB R1, [R4]
        POP {R4-R5, PC}


/*--- Undefined instructions --------------------------------------*/
SERVICE_UND:
        B SERVICE_UND
/*--- Software interrupts ----------------------------------------*/
SERVICE_SVC:
        B SERVICE_SVC
/*--- Aborted data reads ------------------------------------------*/
SERVICE_ABT_DATA:
        B SERVICE_ABT_DATA
/*--- Aborted instruction fetch -----------------------------------*/
SERVICE_ABT_INST:
        B SERVICE_ABT_INST
/*--- IRQ ---------------------------------------------------------*/
SERVICE_IRQ:
        PUSH {R0-R7, LR}
        /* Read the ICCIAR from the CPU Interface */
        LDR R4, =0xFFFEC100
        LDR R5, [R4, #0x0C] // read from ICCIAR
        /* NOTE: Check which interrupt has occurred (check interrupt IDs)
        Then call the corresponding ISR
        If the ID is not recognized, branch to UNEXPECTED
        See the assembly example provided in the DE1-SoC Computer Manual
        on page 46 */
Pushbutton_check:
        CMP R5, #73
        BNE Timer_check
        BL KEY_ISR
        B EXIT_IQR
Timer_check:
        CMP R5, #29
        BNE UNEXPECTED
        BL ARM_TIM_ISR
        B EXIT_IQR
UNEXPECTED:
        B UNEXPECTED // if not recognized, stop here

EXIT_IRQ:
        /* Write to the End of Interrupt Register (ICCEOIR) */
        STR R5, [R4, #0x10] // write to ICCEOIR
        POP {R0-R7, LR}
        SUBS PC, LR, #4
/*--- FIQ ---------------------------------------------------------*/
SERVICE_FIQ:
        B SERVICE_FIQ

// key ISR
// reads edge capture and stores it in PB_int_flag
KEY_ISR:
        PUSH {LR}

        BL read_PB_edgecp_ASM
        LDR A2, =PB_int_flag
        STR A1, [A2]
        
        POP {PC}


// timer ISR
ARM_TIM_ISR:
        PUSH {LR}

        LDR A1, =tim_int_flag
        MOV A2, #1
        STR A2, [A1] // store 1 into it
        
        POP {PC}


// draw the current message
draw_current_message:
        PUSH {LR}

        LDR A3, =msg
        LDR A1, [A3] // A1 = msg

        LDR A3, =msg_length
        LDR A2, [A3] // A2 = msg_length

        LDR A3, =current_offset
        LDR A3, [A3] // A3 = current_offset

        BL display_msg

        POP {PC}

// increments the offset by the direction
// loops back to 0 if more or less than length
increment_offset:
        PUSH {V1-V5, LR}

        LDR V1, =current_offset
        LDR A1, [V1] // A1 = current_offset

        LDR A2, =direction
        LDR A2, [A2] // A2 = direction
        
        ADD A1, A1, A2 // A1 = current_offset + direction

        LDR A2, =msg_length
        LDR A2, [A2] // A2 = msg_length

        BL mod // A1 mod A2
        STR A1, [V1] // store A1 back into [V1]

        POP {V1-V5, PC}

// updates the current message and length based on
// the current message index
// returning the new message and length
update_message:
        PUSH {LR}

        LDR A1, =msg_index
        LDR A1, [A1]

        BL get_message // A1 message, A2 length

        LDR A3, =msg
        STR A1, [A3]

        LDR A3, =msg_length
        STR A2, [A3]

        MOV A4, #0
        LDR A3, =current_offset
        STR A4, [A3] // reset the current offset

        POP {PC}
        
// updates the current speed based on the current speed index
// will also update the timer configuration
update_speed:
        LDR A1, =speed_index
        LDR A1, [A1] // A1 is the index

        LSL A1, A1, #2

        LDR A2, =speeds
        LDR A3, =speed

        LDR A4, [A2, A1]
        STR A4, [A3] // store the speed

        // write to load so the next timer countdown is updated
        LDR A3, =LOAD_ADDR
        STR A4, [A3]

        BR LR

// increase the speed, but caps at the end of the array
increase_speed:
        PUSH {LR}

        LDR A1, =speed_index
        LDR A2, [A1] // A2 = speed_index

        CMP A2, #4
        ADDLT A2, A2, #1 // increases index if less than 4

        STR A2, [A1]

        // update the actual speed
        BL update_speed
        POP {LR}
        BX LR

        
// decerase the speed, but caps at 0
decrease_speed:
        PUSH {LR}

        LDR A1, =speed_index
        LDR A2, [A1] // A2 = speed_index

        CMP A2, #0
        SUBGT A2, A2, #1 // dec index if more than 0

        STR A2, [A1]

        // update the actual speed
        BL update_speed
        POP {LR}
        BX LR

        
// handle_key
handle_key:
        PUSH {V1, LR}

        MOV A1, =PB_int_flag
        MOV V1, [A1] // store the edge capture

        // key2 has no effect if paused
        LDR A1, =is_paused
        LDR A2, [A1]
        CMP A2, #1
        BEQ handle_key_3

handle_key_0:
        TST V1, #PB0 // test for 0
        BEQ handle_key_1 // skip if zero

        BL decrease_speed
        
handle_key_1:
        TST V1, #PB1 // test for 1
        BEQ handle_key_2 // skip if zero

        BL increase_speed

handle_key_2:
        TST V1, #PB2 // test for 2
        BEQ handle_key_3 // skip if zero

        LDR A1, =direction
        LDR A2, [A1]
        RSB A2, A2, #0
        STR A2, [A1]

handle_key_3:
        TST V1, #PB3 // test for 2
        BEQ end_handle_key // skip if zero

        LDR A1, =is_paused
        LDR A2, [A1]
        EOR A2, A2, #1
        STR A2, [A1]
 
end_handle_key:
        BL PB_clear_edgecp_ASM
        POP {V1, PC}

// handles the timer
handle_timer:
        PUSH {LR}

        LDR A1, =tim_int_flag
        LDR A2, [A1] // read the flag
        CMP A2, #0 // go out if nothing new
        BEQ end_handle_timer
        
        // otherwise handle it and clear the flag
        MOV A2, #0
        STR A2, [A1] // clear the flag
        
        BL ARM_TIM_clear_INT_ASM

        // if paused, also don't do anything
        LDR A1, =is_paused
        LDR A1, [A1]
        CMP A1, #1
        BEQ end_handle_timer

        
        BL increment_offset
        BL draw_current_message

end_handle_timer:
        POP {LR}
        BX LR

// displays the speed leds
display_speed_leds:
        PUSH {LR}

        LDR A2, =speed_index
        LDR A2, [A2] // A2 = speed index

        // right shift the full leds by the index times 2
        LSL A2, A2, #1
        MOV A1, 0b1111111111
        LSR A1, A2

        BL write_LEDs_ASM

        POP {PC}


// start
_start:
        /* Set up stack pointers for IRQ and SVC processor modes */
        MOV R1, #0b11010010 // interrupts masked, MODE = IRQ
        MSR CPSR_c, R1 // change to IRQ mode
        LDR SP, =0xFFFFFFFF - 3 // set IRQ stack to A9 on-chip memory
        /* Change to SVC (supervisor) mode with interrupts disabled */
        MOV R1, #0b11010011 // interrupts masked, MODE = SVC
        MSR CPSR, R1 // change to supervisor mode
        LDR SP, =0x3FFFFFFF - 3 // set SVC stack to top of DDR3 memory
        BL CONFIG_GIC // configure the ARM GIC
        // NOTE: write to the pushbutton KEY interrupt mask register
        // Or, you can call enable_PB_INT_ASM subroutine from previous task
        // to enable interrupt for ARM A9 private timer,
        // use ARM_TIM_config_ASM subroutine
        LDR A1, =0x2FAF07F
        LDR A2, =0b0000000000000111
        BL ARM_TIM_config_ASM
        MOV A1, #0xF
        BL enable_PB_INT_ASM
        
        LDR R0, =0xFF200050 // pushbutton KEY base address
        MOV R1, #0xF // set interrupt mask bits
        STR R1, [R0, #0x8] // interrupt mask register (base + 8)
        // enable IRQ interrupts in the processor
        MOV R0, #0b01010011 // IRQ unmasked, MODE = SVC
        MSR CPSR_c, R0

init_state:
        // set message index to 0
        LDR V1, =msg_index // msg_index addr
        MOV A1, #0
        STR A1, [v1]

        BL update_message
        BL draw_current_message

IDLE:
        // This is where you write your main program task(s)
        BL display_speed_leds

        BL read_slider_switches_ASM
        BL check_switches_index
        LDR A2, [V1] // A2 = the current msg index

        CMP A2, A1
        BNE IDLE_handle_key // don't update if it's not new
        
        STR A1, [V1]
        BL update_message

IDLE_handle_key:
        BL handle_key

IDLE_handle_timer:
        BL handle_timer

IDLE_next:
        B IDLE
