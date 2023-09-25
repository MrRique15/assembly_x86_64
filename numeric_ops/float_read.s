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

    leave
    ret

print_float:
    pushl %ebp
    movl %esp, %ebp

    subl $8, %esp   # Allocate space for the float number on the stack

    fstpl (%esp)
    pushl $outputString
    call printf
    addl $12, %esp
    
    leave
    ret

exit_program:
    pushl $0
    call exit
