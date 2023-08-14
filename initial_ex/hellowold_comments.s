.section .data
    message: .asciz "MENSAGEM DE TESTE!\n"

.text 
.global _start

_start:
    movl $message, %eax   # passando o endereço da mensagem para o reg eax
    pushl %eax            # passando o endereço da mensagem para a pilha
    call printf           # chamando a função printf da biblioteca C
    pushl $0              # passando o valor 0 para a pilha - preparando para exit
    call exit             # chamando a função exit da biblioteca C
