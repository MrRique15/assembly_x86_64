.section .data
    # String variables
    formato_int: .asciz "%d"
    formato_float: .asciz "%f"
    clearScreenStr: .string "\033[H\033[J"

    # euclidian strings
    pedido_x1: .asciz "\nDIGITE O VALOR DE x1\n\n===>"
    pedido_x2: .asciz "\nDIGITE O VALOR DE x2\n\n===>"
    pedido_y1: .asciz "\nDIGITE O VALOR DE y1\n\n===>"
    pedido_y2: .asciz "\nDIGITE O VALOR DE y2\n\n===>"
    resultado_euclidian: .asciz "\nDistancia EUCLIDIANA calculada = %.4f\n"

    # sqrt strings
    resultado_sqrt: .asciz "\nResultado da RAIZ QUADRADA = %.4f\n"
    pedido_sqrt: .asciz "\nDIGITE UM VALOR PARA CALCULAR SUA RAIZ (float)\n\n===>"

    # pow strings
    resultado_pow: .asciz "\nResultado do QUADRADO = %.4f\n"
    pedido_pow: .asciz "\nDIGITE UM VALOR PARA CALCULAR SEU VALOR AO QUADRADO (float)\n\n===>"

    # sum strings
    resultado_sum: .asciz "\nResultado da SOMA = %.4f\n"
    pedido_sum: .asciz "\nDIGITE O PRIMEIRO VALOR DA SOMA (float)\n\n===> "
    pedido_sum_loop: .asciz "\nDIGITE UM VALOR (float) PARA SOMAR\n[0] PARA FINALIZAR A SOMA\n\n===> +"

    # sub strings
    resultado_sub: .asciz "\nResultado da SUBTRACAO = %.4f\n"
    pedido_sub: .asciz "\DIGITE O VALOR INICIAL DA SUBTRACAO (float)\n\n===>"
    pedido_sub_loop: .asciz "\DIGITE UM VALOR (float) PARA SUBTRAIR\n[0] PARA FINALIZAR A SUBTRACAO\n\n===> -"

    # generic op strings
    resultado_generic: .asciz "\nResultado = %.4f\n"
    pedido_generic: .asciz "\DIGITE O PRIMEIRO VALOR DA OPERACAO (float) COM SINAL\n[+/-]X\n\n===>"
    pedido_generic_loop: .asciz "\DIGITE UM VALOR (float) COM SINAL\n[0] PARA FINALIZAR A OPERACAO\n[+/-]X\n\n===>"

    # div strings
    coleta_div: .asciz "%f / %f"
    resultado_div: .asciz "\nResultado da DIVISAO = %.4f\n"
    pedido_div: .asciz "\nDIGITE OS VALORES DA DIVISÃO (x / y) (floats)\nINSIRA EXATAMENTE NO FORMATO ->  x / y\n\n===>"
    
    # Mul strings
    coleta_mul: .asciz "%f * %f"
    resultado_mul: .asciz "\nResultado da MULTIPLICACAO = %.4f\n"
    pedido_mul: .asciz "\nDIGITE OS VALORES DA MULTIPLICACAO (x * y) (floats)\nINSIRA EXATAMENTE NO FORMATO ->  x * y\n\n===>"

    # menu strings
    options_string: .asciz "\t\t\nMenu de Opções: \n\t[1] - GENERICA (soma/sub)\n\t[2] - SOMA\n\t[3] - SUBTRACAO\n\t[4] - MULTIPLICACAO\n\t[5] - DIVISAO\n\t[6] - RAIZ QUADRADA\n\t[7] - ELEVAR AO QUADRADO\n\t[8] - DISTANCIA EUCLIDIANA\n\t[0] - SAIR DO PROGRAMA: \n===>"

    # Float variables
    float1: .space 4
    float2: .space 4

    # Integer variables
    zero_number: .int 0
    option_selected: .int 0
.section .text

.global _start
# ###########################################################
_start:
    _loop_program:

        finit

        call options_menu

        movl option_selected, %eax

        cmpl $1, %eax
        je generic_option_selected
        cmpl $2, %eax
        je add_option_selected
        cmpl $3, %eax
        je sub_option_selected
        cmpl $4, %eax
        je mult_option_selected
        cmpl $5, %eax
        je div_option_selected
        cmpl $6, %eax
        je sqrt_option_selected
        cmpl $7, %eax
        je pow_option_selected
        cmpl $8, %eax
        je euclidian_option_selected
        cmpl $0, %eax
        je exit_program

    jmp _loop_program
# ###########################################################
exit_program:
    pushl $0
    call exit

generic_option_selected:
    call generic_floats
    jmp _loop_program

add_option_selected:
    call add_floats
    jmp _loop_program

sub_option_selected:
    call sub_floats
    jmp _loop_program

mult_option_selected:
    call mult_floats
    jmp _loop_program

div_option_selected:
    call div_floats
    jmp _loop_program

sqrt_option_selected:
    call sqrt_float
    jmp _loop_program

pow_option_selected:
    call pow_float
    jmp _loop_program

euclidian_option_selected:
    call euclidian_distance
    jmp _loop_program
# ###########################################################
read_number:
    pushl %ebp
    movl %esp, %ebp

    movl 8(%ebp), %edi

    pushl %edi
    call printf
    addl $4, %esp

    pushl $float1
    pushl $formato_float
    call scanf
    addl $8, %esp

    leave
    ret

# read_two_numbers:
#     pushl %ebp
#     movl %esp, %ebp
# 
#     movl 8(%ebp), %edi
# 
#     pushl %edi
#     call printf
#     addl $4, %esp
# 
#     pushl $float1
#     pushl $formato_float
#     call scanf
#     addl $8, %esp
# 
#     movl 12(%ebp), %edi
# 
#     pushl %edi
#     call printf
#     addl $4, %esp
# 
#     pushl $float2
#     pushl $formato_float
#     call scanf
#     addl $8, %esp
# 
#     leave
#     ret

read_number_looping:
    pushl %ebp
    movl %esp, %ebp

    movl 8(%ebp), %edi

    pushl %edi
    call printf
    addl $4, %esp

    pushl $float1
    pushl $formato_float
    call scanf
    addl $8, %esp

    leave
    ret
# ###########################################################
generic_floats:
    pushl %ebp
    movl %esp, %ebp

    pushl $pedido_generic
    call read_number
    addl $4, %esp

    flds float1

    _generic_loop:
        pushl $pedido_generic_loop
        call read_number_looping
        addl $4, %esp

        flds float1

        ficoml zero_number
        fnstsw
        sahf  
        je _exit_generic_loop

        faddp

    jmp _generic_loop

    _exit_generic_loop:
    faddp

    subl $4, %esp
    fstl (%esp)
    pushl $resultado_generic
    call printf
    addl $8, %esp

    leave 
    ret

add_floats:
    pushl %ebp
    movl %esp, %ebp

    pushl $pedido_sum
    call read_number
    addl $4, %esp

    flds float1

    _add_loop:
        pushl $pedido_sum_loop
        call read_number_looping
        addl $4, %esp

        flds float1

        ficoml zero_number
        fnstsw
        sahf  
        je _exit_sum_loop

        faddp

    jmp _add_loop

    _exit_sum_loop:
    faddp

    subl $4, %esp
    fstl (%esp)
    pushl $resultado_sum
    call printf
    addl $8, %esp

    leave 
    ret

sub_floats:
    pushl %ebp
    movl %esp, %ebp

    pushl $pedido_sub
    call read_number
    addl $4, %esp

    flds float1

    _sub_loop:
        pushl $pedido_sub_loop
        call read_number_looping
        addl $4, %esp

        flds float1

        ficoml zero_number
        fnstsw
        sahf  
        je _exit_sub_loop

        fsubp

    jmp _sub_loop

    _exit_sub_loop:
    fsubp

    subl $4, %esp
    fstl (%esp)
    pushl $resultado_sub
    call printf
    addl $8, %esp

    leave 
    ret

mult_floats:
    pushl %ebp
    movl %esp, %ebp

    pushl $pedido_mul
    call printf
    addl $4, %esp

    pushl $float1
    pushl $float2
    pushl $coleta_mul
    call scanf
    addl $12, %esp

    flds float1
    flds float2
    fmulp

    subl $4, %esp

    fstl (%esp)
    pushl $resultado_mul
    call printf
    addl $8, %esp
    
    leave
    ret

div_floats:
    pushl %ebp
    movl %esp, %ebp

    pushl $pedido_div
    call printf
    addl $4, %esp

    pushl $float1
    pushl $float2
    pushl $coleta_div
    call scanf
    addl $12, %esp

    flds float1
    flds float2
    fdivp

    subl $4, %esp

    fstl (%esp)
    pushl $resultado_div
    call printf
    addl $8, %esp

    leave
    ret

sqrt_float:
    pushl %ebp
    movl %esp, %ebp

    pushl $pedido_sqrt
    call read_number
    addl $4, %esp

    flds float1
    fsqrt

    subl $4, %esp
    fstl (%esp)
    pushl $resultado_sqrt
    call printf
    addl $8, %esp

    leave
    ret

pow_float:
    pushl %ebp
    movl %esp, %ebp

    pushl $pedido_pow
    call read_number
    addl $4, %esp

    flds float1
    flds float1
    fmulp

    subl $4, %esp
    fstl (%esp)
    pushl $resultado_pow
    call printf
    addl $8, %esp

    leave
    ret

euclidian_distance:
    pushl %ebp
    movl %esp, %ebp

    pushl $pedido_x1
    call read_number
    addl $4, %esp
    flds float1

    pushl $pedido_x2
    call read_number
    addl $4, %esp
    flds float1

    fsubp
    fmul %st(0), %st(0)

    pushl $pedido_y1
    call read_number
    addl $4, %esp
    flds float1

    pushl $pedido_y2
    call read_number
    addl $4, %esp
    flds float1

    fsubp
    fmul %st(0), %st(0)

    faddp
    fsqrt

    subl $4, %esp
    fstl (%esp)
    pushl $resultado_euclidian
    call printf
    addl $8, %esp

    leave
    ret

options_menu:
    pushl %ebp
    movl %esp, %ebp

    pushl $options_string
    call printf
    addl $4, %esp

    pushl $option_selected
    pushl $formato_int
    call scanf
    addl $8, %esp

    pushl $clearScreenStr
    call printf
    addl $4, %esp
    
    leave
    ret
