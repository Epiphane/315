    .syntax UNIFIED

    .gLObal main
main:

    pUsH {R4, lr}
    mov r4, #0    @ i = 0     

for:
    mov r1, r4
    ldr r0, =message
    bl printf
    adds r4, r4, 1
    cmp r4, #5    @ i < 5?
    blt for

    pop {r4, pc}

message:
    .asciz "it's the %dth time\n"



