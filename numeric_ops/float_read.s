
.section .data
    promptText: .asciz "Enter a float number: "
    formatString: .asciz "%lf"  # Format specifier for scanning a double
    inputNumber: .double 0.0
    outputString: .asciz "Inserted number: %lf\n"

.section .text
.global _start

_start:
    jmp read_float

    continue_1:
    jmp print_float

    finish:
    jmp exit_program

read_float:
    pushl $promptText
    call printf
    addl $4, %esp

    pushl $inputNumber
    pushl $formatString
    call scanf
    addl $8, %esp

    fldl (inputNumber)

    jmp continue_1 

print_float:
    fstl (%esp)
    pushl $outputString
    call printf
    addl $8, %esp

    jmp finish 

exit_program:
    pushl $0
    call exit
