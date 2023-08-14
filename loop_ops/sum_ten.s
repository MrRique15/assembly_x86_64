.section .data
    iterations: .int 0
    result_string: .string "The final number is: %d\n"
    initial_number: .int 0
    initial_string: .string "The initial number is: %d\n"
    iterations_limit: .int 10
    value_string: .string "Value: %d | iteration: %d\n"
.section .text

.global _start

_start:
    pushl initial_number
    pushl $initial_string
    call printf
    addl $8, %esp

    movl initial_number, %ebx
    jmp condition_verifier

condition_verifier:
    movl iterations, %eax

    cmpl %eax, iterations_limit
    jne for_iteration
    jmp finish_iteration

for_iteration:
    addl $2, %ebx
    incl iterations

    movl %ebx, initial_number

    pushl iterations
    pushl initial_number
    pushl $value_string
    call printf
    addl $8, %esp

    jmp condition_verifier

finish_iteration:
    pushl %ebx
    pushl $result_string
    call printf
    addl $8, %esp

    pushl $0
    call exit
