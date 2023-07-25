.section .data
    value1: .long 123
    value2: .long 152
    format: .asciz "Soma: %ld\n"  # Format da string para o printf da soma
    formatsub: .asciz "Subtracao: %ld\n" # Format da string para o printf da subtracao
    normalnum1: .asciz "Valor1: %ld\n" # Format da string para o printf de um numero qualquer
    normalnum2: .asciz "Valor2: %ld\n" # Format da string para o printf de um numero qualquer

.text
.global _start

_start:
    # soma de valores
    movl value1, %ebx
    movl value2, %eax
    addl %ebx, %eax
    pushl %eax           # Coloca o resultado na pilha
    pushl $format        # Coloca a stirng de resultado na pilha
    call printf          # Chama printf do C

    # subtracao de valores
    movl value1, %ebx
    movl value2, %eax
    subl %ebx, %eax
    pushl %eax           # Coloca o resultado na pilha
    pushl $formatsub        # Coloca a stirng de resultado na pilha
    call printf          # Chama printf do C
    
    # Troca valores entre registradores
    movl value1, %ebx
    movl value2, %eax
    xchgl %eax, %ebx    # troca os valores entre os dois registradores [eax <-> ebx]
    pushl %eax
    pushl $normalnum2
    call printf
    pushl %ebx
    pushl $normalnum1
    call printf

    pushl $0             # Coloca o status de exit na pilha
    call exit            # Call exit
