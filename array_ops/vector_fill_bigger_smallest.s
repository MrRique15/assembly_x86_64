.section .data
    smallest_num: .int 999999999
    biggest_num: .int 0
    zero_number: .int 0
    numbers_amount: .int 8
    inserted_numbers: .int 0
    v1: .int 0, 0, 0, 0, 0, 0, 0, 0
    
    result_string: .string "Biggest Number: %d, Smallest Number: %d\n"
    number_insert: .string "Insert an inteter number: \n"
    scan_string: .string "%d"

.text
.global _start

_start:
    movl $v1, %edi

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

        jmp print_results
        
change_biggest:
    movl (%edi), %eax
    movl %eax, biggest_num
    jmp continue_exec_1

change_smallest:
    movl (%edi), %eax
    movl %eax, smallest_num
    jmp continue_exec_2

print_results:
    pushl smallest_num
    pushl biggest_num
    pushl $result_string
    call printf
    addl $12, %esp

    jmp exit_program
    
exit_program:
    pushl $0
    call exit
