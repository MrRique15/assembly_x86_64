.section .data
    v1: .space 32         # creates one variable with 32 bits in memory, that you can fill with INT or String, adding $4 in mem address
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

# function to verify if a number is tringular ex: (1x2x3=6) 6 is triangular, (2x3x4=24) 24 is triangular
verify_triangular:
    movl (%edi), %ebx

    multiplication_loop:
        movl initial_mult_number, %eax  # %eax = initial_mult_number

        movl %eax, %ecx
        addl $1, %ecx
        imull %ecx, %eax  # %eax = initial_mult_number x initial_mult_number+1
        addl $1, %ecx
        imull %ecx, %eax  # %eax = initial_mult_number x initial_mult_number+1 x initial_mult_number+2

        cmpl %ebx, %eax
        jg return_to_insertion   # if the multiplication result is bigger than number, returns to insertion loop
        je found_triangular      # if the multiplication is equal the number, it found a triangular number

        addl $1, initial_mult_number
        jmp multiplication_loop  # jump to continue multiplication loop when the multiplication result is lower than verifyed number
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
