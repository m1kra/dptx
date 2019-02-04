
all: compiler

scanner: scanner.l
	flex scanner.l

parser: parser.y
	bison -d parser.y

compiler: scanner parser
	gcc -lfl lex.yy.c parser.tab.c -o compiler


.PHONY: clean

clean:
	rm -f *.c *.h compiler
