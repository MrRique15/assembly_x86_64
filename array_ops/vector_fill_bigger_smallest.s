.section .data
    menor: .int 999999999
    maior: .int 0
    zero_number: .int 0
    numbers_amount: .int 8
    inserted_numbers: .int 0
    v1: .int 0, 0, 0, 0, 0, 0, 0, 0
    
    result_string: .string "Maior Numero: %d, Menor Numero: %d\n"
    number_insert: .string "Insira um número inteiro: \n"
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
    cmpl maior, %ebx
    jg trocar_maior

    continue_exec_1: 
        movl (%edi), %ebx
        cmpl menor, %ebx
        jl trocar_menor

    continue_exec_2: 
        addl $4, %edi
        incl inserted_numbers
        movl inserted_numbers, %eax
        cmpl numbers_amount, %eax
        jne insertion_loop

        jmp print_results
        
trocar_maior:
    movl (%edi), %eax
    movl %eax, maior
    jmp continue_exec_1

trocar_menor:
    movl (%edi), %eax
    movl %eax, menor
    jmp continue_exec_2

print_results:
    pushl menor
    pushl maior
    pushl $result_string
    call printf
    addl $12, %esp

    jmp exit_program
    
exit_program:
    pushl $0
    call exit
