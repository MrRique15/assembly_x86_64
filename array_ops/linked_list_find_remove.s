.section .data
    tamreg:	.int 35
    abertura: .string "\nPrograma para Leitura de Registros\n\n"
    end_string: .string "\nFinalizando programa, todos os registros foram impressos...!\n"
    pedenome: .string "\nDigite o nome (%d): "
    mostranome:	.string "\nNome: %s"
    mostraprox:	.string	"\nEndereco do Proximo: %d\n\n"
    registersamounttxt: .string "\nInsira a quantidade de registros à ser coletada: "
    info_regs_str: .string "\nSerao lidos %d registros."
    pulaLinha: .string "\n"
    lista: .int	0
    num_registers: .int 0
    num_registers_p1: .int 0
    integer_type: .string "%d"
    string_type: .string "%s"
    initial_list_end: .space 4
    registroNaoEncontrado: .string "\nRegistro nao encontrado!\n"
    insertRegisterToSearch: .string "\nDigite o nome do registro que deseja buscar: "
    insertRegisterToRemove: .string "\nDigite o nome do registro que deseja remover: "
    registroEncontrado: .string "\nRegistro encontrado -> "
    nomeBuscado: .space 31
    optionsMenu: .string "\n\n[1] - Buscar registro\n[2] - Remover Registro\n[3] - Finalizar Programa\n\nDigite a opcao desejada: "
    option: .int 0

    lastAddress: .int 0
    nextAddress: .int 0
.text
.global _start

_start:
    call init_program
    call ler_registro

    loop_search:
        pushl $optionsMenu
        call printf
        addl $4, %esp

        pushl $option
        pushl $integer_type
        call scanf
        addl $8, %esp

        movl option, %eax

        cmpl $1, %eax
        je find_register_option
        cmpl $2, %eax
        je remove_register_option
        cmpl $3, %eax
        je exit_program

        back_to_loop:
        jmp loop_search
    exit_program:
    call mostrar_registro

    push $0
    call exit

find_register_option:
    call find_register
    jmp back_to_loop

remove_register_option:
    call remove_register
    jmp back_to_loop

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

find_register:
    pushl $insertRegisterToSearch
    call printf
    addl $4, %esp

    pushl $nomeBuscado
    pushl $string_type
    call scanf
    addl $8, %esp

    movl initial_list_end, %eax
    movl %eax, lista

    find_register_loop:
        movl lista, %edi
        pushl %edi

        movl $nomeBuscado, %esi
        movl $31, %ecx
        cld
        repe cmpsb
        popl %edi
        jecxz register_found


        addl $31, %edi
        movl (%edi), %eax
        movl %eax, lista

        cmpl $999, %eax
        jne find_register_loop
        jmp register_not_found

    register_found:
        pushl $registroEncontrado
        call printf
        addl $4, %esp

        pushl %edi
        pushl $string_type
        call printf
        addl $8, %esp

        pushl $pulaLinha
        call printf
        addl $4, %esp

        ret

    register_not_found:
        pushl $registroNaoEncontrado
        call printf
        addl $4, %esp

        ret

remove_register:
    pushl $insertRegisterToRemove
    call printf
    addl $4, %esp

    pushl $nomeBuscado
    pushl $string_type
    call scanf
    addl $8, %esp

    movl initial_list_end, %eax
    movl %eax, lista

    remove_register_loop:
        movl lista, %edi
        pushl %edi

        movl $nomeBuscado, %esi
        movl $31, %ecx
        cld
        repe cmpsb
        popl %edi
        jecxz register_found_remove

        movl %edi, lastAddress
        addl $31, %edi
        movl (%edi), %eax
        movl %eax, lista

        cmpl $999, %eax
        jne remove_register_loop
        jmp register_not_found_remove

    register_found_remove:
        pushl $registroEncontrado
        call printf
        addl $4, %esp

        pushl %edi
        pushl $string_type
        call printf
        addl $8, %esp

        pushl $pulaLinha
        call printf
        addl $4, %esp
        
        cmpl initial_list_end, %edi
        je remove_first_register

        addl $31, %edi
        movl (%edi), %eax
        cmpl $999, %eax
        movl %eax, nextAddress
        je remove_last_register
        
        movl lastAddress, %edi
        addl $31, %edi
        movl nextAddress, %eax
        movl %eax, (%edi)

        ret
    remove_first_register:
        addl $31, %edi
        movl (%edi), %eax
        movl %eax, initial_list_end

        ret
    
    remove_last_register:
        movl lastAddress, %edi
        addl $31, %edi
        movl $999, %eax
        movl %eax, (%edi)

        ret
    register_not_found_remove:
        pushl $registroNaoEncontrado
        call printf
        addl $4, %esp

        ret
