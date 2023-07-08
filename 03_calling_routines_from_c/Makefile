.PHONY: run clean

run: build/prog
	build/prog "this _should_ all be upper cased!"

build/prog: main.c build/to_upper.o
	gcc -o build/prog main.c build/to_upper.o

build/to_upper.o: to_upper.s
	as -o build/to_upper.o to_upper.s

clean:
	rm -r build
