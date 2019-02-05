#ifndef __LOL_ACTIONS_H
#define __LOL_ACTIONS_H

#include <stdio.h>

#define MAX_STACK_DEPTH 30
#define MAX_FUNCTION_NAME_LENGTH 300

int _stackdepth;
int _maxdepth;
int _stacks[MAX_STACK_DEPTH];
int fun_num;

void init_scope(){
	_stackdepth = 0;
  	_maxdepth = 0;
  	fun_num = 0;
  	for(int i = 0; i < MAX_STACK_DEPTH; i++){
  		    _stacks[i] = 0;
  	}
}

void _print_pos(int depth, int* stacks){
	for(int i = 1; i <= depth; i++){
        printf("_%d", stacks[i]);
    }
}

void print_pos(){
	_print_pos(_stackdepth, _stacks);
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

void init_fun_block(char* idx){
	fun_num++;
	printf("\n.sub '%s'\n", idx);
}

void init_fun_body(){
	printf(
		    ".local pmc sTAcK\n"
            "sTAcK = new 'ResizableFloatArray'\n"
            ".local num tMp_1\n"
            ".local num tMp_2\n"
            ".local num tMp_3\n"
    );
}


void printgoto(char* boe, int only_label){
    printf("%s_", boe);
    print_pos();

    if(only_label)
        printf(":");
    printf("\n");
}

void get_expr(){
	printf("pop tMp_1, sTAcK\n");
}

void beg_for_block(char* idx){
    enter_scope();
    printf("pop tMp_1,sTAcK\n");
    printf("%s = tMp_1\n", idx);
    printgoto("BEG", 1);
}

void mid_for_block(char* idx){
	printf("pop tMp_1,sTAcK\n");
    printf("if %s > tMp_1 ", idx);
    printgoto("goto END", 0);
}

void end_for_block(char* idx){
	printf("inc %s\n", idx);
    printgoto("goto BEG", 0);
    printgoto("END", 1);
    leave_scope();
}

void beg_ifblock(){
	enter_scope();
	printf("goto JMP_B");
	print_pos();
	printf("\n");
}

void end_ifblock(){
	printf("JMP_B");
	print_pos();
	printf(":\n");
	leave_scope();
}

void mid_ifelseblock(){
	// tMp_1_maxdepth = _maxdepth;
	// tMp_1_depth = _stackdepth;
	// int tMp_1_stacks[_maxdepth + 1];
	// for(int i = 0; i <= _maxdepth; i++){
	// 	tMp_1_stacks[i] = _stacks[i];
	// }
	printf("goto JMP_E");
	print_pos();
	printf("\n");
	printf("JMP_B");
	print_pos();
	printf(":\n");
}

void end_ifelseblock(){
	printf("JMP_E");
	print_pos();
	printf(":\n");
	leave_scope();
}

#endif
