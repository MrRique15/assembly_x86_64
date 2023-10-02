.section .data
    # String variables
    formato_int: .asciz "%d"
    formato_float: .asciz "%f"
    clearScreenStr: .string "\033[H\033[J"
    mostra1: .asciz "\nSoma (N2 + N1) = %.4f\n"
    mostra4: .asciz "\nDivisao (N2 / N1) = %.4f\n"
    mostra2: .asciz "\nSubtracao (N2 - N1) = %.4f\n"
    mostra3: .asciz "\nMultiplicacao (N2 * N1) = %.4f\n"
    pedido1: .asciz "\nDigite um valor (float) => "
    options_string: .asciz "\t\t\nMenu de Opções: \n\t[1] - Realizar Outra operacao\n\t[0] - Sair do programa: \n===>"
    # Float variables
    float1: .space 4
    float2: .space 4

    # Integer variables
    option_selected: .int 0
.section .text

.global _start
_start:
    _loop_program:
    finit

    call read_numbers

    call add_floats
    call sub_floats
    call mult_floats
    call div_floats

    call options_menu

    movl option_selected, %eax
    cmpl $1, %eax
    je _loop_program

    jmp exit_program

read_numbers:
    pushl %ebp
    movl %esp, %ebp

    pushl $pedido1
    call printf

    pushl $float1
    pushl $formato_float
    call scanf
    addl $12, %esp

    pushl $pedido1
    call printf

    pushl $float2
    pushl $formato_float
    call scanf
    addl $12, %esp

    leave
    ret

add_floats:
    pushl %ebp
    movl %esp, %ebp

    flds float1
    flds float2
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

exit_program:
    pushl $0
    call exit
