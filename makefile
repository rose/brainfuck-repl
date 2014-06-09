all: repl.asm
	nasm -felf64 repl.asm && ld repl.o

test: all
	./a.out || true && rm repl.o a.out

	
