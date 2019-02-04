%{
  #include <stdio.h>
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

program : { printf(".sub main\n");
	    printf(".local pmc stos\n");
            printf("     stos = new 'ResizableFloatArray'\n");
            printf(".local num tmp\n");
            printf(".local num tmp2\n");
            printf(".local num tmp3\n");
	    }
           body
          { printf(".end\n"); } ;

body : decls instrs
     ;

decls : decl decls
      |
      ;

instrs: instr instrs
      |
      ;

decl : NUMBER ID { printf(".local num %c\n", $2); }
     ;

instr : assignment
      | print
      | forloop
      ;


assignment : ID '=' expr { printf("pop tmp,stos\n%c = tmp\n",$1); }
           ;

print :      PRINT expr        { printf("pop tmp,stos\nsay tmp\n"); }
      ;


forloop :    FOR
             ID
             '='
             expr
             {
	       printf("pop tmp,stos\n");
	       printf("%c = tmp\n",$2);
               printf("BEGINLOOP:\n");
             }
             TO
             expr
             {
	       printf("pop tmp,stos\n");
               printf("if %c > tmp goto ENDLOOP\n",$2);
             }
             DO
             body
             DONE
             {
               printf("inc %c\n",$2);
               printf("goto BEGINLOOP\n");
               printf("ENDLOOP:\n");
             }
        ;


expr : INTEGER_LITERAL { printf("push stos,%d.0\n",$1); }
     | ID              { printf("push stos,%c\n",$1); }
     | expr '+' expr   { printf("pop tmp2,stos\npop tmp3,stos\n tmp=tmp2+tmp3\n push stos,tmp\n"); }
     ;

%%

yyerror(char* s)
{
  fprintf(stderr, "%s\n", s);
}

main()
{
  yyparse();
}