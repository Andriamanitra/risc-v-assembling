.PHONY: run clean

run: prog
	./prog "this _should_ all be upper cased!"

prog: main.c to_upper.o
	gcc -o prog main.c to_upper.o

to_upper.o: to_upper.s
	as -o to_upper.o to_upper.s

clean:
	rm -f *.o prog
