.section .data
    value1: .long 10
    value2: .long 2
    value3: .long 5
    formatstr: .asciz "Resultado da multiplicacao: %ld\n"  # Format da string para o printf da multiplicacao

.text
.global _start

_start:
    # multiplicacao de 3 valores (10 * 2 * 5) = 100
    movl value1, %eax
    movl value2, %ebx
    mull %ebx            # Multiplica os valores de ebx e eax e coloca o resultado em edx:eax
    movl value3, %ebx
    mull %ebx            # Multiplica os valores de ebx e eax e coloca o resultado em edx:eax
    pushl %eax           # Coloca o resultado na pilha
    pushl $formatstr     # Coloca a stirng de resultado na pilha
    call printf          # Chama printf do C
    pushl $0             # Coloca o status de exit na pilha
    call exit            # Call exit
