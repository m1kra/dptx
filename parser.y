%{
    #include "actions.h"
%}

%token NUMBER
%token ID
%token INTEGER_LITERAL
%token PRINT
%token FOR
%token TO
%token DO
%token DONE
%token STRING


%%

program : body;

body : block body
       |
       ;

block : decl | instr
        | forloop;


decl : NUMBER ID { printf(".local num %c\n", $2); }
     ;

instr : assignment
      | print
      ;


assignment : ID '=' expr { printf("pop tmp, stos\n%c = tmp\n",$1); }
           ;

print :      PRINT expr        { printf("pop tmp, stos\n say tmp \n"); }
      ;


forloop :   FOR ID '=' expr
                {
                    enter_scope();
                    printf("pop tmp,stos\n");
                    printf("%c = tmp\n",$2);
                    printgoto("BEG", 1);
            }
            TO expr
                {
                    printf("pop tmp,stos\n");
                    printf("if %c > tmp ", $2);
                    printgoto("goto END", 0);
            }
            DO body DONE
                {
                    printf("inc %c\n",$2);
                    printgoto("goto BEG", 0);
                    printgoto("END", 1);
                    leave_scope();
            }
        ;


expr : INTEGER_LITERAL { printf("push stos,%d.0\n",$1); }
     | ID              { printf("push stos,%c\n",$1); }
     | expr '+' expr   { printf("pop tmp2,stos\npop tmp3,stos\n tmp=tmp2+tmp3\n push stos,tmp\n"); }
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