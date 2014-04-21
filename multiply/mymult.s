@ Thomas Steinke & Elliot Fiske
@ Multiplier (mymult.s file)

    .arch armv6
    .fpu vfp
    .text
    
    /* Multiply the numbers in r0 and r1 */
    .global mult
mult:
    push {r4, r5, r6, lr}

    /* Product = 0 */
    mov r4, #0

    /* Pass parameters to variable registers */
    mov r5, r0
    mov r6, r1
while:
    /* If LSB(r5) == 0 Skip to endwhile */ 
    ands r3, r5, #1
    beq endwhile

    /* Add multiwhatever */
    mov r0, r4
    mov r1, r6
    bl add
    mov r4, r0

endwhile:
    /* Shift multiplier/multiplicand */
    lsrs r5, r5, #1
    lsls r6, r6, #1

    /* Break on r5 == 0 */
    cmp r5, #0
    bne while

endmult:
    mov r0, r4
    pop {r4, r5, r6, pc}
