
%{
    #include "parser.tab.h"
    #include <string.h>
%}

STRING    \"[a-zA-Z0-9]*\"|\'[a-zA-Z0-9]\'

%%

tMp_1|tMp_2|tMp_3|sTAcK       fprintf(stderr, "Variable %s is reserved.", yytext); exit(1);

":"		return ':';
"=="	return SE;
"("		return '(';
")"		return ')';
","		return ',';
"{"		return '{';
"."		return '.';
"="     return '=';
"++"	return INC;
"--"	return DEC;

%{
/* "."		return '}'; */
%}

to 			return TO;
num      	return NUMBER;
str     	return STR;
return		return RET;
print 	    return PRINT;
for         return FOR;
do 	        return DO;
done	    return DONE;
if          return IF;
fi          return FI;
then        return THEN;
else        return ELSE;

[a-z]+   	yylval.strval=strdup(yytext); return ID;

[0-9]+  	yylval.intval=atoi(yytext); return INTEGER_LITERAL;

"+"     return '+';
"-"     return '-';
"*"     return '*';
"/"     return '/';
"!="	return NE;
"<="    return LE;
">="    return GE;
">"     return '>';
"<"     return '<';

{STRING}	yylval.strval=strdup(yytext); return STR;


[ \t\n] ;

