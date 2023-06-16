.PHONY: run clean

run: hello
	./hello

# compile assembly from text (hello.s) to an object file
hello.o: hello.s
	as -o hello.o hello.s

# link the object file to produce a runnable executable
hello: hello.o
	ld -o hello hello.o

clean:
	rm hello hello.o
