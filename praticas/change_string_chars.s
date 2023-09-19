# pratica 02 - change string chars to CPUID output
.section .data
    output: 
        .ascii "O ID do fabricante eh 'xxxxxxxxxxxx'!\n"
        len = . - output

.section .text
.global _start

_start:
    movl $0, %eax
    cpuid

    movl $output, %edi
    movl %ebx, 23(%edi) # caracter 24 da area apontada
    movl %edx, 27(%edi) # caracter 28 da area apontada
    movl %ecx, 31(%edi) # caracter 32 da area apontada

    movl $4, %eax
    movl $1, %ebx
    movl $output, %ecx
    movl $len, %edx
    int $0x80

    movl $1, %eax # código da chamada ao sistema exit
    movl $0, %ebx # código de término normal da aplicação
    int $0x80 # código da classe de interrupções
