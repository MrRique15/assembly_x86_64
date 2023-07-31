# gcc -> 		gcc $(PROG).s -o $(PROG).o -m32
# gcc run -> 	./$(PROG).o
  
# Add the program path here
PROG = initial_ex/syscall_print

all: $(PROG).s
	as -32 $(PROG).s -o $(PROG).o 
	ld -m elf_i386 $(PROG).o -lc -dynamic-linker /lib/ld-linux.so.2 -o $(PROG)

run:
	./$(PROG)

gdb: 
	as -gstabs -32 $(PROG).s -o $(PROG).o
	ld -m elf_i386 $(PROG).o -lc -dynamic-linker /lib/ld-linux.so.2 -o $(PROG)

rgdb:
	gdb $(PROG)