.section .data
    # string variables
	skipLine: .asciz "\n"
    intFormat: .asciz "%d"
    showIntNumber: .asciz " %d"
    showSortedArr: .asciz "\nSorted Array:  "
    showOriginalArr: .asciz "Inserted Array:"
    collectNumberStr: .asciz "Insert the %d° element > "
    progTitle: .asciz "\n------------------------------\nSorting Array withBubble Sort\n------------------------------\n"
	
    # integer variables
	auxSize: .int 0
    arrSize: .int 16
	lastSwap: .int 0
    intNumber: .int 0
	currentIndex: .int 0

    # array allocated with 64 bytes (16 positions of 4 bytes each)
	operatedArray: .space 64
	
.section .text
.global _start

# ###########################################################
# auxiliary procedures
# ###########################################################
show_sorted_array:
	pushl $showSortedArr
	call printf

	addl $4, %esp
	movl arrSize, %ecx
	movl $operatedArray, %edi

    _show_number_sorted:
	    movl (%edi), %ebx
	    addl $4, %edi

	    pushl %edi
	    pushl %ecx

	    pushl %ebx
	    pushl $showIntNumber
	    call printf
	    addl $8, %esp

	    popl %ecx
	    popl %edi
	loop _show_number_sorted

	pushl $skipLine
	call printf
	addl $4, %esp

    ret

show_collected_array:
	pushl $showOriginalArr
	call printf
	addl $4, %esp

	movl arrSize, %ecx
	movl $operatedArray, %edi

    _show_number_initial:
	    movl (%edi), %ebx
	    addl $4, %edi

	    pushl %edi
	    pushl %ecx

	    pushl %ebx
	    pushl $showIntNumber
	    call printf
	    addl $8, %esp

	    popl %ecx
	    popl %edi
	loop _show_number_initial
    ret

start_program:
    movl arrSize, %ecx
    movl %ecx, auxSize
    movl $operatedArray,%edi
    movl $0, %ebx

    _collect_numbers:
	    incl %ebx

	    pushl %edi
	    pushl %ecx             # array size (pushed to backup the size)

	    pushl %ebx
	    pushl $collectNumberStr
	    call printf
        addl $4, %esp

	    pushl $intNumber
	    pushl $intFormat
	    call scanf
        addl $8, %esp

	    pushl $skipLine
	    call printf
	    addl $4, %esp

	    popl %ebx
	    popl %ecx              # array size (popped to be used in loop condition)

	    popl %edi
	    movl intNumber, %eax
	    movl %eax, (%edi)
	    addl $4, %edi
	loop _collect_numbers      # loop until ecx == 0
	ret

# ###########################################################
# bubble sort algorithm 
# ###########################################################
bubble_sort_array:
	movl $operatedArray, %edi  # %edi receives the address of the first array element
	movl %edi, %esi            # %esi receives the address of the first array element

	addl $4, %esi              # %esi receives the address of the second array element

	movl $1, lastSwap          # lastSwap maintains the index of the last swap made
	movl $1, currentIndex      # currentIndex maintains the index of the current element
	movl arrSize, %ecx         # %ecx receives the array size
	subl $1, %ecx              # %ecx will loop into arraySize-1, because it uses two index

    _inner_loop:
		pushl %ecx             # store %ecx value to backup in loop

	    movl (%edi), %eax      # %eax contains the value of the current element
	    movl (%esi), %ebx      # %ebx contains the value of the next element
	    cmpl %eax, %ebx
	    jl swap_values         # if %ebx < %eax, swap the values

        continue_execution:
	    addl $4, %edi          # go next element with current index
	    addl $4, %esi          # go next element with next index
	    incl currentIndex      # increment the current index

		popl %ecx              # get resting amount of numbers to be checked into array
	loop _inner_loop           # continue inner_loop until it reachs the end of the array

	movl lastSwap, %eax
	movl %eax, auxSize         # auxSize receives the index of the last swap made
	movl %eax, %ecx
	cmpl $1, %ecx
	jle finish_bubble_sort     # if auxSize <= 1, the array is sorted
	jmp bubble_sort_array      # else, sort the array again

swap_values:
	movl currentIndex, %edx
	movl %edx, lastSwap
	movl %eax, (%esi)          # put the greater value in the right neighbor
	movl %ebx, (%edi)          # put the smaller value in the current position
	jmp continue_execution

finish_bubble_sort:
    ret

# ###########################################################
# main program
# ###########################################################
_start:
	pushl $progTitle
	call printf
    addl $4, %esp

    call start_program
	call show_collected_array
	call bubble_sort_array
	call show_sorted_array

finish_program:
    pushl $0
	call exit

aoidgasdfaksy
aksfkasfdyaysk
akusdfkaf