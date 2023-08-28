.section .data
	break_line: .asciz "\n"
    close_bracket: .asciz " ]\n"
    number_print: .asciz " %d,"
    collect_int_str: .asciz "%d"
    sorted_numbers: .asciz "Sorted values: ["
    numbers_collected: .asciz "Inserted values: ["
    collect_num_info: .asciz "Insert the element %d => "
    get_tam: .asciz "Insert the vector length (max=20) => "
    title: .asciz "\n*** Vector Sorting with Selection Sort ***\n\n"

	maxtam:  .int 30
	tam: .int 0
	num: .int 0
	array: .int 4
.section .text

.global _start
# ###########################################################
# utility functions to operate insertions and allocation
# ###########################################################
getLength:
	pushl $get_tam
	call printf
    addl $4, %esp

	pushl $tam
	pushl $collect_int_str
	call scanf
    addl $8, %esp

	pushl $break_line
	call printf
	addl $4, %esp

	movl tam, %ecx
	cmpl $0, %ecx
	jle getLength

	cmpl maxtam, %ecx
	jg getLength

	ret

alocateArray:
	movl tam, %eax
	movl $4, %ebx
	mull %ebx

	pushl %eax
	call malloc
    addl $4, %esp

	movl %eax, array
	ret

collectArray:
	movl 	$0, %ebx
	movl 	tam, %ecx
	movl	array, %edi

    _insertLoop:
    	incl %ebx

    	pushl %edi
    	pushl %ecx
    	pushl %ebx
    	pushl $collect_num_info
    	call printf
        addl $8, %esp

    	pushl $num
    	pushl $collect_int_str
    	call scanf
        addl $8, %esp

    	pushl 	$break_line
    	call 	printf
        addl $4, %esp

    	popl %ecx
    	popl %edi
    	movl num, %eax
    	movl %eax, (%edi)
    	addl $4, %edi
    loop _insertLoop
    ret

showArray:
	movl 	tam, %ecx
	movl 	array, %edi

    _showElementLoop:
    	movl (%edi), %ebx
    	addl $4, %edi

    	pushl %edi
    	pushl %ecx
    	pushl %ebx
    	pushl $number_print
    	call printf
    	addl $8, %esp

    	popl %ecx
    	popl %edi
    loop _showElementLoop

    pushl $close_bracket
    call printf
    addl $4, %esp

    ret
# ###########################################################
# main program
# ###########################################################
_start:
	pushl $title
	call printf
    addl $4, %esp

	call getLength
	call alocateArray
	call collectArray

	pushl $numbers_collected
	call printf
	addl $4, %esp
	call showArray

	call selectionSort

	pushl $sorted_numbers
	call printf
	addl $4, %esp
	call showArray

	jmp	exit_program
# ###########################################################
# selection sort function
# ###########################################################
selectionSort:
	movl tam, %ecx
	cmpl $1, %ecx
	jle _cancelSorting   

	movl array, %edx
	decl %ecx       

    _outerLoop:
    	movl %edx, %edi	
    	movl %edi, %esi

    	addl $4, %esi        

    	pushl %ecx         

        _innerLoop:
	        movl (%edi), %eax   
	        movl (%esi), %ebx   

	        cmpl %eax, %ebx	
	        jl 	_changeSmallestPosition	

            _nextIteration:
	        addl $4, %esi

	    loop _innerLoop

        _exchangeElements:
        	movl (%edx), %ebx
        	movl (%edi), %eax
        	movl %eax, (%edx)
        	movl %ebx, (%edi)

        	addl $4, %edx 

        	popl %ecx
    loop _outerLoop

    ret

_changeSmallestPosition:
	movl %esi, %edi
	jmp _nextIteration

_cancelSorting:
	ret

exit_program:
	pushl $0
	call exit
