.global _start

LOAD_ADDR = 0xFFFEC600
COUNTER_ADDR = 0xFFFEC604
CTRL_ADDR = 0xFFFEC608
INT_ST_ADDR = 0xFFFEC60C

// configures the private timer
// A1: initial count value (32bit value into load register)
// A2: configuration bits (15-8bit prescaler, 2 I, 1 A 0 E)
ARM_TIM_config_ASM:
    LDR A3, =LOAD_ADDR
    LDR A4, =CTRL_ADDR

    STR A1, [A3]
    STR A2, [A4]
    
    BX LR


_start:
    LDR A1, =10
    LDR A2, =0b0000000000000011
    //         | pres |     IAE

    BL ARM_TIM_config_ASM

    
_stop:
    B _stop
                                
