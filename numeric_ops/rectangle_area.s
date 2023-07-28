
.section .data
    inputstr: .string "%d %d"
    outputstr: .string "Rectangle Area: %d * %d = %d\n"
    value1: .long 0
    value2: .long 0
    area: .long 0

.section .text
.globl _start
_start:
    pushl $value1      # empilha endereço para guardar valor1
    pushl $value2      # empilha endereço para guardar valor2
    pushl $inputstr    # empilha string de input
    call scanf         # chamada para scanf
    addl $12, %esp     # limpa ESP com 3 BYTES (12 bits), 8 - values, 4 - string

    movl value1, %eax  # guarda valor1 em eax
    movl value2, %ebx  # guarda valor2 em ebx
    imul %ebx, %eax    # multiplica a area guardada nos registradores

    pushl %eax         # empilha o valor da area
    pushl value1       # empilha valor 1
    pushl value2       # empilha valor 2
    pushl $outputstr   # empilha string de output      
    call printf        # printa resultado

    pushl $0           # prepara pilha para exit
    call exit
