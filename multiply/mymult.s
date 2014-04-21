@ Thomas Steinke & Elliot Fiske
@ Multiplier (mymult.s file)

    .arch armv6
    .fpu vfp
    .text
    
    /* Multiply the numbers in r0 and r1 */
    .global mult
mult:
    push {r5, r6, lr, r0, r1}

    /* Pass parameters to variable registers */
    pop {r5, r6}

    /* Product = 0 */
    mov r0, #0
while:
    /* If LSB(r5) == 0 Skip to endwhile */ 
    ands r3, r5, #1
    beq endwhile

    /* Add multiwhatever */
    mov r1, r6
    bl add

endwhile:
    /* Shift multiplier/multiplicand */
    lsrs r5, r5, #1
    lsls r6, r6, #1

    /* Break on r5 == 0 */
    cmp r5, #0
    bne while

endmult:
    pop {r5, r6, pc}
