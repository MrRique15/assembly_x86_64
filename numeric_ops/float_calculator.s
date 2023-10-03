.section .data
    # String variables
    formato_int: .asciz "%d"
    formato_float: .asciz "%f"
    clearScreenStr: .string "\033[H\033[J"
    mostra1: .asciz "\nSoma (N2 + N1) = %.4f\n"
    mostra4: .asciz "\nDivisao (N2 / N1) = %.4f\n"
    mostra2: .asciz "\nSubtracao (N2 - N1) = %.4f\n"
    mostra3: .asciz "\nMultiplicacao (N2 * N1) = %.4f\n"
    pedido1_loop: .asciz "\nDigite um valor (float) ou [0] para finalizar a operação\n===> "
    pedido0: .asciz "\nDigite o um valor (float)\n===> "
    pedido1: .asciz "\nDigite o primeiro valor (float)\n===> "
    pedido2: .asciz "\nDigite o segundo  valor (float)\n===> "
    options_string: .asciz "\t\t\nMenu de Opções: \n\t[1] - Soma\n\t[2] - Subtracao\n\t[3] - Multiplicacao\n\t[4] - Divisao\n\t[0] - Sair do programa: \n===>"
    # Float variables
    float1: .space 4
    float2: .space 4
    zero_number: .int 0

    # Integer variables
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
        je add_option_selected
        cmpl $2, %eax
        je sub_option_selected
        cmpl $3, %eax
        je mult_option_selected
        cmpl $4, %eax
        je div_option_selected
        cmpl $0, %eax
        je exit_program

    jmp _loop_program
# ###########################################################
exit_program:
    pushl $0
    call exit

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
# ###########################################################
read_number:
    pushl %ebp
    movl %esp, %ebp

    pushl $pedido0
    call printf
    addl $4, %esp

    pushl $float1
    pushl $formato_float
    call scanf
    addl $8, %esp

    leave
    ret

read_two_numbers:
    pushl %ebp
    movl %esp, %ebp

    pushl $pedido1
    call printf
    addl $4, %esp

    pushl $float1
    pushl $formato_float
    call scanf
    addl $8, %esp

    pushl $pedido2
    call printf
    addl $4, %esp

    pushl $float2
    pushl $formato_float
    call scanf
    addl $8, %esp

    leave
    ret

read_number_looping:
    pushl %ebp
    movl %esp, %ebp

    pushl $pedido1_loop
    call printf
    addl $4, %esp

    pushl $float1
    pushl $formato_float
    call scanf
    addl $8, %esp

    leave
    ret
# ###########################################################
add_floats:
    pushl %ebp
    movl %esp, %ebp

    call read_number
    flds float1

    _add_loop:
        call read_number

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
    pushl $mostra1
    call printf
    addl $8, %esp

    leave 
    ret

sub_floats:
    pushl %ebp
    movl %esp, %ebp

    flds float1
    flds float2
    fsubp

    subl $4, %esp

    fstl (%esp)

    pushl $mostra2
    call printf
    addl $8, %esp
    leave
    ret

mult_floats:
    pushl %ebp
    movl %esp, %ebp

    flds float1
    flds float2
    fmulp

    subl $4, %esp

    fstl (%esp)
    pushl $mostra3
    call printf
    addl $8, %esp
    
    leave
    ret

div_floats:
    pushl %ebp
    movl %esp, %ebp

    flds float1
    flds float2
    fdivp

    subl $4, %esp

    fstl (%esp)
    pushl $mostra4
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
