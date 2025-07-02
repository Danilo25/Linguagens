%{
#include "parser.tab.h"
#include <string.h>
%}

%option noyywrap
%option yylineno
%option nounput
%option noinput

%%

"Unit"          { return UNIT; }
"Float"         { return FLOAT; }
"Int"           { return INT; }
"print"         { return PRINT; }
"return"        { return RETURN; }

"<-"            { return ARROW_LEFT; }
"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return MUL; }
"/"             { return DIV; }

";"             { return SEMICOLON; }
"("             { return LPAREN; }
")"             { return RPAREN; }
"{"             { return LBRACE; }
"}"             { return RBRACE; }
","             { return COMMA; }


[0-9]+\.[0-9]+ {
    yylval.float_val = atof(yytext);
    return FLOAT_LIT;
}

[0-9]+ {
    yylval.int_val = atoi(yytext);
    return INT_LIT;
}

[a-zA-Z_][a-zA-Z0-9_]* {
    yylval.str_val = strdup(yytext);
    return ID;
}

"//".* { /* Ignora comentários de linha */ }
[ \t\r\n]+      { /* Ignora espaços em branco */ }

.               {
    fprintf(stderr, "ERRO LÉXICO: Token desconhecido '%s' na linha %d\n", yytext, yylineno);
    return 0;
}

%%
