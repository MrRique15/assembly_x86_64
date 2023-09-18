.section .data
    esq: .int 0
    dir: .int 0
    vetorTxt: .asciz "\nvetor: "
    vetorElemTxt: .string "%d"
    vetorElemF: .string "%d "
    newLine: .string "\n"
    comma: .string ", "
    scanVec: .string "%d"
    conti: .int 0
    testTxt: .string "%d - %d"
    contj: .int 0
    v1: .int 0, 8, 3, 6, 2, 4, 7, 5, 1, 9
    v1Aux: .int 0, 0, 0, 0, 0, 0, 0, 0
    vecTam: .int 8
    meio: .long 0

.section .text
.global _start

_start:
    # pushl $10
    # pushl $v1
    # call insert
    # addl $8, %esp

    pushl $vetorTxt
    call printf
    addl $4, %esp

    pushl $10
    pushl $v1
    call printVec
    addl $8, %esp

    pushl $v1Aux # vetAux
    pushl $10 # tamanho
    pushl $0 # meio
    pushl $v1 # vet
    call mergeSort
    addl $16, %esp

    pushl $vetorTxt
    call printf
    addl $4, %esp

    pushl $10
    pushl $v1
    call printVec
    addl $8, %esp
    
    pushl $0
    call exit

# tam   12
# vetor 8
insert:
    pushl %ebp
    movl %esp, %ebp
    xor %ebx, %ebx
    jmp insertLoop

insertLoop:
    cmpl %ebx, 12(%ebp)
    je exitInsertLoop

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
# tamanho 12
# v1      8
# ebx = contador
printVec:
    pushl %ebp
    movl %esp, %ebp
    xor %ebx, %ebx
    jmp printVecLoop

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
#pushl $v1Aux           24
#pushl $8 # fim         20
#pushl $0 # meio        16
#pushl $0 # ini         12
#pushl $v1              8
merge:
    pushl %ebp
    movl %esp, %ebp
    movl 12(%ebp), %ebx
    movl 16(%ebp), %eax
    movl %ebx, esq
    movl %eax, dir
    jmp .mergeLoop

#pushl $v1Aux           24
#pushl $8 # fim         20
#pushl $0 # meio        16
#pushl $0 # ini         12
#pushl $v1              8
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
    pushl $v1
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

# v1Aux 20
# v1    16
# fim   12
# i     8
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

# vetor[dir] 28
# vetor[esq] 24
# fim        20
# dir        16
# meio       12
# esq        8
.isLeftVec:
    # ((esq < meio) && ((dir >= fim) || (vetor[esq] < vetor[dir])))

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

#pushl $v1Aux           20
#pushl $8 # tamanho     16
#pushl $0 # inicio      12
#pushl $v1              8
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
    leave
getMid:
    pushl %ebp
    movl %esp, %ebp
    movl 8(%ebp), %eax
    movl $2, %ebx
    xor %edx, %edx
    divl %ebx
    popl %ebp
    ret

exitMerge:
    nop

exitGetMid:
    movl %ebp, %esp
    popl %ebp
    ret
