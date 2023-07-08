.PHONY: run clean

run: build
	build/to_upper "this _should_ all be upper cased!"

build: main.c to_upper.s
	mkdir -p build
	as -o build/to_upper.o to_upper.s
	gcc -o build/to_upper main.c build/to_upper.o

clean:
	rm -r build
