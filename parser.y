%{
    #include "actions.h"
%}

%union {
    char* strval;
    int intval;
}


%token <strval> ID
%token NUMBER
%token <intval> INTEGER_LITERAL
%token PRINT
%token FOR
%token TO
%token DO
%token DONE
%token IF THEN ELSE FI
%token LE
%token GE
%token STRING


%%

program : body;

body : block body
       |
       ;

block : decl | instr
        | forloop | ifblock | ifelseblock
        ;


decl : NUMBER ID { printf(".local num %s\n", $2); }
     ;

instr : assignment
      | print
      ;


assignment : ID '=' expr { printf("pop tMp_1, sTAcK\n%s = tMp_1\n",$1); }
           ;

print :      PRINT expr        { printf("pop tMp_1, sTAcK\n say tMp_1 \n"); }
      ;


forloop :   FOR ID '=' expr
                {
                    enter_scope();
                    printf("pop tMp_1,sTAcK\n");
                    printf("%s = tMp_1\n",$2);
                    printgoto("BEG", 1);
            }
            TO expr
                {
                    printf("pop tMp_1,sTAcK\n");
                    printf("if %s > tMp_1 ", $2);
                    printgoto("goto END", 0);
            }
            DO body DONE
                {
                    printf("inc %s\n",$2);
                    printgoto("goto BEG", 0);
                    printgoto("END", 1);
                    leave_scope();
            }
        ;

ifblock :       subifblock FI {end_ifblock();}

ifelseblock:    subifblock ELSE {mid_ifelseblock();} body FI {end_ifelseblock();}

subifblock:     IF ifboolexpr THEN {beg_ifblock();} body


expr : INTEGER_LITERAL { printf("push sTAcK,%d.0\n", $<intval>1); }
     | ID              { printf("push sTAcK,%s\n", $1); }
     | expr '+' expr   { printf("pop tMp_2,sTAcK\npop tMp_3,sTAcK\n tMp_1=tMp_2+tMp_3\n push sTAcK,tMp_1\n"); }
     ;

ifboolexpr  :   ID '<' expr { get_expr(); printf("unless %s < tMp_1 ", $1); }
            |   ID '>' expr { get_expr(); printf("unless %s > tMp_1 ", $1); }
            |   ID '=' expr { get_expr(); printf("unless %s == tMp_1 ", $1); }
            |   ID LE  expr { get_expr(); printf("unless %s <= tMp_1 ", $1); }
            |   ID GE  expr { get_expr(); printf("unless %s >= tMp_1 ", $1); }
            |
            ;

%%

int yyerror(char* s)
{
  fprintf(stderr, "%s\n", s);
  return 0;
}

int main()
{
  init_scope();
  init_program();
  yyparse();
  printf(".end\n");
  return 0;
}