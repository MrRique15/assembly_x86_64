.section .data
    texto1: .asciz "Soma: %d\n"
    v1: .int	10, 20, 30

.text
.globl _start

_start:

    #O trecho a seguir soma os 3 valores do rótulo v1, que funciona como um vetor. 
    #O endereço inicial do vetor é colocado em %edi e as diferentes posições são acessadas     
    #incrementando o %edi a cada 4 bytes de forma a causar um deslocamento no acesso deste     
    #vetor.

    movl $v1, %edi
    movl (%edi), %eax
    addl $4, %edi
    addl (%edi), %eax
    addl $4, %edi
    addl (%edi), %eax

    pushl %eax
    pushl $texto1
    call printf

    pushl $0
    call exit
