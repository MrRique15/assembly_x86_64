.section .data
    # string variables
    comma: .string ", "
    scanVec: .string "%d"
    newLine: .string "\n"
    vetorElemF: .string "%d "
    vetorElemTxt: .string "%d"
    testTxt: .string "%d - %d"
    vetorTxt: .asciz "\nInserted Array: "
    vetorTxtFinal: .asciz "\nSorted Array  : "
    collectStr: .string "Insert the [%d] element: "
    allocString: .string "Insert the array length: "
    
    # integer variables
    esq: .int 0
    dir: .int 0
    vecTam: .int 8
    v1: .space 32
    v1Aux: .space 32
.section .text
.global _start

_start:
    pushl vecTam
    pushl $v1
    call insert
    addl $8, %esp

    pushl $vetorTxt
    call printf
    addl $4, %esp

    pushl vecTam
    pushl $v1
    call printVec
    addl $8, %esp

    pushl $v1Aux
    pushl vecTam
    pushl $0
    pushl $v1
    call merge_sort
    addl $16, %esp

    pushl $vetorTxtFinal
    call printf
    addl $4, %esp

    pushl vecTam
    pushl $v1
    call printVec
    addl $8, %esp
    
    pushl $newLine
    call printf
    addl $4, %esp

    pushl $0
    call exit

insert:
    pushl %ebp
    movl %esp, %ebp
    xor %ebx, %ebx

    insertLoop:
        cmpl %ebx, 12(%ebp)
        je exitInsertLoop
        
        pushl %ebx
        pushl $collectStr
        call printf
        addl $8, %esp

        movl %ebx, %ecx
        imul $4, %ecx
        movl 8(%ebp), %eax
        addl %ecx, %eax

        pushl %eax
        pushl $scanVec
        call scanf
        addl $8, %esp

        incl %ebx
        jmp insertLoop

    exitInsertLoop:
    movl %ebp, %esp
    popl %ebp
    ret

printVec:
    pushl %ebp
    movl %esp, %ebp
    xor %ebx, %ebx

    printVecLoop:
        movl 12(%ebp), %eax
        decl %eax
        cmpl %ebx, %eax
        je exitPrintVecLoop

        movl %ebx, %ecx
        imul $4, %ecx
        movl 8(%ebp), %eax
        addl %ecx, %eax

        pushl (%eax)
        pushl $vetorElemTxt
        call printf
        addl $8, %esp

        pushl $comma
        call printf
        addl $4, %esp

        incl %ebx
        jmp printVecLoop

    exitPrintVecLoop:
    movl %ebx, %ecx
    imul $4, %ecx
    movl 8(%ebp), %eax
    addl %ecx, %eax

    pushl (%eax)
    pushl $vetorElemTxt
    call printf
    addl $8, %esp

    movl %ebp, %esp
    popl %ebp
    ret

merge:
    pushl %ebp
    movl %esp, %ebp
    movl 12(%ebp), %ebx
    movl 16(%ebp), %eax
    movl %ebx, esq
    movl %eax, dir
    jmp _merge_sort_loop

    _merge_sort_loop:
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
        call _leftVect
        addl $24, %esp

        cmpl $1, %eax
        je _leftVec

        movl %ebx, %ecx
        imul $4, %ecx
        movl 24(%ebp), %eax #v1aux
        addl %ecx, %eax
        movl %edx, (%eax)
        incl dir
        incl %ebx
        jmp _merge_sort_loop

    _leftVec:
        movl %ebx, %edx
        imul $4, %edx
        movl 24(%ebp), %eax #v1aux
        addl %edx, %eax
        movl %ecx, (%eax)
        incl esq
        incl %ebx
        jmp _merge_sort_loop
        
    exitmergeLoop:
    pushl $v1Aux
    pushl $v1
    pushl 20(%ebp)
    pushl 12(%ebp)
    call _arrayCopy
    addl $16, %esp

    movl %ebp, %esp
    popl %ebp
    ret

_arrayCopy:
    pushl %ebp
    movl %esp, %ebp
    movl 8(%ebp), %ebx

    _arrayCopyLoop:
        cmpl 12(%ebp), %ebx
        je _finishCopyingArray

        movl %ebx, %eax
        imul $4, %eax
        movl 20(%ebp), %ecx # v1Aux
        movl 16(%ebp), %edx # v1
        addl %eax, %ecx
        addl %eax, %edx
        movl (%ecx), %ecx
        movl %ecx, (%edx)
        incl %ebx
        jmp _arrayCopyLoop

    _finishCopyingArray:
    movl %ebp, %esp
    popl %ebp
    ret

_leftVect:
    pushl %ebp
    movl %esp, %ebp
    movl 24(%ebp), %eax
    cmpl 28(%ebp), %eax
    jl vet_esq_smaller_than_vet_dir

    movl 16(%ebp), %eax
    cmpl 20(%ebp), %eax
    jl falseFlag

    vet_esq_smaller_than_vet_dir:
    movl 8(%ebp), %eax
    cmpl 12(%ebp), %eax
    jge falseFlag

    movl $1, %eax
    jmp finishLeftVec

    falseFlag:
    movl $0, %eax

    finishLeftVec:
    movl %ebp, %esp
    popl %ebp
    ret

merge_sort:
    pushl %ebp
    movl %esp, %ebp
    subl $20, %esp
    movl 16(%ebp), %eax # tamanho
    movl 12(%ebp), %ebx # inicio
    subl %ebx, %eax
    cmpl $2, %eax
    jl finishSorting

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
    call merge_sort
    addl $16, %esp

    subl $16, %esp
    pushl $v1Aux
    pushl 16(%ebp)
    pushl -12(%ebp)
    pushl 8(%ebp)
    call merge_sort
    addl $16, %esp

    pushl $v1Aux
    pushl 16(%ebp)
    pushl -12(%ebp)
    pushl 12(%ebp)
    pushl 8(%ebp)
    call merge
    addl $20, %esp

    finishSorting:
    movl %ebp, %esp
    popl %ebp
    ret
