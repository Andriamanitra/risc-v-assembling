.PHONY: run clean

run: build/fizzbuzz
	build/fizzbuzz

build/fizzbuzz.o: fizzbuzz.s
	mkdir -p build
	as -o build/fizzbuzz.o fizzbuzz.s

build/fizzbuzz: build/fizzbuzz.o
	ld -o build/fizzbuzz build/fizzbuzz.o

clean:
	rm -r build
