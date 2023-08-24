.section .data
    v1: .space 32
    zero_number: .int 0
    numbers_to_insert: .int 7
    triangular_amount: .int 0
    initial_mult_number: .int 1

    scan_string: .string "%d"
    info_string: .string "Enter one number: \n"
    result_string: .string "The amount of triangular numbers is: %d\n"
    
.text
.global _start
_start:
    movl $v1, %edi

    jmp loop_insert

loop_insert:
    pushl $info_string
    call printf
    addl $4, %esp

    pushl %edi
    pushl $scan_string
    call scanf
    addl $8, %esp

    movl $1, initial_mult_number
    call verify_triangular

    return_to_insertion:
        addl $4, %edi

        movl numbers_to_insert, %eax
        decl numbers_to_insert
        cmpl zero_number, %eax
        jne loop_insert

        jmp finish_program


verify_triangular:
    movl (%edi), %ebx

    multiplication_loop:
        movl initial_mult_number, %eax

        movl %eax, %ecx
        addl $1, %ecx
        imull %ecx, %eax
        addl $1, %ecx
        imull %ecx, %eax

        cmpl %ebx, %eax
        jg return_to_insertion
        je found_triangular

        addl $1, initial_mult_number
        jmp multiplication_loop
    ret

found_triangular:
    addl $1, triangular_amount
    ret

finish_program:
    pushl triangular_amount
    pushl $result_string
    call printf
    addl $8, %esp

    pushl $0
    call exit
