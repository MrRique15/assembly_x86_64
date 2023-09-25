
.section .data
    promptText: .asciz "Enter a float number: "
    formatString: .asciz "%lf"  # Format specifier for scanning a double
    inputNumber: .double 0.0
    outputString: .asciz "Inserted number: %lf\n"

.section .text
.global _start

_start:
    call read_float

    continue_1:
    call print_float

    finish:
    jmp exit_program

read_float:
    pushl %ebp
    movl %esp, %ebp

    pushl $promptText
    call printf
    addl $4, %esp

    pushl $inputNumber
    pushl $formatString
    call scanf
    addl $8, %esp

    fldl (inputNumber)

    movl %ebp, %esp
    popl %ebp
    ret

print_float:
    pushl %ebp
    movl %esp, %ebp

    pushl %esp

    fstl (%esp)
    pushl $outputString
    call printf
    addl $8, %esp

    popl %esp
    
    movl %ebp, %esp
    popl %ebp
    ret

exit_program:
    pushl $0
    call exit
