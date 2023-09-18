# gcc -> 		gcc $(PROG_PATH).s -o $(PROG).o -m32
# gcc run -> 	./$(PROG).o
  
# Add the program path here
PROG_PATH = array_ops/mergesort
OUTPUT_NAME = merge_sort

all:
	as -32 $(PROG_PATH).s -o builds/$(OUTPUT_NAME).o 
	ld -m elf_i386 builds/$(OUTPUT_NAME).o -lc -dynamic-linker /lib/ld-linux.so.2 -o builds/$(OUTPUT_NAME)

run:
	./builds/$(OUTPUT_NAME)

gdb: 
	as -gstabs -32 $(PROG_PATH).s -o builds/$(OUTPUT_NAME).o
	ld -m elf_i386 builds/$(OUTPUT_NAME).o -lc -dynamic-linker /lib/ld-linux.so.2 -o builds/$(OUTPUT_NAME)

rgdb:
	gdb builds/$(OUTPUT_NAME)