.section .data
    strone: .asciz "First String\n"
    strtwo: .asciz "Second String\n"

.section .text

.global _start
_start:
    # print all strings
    movl $strone, %eax
    pushl %eax
    call printf

    movl $strtwo, %eax
    pushl %eax
    call printf

    # print only second string, jumping first one
    movl $strone, %eax
    pushl %eax
    jmp R1
    call printf

    R1: movl $strtwo, %eax
    pushl %eax
    call printf

    pushl $0           # prepare program to exit
    call exit
