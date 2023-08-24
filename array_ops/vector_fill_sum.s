.section .data
    # ------------------------------------------------------------------------
    # integer data
    sum_value: .int 0
    biggest_num: .int 0
    zero_number: .int 0
    errors_limit: .int 3
    numbers_amount: .int 0
    max_insertions: .int 20
    inserted_numbers: .int 0
    smallest_num: .int 999999999
    v1: .space 84
    # ------------------------------------------------------------------------
    # text data
    scan_string: .string "%d"
    sum_result_string: .string "Total Sum: %d\n"
    number_insert: .string "Insert an integer number: \n"
    exiting_error_string: .string "Max retries reached, exiting\n"
    divisor_string: .string "-----------------------------------------------\n"
    info_string: .string "Insert the amount of numbers to be inserted [1-20]: \n"
    result_string: .string "Biggest Number Inserted: %d, Smallest Number Inserted: %d\n"
    amount_error_string: .string "%d inserted, supported only [1-20], please try again with supported values! (%d retries left)\n"
     # ------------------------------------------------------------------------
    
.text
.global _start

_start:
    pushl $info_string
    call printf
    addl $4, %esp

    pushl $numbers_amount
    pushl $scan_string
    call scanf
    addl $8, %esp

    movl numbers_amount, %eax
    cmpl max_insertions, %eax
    jg error_by_user

    movl numbers_amount, %eax
    cmpl zero_number, %eax
    je error_by_user

    movl $v1, %edi

    jmp insertion_loop

error_by_user:
    decl errors_limit

    pushl $divisor_string
    call printf
    addl $4, %esp

    pushl errors_limit
    pushl numbers_amount
    pushl $amount_error_string
    call printf
    addl $8, %esp

    movl errors_limit, %eax
    cmpl zero_number, %eax
    je exiting_by_error

    jmp _start

exiting_by_error:
    pushl $exiting_error_string
    call printf
    addl $4, %esp

    jmp exit_program

insertion_loop:
    pushl $number_insert
    call printf
    addl $4, %esp
    
    pushl %edi
    pushl $scan_string
    call scanf
    addl $8, %esp

    movl (%edi), %ebx
    cmpl biggest_num, %ebx
    jg change_biggest

    continue_exec_1: 
        movl (%edi), %ebx
        cmpl smallest_num, %ebx
        jl change_smallest

    continue_exec_2: 
        addl $4, %edi
        incl inserted_numbers
        movl inserted_numbers, %eax
        cmpl numbers_amount, %eax
        jne insertion_loop

        movl $0, %ebx
        jmp sum_loop
        
change_biggest:
    movl (%edi), %eax
    movl %eax, biggest_num
    jmp continue_exec_1

change_smallest:
    movl (%edi), %eax
    movl %eax, smallest_num
    jmp continue_exec_2

sum_loop:

    addl (%edi), %ebx
    subl $4, %edi

    movl numbers_amount, %eax
    decl numbers_amount
    cmpl zero_number, %eax
    jne sum_loop

    movl %ebx, sum_value
    jmp print_results

print_results:
    pushl $divisor_string
    call printf
    addl $4, %esp

    pushl smallest_num
    pushl biggest_num
    pushl $result_string
    call printf
    addl $12, %esp

    pushl $divisor_string
    call printf
    addl $4, %esp

    pushl sum_value
    pushl $sum_result_string
    call printf
    addl $8, %esp

    pushl $divisor_string
    call printf
    addl $4, %esp

    jmp exit_program
    
exit_program:
    pushl $0
    call exit
