@ Thomas Steinke & Elliot Fiske
@ Multiplier (mymult.s file)
@ Increments r7 for step counter

    .arch armv6
    .fpu vfp
    .text
    
    /* Multiply the numbers in r0 and r1 */
    .global mult
mult:
    push {r5, r6, r7, lr, r0, r1}

    mov r7, #0

    /* Pass parameters to variable registers */
    pop {r5, r6}

    /* Product = 0 */
    mov r0, #0
        /* COUNTER */
        add r7, r7, #3

while:
    /* If LSB(r5) == 0 Skip to endwhile */ 
    ands r3, r5, #1
        /* COUNTER (1 for the branch) */
        add r7, r7, #2
    beq endwhile

    /* Add multiwhatever */
    mov r1, r6
        /* COUNTER (1 for the branch) */
        add r7, r7, #2
    bl add

endwhile:
    /* Shift multiplier/multiplicand */
    lsrs r5, r5, #1
    lsls r6, r6, #1

    /* Break on r5 == 0 */
    cmp r5, #0
        /* COUNTER (1 for the branch) */
        add r7, r7, #4
    bne while

endmult:
        /* COUNTER (for pop) */
        add r7, r7, #1

    /* Display */
    mov r5, r0
    ldr r0, =display
    mov r1, r7
    bl printf

    mov r0, r5

    pop {r5, r6, r7, pc}

display:
    .asciz "Number of commands: %d\n"
