.section .data
    
    # string variables
	skipLine: .asciz "\n"
    intFormat: .asciz "%d"
    showIntNumber: .asciz " %d"
    clearScreenStr: .string "\033[H\033[J"
    showSortedArr: .asciz "\nSorted Array:  "
    showOriginalArr: .asciz "Inserted Array:"
    collectNumberStr: .asciz "Insert the %d° element > "
    get_tam: .asciz "Insert the vector length (max=20) => "
    wrongOption: .string "Wrong Option! Select a valid one!\n\n"
    progTitle: .string "----------Sorting Program [Bubble and Merge Sorting]----------\n"
    anyArrayInserted: .asciz "Any array was inserted! Insert before showing or sorting!\n\n"
    arrayNotAlocated: .asciz "Array not alocated! Define the length before inserting elements!\n\n"
    optionsMenu: .string "\n\n\t\tSelect an Option:\n[1]Define Array Size\n[2]Insert Array Elements\n[3]Show Array\n[4]MergeSort\n[5]BubbleSort\n[6]Reset Values\n[7]Exit\n\nOption: "
    

    # integer variables
    esq: .int 0
    dir: .int 0
    choice: .int 0
	auxSize: .int 0
    arrSize: .int 0
    maxSize: .int 20
	lastSwap: .int 0
    intNumber: .int 0
	currentIndex: .int 0

    # array allocated with 64 bytes (16 positions of 4 bytes each)
	operatedArray: .int 4
    v1Aux: .int 0, 0, 0, 0, 0, 0, 0, 0
	
.section .text
.global _start

# ###########################################################
# auxiliary procedures
# ###########################################################
optionsMenuSelection:
    pushl %ebp
    movl %esp, %ebp

    pushl $optionsMenu
    call printf
    addl $4, %esp

    pushl $choice
    pushl $intFormat
    call scanf
    addl $8, %esp

    pushl $skipLine
    call printf
    addl $4, %esp

    movl %ebp, %esp
    popl %ebp
    ret

getLength:
    pushl %ebp
    movl %esp, %ebp

	pushl $get_tam
	call printf
    addl $4, %esp

	pushl $arrSize
	pushl $intFormat
	call scanf
    addl $8, %esp

	pushl $skipLine
	call printf
	addl $4, %esp

	movl arrSize, %ecx
	cmpl $0, %ecx
	jle getLength

	cmpl maxSize, %ecx
	jg getLength

    movl %ebp, %esp
    popl %ebp
	ret

alocateArray:
    pushl %ebp
    movl %esp, %ebp

	movl arrSize, %eax
	movl $4, %ebx
	mull %ebx

	pushl %eax
	call malloc
    addl $4, %esp

	movl %eax, operatedArray
    movl %eax, v1Aux

    movl arrSize, %ecx
    movl $operatedArray, %edi
    _fill_with_zeros:
        movl $0, (%edi)
        addl $4, %edi
    loop _fill_with_zeros

    movl arrSize, %ecx
    movl $v1Aux, %edi
    _fill_with_zeros_aux:
        movl $0, (%edi)
        addl $4, %edi
    loop _fill_with_zeros_aux

    movl %ebp, %esp
    popl %ebp
	ret

show_sorted_array:
    pushl %ebp
    movl %esp, %ebp

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

    movl %ebp, %esp
    popl %ebp
    ret

show_collected_array:
    pushl %ebp
    movl %esp, %ebp

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
    
    pushl $skipLine
    call printf
    addl $4, %esp

    movl %ebp, %esp
    popl %ebp
    ret

start_program:
    pushl %ebp
    movl %esp, %ebp

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
    
    movl %ebp, %esp
    popl %ebp
    ret
# ###########################################################
# merge sort algorithm 
# ###########################################################
merge:
    pushl %ebp
    movl %esp, %ebp
    movl 12(%ebp), %ebx
    movl 16(%ebp), %eax
    movl %ebx, esq
    movl %eax, dir
    jmp .mergeLoop

.mergeLoop:
    cmpl 20(%ebp), %ebx
    jge exitmergeLoop

    movl esq, %ecx
    imul $4, %ecx
    movl 8(%ebp), %eax
    addl %ecx, %eax
    movl (%eax), %ecx # vetor[esq]

    movl dir, %edx
    imul $4, %edx
    movl 8(%ebp), %eax
    addl %edx, %eax
    movl (%eax), %edx # vetor[dir]

    pushl %edx
    pushl %ecx
    pushl 20(%ebp)
    pushl dir
    pushl 16(%ebp)
    pushl esq
    call .isLeftVec
    addl $24, %esp

    cmpl $1, %eax
    je .leftVec

    movl %ebx, %ecx
    imul $4, %ecx
    movl 24(%ebp), %eax #v1aux
    addl %ecx, %eax
    movl %edx, (%eax)
    incl dir
    incl %ebx
    jmp .mergeLoop


exitmergeLoop:
    pushl $v1Aux
    pushl $operatedArray
    pushl 20(%ebp)
    pushl 12(%ebp)
    call .copyVec
    addl $16, %esp

    movl %ebp, %esp
    popl %ebp
    ret

.leftVec:
    movl %ebx, %edx
    imul $4, %edx
    movl 24(%ebp), %eax #v1aux
    addl %edx, %eax
    movl %ecx, (%eax)
    incl esq
    incl %ebx
    jmp .mergeLoop

.copyVec:
    pushl %ebp
    movl %esp, %ebp
    movl 8(%ebp), %ebx
    jmp .copyVecLoop

.copyVecLoop:
    cmpl 12(%ebp), %ebx
    je .exitCopyVecLoop
    
    movl %ebx, %eax
    imul $4, %eax
    movl 20(%ebp), %ecx # v1Aux
    movl 16(%ebp), %edx # v1
    addl %eax, %ecx
    addl %eax, %edx
    movl (%ecx), %ecx
    movl %ecx, (%edx)
    incl %ebx
    jmp .copyVecLoop

.exitCopyVecLoop:
    movl %ebp, %esp
    popl %ebp
    ret
.isLeftVec:
    pushl %ebp
    movl %esp, %ebp
    movl 24(%ebp), %eax
    cmpl 28(%ebp), %eax
    jl vet_esq_smaller_than_vet_dir

    movl 16(%ebp), %eax
    cmpl 20(%ebp), %eax
    jl exitIsLeftVecFalse

    vet_esq_smaller_than_vet_dir:
    movl 8(%ebp), %eax
    cmpl 12(%ebp), %eax
    jge exitIsLeftVecFalse

    jmp exitIsLeftVecTrue

exitIsLeftVecTrue:
    movl $1, %eax
    movl %ebp, %esp
    popl %ebp
    ret

exitIsLeftVecFalse:
    movl $0, %eax
    movl %ebp, %esp
    popl %ebp
    ret

mergeSort:
    pushl %ebp
    movl %esp, %ebp
    subl $20, %esp
    movl 16(%ebp), %eax # tamanho
    movl 12(%ebp), %ebx # inicio
    subl %ebx, %eax
    cmpl $2, %eax
    jl exitMerge

    movl 16(%ebp), %eax
    movl 12(%ebp), %ebx
    addl %ebx, %eax
    movl $2, %ebx
    xor %edx, %edx
    divl %ebx
    movl %eax, -12(%ebp)
    subl $16, %esp

    pushl $v1Aux
    pushl -12(%ebp)
    pushl 12(%ebp)
    pushl 8(%ebp)
    call mergeSort
    addl $16, %esp

    subl $16, %esp
    pushl $v1Aux
    pushl 16(%ebp)
    pushl -12(%ebp)
    pushl 8(%ebp)
    call mergeSort
    addl $16, %esp

    pushl $v1Aux
    pushl 16(%ebp)
    pushl -12(%ebp)
    pushl 12(%ebp)
    pushl 8(%ebp)
    call merge
    addl $20, %esp
    
    movl %ebp, %esp
    popl %ebp
    ret

exitMerge:
    movl %ebp, %esp
    popl %ebp
    ret
# ###########################################################
# bubble sort algorithm 
# ###########################################################
bubble_sort_array:
    pushl %ebp
    movl %esp, %ebp

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
    movl %ebp, %esp
    popl %ebp
    ret

# ###########################################################
# main program
# ###########################################################
_start:
	pushl $progTitle
	call printf
    addl $4, %esp

    back_from_choice:
    call optionsMenuSelection

    call clearScreenFunction
    movl choice, %eax

    cmpl $1, %eax
    je getLenghtOption
    cmpl $2, %eax
    je insertElementsOption
    cmpl $3, %eax
    je showInsertedArrayOption
    cmpl $4, %eax
    je mergeSortOption
    cmpl $5, %eax
    je bubbleSortOption
    cmpl $6, %eax
    je resetValuesOption
    cmpl $7, %eax
    je finish_program

    pushl $wrongOption
    call printf
    addl $4, %esp
    jmp back_from_choice

getLenghtOption:
    call getLength
    call alocateArray
    jmp back_from_choice

insertElementsOption:
    movl arrSize, %eax
    cmpl $0, %eax
    je notAlocatedArrayError

    call start_program
    jmp back_from_choice

showInsertedArrayOption:
    movl arrSize, %eax
    cmpl $0, %eax
    je anyArrayInsertedError

    call show_collected_array
    jmp back_from_choice

mergeSortOption:
    movl arrSize, %eax
    cmpl $0, %eax
    je anyArrayInsertedError

    movl $0, %eax
    movl $0, %ebx
    movl $0, %ecx
    movl $0, %edx
    
    pushl $v1Aux         # auxiliar array
    pushl arrSize        # array size
    pushl $0             # mid value
    pushl $operatedArray # operated array to be sorted
    call mergeSort
    addl $16, %esp

    call show_sorted_array
    jmp back_from_choice

bubbleSortOption:
    movl arrSize, %eax
    cmpl $0, %eax
    je anyArrayInsertedError

    call bubble_sort_array
    call show_sorted_array
    jmp back_from_choice

resetValuesOption:
    movl $0, arrSize
    movl $0, auxSize
    movl $0, lastSwap
    movl $0, intNumber
    movl $0, currentIndex
    movl $0, choice
    movl $0, operatedArray

    movl $4, %eax
    call malloc
    addl $4, %esp
    movl %eax, operatedArray

    jmp back_from_choice

notAlocatedArrayError:
    pushl $arrayNotAlocated
    call printf
    addl $4, %esp
    jmp back_from_choice

anyArrayInsertedError:
    pushl $anyArrayInserted
    call printf
    addl $4, %esp
    jmp back_from_choice

clearScreenFunction:
    pushl %ebp
    movl %esp, %ebp

    pushl $clearScreenStr
    call printf
    addl $4, %esp

    movl %ebp, %esp
    popl %ebp
    ret

finish_program:
    pushl $0
	call exit
