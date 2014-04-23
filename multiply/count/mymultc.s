@ Thomas Steinke & Elliot Fiske
@ Multiplier (mymult.s file)
@ Increments r7 for step counter

    .arch armv6
    .fpu vfp
    .text
    
    /* Multiply the numbers in r0 and r1 */
    .global mult
mult:
    push {r4, r5, r6, r7, lr, r0, r1}

        mov r7, #0

    /* Pass parameters to variable registers */
    pop {r5, r6}
        /* COUNTER */
        add r7, r7, #2

super:
    /* Check to see if it's easier to do rev(r5) */
    mov r4, #0
    mvn r0, r5
    cmp r0, r5
        /* COUNTER */
        add r7, r7, #4

    /* If not(r5) > r5 (unsigned), then we don't want it */
    bhi prep

    /* Otherwise switch them! */
    mov r1, #1
    bl add
    mov r5, r0
    mov r4, #1
        /* COUNTER */
        add r7, r7, #2

prep:
    /* Product = 0 */
    mov r0, #0
        /* COUNTER */
        add r7, r7, #1

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
    /* Don't do this if we didn't flip any bits */
    cmp r4, #0
        /* COUNTER (1 for branch) */
        add r7, r7, #2
    beq return

    mvns r0, r0
    mov r1, #1
        /* COUNTER (1 for branch) */
        add r7, r7, #3
    bl add

return:
    /* Display */
    mov r5, r0
    ldr r0, =display
    mov r1, r7
    bl printf
    mov r0, r5
    /* End display */

        /* COUNTER (for pop) */
        add r7, r7, #1
    pop {r4, r5, r6, r7, pc}


display:
    .asciz "%d\n"
