.section .data
    tamreg:	.int 35
    abertura: .string "\nPrograma para Leitura de Registros\n\n"
    end_string: .string "\nFinalizando programa, todos os registros foram impressos...!\n"
    pedenome: .string "\nDigite o nome (%d): "
    mostranome:	.string "\nNome: %s"
    mostraprox:	.string	"\nEndereco do Proximo: %d\n\n"
    registersamounttxt: .string "\nInsira a quantidade de registros à ser coletada: "
    info_regs_str: .string "\nSerao lidos %d registros."
    lista: .int	0
    num_registers: .int 0
    num_registers_p1: .int 0
    integer_type: .string "%d"
    string_type: .string "%s"
    initial_list_end: .space 4

.text
.global _start

_start:
    call init_program
    call ler_registro
    call mostrar_registro

    push $0
    call exit

init_program:
    pushl $abertura
	call printf
    addl $4, %esp

    pushl $registersamounttxt
	call printf
    addl $4, %esp

    pushl $num_registers
    pushl $integer_type
    call scanf
    addl $8, %esp

    pushl num_registers
    pushl $info_regs_str
    call printf
    addl $8, %esp

    movl num_registers, %eax
    addl $1, %eax
    movl %eax, num_registers_p1

    ret

ler_registro:
    pushl tamreg
	call malloc
	movl %eax, lista
	addl $4, %esp

    movl lista, %eax
    movl %eax, initial_list_end
    register_collect_loop:
        movl num_registers_p1, %eax
        subl num_registers, %eax

        pushl %eax
        pushl $pedenome
	    call printf
	    addl $8, %esp

	    movl lista, %edi
	    pushl %edi
        pushl $string_type
	    call scanf
        addl $4, %esp
	    popl %edi
	    addl $31, %edi
	    
        decl num_registers

        movl $0, %eax
        cmpl num_registers, %eax
        jge end_collecting_registers
        jl add_next_register
        
    add_next_register:
        pushl tamreg
	    call malloc
	    movl %eax, lista
	    addl $4, %esp

        movl lista, %eax
        movl %eax, (%edi)
        jmp register_collect_loop

    end_collecting_registers:
        movl $999, (%edi)

    ret

mostrar_registro:
    movl initial_list_end, %eax
    movl %eax, lista

    show_registers_loop:
	    movl lista, %edi

	    pushl %edi
	    pushl $mostranome
	    call printf
	    addl $4, %esp
	
	    popl %edi
	    addl $31, %edi
	    pushl %edi

        movl (%edi), %eax

	    pushl %eax
	    pushl $mostraprox
	    call printf
	    addl $8, %esp

	    popl %edi
        movl $999, %eax
        cmpl (%edi), %eax
        je finish_print_registers
        movl (%edi), %eax
        movl %eax, lista
        jmp show_registers_loop
    
    finish_print_registers:
        pushl $end_string
        call printf
        addl $4, %esp

	ret
