%{
    #include "actions.h"
%}

%right '=' SE

%left '+' '-'
%left '*' '/'

%union {
    char* strval;
    int intval;
}


%token DOT;
%token <strval> ID
%token SE
%token NUMBER STR
%token <intval> INTEGER_LITERAL
%token PRINT
%token FOR TO DO DONE
%token IF THEN ELSE FI
%token LE GE NE
%token STRING


%%

program     :   fun_blocks;

fun_blocks  :   fun_block fun_blocks
            |
            ;

fun_block   :   ID ':' { init_fun_block($1); } '(' arg_list ')' { init_fun_body(); } body '.' { printf(".end"); }
            ;

arg_list    :   arg_decl ',' tmp_arg_list
            |   arg_decl
            |
            ;

tmp_arg_list:   arg_decl ',' tmp_arg_list
            |   arg_decl
            ;

body        :   block body
            |
            ;

block       :   init | assignment | instr
            |   for_block | if_block | ifelse_block
            ;

arg_decl    :   NUMBER ID { printf(".param num %s\n", $2); }
            |   STR ID { printf(".param string %s\n", $2); }
            ;

init        :   NUMBER ID { printf(".local num %s\n", $2); }
            |   STR ID { printf(".local string %s\n", $2); }
            ;

instr       :   print
            |   call
            ;


assignment  :   ID '=' expr { printf("pop tMp_1, sTAcK\n%s = tMp_1\n", $1); }
            |   ID SE { printf("%s = ", $1); } call
            |   ID '=' STR { printf("%s = %s\n", $1, $<strval>3); }
            ;

call        :   ID '(' { printf("%s(", $1); } values ')' { printf(")\n"); }
            ;

values      :   ID ',' { printf("%s,", $1); } tmp_vals
            |   INTEGER_LITERAL ',' { printf("%d,", $1); } tmp_vals
            |   ID { printf("%s", $1); }
            |   INTEGER_LITERAL { printf("%d", $1); }
            |
            ;

tmp_vals    :   ID ',' { printf("%s,", $1); } tmp_vals
            |   INTEGER_LITERAL ',' { printf("%d,", $1); } tmp_vals
            |   ID { printf("%s", $1); }
            |   INTEGER_LITERAL { printf("%d", $1); }
            ;

print       :   PRINT expr { printf("pop tMp_1, sTAcK\n say tMp_1 \n"); }
            ;


for_block   :   FOR ID '=' expr { beg_for_block($2); } TO expr { mid_for_block($2); }
                DO body '.' { end_for_block($2); };
            ;

if_block    :   subifblock '.' { end_ifblock(); }
            ;

ifelse_block:   subifblock ELSE {mid_ifelseblock();} body FI {end_ifelseblock();}
            ;

subifblock  :   IF ifboolexpr THEN {beg_ifblock();} body
            ;


expr        : INTEGER_LITERAL { printf("push sTAcK,%d.0\n", $<intval>1); }
            | ID              { printf("push sTAcK,%s\n", $1); }
            | expr '+' expr   { printf("pop tMp_2,sTAcK\npop tMp_3,sTAcK\n tMp_1=tMp_3+tMp_2\n push sTAcK,tMp_1\n"); }
            | expr '-' expr   { printf("pop tMp_2,sTAcK\npop tMp_3,sTAcK\n tMp_1=tMp_3-tMp_2\n push sTAcK,tMp_1\n"); }
            | expr '*' expr   { printf("pop tMp_2,sTAcK\npop tMp_3,sTAcK\n tMp_1=tMp_3*tMp_2\n push sTAcK,tMp_1\n"); }
            | expr '/' expr   { printf("pop tMp_2,sTAcK\npop tMp_3,sTAcK\n tMp_1=tMp_3/tMp_2\n push sTAcK,tMp_1\n"); }
            | '(' expr ')'
            ;

ifboolexpr  :   ID '<' expr { get_expr(); printf("unless %s < tMp_1 ", $1); }
            |   ID '>' expr { get_expr(); printf("unless %s > tMp_1 ", $1); }
            |   ID '=' expr { get_expr(); printf("unless %s == tMp_1 ", $1); }
            |   ID NE  expr { get_expr(); printf("if %s == tMp_1 ", $1); }
            |   ID LE  expr { get_expr(); printf("unless %s <= tMp_1 ", $1); }
            |   ID GE  expr { get_expr(); printf("unless %s >= tMp_1 ", $1); }
            |
            ;

%%

int yyerror(char* s){
  fprintf(stderr, "%s\n", s);
  return 0;
}

int main(){
  init_scope();
  yyparse();
  return 0;
}