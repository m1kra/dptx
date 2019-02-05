#ifndef __LOL_ACTIONS_H
#define __LOL_ACTIONS_H

#include <stdio.h>

#define MAX_STACK_DEPTH 30

int _stackdepth;
int _maxdepth;
int _stacks[MAX_STACK_DEPTH];

void init_scope(){
	_stackdepth = 0;
  	_maxdepth = 0;
  	for(int i = 0; i < MAX_STACK_DEPTH; i++){
  		    _stacks[i] = 0;
  	}
}

void print_pos(){
    for(int i = 1; i <= _stackdepth; i++){
        printf("_%d", _stacks[i]);
    }
}

void enter_scope(){
	_stackdepth++;
    if (_stackdepth <= _maxdepth){
        _stacks[_stackdepth]++;
        for(int i = _stackdepth + 1; i <= _maxdepth; i++){
        	_stacks[i] = 0;
        }
    }
    _maxdepth = _stackdepth;
}

void leave_scope(){
	_stackdepth--;
}

void init_program(){
	printf(
		    ".sub main\n"
		    ".local pmc stos\n"
            "stos = new 'ResizableFloatArray'\n"
            ".local num tmp\n"
            ".local num tmp2\n"
            ".local num tmp3\n"
        );

}

void printgoto(char* boe, int only_label){
    fprintf(stderr, "%s std=%d mstd=%d\n", boe, _stackdepth, _maxdepth);

    printf("%s_", boe);
    print_pos();

    if(only_label)
        printf(":");
    printf("\n");
}

#endif
