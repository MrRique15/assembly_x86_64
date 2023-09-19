.section .data
	usedArray: .int 9, 8, 6, 7, 4, 5, 3, 2, 1, 0
	arrSize: .int 10

	# merge_sort function variables
	curr_size: .int 0
	left_start: .int 0
	mid: .int 0
	rightEnd: .int 0
	aux1: .int 0
	aux2: .int 0

	# merge function variables
	esq: .int 0
	dir: .int 0

	auxArr1: .int 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

	showSortedArr: .asciz "Sorted Array:   "
	showOriginalArr: .asciz "Original Array: "
	intFormat: .asciz "%d "
	newLine: .asciz "\n"
	debugStr: .asciz "Ocurred operation\n"

	left_start_print: .string "Left_Start: %d\n"
	curr_size_print: .string "Curr_Size: %d\n"

.section .text
.global _start

show_collected_array:
	pushl $showOriginalArr
	call printf
	addl $4, %esp

	movl arrSize, %ecx
	movl $usedArray, %edi

    _show_number_initial:
	    movl (%edi), %ebx
	    addl $4, %edi

	    pushl %edi
	    pushl %ecx

	    pushl %ebx
	    pushl $intFormat
	    call printf
	    addl $8, %esp

	    popl %ecx
	    popl %edi
	loop _show_number_initial

	pushl $newLine
	call printf
	addl $4, %esp

    ret

# show_sorted_array:
# 	pushl %ebp
# 	movl %esp, %ebp
# 
# 	movl 8(%ebp), %edi # usedArray
# 
# 	pushl $showSortedArr
# 	call printf
# 	addl $4, %esp
# 
# 	movl arrSize, %ecx
# 	# movl $usedArray, %edi
# 
#     _show_number_sorted:
# 	    movl (%edi), %ebx
# 	    addl $4, %edi
# 
# 	    pushl %edi
# 	    pushl %ecx
# 
# 	    pushl %ebx
# 	    pushl $intFormat
# 	    call printf
# 	    addl $8, %esp
# 
# 	    popl %ecx
# 	    popl %edi
# 	loop _show_number_sorted
# 
# 	pushl $newLine
# 	call printf
# 	addl $4, %esp
# 
# 	popl %ebp
#     ret

merge_sort:
	movl $usedArray, %edi
	movl $1, curr_size    # curr_size = 1
	movl $0, left_start   # left_start = 0
	_external_loop:
		movl arrSize, %eax
		subl $1, %eax
		cmpl %eax, curr_size
		jg _end_merge_sort    # curr_size > arrSize - 1

		movl $0, left_start   # left_start=0
		_internal_loop:
			movl arrSize, %eax
			subl $1, %eax
			cmpl %eax, left_start
			jge _end_internal_loop # left_start >= arrSize - 1

			movl curr_size, %eax
			subl $1, %eax
			addl left_start, %eax
			movl %eax, aux1       # aux1 = left_start + curr_size - 1

			movl arrSize, %eax
			subl $1, %eax         # eax = arrSize - 1

			cmpl %eax, aux1
			jl aux1_is_smaller
			movl %eax, mid
			jmp _continue_exec_1

			aux1_is_smaller:
			movl aux1, %eax
			movl %eax, mid
			
			# mid = min(left_start + curr_size - 1, arrSize - 1)
			_continue_exec_1:
			movl curr_size, %eax
			imull $2, %eax
			subl $1, %eax
			addl left_start, %eax
			movl %eax, aux2       # aux2 = left_start + 2*curr_size - 1

			movl arrSize, %eax
			subl $1, %eax         # eax = arrSize - 1

			cmpl %eax, aux2
			jl aux2_is_smaller
			movl %eax, rightEnd
			jmp _continue_exec_2

			aux2_is_smaller:
			movl aux2, %eax
			movl %eax, rightEnd

			_continue_exec_2:

			pushl %edi
			
			# adicionar função MERGE aqui

			popl %edi

			movl curr_size, %eax
			imull $2, %eax
			addl left_start, %eax
			movl %eax, left_start
		jmp _internal_loop

		_end_internal_loop:
			movl curr_size, %eax
			imull $2, %eax
			movl %eax, curr_size
	jmp _external_loop

	_end_merge_sort:
    	jmp return_to_main

exit_program:
	pushl $0
	call exit

_start:
	call show_collected_array

	jmp merge_sort

	return_to_main:
	call show_collected_array

	jmp exit_program
