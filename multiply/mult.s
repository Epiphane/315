@ Thomas Steinke & Elliot Fiske
@ Multiplier

    .arch armv6
    .fpu vfp
    .text

    /* Prints out two numbers */
    .global print
print: 
        

    .global main
main:
    push {lr}

    mov r0, #7
    mov r1, #6

    /* Multiply the two */
    bl mult

    mov r3, r0
    mov r1, #7
    mov r2, #6
    ldr r0, =string

    bl printf
    pop {pc}
end:

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
    cbz r5, while

endmult:
    mov r0, r4
    pop {r4, r5, r6, pc}

string:
    .asciz "%d * %d = %d\n"
