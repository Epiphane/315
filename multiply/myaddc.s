@ Thomas Steinke & Elliot Fiske
@ Multiplier (myadd.s file)
@ Increments r7 for step counter
@ WARNING: DO NOT USE ON YOUR PETS. IT ACTUALLY CHANGS r7!

    .arch armv6
    .fpu vfp
    .text
    
    /* Add the numbers in r0 and r1 */
    .global add
add:
    push {lr}
        
        /* COUNTER */
        add r7, r7, #1

keepadding:

    /* Get AND */
    ands r2, r0, r1

    /* Get XOR */
    eor r0, r0, r1

        /* COUNTER (1 for the branch) */
        add r7, r7, #3
   
    /* Uses the result of 'and' to break or not */
    beq endadd

    /* Shift the carry left 1 */
    lsls r1, r2, #1
        
        /* COUNTER (1 for the branch) */
        add r7, r7, #2

    /* Add the XOR + AND(shifted) */
    bl keepadding

endadd:
        /* COUNTER */
        add r7, r7, #1
    pop {pc}
