.section .data
    inputstr: .string "%d %d"
    outputstr: .string "Triangle Area: (%d * %d) / %d = %d\n"
    infostr: .string "Insira os valores: '(base) (altura)':\n"
    formulastr: .string "Formula: a = [(b * h) / 2]\n"
    base: .long 0
    high: .long 0
    divisor: .long 2
    
.section .text
.global _start
_start:
    pushl $formulastr
    call printf
    pushl $infostr
    call printf 
    addl $8, %esp            # limpa ESP com 64 bits (8 Bytes), 8 - string

    pushl $base
    pushl $high
    pushl $inputstr
    call scanf
    addl $12, %esp           # limpa ESP com 96 bits (12 Bytes), 8 - values, 4 - string

    movl $0, %edx            # limpa edx para divisao, ira guardar "resto" da divisao
    movl base, %eax
    movl high, %ebx
    imul %ebx, %eax          # multiplica e guarda em eax
    # mov eax, (dividendo)   # caso necessário, move dividendo para o eax, nesse caso, já está, entao fica comentado
    movl divisor, %ecx       # envia divisor para ecx (divisor)
    divl %ecx                # divide e armazena em eax

    pushl %eax               # empilha valor da area
    pushl divisor            # empilha divisor
    pushl base               # empilha valor da base
    pushl high               # empilha valor da altura
    pushl $outputstr         # empilha string de output
    call printf              # chamada para printf

    pushl $0    # prepara pilha para exit
    call exit   # chamada para exit
