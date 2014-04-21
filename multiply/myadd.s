@ Thomas Steinke & Elliot Fiske
@ Multiplier (myadd.s file)

    .arch armv6
    .fpu vfp
    .text
    
    /* Add the numbers in r0 and r1 */
    .global add
add:
    push {lr}
    
    /* Get XOR */
    eors r3, r0, r1

    /* Get AND */
    ands r2, r0, r1
    
    /* Put the XOR in r0 */
    mov r0, r3

    beq endadd

    /* Shift the carry left 1 */
    lsls r1, r2, #1

    /* Add the XOR + AND(shifted) */
    bl add
endadd:
    pop {pc}
