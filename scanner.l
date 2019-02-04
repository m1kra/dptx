
%{
   #include "parser.tab.h"
%}

STRING	\"[a-zA-Z0-9]*\"|\'[a-zA-Z0-9]\'

%%

liczba             return NUMBER;

drukuj             return PRINT;
dla                return FOR;
do                 return TO;
rób                return DO;
zrobione           return DONE;

[a-z]+   yylval=*yytext; return ID;

[0-9]+  yylval=atoi(yytext); return INTEGER_LITERAL;

"="   return '=';
"+"   return '+';
"*"   return '*';

{STRING}	{
				/* yylval.str_val = malloc(yyleng * sizeof(char)); */
				/* strcpy(yylval, yytext); */
				return STRING;
			}


[ \t\n] ;

