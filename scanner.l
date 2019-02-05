
%{
    #include "parser.tab.h"
    #include <string.h>
%}

/*STRING    \"[a-zA-Z0-9]*\"|\'[a-zA-Z0-9]\'*/

%%

tMp_1|tMp_2|tMp_3|sTAcK       fprintf(stderr, "Variable %s is reserved.", yytext); exit(1);

liczba      return NUMBER;
drukuj      return PRINT;
dla         return FOR;
do          return TO;
rób         return DO;
zrobione    return DONE;
if          return IF;
then        return THEN;
fi          return FI;
else        return ELSE;

[a-z]+   yylval.strval=strdup(yytext); return ID;

[0-9]+  yylval.intval=atoi(yytext); return INTEGER_LITERAL;

"="     return '=';
"+"     return '+';
"-"     return '-';
"*"     return '*';
"/"     return '/';
"<="    return LE;
">="    return GE;
">"     return '>';
"<"     return '<';


[ \t\n] ;

