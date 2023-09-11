.section .data
	usedArray: .int 5,8,6,3,4,2,1,9
	arrSize: .int 8
	middleValue: .int 0
	rightValue: .int 0
	leftValue: .int 0

	n1: .int 0
	n2: .int 0
	j: .int 0
	i: .int 0

	auxArr1: .space 4
	auxArr2: .space 4

	auxArrGlobal: .space 8
	auxValue1: .int 0
	auxValue2: .int 0
	auxValue3: .int 0

	showSortedArr: .asciz "Sorted Array:   "
	showOriginalArr: .asciz "Original Array: "
	intFormat: .asciz "%d "
	newLine: .asciz "\n"

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

show_sorted_array:
	pushl $showSortedArr
	call printf
	addl $4, %esp

	movl arrSize, %ecx
	movl $usedArray, %edi

    _show_number_sorted:
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
	loop _show_number_sorted

	pushl $newLine
	call printf
	addl $4, %esp

    ret

merge:
	pushl %ebp
	movl %esp, %ebp

	movl 8(%ebp), %ebx # rightValue
	movl 12(%ebp), %ecx # middleValue
	movl 16(%ebp), %edx # leftValue
	movl 20(%ebp), %edi # usedArray

	movl $0, i
	movl $0, j
	movl $0, n1
	movl $0, n2

	pushl %ebx
	pushl %ecx
	pushl %edx
	pushl %edi

	# n1 = middleValue - leftValue + 1
	movl %ecx, %eax
	subl %edx, %eax
	addl $1, %eax
	movl %eax, %ecx

	movl %ecx, n1

	movl $auxArr1, %esi

	movl %edx, %eax
	imul $4, %eax
	addl %eax, %edi

	incl %ecx
	cmpl $0, %ecx
	je ignore_copy_arr1
	_copy_arr1_loop:
		movl (%edi), %eax
		movl %eax, (%esi)
		addl $4, %esi
		addl $4, %edi
	loop _copy_arr1_loop

	ignore_copy_arr1:
	popl %edi
	popl %edx
	popl %ecx
	popl %ebx

	pushl %ebx
	pushl %ecx
	pushl %edx
	pushl %edi

	movl $auxArr2, %esi
	addl %ecx, %eax
	imul $4, %eax
	addl %eax, %edi

	# n2 = rightValue - middleValue
	movl %ebx, %eax
	subl %ecx, %eax
	movl %eax, %ecx

	movl %ecx, n2

	incl %ecx
	cmpl $0, %ecx
	je ignore_copy_arr2
	_copy_arr2_loop:
		movl (%edi), %eax
		movl %eax, (%esi)
		addl $4, %esi
		addl $4, %edi
	loop _copy_arr2_loop

	ignore_copy_arr2:
	popl %edi
	popl %edx
	popl %ecx
	popl %ebx

	movl $auxArr1, %esi
	movl $auxArr2, %ebp

	movl %edx, %eax
	imul $4, %eax
	addl %eax, %edi
	_first_while_loop:
		_first_while_condition:
			movl n1, %eax
			cmpl %eax, i
			jge _second_while_loop
			_verify_second:
				movl n2, %eax
				cmpl %eax, j
				jge _second_while_loop
				
		movl (%esi), %eax
		movl (%ebp), %ebx
		cmpl %eax, %ebx
		jge _first_else
		_first_if:
			movl %eax, (%edi)
			addl $4, %edi
			addl $4, %esi
			incl i
		_first_else:
			movl %ebx, (%edi)
			addl $4, %edi
			addl $4, %ebp
			incl j
		# _first_while_condition:
		# 	movl n1, %eax
		# 	cmpl %eax, i
		# 	jge _second_while_loop
		# 	_verify_second:
		# 		movl n2, %eax
		# 		cmpl %eax, j
		# 		jge _second_while_loop

	_second_while_loop:
		movl n1, %eax
		cmpl %eax, i
		jge _third_while_loop
		movl (%esi), %eax
		movl %eax, (%edi)
		addl $4, %edi
		addl $4, %esi
		incl i
		jmp _second_while_loop

	_third_while_loop:
		movl n2, %eax
		cmpl %eax, j
		jge _end_merge
		movl (%ebp), %eax
		movl %eax, (%edi)
		addl $4, %edi
		addl $4, %ebp
		incl j
		jmp _third_while_loop

	_end_merge:
		popl %ebp
		popl %ebx
		popl %eax
		popl %edx
		popl %edi
		ret

merge_sort_two:
	pushl %ebp
	movl %esp, %ebp

	movl 8(%ebp), %ebx # rightValue
	movl 12(%ebp), %edx # leftValue
	movl 16(%ebp), %edi # usedArray

	cmpl %ebx, %edx
	jge _end_merge_sort_two

	movl %ebx, %ecx
	subl $1, %ecx
	addl %edx, %ecx
	movl %ecx, %eax
	sarl $1, %eax 

	pushl %edi
	pushl %edx
	pushl %eax
	call merge_sort_one

	addl $1, %eax
	pushl %edi
	pushl %eax
	pushl %ebx
	call merge_sort_two

	pushl %edi
	pushl %edx
	pushl %eax
	pushl %ebx
	call merge

	_end_merge_sort_two:
		popl %ebp
		popl %ebx
		popl %eax
		popl %edi
		ret

merge_sort_one:
	pushl %ebp
	movl %esp, %ebp

	movl 8(%ebp), %ebx # rightValue
	movl 12(%ebp), %edx # leftValue
	movl 16(%ebp), %edi # usedArray

	cmpl %ebx, %edx
	jge _end_merge_sort_one

	movl %ebx, %ecx
	subl $1, %ecx
	addl %edx, %ecx
	movl %ecx, %eax
	sarl $1, %eax 

	pushl %edi
	pushl %edx
	pushl %eax
	call merge_sort_one

	addl $1, %eax
	pushl %edi
	pushl %eax
	pushl %ebx
	call merge_sort_two

	pushl %edi
	pushl %edx
	pushl %eax
	pushl %ebx
	call merge

	_end_merge_sort_one:
		popl %ebp
		popl %eax
		popl %edx
		popl %edi
		ret

merge_sort:
	pushl %ebp
	movl %esp, %ebp

	movl 8(%ebp), %ebx # rightValue
	movl 12(%ebp), %edx # leftValue
	movl 16(%ebp), %edi # usedArray

	cmpl %ebx, %edx
	jge _end_merge_sort

	movl %ebx, %ecx
	subl $1, %ecx
	addl %edx, %ecx
	movl %ecx, %eax
	sarl $1, %eax 

	pushl %edi
	pushl %edx
	pushl %eax
	call merge_sort_one

	addl $1, %eax
	pushl %edi
	pushl %eax
	pushl %ebx
	call merge_sort_two

	pushl %edi
	pushl %edx
	pushl %eax
	pushl %ebx
	call merge

	_end_merge_sort:
		popl %ebp

		popl %ebx
		popl %eax
		popl %edx
		ret

exit_program:
	pushl $0
	call exit

_start:
	call show_collected_array

	# prepare initial rightValue
	movl arrSize, %eax
	subl $1, %eax
    
	movl $usedArray, %edi
	pushl %edi  # push array
	pushl $0   # push leftValue
	pushl %eax  # push rightValue
	call merge_sort

	call show_sorted_array

	jmp exit_program
