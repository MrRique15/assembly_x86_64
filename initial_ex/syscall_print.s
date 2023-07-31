.section .data
    msg:
        .ascii "Hello, World!\n"
        len = . - msg              # ou, pode criar o len na mao, considerando \n como um caractere só (14 para esse caso)

.section .text
.global _start

_start:
    movl $4, %eax
    movl $1, %ebx
    movl $msg, %ecx
    movl $len, %edx
    int $0x80
    movl $1, %eax
    movl $0, %ebx
    int $0x80
