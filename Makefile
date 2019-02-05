
all: compiler

scanner: scanner.l
	flex scanner.l

parser: parser.y
	bison -dv parser.y

actions: actions.h

compiler: scanner parser actions
	gcc -lfl lex.yy.c parser.tab.c actions.h -o compiler


.PHONY: clean fullclean

clean:
	rm -f *.c parser.tab.h *.o parser.output

fullclean: clean
	rm -f *.pir compiler