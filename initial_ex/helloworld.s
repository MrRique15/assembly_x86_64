.section .data
    message: .asciz "Hello World Assembly!\n"

.text 
.global _start

_start:
    movl $message, %eax
    pushl %eax
    call printf
    pushl $0
    call exit
