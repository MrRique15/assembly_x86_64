.section .data
    text1: .asciz "Sum: %d\n"
    v1: .int	10, 20, 30

.text
.global _start

_start:
    # PT-BR
    #O trecho a seguir soma os 3 valores do rótulo v1, que funciona como um vetor. 
    #O endereço inicial do vetor é colocado em %edi e as diferentes posições são acessadas   
    #incrementando o %edi a cada 4 bytes de forma a causar um deslocamento no acesso deste   
    #vetor.
    
    # EN-US
    #The following code sums the 3 values of the label v1, which works as a vector.
    #The initial address of the vector is placed in %edi and the different positions are accessed 
    #by incrementing %edi every 4 bytes so as to cause a shift in the access of this  vector
    

    movl $v1, %edi
    movl (%edi), %eax
    addl $4, %edi
    addl (%edi), %eax
    addl $4, %edi
    addl (%edi), %eax

    pushl %eax
    pushl $text1
    call printf

    pushl $0
    call exit
