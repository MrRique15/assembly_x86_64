.section .data
    message1: .string "The numbers are equal.\n"
    message2: .string "The numbers aren't equal.\n"
    number_one: .int 0
    number_two: .int 0
    scan_str: .string "%d %d"
    infostr: .string "Insert two integer values: '(number1) (number2)':\n"

.section .text

.global _start
_start:
    pushl $infostr
    call printf
    addl $4, %esp

    pushl $number_two
    pushl $number_one
    pushl $scan_str
    call scanf

    movl number_one, %eax
    cmpl number_two, %eax
    je equal
    pushl $message2
    call printf
    addl $4, %esp
    jmp end

    equal: pushl $message1
    call printf
    addl $4, %esp
    jmp end

    end:pushl $0
    call exit
